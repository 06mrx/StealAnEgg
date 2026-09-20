#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""g4.py — bangun fluent3.lua (LinoriaLib, 3 TAB: Home/Farmx/Progress) dari fluent2.lua.

SURGERY (anchor 1-based, di-resolve DINAMIS via pencarian substring — tahan nomor baris berubah):
  KEEP verbatim : head[1..2181]   + dt-plumbing[2194..2255] + addStatusRow[2267..2304] + tail[2740..end]
  DROP          : Z1 loader Fluent[2181..2193]
  DROP          : Z2 r.notify Fluent[2256..2266]   -> ganti versi Linoria (signature SAMA)
  DROP          : Z3 helper Fluent[2305..2490]     -> 10 helper Linoria (signature/callback SAMA)
  DROP          : Z4 build 7-tab[2491..2739]       -> build 3-tab; call-site Home/Farmx/Progress
                  disalin VERBATIM dari fluent2 (Home[2491..2535], Farmx[2536..2585], Prog[2627..2646]).
  TAIL KEEP     : tail[2740..end] verbatim; hanya r.unload punya Fluent:Destroy -> diganti Linoria.

Logika (r.*, callbacks, dt.SetState/dt.GetState wiring, fr(), main-loop) TIDAK disentuh: tetap
menulis ke state-store yg sama, sehingga dapat diverifikasi definitif via luau-compile.
"""
import io

SRC = "fluent2.lua"
DST = "fluent3.lua"

def read_lines(path):
    with io.open(path, "r", encoding="utf-8", errors="replace") as fh:
        return fh.read().split("\n")

L = read_lines(SRC)
N = len(L)

def find(term, start=0, label=""):
    for i in range(start, N):
        if term in L[i]:
            return i
    raise RuntimeError("ANCHOR GAGAL: " + (label or term))

# ===================== anchor (0-based index baris) =====================
iFluent   = find("local Fluent = nil", 0, "loader Fluent")          # 2181
iDt       = find("local dt = {}", iFluent, "dt store")              # 2193
iNotify   = find("function r.notify(", iDt, "r.notify")             # 2255
iStatus   = find("local function addStatusRow(", iNotify, "addStatusRow")  # 2266
iToggle   = find("local function addToggle(", iStatus, "addToggle") # 2304
iSafeTab  = find("local function safeTab(", iToggle, "safeTab")     # 2468
iSection  = find("local function addSectionSafe(", iSafeTab, "addSectionSafe")  # 2479
iHome     = find('local tabHome = addTab(Window, "Home")', iSection, "tabHome")  # 2490
iFarm     = find('local tabFarm = addTab(Window, "Farmx")', iHome, "tabFarm")    # 2535
iPets     = find('local tabPets = addTab(Window, "Pets")', iFarm, "tabPets")     # 2585
iSell     = find('local tabSell = addTab(Window, "Sell")', iPets, "tabSell")     # 2607
iProg     = find('local tabProg = addTab(Window, "Progress")', iSell, "tabProg") # 2626
iPlayer   = find('local tabPlayer = addTab(Window, "Player")', iProg, "tabPlayer")  # 2646
iSys      = find('local tabSys = addTab(Window, "System")', iPlayer, "tabSys")      # 2687
iFr       = find("local function fr()", iSys, "fr")                 # 2739

print("anchor OK: Fluent=%d dt=%d notify=%d status=%d toggle=%d safeTab=%d section=%d | home=%d farm=%d pets=%d sell=%d prog=%d player=%d sys=%d fr=%d (0-based)" % (
    iFluent, iDt, iNotify, iStatus, iToggle, iSafeTab, iSection,
    iHome, iFarm, iPets, iSell, iProg, iPlayer, iSys, iFr))

# ===================== segmen yang dipakai verbatim =====================
head_keep    = L[0:iFluent]                          # prolog + r.* + callbacks + logika (1..2181)
plumb_keep   = L[iDt:iNotify]                        # dt store + getState/isOn/optionValue (2194..2255)
status_keep  = L[iStatus:iToggle]                    # addStatusRow custom (2267..2304)
tail_keep    = L[iFr:N]                              # fr() + fr() run + main loop (2740..end)
home_block   = L[iHome:iFarm]                        # call-site HOME verbatim
farm_block   = L[iFarm:iPets]                        # call-site FARMX verbatim
prog_block   = L[iProg:iPlayer]                      # call-site PROGRESS verbatim

# ===================== Z1: LINORIA LOADER =====================
lin_loader = [
"local Library = nil",
"local LibLoaded = false",
"do",
"    local ok, lib = pcall(function()",
"        return loadstring(game:HttpGet(\"https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua\"))()",
"    end)",
"    if ok and lib then",
"        Library = lib",
"        LibLoaded = true",
"    end",
"end",
"if not Library then",
"    warn(\"[NiCH] LinoriaLib failed to load (check internet connection)\")",
"end",
"",
]

# ===================== Z2: r.notify LINTAS LIBRARY (Linoria) =====================
lin_notify = [
"function r.notify(title, content, kind, duration)",
"    pcall(function()",
"        if not Library then return end",
"        local nt = {",
"            Title = tostring(title or \"NiCH HUB\"),",
"            Content = tostring(content or \"\"),",
"            Duration = tonumber(duration) or 3,",
"        }",
"        if kind == \"Warning\" then nt.Title = \"[WARN] \" .. nt.Title end",
"        if kind == \"Error\" then nt.Title = \"[ERR] \" .. nt.Title end",
"        Library:Notify(nt)",
"    end)",
"end",
"",
]

# ===================== Z3: 10 HELPER LINORIA (signature SAMA dgn Fluent) =====================
lin_helpers = [
"local function addSectionSafe(parent, title)",
"    if not parent then return nil end",
"    local ok, sec = pcall(function() return parent:AddLeftGroupbox(title) end)",
"    if not ok then",
"        ok, sec = pcall(function() return parent:AddRightGroupbox(title) end)",
"    end",
"    if not ok or not sec then",
"        pcall(function() if Library then Library:Notify({ Title = \"UI skip\", Content = \"Section \\\"\" .. title .. \"\\\": \" .. tostring(sec) }) end end)",
"        return nil",
"    end",
"    return sec",
"end",
"",
"local function addStatusRowSafe(section, title, value)",
"    if not section then return nil end",
"    local ctr = section.Container or section",
"    local row = Instance.new(\"Frame\")",
"    row.BackgroundTransparency = 1",
"    row.Size = UDim2.new(1, 0, 0, 20)",
"    row.Parent = ctr",
"",
"    local t = Instance.new(\"TextLabel\")",
"    t.BackgroundTransparency = 1",
"    t.Size = UDim2.new(0.5, 0, 1, 0)",
"    t.Font = Enum.Font.GothamMedium",
"    t.TextSize = 13",
"    t.TextColor3 = Color3.fromRGB(190, 190, 200)",
"    t.TextXAlignment = Enum.TextXAlignment.Left",
"    t.Text = title",
"    t.Parent = row",
"",
"    local v = Instance.new(\"TextLabel\")",
"    v.BackgroundTransparency = 1",
"    v.Size = UDim2.new(0.5, 0, 1, 0)",
"    v.Position = UDim2.new(0.5, 0, 0, 0)",
"    v.Font = Enum.Font.GothamBold",
"    v.TextSize = 13",
"    v.TextColor3 = Color3.fromRGB(130, 200, 255)",
"    v.TextXAlignment = Enum.TextXAlignment.Right",
"    v.Text = tostring(value or \"\")",
"    v.Parent = row",
"",
"    local obj = {}",
"    function obj.SetValue(x) v.Text = tostring(x) end",
"    function obj.SetStatus(k)",
"        if k == \"Success\" then v.TextColor3 = Color3.fromRGB(90, 210, 130)",
"        elseif k == \"Warning\" then v.TextColor3 = Color3.fromRGB(235, 175, 70)",
"        elseif k == \"Error\" then v.TextColor3 = Color3.fromRGB(240, 90, 90)",
"        else v.TextColor3 = Color3.fromRGB(160, 160, 170) end",
"    end",
"    return obj",
"end",
"",
"local addStatusRow = addStatusRowSafe",
"",
"local function addToggle(parent, opt)",
"    local id = opt.Id",
"    dt.SetState(id, opt.Default == true, false)",
"    local fresh = true",
"    local ok, ctl = pcall(function()",
"        return parent:AddToggle(id, {",
"            Text = opt.Title,",
"            Default = opt.Default == true,",
"            Callback = function(v)",
"                if fresh then fresh = false; return end",
"                dt.SetState(id, v, true)",
"                if opt.Callback then pcall(opt.Callback, v) end",
"            end,",
"        })",
"    end)",
"    if not ok or not ctl then",
"        pcall(function() if Library then Library:Notify({ Title = \"UI skip\", Content = \"Toggle \\\"\" .. id .. \"\\\": \" .. tostring(ctl) }) end end)",
"        return nil",
"    end",
"    fresh = false",
"    return ctl",
"end",
"",
"local function addSlider(parent, opt)",
"    local id = opt.Id",
"    local defv = tonumber(opt.Default) or tonumber(opt.Min) or 0",
"    dt.SetState(id, defv, false)",
"    local fresh = true",
"    local ok, ctl = pcall(function()",
"        return parent:AddSlider(id, {",
"            Text = opt.Title,",
"            Min = tonumber(opt.Min) or 0,",
"            Max = tonumber(opt.Max) or 100,",
"            Default = defv,",
"            Rounding = tonumber(opt.Step) or 1,",
"            Suffix = opt.Suffix or \"\",",
"            Callback = function(v)",
"                if fresh then fresh = false; return end",
"                dt.SetState(id, tonumber(v) or 0, true)",
"                if opt.Callback then pcall(opt.Callback, tonumber(v) or 0) end",
"            end,",
"        })",
"    end)",
"    if not ok or not ctl then",
"        pcall(function() if Library then Library:Notify({ Title = \"UI skip\", Content = \"Slider \\\"\" .. id .. \"\\\": \" .. tostring(ctl) }) end end)",
"        return nil",
"    end",
"    fresh = false",
"    return ctl",
"end",
"",
"local function addDropdown(parent, opt)",
"    local id = opt.Id",
"    local defv = opt.Default",
"    dt.SetState(id, defv, false)",
"    local fresh = true",
"    local ok, ctl = pcall(function()",
"        return parent:AddDropdown(id, {",
"            Text = opt.Title,",
"            Values = opt.Options or {},",
"            Multi = opt.Multi == true,",
"            Default = defv,",
"            Callback = function(v)",
"                if fresh then fresh = false; return end",
"                dt.SetState(id, v, true)",
"                if opt.Callback then pcall(opt.Callback, v) end",
"            end,",
"        })",
"    end)",
"    if not ok or not ctl then",
"        pcall(function() if Library then Library:Notify({ Title = \"UI skip\", Content = \"Dropdown \\\"\" .. id .. \"\\\": \" .. tostring(ctl) }) end end)",
"        return nil",
"    end",
"    fresh = false",
"    return ctl",
"end",
"",
"local function addButton(parent, opt)",
"    local ok, ctl = pcall(function()",
"        return parent:AddButton({",
"            Text = opt.Title,",
"            Callback = function()",
"                if opt.Callback then pcall(opt.Callback) end",
"            end,",
"        })",
"    end)",
"    if not ok or not ctl then",
"        pcall(function() if Library then Library:Notify({ Title = \"UI skip\", Content = \"Button \\\"\" .. tostring(opt.Title) .. \"\\\": \" .. tostring(ctl) }) end end)",
"        return nil",
"    end",
"    return ctl",
"end",
"",
"local function addParagraph(parent, opt)",
"    local ok, ctl = pcall(function()",
"        local lbl = Instance.new(\"TextLabel\")",
"        lbl.BackgroundTransparency = 1",
"        lbl.Font = Enum.Font.GothamMedium",
"        lbl.TextSize = 13",
"        lbl.TextColor3 = Color3.fromRGB(200, 200, 210)",
"        lbl.TextWrapped = true",
"        lbl.Size = UDim2.new(1, 0, 0, 42)",
"        lbl.Text = tostring(opt.Title or \"\") .. \"\\n\" .. tostring(opt.Content or \"\")",
"        lbl.Parent = parent.Container or parent",
"        return lbl",
"    end)",
"    if not ok or not ctl then",
"        pcall(function() if Library then Library:Notify({ Title = \"UI skip\", Content = \"Paragraph: \" .. tostring(ctl) }) end end)",
"        return nil",
"    end",
"    return ctl",
"end",
"",
"local function addInput(parent, opt)",
"    local id = opt.Id",
"    local defv = tostring(opt.Default or \"\")",
"    dt.SetState(id, defv, false)",
"    local fresh = true",
"    local ok, ctl = pcall(function()",
"        return parent:AddInput(id, {",
"            Text = opt.Title,",
"            Default = defv,",
"            Numeric = opt.Numeric == true,",
"            Finished = function(v)",
"                if fresh then fresh = false; return end",
"                dt.SetState(id, v, true)",
"                if opt.Callback then pcall(opt.Callback, v) end",
"            end,",
"        })",
"    end)",
"    if not ok or not ctl then",
"        pcall(function() if Library then Library:Notify({ Title = \"UI skip\", Content = \"Input \\\"\" .. id .. \"\\\": \" .. tostring(ctl) }) end end)",
"        return nil",
"    end",
"    fresh = false",
"    return ctl",
"end",
"",
"local function safeTab(window, title)",
"    if not window then return nil end",
"    local ok, tab = pcall(function() return window:AddTab(title:lower()) end)",
"    if not ok or not tab then",
"        pcall(function() if Library then Library:Notify({ Title = \"UI skip\", Content = \"Tab \\\"\" .. title .. \"\\\": \" .. tostring(tab) }) end end)",
"        return nil",
"    end",
"    return tab",
"end",
"",
"local addTab = safeTab",
"",
]

# ===================== Z4: WINDOW + BUILD 3 TAB =====================
win_block = [
"local Window = nil",
"do",
"    if Library then",
"        local ok, ctl = pcall(function()",
"            return Library:CreateWindow({",
'                Title = "NiCH HUB (LinoriaLib)",',
"                ShowCustomCursor = false,",
"            })",
"        end)",
"        if ok and ctl then Window = ctl end",
"    end",
"end",
"",
"if Window then",
""]

home_block = home_block + ["    end"]   # tutup blok Home (punya `if tabHome then`)
farm_block = farm_block + ["    end"]   # tutup blok Farmx
prog_block = prog_block + ["    end"]   # tutup blok Progress

build_3tab = win_block + home_block + [""] + farm_block + [""] + prog_block + [
"end",
"",
]

# ===================== TAIL: r.unload Fluent -> Linoria =====================
tail_fixed = []
i_unload_destroy = None
for i, ln in enumerate(tail_keep):
    if "function r.unload(" in ln:
        i_unload_destroy = i
    if i_unload_destroy is not None and "Fluent:Destroy()" in ln:
        ln = ln.replace("Fluent:Destroy()", "LinoriaLibUnloadSafe()")
    if i_unload_destroy is not None and 'getgenv().Fluent = nil' in ln:
        ln = "        pcall(function() if getgenv then getgenv().Library = nil end end)"
    tail_fixed.append(ln)

# ---- tambahkan unload-safe helper di ATAS tail (dipakai r.unload) ----
unload_safe = [
"local function LinoriaLibUnloadSafe()",
"    pcall(function() if Library then Library:Unload() end end)",
"end",
"",
]

# ===================== ASSEMBLE =====================
out = (
    "\n".join(head_keep) + "\n\n" +
    "\n".join(lin_loader) + "\n" +
    "\n".join(plumb_keep) + "\n" +
    "\n".join(lin_notify) + "\n" +
    "\n".join(status_keep) + "\n" +
    "\n".join(lin_helpers) + "\n" +
    "\n".join(build_3tab) + "\n" +
    "\n".join(unload_safe) + "\n" +
    "\n".join(tail_fixed) + "\n"
)

with io.open(DST, "w", encoding="utf-8", newline="\n") as fh:
    fh.write(out)

print("DITULIS:", DST, "| total baris:", out.count("\n") + 1)
print("segmen: head=%d plumb=%d notify=%d status=%d helper=%d home=%d farm=%d prog=%d tail=%d unload=%d" % (
    len(head_keep), len(plumb_keep), len(lin_notify), len(status_keep),
    len(lin_helpers), len(home_block), len(farm_block), len(prog_block), len(tail_fixed), len(unload_safe)))
