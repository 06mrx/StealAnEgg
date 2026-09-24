local _G_ENV = (getgenv and getgenv()) or _G

if type(table.pack) ~= "function" then
    function table.pack(...) return { n = select("#", ...), ... } end
end
if type(table.unpack) ~= "function" then table.unpack = unpack end
if type(typeof) ~= "function" then typeof = type end
if type(math.clamp) ~= "function" then
    function math.clamp(a, b, c)
        if a < b then return b elseif a > c then return c end
        return a
    end
end
if type(table.find) ~= "function" then
    function table.find(a, b, c)
        if type(a) ~= "table" then return nil end
        for d = tonumber(c) or 1, #a do if a[d] == b then return d end end
        return nil
    end
end

local a = _G_ENV
if type(a.__APEX_HUB_SHUTDOWN) == "function" then
    pcall(a.__APEX_HUB_SHUTDOWN); task.wait(0.1)
end
if a.__APEX_HUB_RUNNING then return end
a.__APEX_HUB_RUNNING = true

if not game:IsLoaded() then game.Loaded:Wait() end

local b            = game:GetService("Players")
local c         = game:GetService("RunService")
local d        = game:GetService("HttpService")
local e    = game:GetService("TeleportService")
local f   = game:GetService("UserInputService")
local g           = game:GetService("Lighting")
local h          = game:GetService("Workspace")
local i  = game:GetService("ReplicatedStorage")
local j         = game:GetService("GuiService")
local k            = game:GetService("CoreGui")
local l       = game:GetService("TweenService")

local m = b.LocalPlayer or b.PlayerAdded:Wait()
pcall(function() m:WaitForChild("PlayerGui", 10) end)

local n = "isi nanti aja"
local o  = "rbxassetid://131679774975668"
local p  = "NiCH Hub"
local q     = "Discord: " .. n

-- ============================================================
-- GAME MODULES
-- ============================================================
local r = {}

function r.cloneList(s)
    local t = {}
    if type(s) ~= "table" then return t end
    for u = 1, #s do t[u] = s[u] end
    return t
end
function r.clearTable(s)
    if type(s) ~= "table" then return end
    for t in pairs(s) do s[t] = nil end
end

local s = true

function r.waitFor(t, u, v)
    local w = os.clock() + (tonumber(t) or 1)
    local x = tonumber(u) or 0.05
    local y = false
    repeat
        if v and v() == true then y = true
        elseif s and os.clock() < w then task.wait(x) end
    until y or (not s) or os.clock() >= w
    return y
end

function r.requirePath(t, u, ...)
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
function r.findModule(t)
    for _, u in ipairs(i:GetDescendants()) do
        if u:IsA("ModuleScript") and u.Name == t then
            local v, w = pcall(require, u)
            if v then return w end
        end
    end
    return nil
end
function r.findRemote(t)
    for _, u in ipairs(i:GetDescendants()) do
        if (u:IsA("RemoteEvent") or u:IsA("RemoteFunction")) and u.Name == t then return u end
    end
    return nil
end
function r.findRemoteContains(...)
    local t = { ... }
    for _, u in ipairs(i:GetDescendants()) do
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
function r.pickFromTable(t, ...)
    if typeof(t) ~= "table" then return nil end
    local u = { ... }
    local v = t
    for _, w in ipairs(u) do
        if typeof(v) ~= "table" then return nil end
        v = v[w]
    end
    return v
end
function r.pickFn(t, ...)
    if typeof(t) ~= "table" then return nil end
    for u = 1, select("#", ...) do
        local v = select(u, ...)
        local w = t[v]
        if typeof(w) == "function" then return w end
    end
    return nil
end
function r.remoteFrom(t, ...)
    local u = r.pickFromTable(t, ...)
    if typeof(u) == "Instance" then return u end
    return nil
end

local t        = r.requirePath(i, 6, "Shared", "Save") or r.findModule("Save")
local u         = r.requirePath(i, 4, "Shared", "Globals", "Constants") or r.findModule("Constants")
local v = r.requirePath(i, 4, "Client", "BaseUpgrade") or r.findModule("BaseUpgrade")
local w          = r.requirePath(i, 4, "Shared", "Types", "Eggs") or r.findModule("Eggs")
local x       = r.requirePath(i, 4, "Data", "Areas") or r.findModule("Areas")
local y        = r.requirePath(i, 4, "Data", "Assets") or r.findModule("Assets")
local z       = r.requirePath(i, 4, "Data", "Gears") or r.findModule("Gears")
local aa      = r.requirePath(i, 4, "Data", "Trails") or r.findModule("Trails")
local ab    = r.requirePath(i, 4, "Data", "Treadmills") or r.findModule("Treadmills")
local ac    = r.requirePath(i, 6, "Client", "EggState") or r.findModule("EggState")
local ad   = r.requirePath(i, 6, "Client", "PlotState") or r.findModule("PlotState")
local ae= r.requirePath(i, 4, "Shared", "Util", "AreaEggSlotIdentity") or r.findModule("AreaEggSlotIdentity")
local af = r.requirePath(i, 4, "Client", "AssetRoster") or r.findModule("AssetRoster")
local ag  = r.requirePath(i, 4, "Shared", "Util", "AssetItems") or r.findModule("AssetItems")
local ah  = r.requirePath(i, 4, "Shared", "Util", "FuseKernel") or r.findModule("FuseKernel")
local ai     = r.requirePath(i, 6, "Shared", "Remotes") or r.findModule("Remotes")

local aj = {
    GetAreaEggSnapshot = r.pickFn(ac, "ReadFieldEggs", "GetAreaEggSnapshot"),
    RequestAreaEggSnapshot = r.pickFn(ac, "SyncFieldEggs", "RequestAreaEggSnapshot"),
    AreaEggCarryStateChanged = ac and (ac.CarryChanged or ac.AreaEggCarryStateChanged),
    RequestCarryAreaEgg = r.pickFn(ac, "CarryFieldEgg", "RequestCarryAreaEgg"),
    RequestDropHeldAreaEgg = r.pickFn(ac, "DropFieldEgg", "RequestDropHeldAreaEgg"),
    IsLocalEggReady = r.pickFn(ac, "IsReadyToHatch", "IsLocalEggReady"),
    RequestHatchEgg = r.pickFn(ac, "BeginHatch", "RequestHatchEgg"),
    RequestCompleteHatchEgg = r.pickFn(ac, "FinishHatch", "RequestCompleteHatchEgg"),
    RequestEquipTool = r.pickFn(ac, "WearEggTool", "RequestEquipTool"),
    RequestPlaceEgg = r.pickFn(ac, "PlantEgg", "RequestPlaceEgg"),
}
local ak = {
    GetRespawnPointCFrame = r.pickFn(ad, "FindRespawnCFrame", "GetRespawnPointCFrame"),
    GetPlotData = r.pickFn(ad, "ResolvePlot", "GetPlotData"),
    IsWorldPositionWithinLocalPlotBounds = r.pickFn(ad, "ContainsLocalPoint", "IsWorldPositionWithinLocalPlotBounds"),
    GetSlotOwner = r.pickFn(ad, "LookupOwner", "GetSlotOwner"),
}
local al = {
    IsFirstAreaUid = r.pickFn(ae, "LooksLikeFirstAreaUid", "IsFirstAreaUid"),
    BuildSlotKey = r.pickFn(ae, "SlotKey", "BuildSlotKey"),
}
local am = { GetRuntimeSnapshot = r.pickFn(af, "ReadSnapshot", "GetRuntimeSnapshot") }
local an = { Deserialize = r.pickFn(ag, "Decode", "Deserialize") }
local ao = {
    CanSelectPet = r.pickFn(ah, "MayEnterFuse", "CanSelectPet"),
    CalculateFusePrice = r.pickFn(ah, "PriceFor", "CalculateFusePrice"),
}

local ap = {
    Backpack = {
        EQUIP_BEST = r.remoteFrom(ai, "Haul", "WearBest")
            or r.findRemoteContains("WearBest") or r.findRemoteContains("EQUIP_BEST"),
    },
    Plots = {
        REQUEST_BASE_UPGRADE = r.remoteFrom(ai, "Homestead", "AskBaseTierRaise")
            or r.findRemoteContains("AskBaseTierRaise") or r.findRemoteContains("BaseUpgrade"),
    },
    Treadmills = {
        REQUEST_UPGRADE = r.remoteFrom(ai, "Treadmill", "AskTierRaise") or r.findRemoteContains("AskTierRaise"),
        REQUEST_EQUIP_STATIC = r.remoteFrom(ai, "Treadmill", "AskWearStill") or r.findRemoteContains("AskWearStill"),
        REQUEST_UNEQUIP = r.remoteFrom(ai, "Treadmill", "AskDoff") or r.findRemoteContains("AskDoff"),
    },
    Index = { REQUEST_CLAIM_ALL = r.remoteFrom(ai, "Codex", "AskRedeemAll") or r.findRemoteContains("AskRedeemAll") },
    AssetInventory = {
        SELL_ASSET = r.remoteFrom(ai, "PetSatchel", "SellPet")
            or r.findRemoteContains("SellPet") or r.findRemoteContains("SELL_ASSET"),
        SELL_SELECTION = (function()
            local pkg = i:FindFirstChild("Packages")
            local net = pkg and pkg:FindFirstChild("Networking")
            local ev = net and net:FindFirstChild("RE/PetSatchel/SellSelection")
            if ev and (ev:IsA("RemoteEvent") or ev:IsA("RemoteFunction")) then return ev end
            return r.findRemote("RE/PetSatchel/SellSelection")
                or r.remoteFrom(ai, "PetSatchel", "SellSelection")
                or r.findRemoteContains("SellSelection")
        end)(),
    },
    OfflineAssets = {
        GET_SUMMARY = r.remoteFrom(ai, "AwayEarnings", "FetchSummary") or r.findRemoteContains("FetchSummary"),
        REQUEST_REDEEM = r.remoteFrom(ai, "AwayEarnings", "AskCollect") or r.findRemoteContains("AskCollect"),
    },
    FuseMachine = {
        COMPLETE_REVEAL = r.remoteFrom(ai, "Fusery", "FinishReveal") or r.findRemoteContains("FinishReveal"),
        ACKNOWLEDGE_INFO = r.remoteFrom(ai, "Fusery", "ConfirmBriefing") or r.findRemoteContains("ConfirmBriefing"),
        INSERT_MOB = r.remoteFrom(ai, "Fusery", "LoadPet") or r.findRemoteContains("LoadPet"),
        START_FUSE = r.remoteFrom(ai, "Fusery", "BeginFuse") or r.findRemoteContains("BeginFuse"),
    },
    Trails = {
        REQUEST_PURCHASE = r.remoteFrom(ai, "Trailwear", "AskPurchase") or r.findRemoteContains("AskPurchase"),
        REQUEST_SELECT = r.remoteFrom(ai, "Trailwear", "AskChoose") or r.findRemoteContains("AskChoose"),
        WORN_SNAPSHOT = r.remoteFrom(ai, "Trailwear", "AskWornSnapshot") or r.findRemoteContains("AskWornSnapshot"),
    },
    GroupReward = { CLAIM_REWARD = r.remoteFrom(ai, "GroupPerk", "RedeemPerk") or r.findRemoteContains("RedeemPerk") },
}

local aq    = r.findRemote("RF/EggWorld/AskFieldEggCarry") or r.findRemoteContains("AskFieldEggCarry")
local ar = r.findRemote("RF/EggWorld/AskFieldEggSnapshot") or r.findRemoteContains("AskFieldEggSnapshot")
local as    = r.findRemote("RF/EggWorld/AskPlaceEgg") or r.findRemoteContains("AskPlaceEgg")
local warpStrikeRemote = r.remoteFrom(ai, "GuardPatrol", "ForestStrike")
    or r.findRemote("RE/GuardPatrol/ForestStrike") or r.findRemoteContains("ForestStrike")
local warpTollRemote = r.remoteFrom(ai, "GuardPatrol", "SpeedTollOffer")
    or r.findRemote("RE/GuardPatrol/SpeedTollOffer") or r.findRemoteContains("SpeedTollOffer")

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
if not aj.RequestPlaceEgg and as then
    aj.RequestPlaceEgg = function(at, au)
        if as:IsA("RemoteFunction") then return as:InvokeServer(at, au) end
        as:FireServer(at, au); return true
    end
end

-- ============================================================
-- CONSTANTS
-- ============================================================
local at = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine" }
local au = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10,
}
local av = { "Golden", "Rainbow", "Silver" }
local aw = { "Rarest", "Nearest", "Furthest", "Biggest Size" }
local ax = { "Highest Rarity", "Lowest Rarity", "Most Duplicates" }
local ay = { "Base", "Treadmill" }
local az = { "Auto Steal Egg", "Auto Place Egg", "Auto Hatch", "Auto Treadmill" }
local ba = { "PrioritySlot1", "PrioritySlot2", "PrioritySlot3", "PrioritySlot4" }
local bb = { "No Matching Eggs", "Timed Interval", "After Steal Count" }
local bc = { "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic" }

local bd = {}
if x and typeof(x.Directory) == "table" then
    for be in pairs(x.Directory) do table.insert(bd, be) end
    table.sort(bd)
else
    bd = r.cloneList(bc)
end

local be, bf, bg = {}, {}, {}
if aa and typeof(aa.Directory) == "table" then
    local bh = {}
    for bi, bj in pairs(aa.Directory) do
        table.insert(bh, { id = bi, name = bj.DisplayName, price = tonumber(bj.Price) or 0 })
    end
    table.sort(bh, function(bi, bj) return bi.price < bj.price end)
    for _, bi in ipairs(bh) do
        table.insert(be, bi.name)
        bf[bi.name] = bi.id
        bg[bi.name] = bi.price
    end
end

local bh = {}
if z then
    local bi = z.Directory or z
    if typeof(bi) == "table" then
        for _, bj in pairs(bi) do
            if typeof(bj) == "table" and typeof(bj.DisplayName) == "string" then
                bh[bj.DisplayName] = tonumber(bj.MoneyCost) or 0
            end
        end
    end
end

-- ============================================================
-- STATE / TUNABLES
-- ============================================================
local bi       = 2000
local bj  = 700
local bk = 800
local bl     = 2000

local function bm(bn)
    return math.clamp(tonumber(bn) or bk, 16, bl)
end

local bo = 4
local bp = 3
local bq = { GrabDelay = 0.55, ReturnPace = 0.12, ArriveDistance = 1.35, MoveTimeout = 14 }

local br = {}
local bs = tostring(game.JobId)
local bt = bs
if #bt > 18 then bt = string.sub(bt, 1, 18) .. "..." end

local bu = false
local bv = 0
local bw = nil
local bx = false
local by = {}
local bz = false
local returnEggUid = nil
local returnState = "idle"
local ca = false
local cb = 0
local cc = 0
local cd = os.clock()
local ce = nil
local cf = 0
local cg = 1
local ch = 0
local ci = tick()
local cj = tick()
local ck = false
local cl = false
local cm = nil
local cn = nil
local co = false
local cp = os.clock()
local cq = os.clock()
local cr, cs = {}, {}
local ct = false
local cu = nil
local cv = 0
local cw, cx, cy = 0, 0, 0
local cz, da = {}, {}
local db, dc = {}, {}

local dd = {}
if getgenv then
    local de = getgenv().ApexHubHopHistory
    if typeof(de) ~= "table" then de = {}; getgenv().ApexHubHopHistory = de end
    dd = de
end

local de = h:FindFirstChild("__OBJECTS") and h.__OBJECTS:FindFirstChild("Areas")
if not de then
    local df = h:WaitForChild("__OBJECTS", 8)
    de = df and df:WaitForChild("Areas", 8)
end
local df = de and de:FindFirstChild("GuardAreas")
if de and not df then df = de:WaitForChild("GuardAreas", 6) end

local dg = h:FindFirstChild("AreaEggSlotsClient")
if not dg then dg = h:WaitForChild("AreaEggSlotsClient", 10) end

local dh = Instance.new("Folder")
dh.Name = "ApexEggEsp"
dh.Parent = h

function r.track(di) table.insert(br, di); return di end

-- ============================================================
-- ANTI-KICK HELPERS
-- ============================================================
local function di(dj)
    local dl = dj or 0.15
    return Vector3.new(
        (math.random() - 0.5) * dl,
        0,
        (math.random() - 0.5) * dl
    )
end

local dk = 0
local dl = 1 / 45
local function dm(dn, dp)
    if not dn or not dp then return end
    local ds = os.clock()
    if ds - dk < dl then return end
    dk = ds
    pcall(function() dn.CFrame = dp end)
end

-- ============================================================
-- GAME HELPERS
-- ============================================================
function r.getHumanoid()
    local dq = m.Character
    return dq and dq:FindFirstChildOfClass("Humanoid") or nil
end
function r.getRoot()
    local dq = m.Character
    return dq and dq:FindFirstChild("HumanoidRootPart") or nil
end
function r.getSave()
    if not t or typeof(t.Get) ~= "function" then return nil end
    local dq, dr = pcall(t.Get)
    return dq and dr or nil
end
function r.netInvoke(dq, ...)
    if typeof(dq) ~= "Instance" then return nil end
    local dr = table.pack(...)
    local ds, dt = nil, false
    task.spawn(function()
        if dq:IsA("RemoteFunction") then
            ds = table.pack(pcall(function() return dq:InvokeServer(table.unpack(dr, 1, dr.n)) end))
        elseif dq:IsA("RemoteEvent") then
            ds = table.pack(pcall(function() dq:FireServer(table.unpack(dr, 1, dr.n)); return true end))
        else ds = table.pack(false) end
        dt = true
    end)
    r.waitFor(8, 0.05, function() return dt == true end)
    if not dt or ds[1] ~= true then return nil end
    return ds[2], ds[3]
end
function r.netCall(dq, ...)
    if typeof(dq) == "Instance" and dq:IsA("RemoteEvent") then
        return pcall(function(...) dq:FireServer(...) end, ...)
    end
    return r.netInvoke(dq, ...)
end
function r.countTable(dq)
    if typeof(dq) ~= "table" then return 0 end
    local dr = 0
    for _ in pairs(dq) do dr = dr + 1 end
    return dr
end
function r.formatNumber(dq)
    local dr = tonumber(dq) or 0
    local ds = { "", "K", "M", "B", "T", "Qa", "Qi" }
    local dt = 1
    for _ = 1, 6 do
        if dr >= 1000 then dr = dr / 1000; dt = dt + 1 end
    end
    if dt == 1 then return string.format("%d", dr) end
    return string.format("%.2f%s", dr, ds[dt])
end
function r.formatElapsed(dq)
    local dr = math.max(0, math.floor(dq))
    local ds = math.floor(dr / 3600)
    local dt = math.floor((dr % 3600) / 60)
    if ds > 0 then return string.format("%dh %dm", ds, dt) end
    return string.format("%dm", dt)
end
function r.resolveRarity(dq)
    if typeof(dq) ~= "string" or not y or typeof(y.Directory) ~= "table" then return nil end
    local dr = y.Directory[dq]
    local ds = dr and dr.Rarity
    if not ds then return nil end
    return ds._id or ds.DisplayName
end
function r.assetName(dq)
    if y and typeof(y.Directory) == "table" then
        local dr = y.Directory[dq or ""]
        if dr and dr.DisplayName then return dr.DisplayName end
    end
    return tostring(dq or "Unknown")
end
function r.recordMutations(dq)
    local dr = {}
    if typeof(dq) ~= "table" then return dr end
    if typeof(dq.Mutations) == "table" then
        for _, ds in pairs(dq.Mutations) do
            if typeof(ds) == "string" then table.insert(dr, ds) end
        end
    end
    if typeof(dq.BaseMutation) == "string" then table.insert(dr, dq.BaseMutation) end
    return dr
