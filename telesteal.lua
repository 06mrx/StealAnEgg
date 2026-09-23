local _G_ENV = (getgenv and getgenv()) or _G

if type(table.pack) ~= "function" then
    function table.pack(...) return { n = select("#", ...), ... } end
end
if type(table.unpack) ~= "function" then table.unpack = unpack end
if type(typeof) ~= "function" then typeof = type end

-- ============================================================
-- CLEANUP + GUARD (biar bisa di-stop dengan re-run)
-- ============================================================
local a = _G_ENV
if a.__TELESTEAL_RUNNING then
    a.__TELESTEAL_STOP = true
    task.wait(0.2)
end
a.__TELESTEAL_RUNNING = true

if not game:IsLoaded() then game.Loaded:Wait() end

local b       = game:GetService("Players")
local c       = game:GetService("RunService")
local d       = game:GetService("ReplicatedStorage")
local e       = game:GetService("Workspace")
local m       = b.LocalPlayer or b.PlayerAdded:Wait()
pcall(function() m:WaitForChild("PlayerGui", 10) end)

-- ============================================================
-- CONFIG
-- ============================================================
local CFG = {
    HoldTime      = 3,     -- durasi anchok di slot (konfirmasi carry)
    GrabDelay     = 0.55,  -- delay inisiasi carry
    TpHop         = 800,   -- lompatan teleport per frame (besar = makin instan)
    ArriveDist    = 4,     -- jarak dianggap sampai
    Priority      = "Rarest", -- Rarest | Nearest | Furthest | Biggest Size
    AutoReturn    = true,  -- teleport balik ke base setelah grab
    Defense       = true,  -- auto-swing bat bila ada lawan < 20 stud saat hold
    DefenseRadius = 20,
    BatTool       = "Bat [X1]",
    MaxSteals     = -1,    -- -1 = unlimited
    LoopDelay     = 0.25,
}

-- ============================================================
-- MODULE LOADER
-- ============================================================
local function requirePath(t, u, ...)
    local v = t
    local w = { ... }
    for _, x in ipairs(w) do
        if not v then return nil end
        local y = v:FindFirstChild(x)
        if not y then y = v:WaitForChild(x, u or 4) end
        v = y
    end
    if not v then return nil end
    local x, y = pcall(require, v)
    return x and y or nil
end
local function findModule(t)
    for _, u in ipairs(d:GetDescendants()) do
        if u:IsA("ModuleScript") and u.Name == t then
            local v, w = pcall(require, u)
            if v then return w end
        end
    end
    return nil
end
local function findRemote(t)
    for _, u in ipairs(d:GetDescendants()) do
        if (u:IsA("RemoteEvent") or u:IsA("RemoteFunction")) and u.Name == t then return u end
    end
    return nil
end
local function findRemoteContains(...)
    local t = { ... }
    for _, u in ipairs(d:GetDescendants()) do
        if u:IsA("RemoteEvent") or u:IsA("RemoteFunction") then
            local v = true
            for _, w in ipairs(t) do
                if not string.find(u.Name, w, 1, true) then v = false; break end
            end
            if v then return u end
        end
    end
    return nil
end
local function pickFromTable(t, ...)
    if typeof(t) ~= "table" then return nil end
    local u = { ... }
    local v = t
    for _, w in ipairs(u) do
        if typeof(v) ~= "table" then return nil end
        v = v[w]
    end
    return v
end
local function pickFn(t, ...)
    if typeof(t) ~= "table" then return nil end
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        local w = t[v]
        if typeof(w) == "function" then return w end
    end
    return nil
end

-- ============================================================
-- GAME MODULES
-- ============================================================
local ac     = requirePath(d, 6, "Client", "EggState") or findModule("EggState")
local ad     = requirePath(d, 6, "Client", "PlotState") or findModule("PlotState")
local ae     = requirePath(d, 4, "Shared", "Util", "AreaEggSlotIdentity") or findModule("AreaEggSlotIdentity")
local y      = requirePath(d, 4, "Data", "Assets") or findModule("Assets")

