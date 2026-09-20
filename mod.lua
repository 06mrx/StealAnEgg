local GLOBAL_ENV = (getgenv and getgenv()) or _G

if type(table.pack) ~= "function" then
    function table.pack(...) return { n = select("#", ...), ... } end
end
if type(table.unpack) ~= "function" then table.unpack = unpack end
if type(typeof) ~= "function" then typeof = type end
if type(math.clamp) ~= "function" then
    function math.clamp(value, minimum, maximum)
        if value < minimum then return minimum elseif value > maximum then return maximum end
        return value
    end
end
if type(table.find) ~= "function" then
    function table.find(list, target, startIndex)
        if type(list) ~= "table" then return nil end
        for index = tonumber(startIndex) or 1, #list do if list[index] == target then return index end end
        return nil
    end
end

if type(GLOBAL_ENV.__APEX_HUB_SHUTDOWN) == "function" then
    pcall(GLOBAL_ENV.__APEX_HUB_SHUTDOWN); task.wait(0.1)
end
if GLOBAL_ENV.__APEX_HUB_RUNNING then return end
GLOBAL_ENV.__APEX_HUB_RUNNING = true

if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local Workspace         = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService        = game:GetService("GuiService")
local CoreGui           = game:GetService("CoreGui")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
pcall(function() LocalPlayer:WaitForChild("PlayerGui", 10) end)

local DISCORD_LINK     = "https://discord.gg/kptjwzKWgX"
local TOGGLE_IMAGE     = "rbxassetid://131679774975668"
local HUB_NAME         = "Apex Hub"
local DISCORD_SUBTITLE = "Discord: " .. DISCORD_LINK

-- ============================================================
-- GAME MODULES
-- ============================================================
local Hub = {}

function Hub.cloneList(source)
    local result = {}
    if type(source) ~= "table" then return result end
    for index = 1, #source do result[index] = source[index] end
    return result
end
function Hub.clearTable(target)
    if type(target) ~= "table" then return end
    for key in pairs(target) do target[key] = nil end
end

local isRunning = true

function Hub.waitFor(timeout, interval, condition)
    local deadline = os.clock() + (tonumber(timeout) or 1)
    local step = tonumber(interval) or 0.05
    local success = false
    repeat
        if condition and condition() == true then success = true
        elseif isRunning and os.clock() < deadline then task.wait(step) end
    until success or (not isRunning) or os.clock() >= deadline
    return success
end

function Hub.requirePath(root, timeout, ...)
    local current = root
    local pathNames = { ... }
    for _, name in ipairs(pathNames) do
        if not current then return nil end
        local child = current:FindFirstChild(name)
        if not child then child = current:WaitForChild(name, timeout or 4) end
        current = child
    end
    if not current then return nil end
    local ok, module = pcall(require, current)
    return ok and module or nil
end
function Hub.findModule(name)
    for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("ModuleScript") and descendant.Name == name then
            local ok, module = pcall(require, descendant)
            if ok then return module end
        end
    end
    return nil
end
function Hub.findRemote(name)
    for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
        if (descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction")) and descendant.Name == name then
            return descendant
        end
    end
    return nil
end
function Hub.findRemoteContains(...)
    local keywords = { ... }
    for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            local allMatch = true
            for _, keyword in ipairs(keywords) do
                if not string.find(descendant.Name, keyword, 1, true) then allMatch = false; break end
            end
            if allMatch then return descendant end
        end
    end
    return nil
end
function Hub.pickFromTable(root, ...)
    if typeof(root) ~= "table" then return nil end
    local keys = { ... }
    local current = root
    for _, key in ipairs(keys) do
        if typeof(current) ~= "table" then return nil end
        current = current[key]
    end
    return current
end
function Hub.pickFn(root, ...)
    if typeof(root) ~= "table" then return nil end
    for index = 1, select("#", ...) do
        local name = select(index, ...)
        local candidate = root[name]
        if typeof(candidate) == "function" then return candidate end
    end
    return nil
end
function Hub.remoteFrom(root, ...)
    local result = Hub.pickFromTable(root, ...)
    if typeof(result) == "Instance" then return result end
    return nil
end

local saveModule            = Hub.requirePath(ReplicatedStorage, 6, "Shared", "Save") or Hub.findModule("Save")
local constantsModule       = Hub.requirePath(ReplicatedStorage, 4, "Shared", "Globals", "Constants") or Hub.findModule("Constants")
local baseUpgradeModule     = Hub.requirePath(ReplicatedStorage, 4, "Client", "BaseUpgrade") or Hub.findModule("BaseUpgrade")
local eggsModule            = Hub.requirePath(ReplicatedStorage, 4, "Shared", "Types", "Eggs") or Hub.findModule("Eggs")
local areasModule           = Hub.requirePath(ReplicatedStorage, 4, "Data", "Areas") or Hub.findModule("Areas")
local assetsModule          = Hub.requirePath(ReplicatedStorage, 4, "Data", "Assets") or Hub.findModule("Assets")
local gearsModule           = Hub.requirePath(ReplicatedStorage, 4, "Data", "Gears") or Hub.findModule("Gears")
local trailsModule          = Hub.requirePath(ReplicatedStorage, 4, "Data", "Trails") or Hub.findModule("Trails")
local treadmillsModule      = Hub.requirePath(ReplicatedStorage, 4, "Data", "Treadmills") or Hub.findModule("Treadmills")
local eggStateModule        = Hub.requirePath(ReplicatedStorage, 6, "Client", "EggState") or Hub.findModule("EggState")
local plotStateModule       = Hub.requirePath(ReplicatedStorage, 6, "Client", "PlotState") or Hub.findModule("PlotState")
local slotIdentityModule    = Hub.requirePath(ReplicatedStorage, 4, "Shared", "Util", "AreaEggSlotIdentity") or Hub.findModule("AreaEggSlotIdentity")
local assetRosterModule     = Hub.requirePath(ReplicatedStorage, 4, "Client", "AssetRoster") or Hub.findModule("AssetRoster")
local assetItemsModule      = Hub.requirePath(ReplicatedStorage, 4, "Shared", "Util", "AssetItems") or Hub.findModule("AssetItems")
local fuseKernelModule      = Hub.requirePath(ReplicatedStorage, 4, "Shared", "Util", "FuseKernel") or Hub.findModule("FuseKernel")
local remotesModule         = Hub.requirePath(ReplicatedStorage, 6, "Shared", "Remotes") or Hub.findModule("Remotes")

local eggApi = {
    GetAreaEggSnapshot = Hub.pickFn(eggStateModule, "ReadFieldEggs", "GetAreaEggSnapshot"),
    RequestAreaEggSnapshot = Hub.pickFn(eggStateModule, "SyncFieldEggs", "RequestAreaEggSnapshot"),
    AreaEggCarryStateChanged = eggStateModule and (eggStateModule.CarryChanged or eggStateModule.AreaEggCarryStateChanged),
    RequestCarryAreaEgg = Hub.pickFn(eggStateModule, "CarryFieldEgg", "RequestCarryAreaEgg"),
    RequestDropHeldAreaEgg = Hub.pickFn(eggStateModule, "DropFieldEgg", "RequestDropHeldAreaEgg"),
    IsLocalEggReady = Hub.pickFn(eggStateModule, "IsReadyToHatch", "IsLocalEggReady"),
    RequestHatchEgg = Hub.pickFn(eggStateModule, "BeginHatch", "RequestHatchEgg"),
    RequestCompleteHatchEgg = Hub.pickFn(eggStateModule, "FinishHatch", "RequestCompleteHatchEgg"),
    RequestEquipTool = Hub.pickFn(eggStateModule, "WearEggTool", "RequestEquipTool"),
    RequestPlaceEgg = Hub.pickFn(eggStateModule, "PlantEgg", "RequestPlaceEgg"),
}
local plotApi = {
    GetRespawnPointCFrame = Hub.pickFn(plotStateModule, "FindRespawnCFrame", "GetRespawnPointCFrame"),
    GetPlotData = Hub.pickFn(plotStateModule, "ResolvePlot", "GetPlotData"),
    IsWorldPositionWithinLocalPlotBounds = Hub.pickFn(plotStateModule, "ContainsLocalPoint", "IsWorldPositionWithinLocalPlotBounds"),
    GetSlotOwner = Hub.pickFn(plotStateModule, "LookupOwner", "GetSlotOwner"),
}
local slotApi = {
    IsFirstAreaUid = Hub.pickFn(slotIdentityModule, "LooksLikeFirstAreaUid", "IsFirstAreaUid"),
    BuildSlotKey = Hub.pickFn(slotIdentityModule, "SlotKey", "BuildSlotKey"),
}
local rosterApi = { GetRuntimeSnapshot = Hub.pickFn(assetRosterModule, "ReadSnapshot", "GetRuntimeSnapshot") }
local assetItemsApi = { Deserialize = Hub.pickFn(assetItemsModule, "Decode", "Deserialize") }
local fuseApi = {
    CanSelectPet = Hub.pickFn(fuseKernelModule, "MayEnterFuse", "CanSelectPet"),
    CalculateFusePrice = Hub.pickFn(fuseKernelModule, "PriceFor", "CalculateFusePrice"),
}

local remotes = {
    Backpack = {
        EQUIP_BEST = Hub.remoteFrom(remotesModule, "Haul", "WearBest")
            or Hub.findRemoteContains("WearBest") or Hub.findRemoteContains("EQUIP_BEST"),
    },
    Plots = {
        REQUEST_BASE_UPGRADE = Hub.remoteFrom(remotesModule, "Homestead", "AskBaseTierRaise")
            or Hub.findRemoteContains("AskBaseTierRaise") or Hub.findRemoteContains("BaseUpgrade"),
    },
    Treadmills = {
        REQUEST_UPGRADE = Hub.remoteFrom(remotesModule, "Treadmill", "AskTierRaise") or Hub.findRemoteContains("AskTierRaise"),
        REQUEST_EQUIP_STATIC = Hub.remoteFrom(remotesModule, "Treadmill", "AskWearStill") or Hub.findRemoteContains("AskWearStill"),
        REQUEST_UNEQUIP = Hub.remoteFrom(remotesModule, "Treadmill", "AskDoff") or Hub.findRemoteContains("AskDoff"),
    },
    Index = { REQUEST_CLAIM_ALL = Hub.remoteFrom(remotesModule, "Codex", "AskRedeemAll") or Hub.findRemoteContains("AskRedeemAll") },
    AssetInventory = {
        SELL_ASSET = Hub.remoteFrom(remotesModule, "PetSatchel", "SellPet")
            or Hub.findRemoteContains("SellPet") or Hub.findRemoteContains("SELL_ASSET"),
    },
    OfflineAssets = {
        GET_SUMMARY = Hub.remoteFrom(remotesModule, "AwayEarnings", "FetchSummary") or Hub.findRemoteContains("FetchSummary"),
        REQUEST_REDEEM = Hub.remoteFrom(remotesModule, "AwayEarnings", "AskCollect") or Hub.findRemoteContains("AskCollect"),
    },
    FuseMachine = {
        COMPLETE_REVEAL = Hub.remoteFrom(remotesModule, "Fusery", "FinishReveal") or Hub.findRemoteContains("FinishReveal"),
        ACKNOWLEDGE_INFO = Hub.remoteFrom(remotesModule, "Fusery", "ConfirmBriefing") or Hub.findRemoteContains("ConfirmBriefing"),
        INSERT_MOB = Hub.remoteFrom(remotesModule, "Fusery", "LoadPet") or Hub.findRemoteContains("LoadPet"),
        START_FUSE = Hub.remoteFrom(remotesModule, "Fusery", "BeginFuse") or Hub.findRemoteContains("BeginFuse"),
    },
    Trails = {
        REQUEST_PURCHASE = Hub.remoteFrom(remotesModule, "Trailwear", "AskPurchase") or Hub.findRemoteContains("AskPurchase"),
        REQUEST_SELECT = Hub.remoteFrom(remotesModule, "Trailwear", "AskChoose") or Hub.findRemoteContains("AskChoose"),
        WORN_SNAPSHOT = Hub.remoteFrom(remotesModule, "Trailwear", "AskWornSnapshot") or Hub.findRemoteContains("AskWornSnapshot"),
    },
    GroupReward = { CLAIM_REWARD = Hub.remoteFrom(remotesModule, "GroupPerk", "RedeemPerk") or Hub.findRemoteContains("RedeemPerk") },
}

local carryEggRemote   = Hub.findRemote("RF/EggWorld/AskFieldEggCarry") or Hub.findRemoteContains("AskFieldEggCarry")
local eggSnapshotRemote = Hub.findRemote("RF/EggWorld/AskFieldEggSnapshot") or Hub.findRemoteContains("AskFieldEggSnapshot")
local placeEggRemote   = Hub.findRemote("RF/EggWorld/AskPlaceEgg") or Hub.findRemoteContains("AskPlaceEgg")

if not eggApi.RequestCarryAreaEgg and carryEggRemote then
    eggApi.RequestCarryAreaEgg = function(eggUid, slotKey)
        if carryEggRemote:IsA("RemoteFunction") then return carryEggRemote:InvokeServer(eggUid, slotKey) end
        carryEggRemote:FireServer(eggUid, slotKey); return true
    end
end
if not eggApi.RequestAreaEggSnapshot and eggSnapshotRemote then
    eggApi.RequestAreaEggSnapshot = function()
        if eggSnapshotRemote:IsA("RemoteFunction") then return eggSnapshotRemote:InvokeServer() end
        eggSnapshotRemote:FireServer()
    end
end
if not eggApi.RequestPlaceEgg and placeEggRemote then
    eggApi.RequestPlaceEgg = function(eggUid, cframe)
        if placeEggRemote:IsA("RemoteFunction") then return placeEggRemote:InvokeServer(eggUid, cframe) end
        placeEggRemote:FireServer(eggUid, cframe); return true
    end
end

-- ============================================================
-- CONSTANTS
-- ============================================================
local RARITY_NAMES = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine" }
local RARITY_RANK = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10,
}
local MUTATION_NAMES = { "Golden", "Rainbow", "Silver" }
local STEAL_PRIORITY_OPTIONS = { "Rarest", "Nearest", "Furthest", "Biggest Size" }
local FUSE_TARGET_OPTIONS = { "Highest Rarity", "Lowest Rarity", "Most Duplicates" }
local UPGRADE_TYPES = { "Base", "Treadmill" }
local TASK_NAMES = { "Auto Steal Egg", "Auto Place Egg", "Auto Hatch", "Auto Treadmill" }
local PRIORITY_SLOTS = { "PrioritySlot1", "PrioritySlot2", "PrioritySlot3", "PrioritySlot4" }
local HOP_MODE_OPTIONS = { "No Matching Eggs", "Timed Interval", "After Steal Count" }
local FALLBACK_AREAS = { "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic" }

local areaList = {}
if areasModule and typeof(areasModule.Directory) == "table" then
    for areaName in pairs(areasModule.Directory) do table.insert(areaList, areaName) end
    table.sort(areaList)
else
    areaList = Hub.cloneList(FALLBACK_AREAS)
end

local trailNames, trailIdByName, trailPriceByName = {}, {}, {}
if trailsModule and typeof(trailsModule.Directory) == "table" then
    local trailEntries = {}
    for id, data in pairs(trailsModule.Directory) do
        table.insert(trailEntries, { id = id, name = data.DisplayName, price = tonumber(data.Price) or 0 })
    end
    table.sort(trailEntries, function(left, right) return left.price < right.price end)
    for _, entry in ipairs(trailEntries) do
        table.insert(trailNames, entry.name)
        trailIdByName[entry.name] = entry.id
        trailPriceByName[entry.name] = entry.price
    end
end

local gearPriceByName = {}
if gearsModule then
    local gearDirectory = gearsModule.Directory or gearsModule
    if typeof(gearDirectory) == "table" then
        for _, gearData in pairs(gearDirectory) do
            if typeof(gearData) == "table" and typeof(gearData.DisplayName) == "string" then
                gearPriceByName[gearData.DisplayName] = tonumber(gearData.MoneyCost) or 0
            end
        end
    end
end

-- ============================================================
-- STATE / TUNABLES
-- ============================================================
local MAX_SPEED            = 2000
local STEAL_SPEED_DEFAULT  = 700
local BYPASS_SPEED_DEFAULT = 800

local function clampReturnSpeed(value)
    return math.clamp(tonumber(value) or BYPASS_SPEED_DEFAULT, 16, MAX_SPEED)
end

local ARRIVE_TOLERANCE = 4
local HOLD_DURATION = 3
local STEAL_MOVEMENT = { GrabDelay = 0.55, ReturnPace = 0.12, ArriveDistance = 1.35, MoveTimeout = 14 }

local trackedConnections = {}
local jobId = tostring(game.JobId)
local jobIdLabel = jobId
if #jobIdLabel > 18 then jobIdLabel = string.sub(jobIdLabel, 1, 18) .. "..." end

local carryingEgg = false
local stolenEggs = 0
local eggCarryWebhook = nil
local taskBusy = false
local taskLastRunAt = {}
local treadmillTraining = false
local isHopping = false
local hopCooldownUntil = 0
local eggCheckCountdown = 0
local hopIntervalStart = os.clock()
local lastTeleportError = nil
local lastEquipBestAt = 0
local nextPlaceSlotIndex = 1
local plotFullUntil = 0
local lastInputTick = tick()
local lastAntiAfkJumpTick = tick()
local disconnectHandled = false
local renderingDisabled = false
local fpsBoostSavedSettings = nil
local fpsEffectWatcher = nil
local fpsCapUnavailable = false
local scriptStartTime = os.clock()
local lastWebhookSentAt = os.clock()
local knownEggUids, knownInventoryUids = {}, {}
local webhookBaselineReady = false
local lastRebirthCount = nil
local lastStolenEggCount = 0
local sessionEggsStolen, sessionPetsObtained, sessionRebirths = 0, 0, 0
local eggSpawnQueue, stolenEggLog = {}, {}
local espObjects, espDrawnKeys = {}, {}

local hopHistory = {}
if getgenv then
    local existingHistory = getgenv().ApexHubHopHistory
    if typeof(existingHistory) ~= "table" then existingHistory = {}; getgenv().ApexHubHopHistory = existingHistory end
    hopHistory = existingHistory
end

local areasFolder = Workspace:FindFirstChild("__OBJECTS") and Workspace.__OBJECTS:FindFirstChild("Areas")
if not areasFolder then
    local objects = Workspace:WaitForChild("__OBJECTS", 8)
    areasFolder = objects and objects:WaitForChild("Areas", 8)
end
local guardAreasFolder = areasFolder and areasFolder:FindFirstChild("GuardAreas")
if areasFolder and not guardAreasFolder then guardAreasFolder = areasFolder:WaitForChild("GuardAreas", 6) end

local areaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")
if not areaEggSlotsClient then areaEggSlotsClient = Workspace:WaitForChild("AreaEggSlotsClient", 10) end

local espFolder = Instance.new("Folder")
espFolder.Name = "ApexEggEsp"
espFolder.Parent = Workspace

function Hub.track(connection) table.insert(trackedConnections, connection); return connection end

-- ============================================================
-- ANTI-KICK HELPERS
-- ============================================================
local function jitterOffset(magnitude)
    local spread = magnitude or 0.15
    return Vector3.new(
        (math.random() - 0.5) * spread,
        0,
        (math.random() - 0.5) * spread
    )
end

local lastCframeSetTime = 0
local ANTI_KICK_INTERVAL = 1 / 45
local function setCframeSafely(part, cframe)
    if not part or not cframe then return end
    local now = os.clock()
    if now - lastCframeSetTime < ANTI_KICK_INTERVAL then return end
    lastCframeSetTime = now
    pcall(function() part.CFrame = cframe end)
end

-- ============================================================
-- GAME HELPERS
-- ============================================================
function Hub.getHumanoid()
    local character = LocalPlayer.Character
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end
function Hub.getRoot()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart") or nil
end
function Hub.getSave()
    if not saveModule or typeof(saveModule.Get) ~= "function" then return nil end
    local ok, data = pcall(saveModule.Get)
    return ok and data or nil
end
function Hub.netInvoke(remote, ...)
    if typeof(remote) ~= "Instance" then return nil end
    local args = table.pack(...)
    local result, done = nil, false
    task.spawn(function()
        if remote:IsA("RemoteFunction") then
            result = table.pack(pcall(function() return remote:InvokeServer(table.unpack(args, 1, args.n)) end))
        elseif remote:IsA("RemoteEvent") then
            result = table.pack(pcall(function() remote:FireServer(table.unpack(args, 1, args.n)); return true end))
        else result = table.pack(false) end
        done = true
    end)
    Hub.waitFor(8, 0.05, function() return done == true end)
    if not done or result[1] ~= true then return nil end
    return result[2], result[3]
end
function Hub.netCall(remote, ...)
    if typeof(remote) == "Instance" and remote:IsA("RemoteEvent") then
        return pcall(function(...) remote:FireServer(...) end, ...)
    end
    return Hub.netInvoke(remote, ...)
end
function Hub.countTable(target)
    if typeof(target) ~= "table" then return 0 end
    local count = 0
    for _ in pairs(target) do count = count + 1 end
    return count