end
function r.getLaneZ()
    if de then
        local dq = de:FindFirstChild("GameplayZ")
        if dq and dq:IsA("BasePart") then return dq.Position.Z end
        local dr = de:FindFirstChild("SeparationLine")
        if dr and dr:IsA("BasePart") then return dr.Position.Z end
    end
    return -365.5
end
function r.getLaneY()
    if de then
        local dq = de:FindFirstChild("GameplayZ")
        if dq and dq:IsA("BasePart") then return dq.Position.Y + 3 end
    end
    local dq = r.getRoot()
    return dq and dq.Position.Y or 70
end
function r.getEntryPosition()
    if de then
        local dq = de:FindFirstChild("StartArea")
        if dq and dq:IsA("BasePart") then return Vector3.new(dq.Position.X, r.getLaneY(), r.getLaneZ()) end
        local dr = de:FindFirstChild("SeparationLine")
        if dr and dr:IsA("BasePart") then return Vector3.new(dr.Position.X, r.getLaneY(), r.getLaneZ()) end
    end
    return Vector3.new(543.5, r.getLaneY(), r.getLaneZ())
end
function r.getZoneModel(dq) return df and df:FindFirstChild(dq) end
function r.getZoneLaneCenter(dq)
    local dr = r.getZoneModel(dq)
    if not dr then return nil end
    local ds = dr:FindFirstChild("Bounds")
    if ds and ds:IsA("BasePart") then return Vector3.new(ds.Position.X, r.getLaneY(), r.getLaneZ()) end
    local dt, du = pcall(function() return dr:GetBoundingBox() end)
    if dt and du then return Vector3.new(du.Position.X, r.getLaneY(), r.getLaneZ()) end
    return nil
end
function r.getArenaBounds()
    if not de then return nil end
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
    local found = false
    for _, dr in ipairs(de:GetChildren()) do
        if dr:IsA("Model") then
            local ds = dr:FindFirstChild("Bounds")
            if ds and ds:IsA("BasePart") then
                local dt = ds.Position
                local du = ds.Size
                minX = math.min(minX, dt.X - du.X / 2)
                maxX = math.max(maxX, dt.X + du.X / 2)
                minZ = math.min(minZ, dt.Z - du.Z / 2)
                maxZ = math.max(maxZ, dt.Z + du.Z / 2)
                found = true
            end
        end
    end
    if not found then return nil end
    return { minX = minX, maxX = maxX, minZ = minZ, maxZ = maxZ }
end
function r.stripCheatMovers(dq)
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
function r.stopSoftMove(dq)
    if not dq then return end
    for _, dr in ipairs(dq:GetChildren()) do
        if dr:IsA("AlignPosition") then pcall(function() dr.Enabled = false; dr:Destroy() end) end
    end
end
function r.placeRoot(dq, dr)
    if not dq or not dr then return end
    r.stopSoftMove(dq); r.stripCheatMovers(dq)
    local ds = m.Character
    if ds and ds.Parent then
        pcall(function() ds:PivotTo(dr) end)
    else
        dm(dq, dr)
    end
end
function r.groundedY(dq, dr, ds)
    local dt = r.getLaneY()
    local du = r.getRoot()
    local dv = r.getHumanoid()
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
        local ee = h:Raycast(Vector3.new(dq, ec, dr), Vector3.new(0, -160, 0), eb)
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
-- STEAL / BYPASS SPEED
-- ============================================================
function r.stealSpeed()
    local dq = tonumber(r.optionValue("StealMoveSpeed", bj)) or bj
    return math.clamp(dq, 16, bi)
end
function r.bypassSpeed()
    local dq = tonumber(r.optionValue("BypassReturnSpeed", bk)) or bk
    return bm(dq)
end

function r.swapStealHumanoid()
    local dq = m.Character
    if not dq then return false end
    for _, dr in ipairs(dq:GetDescendants()) do
        if dr:IsA("LocalScript") and string.find(dr.Name, "PushBack") then
            pcall(function() dr.Disabled = true; dr:Destroy() end)
        end
    end
    return true
end

function r.disableRagdoll(dq)
    dq = dq or m.Character
    if not dq then return false end
    local dh = dq:FindFirstChildOfClass("Humanoid")
    if dh then
        pcall(function()
            dh:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            dh:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            dh:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end)
    end
    for _, dr in ipairs(dq:GetDescendants()) do
        if dr:IsA("LocalScript") then
            local dn = string.lower(dr.Name)
            if string.find(dn, "ragdoll") or string.find(dn, "fall") then
                pcall(function() dr.Disabled = true end)
            end
        end
        if dr:IsA("BallSocketConstraint") or dr:IsA("HingeConstraint") then
            pcall(function() dr:Destroy() end)
        end
    end
    for _, dr in ipairs(dq:GetDescendants()) do
        if dr:IsA("Motor6D") and dr.Part0 and dr.Part1 then
            pcall(function()
                dr.Enabled = true
                local dw = dr.Part1:FindFirstChild("RigidJointWeld_" .. dr.Name)
                if not dw then
                    dw = Instance.new("WeldConstraint")
                    dw.Name = "RigidJointWeld_" .. dr.Name
                    dw.Part0 = dr.Part0
                    dw.Part1 = dr.Part1
                    dw.Parent = dr.Part1
                end
            end)
        end
    end
    return true
end

local origWalkSpeed, origJumpPower, origUseJumpPower = nil, nil, nil
function r.stealCleanup()
    r.statueDespawn()
    local part = r.getRoot()
    if part then
        pcall(function() part.Anchored = false end)
        pcall(function() part.AssemblyLinearVelocity = Vector3.zero end)
        pcall(function() part.AssemblyAngularVelocity = Vector3.zero end)
        for _, item in ipairs(part:GetChildren()) do
            local nm = item.Name
            if nm == "ApexBypassMove" or nm == "ApexBypassGyro" or nm == "ApexFlyLV" then
                pcall(function() item:Destroy() end)
            end
        end
    end

    local hum = r.prepareStealHumanoid()
    if hum then
        hum.Sit = false
        hum.PlatformStand = false
        hum.AutoRotate = true
        if origWalkSpeed ~= nil then hum.WalkSpeed = origWalkSpeed end
        if origJumpPower ~= nil then hum.JumpPower = origJumpPower end
        if origUseJumpPower ~= nil then hum.UseJumpPower = origUseJumpPower end
    end

    task.delay(0.2, function()
        local char = m.Character
        if not char then return end
        for _, item in ipairs(char:GetDescendants()) do
            if item:IsA("LocalScript") then
                pcall(function()
                    item.Disabled = true
                    item.Disabled = false
                end)
            end
        end
    end)
    return true
end

function r.prepareStealHumanoid()
    local dq = m.Character
    if not dq then return nil end
    local dr = dq:FindFirstChildOfClass("Humanoid")
    if not dr then return nil end

    if origWalkSpeed == nil then
        origWalkSpeed = dr.WalkSpeed
        origJumpPower = dr.JumpPower
        origUseJumpPower = dr.UseJumpPower
    end

    local ds = h.CurrentCamera
    local dt = ds and ds.CFrame or nil

    local du = nil
    local dv, dw = pcall(function()
        dr.Archivable = true
        return dr:Clone()
    end)

    if dv and dw then
        du = dw
        du.Parent = dq
        c.Heartbeat:Wait()
        pcall(function()
            if dr and dr.Parent then dr:Destroy() end
        end)
    else
        du = dr
    end

    task.wait(0.1)

    du = dq:FindFirstChildOfClass("Humanoid") or du
    if du then
        du.Sit = false
        du.PlatformStand = false
        du.WalkSpeed = r.stealSpeed()
        du.AutoRotate = true
    end

    if ds and du then
        pcall(function()
            ds.CameraSubject = du
            if dt then ds.CFrame = dt end
        end)
    end

    return du
end

function r.buildStealPath(dq, dr)
    local ds, dt = r.getLaneZ(), r.getLaneY()
    local du = {}
    if math.abs(dq.Z - ds) > 3 then table.insert(du, Vector3.new(dq.X, dt, ds)) end
    if math.abs(dq.X - dr.X) > 2 then table.insert(du, Vector3.new(dr.X, dt, ds)) end
    table.insert(du, Vector3.new(dr.X, dt, dr.Z))
    return du
end

function r.humanoidStealMoveTo(dq, dr)
    if typeof(dq) ~= "Vector3" or not s then return false end
    local ds = m.Character
    local dt = ds and ds:FindFirstChildOfClass("Humanoid")
    local du = r.getRoot()
    if not dt or not du then return false end

    dt.Sit = false
    dt.PlatformStand = false
    dt.AutoRotate = true
    dt.WalkSpeed = r.stealSpeed()

    local dv = r.groundedY(dq.X, dq.Z, du.Position.Y)
    local dw = Vector3.new(dq.X, dv, dq.Z)
    if (du.Position - dw).Magnitude <= bq.ArriveDistance then return true end

    local dx = r.buildStealPath(du.Position, dw)
    if #dx == 0 then dx = { dw } end

    local dy = 0
    for _, dz in ipairs(dx) do
        if not s or (dr and not dr()) then return false end
        du = r.getRoot(); if not du then return false end
        local ea = r.groundedY(dz.X, dz.Z, du.Position.Y)
        local eb = Vector3.new(dz.X, ea, dz.Z)
        local ec = os.clock() + bq.MoveTimeout

        while s and os.clock() < ec do
            if dr and not dr() then return false end
            du = r.getRoot(); if not du then return false end
            local ed = eb - du.Position
            local ee = ed.Magnitude
            if ee <= bq.ArriveDistance then break end

            local ef = ed.Unit
            local eg = math.clamp(c.Heartbeat:Wait(), 0, 1 / 30)
            local eh = math.min(r.stealSpeed() * eg, ee)
            local ei = du.Position + ef * eh + di(0.1)

            local ej = Vector3.new(ef.X, 0, ef.Z)
            local ek
            if ej.Magnitude > 0.001 then
                ek = CFrame.lookAt(ei, ei + ej.Unit)
            else
                ek = CFrame.new(ei)
            end
            dm(du, ek)

            dy = dy + 1
            if dy % 4 == 0 then
                du.AssemblyLinearVelocity = Vector3.zero
                du.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end

    du = r.getRoot(); if not du then return false end
    r.placeRoot(du, CFrame.new(dw))
    return (du.Position - dw).Magnitude <= math.max(3, bq.ArriveDistance + 1)
end

function r.stealMoveTo(dq, dr, ds)
    local dt = r.getRoot(); if not dt then return false end
    local du = r.groundedY(dq, dr, dt.Position.Y)
    return r.humanoidStealMoveTo(Vector3.new(dq, du, dr), ds)
end
function r.stealAlong(dq, dr)
    for _, ds in ipairs(dq) do
        if dr and not dr() then return false end
        if not r.stealMoveTo(ds.X, ds.Z, dr) then return false end
    end
    return true
end
function r.getBasePosition()
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
function r.getPetAreaStandPosition()
    if ak.GetPlotData then
        local dq = ak.GetPlotData()
        if dq and dq.PetArea then return dq.PetArea.Position + Vector3.new(0, 4, 0) end
    end
    return r.getBasePosition()
end
function r.isNearPlot()
    local dq = r.getRoot(); if not dq then return false end
    if ak.IsWorldPositionWithinLocalPlotBounds and ak.IsWorldPositionWithinLocalPlotBounds(dq.Position) then return true end
    local dr = r.getPetAreaStandPosition()
    return dr ~= nil and (dq.Position - dr).Magnitude <= 30
end

function r.bypassMoveTo(dq, dr, ds, eeAlt)
    if typeof(dq) ~= "Vector3" or not s then return false end
    ds = bm(ds or r.bypassSpeed())
    local dt = r.getRoot(); if not dt then return false end

    r.stripCheatMovers(dt); r.stopSoftMove(dt)
    local du = r.getHumanoid()
    if du then
        du.Sit = false
        du.PlatformStand = true
    end

    local dv = r.groundedY(dq.X, dq.Z, dt.Position.Y)
    local dw = Vector3.new(dq.X, dv, dq.Z)
    if tonumber(eeAlt) and eeAlt > 0 then dw = Vector3.new(dq.X, dv + eeAlt, dq.Z) end
    if (dt.Position - dw).Magnitude <= bo then
        if du then du.PlatformStand = false end
        return true
    end

    local dx = Instance.new("BodyVelocity")
    dx.Name = "ApexBypassMove"
    dx.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    dx.P = 1250
    dx.Velocity = Vector3.zero
    dx.Parent = dt

    local dy = Instance.new("BodyGyro")
    dy.Name = "ApexBypassGyro"
    dy.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    dy.P = 3000
    dy.D = 50
    dy.CFrame = dt.CFrame
    dy.Parent = dt

    local dz, ea = false, os.clock() + 15
    local bn = r.getArenaBounds()
    local bmN = 25
    if bn then
        local bx, cx = bn.minX + bmN, bn.maxX - bmN
        local bz, cz = bn.minZ + bmN, bn.maxZ - bmN
        if bx > cx then bx, cx = (bx + cx) / 2, (bx + cx) / 2 end
        if bz > cz then bz, cz = (bz + cz) / 2, (bz + cz) / 2 end
        bn.loX, bn.hiX = bx, cx
        bn.loZ, bn.hiZ = bz, cz
    end
    while s and os.clock() < ea do
        if dr and not dr() then break end
        dt = r.getRoot(); if not dt then break end
        local eb = dw - dt.Position
        local ec = eb.Magnitude
        if ec <= bo then dz = true; break end
        local ed = eb.Unit
        local vd = ed * ds
        if bn then
            local px = math.clamp(dt.Position.X + vd.X * 0.1, bn.loX, bn.hiX)
            local pz = math.clamp(dt.Position.Z + vd.Z * 0.1, bn.loZ, bn.hiZ)
            local ex = px - dt.Position.X
            local ez = pz - dt.Position.Z
            local eh = math.sqrt(ex * ex + ez * ez)
            if eh > 0.001 then
                vd = Vector3.new(ex, ed.Y, ez) * (1 / eh) * ds
            end
        end
        dx.Velocity = vd
        local ee = Vector3.new(ed.X, 0, ed.Z)
        if ee.Magnitude > 0.001 then
            dy.CFrame = CFrame.lookAt(dt.Position, dt.Position + ee.Unit)
        end
        c.Heartbeat:Wait()
    end

    if dx and dx.Parent then dx:Destroy() end
    if dy and dy.Parent then dy:Destroy() end

    dt = r.getRoot()
    if dt then
        dt.AssemblyLinearVelocity = Vector3.zero
        dt.AssemblyAngularVelocity = Vector3.zero
        if dz then r.placeRoot(dt, CFrame.new(dw.X, dv, dw.Z)) end
    end
    du = r.getHumanoid()
    if du then du.PlatformStand = false end
    return dz
end

-- ============================================================
-- HOLD 3s: ĐỨNG CHẶT (Anchored). Hết 3s -> nhả anchor dứt khoát
-- ============================================================
function r.holdAtPosition(dq, dr, eeDef)
    dq = tonumber(dq) or bp
    local ds = r.getRoot(); if not ds then return false end
    local dt = ds.CFrame

    pcall(function() ds.Anchored = true end)

    local du = os.clock() + dq
    while s and os.clock() < du do
        if dr and not dr() then break end
        if eeDef then
            local dv = r.defenseThreat(20)
            if dv and r.stealingEnabled() then pcall(r.swingBat) end
        end
        ds = r.getRoot()
        if ds then
            ds.AssemblyLinearVelocity  = Vector3.zero
            ds.AssemblyAngularVelocity = Vector3.zero
            pcall(function() ds.CFrame = dt end)
            pcall(function() ds.Anchored = true end)
        end
        c.Heartbeat:Wait()
    end

    -- Hết 3s -> NHẢ ANCHOR NGAY (không đứng chặt nữa)
    ds = r.getRoot()
    if ds then
        pcall(function() ds.Anchored = false end)
        ds.AssemblyLinearVelocity  = Vector3.zero
        ds.AssemblyAngularVelocity = Vector3.zero
    end
    return true
end

function r.returnToBaseBypass(dq)
    r.statueDespawn()
    local dr = r.getBasePosition()
    if not dr then return false end
    if dq and not dq() then return false end
    local eeAlt = tonumber(r.optionValue("ReturnFlyHeight", 40)) or 40
    return r.bypassMoveTo(Vector3.new(dr.X, dr.Y + 3, dr.Z), dq, r.bypassSpeed(), eeAlt)
end
function r.returnToBase(dq) return r.returnToBaseBypass(dq) end
function r.ensureAtPlot(dq)
    if dq and not dq() then return false end
    if r.isNearPlot() then return true end
    local dr = r.getPetAreaStandPosition()
    if not dr then return false end
    return r.bypassMoveTo(dr, dq, r.bypassSpeed())
end

local statueActive = false
local statueModel = nil
local statueBasePos = nil
local statueConn = nil