local aj = {
    GetAreaEggSnapshot = pickFn(ac, "ReadFieldEggs", "GetAreaEggSnapshot"),
    RequestAreaEggSnapshot = pickFn(ac, "SyncFieldEggs", "RequestAreaEggSnapshot"),
    AreaEggCarryStateChanged = ac and (ac.CarryChanged or ac.AreaEggCarryStateChanged),
    RequestCarryAreaEgg = pickFn(ac, "CarryFieldEgg", "RequestCarryAreaEgg"),
    RequestEquipTool = pickFn(ac, "WearEggTool", "RequestEquipTool"),
}
local ak = {
    GetRespawnPointCFrame = pickFn(ad, "FindRespawnCFrame", "GetRespawnPointCFrame"),
    GetPlotData = pickFn(ad, "ResolvePlot", "GetPlotData"),
}
local al = {
    IsFirstAreaUid = pickFn(ae, "LooksLikeFirstAreaUid", "IsFirstAreaUid"),
    BuildSlotKey = pickFn(ae, "SlotKey", "BuildSlotKey"),
}

local aq = findRemote("RF/EggWorld/AskFieldEggCarry") or findRemoteContains("AskFieldEggCarry")
local ar = findRemote("RF/EggWorld/AskFieldEggSnapshot") or findRemoteContains("AskFieldEggSnapshot")

if not aj.RequestCarryAreaEgg and aq then
    aj.RequestCarryAreaEgg = function(at, au)
        if aq:IsA("RemoteFunction") then return aq:InvokeServer(at, au) end
        aq:FireServer(at, au); return true
    end
end
if not aj.RequestAreaEggSnapshot and ar then
    aj.RequestAreaEggSnapshot = function()
        if ar:IsA("RemoteFunction") then return ar:InvokeServer() end
        ar:FireServer()
    end
end

-- ============================================================
-- CONSTANTS / STATE
-- ============================================================
local au = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10,
}

local de = e:FindFirstChild("__OBJECTS") and e.__OBJECTS:FindFirstChild("Areas")
if not de then
    local df = e:WaitForChild("__OBJECTS", 8)
    de = df and df:WaitForChild("Areas", 8)
end
local dg = e:FindFirstChild("AreaEggSlotsClient")
if not dg then dg = e:WaitForChild("AreaEggSlotsClient", 10) end

local run = true
local bu = false
local returnEggUid = nil
local steals = 0

local cs, ct = {}, {}
local function track(cn) table.insert(cs, cn); return cn end

-- ============================================================
-- ANTI-KICK HELPERS (dipakai gestur teleport)
-- ============================================================
local function di(dl)
    local dm = dl or 0.15
    return Vector3.new(
        (math.random() - 0.5) * dm,
        0,
        (math.random() - 0.5) * dm
    )
end

local function getRoot()
    local dq = m.Character
    return dq and dq:FindFirstChild("HumanoidRootPart") or nil
end
local function getHumanoid()
    local dq = m.Character
    return dq and dq:FindFirstChildOfClass("Humanoid") or nil
end

local function stripCheatMovers(dq)
    if not dq then return end
    for _, dr in ipairs(dq:GetChildren()) do
        local ds = dr.ClassName
        if ds == "BodyVelocity" or ds == "BodyPosition" or ds == "BodyGyro"
            or ds == "BodyAngularVelocity" or ds == "LinearVelocity"
            or ds == "VectorForce" or ds == "AlignOrientation" then
            pcall(function() dr:Destroy() end)
        end
    end
end
local function stopSoftMove(dq)
    if not dq then return end
    for _, dr in ipairs(dq:GetChildren()) do
        if dr:IsA("AlignPosition") then pcall(function() dr.Enabled = false; dr:Destroy() end) end
    end
end
local function placeRoot(dq, dr)
    if not dq or not dr then return end
    stopSoftMove(dq); stripCheatMovers(dq)
    local ds = m.Character
    if ds and ds.Parent then
        pcall(function() ds:PivotTo(dr) end)
    else
        pcall(function() dq.CFrame = dr end)
    end
end

local function getLaneY()
    if de then
        local dq = de:FindFirstChild("GameplayZ")
        if dq and dq:IsA("BasePart") then return dq.Position.Y + 3 end
    end
    local dq = getRoot()
    return dq and dq.Position.Y or 70
