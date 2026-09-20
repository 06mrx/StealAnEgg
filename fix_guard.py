#!/usr/bin/env python3
import re, sys

PATH = "fluent2.lua"

def read():
    return open(PATH, encoding="utf-8").read()

def write(text):
    open(PATH, "w", encoding="utf-8").write(text)

# ============================================================
# PECAH & KENALI anchor
# ============================================================
lines = read().split("\n")

# (a) baris helper add* wrapper sudah ada? kita tambahkan addTab & addSection
#     persis SEBELUM baris 'if Window then'
ifline = next(i for i, l in enumerate(lines) if l.strip() == "if Window then")

HELPER = '''local function addTab(window, title)
    local ok, tab = pcall(function() return window:AddTab({ Title = title }) end)
    if not ok then
        pcall(function() Fluent:Notify({ Title = "UI skip", Content = "Tab \\"" .. title .. "\\": " .. tostring(tab) }) end)
        return nil
    end
    return tab
end

local function addSection(parent, title)
    local ok, sec = pcall(function() return parent:AddSection(title) end)
    if not ok then
        pcall(function() Fluent:Notify({ Title = "UI skip", Content = "Section \\"" .. title .. "\\": " .. tostring(sec) }) end)
        return nil
    end
    return sec
end
'''

lines[ifline:ifline] = HELPER.split("\n")

# (b) ganti semua panggilan Fluent Mentah yang TIDAK lewat wrapper:
#     - `local tabX = Window:AddTab({ Title = "T" })`  -> addTab(Window, "T")
#     - `X:AddSection("Title")` (tab:AddSection / sec:AddSection) -> addSection(X, "Title")
NEW = []
for l in lines:
    m = re.match(r'^(\s*)local\s+(tab\w+)\s*=\s*Window:AddTab\(\{\s*Title\s*=\s*"([^"]+)"\s*\}\)\s*$', l)
    if m:
        NEW.append('%slocal %s = addTab(Window, "%s")' % (m.group(1), m.group(2), m.group(3)))
        continue
    m = re.match(r'^(\s*)(\w+):AddSection\(\s*"([^"]+)"\s*\)\s*$', l)
    if m and m.group(2) != "tabStub":
        NEW.append('%saddSection(%s, "%s")' % (m.group(1), m.group(2), m.group(3)))
        continue
    NEW.append(l)
lines = NEW

# (c) cek: semua target kontrol (addToggle/addSlider/addDropdown/addButton/
#         addParagraph/addInput) sudah melalui wrapper & wrapper aman?
#     -> addToggle/addSlider (safeAdd), addDropdown(both), addButton,
#        addParagraph, addInput  =>  semuanya YES (di atas). TIDAK diubah.

write("\n".join(lines) + "\n")
print("OK — addTab/addSection helper + 7 AddTab + N AddSection di-replace.")
print("total baris sekarang:", len(lines))