function r.statueSpawn()
    if statueActive or not r.isOn("StatueCam") then return end
    local real = m.Character
    if not real then return end
    local stand = r.getPetAreaStandPosition() or r.getBasePosition()
    if not stand then return end
    local statue
    pcall(function()
        real.Archivable = true
        statue = real:Clone()
    end)
    if not statue then return end
    for _, dr in ipairs(statue:GetDescendants()) do
        if dr:IsA("LocalScript") or dr:IsA("Script") then pcall(function() dr:Destroy() end) end
    end
    local sh = statue:FindFirstChildOfClass("Humanoid")
    if sh then
        pcall(function()
            sh:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            sh.WalkSpeed = 0
            sh.JumpPower = 0
            sh.AutoRotate = false
            sh.PlatformStand = false
            sh.Sit = false
        end)
    end
    for _, dr in ipairs(statue:GetDescendants()) do
        if dr:IsA("BasePart") then
            pcall(function()
                dr.Anchored = true
                dr.AssemblyLinearVelocity = Vector3.zero
                dr.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
    local sroot = statue:FindFirstChild("HumanoidRootPart")
    if sroot then
        pcall(function() sroot.CFrame = CFrame.new(stand) * CFrame.Angles(0, math.rad(180), 0) end)
    end
    statue.Name = "ApexStatueCam"
    statue.Parent = h
    statueModel = statue
    statueBasePos = stand
    statueActive = true

    local cam = h.CurrentCamera
    if not cam then statueActive = false; return end
    pcall(function() cam.CameraType = Enum.CameraType.Scriptable end)
    local lookOffset = Vector3.new(0, 4, 0)
    statueConn = c.RenderStepped:Connect(function()
        local sm = statueModel
        if not r.statueToggle() or not sm or not sm.Parent then
            r.statueDespawn()
            return
        end
        local sroot2 = sm:FindFirstChild("HumanoidRootPart")
        local p = sroot2 and sroot2.Position or (statueBasePos.Position + Vector3.new(0, 3, 0))
        local eye = statueBasePos.Position + Vector3.new(0, 5, 12)
        cam.CFrame = CFrame.lookAt(eye, p + lookOffset)
    end)
end

function r.statueDespawn()
    statueActive = false
    if statueConn then
        pcall(function() statueConn:Disconnect() end)
        statueConn = nil
    end
    if statueModel then
        pcall(function() statueModel:Destroy() end)
        statueModel = nil
    end
    statueBasePos = nil
    local cam = h.CurrentCamera
    if cam then
        pcall(function()
            cam.CameraType = Enum.CameraType.Custom
            local hum = m.Character and m.Character:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end)
    end
end
function r.statueToggle() return r.isOn("StatueCam") end

-- ============================================================
-- EGG / STEAL
-- ============================================================
function r.getAreaEggs()
    if not aj.GetAreaEggSnapshot then return {} end
    local dq = aj.GetAreaEggSnapshot()
    if typeof(dq) ~= "table" or typeof(dq.Records) ~= "table" then
        if aj.RequestAreaEggSnapshot then pcall(aj.RequestAreaEggSnapshot) end
        dq = aj.GetAreaEggSnapshot()
    end
    if typeof(dq) ~= "table" or typeof(dq.Records) ~= "table" then return {} end
    local dr = {}
    for _, ds in pairs(dq.Records) do
        if typeof(ds) == "table" and typeof(ds.Uid) == "string" then table.insert(dr, ds) end
    end
    return dr
end
function r.findAreaEggRecord(dq)
    for _, dr in ipairs(r.getAreaEggs()) do if dr.Uid == dq then return dr end end
    return nil
end
function r.getSlotEggPosition(dq)
    local dr = dq:FindFirstChild("Hitbox")
        or dq:FindFirstChild("CustomBoundingBox")
        or dq:FindFirstChildOfClass("BasePart")
    if dr then return dr.Position end
    return dq:GetPivot().Position
end
function r.isBigEgg(dq)
    if not r.isOn("StealBigEggs") then return false end
    local dr = tonumber(dq.AssetScale)
    if not dr then return false end
    return dr >= (tonumber(r.optionValue("StealBigEggScale", 1.5)) or 1.5)
end
function r.eggScore(dq) return au[r.resolveRarity(dq.AssetCategory) or "Common"] or 0 end
function r.isStealCandidate(dq, dr)
    if typeof(dq) ~= "table" or typeof(dq.Uid) ~= "string" then return false end
    if dq.State ~= "Slot" and dq.State ~= "Dropped" then return false end
    if dr then return true end
    if r.isBigEgg(dq) and r.selectionAllows("StealZones", dq.AreaId) then return true end
    if not r.isOn("AutoStealSelected") and not r.isOn("AutoStealWarp") then return false end
    return r.matchesEggFilters(dq, "StealZones", "StealRarities", "StealMutations")
end
function r.pickStealTarget()
    local dq = dg and dg:GetChildren() or {}
    if #dq == 0 and #r.getAreaEggs() == 0 then return nil end
    local dr = {}
    for _, ds in ipairs(r.getAreaEggs()) do
        if typeof(ds.Uid) == "string" then dr[ds.Uid] = ds end
    end
    local ds = r.isOn("AutoStealAll") and not r.isOn("AutoStealSelected")
    local dt = r.getRoot()
    local du = r.optionValue("StealPriority", "Rarest")
    local dv, dw = nil, -math.huge
    local sc
    sc = function(dx, dy)
        local ea = r.getSlotEggPosition(dx)
        local eb = dt and ea and (dt.Position - ea).Magnitude or math.huge
        local ec
        if du == "Nearest" then ec = -eb
        elseif du == "Furthest" then ec = eb
        elseif du == "Biggest Size" then ec = tonumber(dy and dy.AssetScale) or 0
        else ec = (dy and r.eggScore(dy) or 0) * 100000 - math.min(eb, 99999) end
        if ec > dw then dv, dw = dx, ec end
    end
    for _, dx in ipairs(dq) do
        local dy = dr[dx.Name]
        local dz = dy and r.isStealCandidate(dy, ds) or (dy == nil and ds)
        if dz then sc(dx, dy) end
    end
    for _, dy in ipairs(r.getAreaEggs()) do
        if dy.State == "Dropped" then
            local dx = r.findEggPart(dy.Uid)
            if dx then sc(dx, dy) end
        end
    end
    return dv
end
function r.carriedEggPosition(dq)
    if typeof(dq) ~= "table" then return nil end
    local dr = dq.BottomCFrame or dq.BoundsCFrame
    if typeof(dr) == "CFrame" then return dr.Position end
    local ds = typeof(dq.Uid) == "string" and r.findEggPart(dq.Uid)
    if ds then return r.getSlotEggPosition(ds) end
    return nil
end
function r.findCarrierRoot(dq)
    local dr = r.carriedEggPosition(dq)
    if not dr then return nil end
    local ds = r.getRoot()
    local dt, du = nil, math.huge
    for _, dv in ipairs(b:GetPlayers()) do
        if dv ~= m then
            local dw = dv.Character and dv.Character:FindFirstChild("HumanoidRootPart")
            if dw then
                local dx = (dr - dw.Position).Magnitude
                if dx < du then du, dt = dx, dw end
            end
        end
    end
    if du <= 250 then return dt end
    return nil
end
function r.defenseThreat(dq)
    local dr = r.getRoot()
    if not dr then return nil end
    local ds = math.min(tonumber(dq) or 20, 250)
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
function r.chaseCandidateEggs()
    local dq = {}
    local dr = r.isOn("AutoStealAll") and not r.isOn("AutoStealSelected")
    for _, ds in ipairs(r.getAreaEggs()) do
        if typeof(ds) == "table" and (ds.State == "Carried" or ds.State == "Dropped") then
            if dr or r.isBigEgg(ds) or r.matchesEggFilters(ds, "StealZones", "StealRarities", "StealMutations") then
                table.insert(dq, ds)
            end
        end
    end
    return dq
end
function r.filterAllows(dq)
    if r.isOn("AutoStealAll") then return true end
    return r.isBigEgg(dq) or r.matchesEggFilters(dq, "StealZones", "StealRarities", "StealMutations")
end
function r.divineCarriedSolo()
    local dq = {}
    for _, ds in ipairs(r.getAreaEggs()) do
        if r.resolveRarity(ds.AssetCategory) == "Divine" and r.filterAllows(ds) then table.insert(dq, ds) end
    end
    if #dq ~= 1 then return nil end
    local ds = dq[1]
    if ds.State ~= "Carried" then return nil end
    local dt = r.findCarrierRoot(ds)
    if not dt then return nil end
    return { rec = ds, root = dt }
end
function r.pickChaseHitTarget()
    if not r.isOn("AutoChaseAndHit") then return nil end
    local dq = r.divineCarriedSolo()
    if dq then return dq end
    local dr, ds = nil, -math.huge
    for _, dt in ipairs(r.chaseCandidateEggs()) do
        local du = dt.State == "Carried" and r.findCarrierRoot(dt)
        local dv = r.eggScore(dt) * 100000 - math.min((r.getRoot() and (r.getRoot().Position - r.carriedEggPosition(dt)).Magnitude or 99999), 99999)
        if dv > ds then dr, ds = { rec = dt, root = du }, dv end
    end
    return dr
end
function r.findBatTool()
    local char = m.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("bat") then return t, true end
        end
    end
    local bp = m:FindFirstChildOfClass("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("bat") then return t, false end
        end
    end
    return nil, false
end
local swingRemoteEager = nil
function r.findSwingRemote()
    if swingRemoteEager ~= nil then return swingRemoteEager end
    for _, dr in ipairs({ "RequestSwing", "SwingTool", "MeleeSwing", "KnockCarrierEgg", "AskSwingEggTool", "SwingEggToolCarrier" }) do
        local ds = r.findRemoteContains(dr)
        if ds then swingRemoteEager = ds; return ds end
    end
    swingRemoteEager = false
    return nil
end
function r.swingBat()
    local dq = r.findBatTool()
    if not dq then return false end
    local dr = r.getHumanoid()
    if dr then pcall(function() dr:EquipTool(dq) end) end
    pcall(function() dq:Activate() end)
    if aj.RequestEquipTool then pcall(aj.RequestEquipTool, dq.Name) end
    local ds = dq:FindFirstChildOfClass("RemoteEvent")
    if ds then pcall(function() ds:FireServer() end) end
    local dt = r.findSwingRemote()
    if dt then pcall(function() dt:FireServer(m.Name) end) end
    return true
end
function r.runChaseAndHit(dq, targetRoot)
    if not dq or not targetRoot then return false end
    local dr = os.clock()
    while s and r.isOn("AutoChaseAndHit") and r.eggInteractActive() and os.clock() - dr < 120 do
        local ds = r.findAreaEggRecord(dq.Uid)
        if not ds or ds.State ~= "Carried" then break end
        if not targetRoot.Parent then
            targetRoot = r.findCarrierRoot(ds)
            if not targetRoot then break end
        end
        local dt = r.getRoot()
        local du = dt and targetRoot and (dt.Position - targetRoot.Position).Magnitude or 999
        if du > 50 then
            local bn = r.getArenaBounds()
            local dv = du > 250 and nil or (bn and Vector3.new(
                math.clamp(targetRoot.Position.X, bn.minX + 25, bn.maxX - 25),
                targetRoot.Position.Y,
                math.clamp(targetRoot.Position.Z, bn.minZ + 25, bn.maxZ - 25)) or targetRoot.Position)
            if dv and not r.bypassMoveTo(dv, function() return r.isOn("AutoChaseAndHit") and r.eggInteractActive() end, r.bypassSpeed(), 4) then
                break
            end
        else
            r.swingBat()
            task.wait(0.08)
        end
        task.wait(0.05)
    end
    return true
end
function r.stealingEnabled() return r.isOn("AutoStealSelected") or r.isOn("AutoStealAll") or r.isOn("StealBigEggs") or r.isOn("AutoStealWarp") end
function r.eggInteractActive() return r.stealingEnabled() or r.isOn("AutoChaseAndHit") end
function r.eggInventoryCount()
    local dq = r.getSave()
    local dr = dq and dq.EggInventory
    if typeof(dr) ~= "table" then return 0 end
    return r.countTable(dr)
end
function r.eggInventoryFull()
    local dq = w and tonumber(w.MAX_INVENTORY) or math.huge
    return r.eggInventoryCount() >= dq
end
function r.canAutoSteal() return r.eggInteractActive() and not bu and not r.eggInventoryFull() end
function r.tryCarryEgg(dq)
    if not dq or not aj.RequestCarryAreaEgg then return false end
    local dr = dq.Name
    local ds = nil
    if al.IsFirstAreaUid and al.IsFirstAreaUid(dr) then
        for _, dt in ipairs(r.getAreaEggs()) do
            if dt.Uid == dr and al.BuildSlotKey then
                ds = al.BuildSlotKey(dt.AreaId, dt.NestId)
                break
            end
        end
    end
    local dt, du = pcall(function() return aj.RequestCarryAreaEgg(dr, ds) end)
    if dt and du == true then return true end
    return bu
end

function r.carriedEggKey()
    local du = nil
    if typeof(returnEggUid) == "string" and returnEggUid ~= "" then
        du = returnEggUid
    else
        for _, ds in ipairs(r.getAreaEggs()) do
            if ds.State == "Carried" then du = ds.Uid; break end
        end
    end
    if not du then return nil, nil end
    local dv = nil
    if al.IsFirstAreaUid and al.BuildSlotKey and al.IsFirstAreaUid(du) then
        for _, ds in ipairs(r.getAreaEggs()) do
            if ds.Uid == du then
                dv = al.BuildSlotKey(ds.AreaId, ds.NestId)
                break
            end
        end
    end
    return du, dv
end

function r.refreshCarryEgg()
    if not bu or typeof(aj.RequestCarryAreaEgg) ~= "function" then return false end
    local du, dv = r.carriedEggKey()
    if not du then return false end
    return pcall(function() return aj.RequestCarryAreaEgg(du, dv) end)
end

function r.finalizeCarryReturn()
    if not bu or typeof(aj.RequestCarryAreaEgg) ~= "function" then return false end
    local du = r.carriedEggKey()
    if not du then return false end
    local dq = { Name = du }

    local ds = r.getRoot()
    if not ds then return false end

    -- 2) Nhặt lần 1 (xác nhận giữ trứng tại vị trí hiện tại)
    r.waitFor(bq.GrabDelay, 0.04, function()
        ds = r.getRoot()
        if ds then
            local dt = r.groundedY(ds.X, ds.Z, ds.Y)
            r.placeRoot(ds, CFrame.new(ds.X, dt, ds.Z))
        end
        if not r.isOn("AutoReturn") then return true end
        if not bu then r.tryCarryEgg(dq) end
        return bu == true
    end)

    local dt = os.clock() + 2.5
    while s and r.isOn("AutoReturn") and not bu and os.clock() < dt do
        ds = r.getRoot()
        if ds then
            local dx = r.groundedY(ds.X, ds.Z, ds.Y)
            r.placeRoot(ds, CFrame.new(ds.X, dx, ds.Z))
        end
        r.tryCarryEgg(dq)
        if bu then break end
        task.wait(0.05)
    end

    if not bu then return false end

    -- 3) Đứng chặt 3s (Anchored + zero velocity)
    do
        local dy = r.getRoot()
        if dy then
            pcall(function() dy.Anchored = true end)
            dy.AssemblyLinearVelocity  = Vector3.zero
            dy.AssemblyAngularVelocity = Vector3.zero
            c.Heartbeat:Wait()
        end
    end
    r.holdAtPosition(bp, function() return r.isOn("AutoReturn") and bu end, true)

    -- 4) Nhặt lần 2
    if not s or not r.isOn("AutoReturn") then return false end
    if not bu then r.tryCarryEgg(dq); task.wait(0.1) end
    local dz = os.clock() + 1.5
    while s and r.isOn("AutoReturn") and not bu and os.clock() < dz do
        r.tryCarryEgg(dq); task.wait(0.05)
    end

    -- 5) Về base bằng bypass
    r.returnToBaseBypass(function() return r.isOn("AutoReturn") and bu end)

    -- 6) Confirm
    local dw = os.clock() + 3
    while s and r.isOn("AutoReturn") and bu and os.clock() < dw do
        task.wait(0.1)
    end
    return true
end

-- ============================================================
-- STEAL EGG FLOW
-- 1) Tới target
-- 2) Nhặt lần 1
-- 3) Đứng chặt 3s (Anchored)
-- 4) Hết 3s -> nhả anchor -> nhặt lần 2
-- 5) Về base bằng bypass
-- 6) Confirm -> loop
-- ============================================================
function r.findEggPart(dq)
    if typeof(dq) ~= "string" or not dg then return nil end
    return dg:FindFirstChild(dq)
end
function r.stealEggPickup(dq)
    r.swapStealHumanoid()
    if not r.prepareStealHumanoid() then return false end

    local dr = r.getSlotEggPosition(dq)
    local ds = r.getRoot()
    if not ds or not dr then return false end

    -- 1) Đi tới target
    if not r.stealAlong(r.buildStealPath(ds.Position, dr), r.eggInteractActive) then
        return false
    end

    ds = r.getRoot()
    if ds then
        local dt = r.groundedY(dr.X, dr.Z, dr.Y)
        r.placeRoot(ds, CFrame.new(dr.X, dt, dr.Z))
    end

    if not r.eggInteractActive() then return false end

    -- 2) Nhặt lần 1
    r.waitFor(bq.GrabDelay, 0.04, function()
        ds = r.getRoot()
        if ds then
            local dt2 = r.groundedY(dr.X, dr.Z, dr.Y)
            r.placeRoot(ds, CFrame.new(dr.X, dt2, dr.Z))
        end
        if not r.eggInteractActive() then return true end
        if not bu then r.tryCarryEgg(dq) end
        return bu == true
    end)

    local dt = os.clock() + 2.5
    while s and r.eggInteractActive() and not bu and os.clock() < dt do
        ds = r.getRoot()
        if ds then
            local du = r.groundedY(dr.X, dr.Z, dr.Y)
            r.placeRoot(ds, CFrame.new(dr.X, du, dr.Z))
        end
        r.tryCarryEgg(dq)
        if bu then break end
        task.wait(0.05)
    end

    if not bu then return false end

    -- 3) Đứng chặt 3s (Anchored + zero velocity)
    do
        local du = r.getRoot()
        if du then
            pcall(function() du.Anchored = true end)
            du.AssemblyLinearVelocity  = Vector3.zero
            du.AssemblyAngularVelocity = Vector3.zero
            c.Heartbeat:Wait()
        end
    end
    r.holdAtPosition(bp, r.eggInteractActive, true)

    -- 4) Hết 3s -> không còn đứng chặt (Anchored đã nhả trong holdAtPosition)
    if not s or not r.eggInteractActive() then return false end

    -- Nhặt lần 2
    if not bu then r.tryCarryEgg(dq); task.wait(0.1) end
    local du = os.clock() + 1.5
    while s and r.eggInteractActive() and not bu and os.clock() < du do
        r.tryCarryEgg(dq); task.wait(0.05)
    end
    return bu
end

function r.stealEgg(dq)
    if not dq then return false end
    local dqUid = dq.Name
    if not r.stealEggPickup(dq) then return false end

    -- 5) Về base bằng bypass. Nếu trứng bị rớt giữa đường (bị đánh / bẫy)
    --    thì dừng bay, quay lại nhặt CHÍNH trứng đó ở vị trí mới.
    local q0 = os.clock()
    while s and r.eggInteractActive() and os.clock() - q0 < 180 do
        if bu then
            if r.returnToBaseBypass(function() return r.eggInteractActive() and bu end) then
                -- 6) Confirm vòng hoàn tất
                local q1 = os.clock() + 3
                while s and r.eggInteractActive() and bu and os.clock() < q1 do
                    task.wait(0.1)
                end
                return true
            end
        end
        if not bu and r.eggInteractActive() then
            -- trứng bị rớt -> tìm lại và re-steal
            local dq2 = r.findEggPart(dqUid)
            if not dq2 then dq2 = r.pickStealTarget() end
            if not dq2 then break end
            if not r.stealEggPickup(dq2) then break end
            dqUid = dq2.Name
        end
        task.wait(0.2)
    end
    return true
end

-- ============================================================
-- WARP MODE (Snipe via Guard-Strike Bounce + PivotTo)
-- Mirrors DiceHub snipeLoop: find a lake egg to trigger the
-- guard bounce, then teleport to the target egg's position.
-- ============================================================
local warpBusy = false

function r.findWarpLakeEgg()
    local root = r.getRoot()
    if not root then return nil end
    local cands = {}
    for _, rec in ipairs(r.getAreaEggs()) do
        local playable = rec.State == "Slot" or rec.State == "Dropped"
        local areaLow = string.lower(tostring(rec.AreaId or ""))
        local uidLow = string.lower(tostring(rec.Uid or ""))
        local isLake = rec.AreaId == "Lake"
            or areaLow:find("lake", 1, true) ~= nil
            or uidLow:find("lake", 1, true) ~= nil
        local cf = rec.BoundsCFrame or rec.BottomCFrame
        if playable and isLake and cf then
            local pos = cf.Position
            table.insert(cands, {
                Uid = rec.Uid, CFrame = cf, Position = pos,
                Distance = (root.Position - pos).Magnitude,
            })
        end
    end
    if #cands == 0 then
        for _, rec in ipairs(r.getAreaEggs()) do
            local playable = rec.State == "Slot" or rec.State == "Dropped"
            local cf = rec.BoundsCFrame or rec.BottomCFrame
            local pos = cf and cf.Position
            if playable and pos and pos.X >= 545 and pos.X < 850 then
                table.insert(cands, {
                    Uid = rec.Uid, CFrame = cf, Position = pos,
                    Distance = (root.Position - pos).Magnitude,
                    Area = rec.AreaId or "Field",
                })
            end
        end
    end
    if #cands == 0 then return nil end
    table.sort(cands, function(a, b) return a.Distance < b.Distance end)
    local best = cands[1]
    if best and dg then best.Model = dg:FindFirstChild(best.Uid) end
    return best
end