end
local function groundedY(dq, dr, ds)
    local dt = getLaneY()
    local du = getRoot()
    local dv = getHumanoid()
    local dw = 2
    if dv and dv.HipHeight > 0 then dw = dv.HipHeight end
    local dx = du and du.Size.Y * 0.5 or 1
    local dy = dw + dx
    local dz = dt + 1.5
    local ea = {}
    if m.Character then table.insert(ea, m.Character) end
    local eb = RaycastParams.new()
    eb.FilterType = Enum.RaycastFilterType.Exclude
    local ec = dt + 40
    local ed = nil
    for _ = 1, 20 do
        eb.FilterDescendantsInstances = ea
        local ee = e:Raycast(Vector3.new(dq, ec, dr), Vector3.new(0, -160, 0), eb)
        if not ee then break end
        local ef = ee.Position.Y
        local eg = ee.Instance.Name
        local eh = eg == "Ground" or string.find(string.lower(eg), "ground", 1, true) ~= nil
        if eh or ef <= dz then ed = ef; break end
        table.insert(ea, ee.Instance)
    end
    if ed then return math.clamp(ed + dy, dt - 2, dt + 5) end
    if typeof(ds) == "number" then return math.clamp(ds, dt - 2, dt + 5) end
    return dt + 3
end

-- ============================================================
-- TELEPORT BYPASS (versi "hop" -> ikke jalan, langsung lompat)
-- ============================================================
function teleportTo(dq, dr, hop)
    if typeof(dq) ~= "Vector3" or not run then return false end
    local dt = getRoot(); if not dt then return false end

    stripCheatMovers(dt); stopSoftMove(dt)
    local du = getHumanoid()
    if du then
        du.Sit = false
        du.PlatformStand = true
    end

    local dv = groundedY(dq.X, dq.Z, dt.Position.Y)
    local dw = Vector3.new(dq.X, dv, dq.Z)

    local hopLen = math.max(50, tonumber(hop) or CFG.TpHop)
    local q0 = os.clock()
    while run and os.clock() - q0 < 15 do
        if dr and not dr() then break end
        dt = getRoot(); if not dt then break end
        local eb = dw - dt.Position
        local ec = eb.Magnitude
        if ec <= CFG.ArriveDist then break end
        local ed = eb.Unit
        local step = math.min(hopLen, ec)
        local ei = dt.Position + ed * step + di(0.12)
        local ej = Vector3.new(ed.X, 0, ed.Z)
        local ek = CFrame.new(ei)
        if ej.Magnitude > 0.001 then ek = CFrame.lookAt(ei, ei + ej.Unit) end
        placeRoot(dt, ek)
        pcall(function() dt.AssemblyLinearVelocity = Vector3.zero end)
        pcall(function() dt.AssemblyAngularVelocity = Vector3.zero end)
        task.wait()
    end

    dt = getRoot()
    if dt then
        placeRoot(dt, CFrame.new(dw))
        pcall(function() dt.AssemblyLinearVelocity = Vector3.zero end)
        pcall(function() dt.AssemblyAngularVelocity = Vector3.zero end)
    end
    du = getHumanoid()
    if du then du.PlatformStand = false end
    return (dt and (dt.Position - dw).Magnitude or 1e9) <= math.max(4, CFG.ArriveDist + 1)
end

-- ============================================================
-- EGG SNAPSHOT
-- ============================================================
function snapshotEggs()
    local dq = aj.GetAreaEggSnapshot and aj.GetAreaEggSnapshot()
    if typeof(dq) ~= "table" or typeof(dq.Records) ~= "table" then
        if aj.RequestAreaEggSnapshot then pcall(aj.RequestAreaEggSnapshot) end
        dq = aj.GetAreaEggSnapshot and aj.GetAreaEggSnapshot()
    end
    if typeof(dq) ~= "table" then return {} end
    local dr = {}
    for _, ds in pairs(dq.Records or dq) do
        if typeof(ds) == "table" and typeof(ds.Uid) == "string" then table.insert(dr, ds) end
    end
    return dr
end
function findEggPart(dq)
    return (typeof(dq) == "string") and dg and dg:FindFirstChild(dq) or nil
end
function getSlotEggPosition(dq)
    if not dq then return nil end
    local dr = dq:FindFirstChild("Hitbox")
        or dq:FindFirstChild("CustomBoundingBox")
        or dq:FindFirstChildOfClass("BasePart")
    if dr then return dr.Position end
    return dq:GetPivot().Position
end
function resolveRarity(dq)
    if typeof(dq) ~= "string" or not y or typeof(y.Directory) ~= "table" then return nil end
    local dr = y.Directory[dq]
    local ds = dr and dr.Rarity
    if not ds then return nil end
    return ds._id or ds.DisplayName
