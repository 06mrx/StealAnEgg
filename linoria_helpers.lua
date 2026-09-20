-- ============================================================
-- LINORIA HELPER SHIM — fluent3.lua
-- Nama & signature SAMA dengan panggilan-call site Fluent asli
-- (addToggle/addSlider/addDropdown/addButton/addParagraph/
--  addInput/addSectionSafe/addTab) sehingga blok Home/Farm/Progress
-- yang disalin verbatim tetap terwire otomatis ke r.*/dt.*/fq.*
-- ============================================================

do
    local ok, lib = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
    end)
    if ok and lib then Library = lib end
end

if not Library then
    warn("[NiCH] LinoriaLib failed to load (check internet connection)")
end

r.notify = function(title, content, kind, duration)
    pcall(function()
        if not Library or not Library.Notify then return end
        Library:Notify({
            Title = tostring(title or "NiCH HUB"),
            Content = tostring(content or ""),
            Duration = tonumber(duration) or 3,
        })
    end)
end

local function addSectionSafe(parent, title)
    if not parent then return nil end
    local ok, sec = pcall(function() return parent:AddLeftGroupbox(title) end)
    if not ok or not sec then
        local ok2, sec2 = pcall(function() return parent:AddRightGroupbox(title) end)
        if not ok2 or not sec2 then
            pcall(function() if Library then Library:Notify({ Title = "UI skip", Content = "Section \"" .. title .. "\": " .. tostring(sec) }) end end)
            return nil
        end
        sec = sec2
    end
    return sec
end

local function addTab(window, title)
    if not window then return nil end
    local ok, tab = pcall(function() return window:AddTab(title) end)
    if not ok or not tab then
        pcall(function() if Library then Library:Notify({ Title = "UI skip", Content = "Tab \"" .. title .. "\": " .. tostring(tab) }) end end)
        return nil
    end
    return tab
end

local function addStatusRow(section, title, value)
    if not section then return nil end

    local row = Instance.new("Frame")
    row.BackgroundTransparency = 1
    row.Parent = section.Container or section
    row.Size = UDim2.new(1, 0, 0, 22)

    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Size = UDim2.new(0.55, -4, 1, 0)
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 13
    t.TextColor3 = Color3.fromRGB(200, 200, 210)
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = title
    t.Parent = row

    local v = Instance.new("TextLabel")
    v.BackgroundTransparency = 1
    v.Size = UDim2.new(0.45, 0, 1, 0)
    v.Position = UDim2.new(0.55, 0, 0, 0)
    v.Font = Enum.Font.GothamBold
    v.TextSize = 13
    v.TextColor3 = Color3.fromRGB(120, 180, 255)
    v.TextXAlignment = Enum.TextXAlignment.Right
    v.Text = tostring(value or "")
    v.Parent = row

    local obj = {}
    function obj.SetValue(x) v.Text = tostring(x) end
    function obj.SetStatus(k)
        if k == "Success" then v.TextColor3 = Color3.fromRGB(90, 210, 130)
        elseif k == "Warning" then v.TextColor3 = Color3.fromRGB(235, 175, 70)
        elseif k == "Error" then v.TextColor3 = Color3.fromRGB(240, 90, 90)
        else v.TextColor3 = Color3.fromRGB(160, 160, 170)
        end
    end
    return obj
end

local function addToggle(parent, opt)
    local id = opt.Id

    dt.SetState(id, opt.Default == true, false)

    local fresh = true
    local ok, ctl = pcall(function()
        return parent:AddToggle(id, {
            Text = opt.Title,
            Default = opt.Default == true,
            Callback = function(v)
                if fresh then fresh = false; return end
                dt.SetState(id, v, true)
                if opt.Callback then pcall(opt.Callback, v) end
            end,
        })
    end)
    if not ok or not ctl then
        pcall(function() if Library then Library:Notify({ Title = "UI skip", Content = "Toggle \"" .. id .. "\": " .. tostring(ctl) }) end end)
        return nil
    end
    fresh = false
    return ctl
end

local function addSlider(parent, opt)
    local id = opt.Id
    local def = tonumber(opt.Default) or opt.Min or 0

    dt.SetState(id, def, false)

    local fresh = true
    local ok, ctl = pcall(function()
        return parent:AddSlider(id, {
            Text = opt.Title,
            Min = tonumber(opt.Min) or 0,
            Max = tonumber(opt.Max) or 100,
            Default = def,
            Rounding = tonumber(opt.Step) or 1,
            Suffix = opt.Suffix or "",
            Callback = function(v)
                if fresh then fresh = false; return end
                dt.SetState(id, v, true)
                if opt.Callback then pcall(opt.Callback, v) end
            end,
        })
    end)
    if not ok or not ctl then
        pcall(function() if Library then Library:Notify({ Title = "UI skip", Content = "Slider \"" .. id .. "\": " .. tostring(ctl) }) end end)
        return nil
    end
    fresh = false
    return ctl
end

local function addDropdown(parent, opt)
    local id = opt.Id
    local multi = opt.Multi == true

    dt.SetState(id, opt.Default, false)

    local fresh = true
    local ok, ctl = pcall(function()
        return parent:AddDropdown(id, {
            Text = opt.Title,
            Values = opt.Options or {},
            Multi = multi,
            Default = opt.Default,
            Callback = function(v)
                if fresh then fresh = false; return end
                dt.SetState(id, v, true)
                if opt.Callback then pcall(opt.Callback, v) end
            end,
        })
    end)
    if not ok or not ctl then
        pcall(function() if Library then Library:Notify({ Title = "UI skip", Content = "Dropdown \"" .. id .. "\": " .. tostring(ctl) }) end end)
        return nil
    end
    fresh = false
    return ctl
end

local function addButton(parent, opt)
    local ok, ctl = pcall(function()
        return parent:AddButton({
            Text = opt.Title,
            Callback = function()
                if opt.Callback then pcall(opt.Callback) end
            end,
        })
    end)
    if not ok or not ctl then
        pcall(function() if Library then Library:Notify({ Title = "UI skip", Content = "Button \"" .. tostring(opt.Title) .. "\": " .. tostring(ctl) }) end end)
        return nil
    end
    return ctl
end

local function addParagraph(parent, opt)
    local ok, lbl = pcall(function()
        return parent:AddLabel(tostring(opt.Title or "") .. "\n" .. tostring(opt.Content or ""))
    end)
    if not ok or not lbl then
        pcall(function() if Library then Library:Notify({ Title = "UI skip", Content = "Paragraph \"" .. tostring(opt.Title) .. "\": " .. tostring(lbl) }) end end)
        return nil
    end
    return lbl
end

local function addInput(parent, opt)
    local id = opt.Id
    local def = tostring(opt.Default or "")

    dt.SetState(id, def, false)

    local fresh = true
    local ok, ctl = pcall(function()
        return parent:AddInput(id, {
            Text = opt.Title,
            Default = def,
            Numeric = opt.Numeric == true,
            Finished = function(v)
                if opt.Callback then pcall(opt.Callback, v) end
            end,
        })
    end)
    if not ok or not ctl then
        pcall(function() if Library then Library:Notify({ Title = "UI skip", Content = "Input \"" .. id .. "\": " .. tostring(ctl) }) end end)
        return nil
    end
    fresh = false
    return ctl
end