function r.warpSpawnFloor(pos, ttl)
    if not pos then return nil end
    local floor = Instance.new("Part")
    floor.Name = "ApexWarpFloor"
    floor.Size = Vector3.new(28, 1.5, 28)
    floor.Position = pos - Vector3.new(0, 3.2, 0)
    floor.Anchored = true
    floor.Transparency = 1
    floor.CanCollide = true
    floor.Parent = h
    task.delay(ttl or 12, function()
        if floor and floor.Parent then pcall(function() floor:Destroy() end) end
    end)
    return floor
end

function r.triggerGuardStrike(uid)
    if not warpStrikeRemote or not uid then return false end
    local root = r.getRoot()
    local guardCf = root and root.CFrame * CFrame.new(0, 0, -3) or CFrame.new()
    if warpStrikeRemote:IsA("RemoteFunction") then
        pcall(function() warpStrikeRemote:InvokeServer({ EggUid = uid, GuardCFrame = guardCf }) end)
    else
        pcall(function() warpStrikeRemote:FireServer({ EggUid = uid, GuardCFrame = guardCf }) end)
    end
    return true
end

function r.warpCarryingEgg(uid)
    if not bu then return false end
    if typeof(returnEggUid) == "string" and returnEggUid ~= "" then return returnEggUid == uid end
    local rec = r.findAreaEggRecord(uid)
    return rec ~= nil and rec.State == "Carried"
end

-- DiceHub checkEggState: true if target still stealable / carried by self
function r.warpTargetAvailable(uid)
    if typeof(returnEggUid) == "string" and returnEggUid ~= "" and returnEggUid == uid then return true end
    local rec = r.findAreaEggRecord(uid)
    if not rec then return true end
    return rec.State == "Slot" or rec.State == "Dropped"
end

local function warpZeroVelocities(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function r.warpStealEgg(dq)
    if warpBusy then return false end
    warpBusy = true
    local function notify(msg)
        task.spawn(function()
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Warp Mode",
                    Text = tostring(msg),
                    Duration = 3
                })
            end)
        end)
    end
    local okCb, res = pcall(function()
        if not dq then return false end
        local snipeUid = dq.Name
        local snipeRec = r.findAreaEggRecord(snipeUid)
        local snipeCFrame = snipeRec and (snipeRec.BoundsCFrame or snipeRec.BottomCFrame)
        if not snipeCFrame then
            local model = r.findEggPart(snipeUid)
            snipeCFrame = model and model:GetPivot() or CFrame.new(r.getSlotEggPosition(dq))
        end
        local snipePos = snipeCFrame.Position
        local hum = r.getHumanoid()
        local root = r.getRoot()
        if not root or not hum then return false end

        hum:UnequipTools()
        hum = r.prepareStealHumanoid()
        if not hum then return false end
        r.disableRagdoll(m.Character)
        root = r.getRoot()
        if not root then return false end

        -- DiceHub [1/7]: pre-flight — abort if target egg was already taken
        r.swapStealHumanoid()
        notify("[1/7] Pre-Flight Desync...")
        if not r.warpTargetAvailable(snipeUid) then
            notify("[1/7] Target taken! Aborting.")
            return false
        end

        -- 1) Need a held egg to trigger the guard strike: use current carry
        --    or fetch the nearest lake egg (DiceHub uses it as the striker).
        local heldOk = nil
        if bu then
            heldOk = returnEggUid
        else
            local lake = r.findWarpLakeEgg()
            if not lake then
                notify("[2/7] Lake egg not found!")
                return false
            end
            local lakePos = lake.Position
            pcall(function() m:RequestStreamAroundAsync(lakePos) end)
            r.warpSpawnFloor(lakePos, 8)
            root = r.getRoot()
            if (root.Position - lakePos).Magnitude > 60 then
                notify("[2/7] Gliding to Lake Egg...")
                if not r.bypassMoveTo(lakePos, function() return r.isOn("AutoStealWarp") end, r.stealSpeed(), 3) then
                    notify("[2/7] Lake glide failed!")
                    return false
                end
            else
                notify("[2/7] Aligning with Lake Egg...")
                root = r.getRoot()
                r.placeRoot(root, lake.CFrame * CFrame.new(0, 0.4, 0))
            end
            root = r.getRoot()
            root.Anchored = true
            task.wait(0.06)
            root.Anchored = false
            local grabDeadline = os.clock() + 3
            while s and r.isOn("AutoStealWarp") and os.clock() < grabDeadline and not r.warpCarryingEgg(lake.Uid) do
                root = r.getRoot()
                if root then
                    local gy = r.groundedY(lakePos.X, lakePos.Z, lakePos.Y)
                    r.placeRoot(root, CFrame.new(lakePos.X, gy, lakePos.Z))
                end
                r.tryCarryEgg({ Name = lake.Uid })
                task.wait(0.05)
            end
            if not r.warpCarryingEgg(lake.Uid) then
                notify("[2/7] Lake pickup failed!")
                r.stealCleanup()
                return false
            end
            heldOk = lake.Uid
        end

        -- 2) Pre-stream the snipe position + safety floor
        notify("[3/7] Pre-streaming Target...")
        pcall(function() m:RequestStreamAroundAsync(snipePos) end)
        r.warpSpawnFloor(snipePos, 12)

        -- 3) Wait for the physical bounce (guard strike knockback)
        notify("[4/7] Waiting for physical bounce...")
        root = r.getRoot()
        root.Anchored = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
        local savedWalk = (hum.WalkSpeed > 0) and hum.WalkSpeed or 16
        hum.WalkSpeed = 0
        hum:Move(Vector3.zero, false)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        task.wait(0.04)
        local bounceOrigin = root.Position
        local bounceOriginY = bounceOrigin.Y
        local tollFired = false
        local tollConn = nil
        if warpTollRemote and warpTollRemote:IsA("RemoteEvent") then
            tollConn = warpTollRemote.OnClientEvent:Connect(function()
                tollFired = true
                if tollConn then tollConn:Disconnect() end
            end)
        end
        r.triggerGuardStrike(heldOk)
        local strikeClock = os.clock()
        local strikeDeadline = os.clock() + 2.5
        local strikeSent = false
        local bounceDetected = false
        while s and r.isOn("AutoStealWarp") and os.clock() < strikeDeadline do
            local bounceDt = os.clock() - strikeClock
            local velNow = root.AssemblyLinearVelocity
            local posNow = root.Position
            local dyNow = posNow.Y - bounceOriginY
            local distMoved = (posNow - bounceOrigin).Magnitude
            if bounceDt >= 0.08 then
                local cond = tollFired
                    or velNow.Y >= 10
                    or (dyNow >= 1.5 and velNow.Magnitude >= 16)
                    or distMoved >= 2
                    or velNow.Magnitude >= 20
                if cond then bounceDetected = true break end
            end
            if bounceDt >= 0.5 and not strikeSent then
                strikeSent = true
                r.triggerGuardStrike(heldOk)
            end
            c.Heartbeat:Wait()
        end
        if tollConn then pcall(function() tollConn:Disconnect() end) end
        hum.WalkSpeed = savedWalk
        if not bounceDetected then
            notify("[4/7] No bounce detected, aborting!")
            if bu then pcall(r.runAutoDropEgg) end
            r.stealCleanup()
            return false
        end

        -- DiceHub [4/7]: re-check target wasn't snatched while bouncing
        task.wait(0.05)
        if not r.warpTargetAvailable(snipeUid) then
            notify("[4/7] Target taken! Aborting warp.")
            if bu then pcall(r.runAutoDropEgg) end
            r.stealCleanup()
            return false
        end

        -- 4) Warp to the snipe position
        notify("[5/7] Warping to Target Egg...")
        task.wait(0.05)
        r.warpSpawnFloor(snipePos, 8)
        m.Character:PivotTo(snipeCFrame * CFrame.new(0, 0.4, 0))
        root = r.getRoot()
        root.Anchored = true
        warpZeroVelocities(m.Character)

        -- 5) At target: keep the desync lock (DiceHub holds Anchored + zero
        --    velocity after PivotTo), drop the carried lake egg WHILE locked,
        --    hold it briefly, then release into a stealEggPickup-style grab.
        notify("[6/7] Picking up Target Egg...")
        if bu then pcall(r.runAutoDropEgg) end
        task.wait(0.06)
        root = r.getRoot()
        if root then
            root.Anchored = true
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        task.wait(0.06)
        root = r.getRoot()
        if root then pcall(function() root.Anchored = false end) end
        hum:ChangeState(Enum.HumanoidStateType.Running)

        if not r.waitFor(2, 0.05, function() return not bu end) then
            pcall(r.runAutoDropEgg)
            task.wait(0.3)
        end

        -- stealEggPickup handles everything: grab 1 -> stand tight (3s
        -- anchored, no ragdoll) -> grab 2, exactly like normal stealEgg.
        local pickupOk = r.stealEggPickup(dq)
        if not pickupOk then notify("[6/7] Pickup failed, will retry.") end

        
        -- 6) Return home immediately (no extra wait, like stealEgg)
        notify("[7/7] Target secured! Returning home...")
        local q0 = os.clock()
        while s and r.isOn("AutoStealWarp") and os.clock() - q0 < 180 do
            if bu and r.returnToBaseBypass(function() return r.isOn("AutoStealWarp") and bu end) then
                notify("[7/7] Delivered!")
                return true
            end
            if not bu and r.isOn("AutoStealWarp") then
                local dq2 = r.findEggPart(snipeUid)
                if not dq2 then dq2 = r.pickStealTarget() end
                if not dq2 then break end
                if not r.stealEggPickup(dq2) then break end
                snipeUid = dq2.Name
            end
            task.wait(0.2)
        end
        return true
    end)
    warpBusy = false
    return okCb and res == true
end

function r.runAutoSteal()
    if bu or r.eggInventoryFull() then return false end
    
    task.wait(0.1)
    local dq = r.pickStealTarget()
    if dq then
        r.statueSpawn()
        pcall(function()
            local dq = game:GetService("ReplicatedStorage").Packages.Networking["RF/Treadmill/AskDoff"]
            if dq then dq:InvokeServer() end
        end)
        local ds, dd
        if r.isOn("AutoStealWarp") then
            ds, dd = pcall(r.warpStealEgg, dq)
        else
            ds, dd = pcall(r.stealEgg, dq)
        end
        r.statueDespawn()
        if ds then return dd == true end
        return false
    end
    if r.isOn("AutoChaseAndHit") then
        local dr = r.pickChaseHitTarget()
        if dr then
            if dr.root then r.runChaseAndHit(dr.rec, dr.root) end
            local ds = r.findEggPart(dr.rec.Uid) or r.pickStealTarget()
            if ds then
                r.statueSpawn()
                local de, df = pcall(r.stealEgg, ds)
                r.statueDespawn()
                if de then return df == true end
                return false
            end
        end
    end
    return false
end
function r.runAutoDropEgg()
    if not bu then return false end
    if aj.RequestDropHeldAreaEgg then return pcall(function() aj.RequestDropHeldAreaEgg("PlayerRequest") end) end
    return false
end
function r.runAutoReturn()
    if not bu then return false end
    local rr = r.getRoot(); if rr then pcall(function() rr.Anchored = false end) end
    local dq = function() return r.isOn("AutoReturn") and bu end
    if not r.returnToBaseBypass(dq) then return false end
    local dr = r.getRoot()
    if dr and ak.IsWorldPositionWithinLocalPlotBounds and ak.IsWorldPositionWithinLocalPlotBounds(dr.Position) then
        r.waitFor(4, 0.15, function() return (not bu) or (not r.isOn("AutoReturn")) end)
    end
    return true
end

if aj.AreaEggCarryStateChanged and typeof(aj.AreaEggCarryStateChanged.Connect) == "function" then
    r.track(aj.AreaEggCarryStateChanged:Connect(function(dq)
        local dr = typeof(dq) == "table" and dq.IsCarrying == true
        local ds = dr and not bu
        if ds then
            bv = bv + 1
            if bw then bw(dq) end
        end
        if dr then
            if typeof(dq) == "table" and typeof(dq.Uid) == "string" then
                returnEggUid = dq.Uid
            end
        else
            returnEggUid = nil
        end
        bu = dr
    end))
end

-- ============================================================
-- PLACE / HATCH / SELL / FUSE / UPGRADE
-- ============================================================
function r.getUnplacedEggUids()
    local dq = r.getSave()
    local dr = dq and dq.EggInventory
    local ds = {}
    if typeof(dr) ~= "table" then return ds end
    local dt = r.isOn("AutoPlaceAll") and not r.isOn("AutoPlaceSelected")
    for du, dv in pairs(dr) do
        if typeof(du) == "string" and typeof(dv) == "table" and dv.Placement == nil
            and (dt or r.matchesEggFilters(dv, nil, "LifecycleRarities", "LifecycleMutations")) then
            table.insert(ds, du)
        end
    end
    return ds
end
function r.placingEnabled() return r.isOn("AutoPlaceSelected") or r.isOn("AutoPlaceAll") end
function r.isPlotFull() return os.clock() < ch end
function r.markPlotFull() ch = os.clock() + 30 end
function r.getPlacementLocalCFrames()
    if not ak.GetPlotData then return {} end
    local dq = ak.GetPlotData()
    if not dq or not dq.PetArea or not dq.CenterPoint then return {} end
    local dr, ds = dq.PetArea, dq.CenterPoint
    local dt = dr.Size
    local du = {}
    for dv = -dt.X * 0.5 + 5, dt.X * 0.5 - 5, 7 do
        for dw = -dt.Z * 0.5 + 5, dt.Z * 0.5 - 5, 7 do
            local dx = dr.CFrame:PointToWorldSpace(Vector3.new(dv, 1, dw))
            table.insert(du, ds.CFrame:ToObjectSpace(CFrame.new(dx)))
        end
    end
    return du
end
function r.canAutoPlace()
    return r.placingEnabled() and not bu and not r.isPlotFull() and #r.getUnplacedEggUids() > 0
end
function r.runAutoPlaceEggs(dq)
    if bu or not aj.RequestPlaceEgg then return end
    local function dr() return (dq == true or r.placingEnabled()) and not bu end
    local ds = r.getUnplacedEggUids()
    if #ds == 0 or not r.ensureAtPlot(dr) then return end
    local dt = r.getPlacementLocalCFrames()
    if #dt == 0 then return end
    local du = false
    for _, dv in ipairs(ds) do
        if not s or not dr() then return du end
        if not r.isNearPlot() and not r.ensureAtPlot(dr) then return du end
        if aj.RequestEquipTool then pcall(aj.RequestEquipTool, dv) end
        task.wait(0.15)
        local dw = false
        for dx = 0, #dt - 1 do
            local dy = (cg + dx - 1) % #dt + 1
            local dz = false
            pcall(function() dz = aj.RequestPlaceEgg(dv, dt[dy]) == true end)
            if dz then
                cg = dy + 1
                dw = true; du = true
                task.wait(0.25); break
            end
        end
        if not dw then r.markPlotFull(); return du end
        ch = 0
    end
    return du
end
function r.canAutoHatch() return r.isOn("AutoOpenReadyEggs") and not bu end
function r.runAutoOpenReadyEggs()
    local dq = r.getSave()
    local dr = dq and dq.EggInventory
    if typeof(dr) ~= "table" then return end
    local ds = false
    for dt, du in pairs(dr) do
        if not s or not r.isOn("AutoOpenReadyEggs") then return ds end
        if typeof(dt) == "string" and typeof(du) == "table" and du.Placement ~= nil
            and r.matchesEggFilters(du, nil, "LifecycleRarities", "LifecycleMutations") then
            local dv = false
            if aj.IsLocalEggReady then pcall(function() dv = aj.IsLocalEggReady(dt) == true end) end
            if dv and aj.RequestHatchEgg then
                local dw = false
                pcall(function() dw = aj.RequestHatchEgg(dt) == true end)
                if dw then
                    ds = true
                    if aj.RequestCompleteHatchEgg then pcall(aj.RequestCompleteHatchEgg, dt) end
                    task.wait(0.35)
                end
            end
        end
    end
    return ds
end
function r.getPetItemData(dq)
    if not an.Deserialize then return nil end
    local dr, ds = pcall(an.Deserialize, dq)
    if not dr or typeof(ds) ~= "table" then return nil end
    return ds
end
function r.findToolByUid(dq)
    local dr = { m.Character, m:FindFirstChildOfClass("Backpack") }
    for _, ds in ipairs(dr) do
        if ds then
            for _, dt in ipairs(ds:GetChildren()) do
                if dt:IsA("Tool") and dt:GetAttribute("UID") == dq then return dt end
            end
        end
    end
    return nil
end
function r.holdUid(dq)
    local dr = m.Character
    local ds = r.getHumanoid()
    if not dr or not ds then return false end
    local dt = r.findToolByUid(dq)
    if not dt then return false end
    if dt.Parent == dr then return true end
    pcall(function() ds:EquipTool(dt) end)
    return r.waitFor(1, 0.05, function() return dt.Parent == m.Character end)
end
function r.sellUid(dq)
    if not r.holdUid(dq) then return false end
    r.netCall(ap.AssetInventory.SELL_ASSET, dq)
    return r.waitFor(2, 0.1, function()
        local dr = r.getSave(); if not dr then return false end
        local ds = dr.Inventory or {}
        local dt = dr.EggInventory or {}
        return ds[dq] == nil and dt[dq] == nil
    end)
end
function r.getSellablePets()
    local dq = r.getSave()
    local dr = dq and dq.Inventory
    local ds = {}
    if typeof(dr) ~= "table" then return ds end
    local dt = dq.EquippedAssets or {}
    local du = tonumber(r.optionValue("SellMaxScale", 10)) or 10
    local dv = r.isOn("SellKeepMutated")
    local dw = r.isOn("SellKeepEquipped")
    local dx = r.multiSelected("SellMutations")
    local dy = r.multiHasAny("SellMutations")
    local dz = r.multiSelected("SellRarities")
    local ea = r.multiHasAny("SellRarities")
    for eb, ec in pairs(dr) do
        if typeof(eb) == "string" and typeof(ec) == "table" then
            local ed = r.getPetItemData(ec)
            local ee = table.find(dt, eb) ~= nil
            local ef = not ed or ed.IsFavorite == true or ed.InFuse == true or (dw and ee)
            if not ef then
                local eg = r.recordMutations(ec)
                local eh = not (dv and #eg > 0)
                if eh and dy then
                    eh = false
                    for _, ei in ipairs(eg) do
                        if dx[ei] then eh = true; break end
                    end
                end
                local ei = tonumber(ec.Scale) or 0
                local ej = r.resolveRarity(ec.Category)
                local ek = not ea or (typeof(ej) == "string" and dz[ej] == true)
                if eh and ei <= du and ek then table.insert(ds, eb) end
            end
        end
    end
    return ds
end
function r.sellSelectionBatch(assets, eggs)
    assets = typeof(assets) == "table" and assets or {}
    eggs = typeof(eggs) == "table" and eggs or {}
    local total = #assets + #eggs
    if total == 0 then return true end
    local ev = ap.AssetInventory.SELL_SELECTION
    if ev then
        local ok = pcall(function()
            if ev:IsA("RemoteFunction") then
                ev:InvokeServer({ Assets = assets, Eggs = eggs })
            else
                ev:FireServer({ Assets = assets, Eggs = eggs })
            end
        end)
        if ok then
            return r.waitFor(3, 0.1, function()
                local dr = r.getSave(); if not dr then return false end
                local inv = dr.Inventory or {}
                local einv = dr.EggInventory or {}
                local removed = 0
                for _, uid in ipairs(assets) do if inv[uid] == nil then removed = removed + 1 end end
                for _, uid in ipairs(eggs) do if einv[uid] == nil then removed = removed + 1 end end
                return removed >= math.max(1, math.floor(total * 0.8))
            end)
        end
    end
    for _, uid in ipairs(assets) do pcall(r.sellUid, uid); task.wait(0.15) end
    for _, uid in ipairs(eggs) do pcall(r.sellUid, uid); task.wait(0.15) end
    return true
end
function r.runAutoSellPets()
    local uids = r.getSellablePets()
    if #uids == 0 then return end
    r.sellSelectionBatch(uids, {})
    task.wait(0.1)
end
function r.getSellableEggUids()
    local dq = r.getSave()
    local dr = dq and dq.EggInventory
    local ds = {}
    if typeof(dr) ~= "table" then return ds end
    local dt = r.multiHasAny("SellEggRarities")
    local du = r.multiSelected("SellEggRarities")
    for dv, dw in pairs(dr) do
        if typeof(dv) == "string" and typeof(dw) == "table" and dw.Placement == nil then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "AutoSell",
                    Text = "ok",
                    Duration = 3
                })
            local dx = r.resolveRarity(dw.AssetCategory)
            if not dt or (typeof(dx) == "string" and du[dx] == true) then
                table.insert(ds, dv)
            end
        end
    end
    return ds