end
function eggScore(dq) return au[resolveRarity(dq.AssetCategory) or "Common"] or 0 end

function pickTarget()
    local eggs = snapshotEggs()
    if #eggs == 0 then return nil end

    local root = getRoot()
    local mode = CFG.Priority
    local best, bestScore = nil, -math.huge
    local function score(rec, inst)
        local pos = inst and getSlotEggPosition(inst)
        local dist = pos and root and (root.Position - pos).Magnitude or math.huge
        local sc
        if mode == "Nearest" then sc = -dist
        elseif mode == "Furthest" then sc = dist
        elseif mode == "Biggest Size" then sc = tonumber(rec.AssetScale) or 0
        else sc = eggScore(rec) * 100000 - math.min(dist, 99999) end
        return sc
    end

    for _, rec in ipairs(eggs) do
        if rec.State == "Slot" then
            local inst = dg and dg:FindFirstChild(rec.Uid)
            if inst then
                local sc = score(rec, inst)
                if sc > bestScore then best, bestScore = { rec = rec, inst = inst }, sc end
            end
        elseif rec.State == "Dropped" then
            local inst = findEggPart(rec.Uid)
            if inst then
                local sc = score(rec, inst)
                if sc > bestScore then best, bestScore = { rec = rec, inst = inst }, sc end
            end
        end
    end
    return best
end

-- ============================================================
-- CARRY
-- ============================================================
function carriedEggKey()
    local du = returnEggUid
    if typeof(du) ~= "string" or du == "" then
        for _, ds in ipairs(snapshotEggs()) do
            if ds.State == "Carried" then du = ds.Uid; break end
        end
    end
    if not du then return nil, nil end
    local dv = nil
    if al.IsFirstAreaUid and al.BuildSlotKey and al.IsFirstAreaUid(du) then
        for _, ds in ipairs(snapshotEggs()) do
            if ds.Uid == du then
                dv = al.BuildSlotKey(ds.AreaId, ds.NestId)
                break
            end
        end
    end
    return du, dv
end
function tryCarryEgg(dq)
    if not dq or not aj.RequestCarryAreaEgg then return false end
    local edu = dq.Name
    local eds = nil
    if al.IsFirstAreaUid and al.IsFirstAreaUid(edu) then
        for _, dt in ipairs(snapshotEggs()) do
            if dt.Uid == edu and al.BuildSlotKey then
                eds = al.BuildSlotKey(dt.AreaId, dt.NestId)
                break
            end
        end
    end
    local dt, du = pcall(function() return aj.RequestCarryAreaEgg(edu, eds) end)
    if dt and du == true then return true end
    return bu
end
function refreshCarryEgg()
    if not bu or typeof(aj.RequestCarryAreaEgg) ~= "function" then return false end
    local du, dv = carriedEggKey()
    if not du then return false end
    return pcall(function() return aj.RequestCarryAreaEgg(du, dv) end)
end

if aj.AreaEggCarryStateChanged and typeof(aj.AreaEggCarryStateChanged.Connect) == "function" then
    track(aj.AreaEggCarryStateChanged:Connect(function(dq)
        local dr = typeof(dq) == "table" and dq.IsCarrying == true
        if dr then
            if typeof(dq) == "table" and typeof(dq.Uid) == "string" then returnEggUid = dq.Uid end
        else
            returnEggUid = nil
        end
        bu = dr
    end))
end

-- ============================================================
-- DEFENSE (opsional) - swing bat ke lawan dekat saat holding
-- ============================================================
local swingRemote = nil
local function findSwingRemote()
    if swingRemote ~= nil then return swingRemote end
    for _, dr in ipairs({ "RequestSwing", "SwingTool", "MeleeSwing", "KnockCarrierEgg", "AskSwingEggTool" }) do
        local ds = findRemoteContains(dr)
        if ds then swingRemote = ds; return ds end
    end
    swingRemote = false
    return nil
end
local function findBatTool()
    local char = m.Character
    if char then
        local t = char:FindFirstChild(CFG.BatTool)
        if t and t:IsA("Tool") then return t, true end
    end
    local bp = m:FindFirstChildOfClass("Backpack")
    if bp then
        local t = bp:FindFirstChild(CFG.BatTool)
        if t and t:IsA("Tool") then return t, false end
    end
    return nil, false
