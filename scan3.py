#!/usr/bin/env python3
# scan3.py — temukan 3 anchor presisi di fluent2.lua utk rewrite Linoria.
import re

L = open("fluent2.lua", encoding="utf-8").read().split("\n")

def find(sub, start=0, n=1):
    out = []
    for i in range(start, len(L)):
        if sub in L[i]:
            out.append(i)
            if len(out) == n:
                return out
    return out

start_loader = find("local Fluent = nil")[0]
print("start_loader (0-based):", start_loader, "->", L[start_loader].strip())

# Build dimulai: baris pertama setelah seluruh helper yg masih memakai 'dt' state store
# & baris '-- ============================================================'
# cari baris pertama '-- HOME / local tabHome = addTab(Window,"Home")'
th = find('local tabHome = addTab(Window, "Home")')
print("start_build tabHome    (0-based):", th[0] if th else None)

# Ekor MAIN LOOP: baris pertama MENDATAR (indent 0) yang mengawali loop runtime.
# Cari marker klasik: baris yg starts 'task.spawn(function()' indent 0 ATAU
# 'while Window and' ATAU '-- MAIN LOOP' ATAU baris yg mengandung 'r.mainLoop'
candidates = []
tokens = ["while Window and", "while fq", "task.spawn(function()", "-- MAIN", "-- UPDATER", "r.mainLoop", "repeat until", "      task.spawn(function()"]
for i in range(start_loader, len(L)):
    s = L[i].strip()
    if s.startswith("--") and ("MAIN" in s or "LOOP" in s or "UPDATE" in s):
        candidates.append((i, "marker:" + s))
    if re.match(r"^while ", s) or re.match(r"^repeat", s):
        candidates.append((i, "while:" + s[:40]))
    if i < len(L)-1 and re.match(r"^task\.spawn", s) and L[i+1].strip().startswith("--"):
        pass
# cari juga baris: 'fq.runtimeRow' yg di-loop (akhir): cari 'while' terakhir sebelum EOF yg indent 0
last_while = [i for i in range(len(L)) if re.match(r"^while ", L[i])]
if last_while:
    print("LAST 'while' indent-0 @", last_while[-1], "->", L[last_while[-1]].strip()[:60])
print("candidates yg menarik:")
for i, c in candidates[-6:]:
    print("  ", i, c)
# Tentukan ekor = baris while terakhir indent0 (loop runtime utama), yg memakai fq.*
if last_while:
    tw = last_while[-1]
    print("\nekor_main_loop_start (0-based):", tw)
    print("[contoh isi 3 baris sebelum while]", *["  %s" % L[j].strip() for j in range(tw-2, tw)], sep="\n")