end
function Hub.formatNumber(value)
    local amount = tonumber(value) or 0
    local suffixes = { "", "K", "M", "B", "T", "Qa", "Qi" }
    local suffixIndex = 1
    for _ = 1, 6 do
        if amount >= 1000 then amount = amount / 1000; suffixIndex = suffixIndex + 1 end
    end
    if suffixIndex == 1 then return string.format("%d", amount) end
    return string.format("%.2f%s", amount, suffixes[suffixIndex])
end
function Hub.formatElapsed(seconds)
    local totalSeconds = math.max(0, math.floor(seconds))
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    if hours > 0 then return string.format("%dh %dm", hours, minutes) end
    return string.format("%dm", minutes)
end
function Hub.resolveRarity(category)
    if typeof(category) ~= "string" or not assetsModule or typeof(assetsModule.Directory) ~= "table" then return nil end
    local asset = assetsModule.Directory[category]
    local rarity = asset and asset.Rarity
    if not rarity then return nil end
    return rarity._id or rarity.DisplayName
end
function Hub.assetName(category)
    if assetsModule and typeof(assetsModule.Directory) == "table" then
        local asset = assetsModule.Directory[category or ""]
        if asset and asset.DisplayName then return asset.DisplayName end
    end
    return tostring(category or "Unknown")
end
function Hub.recordMutations(asset)
    local mutations = {}
    if typeof(asset) ~= "table" then return mutations end
    if typeof(asset.Mutations) == "table" then
        for _, mutation in pairs(asset.Mutations) do
            if typeof(mutation) == "string" then table.insert(mutations, mutation) end
        end
    end
    if typeof(asset.BaseMutation) == "string" then table.insert(mutations, asset.BaseMutation) end
    return mutations
end
function Hub.getLaneZ()
    if areasFolder then
        local gameplayBound = areasFolder:FindFirstChild("GameplayZ")
        if gameplayBound and gameplayBound:IsA("BasePart") then return gameplayBound.Position.Z end
        local separationLine = areasFolder:FindFirstChild("SeparationLine")
        if separationLine and separationLine:IsA("BasePart") then return separationLine.Position.Z end
    end
    return -365.5
end
function Hub.getLaneY()
    if areasFolder then
        local gameplayBound = areasFolder:FindFirstChild("GameplayZ")
        if gameplayBound and gameplayBound:IsA("BasePart") then return gameplayBound.Position.Y + 3 end
    end
    local root = Hub.getRoot()
    return root and root.Position.Y or 70
end
function Hub.getEntryPosition()
    if areasFolder then
        local startArea = areasFolder:FindFirstChild("StartArea")
        if startArea and startArea:IsA("BasePart") then return Vector3.new(startArea.Position.X, Hub.getLaneY(), Hub.getLaneZ()) end
        local separationLine = areasFolder:FindFirstChild("SeparationLine")
        if separationLine and separationLine:IsA("BasePart") then return Vector3.new(separationLine.Position.X, Hub.getLaneY(), Hub.getLaneZ()) end
    end
    return Vector3.new(543.5, Hub.getLaneY(), Hub.getLaneZ())
end
function Hub.getZoneModel(zoneId) return guardAreasFolder and guardAreasFolder:FindFirstChild(zoneId) end
function Hub.getZoneLaneCenter(zoneId)
    local zoneModel = Hub.getZoneModel(zoneId)
    if not zoneModel then return nil end
    local bounds = zoneModel:FindFirstChild("Bounds")
    if bounds and bounds:IsA("BasePart") then return Vector3.new(bounds.Position.X, Hub.getLaneY(), Hub.getLaneZ()) end
    local ok, boundingBox = pcall(function() return zoneModel:GetBoundingBox() end)
    if ok and boundingBox then return Vector3.new(boundingBox.Position.X, Hub.getLaneY(), Hub.getLaneZ()) end
    return nil
end
function Hub.stripCheatMovers(root)
    if not root then return end
    for _, child in ipairs(root:GetChildren()) do
        local className = child.ClassName
        if className == "BodyVelocity" or className == "BodyPosition" or className == "BodyGyro"
            or className == "BodyAngularVelocity" or className == "LinearVelocity"
            or className == "VectorForce" or className == "AlignOrientation" then
            pcall(function() child:Destroy() end)
        end
    end
end
function Hub.stopSoftMove(root)
    if not root then return end
    for _, child in ipairs(root:GetChildren()) do
        if child:IsA("AlignPosition") then pcall(function() child.Enabled = false; child:Destroy() end) end
    end
end
function Hub.placeRoot(root, cframe)
    if not root or not cframe then return end
    Hub.stopSoftMove(root); Hub.stripCheatMovers(root)
    local character = LocalPlayer.Character
    if character and character.Parent then
        pcall(function() character:PivotTo(cframe) end)
    else
        setCframeSafely(root, cframe)
    end
end
function Hub.teleportTo(target)
    if typeof(target) ~= "Vector3" or not isRunning then return false end
    local root = Hub.getRoot()
    if not root then return false end
    local groundedY = Hub.groundedY(target.X, target.Z, target.Y)
    Hub.placeRoot(root, CFrame.new(target.X, groundedY, target.Z))
    return true
end
function Hub.groundedY(x, z, fallbackY)
    local laneY = Hub.getLaneY()
    local root = Hub.getRoot()
    local humanoid = Hub.getHumanoid()
    local hipOffset = 2
    if humanoid and humanoid.HipHeight > 0 then hipOffset = humanoid.HipHeight end
    local rootHalfExtent = root and root.Size.Y * 0.5 or 1
    local standOffset = hipOffset + rootHalfExtent
    local groundCeiling = laneY + 1.5
    local ignored = {}
    if LocalPlayer.Character then table.insert(ignored, LocalPlayer.Character) end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local startY = laneY + 40
    local groundY = nil
    for _ = 1, 20 do
        rayParams.FilterDescendantsInstances = ignored
        local hit = Workspace:Raycast(Vector3.new(x, startY, z), Vector3.new(0, -160, 0), rayParams)
        if not hit then break end
        local hitY = hit.Position.Y
        local hitName = hit.Instance.Name
        local isGround = hitName == "Ground" or string.find(string.lower(hitName), "ground", 1, true) ~= nil
        if isGround or hitY <= groundCeiling then groundY = hitY; break end
        table.insert(ignored, hit.Instance)
    end
    if groundY then return math.clamp(groundY + standOffset, laneY - 2, laneY + 5) end
    if typeof(fallbackY) == "number" then return math.clamp(fallbackY, laneY - 2, laneY + 5) end
    return laneY + 3
end

-- ============================================================
-- STEAL / BYPASS SPEED
-- ============================================================
function Hub.stealSpeed()
    local optionSpeed = tonumber(Hub.optionValue("StealMoveSpeed", STEAL_SPEED_DEFAULT)) or STEAL_SPEED_DEFAULT
    return math.clamp(optionSpeed, 16, MAX_SPEED)
end
function Hub.bypassSpeed()
    local optionSpeed = tonumber(Hub.optionValue("BypassReturnSpeed", BYPASS_SPEED_DEFAULT)) or BYPASS_SPEED_DEFAULT
    return clampReturnSpeed(optionSpeed)
end

function Hub.swapStealHumanoid()
    local character = LocalPlayer.Character
    if not character then return false end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("LocalScript") and string.find(descendant.Name, "PushBack") then
            pcall(function() descendant.Disabled = true; descendant:Destroy() end)
        end
    end
    return true
end

function Hub.prepareStealHumanoid()
    local character = LocalPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end

    local camera = Workspace.CurrentCamera
    local cameraFrame = camera and camera.CFrame or nil

    local swapHumanoid = nil
    local ok, clone = pcall(function()
        humanoid.Archivable = true
        return humanoid:Clone()
    end)

    if ok and clone then
        swapHumanoid = clone
        swapHumanoid.Parent = character
        RunService.Heartbeat:Wait()
        pcall(function()
            if humanoid and humanoid.Parent then humanoid:Destroy() end
        end)
    else
        swapHumanoid = humanoid
    end

    task.wait(0.1)

    swapHumanoid = character:FindFirstChildOfClass("Humanoid") or swapHumanoid
    if swapHumanoid then
        swapHumanoid.Sit = false
        swapHumanoid.PlatformStand = false
        swapHumanoid.WalkSpeed = Hub.stealSpeed()
        swapHumanoid.AutoRotate = true
    end

    if camera and swapHumanoid then
        pcall(function()
            camera.CameraSubject = swapHumanoid
            if cameraFrame then camera.CFrame = cameraFrame end
        end)
    end

    return swapHumanoid
end

function Hub.buildStealPath(from, to)
    local laneZ, laneY = Hub.getLaneZ(), Hub.getLaneY()
    local path = {}
    if math.abs(from.Z - laneZ) > 3 then table.insert(path, Vector3.new(from.X, laneY, laneZ)) end
    if math.abs(from.X - to.X) > 2 then table.insert(path, Vector3.new(to.X, laneY, laneZ)) end
    table.insert(path, Vector3.new(to.X, laneY, to.Z))
    return path
end

function Hub.humanoidStealMoveTo(target, cancel)
    if typeof(target) ~= "Vector3" or not isRunning then return false end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = Hub.getRoot()
    if not humanoid or not root then return false end

    humanoid.Sit = false
    humanoid.PlatformStand = false
    humanoid.AutoRotate = true
    humanoid.WalkSpeed = Hub.stealSpeed()

    local groundedY = Hub.groundedY(target.X, target.Z, root.Position.Y)
    local dest = Vector3.new(target.X, groundedY, target.Z)
    if (root.Position - dest).Magnitude <= STEAL_MOVEMENT.ArriveDistance then return true end

    local path = Hub.buildStealPath(root.Position, dest)
    if #path == 0 then path = { dest } end

    local heartbeatCount = 0
    for _, point in ipairs(path) do
        if not isRunning or (cancel and not cancel()) then return false end
        root = Hub.getRoot(); if not root then return false end
        local pointY = Hub.groundedY(point.X, point.Z, root.Position.Y)
        local stopPoint = Vector3.new(point.X, pointY, point.Z)
        local deadline = os.clock() + STEAL_MOVEMENT.MoveTimeout

        while isRunning and os.clock() < deadline do
            if cancel and not cancel() then return false end
            root = Hub.getRoot(); if not root then return false end
            local delta = stopPoint - root.Position
            local distance = delta.Magnitude
            if distance <= STEAL_MOVEMENT.ArriveDistance then break end

            local direction = delta.Unit
            local frameTime = math.clamp(RunService.Heartbeat:Wait(), 0, 1 / 30)
            local step = math.min(Hub.stealSpeed() * frameTime, distance)
            local nextPosition = root.Position + direction * step + jitterOffset(0.1)

            local lookDirection = Vector3.new(direction.X, 0, direction.Z)
            local lookFrame
            if lookDirection.Magnitude > 0.001 then
                lookFrame = CFrame.lookAt(nextPosition, nextPosition + lookDirection.Unit)
            else
                lookFrame = CFrame.new(nextPosition)
            end
            setCframeSafely(root, lookFrame)

            heartbeatCount = heartbeatCount + 1
            if heartbeatCount % 4 == 0 then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end

    root = Hub.getRoot(); if not root then return false end
    Hub.placeRoot(root, CFrame.new(dest))
    return (root.Position - dest).Magnitude <= math.max(3, STEAL_MOVEMENT.ArriveDistance + 1)
end

function Hub.stealMoveTo(x, z, cancel)
    local root = Hub.getRoot(); if not root then return false end
    local groundedY = Hub.groundedY(x, z, root.Position.Y)
    return Hub.humanoidStealMoveTo(Vector3.new(x, groundedY, z), cancel)
end
function Hub.stealAlong(points, cancel)
    for _, point in ipairs(points) do
        if cancel and not cancel() then return false end
        if not Hub.stealMoveTo(point.X, point.Z, cancel) then return false end
    end
    return true
end
function Hub.getBasePosition()
    if plotApi.GetRespawnPointCFrame then
        local point = plotApi.GetRespawnPointCFrame()
        if point then return point.Position end
    end
    if not plotApi.GetPlotData then return nil end
    local plotData = plotApi.GetPlotData()
    if not plotData then return nil end
    if plotData.CenterPoint then return plotData.CenterPoint.Position end
    if plotData.PetArea then return plotData.PetArea.Position end
    return nil
end
function Hub.getPetAreaStandPosition()
    if plotApi.GetPlotData then
        local plotData = plotApi.GetPlotData()
        if plotData and plotData.PetArea then return plotData.PetArea.Position + Vector3.new(0, 4, 0) end
    end
    return Hub.getBasePosition()
end
function Hub.isNearPlot()
    local root = Hub.getRoot(); if not root then return false end
    if plotApi.IsWorldPositionWithinLocalPlotBounds and plotApi.IsWorldPositionWithinLocalPlotBounds(root.Position) then return true end
    local standPosition = Hub.getPetAreaStandPosition()
    return standPosition ~= nil and (root.Position - standPosition).Magnitude <= 30
end

function Hub.bypassMoveTo(target, cancel, speed)
    if typeof(target) ~= "Vector3" or not isRunning then return false end
    speed = clampReturnSpeed(speed or Hub.bypassSpeed())
    local root = Hub.getRoot(); if not root then return false end

    Hub.stripCheatMovers(root); Hub.stopSoftMove(root)
    local humanoid = Hub.getHumanoid()
    if humanoid then
        humanoid.Sit = false
        humanoid.PlatformStand = true
    end

    local groundedY = Hub.groundedY(target.X, target.Z, root.Position.Y)
    local dest = Vector3.new(target.X, groundedY, target.Z)
    if (root.Position - dest).Magnitude <= ARRIVE_TOLERANCE then
        if humanoid then humanoid.PlatformStand = false end
        return true
    end

    local velocity = Instance.new("BodyVelocity")
    velocity.Name = "ApexBypassMove"
    velocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    velocity.P = 1250
    velocity.Velocity = Vector3.zero
    velocity.Parent = root

    local gyro = Instance.new("BodyGyro")
    gyro.Name = "ApexBypassGyro"
    gyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    gyro.P = 3000
    gyro.D = 50
    gyro.CFrame = root.CFrame
    gyro.Parent = root

    local arrived, deadline = false, os.clock() + 15
    while isRunning and os.clock() < deadline do
        if cancel and not cancel() then break end
        root = Hub.getRoot(); if not root then break end
        local delta = dest - root.Position
        local distance = delta.Magnitude
        if distance <= ARRIVE_TOLERANCE then arrived = true; break end
        local direction = delta.Unit
        velocity.Velocity = direction * speed
        local lookDirection = Vector3.new(direction.X, 0, direction.Z)
        if lookDirection.Magnitude > 0.001 then
            gyro.CFrame = CFrame.lookAt(root.Position, root.Position + lookDirection.Unit)
        end
        RunService.Heartbeat:Wait()
    end

    if velocity and velocity.Parent then velocity:Destroy() end
    if gyro and gyro.Parent then gyro:Destroy() end

    root = Hub.getRoot()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if arrived then Hub.placeRoot(root, CFrame.new(dest.X, groundedY, dest.Z)) end
    end
    humanoid = Hub.getHumanoid()
    if humanoid then humanoid.PlatformStand = false end
    return arrived
end

-- ============================================================
-- HOLD 3s: ĐỨNG CHẶT (Anchored). Hết 3s -> nhả anchor dứt khoát
-- ============================================================
function Hub.holdAtPosition(duration, cancel)
    duration = tonumber(duration) or HOLD_DURATION
    local root = Hub.getRoot(); if not root then return false end
    local holdFrame = root.CFrame

    pcall(function() root.Anchored = true end)

    local deadline = os.clock() + duration
    while isRunning and os.clock() < deadline do
        if cancel and not cancel() then break end
        root = Hub.getRoot()
        if root then
            root.AssemblyLinearVelocity  = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            pcall(function() root.CFrame = holdFrame end)
            pcall(function() root.Anchored = true end)
        end
        RunService.Heartbeat:Wait()
    end

    root = Hub.getRoot()
    if root then
        pcall(function() root.Anchored = false end)
        root.AssemblyLinearVelocity  = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    return true
end

function Hub.returnToBaseBypass(cancel)
    local basePosition = Hub.getBasePosition()
    if not basePosition then return false end
    if cancel and not cancel() then return false end
    return Hub.bypassMoveTo(Vector3.new(basePosition.X, basePosition.Y + 3, basePosition.Z), cancel, Hub.bypassSpeed())
end
function Hub.returnToBase(cancel) return Hub.returnToBaseBypass(cancel) end
function Hub.ensureAtPlot(cancel)
    if cancel and not cancel() then return false end
    if Hub.isNearPlot() then return true end
    local standPosition = Hub.getPetAreaStandPosition()
    if not standPosition then return false end
    return Hub.bypassMoveTo(standPosition, cancel, Hub.bypassSpeed())
end

-- ============================================================
-- EGG / STEAL
-- ============================================================
function Hub.getAreaEggs()
    if not eggApi.GetAreaEggSnapshot then return {} end
    local snapshot = eggApi.GetAreaEggSnapshot()
    if typeof(snapshot) ~= "table" or typeof(snapshot.Records) ~= "table" then
        if eggApi.RequestAreaEggSnapshot then pcall(eggApi.RequestAreaEggSnapshot) end
        snapshot = eggApi.GetAreaEggSnapshot()
    end
    if typeof(snapshot) ~= "table" or typeof(snapshot.Records) ~= "table" then return {} end
    local records = {}
    for _, record in pairs(snapshot.Records) do
        if typeof(record) == "table" and typeof(record.Uid) == "string" then table.insert(records, record) end
    end
    return records
end
function Hub.findAreaEggRecord(uid)
    for _, record in ipairs(Hub.getAreaEggs()) do if record.Uid == uid then return record end end
    return nil
end
function Hub.getSlotEggPosition(eggSlot)
    local hitPart = eggSlot:FindFirstChild("Hitbox")
        or eggSlot:FindFirstChild("CustomBoundingBox")
        or eggSlot:FindFirstChildOfClass("BasePart")
    if hitPart then return hitPart.Position end
    return eggSlot:GetPivot().Position
end
function Hub.isBigEgg(record)
    if not Hub.isOn("StealBigEggs") then return false end
    local scale = tonumber(record.AssetScale)
    if not scale then return false end
    return scale >= (tonumber(Hub.optionValue("StealBigEggScale", 1.5)) or 1.5)
end
function Hub.eggScore(record) return RARITY_RANK[Hub.resolveRarity(record.AssetCategory) or "Common"] or 0 end
function Hub.isStealCandidate(record, allowAll)
    if typeof(record) ~= "table" or typeof(record.Uid) ~= "string" then return false end
    if record.State ~= "Slot" and record.State ~= "Dropped" then return false end
    if allowAll then return true end
    if Hub.isBigEgg(record) and Hub.selectionAllows("StealZones", record.AreaId) then return true end
    if not Hub.isOn("AutoStealSelected") then return false end
    return Hub.matchesEggFilters(record, "StealZones", "StealRarities", "StealMutations")
end
function Hub.pickStealTarget()
    local eggSlots = areaEggSlotsClient and areaEggSlotsClient:GetChildren() or {}
    if #eggSlots == 0 then return nil end
    local recordBySlot = {}
    for _, record in ipairs(Hub.getAreaEggs()) do
        if typeof(record.Uid) == "string" then recordBySlot[record.Uid] = record end
    end
    local allowAll = Hub.isOn("AutoStealAll") and not Hub.isOn("AutoStealSelected")
    local root = Hub.getRoot()
    local priorityMode = Hub.optionValue("StealPriority", "Rarest")
    local bestSlot, bestScore = nil, -math.huge
    for _, eggSlot in ipairs(eggSlots) do
        local record = recordBySlot[eggSlot.Name]
        local eligible = record and Hub.isStealCandidate(record, allowAll) or (record == nil and allowAll)
        if eligible then
            local slotPosition = Hub.getSlotEggPosition(eggSlot)
            local distance = root and slotPosition and (root.Position - slotPosition).Magnitude or math.huge
            local score
            if priorityMode == "Nearest" then score = -distance
            elseif priorityMode == "Furthest" then score = distance
            elseif priorityMode == "Biggest Size" then score = tonumber(record and record.AssetScale) or 0
            else score = (record and Hub.eggScore(record) or 0) * 100000 - math.min(distance, 99999) end
            if score > bestScore then bestSlot = eggSlot; bestScore = score end
        end
    end
    return bestSlot
end
function Hub.stealingEnabled() return Hub.isOn("AutoStealSelected") or Hub.isOn("AutoStealAll") or Hub.isOn("StealBigEggs") end
function Hub.eggInventoryCount()
    local save = Hub.getSave()
    local inventory = save and save.EggInventory
    if typeof(inventory) ~= "table" then return 0 end
    return Hub.countTable(inventory)
end
function Hub.eggInventoryFull()
    local maxInventory = eggsModule and tonumber(eggsModule.MAX_INVENTORY) or math.huge
    return Hub.eggInventoryCount() >= maxInventory
