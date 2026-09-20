#!/usr/bin/env python3
# fix_guard_final.py — sekali jalan, deterministik.
# Tujuan: SATU Fluent call yang melempar TIDAK PERNAH memotong blok build UI.
#   a) tambah helper addSectionSafe (pcall + fallback stub).
#   b) konversi 7 call-site `Window:AddTab(...)` mentah  -> addTab(Window,"X").
#   c) konversi SEMUA `X:AddSection("T")` mentah          -> addSectionSafe(X,"T").
import re

PATH = "fluent2.lua"
lines = open(PATH, encoding="utf-8").read().split("\n")

def ditemukan(pred, start=0):
    for i in range(start, len(lines)):
        if pred(lines[i]):
            return i
    return None

# ============================================================
# 1) PASTIKAN helper addSectionSafe ADA (panggil pcall; error di-skip+dibuat stub)
# ============================================================
def ada_section_helper():
    for l in lines:
        if "local function addSectionSafe(" in l:
            return True
    return False

if not ada_section_helper():
    # sisipkan setelah helper addTab (def di idxA, tutup "end" di idxEnd)
    aidx = None
    for i, l in enumerate(lines):
        if "local function addTab(" in l:
            aidx = i
            break
    if aidx is None:
        raise SystemExit("helper addTab tak ditemukan — batalkan")
    eidx = aidx + 1
    while eidx < len(lines) and lines[eidx].strip() != "end":
        eidx += 1
    if eidx >= len(lines):
        raise SystemExit("penutup addTab tak ditemukan — batalkan")
    extra = [
        "",
        "local sectionStub = nil",
        "local function makeSectionStub()",
        "    if sectionStub then return sectionStub end",
        "    sectionStub = setmetatable({}, {",
        "        __index = function() return function() return makeSectionStub() end end,",
        "    })",
        "    return sectionStub",
        "end",
        "local function addSectionSafe(parent, title)",
        "    local stub = makeSectionStub()",
        "    local ok, ctl = pcall(function() return parent:AddSection(title) end)",
        "    if not ok then",
        "        pcall(function() Fluent:Notify({ Title = \"UI skip\", Content = \"Section \\\"\" .. title .. \"\\\": \" .. tostring(ctl) }) end)",
        "        return stub",
        "    end",
        "    return ctl or stub",
        "end",
        "",
    ]
    lines[eidx + 1 : eidx + 1] = extra
    print("helper addSectionSafe DISISIPKAN setelah addTab (idx", eidx, ")")
else:
    print("helper addSectionSafe SUDAH ada — lewati sisip")

# ============================================================
# 2) Konversi SEMUA call-site `:AddSection("T")` -> addSectionSafe(parent,"T")
# ============================================================
PAT_ASSIGN = re.compile(
    r'^(\s*)local\s+(\w+)\s*=\s*(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$'
)
PAT_PLAIN = re.compile(
    r'^(\s*)(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$'
)
sec_assign = 0
sec_plain = 0
for i, l in enumerate(lines):
    if "local function addSectionSafe(" in l or "AddSection" in l and "function" in l:
        continue
    m = PAT_ASSIGN.match(l)
    if m:
        lines[i] = '%slocal %s = addSectionSafe(%s, "%s")' % (
            m.group(1), m.group(2), m.group(2), m.group(4))
        sec_assign += 1
        continue
    m2 = PAT_PLAIN.match(l)
    if m2:
        lines[i] = '%saddSectionSafe(%s, "%s")' % (
            m2.group(1), m2.group(3), m2.group(2))
        sec_plain += 1
print("call-site :AddSection konversi — assign:", sec_assign, "plain:", sec_plain)

# ============================================================
# 3) Konversi 7 call-site `Window:AddTab({Title=..})` mentah -> addTab(Window,"X")
# ============================================================
PAT_TAB = re.compile(
    r'^(\s*)local\s+(tab\w+)\s*=\s*Window:AddTab\(\{\s*Title\s*=\s*"([^"]+)"\s*\}\)\s*$'
)
tab_cnt = 0
for i, l in enumerate(lines):
    if "local function addTab(" in l or "local function addSectionSafe(" in l:
        continue
    m = PAT_TAB.match(l)
    if m:
        lines[i] = '%slocal %s = addTab(Window, "%s")' % (
            m.group(1), m.group(2), m.group(3))
        tab_cnt += 1
print("call-site Window:AddTab -> addTab:", tab_cnt)

open(PATH, "w", encoding="utf-8").write("\n".join(lines) + "\n")
print("SELESAI — fluent2.lua di-update.")