end
function defenseThreat()
    local dr = getRoot(); if not dr then return nil end
    local ds = CFG.DefenseRadius
    local dt = nil
    for _, du in ipairs(b:GetPlayers()) do
        if du ~= m then
            local dv = du.Character and du.Character:FindFirstChild("HumanoidRootPart")
            if dv then
                local dw = (dr.Position - dv.Position).Magnitude
                if dw <= ds then
                    if not dt then dt = dv elseif dw < (dr.Position - dt.Position).Magnitude then dt = dv end
                end
            end
        end
    end
    return dt
end
local function swingBat()
    local tool = findBatTool()
    if not tool then return false end
    local hum = getHumanoid()
    if hum then pcall(function() hum:EquipTool(tool) end) end
    pcall(function() tool:Activate() end)
    if aj.RequestEquipTool then pcall(aj.RequestEquipTool, tool.Name) end
    local re = tool:FindFirstChildOfClass("RemoteEvent")
    if re then pcall(function() re:FireServer() end) end
    local r = findSwingRemote()
    if r then pcall(function() r:FireServer(m.Name) end) end
    return true
end

-- ============================================================
-- BASE POSITION
-- ============================================================
function getBasePosition()
    if ak.GetRespawnPointCFrame then
        local dq = ak.GetRespawnPointCFrame()
        if dq then return dq.Position end
    end
    if not ak.GetPlotData then return nil end
    local dq = ak.GetPlotData()
    if not dq then return nil end
    if dq.CenterPoint then return dq.CenterPoint.Position end
    if dq.PetArea then return dq.PetArea.Position end
    return nil
end

-- ============================================================
-- STEAL FLOW
-- ============================================================
local function removePushBack()
    local ch = m.Character
    if not ch then return end
    for _, dr in ipairs(ch:GetDescendants()) do
        if dr:IsA("LocalScript") and string.find(dr.Name, "PushBack") then
            pcall(function() dr.Disabled = true; dr:Destroy() end)
        end
    end
end
local function holdAt(dur, pred)
    dur = tonumber(dur) or CFG.HoldTime
    local ds = getRoot(); if not ds then return false end
    local dt = ds.CFrame
    pcall(function() ds.Anchored = true end)
    local du = os.clock() + dur
    while run and os.clock() < du do
        if pred and not pred() then break end
        if CFG.Defense then
            if defenseThreat() then
                pcall(swingBat)
                task.wait(0.03)
            end
        end
        ds = getRoot()
        if ds then
            pcall(function() ds.CFrame = dt end)
            pcall(function() ds.Anchored = true end)
            pcall(function() ds.AssemblyLinearVelocity = Vector3.zero end)
        end
        c.Heartbeat:Wait()
    end
    ds = getRoot()
    if ds then
        pcall(function() ds.Anchored = false end)
        pcall(function() ds.AssemblyLinearVelocity = Vector3.zero end)
    end
    return true
end

function stealEgg(target)
    local pos = getSlotEggPosition(target.inst)
    if not pos then return false end

    removePushBack()

    -- TELEPORT langsung ke slot (tanpa jalan)
    if not teleportTo(pos, function() return run end) then return false end

    local ds = getRoot()
    if ds then
        local gy = groundedY(pos.X, pos.Z, pos.Y)
        placeRoot(ds, CFrame.new(pos.X, gy, pos.Z))
    end

    -- GRAB
    local dfe = { Name = target.rec.Uid }
    local q0 = os.clock()
    while run and not bu and os.clock() - q0 < 3 do
        tryCarryEgg(dfe)
        if bu then break end
        task.wait(0.05)
    end
    if not bu then return false end

    -- HOLD konfirmasi (anchored, bisa defend)
    holdAt(CFG.HoldTime, function() return bu end)

    -- Teleport kembali ke base
    if CFG.AutoReturn then
        local base = getBasePosition()
        if base then
            teleportTo(Vector3.new(base.X, base.Y + 3, base.Z), function() return bu end, CFG.TpHop)
        end
    end

    -- Confirm stage
    local q1 = os.clock()
    while run and bu and os.clock() - q1 < 3 do
        refreshCarryEgg()
        task.wait(0.1)
    end
    return true
end