end
function Hub.canAutoSteal() return Hub.stealingEnabled() and not carryingEgg and not Hub.eggInventoryFull() end
function Hub.tryCarryEgg(eggSlot)
    if not eggSlot or not eggApi.RequestCarryAreaEgg then return false end
    local uid = eggSlot.Name
    local slotKey = nil
    if slotApi.IsFirstAreaUid and slotApi.IsFirstAreaUid(uid) then
        for _, record in ipairs(Hub.getAreaEggs()) do
            if record.Uid == uid and slotApi.BuildSlotKey then
                slotKey = slotApi.BuildSlotKey(record.AreaId, record.NestId)
                break
            end
        end
    end
    local ok, result = pcall(function() return eggApi.RequestCarryAreaEgg(uid, slotKey) end)
    if ok and result == true then return true end
    return carryingEgg
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
function Hub.stealEgg(targetSlot)
    Hub.swapStealHumanoid()
    if not Hub.prepareStealHumanoid() then return false end

    local targetPosition = Hub.getSlotEggPosition(targetSlot)
    local root = Hub.getRoot()
    if not root or not targetPosition then return false end

    -- 1) Đi tới target
    if Hub.isOn("StealByTeleport") then
        if not Hub.teleportTo(targetPosition) then return false end
    elseif not Hub.stealAlong(Hub.buildStealPath(root.Position, targetPosition), Hub.stealingEnabled) then
        return false
    end

    root = Hub.getRoot()
    if root then
        local groundedY = Hub.groundedY(targetPosition.X, targetPosition.Z, targetPosition.Y)
        Hub.placeRoot(root, CFrame.new(targetPosition.X, groundedY, targetPosition.Z))
    end

    if not Hub.stealingEnabled() then return false end

    -- 2) Nhặt lần 1
    Hub.waitFor(STEAL_MOVEMENT.GrabDelay, 0.04, function()
        root = Hub.getRoot()
        if root then
            local groundedY = Hub.groundedY(targetPosition.X, targetPosition.Z, targetPosition.Y)
            Hub.placeRoot(root, CFrame.new(targetPosition.X, groundedY, targetPosition.Z))
        end
        if not Hub.stealingEnabled() then return true end
        if not carryingEgg then Hub.tryCarryEgg(targetSlot) end
        return carryingEgg == true
    end)

    local carryDeadline = os.clock() + 2.5
    while isRunning and Hub.stealingEnabled() and not carryingEgg and os.clock() < carryDeadline do
        root = Hub.getRoot()
        if root then
            local groundedY = Hub.groundedY(targetPosition.X, targetPosition.Z, targetPosition.Y)
            Hub.placeRoot(root, CFrame.new(targetPosition.X, groundedY, targetPosition.Z))
        end
        Hub.tryCarryEgg(targetSlot)
        if carryingEgg then break end
        task.wait(0.05)
    end

    if not carryingEgg then return false end

    -- 3) Đứng chặt 3s (Anchored + zero velocity)
    do
        local holdRoot = Hub.getRoot()
        if holdRoot then
            pcall(function() holdRoot.Anchored = true end)
            holdRoot.AssemblyLinearVelocity  = Vector3.zero
            holdRoot.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end
    Hub.holdAtPosition(HOLD_DURATION, Hub.stealingEnabled)

    -- 4) Hết 3s -> không còn đứng chặt (Anchored đã nhả trong holdAtPosition)
    if not isRunning or not Hub.stealingEnabled() then return false end

    -- Nhặt lần 2
    if not carryingEgg then Hub.tryCarryEgg(targetSlot); task.wait(0.1) end
    local confirmDeadline = os.clock() + 1.5
    while isRunning and Hub.stealingEnabled() and not carryingEgg and os.clock() < confirmDeadline do
        Hub.tryCarryEgg(targetSlot); task.wait(0.05)
    end

    -- 5) Về base (bypass hoặc teleport)
    if Hub.isOn("StealByTeleport") then
        local basePosition = Hub.getBasePosition()
        if basePosition then Hub.teleportTo(basePosition) end
    else
        Hub.returnToBaseBypass(Hub.stealingEnabled)
    end

    -- 6) Confirm vòng hoàn tất
    local returnDeadline = os.clock() + 3
    while isRunning and Hub.stealingEnabled() and carryingEgg and os.clock() < returnDeadline do
        task.wait(0.1)
    end
    return true
end

function Hub.runAutoSteal()
    if carryingEgg or Hub.eggInventoryFull() then return false end
    local targetSlot = Hub.pickStealTarget()
    if not targetSlot then return false end
    return Hub.stealEgg(targetSlot)
end
function Hub.runAutoDropEgg()
    if not carryingEgg then return false end
    if eggApi.RequestDropHeldAreaEgg then return pcall(function() eggApi.RequestDropHeldAreaEgg("PlayerRequest") end) end
    return false
end
function Hub.runAutoReturn()
    if not carryingEgg then return false end
    local cancel = function() return Hub.isOn("AutoReturn") and carryingEgg end
    if Hub.isOn("StealByTeleport") then
        local basePosition = Hub.getBasePosition()
        if not basePosition then return false end
        Hub.teleportTo(basePosition)
    elseif not Hub.returnToBaseBypass(cancel) then return false end
    local root = Hub.getRoot()
    if root and plotApi.IsWorldPositionWithinLocalPlotBounds and plotApi.IsWorldPositionWithinLocalPlotBounds(root.Position) then
        Hub.waitFor(4, 0.15, function() return (not carryingEgg) or (not Hub.isOn("AutoReturn")) end)
    end
    return true
end

if eggApi.AreaEggCarryStateChanged and typeof(eggApi.AreaEggCarryStateChanged.Connect) == "function" then
    Hub.track(eggApi.AreaEggCarryStateChanged:Connect(function(payload)
        local isCarrying = typeof(payload) == "table" and payload.IsCarrying == true
        local earned = isCarrying and not carryingEgg
        if earned then
            stolenEggs = stolenEggs + 1
            if eggCarryWebhook then eggCarryWebhook(payload) end
        end
        carryingEgg = isCarrying
    end))
end

-- ============================================================
-- PLACE / HATCH / SELL / FUSE / UPGRADE
-- ============================================================
function Hub.getUnplacedEggUids()
    local save = Hub.getSave()
    local inventory = save and save.EggInventory
    local uids = {}
    if typeof(inventory) ~= "table" then return uids end
    local placeAll = Hub.isOn("AutoPlaceAll") and not Hub.isOn("AutoPlaceSelected")
    for uid, egg in pairs(inventory) do
        if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement == nil
            and (placeAll or Hub.matchesEggFilters(egg, nil, "LifecycleRarities", "LifecycleMutations")) then
            table.insert(uids, uid)
        end
    end
    return uids
end
function Hub.placingEnabled() return Hub.isOn("AutoPlaceSelected") or Hub.isOn("AutoPlaceAll") end
function Hub.isPlotFull() return os.clock() < plotFullUntil end
function Hub.markPlotFull() plotFullUntil = os.clock() + 30 end
function Hub.getPlacementLocalCFrames()
    if not plotApi.GetPlotData then return {} end
    local plotData = plotApi.GetPlotData()
    if not plotData or not plotData.PetArea or not plotData.CenterPoint then return {} end
    local petArea, centerPoint = plotData.PetArea, plotData.CenterPoint
    local areaSize = petArea.Size
    local localCFrames = {}
    for x = -areaSize.X * 0.5 + 5, areaSize.X * 0.5 - 5, 7 do
        for z = -areaSize.Z * 0.5 + 5, areaSize.Z * 0.5 - 5, 7 do
            local worldPosition = petArea.CFrame:PointToWorldSpace(Vector3.new(x, 1, z))
            table.insert(localCFrames, centerPoint.CFrame:ToObjectSpace(CFrame.new(worldPosition)))
        end
    end
    return localCFrames
end
function Hub.canAutoPlace()
    return Hub.placingEnabled() and not carryingEgg and not Hub.isPlotFull() and #Hub.getUnplacedEggUids() > 0
end
function Hub.runAutoPlaceEggs(force)
    if carryingEgg or not eggApi.RequestPlaceEgg then return end
    local function cancel() return (force == true or Hub.placingEnabled()) and not carryingEgg end
    local uids = Hub.getUnplacedEggUids()
    if #uids == 0 or not Hub.ensureAtPlot(cancel) then return end
    local localCFrames = Hub.getPlacementLocalCFrames()
    if #localCFrames == 0 then return end
    local placedAny = false
    for _, uid in ipairs(uids) do
        if not isRunning or not cancel() then return placedAny end
        if not Hub.isNearPlot() and not Hub.ensureAtPlot(cancel) then return placedAny end
        if eggApi.RequestEquipTool then pcall(eggApi.RequestEquipTool, uid) end
        task.wait(0.15)
        local placed = false
        for offset = 0, #localCFrames - 1 do
            local index = (nextPlaceSlotIndex + offset - 1) % #localCFrames + 1
            local ok = false
            pcall(function() ok = eggApi.RequestPlaceEgg(uid, localCFrames[index]) == true end)
            if ok then
                nextPlaceSlotIndex = index + 1
                placed = true; placedAny = true
                task.wait(0.25); break
            end
        end
        if not placed then Hub.markPlotFull(); return placedAny end
        plotFullUntil = 0
    end
    return placedAny
end
function Hub.canAutoHatch() return Hub.isOn("AutoOpenReadyEggs") and not carryingEgg end
function Hub.runAutoOpenReadyEggs()
    local save = Hub.getSave()
    local inventory = save and save.EggInventory
    if typeof(inventory) ~= "table" then return end
    local hatchedAny = false
    for uid, egg in pairs(inventory) do
        if not isRunning or not Hub.isOn("AutoOpenReadyEggs") then return hatchedAny end
        if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement ~= nil
            and Hub.matchesEggFilters(egg, nil, "LifecycleRarities", "LifecycleMutations") then
            local isReady = false
            if eggApi.IsLocalEggReady then pcall(function() isReady = eggApi.IsLocalEggReady(uid) == true end) end
            if isReady and eggApi.RequestHatchEgg then
                local hatched = false
                pcall(function() hatched = eggApi.RequestHatchEgg(uid) == true end)
                if hatched then
                    hatchedAny = true
                    if eggApi.RequestCompleteHatchEgg then pcall(eggApi.RequestCompleteHatchEgg, uid) end
                    task.wait(0.35)
                end
            end
        end
    end
    return hatchedAny
end
function Hub.getPetItemData(serialized)
    if not assetItemsApi.Deserialize then return nil end
    local ok, data = pcall(assetItemsApi.Deserialize, serialized)
    if not ok or typeof(data) ~= "table" then return nil end
    return data
end
function Hub.findToolByUid(uid)
    local containers = { LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }
    for _, container in ipairs(containers) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") and child:GetAttribute("UID") == uid then return child end
            end
        end
    end
    return nil
end
function Hub.holdUid(uid)
    local character = LocalPlayer.Character
    local humanoid = Hub.getHumanoid()
    if not character or not humanoid then return false end
    local tool = Hub.findToolByUid(uid)
    if not tool then return false end
    if tool.Parent == character then return true end
    pcall(function() humanoid:EquipTool(tool) end)
    return Hub.waitFor(1, 0.05, function() return tool.Parent == LocalPlayer.Character end)
end
function Hub.sellUid(uid)
    if not Hub.holdUid(uid) then return false end
    Hub.netCall(remotes.AssetInventory.SELL_ASSET, uid)
    return Hub.waitFor(2, 0.1, function()
        local save = Hub.getSave(); if not save then return false end
        local pets = save.Inventory or {}
        local eggs = save.EggInventory or {}
        return pets[uid] == nil and eggs[uid] == nil
    end)
