#!/usr/bin/env python3
# ============================================================
# FIX flufluent2.lua: UI selalu LENGKAP
#  - helper addTab ALREADY exists @~2470 (guard-nama)
#  - helper addSectionStub BARU
#  - konversi 7 call-site AddTab -> helper
#  - konversi SEMUA :AddSection() -> helper (skip-safe, {Title} fallback)
# ============================================================
import re, sys

PATH = "fluent2.lua"
src = open(PATH, encoding="utf-8").read()
lines = src.split("\n")

def idx(pred, start=0):
    for i in range(start, len(lines)):
        if pred(lines[i]):
            return i
    return None

# ---------- 1) anchor helper addTab (sudah ada). sisip addSectionStub SETELAH
#               baris "end" penutup helper addTab.
# ----------
a = idx(lambda l: "local function addTab(window, title)" in l or "local function addTab(" in l or "fn addTab(" in l)
assert a is not None, "helper addTab tak ketemu"
# cari end penutup addTab (baris "end" pertama setelah a dengan indent >= 4)
e = a + 1
while e < len(lines) and lines[e].strip() != "end":
    if lines[e].strip() == "":
        break  # kosong = end blkm
    e += 1
print("addTab helper @", a, " penutup @", e)

STUB = '''local function addSectionStub(parent, title)
    local ok, sec = pcall(function()
        local container = parent
        if typeof(container) == "table" and container.AddSection then
            return container:AddSection(title)
        end
        if typeof(parent) == "userdata" and parent.AddSection then
            return parent:AddSection(title)
        end
        return nil
    end)
    if not ok then
        pcall(function() Fluent:Notify({ Title = "UI skip", Content = "Section \\"" .. title .. "\\": " .. tostring(sec) }) end)
        return nil
    end
    return sec
end
'''
stub_lines = STUB.rstrip("\n").split("\n")
lines[e + 1 : e + 1] = stub_lines

# ---------- 2) konversi 7 call-site: local tabX = Window:AddTab(...) -> addTab(Window, "...")
# ----------
changed = 0
for i, l in enumerate(lines):
    if i == a:
        continue
    m = re.match(r'^(\s*)local\s+(tab\w+)\s*=\s*Window:AddTab\(\{\s*Title\s*=\s*"([^"]+)"\s*\}\)\s*$', l)
    if m:
        lines[i] = '%slocal %s = addTab(Window, "%s")' % (m.group(1), m.group(2), m.group(3))
        changed += 1
print("AddTab call-site dikonversi:", changed)

# ---------- 3) konversi SEMUA :AddSection() (di luar helper addSectionStub itu sendiri)
#    bentuk:   local secX = parent:AddSection("T")        -> addSectionStub(parent, "T")
#    bentuk2:  parent:AddSection("T") (call tanpa assign)  -> addSectionStub(parent, "T")
#    bentuk3:  X:AddSection({ Title = "T" })?
# ----------
sec = 0
for i, l in enumerate(lines):
    if "function addSectionStub" in l:
        continue
    # bentuk menulis: local secX = owner:AddSection("Title")
    m = re.match(r'^(\s*)local\s+(sec\w+)\s*=\s*(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$', l)
    if m:
        lines[i] = '%slocal %s = addSectionStub(%s, "%s")' % (m.group(1), m.group(2), m.group(3), m.group(4))
        sec += 1
        continue
    # bentuk panggilan langsung: owner:AddSection("Title")
    m = re.match(r'^(\s*)(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$', l)
    if m:
        lines[i] = '%saddSectionStub(%s, "%s")' % (m.group(1), m.group(2), m.group(3))
        sec += 1
        continue
    # bentuk AddSection({...}) ? (mungkin :AddSection("...") saja di Fluent)
print("AddSection call-site dikonversi:", sec)

open(PATH, "w", encoding="utf-8").write("\n".join(lines) + "\n")
print("OK — fluent2.lua ditulis ulang.")