-- ============================================================
-- MAIN LOOP
-- ============================================================
function step()
    if bu then
        -- lagi megang telur -> teleport ke base lalu konfirmasi
        local base = getBasePosition()
        if base then teleportTo(Vector3.new(base.X, base.Y + 3, base.Z), function() return bu end) end
        local q = os.clock()
        while run and bu and os.clock() - q < 3 do
            refreshCarryEgg(); task.wait(0.1)
        end
        return
    end
    if CFG.MaxSteals > 0 and steals >= CFG.MaxSteals then
        run = false
        print("[TeleSteal] reached MaxSteals:", steals)
        return
    end
    local target = pickTarget()
    if not target then return end
    local ok = pcall(stealEgg, target)
    if ok then steals = steals + 1 end
end

local function loop()
    while run and a.__TELESTEAL_RUN ~= false do
        if a.__TELESTEAL_STOP then break end
        local ok, err = pcall(step)
        if not ok then
            print("[TeleSteal] step error:", err)
            task.wait(1)
        end
        task.wait(CFG.LoopDelay)
    end
end

-- ============================================================
-- START/PAUSE (dipakai UI) + HARD-STOP (rerun / Stop penuh)
-- ============================================================
local loopActive = false
local function startLoop()
    if loopActive then return end
    loopActive = true
    run = true
    a.__TELESTEAL_RUN = true
    task.spawn(function()
        loop()
        loopActive = false
    end)
end
local function pauseLoop()
    run = false
    a.__TELESTEAL_RUN = false
end

-- Teardown penuh hanya saat rerun (guard di atas) / tombol Stop penuh.
task.spawn(function()
    while a.__TELESTEAL_STOP ~= true do task.wait() end
    run = false
    loopActive = false
    for _, cn in ipairs(cs) do
        pcall(function() cn:Disconnect() end)
    end
    a.__TELESTEAL_RUNNING = false
    print("[TeleSteal] dihentikan (hard stop).")
end)

a.__TELESTEAL_STOP = nil
startLoop()
print("[TeleSteal] aktif.")

-- ============================================================
-- LINORIA UI (config panel live)
-- ============================================================
if not (type(loadstring) == "function" or type(_G.loadstring) == "function") then
    print("[TeleSteal] executor tidak support loadstring; UI Linoria dilewati.")