end
function Hub.getSellablePets()
    local save = Hub.getSave()
    local inventory = save and save.Inventory
    local sellable = {}
    if typeof(inventory) ~= "table" then return sellable end
    local equippedAssets = save.EquippedAssets or {}
    local maxScale = tonumber(Hub.optionValue("SellMaxScale", 10)) or 10
    local keepMutated = Hub.isOn("SellKeepMutated")
    local keepEquipped = Hub.isOn("SellKeepEquipped")
    local mutationsSelected = Hub.multiSelected("SellMutations")
    local mutationsHasAny = Hub.multiHasAny("SellMutations")
    local raritiesSelected = Hub.multiSelected("SellRarities")
    local raritiesHasAny = Hub.multiHasAny("SellRarities")
    for uid, pet in pairs(inventory) do
        if typeof(uid) == "string" and typeof(pet) == "table" then
            local itemData = Hub.getPetItemData(pet)
            local isEquipped = table.find(equippedAssets, uid) ~= nil
            local skip = not itemData or itemData.IsFavorite == true or itemData.InFuse == true or (keepEquipped and isEquipped)
            if not skip then
                local mutations = Hub.recordMutations(pet)
                local sellIt = not (keepMutated and #mutations > 0)
                if sellIt and mutationsHasAny then
                    sellIt = false
                    for _, mutation in ipairs(mutations) do
                        if mutationsSelected[mutation] then sellIt = true; break end
                    end
                end
                local scale = tonumber(pet.Scale) or 0
                local rarity = Hub.resolveRarity(pet.Category)
                local rarityOk = not raritiesHasAny or (typeof(rarity) == "string" and raritiesSelected[rarity] == true)
                if sellIt and scale <= maxScale and rarityOk then table.insert(sellable, uid) end
            end
        end
    end
    return sellable
end
function Hub.runAutoSellPets()
    for _, uid in ipairs(Hub.getSellablePets()) do
        if not isRunning or not Hub.isOn("AutoSellPets") or carryingEgg then return end
        Hub.sellUid(uid); task.wait(0.15)
    end
end
function Hub.getSellableEggUids()
    local save = Hub.getSave()
    local inventory = save and save.EggInventory
    local sellable = {}
    if typeof(inventory) ~= "table" then return sellable end
    local raritiesHasAny = Hub.multiHasAny("SellEggRarities")
    local raritiesSelected = Hub.multiSelected("SellEggRarities")
    for uid, egg in pairs(inventory) do
        if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement == nil then
            local rarity = Hub.resolveRarity(egg.AssetCategory)
            if not raritiesHasAny or (typeof(rarity) == "string" and raritiesSelected[rarity] == true) then
                table.insert(sellable, uid)
            end
        end
    end
    return sellable
end
function Hub.runAutoSellEggs()
    for _, uid in ipairs(Hub.getSellableEggUids()) do
        if not isRunning or not Hub.isOn("AutoSellEggs") or carryingEgg then return end
        if eggApi.RequestEquipTool then pcall(eggApi.RequestEquipTool, uid) end
        task.wait(0.15)
        Hub.sellUid(uid); task.wait(0.15)
    end
end
function Hub.fuseGroups(save)
    local inventory = save and save.Inventory
    local groups = {}
    if typeof(inventory) ~= "table" then return groups end
    local equippedAssets = save.EquippedAssets or {}
    local keepEquipped = Hub.isOn("FuseKeepEquipped")
    local keepMutated = Hub.isOn("FuseKeepMutated")
    local maxScale = tonumber(Hub.optionValue("FuseMaxScale", 10)) or 10
    local mutationsHasAny = Hub.multiHasAny("FuseMutations")
    local mutationsSelected = Hub.multiSelected("FuseMutations")
    for uid, pet in pairs(inventory) do
        if typeof(uid) == "string" and typeof(pet) == "table" then
            local category = pet.Category
            local selectable = false
            if typeof(category) == "string" and fuseApi.CanSelectPet then
                pcall(function() selectable = fuseApi.CanSelectPet(uid, pet, category, false) == true end)
            end
            if selectable and not (keepEquipped and table.find(equippedAssets, uid) ~= nil) then
                local mutations = Hub.recordMutations(pet)
                local fuseIt = not (keepMutated and #mutations > 0)
                if fuseIt and mutationsHasAny then
                    fuseIt = false
                    for _, mutation in ipairs(mutations) do
                        if mutationsSelected[mutation] then fuseIt = true; break end
                    end
                end
                local rarity = Hub.resolveRarity(category)
                local scale = tonumber(pet.Scale) or 0
                local rarityOk = rarity == nil or Hub.selectionAllows("FuseRarities", rarity)
                if fuseIt and scale <= maxScale and rarityOk then
                    groups[category] = groups[category] or {}
                    table.insert(groups[category], { uid = uid, scale = scale })
                end
            end
        end
    end
    return groups
end
function Hub.pickFuseGroup(save)
    local groups = Hub.fuseGroups(save)
    local keepPerCategory = math.floor(tonumber(Hub.optionValue("FuseKeepPerCategory", 0)) or 0)
    local fuseTarget = Hub.optionValue("FuseTarget", "Highest Rarity")
    local bestGroup, bestScore = nil, -math.huge
    for category, entries in pairs(groups) do
        table.sort(entries, function(a, b) return a.scale < b.scale end)
        if #entries - keepPerCategory >= 3 then
            local baseRarity = RARITY_RANK[Hub.resolveRarity(category) or "Common"] or 0
            local score = baseRarity
            if fuseTarget == "Most Duplicates" then score = #entries
            elseif fuseTarget == "Lowest Rarity" then score = -baseRarity end
            if score > bestScore then bestGroup = category; bestScore = score end
        end
    end
    if not bestGroup then return nil end
    local entries = groups[bestGroup]
    return { entries[1].uid, entries[2].uid, entries[3].uid }
end
function Hub.fusePrice(save, uids)
    local inventory = save and save.Inventory
    if typeof(inventory) ~= "table" or not fuseApi.CalculateFusePrice then return nil end
    local data = {}
    for i, uid in ipairs(uids) do
        local pet = inventory[uid]
        local itemData = pet and Hub.getPetItemData(pet)
        if not itemData then return nil end
        data[i] = itemData
    end
    local ok, price = pcall(fuseApi.CalculateFusePrice, data)
    return ok and tonumber(price) or nil
end
function Hub.getFuseMachinePosition()
    local objects = Workspace:FindFirstChild("__OBJECTS")
    local machines = objects and objects:FindFirstChild("Machines")
    local fuseMachine = machines and machines:FindFirstChild("FuseMachine")
    if not fuseMachine then return nil end
    local ok, pivot = pcall(function() return fuseMachine:GetPivot() end)
    if not ok or not pivot then return nil end
    return pivot.Position + Vector3.new(0, 4, 0)
end
function Hub.runAutoFusePets(force)
    local save = Hub.getSave(); if not save then return end
    local function keepEnabled() return force == true or Hub.isOn("AutoFusePets") end
    if save.FusionLocked == true then
        if Hub.isOn("FuseAutoReveal") or force == true then Hub.netInvoke(remotes.FuseMachine.COMPLETE_REVEAL) end
        return
    end
    local uids = Hub.pickFuseGroup(save)
    if not uids then return end
    local price = Hub.fusePrice(save, uids)
    if price and (tonumber(save.Money) or 0) < price then return end
    local machinePosition = Hub.getFuseMachinePosition()
    if machinePosition and not Hub.bypassMoveTo(machinePosition, keepEnabled, Hub.bypassSpeed()) then return end
    if save.FusionInfoAcknowledged ~= true then Hub.netInvoke(remotes.FuseMachine.ACKNOWLEDGE_INFO) end
    for _, uid in ipairs(uids) do
        if not isRunning or not keepEnabled() then return end
        Hub.netInvoke(remotes.FuseMachine.INSERT_MOB, uid)
        task.wait(0.2)
    end
    Hub.netInvoke(remotes.FuseMachine.START_FUSE)
    return true
end
function Hub.runAutoEquipBest()
    local now = Workspace:GetServerTimeNow()
    if now - lastEquipBestAt < 5 then return end
    lastEquipBestAt = now
    Hub.netCall(remotes.Backpack.EQUIP_BEST)
end
function Hub.runAutoEquipBestTrail()
    local save = Hub.getSave()
    local trailInventory = save and save.TrailInventory
    if typeof(trailInventory) ~= "table" then return false end
    local bestId, bestScore = nil, -1
    for _, trailName in ipairs(trailNames) do
        local trailId = trailIdByName[trailName]
        if trailId and trailInventory[trailId] then
            local score = trailPriceByName[trailName] or 0
            if score > bestScore then bestScore = score; bestId = trailId end
        end
    end
    local wornSnapshot = Hub.netInvoke(remotes.Trails.WORN_SNAPSHOT)
    local worn = typeof(wornSnapshot) == "table" and wornSnapshot[tostring(LocalPlayer.UserId)] or nil
    if not bestId or worn == bestId then return false end
    Hub.netInvoke(remotes.Trails.REQUEST_SELECT, bestId)
    return true
end
function Hub.gearBaseName(name) return tostring(name):gsub("%s*%[X%d+%]%s*$", "") end
function Hub.runAutoEquipBestGear()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local humanoid = Hub.getHumanoid()
    if not character or not backpack or not humanoid then return end
    local bestTool, bestScore = nil, -1
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local score = gearPriceByName[Hub.gearBaseName(tool.Name)]
            if score and score > bestScore then bestScore = score; bestTool = tool end
        end
    end
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local score = gearPriceByName[Hub.gearBaseName(tool.Name)]
            if score and score >= bestScore then return end
        end
    end
    if bestTool then pcall(function() humanoid:EquipTool(bestTool) end) end
end
function Hub.runAutoBuyTrail()
    local save = Hub.getSave()
    if not save or not Hub.multiHasAny("TrailWanted") then return false end
    local wanted = Hub.multiSelected("TrailWanted")
    local trailInventory = save.TrailInventory or {}
    local boughtAny = false
    for _, trailName in ipairs(trailNames) do
        if wanted[trailName] then
            local trailId = trailIdByName[trailName]
            if trailId and not trailInventory[trailId] then
                local price = trailPriceByName[trailName] or 0
                if save.Money >= price then
                    Hub.netCall(remotes.Trails.REQUEST_PURCHASE, trailId)
                    boughtAny = true; task.wait(0.35)
                    save = Hub.getSave() or save
                    trailInventory = save.TrailInventory or trailInventory
                end
            end
        end
    end
    return boughtAny
end
function Hub.runAutoUpgrades()
    local upgradeSelection = Hub.multiSelected("UpgradeTypes")
    if not Hub.multiHasAny("UpgradeTypes") then upgradeSelection = { Base = true, Treadmill = true } end
    local save = Hub.getSave(); if not save then return false end
    local upgraded = false
    if upgradeSelection.Base and baseUpgradeModule and typeof(baseUpgradeModule.IsNextTierAffordable) == "function" then
        if baseUpgradeModule.IsNextTierAffordable(save) then
            Hub.netCall(remotes.Plots.REQUEST_BASE_UPGRADE)
            upgraded = true; task.wait(0.35)
        end
    end
    if upgradeSelection.Treadmill and treadmillsModule and typeof(treadmillsModule.GetByUpgradeLevel) == "function" then
        local currentLevel = tonumber(save.TreadmillUpgradeLevel) or 0
        local nextTier = treadmillsModule.GetByUpgradeLevel(currentLevel + 1)
        if nextTier then
            local price = tonumber(nextTier.Price) or math.huge
            if save.Money >= price then
                Hub.netCall(remotes.Treadmills.REQUEST_UPGRADE, nextTier._id)
                upgraded = true; task.wait(0.35)
            end
        end
    end
    return upgraded
end
function Hub.runAutoClaimIndex() Hub.netCall(remotes.Index.REQUEST_CLAIM_ALL) end
function Hub.runClaimOfflineEarnings()
    local summary = Hub.netInvoke(remotes.OfflineAssets.GET_SUMMARY)
    if typeof(summary) ~= "table" then return false end
    if (tonumber(summary.ClaimableAmount) or 0) <= 0 then return false end
    Hub.netCall(remotes.OfflineAssets.REQUEST_REDEEM)
    return true
end
function Hub.runAutoClaimGroupReward()
    local save = Hub.getSave()
    if save and save.ClaimedGroupReward == true then return false end
    local inGroup = false
    pcall(function()
        inGroup = constantsModule and constantsModule.GROUP_ID and LocalPlayer:IsInGroupAsync(constantsModule.GROUP_ID) == true
    end)
    Hub.netInvoke(remotes.GroupReward.CLAIM_REWARD, inGroup)
    return true
end
function Hub.deleteOwnPetRenders()
    local clientRendered = Workspace:FindFirstChild("ClientRenderedAssets")
    if not clientRendered then return end
    for _, render in ipairs(clientRendered:GetChildren()) do
        if render:GetAttribute("OwnerUserId") == LocalPlayer.UserId then pcall(function() render:Destroy() end) end
    end
end
function Hub.getTreadmillStand()
    if not plotApi.GetPlotData then return nil end
    local plotData = plotApi.GetPlotData()
    local plotFolder = plotData and plotData.PlotFolder
    local treadmillBottom = plotFolder and plotFolder:FindFirstChild("TreadmillBottom")
    if not treadmillBottom or not treadmillBottom:IsA("BasePart") then return nil end
    return treadmillBottom.Position + Vector3.new(0, 4, 0)
end
function Hub.isDoubleSpeedVisible()
    local ok, visible = pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local elements = playerGui and playerGui:FindFirstChild("Elements")
        local left = elements and elements:FindFirstChild("Left")
        local tools = left and left:FindFirstChild("Tools")
        local doubleSpeed = tools and tools:FindFirstChild("DoubleYourSpeed")
        return doubleSpeed ~= nil and doubleSpeed.Visible == true
    end)
    return ok and visible == true
end
function Hub.dismountTreadmill()
    pcall(function()
        local inputService = game:GetService("VirtualInputManager")
        inputService:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        inputService:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
    local humanoid = Hub.getHumanoid()
    if humanoid then humanoid.Jump = true; humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end
function Hub.stopTreadmillTraining()
    treadmillTraining = false
    pcall(function() Hub.netInvoke(remotes.Treadmills.REQUEST_UNEQUIP) end)
    if Hub.isDoubleSpeedVisible() then
        Hub.dismountTreadmill(); task.wait(0.1)
        if Hub.isDoubleSpeedVisible() then Hub.dismountTreadmill() end
    end
end
function Hub.canAutoTreadmill() return Hub.isOn("AutoTreadmill") and not carryingEgg end
function Hub.runAutoTreadmillTraining()
    local standPosition = Hub.getTreadmillStand()
    if not standPosition then return end
    local root = Hub.getRoot(); if not root then return end
    if (root.Position - standPosition).Magnitude > 12 then
        if not Hub.bypassMoveTo(standPosition, nil, Hub.bypassSpeed()) then return end
    end
    Hub.netInvoke(remotes.Treadmills.REQUEST_EQUIP_STATIC)
    treadmillTraining = true
    return true
end

local waypointNames = { "Base", "Pet Area", "Treadmill", "Fuse Machine", "Lobby Entry" }
for _, zoneId in ipairs(FALLBACK_AREAS) do table.insert(waypointNames, zoneId) end
function Hub.resolveWaypoint(name)
    if typeof(name) ~= "string" then return nil end
    if name == "Base" then return Hub.getBasePosition()
    elseif name == "Pet Area" then return Hub.getPetAreaStandPosition()
    elseif name == "Treadmill" then return Hub.getTreadmillStand()
    elseif name == "Fuse Machine" then return Hub.getFuseMachinePosition()
    elseif name == "Lobby Entry" then return Hub.getEntryPosition() end
    return Hub.getZoneLaneCenter(name)
end

-- ============================================================
-- ESP
-- ============================================================
function Hub.espDistanceLimit() return tonumber(Hub.optionValue("EspDistance", 2000)) or 2000 end
function Hub.withinEspRange(position)
    local root = Hub.getRoot()
    return root ~= nil and (root.Position - position).Magnitude <= Hub.espDistanceLimit()
end
function Hub.espColorFor(rarity)
    local rank = RARITY_RANK[rarity or ""] or 0
    if rank >= 9 then return Color3.fromRGB(255, 120, 255)
    elseif rank >= 7 then return Color3.fromRGB(255, 90, 90)
    elseif rank >= 5 then return Color3.fromRGB(255, 190, 80)
    elseif rank >= 3 then return Color3.fromRGB(110, 195, 255) end
    return Color3.fromRGB(190, 200, 215)
end
function Hub.ensureEspEntry(key, color)
    local entry = espObjects[key]
    if entry then return entry end
    local anchor = Instance.new("Part")
    anchor.Name = "EspAnchor"; anchor.Anchored = true; anchor.CanCollide = false
    anchor.CanQuery = false; anchor.CanTouch = false; anchor.Transparency = 1
    anchor.Size = Vector3.new(0.2, 0.2, 0.2); anchor.Parent = espFolder
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EspLabel"; billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(220, 34); billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Adornee = anchor; billboard.Parent = anchor
    local label = Instance.new("TextLabel")
    label.Name = "Text"; label.BackgroundTransparency = 1; label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold; label.TextSize = 13; label.TextStrokeTransparency = 0.4
    label.TextColor3 = color; label.Parent = billboard
    entry = { anchor = anchor, billboard = billboard, label = label, highlight = nil }
    espObjects[key] = entry
    return entry
end
function Hub.drawEspAt(key, position, text, color, highlightTarget)
    local entry = Hub.ensureEspEntry(key, color)
    entry.anchor.CFrame = CFrame.new(position)
    entry.label.Text = text; entry.label.TextColor3 = color
    if highlightTarget and highlightTarget.Parent then
        if not entry.highlight then
            local highlight = Instance.new("Highlight")
            highlight.FillTransparency = 0.6; highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = espFolder; entry.highlight = highlight
        end
        entry.highlight.Adornee = highlightTarget
        entry.highlight.FillColor = color; entry.highlight.OutlineColor = color
    elseif entry.highlight then entry.highlight:Destroy(); entry.highlight = nil end
    espDrawnKeys[key] = true
end
function Hub.releaseEsp(key)
    local entry = espObjects[key]; if not entry then return end
    if entry.highlight then entry.highlight:Destroy() end
    if entry.billboard then entry.billboard:Destroy() end
    if entry.anchor then entry.anchor:Destroy() end
    espObjects[key] = nil
end
function Hub.clearAllEsp() for key in pairs(espObjects) do Hub.releaseEsp(key) end end
function Hub.collectEggEsp()
    local showWorldEggs = Hub.isOn("EspWorldEggs")
    local showCarriedEggs = Hub.isOn("EspCarriedEggs")
    if not showWorldEggs and not showCarriedEggs then return end
    for _, record in ipairs(Hub.getAreaEggs()) do
        local frame = record.BottomCFrame or record.BoundsCFrame
        if frame then
            local state = record.State
            local visible = (state == "Slot" and showWorldEggs) or ((state == "Dropped" or state == "Carried") and showCarriedEggs)
            if visible and Hub.withinEspRange(frame.Position) then
                local rarity = Hub.resolveRarity(record.AssetCategory)
                local text = string.format("%s [%s]", Hub.assetName(record.AssetCategory), tostring(rarity or "?"))
                if state == "Dropped" or state == "Carried" then text = string.format("%s\n%s", text, tostring(state)) end
                Hub.drawEspAt("egg_" .. record.Uid, frame.Position, text, Hub.espColorFor(rarity), nil)
            end
        end
    end
end
function Hub.collectGuardEsp()
    if not Hub.isOn("EspGuards") or not guardAreasFolder then return end
    for _, area in ipairs(guardAreasFolder:GetChildren()) do
        local guard = area:FindFirstChild("Guard")
        local ok, pivot = pcall(function() return guard and guard:GetPivot() or nil end)
        if ok and pivot and Hub.withinEspRange(pivot.Position) then
            Hub.drawEspAt("guard_" .. area.Name, pivot.Position,
                string.format("Guard %s\n%s", area.Name, tostring(guard:GetAttribute("GuardState") or "Idle")),
                Color3.fromRGB(255, 140, 90), guard)
        end
    end
end
function Hub.collectPetEsp()
    if not Hub.isOn("EspPets") then return end
    local clientRendered = Workspace:FindFirstChild("ClientRenderedAssets")
    if not clientRendered then return end
    local save = Hub.getSave()
    local inventory = save and save.Inventory or {}
    local ownerByUid = {}
    pcall(function()
        if rosterApi.GetRuntimeSnapshot then
            local snapshot = rosterApi.GetRuntimeSnapshot() or {}
            for _, group in pairs(snapshot) do
                if typeof(group) == "table" and typeof(group.Records) == "table" then
                    for uid, info in pairs(group.Records) do ownerByUid[uid] = info end
                end
            end
        end
    end)
    for _, render in ipairs(clientRendered:GetChildren()) do
        local uid = render:GetAttribute("UID")
        local ok, pivot = pcall(function() return render:GetPivot() end)
        if typeof(uid) == "string" and ok and pivot and Hub.withinEspRange(pivot.Position) then
            local category, earnings = nil, nil
            local savedPet = inventory[uid]
            if typeof(savedPet) == "table" then category = savedPet.Category end
            local info = ownerByUid[uid]
            if typeof(info) == "table" then
                if not category and info.ItemData then category = info.ItemData.Category end
                earnings = tonumber(info.MoneyPerSecond)
            end
            local rarity = Hub.resolveRarity(category)
            local text = string.format("%s [%s]", Hub.assetName(category), tostring(rarity or "?"))
            if earnings then text = string.format("%s\n%s/s", text, Hub.formatNumber(earnings)) end
            Hub.drawEspAt("pet_" .. render.Name, pivot.Position, text, Hub.espColorFor(rarity), render)
        end
    end
end
function Hub.collectPlayerEsp()
    if not Hub.isOn("EspPlayers") then return end
    local root = Hub.getRoot()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and Hub.withinEspRange(humanoidRootPart.Position) then
                local distance = root and (root.Position - humanoidRootPart.Position).Magnitude or 0
                Hub.drawEspAt("player_" .. player.Name, humanoidRootPart.Position,
                    string.format("%s\n%d studs", player.DisplayName, math.floor(distance)),
                    Color3.fromRGB(120, 190, 255), character)
            end
        end
    end
end
function Hub.collectMachineEsp()
    if not Hub.isOn("EspMachines") then return end
    local objects = Workspace:FindFirstChild("__OBJECTS")
    local machines = objects and objects:FindFirstChild("Machines")
    if not machines then return end
    for _, machine in ipairs(machines:GetChildren()) do
        local ok, pivot = pcall(function() return machine:GetPivot() end)
        if ok and pivot and Hub.withinEspRange(pivot.Position) then
            Hub.drawEspAt("machine_" .. machine.Name, pivot.Position, machine.Name, Color3.fromRGB(230, 200, 120), machine)
        end
    end
end
function Hub.collectPlotEsp()
    if not Hub.isOn("EspPlots") then return end
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign") or plot:FindFirstChild("CenterPoint")
        if sign and sign:IsA("BasePart") and Hub.withinEspRange(sign.Position) then
            local ownerId = nil
            pcall(function()
                if plotApi.GetSlotOwner then ownerId = plotApi.GetSlotOwner(tonumber(plot.Name)) end
            end)
            local ownerText = "Empty"
            local ownerIdNumber = tonumber(ownerId)
            if ownerIdNumber then
                local owner = Players:GetPlayerByUserId(ownerIdNumber)
                if owner then
                    ownerText = owner.DisplayName
                    if owner == LocalPlayer then ownerText = ownerText .. " (You)" end
                else ownerText = "User " .. tostring(ownerIdNumber) end
            end
            Hub.drawEspAt("plot_" .. plot.Name, sign.Position,
                string.format("Plot %s\n%s", plot.Name, ownerText),
                Color3.fromRGB(200, 170, 255), nil)
        end
    end
end
function Hub.runEsp()
    Hub.clearTable(espDrawnKeys)
    Hub.collectEggEsp()
    Hub.collectGuardEsp()
    Hub.collectPetEsp()
    Hub.collectPlayerEsp()
    Hub.collectMachineEsp()
    Hub.collectPlotEsp()
    for key in pairs(espObjects) do
        if not espDrawnKeys[key] then Hub.releaseEsp(key) end
    end
end

-- ============================================================
-- SERVER HOP
-- ============================================================
function Hub.rememberVisited(jobId)
    if typeof(jobId) ~= "string" or jobId == "" then return end
    if Hub.countTable(hopHistory) >= 300 then Hub.clearTable(hopHistory) end
    hopHistory[jobId] = true
end
Hub.rememberVisited(tostring(game.JobId))
Hub.track(TeleportService.TeleportInitFailed:Connect(function(player, errorPlaceId, errorMessage)
    if player == LocalPlayer then lastTeleportError = tostring(errorMessage or errorPlaceId) end
end))
function Hub.fetchServerPage(cursor)
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100", game.PlaceId)
    if cursor then url = url .. "&cursor=" .. cursor end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok or typeof(body) ~= "string" then return nil end
    local decoded, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not decoded or typeof(data) ~= "table" or typeof(data.data) ~= "table" then return nil end
    return data
end
function Hub.pickHopTargets()
    local cursor = nil
    local candidates = {}
    for _ = 1, 4 do
        local page = Hub.fetchServerPage(cursor)
        if not page then break end
        for _, server in ipairs(page.data) do
            if typeof(server) == "table" and typeof(server.id) == "string"
                and server.id ~= game.JobId and not hopHistory[server.id] then
                local playing = tonumber(server.playing) or 0
                local maxPlayers = tonumber(server.maxPlayers) or 0
                if maxPlayers > 0 and playing < maxPlayers then
                    table.insert(candidates, { id = server.id, playing = playing })
                end
            end
        end
        cursor = typeof(page.nextPageCursor) == "string" and page.nextPageCursor or nil
        if not cursor or #candidates >= 40 then break end
        task.wait(0.25)
    end
    table.sort(candidates, function(a, b) return a.playing < b.playing end)
    return candidates
end
function Hub.tryTeleportTo(jobId)
    lastTeleportError = nil
    task.wait(1)
    local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer) end)
    if not ok then return false end
    Hub.waitFor(20, 0.25, function() return lastTeleportError ~= nil or (not isRunning) end)
    if lastTeleportError then return false end
    return true
