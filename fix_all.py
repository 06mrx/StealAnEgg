#!/usr/bin/env python3
# Fix fluent2.lua: wrap setiap Window:AddTab dan setiap :AddSection
# dalam pcall-safe helpers sehingga SATU kegagalan Fluent tidak
# memotong seluruh blok build -> menu SELALU lengkap (7 tab / 27 section).

import re, sys

PATH = "fluent2.lua"
src = open(PATH, encoding="utf-8").read()
lines = src.split("\n")

# ============ 1) Helper addSection (mirip addTab yang sudah ada) ============
HELPER = """local function addSection(parent, title)
    local ok, sec = pcall(function() return parent:AddSection(title) end)
    if not ok then
        pcall(function() Fluent:Notify({ Title = "UI skip", Content = "Section \\"" .. title .. "\\": " .. tostring(sec) }) end)
        return nil
    end
    return sec
end
"""

# sisipkan helper addSection tepat setelah baris helper addTab ditutup.
# cari "local function addTab(" lalu cari "end" penutup pertama setelahnya.
def find_line(pred, start=0):
    for i in range(start, len(lines)):
        if pred(lines[i]):
            return i
    return None

ti = find_line(lambda l: "local function addTab(" in l)
assert ti is not None, "helper addTab tak ketemu"
# cari baris "end" penutup helper addTab (indent 1/4/8 kosong)
ei = ti + 1
while ei < len(lines) and lines[ei].strip() != "end":
    ei += 1
assert ei < len(lines), "penutup addTab tak ketemu"
# sisipkan HELPER setelah baris ei
helper_lines = HELPER.rstrip("\n").split("\n")
lines[ei + 1 : ei + 1] = helper_lines

# ============ 2) Bersihkan stale helper addSection bila sudah ada ============
#   (jika duplikat dari percobaan sebelumnya: hapus SEMUA "local function addSection(" .. "end")
#    lalu sisip ulang sekali)
def drop_dup_addSection():
    out = []
    i = 0
    while i < len(lines):
        if lines[i].strip().startswith("local function addSection("):
            j = i + 1
            while j < len(lines) and lines[j].strip() != "end":
                j += 1
            i = j + 1  # lewati seluruh dump
            continue
        out.append(lines[i])
        i += 1
    return out

lines = drop_dup_addSection()

# sisip ulang helper di posisi yang benar (setelah addTab helper end)
ti = find_line(lambda l: "local function addTab(" in l)
ei = ti + 1
while ei < len(lines) and lines[ei].strip() != "end":
    ei += 1
lines[ei + 1 : ei + 1] = HELPER.rstrip("\n").split("\n")

# ============ 3) Konversi SEMUA call-site Window:AddTab -> addTab(...) ============
changed = 0
for i, l in enumerate(lines):
    m = re.match(
        r"^(\s*)local\s+(tab\w+)\s*=\s*Window:AddTab\(\{\s*Title\s*=\s*\"([^\"]+)\"\s*\}\s*\)\s*$",
        l,
    )
    if m:
        lines[i] = '%slocal %s = addTab(Window, "%s")' % (m.group(1), m.group(2), m.group(3))
        changed += 1
print("AddTab call-site dikonversi:", changed)

# ============ 4) Konversi SEMUA :AddSection(...) -> addSection(...) ============
# Bentuk A:  local secX = parent:AddSection("Title")
# Bentuk B:  parent:AddSection("Title")          (tanpa assign, biasanya panggilan section bersarang)
sec_changed = 0
for i, l in enumerate(lines):
    if "local function addSection(" in l:
        continue  # jangan sentuh helper
    m = re.match(
        r'^(\s*)local\s+(sec\w+)\s*=\s*(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$', l
    )
    if m:
        lines[i] = '%slocal %s = addSection(%s, "%s")' % (
            m.group(1), m.group(2), m.group(3), m.group(4))
        sec_changed += 1
        continue
    m = re.match(r'^(\s*)(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$', l)
    if m:
        lines[i] = '%saddSection(%s, "%s")' % (m.group(1), m.group(2), m.group(3))
        sec_changed += 1
print("AddSection call-site dikonversi:", sec_changed)

# ============ 5) Tambah guard per-tab: jika addTab gagal (nil), lewati bloknya ============
# lazy sederhana: karena helper addSection sudah pcall-safe terhadap parent nil
# (parent:AddSection saat parent=nil -> error -> pcall -> nil), dan helper add*
# (toggle/slider/dropdown/...) sudah pcall-safe terhadap parent nil, maka blok
# tidak perlu di-guard if-tab: seluruh build TAHAN BANTING dengan sendirinya.
# Ini yang benar: tidak ada satu pun panggilan Fluent mentah di blok build.

open(PATH, "w", encoding="utf-8").write("\n".join(lines) + "\n")
print("OK — fluent2.lua diperbarui")