else
    local Repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
    local okLS, Library = pcall(loadstring, game:HttpGet(Repo .. "Library.lua"))
    if not (okLS and Library) then
        print("[TeleSteal] gagal load LinoriaLib:", okLS and "nil lib" or tostring(Library))
    else
        Library = Library()
        local okTM, ThemeManager = pcall(loadstring, game:HttpGet(Repo .. "addons/ThemeManager.lua"))
        local okSM, SaveManager = pcall(loadstring, game:HttpGet(Repo .. "addons/SaveManager.lua"))
        ThemeManager = okTM and ThemeManager and ThemeManager() or nil
        SaveManager = okSM and SaveManager and SaveManager() or nil

        local ScreenH = (workspace and workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) and workspace.CurrentCamera.ViewportSize.Y or 1080

        local Window = Library:CreateWindow({
            Title = "TeleSteal",
            Center = true,
            AutoShow = true,
            TabPadding = 8,
            MenuFadeTime = 0.2,
            Size = UDim2.new(0, 360, 0, math.floor(ScreenH * 0.9)),
            Resizable = false,
        })

        local Tabs = {
            Steal = Window:AddTab("Steal"),
            ["UI Settings"] = Window:AddTab("UI Settings"),
        }

        local GrupTarget = Tabs.Steal:AddLeftGroupbox("Target")
        local GrupPerilaku = Tabs.Steal:AddLeftGroupbox("Perilaku")
        local GrupTiming = Tabs.Steal:AddRightGroupbox("Timing")
        local GrupDefense = Tabs.Steal:AddRightGroupbox("Defense")
        local GrupKontrol = Tabs.Steal:AddRightGroupbox("Kontrol")

        GrupTarget:AddDropdown("Priority", {
            Text = "Prioritas",
            Values = { "Rarest", "Nearest", "Furthest", "Biggest Size" },
            Default = CFG.Priority,
            Callback = function(v) CFG.Priority = v end,
        })
        GrupTarget:AddSlider("ArriveDist", {
            Text = "Jarak Anggap Sampai",
            Default = CFG.ArriveDist, Min = 1, Max = 15, Rounding = 1,
            Suffix = " stud", Callback = function(v) CFG.ArriveDist = v end,
        })
        GrupTarget:AddSlider("TpHop", {
            Text = "Panjang Hop Teleport",
            Default = CFG.TpHop, Min = 100, Max = 2000, Rounding = 1,
            Suffix = " stud", Callback = function(v) CFG.TpHop = v end,
        })
        GrupTarget:AddSlider("MaxSteals", {
            Text = "Maksimal Steal (-1 = abadi)",
            Default = CFG.MaxSteals, Min = -1, Max = 50, Rounding = 1,
            Callback = function(v) CFG.MaxSteals = v end,
        })

        GrupPerilaku:AddToggle("AutoReturn", {
            Text = "Balik ke Base Setelah Grab",
            Default = CFG.AutoReturn,
            Callback = function(v) CFG.AutoReturn = v end,
        })
        GrupPerilaku:AddInput("BatTool", {
            Text = "Nama Tool Bat",
            Default = CFG.BatTool, Numeric = false, Finished = false,
            Callback = function(v) CFG.BatTool = v end,
        })

        GrupTiming:AddSlider("HoldTime", {
            Text = "Durasi Anchok di Slot",
            Default = CFG.HoldTime, Min = 0.5, Max = 10, Rounding = 1,
            Suffix = " dtk", Callback = function(v) CFG.HoldTime = v end,
        })
        GrupTiming:AddSlider("GrabDelay", {
            Text = "Delay Inisiasi Grab",
            Default = CFG.GrabDelay, Min = 0.1, Max = 2, Rounding = 2,
            Suffix = " dtk", Callback = function(v) CFG.GrabDelay = v end,
        })
        GrupTiming:AddSlider("LoopDelay", {
            Text = "Delay Loop",
            Default = CFG.LoopDelay, Min = 0.05, Max = 1, Rounding = 2,
            Suffix = " dtk", Callback = function(v) CFG.LoopDelay = v end,
        })

        GrupDefense:AddToggle("Defense", {
            Text = "Auto Swing Bat (anti-ganggu)",
            Default = CFG.Defense,
            Callback = function(v) CFG.Defense = v end,
        })
        GrupDefense:AddSlider("DefenseRadius", {
            Text = "Jarak Deteksi Lawan",
            Default = CFG.DefenseRadius, Min = 5, Max = 40, Rounding = 1,
            Suffix = " stud", Callback = function(v) CFG.DefenseRadius = v end,
        })

        GrupKontrol:AddToggle("Enabled", {
            Text = "Aktif (start/pause loop)",
            Default = (run and a.__TELESTEAL_RUN ~= false and run ~= nil) or false,
            Callback = function(v)
                if v then
                    startLoop()
                    print("[TeleSteal] lanjut (loop distart ulang dari UI).")
                else
                    pauseLoop()
                    print("[TeleSteal] dijeda lewat UI.")
                end
            end,
        })
        GrupKontrol:AddButton({
            Text = "Stop Total (hard stop)",
            DoubleClick = true,
            Func = function()
                run = false
                pauseLoop()
                if a.__TELESTEAL_STOP ~= nil or a.__TELESTEAL_STOP == nil then
                    a.__TELESTEAL_STOP = true
                end
                print("[TeleSteal] hard stop diminta lewat UI (teardown jalan).")
            end,
        })
        GrupKontrol:AddLabel("Rerun skrip = hard stop total (teardown semua koneksi).")

        Tabs["UI Settings"]:AddDivider()
        local TmBox = Tabs["UI Settings"]:AddRightGroupbox("Tema")
        local SvBox = Tabs["UI Settings"]:AddRightGroupbox("Simpan")

        if ThemeManager then
            ThemeManager:SetLibrary(Library)
            TmBox:AddLabel("Warna / tema via ThemeManager")
            ThemeManager:ApplyToTab(Tabs["UI Settings"])
        end
        if SaveManager then
            SaveManager:SetLibrary(Library)
            SaveManager:IgnoreThemeSettings()
            SaveManager:BuildConfigSection(Tabs["UI Settings"])
        end

        if ThemeManager then Library:OnUnload(function() ThemeManager:Unload() if SaveManager then SaveManager:Unload() end end) end

        print("[TeleSteal] UI Linoria siap.")
    end
end