end
function Hub.serverHop(reason)
    if isHopping or os.clock() < hopCooldownUntil then return false end
    isHopping = true
    local targets = Hub.pickHopTargets()
    if typeof(targets) ~= "table" or #targets == 0 then
        hopCooldownUntil = os.clock() + 30
        isHopping = false
        return false
    end
    for attempt = 1, 3 do
        if attempt > 1 then
            targets = Hub.pickHopTargets()
            if typeof(targets) ~= "table" or #targets == 0 then
                hopCooldownUntil = os.clock() + 10
                isHopping = false
                return false
            end
        end
        for index = 1, math.min(#targets, 10) do
            if not isRunning then isHopping = false; return false end
            local target = targets[index]
            Hub.rememberVisited(target.id)
            if Hub.tryTeleportTo(target.id) then
                isHopping = false
                return true
            end
            task.wait(0.5)
        end
    end
    hopCooldownUntil = os.clock() + 10
    isHopping = false
    return false
end
function Hub.runServerHop()
    if carryingEgg or isHopping then return end
    local mode = Hub.optionValue("HopMode", HOP_MODE_OPTIONS[1])
    local threshold = tonumber(Hub.optionValue("HopValue", 15)) or 15
    local now = os.clock()
    if mode == "Timed Interval" then
        if now - hopIntervalStart >= threshold * 60 then Hub.serverHop("Interval reached") end
        return
    end
    if mode == "After Steal Count" then
        if stolenEggs >= threshold then Hub.serverHop(string.format("Stole %d eggs", stolenEggs)) end
        return
    end
    if Hub.pickStealTarget() ~= nil then eggCheckCountdown = 0; return end
    if eggCheckCountdown == 0 then eggCheckCountdown = now
    elseif now - eggCheckCountdown >= threshold then
        eggCheckCountdown = 0
        Hub.serverHop("No matching eggs in this server")
    end
end
function Hub.rejoinServer()
    local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    if not ok then pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end
end

-- ============================================================
-- WEBHOOK
-- ============================================================
function Hub.webhookPing()
    local pingId = tostring(Hub.optionValue("WebhookPingId", "") or ""):gsub("%D", "")
    if pingId == "" then return nil end
    return string.format("<@%s>", pingId)
end
function Hub.httpPost(payload)
    local request = (syn and syn.request) or (http and http.request) or http_request or request
    if typeof(request) ~= "function" then return false end
    local url = tostring(Hub.optionValue("WebhookUrl", "") or "")
    if url == "" then return false end
    local body
    local encoded = pcall(function() body = HttpService:JSONEncode(payload) end)
    if not encoded then return false end
    return pcall(request, {
        Url = url, Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = body,
    })
end
function Hub.sendWebhookEmbed(embed, ping)
    if not Hub.isOn("WebhookEnabled") then return false end
    local payload = { username = "Apex Hub", embeds = { embed } }
    if ping then payload.content = Hub.webhookPing() end
    return Hub.httpPost(payload)
end
function Hub.embedField(name, value, inline) return { name = name, value = value, inline = inline ~= false } end

eggCarryWebhook = function(payload)
    if typeof(payload) ~= "table" then return end
    local record = typeof(payload.Uid) == "string" and Hub.findAreaEggRecord(payload.Uid) or nil
    local category = record and record.AssetCategory or payload.AssetCategory
    local text = { string.format("**%s** `%s`", Hub.assetName(category), tostring(Hub.resolveRarity(category) or "?")) }
    local areaId = record and record.AreaId or payload.AreaId
    if typeof(areaId) == "string" then table.insert(text, areaId) end
    if record then
        local scale = tonumber(record.AssetScale)
        if scale then table.insert(text, string.format("x%.2f", scale)) end
        local mutations = Hub.recordMutations(record)
        if #mutations > 0 then table.insert(text, table.concat(mutations, ", ")) end
    end
    if #stolenEggLog < 100 then table.insert(stolenEggLog, table.concat(text, " | ")) end
end
function Hub.trackWebhookEvents()
    local save = Hub.getSave()
    if not save then return end
    if not webhookBaselineReady then
        webhookBaselineReady = true
        for uid in pairs(save.Inventory or {}) do knownInventoryUids[uid] = true end
        for _, record in ipairs(Hub.getAreaEggs()) do knownEggUids[record.Uid] = true end
        lastRebirthCount = tonumber(save.Rebirth) or 0
        lastStolenEggCount = stolenEggs
        return
    end
    sessionEggsStolen = sessionEggsStolen + math.max(0, stolenEggs - lastStolenEggCount)
    lastStolenEggCount = stolenEggs
    for uid in pairs(save.Inventory or {}) do
        if knownInventoryUids[uid] == nil then
            knownInventoryUids[uid] = true
            sessionPetsObtained = sessionPetsObtained + 1
        end
    end
    local rebirth = tonumber(save.Rebirth) or 0
    if lastRebirthCount and rebirth > lastRebirthCount then
        sessionRebirths = sessionRebirths + rebirth - lastRebirthCount
    end
    lastRebirthCount = rebirth
    local presentEggs = {}
    local logSpawns = Hub.isOn("WebhookEggSpawns")
    for _, record in ipairs(Hub.getAreaEggs()) do
        presentEggs[record.Uid] = true
        if knownEggUids[record.Uid] == nil then
            knownEggUids[record.Uid] = true
            local rarity = Hub.resolveRarity(record.AssetCategory)
            if logSpawns and Hub.selectionAllows("WebhookRarities", rarity or "") and #eggSpawnQueue < 60 then
                table.insert(eggSpawnQueue, {
                    rank = RARITY_RANK[rarity or ""] or 0,
                    order = #eggSpawnQueue,
                    text = string.format("**%s** `%s` in %s", Hub.assetName(record.AssetCategory), tostring(rarity or "?"), tostring(record.AreaId)),
                })
            end
        end
    end
    for uid in pairs(knownEggUids) do
        if not presentEggs[uid] then knownEggUids[uid] = nil end
    end
end
function Hub.buildSummaryEmbed()
    local save = Hub.getSave()
    local fields = {}
    if save then
        table.insert(fields, Hub.embedField("Money", "`" .. Hub.formatNumber(save.Money) .. "`"))
        table.insert(fields, Hub.embedField("Speed Power", "`" .. Hub.formatNumber(save.SpeedPower) .. "`"))
        table.insert(fields, Hub.embedField("Rebirth", "`" .. tostring(save.Rebirth or 0) .. "`"))
        table.insert(fields, Hub.embedField("Pets Owned", "`" .. tostring(Hub.countTable(save.Inventory)) .. "`"))
    end
    table.insert(fields, Hub.embedField("Since Last Summary",
        string.format("Eggs stolen: **%d**\nPets obtained: **%d**\nRebirths: **%d**", sessionEggsStolen, sessionPetsObtained, sessionRebirths), false))
    return {
        author = { name = "Steal an Egg | Apex Hub" },
        title = "Session Summary",
        description = string.format("**Player** `%s`\n**Server** `%s`\n**Runtime** `%s`",
            LocalPlayer.Name, jobIdLabel, Hub.formatElapsed(os.clock() - scriptStartTime)),
        color = 5793266, fields = fields,
        footer = { text = "Apex Hub | " .. DISCORD_LINK },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
end
Hub.sendSummary = function()
    local sent = Hub.sendWebhookEmbed(Hub.buildSummaryEmbed(), true)
    if sent then
        sessionEggsStolen, sessionPetsObtained, sessionRebirths = 0, 0, 0
        Hub.clearTable(eggSpawnQueue); Hub.clearTable(stolenEggLog)
    end
    return sent
end
function Hub.runWebhookSummary()
    local interval = (tonumber(Hub.optionValue("WebhookInterval", 15)) or 15) * 60
    if os.clock() - lastWebhookSentAt < interval then return false end
    lastWebhookSentAt = os.clock()
    return Hub.sendSummary()
end

-- ============================================================
-- PERFORMANCE
-- ============================================================
function Hub.applyAntiGameplayPause(enabled)
    pcall(function() GuiService:SetGameplayPausedNotificationEnabled(not enabled) end)
    pcall(function()
        local notification = CoreGui:FindFirstChild("RobloxNetworkPauseNotification")
        if notification then notification.Enabled = not enabled end
    end)
end
function Hub.applyRendering(enabled)
    pcall(function() RunService:Set3dRenderingEnabled(not enabled) end)
    renderingDisabled = enabled
end
local effectClasses = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true }
function Hub.setEffectEnabled(effect, enabled) pcall(function() effect.Enabled = enabled end) end
function Hub.enableFpsBoost()
    if fpsBoostSavedSettings then return end
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    local qualityLevel = nil
    pcall(function() qualityLevel = settings().Rendering.QualityLevel end)
    fpsBoostSavedSettings = {
        QualityLevel = qualityLevel, GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd,
        Terrain = terrain,
        WaterWaveSize = terrain and terrain.WaterWaveSize or nil,
        WaterReflectance = terrain and terrain.WaterReflectance or nil,
        Effects = {},
    }
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows = false; Lighting.FogEnd = 1000000
    if terrain then terrain.WaterWaveSize = 0; terrain.WaterReflectance = 0 end
    for _, effect in ipairs(Workspace:GetDescendants()) do
        if effectClasses[effect.ClassName] and effect.Enabled then
            table.insert(fpsBoostSavedSettings.Effects, effect)
            Hub.setEffectEnabled(effect, false)
        end
    end
    fpsEffectWatcher = Workspace.DescendantAdded:Connect(function(effect)
        if effectClasses[effect.ClassName] and Hub.isOn("FpsBoost") then Hub.setEffectEnabled(effect, false) end
    end)
end
function Hub.disableFpsBoost()
    if fpsEffectWatcher then fpsEffectWatcher:Disconnect(); fpsEffectWatcher = nil end
    local saved = fpsBoostSavedSettings; if not saved then return end
    fpsBoostSavedSettings = nil
    if saved.QualityLevel then pcall(function() settings().Rendering.QualityLevel = saved.QualityLevel end) end
    Lighting.GlobalShadows = saved.GlobalShadows; Lighting.FogEnd = saved.FogEnd
    if saved.Terrain and saved.Terrain.Parent then
        saved.Terrain.WaterWaveSize = saved.WaterWaveSize
        saved.Terrain.WaterReflectance = saved.WaterReflectance
    end
    for _, effect in ipairs(saved.Effects) do Hub.setEffectEnabled(effect, true) end
end
function Hub.applyFpsCap(fps)
    local apply = setfpscap or (syn and syn.set_fps_cap)
    if typeof(apply) ~= "function" then
        if not fpsCapUnavailable then fpsCapUnavailable = true end
        return false
    end
    return pcall(apply, math.clamp(tonumber(fps) or 60, 15, 360))
end
function Hub.handleDisconnect(reason)
    if disconnectHandled then return end
    disconnectHandled = true
    if Hub.isOn("WebhookDisconnectAlerts") then
        Hub.sendWebhookEmbed({
            author = { name = "Steal an Egg | Apex Hub" },
            title = "Disconnected",
            description = string.format("**Player** `%s`\n**Reason** %s", LocalPlayer.Name, tostring(reason or "Connection lost")),
            color = 15158332,
            footer = { text = "Apex Hub | " .. DISCORD_LINK },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }, true)
    end
    if Hub.isOn("AutoReconnect") then task.delay(2, Hub.rejoinServer) end
end

local tasks = {
    ["Auto Steal Egg"] = { Ready = Hub.canAutoSteal, Run = Hub.runAutoSteal, Interval = 0.25 },
    ["Auto Place Egg"] = { Ready = Hub.canAutoPlace, Run = Hub.runAutoPlaceEggs, Interval = 0.45 },
    ["Auto Hatch"] = { Ready = Hub.canAutoHatch, Run = Hub.runAutoOpenReadyEggs, Interval = 0.55 },
    ["Auto Treadmill"] = { Ready = Hub.canAutoTreadmill, Run = Hub.runAutoTreadmillTraining, Interval = 1.2 },
}
function Hub.priorityOrder()
    local selected, order = {}, {}
    for _, slot in ipairs(PRIORITY_SLOTS) do
        local taskName = Hub.optionValue(slot, nil)
        if tasks[taskName] and not selected[taskName] then selected[taskName] = true; table.insert(order, taskName) end
    end
    for _, taskName in ipairs(TASK_NAMES) do
        if not selected[taskName] then selected[taskName] = true; table.insert(order, taskName) end
    end
    return order
end

-- ============================================================
-- STANDALONE UI
-- ============================================================
local dt = {}
dt.__state = {}
dt.__callbacks = {}
dt.__tabs = {}
dt.__activeTab = nil
dt.__connections = {}

local function du(dv) table.insert(dt.__connections, dv); return dv end

local dw = {
    panelBg       = Color3.fromRGB(12, 12, 14),
    panelBg2      = Color3.fromRGB(18, 18, 22),
    panelBorder   = Color3.fromRGB(40, 40, 46),
    panelBorderHi = Color3.fromRGB(90, 90, 100),
    sidebarBg     = Color3.fromRGB(10, 10, 12),
    sectionBg     = Color3.fromRGB(22, 22, 26),
    sectionBorder = Color3.fromRGB(42, 42, 48),
    text          = Color3.fromRGB(240, 240, 245),
    textDim       = Color3.fromRGB(160, 160, 170),
    textMuted     = Color3.fromRGB(105, 105, 115),
    accent        = Color3.fromRGB(180, 30, 30),
    accentHi      = Color3.fromRGB(230, 55, 55),
    toggleOn      = Color3.fromRGB(200, 40, 40),
    toggleOff     = Color3.fromRGB(45, 45, 52),
    success       = Color3.fromRGB(90, 210, 130),
    warning       = Color3.fromRGB(235, 175, 70),
    error         = Color3.fromRGB(240, 90, 90),
    info          = Color3.fromRGB(110, 170, 240),
}

local function dx()
    if gethui then
        local dy, dz = pcall(gethui)
        if dy and dz then return dz end
    end
    return CoreGui
end

local dy = Instance.new("ScreenGui")
dy.Name = "ApexHubGUI"
dy.ResetOnSpawn = false
dy.IgnoreGuiInset = true
dy.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
dy.DisplayOrder = 9999
dy.Parent = dx()

local dz = Instance.new("ScreenGui")
dz.Name = "ApexHubToggle"
dz.ResetOnSpawn = false
dz.IgnoreGuiInset = true
dz.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
dz.DisplayOrder = 9998
dz.Parent = dx()

local ea = Instance.new("ImageButton")
ea.Name = "ToggleBtn"
ea.Size = UDim2.fromOffset(56, 56)
ea.Position = UDim2.new(0, 24, 0.4, 0)
ea.BackgroundColor3 = dw.panelBg
ea.BackgroundTransparency = 0.15
ea.BorderSizePixel = 0
ea.Image = TOGGLE_IMAGE
ea.ImageColor3 = Color3.fromRGB(255, 255, 255)
ea.ScaleType = Enum.ScaleType.Fit
ea.AutoButtonColor = false
ea.Active = true
ea.Draggable = false
ea.Parent = dz

local eb = Instance.new("UICorner")
eb.CornerRadius = UDim.new(1, 0)
eb.Parent = ea
local ec = Instance.new("UIStroke")
ec.Thickness = 1.5
ec.Color = dw.panelBorderHi
ec.Transparency = 0.3
ec.Parent = ea
local ed = Instance.new("UIPadding")
ed.PaddingTop = UDim.new(0, 8)
ed.PaddingBottom = UDim.new(0, 8)
ed.PaddingLeft = UDim.new(0, 8)
ed.PaddingRight = UDim.new(0, 8)
ed.Parent = ea

local ee, ef = 640, 440
local eg = Instance.new("Frame")
eg.Name = "Panel"
eg.Size = UDim2.fromOffset(ee, ef)
eg.Position = UDim2.new(0.5, -ee / 2, 0.5, -ef / 2)
eg.BackgroundColor3 = dw.panelBg
eg.BackgroundTransparency = 0.08
eg.BorderSizePixel = 0
eg.ClipsDescendants = true
eg.Active = true
eg.Draggable = false
eg.Visible = true
eg.Parent = dy

local eh = Instance.new("UICorner")
eh.CornerRadius = UDim.new(0, 12)
eh.Parent = eg
local ei = Instance.new("UIStroke")
ei.Thickness = 1.5
ei.Color = dw.panelBorder
ei.Transparency = 0.15
ei.Parent = eg

local function ej(ek, el)
    local eo = Instance.new("UICorner"); eo.CornerRadius = UDim.new(0, el or 6); eo.Parent = ek; return eo
end
local function em(en, eo, ep)
    local et = Instance.new("UIStroke"); et.Color = eo or dw.panelBorder
    et.Thickness = ep or 1; et.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; et.Parent = en; return et
end

local eq = Instance.new("Frame")
eq.Name = "Header"
eq.Size = UDim2.new(1, 0, 0, 52)
eq.BackgroundColor3 = dw.panelBg2
eq.BackgroundTransparency = 0.05
eq.BorderSizePixel = 0
eq.Parent = eg
ej(eq, 12)

local er = Instance.new("Frame")
er.Size = UDim2.new(1, 0, 0, 1)
er.Position = UDim2.new(0, 0, 1, -1)
er.BackgroundColor3 = dw.panelBorder
er.BorderSizePixel = 0
er.Parent = eq

local es = Instance.new("TextLabel")
es.BackgroundTransparency = 1
es.Position = UDim2.fromOffset(20, 8)
es.Size = UDim2.new(0, 300, 0, 22)
es.Font = Enum.Font.GothamBold
es.TextSize = 18
es.TextColor3 = dw.text
es.TextXAlignment = Enum.TextXAlignment.Left
es.Text = HUB_NAME
es.Parent = eq

local et = Instance.new("TextLabel")
et.BackgroundTransparency = 1
et.Position = UDim2.fromOffset(20, 30)
et.Size = UDim2.new(0, 400, 0, 16)
et.Font = Enum.Font.Gotham
et.TextSize = 12
et.TextColor3 = dw.textDim
et.TextXAlignment = Enum.TextXAlignment.Left
et.Text = DISCORD_SUBTITLE
et.Parent = eq

local eu = Instance.new("TextButton")
eu.Size = UDim2.fromOffset(96, 26)
eu.Position = UDim2.new(1, -174, 0, 13)
eu.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
eu.BackgroundTransparency = 0.15
eu.BorderSizePixel = 0
eu.AutoButtonColor = false
eu.Font = Enum.Font.GothamSemibold
eu.TextSize = 12
eu.TextColor3 = dw.text
eu.Text = "Discord"
eu.Parent = eq
ej(eu, 6)
em(eu, Color3.fromRGB(90, 90, 130), 1)
eu.MouseEnter:Connect(function() TweenService:Create(eu, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play() end)
eu.MouseLeave:Connect(function() TweenService:Create(eu, TweenInfo.new(0.15), { BackgroundTransparency = 0.15 }):Play() end)
eu.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD_LINK) end)
    Hub.notify("Apex Hub", "Discord link copied", "Success", 3)
end)

local ev = Instance.new("TextButton")
ev.Size = UDim2.fromOffset(28, 28)
ev.Position = UDim2.new(1, -38, 0, 12)
ev.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
ev.BackgroundTransparency = 0.2
ev.BorderSizePixel = 0
ev.AutoButtonColor = false
ev.Font = Enum.Font.GothamBold
ev.TextSize = 14
ev.TextColor3 = dw.text
ev.Text = "X"
ev.Parent = eq
ej(ev, 6)
em(ev, Color3.fromRGB(120, 40, 40), 1)
ev.MouseEnter:Connect(function() TweenService:Create(ev, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(90, 30, 30), BackgroundTransparency = 0 }):Play() end)
ev.MouseLeave:Connect(function() TweenService:Create(ev, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(50, 20, 20), BackgroundTransparency = 0.2 }):Play() end)
ev.MouseButton1Click:Connect(function() eg.Visible = false end)

local ew = 150
local ex = Instance.new("Frame")
ex.Position = UDim2.fromOffset(0, 52)
ex.Size = UDim2.new(0, ew, 1, -52)
ex.BackgroundColor3 = dw.sidebarBg
ex.BackgroundTransparency = 0.1
ex.BorderSizePixel = 0
ex.Parent = eg

local ey = Instance.new("ScrollingFrame")
ey.BackgroundTransparency = 1
ey.BorderSizePixel = 0
ey.Size = UDim2.new(1, 0, 1, 0)
ey.CanvasSize = UDim2.new(0, 0, 0, 0)
ey.AutomaticCanvasSize = Enum.AutomaticSize.Y
ey.ScrollBarThickness = 3
ey.ScrollBarImageColor3 = dw.accent
ey.Parent = ex

local ez = Instance.new("UIListLayout")
ez.Padding = UDim.new(0, 4)
ez.SortOrder = Enum.SortOrder.LayoutOrder
ez.Parent = ey

local fa = Instance.new("UIPadding")
fa.PaddingTop = UDim.new(0, 10)
fa.PaddingLeft = UDim.new(0, 8)
fa.PaddingRight = UDim.new(0, 8)
fa.Parent = ey

local fb = Instance.new("Frame")
fb.Position = UDim2.fromOffset(ew + 10, 62)
fb.Size = UDim2.new(1, -(ew + 20), 1, -72)
fb.BackgroundTransparency = 1
fb.BorderSizePixel = 0
fb.Parent = eg

local fc = Instance.new("ScrollingFrame")
fc.BackgroundTransparency = 1
fc.BorderSizePixel = 0
fc.Size = UDim2.new(1, 0, 1, 0)
fc.CanvasSize = UDim2.new(0, 0, 0, 0)
fc.AutomaticCanvasSize = Enum.AutomaticSize.Y
fc.ScrollBarThickness = 4
fc.ScrollBarImageColor3 = dw.accent
fc.Parent = fb

local fd = Instance.new("UIListLayout")
fd.Padding = UDim.new(0, 10)
fd.SortOrder = Enum.SortOrder.LayoutOrder
fd.Parent = fc

local fe = Instance.new("UIPadding")
fe.PaddingRight = UDim.new(0, 8)
fe.PaddingBottom = UDim.new(0, 12)
fe.Parent = fc

local function ff(fg, fh)
    fh = fh or fg
    local startDown, startMoved = false, false
    local pressPos, basePos = nil, nil
    local function hitTest(pos)
        local ok, hit = pcall(function()
            local abs = fh.AbsolutePosition
            local absSize = fh.AbsoluteSize
            return pos.X >= abs.X and pos.X <= abs.X + absSize.X
                and pos.Y >= abs.Y and pos.Y <= abs.Y + absSize.Y
        end)
        return ok and hit == true
    end
    du(UserInputService.InputBegan:Connect(function(fn)
        local ut = fn.UserInputType
        if ut ~= Enum.UserInputType.MouseButton1 and ut ~= Enum.UserInputType.Touch then return end
        if not hitTest(fn.Position) then return end
        startDown = true
        startMoved = false
        pressPos = fn.Position
        basePos = fg.Position
    end))
    du(UserInputService.InputChanged:Connect(function(fn)
        local ut = fn.UserInputType
        if ut ~= Enum.UserInputType.MouseMovement and ut ~= Enum.UserInputType.Touch then return end
        if not startDown or not pressPos then return end
        local delta = fn.Position - pressPos
        if not startMoved and (math.abs(delta.X) > 4 or math.abs(delta.Y) > 4) then startMoved = true end
        if startMoved then
            fg.Position = UDim2.new(
                basePos.X.Scale, basePos.X.Offset + delta.X,
                basePos.Y.Scale, basePos.Y.Offset + delta.Y
            )
        end
    end))
    du(UserInputService.InputEnded:Connect(function(fn)
        local ut = fn.UserInputType
        if ut ~= Enum.UserInputType.MouseButton1 and ut ~= Enum.UserInputType.Touch then return end
        startDown = false
        startMoved = false
        pressPos = nil
        basePos = nil
    end))
end
ff(eg, eq)

do
    local iconDown, iconMoved = false, false
    local pressPos, basePos = nil, nil
    local function iconHitTest(pos)
        local ok, hit = pcall(function()
            local abs = ea.AbsolutePosition
            local absSize = ea.AbsoluteSize
            return pos.X >= abs.X and pos.X <= abs.X + absSize.X
                and pos.Y >= abs.Y and pos.Y <= abs.Y + absSize.Y
        end)
        return ok and hit == true
    end
    du(UserInputService.InputBegan:Connect(function(input)
        local ut = input.UserInputType
        if ut ~= Enum.UserInputType.MouseButton1 and ut ~= Enum.UserInputType.Touch then return end
        if not iconHitTest(input.Position) then return end
        iconDown = true
        iconMoved = false
        pressPos = input.Position
        basePos = ea.Position
    end))
    du(UserInputService.InputChanged:Connect(function(input)
        local ut = input.UserInputType
        if ut ~= Enum.UserInputType.MouseMovement and ut ~= Enum.UserInputType.Touch then return end
        if not iconDown or not pressPos then return end
        local delta = input.Position - pressPos
        if not iconMoved and (math.abs(delta.X) > 4 or math.abs(delta.Y) > 4) then iconMoved = true end
        if iconMoved then
            ea.Position = UDim2.new(
                basePos.X.Scale, basePos.X.Offset + delta.X,
                basePos.Y.Scale, basePos.Y.Offset + delta.Y
            )
        end
    end))
    du(UserInputService.InputEnded:Connect(function(input)
        local ut = input.UserInputType
        if ut ~= Enum.UserInputType.MouseButton1 and ut ~= Enum.UserInputType.Touch then return end
        if not iconDown then return end
        if not iconMoved then eg.Visible = not eg.Visible end
        iconDown = false
        iconMoved = false
        pressPos = nil
        basePos = nil
    end))
    du(ea.MouseEnter:Connect(function()
        TweenService:Create(ea, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(28, 28, 34), BackgroundTransparency = 0 }):Play()
        TweenService:Create(ec, TweenInfo.new(0.15), { Color = dw.accent, Transparency = 0 }):Play()
    end))
    du(ea.MouseLeave:Connect(function()
        TweenService:Create(ea, TweenInfo.new(0.15), { BackgroundColor3 = dw.panelBg, BackgroundTransparency = 0.15 }):Play()
        TweenService:Create(ec, TweenInfo.new(0.15), { Color = dw.panelBorderHi, Transparency = 0.3 }):Play()
    end))
end

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

function Hub.getState(fi, fj)
    local fk = dt.GetState(fi)
    if fk ~= nil then return fk end
    return fj