end
function r.runAutoSellEggs()
    local uids = r.getSellableEggUids()
    game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "AutoSell",
                    Text = "Auto Sell All" .. tostring(#uids) .. " eggs to sell.",
                    Duration = 3
                })

        
    -- r.notify(, "Success", 3)
    if #uids == 0 then return end
    r.sellSelectionBatch({}, uids)
    task.wait(0.1)
end
function r.fuseGroups(dq)
    local dr = dq and dq.Inventory
    local ds = {}
    if typeof(dr) ~= "table" then return ds end
    local dt = dq.EquippedAssets or {}
    local du = r.isOn("FuseKeepEquipped")
    local dv = r.isOn("FuseKeepMutated")
    local dw = tonumber(r.optionValue("FuseMaxScale", 10)) or 10
    local dx = r.multiHasAny("FuseMutations")
    local dy = r.multiSelected("FuseMutations")
    for dz, ea in pairs(dr) do
        if typeof(dz) == "string" and typeof(ea) == "table" then
            local eb = ea.Category
            local ec = false
            if typeof(eb) == "string" and ao.CanSelectPet then
                pcall(function() ec = ao.CanSelectPet(dz, ea, eb, false) == true end)
            end
            if ec and not (du and table.find(dt, dz) ~= nil) then
                local ed = r.recordMutations(ea)
                local ee = not (dv and #ed > 0)
                if ee and dx then
                    ee = false
                    for _, ef in ipairs(ed) do
                        if dy[ef] then ee = true; break end
                    end
                end
                local ef = r.resolveRarity(eb)
                local eg = tonumber(ea.Scale) or 0
                local eh = ef == nil or r.selectionAllows("FuseRarities", ef)
                if ee and eg <= dw and eh then
                    ds[eb] = ds[eb] or {}
                    table.insert(ds[eb], { uid = dz, scale = eg })
                end
            end
        end
    end
    return ds
end
function r.pickFuseGroup(dq)
    local dr = r.fuseGroups(dq)
    local ds = math.floor(tonumber(r.optionValue("FuseKeepPerCategory", 0)) or 0)
    local dt = r.optionValue("FuseTarget", "Highest Rarity")
    local du, dv = nil, -math.huge
    for dw, dx in pairs(dr) do
        table.sort(dx, function(dy, dz) return dy.scale < dz.scale end)
        if #dx - ds >= 3 then
            local dy = au[r.resolveRarity(dw) or "Common"] or 0
            local dz = dy
            if dt == "Most Duplicates" then dz = #dx
            elseif dt == "Lowest Rarity" then dz = -dy end
            if dz > dv then du = dw; dv = dz end
        end
    end
    if not du then return nil end
    local dw = dr[du]
    return { dw[1].uid, dw[2].uid, dw[3].uid }
end
function r.fusePrice(dq, dr)
    local ds = dq and dq.Inventory
    if typeof(ds) ~= "table" or not ao.CalculateFusePrice then return nil end
    local dt = {}
    for du, dv in ipairs(dr) do
        local dw = ds[dv]
        local dx = dw and r.getPetItemData(dw)
        if not dx then return nil end
        dt[du] = dx
    end
    local du, dv = pcall(ao.CalculateFusePrice, dt)
    return du and tonumber(dv) or nil
end
function r.getFuseMachinePosition()
    local dq = h:FindFirstChild("__OBJECTS")
    local dr = dq and dq:FindFirstChild("Machines")
    local ds = dr and dr:FindFirstChild("FuseMachine")
    if not ds then return nil end
    local dt, du = pcall(function() return ds:GetPivot() end)
    if not dt or not du then return nil end
    return du.Position + Vector3.new(0, 4, 0)
end
function r.runAutoFusePets(dq)
    local dr = r.getSave(); if not dr then return end
    local function ds() return dq == true or r.isOn("AutoFusePets") end
    if dr.FusionLocked == true then
        if r.isOn("FuseAutoReveal") or dq == true then r.netInvoke(ap.FuseMachine.COMPLETE_REVEAL) end
        return
    end
    local dt = r.pickFuseGroup(dr)
    if not dt then return end
    local du = r.fusePrice(dr, dt)
    if du and (tonumber(dr.Money) or 0) < du then return end
    local dv = r.getFuseMachinePosition()
    if dv and not r.bypassMoveTo(dv, ds, r.bypassSpeed()) then return end
    if dr.FusionInfoAcknowledged ~= true then r.netInvoke(ap.FuseMachine.ACKNOWLEDGE_INFO) end
    for _, dw in ipairs(dt) do
        if not s or not ds() then return end
        r.netInvoke(ap.FuseMachine.INSERT_MOB, dw)
        task.wait(0.2)
    end
    r.netInvoke(ap.FuseMachine.START_FUSE)
    return true
end
function r.runAutoEquipBest()
    local dq = h:GetServerTimeNow()
    if dq - cf < 5 then return end
    cf = dq
    r.netCall(ap.Backpack.EQUIP_BEST)
end
function r.runAutoEquipBestTrail()
    local dq = r.getSave()
    local dr = dq and dq.TrailInventory
    if typeof(dr) ~= "table" then return false end
    local ds, dt = nil, -1
    for _, du in ipairs(be) do
        local dv = bf[du]
        if dv and dr[dv] then
            local dw = bg[du] or 0
            if dw > dt then dt = dw; ds = dv end
        end
    end
    local du = r.netInvoke(ap.Trails.WORN_SNAPSHOT)
    local dv = typeof(du) == "table" and du[tostring(m.UserId)] or nil
    if not ds or dv == ds then return false end
    r.netInvoke(ap.Trails.REQUEST_SELECT, ds)
    return true
end
function r.gearBaseName(dq) return tostring(dq):gsub("%s*%[X%d+%]%s*$", "") end
function r.runAutoEquipBestGear()
    local dq = m.Character
    local dr = m:FindFirstChildOfClass("Backpack")
    local ds = r.getHumanoid()
    if not dq or not dr or not ds then return end
    local dt, du = nil, -1
    for _, dv in ipairs(dr:GetChildren()) do
        if dv:IsA("Tool") then
            local dw = bh[r.gearBaseName(dv.Name)]
            if dw and dw > du then du = dw; dt = dv end
        end
    end
    for _, dv in ipairs(dq:GetChildren()) do
        if dv:IsA("Tool") then
            local dw = bh[r.gearBaseName(dv.Name)]
            if dw and dw >= du then return end
        end
    end
    if dt then pcall(function() ds:EquipTool(dt) end) end
end
function r.runAutoBuyTrail()
    local dq = r.getSave()
    if not dq or not r.multiHasAny("TrailWanted") then return false end
    local dr = r.multiSelected("TrailWanted")
    local ds = dq.TrailInventory or {}
    local dt = false
    for _, du in ipairs(be) do
        if dr[du] then
            local dv = bf[du]
            if dv and not ds[dv] then
                local dw = bg[du] or 0
                if dq.Money >= dw then
                    r.netCall(ap.Trails.REQUEST_PURCHASE, dv)
                    dt = true; task.wait(0.35)
                    dq = r.getSave() or dq
                    ds = dq.TrailInventory or ds
                end
            end
        end
    end
    return dt
end
function r.runAutoUpgrades()
    local dq = r.multiSelected("UpgradeTypes")
    if not r.multiHasAny("UpgradeTypes") then dq = { Base = true, Treadmill = true } end
    local dr = r.getSave(); if not dr then return false end
    local ds = false
    if dq.Base and v and typeof(v.IsNextTierAffordable) == "function" then
        if v.IsNextTierAffordable(dr) then
            r.netCall(ap.Plots.REQUEST_BASE_UPGRADE)
            ds = true; task.wait(0.35)
        end
    end
    if dq.Treadmill and ab and typeof(ab.GetByUpgradeLevel) == "function" then
        local dt = tonumber(dr.TreadmillUpgradeLevel) or 0
        local du = ab.GetByUpgradeLevel(dt + 1)
        if du then
            local dv = tonumber(du.Price) or math.huge
            if dr.Money >= dv then
                r.netCall(ap.Treadmills.REQUEST_UPGRADE, du._id)
                ds = true; task.wait(0.35)
            end
        end
    end
    return ds
end
function r.runAutoClaimIndex() r.netCall(ap.Index.REQUEST_CLAIM_ALL) end
function r.runClaimOfflineEarnings()
    local dq = r.netInvoke(ap.OfflineAssets.GET_SUMMARY)
    if typeof(dq) ~= "table" then return false end
    if (tonumber(dq.ClaimableAmount) or 0) <= 0 then return false end
    r.netCall(ap.OfflineAssets.REQUEST_REDEEM)
    return true
end
function r.runAutoClaimGroupReward()
    local dq = r.getSave()
    if dq and dq.ClaimedGroupReward == true then return false end
    local dr = false
    pcall(function()
        dr = u and u.GROUP_ID and m:IsInGroupAsync(u.GROUP_ID) == true
    end)
    r.netInvoke(ap.GroupReward.CLAIM_REWARD, dr)
    return true
end
function r.deleteOwnPetRenders()
    local dq = h:FindFirstChild("ClientRenderedAssets")
    if not dq then return end
    for _, dr in ipairs(dq:GetChildren()) do
        if dr:GetAttribute("OwnerUserId") == m.UserId then pcall(function() dr:Destroy() end) end
    end
end
function r.getTreadmillStand()
    if not ak.GetPlotData then return nil end
    local dq = ak.GetPlotData()
    local dr = dq and dq.PlotFolder
    local ds = dr and dr:FindFirstChild("TreadmillBottom")
    if not ds or not ds:IsA("BasePart") then return nil end
    return ds.Position + Vector3.new(0, 4, 0)
end
function r.isDoubleSpeedVisible()
    local dq, dr = pcall(function()
        local ds = m:FindFirstChild("PlayerGui")
        local dt = ds and ds:FindFirstChild("Elements")
        local du = dt and dt:FindFirstChild("Left")
        local dv = du and du:FindFirstChild("Tools")
        local dw = dv and dv:FindFirstChild("DoubleYourSpeed")
        return dw ~= nil and dw.Visible == true
    end)
    return dq and dr == true
end
function r.dismountTreadmill()
    pcall(function()
        local dq = game:GetService("VirtualInputManager")
        dq:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        dq:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
    local dq = r.getHumanoid()
    if dq then dq.Jump = true; dq:ChangeState(Enum.HumanoidStateType.Jumping) end
end
function r.stopTreadmillTraining()
    bz = false
    pcall(function() r.netInvoke(ap.Treadmills.REQUEST_UNEQUIP) end)
    if r.isDoubleSpeedVisible() then
        r.dismountTreadmill(); task.wait(0.1)
        if r.isDoubleSpeedVisible() then r.dismountTreadmill() end
    end
    end
function r.canAutoTreadmill() return r.isOn("AutoTreadmill") and not bu end
function r.runAutoTreadmillTraining()
    local dq = r.getTreadmillStand()
    if not dq then return end
    local dr = r.getRoot(); if not dr then return end
    if (dr.Position - dq).Magnitude > 12 then
        if not r.bypassMoveTo(dq, nil, r.bypassSpeed()) then return end
    end
    r.netInvoke(ap.Treadmills.REQUEST_EQUIP_STATIC)
    bz = true
    return true
end

local dq = { "Base", "Pet Area", "Treadmill", "Fuse Machine", "Lobby Entry" }
for _, dr in ipairs(bc) do table.insert(dq, dr) end
function r.resolveWaypoint(dr)
    if typeof(dr) ~= "string" then return nil end
    if dr == "Base" then return r.getBasePosition()
    elseif dr == "Pet Area" then return r.getPetAreaStandPosition()
    elseif dr == "Treadmill" then return r.getTreadmillStand()
    elseif dr == "Fuse Machine" then return r.getFuseMachinePosition()
    elseif dr == "Lobby Entry" then return r.getEntryPosition() end
    return r.getZoneLaneCenter(dr)
end

-- ============================================================
-- ESP
-- ============================================================
function r.espDistanceLimit() return tonumber(r.optionValue("EspDistance", 2000)) or 2000 end
function r.withinEspRange(dr)
    local ds = r.getRoot()
    return ds ~= nil and (ds.Position - dr).Magnitude <= r.espDistanceLimit()
end
function r.espColorFor(dr)
    local ds = au[dr or ""] or 0
    if ds >= 9 then return Color3.fromRGB(255, 120, 255)
    elseif ds >= 7 then return Color3.fromRGB(255, 90, 90)
    elseif ds >= 5 then return Color3.fromRGB(255, 190, 80)
    elseif ds >= 3 then return Color3.fromRGB(110, 195, 255) end
    return Color3.fromRGB(190, 200, 215)
end
function r.ensureEspEntry(dr, ds)
    local dt = db[dr]
    if dt then return dt end
    local du = Instance.new("Part")
    du.Name = "EspAnchor"; du.Anchored = true; du.CanCollide = false
    du.CanQuery = false; du.CanTouch = false; du.Transparency = 1
    du.Size = Vector3.new(0.2, 0.2, 0.2); du.Parent = dh
    local dv = Instance.new("BillboardGui")
    dv.Name = "EspLabel"; dv.AlwaysOnTop = true
    dv.Size = UDim2.fromOffset(220, 34); dv.StudsOffset = Vector3.new(0, 2.5, 0)
    dv.Adornee = du; dv.Parent = du
    local dw = Instance.new("TextLabel")
    dw.Name = "Text"; dw.BackgroundTransparency = 1; dw.Size = UDim2.fromScale(1, 1)
    dw.Font = Enum.Font.GothamBold; dw.TextSize = 13; dw.TextStrokeTransparency = 0.4
    dw.TextColor3 = ds; dw.Parent = dv
    local dx = { anchor = du, billboard = dv, label = dw, highlight = nil }
    db[dr] = dx
    return dx
end
function r.drawEspAt(dr, ds, dt, du, dv)
    local dw = r.ensureEspEntry(dr, du)
    dw.anchor.CFrame = CFrame.new(ds)
    dw.label.Text = dt; dw.label.TextColor3 = du
    if dv and dv.Parent then
        if not dw.highlight then
            local dx = Instance.new("Highlight")
            dx.FillTransparency = 0.6; dx.OutlineTransparency = 0
            dx.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            dx.Parent = dh; dw.highlight = dx
        end
        dw.highlight.Adornee = dv
        dw.highlight.FillColor = du; dw.highlight.OutlineColor = du
    elseif dw.highlight then dw.highlight:Destroy(); dw.highlight = nil end
    dc[dr] = true
end
function r.releaseEsp(dr)
    local ds = db[dr]; if not ds then return end
    if ds.highlight then ds.highlight:Destroy() end
    if ds.billboard then ds.billboard:Destroy() end
    if ds.anchor then ds.anchor:Destroy() end
    db[dr] = nil
end
function r.clearAllEsp() for dr in pairs(db) do r.releaseEsp(dr) end end
function r.collectEggEsp()
    local dr = r.isOn("EspWorldEggs")
    local ds = r.isOn("EspCarriedEggs")
    if not dr and not ds then return end
    for _, dt in ipairs(r.getAreaEggs()) do
        local du = dt.BottomCFrame or dt.BoundsCFrame
        if du then
            local dv = dt.State
            local dw = (dv == "Slot" and dr) or ((dv == "Dropped" or dv == "Carried") and ds)
            if dw and r.withinEspRange(du.Position) then
                local dx = r.resolveRarity(dt.AssetCategory)
                local dy = string.format("%s [%s]", r.assetName(dt.AssetCategory), tostring(dx or "?"))
                if dv == "Dropped" or dv == "Carried" then dy = string.format("%s\n%s", dy, tostring(dv)) end
                r.drawEspAt("egg_" .. dt.Uid, du.Position, dy, r.espColorFor(dx), nil)
            end
        end
    end
end
function r.collectGuardEsp()
    if not r.isOn("EspGuards") or not df then return end
    for _, dr in ipairs(df:GetChildren()) do
        local ds = dr:FindFirstChild("Guard")
        local dt, du = pcall(function() return ds and ds:GetPivot() or nil end)
        if dt and du and r.withinEspRange(du.Position) then
            r.drawEspAt("guard_" .. dr.Name, du.Position,
                string.format("Guard %s\n%s", dr.Name, tostring(ds:GetAttribute("GuardState") or "Idle")),
                Color3.fromRGB(255, 140, 90), ds)
        end
    end
end
function r.collectPetEsp()
    if not r.isOn("EspPets") then return end
    local dr = h:FindFirstChild("ClientRenderedAssets")
    if not dr then return end
    local ds = r.getSave()
    local dt = ds and ds.Inventory or {}
    local du = {}
    pcall(function()
        if am.GetRuntimeSnapshot then
            local dv = am.GetRuntimeSnapshot() or {}
            for _, dw in pairs(dv) do
                if typeof(dw) == "table" and typeof(dw.Records) == "table" then
                    for dx, dy in pairs(dw.Records) do du[dx] = dy end
                end
            end
        end
    end)
    for _, dv in ipairs(dr:GetChildren()) do
        local dw = dv:GetAttribute("UID")
        local dx, dy = pcall(function() return dv:GetPivot() end)
        if typeof(dw) == "string" and dx and dy and r.withinEspRange(dy.Position) then
            local dz, ea = nil, nil
            local eb = dt[dw]
            if typeof(eb) == "table" then dz = eb.Category end
            local ec = du[dw]
            if typeof(ec) == "table" then
                if not dz and ec.ItemData then dz = ec.ItemData.Category end
                ea = tonumber(ec.MoneyPerSecond)
            end
            local ed = r.resolveRarity(dz)
            local ee = string.format("%s [%s]", r.assetName(dz), tostring(ed or "?"))
            if ea then ee = string.format("%s\n%s/s", ee, r.formatNumber(ea)) end
            r.drawEspAt("pet_" .. dv.Name, dy.Position, ee, r.espColorFor(ed), dv)
        end
    end
end
function r.collectPlayerEsp()
    if not r.isOn("EspPlayers") then return end
    local dr = r.getRoot()
    for _, ds in ipairs(b:GetPlayers()) do
        if ds ~= m then
            local dt = ds.Character
            local du = dt and dt:FindFirstChild("HumanoidRootPart")
            if du and r.withinEspRange(du.Position) then
                local dv = dr and (dr.Position - du.Position).Magnitude or 0
                r.drawEspAt("player_" .. ds.Name, du.Position,
                    string.format("%s\n%d studs", ds.DisplayName, math.floor(dv)),
                    Color3.fromRGB(120, 190, 255), dt)
            end
        end
    end
end
function r.collectMachineEsp()
    if not r.isOn("EspMachines") then return end
    local dr = h:FindFirstChild("__OBJECTS")
    local ds = dr and dr:FindFirstChild("Machines")
    if not ds then return end
    for _, dt in ipairs(ds:GetChildren()) do
        local du, dv = pcall(function() return dt:GetPivot() end)
        if du and dv and r.withinEspRange(dv.Position) then
            r.drawEspAt("machine_" .. dt.Name, dv.Position, dt.Name, Color3.fromRGB(230, 200, 120), dt)
        end
    end
end
function r.collectPlotEsp()
    if not r.isOn("EspPlots") then return end
    local dr = h:FindFirstChild("Plots")
    if not dr then return end
    for _, ds in ipairs(dr:GetChildren()) do
        local dt = ds:FindFirstChild("PlotSign") or ds:FindFirstChild("CenterPoint")
        if dt and dt:IsA("BasePart") and r.withinEspRange(dt.Position) then
            local du = nil
            pcall(function()
                if ak.GetSlotOwner then du = ak.GetSlotOwner(tonumber(ds.Name)) end
            end)
            local dv = "Empty"
            local dw = tonumber(du)
            if dw then
                local dx = b:GetPlayerByUserId(dw)
                if dx then
                    dv = dx.DisplayName
                    if dx == m then dv = dv .. " (You)" end
                else dv = "User " .. tostring(dw) end
            end
            r.drawEspAt("plot_" .. ds.Name, dt.Position,
                string.format("Plot %s\n%s", ds.Name, dv),
                Color3.fromRGB(200, 170, 255), nil)
        end
    end
end
function r.runEsp()
    r.clearTable(dc)
    r.collectEggEsp()
    r.collectGuardEsp()
    r.collectPetEsp()
    r.collectPlayerEsp()
    r.collectMachineEsp()
    r.collectPlotEsp()
    for dr in pairs(db) do
        if not dc[dr] then r.releaseEsp(dr) end
    end
end

-- ============================================================
-- SERVER HOP
-- ============================================================
function r.rememberVisited(dr)
    if typeof(dr) ~= "string" or dr == "" then return end
    if r.countTable(dd) >= 300 then r.clearTable(dd) end
    dd[dr] = true
end
r.rememberVisited(tostring(game.JobId))
r.track(e.TeleportInitFailed:Connect(function(dr, ds, dt)
    if dr == m then ce = tostring(dt or ds) end
end))
function r.fetchServerPage(dr)
    local ds = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100", game.PlaceId)
    if dr then ds = ds .. "&cursor=" .. dr end
    local dt, du = pcall(function() return game:HttpGet(ds) end)
    if not dt or typeof(du) ~= "string" then return nil end
    local dv, dw = pcall(function() return d:JSONDecode(du) end)
    if not dv or typeof(dw) ~= "table" or typeof(dw.data) ~= "table" then return nil end
    return dw
end
function r.pickHopTargets()
    local dr = nil
    local ds = {}
    for _ = 1, 4 do
        local dt = r.fetchServerPage(dr)
        if not dt then break end
        for _, du in ipairs(dt.data) do
            if typeof(du) == "table" and typeof(du.id) == "string"
                and du.id ~= game.JobId and not dd[du.id] then
                local dv = tonumber(du.playing) or 0
                local dw = tonumber(du.maxPlayers) or 0
                if dw > 0 and dv < dw then
                    table.insert(ds, { id = du.id, playing = dv })
                end
            end
        end
        dr = typeof(dt.nextPageCursor) == "string" and dt.nextPageCursor or nil
        if not dr or #ds >= 40 then break end
        task.wait(0.25)
    end
    table.sort(ds, function(dt, du) return dt.playing < du.playing end)
    return ds
end
function r.tryTeleportTo(dr)
    ce = nil
    task.wait(1)
    local ds = pcall(function() e:TeleportToPlaceInstance(game.PlaceId, dr, m) end)
    if not ds then return false end
    r.waitFor(20, 0.25, function() return ce ~= nil or (not s) end)
    if ce then return false end
    return true
end
function r.serverHop(dr)
    if ca or os.clock() < cb then return false end
    ca = true
    local ds = r.pickHopTargets()
    if typeof(ds) ~= "table" or #ds == 0 then
        cb = os.clock() + 30
        ca = false
        return false
    end
    for dt = 1, 3 do
        if dt > 1 then
            ds = r.pickHopTargets()
            if typeof(ds) ~= "table" or #ds == 0 then
                cb = os.clock() + 10
                ca = false
                return false
            end
        end
        for du = 1, math.min(#ds, 10) do
            if not s then ca = false; return false end
            local dv = ds[du]
            r.rememberVisited(dv.id)
            if r.tryTeleportTo(dv.id) then
                ca = false
                return true
            end
            task.wait(0.5)
        end
    end
    cb = os.clock() + 10
    ca = false
    return false
end
function r.runServerHop()
    if bu or ca then return end
    local dr = r.optionValue("HopMode", bb[1])
    local ds = tonumber(r.optionValue("HopValue", 15)) or 15
    local dt = os.clock()
    if dr == "Timed Interval" then
        if dt - cd >= ds * 60 then r.serverHop("Interval reached") end
        return
    end
    if dr == "After Steal Count" then
        if bv >= ds then r.serverHop(string.format("Stole %d eggs", bv)) end
        return
    end
    if r.pickStealTarget() ~= nil then cc = 0; return end
    if cc == 0 then cc = dt
    elseif dt - cc >= ds then
        cc = 0
        r.serverHop("No matching eggs in this server")
    end
end
function r.rejoinServer()
    local dr = pcall(function() e:TeleportToPlaceInstance(game.PlaceId, game.JobId, m) end)
    if not dr then pcall(function() e:Teleport(game.PlaceId, m) end) end
end

-- ============================================================
-- WEBHOOK
-- ============================================================
function r.webhookPing()
    local dr = tostring(r.optionValue("WebhookPingId", "") or ""):gsub("%D", "")
    if dr == "" then return nil end
    return string.format("<@%s>", dr)
end
function r.httpPost(dr)
    local ds = (syn and syn.request) or (http and http.request) or http_request or request
    if typeof(ds) ~= "function" then return false end
    local dt = tostring(r.optionValue("WebhookUrl", "") or "")
    if dt == "" then return false end
    local du
    local dv = pcall(function() du = d:JSONEncode(dr) end)
    if not dv then return false end
    return pcall(ds, {
        Url = dt, Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = du,
    })
end
function r.sendWebhookEmbed(dr, ds)
    if not r.isOn("WebhookEnabled") then return false end
    local dt = { username = "Apex Hub", embeds = { dr } }
    if ds then dt.content = r.webhookPing() end
    return r.httpPost(dt)
end
function r.embedField(dr, ds, dt) return { name = dr, value = ds, inline = dt ~= false } end

bw = function(dr)
    if typeof(dr) ~= "table" then return end
    local ds = typeof(dr.Uid) == "string" and r.findAreaEggRecord(dr.Uid) or nil
    local dt = ds and ds.AssetCategory or dr.AssetCategory
    local du = { string.format("**%s** `%s`", r.assetName(dt), tostring(r.resolveRarity(dt) or "?")) }
    local dv = ds and ds.AreaId or dr.AreaId
    if typeof(dv) == "string" then table.insert(du, dv) end
    if ds then
        local dw = tonumber(ds.AssetScale)
        if dw then table.insert(du, string.format("x%.2f", dw)) end
        local dx = r.recordMutations(ds)
        if #dx > 0 then table.insert(du, table.concat(dx, ", ")) end
    end
    if #da < 100 then table.insert(da, table.concat(du, " | ")) end
end
function r.trackWebhookEvents()
    local dr = r.getSave()
    if not dr then return end
    if not ct then
        ct = true
        for ds in pairs(dr.Inventory or {}) do cs[ds] = true end
        for _, ds in ipairs(r.getAreaEggs()) do cr[ds.Uid] = true end
        cu = tonumber(dr.Rebirth) or 0
        cv = bv
        return
    end
    cw = cw + math.max(0, bv - cv)
    cv = bv
    for ds in pairs(dr.Inventory or {}) do
        if cs[ds] == nil then
            cs[ds] = true
            cx = cx + 1
        end
    end
    local ds = tonumber(dr.Rebirth) or 0
    if cu and ds > cu then
        cy = cy + ds - cu
    end
    cu = ds
    local dt = {}
    local du = r.isOn("WebhookEggSpawns")
    for _, dv in ipairs(r.getAreaEggs()) do
        dt[dv.Uid] = true
        if cr[dv.Uid] == nil then
            cr[dv.Uid] = true
            local dw = r.resolveRarity(dv.AssetCategory)
            if du and r.selectionAllows("WebhookRarities", dw or "") and #cz < 60 then
                table.insert(cz, {
                    rank = au[dw or ""] or 0,
                    order = #cz,
                    text = string.format("**%s** `%s` in %s", r.assetName(dv.AssetCategory), tostring(dw or "?"), tostring(dv.AreaId)),
                })
            end
        end
    end
    for dv in pairs(cr) do
        if not dt[dv] then cr[dv] = nil end
    end
end
function r.buildSummaryEmbed()
    local dr = r.getSave()
    local ds = {}
    if dr then
        table.insert(ds, r.embedField("Money", "`" .. r.formatNumber(dr.Money) .. "`"))
        table.insert(ds, r.embedField("Speed Power", "`" .. r.formatNumber(dr.SpeedPower) .. "`"))
        table.insert(ds, r.embedField("Rebirth", "`" .. tostring(dr.Rebirth or 0) .. "`"))
        table.insert(ds, r.embedField("Pets Owned", "`" .. tostring(r.countTable(dr.Inventory)) .. "`"))
    end
    table.insert(ds, r.embedField("Since Last Summary",
        string.format("Eggs stolen: **%d**\nPets obtained: **%d**\nRebirths: **%d**", cw, cx, cy), false))
    return {
        author = { name = "Steal an Egg | Apex Hub" },
        title = "Session Summary",
        description = string.format("**Player** `%s`\n**Server** `%s`\n**Runtime** `%s`",
            m.Name, bt, r.formatElapsed(os.clock() - cp)),
        color = 5793266, fields = ds,
        footer = { text = "Apex Hub | " .. n },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
end
r.sendSummary = function()
    local dr = r.sendWebhookEmbed(r.buildSummaryEmbed(), true)
    if dr then
        cw, cx, cy = 0, 0, 0
        r.clearTable(cz); r.clearTable(da)
    end
    return dr
end
function r.runWebhookSummary()
    local dr = (tonumber(r.optionValue("WebhookInterval", 15)) or 15) * 60
    if os.clock() - cq < dr then return false end
    cq = os.clock()
    return r.sendSummary()
end

-- ============================================================
-- PERFORMANCE
-- ============================================================
function r.applyAntiGameplayPause(dr)
    pcall(function() j:SetGameplayPausedNotificationEnabled(not dr) end)
    pcall(function()
        local ds = k:FindFirstChild("RobloxNetworkPauseNotification")
        if ds then ds.Enabled = not dr end
    end)
end
function r.applyRendering(dr)
    pcall(function() c:Set3dRenderingEnabled(not dr) end)
    cl = dr
end
local dr = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true }
function r.setEffectEnabled(ds, dt) pcall(function() ds.Enabled = dt end) end
function r.enableFpsBoost()
    if cm then return end
    local ds = h:FindFirstChildOfClass("Terrain")
    local dt = nil
    pcall(function() dt = settings().Rendering.QualityLevel end)
    cm = {
        QualityLevel = dt, GlobalShadows = g.GlobalShadows, FogEnd = g.FogEnd,
        Terrain = ds,
        WaterWaveSize = ds and ds.WaterWaveSize or nil,
        WaterReflectance = ds and ds.WaterReflectance or nil,
        Effects = {},
    }
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    g.GlobalShadows = false; g.FogEnd = 1000000
    if ds then ds.WaterWaveSize = 0; ds.WaterReflectance = 0 end
    for _, du in ipairs(h:GetDescendants()) do
        if dr[du.ClassName] and du.Enabled then
            table.insert(cm.Effects, du)
            r.setEffectEnabled(du, false)
        end
    end
    cn = h.DescendantAdded:Connect(function(du)
        if dr[du.ClassName] and r.isOn("FpsBoost") then r.setEffectEnabled(du, false) end
    end)
end
function r.disableFpsBoost()
    if cn then cn:Disconnect(); cn = nil end
    local ds = cm; if not ds then return end
    cm = nil
    if ds.QualityLevel then pcall(function() settings().Rendering.QualityLevel = ds.QualityLevel end) end
    g.GlobalShadows = ds.GlobalShadows; g.FogEnd = ds.FogEnd
    if ds.Terrain and ds.Terrain.Parent then
        ds.Terrain.WaterWaveSize = ds.WaterWaveSize
        ds.Terrain.WaterReflectance = ds.WaterReflectance
    end
    for _, dt in ipairs(ds.Effects) do r.setEffectEnabled(dt, true) end
end
function r.applyFpsCap(ds)
    local dt = setfpscap or (syn and syn.set_fps_cap)
    if typeof(dt) ~= "function" then
        if not co then co = true end
        return false
    end
    return pcall(dt, math.clamp(tonumber(ds) or 60, 15, 360))
end
function r.handleDisconnect(ds)
    if ck then return end
    ck = true
    if r.isOn("WebhookDisconnectAlerts") then
        r.sendWebhookEmbed({
            author = { name = "Steal an Egg | Apex Hub" },
            title = "Disconnected",
            description = string.format("**Player** `%s`\n**Reason** %s", m.Name, tostring(ds or "Connection lost")),
            color = 15158332,
            footer = { text = "Apex Hub | " .. n },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }, true)
    end
    if r.isOn("AutoReconnect") then task.delay(2, r.rejoinServer) end
end

local ds = {
    ["Auto Steal Egg"] = { Ready = r.canAutoSteal, Run = r.runAutoSteal, Interval = 0.25 },
    ["Auto Place Egg"] = { Ready = r.canAutoPlace, Run = r.runAutoPlaceEggs, Interval = 0.45 },
    ["Auto Hatch"] = { Ready = r.canAutoHatch, Run = r.runAutoOpenReadyEggs, Interval = 0.55 },
    ["Auto Treadmill"] = { Ready = r.canAutoTreadmill, Run = r.runAutoTreadmillTraining, Interval = 1.2 },
}
function r.priorityOrder()
    local dt, du = {}, {}
    for _, dv in ipairs(ba) do
        local dw = r.optionValue(dv, nil)
        if ds[dw] and not dt[dw] then dt[dw] = true; table.insert(du, dw) end
    end
    for _, dv in ipairs(az) do
        if not dt[dv] then dt[dv] = true; table.insert(du, dv) end
    end
    return du
end

-- ============================================================
-- WINDU UI (WindUI)
-- ============================================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local dt = {}
dt.__state = {}
dt.__callbacks = {}
dt.__connections = {}

function dt.GetState(fi) return dt.__state[fi] end
function dt.SetState(fi, fj, fk)
    dt.__state[fi] = fj
    if fk and dt.__callbacks[fi] then
        for _, fl in ipairs(dt.__callbacks[fi]) do pcall(fl, fj) end
    end
end
function dt.OnChange(fi, fj)
    dt.__callbacks[fi] = dt.__callbacks[fi] or {}
    table.insert(dt.__callbacks[fi], fj)
end

function r.getState(fi, fj)
    local fk = dt.GetState(fi)
    if fk ~= nil then return fk end
    return fj
end
function r.isOn(fi)
    if fi == "AutoStealSelected" then
        local fk = dt.GetState("StealMode")
        return dt.GetState("StealEggsEnabled") == true
            and (fk == "Filtered Eggs" or fk == "Filtered + Oversized")
    elseif fi == "AutoStealAll" then
        return dt.GetState("StealEggsEnabled") == true and dt.GetState("StealMode") == "All Eggs"
    elseif fi == "AutoStealWarp" then
        return dt.GetState("StealEggsEnabled") == true and dt.GetState("StealMode") == "Warp Mode"
    elseif fi == "StealBigEggs" then
        local fk = dt.GetState("StealMode")
        return dt.GetState("StealEggsEnabled") == true
            and (fk == "Oversized Eggs" or fk == "Filtered + Oversized")
    end
    local fk = dt.GetState(fi)
    return fk == true
end
function r.optionValue(fi, fj)
    local fk = dt.GetState(fi)
    if fk == nil then return fj end
    return fk
end
function r.multiSelected(fi)
    local fj = dt.GetState(fi)
    local fk = {}
    if typeof(fj) ~= "table" then
        if typeof(fj) == "string" and fj ~= "" then fk[fj] = true end
        return fk
    end
    for fl, fm in pairs(fj) do
        if fm == true then fk[fl] = true
        elseif typeof(fl) == "number" and typeof(fm) == "string" then fk[fm] = true end
    end
    return fk
end
function r.multiHasAny(fi) return next(r.multiSelected(fi)) ~= nil end
function r.selectionAllows(fi, fj)
    if not r.multiHasAny(fi) then return true end
    return r.multiSelected(fi)[fj] == true
end
function r.matchesMutationFilter(fi, fj)
    if not r.multiHasAny(fi) then return true end
    local fk = r.multiSelected(fi)
    for _, fl in ipairs(r.recordMutations(fj)) do
        if fk[fl] then return true end
    end
    return false
end
function r.matchesEggFilters(fi, fj, fk, fl)
    if fj then
        local fm = fi.AreaId
        if typeof(fm) ~= "string" or not r.selectionAllows(fj, fm) then return false end
    end
    local fm = r.resolveRarity(fi.AssetCategory)
    if typeof(fm) ~= "string" or not r.selectionAllows(fk, fm) then return false end
    return r.matchesMutationFilter(fl, fi)
end

-- ============================================================
-- WINDOW
-- ============================================================
local vp = h.CurrentCamera and h.CurrentCamera.ViewportSize
local winW, winH = 640, 500
if vp then
    winH = math.min(winH, math.max(320, vp.Y - 80))
    winW = math.min(winW, math.max(560, vp.X - 40))
end

local Window = WindUI:CreateWindow({
    Title = p,
    Author = q,
    Folder = "NiCHHub",
    ToggleKey = Enum.KeyCode.LeftControl,
    Theme = "Violet",
    Size = UDim2.fromOffset(winW, winH),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Resizable = true,
})

-- ============================================================
-- RENDERER ADAPTERS
-- ============================================================
-- ============================================================
-- RENDERER ADAPTERS
-- ============================================================
dt.elements = dt.elements or {}
dt.defaults = dt.defaults or {}

function dt.AddTab(cfg)
    return Window:Tab({ Title = cfg.Title })
end

function dt.AddSection(tab, cfg)
    return tab:Section({ Title = cfg.Title, Desc = cfg.Description })
end

function dt.AddToggle(sec, cfg)
    local def = cfg.Default == true
    dt.__state[cfg.Id] = def
    dt.defaults[cfg.Id] = def
    if cfg.Callback then dt.OnChange(cfg.Id, cfg.Callback) end
    local el = sec:Toggle({
        Title = cfg.Title,
        Desc = cfg.Description,
        Value = def,
        Callback = function(v) dt.SetState(cfg.Id, v, true) end,
    })
    dt.elements[cfg.Id] = el
    return el
end

function dt.AddSlider(sec, cfg)
    local mn = tonumber(cfg.Min) or 0
    local mx = tonumber(cfg.Max) or 100
    local def = math.clamp(tonumber(cfg.Default) or mn, mn, mx)
    dt.__state[cfg.Id] = def
    dt.defaults[cfg.Id] = def
    if cfg.Callback then dt.OnChange(cfg.Id, cfg.Callback) end
    local el = sec:Slider({
        Title = cfg.Title,
        Value = { Min = mn, Max = mx, Default = def },
        Step = tonumber(cfg.Step) or 1,
        Callback = function(v) dt.SetState(cfg.Id, v, true) end,
    })
    dt.elements[cfg.Id] = el
    return el
end

function dt.AddDropdown(sec, cfg)
    local multi = cfg.Multi == true
    local state = cfg.Default
    if multi then
        if typeof(state) ~= "table" then state = {} end
    elseif typeof(state) ~= "string" then
        state = cfg.Options and cfg.Options[1] or nil
    end
    dt.__state[cfg.Id] = state
    dt.defaults[cfg.Id] = state
    if cfg.Callback then dt.OnChange(cfg.Id, cfg.Callback) end
    local el = sec:Dropdown({
        Title = cfg.Title,
        Desc = cfg.Description,
        Values = cfg.Options,
        Value = state,
        Multi = multi,
        AllowNone = multi,
        Callback = function(v) dt.SetState(cfg.Id, v, true) end,
    })
    dt.elements[cfg.Id] = el
    return el
end

function dt.AddButton(sec, cfg)
    return sec:Button({
        Title = cfg.Title,
        Callback = function()
            if cfg.Callback then task.spawn(cfg.Callback) end
        end,
    })
end

function dt.AddParagraph(sec, cfg)
    return sec:Paragraph({ Title = cfg.Title, Desc = cfg.Content })
end

function dt.AddDivider(sec, cfg)
    if cfg and cfg.Title then
        return sec:Paragraph({ Title = cfg.Title })
    end
    return sec:Divider()
end

function dt.AddStatus(sec, cfg)
    local el = sec:Paragraph({ Title = cfg.Title, Desc = tostring(cfg.Value or "") })
    local obj = {}
    function obj.SetValue(v)
        if el and el.SetDesc then pcall(el.SetDesc, el, tostring(v)) end
    end
    function obj.SetStatus(st) end
    return obj
end

function dt.AddInput(sec, cfg)
    local def = tostring(cfg.Default or "")
    dt.__state[cfg.Id] = def
    dt.defaults[cfg.Id] = def
    if cfg.Callback then dt.OnChange(cfg.Id, cfg.Callback) end
    local el = sec:Input({
        Title = cfg.Title,
        Desc = cfg.Description,
        Placeholder = cfg.Placeholder or "Enter Text...",
        Value = def,
        Callback = function(v) dt.SetState(cfg.Id, v, true) end,
    })
    dt.elements[cfg.Id] = el
    return el
end

-- ============================================================
-- CONFIG PERSISTENCE
-- ============================================================
local CONFIG_FOLDER = "WindUI/NiCHHub"
local CONFIG_FILE = CONFIG_FOLDER .. "/config/main.json"

local function configReady()
    return typeof(writefile) == "function" and typeof(readfile) == "function"
        and typeof(isfile) == "function" and typeof(makefolder) == "function"
end

local function ensureConfigDirs()
    if not configReady() then return end
    pcall(makefolder, "WindUI")
    pcall(makefolder, CONFIG_FOLDER)
    pcall(makefolder, CONFIG_FOLDER .. "/config")
end

local function syncElement(id, v)
    local el = dt.elements[id]
    if not el then return end
    if typeof(el.Set) == "function" then pcall(el.Set, el, v)
    elseif typeof(el.Select) == "function" then pcall(el.Select, el, v) end
end

local function applyState(id, v)
    if dt.elements[id] == nil then return end
    dt.SetState(id, v, true)
    syncElement(id, v)
end

function r.saveConfig()
    if not configReady() then return false end
    ensureConfigDirs()
    local data = {}
    for id in pairs(dt.elements) do
        local v = dt.__state[id]
        if v ~= nil then data[id] = v end
    end
    local ok, json = pcall(function() return d:JSONEncode(data) end)
    if not ok or typeof(json) ~= "string" then return false end
    pcall(writefile, CONFIG_FILE, json)
    return true
end

function r.loadConfig()
    if not configReady() or not isfile(CONFIG_FILE) then return false end
    local ok, data = pcall(function() return d:JSONDecode(readfile(CONFIG_FILE)) end)
    if not ok or typeof(data) ~= "table" then return false end
    local n = 0
    for id, v in pairs(data) do
        pcall(applyState, id, v)
        n = n + 1
    end
    return n > 0
end

function r.resetConfig()
    if configReady() and isfile(CONFIG_FILE) and typeof(delfile) == "function" then
        pcall(delfile, CONFIG_FILE)
    end
    for id in pairs(dt.elements) do
        dt.SetState(id, dt.defaults[id], true)
        syncElement(id, dt.defaults[id])
    end
    return true
end

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local notifyIcons = {
    Success = "check",
    Warning = "triangle-alert",
    Error = "x",
    Info = "info",
}
function r.notify(fq, fr, fs, ft)
    local fv = {
        Title = tostring(fq or "NiCH Hub"),
        Content = tostring(fr or ""),
        Duration = tonumber(ft) or 5,
    }
    local fw = notifyIcons[fs]
    if fw then
        fv.Icon = fw
        local fx, fy = pcall(WindUI.CreateNotify, WindUI, fv)
        if fx and fy then return fy end
        fv.Icon = nil
    end
    local fx, fy = pcall(WindUI.CreateNotify, WindUI, fv)
    return fx and fy
end

-- ============================================================
-- BUILD UI
-- ============================================================
local fq = {}

do
    -- ============ HOME ============
    local homeTab = dt.AddTab({ Id = "home", Title = "Home" })

    local secStatus = dt.AddSection(homeTab, { Title = "Live Status", Description = "Session stats" })
    fq.statusRow = dt.AddStatus(secStatus, { Title = "Automation", Value = "Ready" })
    fq.statusRow:SetStatus("Success")
    fq.jobRow = dt.AddStatus(secStatus, { Title = "Current Job", Value = "Idle" })
    fq.stolenRow = dt.AddStatus(secStatus, { Title = "Stolen Eggs", Value = "0" })
    fq.carryingRow = dt.AddStatus(secStatus, { Title = "Carrying Egg", Value = "No" })
    fq.runtimeRow = dt.AddStatus(secStatus, { Title = "Runtime", Value = "0m" })
    dt.AddStatus(secStatus, { Title = "Server", Value = bt })

    local secAccount = dt.AddSection(homeTab, { Title = "Account", Description = "Save data" })
    fq.inventoryProgress = dt.AddStatus(secAccount, { Title = "Egg Inventory", Value = tostring(r.eggInventoryCount()) })
    fq.moneyRow = dt.AddStatus(secAccount, { Title = "Money", Value = "0" })
    fq.speedRow = dt.AddStatus(secAccount, { Title = "Speed Power", Value = "0" })
    fq.rebirthRow = dt.AddStatus(secAccount, { Title = "Rebirths", Value = "0" })
    fq.petsOwnedRow = dt.AddStatus(secAccount, { Title = "Pets Owned", Value = "0" })

    local secActions = dt.AddSection(homeTab, { Title = "Quick Actions", Description = "One-click commands" })
    dt.AddButton(secActions, { Title = "Return to Base", Text = "Return", Callback = function()
        task.spawn(function()
            if not r.getBasePosition() or not r.returnToBaseBypass(nil) then
                r.notify("Return", "Base unavailable", "Warning", 3)
            end
        end)
    end })
    dt.AddButton(secActions, { Title = "Place Eggs", Text = "Place", Callback = function()
        task.spawn(function() r.runAutoPlaceEggs(true) end)
    end })
    dt.AddButton(secActions, { Title = "Fuse Now", Text = "Fuse", Callback = function()
        task.spawn(function() r.runAutoFusePets(true) end)
    end })
    dt.AddButton(secActions, { Title = "Hop Server Now", Text = "Hop", Callback = function()
        task.spawn(function() cb = 0; r.serverHop("Manual") end)
    end })

    local secTips = dt.AddSection(homeTab, { Title = "Quick Start" })
    dt.AddParagraph(secTips, { Title = "Farm flow",
        Content = "Farm tab -> set 'What to Steal' -> turn on 'Auto Steal'. It runs on its own." })
    dt.AddParagraph(secTips, { Title = "What to Steal",
        Content = "All Eggs = everything. Filtered Eggs = only matching rarities/mutations you pick. Oversized = big eggs only. Filtered + Oversized = both." })
    dt.AddParagraph(secTips, { Title = "Config",
        Content = "Settings auto-save and auto-load. Manage them in the Settings tab." })

    -- ============ FARM ============
    local farmTab = dt.AddTab({ Id = "farm", Title = "Farm" })

    local secSteal = dt.AddSection(farmTab, { Title = "Steal Eggs", Description = "Main egg farming" })
    dt.AddToggle(secSteal, { Id = "StealEggsEnabled", Title = "Auto Steal", Description = "Master switch for stealing", Default = false, Callback = function(bi)
        if not bi then r.stealCleanup() end
    end })
    dt.AddDropdown(secSteal, { Id = "StealMode", Title = "What to Steal", Description = "Pick ONE target type",
        Options = { "All Eggs", "Filtered Eggs", "Oversized Eggs", "Filtered + Oversized", "Warp Mode" }, Default = "Filtered Eggs" })
    dt.AddSlider(secSteal, { Id = "StealMoveSpeed", Title = "Steal Speed", Min = 16, Max = 2000, Default = bj, Step = 1, Suffix = " studs/s" })
    dt.AddSlider(secSteal, { Id = "BypassReturnSpeed", Title = "Return Speed", Min = 16, Max = 2000, Default = bk, Step = 1, Suffix = " studs/s" })

    dt.AddDivider(secSteal, { Title = "Target filters" })
    dt.AddDropdown(secSteal, { Id = "StealZones", Title = "Areas", Options = bd, Multi = true, Default = {} })
    dt.AddDropdown(secSteal, { Id = "StealRarities", Title = "Rarities", Options = at, Multi = true, Default = {} })
    dt.AddDropdown(secSteal, { Id = "StealMutations", Title = "Mutations", Options = av, Multi = true, Default = {} })
    dt.AddDropdown(secSteal, { Id = "StealPriority", Title = "Target Priority", Options = aw, Default = "Rarest" })
    dt.AddSlider(secSteal, { Id = "StealBigEggScale", Title = "Minimum Big Egg Size", Min = 1, Max = 50, Default = 1.5, Step = 0.1, Suffix = "x" })

    dt.AddDivider(secSteal, { Title = "Carry behavior" })
    dt.AddToggle(secSteal, { Id = "AutoReturn", Title = "Auto Return to Base", Default = true })
    dt.AddToggle(secSteal, { Id = "AutoChaseAndHit", Title = "Auto Chase & Hit Carriers", Description = "Chase players carrying an egg, or pick up carried/dropped eggs matching your filters. Works even when Auto Steal is off. Knock the egg loose with a Bat tool, then pick it up.", Default = false })
    dt.AddSlider(secSteal, { Id = "ReturnFlyHeight", Title = "Return Flight Height", Min = 3, Max = 30, Default = 30, Step = 1, Suffix = " studs" })
    dt.AddToggle(secSteal, { Id = "AutoDropEgg", Title = "Auto Drop Held Egg", Default = false })
    dt.AddToggle(secSteal, { Id = "StatueCam", Title = "Base Statue Camera", Description = "Keep camera at base watching a statue clone while your real character steals; camera restores when it returns to base.", Default = false })

    local secPlace = dt.AddSection(farmTab, { Title = "Place & Hatch" })
    dt.AddToggle(secPlace, { Id = "AutoPlaceSelected", Title = "Auto Place Selected", Default = false })
    dt.AddToggle(secPlace, { Id = "AutoPlaceAll", Title = "Auto Place All", Default = false })
    dt.AddToggle(secPlace, { Id = "AutoOpenReadyEggs", Title = "Auto Hatch Ready", Default = false })
    dt.AddDropdown(secPlace, { Id = "LifecycleRarities", Title = "Rarities", Options = at, Multi = true, Default = {} })
    dt.AddDropdown(secPlace, { Id = "LifecycleMutations", Title = "Mutations", Options = av, Multi = true, Default = {} })

    local secHop = dt.AddSection(farmTab, { Title = "Server Hop" })
    dt.AddToggle(secHop, { Id = "AutoServerHop", Title = "Auto Server Hop", Default = false })
    dt.AddDropdown(secHop, { Id = "HopMode", Title = "Hop When", Options = bb, Default = "No Matching Eggs" })
    dt.AddSlider(secHop, { Id = "HopValue", Title = "Wait Before Hop", Min = 1, Max = 200, Default = 15, Step = 1 })
    dt.AddButton(secHop, { Title = "Hop Now", Text = "Hop", Callback = function()
        task.spawn(function() cb = 0; r.serverHop("Manual") end)
    end })

    local secOrder = dt.AddSection(farmTab, { Title = "Task Order", Description = "Runs the first ready task in this order" })
    for idx, taskName in ipairs(ba) do
        dt.AddDropdown(secOrder, { Id = taskName, Title = "Slot " .. idx, Options = az, Default = az[idx] })
    end

    -- ============ SELL ============
    local sellTab = dt.AddTab({ Id = "sell", Title = "Sell" })

    local secSellEggs = dt.AddSection(sellTab, { Title = "Auto Sell Eggs", Description = "Sell eggs from inventory" })
    dt.AddToggle(secSellEggs, { Id = "AutoSellEggs", Title = "Auto Sell Eggs", Default = false })
    dt.AddDropdown(secSellEggs, { Id = "SellEggRarities", Title = "Rarities", Options = at, Multi = true, Default = {} })
    dt.AddSlider(secSellEggs, { Id = "SellEggInterval", Title = "Interval", Min = 1, Max = 120, Default = 8, Step = 1, Suffix = " s" })
    dt.AddButton(secSellEggs, { Title = "Sell All Eggs Now", Text = "Sell All", Callback = function()
        task.spawn(function() r.runAutoSellEggs() end)
    end })

    local secSellPets = dt.AddSection(sellTab, { Title = "Auto Sell Pets", Description = "Sell spare pets" })
    dt.AddToggle(secSellPets, { Id = "AutoSellPets", Title = "Auto Sell Pets", Default = false })
    dt.AddDropdown(secSellPets, { Id = "SellRarities", Title = "Rarities", Options = at, Multi = true, Default = {} })
    dt.AddDropdown(secSellPets, { Id = "SellMutations", Title = "Mutations", Options = av, Multi = true, Default = {} })
    dt.AddToggle(secSellPets, { Id = "SellKeepMutated", Title = "Never Sell Mutated", Default = true })
    dt.AddToggle(secSellPets, { Id = "SellKeepEquipped", Title = "Never Sell Equipped", Default = true })
    dt.AddSlider(secSellPets, { Id = "SellMaxScale", Title = "Maximum Scale to Sell", Min = 0, Max = 10, Default = 10, Step = 0.1 })
    dt.AddSlider(secSellPets, { Id = "SellInterval", Title = "Interval", Min = 1, Max = 120, Default = 6, Step = 1, Suffix = " s" })
    dt.AddButton(secSellPets, { Title = "Sell All Pets Now", Text = "Sell All", Callback = function()
        task.spawn(function() r.runAutoSellPets() end)
    end })

    -- ============ PETS ============
    local petsTab = dt.AddTab({ Id = "pets", Title = "Pets" })

    local secFuse = dt.AddSection(petsTab, { Title = "Auto Fuse", Description = "Merge pets into rarer ones" })
    dt.AddToggle(secFuse, { Id = "AutoFusePets", Title = "Auto Fuse Pets", Default = false })
    dt.AddDropdown(secFuse, { Id = "FuseRarities", Title = "Rarities", Options = at, Multi = true, Default = {} })
    dt.AddDropdown(secFuse, { Id = "FuseMutations", Title = "Mutations", Options = av, Multi = true, Default = {} })
    dt.AddDropdown(secFuse, { Id = "FuseTarget", Title = "Pick Group By", Options = ax, Default = "Highest Rarity" })
    dt.AddToggle(secFuse, { Id = "FuseKeepMutated", Title = "Never Fuse Mutated", Default = true })
    dt.AddToggle(secFuse, { Id = "FuseKeepEquipped", Title = "Never Fuse Equipped", Default = true })
    dt.AddToggle(secFuse, { Id = "FuseAutoReveal", Title = "Auto Complete Reveal", Default = true })
    dt.AddSlider(secFuse, { Id = "FuseMaxScale", Title = "Maximum Scale to Fuse", Min = 0, Max = 10, Default = 10, Step = 0.1 })
    dt.AddSlider(secFuse, { Id = "FuseKeepPerCategory", Title = "Keep Per Pet Type", Min = 0, Max = 20, Default = 0, Step = 1 })
    dt.AddSlider(secFuse, { Id = "FuseInterval", Title = "Interval", Min = 1, Max = 120, Default = 8, Step = 1, Suffix = " s" })
    dt.AddButton(secFuse, { Title = "Fuse Now", Text = "Fuse", Callback = function()
        task.spawn(function() r.runAutoFusePets(true) end)
    end })

    local secPetsGeneral = dt.AddSection(petsTab, { Title = "General" })
    dt.AddToggle(secPetsGeneral, { Id = "AutoEquipBest", Title = "Auto Equip Best Pets", Default = false })
    dt.AddToggle(secPetsGeneral, { Id = "AutoDeleteOwnPets", Title = "Hide Own Pet Renders", Default = false })

    -- ============ PROGRESS ============
    local progTab = dt.AddTab({ Id = "progress", Title = "Progress" })

    local secUpgrades = dt.AddSection(progTab, { Title = "Upgrades", Description = "Money spenders" })
    dt.AddToggle(secUpgrades, { Id = "AutoUpgrades", Title = "Auto Buy Upgrades", Default = false })
    dt.AddDropdown(secUpgrades, { Id = "UpgradeTypes", Title = "Upgrade Types", Options = ay, Multi = true, Default = { "Base", "Treadmill" } })

    local secRewards = dt.AddSection(progTab, { Title = "Rewards" })
    dt.AddToggle(secRewards, { Id = "AutoClaimIndex", Title = "Auto Claim Index", Default = false })
    dt.AddToggle(secRewards, { Id = "AutoClaimGroupReward", Title = "Auto Claim Group Reward", Default = false })
    dt.AddToggle(secRewards, { Id = "AutoClaimOffline", Title = "Claim Offline Earnings", Default = false })

    local secTrails = dt.AddSection(progTab, { Title = "Equipment" })
    dt.AddToggle(secTrails, { Id = "AutoBuyTrail", Title = "Auto Buy Trail", Default = false })
    dt.AddDropdown(secTrails, { Id = "TrailWanted", Title = "Trails", Options = be, Multi = true, Default = {} })
    dt.AddToggle(secTrails, { Id = "AutoEquipBestTrail", Title = "Auto Equip Best Trail", Default = false })
    dt.AddToggle(secTrails, { Id = "AutoEquipBestGear", Title = "Auto Equip Best Gear", Default = false })

    local secTraining = dt.AddSection(progTab, { Title = "Training" })
    dt.AddToggle(secTraining, { Id = "AutoTreadmill", Title = "Auto Treadmill Training", Default = false })

    -- ============ PLAYER ============
    local playerTab = dt.AddTab({ Id = "player", Title = "Player" })

    local secEsp = dt.AddSection(playerTab, { Title = "ESP", Description = "Highlight targets" })
    dt.AddToggle(secEsp, { Id = "EspWorldEggs", Title = "World Egg ESP", Default = false })
    dt.AddToggle(secEsp, { Id = "EspCarriedEggs", Title = "Carried and Dropped Egg ESP", Default = false })
    dt.AddToggle(secEsp, { Id = "EspGuards", Title = "Guard ESP", Default = false })
    dt.AddToggle(secEsp, { Id = "EspPets", Title = "Pet ESP", Default = false })
    dt.AddToggle(secEsp, { Id = "EspPlayers", Title = "Player ESP", Default = false })
    dt.AddToggle(secEsp, { Id = "EspMachines", Title = "Machine ESP", Default = false })
    dt.AddToggle(secEsp, { Id = "EspPlots", Title = "Plot ESP", Default = false })
    dt.AddSlider(secEsp, { Id = "EspDistance", Title = "Render Distance", Min = 100, Max = 6000, Default = 2000, Step = 50, Suffix = " studs" })

    local secMove = dt.AddSection(playerTab, { Title = "Movement" })
    dt.AddToggle(secMove, { Id = "WalkSpeedEnabled", Title = "Walk Speed Override", Default = false })
    dt.AddSlider(secMove, { Id = "WalkSpeed", Title = "Walk Speed", Min = 16, Max = 500, Default = 32, Step = 1 })
    dt.AddToggle(secMove, { Id = "JumpPowerEnabled", Title = "Jump Power Override", Default = false })
    dt.AddSlider(secMove, { Id = "JumpPower", Title = "Jump Power", Min = 10, Max = 500, Default = 50, Step = 1 })
    dt.AddToggle(secMove, { Id = "InfJump", Title = "Infinite Jump", Default = false })
    dt.AddToggle(secMove, { Id = "NoClip", Title = "NoClip", Default = false })

    dt.AddDivider(secMove, { Title = "Fly" })
    dt.AddToggle(secMove, { Id = "Fly", Title = "Fly", Default = false, Callback = function(by)
        if not by then
            local hmd = r.getHumanoid(); if hmd then hmd.PlatformStand = false end
            local root = r.getRoot()
            local lv = root and root:FindFirstChild("ApexFlyLV")
            if lv then lv:Destroy() end
        end
    end })
    dt.AddSlider(secMove, { Id = "FlySpeed", Title = "Fly Speed", Min = 10, Max = 400, Default = 60, Step = 1 })

    local secTeleport = dt.AddSection(playerTab, { Title = "Teleports" })
    dt.AddDropdown(secTeleport, { Id = "WaypointTarget", Title = "Waypoint", Options = dq, Default = "Base" })
    dt.AddButton(secTeleport, { Title = "Teleport to Waypoint", Text = "Go", Callback = function()
        task.spawn(function()
            local wp = r.resolveWaypoint(r.optionValue("WaypointTarget", "Base"))
            if not wp then r.notify("Waypoint", "Unavailable", "Warning", 3); return end
            if not r.bypassMoveTo(wp, nil, r.bypassSpeed()) then r.notify("Waypoint", "Failed", "Error", 3) end
        end)
    end })

    -- ============ SETTINGS ============
    local settingsTab = dt.AddTab({ Id = "system", Title = "Settings" })

    local secSessionProtect = dt.AddSection(settingsTab, { Title = "Session", Description = "Session safety" })
    dt.AddToggle(secSessionProtect, { Id = "AntiAfk", Title = "Anti-AFK", Default = true })
    dt.AddToggle(secSessionProtect, { Id = "AntiGameplayPause", Title = "No Gameplay Paused", Default = true,
        Callback = function(ch) r.applyAntiGameplayPause(ch) end })
    dt.AddToggle(secSessionProtect, { Id = "AutoReconnect", Title = "Auto Reconnect", Default = false })
    dt.AddButton(secSessionProtect, { Title = "Rejoin Server", Text = "Rejoin", Callback = function() r.rejoinServer() end })
    -- dt.AddButton(secSessionProtect, { Title = "Copy Join Script", Text = "Copy", Callback = function()
    --     pcall(function() setclipboard(string.format(
    --         'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game:GetService("Players").LocalPlayer)',
    --         game.PlaceId, bs)) end)
    --     r.notify("Copied", "Join script copied", "Success", 3)
    -- end })

    local secPerf = dt.AddSection(settingsTab, { Title = "Performance" })
    dt.AddToggle(secPerf, { Id = "FpsBoost", Title = "FPS Boost", Default = false,
        Callback = function(ch) if ch then r.enableFpsBoost() else r.disableFpsBoost() end end })
    dt.AddToggle(secPerf, { Id = "DisableRendering", Title = "Disable 3D Rendering", Default = false,
        Callback = function(ch) r.applyRendering(ch) end })
    dt.AddSlider(secPerf, { Id = "FpsCap", Title = "FPS Cap", Min = 15, Max = 360, Default = 60, Step = 1, Suffix = " fps",
        Callback = function(ch) r.applyFpsCap(ch) end })

    local secWebhooks = dt.AddSection(settingsTab, { Title = "Webhooks", Description = "Discord push notifications" })
    dt.AddToggle(secWebhooks, { Id = "WebhookEnabled", Title = "Enable Webhooks", Default = false })
    dt.AddInput(secWebhooks, { Id = "WebhookUrl", Title = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Default = "" })
    dt.AddInput(secWebhooks, { Id = "WebhookPingId", Title = "Ping User ID", Placeholder = "123456789012345678", Default = "" })
    dt.AddSlider(secWebhooks, { Id = "WebhookInterval", Title = "Summary Interval", Min = 1, Max = 180, Default = 15, Step = 1, Suffix = " min" })
    dt.AddToggle(secWebhooks, { Id = "WebhookEggSpawns", Title = "List Spawned Eggs", Default = true })
    dt.AddDropdown(secWebhooks, { Id = "WebhookRarities", Title = "Rarities", Options = at, Multi = true, Default = {} })
    dt.AddToggle(secWebhooks, { Id = "WebhookDisconnectAlerts", Title = "Disconnect Alerts", Default = false })
    dt.AddButton(secWebhooks, { Title = "Send Summary Now", Text = "Send", Callback = function()
        task.spawn(function()
            local ch = r.sendSummary()
            r.notify("Webhook", ch and "Sent" or "Failed", ch and "Success" or "Error", 3)
        end)
    end })

    local secConfig = dt.AddSection(settingsTab, { Title = "Config", Description = "Settings persistence" })
    dt.AddParagraph(secConfig, { Title = "Auto", Content = "Saves every 30 seconds and on close. Auto-loads on start." })
    dt.AddButton(secConfig, { Title = "Save Config Now", Text = "Save", Callback = function()
        local ok = r.saveConfig()
        r.notify("Config", ok and "Saved" or "Save failed", ok and "Success" or "Error", 3)
    end })
    dt.AddButton(secConfig, { Title = "Load Config", Text = "Load", Callback = function()
        local ok = r.loadConfig()
        r.notify("Config", ok and "Loaded" or "No saved config", ok and "Success" or "Warning", 3)
    end })
    dt.AddButton(secConfig, { Title = "Reset to Defaults", Text = "Reset", Callback = function()
        local ok = r.resetConfig()
        r.notify("Config", ok and "Reset to defaults" or "Reset failed", ok and "Success" or "Error", 3)
    end })

    local secAbout = dt.AddSection(settingsTab, { Title = "About" })
    dt.AddParagraph(secAbout, { Title = "Script Dev", Content = "Apex" })
    dt.AddParagraph(secAbout, { Title = "UI", Content = "WindUI" })
    dt.AddParagraph(secAbout, { Title = "Discord", Content = n })
    dt.AddButton(secAbout, { Title = "Copy Discord Link", Text = "Copy", Callback = function()
        pcall(function() setclipboard(n) end)
        r.notify("Copied", "Discord link copied", "Success", 3)
    end })

    dt.AddDivider(secAbout, { Title = "Danger Zone" })
    dt.AddButton(secAbout, { Title = "Unload Script", Text = "Unload", Callback = function() r.unload() end })
end

-- ============================================================
-- DASHBOARD REFRESH
-- ============================================================
local function fr()
    if not s then return end
    pcall(function()
        if fq.carryingRow then
            fq.carryingRow:SetValue(bu and "Yes" or "No")
            fq.carryingRow:SetStatus(bu and "Warning" or "Neutral")
        end
        if fq.runtimeRow then fq.runtimeRow:SetValue(r.formatElapsed(os.clock() - cp)) end
        if fq.inventoryProgress then
            fq.inventoryProgress:SetValue(string.format("%d / %s", r.eggInventoryCount(),
                tostring(w and w.MAX_INVENTORY or "?")))
        end
        local gw = r.getSave()
        if gw then
            if fq.moneyRow then fq.moneyRow:SetValue(r.formatNumber(gw.Money)) end
            if fq.speedRow then fq.speedRow:SetValue(r.formatNumber(gw.SpeedPower)) end
            if fq.rebirthRow then fq.rebirthRow:SetValue(tostring(gw.Rebirth or 0)) end
            if fq.petsOwnedRow then fq.petsOwnedRow:SetValue(tostring(r.countTable(gw.Inventory))) end
        end
        if fq.stolenRow then fq.stolenRow:SetValue(tostring(bv)) end
    end)
end
fr()
r.loadConfig()
if Window.OnDestroy then pcall(Window.OnDestroy, Window, function() pcall(r.saveConfig) end) end
task.spawn(function()
    while s do
        task.wait(30)
        pcall(r.saveConfig)
    end
end)

-- ============================================================
-- UNLOAD
-- ============================================================
function r.unload()
    if not s then return end
    s = false
    pcall(r.stealCleanup)
    pcall(r.stopTreadmillTraining)
    pcall(function() r.applyAntiGameplayPause(false) end)
    pcall(function() r.applyRendering(false) end)
    pcall(r.disableFpsBoost)
    pcall(r.clearAllEsp)
    if dh then pcall(function() dh:Destroy() end) end
    for _, fs in ipairs(br) do
        pcall(function() if typeof(fs) == "RBXScriptConnection" then fs:Disconnect() end end)
    end
    r.clearTable(br)
    for _, fs in ipairs(dt.__connections) do
        pcall(function() if typeof(fs) == "RBXScriptConnection" then fs:Disconnect() end end)
    end
    if Window then
        pcall(r.saveConfig)
        pcall(function() Window:Destroy() end)
    end
    a.__APEX_HUB_RUNNING = nil
    a.__APEX_HUB_SHUTDOWN = nil
end
a.__APEX_HUB_SHUTDOWN = r.unload

-- ============================================================
-- CONNECTIONS
-- ============================================================
local function fs(ft)
    if ft and ft:IsA("BasePart") then ft.CanCollide = false end
end
local fu = nil
local function fv(fw)
    if fu then pcall(function() fu:Disconnect() end); fu = nil end
    local fy = m.Character
    if not fw or not fy then return end
    for _, fz in ipairs(fy:GetDescendants()) do fs(fz) end
    fu = fy.DescendantAdded:Connect(fs)
    r.track(fu)
end

r.track(f.JumpRequest:Connect(function()
    if not s or not r.isOn("InfJump") then return end
    local fx = r.getHumanoid()
    if fx then fx:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

r.track(c.RenderStepped:Connect(function(fx)
    if not s or not r.isOn("Fly") then return end
    local fy = r.getRoot(); local fz = r.getHumanoid()
    local ga = h.CurrentCamera
    if not fy or not fz or not ga then return end

    fz.PlatformStand = true

    local gb = fy:FindFirstChild("ApexFlyLV")
    if not gb then
        gb = Instance.new("LinearVelocity")
        gb.Name = "ApexFlyLV"
        gb.MaxForce = 1e6
        gb.RelativeTo = Enum.ActuatorRelativeTo.World
        local gc = Instance.new("Attachment")
        gc.Name = "ApexFlyAttachment"
        gc.Parent = fy
        gb.Attachment0 = gc
        gb.Parent = fy
    end

    local gc = Vector3.zero
    if f:IsKeyDown(Enum.KeyCode.W) then gc = gc + ga.CFrame.LookVector end
    if f:IsKeyDown(Enum.KeyCode.S) then gc = gc - ga.CFrame.LookVector end
    if f:IsKeyDown(Enum.KeyCode.A) then gc = gc - ga.CFrame.RightVector end
    if f:IsKeyDown(Enum.KeyCode.D) then gc = gc + ga.CFrame.RightVector end
    if f:IsKeyDown(Enum.KeyCode.Space) then gc = gc + Vector3.new(0, 1, 0) end
    if f:IsKeyDown(Enum.KeyCode.LeftControl) then gc = gc - Vector3.new(0, 1, 0) end

    local gd = math.min(tonumber(r.optionValue("FlySpeed", 60)) or 60, bi)
    if gc.Magnitude > 0 then
        gb.VectorVelocity = gc.Unit * gd
    else
        gb.VectorVelocity = Vector3.zero
    end
end))

r.track(f.InputBegan:Connect(function() ci = tick() end))
r.track(f.InputChanged:Connect(function(fx)
    local fy = fx.UserInputType
    if fy == Enum.UserInputType.MouseMovement or fy == Enum.UserInputType.Gamepad1 then ci = tick() end
end))

r.track(m.CharacterAdded:Connect(function()
    if not s then return end
    task.delay(0.35, function()
        if r.stealingEnabled() then r.swapStealHumanoid() end
        if r.isOn("NoClip") then fv(true) end
    end)
end))

r.track(f.InputBegan:Connect(function(fx, fy)
    if not fy and fx.KeyCode == Enum.KeyCode.End then r.unload() end
end))

-- ============================================================
-- SCHEDULER
-- ============================================================
local fx = {}
local fy = false
local function fz(ga, gb)
    local ge = os.clock()
    if ge < (fx[ga] or 0) then return false end
    fx[ga] = ge + gb
    return true
end

local function gc()
    if bx then return end
    if r.isOn("AutoDropEgg") and bu then
        bx = true; pcall(r.runAutoDropEgg); bx = false; return
    end
    if r.isOn("AutoReturn") and bu then
        if not r.stealingEnabled() then
            if returnState == "idle" then
                bx = true
                pcall(r.finalizeCarryReturn)
                if bu then returnState = "running" end
                bx = false
                return
            end
            if returnState == "running" then
                bx = true; pcall(r.runAutoReturn); bx = false
                return
            end
        end
    else
        returnState = "idle"
        local rr = r.getRoot(); if rr then pcall(function() rr.Anchored = false end) end
    end
end

local function gd()
    if bx then return end
    local ge = r.priorityOrder()
    if #ge < 1 then return end
    for _, gf in ipairs(ge) do
        local gg = ds[gf]
        local gh = gg and gg.Ready()
        if gh then
            local gi = by[gf] or 0
            gh = os.clock() - gi >= gg.Interval
        end
        if gh then
            by[gf] = os.clock()
            if gf ~= "Auto Treadmill" and (bz or r.isDoubleSpeedVisible()) then
                pcall(r.stopTreadmillTraining)
            end
            bx = true
            local gi, gj = pcall(gg.Run)
            bx = false
            if gi and gj then return end
        end
    end
end

r.track(c.Heartbeat:Connect(function()
    if not s then return end

    if fz("core", 0.35) then
        task.spawn(function()
if r.stealingEnabled() or bu then r.swapStealHumanoid() end
            gc()
            gd()
        end)
    end

    if fz("dashboard", 2) then
        fr()
        local ge = r.isOn("NoClip")
        if ge ~= fy then fy = ge; fv(ge) end
        if r.isOn("WalkSpeedEnabled") then
            local gf = r.getHumanoid()
            if gf then
                gf.WalkSpeed = math.min(tonumber(r.optionValue("WalkSpeed", 32)) or 32, bi)
            end
        end
        if r.isOn("JumpPowerEnabled") then
            local gf = r.getHumanoid()
            if gf then
                gf.UseJumpPower = true
                gf.JumpPower = tonumber(r.optionValue("JumpPower", 50)) or 50
            end
        end
        if bz or r.isDoubleSpeedVisible() then
            if not r.isOn("AutoTreadmill") then pcall(r.stopTreadmillTraining) end
        end
        if r.isOn("AntiGameplayPause") then r.applyAntiGameplayPause(true) end
    end

    if fz("esp", 1.25) then
        local ge = r.isOn("EspWorldEggs") or r.isOn("EspCarriedEggs") or r.isOn("EspGuards")
            or r.isOn("EspPets") or r.isOn("EspPlayers") or r.isOn("EspMachines") or r.isOn("EspPlots")
        if ge then pcall(r.runEsp)
        elseif next(db) ~= nil then pcall(r.clearAllEsp) end
    end

    if fz("pets", 5) then
        if r.isOn("AutoEquipBest") and not bx then pcall(r.runAutoEquipBest) end
        if r.isOn("AutoEquipBestTrail") then pcall(r.runAutoEquipBestTrail) end
        if r.isOn("AutoEquipBestGear") then pcall(r.runAutoEquipBestGear) end
        if r.isOn("AutoDeleteOwnPets") then pcall(r.deleteOwnPetRenders) end
    end

    if fz("fuse", tonumber(r.optionValue("FuseInterval", 8)) or 8) then
        if r.isOn("AutoFusePets") and not bx and not bu then
            bx = true; pcall(r.runAutoFusePets); bx = false
        end
    end

    if fz("sellPets", tonumber(r.optionValue("SellInterval", 6)) or 6) then
        if r.isOn("AutoSellPets") and not bx and not bu then pcall(r.runAutoSellPets) end
    end

    if fz("sellEggs", tonumber(r.optionValue("SellEggInterval", 8)) or 8) then
        if r.isOn("AutoSellEggs") and not bx and not bu then
            bx = true; pcall(r.runAutoSellEggs); bx = false
        end
    end

    if fz("upgrades", 4) then
        if r.isOn("AutoUpgrades") and not bu then pcall(r.runAutoUpgrades) end
        if r.isOn("AutoBuyTrail") and not bu then pcall(r.runAutoBuyTrail) end
    end

    if fz("claims", 12) then
        if r.isOn("AutoClaimIndex") then pcall(r.runAutoClaimIndex) end
        if r.isOn("AutoClaimOffline") then pcall(r.runClaimOfflineEarnings) end
        if r.isOn("AutoClaimGroupReward") then pcall(r.runAutoClaimGroupReward) end
    end

    if fz("hop", 3) then
        if r.isOn("AutoServerHop") and not bx then pcall(r.runServerHop) end
    end

    if fz("webhook", 5) then
        if r.isOn("WebhookEnabled") then
            pcall(r.trackWebhookEvents)
            pcall(r.runWebhookSummary)
        end
    end

    if fz("session", 4) then
        if r.isOn("AntiAfk") then
            local ge = tick() - ci
            local gf = tick() - cj
            if (ge >= 300 and gf >= 60) or (ge < 300 and gf >= 300) then
                pcall(function()
                    local gg = r.getHumanoid()
                    if gg then
                        gg.Jump = true
                        cj = tick()
                    end
                end)
            end
        end
        if r.isOn("AutoReconnect") or r.isOn("WebhookDisconnectAlerts") then
            local ge = k:FindFirstChild("RobloxPromptGui")
            local gf = ge and ge:FindFirstChild("promptOverlay")
            if gf then
                local gg = gf:FindFirstChild("ErrorPrompt") or gf:FindFirstChildWhichIsA("Frame")
                if gg and gg.Visible and tostring(gg.Name):find("ErrorPrompt") then
                    r.handleDisconnect("Roblox error prompt")
                end
            end
        end
    end
end))

if r.isOn("AntiGameplayPause") then r.applyAntiGameplayPause(true) end
if r.isOn("FpsBoost") then r.enableFpsBoost() end
r.applyFpsCap(r.optionValue("FpsCap", 60))

r.notify("NiCH HUB", "Ready - press LeftControl to toggle the hub (unload in System tab)", "Success", 5)
if fq.statusRow then fq.statusRow:SetStatus("Success") end
