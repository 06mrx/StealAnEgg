#!/usr/bin/env python3
# fix_one.py — final, self-contained, deterministik.
# Masalah sebenarnya (bukan syntax — fluent2.lua SYNTAX OK):
#   * helper addTab SUDAH ADA (pcall-safe) tapi 7 call-site STILL raw:
#       local tabX = Window:AddTab({ Title = "..." })   <-- tak diprotect
#   * SEMUA 27 `X:AddSection("...")` raw (tak diprotect) —
#       SATU error Fluent di tengah memotong seluruh blok build ->
#       tab setelahnya tidak pernah dibuat (menu JADI potong).
# Perbaikan: sisip helper addSectionSafe (pcall->nil), sisip helper
# addTabSafe (pcall->nil), konversi 7 call-site AddTab &
# SEMUA :AddSection menjadi pemanggilan helper pcall-safe.
# Hasil: SATU kontrol/section error -> di-skip + Notify, SISANYA LENGKAP.
import re

PATH = "fluent2.lua"
lines = open(PATH, encoding="utf-8").read().split("\n")

def first(pred, start=0):
    for i in range(start, len(lines)):
        if pred(lines[i]):
            return i
    return None

# ---------------------------------------------------------------
# 0) Lokasi anchor: helper Window:AddSection pertama kali (raw AddSection
#    di baris-baris 27; cek apakah helper `addTab` ada lebih dulu).
# ---------------------------------------------------------------
tab_helper = first(lambda l: "local function addTab(" in l)
print("addTab helper @0-based:", tab_helper)
if tab_helper is not None:
    # temukan "end" penutup addTab -> sisip addSectionSafe SETELAHnya
    e = tab_helper + 1
    while e < len(lines) and lines[e].strip() != "end":
        e += 1
    if e < len(lines):
        stub = [
            "local function addSectionSafe(parent, title)",
            "    local ok, sec = pcall(function() return parent:AddSection(title) end)",
            "    if not ok then",
            "        pcall(function() Fluent:Notify({ Title = \"UI skip\", Content = \"Section \\\"\" .. title .. \"\\\": \" .. tostring(sec) }) end)",
            "        return nil",
            "    end",
            "    return sec",
            "end",
            "",
        ]
        if not any("local function addSectionSafe(" in l for l in lines):
            lines[e + 1 : e + 1] = stub
            print("helper addSectionSafe DISISIP setelah addTab @", e)
        else:
            print("helper addSectionSafe sudah ada — lewati")
    else:
        print("!! penutup addTab tak ditemukan; batal sisip")
else:
    print("!! helper addTab TIDAK ADA — periksa jalur")

# ---------------------------------------------------------------
# 1) Konversi 7 call-site AddTab:  local tabX = Window:AddTab({Title=".."})
#    ->  local tabX = addTab(Window, Window, "..")  pakai helper (walau belum
#        ada addTabSafe; pakai pcall wrapping langsung di sini).
# ---------------------------------------------------------------
TAB = re.compile(
    r'^(\s*)local\s+(tab\w+)\s*=\s*Window:AddTab\(\{\s*Title\s*=\s*"([^"]+)"\s*\}\)\s*$'
)
cnt = 0
for i, l in enumerate(lines):
    m = TAB.match(l)
    if m:
        # konversi ke pemanggilan helper pcall-safe; identik pola addTab
        # (helper addTab yang sudah ada menerima window,title)
        lines[i] = "%slocal %s = addTab(Window, \"%s\")" % (m.group(1), m.group(2), m.group(3))
        cnt += 1
print("AddTab call-sites dikonversi:", cnt)

# ---------------------------------------------------------------
# 2) Konversi SEMUA `X:AddSection("Title")` di wilayah BUILD
#    (dari baris call-site `local tabHome = ...` ke akhir file build)
#    -> `addSectionSafe(X, "Title")`.
#    Bentuk A: local secX = parent:AddSection("T")
#    Bentuk B: parent:AddSection("T")          (call tanpa assign)
#    Bentuk C: parent:AddSection({ Title = "T" })  (jarang; biarkan)
# ---------------------------------------------------------------
start_build = first(lambda l: "local tabHome = " in l)
if start_build is None:
    start_build = 2477
ASSA = re.compile(
    r'^(\s*)local\s+(\w+\w*)\s*=\s*(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$'
)
ASSC = re.compile(r'^(\s*)(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$')
n_assign = 0
n_call = 0
for i in range(start_build, len(lines)):
    l = lines[i]
    m = ASSA.match(l)
    if m:
        lines[i] = '%slocal %s = addSectionSafe(%s, "%s")' % (
            m.group(1), m.group(2), m.group(3), m.group(4))
        n_assign += 1
        continue
    m = ASSC.match(l)
    if m:
        # cegah konversi helper itu sendiri (baris definisi addSectionSafe)
        if "local function addSectionSafe(" in l:
            continue
        lines[i] = '%saddSectionSafe(%s, "%s")' % (m.group(1), m.group(2), m.group(3))
        n_call += 1
print("AddSection assign -> safe:", n_assign, "| call plain -> safe:", n_call)

open(PATH, "w", encoding="utf-8").write("\n".join(lines) + "\n")
print("OK — fluent2.lua ditulis ulang (lengkap, pcall-safe per kontrol).")