end
function Hub.isOn(fi) return dt.GetState(fi) == true end
function Hub.optionValue(fi, fj)
    local fk = dt.GetState(fi)
    if fk == nil then return fj end
    return fk
end
function Hub.multiSelected(fi)
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
function Hub.multiHasAny(fi) return next(Hub.multiSelected(fi)) ~= nil end
function Hub.selectionAllows(fi, fj)
    if not Hub.multiHasAny(fi) then return true end
    return Hub.multiSelected(fi)[fj] == true
end
function Hub.matchesMutationFilter(fi, fj)
    if not Hub.multiHasAny(fi) then return true end
    local fk = Hub.multiSelected(fi)
    for _, fl in ipairs(Hub.recordMutations(fj)) do
        if fk[fl] then return true end
    end
    return false
end
function Hub.matchesEggFilters(fi, fj, fk, fl)
    if fj then
        local fm = fi.AreaId
        if typeof(fm) ~= "string" or not Hub.selectionAllows(fj, fm) then return false end
    end
    local fm = Hub.resolveRarity(fi.AssetCategory)
    if typeof(fm) ~= "string" or not Hub.selectionAllows(fk, fm) then return false end
    return Hub.matchesMutationFilter(fl, fi)
end

local function fi(fj, fk)
    local fn = Instance.new("TextButton")
    fn.Name = "Tab_" .. fj
    fn.Size = UDim2.new(1, 0, 0, 32)
    fn.BackgroundColor3 = dw.sectionBg
    fn.BackgroundTransparency = 0.5
    fn.BorderSizePixel = 0
    fn.AutoButtonColor = false
    fn.Font = Enum.Font.GothamMedium
    fn.TextSize = 13
    fn.TextColor3 = dw.textDim
    fn.TextXAlignment = Enum.TextXAlignment.Left
    fn.Text = fk
    fn.Parent = ey
    ej(fn, 6)
    local fo = Instance.new("UIPadding"); fo.PaddingLeft = UDim.new(0, 12); fo.Parent = fn

    local fp = Instance.new("Frame")
    fp.Size = UDim2.new(0, 3, 0, 0)
    fp.Position = UDim2.new(0, 0, 0.5, 0)
    fp.AnchorPoint = Vector2.new(0, 0.5)
    fp.BackgroundColor3 = dw.accent
    fp.BorderSizePixel = 0
    fp.Parent = fn
    ej(fp, 2)

    local function fq(fr)
        if fr then
            TweenService:Create(fn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 20, 20), BackgroundTransparency = 0.2 }):Play()
            TweenService:Create(fn, TweenInfo.new(0.15), { TextColor3 = dw.text }):Play()
            TweenService:Create(fp, TweenInfo.new(0.15), { Size = UDim2.new(0, 3, 0.7, 0) }):Play()
        else
            TweenService:Create(fn, TweenInfo.new(0.15), { BackgroundColor3 = dw.sectionBg, BackgroundTransparency = 0.5 }):Play()
            TweenService:Create(fn, TweenInfo.new(0.15), { TextColor3 = dw.textDim }):Play()
            TweenService:Create(fp, TweenInfo.new(0.15), { Size = UDim2.new(0, 3, 0, 0) }):Play()
        end
    end
    fn.MouseEnter:Connect(function()
        if dt.__activeTab ~= fj then
            TweenService:Create(fn, TweenInfo.new(0.15), { BackgroundTransparency = 0.25 }):Play()
            TweenService:Create(fn, TweenInfo.new(0.15), { TextColor3 = dw.text }):Play()
        end
    end)
    fn.MouseLeave:Connect(function()
        if dt.__activeTab ~= fj then fq(false) end
    end)
    return fn, fq
end

function dt.AddTab(fl)
    local fm = fl.Id
    local fn, fo = fi(fm, fl.Title)
    local fp = Instance.new("ScrollingFrame")
    fp.BackgroundTransparency = 1
    fp.BorderSizePixel = 0
    fp.Size = UDim2.new(1, 0, 1, 0)
    fp.CanvasSize = UDim2.new(0, 0, 0, 0)
    fp.AutomaticCanvasSize = Enum.AutomaticSize.Y
    fp.ScrollBarThickness = 4
    fp.ScrollBarImageColor3 = dw.accent
    fp.Visible = false
    fp.Parent = fc
    local fq = Instance.new("UIListLayout")
    fq.Padding = UDim.new(0, 10)
    fq.SortOrder = Enum.SortOrder.LayoutOrder
    fq.Parent = fp
    local fr = Instance.new("UIPadding"); fr.PaddingRight = UDim.new(0, 6); fr.Parent = fp

    local fs = { Id = fm, Page = fp, Button = fn, SetActive = fo }
    fn.MouseButton1Click:Connect(function()
        if dt.__activeTab == fm then return end
        for ft, fu in pairs(dt.__tabs) do
            fu.Page.Visible = (ft == fm)
            fu.SetActive(ft == fm)
        end
        dt.__activeTab = fm
    end)
    dt.__tabs[fm] = fs
    if not dt.__activeTab then
        dt.__activeTab = fm
        fp.Visible = true
        fo(true)
    end
    return fs
end

function dt.AddSection(fl, fm)
    local fn = Instance.new("Frame")
    fn.BackgroundColor3 = dw.sectionBg
    fn.BackgroundTransparency = 0.35
    fn.BorderSizePixel = 0
    fn.Size = UDim2.new(1, 0, 0, 0)
    fn.AutomaticSize = Enum.AutomaticSize.Y
    fn.Parent = fl.Page
    ej(fn, 8)
    em(fn, dw.sectionBorder, 1)
    local fo = Instance.new("UIListLayout")
    fo.Padding = UDim.new(0, 6)
    fo.SortOrder = Enum.SortOrder.LayoutOrder
    fo.Parent = fn
    local fp = Instance.new("UIPadding")
    fp.PaddingTop = UDim.new(0, 10)
    fp.PaddingBottom = UDim.new(0, 10)
    fp.PaddingLeft = UDim.new(0, 12)
    fp.PaddingRight = UDim.new(0, 12)
    fp.Parent = fn

    if fm.Title then
        local fq = Instance.new("TextLabel")
        fq.BackgroundTransparency = 1
        fq.Size = UDim2.new(1, 0, 0, 20)
        fq.Font = Enum.Font.GothamBold
        fq.TextSize = 13
        fq.TextColor3 = dw.text
        fq.TextXAlignment = Enum.TextXAlignment.Left
        fq.Text = fm.Title
        fq.Parent = fn
    end
    if fm.Description then
        local fq = Instance.new("TextLabel")
        fq.BackgroundTransparency = 1
        fq.Size = UDim2.new(1, 0, 0, 16)
        fq.Font = Enum.Font.Gotham
        fq.TextSize = 11
        fq.TextColor3 = dw.textMuted
        fq.TextXAlignment = Enum.TextXAlignment.Left
        fq.TextWrapped = true
        fq.Text = fm.Description
        fq.Parent = fn
    end
    return fn
end

local function fl(fm, fn)
    local fq = Instance.new("Frame")
    fq.BackgroundColor3 = dw.panelBg2
    fq.BackgroundTransparency = 0.4
    fq.BorderSizePixel = 0
    fq.Size = UDim2.new(1, 0, 0, fn or 30)
    fq.Parent = fm
    ej(fq, 6)
    local fr = Instance.new("UIPadding")
    fr.PaddingLeft = UDim.new(0, 10)
    fr.PaddingRight = UDim.new(0, 10)
    fr.Parent = fq
    return fq
end

function dt.AddToggle(fo, fp)
    local fq = fl(fo, 36)
    local fr = Instance.new("TextLabel")
    fr.BackgroundTransparency = 1
    fr.Size = UDim2.new(1, -60, 0, 22)
    fr.Font = Enum.Font.GothamMedium
    fr.TextSize = 13
    fr.TextColor3 = dw.text
    fr.TextXAlignment = Enum.TextXAlignment.Left
    fr.Text = fp.Title or "Toggle"
    fr.Parent = fq
    if fp.Description then
        local fs = Instance.new("TextLabel")
        fs.BackgroundTransparency = 1
        fs.Position = UDim2.fromOffset(0, 20)
        fs.Size = UDim2.new(1, -60, 0, 14)
        fs.Font = Enum.Font.Gotham
        fs.TextSize = 11
        fs.TextColor3 = dw.textMuted
        fs.TextXAlignment = Enum.TextXAlignment.Left
        fs.Text = fp.Description
        fs.Parent = fq
    end
    local fs = Instance.new("TextButton")
    fs.Size = UDim2.fromOffset(40, 22)
    fs.Position = UDim2.new(1, -40, 0.5, -11)
    fs.BackgroundColor3 = dw.toggleOff
    fs.BorderSizePixel = 0
    fs.Text = ""
    fs.AutoButtonColor = false
    fs.Parent = fq
    ej(fs, 11)
    local ft = Instance.new("Frame")
    ft.Size = UDim2.fromOffset(18, 18)
    ft.Position = UDim2.fromOffset(2, 2)
    ft.BackgroundColor3 = dw.text
    ft.BorderSizePixel = 0
    ft.Parent = fs
    ej(ft, 9)
    local fu = fp.Default == true
    local function fv(fw)
        local fy = TweenInfo.new(fw and 0.18 or 0)
        TweenService:Create(fs, fy, { BackgroundColor3 = fu and dw.toggleOn or dw.toggleOff }):Play()
        TweenService:Create(ft, fy, { Position = fu and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2) }):Play()
    end
    fv(false)
    dt.__state[fp.Id] = fu
    fs.MouseButton1Click:Connect(function()
        fu = not fu
        dt.SetState(fp.Id, fu, true)
        fv(true)
        if fp.Callback then pcall(fp.Callback, fu) end
    end)
    return fs
end

function dt.AddSlider(fo, fp)
    local fq = fl(fo, 44)
    local fr = Instance.new("TextLabel")
    fr.BackgroundTransparency = 1
    fr.Size = UDim2.new(1, -80, 0, 20)
    fr.Font = Enum.Font.GothamMedium
    fr.TextSize = 13
    fr.TextColor3 = dw.text
    fr.TextXAlignment = Enum.TextXAlignment.Left
    fr.Text = fp.Title or "Slider"
    fr.Parent = fq
    local fs = Instance.new("TextLabel")
    fs.BackgroundTransparency = 1
    fs.Position = UDim2.new(1, -80, 0, 0)
    fs.Size = UDim2.fromOffset(80, 20)
    fs.Font = Enum.Font.GothamBold
    fs.TextSize = 12
    fs.TextColor3 = dw.accentHi
    fs.TextXAlignment = Enum.TextXAlignment.Right
    fs.Parent = fq
    local ft = Instance.new("Frame")
    ft.Position = UDim2.fromOffset(0, 26)
    ft.Size = UDim2.new(1, 0, 0, 6)
    ft.BackgroundColor3 = dw.toggleOff
    ft.BorderSizePixel = 0
    ft.Parent = fq
    ej(ft, 3)
    local fu = Instance.new("Frame")
    fu.Size = UDim2.new(0, 0, 1, 0)
    fu.BackgroundColor3 = dw.accent
    fu.BorderSizePixel = 0
    fu.Parent = ft
    ej(fu, 3)
    local fv = Instance.new("Frame")
    fv.Size = UDim2.fromOffset(14, 14)
    fv.AnchorPoint = Vector2.new(0.5, 0.5)
    fv.Position = UDim2.new(0, 0, 0.5, 0)
    fv.BackgroundColor3 = dw.text
    fv.BorderSizePixel = 0
    fv.Parent = ft
    ej(fv, 7)
    local fw, fx, fy = fp.Min or 0, fp.Max or 100, fp.Step or 1
    local fz = fp.Suffix or ""
    local ga = tonumber(fp.Default) or fw
    dt.__state[fp.Id] = ga
    local function gb()
        local gc = (ga - fw) / math.max(0.0001, (fx - fw))
        fu.Size = UDim2.new(gc, 0, 1, 0)
        fv.Position = UDim2.new(gc, 0, 0.5, 0)
        fs.Text = tostring(ga) .. fz
    end
    gb()
    local gc = false
    local function gd(ge)
        local gg = ft.AbsolutePosition.X
        local gh = ft.AbsoluteSize.X
        local gi = math.clamp((ge - gg) / math.max(1, gh), 0, 1)
        local gj = fw + gi * (fx - fw)
        local gk = math.floor((gj - fw) / fy + 0.5) * fy + fw
        gk = math.clamp(gk, fw, fx)
        if gk ~= ga then
            ga = gk
            dt.SetState(fp.Id, ga, true)
            gb()
            if fp.Callback then pcall(fp.Callback, ga) end
        end
    end
    ft.InputBegan:Connect(function(gf)
        if gf.UserInputType == Enum.UserInputType.MouseButton1
        or gf.UserInputType == Enum.UserInputType.Touch then
            gc = true
            gd(gf.Position.X)
        end
    end)
    du(UserInputService.InputChanged:Connect(function(gf)
        if gc and (gf.UserInputType == Enum.UserInputType.MouseMovement
        or gf.UserInputType == Enum.UserInputType.Touch) then
            gd(gf.Position.X)
        end
    end))
    du(UserInputService.InputEnded:Connect(function(gf)
        if gf.UserInputType == Enum.UserInputType.MouseButton1
        or gf.UserInputType == Enum.UserInputType.Touch then
            gc = false
        end
    end))
    return ft
end

function dt.AddDropdown(fo, fp)
    local fq = fp.Multi == true
    local fr = fl(fo, 34)
    local fs = Instance.new("TextLabel")
    fs.BackgroundTransparency = 1
    fs.Size = UDim2.new(1, -120, 1, 0)
    fs.Font = Enum.Font.GothamMedium
    fs.TextSize = 13
    fs.TextColor3 = dw.text
    fs.TextXAlignment = Enum.TextXAlignment.Left
    fs.Text = fp.Title or "Dropdown"
    fs.Parent = fr
    local ft = Instance.new("TextLabel")
    ft.BackgroundTransparency = 1
    ft.Position = UDim2.new(1, -210, 0, 0)
    ft.Size = UDim2.fromOffset(170, 34)
    ft.Font = Enum.Font.Gotham
    ft.TextSize = 12
    ft.TextColor3 = dw.textDim
    ft.TextXAlignment = Enum.TextXAlignment.Right
    ft.TextTruncate = Enum.TextTruncate.AtEnd
    ft.Parent = fr
    local fu = Instance.new("TextButton")
    fu.Size = UDim2.fromOffset(28, 24)
    fu.Position = UDim2.new(1, -32, 0.5, -12)
    fu.BackgroundColor3 = dw.toggleOff
    fu.BackgroundTransparency = 0.4
    fu.BorderSizePixel = 0
    fu.AutoButtonColor = false
    fu.Font = Enum.Font.GothamBold
    fu.TextSize = 12
    fu.TextColor3 = dw.text
    fu.Text = "v"
    fu.Parent = fr
    ej(fu, 4)

    local fv = Instance.new("Frame")
    fv.BackgroundColor3 = dw.panelBg2
    fv.BorderSizePixel = 0
    fv.Size = UDim2.new(1, 0, 0, 0)
    fv.AutomaticSize = Enum.AutomaticSize.Y
    fv.Visible = false
    fv.Parent = fo
    ej(fv, 6)
    em(fv, dw.panelBorder, 1)
    local fw = Instance.new("UIListLayout")
    fw.Padding = UDim.new(0, 2)
    fw.SortOrder = Enum.SortOrder.LayoutOrder
    fw.Parent = fv
    local fx = Instance.new("UIPadding")
    fx.PaddingTop = UDim.new(0, 4)
    fx.PaddingBottom = UDim.new(0, 4)
    fx.PaddingLeft = UDim.new(0, 4)
    fx.PaddingRight = UDim.new(0, 4)
    fx.Parent = fv

    local fy
    if fq then
        fy = {}
        if typeof(fp.Default) == "table" then
            for _, fz in ipairs(fp.Default) do fy[fz] = true end
        end
        dt.__state[fp.Id] = {}
        for fz in pairs(fy) do table.insert(dt.__state[fp.Id], fz) end
    else
        fy = fp.Default or (fp.Options and fp.Options[1])
        dt.__state[fp.Id] = fy
    end

    local function fz()
        if fq then
            local ga = {}
            for gb in pairs(fy) do if fy[gb] then table.insert(ga, gb) end end
            table.sort(ga)
            if #ga == 0 then ft.Text = "All"
            elseif #ga <= 2 then ft.Text = table.concat(ga, ", ")
            else ft.Text = string.format("%s +%d", ga[1], #ga - 1) end
        else
            ft.Text = tostring(fy or "")
        end
    end
    fz()

    local ga = {}
    for _, gb in ipairs(fp.Options or {}) do
        local gc = Instance.new("TextButton")
        gc.Size = UDim2.new(1, 0, 0, 24)
        gc.BackgroundColor3 = dw.sectionBg
        gc.BackgroundTransparency = 0.6
        gc.BorderSizePixel = 0
        gc.AutoButtonColor = false
        gc.Font = Enum.Font.Gotham
        gc.TextSize = 12
        gc.TextColor3 = dw.text
        gc.TextXAlignment = Enum.TextXAlignment.Left
        gc.Text = "  " .. tostring(gb)
        gc.Parent = fv
        ej(gc, 4)
        ga[gb] = gc

        local function gd()
            local ge
            if fq then ge = fy[gb] == true
            else ge = (fy == gb) end
            gc.TextColor3 = ge and dw.accentHi or dw.text
        end
        gd()

        gc.MouseEnter:Connect(function() TweenService:Create(gc, TweenInfo.new(0.12), { BackgroundTransparency = 0.3 }):Play() end)
        gc.MouseLeave:Connect(function()
            TweenService:Create(gc, TweenInfo.new(0.12), { BackgroundTransparency = 0.6 }):Play()
            gd()
        end)
        gc.MouseButton1Click:Connect(function()
            if fq then
                fy[gb] = not fy[gb]
                local ge = {}
                for gf, gg in pairs(fy) do if gg then table.insert(ge, gf) end end
                dt.SetState(fp.Id, ge, true)
            else
                fy = gb
                dt.SetState(fp.Id, fy, true)
            end
            for ge, gf in pairs(ga) do
                local gg = fq and fy[ge] == true or (not fq and fy == ge)
                gf.TextColor3 = gg and dw.accentHi or dw.text
            end
            fz()
            if fp.Callback then pcall(fp.Callback, dt.__state[fp.Id]) end
            if not fq then
                fv.Visible = false
                fu.Text = "v"
            end
        end)
    end

    fu.MouseButton1Click:Connect(function()
        fv.Visible = not fv.Visible
        fu.Text = fv.Visible and "^" or "v"
    end)
    return fu
end

function dt.AddButton(fo, fp)
    local fq = fl(fo, 34)
    local fr = Instance.new("TextButton")
    fr.Size = UDim2.new(1, 0, 1, 0)
    fr.BackgroundTransparency = 1
    fr.BorderSizePixel = 0
    fr.AutoButtonColor = false
    fr.Font = Enum.Font.GothamSemibold
    fr.TextSize = 13
    fr.TextColor3 = dw.text
    fr.Text = fp.Title or "Button"
    fr.TextXAlignment = Enum.TextXAlignment.Left
    fr.Parent = fq
    local fs = Instance.new("TextLabel")
    fs.BackgroundColor3 = dw.accent
    fs.BackgroundTransparency = 0.2
    fs.Size = UDim2.fromOffset(70, 24)
    fs.Position = UDim2.new(1, -70, 0.5, -12)
    fs.Font = Enum.Font.GothamBold
    fs.TextSize = 12
    fs.TextColor3 = dw.text
    fs.Text = fp.Text or "Run"
    fs.Parent = fq
    ej(fs, 4)
    fr.MouseEnter:Connect(function() TweenService:Create(fs, TweenInfo.new(0.12), { BackgroundTransparency = 0 }):Play() end)
    fr.MouseLeave:Connect(function() TweenService:Create(fs, TweenInfo.new(0.12), { BackgroundTransparency = 0.2 }):Play() end)
    fr.MouseButton1Click:Connect(function()
        if fp.Callback then pcall(fp.Callback) end
    end)
    return fr
end

function dt.AddParagraph(fo, fp)
    local fq = fl(fo, 44)
    local fr = Instance.new("TextLabel")
    fr.BackgroundTransparency = 1
    fr.Size = UDim2.new(1, 0, 0, 18)
    fr.Font = Enum.Font.GothamBold
    fr.TextSize = 12
    fr.TextColor3 = dw.text
    fr.TextXAlignment = Enum.TextXAlignment.Left
    fr.Text = fp.Title or ""
    fr.Parent = fq
    local fs = Instance.new("TextLabel")
    fs.BackgroundTransparency = 1
    fs.Position = UDim2.fromOffset(0, 18)
    fs.Size = UDim2.new(1, 0, 0, 26)
    fs.Font = Enum.Font.Gotham
    fs.TextSize = 11
    fs.TextColor3 = dw.textDim
    fs.TextXAlignment = Enum.TextXAlignment.Left
    fs.TextWrapped = true
    fs.TextYAlignment = Enum.TextYAlignment.Top
    fs.Text = fp.Content or ""
    fs.Parent = fq
    return fq
end

function dt.AddDivider(fo, fp)
    local fq = Instance.new("Frame")
    fq.BackgroundTransparency = 1
    fq.Size = UDim2.new(1, 0, 0, 12)
    fq.Parent = fo
    local fr = Instance.new("Frame")
    fr.BackgroundColor3 = dw.panelBorder
    fr.BorderSizePixel = 0
    fr.Position = UDim2.new(0, 0, 0.5, 0)
    fr.Size = UDim2.new(1, 0, 0, 1)
    fr.Parent = fq
    if fp and fp.Title then
        local fs = Instance.new("TextLabel")
        fs.BackgroundTransparency = 1
        fs.Size = UDim2.new(1, 0, 1, 0)
        fs.Font = Enum.Font.Gotham
        fs.TextSize = 11
        fs.TextColor3 = dw.textMuted
        fs.TextXAlignment = Enum.TextXAlignment.Center
        fs.Text = fp.Title
        fs.Parent = fq
    end
    return fq
end

function dt.AddStatus(fo, fp)
    local fq = fl(fo, 26)
    local fr = Instance.new("TextLabel")
    fr.BackgroundTransparency = 1
    fr.Size = UDim2.new(0.6, 0, 1, 0)
    fr.Font = Enum.Font.Gotham
    fr.TextSize = 12
    fr.TextColor3 = dw.textDim
    fr.TextXAlignment = Enum.TextXAlignment.Left
    fr.Text = fp.Title or "Status"
    fr.Parent = fq
    local fs = Instance.new("TextLabel")
    fs.BackgroundTransparency = 1
    fs.Size = UDim2.new(0.4, 0, 1, 0)
    fs.Position = UDim2.fromScale(0.6, 0)
    fs.Font = Enum.Font.GothamBold
    fs.TextSize = 12
    fs.TextColor3 = dw.text
    fs.TextXAlignment = Enum.TextXAlignment.Right
    fs.Text = tostring(fp.Value or "")
    fs.Parent = fq
    local ft = {}
    function ft.SetValue(fu) fs.Text = tostring(fu) end
    function ft.SetStatus(fu)
        if fu == "Success" then fs.TextColor3 = dw.success
        elseif fu == "Warning" then fs.TextColor3 = dw.warning
        elseif fu == "Error" then fs.TextColor3 = dw.error
        elseif fu == "Info" then fs.TextColor3 = dw.info
        else fs.TextColor3 = dw.text end
    end
    return ft
end

function dt.AddInput(fo, fp)
    local fq = fl(fo, 34)
    local fr = Instance.new("TextLabel")
    fr.BackgroundTransparency = 1
    fr.Size = UDim2.new(0.4, 0, 1, 0)
    fr.Font = Enum.Font.GothamMedium
    fr.TextSize = 13
    fr.TextColor3 = dw.text
    fr.TextXAlignment = Enum.TextXAlignment.Left
    fr.Text = fp.Title or "Input"
    fr.Parent = fq
    local fs = Instance.new("TextBox")
    fs.BackgroundColor3 = dw.toggleOff
    fs.BackgroundTransparency = 0.2
    fs.BorderSizePixel = 0
    fs.Position = UDim2.fromScale(0.42, 0.5)
    fs.AnchorPoint = Vector2.new(0, 0.5)
    fs.Size = UDim2.new(0.58, -10, 0, 26)
    fs.Font = Enum.Font.Gotham
    fs.TextSize = 12
    fs.TextColor3 = dw.text
    fs.PlaceholderColor3 = dw.textMuted
    fs.PlaceholderText = fp.Placeholder or ""
    fs.Text = tostring(fp.Default or "")
    fs.ClearTextOnFocus = false
    fs.TextXAlignment = Enum.TextXAlignment.Left
    fs.Parent = fq
    ej(fs, 4)
    local ft = Instance.new("UIPadding")
    ft.PaddingLeft = UDim.new(0, 8)
    ft.PaddingRight = UDim.new(0, 8)
    ft.Parent = fs
    dt.__state[fp.Id] = fs.Text
    fs.FocusLost:Connect(function()
        dt.SetState(fp.Id, fs.Text, true)
        if fp.Callback then pcall(fp.Callback, fs.Text) end
    end)
    return fs
end

local fo = Instance.new("Frame")
fo.BackgroundTransparency = 1
fo.AnchorPoint = Vector2.new(1, 1)
fo.Position = UDim2.new(1, -16, 1, -16)
fo.Size = UDim2.fromOffset(280, 400)
fo.Parent = dy
local fp = Instance.new("UIListLayout")
fp.Padding = UDim.new(0, 6)
fp.SortOrder = Enum.SortOrder.LayoutOrder
fp.VerticalAlignment = Enum.VerticalAlignment.Bottom
fp.HorizontalAlignment = Enum.HorizontalAlignment.Right
fp.Parent = fo

function Hub.notify(fq, fr, fs, ft)
    local fu = Instance.new("Frame")
    fu.BackgroundColor3 = dw.panelBg
    fu.BackgroundTransparency = 0.05
    fu.BorderSizePixel = 0
    fu.Size = UDim2.fromOffset(260, 52)
    fu.Parent = fo
    ej(fu, 8)
    local fv = dw.panelBorderHi
    if fs == "Success" then fv = dw.success
    elseif fs == "Warning" then fv = dw.warning
    elseif fs == "Error" then fv = dw.error
    elseif fs == "Info" then fv = dw.info end
    em(fu, fv, 1.5)
    local fw = Instance.new("TextLabel")
    fw.BackgroundTransparency = 1
    fw.Position = UDim2.fromOffset(12, 6)
    fw.Size = UDim2.new(1, -24, 0, 18)
    fw.Font = Enum.Font.GothamBold
    fw.TextSize = 13
    fw.TextColor3 = fv
    fw.TextXAlignment = Enum.TextXAlignment.Left
    fw.Text = tostring(fq or "Apex Hub")
    fw.Parent = fu
    local fx = Instance.new("TextLabel")
    fx.BackgroundTransparency = 1
    fx.Position = UDim2.fromOffset(12, 24)
    fx.Size = UDim2.new(1, -24, 0, 22)
    fx.Font = Enum.Font.Gotham
    fx.TextSize = 11
    fx.TextColor3 = dw.textDim
    fx.TextXAlignment = Enum.TextXAlignment.Left
    fx.TextWrapped = true
    fx.TextYAlignment = Enum.TextYAlignment.Top
    fx.Text = tostring(fr or "")
    fx.Parent = fu
    task.delay(tonumber(ft) or 3, function()
        local fy = TweenInfo.new(0.25)
        TweenService:Create(fu, fy, { BackgroundTransparency = 1 }):Play()
        for _, fz in ipairs(fu:GetDescendants()) do
            if fz:IsA("TextLabel") then TweenService:Create(fz, fy, { TextTransparency = 1 }):Play()
            elseif fz:IsA("UIStroke") then TweenService:Create(fz, fy, { Transparency = 1 }):Play() end
        end
        task.wait(0.3)
        fu:Destroy()
    end)
    return fu
end

-- ============================================================
-- BUILD UI
-- ============================================================
local fq = {}

do
    local fr = dt.AddTab({ Id = "home", Title = "Home" })
    local fs = dt.AddSection(fr, { Title = "Session", Description = "Live status" })
    local ft = dt.AddSection(fr, { Title = "Account", Description = "Save data" })
    local fu = dt.AddSection(fr, { Title = "Quick Actions" })
    local fv = dt.AddSection(fr, { Title = "Quick Start" })

    fq.statusRow = dt.AddStatus(fs, { Title = "Automation", Value = "Ready" })
    fq.statusRow:SetStatus("Success")
    fq.jobRow = dt.AddStatus(fs, { Title = "Current Job", Value = "Idle" })
    fq.stolenRow = dt.AddStatus(fs, { Title = "Stolen Eggs", Value = "0" })
    fq.carryingRow = dt.AddStatus(fs, { Title = "Carrying Egg", Value = "No" })
    fq.runtimeRow = dt.AddStatus(fs, { Title = "Runtime", Value = "0m" })
    dt.AddStatus(fs, { Title = "Server", Value = jobIdLabel })

    fq.inventoryProgress = dt.AddStatus(ft, { Title = "Egg Inventory", Value = tostring(Hub.eggInventoryCount()) })
    fq.moneyRow = dt.AddStatus(ft, { Title = "Money", Value = "0" })
    fq.speedRow = dt.AddStatus(ft, { Title = "Speed Power", Value = "0" })
    fq.rebirthRow = dt.AddStatus(ft, { Title = "Rebirths", Value = "0" })
    fq.petsOwnedRow = dt.AddStatus(ft, { Title = "Pets Owned", Value = "0" })

    dt.AddButton(fu, { Title = "Return to Base", Text = "Return", Callback = function()
        task.spawn(function()
            if not Hub.getBasePosition() or not Hub.returnToBaseBypass(nil) then
                Hub.notify("Return", "Base unavailable", "Warning", 3)
            end
        end)
    end })
    dt.AddButton(fu, { Title = "Place Eggs", Text = "Place", Callback = function()
        task.spawn(function() Hub.runAutoPlaceEggs(true) end)
    end })
    dt.AddButton(fu, { Title = "Server Hop", Text = "Hop", Callback = function()
        task.spawn(function() hopCooldownUntil = 0; Hub.serverHop("Manual") end)
    end })
    dt.AddButton(fu, { Title = "Fuse Now", Text = "Fuse", Callback = function()
        task.spawn(function() Hub.runAutoFusePets(true) end)
    end })

    dt.AddParagraph(fv, { Title = "Farm flow",
        Content = "Grab1 -> Hold 3s -> Release -> Grab2 -> Return Base. Hold time " .. HOLD_DURATION .. "s." })
    dt.AddParagraph(fv, { Title = "Filters",
        Content = "Empty multi-select filters mean everything matches." })

    local fw = dt.AddTab({ Id = "farm", Title = "Farm" })
    local fx = dt.AddSection(fw, { Title = "Steal Eggs", Description = "Main egg farming" })
    local fy = dt.AddSection(fw, { Title = "Egg Handling" })
    local fz = dt.AddSection(fw, { Title = "Server Hop" })
    local ga = dt.AddSection(fw, { Title = "Task Order" })

    dt.AddToggle(fx, { Id = "AutoStealSelected", Title = "Auto Steal Selected", Description = "Use filters below", Default = false })
    dt.AddToggle(fx, { Id = "AutoStealAll", Title = "Auto Steal All", Description = "Ignore rarity/mutation", Default = false })
    dt.AddToggle(fx, { Id = "StealBigEggs", Title = "Steal Big Eggs", Default = false })

    dt.AddSlider(fx, {
        Id = "StealMoveSpeed",
        Title = "Steal Speed",
        Min = 16, Max = 2000,
        Default = STEAL_SPEED_DEFAULT,
        Step = 1,
        Suffix = " studs/s",
    })

    dt.AddSlider(fx, {
        Id = "BypassReturnSpeed",
        Title = "Return Speed",
        Min = 16, Max = 2000,
        Default = BYPASS_SPEED_DEFAULT,
        Step = 1,
        Suffix = " studs/s",
    })

    dt.AddDivider(fx, { Title = "Target filters" })
    dt.AddDropdown(fx, { Id = "StealZones", Title = "Areas", Options = areaList, Multi = true, Default = {} })
    dt.AddDropdown(fx, { Id = "StealRarities", Title = "Rarities", Options = RARITY_NAMES, Multi = true, Default = {} })
    dt.AddDropdown(fx, { Id = "StealMutations", Title = "Mutations", Options = MUTATION_NAMES, Multi = true, Default = {} })
    dt.AddDropdown(fx, { Id = "StealPriority", Title = "Target Priority", Options = STEAL_PRIORITY_OPTIONS, Default = "Rarest" })
    dt.AddSlider(fx, { Id = "StealBigEggScale", Title = "Minimum Big Egg Size", Min = 1, Max = 50, Default = 1.5, Step = 0.1, Suffix = "x" })
    dt.AddDivider(fx, { Title = "Carry behavior" })
    dt.AddToggle(fx, { Id = "StealByTeleport", Title = "Steal by Teleport", Description = "Teleport to egg and back to base", Default = false })
    dt.AddToggle(fx, { Id = "AutoReturn", Title = "Auto Return to Base", Default = true })
    dt.AddToggle(fx, { Id = "AutoDropEgg", Title = "Auto Drop Held Egg", Default = false })

    dt.AddToggle(fy, { Id = "AutoPlaceSelected", Title = "Auto Place Selected", Default = false })
    dt.AddToggle(fy, { Id = "AutoPlaceAll", Title = "Auto Place All", Default = false })
    dt.AddToggle(fy, { Id = "AutoOpenReadyEggs", Title = "Auto Hatch Ready", Default = false })
    dt.AddDropdown(fy, { Id = "LifecycleRarities", Title = "Lifecycle Rarities", Options = RARITY_NAMES, Multi = true, Default = {} })
    dt.AddDropdown(fy, { Id = "LifecycleMutations", Title = "Lifecycle Mutations", Options = MUTATION_NAMES, Multi = true, Default = {} })
    dt.AddDivider(fy, { Title = "Egg selling" })
    dt.AddToggle(fy, { Id = "AutoSellEggs", Title = "Auto Sell Eggs", Default = false })
    dt.AddDropdown(fy, { Id = "SellEggRarities", Title = "Sell Rarities", Options = RARITY_NAMES, Multi = true, Default = {} })
    dt.AddSlider(fy, { Id = "SellEggInterval", Title = "Sell Interval", Min = 1, Max = 120, Default = 8, Step = 1, Suffix = " s" })

    dt.AddToggle(fz, { Id = "AutoServerHop", Title = "Auto Server Hop", Default = false })
    dt.AddDropdown(fz, { Id = "HopMode", Title = "Hop When", Options = HOP_MODE_OPTIONS, Default = "No Matching Eggs" })
    dt.AddSlider(fz, { Id = "HopValue", Title = "Wait Before Hop", Min = 1, Max = 200, Default = 15, Step = 1 })
    dt.AddButton(fz, { Title = "Hop Now", Text = "Hop", Callback = function()
        task.spawn(function() hopCooldownUntil = 0; Hub.serverHop("Manual") end)
    end })

    dt.AddParagraph(ga, { Content = "Runs the first ready task in your priority list." })
    for gb, gc in ipairs(PRIORITY_SLOTS) do
        dt.AddDropdown(ga, { Id = gc, Title = "Priority " .. gb, Options = TASK_NAMES, Default = TASK_NAMES[gb] })
    end

    local gb = dt.AddTab({ Id = "pets", Title = "Pets" })
    local gc = dt.AddSection(gb, { Title = "Pets" })
    local gd = dt.AddSection(gb, { Title = "Auto Fuse" })
    local ge = dt.AddSection(gb, { Title = "Auto Sell Pets" })

    dt.AddToggle(gc, { Id = "AutoEquipBest", Title = "Auto Equip Best Pets", Default = false })
    dt.AddToggle(gc, { Id = "AutoDeleteOwnPets", Title = "Hide Own Pet Renders", Default = false })
    dt.AddToggle(gd, { Id = "AutoFusePets", Title = "Auto Fuse Pets", Default = false })
    dt.AddDropdown(gd, { Id = "FuseRarities", Title = "Fuse Rarities", Options = RARITY_NAMES, Multi = true, Default = {} })
    dt.AddDropdown(gd, { Id = "FuseMutations", Title = "Fuse Mutations", Options = MUTATION_NAMES, Multi = true, Default = {} })
    dt.AddDropdown(gd, { Id = "FuseTarget", Title = "Pick Group By", Options = FUSE_TARGET_OPTIONS, Default = "Highest Rarity" })
    dt.AddToggle(gd, { Id = "FuseKeepMutated", Title = "Never Fuse Mutated", Default = true })
    dt.AddToggle(gd, { Id = "FuseKeepEquipped", Title = "Never Fuse Equipped", Default = true })
    dt.AddToggle(gd, { Id = "FuseAutoReveal", Title = "Auto Complete Reveal", Default = true })
    dt.AddSlider(gd, { Id = "FuseMaxScale", Title = "Maximum Scale to Fuse", Min = 0, Max = 10, Default = 10, Step = 0.1 })
    dt.AddSlider(gd, { Id = "FuseKeepPerCategory", Title = "Keep Per Pet Type", Min = 0, Max = 20, Default = 0, Step = 1 })
    dt.AddSlider(gd, { Id = "FuseInterval", Title = "Fuse Interval", Min = 1, Max = 120, Default = 8, Step = 1, Suffix = " s" })
    dt.AddButton(gd, { Title = "Fuse Now", Text = "Fuse", Callback = function() task.spawn(function() Hub.runAutoFusePets(true) end) end })

    dt.AddToggle(ge, { Id = "AutoSellPets", Title = "Auto Sell Pets", Default = false })
    dt.AddDropdown(ge, { Id = "SellRarities", Title = "Sell Rarities", Options = RARITY_NAMES, Multi = true, Default = {} })
    dt.AddDropdown(ge, { Id = "SellMutations", Title = "Sell Mutations", Options = MUTATION_NAMES, Multi = true, Default = {} })
    dt.AddToggle(ge, { Id = "SellKeepMutated", Title = "Never Sell Mutated", Default = true })
    dt.AddToggle(ge, { Id = "SellKeepEquipped", Title = "Never Sell Equipped", Default = true })
    dt.AddSlider(ge, { Id = "SellMaxScale", Title = "Maximum Scale to Sell", Min = 0, Max = 10, Default = 10, Step = 0.1 })
    dt.AddSlider(ge, { Id = "SellInterval", Title = "Sell Interval", Min = 1, Max = 120, Default = 6, Step = 1, Suffix = " s" })

    local gf = dt.AddTab({ Id = "progress", Title = "Progress" })
    local gg = dt.AddSection(gf, { Title = "Upgrades" })
    local gh = dt.AddSection(gf, { Title = "Rewards" })
    local gi = dt.AddSection(gf, { Title = "Equipment" })
    local gj = dt.AddSection(gf, { Title = "Training" })
    dt.AddToggle(gg, { Id = "AutoUpgrades", Title = "Auto Buy Upgrades", Default = false })
    dt.AddDropdown(gg, { Id = "UpgradeTypes", Title = "Upgrade Types", Options = UPGRADE_TYPES, Multi = true, Default = { "Base", "Treadmill" } })
    dt.AddToggle(gh, { Id = "AutoClaimIndex", Title = "Auto Claim Index", Default = false })
    dt.AddToggle(gh, { Id = "AutoClaimGroupReward", Title = "Auto Claim Group Reward", Default = false })
    dt.AddToggle(gh, { Id = "AutoClaimOffline", Title = "Claim Offline Earnings", Default = false })
    dt.AddToggle(gi, { Id = "AutoBuyTrail", Title = "Auto Buy Trail", Default = false })
    dt.AddDropdown(gi, { Id = "TrailWanted", Title = "Trails", Options = trailNames, Multi = true, Default = {} })
    dt.AddToggle(gi, { Id = "AutoEquipBestTrail", Title = "Auto Equip Best Trail", Default = false })
    dt.AddToggle(gi, { Id = "AutoEquipBestGear", Title = "Auto Equip Best Gear", Default = false })
    dt.AddToggle(gj, { Id = "AutoTreadmill", Title = "Auto Treadmill Training", Default = false })

    local gk = dt.AddTab({ Id = "player", Title = "Player" })
    local gl = dt.AddSection(gk, { Title = "ESP" })
    local gm = dt.AddSection(gk, { Title = "Movement" })
    local gn = dt.AddSection(gk, { Title = "Teleports" })
    dt.AddToggle(gl, { Id = "EspWorldEggs", Title = "World Egg ESP", Default = false })
    dt.AddToggle(gl, { Id = "EspCarriedEggs", Title = "Carried and Dropped Egg ESP", Default = false })
    dt.AddToggle(gl, { Id = "EspGuards", Title = "Guard ESP", Default = false })
    dt.AddToggle(gl, { Id = "EspPets", Title = "Pet ESP", Default = false })
    dt.AddToggle(gl, { Id = "EspPlayers", Title = "Player ESP", Default = false })
    dt.AddToggle(gl, { Id = "EspMachines", Title = "Machine ESP", Default = false })
    dt.AddToggle(gl, { Id = "EspPlots", Title = "Plot ESP", Default = false })
    dt.AddSlider(gl, { Id = "EspDistance", Title = "Render Distance", Min = 100, Max = 6000, Default = 2000, Step = 50, Suffix = " studs" })
    dt.AddToggle(gm, { Id = "WalkSpeedEnabled", Title = "Walk Speed Override", Default = false })
    dt.AddSlider(gm, { Id = "WalkSpeed", Title = "Walk Speed", Min = 16, Max = 500, Default = 32, Step = 1 })
    dt.AddToggle(gm, { Id = "JumpPowerEnabled", Title = "Jump Power Override", Default = false })
    dt.AddSlider(gm, { Id = "JumpPower", Title = "Jump Power", Min = 10, Max = 500, Default = 50, Step = 1 })
    dt.AddToggle(gm, { Id = "InfJump", Title = "Infinite Jump", Default = false })
    dt.AddToggle(gm, { Id = "NoClip", Title = "NoClip", Default = false })
    dt.AddDivider(gm, { Title = "Fly" })
    dt.AddToggle(gm, { Id = "Fly", Title = "Fly", Default = false, Callback = function(go)
        if not go then
            local gp = Hub.getHumanoid(); if gp then gp.PlatformStand = false end
            local gq = Hub.getRoot()
            local gr = gq and gq:FindFirstChild("ApexFlyLV")
            if gr then gr:Destroy() end
        end
    end })
    dt.AddSlider(gm, { Id = "FlySpeed", Title = "Fly Speed", Min = 10, Max = 400, Default = 60, Step = 1 })
    dt.AddDropdown(gn, { Id = "WaypointTarget", Title = "Waypoint", Options = waypointNames, Default = "Base" })
    dt.AddButton(gn, { Title = "Teleport to Waypoint", Text = "Go", Callback = function()
        task.spawn(function()
            local go = Hub.resolveWaypoint(Hub.optionValue("WaypointTarget", "Base"))
            if not go then Hub.notify("Waypoint", "Unavailable", "Warning", 3); return end
            if not Hub.bypassMoveTo(go, nil, Hub.bypassSpeed()) then Hub.notify("Waypoint", "Failed", "Error", 3) end
        end)
    end })

    local go = dt.AddTab({ Id = "system", Title = "System" })
    local gp = dt.AddSection(go, { Title = "Session" })
    local gq = dt.AddSection(go, { Title = "Performance" })
    local gr = dt.AddSection(go, { Title = "Webhooks" })
    local gs = dt.AddSection(go, { Title = "About" })
    dt.AddToggle(gp, { Id = "AntiAfk", Title = "Anti-AFK", Default = true })
    dt.AddToggle(gp, { Id = "AntiGameplayPause", Title = "No Gameplay Paused", Default = true,
        Callback = function(gt) Hub.applyAntiGameplayPause(gt) end })
    dt.AddToggle(gp, { Id = "AutoReconnect", Title = "Auto Reconnect", Default = false })
    dt.AddButton(gp, { Title = "Rejoin Server", Text = "Rejoin", Callback = function() Hub.rejoinServer() end })
    dt.AddButton(gp, { Title = "Copy Join Script", Text = "Copy", Callback = function()
        pcall(function() setclipboard(string.format(
            'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game:GetService("Players").LocalPlayer)',
            game.PlaceId, jobId)) end)
        Hub.notify("Copied", "Join script copied", "Success", 3)
    end })
    dt.AddToggle(gq, { Id = "FpsBoost", Title = "FPS Boost", Default = false,
        Callback = function(gt) if gt then Hub.enableFpsBoost() else Hub.disableFpsBoost() end end })
    dt.AddToggle(gq, { Id = "DisableRendering", Title = "Disable 3D Rendering", Default = false,
        Callback = function(gt) Hub.applyRendering(gt) end })
    dt.AddSlider(gq, { Id = "FpsCap", Title = "FPS Cap", Min = 15, Max = 360, Default = 60, Step = 1, Suffix = " fps",
        Callback = function(gt) Hub.applyFpsCap(gt) end })
    dt.AddToggle(gr, { Id = "WebhookEnabled", Title = "Enable Webhooks", Default = false })
    dt.AddInput(gr, { Id = "WebhookUrl", Title = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Default = "" })
    dt.AddInput(gr, { Id = "WebhookPingId", Title = "Ping User ID", Placeholder = "123456789012345678", Default = "" })
    dt.AddSlider(gr, { Id = "WebhookInterval", Title = "Summary Interval", Min = 1, Max = 180, Default = 15, Step = 1, Suffix = " min" })
    dt.AddToggle(gr, { Id = "WebhookEggSpawns", Title = "List Spawned Eggs", Default = true })
    dt.AddDropdown(gr, { Id = "WebhookRarities", Title = "Rarities", Options = RARITY_NAMES, Multi = true, Default = {} })
    dt.AddToggle(gr, { Id = "WebhookDisconnectAlerts", Title = "Disconnect Alerts", Default = false })
    dt.AddButton(gr, { Title = "Send Summary Now", Text = "Send", Callback = function()
        task.spawn(function()
            local gt = Hub.sendSummary()
            Hub.notify("Webhook", gt and "Sent" or "Failed", gt and "Success" or "Error", 3)
        end)
    end })
    dt.AddParagraph(gs, { Title = "Script Dev", Content = "Apex" })
    dt.AddParagraph(gs, { Title = "UI", Content = "Standalone custom UI" })
    dt.AddParagraph(gs, { Title = "Discord", Content = n })
    dt.AddButton(gs, { Title = "Copy Discord Link", Text = "Copy", Callback = function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        Hub.notify("Copied", "Discord link copied", "Success", 3)
    end })
    dt.AddDivider(gs, { Title = "Danger Zone" })
    dt.AddButton(gs, { Title = "Unload Script", Text = "Unload", Callback = function() Hub.unload() end })
end

-- ============================================================
-- DASHBOARD REFRESH
-- ============================================================
local function fr()
    if not isRunning then return end
    pcall(function()
        if fq.carryingRow then
            fq.carryingRow:SetValue(carryingEgg and "Yes" or "No")
            fq.carryingRow:SetStatus(carryingEgg and "Warning" or "Neutral")
        end
        if fq.runtimeRow then fq.runtimeRow:SetValue(Hub.formatElapsed(os.clock() - scriptStartTime)) end
        if fq.inventoryProgress then
            fq.inventoryProgress:SetValue(string.format("%d / %s", Hub.eggInventoryCount(),
                tostring(eggsModule and eggsModule.MAX_INVENTORY or "?")))
        end
        local save = Hub.getSave()
        if save then
            if fq.moneyRow then fq.moneyRow:SetValue(Hub.formatNumber(save.Money)) end
            if fq.speedRow then fq.speedRow:SetValue(Hub.formatNumber(save.SpeedPower)) end
            if fq.rebirthRow then fq.rebirthRow:SetValue(tostring(save.Rebirth or 0)) end
            if fq.petsOwnedRow then fq.petsOwnedRow:SetValue(tostring(Hub.countTable(save.Inventory))) end
        end
        if fq.stolenRow then fq.stolenRow:SetValue(tostring(stolenEggs)) end
    end)
end
fr()

-- ============================================================
-- UNLOAD
-- ============================================================
function Hub.unload()
    if not isRunning then return end
    isRunning = false
    pcall(Hub.stopTreadmillTraining)
    pcall(function() Hub.applyAntiGameplayPause(false) end)
    pcall(function() Hub.applyRendering(false) end)
    pcall(Hub.disableFpsBoost)
    pcall(Hub.clearAllEsp)
    if espFolder then pcall(function() espFolder:Destroy() end) end
    for _, connection in ipairs(trackedConnections) do
        pcall(function() if typeof(connection) == "RBXScriptConnection" then connection:Disconnect() end end)
    end
    Hub.clearTable(trackedConnections)
    for _, connection in ipairs(dt.__connections) do
        pcall(function() if typeof(connection) == "RBXScriptConnection" then connection:Disconnect() end end)
    end
    pcall(function() dy:Destroy() end)
    pcall(function() dz:Destroy() end)
    GLOBAL_ENV.__APEX_HUB_RUNNING = nil
    GLOBAL_ENV.__APEX_HUB_SHUTDOWN = nil
end
GLOBAL_ENV.__APEX_HUB_SHUTDOWN = Hub.unload

-- ============================================================
-- CONNECTIONS
-- ============================================================
local function fs(ft)
    if ft and ft:IsA("BasePart") then ft.CanCollide = false end
end
local fu = nil
local function fv(fw)
    if fu then pcall(function() fu:Disconnect() end); fu = nil end
    local character = LocalPlayer.Character
    if not fw or not character then return end
    for _, descendant in ipairs(character:GetDescendants()) do fs(descendant) end
    fu = character.DescendantAdded:Connect(fs)
    Hub.track(fu)
end

Hub.track(UserInputService.JumpRequest:Connect(function()
    if not isRunning or not Hub.isOn("InfJump") then return end
    local humanoid = Hub.getHumanoid()
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

Hub.track(RunService.RenderStepped:Connect(function(fx)
    if not isRunning or not Hub.isOn("Fly") then return end
    local root = Hub.getRoot(); local humanoid = Hub.getHumanoid()
    local camera = Workspace.CurrentCamera
    if not root or not humanoid or not camera then return end

    humanoid.PlatformStand = true

    local linearVelocity = root:FindFirstChild("ApexFlyLV")
    if not linearVelocity then
        linearVelocity = Instance.new("LinearVelocity")
        linearVelocity.Name = "ApexFlyLV"
        linearVelocity.MaxForce = 1e6
        linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
        local attachment = Instance.new("Attachment")
        attachment.Name = "ApexFlyAttachment"
        attachment.Parent = root
        linearVelocity.Attachment0 = attachment
        linearVelocity.Parent = root
    end

    local moveVector = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector - Vector3.new(0, 1, 0) end

    local flySpeed = math.min(tonumber(Hub.optionValue("FlySpeed", 60)) or 60, MAX_SPEED)
    if moveVector.Magnitude > 0 then
        linearVelocity.VectorVelocity = moveVector.Unit * flySpeed
    else
        linearVelocity.VectorVelocity = Vector3.zero
    end
end))

Hub.track(UserInputService.InputBegan:Connect(function() lastInputTick = tick() end))
Hub.track(UserInputService.InputChanged:Connect(function(input)
    local inputType = input.UserInputType
    if inputType == Enum.UserInputType.MouseMovement or inputType == Enum.UserInputType.Gamepad1 then lastInputTick = tick() end
end))

Hub.track(LocalPlayer.CharacterAdded:Connect(function()
    if not isRunning then return end
    task.delay(0.35, function()
        if Hub.stealingEnabled() then Hub.swapStealHumanoid() end
        if Hub.isOn("NoClip") then fv(true) end
    end)
end))

Hub.track(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.End then Hub.unload() end
end))

-- ============================================================
-- SCHEDULER
-- ============================================================
local fx = {}
local fy = false
local function fz(ga, gb)
    local now = os.clock()
    if now < (fx[ga] or 0) then return false end
    fx[ga] = now + gb
    return true
end

local function gc()
    if taskBusy then return end
    if Hub.isOn("AutoDropEgg") and carryingEgg then
        taskBusy = true; pcall(Hub.runAutoDropEgg); taskBusy = false; return
    end
    if Hub.isOn("AutoReturn") and carryingEgg then
        taskBusy = true; pcall(Hub.runAutoReturn); taskBusy = false
    end
end

local function gd()
    if taskBusy then return end
    local order = Hub.priorityOrder()
    if #order < 1 then return end
    for _, taskName in ipairs(order) do
        local task = tasks[taskName]
        local ready = task and task.Ready()
        if ready then
            local lastRunAt = taskLastRunAt[taskName] or 0
            ready = os.clock() - lastRunAt >= task.Interval
        end
        if ready then
            taskLastRunAt[taskName] = os.clock()
            if taskName ~= "Auto Treadmill" and (treadmillTraining or Hub.isDoubleSpeedVisible()) then
                pcall(Hub.stopTreadmillTraining)
            end
            taskBusy = true
            local ok, result = pcall(task.Run)
            taskBusy = false
            if ok and result then return end
        end
    end
end

Hub.track(RunService.Heartbeat:Connect(function()
    if not isRunning then return end

    if fz("core", 0.35) then
        task.spawn(function()
            if Hub.stealingEnabled() then Hub.swapStealHumanoid() end
            gc()
            gd()
        end)
    end

    if fz("dashboard", 2) then
        fr()
        local noClip = Hub.isOn("NoClip")
        if noClip ~= fy then fy = noClip; fv(noClip) end
        if Hub.isOn("WalkSpeedEnabled") then
            local humanoid = Hub.getHumanoid()
            if humanoid then
                humanoid.WalkSpeed = math.min(tonumber(Hub.optionValue("WalkSpeed", 32)) or 32, MAX_SPEED)
            end
        end
        if Hub.isOn("JumpPowerEnabled") then
            local humanoid = Hub.getHumanoid()
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = tonumber(Hub.optionValue("JumpPower", 50)) or 50
            end
        end
        if treadmillTraining or Hub.isDoubleSpeedVisible() then
            if not Hub.isOn("AutoTreadmill") then pcall(Hub.stopTreadmillTraining) end
        end
        if Hub.isOn("AntiGameplayPause") then Hub.applyAntiGameplayPause(true) end
    end

    if fz("esp", 1.25) then
        local espEnabled = Hub.isOn("EspWorldEggs") or Hub.isOn("EspCarriedEggs") or Hub.isOn("EspGuards")
            or Hub.isOn("EspPets") or Hub.isOn("EspPlayers") or Hub.isOn("EspMachines") or Hub.isOn("EspPlots")
        if espEnabled then pcall(Hub.runEsp)
        elseif next(espObjects) ~= nil then pcall(Hub.clearAllEsp) end
    end

    if fz("pets", 5) then
        if Hub.isOn("AutoEquipBest") and not taskBusy then pcall(Hub.runAutoEquipBest) end
        if Hub.isOn("AutoEquipBestTrail") then pcall(Hub.runAutoEquipBestTrail) end
        if Hub.isOn("AutoEquipBestGear") then pcall(Hub.runAutoEquipBestGear) end
        if Hub.isOn("AutoDeleteOwnPets") then pcall(Hub.deleteOwnPetRenders) end
    end

    if fz("fuse", tonumber(Hub.optionValue("FuseInterval", 8)) or 8) then
        if Hub.isOn("AutoFusePets") and not taskBusy and not carryingEgg then
            taskBusy = true; pcall(Hub.runAutoFusePets); taskBusy = false
        end
    end

    if fz("sellPets", tonumber(Hub.optionValue("SellInterval", 6)) or 6) then
        if Hub.isOn("AutoSellPets") and not taskBusy and not carryingEgg then pcall(Hub.runAutoSellPets) end
    end

    if fz("sellEggs", tonumber(Hub.optionValue("SellEggInterval", 8)) or 8) then
        if Hub.isOn("AutoSellEggs") and not taskBusy and not carryingEgg then
            taskBusy = true; pcall(Hub.runAutoSellEggs); taskBusy = false
        end
    end

    if fz("upgrades", 4) then
        if Hub.isOn("AutoUpgrades") and not carryingEgg then pcall(Hub.runAutoUpgrades) end
        if Hub.isOn("AutoBuyTrail") and not carryingEgg then pcall(Hub.runAutoBuyTrail) end
    end

    if fz("claims", 12) then
        if Hub.isOn("AutoClaimIndex") then pcall(Hub.runAutoClaimIndex) end
        if Hub.isOn("AutoClaimOffline") then pcall(Hub.runClaimOfflineEarnings) end
        if Hub.isOn("AutoClaimGroupReward") then pcall(Hub.runAutoClaimGroupReward) end
    end

    if fz("hop", 3) then
        if Hub.isOn("AutoServerHop") and not taskBusy then pcall(Hub.runServerHop) end
    end

    if fz("webhook", 5) then
        if Hub.isOn("WebhookEnabled") then
            pcall(Hub.trackWebhookEvents)
            pcall(Hub.runWebhookSummary)
        end
    end

    if fz("session", 4) then
        if Hub.isOn("AntiAfk") then
            local lastKeyTime = tick() - lastInputTick
            local lastJumpTime = tick() - lastAntiAfkJumpTick
            if (lastKeyTime >= 300 and lastJumpTime >= 60) or (lastKeyTime < 300 and lastJumpTime >= 300) then
                pcall(function()
                    local humanoid = Hub.getHumanoid()
                    if humanoid then
                        humanoid.Jump = true
                        lastAntiAfkJumpTick = tick()
                    end
                end)
            end
        end
        if Hub.isOn("AutoReconnect") or Hub.isOn("WebhookDisconnectAlerts") then
            local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
            local overlay = promptGui and promptGui:FindFirstChild("promptOverlay")
            if overlay then
                local prompt = overlay:FindFirstChild("ErrorPrompt") or overlay:FindFirstChildWhichIsA("Frame")
                if prompt and prompt.Visible and tostring(prompt.Name):find("ErrorPrompt") then
                    Hub.handleDisconnect("Roblox error prompt")
                end
            end
        end
    end
end))

Hub.track(RunService.Heartbeat:Connect(function()
    if not isRunning then return end

    if fz("core", 0.35) then
        task.spawn(function()
            if Hub.stealingEnabled() then Hub.swapStealHumanoid() end
            gc()
            gd()
        end)
    end

    if fz("dashboard", 2) then
        fr()
        local noClip = Hub.isOn("NoClip")
        if noClip ~= fy then fy = noClip; fv(noClip) end
        if Hub.isOn("WalkSpeedEnabled") then
            local humanoid = Hub.getHumanoid()
            if humanoid then
                humanoid.WalkSpeed = math.min(tonumber(Hub.optionValue("WalkSpeed", 32)) or 32, MAX_SPEED)
            end
        end
        if Hub.isOn("JumpPowerEnabled") then
            local humanoid = Hub.getHumanoid()
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = tonumber(Hub.optionValue("JumpPower", 50)) or 50
            end
        end
        if treadmillTraining or Hub.isDoubleSpeedVisible() then
            if not Hub.isOn("AutoTreadmill") then pcall(Hub.stopTreadmillTraining) end
        end
        if Hub.isOn("AntiGameplayPause") then Hub.applyAntiGameplayPause(true) end
    end

    if fz("esp", 1.25) then
        local espEnabled = Hub.isOn("EspWorldEggs") or Hub.isOn("EspCarriedEggs") or Hub.isOn("EspGuards")
            or Hub.isOn("EspPets") or Hub.isOn("EspPlayers") or Hub.isOn("EspMachines") or Hub.isOn("EspPlots")
        if espEnabled then pcall(Hub.runEsp)
        elseif next(espObjects) ~= nil then pcall(Hub.clearAllEsp) end
    end

    if fz("pets", 5) then
        if Hub.isOn("AutoEquipBest") and not taskBusy then pcall(Hub.runAutoEquipBest) end
        if Hub.isOn("AutoEquipBestTrail") then pcall(Hub.runAutoEquipBestTrail) end
        if Hub.isOn("AutoEquipBestGear") then pcall(Hub.runAutoEquipBestGear) end
        if Hub.isOn("AutoDeleteOwnPets") then pcall(Hub.deleteOwnPetRenders) end
    end

    if fz("fuse", tonumber(Hub.optionValue("FuseInterval", 8)) or 8) then
        if Hub.isOn("AutoFusePets") and not taskBusy and not carryingEgg then
            taskBusy = true; pcall(Hub.runAutoFusePets); taskBusy = false
        end
    end

    if fz("sellPets", tonumber(Hub.optionValue("SellInterval", 6)) or 6) then
        if Hub.isOn("AutoSellPets") and not taskBusy and not carryingEgg then pcall(Hub.runAutoSellPets) end
    end

    if fz("sellEggs", tonumber(Hub.optionValue("SellEggInterval", 8)) or 8) then
        if Hub.isOn("AutoSellEggs") and not taskBusy and not carryingEgg then
            taskBusy = true; pcall(Hub.runAutoSellEggs); taskBusy = false
        end
    end

    if fz("upgrades", 4) then
        if Hub.isOn("AutoUpgrades") and not carryingEgg then pcall(Hub.runAutoUpgrades) end
        if Hub.isOn("AutoBuyTrail") and not carryingEgg then pcall(Hub.runAutoBuyTrail) end
    end

    if fz("claims", 12) then
        if Hub.isOn("AutoClaimIndex") then pcall(Hub.runAutoClaimIndex) end
        if Hub.isOn("AutoClaimOffline") then pcall(Hub.runClaimOfflineEarnings) end
        if Hub.isOn("AutoClaimGroupReward") then pcall(Hub.runAutoClaimGroupReward) end
    end

    if fz("hop", 3) then
        if Hub.isOn("AutoServerHop") and not taskBusy then pcall(Hub.runServerHop) end
    end

    if fz("webhook", 5) then
        if Hub.isOn("WebhookEnabled") then
            pcall(Hub.trackWebhookEvents)
            pcall(Hub.runWebhookSummary)
        end
    end

    if fz("session", 4) then
        if Hub.isOn("AntiAfk") then
            local lastKeyTime = tick() - lastInputTick
            local lastJumpTime = tick() - lastAntiAfkJumpTick
            if (lastKeyTime >= 300 and lastJumpTime >= 60) or (lastKeyTime < 300 and lastJumpTime >= 300) then
                pcall(function()
                    local humanoid = Hub.getHumanoid()
                    if humanoid then
                        humanoid.Jump = true
                        lastAntiAfkJumpTick = tick()
                    end
                end)
            end
        end
        if Hub.isOn("AutoReconnect") or Hub.isOn("WebhookDisconnectAlerts") then
            local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
            local overlay = promptGui and promptGui:FindFirstChild("promptOverlay")
            if overlay then
                local prompt = overlay:FindFirstChild("ErrorPrompt") or overlay:FindFirstChildWhichIsA("Frame")
                if prompt and prompt.Visible and tostring(prompt.Name):find("ErrorPrompt") then
                    Hub.handleDisconnect("Roblox error prompt")
                end
            end
        end
    end
end))

if Hub.isOn("AntiGameplayPause") then Hub.applyAntiGameplayPause(true) end
if Hub.isOn("FpsBoost") then Hub.enableFpsBoost() end
Hub.applyFpsCap(Hub.optionValue("FpsCap", 60))

Hub.notify("Apex Hub", "Ready - press the floating icon", "Success", 5)
if fq.statusRow then fq.statusRow:SetStatus("Success") end
