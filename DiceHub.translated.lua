local Players=game:GetService( "Players" )
local Workspace=game:GetService( "Workspace" )
local RunService=game:GetService( "RunService" )
local TweenService=game:GetService( "TweenService" )
local UserInputService=game:GetService( "UserInputService" )
local ReplicatedStorage=game:GetService( "ReplicatedStorage" )
local ProximityPromptService=game:GetService( "ProximityPromptService" )
local HttpService=game:GetService( "HttpService" )
local TeleportService=game:GetService( "TeleportService" )
local LocalPlayer=Players.LocalPlayer
local windUiHolder=nil
local defaultLang="EN"
local checkCallerFn=typeof(checkcaller)=="function" and checkcaller or function() return false end
local newCClosure=typeof(newcclosure)=="function" and newcclosure or function(cclosureArg) return cclosureArg end
local autoFirePromptHook=game:GetService( "ProximityPromptService" )pcall(function(...) autoFirePromptHook.PromptButtonHoldBegan :Connect(function(promptHoldBtn,...) pcall(function(...)
            if typeof(fireproximityprompt)== "function" then
                fireproximityprompt(promptHoldBtn)
            end
        end
        )
    end
    )
end
)
local Log=function(...)
end
local Warn=function(...)
end
local EggStateModule=nil pcall(function(...) EggStateModule=require((ReplicatedStorage:WaitForChild( "Client" , 5 )):WaitForChild( "EggState" , 5 ))
end
)
if not EggStateModule then
    pcall(function(...) EggStateModule=require(ReplicatedStorage.Client.EggState )
    end
    )
end
local AssetItemsModule=nil pcall(function(...) AssetItemsModule=require(((ReplicatedStorage:WaitForChild( "Shared" , 5 )):WaitForChild( "Util" , 5 )):WaitForChild( "AssetItems" , 5 ))
end
)
if not AssetItemsModule then
    pcall(function(...) AssetItemsModule=require(ReplicatedStorage.Shared.Util .AssetItems )
    end
    )
end
local RemotesModule=nil pcall(function(...) RemotesModule=require((ReplicatedStorage:WaitForChild( "Shared" , 5 )):WaitForChild( "Remotes" , 5 ))
end
)
if not RemotesModule then
    pcall(function(...) RemotesModule=require(ReplicatedStorage.Shared.Remotes )
    end
    )
end
local function findRemoteFn(remotePath,remoteAltName,...)
    local networkRoot=(ReplicatedStorage:FindFirstChild( "Packages" )and ReplicatedStorage.Packages :FindFirstChild( "Networking" ))or ReplicatedStorage:FindFirstChild( "Network" )or ReplicatedStorage
    local remoteFoundTop=networkRoot:FindFirstChild(remotePath)or ReplicatedStorage:FindFirstChild(remotePath)
    if remoteFoundTop then
        return remoteFoundTop
    end
    local remoteFoundDeep=networkRoot:FindFirstChild(remotePath, true )or ReplicatedStorage:FindFirstChild(remotePath, true )
    if remoteFoundDeep then
        return remoteFoundDeep
    end
    if remoteAltName then
        local remoteAltTop=networkRoot:FindFirstChild(remoteAltName)or ReplicatedStorage:FindFirstChild(remoteAltName)
        if remoteAltTop then
            return remoteAltTop
        end
        local remoteAltDeep=networkRoot:FindFirstChild(remoteAltName, true )or ReplicatedStorage:FindFirstChild(remoteAltName, true )
        if remoteAltDeep then
            return remoteAltDeep
        end
    end
    local remoteTailName=string.match (remotePath, "[^/]+$" )
    if remoteTailName then
        local remoteTailDeep=networkRoot:FindFirstChild(remoteTailName, true )or ReplicatedStorage:FindFirstChild(remoteTailName, true )
        if remoteTailDeep then
            return remoteTailDeep
        end
    end
    return nil
end

local AskPlaceEgg=findRemoteFn( "RF/EggWorld/AskPlaceEgg" , "AskPlaceEgg" ) 
local AskLiveSnapshot=findRemoteFn( "RF/EggWorld/AskLiveSnapshot" , "AskLiveSnapshot" ) 
local AskState=findRemoteFn( "RF/Homestead/AskState" , "RF/Plots/AskState" )or findRemoteFn( "AskState" )
local AskFieldEggCarry=findRemoteFn( "RF/EggWorld/AskFieldEggCarry" , "AskFieldEggCarry" ) 
local AskFieldEggSnapshot=findRemoteFn( "RF/EggWorld/AskFieldEggSnapshot" , "AskFieldEggSnapshot" )or findRemoteFn( "Eggs: RequestAreaEggSnapshot" , "RequestAreaEggSnapshot" )
local AskHatch=findRemoteFn( "RF/EggWorld/AskHatch" , "AskHatch" )or findRemoteFn( "Eggs: RequestHatchEgg" )
local AskFinishHatch=findRemoteFn( "RF/EggWorld/AskFinishHatch" , "AskFinishHatch" )or findRemoteFn( "Eggs: RequestCompleteHatchEgg" )
local ForestStrikeRemote=findRemoteFn( "RE/GuardPatrol/ForestStrike" , "ForestStrike" )or(RemotesModule and(RemotesModule.GuardPatrol and RemotesModule.GuardPatrol.ForestStrike ))
local SpeedTollRemote=findRemoteFn( "SpeedTollOffer" , "RE/GuardPatrol/SpeedTollOffer" )or(RemotesModule and(RemotesModule.GuardPatrol and RemotesModule.GuardPatrol.SpeedTollOffer ))
local AskTreadmillDoff=findRemoteFn( "RF/Treadmill/AskDoff" , "AskDoff" )
local AskTreadmillDon=findRemoteFn( "RF/Treadmill/AskDon" , "AskDon" )or findRemoteFn( "RF/Treadmill/AskMount" , "AskMount" )
local AskTreadmillUpgrade=findRemoteFn( "RF/Treadmill/AskTierRaise" , "Treadmills: RequestUpgrade" , "AskTierRaise" )
local AskTrailPurchase=findRemoteFn( "RF/Trailwear/AskPurchase" , "Trailwear: RequestPurchase" , "AskPurchase" )
local AskTrailChoose=findRemoteFn( "RF/Trailwear/AskChoose" , "Trailwear: RequestEquip" , "AskChoose" )
local AskTrailDoff=findRemoteFn( "RF/Trailwear/AskDoff" , "Trailwear: RequestUnequip" , "AskDoff" )Log(string.format ( "[RemoteCheck] Carry: %s | Snapshot: %s | Place: %s | Hatch: %s | FinishHatch: %s | Strike: %s | Toll: %s | Doff: %s" ,tostring(AskFieldEggCarry~=nil),tostring(AskFieldEggSnapshot~=nil),tostring(AskPlaceEgg~=nil),tostring(AskHatch~=nil),tostring(AskFinishHatch~=nil),tostring(ForestStrikeRemote~=nil),tostring(SpeedTollRemote~=nil),tostring(AskTreadmillDoff~=nil)))

local zoneOrderZ={[ "Light Dark" ]= 1300 ,[ "LightDark" ]= 1300 ;
[ "Titan Temple" ]= 1100 ,[ "Cherry Blossom" ]= 1000 ,[ "Cosmic" ]= 900 ;
[ "Prehistoric" ]= 800 ;
[ "Abyss Ocean" ]= 700 ,[ "Volcano" ]= 600 ;
[ "Snow" ]= 500 ,[ "Jungle" ]= 400 ;
[ "Desert" ]= 300 ,[ "Lake" ]= 200 ;
[ "Forest" ]= 100 }
local zoneNames={ "Light Dark" ;
"Titan Temple" ;
"Cherry Blossom" , "Cosmic" ;
"Prehistoric" , "Abyss Ocean" ;
"Volcano" ;
"Snow" , "Jungle" , "Desert" , "Lake" ;
"Forest" }
local zoneZMulti={[ "Light Dark" ]= 420 ,[ "LightDark" ]= 420 ;
[ "Titan Temple" ]= 380 ,[ "Cherry Blossom" ]= 330 ,[ "Cosmic" ]= 280 ;
[ "Prehistoric" ]= 240 ,[ "Abyss Ocean" ]= 200 ;
[ "Volcano" ]= 180 ;
[ "Snow" ]= 160 ,[ "Jungle" ]= 140 ;
[ "Desert" ]= 130 ,[ "Lake" ]= 125 ,[ "Forest" ]= 125 }
local corridorZ= -360
local safeLineX= 525
local returnX= 620
local returnDistMul= 130
local homeCFrame=CFrame.new ( 4773.7587890625 , 70.392112731934 , -315.73501586914 )

local flightSpeedFile= "DiceHub_FlightSpeed.txt"
local configFile= "DiceHub_EggSelectConfig.json"
local zoneColors={[ "Light Dark" ]=Color3.fromRGB ( 168 , 85 , 247 ),[ "Titan Temple" ]=Color3.fromRGB ( 245 , 158 , 11 );
[ "Cherry Blossom" ]=Color3.fromRGB ( 236 , 72 , 153 );
[ "Cosmic" ]=Color3.fromRGB ( 6 , 182 , 212 ),[ "Prehistoric" ]=Color3.fromRGB ( 16 , 185 , 129 ),[ "Abyss Ocean" ]=Color3.fromRGB ( 59 , 130 , 246 );
[ "Volcano" ]=Color3.fromRGB ( 239 , 68 , 68 ),[ "Snow" ]=Color3.fromRGB ( 147 , 197 , 253 ),[ "Jungle" ]=Color3.fromRGB ( 34 , 197 , 94 ),[ "Desert" ]=Color3.fromRGB ( 234 , 179 , 8 ),[ "Lake" ]=Color3.fromRGB ( 20 , 184 , 166 ),[ "Forest" ]=Color3.fromRGB ( 22 , 163 , 74 )}

local rarityNames={ "Divine" , "Eternal" , "Secret" ;
"Cosmic" , "Mythic" , "Legendary" ;
"Epic" ;
"Rare" ;
"Uncommon" ;
"Common" }
local rarityColors={[ "Divine" ]=Color3.fromRGB ( 244 , 63 , 94 );
[ "Eternal" ]=Color3.fromRGB ( 217 , 70 , 239 ),[ "Secret" ]=Color3.fromRGB ( 249 , 115 , 22 ),[ "Cosmic" ]=Color3.fromRGB ( 6 , 182 , 212 ),[ "Mythic" ]=Color3.fromRGB ( 139 , 92 , 246 ),[ "Legendary" ]=Color3.fromRGB ( 251 , 191 , 36 );
[ "Epic" ]=Color3.fromRGB ( 168 , 85 , 247 );
[ "Rare" ]=Color3.fromRGB ( 59 , 130 , 246 );
[ "Uncommon" ]=Color3.fromRGB ( 34 , 197 , 94 ),[ "Common" ]=Color3.fromRGB ( 148 , 163 , 184 )}
local rarityTiers={[ "Divine" ]= 6 ;
[ "Eternal" ]= 5 ;
[ "Secret" ]= 4 ,[ "Cosmic" ]= 3 ;
[ "Mythic" ]= 2 ;
[ "Legendary" ]= 1 ,[ "Epic" ]= 0.5 ,[ "Rare" ]= 0.3 ,[ "Uncommon" ]= 0.1 ;
[ "Common" ]= 0 }
local h
local function loadFlightSpeed(...)
    local flightDefault= 600 pcall(function(...)
        local speedFileOk= false
        if isfile then
            speedFileOk=isfile(flightSpeedFile)
        elseif readfile then
            local speedReadOk,speedReadVal=pcall(readfile,flightSpeedFile)speedFileOk=speedReadOk and(speedReadVal~=nil)
        end
        if speedFileOk and readfile then
            local speedRawText=readfile(flightSpeedFile)
            local speedTonumber=tonumber(speedRawText)
            if speedTonumber and(speedTonumber>= 100 and speedTonumber<= 1000 )then
                flightDefault=math.floor (speedTonumber)
            end
        end
    end
    )
    return flightDefault
end
local function saveFlightSpeed(speedInput,...) pcall(function(...)
        if writefile then
            local speedClamped=math.clamp (math.floor (tonumber(speedInput)or 600 ), 100 , 1000 )writefile(flightSpeedFile,tostring(speedClamped))
        end
    end
    )
end
local function loadConfig(...)
    local cfgLoaded=nil pcall(function(...)
        local fileExists= false
        if isfile then
            fileExists=isfile(configFile)
        elseif readfile then
            local readOK,readContent=pcall(readfile,configFile)fileExists=readOK and(readContent~=nil)
        end
        if fileExists and(readfile and HttpService)then
            local rawText=readfile(configFile)
            if rawText and rawText~= "" then
                local decodedObj=HttpService:JSONDecode(rawText)
                if type(decodedObj)== "table" then
                    cfgLoaded=decodedObj
                end
            end
        end
    end
    )
    local cfgDefaultZones={[ "Light Dark" ]= true ,[ "Titan Temple" ]= true ,[ "Cherry Blossom" ]= true ;
    [ "Cosmic" ]= false ;
    [ "Prehistoric" ]= false ,[ "Abyss Ocean" ]= false ;
    [ "Volcano" ]= false ,[ "Snow" ]= false ;
    [ "Jungle" ]= false ,[ "Desert" ]= false ;
    [ "Lake" ]= false ,[ "Forest" ]= false }
    local cfgDefaultRarities={[ "Divine" ]= true ,[ "Eternal" ]= true ,[ "Secret" ]= true ,[ "Cosmic" ]= true ,[ "Mythic" ]= true ;
    [ "Legendary" ]= false ,[ "Epic" ]= false ,[ "Rare" ]= false ;
    [ "Uncommon" ]= false ;
    [ "Common" ]= false }
    if type(cfgLoaded)~= "table" then
        cfgLoaded={[ "selectedZones" ]=cfgDefaultZones;
        [ "selectedRarities" ]=cfgDefaultRarities,[ "alwaysCollectSecretPlus" ]= true ,[ "minRarityTier" ]= 2 ;
        [ "autoTreadmill" ]= true ;
        [ "autoUpgradeTreadmill" ]= true ,[ "autoBuyTrails" ]= true ;
        [ "hideNotEnoughMoney" ]= true ;
        [ "performanceMode" ]= false ,[ "disable3D" ]= false ,[ "antiAFK" ]= true ,[ "language" ]= "EN" }
    else
        if type(cfgLoaded.selectedZones )~= "table" then
            cfgLoaded.selectedZones =cfgDefaultZones
        end
        if type(cfgLoaded.selectedRarities )~= "table" then
            cfgLoaded.selectedRarities =cfgDefaultRarities
        else
            for rarityNameIdx,rarityNameVal in ipairs(rarityNames)do
                if cfgLoaded.selectedRarities [rarityNameVal]==nil then
                    cfgLoaded.selectedRarities [rarityNameVal]=(cfgDefaultRarities[rarityNameVal]== true )
                end
            end
        end
        if cfgLoaded.alwaysCollectSecretPlus ==nil then
            cfgLoaded.alwaysCollectSecretPlus = true
        end
        if cfgLoaded.minRarityTier ==nil then
            cfgLoaded.minRarityTier = 2
        end
        if cfgLoaded.autoTreadmill ==nil then
            cfgLoaded.autoTreadmill = true
        end
        if cfgLoaded.autoUpgradeTreadmill ==nil then
            cfgLoaded.autoUpgradeTreadmill = true
        end
        if cfgLoaded.autoBuyTrails ==nil then
            cfgLoaded.autoBuyTrails = true
        end
        if cfgLoaded.hideNotEnoughMoney ==nil then
            cfgLoaded.hideNotEnoughMoney = true
        end
        if cfgLoaded.performanceMode ==nil then
            cfgLoaded.performanceMode = false
        end
        if cfgLoaded.disable3D ==nil then
            cfgLoaded.disable3D = false
        end
        if cfgLoaded.antiAFK ==nil then
            cfgLoaded.antiAFK = true
        end
        if cfgLoaded.language and((cfgLoaded.language == "EN" or cfgLoaded.language == "TH" ))then
            defaultLang=cfgLoaded.language
        end
    end
    return cfgLoaded
end
local function saveConfig(...) pcall(function(...)
        if writefile and(HttpService and h)then
            local cfgPayloadTable={[ "selectedZones" ]=h.selectedZones or{};
            [ "selectedRarities" ]=h.selectedRarities or{};
            [ "alwaysCollectSecretPlus" ]=(h.alwaysCollectSecretPlus ~= false ),[ "minRarityTier" ]=h.minRarityTier or 2 ,[ "autoTreadmill" ]=(h.autoTreadmill == true );
            [ "autoUpgradeTreadmill" ]=(h.autoUpgradeTreadmill == true ),[ "autoBuyTrails" ]=(h.autoBuyTrails == true );
            [ "hideNotEnoughMoney" ]=(h.hideNotEnoughMoney == true );
            [ "performanceMode" ]=(h.performanceMode == true );
            [ "disable3D" ]=(h.disable3D == true );
            [ "antiAFK" ]=(h.antiAFK == true );
            [ "language" ]=defaultLang or "EN" }
            local cfgPayloadJson=HttpService:JSONEncode(cfgPayloadTable)writefile(configFile,cfgPayloadJson)
        end
    end
    )
end
local cfg=loadConfig()h={[ "godmode" ]= true ,[ "autoGlide" ]= true ,[ "autoHatch" ]= true ;
[ "autoPlaceEvery5" ]= false ;
[ "batchStealCount" ]= 0 ,[ "isBatchPlacing" ]= false ,[ "isHatching" ]= false ;
[ "autoFarmLoop" ]= false ,[ "pureTweenFarm" ]= false ;
[ "glidingToTarget" ]= false ;
[ "securingEgg" ]= false ,[ "glideSpeed" ]=loadFlightSpeed();
[ "selectedZones" ]=cfg.selectedZones ;
[ "selectedRarities" ]=cfg.selectedRarities ;
[ "alwaysCollectSecretPlus" ]=cfg.alwaysCollectSecretPlus ,[ "minRarityTier" ]=cfg.minRarityTier ,[ "autoTreadmill" ]=(cfg.autoTreadmill ~= false );
[ "autoUpgradeTreadmill" ]=(cfg.autoUpgradeTreadmill ~= false ),[ "autoBuyTrails" ]=(cfg.autoBuyTrails ~= false ),[ "hideNotEnoughMoney" ]= true ;
[ "performanceMode" ]=(cfg.performanceMode == true ),[ "disable3D" ]=(cfg.disable3D == true ),[ "antiAFK" ]=(cfg.antiAFK ~= false ),[ "onTreadmill" ]= false ,[ "lastTreadmillMount" ]= 0 ,[ "laneZ" ]= -360 ,[ "swapped" ]= false ;
[ "teleporting" ]= false ,[ "isReturning" ]= false ;
[ "delivering" ]= false ,[ "holdingEggForGuard" ]= false ,[ "currentTargetModel" ]=nil,[ "targetPosition" ]=nil;
[ "stateTime" ]=os.clock (),[ "statusText" ]= "Ready" ,[ "bestEggInfo" ]= "Scanning..." ;
[ "gui" ]=nil;
[ "alive" ]= true ,[ "plot" ]=nil;
[ "pen" ]=nil,[ "origin" ]=nil;
[ "tread" ]=nil}
local isEggTool
local findEggTool
local findEggInBackpack
local countCarriedEggs
local unequipAllTools
local isCarryingTargetEgg
local hasEggOrCarried
local checkEggState
local isLakeEgg
local getEggGlideSpeed
local spawnSafetyFloor
local triggerGuardStrike
local mountTreadmill
local findTreadmill
local upgradeTreadmill
local buyRandomTrail
local hatchReadyEggs
local pickUnhatchedEgg
local autoPlaceEggs
local autoPlaceLoop
local hatchAllEggs
local tweenGlide
local placeEggsToStand
local returnHome
local findLakeEgg
local pickBestEgg
local guardStrikeLift
local snipeLoop
local recoverAutoSteal
local doffTreadmill
local dismountAlias
local smartDoffTreadmill
local treadmillFarmLoop
local dismountTreadmill
local findTreadmillEntry
local mountAndFarm
local fireTreadmillExit
local setGodmode
local swapHumanoidAntiDesync
local rigidifyCharacter
local disableRagdoll
local lockRigJoints
local followEgg
local eggCooldownMap={}
local snapshotTime= 0
local cachedEggRecords=nil
local getEggSlots
local sessionSwitchId= 0
local farmMode= "NONE"
local setFarmMode
local tweenToggleFn=nil
local warpToggleFn=nil pcall(function(...)
    local lightingSvc=game:GetService( "Lighting" );
    (lightingSvc:GetPropertyChangedSignal( "ClockTime" )):Connect(function(...) eggCooldownMap={}snapshotTime= 0
    end
    )
end
)pcall(function(...)
    local function zoneTintFn(zoneAssetObj,...)
        if zoneAssetObj:IsA( "RemoteEvent" )then
            local zoneAssetName=string.lower (zoneAssetObj.Name )
            if string.find (zoneAssetName, "reset" )or string.find (zoneAssetName, "night" )or string.find (zoneAssetName, "spawn" )or string.find (zoneAssetName, "countdown" )then
                pcall(function(...) zoneAssetObj.OnClientEvent :Connect(function(...) eggCooldownMap={}snapshotTime= 0
                    end
                    )
                end
                )
            end
        end
    end
    for rsDescIdx,rsDescObj in ipairs(ReplicatedStorage:GetDescendants())do
        zoneTintFn(rsDescObj)
    end
    ReplicatedStorage.DescendantAdded :Connect(zoneTintFn)
end
)isEggTool=function(toolCheckObj,...)
    if not toolCheckObj or not toolCheckObj:IsA( "Tool" )then
        return false
    end
    local toolCheckName=string.lower (toolCheckObj.Name )
    if string.find (toolCheckName, "sword" )or string.find (toolCheckName, "radar" )or string.find (toolCheckName, "basket" )or string.find (toolCheckName, "punch" )then
        return false
    end
    if toolCheckObj:GetAttribute( "EggUid" )or toolCheckObj:GetAttribute( "UID" )or string.find (toolCheckName, "egg" )or toolCheckObj:GetAttribute( "Category" )or toolCheckObj:GetAttribute( "ItemType" )== "Egg" then
        return true
    end
    return false
end
findEggTool=function(...)
    local charScan=LocalPlayer.Character
    if charScan then
        for charScanChildIdx,charScanChild in ipairs(charScan:GetChildren())do
            if isEggTool(charScanChild)then
                local charScanUid=charScanChild:GetAttribute( "UID" )or charScanChild:GetAttribute( "EggUid" )
                return charScanChild,charScanUid or charScanChild.Name
            end
        end
    end
    return nil,nil
end
findEggInBackpack=function(...)
    local bpScan=LocalPlayer:FindFirstChild( "Backpack" )
    if bpScan then
        for bpScanChildIdx,bpScanChild in ipairs(bpScan:GetChildren())do
            if isEggTool(bpScanChild)then
                local bpScanUid=bpScanChild:GetAttribute( "UID" )or bpScanChild:GetAttribute( "EggUid" )
                return bpScanChild,bpScanUid or bpScanChild.Name
            end
        end
    end
    return nil,nil
end
countCarriedEggs=function(...)
    local bpCarriedCount= 0
    local bpCarried=LocalPlayer:FindFirstChild( "Backpack" )
    if bpCarried then
        for bpCarriedChildIdx,bpCarriedChild in ipairs(bpCarried:GetChildren())do
            if isEggTool(bpCarriedChild)then
                bpCarriedCount=bpCarriedCount+ 1
            end
        end
    end
    local charCarried=LocalPlayer.Character
    if charCarried then
        for charCarriedChildIdx,charCarriedChild in ipairs(charCarried:GetChildren())do
            if isEggTool(charCarriedChild)then
                bpCarriedCount=bpCarriedCount+ 1
            end
        end
    end
    return bpCarriedCount
end
unequipAllTools=function(charUnequip,...)
    if not charUnequip and not((h.pureTweenFarm or h.autoFarmLoop or h.teleporting ))then
        return
    end
    local charUnequipVal=LocalPlayer.Character
    local humanoidUnequip=charUnequipVal and charUnequipVal:FindFirstChildOfClass( "Humanoid" )
    local bpUnequip=LocalPlayer:FindFirstChild( "Backpack" )
    if humanoidUnequip then
        pcall(function(...) humanoidUnequip:UnequipTools()
        end
        )
    end
    if charUnequipVal and bpUnequip then
        for unequipChildIdx,unequipChild in ipairs(charUnequipVal:GetChildren())do
            if unequipChild:IsA( "Tool" )then
                pcall(function(...) unequipChild.Parent =bpUnequip
                end
                )
            end
        end
    end
end
isCarryingTargetEgg=function(targetUidArg,...)
    if((h.pureTweenFarm or h.autoFarmLoop ))and not h.holdingEggForGuard then
        local findHeldTool=findEggTool()
        if findHeldTool then
            pcall(unequipAllTools)
        end
        return false
    end
    local findToolTool,findToolUid=findEggTool()
    if findToolTool then
        if targetUidArg then
            if findToolUid==targetUidArg or not findToolUid then
                return true
            end
        else
            return true
        end
    end
    local charCarryChk=LocalPlayer.Character
    local carryChkRoot=charCarryChk and charCarryChk:FindFirstChild( "HumanoidRootPart" )
    if carryChkRoot and carryChkRoot.Position.X <=(safeLineX+ 15 )then
        return false
    end
    if EggStateModule and EggStateModule.ReadFieldEggs then
        local fieldReadOk,fieldReadData=pcall(EggStateModule.ReadFieldEggs )
        if fieldReadOk and(fieldReadData and fieldReadData.Records )then
            for fieldReadChildIdx,fieldReadChild in ipairs(fieldReadData.Records )do
                if((fieldReadChild.State == "Carried" or fieldReadChild.State == 2 ))and((fieldReadChild.CarrierUserId ==LocalPlayer.UserId or fieldReadChild.Carrier ==LocalPlayer.UserId ))then
                    if targetUidArg then
                        if fieldReadChild.Uid ==targetUidArg then
                            return true
                        end
                    else
                        return true
                    end
                end
            end
        end
    end
    return false
end
hasEggOrCarried=function(hasEggUidArg,...)
    local hasEggTool,hasEggUidRet=findEggTool()
    if hasEggTool then
        if not hasEggUidArg or hasEggUidRet==hasEggUidArg or not hasEggUidRet then
            return true
        end
    end
    local hasEggBp=LocalPlayer:FindFirstChild( "Backpack" )
    if hasEggBp then
        for hasEggBpChildIdx,hasEggBpChild in ipairs(hasEggBp:GetChildren())do
            if isEggTool(hasEggBpChild)then
                local hasEggBpUid=hasEggBpChild:GetAttribute( "UID" )or hasEggBpChild:GetAttribute( "EggUid" )
                if not hasEggUidArg or hasEggBpUid==hasEggUidArg or hasEggBpChild.Name ==tostring(hasEggUidArg)then
                    return true
                end
            end
        end
    end
    if hasEggUidArg and(EggStateModule and EggStateModule.ReadFieldEggs )then
        local hasEggReadOk,hasEggReadData=pcall(EggStateModule.ReadFieldEggs )
        if hasEggReadOk and(hasEggReadData and hasEggReadData.Records )then
            for hasEggRecIdx,hasEggRec in ipairs(hasEggReadData.Records )do
                if hasEggRec.Uid ==hasEggUidArg then
                    if(hasEggRec.State == "Carried" or hasEggRec.State == 2 )then
                        local hasEggCarrierId=hasEggRec.CarrierUserId or hasEggRec.Carrier
                        if hasEggCarrierId==LocalPlayer.UserId then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end
local snapshotInFlight= false
local function refreshEggSnapshot(...)
    if snapshotInFlight then
        return
    end
    local snapRemoteRef=AskFieldEggSnapshot or ReplicatedStorage:FindFirstChild( "RF/EggWorld/AskFieldEggSnapshot" , true )or ReplicatedStorage:FindFirstChild( "AskFieldEggSnapshot" , true )or ReplicatedStorage:FindFirstChild( "Eggs: RequestAreaEggSnapshot" , true )
    if not snapRemoteRef or not snapRemoteRef:IsA( "RemoteFunction" )then
        return
    end
    snapshotInFlight= true task.spawn (function(...)
        local snapPcallOk,snapPcallData=pcall(function(...)
            return snapRemoteRef:InvokeServer()
        end
        )
        if snapPcallOk and type(snapPcallData)== "table" then
            local snapMergeTable={}
            local snapMergeRecords=snapPcallData.Records or snapPcallData
            if type(snapMergeRecords)== "table" then
                for snapMergeKey,snapMergeVal in pairs(snapMergeRecords)do
                    if type(snapMergeVal)== "table" then
                        if not snapMergeVal.Uid and type(snapMergeKey)== "string" then
                            snapMergeVal.Uid =snapMergeKey
                        end
                        table.insert (snapMergeTable,snapMergeVal)
                    end
                end
            end
            if#snapMergeTable> 0 then
                cachedEggRecords=snapMergeTable snapshotTime=os.clock ()
            end
        end
        snapshotInFlight= false
    end
    )
end
task.spawn (function(...)
    while true do
        task.wait ( 1.5 )pcall(refreshEggSnapshot)
    end
end
)function h4(h4Arg,...)
    local h4Clock=os.clock ()
    if h4Arg or(h4Clock-snapshotTime>= 1.5 )or not cachedEggRecords then
        refreshEggSnapshot()
    end
    local h4PrevCache=((cachedEggRecords and#cachedEggRecords> 0 ))and cachedEggRecords or nil
    local h4FreshRecs=nil
    if EggStateModule and EggStateModule.ReadFieldEggs then
        local fieldEggsOk,fieldEggsData=pcall(EggStateModule.ReadFieldEggs )
        if fieldEggsOk and type(fieldEggsData)== "table" then
            local h4FreshTable={}
            local h4FreshRecords=fieldEggsData.Records or fieldEggsData
            if type(h4FreshRecords)== "table" then
                for h4FreshKey,h4FreshVal in pairs(h4FreshRecords)do
                    if type(h4FreshVal)== "table" then
                        if not h4FreshVal.Uid and type(h4FreshKey)== "string" then
                            h4FreshVal.Uid =h4FreshKey
                        end
                        table.insert (h4FreshTable,h4FreshVal)
                    end
                end
            end
            if#h4FreshTable> 0 then
                h4FreshRecs=h4FreshTable
            end
        end
    end
    local h4AreaRecs={}
    local h4CachedOut={}
    if h4PrevCache then
        for h4AreaRecIdx,h4AreaRec in ipairs(h4PrevCache)do
            if h4AreaRec.Uid then
                h4CachedOut[h4AreaRec.Uid ]= true table.insert (h4AreaRecs,h4AreaRec)
            end
        end
    end
    if h4FreshRecs then
        for h4CacheIdx,h4CacheRec in ipairs(h4FreshRecs)do
            if h4CacheRec.Uid and not h4CachedOut[h4CacheRec.Uid ]then
                h4CachedOut[h4CacheRec.Uid ]= true table.insert (h4AreaRecs,h4CacheRec)
            end
        end
    end
    local h4SlotsClient=Workspace:FindFirstChild( "AreaEggSlotsClient" )
    if h4SlotsClient then
        for areaEggIdx,areaEgg in ipairs(h4SlotsClient:GetChildren())do
            local areaEggName=areaEgg.Name
            if areaEggName and areaEggName~= "" then
                local areaEggPivot=areaEgg:GetPivot()
                local h4SlotPivot=areaEggPivot.Position
                if h4SlotPivot.X >= 530 and not string.find (tostring(areaEggName), "FirstArea" )then
                    if not h4CachedOut[areaEggName]then
                        h4CachedOut[areaEggName]= true
                        local areaEggCat=areaEgg:GetAttribute( "Category" )or areaEgg:GetAttribute( "AssetCategory" )or areaEgg.Name
                        local h4SlotAreaId=areaEgg:GetAttribute( "AreaId" )or areaEgg:GetAttribute( "Area" )
                        local h4SlotRarity=areaEgg:GetAttribute( "Rarity" )or areaEgg:GetAttribute( "RarityTier" )
                        local h4SlotRank=areaEgg:GetAttribute( "RarityRank" )or areaEgg:GetAttribute( "Rank" )
                        local h4SlotIncome=areaEgg:GetAttribute( "Income" )or areaEgg:GetAttribute( "EarningRate" )
                        local h4SlotScale=areaEgg:GetAttribute( "Scale" )or areaEgg:GetAttribute( "AssetScale" )or 1
                        local h4SlotMutations=areaEgg:GetAttribute( "Mutations" )or areaEgg:GetAttribute( "Mutation" )table.insert (h4AreaRecs,{[ "Uid" ]=areaEggName,[ "AssetCategory" ]=areaEggCat,[ "AreaId" ]=h4SlotAreaId;
                        [ "Rarity" ]=h4SlotRarity,[ "Rank" ]=h4SlotRank,[ "Income" ]=h4SlotIncome,[ "BoundsCFrame" ]=areaEggPivot;
                        [ "BottomCFrame" ]=areaEggPivot,[ "CFrame" ]=areaEggPivot;
                        [ "State" ]= "Slot" ;
                        [ "AssetScale" ]=h4SlotScale,[ "Mutations" ]=h4SlotMutations,[ "PhysicalModel" ]=areaEgg})
                    else
                        for h4MergeIdx,h4MergeRec in ipairs(h4AreaRecs)do
                            if h4MergeRec.Uid ==areaEggName then
                                h4MergeRec.PhysicalModel =areaEgg
                                if not h4MergeRec.BoundsCFrame then
                                    h4MergeRec.BoundsCFrame =areaEggPivot
                                end
                                if not h4MergeRec.AreaId or h4MergeRec.AreaId == "" or h4MergeRec.AreaId == "Unknown" then
                                    h4MergeRec.AreaId =areaEgg:GetAttribute( "AreaId" )or areaEgg:GetAttribute( "Area" )
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return h4AreaRecs
end
checkEggState=function(stateUidArg,...)
    if not stateUidArg then
        return false , "NoUid"
    end
    local stateSlots=getEggSlots( false )
    if stateSlots and#stateSlots> 0 then
        for eggCtxIdx,eggCtxRec in ipairs(stateSlots)do
            if eggCtxRec.Uid ==stateUidArg then
                if(eggCtxRec.State == "Carried" or eggCtxRec.State == 2 )then
                    local stateCarrierA=eggCtxRec.CarrierUserId or eggCtxRec.Carrier
                    if stateCarrierA and stateCarrierA==LocalPlayer.UserId then
                        return true , "CarriedBySelf"
                    else
                        return false , "CarriedByOther"
                    end
                end
                if(eggCtxRec.State == "Slot" or eggCtxRec.State == "Dropped" or eggCtxRec.State == "GuardCarried" or eggCtxRec.State == 1 )then
                    return true , "Available"
                end
                local stateCarrierB=eggCtxRec.CarrierUserId or eggCtxRec.Carrier
                if stateCarrierB then
                    if stateCarrierB==LocalPlayer.UserId then
                        return true , "CarriedBySelf"
                    else
                        return false , "CarriedByOther"
                    end
                end
                return true , "Available"
            end
        end
    end
    local stateSlotsClient=Workspace:FindFirstChild( "AreaEggSlotsClient" )
    if stateSlotsClient then
        for stateSlotIdx,stateSlotObj in ipairs(stateSlotsClient:GetChildren())do
            if stateSlotObj.Name ==tostring(stateUidArg)or stateSlotObj:GetAttribute( "UID" )==stateUidArg or stateSlotObj:GetAttribute( "Uid" )==stateUidArg then
                return true , "Available"
            end
        end
    end
    return true , "Unchecked"
end
isLakeEgg=function(...)
    local stateTool,stateToolUid=findEggTool()
    if not stateToolUid then
        local stateBpTool,stateBpToolUid=findEggInBackpack()stateToolUid=stateBpToolUid
    end
    if not stateToolUid then
        return false
    end
    if EggStateModule and EggStateModule.ReadFieldEggs then
        local stateReadOk,stateReadData=pcall(EggStateModule.ReadFieldEggs )
        if stateReadOk and(stateReadData and stateReadData.Records )then
            for stateRecIdx,stateRec in ipairs(stateReadData.Records )do
                if stateRec.Uid ==stateToolUid then
                    local stateAreaIdStr=tostring(stateRec.AreaId or "" )
                    if stateAreaIdStr== "Lake" or string.find (string.lower (stateAreaIdStr), "lake" )~=nil then
                        return true
                    end
                end
            end
        end
    end
    if string.find (string.lower (tostring(stateToolUid)), "lake" )~=nil then
        return true
    end
    return false
end
getEggGlideSpeed=function(...)
    local lakeToolA,lakeToolUidA=findEggTool()
    if not lakeToolUidA then
        local lakeBpTool,lakeBpUid=findEggInBackpack()lakeToolUidA=lakeBpUid
    end
    if not lakeToolUidA then
        return h.glideSpeed or 350
    end
    if EggStateModule and EggStateModule.ReadFieldEggs then
        local lakeReadOk,lakeReadData=pcall(EggStateModule.ReadFieldEggs )
        if lakeReadOk and(lakeReadData and lakeReadData.Records )then
            for lakeRecIdx,lakeRec in ipairs(lakeReadData.Records )do
                if lakeRec.Uid ==lakeToolUidA and lakeRec.AreaId then
                    return zoneZMulti[lakeRec.AreaId ]or h.glideSpeed or 350
                end
            end
        end
    end
    return h.glideSpeed or 350
end
spawnSafetyFloor=function(padPosArg,padSizeArg,...) padSizeArg=padSizeArg or 8
    local safetyPadObj=Instance.new ( "Part" )safetyPadObj.Name = "SafetyFloorPad_AntiVoid" safetyPadObj.Size =Vector3.new ( 28 , 1.5 , 28 )safetyPadObj.Position =padPosArg-Vector3.new ( 0 , 3.2 , 0 )safetyPadObj.Anchored = true safetyPadObj.Transparency = 1 safetyPadObj.CanCollide = true safetyPadObj.Parent =Workspace task.delay (padSizeArg,function(...) pcall(function(...) safetyPadObj:Destroy()
        end
        )
    end
    )
    return safetyPadObj
end
triggerGuardStrike=function(strikeUidArg,...)
    if ForestStrikeRemote and strikeUidArg then
        pcall(function(...)
            local guardSnapChar=LocalPlayer.Character
            local strikeCharRoot=guardSnapChar and guardSnapChar:FindFirstChild( "HumanoidRootPart" )
            local strikeGuardCf=strikeCharRoot and(strikeCharRoot.CFrame *CFrame.new ( 0 , 0 , -3 ))or CFrame.new ()
            if ForestStrikeRemote:IsA( "RemoteFunction" )then
                ForestStrikeRemote:InvokeServer({[ "EggUid" ]=strikeUidArg,[ "GuardCFrame" ]=strikeGuardCf})
            else
                ForestStrikeRemote:FireServer({[ "EggUid" ]=strikeUidArg;
                [ "GuardCFrame" ]=strikeGuardCf})
            end
        end
        )
    end
end
if typeof(hookmetamethod)== "function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked = true
    local hookNewIndex hookNewIndex=hookmetamethod(game, "__newindex" ,newCClosure(function(hookTarget,hookKey,hookValue,...)
        if not checkCallerFn()and typeof(hookTarget)== "Instance" then
            if hookTarget:IsA( "Motor6D" )and(hookKey== "Enabled" and hookValue== false )then
                return nil
            end
            if hookTarget:IsA( "Humanoid" )then
                if hookKey== "PlatformStand" and hookValue== true then
                    return nil
                end
                if hookKey== "Sit" and(hookValue== true and((h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget )))then
                    return nil
                end
            end
        end
        return hookNewIndex(hookTarget,hookKey,hookValue)
    end
    ))
end
rigidifyCharacter=function(rigidCharArg,...) rigidCharArg=rigidCharArg or LocalPlayer.Character
    if not rigidCharArg then
        return
    end
    local rigidRoot=rigidCharArg:FindFirstChild( "HumanoidRootPart" )
    local rigidTorso=rigidCharArg:FindFirstChild( "Torso" )or rigidCharArg:FindFirstChild( "UpperTorso" )or rigidRoot
    if not rigidTorso then
        return
    end
    for rigidDescIdx,rigidDesc in ipairs(rigidCharArg:GetDescendants())do
        if rigidDesc:IsA( "BallSocketConstraint" )or rigidDesc:IsA( "HingeConstraint" )or rigidDesc:IsA( "NoCollisionConstraint" )then
            pcall(function(...) rigidDesc:Destroy()
            end
            )
        end
    end
    for rigidMotorIdx,rigJoint in ipairs(rigidCharArg:GetDescendants())do
        if rigJoint:IsA( "Motor6D" )and(rigJoint.Part0 and rigJoint.Part1 )then
            rigJoint.Enabled = true
            local weldName= "RigidJointWeld_" ..rigJoint.Name
            local weldExisting=rigJoint.Part1 :FindFirstChild(weldName)
            if not weldExisting then
                local weldNew=Instance.new ( "WeldConstraint" )weldNew.Name =weldName weldNew.Part0 =rigJoint.Part0 weldNew.Part1 =rigJoint.Part1 weldNew.Parent =rigJoint.Part1
            end
        end
    end
end
disableRagdoll=function(hookChar,...)
    if h and h.onTreadmill then
        return
    end
    hookChar=hookChar or LocalPlayer.Character
    if not hookChar then
        return
    end
    local hookHumanoid=hookChar:FindFirstChildOfClass( "Humanoid" )
    if hookHumanoid then
        hookHumanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll , false )hookHumanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown , false )hookHumanoid:SetStateEnabled(Enum.HumanoidStateType.Physics , false )hookHumanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding , false )hookHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated , false )
        if hookHumanoid.PlatformStand then
            hookHumanoid.PlatformStand = false
        end
        if hookHumanoid.Sit then
            hookHumanoid.Sit = false
        end
    end
    for hookDescIdx,hookDescObj in ipairs(hookChar:GetDescendants())do
        if hookDescObj:IsA( "LocalScript" )and((string.find (string.lower (hookDescObj.Name ), "ragdoll" )or string.find (string.lower (hookDescObj.Name ), "fall" )))then
            hookDescObj.Disabled = true
        end
    end
    rigidifyCharacter(hookChar)
end
lockRigJoints=function(lockCharArg,...)
    if not lockCharArg then
        return
    end
    disableRagdoll(lockCharArg)
    for lockDescIdx,lockDescObj in ipairs(lockCharArg:GetDescendants())do
        if lockDescObj:IsA( "Motor6D" )then
            (lockDescObj:GetPropertyChangedSignal( "Enabled" )):Connect(function(...)
                if not lockDescObj.Enabled then
                    lockDescObj.Enabled = true
                end
            end
            )
        end
    end
    lockCharArg.DescendantAdded :Connect(function(lockJoinedPart,...)
        if lockJoinedPart:IsA( "BallSocketConstraint" )or lockJoinedPart:IsA( "HingeConstraint" )or lockJoinedPart:IsA( "NoCollisionConstraint" )then
            task.defer (function(...) pcall(function(...) lockJoinedPart:Destroy()
                end
                )disableRagdoll(lockCharArg)
            end
            )
        elseif lockJoinedPart:IsA( "LocalScript" )and((string.find (string.lower (lockJoinedPart.Name ), "ragdoll" )or string.find (string.lower (lockJoinedPart.Name ), "fall" )))then
            lockJoinedPart.Disabled = true
        end
    end
    )lockCharArg.ChildAdded :Connect(function(lockChildPart,...)
        if lockChildPart:IsA( "Tool" )and(((h.pureTweenFarm or h.autoFarmLoop ))and not h.holdingEggForGuard )then
            task.defer (function(...) unequipAllTools()
            end
            )
        end
    end
    )
end
doffTreadmill=function(...)
    if h then
        h.onTreadmill = false
    end
    local ragChar=LocalPlayer.Character
    local ragHumanoid=ragChar and ragChar:FindFirstChildOfClass( "Humanoid" )
    local ragRoot=ragChar and ragChar:FindFirstChild( "HumanoidRootPart" )
    if AskTreadmillDoff then
        task.spawn (function(...) pcall(function(...) AskTreadmillDoff:InvokeServer()
            end
            )
        end
        )
    end
    if ragHumanoid then
        pcall(function(...)
            for ragAnimIdx,ragAnimTrack in ipairs(ragHumanoid:GetPlayingAnimationTracks())do
                local ragAnimObj=ragAnimTrack.Animation
                local ragAnimId=ragAnimObj and ragAnimObj.AnimationId or ""
                if string.find (ragAnimId, "10921259953" )or string.find (string.lower (ragAnimTrack.Name ), "treadmill" )or string.find (string.lower (ragAnimTrack.Name ), "run" )then
                    ragAnimTrack:Stop( 0 )
                end
            end
            ragHumanoid.PlatformStand = false ragHumanoid.Sit = false ragHumanoid:SetStateEnabled(Enum.HumanoidStateType.Running , true )ragHumanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping , true )ragHumanoid:ChangeState(Enum.HumanoidStateType.Running )
        end
        )
    end
    local ragPlayerGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    if ragPlayerGui then
        local ragSpeedAnim=ragPlayerGui:FindFirstChild( "SpeedGainAnimation" )
        if ragSpeedAnim then
            pcall(function(...) ragSpeedAnim:Destroy()
            end
            )
        end
    end
    if ragRoot then
        ragRoot.AssemblyLinearVelocity =Vector3.zero ragRoot.AssemblyAngularVelocity =Vector3.zero
    end
    disableRagdoll(ragChar)
end
local prevTreadmillTime= 0
local isClickingExit= false fireTreadmillExit=function(...)
    local antiBtnGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    if not antiBtnGui then
        return false
    end
    local antiBtnBlocked= false pcall(function(...)
        for antiBtnGuiIdx,antiBtnGuiChild in ipairs(antiBtnGui:GetChildren())do
            if antiBtnGuiChild:IsA( "ScreenGui" )and antiBtnGuiChild.Enabled then
                for unstickScanIdx,uiBtn in ipairs(antiBtnGuiChild:GetDescendants())do
                    if((uiBtn:IsA( "TextButton" )or uiBtn:IsA( "ImageButton" )))and uiBtn.Visible then
                        local antiBtnText=(uiBtn:IsA( "TextButton" )and uiBtn.Text )or uiBtn.Name
                        local antiBtnTextLower=string.lower (antiBtnText or "" )
                        if string.find (antiBtnTextLower, "get out" )or string.find (antiBtnTextLower, "treadmill" )or string.find (antiBtnTextLower, "doff" )or string.find (antiBtnTextLower, "leave" )or string.find (antiBtnTextLower, "exit" )then
                            if typeof(firesignal)== "function" and uiBtn.Activated then
                                pcall(firesignal,uiBtn.Activated )
                            elseif typeof(firesignal)== "function" and uiBtn.MouseButton1Click then
                                pcall(firesignal,uiBtn.MouseButton1Click )
                            elseif typeof(getconnections)== "function" then
                                local antiBtnConns=getconnections(uiBtn.MouseButton1Click )or getconnections(uiBtn.Activated )or{}
                                for antiBtnConnIdx,antiBtnConn in ipairs(antiBtnConns)do
                                    pcall(function(...) antiBtnConn:Fire()
                                    end
                                    )
                                    break
                                end
                            end
                            antiBtnBlocked= true
                            break
                        end
                    end
                end
                if antiBtnBlocked then
                    break
                end
            end
        end
    end
    )
    return antiBtnBlocked
end
mountAndFarm=function(...)
    local farmChar=LocalPlayer.Character
    local farmCharRoot=farmChar and farmChar:FindFirstChild( "HumanoidRootPart" )
    if not farmCharRoot then
        return false
    end
    local farmEntryInfo=(typeof(findTreadmillEntry)== "function" )and findTreadmillEntry()or nil
    if farmEntryInfo then
        local farmEntryPos=farmEntryInfo.Position +Vector3.new ( 0 , 1.8 , 0 )
        local farmEntryDist=((farmCharRoot.Position -farmEntryPos)).Magnitude
        if farmEntryDist> 6 then
            if h then
                h.onTreadmill = false
            end
            return false
        end
    else
        if farmCharRoot.Position.X > 535 then
            if h then
                h.onTreadmill = false
            end
            return false
        end
    end
    if h and h.onTreadmill then
        return true
    end
    local farmHumanoid=farmChar and farmChar:FindFirstChildOfClass( "Humanoid" )
    if farmHumanoid then
        for farmAnimIdx,farmAnimTrack in ipairs(farmHumanoid:GetPlayingAnimationTracks())do
            local farmAnimObj=farmAnimTrack.Animation
            local farmAnimId=farmAnimObj and farmAnimObj.AnimationId or ""
            local farmAnimNameLower=string.lower (farmAnimTrack.Name or "" )
            if string.find (farmAnimId, "10921259953" )or string.find (farmAnimNameLower, "treadmill" )or string.find (farmAnimNameLower, "run" )then
                return true
            end
        end
    end
    local farmPlayerGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    if farmPlayerGui and farmPlayerGui:FindFirstChild( "SpeedGainAnimation" )then
        return true
    end
    return false
end
dismountTreadmill=function(...)
    if isClickingExit then
        return
    end
    if os.clock ()-prevTreadmillTime< 0.8 then
        if h then
            h.onTreadmill = false
        end
        return
    end
    isClickingExit= true prevTreadmillTime=os.clock ()
    if h then
        h.onTreadmill = false
    end
    fireTreadmillExit()
    if AskTreadmillDoff then
        pcall(function(...) AskTreadmillDoff:InvokeServer()
        end
        )
    end
    local treadChar=LocalPlayer.Character
    local treadHumanoid=treadChar and treadChar:FindFirstChildOfClass( "Humanoid" )
    local treadCharRoot=treadChar and treadChar:FindFirstChild( "HumanoidRootPart" )
    if treadHumanoid then
        pcall(function(...)
            for treadAnimIdx,treadAnimTrack in ipairs(treadHumanoid:GetPlayingAnimationTracks())do
                local treadAnimObj=treadAnimTrack.Animation
                local treadAnimId=treadAnimObj and treadAnimObj.AnimationId or ""
                local treadAnimNameLower=string.lower (treadAnimTrack.Name or "" )
                if string.find (treadAnimId, "10921259953" )or string.find (treadAnimNameLower, "treadmill" )or string.find (treadAnimNameLower, "run" )then
                    treadAnimTrack:Stop( 0 )
                end
            end
            treadHumanoid.PlatformStand = false treadHumanoid.Sit = false treadHumanoid:SetStateEnabled(Enum.HumanoidStateType.Running , true )treadHumanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping , true )treadHumanoid:ChangeState(Enum.HumanoidStateType.Running )
        end
        )
    end
    local treadPlayerGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    if treadPlayerGui then
        local treadSpeedAnim=treadPlayerGui:FindFirstChild( "SpeedGainAnimation" )
        if treadSpeedAnim then
            pcall(function(...) treadSpeedAnim:Destroy()
            end
            )
        end
    end
    if treadCharRoot then
        treadCharRoot.AssemblyLinearVelocity =Vector3.zero treadCharRoot.AssemblyAngularVelocity =Vector3.zero
    end
    disableRagdoll(treadChar)task.wait ( 0.15 )isClickingExit= false
end
dismountAlias=dismountTreadmill smartDoffTreadmill=function(...) pcall(function(...)
        local treadPlotsFolder=Workspace:FindFirstChild( "Plots" )
        if treadPlotsFolder then
            local treadPlotHome=h and h.plot
            if not treadPlotHome and mountTreadmill then
                treadPlotHome=select( 1 ,mountTreadmill())
            end
            for treadPlotIdx,treadPlotObj in ipairs(treadPlotsFolder:GetChildren())do
                local treadPlotIsHome=(treadPlotHome~=nil and treadPlotObj==treadPlotHome)
                local treadPlotBottom=treadPlotObj:FindFirstChild( "TreadmillBottom" )
                if treadPlotBottom and treadPlotBottom:IsA( "BasePart" )then
                    if treadPlotIsHome and(h and h.autoTreadmill )then
                        treadPlotBottom.CanTouch = true treadPlotBottom.CanCollide = true
                    else
                        treadPlotBottom.CanTouch = false treadPlotBottom.CanCollide = false
                    end
                end
                local treadPlotUpgrade=treadPlotObj:FindFirstChild( "TreadmillUpgrade" )
                if treadPlotUpgrade then
                    for treadPlotUpIdx,treadPlotUpChild in ipairs(treadPlotUpgrade:GetDescendants())do
                        if treadPlotUpChild:IsA( "BasePart" )then
                            if treadPlotIsHome and(h and h.autoTreadmill )then
                                treadPlotUpChild.CanTouch = true
                            else
                                treadPlotUpChild.CanTouch = false treadPlotUpChild.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end
    )
end
smartDoffTreadmill()Workspace.DescendantAdded :Connect(function(treadDesc,...) pcall(function(...)
        local treadWatchIsBottom=(treadDesc.Name == "TreadmillBottom" and treadDesc:IsA( "BasePart" ))
        local treadWatchIsUpgrade=(treadDesc.Name == "TreadmillUpgrade" and treadDesc:IsA( "Model" ))
        if treadWatchIsBottom or treadWatchIsUpgrade then
            local treadWatchHomePlot=h and h.plot
            if not treadWatchHomePlot and mountTreadmill then
                treadWatchHomePlot=select( 1 ,mountTreadmill())
            end
            local treadWatchInPlot=treadWatchHomePlot and treadDesc:IsDescendantOf(treadWatchHomePlot)
            if treadWatchInPlot and(h and h.autoTreadmill )then
                if treadWatchIsBottom then
                    treadDesc.CanTouch = true treadDesc.CanCollide = true
                else
                    for treadWatchBottomIdx,treadWatchBottomChild in ipairs(treadDesc:GetDescendants())do
                        if treadWatchBottomChild:IsA( "BasePart" )then
                            treadWatchBottomChild.CanTouch = true
                        end
                    end
                end
            else
                if treadWatchIsBottom then
                    treadDesc.CanTouch = false treadDesc.CanCollide = false
                else
                    for treadWatchUpIdx,treadWatchUpChild in ipairs(treadDesc:GetDescendants())do
                        if treadWatchUpChild:IsA( "BasePart" )then
                            treadWatchUpChild.CanTouch = false treadWatchUpChild.CanCollide = false
                        end
                    end
                end
            end
        end
    end
    )
end
)recoverAutoSteal=function(...) h.onTreadmill = false h.teleporting = false h.glidingToTarget = false h.securingEgg = false h.isReturning = false h.delivering = false h.holdingEggForGuard = false h.currentTargetModel =nil h.targetPosition =nil h.stateTime =os.clock ()
    local mountCharArg=LocalPlayer.Character
    local mountRootArg=mountCharArg and mountCharArg:FindFirstChild( "HumanoidRootPart" )
    if mountRootArg then
        pcall(function(...) mountRootArg.Anchored = false mountRootArg.AssemblyLinearVelocity =Vector3.zero mountRootArg.AssemblyAngularVelocity =Vector3.zero
        end
        )
    end
    pcall(function(...)
        if doffTreadmill then
            doffTreadmill()
        end
    end
    )pcall(function(...)
        if disableRagdoll and mountCharArg then
            disableRagdoll(mountCharArg)
        end
    end
    )pcall(function(...)
        if unequipAllTools and((h.pureTweenFarm or h.autoFarmLoop ))then
            unequipAllTools()
        end
    end
    )
end
followEgg=function(followEggObj,followEggSpeed,...)
    if followEggObj then
        for followDescIdx,followDescPart in ipairs(followEggObj:GetDescendants())do
            if followDescPart:IsA( "ProximityPrompt" )then
                pcall(function(...) followDescPart.RequiresLineOfSight = false followDescPart.HoldDuration = 0
                    if typeof(fireproximityprompt)== "function" then
                        fireproximityprompt(followDescPart, 0 )fireproximityprompt(followDescPart)
                    end
                end
                )
            end
        end
    end
    local followSlotsClient=Workspace:FindFirstChild( "AreaEggSlotsClient" )
    if followSlotsClient and followEggSpeed then
        for followSlotIdx,followSlotObj in ipairs(followSlotsClient:GetChildren())do
            local followSlotPart=followSlotObj:FindFirstChildWhichIsA( "BasePart" )or followSlotObj.PrimaryPart
            if followSlotPart and((followSlotPart.Position -followEggSpeed)).Magnitude <= 18 then
                for followSlotDescIdx,followSlotDesc in ipairs(followSlotObj:GetDescendants())do
                    if followSlotDesc:IsA( "ProximityPrompt" )then
                        pcall(function(...) followSlotDesc.RequiresLineOfSight = false followSlotDesc.HoldDuration = 0
                            if typeof(fireproximityprompt)== "function" then
                                fireproximityprompt(followSlotDesc, 0 )fireproximityprompt(followSlotDesc)
                            end
                        end
                        )
                    end
                end
            end
        end
    end
end
setGodmode=function(godmodeOnArg,...) h.godmode =godmodeOnArg
    local godmodeChar=LocalPlayer.Character
    if not godmodeChar then
        return
    end
    local godmodeHumanoid=godmodeChar:FindFirstChildOfClass( "Humanoid" )
    if godmodeHumanoid then
        godmodeHumanoid:SetStateEnabled(Enum.HumanoidStateType.Dead ,not godmodeOnArg)
        if godmodeOnArg and godmodeHumanoid.Health < 100 then
            godmodeHumanoid.Health = 100
        end
    end
    for godmodeDescIdx,godmodeDescPart in ipairs(godmodeChar:GetDescendants())do
        if godmodeDescPart:IsA( "BasePart" )then
            if godmodeOnArg then
                godmodeDescPart.CanTouch = false godmodeDescPart.CanCollide = false
            end
        end
    end
    disableRagdoll(godmodeChar)
end
local function enableGodmode()
    setGodmode(true)
end
local function disableGodmode()
    setGodmode(false)
end

swapHumanoidAntiDesync=function(...)
    local mountChar=LocalPlayer.Character
    local baseHumanoid=mountChar and mountChar:FindFirstChildOfClass( "Humanoid" )
    if not mountChar or not baseHumanoid then
        return false
    end
    pcall(function(...) baseHumanoid.BreakJointsOnDeath = false
        local cloneHumanoid=baseHumanoid:Clone()cloneHumanoid.Parent =mountChar baseHumanoid:Destroy()
        local cloneAnimator=cloneHumanoid:FindFirstChildOfClass( "Animator" )
        if not cloneAnimator then
            cloneAnimator=Instance.new ( "Animator" )cloneAnimator.Parent =cloneHumanoid
        end
        Workspace.CurrentCamera.CameraSubject =cloneHumanoid
        local mountAnimate=mountChar:FindFirstChild( "Animate" )
        if mountAnimate and mountAnimate:IsA( "LocalScript" )then
            mountAnimate.Disabled = true task.defer (function(...) task.wait ( 0.05 )mountAnimate.Disabled = false
            end
            )
        end
        cloneHumanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping , true )cloneHumanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall , true )cloneHumanoid:SetStateEnabled(Enum.HumanoidStateType.Running , true )cloneHumanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing , true )cloneHumanoid.JumpPower =math.max ( 50 ,cloneHumanoid.JumpPower )cloneHumanoid.JumpHeight =math.max ( 7.2 ,cloneHumanoid.JumpHeight )cloneHumanoid:ChangeState(Enum.HumanoidStateType.Running )
    end
    )h.swapped = true
    if h.godmode then
        setGodmode( true )
    end
    lockRigJoints(mountChar)
    return true
end
mountTreadmill=function(...)
    if h.plot and(h.plot.Parent and(h.pen and(h.origin and h.plotVerified )))then
        return h.plot ,h.pen ,h.origin
    end
    local plotsFolder=Workspace:FindFirstChild( "Plots" )
    if not plotsFolder then
        return nil,nil,nil
    end
    local ownUserId=LocalPlayer.UserId
    local ownUserName=LocalPlayer.Name
    local ownDisplayName=LocalPlayer.DisplayName
    local ownerHrp=nil
    local plotOwned= false
    if AskState then
        local plotOwnOk,plotOwnData=pcall(function(...)
            return AskState:InvokeServer()
        end
        )
        if plotOwnOk and(type(plotOwnData)== "table" and type(plotOwnData.OwnersBySlot )== "table" )then
            for ownerSlotKey,ownerSlotVal in pairs(plotOwnData.OwnersBySlot )do
                if ownerSlotVal==ownUserId or tostring(ownerSlotVal)==tostring(ownUserId)or ownerSlotVal==ownUserName then
                    ownerHrp=plotsFolder:FindFirstChild(tostring(ownerSlotKey))
                    if ownerHrp then
                        plotOwned= true
                        break
                    end
                end
            end
        end
    end
    if not ownerHrp and AskLiveSnapshot then
        local ownerReadOk,ownerReadData=pcall(function(...)
            return AskLiveSnapshot:InvokeServer()
        end
        )
        if ownerReadOk and type(ownerReadData)== "table" then
            for ownerRecKey,ownerRecVal in pairs(ownerReadData)do
                if type(ownerRecVal)== "table" and((ownerRecVal.OwnerUserId ==ownUserId or tostring(ownerRecVal.OwnerUserId )==tostring(ownUserId)))then
                    local ownerSlotId=ownerRecVal.Slot or ownerRecKey ownerHrp=plotsFolder:FindFirstChild(tostring(ownerSlotId))or plotsFolder:FindFirstChild(tostring(ownerRecKey))
                    if ownerHrp then
                        plotOwned= true
                        break
                    end
                end
            end
        end
    end
    if not ownerHrp then
        for ownerPlotIdx,ownerPlotObj in ipairs(plotsFolder:GetChildren())do
            local ownerPlotAttr=ownerPlotObj:GetAttribute( "Owner" )or ownerPlotObj:GetAttribute( "OwnerUserId" )or ownerPlotObj:GetAttribute( "UserId" )or ownerPlotObj:GetAttribute( "OwnerId" )or ownerPlotObj:GetAttribute( "Player" )
            if ownerPlotAttr and((ownerPlotAttr==ownUserId or tostring(ownerPlotAttr)==tostring(ownUserId)or ownerPlotAttr==ownUserName or tostring(ownerPlotAttr)==ownUserName or ownerPlotAttr==ownDisplayName))then
                ownerHrp=ownerPlotObj plotOwned= true
                break
            end
            for ownerAttrIdx,ownerAttrName in ipairs({ "Owner" , "OwnerUserId" , "OwnerId" ;
                "UserId" ;
                "Player" ;
                "PlayerName" })do
                local ownerAttrChild=ownerPlotObj:FindFirstChild(ownerAttrName)
                if ownerAttrChild and((ownerAttrChild.Value ==ownUserId or tostring(ownerAttrChild.Value )==tostring(ownUserId)or ownerAttrChild.Value ==ownUserName or ownerAttrChild.Value ==ownDisplayName))then
                    ownerHrp=ownerPlotObj plotOwned= true
                    break
                end
            end
            if ownerHrp then
                break
            end
        end
    end
    if not ownerHrp then
        for ownerScanPlotIdx,ownerScanPlot in ipairs(plotsFolder:GetChildren())do
            for ownerScanDescIdx,ownerScanDesc in ipairs(ownerScanPlot:GetDescendants())do
                if ownerScanDesc:IsA( "TextLabel" )and ownerScanDesc.Text ~= "" then
                    local ownerScanTextLower=string.lower (ownerScanDesc.Text )
                    if string.find (ownerScanTextLower,string.lower (ownUserName), 1 , true )or(ownDisplayName and string.find (ownerScanTextLower,string.lower (ownDisplayName), 1 , true ))then
                        ownerHrp=ownerScanPlot plotOwned= true
                        break
                    end
                end
            end
            if ownerHrp then
                break
            end
        end
    end
    if not ownerHrp then
        local nearChar=LocalPlayer.Character
        local nearRoot=nearChar and nearChar:FindFirstChild( "HumanoidRootPart" )
        if nearRoot and nearRoot.Position.X <=(safeLineX+ 30 )then
            local nearBestPlot=nil
            local nearBestDist= 999999
            for nearPlotIdx,nearPlotObj in ipairs(plotsFolder:GetChildren())do
                local nearPlotCenter=nearPlotObj:FindFirstChild( "CenterPoint" )or nearPlotObj.PrimaryPart or nearPlotObj:FindFirstChildWhichIsA( "BasePart" )
                if nearPlotCenter then
                    local nearPlotDist=((nearRoot.Position -nearPlotCenter.Position )).Magnitude
                    if nearPlotDist<nearBestDist then
                        nearBestDist=nearPlotDist nearBestPlot=nearPlotObj
                    end
                end
            end
            if nearBestPlot and nearBestDist< 160 then
                ownerHrp=nearBestPlot
            end
        end
    end
    if not ownerHrp then
        ownerHrp=plotsFolder:FindFirstChild( "2" )or plotsFolder:FindFirstChild( "1" )or(plotsFolder:GetChildren())[ 1 ]
    end
    if not ownerHrp then
        return nil,nil,nil
    end
    h.plot =ownerHrp h.plotVerified =plotOwned h.origin =ownerHrp:FindFirstChild( "CenterPoint" )
    local plotUpdateObj=ownerHrp:FindFirstChild( "ToUpdate" )h.pen =(plotUpdateObj and plotUpdateObj:FindFirstChild( "PetArea" ))or ownerHrp:FindFirstChild( "PetArea" )h.tread =ownerHrp:FindFirstChild( "TreadmillBottom" )
    if not h.pen and plotUpdateObj then
        for plotUpdateChildIdx,plotUpdateChild in ipairs(plotUpdateObj:GetChildren())do
            if plotUpdateChild:IsA( "BasePart" )and string.find (string.lower (plotUpdateChild.Name ), "pet" )then
                h.pen =plotUpdateChild
                break
            end
        end
    end
    if not h.origin then
        h.origin =ownerHrp:FindFirstChild( "CenterPoint" )or h.pen or ownerHrp.PrimaryPart
    end
    if not h.pen then
        h.pen =h.origin
    end
    return h.plot ,h.pen ,h.origin
end
findTreadmill=function(...)
    local mountRetTread,mountRetBottom,mountRetUpgrade=mountTreadmill()
    if mountRetBottom then
        return mountRetBottom.Position +Vector3.new ( 0 , 3.5 , 0 )
    end
    if mountRetUpgrade then
        return mountRetUpgrade.Position +Vector3.new ( 0 , 3.5 , 0 )
    end
    return Vector3.new ( 464.7 , 71.7 , -304 )
end
upgradeTreadmill=function(upgrTreads,...)
    local upgrBottom,upgrUpgrade,upgrRoot=mountTreadmill()
    if not upgrUpgrade then
        return nil
    end
    local upgrSize=upgrUpgrade.Size
    local upgrHalfX=math.max ( 4 ,upgrSize.X / 2 - 5 )
    local upgrHalfZ=math.max ( 4 ,upgrSize.Z / 2 - 5 )
    for spotScanIdx= 1 , 60 , 1 do
        local upgrRandX=math.random (-math.floor (upgrHalfX),math.floor (upgrHalfX))
        local upgrRandZ=math.random (-math.floor (upgrHalfZ),math.floor (upgrHalfZ))
        local upgrRandCf=upgrUpgrade.CFrame *CFrame.new (upgrRandX,upgrSize.Y / 2 + 1 ,upgrRandZ)
        local upgrSlotFree= true
        for upgrTreadIdx,upgrTreadPart in ipairs(upgrTreads)do
            if((upgrTreadPart-upgrRandCf.Position )).Magnitude < 5.5 then
                upgrSlotFree= false
                break
            end
        end
        if upgrSlotFree then
            return upgrRandCf
        end
    end
    return upgrUpgrade.CFrame *CFrame.new (math.random ( -8 , 8 ),upgrSize.Y / 2 + 1 ,math.random ( -8 , 8 ))
end
buyRandomTrail=function(...)
    local bmTread,bmBottom,bmUpgrade=mountTreadmill()
    if not bmUpgrade or not AskPlaceEgg then
        return 0
    end
    local bmUpgErr= 0
    local bmUpgList={}
    if AskLiveSnapshot then
        local placeRecOk,placeRecData=pcall(function(...)
            return AskLiveSnapshot:InvokeServer()
        end
        )
        if placeRecOk and type(placeRecData)== "table" then
            local bmAreaRecs={}
            for bmAreaKey,bmAreaVal in pairs(placeRecData)do
                if type(bmAreaVal)== "table" and bmAreaVal.OwnerUserId ==LocalPlayer.UserId then
                    for bmRecKey,bmRec in pairs(bmAreaVal.Records or{})do
                        bmAreaRecs[bmRecKey]=bmRec
                    end
                end
            end
            for bmMergeKey,bmMergeVal in pairs(bmAreaRecs)do
                if bmMergeVal.Placement and bmMergeVal.Placement.LocalCFrame then
                    bmUpgList[#bmUpgList+ 1 ]=((bmUpgrade.CFrame *bmMergeVal.Placement.LocalCFrame )).Position
                else
                    local bmUpgResult=upgradeTreadmill(bmUpgList)
                    if bmUpgResult then
                        local bmUpgOffset=bmUpgrade.CFrame :ToObjectSpace(bmUpgResult)
                        local incubatorOk,incubatorRes=pcall(function(...)
                            return AskPlaceEgg:InvokeServer({[ "Uid" ]=bmMergeKey;
                            [ "LocalCFrame" ]=bmUpgOffset})
                        end
                        )
                        if incubatorOk and incubatorRes then
                            bmUpgErr=bmUpgErr+ 1 bmUpgList[#bmUpgList+ 1 ]=bmUpgResult.Position
                        end
                    end
                end
            end
        end
    end
    local bmEggTools={}
    local bmChar=LocalPlayer.Character
    if bmChar then
        for bmCharChildIdx,bmCharChild in ipairs(bmChar:GetChildren())do
            if isEggTool(bmCharChild)then
                table.insert (bmEggTools,bmCharChild)
            end
        end
    end
    local bmBackpack=LocalPlayer:FindFirstChild( "Backpack" )
    if bmBackpack then
        for bmBpChildIdx,bmBpChild in ipairs(bmBackpack:GetChildren())do
            if isEggTool(bmBpChild)then
                table.insert (bmEggTools,bmBpChild)
            end
        end
    end
    for bmToolIdx,bmToolObj in ipairs(bmEggTools)do
        if not h.alive then
            break
        end
        local bmToolUid=bmToolObj:GetAttribute( "UID" )or bmToolObj:GetAttribute( "EggUid" )or bmToolObj.Name
        local bmToolUpgResult=upgradeTreadmill(bmUpgList)
        if bmToolUpgResult then
            local bmToolUpgOffset=bmUpgrade.CFrame :ToObjectSpace(bmToolUpgResult)
            local incubatorInvOk,incubatorInvRes=pcall(function(...)
                return AskPlaceEgg:InvokeServer({[ "Uid" ]=bmToolUid,[ "LocalCFrame" ]=bmToolUpgOffset})
            end
            )
            if incubatorInvOk and incubatorInvRes~= false then
                bmUpgErr=bmUpgErr+ 1 bmUpgList[#bmUpgList+ 1 ]=bmToolUpgResult.Position Log(string.format ( "[PlaceEgg] Placed egg %s from inventory" ,tostring(bmToolUid)))
            end
            task.wait ( 0.04 )
        end
    end
    return bmUpgErr
end
hatchReadyEggs=function(hatchModeArg,...)
    if(not hatchModeArg and not h.autoHatch )or not AskHatch or not AskFinishHatch or not AskLiveSnapshot then
        return 0
    end
    if h.isHatching then
        return 0
    end
    h.isHatching = true
    local hatchReadOk,hatchReadData=pcall(function(...)
        return AskLiveSnapshot:InvokeServer()
    end
    )
    if not hatchReadOk or type(hatchReadData)~= "table" then
        return 0
    end
    local hatchCandidates={}
    for hatchAreaKey,hatchAreaVal in pairs(hatchReadData)do
        if type(hatchAreaVal)== "table" and hatchAreaVal.OwnerUserId ==LocalPlayer.UserId then
            for hatchRecKey,hatchRecVal in pairs(hatchAreaVal.Records or{})do
                hatchCandidates[hatchRecKey]=hatchRecVal
            end
        end
    end
    local hatchReadyList={}
    local hatchServerTime=Workspace:GetServerTimeNow()
    for hatchItemIdx,hatchItem in pairs(hatchCandidates)do
        if not h.alive then
            break
        end
        if hatchItem.Placement then
            local hatchIsReady=nil
            if EggStateModule then
                local hatchReadyFn=EggStateModule.IsReadyToHatch or EggStateModule.IsLocalEggReady
                if hatchReadyFn then
                    local hatchReadyOk,hatchReadyRes=pcall(hatchReadyFn,hatchItemIdx)
                    if hatchReadyOk and type(hatchReadyRes)== "boolean" then
                        hatchIsReady=hatchReadyRes
                    end
                end
            end
            if hatchIsReady==nil then
                local hatchPlacedAt=hatchItem.Placement.PlacedAt or hatchItem.Placement.Time or 0
                local hatchGrowthTime= 30
                if AssetItemsModule and(AssetItemsModule.Assets and AssetItemsModule.Assets [hatchItem.AssetCategory ])then
                    local hatchAssetDef=AssetItemsModule.Assets [hatchItem.AssetCategory ]hatchGrowthTime=(hatchAssetDef and(hatchAssetDef.Egg and hatchAssetDef.Egg.GrowthTime ))or 30
                end
                local hatchNeededTime=hatchGrowthTime/math.max ( 0.01 ,hatchItem.GrowthSpeedMultiplier or 1 )hatchIsReady=(hatchServerTime-hatchPlacedAt)>=hatchNeededTime
            end
            if hatchIsReady then
                table.insert (hatchReadyList,{[ "uid" ]=hatchItemIdx;
                [ "category" ]=hatchItem.AssetCategory or "Egg" })
            end
        end
    end
    if#hatchReadyList== 0 then
        h.isHatching = false
        return 0
    end
    Log(string.format ( "[AutoHatch] Found %d eggs ready to hatch! Starting hatch sequence..." ,#hatchReadyList))h.statusText =string.format ( "[Hatch] Hatching %d ready eggs..." ,#hatchReadyList)
    local hatchCountDone= 0
    for hatchReadyIdx,hatchReadyRec in ipairs(hatchReadyList)do
        task.spawn (function(...)
            local hatchReqOk,hatchReqRes=pcall(function(...)
                if AskHatch:IsA( "RemoteFunction" )then
                    return AskHatch:InvokeServer(hatchReadyRec.uid )
                else
                    AskHatch:FireServer(hatchReadyRec.uid )
                    return true
                end
            end
            )
            if hatchReqOk and hatchReqRes~= false then
                task.wait ( 0.9 )
                local hatchFireOk,hatchFireErr=pcall(function(...)
                    if AskFinishHatch:IsA( "RemoteFunction" )then
                        return AskFinishHatch:InvokeServer(hatchReadyRec.uid )
                    else
                        AskFinishHatch:FireServer(hatchReadyRec.uid )
                        return true
                    end
                end
                )
                if hatchFireOk and hatchFireErr~= false then
                    hatchCountDone=hatchCountDone+ 1 h.hatched =((h.hatched or 0 ))+ 1 Log(string.format ( "[+] [AutoHatch] Hatched %s (UID: %s) -> Total Hatched: %d" ,hatchReadyRec.category ,tostring(hatchReadyRec.uid ),h.hatched ))
                end
            end
        end
        )task.wait ( 0.04 )
    end
    task.wait ( 0.95 )h.isHatching = false Log(string.format ( "[AutoHatch] Finished! Hatched %d eggs." ,hatchCountDone))
    return hatchCountDone
end
hatchAllEggs=function(...)
    local debrisEggList={}
    local debrisFolder=Workspace:FindFirstChild( "__DEBRIS" )
    if debrisFolder then
        for debrisChildIdx,debrisChild in ipairs(debrisFolder:GetChildren())do
            local debrisHitbox=debrisChild:FindFirstChild( "Hitbox" )
            if debrisHitbox and debrisHitbox:IsA( "BasePart" )then
                table.insert (debrisEggList,debrisHitbox)
            elseif debrisChild:IsA( "BasePart" )and string.find (debrisChild.Name :lower(), "hitbox" )then
                table.insert (debrisEggList,debrisChild)
            end
        end
    end
    local bossTeleportObj=Workspace:FindFirstChild( "BossArenaTeleport" )
    if bossTeleportObj then
        local bossHitbox=bossTeleportObj:FindFirstChild( "Hitbox" )or bossTeleportObj:FindFirstChildWhichIsA( "BasePart" )or(bossTeleportObj:IsA( "BasePart" )and bossTeleportObj)
        if bossHitbox and bossHitbox:IsA( "BasePart" )then
            table.insert (debrisEggList,bossHitbox)
        end
    end
    return debrisEggList
end
placeEggsToStand=function(standSpeedArg,standSessionArg,standEggArg,...)
    local carryChar=LocalPlayer.Character
    local carryCharRoot=carryChar and carryChar:FindFirstChild( "HumanoidRootPart" )
    local standHumanoid=carryChar and carryChar:FindFirstChildOfClass( "Humanoid" )
    if not carryCharRoot then
        return false
    end
    if standHumanoid then
        standHumanoid.AutoRotate = false
    end
    local treadPos=findTreadmill()standSpeedArg=math.max ( 100 ,standSpeedArg or h.glideSpeed or 600 )
    local standLaneZ=h.laneZ or corridorZ h.isReturning = true h.stateTime =os.clock ()spawnSafetyFloor(treadPos, 20 )carryCharRoot.AssemblyLinearVelocity =Vector3.zero carryCharRoot.AssemblyAngularVelocity =Vector3.zero
    local standGlideSpeed=getEggGlideSpeed()
    local standMaxSpeed=math.max (standSpeedArg,standGlideSpeed)
    local standDeadline=os.clock ()+ 25
    while h.alive and(h.isReturning and os.clock ()<standDeadline)do
        if standSessionArg and sessionSwitchId~=standSessionArg then
            if standHumanoid then
                standHumanoid.AutoRotate = true
            end
            h.isReturning = false
            return false
        end
        if not standEggArg and(not h.pureTweenFarm and not h.autoFarmLoop )then
            if standHumanoid then
                standHumanoid.AutoRotate = true
            end
            h.isReturning = false
            return false
        end
        local carPos=carryCharRoot.Position
        local carDist=((treadPos-carPos)).Magnitude
        if(carPos.X <=(treadPos.X + 3 )and math.abs (carPos.Z -treadPos.Z )<= 8 )or carDist<= 6 then
            break
        end
        local carWatchConn=RunService.Heartbeat :Wait()carPos=carryCharRoot.Position
        local standCurSpeed=standMaxSpeed
        if carPos.X <=returnX and carPos.X >safeLineX then
            local standFrac=math.clamp (((carPos.X -safeLineX))/((returnX-safeLineX)), 0 , 1 )standCurSpeed=returnDistMul+(((standMaxSpeed-returnDistMul))*standFrac)
        elseif carPos.X <=safeLineX then
            standCurSpeed=returnDistMul
        end
        local standLaneZCur=treadPos.Z
        if carPos.X > 540 then
            standLaneZCur=standLaneZ
        end
        local standDirX=math.sign (treadPos.X -carPos.X )
        local standStepX=standDirX*math.min (math.abs (treadPos.X -carPos.X ),standCurSpeed*carWatchConn)
        local standNewX=carPos.X +standStepX
        local standDirY=math.sign (treadPos.Y -carPos.Y )
        local standStepY=standDirY*math.min (math.abs (treadPos.Y -carPos.Y ),(standCurSpeed*carWatchConn)* 0.5 )
        local standNewY=carPos.Y +standStepY
        local standDiffZ=standLaneZCur-carPos.Z
        local standStepZ=math.sign (standDiffZ)*math.min (math.abs (standDiffZ),standCurSpeed*carWatchConn)
        local standNewZ=carPos.Z +standStepZ
        local standHatchAll=hatchAllEggs()
        local standNearHatched= false
        if carPos.X >safeLineX then
            for standHatchIdx,standHatchRec in ipairs(standHatchAll)do
                local standHatchPos=standHatchRec.Position
                local standHatchDist=((Vector3.new (standNewX,standNewY,standNewZ)-standHatchPos)).Magnitude
                local standHatchDx=math.abs (standNewX-standHatchPos.X )
                local standHatchDz=math.abs (standNewZ-standHatchPos.Z )
                if standHatchDist< 22 or(standHatchDx< 18 and standHatchDz< 14 )then
                    standNearHatched= true
                    local standHatchLiftY=standHatchPos.Y + 16
                    if standNewY<standHatchLiftY then
                        standNewY=math.min (standNewY+((standCurSpeed*carWatchConn)* 1.5 ),standHatchLiftY)
                    end
                    break
                end
            end
        end
        local standTargetPos=Vector3.new (standNewX,standNewY,standNewZ)
        local standLookVec=((standTargetPos-carPos)).Magnitude > 0.05 and((standTargetPos-carPos)).Unit or carryCharRoot.CFrame.LookVector carryCharRoot.CFrame =CFrame.lookAt (standTargetPos,standTargetPos+standLookVec)carryCharRoot.AssemblyLinearVelocity =Vector3.zero carryCharRoot.AssemblyAngularVelocity =Vector3.zero
        if standNearHatched then
            h.statusText =string.format ( "Tweening Home (Z: %.0f) [DODGING TRAP!]" ,standNewZ)
        else
            h.statusText =string.format ( "Tweening Home (%.0f studs | Z: %.0f | Spd: %.0f)" ,carDist,standNewZ,standCurSpeed)
        end
    end
    carryCharRoot.CFrame =CFrame.new (treadPos)carryCharRoot.AssemblyLinearVelocity =Vector3.zero carryCharRoot.AssemblyAngularVelocity =Vector3.zero
    if standHumanoid then
        standHumanoid.AutoRotate = true
    end
    unequipAllTools()h.isReturning = false h.delivering = false h.statusText = "Arrived at Base PetArea!"
    return true
end
autoPlaceLoop=function(placeSpeedArg,placeEggArg,placeSessionArg,...)
    local placeChar=LocalPlayer.Character
    local placeCharRoot=placeChar and placeChar:FindFirstChild( "HumanoidRootPart" )
    local placeHumanoid=placeChar and placeChar:FindFirstChildOfClass( "Humanoid" )
    if not placeCharRoot or not placeHumanoid then
        return
    end
    local placeTreadInfo=findTreadmill()
    local placeTreadDist=((placeCharRoot.Position -placeTreadInfo)).Magnitude
    if placeTreadDist> 8 then
        h.statusText = "[Place] Tweening back to base plot..." placeEggsToStand(placeSpeedArg or h.glideSpeed or 600 ,placeEggArg, true )
    end
    spawnSafetyFloor(placeTreadInfo, 15 )placeCharRoot.CFrame =CFrame.new (placeTreadInfo)placeCharRoot.AssemblyLinearVelocity =Vector3.zero h.statusText = "[Place] Placing All Eggs to Stand..."
    local placeDeadline=os.clock ()+ 3
    while countCarriedEggs()> 0 and(os.clock ()<placeDeadline and h.alive )do
        buyRandomTrail()task.wait ( 0.06 )
    end
    h.statusText = "[Place] Hatching ready eggs..." hatchReadyEggs( true )unequipAllTools()h.isReturning = false h.delivering = false h.currentTargetModel =nil h.targetPosition =nil
    local placeLeftEggs=countCarriedEggs()h.statusText =string.format ( "Placed & Hatched (Left: %d)! Hands Free." ,placeLeftEggs)
end
local batchStealLimit= 5 pickUnhatchedEgg=function(pickModeArg,...)
    if h.isBatchPlacing then
        return
    end
    h.isBatchPlacing = true Log(string.format ( "[AutoPlace] %d steals done! Batch placing (%s mode)..." ,batchStealLimit,tostring(pickModeArg)))
    local pickSessionCpy=sessionSwitchId h.pureTweenFarm =(pickModeArg== "TWEEN" )h.autoFarmLoop =(pickModeArg== "WARP" )
    local pickChar=LocalPlayer.Character
    local pickCharRoot=pickChar and pickChar:FindFirstChild( "HumanoidRootPart" )
    local pickHumanoid=pickChar and pickChar:FindFirstChildOfClass( "Humanoid" )
    local pickTreadInfo=findTreadmill()
    local pickTreadDist=pickCharRoot and((pickCharRoot.Position -pickTreadInfo)).Magnitude or 999
    if pickTreadDist> 8 then
        h.statusText = "[AutoPlace] Tweening home to base plot..." placeEggsToStand(h.glideSpeed or 600 ,pickSessionCpy, true )
    end
    if pickCharRoot then
        spawnSafetyFloor(pickTreadInfo, 20 )pickCharRoot.CFrame =CFrame.new (pickTreadInfo)pickCharRoot.AssemblyLinearVelocity =Vector3.zero pickCharRoot.AssemblyAngularVelocity =Vector3.zero
        if pickHumanoid then
            pickHumanoid.AutoRotate = true
        end
    end
    task.spawn (function(...) pcall(buyRandomTrail)pcall(hatchReadyEggs, true )
    end
    )unequipAllTools()h.isReturning = false h.delivering = false h.glidingToTarget = false h.securingEgg = false h.teleporting = false h.currentTargetModel =nil h.targetPosition =nil
    for pickRetryIdx= 5 , 1 , -1 do
        if not h.alive then
            break
        end
        h.statusText =string.format ( "[AutoPlace] At Base: Resuming in %ds..." ,pickRetryIdx)task.wait ( 1 )
    end
    h.isBatchPlacing = false
    if h.alive and sessionSwitchId==pickSessionCpy then
        Log(string.format ( "[AutoPlace] Done! Continuing %s farm." ,pickModeArg))h.statusText =string.format ( "[AutoPlace] Resuming %s farm..." ,pickModeArg)
        if pickModeArg== "TWEEN" then
            h.pureTweenFarm = true h.autoFarmLoop = false
        elseif pickModeArg== "WARP" then
            h.autoFarmLoop = true h.pureTweenFarm = false
        end
        farmMode=pickModeArg
    end
end
autoPlaceEggs=function(autoPlaceEggArg,...)
    if not h.autoPlaceEvery5 then
        return false
    end
    h.batchStealCount =((h.batchStealCount or 0 ))+ 1 Log(string.format ( "[AutoPlace] Steal trip %d / %d completed successfully." ,h.batchStealCount ,batchStealLimit))
    if h.batchStealCount >=batchStealLimit then
        h.batchStealCount = 0 task.spawn (function(...) pickUnhatchedEgg(autoPlaceEggArg)
        end
        )
        return true
    end
    return false
end
local function flyToPos(glideDestArg,glideSpeedArg,glideEggArg,glideModeArg,...)
    local glideChar=LocalPlayer.Character
    local glideCharRoot=glideChar and glideChar:FindFirstChild( "HumanoidRootPart" )
    local glideHumanoid=glideChar and glideChar:FindFirstChildOfClass( "Humanoid" )
    if not glideCharRoot then
        return false
    end
    if glideHumanoid then
        glideHumanoid.AutoRotate = false
    end
    glideSpeedArg=math.max ( 60 ,glideSpeedArg or h.glideSpeed or 350 )
    local landPos=glideDestArg.Position spawnSafetyFloor(landPos, 14 )pcall(function(...) LocalPlayer:RequestStreamAroundAsync(landPos)
    end
    )glideCharRoot.AssemblyLinearVelocity =Vector3.zero glideCharRoot.AssemblyAngularVelocity =Vector3.zero
    local glideLaneZ=h.laneZ or corridorZ h.glidingToTarget = true h.stateTime =os.clock ()
    local glideWaitAmt= 0
    local glideDeadline=os.clock ()+ 15
    while h.alive and(h.glidingToTarget and os.clock ()<glideDeadline)do
        if glideModeArg and sessionSwitchId~=glideModeArg then
            if glideHumanoid then
                glideHumanoid.AutoRotate = true
            end
            h.glidingToTarget = false
            return false
        end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting )then
            if glideHumanoid then
                glideHumanoid.AutoRotate = true
            end
            h.glidingToTarget = false
            return false
        end
        local retPos=glideCharRoot.Position
        local retDist=((landPos-retPos)).Magnitude
        local retXZDist=((Vector2.new (retPos.X ,retPos.Z )-Vector2.new (landPos.X ,landPos.Z ))).Magnitude
        local retYDiff=math.abs (retPos.Y -landPos.Y )
        if retDist<= 6 or(retXZDist<= 3.5 and retYDiff<= 6 )then
            break
        end
        local glideDt=RunService.Heartbeat :Wait()retPos=glideCharRoot.Position retDist=((landPos-retPos)).Magnitude retXZDist=((Vector2.new (retPos.X ,retPos.Z )-Vector2.new (landPos.X ,landPos.Z ))).Magnitude
        local glideResidualX=math.abs (retPos.X -landPos.X )
        if glideEggArg and(os.clock ()-glideWaitAmt> 0.5 )then
            glideWaitAmt=os.clock ()
            local glideState,glideStateName=checkEggState(glideEggArg)
            if not glideState and glideStateName== "CarriedByOther" then
                if glideHumanoid then
                    glideHumanoid.AutoRotate = true
                end
                h.glidingToTarget = false
                return false
            end
        end
        local glideLaneZCur=landPos.Z
        if glideResidualX> 40 then
            glideLaneZCur=glideLaneZ
        end
        local glideDirX=math.sign (landPos.X -retPos.X )
        local glideStepX=glideDirX*math.min (math.abs (landPos.X -retPos.X ),glideSpeedArg*glideDt)
        local glideNewX=retPos.X +glideStepX
        local glideYScale=(retXZDist<= 25 )and 1.2 or 0.5
        local glideDirY=math.sign (landPos.Y -retPos.Y )
        local glideStepY=glideDirY*math.min (math.abs (landPos.Y -retPos.Y ),(glideSpeedArg*glideDt)*glideYScale)
        local glideNewY=retPos.Y +glideStepY
        local glideDiffZ=glideLaneZCur-retPos.Z
        local glideStepZ=math.sign (glideDiffZ)*math.min (math.abs (glideDiffZ),glideSpeedArg*glideDt)
        local glideNewZ=retPos.Z +glideStepZ
        local glideLanded= false
        if retXZDist> 25 then
            local glideHatchAll=hatchAllEggs()
            for glideHatchIdx,glideHatchRec in ipairs(glideHatchAll)do
                local glideHatchPos=glideHatchRec.Position
                local glideHatchDist=((Vector3.new (glideNewX,glideNewY,glideNewZ)-glideHatchPos)).Magnitude
                local glideHatchDx=math.abs (glideNewX-glideHatchPos.X )
                local glideHatchDz=math.abs (glideNewZ-glideHatchPos.Z )
                if glideHatchDist< 22 or(glideHatchDx< 18 and glideHatchDz< 14 )then
                    glideLanded= true
                    local glideHatchLiftY=glideHatchPos.Y + 16
                    if glideNewY<glideHatchLiftY then
                        glideNewY=math.min (glideNewY+((glideSpeedArg*glideDt)* 1.5 ),glideHatchLiftY)
                    end
                    break
                end
            end
        end
        local glideTargetPos=Vector3.new (glideNewX,glideNewY,glideNewZ)
        local glideLookVec=((glideTargetPos-retPos)).Magnitude > 0.05 and((glideTargetPos-retPos)).Unit or glideCharRoot.CFrame.LookVector glideCharRoot.CFrame =CFrame.lookAt (glideTargetPos,glideTargetPos+glideLookVec)glideCharRoot.AssemblyLinearVelocity =Vector3.zero glideCharRoot.AssemblyAngularVelocity =Vector3.zero
        if glideLanded then
            h.statusText =string.format ( "Gliding Out (Z: %.0f) [DODGING TRAP!]" ,glideNewZ)
        else
            h.statusText =string.format ( "Gliding -> Egg (%.0f studs | H: %.0f)" ,retDist,retXZDist)
        end
    end
    glideCharRoot.CFrame =glideDestArg*CFrame.new ( 0 , 0.4 , 0 )glideCharRoot.AssemblyLinearVelocity =Vector3.zero glideCharRoot.AssemblyAngularVelocity =Vector3.zero
    if glideHumanoid then
        glideHumanoid.AutoRotate = true
    end
    h.glidingToTarget = false
    return true
end
tweenGlide=function(tweenDestArg,tweenSpeedArg,tweenEggArg,tweenModeArg,...)
    local tweenChar=LocalPlayer.Character
    local tweenCharRoot=tweenChar and tweenChar:FindFirstChild( "HumanoidRootPart" )
    if tweenCharRoot then
        local tweenStartX=tweenCharRoot.Position.X
        local tweenDestX=tweenDestArg.Position.X
        if tweenStartX<= 535 and tweenDestX> 510 then
            local tweenFallbackCf=CFrame.new ( 500 , 70 , -364 )
            local tweenFallbackDist=((tweenCharRoot.Position -tweenFallbackCf.Position )).Magnitude
            if tweenFallbackDist> 5 then
                h.statusText = "[AutoSteal] Exiting Base -> Waypoint (500, 70, -364)..." Log(string.format ( "[AutoSteal] Leaving base (X=%.1f): Gliding to waypoint (500, 70, -364) first (dist=%.1f studs)..." ,tweenStartX,tweenFallbackDist))
                local tweenFlyResult=flyToPos(tweenFallbackCf,tweenSpeedArg,tweenEggArg,tweenModeArg)
                if not tweenFlyResult then
                    return false
                end
                task.wait ( 0.04 )
            end
        end
    end
    return flyToPos(tweenDestArg,tweenSpeedArg,tweenEggArg,tweenModeArg)
end
returnHome=function(homeSpeedArg,homeFlagArg,...)
    local retChar=LocalPlayer.Character
    local retCharRoot=retChar and retChar:FindFirstChild( "HumanoidRootPart" )
    local homeHumanoid=retChar and retChar:FindFirstChildOfClass( "Humanoid" )
    if not retCharRoot then
        return false
    end
    if homeHumanoid then
        homeHumanoid.AutoRotate = false
    end
    local homeLaneZ=h.laneZ or corridorZ
    local homeSafePos=Vector3.new (safeLineX- 10 , 70 ,homeLaneZ)homeSpeedArg=math.max ( 100 ,homeSpeedArg or h.glideSpeed or 350 )h.isReturning = true h.stateTime =os.clock ()spawnSafetyFloor(Vector3.new (safeLineX, 70 ,homeLaneZ), 20 )pcall(unequipAllTools)retCharRoot.AssemblyLinearVelocity =Vector3.zero retCharRoot.AssemblyAngularVelocity =Vector3.zero
    local homeGlideSpeed=getEggGlideSpeed()
    local homeMaxSpeed=math.max (homeSpeedArg,homeGlideSpeed)
    local homeDeadline=os.clock ()+ 15
    while h.alive and(h.isReturning and os.clock ()<homeDeadline)do
        if homeFlagArg and sessionSwitchId~=homeFlagArg then
            Warn( "[Return] Aborted by session switch!" )
            if homeHumanoid then
                homeHumanoid.AutoRotate = true
            end
            h.isReturning = false
            return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop then
            Warn( "[Return] Aborted (all farms disabled)" )
            if homeHumanoid then
                homeHumanoid.AutoRotate = true
            end
            h.isReturning = false
            return false
        end
        local safelinePos=retCharRoot.Position
        local safelineDist=((homeSafePos-safelinePos)).Magnitude
        if safelinePos.X <=(safeLineX+ 10 )or safelineDist<= 6 then
            unequipAllTools()
            break
        end
        if retChar then
            for homeChildIdx,homeChild in ipairs(retChar:GetChildren())do
                if homeChild:IsA( "Tool" )then
                    pcall(unequipAllTools)
                    break
                end
            end
        end
        local safelineWatchConn=RunService.Heartbeat :Wait()safelinePos=retCharRoot.Position
        local homeCurSpeed=homeMaxSpeed
        if safelinePos.X <=returnX and safelinePos.X >safeLineX then
            local homeFrac=math.clamp (((safelinePos.X -safeLineX))/((returnX-safeLineX)), 0 , 1 )homeCurSpeed=returnDistMul+(((homeMaxSpeed-returnDistMul))*homeFrac)
        elseif safelinePos.X <=safeLineX then
            homeCurSpeed=returnDistMul
        end
        local homeDirX=math.sign (homeSafePos.X -safelinePos.X )
        local homeStepX=homeDirX*math.min (math.abs (homeSafePos.X -safelinePos.X ),homeCurSpeed*safelineWatchConn)
        local homeNewX=safelinePos.X +homeStepX
        local homeDirY=math.sign (homeSafePos.Y -safelinePos.Y )
        local homeStepY=homeDirY*math.min (math.abs (homeSafePos.Y -safelinePos.Y ),(homeCurSpeed*safelineWatchConn)* 0.5 )
        local homeNewY=safelinePos.Y +homeStepY
        local homeDiffZ=homeLaneZ-safelinePos.Z
        local homeStepZ=math.sign (homeDiffZ)*math.min (math.abs (homeDiffZ),homeCurSpeed*safelineWatchConn)
        local homeNewZ=safelinePos.Z +homeStepZ
        local homeHatchAll=hatchAllEggs()
        local homeNearHatched= false
        for homeHatchIdx,homeHatchRec in ipairs(homeHatchAll)do
            local homeHatchPos=homeHatchRec.Position
            local homeHatchDist=((Vector3.new (homeNewX,homeNewY,homeNewZ)-homeHatchPos)).Magnitude
            local homeHatchDx=math.abs (homeNewX-homeHatchPos.X )
            local homeHatchDz=math.abs (homeNewZ-homeHatchPos.Z )
            if homeHatchDist< 22 or(homeHatchDx< 18 and homeHatchDz< 14 )then
                homeNearHatched= true
                local homeHatchLiftY=homeHatchPos.Y + 16
                if homeNewY<homeHatchLiftY then
                    homeNewY=math.min (homeNewY+((homeCurSpeed*safelineWatchConn)* 1.5 ),homeHatchLiftY)
                end
                break
            end
        end
        local homeTargetPos=Vector3.new (homeNewX,homeNewY,homeNewZ)
        local homeLookVec=((homeTargetPos-safelinePos)).Magnitude > 0.05 and((homeTargetPos-safelinePos)).Unit or retCharRoot.CFrame.LookVector retCharRoot.CFrame =CFrame.lookAt (homeTargetPos,homeTargetPos+homeLookVec)retCharRoot.AssemblyLinearVelocity =Vector3.zero retCharRoot.AssemblyAngularVelocity =Vector3.zero
        if homeNearHatched then
            h.statusText =string.format ( "Tweening Safe Line (Z: %.0f) [DODGING!]" ,homeNewZ)
        else
            h.statusText =string.format ( "Tweening to Safe Line (%.0f studs | X: %.0f)" ,safelineDist,safelinePos.X )
        end
    end
    retCharRoot.CFrame =CFrame.new (safeLineX,math.max ( 68 ,retCharRoot.Position.Y ),homeLaneZ)retCharRoot.AssemblyLinearVelocity =Vector3.zero retCharRoot.AssemblyAngularVelocity =Vector3.zero
    if homeHumanoid then
        homeHumanoid.AutoRotate = true
    end
    unequipAllTools()h.isReturning = false h.delivering = false
    if h then
        h.onTreadmill = false
    end
    h.statusText = "Arrived at Safe Line (X=525)! Hands Free."
    return true
end
local function findPlotTread(treadFindPlotArg,...)
    if not treadFindPlotArg then
        return nil
    end
    local treadFindBottom=treadFindPlotArg:FindFirstChild( "TreadmillBottom" )
    if treadFindBottom and treadFindBottom:IsA( "BasePart" )then
        return treadFindBottom
    end
    treadFindBottom=treadFindPlotArg:FindFirstChild( "TreadmillBottom" , true )
    if treadFindBottom and treadFindBottom:IsA( "BasePart" )then
        return treadFindBottom
    end
    local treadFindUpgrade=treadFindPlotArg:FindFirstChild( "TreadmillUpgrade" , true )
    if treadFindUpgrade then
        for treadFindNameIdx,treadFindName in ipairs({ "TreadmillBottom" , "Belt" , "RunArea" ;
            "Run" ;
            "Platform" ;
            "Pad" , "Floor" ;
            "Base" })do
            local treadFindChild=treadFindUpgrade:FindFirstChild(treadFindName, true )
            if treadFindChild and treadFindChild:IsA( "BasePart" )then
                return treadFindChild
            end
        end
        local treadFindBestPart=nil
        local treadFindBestDist= 999999
        for treadFindDescIdx,treadFindDesc in ipairs(treadFindUpgrade:GetDescendants())do
            if treadFindDesc:IsA( "BasePart" )and(treadFindDesc.Size.X >= 1.2 and treadFindDesc.Size.Z >= 1.2 )then
                if treadFindDesc.Position.Y <treadFindBestDist then
                    treadFindBestDist=treadFindDesc.Position.Y treadFindBestPart=treadFindDesc
                end
            end
        end
        if treadFindBestPart then
            return treadFindBestPart
        end
        if treadFindUpgrade.PrimaryPart then
            return treadFindUpgrade.PrimaryPart
        end
        local treadFindBase=treadFindUpgrade:FindFirstChildWhichIsA( "BasePart" , true )
        if treadFindBase then
            return treadFindBase
        end
    end
    for treadFindScanIdx,treadFindScanDesc in ipairs(treadFindPlotArg:GetDescendants())do
        if treadFindScanDesc:IsA( "BasePart" )and string.find (string.lower (treadFindScanDesc.Name ), "treadmill" )then
            return treadFindScanDesc
        end
    end
    return nil
end
findTreadmillEntry=function(...)
    local treadMountList=mountTreadmill()
    if h.tread and h.tread.Parent then
        return h.tread
    end
    local treadMountUpgrade=nil
    if treadMountList then
        treadMountUpgrade=findPlotTread(treadMountList)
    end
    if not treadMountUpgrade then
        local treadPlotsScan=Workspace:FindFirstChild( "Plots" )
        if treadPlotsScan then
            local treadMyNameLower=string.lower (LocalPlayer.Name )
            local treadMyDisplayLower=LocalPlayer.DisplayName and string.lower (LocalPlayer.DisplayName )
            for treadScanPlotIdx,treadScanPlot in ipairs(treadPlotsScan:GetChildren())do
                local treadScanUpgrade=findPlotTread(treadScanPlot)
                if treadScanUpgrade then
                    local treadScanFound= false
                    for treadScanDescIdx,treadScanDesc in ipairs(treadScanPlot:GetDescendants())do
                        if treadScanDesc:IsA( "TextLabel" )and treadScanDesc.Text ~= "" then
                            local treadScanTextLower=string.lower (treadScanDesc.Text )
                            if string.find (treadScanTextLower,treadMyNameLower, 1 , true )or(treadMyDisplayLower and string.find (treadScanTextLower,treadMyDisplayLower, 1 , true ))then
                                treadScanFound= true
                                break
                            end
                        end
                    end
                    if treadScanFound then
                        h.plot =treadScanPlot h.plotVerified = true treadMountUpgrade=treadScanUpgrade
                        break
                    end
                end
            end
            if not treadMountUpgrade and treadMountList then
                treadMountUpgrade=findPlotTread(treadMountList)
            end
        end
    end
    h.tread =treadMountUpgrade
    return treadMountUpgrade
end
treadmillFarmLoop=function(retCharD,...)
    local retCharFull=LocalPlayer.Character
    local charRootRet=retCharFull and retCharFull:FindFirstChild( "HumanoidRootPart" )
    local retCharHumanoid=retCharFull and retCharFull:FindFirstChildOfClass( "Humanoid" )
    if not charRootRet or not retCharHumanoid then
        return false
    end
    if retCharHumanoid.PlatformStand then
        retCharHumanoid.PlatformStand = false
    end
    if retCharHumanoid.Sit then
        retCharHumanoid.Sit = false
    end
    retCharHumanoid:ChangeState(Enum.HumanoidStateType.Running )
    local retTreadList=mountTreadmill()
    local entryInfo=findTreadmillEntry()
    if not entryInfo then
        Warn( "[AutoTreadmill] Treadmill part not found! Retrying next loop..." )
        return false
    end
    pcall(function(...)
        for retChildIdx,retChild in ipairs(retCharFull:GetChildren())do
            if retChild:IsA( "BasePart" )and retChild.Name ~= "HumanoidRootPart" then
                retChild.CanCollide = false
            end
        end
    end
    )pcall(function(...) entryInfo.CanTouch = true entryInfo.CanCollide = true
        local retTreadUpgrade=retTreadList and retTreadList:FindFirstChild( "TreadmillUpgrade" , true )
        if retTreadUpgrade then
            for retUpgDescIdx,retUpgDesc in ipairs(retTreadUpgrade:GetDescendants())do
                if retUpgDesc:IsA( "BasePart" )then
                    retUpgDesc.CanTouch = true retUpgDesc.CanCollide = true
                end
            end
        end
        if entryInfo.Parent and entryInfo.Parent :IsA( "Model" )then
            for retEntDescIdx,retEntDesc in ipairs(entryInfo.Parent :GetDescendants())do
                if retEntDesc:IsA( "BasePart" )then
                    retEntDesc.CanTouch = true retEntDesc.CanCollide = true
                end
            end
        end
    end
    )
    local entryPos=entryInfo.Position +Vector3.new ( 0 , 1.8 , 0 )
    if charRootRet.Position.X > 535 then
        h.statusText = "[AutoTreadmill] Returning along highway to base..." returnHome(h.glideSpeed ,retCharD)
        if retCharD and sessionSwitchId~=retCharD then
            return false
        end
        if charRootRet.Position.X > 535 then
            if charRootRet.Position.X <= 560 then
                charRootRet.CFrame =CFrame.new (safeLineX, 70 ,h.laneZ or corridorZ)
            else
                return false
            end
        end
    end
    if retCharD and sessionSwitchId~=retCharD then
        return false
    end
    local retXzDist=((Vector2.new (charRootRet.Position.X ,charRootRet.Position.Z )-Vector2.new (entryPos.X ,entryPos.Z ))).Magnitude
    if retXzDist> 4 then
        h.statusText = "[AutoTreadmill] Elevated flyover to base plot..."
        local retFlySpeed=math.max ( 250 ,h.glideSpeed or 400 )
        local retFlyClock=os.clock ()
        while h.alive and(((Vector2.new (charRootRet.Position.X ,charRootRet.Position.Z )-Vector2.new (entryPos.X ,entryPos.Z ))).Magnitude > 4 and(os.clock ()-retFlyClock< 4 ))do
            if retCharD and sessionSwitchId~=retCharD then
                return false
            end
            local retHbWait=RunService.Heartbeat :Wait()
            local retHbPos=charRootRet.Position
            local retHbGoal=Vector3.new (entryPos.X , 70 ,entryPos.Z )
            local retHbDelta=(retHbGoal-retHbPos)
            local retHbStep=retHbDelta.Unit *math.min (retHbDelta.Magnitude ,retFlySpeed*retHbWait)
            local retHbNewPos=retHbPos+retHbStep charRootRet.CFrame =CFrame.lookAt (retHbNewPos,retHbNewPos+((retHbDelta.Magnitude > 0.05 and retHbDelta.Unit or charRootRet.CFrame.LookVector )))charRootRet.AssemblyLinearVelocity =Vector3.zero charRootRet.AssemblyAngularVelocity =Vector3.zero
            if retCharHumanoid then
                if retCharHumanoid.PlatformStand then
                    retCharHumanoid.PlatformStand = false
                end
                if retCharHumanoid.Sit then
                    retCharHumanoid.Sit = false
                end
                retCharHumanoid:ChangeState(Enum.HumanoidStateType.Running )
            end
        end
    end
    if retCharD and sessionSwitchId~=retCharD then
        return false
    end
    local retClimbClock=os.clock ()
    while h.alive and(math.abs (charRootRet.Position.Y -entryPos.Y )> 2 and(os.clock ()-retClimbClock< 1.5 ))do
        if retCharD and sessionSwitchId~=retCharD then
            return false
        end
        local retClimbWait=RunService.Heartbeat :Wait()
        local retClimbPos=charRootRet.Position
        local retClimbGoal=entryPos
        local retClimbDelta=(retClimbGoal-retClimbPos)
        local retClimbStep=retClimbDelta.Unit *math.min (retClimbDelta.Magnitude , 150 *retClimbWait)
        local retClimbNewPos=retClimbPos+retClimbStep charRootRet.CFrame =CFrame.new (retClimbNewPos)charRootRet.AssemblyLinearVelocity =Vector3.zero charRootRet.AssemblyAngularVelocity =Vector3.zero
    end
    charRootRet.CFrame =CFrame.new (entryPos)charRootRet.AssemblyLinearVelocity =Vector3.zero charRootRet.AssemblyAngularVelocity =Vector3.zero
    local retFinalDist=((charRootRet.Position -entryPos)).Magnitude
    if retFinalDist<= 6 then
        pcall(function(...)
            if typeof(firetouchinterest)== "function" then
                firetouchinterest(charRootRet,entryInfo, 0 )task.wait ( 0.02 )firetouchinterest(charRootRet,entryInfo, 1 )
            end
        end
        )pcall(function(...)
            for retEntDesc2Idx,retEntDesc2 in ipairs(entryInfo:GetDescendants())do
                if retEntDesc2:IsA( "ProximityPrompt" )and retEntDesc2.Enabled then
                    if typeof(fireproximityprompt)== "function" then
                        fireproximityprompt(retEntDesc2)
                    end
                end
            end
            if entryInfo.Parent then
                for retEntDesc3Idx,retEntDesc3 in ipairs(entryInfo.Parent :GetDescendants())do
                    if retEntDesc3:IsA( "ProximityPrompt" )and retEntDesc3.Enabled then
                        if typeof(fireproximityprompt)== "function" then
                            fireproximityprompt(retEntDesc3)
                        end
                    end
                end
            end
        end
        )
        if AskTreadmillDon then
            pcall(function(...) AskTreadmillDon:InvokeServer()
            end
            )
        end
        h.onTreadmill = true h.lastTreadmillMount =os.clock ()h.statusText = "[AutoTreadmill] Running on treadmill (Waiting for eggs...)"
        return true
    else
        h.onTreadmill = false Warn(string.format ( "[AutoTreadmill] Not yet at treadmill pad (dist=%.1f studs). Will retry!" ,retFinalDist))
        return false
    end
end
local function hideMoneyUi(...)
    if not h or not h.hideNotEnoughMoney then
        return
    end
    local findFundGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    if not findFundGui then
        return
    end
    pcall(function(...)
        for findFundDescIdx,findFundDesc in ipairs(findFundGui:GetDescendants())do
            if findFundDesc:IsA( "TextLabel" )and findFundDesc.Visible then
                local findFundText=(tostring(findFundDesc.Text or "" )):lower()
                if findFundText:find( "not enough money" )or findFundText:find( "not enough cash" )or(findFundText:find( "not enough" )and((findFundText:find( "money" )or findFundText:find( "cash" )or findFundText:find( "coin" )or findFundText:find( "fund" ))))then
                    findFundDesc.Visible = false findFundDesc.TextTransparency = 1 findFundDesc.TextStrokeTransparency = 1
                    local findFundParent=findFundDesc.Parent
                    if findFundParent and(((findFundParent:IsA( "Frame" )or findFundParent:IsA( "CanvasGroup" )))and#findFundParent:GetChildren()<= 3 )then
                        findFundParent.Visible = false
                    end
                end
            end
        end
    end
    )
end
local function watchMoneyUi(...)
    local fundScanGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    if not fundScanGui then
        return
    end
    local function hideMoneyLabel(fundLabel,...)
        if fundLabel:IsA( "TextLabel" )then
            local function fundScanTick(...)
                if not h or not h.hideNotEnoughMoney then
                    return
                end
                local fundScanText=(tostring(fundLabel.Text or "" )):lower()
                if fundScanText:find( "not enough money" )or fundScanText:find( "not enough cash" )or(fundScanText:find( "not enough" )and((fundScanText:find( "money" )or fundScanText:find( "cash" )or fundScanText:find( "coin" )or fundScanText:find( "fund" ))))then
                    fundLabel.Visible = false fundLabel.TextTransparency = 1 fundLabel.TextStrokeTransparency = 1
                    local fundScanParent=fundLabel.Parent
                    if fundScanParent and(((fundScanParent:IsA( "Frame" )or fundScanParent:IsA( "CanvasGroup" )))and#fundScanParent:GetChildren()<= 3 )then
                        fundScanParent.Visible = false
                    end
                end
            end
            fundScanTick();
            (fundLabel:GetPropertyChangedSignal( "Text" )):Connect(fundScanTick);
            (fundLabel:GetPropertyChangedSignal( "Visible" )):Connect(function(...)
                if fundLabel.Visible then
                    fundScanTick()
                end
            end
            )
        end
    end
    pcall(function(...)
        for fundScanDescIdx,fundScanDesc in ipairs(fundScanGui:GetDescendants())do
            task.spawn (hideMoneyLabel,fundScanDesc)
        end
        fundScanGui.DescendantAdded :Connect(hideMoneyLabel)
    end
    )task.spawn (function(...)
        while h and h.alive do
            if h.hideNotEnoughMoney then
                hideMoneyUi()
            end
            task.wait ( 0.25 )
        end
    end
    )
end
task.spawn (watchMoneyUi)
local function parseMoney(moneyRaw,...)
    if not moneyRaw then
        return 0
    end
    local moneyClean=(((tostring(moneyRaw)):gsub( "[$,]" , "" )):gsub( "%s+" , "" )):lower()
    local moneyMatch=moneyClean:match( "[%d%.]+" )
    if not moneyMatch then
        return 0
    end
    local moneyNum2=tonumber(moneyMatch)
    if not moneyNum2 then
        return 0
    end
    if moneyClean:find( "sp" )then
        return moneyNum2* 999999999999999983222784
    elseif moneyClean:find( "sx" )then
        return moneyNum2* 1000000000000000000000
    elseif moneyClean:find( "qi" )then
        return moneyNum2* 1000000000000000000
    elseif moneyClean:find( "qa" )or moneyClean:find( "q" )then
        return moneyNum2* 1000000000000000
    elseif moneyClean:find( "t" )then
        return moneyNum2* 1000000000000
    elseif moneyClean:find( "b" )then
        return moneyNum2* 1000000000
    elseif moneyClean:find( "m" )then
        return moneyNum2* 1000000
    elseif moneyClean:find( "k" )then
        return moneyNum2* 1000
    end
    return moneyNum2
end
local function getBalance(...)
    local mStats=LocalPlayer:FindFirstChild( "leaderstats" )
    if mStats then
        for mStatIdx,mStatName in ipairs({ "Money" , "Cash" , "Coins" ;
            "Currency" })do
            local mStatChild=mStats:FindFirstChild(mStatName)
            if mStatChild then
                local mStatValue=tonumber(mStatChild.Value )or parseMoney(mStatChild.Value )
                if mStatValue and mStatValue> 0 then
                    return mStatValue
                end
            end
        end
    end
    local mPlayerGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    if mPlayerGui then
        local mHudRoot=mPlayerGui:FindFirstChild( "HUD" )or mPlayerGui:FindFirstChild( "GameHUD" )or mPlayerGui:FindFirstChild( "MainHUD" )or mPlayerGui:FindFirstChild( "Main" )
        if mHudRoot then
            for mHudDescIdx,mHudDesc in ipairs(mHudRoot:GetDescendants())do
                if mHudDesc:IsA( "TextLabel" )and mHudDesc.Visible then
                    local mHudNameLower=mHudDesc.Name :lower()
                    if mHudNameLower== "money" or mHudNameLower== "cash" or mHudNameLower== "coins" or mHudNameLower== "currency" or mHudNameLower== "value" then
                        local mHudMoney=parseMoney(mHudDesc.Text )
                        if mHudMoney and mHudMoney> 0 then
                            return mHudMoney
                        end
                    end
                end
            end
        end
    end
    return 0
end
local function getUpgradePrice(...)
    local tUpgPlot=h.plot or(mountTreadmill and mountTreadmill())
    if not tUpgPlot then
        return nil
    end
    local tUpgFind=tUpgPlot:FindFirstChild( "TreadmillUpgrade" , true )
    if not tUpgFind then
        return nil
    end
    local tUpgOk=nil
    for tUpgDescIdx,tUpgDesc in ipairs(tUpgFind:GetDescendants())do
        if tUpgDesc:IsA( "TextLabel" )or tUpgDesc:IsA( "TextButton" )then
            local tUpgText=tostring(tUpgDesc.Text or "" )
            local tUpgMatch=tUpgText:match( "%$([%d%.,]+%s*[kKmMbBtTqQ]?[aA]?)" )
            if tUpgMatch then
                local tUpgMoney=parseMoney(tUpgMatch)
                if tUpgMoney and tUpgMoney> 0 then
                    if not tUpgOk or tUpgMoney>tUpgOk then
                        tUpgOk=tUpgMoney
                    end
                end
            end
        end
    end
    return tUpgOk
end
local lastUpgradeAt= 0
local upgradeCooldown= 10
local function autoUpgradeTread(...)
    if not h.autoUpgradeTreadmill then
        return
    end
    if os.clock ()-lastUpgradeAt<upgradeCooldown then
        return
    end
    local tUrPlot=h.plot or(mountTreadmill and mountTreadmill())
    if not tUrPlot then
        return
    end
    local tUrFind=tUrPlot:FindFirstChild( "TreadmillUpgrade" , true )
    if not tUrFind then
        return
    end
    local tUrBalance=getBalance()
    local tUrPrice=getUpgradePrice()
    if tUrPrice and(tUrPrice> 0 and tUrBalance<tUrPrice)then
        return
    end
    lastUpgradeAt=os.clock ()
    if AskTreadmillUpgrade then
        pcall(function(...) AskTreadmillUpgrade:InvokeServer()
        end
        )
    end
    local tUrChar=LocalPlayer.Character
    local tUrRoot=tUrChar and tUrChar:FindFirstChild( "HumanoidRootPart" )pcall(function(...)
        for tUrPromptIdx,promptLive in ipairs(tUrFind:GetDescendants())do
            if promptLive:IsA( "ProximityPrompt" )and promptLive.Enabled then
                if typeof(fireproximityprompt)== "function" then
                    fireproximityprompt(promptLive, 0 )fireproximityprompt(promptLive)
                end
            end
            if promptLive:IsA( "GuiButton" )and promptLive.Visible then
                local tUrPromptText=(promptLive:IsA( "TextButton" )and promptLive.Text )or promptLive.Name
                local tUrPromptTextLower=string.lower (tUrPromptText)
                if not string.find (tUrPromptTextLower, "robux" )and(not string.find (tUrPromptTextLower, "r%$" )and((string.find (tUrPromptTextLower, "%$" )or string.find (tUrPromptTextLower, "upgrade" )or string.find (tUrPromptTextLower, "cash" )or(promptLive.BackgroundColor3 and promptLive.BackgroundColor3.G >promptLive.BackgroundColor3.R ))))then
                    if typeof(firesignal)== "function" and promptLive.Activated then
                        firesignal(promptLive.Activated )
                    elseif typeof(firesignal)== "function" and promptLive.MouseButton1Click then
                        firesignal(promptLive.MouseButton1Click )
                    end
                end
            end
            if promptLive:IsA( "BasePart" )and(promptLive.Name :find( "Pad" )and tUrRoot)then
                if((tUrRoot.Position -promptLive.Position )).Magnitude < 10 then
                    if typeof(firetouchinterest)== "function" then
                        firetouchinterest(tUrRoot,promptLive, 0 )task.wait ( 0.02 )firetouchinterest(tUrRoot,promptLive, 1 )
                    end
                end
            end
        end
    end
    )
end
local trailList={{[ "id" ]= "GreyTrail" ,[ "base" ]= "Grey" ,[ "name" ]= "Grey Trail" ;
[ "price" ]= 100 ;
[ "mult" ]= 1.5 },{[ "id" ]= "GreenTrail" ;
[ "base" ]= "Green" ,[ "name" ]= "Green Trail" ;
[ "price" ]= 5000 ;
[ "mult" ]= 2 },{[ "id" ]= "BlueTrail" ,[ "base" ]= "Blue" ;
[ "name" ]= "Blue Trail" ;
[ "price" ]= 75000 ;
[ "mult" ]= 2.5 };
{[ "id" ]= "PurpleTrail" ,[ "base" ]= "Purple" ;
[ "name" ]= "Purple Trail" ;
[ "price" ]= 1500000 ;
[ "mult" ]= 3 },{[ "id" ]= "GoldenTrail" ,[ "base" ]= "Golden" ;
[ "name" ]= "Golden Trail" ;
[ "price" ]= 1500000 ;
[ "mult" ]= 3.5 };
{[ "id" ]= "RedTrail" ;
[ "base" ]= "Red" ,[ "name" ]= "Red Trail" ;
[ "price" ]= 750000000 ,[ "mult" ]= 4 },{[ "id" ]= "GalaxyTrail" ,[ "base" ]= "Galaxy" ,[ "name" ]= "Galaxy Trail" ;
[ "price" ]= 20000000000 ,[ "mult" ]= 5 },{[ "id" ]= "SecretTrail" ;
[ "base" ]= "Secret" ;
[ "name" ]= "Secret Trail" ,[ "price" ]= 500000000000 ,[ "mult" ]= 6 };
{[ "id" ]= "EternalTrail" ;
[ "base" ]= "Eternal" ,[ "name" ]= "Eternal Trail" ,[ "price" ]= 12500000000000 ;
[ "mult" ]= 10 };
{[ "id" ]= "DivineTrail" ,[ "base" ]= "Divine" ;
[ "name" ]= "Divine Trail" ,[ "price" ]= 300000000000000 ;
[ "mult" ]= 14 };
{[ "id" ]= "MoonbloomTrail" ,[ "base" ]= "Moonbloom" ;
[ "name" ]= "Moonbloom Trail" ,[ "price" ]= 5000000000000000 ,[ "mult" ]= 20 }}
local function getTrailCatalog(...)
    return trailList
end
local function scanTrailShop(...)
    local ownedTrailKeys={}
    local ownedTrailGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    local ownedTrailShop=ownedTrailGui and((ownedTrailGui:FindFirstChild( "TrailShop" )or ownedTrailGui:FindFirstChild( "TrailShop" , true )))
    local ownedTrailScroll=ownedTrailShop and ownedTrailShop:FindFirstChild( "ScrollingFrame" , true )
    if ownedTrailScroll then
        pcall(function(...)
            for ownedTrailRowIdx,ownedTrailRow in ipairs(ownedTrailScroll:GetChildren())do
                if ownedTrailRow:IsA( "GuiObject" )and(not ownedTrailRow:IsA( "UIListLayout" )and not ownedTrailRow:IsA( "UIPadding" ))then
                    local ownedTrailRowName=ownedTrailRow.Name
                    for ownedTrailDescIdx,ownedTrailDesc in ipairs(ownedTrailRow:GetDescendants())do
                        if ownedTrailDesc:IsA( "GuiButton" )or ownedTrailDesc:IsA( "TextButton" )then
                            local ownedTrailTextLower=(ownedTrailDesc:IsA( "TextButton" )and ownedTrailDesc.Text :lower())or ownedTrailDesc.Name :lower()
                            if ownedTrailTextLower:find( "unequip" )or(ownedTrailTextLower:find( "equip" )and not ownedTrailTextLower:find( "unequip" ))then
                                ownedTrailKeys[ownedTrailRowName]= true ownedTrailKeys[ownedTrailRowName:lower()]= true
                                local ownedTrailKey=ownedTrailRowName:gsub( "Trail" , "" )ownedTrailKeys[ownedTrailKey]= true ownedTrailKeys[ownedTrailKey:lower()]= true
                            end
                        end
                    end
                end
            end
        end
        )
    end
    return ownedTrailKeys
end
local function fireBtn(trailDataArg,...)
    if not trailDataArg then
        return false
    end
    pcall(function(...)
        if typeof(firebutton1click)== "function" then
            firebutton1click(trailDataArg)
        elseif typeof(firesignal)== "function" and trailDataArg.Activated then
            firesignal(trailDataArg.Activated )
        elseif typeof(firesignal)== "function" and trailDataArg.MouseButton1Click then
            firesignal(trailDataArg.MouseButton1Click )
        end
    end
    )
    return true
end
local function equipTrail(...)
    local listTrailDefs=getTrailCatalog()
    local listTrailOwned=scanTrailShop()
    local listTrailGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    local listTrailShop=listTrailGui and((listTrailGui:FindFirstChild( "TrailShop" )or listTrailGui:FindFirstChild( "TrailShop" , true )))
    local listTrailScroll=listTrailShop and listTrailShop:FindFirstChild( "ScrollingFrame" , true )
    if listTrailScroll then
        for listTrailIdx=#listTrailDefs, 1 , -1 do
            local listTrailDef=listTrailDefs[listTrailIdx]
            local listTrailRow=listTrailScroll:FindFirstChild(listTrailDef.id )or listTrailScroll:FindFirstChild(listTrailDef.base )or listTrailScroll:FindFirstChild(listTrailDef.name )
            if not listTrailRow then
                for listTrailRowIdx,listTrailRowChild in ipairs(listTrailScroll:GetChildren())do
                    if listTrailRowChild:IsA( "GuiObject" )and((listTrailRowChild.Name :lower()==listTrailDef.id :lower()or listTrailRowChild.Name :lower()==listTrailDef.base :lower()or listTrailRowChild.Name :lower()==listTrailDef.name :lower()))then
                        listTrailRow=listTrailRowChild
                        break
                    end
                end
            end
            if listTrailRow then
                local listTrailFound= false
                local listTrailOwnerRec=nil
                for listTrailDescIdx,listTrailDesc in ipairs(listTrailRow:GetDescendants())do
                    if listTrailDesc:IsA( "GuiButton" )or listTrailDesc:IsA( "TextButton" )then
                        local listTrailDescText=(listTrailDesc:IsA( "TextButton" )and listTrailDesc.Text :lower())or listTrailDesc.Name :lower()
                        if listTrailDescText:find( "unequip" )then
                            listTrailFound= true
                            break
                        elseif listTrailDescText:find( "equip" )and not listTrailDescText:find( "unequip" )then
                            listTrailOwnerRec=listTrailDesc
                        end
                    end
                end
                if listTrailFound then
                    return true
                end
                if listTrailOwnerRec then
                    fireBtn(listTrailOwnerRec)
                    if AskTrailChoose then
                        pcall(function(...) AskTrailChoose:InvokeServer(listTrailDef.id )
                        end
                        )
                    end
                    task.wait ( 0.2 )
                    return true
                end
            end
        end
    end
    if AskTrailChoose then
        for buyTrailIdx=#listTrailDefs, 1 , -1 do
            local buyTrailDef=listTrailDefs[buyTrailIdx]
            local buyTrailOwned=listTrailOwned[buyTrailDef.id ]or listTrailOwned[buyTrailDef.id :lower()]or listTrailOwned[buyTrailDef.base ]or listTrailOwned[buyTrailDef.base :lower()]or listTrailOwned[buyTrailDef.name ]or listTrailOwned[buyTrailDef.name :lower()]
            if buyTrailOwned then
                pcall(function(...) AskTrailChoose:InvokeServer(buyTrailDef.id )
                end
                )
                return true
            end
        end
    end
    return false
end
local lastTrailBuyTime= 0
local trailBuyCooldown= 8
local function autoBuyTrails(...)
    if not h.autoBuyTrails then
        return
    end
    equipTrail()
    if os.clock ()-lastTrailBuyTime<trailBuyCooldown then
        return
    end
    local shopBalance=getBalance()
    if shopBalance<= 0 then
        return
    end
    local trailCatalog=getTrailCatalog()
    local ownedTrails=scanTrailShop()
    local shopPlayerGui=LocalPlayer:FindFirstChild( "PlayerGui" )
    local trailShopGui=shopPlayerGui and((shopPlayerGui:FindFirstChild( "TrailShop" )or shopPlayerGui:FindFirstChild( "TrailShop" , true )))
    local trailScroller=trailShopGui and trailShopGui:FindFirstChild( "ScrollingFrame" , true )
    for catIdx=#trailCatalog, 1 , -1 do
        local trailItem=trailCatalog[catIdx]
        local ownedRec=ownedTrails[trailItem.id ]or ownedTrails[trailItem.id :lower()]or ownedTrails[trailItem.base ]or ownedTrails[trailItem.base :lower()]or ownedTrails[trailItem.name ]or ownedTrails[trailItem.name :lower()]
        if not ownedRec and(trailItem.price > 0 and shopBalance>=trailItem.price )then
            lastTrailBuyTime=os.clock ()
            local boughtNow= false
            if trailScroller then
                local existingBtn=trailScroller:FindFirstChild(trailItem.id )or trailScroller:FindFirstChild(trailItem.base )or trailScroller:FindFirstChild(trailItem.name )
                if not existingBtn then
                    for guiChildIdx,guiChild in ipairs(trailScroller:GetChildren())do
                        if guiChild:IsA( "GuiObject" )and((guiChild.Name :lower()==trailItem.id :lower()or guiChild.Name :lower()==trailItem.base :lower()or guiChild.Name :lower()==trailItem.name :lower()))then
                            existingBtn=guiChild
                            break
                        end
                    end
                end
                if existingBtn then
                    for btnMatchDescIdx,btnMatchDesc in ipairs(existingBtn:GetDescendants())do
                        if btnMatchDesc:IsA( "GuiButton" )or btnMatchDesc:IsA( "TextButton" )then
                            local btnMatchText=(btnMatchDesc:IsA( "TextButton" )and btnMatchDesc.Text :lower())or btnMatchDesc.Name :lower()
                            if not btnMatchText:find( "robux" )and(not btnMatchText:find( "r%$" )and(not btnMatchText:find( "unequip" )and not btnMatchText:find( "equip" )))then
                                if btnMatchText:find( "%$" )or btnMatchText:find( "buy" )then
                                    fireBtn(btnMatchDesc)boughtNow= true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if AskTrailPurchase then
                pcall(function(...) AskTrailPurchase:InvokeServer(trailItem.id )
                end
                )boughtNow= true
            end
            if boughtNow then
                task.wait ( 0.3 )equipTrail()
                break
            end
        end
    end
end
findLakeEgg=function(...)
    local lakeChar=LocalPlayer.Character
    local lakeCharRoot=lakeChar and lakeChar:FindFirstChild( "HumanoidRootPart" )
    if not lakeCharRoot then
        return nil
    end
    local lakeCandidates={}
    local lakeSlotsClient=Workspace:FindFirstChild( "AreaEggSlotsClient" )
    local lakeSlotsList=getEggSlots( false )
    if lakeSlotsList and#lakeSlotsList> 0 then
        for lakeSlotIdx,lakeSlotRec in ipairs(lakeSlotsList)do
            local lakeSlotPlayable=(lakeSlotRec.State == "Slot" or lakeSlotRec.State == "Dropped" or lakeSlotRec.State == 1 )
            local lakeSlotAreaChk=(lakeSlotRec.AreaId == "Lake" )or(string.find (string.lower (tostring(lakeSlotRec.AreaId )), "lake" )~=nil)or(string.find (string.lower (tostring(lakeSlotRec.Uid )), "lake" )~=nil)
            local lakeSlotCooldown=eggCooldownMap[lakeSlotRec.Uid ]and(os.clock ()<eggCooldownMap[lakeSlotRec.Uid ])
            if lakeSlotPlayable and(lakeSlotAreaChk and(lakeSlotRec.BoundsCFrame and not lakeSlotCooldown))then
                local lakeSlotPos=lakeSlotRec.BoundsCFrame.Position
                local lakeSlotDist=((lakeCharRoot.Position -lakeSlotPos)).Magnitude table.insert (lakeCandidates,{[ "Uid" ]=lakeSlotRec.Uid ;
                [ "Model" ]=nil;
                [ "Hitbox" ]=nil;
                [ "CFrame" ]=lakeSlotRec.BoundsCFrame ,[ "Position" ]=lakeSlotPos,[ "Distance" ]=lakeSlotDist;
                [ "Area" ]= "Lake" })
            end
        end
    end
    if#lakeCandidates== 0 and(lakeSlotsList and#lakeSlotsList> 0 )then
        for eggSlotIdx2,eggSlotRec2 in ipairs(lakeSlotsList)do
            local eggSlotPlayable2=(eggSlotRec2.State == "Slot" or eggSlotRec2.State == "Dropped" or eggSlotRec2.State == 1 )
            local eggSlotCF2=eggSlotRec2.BoundsCFrame and eggSlotRec2.BoundsCFrame.Position
            local lakeSlotXRange=eggSlotCF2 and((eggSlotCF2.X >= 545 and eggSlotCF2.X < 850 ))
            local lakeSlotCdChk=eggCooldownMap[eggSlotRec2.Uid ]and(os.clock ()<eggCooldownMap[eggSlotRec2.Uid ])
            if eggSlotPlayable2 and(lakeSlotXRange and not lakeSlotCdChk)then
                table.insert (lakeCandidates,{[ "Uid" ]=eggSlotRec2.Uid ,[ "Model" ]=nil;
                [ "Hitbox" ]=nil;
                [ "CFrame" ]=eggSlotRec2.BoundsCFrame ;
                [ "Position" ]=eggSlotCF2;
                [ "Distance" ]=((lakeCharRoot.Position -eggSlotCF2)).Magnitude ;
                [ "Area" ]=eggSlotRec2.AreaId or "Field" })
            end
        end
    end
    if#lakeCandidates== 0 then
        return nil
    end
    table.sort (lakeCandidates,function(lakeSortA,lakeSortB,...)
        return lakeSortA.Distance <lakeSortB.Distance
    end
    )
    local lakeBest=lakeCandidates[ 1 ]
    if lakeBest and lakeSlotsClient then
        for lakeClientChildIdx,lakeClientChild in ipairs(lakeSlotsClient:GetChildren())do
            local lakeClientPart=lakeClientChild:FindFirstChildWhichIsA( "BasePart" )or lakeClientChild.PrimaryPart
            if lakeClientPart and((lakeClientPart.Position -lakeBest.Position )).Magnitude <= 8 then
                lakeBest.Model =lakeClientChild
                break
            end
        end
    end
    return lakeBest
end
local guardAreaObjects=nil
local guardAreaCF=nil
local guardRadius= 350
local function findGuardArea(...)
    local guardObjects=Workspace:FindFirstChild( "__OBJECTS" )or Workspace:FindFirstChild( "Objects" )
    local guardAreasFolder=guardObjects and((guardObjects:FindFirstChild( "Areas" )or guardObjects:FindFirstChild( "Area" )))
    local guardGuardGap=guardAreasFolder and((guardAreasFolder:FindFirstChild( "GuardAreas" )or guardAreasFolder:FindFirstChild( "Guards" )))
    if guardGuardGap then
        local guardLightDark=guardGuardGap:FindFirstChild( "Light Dark" )or guardGuardGap:FindFirstChild( "LightDark" )or guardGuardGap:FindFirstChild( "Light_Dark" )or guardGuardGap:FindFirstChild( "Light-Dark" )
        if guardLightDark then
            return guardLightDark
        end
        for guardGapIdx,guardGapArea in ipairs(guardGuardGap:GetChildren())do
            local guardGapNameLower=string.lower (guardGapArea.Name )
            if string.find (guardGapNameLower, "light" )and string.find (guardGapNameLower, "dark" )then
                return guardGapArea
            end
        end
    end
    if guardAreasFolder then
        local areasLightDark=guardAreasFolder:FindFirstChild( "Light Dark" )or guardAreasFolder:FindFirstChild( "LightDark" )or guardAreasFolder:FindFirstChild( "Light_Dark" )
        if areasLightDark then
            return areasLightDark
        end
        for areasIdx,areasObj in ipairs(guardAreasFolder:GetChildren())do
            local areasNameLower=string.lower (areasObj.Name )
            if string.find (areasNameLower, "light" )and string.find (areasNameLower, "dark" )then
                return areasObj
            end
        end
    end
    for wsAreaIdx,wsAreaObj in ipairs(Workspace:GetChildren())do
        local wsAreaName=wsAreaObj.Name
        if wsAreaName== "__OBJECTS" or wsAreaName== "Objects" or wsAreaName== "Areas" or wsAreaName== "Map" then
            for wsAreaDescIdx,wsAreaDesc in ipairs(wsAreaObj:GetDescendants())do
                local wsAreaDescLower=string.lower (wsAreaDesc.Name )
                if(wsAreaDescLower== "light dark" or wsAreaDescLower== "lightdark" or(string.find (wsAreaDescLower, "light" )and string.find (wsAreaDescLower, "dark" )))then
                    if wsAreaDesc:IsA( "BasePart" )or wsAreaDesc:IsA( "Model" )or wsAreaDesc:IsA( "Folder" )then
                        return wsAreaDesc
                    end
                end
            end
        end
    end
    return nil
end
local function isInGuardArea(isInGuardPos,...)
    if not isInGuardPos then
        return false
    end
    if guardAreaObjects then
        local isInGuardDist=((Vector3.new (isInGuardPos.X , 0 ,isInGuardPos.Z )-Vector3.new (guardAreaObjects.X , 0 ,guardAreaObjects.Z ))).Magnitude
        if isInGuardDist<=guardRadius then
            return true
        end
    end
    local isInGuardAreas=findGuardArea()
    if not isInGuardAreas then
        if isInGuardPos.X >= 5200 then
            return true
        end
        return false
    end
    local isInGuardResult= false pcall(function(...)
        local cFrameBox,sizeBox=nil,nil
        if isInGuardAreas:IsA( "BasePart" )then
            cFrameBox=isInGuardAreas.CFrame sizeBox=isInGuardAreas.Size
        elseif isInGuardAreas:IsA( "Model" )then
            cFrameBox,sizeBox=isInGuardAreas:GetBoundingBox()
        else
            local modelObj,modelBounds=nil,nil
            for guardBoxIdx,guardBoxObj in ipairs(isInGuardAreas:GetChildren())do
                if guardBoxObj:IsA( "BasePart" )then
                    local guardBoxCf=guardBoxObj.CFrame
                    local guardBoxHalf=guardBoxObj.Size / 2
                    local guardBoxMin=guardBoxCf.Position -guardBoxHalf
                    local guardBoxMax=guardBoxCf.Position +guardBoxHalf
                    if not modelObj then
                        modelObj=guardBoxMin modelBounds=guardBoxMax
                    else
                        modelObj=Vector3.new (math.min (modelObj.X ,guardBoxMin.X ),math.min (modelObj.Y ,guardBoxMin.Y ),math.min (modelObj.Z ,guardBoxMin.Z ))modelBounds=Vector3.new (math.max (modelBounds.X ,guardBoxMax.X ),math.max (modelBounds.Y ,guardBoxMax.Y ),math.max (modelBounds.Z ,guardBoxMax.Z ))
                    end
                end
            end
            if modelObj and modelBounds then
                cFrameBox=CFrame.new (((modelObj+modelBounds))/ 2 )sizeBox=modelBounds-modelObj
            end
        end
        if cFrameBox and sizeBox then
            guardAreaObjects=cFrameBox.Position guardAreaCF=cFrameBox guardRadius=math.max ( 350 ,math.max (sizeBox.X ,sizeBox.Z )/ 2 + 150 )
            local guardBoxChkDist=((Vector3.new (isInGuardPos.X , 0 ,isInGuardPos.Z )-Vector3.new (cFrameBox.Position.X , 0 ,cFrameBox.Position.Z ))).Magnitude
            if guardBoxChkDist<=guardRadius then
                isInGuardResult= true
                return
            end
            local guardBoxLocal=cFrameBox:PointToObjectSpace(isInGuardPos)
            local guardBoxHalfNow=sizeBox/ 2
            if math.abs (guardBoxLocal.X )<=(guardBoxHalfNow.X + 200 )and math.abs (guardBoxLocal.Z )<=(guardBoxHalfNow.Z + 200 )then
                isInGuardResult= true
                return
            end
        end
        for guardBoxDescIdx,guardBoxDesc in ipairs(isInGuardAreas:GetDescendants())do
            if guardBoxDesc:IsA( "BasePart" )then
                if((isInGuardPos-guardBoxDesc.Position )).Magnitude <= 250 then
                    isInGuardResult= true
                    if not guardAreaObjects then
                        guardAreaObjects=guardBoxDesc.Position
                    end
                    return
                end
            end
        end
    end
    )
    return isInGuardResult
end
local function detectTargetZone(zoneNameArg,guardPartSize,zoneModelArg,...)
    local guardPartX=guardPartSize and guardPartSize.X or 0
    local nameL=string.lower (tostring(zoneNameArg or "" ))
    local targetNameL=string.lower (tostring(zoneModelArg or "" ))
    if targetNameL~= "" and targetNameL~= "egg" then
        if string.find (targetNameL, "spideron" )or string.find (targetNameL, "crustacia" )or string.find (targetNameL, "bladehide" )or string.find (targetNameL, "mantaris" )or string.find (targetNameL, "rhinotaur" )or string.find (targetNameL, "mutantshark" )or string.find (targetNameL, "mutant shark" )or string.find (targetNameL, "gorillaking" )or string.find (targetNameL, "gorilla king" )or string.find (targetNameL, "nightflame" )then
            return "Titan Temple"
        end
        if string.find (targetNameL, "crane" )or string.find (targetNameL, "salamander" )or string.find (targetNameL, "redpanda" )or string.find (targetNameL, "red panda" )or string.find (targetNameL, "snowyowl" )or string.find (targetNameL, "snowy owl" )or string.find (targetNameL, "koiegg" )or string.find (targetNameL, "koi egg" )or string.find (targetNameL, "stagegg" )or string.find (targetNameL, "stag egg" )or string.find (targetNameL, "onitiger" )or string.find (targetNameL, "oni tiger" )or string.find (targetNameL, "kitsune" )then
            return "Cherry Blossom"
        end
        if string.find (targetNameL, "centapede" )or string.find (targetNameL, "cosmicgecko" )or string.find (targetNameL, "cosmic gecko" )or string.find (targetNameL, "cosmicgorilla" )or string.find (targetNameL, "cosmic gorilla" )or string.find (targetNameL, "saturno" )or string.find (targetNameL, "saturnita" )or string.find (targetNameL, "vacca" )or string.find (targetNameL, "cosmic skeleton" )or string.find (targetNameL, "skeletonboss" )or string.find (targetNameL, "skeleton boss" )or string.find (targetNameL, "cosmicdragon" )or string.find (targetNameL, "cosmic dragon" )or string.find (targetNameL, "lunardragon" )or string.find (targetNameL, "lunar dragon" )or string.find (targetNameL, "unicornegg" )or string.find (targetNameL, "unicorn egg" )then
            return "Cosmic"
        end
        if string.find (targetNameL, "dodo" )or string.find (targetNameL, "pterodactyl" )or string.find (targetNameL, "ankylosaurus" )or string.find (targetNameL, "triceratops" )or string.find (targetNameL, "bronto" )or string.find (targetNameL, "trex" )or string.find (targetNameL, "t-rex" )or string.find (targetNameL, "tralaledon" )or string.find (targetNameL, "mosasaurus" )then
            return "Prehistoric"
        end
        if string.find (targetNameL, "parrotfish" )or string.find (targetNameL, "swordfish" )or string.find (targetNameL, "whaleshark" )or string.find (targetNameL, "whale shark" )or string.find (targetNameL, "belugawhale" )or string.find (targetNameL, "beluga whale" )or string.find (targetNameL, "kraken" )or string.find (targetNameL, "elmaja" )or string.find (targetNameL, "el maja" )then
            return "Abyss Ocean"
        end
        if string.find (targetNameL, "lava gecko" )or string.find (targetNameL, "lava frog" )or string.find (targetNameL, "flaming bull" )or string.find (targetNameL, "lava iguana" )or string.find (targetNameL, "chillin chilli" )or string.find (targetNameL, "cerberus" )or string.find (targetNameL, "phoenix" )or string.find (targetNameL, "lava dragon" )then
            return "Volcano"
        end
        if string.find (targetNameL, "penguin" )or string.find (targetNameL, "walrus" )or string.find (targetNameL, "polar bear" )or string.find (targetNameL, "polarbear" )or string.find (targetNameL, "sabertooth" )or string.find (targetNameL, "mammoth" )or string.find (targetNameL, "yeti" )or string.find (targetNameL, "ice dragon" )or string.find (targetNameL, "icedragon" )then
            return "Snow"
        end
        if string.find (targetNameL, "sand spider" )or string.find (targetNameL, "sandspider" )or string.find (targetNameL, "royal sphinx" )or string.find (targetNameL, "sphinx" )or string.find (targetNameL, "tob tobi" )or string.find (targetNameL, "tobtobi" )or string.find (targetNameL, "jerboa" )or string.find (targetNameL, "fennec" )or string.find (targetNameL, "camel" )then
            return "Desert"
        end
        if string.find (targetNameL, "chimpanzee" )or string.find (targetNameL, "toucan" )or string.find (targetNameL, "crocodile" )or string.find (targetNameL, "orangutini" )or string.find (targetNameL, "ananassini" )or string.find (targetNameL, "king snake" )or string.find (targetNameL, "kingsnake" )then
            return "Jungle"
        end
        if string.find (targetNameL, "duckling" )or string.find (targetNameL, "catfish" )or string.find (targetNameL, "turtle" )or string.find (targetNameL, "trulimero" )or string.find (targetNameL, "trulicina" )or string.find (targetNameL, "swan" )or string.find (targetNameL, "axolotl" )or string.find (targetNameL, "leviathan" )then
            return "Lake"
        end
        if string.find (targetNameL, "burrowing owl" )or string.find (targetNameL, "burrowingowl" )or string.find (targetNameL, "brr brr" )or string.find (targetNameL, "patapim" )or string.find (targetNameL, "chicken" )or string.find (targetNameL, "dog" )or string.find (targetNameL, "bird" )or string.find (targetNameL, "raccoon" )or string.find (targetNameL, "fox" )then
            return "Forest"
        end
        if string.find (targetNameL, "shark" )then
            return "Abyss Ocean"
        end
        if string.find (targetNameL, "snake" )then
            return "Desert"
        end
        if string.find (targetNameL, "spider" )then
            return "Jungle"
        end
        if string.find (targetNameL, "gorilla" )then
            return "Jungle"
        end
        if string.find (targetNameL, "tiger" )then
            return "Jungle"
        end
        if string.find (targetNameL, "frog" )then
            return "Lake"
        end
        if string.find (targetNameL, "bear" )then
            return "Forest"
        end
    end
    if(string.find (nameL, "light" )and string.find (nameL, "dark" ))or nameL== "lightdark" then
        return "Light Dark"
    elseif string.find (nameL, "titan" )then
        return "Titan Temple"
    elseif string.find (nameL, "cherry" )then
        return "Cherry Blossom"
    elseif string.find (nameL, "cosmic" )then
        return "Cosmic"
    elseif string.find (nameL, "prehistoric" )or string.find (nameL, "dino" )then
        return "Prehistoric"
    elseif string.find (nameL, "abyss" )or string.find (nameL, "ocean" )then
        return "Abyss Ocean"
    elseif string.find (nameL, "volcano" )or string.find (nameL, "lava" )then
        return "Volcano"
    elseif string.find (nameL, "snow" )or string.find (nameL, "ice" )or string.find (nameL, "winter" )then
        return "Snow"
    elseif string.find (nameL, "jungle" )then
        return "Jungle"
    elseif string.find (nameL, "desert" )or string.find (nameL, "sand" )then
        return "Desert"
    elseif string.find (nameL, "lake" )or string.find (nameL, "water" )then
        return "Lake"
    elseif string.find (nameL, "forest" )then
        return "Forest"
    end
    if guardPartX> 0 then
        if guardPartX>= 5200 then
            return "Light Dark"
        elseif guardPartX>= 4750 then
            return "Titan Temple"
        elseif guardPartX>= 4000 then
            return "Cherry Blossom"
        elseif guardPartX>= 3350 then
            return "Cosmic"
        elseif guardPartX>= 2780 then
            return "Prehistoric"
        elseif guardPartX>= 2250 then
            return "Abyss Ocean"
        elseif guardPartX>= 1850 then
            return "Volcano"
        elseif guardPartX>= 1450 then
            return "Snow"
        elseif guardPartX>= 1150 then
            return "Jungle"
        elseif guardPartX>= 920 then
            return "Desert"
        elseif guardPartX>= 720 then
            return "Lake"
        else
            return "Forest"
        end
    end
    return "Forest"
end
pickBestEgg=function(...)
    local slots=getEggSlots( false )
    if not slots or#slots== 0 then
        slots=getEggSlots( true )
    end
    if not slots or#slots== 0 then
        return nil
    end
    local charPick=LocalPlayer.Character
    local rootPick=charPick and charPick:FindFirstChild( "HumanoidRootPart" )
    local zonePickRoot=rootPick and rootPick.Position or Vector3.new ( 525 , 70 , -360 )
    local function fmtMoney(moneyNum,...) moneyNum=tonumber(moneyNum)or 0
        if moneyNum>= 1000000000000 then
            return string.format ( "%.1fT" ,moneyNum/ 1000000000000 )
        end
        if moneyNum>= 1000000000 then
            return string.format ( "%.1fB" ,moneyNum/ 1000000000 )
        end
        if moneyNum>= 1000000 then
            return string.format ( "%.1fM" ,moneyNum/ 1000000 )
        end
        if moneyNum>= 1000 then
            return string.format ( "%.1fK" ,moneyNum/ 1000 )
        end
        return string.format ( "%.0f" ,moneyNum)
    end
    local function eggRank(eggData,eggRankModel,rarityStr,rarityTierNum,...)
        if eggData and eggData.PhysicalModel then
            local eggRankPhysical=eggData.PhysicalModel
            local eggRankAttr=eggRankPhysical:GetAttribute( "Rarity" )or eggRankPhysical:GetAttribute( "RarityTier" )or eggRankPhysical:GetAttribute( "Tier" )
            if eggRankAttr and(tostring(eggRankAttr)~= "" and tostring(eggRankAttr)~= "Unknown" )then
                rarityStr=tostring(eggRankAttr)
            end
            if not eggRankModel or eggRankModel== "Egg" or eggRankModel== "" then
                eggRankModel=eggRankPhysical:GetAttribute( "Category" )or eggRankPhysical:GetAttribute( "AssetCategory" )or eggRankPhysical.Name
            end
        end
        local rarityLower1=string.lower (tostring(eggData.Rarity or "" ))
        local rarityLower2=string.lower (tostring(rarityStr or "" ))
        for rarityWordIdx,rarityWord in ipairs({rarityLower1,rarityLower2})do
            if rarityWord~= "" and(rarityWord~= "unknown" and rarityWord~= "nil" )then
                if string.find (rarityWord, "divine" )then
                    return 6 , "Divine"
                end
                if string.find (rarityWord, "eternal" )then
                    return 5 , "Eternal"
                end
                if string.find (rarityWord, "secret" )then
                    return 4 , "Secret"
                end
                if string.find (rarityWord, "cosmic" )then
                    return 3 , "Cosmic"
                end
                if string.find (rarityWord, "mythic" )then
                    return 2 , "Mythic"
                end
                if string.find (rarityWord, "legendary" )then
                    return 1 , "Legendary"
                end
                if string.find (rarityWord, "epic" )then
                    return 0.5 , "Epic"
                end
                if string.find (rarityWord, "rare" )then
                    return 0.3 , "Rare"
                end
                if string.find (rarityWord, "uncommon" )then
                    return 0.1 , "Uncommon"
                end
                if string.find (rarityWord, "common" )then
                    return 0 , "Common"
                end
            end
        end
        if rarityTierNum and rarityTierNum>= 10 then
            return 6 , "Divine"
        elseif rarityTierNum and rarityTierNum>= 9 then
            return 5 , "Eternal"
        elseif rarityTierNum and rarityTierNum>= 8 then
            return 4 , "Secret"
        elseif rarityTierNum and rarityTierNum>= 7 then
            return 3 , "Cosmic"
        elseif rarityTierNum and rarityTierNum>= 6 then
            return 2 , "Mythic"
        elseif rarityTierNum and rarityTierNum>= 5 then
            return 1 , "Legendary"
        elseif rarityTierNum and rarityTierNum>= 4 then
            return 0.5 , "Epic"
        elseif rarityTierNum and rarityTierNum>= 3 then
            return 0.3 , "Rare"
        elseif rarityTierNum and rarityTierNum>= 2 then
            return 0.1 , "Uncommon"
        elseif rarityTierNum and rarityTierNum>= 1 then
            return 0 , "Common"
        end
        local eggIdentifyKey=string.lower (string.format ( "%s %s %s %s %s" ,tostring(eggRankModel or "" ),tostring(eggData.Uid or "" ),tostring(eggData.Name or "" ),tostring(eggData.DisplayName or "" ),tostring(eggData.EggName or "" )))
        if string.find (eggIdentifyKey, "nightflame" )or string.find (eggIdentifyKey, "unicornegg" )or string.find (eggIdentifyKey, "unicorn egg" )or string.find (eggIdentifyKey, "shatteredcolossus" )or string.find (eggIdentifyKey, "kitsune" )or string.find (eggIdentifyKey, "elmaja" )or string.find (eggIdentifyKey, "el maja" )then
            return 6 , "Divine"
        end
        if string.find (eggIdentifyKey, "gorillaking" )or string.find (eggIdentifyKey, "gorilla king" )or string.find (eggIdentifyKey, "lunardragon" )or string.find (eggIdentifyKey, "lunar dragon" )or string.find (eggIdentifyKey, "onitiger" )or string.find (eggIdentifyKey, "oni tiger" )or string.find (eggIdentifyKey, "mosasaurus" )then
            return 5 , "Eternal"
        end
        if string.find (eggIdentifyKey, "mutantshark" )or string.find (eggIdentifyKey, "mutant shark" )or string.find (eggIdentifyKey, "skeletonboss" )or string.find (eggIdentifyKey, "skeleton boss" )or string.find (eggIdentifyKey, "stagegg" )or string.find (eggIdentifyKey, "stag egg" )or string.find (eggIdentifyKey, "cosmicdragon" )or string.find (eggIdentifyKey, "cosmic dragon" )or string.find (eggIdentifyKey, "trex" )or string.find (eggIdentifyKey, "t-rex" )or string.find (eggIdentifyKey, "tralaledon" )or string.find (eggIdentifyKey, "kraken" )then
            return 4 , "Secret"
        end
        if string.find (eggIdentifyKey, "saturnita" )or string.find (eggIdentifyKey, "saturno" )or string.find (eggIdentifyKey, "mantaris" )or string.find (eggIdentifyKey, "rhinotaur" )or string.find (eggIdentifyKey, "snowyowl" )or string.find (eggIdentifyKey, "snowy owl" )or string.find (eggIdentifyKey, "koiegg" )or string.find (eggIdentifyKey, "koi egg" )or string.find (eggIdentifyKey, "triceratops" )or string.find (eggIdentifyKey, "bronto" )or string.find (eggIdentifyKey, "whaleshark" )or string.find (eggIdentifyKey, "whale shark" )or string.find (eggIdentifyKey, "belugawhale" )or string.find (eggIdentifyKey, "beluga whale" )then
            return 3 , "Cosmic"
        end
        if string.find (eggIdentifyKey, "bladehide" )or string.find (eggIdentifyKey, "redpanda" )or string.find (eggIdentifyKey, "red panda" )or string.find (eggIdentifyKey, "cosmicgorilla" )or string.find (eggIdentifyKey, "cosmic gorilla" )or string.find (eggIdentifyKey, "ankylosaurus" )or string.find (eggIdentifyKey, "orca" )then
            return 2 , "Mythic"
        end
        if string.find (eggIdentifyKey, "spideron" )or string.find (eggIdentifyKey, "crustacia" )or string.find (eggIdentifyKey, "salamander" )or string.find (eggIdentifyKey, "cosmicgecko" )or string.find (eggIdentifyKey, "cosmic gecko" )or string.find (eggIdentifyKey, "pterodactyl" )or string.find (eggIdentifyKey, "sharkegg" )or string.find (eggIdentifyKey, "shark egg" )then
            return 1 , "Legendary"
        end
        if string.find (eggIdentifyKey, "crane" )or string.find (eggIdentifyKey, "centapede" )or string.find (eggIdentifyKey, "swordfish" )then
            return 0.5 , "Epic"
        end
        if string.find (eggIdentifyKey, "dodo" )or string.find (eggIdentifyKey, "parrotfish" )then
            return 0.3 , "Rare"
        end
        local eggRankEarn=tonumber(eggData.EarningRate or eggData.Income or 0 )
        if eggRankEarn and eggRankEarn>= 150000000 then
            return 4 , "Secret"
        end
        local rarityDisplay=(rarityStr and(rarityStr~= "Unknown" and rarityStr))or "Common"
        local rarityTierVal=rarityTiers[rarityDisplay]or 0
        return rarityTierVal,rarityDisplay
    end
    local function findBestSlot(bestSlotAll,bestSlotForce,...)
        local candidateRecords={}
        for bestSlotIdx,slotRec in ipairs(slots)do
            local slotPlayable=(slotRec.State == "Slot" or slotRec.State == "Dropped" or slotRec.State == "GuardCarried" or slotRec.State == 1 )
            local slotOutOfBounds=(slotRec.BoundsCFrame and slotRec.BoundsCFrame.Position .X < 530 )or string.find (tostring(slotRec.Uid ), "FirstArea" )
            local slotOnCooldown=eggCooldownMap[slotRec.Uid ]and(os.clock ()<eggCooldownMap[slotRec.Uid ])
            if slotPlayable and(not slotOutOfBounds and(((bestSlotForce or not slotOnCooldown))and slotRec.BoundsCFrame ))then
                local slotAssetCat=slotRec.AssetCategory or "Egg"
                local bestSlotIncome= 0
                local bestSlotRate= 0
                local bestSlotBoost= 0
                local bestSlotRarity= "Unknown"
                if AssetItemsModule then
                    pcall(function(...)
                        if AssetItemsModule.RarityRankForCategory then
                            bestSlotIncome=AssetItemsModule.RarityRankForCategory (slotAssetCat)or 0
                        end
                        if AssetItemsModule.ProfileIncomePerSecond then
                            bestSlotRate=AssetItemsModule.ProfileIncomePerSecond (slotAssetCat)or 0
                        end
                        if AssetItemsModule.SalePrice then
                            bestSlotBoost=AssetItemsModule.SalePrice (slotAssetCat)or 0
                        end
                        if AssetItemsModule.Assets and AssetItemsModule.Assets [slotAssetCat]then
                            local bestSlotAsset=AssetItemsModule.Assets [slotAssetCat]bestSlotRarity=bestSlotAsset.Rarity or(bestSlotAsset.Egg and bestSlotAsset.Egg.Rarity )or "Unknown"
                            if not bestSlotRate or bestSlotRate== 0 then
                                bestSlotRate=bestSlotAsset.EarningRate or(bestSlotAsset.Egg and bestSlotAsset.Egg.EarningRate )or 0
                            end
                        end
                    end
                    )
                end
                local bestSlotX=slotRec.BoundsCFrame.Position .X
                local bestSlotPos=slotRec.BoundsCFrame.Position
                local bestSlotAreaId=slotRec.AreaId
                if((not bestSlotAreaId or bestSlotAreaId== "" or bestSlotAreaId== "Unknown" ))and slotRec.PhysicalModel then
                    bestSlotAreaId=slotRec.PhysicalModel :GetAttribute( "AreaId" )or slotRec.PhysicalModel :GetAttribute( "Area" )
                end
                local bestSlotKeyStr=string.format ( "%s %s %s %s" ,tostring(slotAssetCat or "" ),tostring(slotRec.Uid or "" ),tostring(slotRec.Name or "" ),(slotRec.PhysicalModel and slotRec.PhysicalModel.Name )or "" )
                local bestSlotZone=detectTargetZone(bestSlotAreaId,bestSlotPos,bestSlotKeyStr)
                local bestSlotTier,bestSlotRarName=eggRank(slotRec,slotAssetCat,bestSlotRarity,bestSlotIncome)
                local bestSlotElite=(bestSlotTier>= 4 or bestSlotRarName== "Secret" or bestSlotRarName== "Eternal" or bestSlotRarName== "Divine" )
                local bestSlotZoneSel=(h.selectedZones and h.selectedZones [bestSlotZone]== true )
                local bestSlotRarSel=(h.selectedRarities and h.selectedRarities [bestSlotRarName]== true )
                local bestSlotPass= false
                if bestSlotElite then
                    bestSlotPass= true
                else
                    if bestSlotZoneSel and bestSlotRarSel then
                        bestSlotPass= true
                    end
                end
                if bestSlotPass then
                    local mutScale=tonumber(slotRec.AssetScale or slotRec.Scale )or 1
                    local mutMultiplier= 1
                    if slotRec.Mutations and type(slotRec.Mutations )== "table" then
                        for mutKey,mutVal in pairs(slotRec.Mutations )do
                            local mutAmount=(type(mutVal)== "table" and tonumber(mutVal.Multiplier or mutVal.Value ))or tonumber(mutVal)or 1.5 mutMultiplier=mutMultiplier*mutAmount
                        end
                    elseif slotRec.Mutation then
                        mutMultiplier= 1.5
                    end
                    local mutIncome=(bestSlotRate*mutScale)*mutMultiplier
                    local mutZoneWeight=zoneOrderZ[bestSlotZone]or 50
                    if mutIncome<= 0 then
                        mutIncome=(((mutZoneWeight^ 2 )*mutScale)*mutMultiplier)* 10
                    end
                    local mutDist=((zonePickRoot-slotRec.BoundsCFrame.Position )).Magnitude table.insert (candidateRecords,{[ "Uid" ]=slotRec.Uid ,[ "Category" ]=tostring(slotAssetCat),[ "Area" ]=tostring(bestSlotZone),[ "ZoneWeight" ]=mutZoneWeight,[ "Rarity" ]=tostring(bestSlotRarName);
                    [ "RarityTier" ]=bestSlotTier;
                    [ "Rank" ]=bestSlotIncome;
                    [ "Income" ]=bestSlotRate,[ "RealIncome" ]=mutIncome;
                    [ "Scale" ]=mutScale,[ "MutMultiplier" ]=mutMultiplier,[ "CFrame" ]=slotRec.BoundsCFrame ;
                    [ "Position" ]=slotRec.BoundsCFrame.Position ,[ "Distance" ]=mutDist,[ "Model" ]=slotRec.PhysicalModel })
                end
            end
        end
        if#candidateRecords== 0 then
            return nil
        end
        local function scoreFunc(scoreFnRec,...)
            local scoreFnTier=scoreFnRec.RarityTier or 0
            local scoreFnZoneW=scoreFnRec.ZoneWeight or 50
            if scoreFnTier>= 4 then
                return( 400000 +(scoreFnTier* 10000 ))+scoreFnZoneW
            else
                return(scoreFnZoneW* 11 )+(scoreFnTier* 1000 )
            end
        end
        table.sort (candidateRecords,function(sortCandA,sortCandB,...)
            local sortScoreA=scoreFunc(sortCandA)
            local sortScoreB=scoreFunc(sortCandB)
            if sortScoreA~=sortScoreB then
                return sortScoreA>sortScoreB
            end
            if sortCandA.ZoneWeight ~=sortCandB.ZoneWeight then
                return sortCandA.ZoneWeight >sortCandB.ZoneWeight
            end
            if math.abs (sortCandA.RealIncome -sortCandB.RealIncome )> 1 then
                return sortCandA.RealIncome >sortCandB.RealIncome
            end
            if math.abs (sortCandA.Scale -sortCandB.Scale )> 0.05 then
                return sortCandA.Scale >sortCandB.Scale
            end
            return sortCandA.Distance <sortCandB.Distance
        end
        )
        local bestCandRec=candidateRecords[ 1 ]
        local candInfoLines={}
        for candLineIdx= 1 ,math.min ( 3 ,#candidateRecords), 1 do
            local candLineRec=candidateRecords[candLineIdx]table.insert (candInfoLines,string.format ( "#%d %s[%s|%s] Score:%d $%s/s (%.1fx) dist=%dm" ,candLineIdx,tostring(candLineRec.Category ),tostring(candLineRec.Rarity ),tostring(candLineRec.Area ),scoreFunc(candLineRec),fmtMoney(candLineRec.RealIncome ),tonumber(candLineRec.Scale )or 1 ,math.floor (tonumber(candLineRec.Distance )or 0 )))
        end
        if#candInfoLines> 0 then
            Log( "[AutoSteal v42.44] " ..table.concat (candInfoLines, " | " ))
        end
        return bestCandRec
    end
    local bestSlot=findBestSlot( false , false )
    if not bestSlot then
        eggCooldownMap={}bestSlot=findBestSlot( false , true )
    end
    if not bestSlot then
        slots=getEggSlots( true )bestSlot=findBestSlot( false , true )
    end
    if bestSlot and Workspace:FindFirstChild( "AreaEggSlotsClient" )then
        for rawSlotIdx,rawSlotObj in ipairs(Workspace.AreaEggSlotsClient :GetChildren())do
            local rawSlotPart=rawSlotObj:FindFirstChildWhichIsA( "BasePart" )or rawSlotObj.PrimaryPart
            if rawSlotPart and((rawSlotPart.Position -bestSlot.Position )).Magnitude <= 12 then
                bestSlot.Model =rawSlotObj
                break
            end
        end
    end
    return bestSlot
end
guardStrikeLift=function(eggUid,eggCFrame,eggModel,sessionSwitchIdGuard,...)
    local strikeChar=LocalPlayer.Character
    local strikeRoot=strikeChar and strikeChar:FindFirstChild( "HumanoidRootPart" )
    local strikeHumanoid=strikeChar and strikeChar:FindFirstChildOfClass( "Humanoid" )
    if not strikeRoot or not strikeHumanoid then
        return false
    end
    h.securingEgg = true h.isReturning = false h.stateTime =os.clock ()h.holdingEggForGuard = true
    local strikePos=eggCFrame.Position spawnSafetyFloor(strikePos, 14 )h.currentTargetModel =eggModel h.targetPosition =strikePos strikeRoot.AssemblyLinearVelocity =Vector3.zero strikeRoot.AssemblyAngularVelocity =Vector3.zero disableRagdoll(strikeChar)pcall(function(...) LocalPlayer:RequestStreamAroundAsync(strikePos)
    end
    )
    if not eggModel and Workspace:FindFirstChild( "AreaEggSlotsClient" )then
        for slotChild,slotModel in ipairs(Workspace.AreaEggSlotsClient :GetChildren())do
            local slotPart=slotModel:FindFirstChildWhichIsA( "BasePart" )or slotModel.PrimaryPart
            if slotPart and((slotPart.Position -strikePos)).Magnitude <= 16 then
                eggModel=slotModel h.currentTargetModel =slotModel
                break
            end
        end
    end
    if eggModel then
        pcall(function(...)
            for ghostPart,ghostDesc in ipairs(eggModel:GetDescendants())do
                if ghostDesc:IsA( "BasePart" )and(ghostDesc.Transparency > 0.8 and(ghostDesc.Name ~= "Hitbox" and(ghostDesc.Name ~= "Root" and not ghostDesc.Name :find( "Pad" ))))then
                    ghostDesc.Transparency = 0
                end
            end
        end
        )
    end
    h.statusText = "[1/4] Lifting Egg to Trigger Guard..." Log(string.format ( "[GuardStrike] Step 1: Lifting target egg (%s)..." ,tostring(eggUid)))
    local liftDeadline=os.clock ()+ 3.5
    local lastCheckClock= 0
    while not isCarryingTargetEgg()and(os.clock ()<liftDeadline and(h.alive and h.securingEgg ))do
        if sessionSwitchIdGuard and sessionSwitchId~=sessionSwitchIdGuard then
            Warn( "[GuardStrike] Cancelled by session switch in Step 1" )
            break
        end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting )then
            break
        end
        if eggUid and(os.clock ()-lastCheckClock> 0.4 )then
            lastCheckClock=os.clock ()
            local availNow,availState=checkEggState(eggUid)
            if not availNow and availState== "CarriedByOther" then
                Warn(string.format ( "[GuardStrike] Target egg %s was snatched by another player! Aborting pickup..." ,tostring(eggUid)))
                break
            end
        end
        strikeChar:PivotTo(eggCFrame*CFrame.new ( 0 , 0.4 , 0 ))followEgg(eggModel,strikePos)
        if eggUid and AskFieldEggCarry then
            task.spawn (function(...) pcall(function(...)
                    if AskFieldEggCarry:IsA( "RemoteFunction" )then
                        AskFieldEggCarry:InvokeServer({[ "Uid" ]=eggUid})AskFieldEggCarry:InvokeServer(eggUid)
                    else
                        AskFieldEggCarry:FireServer({[ "Uid" ]=eggUid})AskFieldEggCarry:FireServer(eggUid)
                    end
                end
                )
            end
            )
        end
        RunService.Heartbeat :Wait()
    end
    if not isCarryingTargetEgg()then
        Warn( "[GuardStrike] Initial egg pickup timed out or egg was stolen" )
        if eggUid then
            eggCooldownMap[eggUid]=os.clock ()+ 2
        end
        h.currentTargetModel =nil h.targetPosition =nil h.securingEgg = false h.holdingEggForGuard = false
        return false
    end
    h.statusText = "[2/4] Waiting for Guard Strike..." Log( "[GuardStrike] Step 2: Egg lifted! Triggering guard strike..." )
    local guardLiftClock=os.clock ()
    local guardLiftDeadline=guardLiftClock+ 4.5
    local guardLiftHeld= false
    while isCarryingTargetEgg()and(os.clock ()<guardLiftDeadline and(h.alive and h.securingEgg ))do
        if sessionSwitchIdGuard and sessionSwitchId~=sessionSwitchIdGuard then
            Warn( "[GuardStrike] Cancelled by session switch in Step 2" )
            break
        end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting )then
            break
        end
        strikeChar:PivotTo(eggCFrame*CFrame.new ( 0 , 0.4 , 0 ))spawnSafetyFloor(strikePos, 14 )
        if ForestStrikeRemote and not guardLiftHeld then
            task.spawn (function(...) pcall(function(...)
                    if ForestStrikeRemote:IsA( "RemoteFunction" )then
                        ForestStrikeRemote:InvokeServer()
                    else
                        ForestStrikeRemote:FireServer()
                    end
                end
                )
            end
            )guardLiftHeld= true
        end
        RunService.Heartbeat :Wait()
    end
    h.statusText = "[3/4] Re-grabbing Egg..." Log( "[GuardStrike] Step 3: Guard struck! Re-grabbing egg..." )
    local guardLiftTimeout=os.clock ()+ 3
    while not isCarryingTargetEgg()and(os.clock ()<guardLiftTimeout and(h.alive and h.securingEgg ))do
        if sessionSwitchIdGuard and sessionSwitchId~=sessionSwitchIdGuard then
            Warn( "[GuardStrike] Cancelled by session switch in Step 3" )
            break
        end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting )then
            break
        end
        strikeChar:PivotTo(eggCFrame*CFrame.new ( 0 , 0.4 , 0 ))followEgg(eggModel,strikePos)
        if eggUid and AskFieldEggCarry then
            task.spawn (function(...) pcall(function(...)
                    if AskFieldEggCarry:IsA( "RemoteFunction" )then
                        AskFieldEggCarry:InvokeServer({[ "Uid" ]=eggUid})AskFieldEggCarry:InvokeServer(eggUid)
                    else
                        AskFieldEggCarry:FireServer({[ "Uid" ]=eggUid})AskFieldEggCarry:FireServer(eggUid)
                    end
                end
                )
            end
            )
        end
        RunService.Heartbeat :Wait()
    end
    local guardLiftHasEgg=hasEggOrCarried(eggUid)
    if not guardLiftHasEgg then
        task.wait ( 0.12 )guardLiftHasEgg=hasEggOrCarried(eggUid)
    end
    h.currentTargetModel =nil h.targetPosition =nil h.securingEgg = false h.holdingEggForGuard = false
    if sessionSwitchIdGuard and sessionSwitchId~=sessionSwitchIdGuard then
        return false
    end
    if guardLiftHasEgg then
        pcall(unequipAllTools)Log( "[GuardStrike] Egg successfully secured after guard strike! Stashed in backpack." )h.statusText = "Egg Secured! Tweening along Z=-360..."
    else
        Warn( "[-] Failed to re-grab egg after guard strike (stolen or despawned)" )h.statusText = "[-] Failed to re-grab egg"
        if eggUid then
            eggCooldownMap[eggUid]=os.clock ()+ 2
        end
    end
    return guardLiftHasEgg
end
snipeLoop=function(targetInfoW,sessionSwitchW,...)
    if h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg then
        return false
    end
    h.teleporting = true h.isReturning = false h.stateTime =os.clock ()
    local snipeChar=LocalPlayer.Character
    local snipeRoot=snipeChar and snipeChar:FindFirstChild( "HumanoidRootPart" )
    local snipeHumanoid=snipeChar and snipeChar:FindFirstChildOfClass( "Humanoid" )
    if not snipeRoot or not snipeHumanoid then
        recoverAutoSteal()
        return false
    end
    if snipeHumanoid then
        snipeHumanoid:UnequipTools()
    end
    h.statusText = "[1/7] Pre-Flight Desync..."
    if not h.swapped then
        swapHumanoidAntiDesync()
    end
    if not h.godmode then
        setGodmode( true )
    end
    disableRagdoll(snipeChar)
    if not targetInfoW then
        targetInfoW=pickBestEgg()
    end
    local snipeCFrame=targetInfoW and targetInfoW.CFrame or homeCFrame
    local snipeUid=targetInfoW and targetInfoW.Uid
    local snipePos=snipeCFrame.Position
    if snipeUid then
        local snipePreState,snipePreStateName=checkEggState(snipeUid)
        if not snipePreState and snipePreStateName~= "CarriedBySelf" then
            Warn(string.format ( "[Snipe] Target egg %s is already taken (%s)! Selecting next target..." ,tostring(snipeUid),tostring(snipePreStateName)))h.statusText = "Target taken by another player!" eggCooldownMap[snipeUid]=os.clock ()+ 5 recoverAutoSteal()
            return false
        end
    end
    local heldEggUid=select( 2 ,findEggTool())
    if not heldEggUid then
        local lakeEggInfo=findLakeEgg()
        if not lakeEggInfo then
            Warn( "[-] Lake egg not found" )h.statusText = "[-] No Lake egg found" recoverAutoSteal()
            return false
        end
        h.currentTargetModel =lakeEggInfo.Model h.targetPosition =lakeEggInfo.Position
        local lakeEggDist=((snipeRoot.Position -lakeEggInfo.Position )).Magnitude
        local lakePivot=lakeEggInfo.CFrame *CFrame.new ( 0 , 0.4 , 0 )pcall(function(...) LocalPlayer:RequestStreamAroundAsync(lakeEggInfo.Position )
        end
        )spawnSafetyFloor(lakeEggInfo.Position , 8 )
        if lakeEggDist> 60 then
            h.statusText =string.format ( "[2/7] Gliding to Lake Egg (%.0f studs)..." ,lakeEggDist)h.glidingToTarget = true
            local glideResult=tweenGlide(lakePivot,h.glideSpeed ,lakeEggInfo.Uid ,sessionSwitchW)h.glidingToTarget = false
            if not glideResult then
                Warn( "[-] Lake starter egg was taken during flight" )eggCooldownMap[lakeEggInfo.Uid ]=os.clock ()+ 5 recoverAutoSteal()
                return false
            end
        else
            h.statusText = "[2/7] Aligning with Lake Egg..." snipeRoot.CFrame =lakePivot snipeRoot.AssemblyLinearVelocity =Vector3.zero task.wait ( 0.04 )
        end
        snipeRoot.Anchored = true task.wait ( 0.06 )snipeRoot.Anchored = false h.holdingEggForGuard = true
        local lakeTimeout=os.clock ()+ 3
        while not isCarryingTargetEgg()and(os.clock ()<lakeTimeout and(h.alive and h.teleporting ))do
            if sessionSwitchW and sessionSwitchId~=sessionSwitchW then
                Warn( "[Snipe] Cancelled by session switch during Lake egg pickup" )recoverAutoSteal()
                return false
            end
            if not h.autoFarmLoop and not h.teleporting then
                recoverAutoSteal()
                return false
            end
            followEgg(lakeEggInfo.Model ,lakeEggInfo.Position )
            if lakeEggInfo.Uid and AskFieldEggCarry then
                task.spawn (function(...) pcall(function(...)
                        if AskFieldEggCarry:IsA( "RemoteFunction" )then
                            AskFieldEggCarry:InvokeServer({[ "Uid" ]=lakeEggInfo.Uid })
                        else
                            AskFieldEggCarry:FireServer({[ "Uid" ]=lakeEggInfo.Uid })
                        end
                    end
                    )
                end
                )
            end
            RunService.Heartbeat :Wait()
        end
        heldEggUid=select( 2 ,findEggTool())
        if not isCarryingTargetEgg()then
            Warn( "[-] Lake egg pickup failed" )h.statusText = "[-] Lake pickup failed" recoverAutoSteal()
            return false
        end
    end
    h.statusText = "[3/7] Pre-streaming Target..." pcall(function(...) LocalPlayer:RequestStreamAroundAsync(snipePos)
    end
    )spawnSafetyFloor(snipePos, 12 )h.statusText = "[4/7] Waiting for physical bounce..." snipeRoot.Anchored = false snipeHumanoid:ChangeState(Enum.HumanoidStateType.Running )
    local savedWalkSpeed=(snipeHumanoid.WalkSpeed > 0 )and snipeHumanoid.WalkSpeed or 16 snipeHumanoid.WalkSpeed = 0 snipeHumanoid:Move(Vector3.zero , false )snipeRoot.AssemblyLinearVelocity =Vector3.zero snipeRoot.AssemblyAngularVelocity =Vector3.zero task.wait ( 0.04 )
    local bounceOrigin=snipeRoot.Position
    local bounceOriginY=bounceOrigin.Y
    local heldOk=select( 2 ,findEggTool())or heldEggUid
    local tollFired= false
    local tollConn=nil
    if SpeedTollRemote and SpeedTollRemote:IsA( "RemoteEvent" )then
        tollConn=SpeedTollRemote.OnClientEvent :Connect(function(...) tollFired= true
            if tollConn then
                tollConn:Disconnect()
            end
        end
        )
    end
    h.holdingEggForGuard = true triggerGuardStrike(heldOk)
    local strikeClock=os.clock ()
    local bounceDetected= false
    local strikeDeadline=os.clock ()+ 2.5
    local strikeSent= false
    while os.clock ()<strikeDeadline and(h.alive and h.teleporting )do
        if sessionSwitchW and sessionSwitchId~=sessionSwitchW then
            Warn( "[Snipe] Cancelled by session switch during strike bounce" )
            if tollConn then
                tollConn:Disconnect()
            end
            snipeHumanoid.WalkSpeed =savedWalkSpeed recoverAutoSteal()
            return false
        end
        local bounceDt=os.clock ()-strikeClock
        local velNow=snipeRoot.AssemblyLinearVelocity
        local posNow=snipeRoot.Position
        local dyNow=posNow.Y -bounceOriginY
        local distMoved=((posNow-bounceOrigin)).Magnitude
        if bounceDt>= 0.08 then
            local bounceCond=tollFired or(velNow.Y >= 10 )or(dyNow>= 1.5 and velNow.Magnitude >= 16 )or(distMoved>= 2 )or(velNow.Magnitude >= 20 )
            if bounceCond then
                bounceDetected= true
                break
            end
        end
        if bounceDt>= 0.5 and not strikeSent then
            strikeSent= true triggerGuardStrike(heldOk)
        end
        RunService.Heartbeat :Wait()
    end
    if tollConn then
        tollConn:Disconnect()
    end
    snipeHumanoid.WalkSpeed =savedWalkSpeed h.holdingEggForGuard = false
    if not bounceDetected then
        Warn( "[-] No bounce detected, aborting" )h.statusText = "[-] Aborted (No bounce detected)" recoverAutoSteal()pcall(unequipAllTools)
        return false
    end
    task.wait ( 0.05 )
    if snipeUid then
        local takenOk,takenState=checkEggState(snipeUid)
        if not takenOk and takenState== "CarriedByOther" then
            Warn(string.format ( "[Snipe] Target egg %s was snatched while bouncing (%s)! Aborting warp..." ,tostring(snipeUid),tostring(takenState)))h.statusText = "Target taken! Aborting warp..." eggCooldownMap[snipeUid]=os.clock ()+ 5 recoverAutoSteal()
            return false
        end
    end
    h.currentTargetModel =targetInfoW and targetInfoW.Model h.targetPosition =snipePos h.statusText = "[5/7] Warping to Target Egg..." spawnSafetyFloor(snipePos, 8 )snipeChar:PivotTo(snipeCFrame*CFrame.new ( 0 , 0.4 , 0 ))snipeRoot.Anchored = true
    for charPart,descPart in ipairs(snipeChar:GetDescendants())do
        if descPart:IsA( "BasePart" )then
            descPart.AssemblyLinearVelocity =Vector3.zero descPart.AssemblyAngularVelocity =Vector3.zero
        end
    end
    h.statusText = "[6/7] Picking up Target Egg..."
    local backpackW=LocalPlayer:FindFirstChild( "Backpack" )
    for toolPart,handTool in ipairs(snipeChar:GetChildren())do
        if handTool:IsA( "Tool" )then
            pcall(function(...)
                if backpackW then
                    handTool.Parent =backpackW
                else
                    handTool.Parent =Workspace
                end
            end
            )
        end
    end
    task.wait ( 0.06 )snipeRoot.Anchored = false snipeHumanoid:ChangeState(Enum.HumanoidStateType.Running )
    local guardLiftOk=guardStrikeLift(snipeUid,snipeCFrame,targetInfoW and targetInfoW.Model ,sessionSwitchW)snipeRoot.Anchored = false snipeHumanoid:ChangeState(Enum.HumanoidStateType.Running )
    for defPart,descDef in ipairs(snipeChar:GetDescendants())do
        if descDef:IsA( "BasePart" )then
            descDef.AssemblyLinearVelocity =Vector3.zero descDef.AssemblyAngularVelocity =Vector3.zero
        end
    end
    if not guardLiftOk then
        Warn( "[-] Guard Strike criteria not met" )h.statusText = "[-] Guard Strike criteria failed" recoverAutoSteal()
        return false
    else
        h.statusText = "[7/7] Target Secured! Stashing into Backpack..." h.teleporting = false pcall(unequipAllTools)
        return true
    end
end
setFarmMode=function(modeReq,...)
    if farmMode==modeReq then
        return
    end
    sessionSwitchId=sessionSwitchId+ 1
    local modeEpoch=sessionSwitchId farmMode= "SWITCHING" h.pureTweenFarm = false h.autoFarmLoop = false pcall(recoverAutoSteal)pcall(unequipAllTools)
    if modeReq== "TWEEN" then
        if warpToggleFn then
            warpToggleFn( false , true )
        end
        if tweenToggleFn then
            tweenToggleFn( true , true )
        end
    elseif modeReq== "WARP" then
        if tweenToggleFn then
            tweenToggleFn( false , true )
        end
        if warpToggleFn then
            warpToggleFn( true , true )
        end
    else
        if tweenToggleFn then
            tweenToggleFn( false , true )
        end
        if warpToggleFn then
            warpToggleFn( false , true )
        end
    end
    task.delay ( 0.06 ,function(...)
        if sessionSwitchId==modeEpoch then
            farmMode=modeReq
            if modeReq== "TWEEN" then
                h.pureTweenFarm = true h.autoFarmLoop = false pcall(unequipAllTools)Log( "[FarmController] Pure Auto Steal (Tween) ACTIVATED exclusively." )
            elseif modeReq== "WARP" then
                h.autoFarmLoop = true h.pureTweenFarm = false pcall(unequipAllTools)Log( "[FarmController] Snipe Auto Loop (Warp) ACTIVATED exclusively." )
            else
                h.pureTweenFarm = false h.autoFarmLoop = false
                if not h.isBatchPlacing then
                    h.batchStealCount = 0
                end
                Log( "[FarmController] All farms DEACTIVATED. Bot idle." )
            end
        end
    end
    )
end
local tweenLoopStart=os.clock ()task.spawn (function(...)
    while h.alive do
        local loopErr,loopErrDetail=pcall(function(...)
            if h.pureTweenFarm and(not h.autoFarmLoop and(farmMode== "TWEEN" and(not h.isBatchPlacing and(not h.teleporting and(not h.glidingToTarget and(not h.securingEgg and(not h.delivering and not h.isReturning )))))))then
                local char=LocalPlayer.Character
                local charRoot=char and char:FindFirstChild( "HumanoidRootPart" )
                local charHumanoid=char and char:FindFirstChildOfClass( "Humanoid" )
                if charRoot and charHumanoid then
                    pcall(unequipAllTools)
                    local handEgg=isCarryingTargetEgg()
                    if not handEgg then
                        local sessionIdAtLoop=sessionSwitchId
                        local bestEgg=pickBestEgg()
                        if bestEgg and(h.pureTweenFarm and(farmMode== "TWEEN" and sessionSwitchId==sessionIdAtLoop))then
                            if h.onTreadmill or mountAndFarm()then
                                h.statusText = "[AutoSteal] Target found! Getting off treadmill..." dismountTreadmill()task.wait ( 0.08 )
                            end
                            local eggAvail,eggState=checkEggState(bestEgg.Uid )
                            if not eggAvail and eggState~= "CarriedBySelf" then
                                Log(string.format ( "[AutoSteal] Egg %s already taken (%s). Switching to next target..." ,tostring(bestEgg.Uid ),tostring(eggState)))eggCooldownMap[bestEgg.Uid ]=os.clock ()+ 5 task.wait ( 0.12 )
                                return
                            end
                            h.currentTargetModel =bestEgg.Model h.targetPosition =bestEgg.Position h.glidingToTarget = true h.stateTime =os.clock ()
                            local scaleTag=((bestEgg.Scale and bestEgg.Scale > 1.05 ))and string.format ( " | %.1fx" ,bestEgg.Scale )or "" h.statusText =string.format ( "[AutoSteal] Flying to %s (%s%s)..." ,tostring(bestEgg.Category or "Egg" ),tostring(bestEgg.Area or "Field" ),scaleTag)Log(string.format ( "[AutoSteal] Flying to %s | Zone: %s%s | Rank: %d (Corridor Z=-360)" ,tostring(bestEgg.Category or "Egg" ),tostring(bestEgg.Area or "Field" ),scaleTag,tonumber(bestEgg.Rank )or 1 ))
                            if not h.swapped then
                                swapHumanoidAntiDesync()
                            end
                            if not h.godmode then
                                setGodmode( true )
                            end
                            disableRagdoll(char)pcall(function(...) LocalPlayer:RequestStreamAroundAsync(bestEgg.Position )
                            end
                            )
                            local eggAttachCF=bestEgg.CFrame *CFrame.new ( 0 , 0.4 , 0 )
                            local glideOk=tweenGlide(eggAttachCF,h.glideSpeed ,bestEgg.Uid ,sessionIdAtLoop)h.glidingToTarget = false
                            if sessionSwitchId~=sessionIdAtLoop or not h.pureTweenFarm or farmMode~= "TWEEN" then
                                return
                            end
                            if not glideOk then
                                Warn( "[AutoSteal] Egg was taken during flight. Switching to next target..." )eggCooldownMap[bestEgg.Uid ]=os.clock ()+ 5 recoverAutoSteal()
                                return
                            end
                            if h.pureTweenFarm and(farmMode== "TWEEN" and((charRoot.Position -bestEgg.Position )).Magnitude <= 22 )then
                                local guardOk=guardStrikeLift(bestEgg.Uid ,eggAttachCF,bestEgg.Model ,sessionIdAtLoop)
                                if not guardOk and isCarryingTargetEgg()then
                                    guardOk= true
                                end
                                if sessionSwitchId~=sessionIdAtLoop or not h.pureTweenFarm or farmMode~= "TWEEN" then
                                    return
                                end
                                if guardOk then
                                    pcall(unequipAllTools)
                                    if h.autoGlide then
                                        h.statusText = "[AutoSteal] Secured! Tweening to Safe Line X=525..." Log( "[AutoSteal] Egg secured after Guard Strike! Returning smoothly to Safe Line X=525 along Z=-360..." )returnHome(h.glideSpeed ,sessionIdAtLoop)pcall(unequipAllTools)
                                        local bagCount=countCarriedEggs()h.statusText =string.format ( "Stashed in Bag (%d Eggs). Next steal..." ,bagCount)Log(string.format ( "[AutoSteal] Egg stashed in bag (%d total eggs). Hands-Free ready for next steal..." ,bagCount))
                                    else
                                        h.statusText = "[AutoSteal] Secured! (Auto Return is OFF)" Log( "[AutoSteal] Egg secured! Staying at target (Auto Return is OFF)." )
                                    end
                                    pcall(unequipAllTools)h.isReturning = false h.delivering = false h.glidingToTarget = false h.securingEgg = false h.currentTargetModel =nil h.targetPosition =nil
                                    if autoPlaceEggs( "TWEEN" )then
                                        return
                                    end
                                else
                                    if sessionSwitchId==sessionIdAtLoop and(h.pureTweenFarm and farmMode== "TWEEN" )then
                                        Warn( "[AutoSteal] Guard Strike or Re-grab failed. Retrying with next egg..." )eggCooldownMap[bestEgg.Uid ]=os.clock ()+ 5 recoverAutoSteal()
                                    end
                                end
                            else
                                h.currentTargetModel =nil h.targetPosition =nil h.glidingToTarget = false
                            end
                        else
                            if os.clock ()-tweenLoopStart> 5 then
                                eggCooldownMap={}tweenLoopStart=os.clock ()
                            end
                            if h.autoTreadmill and(not h.isBatchPlacing and not h.isHatching )then
                                if not h.onTreadmill and not mountAndFarm()then
                                    h.statusText = "[AutoTreadmill] No targets. Mounting treadmill..." treadmillFarmLoop(sessionIdAtLoop)
                                else
                                    h.statusText = "[AutoTreadmill] Running on treadmill (Waiting for eggs...)"
                                end
                            else
                                h.statusText = "[AutoSteal] Scanning for targets..."
                            end
                        end
                    end
                end
            end
        end
        )
        if not loopErr then
            Warn( "[AutoSteal Loop Recovered]:" ,tostring(loopErrDetail))pcall(recoverAutoSteal)
        end
        task.wait ( 0.08 )
    end
end
)
local warpLoopStart=os.clock ()task.spawn (function(...)
    while h.alive do
        local warpLoopErr,warpLoopErrDetail=pcall(function(...)
            if h.autoFarmLoop and(not h.pureTweenFarm and(farmMode== "WARP" and(not h.isBatchPlacing and(not h.teleporting and(not h.glidingToTarget and(not h.securingEgg and(not h.delivering and not h.isReturning )))))))then
                local charW=LocalPlayer.Character
                local charRootW=charW and charW:FindFirstChild( "HumanoidRootPart" )
                local charHumanoidW=charW and charW:FindFirstChildOfClass( "Humanoid" )
                if charRootW and charHumanoidW then
                    pcall(unequipAllTools)
                    local handEggW=isCarryingTargetEgg()
                    if not handEggW then
                        local sessionIdAtWarp=sessionSwitchId
                        local bestEggW=pickBestEgg()
                        if bestEggW and(h.autoFarmLoop and(farmMode== "WARP" and sessionSwitchId==sessionIdAtWarp))then
                            if h.onTreadmill or mountAndFarm()then
                                h.statusText = "[SnipeLoop] Target found! Getting off treadmill..." dismountTreadmill()task.wait ( 0.08 )
                            end
                            local scaleTagW=((bestEggW.Scale and bestEggW.Scale > 1.05 ))and string.format ( " | %.1fx" ,bestEggW.Scale )or "" Log(string.format ( "[SnipeLoop] Starting Warp Snipe: %s | Zone: %s%s (Rank %d)" ,tostring(bestEggW.Category or "Egg" ),tostring(bestEggW.Area or "Field" ),scaleTagW,tonumber(bestEggW.Rank )or 1 ))h.statusText =string.format ( "[SnipeLoop] Warping for %s%s..." ,tostring(bestEggW.Category or "Egg" ),scaleTagW)
                            local warpOk=snipeLoop(bestEggW,sessionIdAtWarp)
                            if sessionSwitchId~=sessionIdAtWarp or not h.autoFarmLoop or farmMode~= "WARP" then
                                return
                            end
                            if warpOk then
                                pcall(unequipAllTools)
                                if h.autoGlide then
                                    h.statusText = "[SnipeLoop] Target secured! Tweening to Safe Line X=525..." returnHome(h.glideSpeed ,sessionIdAtWarp)pcall(unequipAllTools)
                                    local stashCount=countCarriedEggs()h.statusText =string.format ( "Stashed in Bag (%d Eggs). Next snipe..." ,stashCount)Log(string.format ( "[SnipeLoop] Egg stashed in bag (%d total eggs). Hands-Free ready for next snipe..." ,stashCount))
                                else
                                    h.statusText = "[SnipeLoop] Target secured! (Auto Return is OFF)" Log( "[SnipeLoop] Snipe successful! Staying at target (Auto Return is OFF)." )
                                end
                                pcall(unequipAllTools)h.isReturning = false h.delivering = false
                                if autoPlaceEggs( "WARP" )then
                                    return
                                end
                            else
                                if sessionSwitchId==sessionIdAtWarp and(h.autoFarmLoop and farmMode== "WARP" )then
                                    Warn( "[SnipeLoop] Snipe cycle failed. Resetting for next target..." )
                                    if bestEggW and bestEggW.Uid then
                                        eggCooldownMap[bestEggW.Uid ]=os.clock ()+ 5
                                    end
                                    pcall(recoverAutoSteal)
                                end
                            end
                        else
                            if os.clock ()-warpLoopStart> 5 then
                                eggCooldownMap={}warpLoopStart=os.clock ()
                            end
                            if h.autoTreadmill and(not h.isBatchPlacing and not h.isHatching )then
                                if not h.onTreadmill and not mountAndFarm()then
                                    h.statusText = "[AutoTreadmill] No targets. Mounting treadmill..." treadmillFarmLoop(sessionIdAtWarp)
                                else
                                    h.statusText = "[AutoTreadmill] Running on treadmill (Waiting for eggs...)"
                                end
                            else
                                h.statusText = "[SnipeLoop] Searching for targets..."
                            end
                        end
                    end
                end
            end
        end
        )
        if not warpLoopErr then
            Warn( "[SnipeLoop Loop Recovered]:" ,tostring(warpLoopErrDetail))pcall(recoverAutoSteal)
        end
        task.wait ( 0.08 )
    end
end
)task.spawn (function(...)
    while h.alive do
        local mergeStashOk,mergeStashRec=pcall(function(...)
            if h.autoTreadmill and(not h.pureTweenFarm and(not h.autoFarmLoop and(not h.isBatchPlacing and(not h.isHatching and(not h.teleporting and(not h.glidingToTarget and(not h.securingEgg and(not h.delivering and not h.isReturning ))))))))then
                local recoverChar=LocalPlayer.Character
                local recoverRoot=recoverChar and recoverChar:FindFirstChild( "HumanoidRootPart" )
                if recoverRoot and not isCarryingTargetEgg()then
                    if not h.onTreadmill and not mountAndFarm()then
                        h.statusText = "[AutoTreadmill] Idle without farm. Mounting treadmill..." treadmillFarmLoop()
                    end
                end
            end
        end
        )task.wait ( 0.5 )
    end
end
)task.spawn (function(...)
    while h.alive do
        pcall(function(...)
            if h.autoUpgradeTreadmill then
                autoUpgradeTread()
            end
        end
        )task.wait ( 5 )pcall(function(...)
            if h.autoBuyTrails then
                autoBuyTrails()
            end
        end
        )task.wait ( 5 )
    end
end
)task.spawn (function(...)
    while h.alive do
        if h.autoHatch and(not h.securingEgg and(not h.teleporting and not h.isHatching ))then
            pcall(function(...) hatchReadyEggs( false )
            end
            )
        end
        task.wait ( 4 )
    end
end
)
local lightingFX=nil
local function stripEffect(partToStyle,...) pcall(function(...)
        if partToStyle:IsA( "BasePart" )then
            partToStyle.Material =Enum.Material.SmoothPlastic partToStyle.Reflectance = 0 partToStyle.CastShadow = false
            if partToStyle:IsA( "MeshPart" )then
                partToStyle.TextureID = "" pcall(function(...) partToStyle.RenderFidelity =Enum.RenderFidelity.Performance
                end
                )pcall(function(...) partToStyle.CollisionFidelity =Enum.CollisionFidelity.Box
                end
                )
            end
        elseif partToStyle:IsA( "SpecialMesh" )then
            partToStyle.TextureId = ""
        elseif partToStyle:IsA( "Decal" )or partToStyle:IsA( "Texture" )or partToStyle:IsA( "SurfaceAppearance" )then
            partToStyle.Transparency = 1
        elseif partToStyle:IsA( "ParticleEmitter" )or partToStyle:IsA( "Trail" )or partToStyle:IsA( "Smoke" )or partToStyle:IsA( "Fire" )or partToStyle:IsA( "Sparkles" )then
            partToStyle.Enabled = false
        elseif partToStyle:IsA( "Beam" )then
            partToStyle.Enabled = false
        elseif partToStyle:IsA( "Explosion" )then
            partToStyle.Visible = false
        elseif partToStyle:IsA( "Light" )or partToStyle:IsA( "PointLight" )or partToStyle:IsA( "SpotLight" )or partToStyle:IsA( "SurfaceLight" )then
            partToStyle.Enabled = false
        elseif partToStyle:IsA( "Highlight" )and partToStyle.Name ~= "EggESP_Highlight" then
            partToStyle.Enabled = false
        end
    end
    )
end
local function enablePerfMode(...) h.performanceMode = true pcall(function(...)
        local perfEsp=Workspace:FindFirstChild( "DiceHub_EggESP" )
        if perfEsp then
            perfEsp:Destroy()
        end
        local perfLight=game:GetService( "Lighting" )perfLight.GlobalShadows = false perfLight.FogEnd = 9000000000 perfLight.Brightness = 1 perfLight.ClockTime = 14 perfLight.OutdoorAmbient =Color3.fromRGB ( 128 , 128 , 128 )
        for perfFxIdx,postFx in ipairs(perfLight:GetChildren())do
            if postFx:IsA( "PostEffect" )or postFx:IsA( "BloomEffect" )or postFx:IsA( "BlurEffect" )or postFx:IsA( "ColorCorrectionEffect" )or postFx:IsA( "SunRaysEffect" )or postFx:IsA( "DepthOfFieldEffect" )or postFx:IsA( "Atmosphere" )then
                pcall(function(...) postFx.Enabled = false
                end
                )
            elseif postFx:IsA( "Sky" )then
                pcall(function(...) postFx.Parent =nil
                end
                )
            end
        end
        local perfTerrain=workspace:FindFirstChildOfClass( "Terrain" )
        if perfTerrain then
            pcall(function(...) perfTerrain.Decoration = false perfTerrain.WaterWaveSize = 0 perfTerrain.WaterWaveSpeed = 0 perfTerrain.WaterReflectance = 0 perfTerrain.WaterTransparency = 0
            end
            )
        end
        for perfWsIdx,perfWsDesc in ipairs(workspace:GetDescendants())do
            stripEffect(perfWsDesc)
        end
        if not lightingFX then
            lightingFX=workspace.DescendantAdded :Connect(function(perfAddedDesc,...)
                if h.performanceMode then
                    stripEffect(perfAddedDesc)
                end
            end
            )
        end
        pcall(function(...)
            if settings and(settings()).Rendering then
                (settings()).Rendering.QualityLevel = 1
            end
        end
        )
    end
    )
end
local function disablePerfMode(...) h.performanceMode = false
    if lightingFX then
        pcall(function(...) lightingFX:Disconnect()
        end
        )lightingFX=nil
    end
    pcall(function(...)
        local restLight=game:GetService( "Lighting" )restLight.GlobalShadows = true
        for restFxIdx,restFxItem in ipairs(restLight:GetChildren())do
            if restFxItem:IsA( "PostEffect" )or restFxItem:IsA( "BloomEffect" )or restFxItem:IsA( "BlurEffect" )or restFxItem:IsA( "ColorCorrectionEffect" )or restFxItem:IsA( "SunRaysEffect" )or restFxItem:IsA( "DepthOfFieldEffect" )or restFxItem:IsA( "Atmosphere" )then
                pcall(function(...) restFxItem.Enabled = true
                end
                )
            end
        end
        local restTerrain=workspace:FindFirstChildOfClass( "Terrain" )
        if restTerrain then
            pcall(function(...) restTerrain.Decoration = true
            end
            )
        end
    end
    )
end
local virtualInput= false
local function antiAfkPulse(...) pcall(function(...)
        local virtInput=game:GetService( "VirtualInputManager" )
        if virtInput then
            virtInput:SendKeyEvent( true ,Enum.KeyCode.Escape , false ,game)task.wait ( 0.12 )virtInput:SendKeyEvent( false ,Enum.KeyCode.Escape , false ,game)task.wait ( 0.35 )virtInput:SendKeyEvent( true ,Enum.KeyCode.Escape , false ,game)task.wait ( 0.12 )virtInput:SendKeyEvent( false ,Enum.KeyCode.Escape , false ,game)pcall(function(...)
                if typeof(virtInput.SendTouchEvent )== "function" then
                    virtInput:SendTouchEvent( 99999 , 0 , 15 , 15 )task.wait ( 0.04 )virtInput:SendTouchEvent( 99999 , 2 , 15 , 15 )
                end
            end
            )
        end
    end
    )pcall(function(...)
        if typeof(mousemoverel)== "function" then
            mousemoverel( 1 , 0 )task.wait ( 0.05 )mousemoverel( -1 , 0 )
        end
    end
    )
end
local function startAntiAfk(...)
    if virtualInput then
        return
    end
    virtualInput= true task.spawn (function(...)
        while h and(h.alive and h.antiAFK )do
            local afkTick= 0
            while afkTick< 600 and(h and(h.alive and(h.antiAFK and virtualInput)))do
                task.wait ( 5 )afkTick=afkTick+ 5
            end
            if not h.antiAFK or not virtualInput then
                break
            end
            antiAfkPulse()
        end
        virtualInput= false
    end
    )
end
local function stopAntiAfk(...) virtualInput= false
end
RunService.Heartbeat :Connect(function(...)
    local hbChar=LocalPlayer.Character
    local hbHrp=hbChar and hbChar:FindFirstChild( "HumanoidRootPart" )
    local hbHum=hbChar and hbChar:FindFirstChildOfClass( "Humanoid" )
    if not hbHrp then
        return
    end
    if hbHum and not((h and h.onTreadmill ))then
        if hbHum.PlatformStand then
            hbHum.PlatformStand = false hbHum:ChangeState(Enum.HumanoidStateType.Running )
        end
        if hbHum.Sit and((h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget ))then
            hbHum.Sit = false hbHum:ChangeState(Enum.HumanoidStateType.Running )
        end
    end
    local hbPos=hbHrp.Position
    local hbHasEgg=isCarryingTargetEgg()
    if hbPos.Y < 45 then
        hbHrp.CFrame =CFrame.new (hbPos.X , 72 ,hbPos.Z )hbHrp.AssemblyLinearVelocity =Vector3.zero
        return
    end
    if((h.pureTweenFarm or h.autoFarmLoop ))and not h.holdingEggForGuard then
        local hbHasTool= false
        for hbToolIdx,hbTool in ipairs(hbChar:GetChildren())do
            if hbTool:IsA( "Tool" )then
                hbHasTool= true
                break
            end
        end
        if hbHasTool then
            unequipAllTools()
        end
    end
    if h.pureTweenFarm or h.autoFarmLoop or h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg or h.isReturning then
        return
    end
    if h.alive and(h.autoGlide and(hbHasEgg and(not isLakeEgg()and hbPos.X >safeLineX)))then
        task.spawn (function(...) returnHome(h.glideSpeed )unequipAllTools()h.isReturning = false h.delivering = false
        end
        )
    end
end
)
local iconB64= "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAedEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjEw/7R3GwAAA6BJREFUeN7tW01oE1EQnk0qih4sevCiF/Wg4kEPgqeCHsSDhyIeVIoHDx48KIKHIh48ePAgePBiPRQ8eBA8COJBD4L4B8WD4kHxov7cm2yT3WzeZjdps7t58CG72bebzPfevPlmdg3DMFwul8vlcv13qampWSKi82S2kxgiVpLZZ2T2G5lDZHaRmU9mDxEViOgqEZ1Np9N3V1ZWLlutFh1vNJvN5+12+4bf77+s/p5zIuKCiAgiGhcRLkRkCRkH+rYikYjlOE7G87w/wWBwLxKJbIeDk8mky3q31xG/37/FwR1Fq9V6Q0SX1N9tIuKNiKgiIo/bbrfb+zwez44qchRzHMcioh2Xy6Xb7fYDIsrqu5WIeBDRoohwJ2VlZaWRSCS2VNEdzZTL5ctEdF1V5Yj4QUQ8EXG73e51j8ejiojOa/V6/ZaI7tDfvUS0SUQJEXFeRNRUVVW5mZmZe/R7kZ2cTCZ1vV4/yXfO/4eQeC4iWqpQKJRkZWWl9XrdISJDRMKIyKqqqjIjI2Pj4uLiGef8lMvlYg4eE9E1VVVP9ff/c5z4n04Gg0F3PB7/TkR5dF6k4/F4v9frdc3NzbV1XW/R/2lEVBER91RVVV1TU8OHr1gsVpP198lkct5xnM/q73kiOq+O37G6uvrVdV2u1+vv6XkRkS8UCr3xeDybyuVydWVlZZlOp9v0/y/O+X41538j1b+/qKurW1bVjYg4b0xMTKyqPZ8gIs7pYx7e1/V6/bKa1xEi6k9OTnZVVVW/IqI7RLRJRHkikVhyHGdBVff9+/cf6LpOU1NTD/T3NBFxRkR00Xm1Xq/fV0U+JqK/RETJ7OzsM7vdzhw81nW9RURDRHSpWCze13Wd6/X6bVV0u6qq6mUkEtnSdV3S10z9vUtE3InpdPrB8vLybSLiTk5OTg1tQ7eP8+jo6Jqqwscikcj2wsLCGuf8FBFxJycnJ7sNDQ1rV1dXWzQ4JCKHqnK6XC5bVfS06rp+k6ry8ZWVFR4eHl4jIs4jIyN9hmF81HX9B1Xl9MTERD8RcfN4PDupVOq+67pP1H1bJpPpvb6+7hPRfVVVV0ZGRtiVlRWWSCReZ7PZX36//6Cvr48PDQ09y2azVzwez7Kqqk8556fdbvdnItpVVdUaGRmZoKqaoP6sUjKZ3B8YGGBd122qyu3j/Ojo6F1N034MDAyw6elpW1VVLhQKzH1HRkZ6m4qKiicikajlOI7ler3e9y6X643L5dqi/+NyuZ6rqvpOVdV/Kysr51wu17fW3w8AAAD//wMAe7/lQy8mR0AAAAAElFTkSuQmCC"
local function b64Decode(base64Str,...)
    if crypt and crypt.base64decode then
        return crypt.base64decode (base64Str)
    end
    if base64_decode then
        return base64_decode(base64Str)
    end
    if syn and(syn.crypt and(syn.crypt.base64 and syn.crypt.base64 .decode ))then
        return syn.crypt.base64 .decode (base64Str)
    end
    local b64Charset= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local b64Lookup={}
    for b64LutIdx= 1 ,#b64Charset, 1 do
        b64Lookup[b64Charset:sub(b64LutIdx,b64LutIdx)]=b64LutIdx- 1
    end
    base64Str=(base64Str:gsub( "[^" ..(b64Charset.. "=]" ), "" )):gsub( "=" , "" )
    local b64Bytes={}
    for b64GroupIdx= 1 ,#base64Str, 4 do
        local b64C1=b64Lookup[base64Str:sub(b64GroupIdx,b64GroupIdx)]or 0
        local b64C2=b64Lookup[base64Str:sub(b64GroupIdx+ 1 ,b64GroupIdx+ 1 )]or 0
        local b64C3=b64Lookup[base64Str:sub(b64GroupIdx+ 2 ,b64GroupIdx+ 2 )]
        local b64C4=b64Lookup[base64Str:sub(b64GroupIdx+ 3 ,b64GroupIdx+ 3 )]table.insert (b64Bytes,string.char (bit32.bor (bit32.lshift (b64C1, 2 ),bit32.rshift (b64C2, 4 ))))
        if b64C3 then
            table.insert (b64Bytes,string.char (bit32.bor (bit32.lshift (bit32.band (b64C2, 15 ), 4 ),bit32.rshift (b64C3, 2 ))))
            if b64C4 then
                table.insert (b64Bytes,string.char (bit32.bor (bit32.lshift (bit32.band (b64C3, 3 ), 6 ),b64C4)))
            end
        end
    end
    return table.concat (b64Bytes)
end
local iconPngName= "Dice_Hub_Icon.png"
local iconAsset= "rbxassetid://10734950309" pcall(function(...)
    if writefile and((getcustomasset or getsynasset))then
        local iconLoadFn=getcustomasset or getsynasset
        if not((isfile and isfile(iconPngName)))then
            writefile(iconPngName,b64Decode(iconB64))
        end
        iconAsset=iconLoadFn(iconPngName)
    end
end
)
local langKey=defaultLang or "EN"
local langTables={[ "EN" ]={[ "StatusTagReady" ]= "Status: Ready" ,[ "Tabs" ]={[ "Farm" ]= "Auto Farm" ;
[ "EggSelect" ]= "Egg Selection" ;
[ "Character" ]= "Character" ,[ "Settings" ]= "Settings" },[ "EggSelect" ]={[ "SecZones" ]= "Target Zones" ;
[ "SecZonesDesc" ]= "Select zones to steal regular eggs from (Secret+ bypasses this filter)" ,[ "DropZonesTitle" ]= "Selected Zones" ,[ "DropZonesDesc" ]= "Click to choose which zones to farm eggs from" ;
[ "SecRarities" ]= "Target Rarities" ;
[ "SecRaritiesDesc" ]= "Select egg rarities to target" ;
[ "DropRaritiesTitle" ]= "Selected Rarities" ;
[ "DropRaritiesDesc" ]= "Click to choose which rarities to collect" ,[ "AlwaysSecretPlus" ]= "Always Steal Secret+ Eggs" ;
[ "AlwaysSecretPlusDesc" ]= "Collect Secret, Eternal, Divine eggs from any zone automatically" },[ "Farm" ]={[ "SecModes" ]= "Auto Steal Modes" ,[ "TweenTitle" ]= "Auto Steal (Tween)" ,[ "TweenDesc" ]= "Smoothly fly to steal eggs continuously along the high-speed highway corridor" ;
[ "TeleportTitle" ]= "Auto Steal (Teleport)" ;
[ "TeleportDesc" ]= "Instantly warp to steal eggs in a rapid continuous loop" ,[ "SingleTitle" ]= "Single Steal (Teleport)" ,[ "SingleDesc" ]= "Teleport to steal 1 target egg and return to base" ;
[ "SecPlace" ]= "Place & Hatch" ;
[ "PlaceTitle" ]= "Place Eggs" ,[ "PlaceDesc" ]= "Fly home, place stashed eggs into open incubator stands and request hatch" ,[ "AutoPlaceTitle" ]= "Auto Place (Every 5)" ;
[ "AutoPlaceDesc" ]= "Return home every 5 steals to deposit eggs" ;
[ "HatchTitle" ]= "Auto Hatch" ,[ "HatchDesc" ]= "Continuously hatch ready eggs automatically from anywhere" ,[ "ReturnTitle" ]= "Auto Return" ,[ "ReturnDesc" ]= "Automatically fly back to safe area after stealing" ;
[ "AutoTreadmillTitle" ]= "Auto Treadmill" ,[ "AutoTreadmillDesc" ]= "Run on base treadmill when no target eggs are spawned" ,[ "UpgradeTreadmillTitle" ]= "Auto Upgrade Treadmill" ;
[ "UpgradeTreadmillDesc" ]= "Automatically upgrade base treadmill tier when you have enough cash" ;
[ "BuyTrailsTitle" ]= "Auto Buy & Equip Trails" ,[ "BuyTrailsDesc" ]= "Automatically purchase and equip the best speed trail available" ,[ "HideNotEnoughMoneyTitle" ]= "Hide 'Not Enough Money' UI" ,[ "HideNotEnoughMoneyDesc" ]= "Automatically suppress and hide the red 'Not enough money' game alert" };
[ "Character" ]={[ "SecSafety" ]= "Character & Safety" ,[ "GodmodeTitle" ]= "Godmode" ,[ "GodmodeDesc" ]= "Full immunity against map obstacles, traps, and hazards" ,[ "UnstickTitle" ]= "Get Unstuck" ;
[ "UnstickDesc" ]= "Instantly break free from treadmills, seats, or map geometry" ,[ "SecFlight" ]= "Flight Settings" ;
[ "SpeedTitle" ]= "Flight Speed" ,[ "SpeedDesc" ]= "Adjust cruise flight speed (studs/second)" };
[ "Settings" ]={[ "SecDashboard" ]= "Live Dashboard" ;
[ "DashTitle" ]= "Live Dashboard" ;
[ "DashDesc" ]= "Status: %s\nFarm Mode: %s\nCarried Eggs: %d\nFlight Speed: %d studs/s" ;
[ "SecBlacklist" ]= "Zone Preferences" ,[ "BlacklistToggleTitle" ]= "Target Zone: %s" ;
[ "BlacklistToggleDesc" ]= "Enable egg stealing in %s (Secret+ always collected)" ;
[ "SecUI" ]= "UI Customization" ,[ "TranspTitle" ]= "Window Transparency" ;
[ "TranspDesc" ]= "Adjust background transparency of the UI window (0% - 90%)" ;
[ "ThemeTitle" ]= "Select Theme" ;
[ "SecPerformance" ]= "Performance & Graphics" ,[ "PerformanceTitle" ]= "Ultra Potato Mode (Maximum FPS Boost)" ,[ "PerformanceDesc" ]= "Disables textures, meshes, lights, shadows, effects and particles for maximum FPS" ;
[ "Disable3DTitle" ]= "Disable 3D Rendering (GPU Saver 95%)" ,[ "Disable3DDesc" ]= "Freezes 3D viewport rendering to drop GPU usage to ~1%. Perfect for overnight farming!" ,[ "LangTitle" ]= "Language" ,[ "BtnTranslate" ]= "Switch to Thai" ;
[ "DescTranslate" ]= "Switch interface language to Thai" ,[ "SecSystem" ]= "System Controls" ;
[ "AntiAFKTitle" ]= "Anti-AFK (Double-Esc 10m / Mobile)" ,[ "AntiAFKDesc" ]= "Double-Esc menu pulse every 10m + Mobile touch + PC jitter resets idle timer safely without Idled" ,[ "ResetTitle" ]= "Reset Character State" ,[ "ResetDesc" ]= "Clear internal states and unlock character movement" ;
[ "RejoinTitle" ]= "Rejoin Server" ,[ "RejoinDesc" ]= "Reconnect to the same server automatically" ;
[ "UnloadTitle" ]= "Unload Script" ,[ "UnloadDesc" ]= "Completely terminate all loops and close the interface" };
[ "Notifications" ]={[ "PlaceStarted" ]= "Flying back to base to place eggs..." ;
[ "PlaceDone" ]= "Eggs placed on stands and hatch requested!" ,[ "AutoPlaceStarted" ]= "Auto Place (Every 5) enabled" ;
[ "AutoPlaceStopped" ]= "Auto Place (Every 5) disabled" ,[ "NoEggFound" ]= "No eligible eggs found matching your filter" ,[ "UnstickDone" ]= "Unstick request sent successfully!" ;
[ "TweenStarted" ]= "Auto Steal (Tween) activated" ,[ "TweenStopped" ]= "Auto Steal (Tween) deactivated" ;
[ "TeleportStarted" ]= "Auto Steal (Teleport) activated" ;
[ "TeleportStopped" ]= "Auto Steal (Teleport) deactivated" ;
[ "HatchStarted" ]= "Auto Hatch enabled" ;
[ "HatchStopped" ]= "Auto Hatch disabled" ;
[ "ReturnStarted" ]= "Auto Return enabled" ,[ "ReturnStopped" ]= "Auto Return disabled" ;
[ "AutoTreadmillStarted" ]= "Auto Treadmill enabled (Runs when idle)" ,[ "AutoTreadmillStopped" ]= "Auto Treadmill disabled" ,[ "UpgradeTreadmillStarted" ]= "Auto Upgrade Treadmill enabled" ;
[ "UpgradeTreadmillStopped" ]= "Auto Upgrade Treadmill disabled" ;
[ "BuyTrailsStarted" ]= "Auto Buy Trails enabled" ;
[ "BuyTrailsStopped" ]= "Auto Buy Trails disabled" ;
[ "HideNotEnoughMoneyStarted" ]= "Hide 'Not Enough Money' alert enabled" ,[ "HideNotEnoughMoneyStopped" ]= "Hide 'Not Enough Money' alert disabled" ,[ "GodmodeStarted" ]= "Godmode enabled" ,[ "GodmodeStopped" ]= "Godmode disabled" ,[ "PerformanceStarted" ]= "Ultra Potato Mode enabled (Textures & effects removed)" ;
[ "PerformanceStopped" ]= "Ultra Potato Mode disabled" ;
[ "Disable3DStarted" ]= "3D Rendering disabled (GPU Saver Active)" ,[ "Disable3DStopped" ]= "3D Rendering restored" ,[ "AntiAFKStarted" ]= "Anti-AFK enabled (Double-Esc 10m & Mobile support)" ,[ "AntiAFKStopped" ]= "Anti-AFK disabled" ,[ "LangSwitched" ]= "Language switched to English successfully!" }},[ "TH" ]={[ "StatusTagReady" ]= "สถานะ: พร้อมทำงาน" ,[ "Tabs" ]={[ "Farm" ]= "ระบบฟาร์ม" ;
[ "EggSelect" ]= "เลือกประเภทไข่" ,[ "Character" ]= "ตัวละคร" ;
[ "Settings" ]= "ตั้งค่า" },[ "EggSelect" ]={[ "SecZones" ]= "เลือกโซนเป้าหมาย" ,[ "SecZonesDesc" ]= "เลือกโซนที่ต้องการไปขโมยไข่ (ไข่ระดับ Secret ขึ้นไปจะไม่สนโซน)" ,[ "DropZonesTitle" ]= "โซนเป้าหมายที่เลือก" ,[ "DropZonesDesc" ]= "คลิกเพื่อเลือกโซนที่ต้องการขโมยไข่" ,[ "SecRarities" ]= "เลือกระดับความหายาก" ,[ "SecRaritiesDesc" ]= "เลือกระดับความหายากของไข่ที่ต้องการขโมย" ,[ "DropRaritiesTitle" ]= "ระดับความหายากที่เลือก" ;
[ "DropRaritiesDesc" ]= "คลิกเพื่อเลือกระดับความหายากที่ต้องการขโมย" ;
[ "AlwaysSecretPlus" ]= "เก็บไข่ Secret+ ทุกโซนเสมอ" ;
[ "AlwaysSecretPlusDesc" ]= "ขโมยไข่ระดับ Secret, Eternal, Divine ทันทีไม่ว่าจะเกิดที่โซนใด" };
[ "Farm" ]={[ "SecModes" ]= "โหมดขโมยไข่อัตโนมัติ" ,[ "TweenTitle" ]= "ขโมยไข่อัตโนมัติ (บินเร็ว)" ,[ "TweenDesc" ]= "บินไปขโมยไข่และเก็บใส่กระเป๋าอย่างต่อเนื่องตามทางด่วนความเร็วสูง" ,[ "TeleportTitle" ]= "ขโมยไข่อัตโนมัติ (วาร์ป)" ;
[ "TeleportDesc" ]= "วาร์ปไปขโมยไข่อย่างรวดเร็วและต่อเนื่อง" ,[ "SingleTitle" ]= "ขโมยไข่ใบเดียว" ,[ "SingleDesc" ]= "วาร์ปไปขโมยไข่เป้าหมาย 1 ใบแล้วกลับมาที่ฐานทันที" ;
[ "SecPlace" ]= "นำส่งและฟักไข่" ;
[ "PlaceTitle" ]= "วางไข่ในรัง" ;
[ "PlaceDesc" ]= "บินกลับบ้านและนำไข่ในตัวไปวางบนแท่นฟักที่ว่างแล้วเริ่มฟักทันที" ,[ "AutoPlaceTitle" ]= "วางไข่อัตโนมัติ (ทุก 5 ฟอง)" ,[ "AutoPlaceDesc" ]= "กลับบ้านทุกครั้งที่ขโมยครบ 5 ฟองเพื่อนำไข่ไปวาง" ;
[ "HatchTitle" ]= "ฟักไข่อัตโนมัติ" ,[ "HatchDesc" ]= "สั่งฟักไข่ที่พร้อมฟักอย่างต่อเนื่องจากทุกที่" ;
[ "ReturnTitle" ]= "บินกลับพื้นที่ปลอดภัย" ,[ "ReturnDesc" ]= "บินกลับเข้าพื้นที่ปลอดภัยอัตโนมัติหลังขโมยไข่เสร็จ" ;
[ "AutoTreadmillTitle" ]= "วิ่งลู่วิ่งอัตโนมัติ" ;
[ "AutoTreadmillDesc" ]= "ไปวิ่งบนลู่วิ่งที่บ้านอัตโนมัติเมื่อไม่มีไข่ตามที่เลือกเกิด" ;
[ "UpgradeTreadmillTitle" ]= "อัปเกรดลู่วิ่งอัตโนมัติ" ;
[ "UpgradeTreadmillDesc" ]= "อัปเกรดระดับลู่วิ่งที่บ้านอัตโนมัติทันทีที่มีเงินพอ" ;
[ "BuyTrailsTitle" ]= "ซื้อและใส่ Trail อัตโนมัติ" ,[ "BuyTrailsDesc" ]= "ซื้อเส้นทางเพิ่มความเร็วและสวมใส่อันที่ดีที่สุดอัตโนมัติเมื่อเงินพอ" ;
[ "HideNotEnoughMoneyTitle" ]= "ซ่อนแจ้งเตือนเงินไม่พอ" ;
[ "HideNotEnoughMoneyDesc" ]= "บล็อกและซ่อนข้อความสีแดง 'Not enough money' จากตัวเกมอัตโนมัติ" };
[ "Character" ]={[ "SecSafety" ]= "ความปลอดภัยและตัวละคร" ;
[ "GodmodeTitle" ]= "โหมดอมตะ" ;
[ "GodmodeDesc" ]= "ป้องกันดาเมจจากสิ่งกีดขวางและกับดัก 100%" ;
[ "UnstickTitle" ]= "แก้ตัวติด / ลงจากลู่วิ่ง" ,[ "UnstickDesc" ]= "หลุดออกจากสิ่งกีดขวางหรืออุปกรณ์ทันที" ,[ "SecFlight" ]= "การตั้งค่าการบิน" ,[ "SpeedTitle" ]= "ความเร็วการบิน" ;
[ "SpeedDesc" ]= "ปรับความเร็วในการบิน (Studs/วินาที)" };
[ "Settings" ]={[ "SecDashboard" ]= "แดชบอร์ดสถานะสด" ;
[ "DashTitle" ]= "แดชบอร์ดสถานะสด" ;
[ "DashDesc" ]= "สถานะ: %s\nโหมดฟาร์ม: %s\nจำนวนไข่ในตัว: %d ฟอง\nความเร็วการบิน: %d Studs/วิ" ;
[ "SecBlacklist" ]= "ตัวเลือกโซนที่ต้องการ" ;
[ "BlacklistToggleTitle" ]= "ขโมยในโซน: %s" ,[ "BlacklistToggleDesc" ]= "เปิด/ปิด การขโมยไข่ทั่วไปในโซน %s (ระดับ Secret+ จะเก็บเสมอ)" ;
[ "SecUI" ]= "ปรับแต่งหน้าต่าง" ;
[ "TranspTitle" ]= "ความโปร่งใสของหน้าต่าง" ,[ "TranspDesc" ]= "ปรับความโปร่งแสงของพื้นหลังหน้าต่าง (0% - 90%)" ;
[ "ThemeTitle" ]= "เลือกธีมหน้าต่าง" ;
[ "SecPerformance" ]= "ประสิทธิภาพและกราฟิก" ;
[ "PerformanceTitle" ]= "โหมดภาพกากขั้นสุด (Ultra Potato Mode)" ;
[ "PerformanceDesc" ]= "ลดกราฟิก ลบ Texture ของโมเดล ปิดเงา ปิดแสงไฟ และปิดเอฟเฟกต์ทั้งหมดเพื่อความลื่นขั้นสุด" ;
[ "Disable3DTitle" ]= "ปิดเรนเดอร์ 3D / จอดำ (ประหยัด GPU 95%)" ,[ "Disable3DDesc" ]= "หยุดประมวลผลภาพ 3D ลดภาระการ์ดจอเหลือ 1% เหมาะสำหรับเปิดฟาร์มทิ้งไว้ข้ามคืน (หน้าต่าง UI ยังทำงานปกติ)" ,[ "LangTitle" ]= "ภาษา" ;
[ "BtnTranslate" ]= "เปลี่ยนเป็นภาษาอังกฤษ" ;
[ "DescTranslate" ]= "เปลี่ยนภาษาของหน้าต่างทั้งหมดเป็นภาษาอังกฤษ" ,[ "SecSystem" ]= "จัดการระบบ" ;
[ "AntiAFKTitle" ]= "ป้องกัน AFK เตะ (กด Esc 2 ที / รองรับมือถือ)" ;
[ "AntiAFKDesc" ]= "กด Esc เปิด-ปิดเมนูอัตโนมัติทุก 10 นาที + สัญญาณ Touch มือถือ รีเซ็ตตัวนับ 20 นาที ปลอดภัยไม่แตะเกม" ;
[ "ResetTitle" ]= "รีเซ็ตสถานะตัวละคร" ;
[ "ResetDesc" ]= "ล้างสถานะภายในทั้งหมดและปลดล็อกการเคลื่อนที่ทันที" ;
[ "RejoinTitle" ]= "เข้าเซิร์ฟเวอร์ใหม่" ,[ "RejoinDesc" ]= "เชื่อมต่อกลับเข้าเซิร์ฟเวอร์เดิมใหม่อัตโนมัติ" ,[ "UnloadTitle" ]= "ปิดสคริปต์สมบูรณ์" ;
[ "UnloadDesc" ]= "หยุดการทำงานของลูปทั้งหมดและปิดหน้าต่างอย่างปลอดภัย" };
[ "Notifications" ]={[ "PlaceStarted" ]= "กำลังบินกลับบ้านเพื่อนำไข่ไปวาง..." ;
[ "PlaceDone" ]= "วางไข่บนแท่นฟักและเริ่มฟักเรียบร้อย!" ;
[ "AutoPlaceStarted" ]= "เปิดใช้งาน วางไข่อัตโนมัติ (ทุก 5 ฟอง)" ,[ "AutoPlaceStopped" ]= "ปิดใช้งาน วางไข่อัตโนมัติ" ,[ "NoEggFound" ]= "ไม่พบไข่ที่ตรงตามเงื่อนไขในขณะนี้" ;
[ "UnstickDone" ]= "ส่งคำสั่งแก้ตัวติดเรียบร้อย!" ,[ "TweenStarted" ]= "เปิดใช้งาน ขโมยไข่อัตโนมัติ (บินเร็ว)" ,[ "TweenStopped" ]= "ปิดใช้งาน ขโมยไข่อัตโนมัติ (บินเร็ว)" ;
[ "TeleportStarted" ]= "เปิดใช้งาน ขโมยไข่อัตโนมัติ (วาร์ป)" ,[ "TeleportStopped" ]= "ปิดใช้งาน ขโมยไข่อัตโนมัติ (วาร์ป)" ,[ "HatchStarted" ]= "เปิดใช้งาน ฟักไข่อัตโนมัติ" ;
[ "HatchStopped" ]= "ปิดใช้งาน ฟักไข่อัตโนมัติ" ,[ "ReturnStarted" ]= "เปิดใช้งาน บินกลับพื้นที่ปลอดภัย" ,[ "ReturnStopped" ]= "ปิดใช้งาน บินกลับพื้นที่ปลอดภัย" ;
[ "AutoTreadmillStarted" ]= "เปิดใช้งาน วิ่งลู่วิ่งอัตโนมัติ (ทำงานเมื่อว่าง)" ;
[ "AutoTreadmillStopped" ]= "ปิดใช้งาน วิ่งลู่วิ่งอัตโนมัติ" ,[ "UpgradeTreadmillStarted" ]= "เปิดใช้งาน อัปเกรดลู่วิ่งอัตโนมัติ" ,[ "UpgradeTreadmillStopped" ]= "ปิดใช้งาน อัปเกรดลู่วิ่งอัตโนมัติ" ;
[ "BuyTrailsStarted" ]= "เปิดใช้งาน ซื้อและใส่ Trail อัตโนมัติ" ;
[ "BuyTrailsStopped" ]= "ปิดใช้งาน ซื้อและใส่ Trail อัตโนมัติ" ;
[ "HideNotEnoughMoneyStarted" ]= "เปิดใช้งาน ซ่อนแจ้งเตือนเงินไม่พอ" ,[ "HideNotEnoughMoneyStopped" ]= "ปิดใช้งาน ซ่อนแจ้งเตือนเงินไม่พอ" ,[ "GodmodeStarted" ]= "เปิดใช้งาน โหมดอมตะ" ;
[ "GodmodeStopped" ]= "ปิดใช้งาน โหมดอมตะ" ,[ "PerformanceStarted" ]= "เปิดใช้งาน โหมดภาพกากขั้นสุด (ลบ Texture และแสงเงา)" ;
[ "PerformanceStopped" ]= "ปิดใช้งาน โหมดภาพกากขั้นสุด" ,[ "Disable3DStarted" ]= "เปิดใช้งาน โหมดประหยัด GPU (ปิดเรนเดอร์ 3D)" ;
[ "Disable3DStopped" ]= "คืนค่าการแสดงผล 3D ตามปกติแล้ว" ;
[ "AntiAFKStarted" ]= "เปิดใช้งาน ป้องกัน AFK (กด Esc 2 ที ทุก 10 นาที + รองรับมือถือ)" ;
[ "AntiAFKStopped" ]= "ปิดใช้งาน ป้องกัน AFK" ;
[ "LangSwitched" ]= "เปลี่ยนภาษาเป็นภาษาไทยเรียบร้อยแล้ว!" }}}
local uiRefs={}
local tabFarm,tabEggs,tabSettings,guiStateUI
local tabKeys={ "Farm" ;
"EggSelect" ;
"Character" , "Settings" }
local function statusTextFn(langTag,...)
    local isThai=(langTag== "TH" )
    if h.delivering then
        return isThai and "กำลังวางไข่" or "Placing Egg"
    elseif h.securingEgg or h.holdingEggForGuard then
        return isThai and "กำลังหยิบไข่" or "Securing Egg"
    elseif h.teleporting then
        return isThai and "กำลังวาร์ป" or "Teleporting"
    elseif h.isReturning then
        return isThai and "กำลังบินกลับ" or "Returning"
    elseif h.glidingToTarget then
        return isThai and "กำลังบินไปขโมย" or "Stealing"
    elseif h.onTreadmill or(mountAndFarm and mountAndFarm())then
        return isThai and "อยู่บนลู่วิ่ง" or "On Treadmill"
    elseif farmMode== "TWEEN" and not h.isReturning then
        return isThai and "กำลังหาไข่" or "Searching"
    elseif farmMode== "WARP" and not h.isReturning then
        return isThai and "กำลังหาไข่" or "Searching"
    else
        return isThai and "พร้อมทำงาน" or "Ready"
    end
end
local function disableAutoLoc(autoLocRoot,...) pcall(function(...)
        if autoLocRoot:IsA( "TextLabel" )or autoLocRoot:IsA( "TextButton" )or autoLocRoot:IsA( "TextBox" )then
            autoLocRoot.AutoLocalize = false
        end
        for autoLocDescIdx,autoLocDesc in ipairs(autoLocRoot:GetDescendants())do
            if autoLocDesc:IsA( "TextLabel" )or autoLocDesc:IsA( "TextButton" )or autoLocDesc:IsA( "TextBox" )then
                autoLocDesc.AutoLocalize = false
            end
        end
    end
    )
end
local function themeColors(cellText,btnTitle,btnDesc,...)
    if not cellText then
        return
    end
    pcall(function(...)
        if btnTitle and cellText.SetTitle then
            cellText:SetTitle(btnTitle)
        end
        if btnDesc and cellText.SetDesc then
            cellText:SetDesc(btnDesc)
        end
    end
    )pcall(function(...)
        if cellText.UIElements then
            if btnTitle and(cellText.UIElements.Title and cellText.UIElements.Title :IsA( "TextLabel" ))then
                cellText.UIElements.Title .AutoLocalize = false cellText.UIElements.Title .Text =btnTitle
            end
            if btnDesc and(cellText.UIElements.Desc and cellText.UIElements.Desc :IsA( "TextLabel" ))then
                cellText.UIElements.Desc .AutoLocalize = false cellText.UIElements.Desc .Text =btnDesc
            end
        end
    end
    )
end
local function setToggleColor(togObj,tintColor,accentDark,...) pcall(function(...)
        if not togObj then
            return
        end
        if togObj.UIElements and(togObj.UIElements.Title and togObj.UIElements.Title :IsA( "TextLabel" ))then
            togObj.UIElements.Title .TextColor3 =tintColor
        end
        if togObj.UIElements and togObj.UIElements.ButtonIcon then
            local btnIcon=togObj.UIElements.ButtonIcon :FindFirstChildOfClass( "ImageLabel" )or togObj.UIElements.ButtonIcon
            if btnIcon and btnIcon:IsA( "ImageLabel" )then
                btnIcon.ImageColor3 =tintColor
            end
        end
        local accentImg=nil
        if togObj.ButtonFrame and(togObj.ButtonFrame.UIElements and togObj.ButtonFrame.UIElements .Main )then
            accentImg=togObj.ButtonFrame.UIElements .Main
        elseif togObj.ToggleFrame and(togObj.ToggleFrame.UIElements and togObj.ToggleFrame.UIElements .Main )then
            accentImg=togObj.ToggleFrame.UIElements .Main
        elseif togObj.ElementFrame then
            accentImg=togObj.ElementFrame
        elseif togObj.UIElements and togObj.UIElements.Main then
            accentImg=togObj.UIElements.Main
        end
        if accentImg and accentImg:IsA( "GuiObject" )then
            local accentCorner=accentImg:FindFirstChild( "AccentCorner" )or accentImg:FindFirstChildOfClass( "UICorner" )
            if accentCorner then
                accentCorner:Destroy()
            end
            local accentStroke=accentImg:FindFirstChild( "DiceAccentStroke" )or accentImg:FindFirstChildOfClass( "UIStroke" )
            if accentStroke then
                accentStroke:Destroy()
            end
            local squircleOutline=accentImg:FindFirstChild( "AccentSquircleOutline" )
            if squircleOutline then
                squircleOutline:Destroy()
            end
            for winDescIdx,winDescChild in ipairs(accentImg:GetDescendants())do
                if winDescChild:IsA( "ImageLabel" )and((string.find (tostring(winDescChild.Image ), "117817408534198" )or string.find (winDescChild.Name :lower(), "outline" )))then
                    winDescChild.Visible = false winDescChild.ImageTransparency = 1
                end
            end
            local accentFill=accentDark
            if not accentFill then
                local hsvH,hsvS,hsvV=tintColor:ToHSV()accentFill=Color3.fromHSV (hsvH,math.clamp (hsvS* 0.4 , 0.18 , 0.45 ), 0.18 )
            end
            accentImg.ThemeTag =nil accentImg.ImageColor3 =accentFill accentImg.ImageTransparency = 0.08
        end
    end
    )
end
local function tintToggles(...) setToggleColor(uiRefs.togTween ,Color3.fromRGB ( 0 , 195 , 255 ),Color3.fromRGB ( 24 , 40 , 46 ))setToggleColor(uiRefs.togTeleport ,Color3.fromRGB ( 168 , 85 , 247 ),Color3.fromRGB ( 36 , 24 , 46 ))setToggleColor(uiRefs.btnPlaceEgg ,Color3.fromRGB ( 16 , 215 , 130 ),Color3.fromRGB ( 24 , 45 , 36 ))setToggleColor(uiRefs.togAutoPlaceEvery5 ,Color3.fromRGB ( 14 , 165 , 233 ),Color3.fromRGB ( 24 , 38 , 46 ))setToggleColor(uiRefs.togGodmode ,Color3.fromRGB ( 244 , 63 , 94 ),Color3.fromRGB ( 46 , 24 , 28 ))setToggleColor(uiRefs.btnUnstick ,Color3.fromRGB ( 249 , 115 , 22 ),Color3.fromRGB ( 46 , 32 , 24 ))setToggleColor(uiRefs.btnReset ,Color3.fromRGB ( 99 , 102 , 241 ),Color3.fromRGB ( 25 , 26 , 46 ))setToggleColor(uiRefs.btnLangSettings ,Color3.fromRGB ( 245 , 180 , 30 ),Color3.fromRGB ( 46 , 38 , 24 ))
end
local function applyLang(langReq,...)
    local langUse=langReq or langKey or "EN"
    local langTable=langTables[langUse]or langTables.EN
    local langTabs={tabFarm,tabEggs;
    tabSettings;
    guiStateUI}
    local langTabKeys={ "Farm" ;
    "EggSelect" , "Character" ;
    "Settings" }
    for cfgTabIdx,cfgTabCfg in ipairs(langTabs)do
        local tabKey=langTabKeys[cfgTabIdx]
        local cfgTabTitle=langTable.Tabs [tabKey]or tabKey
        if cfgTabCfg then
            cfgTabCfg.Title =cfgTabTitle pcall(function(...)
                if cfgTabCfg.SetTitle then
                    cfgTabCfg:SetTitle(cfgTabTitle)
                end
            end
            )pcall(function(...)
                if cfgTabCfg.UIElements and cfgTabCfg.UIElements.Main then
                    for tabDescIdx,tabDescChild in ipairs(cfgTabCfg.UIElements.Main :GetDescendants())do
                        if tabDescChild:IsA( "TextLabel" )then
                            tabDescChild.AutoLocalize = false tabDescChild.Text =cfgTabTitle
                        end
                    end
                end
                if cfgTabCfg.UIElements and cfgTabCfg.UIElements.TabItem then
                    for tabItemIdx,tabItemDesc in ipairs(cfgTabCfg.UIElements.TabItem :GetDescendants())do
                        if tabItemDesc:IsA( "TextLabel" )then
                            tabItemDesc.AutoLocalize = false tabItemDesc.Text =cfgTabTitle
                        end
                    end
                end
            end
            )
        end
    end
    pcall(function(...)
        if windUiHolder and(windUiHolder.TabModule and windUiHolder.TabModule.Tabs )then
            for windTabIdx= 1 ,#tabKeys, 1 do
                local windTabObj=windUiHolder.TabModule.Tabs [windTabIdx]
                local windTabKey=tabKeys[windTabIdx]
                local windTabTitle=langTable.Tabs [windTabKey]or windTabKey
                if windTabObj and windTabTitle then
                    windTabObj.Title =windTabTitle
                    if windTabObj.UIElements and windTabObj.UIElements.Main then
                        for windMainIdx,windMainDesc in ipairs(windTabObj.UIElements.Main :GetDescendants())do
                            if windMainDesc:IsA( "TextLabel" )then
                                windMainDesc.AutoLocalize = false windMainDesc.Text =windTabTitle
                            end
                        end
                    end
                    if windTabObj.UIElements and windTabObj.UIElements.TabItem then
                        for windTabItemIdx,windTabItemDesc in ipairs(windTabObj.UIElements.TabItem :GetDescendants())do
                            if windTabItemDesc:IsA( "TextLabel" )then
                                windTabItemDesc.AutoLocalize = false windTabItemDesc.Text =windTabTitle
                            end
                        end
                    end
                end
            end
        end
    end
    )
end
local function uiBuilder(langApplyCode,...)
    local langActive=langTables[langApplyCode]or langTables.EN applyLang(langApplyCode)themeColors(uiRefs.secModes ,langActive.Farm.SecModes )themeColors(uiRefs.togTween ,langActive.Farm.TweenTitle ,langActive.Farm.TweenDesc )themeColors(uiRefs.togTeleport ,langActive.Farm.TeleportTitle ,langActive.Farm.TeleportDesc )themeColors(uiRefs.secPlace ,langActive.Farm.SecPlace )themeColors(uiRefs.btnPlaceEgg ,langActive.Farm.PlaceTitle ,langActive.Farm.PlaceDesc )themeColors(uiRefs.togAutoPlaceEvery5 ,langActive.Farm.AutoPlaceTitle ,langActive.Farm.AutoPlaceDesc )themeColors(uiRefs.togAutoHatch ,langActive.Farm.HatchTitle ,langActive.Farm.HatchDesc )themeColors(uiRefs.togAutoReturn ,langActive.Farm.ReturnTitle ,langActive.Farm.ReturnDesc )themeColors(uiRefs.togAutoTreadmill ,langActive.Farm.AutoTreadmillTitle ,langActive.Farm.AutoTreadmillDesc )themeColors(uiRefs.togAutoUpgradeTreadmill ,langActive.Farm.UpgradeTreadmillTitle ,langActive.Farm.UpgradeTreadmillDesc )themeColors(uiRefs.togAutoBuyTrails ,langActive.Farm.BuyTrailsTitle ,langActive.Farm.BuyTrailsDesc )
    if langActive.EggSelect then
        themeColors(uiRefs.secEggZones ,langActive.EggSelect.SecZones ,langActive.EggSelect.SecZonesDesc )themeColors(uiRefs.dropTargetZones ,langActive.EggSelect.DropZonesTitle ,langActive.EggSelect.DropZonesDesc )themeColors(uiRefs.secEggRarity ,langActive.EggSelect.SecRarities ,langActive.EggSelect.SecRaritiesDesc )themeColors(uiRefs.secEggRarities ,langActive.EggSelect.SecRarities ,langActive.EggSelect.SecRaritiesDesc )themeColors(uiRefs.dropTargetRarities ,langActive.EggSelect.DropRaritiesTitle ,langActive.EggSelect.DropRaritiesDesc )themeColors(uiRefs.togAlwaysSecret ,langActive.EggSelect.AlwaysSecretPlus ,langActive.EggSelect.AlwaysSecretPlusDesc )
    end
    themeColors(uiRefs.secSafety ,langActive.Character.SecSafety )themeColors(uiRefs.togGodmode ,langActive.Character.GodmodeTitle ,langActive.Character.GodmodeDesc )themeColors(uiRefs.btnUnstick ,langActive.Character.UnstickTitle ,langActive.Character.UnstickDesc )themeColors(uiRefs.secFlight ,langActive.Character.SecFlight )themeColors(uiRefs.sliderSpeed ,langActive.Character.SpeedTitle ,langActive.Character.SpeedDesc )themeColors(uiRefs.secDashboard ,langActive.Settings.SecDashboard )themeColors(uiRefs.paraLiveDash ,langActive.Settings.DashTitle )themeColors(uiRefs.secBlacklist ,langActive.Settings.SecBlacklist )themeColors(uiRefs.secUI ,langActive.Settings.SecUI )themeColors(uiRefs.dropLang ,langActive.Settings.LangTitle )themeColors(uiRefs.sliderTransp ,langActive.Settings.TranspTitle ,langActive.Settings.TranspDesc )themeColors(uiRefs.dropTheme ,langActive.Settings.ThemeTitle )themeColors(uiRefs.secPerformance ,langActive.Settings.SecPerformance )themeColors(uiRefs.togPerformance ,langActive.Settings.PerformanceTitle ,langActive.Settings.PerformanceDesc )themeColors(uiRefs.togDisable3D ,langActive.Settings.Disable3DTitle ,langActive.Settings.Disable3DDesc )themeColors(uiRefs.secSystem ,langActive.Settings.SecSystem )themeColors(uiRefs.togAntiAFK ,langActive.Settings.AntiAFKTitle ,langActive.Settings.AntiAFKDesc )themeColors(uiRefs.btnReset ,langActive.Settings.ResetTitle ,langActive.Settings.ResetDesc )themeColors(uiRefs.btnRejoin ,langActive.Settings.RejoinTitle ,langActive.Settings.RejoinDesc )themeColors(uiRefs.btnUnload ,langActive.Settings.UnloadTitle ,langActive.Settings.UnloadDesc )tintToggles()
end
local function buildLoader(...)
    local loaderScreenGui=Instance.new ( "ScreenGui" )loaderScreenGui.Name = "Dice_LOADER_SCREEN" loaderScreenGui.ResetOnSpawn = false loaderScreenGui.DisplayOrder = 9999999 loaderScreenGui.ZIndexBehavior =Enum.ZIndexBehavior.Sibling loaderScreenGui.AutoLocalize = false pcall(function(...)
        if syn and syn.protect_gui then
            syn.protect_gui (loaderScreenGui)loaderScreenGui.Parent =game:GetService( "CoreGui" )
        else
            loaderScreenGui.Parent =LocalPlayer:FindFirstChild( "PlayerGui" )or game:GetService( "CoreGui" )
        end
    end
    )
    if not loaderScreenGui.Parent then
        loaderScreenGui.Parent =game:GetService( "CoreGui" )
    end
    local hhCardFrame=Instance.new ( "Frame" )hhCardFrame.Name = "Card" hhCardFrame.Size =UDim2.fromOffset ( 336 , 140 )hhCardFrame.Position =UDim2.new ( 0.5 , -168 , 0.5 , -70 )hhCardFrame.BackgroundColor3 =Color3.fromRGB ( 16 , 16 , 22 )hhCardFrame.BorderSizePixel = 0 hhCardFrame.Parent =loaderScreenGui;
    (Instance.new ( "UICorner" ,hhCardFrame)).CornerRadius =UDim.new ( 0 , 14 )
    local ldrStroke=Instance.new ( "UIStroke" ,hhCardFrame)ldrStroke.Color =Color3.fromRGB ( 0 , 185 , 255 )ldrStroke.Thickness = 1.4 ldrStroke.ApplyStrokeMode =Enum.ApplyStrokeMode.Border
    local hhTitleMain=Instance.new ( "TextLabel" )hhTitleMain.Size =UDim2.new ( 1 , -28 , 0 , 24 )hhTitleMain.Position =UDim2.new ( 0 , 14 , 0 , 14 )hhTitleMain.BackgroundTransparency = 1 hhTitleMain.Text = "Dice Hub" hhTitleMain.TextColor3 =Color3.fromRGB ( 245 , 248 , 255 )hhTitleMain.TextSize = 18 hhTitleMain.Font =Enum.Font.GothamBold hhTitleMain.TextXAlignment =Enum.TextXAlignment.Left hhTitleMain.AutoLocalize = false hhTitleMain.Parent =hhCardFrame
    local hhTitleSuite=Instance.new ( "TextLabel" )hhTitleSuite.Size =UDim2.new ( 1 , -28 , 0 , 16 )hhTitleSuite.Position =UDim2.new ( 0 , 14 , 0 , 38 )hhTitleSuite.BackgroundTransparency = 1 hhTitleSuite.Text = "Steal an Egg Suite v42.64" hhTitleSuite.TextColor3 =Color3.fromRGB ( 140 , 150 , 175 )hhTitleSuite.TextSize = 12 hhTitleSuite.Font =Enum.Font.Gotham hhTitleSuite.TextXAlignment =Enum.TextXAlignment.Left hhTitleSuite.AutoLocalize = false hhTitleSuite.Parent =hhCardFrame
    local hhPercentLabel=Instance.new ( "TextLabel" )hhPercentLabel.Size =UDim2.new ( 0 , 50 , 0 , 24 )hhPercentLabel.Position =UDim2.new ( 1 , -64 , 0 , 14 )hhPercentLabel.BackgroundTransparency = 1 hhPercentLabel.Text = "0%" hhPercentLabel.TextColor3 =Color3.fromRGB ( 0 , 255 , 160 )hhPercentLabel.TextSize = 14 hhPercentLabel.Font =Enum.Font.GothamBold hhPercentLabel.TextXAlignment =Enum.TextXAlignment.Right hhPercentLabel.AutoLocalize = false hhPercentLabel.Parent =hhCardFrame
    local ldrTrack=Instance.new ( "Frame" )ldrTrack.Size =UDim2.new ( 1 , -28 , 0 , 10 )ldrTrack.Position =UDim2.new ( 0 , 14 , 0 , 74 )ldrTrack.BackgroundColor3 =Color3.fromRGB ( 25 , 27 , 38 )ldrTrack.BorderSizePixel = 0 ldrTrack.Parent =hhCardFrame;
    (Instance.new ( "UICorner" ,ldrTrack)).CornerRadius =UDim.new ( 0 , 5 )
    local ldrFill=Instance.new ( "Frame" )ldrFill.Size =UDim2.new ( 0 , 0 , 1 , 0 )ldrFill.BackgroundColor3 =Color3.fromRGB ( 0 , 185 , 255 )ldrFill.BorderSizePixel = 0 ldrFill.Parent =ldrTrack;
    (Instance.new ( "UICorner" ,ldrFill)).CornerRadius =UDim.new ( 0 , 5 )
    local ldrGrad=Instance.new ( "UIGradient" ,ldrFill)ldrGrad.Color =ColorSequence.new ({ColorSequenceKeypoint.new ( 0 ,Color3.fromRGB ( 0 , 185 , 255 )),ColorSequenceKeypoint.new ( 1 ,Color3.fromRGB ( 0 , 255 , 160 ))})
    local hhInitLabel=Instance.new ( "TextLabel" )hhInitLabel.Size =UDim2.new ( 1 , -28 , 0 , 16 )hhInitLabel.Position =UDim2.new ( 0 , 14 , 0 , 94 )hhInitLabel.BackgroundTransparency = 1 hhInitLabel.Text = "Initializing Dice Hub..." hhInitLabel.TextColor3 =Color3.fromRGB ( 130 , 140 , 165 )hhInitLabel.TextSize = 11 hhInitLabel.Font =Enum.Font.Gotham hhInitLabel.TextXAlignment =Enum.TextXAlignment.Left hhInitLabel.AutoLocalize = false hhInitLabel.Parent =hhCardFrame task.spawn (function(...)
        for ldrPct= 1 , 100 , 1 do
            if not loaderScreenGui.Parent then
                break
            end
            hhPercentLabel.Text =tostring(ldrPct).. "%" ldrFill.Size =UDim2.new (ldrPct/ 100 , 0 , 1 , 0 )
            if ldrPct== 25 then
                hhInitLabel.Text = "Loading interface modules..."
            elseif ldrPct== 60 then
                hhInitLabel.Text = "Setting up auto-steal controllers..."
            elseif ldrPct== 85 then
                hhInitLabel.Text = "Syncing server telemetry..."
            elseif ldrPct== 100 then
                hhInitLabel.Text = "Ready!"
            end
            task.wait ( 0.008 )
        end
    end
    )
    local function ldrHide(ldrDoneCb,...) task.spawn (function(...) task.wait ( 0.9 )
            local ldrTween=TweenInfo.new ( 0.35 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out );
            (TweenService:Create(hhCardFrame,ldrTween,{[ "BackgroundTransparency" ]= 1 })):Play();
            (TweenService:Create(ldrStroke,ldrTween,{[ "Transparency" ]= 1 })):Play();
            (TweenService:Create(hhTitleMain,ldrTween,{[ "TextTransparency" ]= 1 })):Play();
            (TweenService:Create(hhTitleSuite,ldrTween,{[ "TextTransparency" ]= 1 })):Play();
            (TweenService:Create(hhPercentLabel,ldrTween,{[ "TextTransparency" ]= 1 })):Play();
            (TweenService:Create(ldrTrack,ldrTween,{[ "BackgroundTransparency" ]= 1 })):Play();
            (TweenService:Create(ldrFill,ldrTween,{[ "BackgroundTransparency" ]= 1 })):Play();
            (TweenService:Create(hhInitLabel,ldrTween,{[ "TextTransparency" ]= 1 })):Play()task.wait ( 0.4 )pcall(function(...) loaderScreenGui:Destroy()
            end
            )
            if ldrDoneCb then
                ldrDoneCb()
            end
        end
        )
    end
    return ldrHide
end
local restoreBar={}restoreBar.Gui =Instance.new ( "ScreenGui" )restoreBar.Gui.Name = "Dice_RESTORE_BAR" restoreBar.Gui.ResetOnSpawn = false restoreBar.Gui.DisplayOrder = 999999 restoreBar.Gui.ZIndexBehavior =Enum.ZIndexBehavior.Sibling restoreBar.Gui.AutoLocalize = false pcall(function(...)
    if syn and syn.protect_gui then
        syn.protect_gui (restoreBar.Gui )restoreBar.Gui.Parent =game:GetService( "CoreGui" )
    else
        restoreBar.Gui.Parent =LocalPlayer:FindFirstChild( "PlayerGui" )or game:GetService( "CoreGui" )
    end
end
)
if not restoreBar.Gui.Parent then
    restoreBar.Gui.Parent =game:GetService( "CoreGui" )
end
restoreBar.Btn =Instance.new ( "ImageButton" )restoreBar.Btn.Name = "Dice_SquareLogoButton" restoreBar.Btn.Size =UDim2.fromOffset ( 46 , 46 )restoreBar.Btn.Position =UDim2.new ( 0 , 20 , 0 , 20 )restoreBar.Btn.BackgroundColor3 =Color3.fromRGB ( 18 , 18 , 24 )restoreBar.Btn.Active = true restoreBar.Btn.Selectable = true restoreBar.Btn.Visible = false restoreBar.Btn.ZIndex = 999999 restoreBar.Btn.AutoLocalize = false restoreBar.Btn.Parent =restoreBar.Gui ;
(Instance.new ( "UICorner" ,restoreBar.Btn )).CornerRadius =UDim.new ( 0 , 10 )restoreBar.Stroke =Instance.new ( "UIStroke" ,restoreBar.Btn )restoreBar.Stroke.Color =Color3.fromRGB ( 0 , 185 , 255 )restoreBar.Stroke.Thickness = 1.6 restoreBar.Stroke.ApplyStrokeMode =Enum.ApplyStrokeMode.Border restoreBar.Logo =Instance.new ( "ImageLabel" ,restoreBar.Btn )restoreBar.Logo.Name = "LogoIcon" restoreBar.Logo.Size =UDim2.fromOffset ( 36 , 36 )restoreBar.Logo.Position =UDim2.new ( 0.5 , 0 , 0.5 , 0 )restoreBar.Logo.AnchorPoint =Vector2.new ( 0.5 , 0.5 )restoreBar.Logo.BackgroundTransparency = 1 restoreBar.Logo.Image =iconAsset restoreBar.Logo.ImageColor3 =Color3.fromRGB ( 255 , 255 , 255 )restoreBar.Logo.ZIndex = 1000000 ;
(Instance.new ( "UICorner" ,restoreBar.Logo )).CornerRadius =UDim.new ( 0 , 8 )restoreBar.isDragging = false restoreBar.dragStart =nil restoreBar.startPos =nil restoreBar.Btn.InputBegan :Connect(function(dragDown,...)
    if dragDown.UserInputType ==Enum.UserInputType.MouseButton1 or dragDown.UserInputType ==Enum.UserInputType.Touch then
        restoreBar.isDragging = true restoreBar.dragStart =dragDown.Position restoreBar.startPos =restoreBar.Btn.Position
    end
end
)UserInputService.InputEnded :Connect(function(dragUp,...)
    if dragUp.UserInputType ==Enum.UserInputType.MouseButton1 or dragUp.UserInputType ==Enum.UserInputType.Touch then
        restoreBar.isDragging = false
    end
end
)UserInputService.InputChanged :Connect(function(dragMove,...)
    if restoreBar.isDragging and((dragMove.UserInputType ==Enum.UserInputType.MouseMovement or dragMove.UserInputType ==Enum.UserInputType.Touch ))then
        local dragDelta=dragMove.Position -restoreBar.dragStart restoreBar.Btn.Position =UDim2.new (restoreBar.startPos.X .Scale ,restoreBar.startPos.X .Offset +dragDelta.X ,restoreBar.startPos.Y .Scale ,restoreBar.startPos.Y .Offset +dragDelta.Y )
    end
end
)
local function eggSelectFrame(...) h.alive = false pcall(disablePerfMode)pcall(stopAntiAfk)pcall(function(...) RunService:Set3dRenderingEnabled( true )
    end
    )pcall(function(...)
        local unloadEsp=Workspace:FindFirstChild( "DiceHub_EggESP" )
        if unloadEsp then
            unloadEsp:Destroy()
        end
    end
    )pcall(recoverAutoSteal)pcall(unequipAllTools)
    if restoreBar and restoreBar.Gui then
        pcall(function(...) restoreBar.Gui :Destroy()
        end
        )
    end
    if h.gui then
        pcall(function(...) h.gui :Destroy()
        end
        )
    end
    pcall(function(...)
        for coreChildIdx,coreChild in ipairs(game.CoreGui :GetChildren())do
            if coreChild.Name :find( "Dice_" )or coreChild.Name :find( "DesyncSniperUI" )or coreChild.Name :find( "WindUI" )then
                coreChild:Destroy()
            end
        end
    end
    )
end
local function buildMainUi(...)
    local loaderHideFn=buildLoader()
    local windUiLoaded=nil pcall(function(...) windUiLoaded=(loadstring(game:HttpGet( "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua" )))()
    end
    )
    local function windUiUrl(notifyArg,...)
        if not notifyArg then
            return
        end
        local notifySent= false
        if windUiLoaded and windUiLoaded.Notify then
            local notifyOk=pcall(function(...) windUiLoaded:Notify(notifyArg)notifySent= true
            end
            )
        end
        if not notifySent then
            pcall(function(...)
                (game:GetService( "StarterGui" )):SetCore( "SendNotification" ,{[ "Title" ]=tostring(notifyArg.Title or "Dice Hub" ),[ "Text" ]=tostring(notifyArg.Content or "" );
                [ "Duration" ]= 3 })
            end
            )
        end
    end
    if windUiLoaded then
        pcall(function(...)
            local windNotify=windUiLoaded.Notify
            if windNotify then
                windUiLoaded.Notify =function(notifTitle,notifContent,...)
                    local notifPcall=pcall(function(...) windNotify(notifTitle,notifContent)
                    end
                    )
                    if not notifPcall then
                        pcall(function(...)
                            (game:GetService( "StarterGui" )):SetCore( "SendNotification" ,{[ "Title" ]=tostring(notifContent and notifContent.Title or "Dice Hub" );
                            [ "Text" ]=tostring(notifContent and notifContent.Content or "" ),[ "Duration" ]= 3 })
                        end
                        )
                    end
                end
            end
        end
        )
        local winCam=workspace.CurrentCamera
        local winView=winCam and winCam.ViewportSize or Vector2.new ( 1280 , 720 )
        local winTouch=UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        local winW=winTouch and math.clamp (winView.X * 0.7 , 440 , 500 )or 500
        local winH=winTouch and math.clamp (winView.Y * 0.72 , 280 , 340 )or 340
        local winSize=UDim2.fromOffset (winW,winH)
        local windConfig=windUiLoaded:CreateWindow({[ "Title" ]= "Dice Hub" ;
        [ "Author" ]= "Steal An Egg V1" ;
        [ "Folder" ]= "Dice_StealAnEgg" ;
        [ "Icon" ]=iconAsset;
        [ "Theme" ]= "Dark" ,[ "IconSize" ]= 28 ,[ "Size" ]=winSize,[ "MinSize" ]=Vector2.new ( 400 , 240 );
        [ "MaxSize" ]=Vector2.new ( 900 , 600 ),[ "Resizable" ]= true ,[ "SideBarWidth" ]=winTouch and 140 or 160 ,[ "ToggleKey" ]=Enum.KeyCode.RightShift ;
        [ "IgnoreAlerts" ]= true ,[ "Topbar" ]={[ "Height" ]= 44 ,[ "ButtonsType" ]= "Default" }})
        windUiHolder=windConfig
        windConfig.IgnoreAlerts = true pcall(function(...)
            if windConfig.UIElements and windConfig.UIElements.Main then
                windConfig.UIElements.Main .Visible = false
            end
        end
        )
        local winTag=windConfig:Tag({[ "Title" ]= "Status: Ready" ;
        [ "Color" ]=Color3.fromRGB ( 0 , 255 , 160 ),[ "Border" ]= true })
        local winBarH= 44
        local winCollapsed= false
        local winBusy= false
        local winFullH=winH task.spawn (function(...) task.wait ( 0.1 )
            local uiThemeMain=windConfig.UIElements and windConfig.UIElements.Main
            if uiThemeMain then
                if uiThemeMain.AnchorPoint.Y ~= 0 then
                    local winElemH=uiThemeMain.Size.Y .Offset > 0 and uiThemeMain.Size.Y .Offset or winH uiThemeMain.Position =UDim2.new (uiThemeMain.Position.X .Scale ,uiThemeMain.Position.X .Offset ,uiThemeMain.Position.Y .Scale ,uiThemeMain.Position.Y .Offset -(winElemH*uiThemeMain.AnchorPoint.Y ))uiThemeMain.AnchorPoint =Vector2.new ( 0.5 , 0 )
                end
                uiThemeMain.ClipsDescendants = false disableAutoLoc(uiThemeMain)
            end
        end
        )
        local function winToggle(...)
            local uiElemMain=windConfig.UIElements and windConfig.UIElements.Main
            if not uiElemMain or winBusy then
                return
            end
            winBusy= true winCollapsed=not winCollapsed
            local uiSideBar=windConfig.UIElements.SideBarContainer
            local uiMainBar=windConfig.UIElements.MainBar
            local uiBg=uiElemMain:FindFirstChild( "Background" )
            local uiMain=uiElemMain:FindFirstChild( "Main" )
            if uiElemMain.AnchorPoint.Y ~= 0 then
                local winPrevH=uiElemMain.Size.Y .Offset > 0 and uiElemMain.Size.Y .Offset or winFullH uiElemMain.Position =UDim2.new (uiElemMain.Position.X .Scale ,uiElemMain.Position.X .Offset ,uiElemMain.Position.Y .Scale ,uiElemMain.Position.Y .Offset -(winPrevH*uiElemMain.AnchorPoint.Y ))uiElemMain.AnchorPoint =Vector2.new ( 0.5 , 0 )
            end
            local winScaleX=uiElemMain.Size.X .Scale
            local winOffX=uiElemMain.Size.X .Offset
            if winCollapsed then
                if uiElemMain.Size.Y .Offset >winBarH then
                    winFullH=uiElemMain.Size.Y .Offset
                end
                uiElemMain.ClipsDescendants = true
                if uiBg then
                    uiBg.ClipsDescendants = true
                end
                if uiMain then
                    uiMain.ClipsDescendants = true
                end
                if uiSideBar then
                    uiSideBar.Visible = false
                end
                if uiMainBar then
                    uiMainBar.Visible = false
                end
                uiElemMain.Visible = true
                if uiMain then
                    uiMain.Visible = true
                end
                local collTween=TweenService:Create(uiElemMain,TweenInfo.new ( 0.24 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out ),{[ "Size" ]=UDim2.new (winScaleX,winOffX, 0 ,winBarH)})collTween:Play()task.delay ( 0.25 ,function(...) winBusy= false
                end
                )
            else
                uiElemMain.Visible = true
                if uiMain then
                    uiMain.Visible = true
                end
                local winExpandH=winFullH or winH
                if uiSideBar then
                    uiSideBar.Visible = true
                end
                if uiMainBar then
                    uiMainBar.Visible = true
                end
                if windConfig.TabModule and windConfig.TabModule.SelectedTab then
                    pcall(function(...) windConfig.TabModule :SelectTab(windConfig.TabModule.SelectedTab )
                    end
                    )
                end
                local expandTween=TweenService:Create(uiElemMain,TweenInfo.new ( 0.24 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out ),{[ "Size" ]=UDim2.new (winScaleX,winOffX, 0 ,winExpandH)})expandTween:Play()task.delay ( 0.25 ,function(...)
                    if not winCollapsed then
                        uiElemMain.ClipsDescendants = false
                        if uiBg then
                            uiBg.ClipsDescendants = false
                        end
                        if uiMain then
                            uiMain.ClipsDescendants = false
                        end
                        if uiSideBar then
                            uiSideBar.Visible = true
                        end
                        if uiMainBar then
                            uiMainBar.Visible = true
                        end
                        if windConfig.TabModule and windConfig.TabModule.SelectedTab then
                            pcall(function(...) windConfig.TabModule :SelectTab(windConfig.TabModule.SelectedTab )
                            end
                            )
                        end
                    end
                    winBusy= false
                end
                )
            end
        end
        windConfig.Close =function(closeArg,...) winToggle()
            local closeRet={}function r.Destroy(rDestroyArg,...) eggSelectFrame()
            end
            return closeRet
        end
        local function winShow(...)
            if windConfig.UIElements and windConfig.UIElements.Main then
                (TweenService:Create(restoreBar.Btn ,TweenInfo.new ( 0.12 ,Enum.EasingStyle.Quart ),{[ "Size" ]=UDim2.fromOffset ( 42 , 42 )})):Play()task.wait ( 0.08 )restoreBar.Btn.Size =UDim2.fromOffset ( 46 , 46 )windConfig.UIElements.Main .Visible = true restoreBar.Btn.Visible = false
                if windConfig.TabModule and windConfig.TabModule.SelectedTab then
                    pcall(function(...) windConfig.TabModule :SelectTab(windConfig.TabModule.SelectedTab )
                    end
                    )
                end
            end
        end
        local function winHide(...)
            if windConfig.UIElements and windConfig.UIElements.Main then
                windConfig.UIElements.Main .Visible = false restoreBar.Btn.Visible = true
            end
        end
        restoreBar.Btn.MouseButton1Click :Connect(winShow)windConfig.Destroy =function(winDestroyArg,...) winHide()
        end
        UserInputService.InputBegan :Connect(function(keysInput,keysProcessed,...)
            if not keysProcessed and keysInput.KeyCode ==Enum.KeyCode.RightShift then
                if windConfig.UIElements and windConfig.UIElements.Main then
                    if windConfig.UIElements.Main .Visible then
                        winHide()
                    else
                        winShow()
                    end
                end
            end
        end
        )
        local function winOpac(opacVal,...)
            local opacClamp=math.clamp (tonumber(opacVal)or 0 , 0 , 90 )
            local opacFrac=opacClamp/ 100 pcall(function(...)
                local opWinMain=windConfig.UIElements and windConfig.UIElements.Main
                if not opWinMain then
                    return
                end
                if windConfig.AcrylicPaint and windConfig.AcrylicPaint.Frame then
                    windConfig.AcrylicPaint.Frame .Visible =(opacClamp== 0 )
                end
                local opWinBg=opWinMain:FindFirstChild( "Background" )
                if opWinBg then
                    if opWinBg:IsA( "ImageLabel" )then
                        opWinBg.ImageTransparency =opacFrac
                    elseif opWinBg:IsA( "Frame" )then
                        opWinBg.BackgroundTransparency =opacFrac
                    end
                end
            end
            )
        end
        local langTbl=langTables[langKey]or langTables.EN tabFarm=windConfig:Tab({[ "Title" ]=langTbl.Tabs.Farm ;
        [ "Icon" ]= "solar:box-minimalistic-bold" })tabEggs=windConfig:Tab({[ "Title" ]=langTbl.Tabs.EggSelect or "Egg Selection" ;
        [ "Icon" ]= "lucide:egg" })tabSettings=windConfig:Tab({[ "Title" ]=langTbl.Tabs.Character ;
        [ "Icon" ]= "solar:user-bold" })guiStateUI=windConfig:Tab({[ "Title" ]=langTbl.Tabs.Settings ;
        [ "Icon" ]= "solar:settings-bold" })uiRefs.secModes =tabFarm:Section({[ "Title" ]=langTbl.Farm.SecModes })
        local togGuard= false
        local togTweenRef=nil
        local togWarpRef=nil uiRefs.togTween =tabFarm:Toggle({[ "Title" ]=langTbl.Farm.TweenTitle ,[ "Desc" ]=langTbl.Farm.TweenDesc ,[ "Icon" ]= "solar:compass-bold" ;
        [ "Value" ]=h.pureTweenFarm ;
        [ "Callback" ]=function(tweenOn,...)
            if togGuard then
                return
            end
            if tweenOn then
                setFarmMode( "TWEEN" )
            else
                if farmMode== "TWEEN" or h.pureTweenFarm then
                    setFarmMode( "NONE" )
                end
            end
        end
        })togTweenRef=uiRefs.togTween uiRefs.togTeleport =tabFarm:Toggle({[ "Title" ]=langTbl.Farm.TeleportTitle ;
        [ "Desc" ]=langTbl.Farm.TeleportDesc ,[ "Icon" ]= "solar:magic-stick-3-bold" ,[ "Value" ]=h.autoFarmLoop ,[ "Callback" ]=function(teleOn,...)
            if togGuard then
                return
            end
            if teleOn then
                setFarmMode( "WARP" )
            else
                if farmMode== "WARP" or h.autoFarmLoop then
                    setFarmMode( "NONE" )
                end
            end
        end
        })togWarpRef=uiRefs.togTeleport tweenToggleFn=function(setTweenOn,...) pcall(function(...)
                if togTweenRef and togTweenRef.Set then
                    togGuard= true togTweenRef:Set(setTweenOn)togGuard= false
                end
            end
            )
        end
        warpToggleFn=function(setTeleOn,...) pcall(function(...)
                if togWarpRef and togWarpRef.Set then
                    togGuard= true togWarpRef:Set(setTeleOn)togGuard= false
                end
            end
            )
        end
        uiRefs.secPlace =tabFarm:Section({[ "Title" ]=langTbl.Farm.SecPlace })uiRefs.btnPlaceEgg =tabFarm:Button({[ "Title" ]=langTbl.Farm.PlaceTitle ,[ "Desc" ]=langTbl.Farm.PlaceDesc ,[ "Icon" ]= "solar:box-bold" ;
        [ "Callback" ]=function(...) task.spawn (function(...) windUiUrl({[ "Title" ]= "Steal An Egg V1" ,[ "Content" ]=langTables[langKey].Notifications.PlaceStarted ,[ "Icon" ]= "loader" })h.statusText = "[Manual] Tweening to base..." autoPlaceLoop(h.glideSpeed ,nil, true )windUiUrl({[ "Title" ]= "Steal An Egg V1" ,[ "Content" ]=langTables[langKey].Notifications.PlaceDone ,[ "Icon" ]= "check-circle" })
            end
            )
        end
        })uiRefs.togAutoPlaceEvery5 =tabFarm:Toggle({[ "Title" ]=langTbl.Farm.AutoPlaceTitle or "Auto Place (Every 5)" ;
        [ "Desc" ]=langTbl.Farm.AutoPlaceDesc or "Return home every 5 steals, place & wait 5s" ;
        [ "Icon" ]= "solar:box-minimalistic-bold" ;
        [ "Value" ]=h.autoPlaceEvery5 ;
        [ "Callback" ]=function(autoPlaceOn,...) h.autoPlaceEvery5 =autoPlaceOn
            if not autoPlaceOn then
                h.batchStealCount = 0
            end
            local tglNotif=langTables[langKey]or langTables.EN windUiUrl({[ "Title" ]= "Auto Place (Every 5)" ,[ "Content" ]=autoPlaceOn and((tglNotif.Notifications.AutoPlaceStarted or "Auto Place (Every 5) enabled" ))or(tglNotif.Notifications.AutoPlaceStopped or "Auto Place (Every 5) disabled" ),[ "Icon" ]=autoPlaceOn and "check-circle" or "x-circle" })
        end
        })uiRefs.togAutoHatch =tabFarm:Toggle({[ "Title" ]=langTbl.Farm.HatchTitle ;
        [ "Desc" ]=langTbl.Farm.HatchDesc ,[ "Icon" ]= "solar:star-bold" ;
        [ "Value" ]=h.autoHatch ,[ "Callback" ]=function(hatchOn,...) h.autoHatch =hatchOn windUiUrl({[ "Title" ]= "Auto Hatch" ,[ "Content" ]=hatchOn and langTables[langKey].Notifications.HatchStarted or langTables[langKey].Notifications.HatchStopped ,[ "Icon" ]=hatchOn and "check-circle" or "x-circle" })
        end
        })uiRefs.togAutoReturn =tabFarm:Toggle({[ "Title" ]=langTbl.Farm.ReturnTitle ;
        [ "Desc" ]=langTbl.Farm.ReturnDesc ;
        [ "Icon" ]= "solar:undo-left-round-bold" ,[ "Value" ]=h.autoGlide ;
        [ "Callback" ]=function(glideOn,...) h.autoGlide =glideOn windUiUrl({[ "Title" ]= "Auto Return" ;
            [ "Content" ]=glideOn and langTables[langKey].Notifications.ReturnStarted or langTables[langKey].Notifications.ReturnStopped ;
            [ "Icon" ]=glideOn and "check-circle" or "x-circle" })
        end
        })uiRefs.togAutoTreadmill =tabFarm:Toggle({[ "Title" ]=langTbl.Farm.AutoTreadmillTitle or "Auto Treadmill" ;
        [ "Desc" ]=langTbl.Farm.AutoTreadmillDesc or "Run on base treadmill when no target eggs are spawned" ;
        [ "Icon" ]= "solar:running-bold" ;
        [ "Value" ]=h.autoTreadmill ;
        [ "Callback" ]=function(treadOn,...) h.autoTreadmill =treadOn saveConfig()smartDoffTreadmill()
            if not treadOn and((h.onTreadmill or mountAndFarm()))then
                dismountTreadmill()
            end
            local tglNotif2=langTables[langKey]or langTables.EN windUiUrl({[ "Title" ]= "Auto Treadmill" ;
            [ "Content" ]=treadOn and((tglNotif2.Notifications.AutoTreadmillStarted or "Auto Treadmill enabled (Runs when idle)" ))or(tglNotif2.Notifications.AutoTreadmillStopped or "Auto Treadmill disabled" );
            [ "Icon" ]=treadOn and "check-circle" or "x-circle" })
        end
        })uiRefs.togAutoUpgradeTreadmill =tabFarm:Toggle({[ "Title" ]=langTbl.Farm.UpgradeTreadmillTitle or "Auto Upgrade Treadmill" ;
        [ "Desc" ]=langTbl.Farm.UpgradeTreadmillDesc or "Automatically upgrade base treadmill tier when you have enough cash" ;
        [ "Icon" ]= "solar:double-alt-arrow-up-bold" ;
        [ "Value" ]=h.autoUpgradeTreadmill ,[ "Callback" ]=function(upgOn,...) h.autoUpgradeTreadmill =upgOn saveConfig()
            local tglNotif3=langTables[langKey]or langTables.EN windUiUrl({[ "Title" ]=(langKey== "TH" )and "อัปเกรดลู่วิ่ง" or "Upgrade Treadmill" ,[ "Content" ]=upgOn and((tglNotif3.Notifications.UpgradeTreadmillStarted or "Auto Upgrade Treadmill enabled" ))or(tglNotif3.Notifications.UpgradeTreadmillStopped or "Auto Upgrade Treadmill disabled" ),[ "Icon" ]=upgOn and "check-circle" or "x-circle" })
        end
        })uiRefs.togAutoBuyTrails =tabFarm:Toggle({[ "Title" ]=langTbl.Farm.BuyTrailsTitle or "Auto Buy & Equip Trails" ;
        [ "Desc" ]=langTbl.Farm.BuyTrailsDesc or "Automatically purchase and equip the best speed trail available" ;
        [ "Icon" ]= "solar:fire-bold" ;
        [ "Value" ]=h.autoBuyTrails ;
        [ "Callback" ]=function(trailOn,...) h.autoBuyTrails =trailOn saveConfig()
            local tglNotif4=langTables[langKey]or langTables.EN windUiUrl({[ "Title" ]=(langKey== "TH" )and "ซื้อ Trail" or "Buy Trails" ,[ "Content" ]=trailOn and((tglNotif4.Notifications.BuyTrailsStarted or "Auto Buy Trails enabled" ))or(tglNotif4.Notifications.BuyTrailsStopped or "Auto Buy Trails disabled" );
            [ "Icon" ]=trailOn and "check-circle" or "x-circle" })
        end
        })uiRefs.secEggZones =tabEggs:Section({[ "Title" ]=(langTbl.EggSelect and langTbl.EggSelect.SecZones )or "Target Zones" })
        local zoneOpts={ "🟣 Light Dark" ;
        "🟡 Titan Temple" , "🌸 Cherry Blossom" ;
        "🌌 Cosmic" ;
        "🦖 Prehistoric" , "🌊 Abyss Ocean" , "🌋 Volcano" ;
        "❄️ Snow" ;
        "🌴 Jungle" ;
        "🏜️ Desert" , "💧 Lake" ;
        "🌲 Forest" }
        local zoneLblToName={[ "🟣 Light Dark" ]= "Light Dark" ,[ "🟡 Titan Temple" ]= "Titan Temple" ,[ "🌸 Cherry Blossom" ]= "Cherry Blossom" ,[ "🌌 Cosmic" ]= "Cosmic" ;
        [ "🦖 Prehistoric" ]= "Prehistoric" ,[ "🌊 Abyss Ocean" ]= "Abyss Ocean" ;
        [ "🌋 Volcano" ]= "Volcano" ;
        [ "❄️ Snow" ]= "Snow" ;
        [ "🌴 Jungle" ]= "Jungle" ,[ "🏜️ Desert" ]= "Desert" ,[ "💧 Lake" ]= "Lake" ,[ "🌲 Forest" ]= "Forest" }
        local zoneNameToLbl={[ "Light Dark" ]= "🟣 Light Dark" ,[ "Titan Temple" ]= "🟡 Titan Temple" ;
        [ "Cherry Blossom" ]= "🌸 Cherry Blossom" ;
        [ "Cosmic" ]= "🌌 Cosmic" ,[ "Prehistoric" ]= "🦖 Prehistoric" ;
        [ "Abyss Ocean" ]= "🌊 Abyss Ocean" ;
        [ "Volcano" ]= "🌋 Volcano" ;
        [ "Snow" ]= "❄️ Snow" ,[ "Jungle" ]= "🌴 Jungle" ,[ "Desert" ]= "🏜️ Desert" ;
        [ "Lake" ]= "💧 Lake" ,[ "Forest" ]= "🌲 Forest" }
        local zoneSelLbls={}
        for selZKey,selZVal in pairs(h.selectedZones or{})do
            if selZVal and zoneNameToLbl[selZKey]then
                table.insert (zoneSelLbls,zoneNameToLbl[selZKey])
            end
        end
        uiRefs.dropTargetZones =tabEggs:Dropdown({[ "Title" ]=(langTbl.EggSelect and langTbl.EggSelect.DropZonesTitle )or "Selected Zones" ,[ "Desc" ]=(langTbl.EggSelect and langTbl.EggSelect.DropZonesDesc )or "Click to choose which zones to farm eggs from" ,[ "Values" ]=zoneOpts,[ "Value" ]=zoneSelLbls,[ "Multi" ]= true ;
        [ "Callback" ]=function(zonePick,...)
            local zoneSel={}
            local function zoneAdd(zoneAddArg,...)
                if type(zoneAddArg)== "table" then
                    zoneAddArg=zoneAddArg.Title or zoneAddArg.Name or zoneAddArg[ 1 ]or ""
                end
                local zoneAddStr=tostring(zoneAddArg or "" )
                local zoneCanon=zoneLblToName[zoneAddStr]
                if not zoneCanon and(zoneAddStr~= "" and(zoneAddStr~= "true" and zoneAddStr~= "false" ))then
                    for zoneCapIdx,zoneName in ipairs(zoneNames)do
                        if string.find (string.lower (zoneAddStr),string.lower (zoneName))then
                            zoneCanon=zoneName
                            break
                        end
                    end
                end
                if zoneCanon and zoneOrderZ[zoneCanon]then
                    zoneSel[zoneCanon]= true
                end
            end
            if type(zonePick)== "table" then
                for zonePickKey,zonePickVal in pairs(zonePick)do
                    if type(zonePickVal)== "string" or type(zonePickVal)== "table" then
                        zoneAdd(zonePickVal)
                    elseif type(zonePickKey)== "string" and zonePickVal== true then
                        zoneAdd(zonePickKey)
                    end
                end
            elseif type(zonePick)== "string" then
                zoneAdd(zonePick)
            end
            h.selectedZones =zoneSel saveConfig()
        end
        })uiRefs.secEggRarity =tabEggs:Section({[ "Title" ]=(langTbl.EggSelect and langTbl.EggSelect.SecRarities )or "Target Rarities" })
        local rarOpts={ "👑 Divine (Tier 6)" ;
        "⚡ Eternal (Tier 5)" , "🔥 Secret (Tier 4)" , "✨ Cosmic (Tier 3)" , "🔮 Mythic (Tier 2)" ;
        "⭐ Legendary (Tier 1)" ;
        "💜 Epic" ;
        "🔷 Rare" ;
        "🟢 Uncommon" , "⚪ Common" }
        local rarLblToName={[ "👑 Divine (Tier 6)" ]= "Divine" ,[ "⚡ Eternal (Tier 5)" ]= "Eternal" ,[ "🔥 Secret (Tier 4)" ]= "Secret" ;
        [ "✨ Cosmic (Tier 3)" ]= "Cosmic" ;
        [ "🔮 Mythic (Tier 2)" ]= "Mythic" ;
        [ "⭐ Legendary (Tier 1)" ]= "Legendary" ,[ "💜 Epic" ]= "Epic" ,[ "🔷 Rare" ]= "Rare" ,[ "🟢 Uncommon" ]= "Uncommon" ,[ "⚪ Common" ]= "Common" }
        local rarNameToLbl={[ "Divine" ]= "👑 Divine (Tier 6)" ,[ "Eternal" ]= "⚡ Eternal (Tier 5)" ;
        [ "Secret" ]= "🔥 Secret (Tier 4)" ;
        [ "Cosmic" ]= "✨ Cosmic (Tier 3)" ,[ "Mythic" ]= "🔮 Mythic (Tier 2)" ,[ "Legendary" ]= "⭐ Legendary (Tier 1)" ,[ "Epic" ]= "💜 Epic" ,[ "Rare" ]= "🔷 Rare" ;
        [ "Uncommon" ]= "🟢 Uncommon" ;
        [ "Common" ]= "⚪ Common" }
        local rarSelLbls={}
        for selRKey,selRVal in pairs(h.selectedRarities or{})do
            if selRVal and rarNameToLbl[selRKey]then
                table.insert (rarSelLbls,rarNameToLbl[selRKey])
            end
        end
        uiRefs.dropTargetRarities =tabEggs:Dropdown({[ "Title" ]=(langTbl.EggSelect and langTbl.EggSelect.DropRaritiesTitle )or "Selected Rarities" ;
        [ "Desc" ]=(langTbl.EggSelect and langTbl.EggSelect.DropRaritiesDesc )or "Click to choose which rarities to collect" ,[ "Values" ]=rarOpts;
        [ "Value" ]=rarSelLbls,[ "Multi" ]= true ;
        [ "Callback" ]=function(rarPick,...)
            local rarSel={}
            local function rarAdd(rarAddArg,...)
                if type(rarAddArg)== "table" then
                    rarAddArg=rarAddArg.Title or rarAddArg.Name or rarAddArg[ 1 ]or ""
                end
                local rarAddStr=string.lower (tostring(rarAddArg or "" ))
                for rarCapIdx,rarName in ipairs(rarityNames)do
                    if string.find (rarAddStr,string.lower (rarName))then
                        rarSel[rarName]= true
                        break
                    end
                end
            end
            if type(rarPick)== "table" then
                for rarPickKey,rarPickVal in pairs(rarPick)do
                    if type(rarPickVal)== "string" or type(rarPickVal)== "table" then
                        rarAdd(rarPickVal)
                    elseif type(rarPickKey)== "string" and rarPickVal== true then
                        rarAdd(rarPickKey)
                    end
                end
            elseif type(rarPick)== "string" then
                rarAdd(rarPick)
            end
            h.selectedRarities =rarSel saveConfig()
        end
        })uiRefs.secSafety =tabSettings:Section({[ "Title" ]=langTbl.Character.SecSafety })uiRefs.togGodmode =tabSettings:Toggle({[ "Title" ]=langTbl.Character.GodmodeTitle ;
        [ "Desc" ]=langTbl.Character.GodmodeDesc ,[ "Icon" ]= "solar:shield-check-bold" ,[ "Value" ]= false ;
        [ "Callback" ]=function(godOn,...)
            if godOn then
                enableGodmode()windUiUrl({[ "Title" ]= "Godmode" ,[ "Content" ]=langTables[langKey].Notifications.GodmodeStarted ,[ "Icon" ]= "shield-check" })
            else
                disableGodmode()windUiUrl({[ "Title" ]= "Godmode" ,[ "Content" ]=langTables[langKey].Notifications.GodmodeStopped ,[ "Icon" ]= "shield-off" })
            end
        end
        })uiRefs.btnUnstick =tabSettings:Button({[ "Title" ]=langTbl.Character.UnstickTitle ,[ "Desc" ]=langTbl.Character.UnstickDesc ,[ "Icon" ]= "solar:exit-bold" ;
        [ "Callback" ]=function(...) pcall(dismountTreadmill)pcall(doffTreadmill)pcall(recoverAutoSteal)windUiUrl({[ "Title" ]= "Unstick" ;
            [ "Content" ]=langTables[langKey].Notifications.UnstickDone ,[ "Icon" ]= "check" })
        end
        })uiRefs.secFlight =tabSettings:Section({[ "Title" ]=langTbl.Character.SecFlight })uiRefs.sliderSpeed =tabSettings:Slider({[ "Title" ]=langTbl.Character.SpeedTitle ,[ "Desc" ]=langTbl.Character.SpeedDesc ,[ "Step" ]= 25 ,[ "Value" ]={[ "Min" ]= 100 ;
        [ "Max" ]= 1000 ;
        [ "Default" ]=h.glideSpeed or 600 },[ "Callback" ]=function(speedVal,...) h.glideSpeed =speedVal saveFlightSpeed(speedVal)
        end
        })uiRefs.secDashboard =guiStateUI:Section({[ "Title" ]=langTbl.Settings.SecDashboard })uiRefs.paraLiveDash =guiStateUI:Paragraph({[ "Title" ]=langTbl.Settings.DashTitle ;
        [ "Desc" ]=string.format ( "Status: Ready\nFarm Mode: Idle\nCarried Eggs: 0\nFlight Speed: %d Studs/s" ,h.glideSpeed or 600 )})uiRefs.secUI =guiStateUI:Section({[ "Title" ]=langTbl.Settings.SecUI })uiRefs.dropLang =guiStateUI:Dropdown({[ "Title" ]=langTbl.Settings.LangTitle ,[ "Values" ]={ "English" , "ไทย" },[ "Value" ]=(langKey== "EN" and "English" or "ไทย" ),[ "Callback" ]=function(langPick,...)
            local langCode=(langPick== "ไทย" )and "TH" or "EN"
            if langCode~=langKey then
                langKey=langCode uiBuilder(langKey)pcall(saveConfig)windUiUrl({[ "Title" ]=(langKey== "TH" )and "ภาษา" or "Language" ,[ "Content" ]=langTables[langKey].Notifications.LangSwitched ,[ "Icon" ]= "check-circle" })
            end
        end
        })uiRefs.sliderTransp =guiStateUI:Slider({[ "Title" ]=langTbl.Settings.TranspTitle ;
        [ "Desc" ]=langTbl.Settings.TranspDesc ;
        [ "Step" ]= 5 ;
        [ "Value" ]={[ "Min" ]= 0 ;
        [ "Max" ]= 90 ,[ "Default" ]= 0 },[ "Callback" ]=function(transpVal,...) winOpac(transpVal)
        end
        })uiRefs.dropTheme =guiStateUI:Dropdown({[ "Title" ]=langTbl.Settings.ThemeTitle ;
        [ "Values" ]={ "Dark" ;
        "Rose" , "Plant" ;
        "Red" , "Sky" , "Purple" },[ "Value" ]= "Dark" ;
        [ "Callback" ]=function(themePick,...) pcall(function(...) windUiLoaded:SetTheme(themePick)
            end
            )
        end
        })uiRefs.secPerformance =guiStateUI:Section({[ "Title" ]=(langTbl.Settings and langTbl.Settings.SecPerformance )or "Performance & Graphics" })uiRefs.togPerformance =guiStateUI:Toggle({[ "Title" ]=(langTbl.Settings and langTbl.Settings.PerformanceTitle )or "Ultra Potato Mode (Maximum FPS Boost)" ;
        [ "Desc" ]=(langTbl.Settings and langTbl.Settings.PerformanceDesc )or "Disables shadows, textures, particles, and shaders for maximum FPS smoothness" ,[ "Icon" ]= "solar:bolt-bold" ,[ "Value" ]=h.performanceMode ,[ "Callback" ]=function(perfOn,...) h.performanceMode =perfOn saveConfig()
            if perfOn then
                enablePerfMode()
            else
                disablePerfMode()
            end
            local tglNotif5=langTables[langKey]or langTables.EN windUiUrl({[ "Title" ]= "Performance Mode" ,[ "Content" ]=perfOn and((tglNotif5.Notifications.PerformanceStarted or "Performance Mode enabled" ))or(tglNotif5.Notifications.PerformanceStopped or "Performance Mode disabled" ),[ "Icon" ]=perfOn and "check-circle" or "x-circle" })
        end
        })uiRefs.togDisable3D =guiStateUI:Toggle({[ "Title" ]=(langTbl.Settings and langTbl.Settings.Disable3DTitle )or "Disable 3D Rendering (GPU Saver 95%)" ;
        [ "Desc" ]=(langTbl.Settings and langTbl.Settings.Disable3DDesc )or "Freezes 3D viewport rendering to drop GPU usage to ~1%. Perfect for overnight farming!" ;
        [ "Icon" ]= "solar:monitor-camera-bold" ;
        [ "Value" ]=h.disable3D ,[ "Callback" ]=function(d3dOn,...) h.disable3D =d3dOn saveConfig()pcall(function(...) RunService:Set3dRenderingEnabled(not d3dOn)
            end
            )
            local tglNotif6=langTables[langKey]or langTables.EN windUiUrl({[ "Title" ]= "3D Rendering" ,[ "Content" ]=d3dOn and((tglNotif6.Notifications.Disable3DStarted or "3D Rendering disabled (GPU Saver)" ))or(tglNotif6.Notifications.Disable3DStopped or "3D Rendering restored" ),[ "Icon" ]=d3dOn and "check-circle" or "x-circle" })
        end
        })uiRefs.secSystem =guiStateUI:Section({[ "Title" ]=langTbl.Settings.SecSystem })uiRefs.togAntiAFK =guiStateUI:Toggle({[ "Title" ]=(langTbl.Settings and langTbl.Settings.AntiAFKTitle )or "Anti-AFK (Double-Esc 10m / Mobile)" ,[ "Desc" ]=(langTbl.Settings and langTbl.Settings.AntiAFKDesc )or "Double-Esc menu pulse every 10m + Mobile touch + PC jitter resets idle timer safely without Idled" ;
        [ "Icon" ]= "solar:shield-check-bold" ;
        [ "Value" ]=h.antiAFK ,[ "Callback" ]=function(afkOn,...) h.antiAFK =afkOn saveConfig()
            if afkOn then
                startAntiAfk()
            else
                stopAntiAfk()
            end
            local tglNotif7=langTables[langKey]or langTables.EN windUiUrl({[ "Title" ]= "Anti-AFK" ,[ "Content" ]=afkOn and((tglNotif7.Notifications.AntiAFKStarted or "Safe Anti-AFK enabled" ))or(tglNotif7.Notifications.AntiAFKStopped or "Safe Anti-AFK disabled" ),[ "Icon" ]=afkOn and "check-circle" or "x-circle" })
        end
        })uiRefs.btnReset =guiStateUI:Button({[ "Title" ]=langTbl.Settings.ResetTitle ;
        [ "Desc" ]=langTbl.Settings.ResetDesc ,[ "Icon" ]= "solar:restart-bold" ;
        [ "Callback" ]=function(...) pcall(recoverAutoSteal)pcall(unequipAllTools)windUiUrl({[ "Title" ]= "Reset State" ;
            [ "Content" ]= "Character state reset successfully" ,[ "Icon" ]= "check-circle" })
        end
        })uiRefs.btnRejoin =guiStateUI:Button({[ "Title" ]=langTbl.Settings.RejoinTitle ;
        [ "Desc" ]=langTbl.Settings.RejoinDesc ;
        [ "Icon" ]= "solar:logout-2-bold" ,[ "Callback" ]=function(...) pcall(function(...) TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)
            end
            )
        end
        })uiRefs.btnUnload =guiStateUI:Button({[ "Title" ]=langTbl.Settings.UnloadTitle ,[ "Desc" ]=langTbl.Settings.UnloadDesc ;
        [ "Icon" ]= "solar:trash-bin-trash-bold" ,[ "Callback" ]=function(...) eggSelectFrame()
        end
        })tintToggles()task.spawn (function(...)
            while h.alive do
                pcall(function(...)
                    local carryCount=countCarriedEggs()
                    local thaiMode=(langKey== "TH" )
                    local statusNow=statusTextFn(langKey)
                    if winTag then
                        local statusColor=Color3.fromRGB ( 0 , 255 , 160 )
                        if h.securingEgg or h.teleporting then
                            statusColor=Color3.fromRGB ( 249 , 115 , 22 )
                        elseif h.isReturning or h.glidingToTarget then
                            statusColor=Color3.fromRGB ( 59 , 130 , 246 )
                        elseif h.delivering then
                            statusColor=Color3.fromRGB ( 16 , 185 , 129 )
                        end
                        pcall(function(...)
                            if winTag.SetTitle then
                                winTag:SetTitle(((thaiMode and "สถานะ: " or "Status: " ))..statusNow)
                            end
                            if winTag.SetColor then
                                winTag:SetColor(statusColor)
                            end
                        end
                        )
                    end
                    if uiRefs.paraLiveDash and uiRefs.paraLiveDash.SetDesc then
                        local farmState=thaiMode and "หยุดพัก" or "Idle"
                        if farmMode== "TWEEN" then
                            farmState=thaiMode and "ขโมยไข่ (บินเร็ว)" or "Auto Steal (Tween)"
                        elseif farmMode== "WARP" then
                            farmState=thaiMode and "ขโมยไข่ (วาร์ป)" or "Auto Steal (Teleport)"
                        end
                        local dashFmt=thaiMode and "สถานะ: %s\nโหมดฟาร์ม: %s\nจำนวนไข่ในตัว: %d ฟอง\nความเร็วบิน: %d Studs/s" or "Status: %s\nFarm Mode: %s\nCarried Eggs: %d\nFlight Speed: %d Studs/s"
                        local dashText=string.format (dashFmt,statusNow,farmState,carryCount,h.glideSpeed or 600 )pcall(function(...) uiRefs.paraLiveDash :SetDesc(dashText)
                        end
                        )
                    end
                end
                )task.wait ( 0.5 )
            end
        end
        )loaderHideFn(winShow)
        return
    end
    if h.gui then
        pcall(function(...) h.gui :Destroy()
        end
        )h.gui =nil
    end
    local sniperScreenGui=Instance.new ( "ScreenGui" )sniperScreenGui.Name = "DesyncSniperUI_v41_5" sniperScreenGui.ResetOnSpawn = false sniperScreenGui.DisplayOrder = 99999 sniperScreenGui.ZIndexBehavior =Enum.ZIndexBehavior.Sibling sniperScreenGui.AutoLocalize = false
    local fbGuiParent=LocalPlayer:FindFirstChild( "PlayerGui" )or game:GetService( "CoreGui" )pcall(function(...)
        if syn and syn.protect_gui then
            syn.protect_gui (sniperScreenGui)sniperScreenGui.Parent =game:GetService( "CoreGui" )
        else
            sniperScreenGui.Parent =fbGuiParent
        end
    end
    )
    if not sniperScreenGui.Parent then
        sniperScreenGui.Parent =fbGuiParent
    end
    h.gui =sniperScreenGui
    local fbColBg=Color3.fromRGB ( 15 , 17 , 24 )
    local fbColHeader=Color3.fromRGB ( 20 , 24 , 34 )
    local fbColCard=Color3.fromRGB ( 22 , 26 , 38 )
    local fbColBtn=Color3.fromRGB ( 28 , 33 , 48 )
    local fbColBorder=Color3.fromRGB ( 45 , 52 , 75 )
    local fbColText=Color3.fromRGB ( 240 , 243 , 255 )
    local fbColSub=Color3.fromRGB ( 140 , 148 , 170 )
    local fbColDark=Color3.fromRGB ( 38 , 43 , 60 )
    local fbColGray=Color3.fromRGB ( 150 , 158 , 180 )
    local fbColWhite=Color3.fromRGB ( 255 , 255 , 255 )
    local fbWinH= 475
    local fbHeadH= 46
    local fbCollapsed= false
    local sniperMainFrame=Instance.new ( "Frame" )sniperMainFrame.Name = "MainFrame" sniperMainFrame.Size =UDim2.new ( 0 , 330 , 0 ,fbWinH)sniperMainFrame.Position =UDim2.new ( 0.04 , 0 , 0.22 , 0 )sniperMainFrame.BackgroundColor3 =fbColBg sniperMainFrame.BorderSizePixel = 0 sniperMainFrame.Active = true sniperMainFrame.Draggable = true sniperMainFrame.ClipsDescendants = true sniperMainFrame.Parent =sniperScreenGui
    local fbCorner=Instance.new ( "UICorner" )fbCorner.CornerRadius =UDim.new ( 0 , 12 )fbCorner.Parent =sniperMainFrame
    local fbStroke=Instance.new ( "UIStroke" )fbStroke.Color =fbColBorder fbStroke.Thickness = 1.4 fbStroke.Parent =sniperMainFrame
    local sniperHeader=Instance.new ( "Frame" )sniperHeader.Name = "Header" sniperHeader.Size =UDim2.new ( 1 , 0 , 0 , 46 )sniperHeader.BackgroundColor3 =fbColHeader sniperHeader.BorderSizePixel = 0 sniperHeader.Parent =sniperMainFrame;
    (Instance.new ( "UICorner" ,sniperHeader)).CornerRadius =UDim.new ( 0 , 12 )
    local sniperFallbackTitle=Instance.new ( "TextLabel" )sniperFallbackTitle.Size =UDim2.new ( 1 , -90 , 0 , 22 )sniperFallbackTitle.Position =UDim2.new ( 0 , 12 , 0 , 6 )sniperFallbackTitle.BackgroundTransparency = 1 sniperFallbackTitle.Text = "Dice Hub (Fallback)" sniperFallbackTitle.TextColor3 =fbColText sniperFallbackTitle.TextSize = 14 sniperFallbackTitle.Font =Enum.Font.GothamBold sniperFallbackTitle.TextXAlignment =Enum.TextXAlignment.Left sniperFallbackTitle.AutoLocalize = false sniperFallbackTitle.Parent =sniperHeader
    local sniperTitle=Instance.new ( "TextLabel" )sniperTitle.Size =UDim2.new ( 1 , -90 , 0 , 14 )sniperTitle.Position =UDim2.new ( 0 , 12 , 0 , 26 )sniperTitle.BackgroundTransparency = 1 sniperTitle.Text = "Steal an Egg v42.64" sniperTitle.TextColor3 =Color3.fromRGB ( 0 , 255 , 160 )sniperTitle.TextSize = 11 sniperTitle.Font =Enum.Font.Gotham sniperTitle.TextXAlignment =Enum.TextXAlignment.Left sniperTitle.AutoLocalize = false sniperTitle.Parent =sniperHeader
    local sniperMinBtn=Instance.new ( "TextButton" )sniperMinBtn.Size =UDim2.new ( 0 , 28 , 0 , 28 )sniperMinBtn.Position =UDim2.new ( 1 , -68 , 0 , 9 )sniperMinBtn.BackgroundColor3 =fbColCard sniperMinBtn.Text = "-" sniperMinBtn.TextColor3 =fbColText sniperMinBtn.TextSize = 16 sniperMinBtn.Font =Enum.Font.GothamBold sniperMinBtn.AutoButtonColor = false sniperMinBtn.Parent =sniperHeader;
    (Instance.new ( "UICorner" ,sniperMinBtn)).CornerRadius =UDim.new ( 0 , 6 )
    local sniperCloseBtn=Instance.new ( "TextButton" )sniperCloseBtn.Size =UDim2.new ( 0 , 28 , 0 , 28 )sniperCloseBtn.Position =UDim2.new ( 1 , -36 , 0 , 9 )sniperCloseBtn.BackgroundColor3 =Color3.fromRGB ( 239 , 68 , 68 )sniperCloseBtn.Text = "X" sniperCloseBtn.TextColor3 =fbColText sniperCloseBtn.TextSize = 12 sniperCloseBtn.Font =Enum.Font.GothamBold sniperCloseBtn.AutoButtonColor = false sniperCloseBtn.Parent =sniperHeader;
    (Instance.new ( "UICorner" ,sniperCloseBtn)).CornerRadius =UDim.new ( 0 , 6 )
    local eggScroller=Instance.new ( "ScrollingFrame" )eggScroller.Size =UDim2.new ( 1 , 0 , 1 , -46 )eggScroller.Position =UDim2.new ( 0 , 0 , 0 , 46 )eggScroller.BackgroundTransparency = 1 eggScroller.BorderSizePixel = 0 eggScroller.ScrollBarThickness = 3 eggScroller.ScrollBarImageColor3 =fbColBorder eggScroller.CanvasSize =UDim2.new ( 0 , 0 , 0 , 0 )eggScroller.AutomaticCanvasSize =Enum.AutomaticSize.Y eggScroller.Parent =sniperMainFrame
    local fbLayout=Instance.new ( "UIListLayout" )fbLayout.SortOrder =Enum.SortOrder.LayoutOrder fbLayout.Padding =UDim.new ( 0 , 7 )fbLayout.Parent =eggScroller
    local fbPadding=Instance.new ( "UIPadding" )fbPadding.PaddingTop =UDim.new ( 0 , 8 )fbPadding.PaddingBottom =UDim.new ( 0 , 12 )fbPadding.PaddingLeft =UDim.new ( 0 , 10 )fbPadding.PaddingRight =UDim.new ( 0 , 10 )fbPadding.Parent =eggScroller sniperMinBtn.MouseButton1Click :Connect(function(...) fbCollapsed=not fbCollapsed sniperMinBtn.Text =fbCollapsed and "+" or "-" ;
        (TweenService:Create(sniperMainFrame,TweenInfo.new ( 0.25 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out ),{[ "Size" ]=fbCollapsed and UDim2.new ( 0 , 330 , 0 ,fbHeadH)or UDim2.new ( 0 , 330 , 0 ,fbWinH)})):Play()
    end
    )sniperCloseBtn.MouseButton1Click :Connect(function(...) eggSelectFrame()
    end
    )
    local function fbSection(secTitle,secOrder,...)
        local secFrame=Instance.new ( "Frame" )secFrame.Size =UDim2.new ( 1 , 0 , 0 , 20 )secFrame.BackgroundTransparency = 1 secFrame.LayoutOrder =secOrder secFrame.Parent =eggScroller
        local hhBackdropText=Instance.new ( "TextLabel" )hhBackdropText.Size =UDim2.new ( 1 , 0 , 1 , 0 )hhBackdropText.BackgroundTransparency = 1 hhBackdropText.Text =secTitle hhBackdropText.TextColor3 =Color3.fromRGB ( 0 , 185 , 255 )hhBackdropText.TextSize = 11 hhBackdropText.Font =Enum.Font.GothamBold hhBackdropText.TextXAlignment =Enum.TextXAlignment.Left hhBackdropText.AutoLocalize = false hhBackdropText.Parent =secFrame
        return secFrame
    end
    local function fbRowToggle(rowTitleTxt,rowDescTxt,rowOn,rowColor,rowOrder,rowCb,...)
        local rowFrame=Instance.new ( "Frame" )rowFrame.Size =UDim2.new ( 1 , 0 , 0 , 52 )rowFrame.BackgroundColor3 =fbColCard rowFrame.LayoutOrder =rowOrder rowFrame.Parent =eggScroller;
        (Instance.new ( "UICorner" ,rowFrame)).CornerRadius =UDim.new ( 0 , 8 )
        local rowTitle=Instance.new ( "TextLabel" )rowTitle.Size =UDim2.new ( 1 , -60 , 0 , 18 )rowTitle.Position =UDim2.new ( 0 , 10 , 0 , 8 )rowTitle.BackgroundTransparency = 1 rowTitle.Text =rowTitleTxt rowTitle.TextColor3 =rowColor or fbColText rowTitle.TextSize = 13 rowTitle.Font =Enum.Font.GothamBold rowTitle.TextXAlignment =Enum.TextXAlignment.Left rowTitle.AutoLocalize = false rowTitle.Parent =rowFrame
        local rowHint=Instance.new ( "TextLabel" )rowHint.Size =UDim2.new ( 1 , -60 , 0 , 16 )rowHint.Position =UDim2.new ( 0 , 10 , 0 , 26 )rowHint.BackgroundTransparency = 1 rowHint.Text =rowDescTxt rowHint.TextColor3 =fbColSub rowHint.TextSize = 10 rowHint.Font =Enum.Font.Gotham rowHint.TextXAlignment =Enum.TextXAlignment.Left rowHint.AutoLocalize = false rowHint.Parent =rowFrame
        local rowRunBtn=Instance.new ( "TextButton" )rowRunBtn.Size =UDim2.new ( 0 , 44 , 0 , 24 )rowRunBtn.Position =UDim2.new ( 1 , -54 , 0.5 , -12 )rowRunBtn.BackgroundColor3 =rowOn and rowColor or fbColDark rowRunBtn.Text = "" rowRunBtn.AutoButtonColor = false rowRunBtn.Parent =rowFrame;
        (Instance.new ( "UICorner" ,rowRunBtn)).CornerRadius =UDim.new ( 1 , 0 )
        local rowKnob=Instance.new ( "Frame" )rowKnob.Size =UDim2.new ( 0 , 18 , 0 , 18 )rowKnob.Position =rowOn and UDim2.new ( 1 , -21 , 0.5 , -9 )or UDim2.new ( 0 , 3 , 0.5 , -9 )rowKnob.BackgroundColor3 =rowOn and fbColWhite or fbColGray rowKnob.Parent =rowRunBtn;
        (Instance.new ( "UICorner" ,rowKnob)).CornerRadius =UDim.new ( 1 , 0 )
        local rowState=rowOn
        local function rowSet(rowNext,...) rowState=rowNext
            local rowTween=TweenInfo.new ( 0.18 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out );
            (TweenService:Create(rowRunBtn,rowTween,{[ "BackgroundColor3" ]=rowState and rowColor or fbColDark})):Play();
            (TweenService:Create(rowKnob,rowTween,{[ "Position" ]=rowState and UDim2.new ( 1 , -21 , 0.5 , -9 )or UDim2.new ( 0 , 3 , 0.5 , -9 );
            [ "BackgroundColor3" ]=rowState and fbColWhite or fbColGray})):Play()
        end
        rowRunBtn.MouseButton1Click :Connect(function(...)
            local rowClick=not rowState rowSet(rowClick)rowCb(rowClick)
        end
        )
        return rowSet
    end
    local function fbRunButton(runTitle,runDesc,runColor,runOrder,runCb,...)
        local runFrame=Instance.new ( "Frame" )runFrame.Size =UDim2.new ( 1 , 0 , 0 , 48 )runFrame.BackgroundColor3 =fbColCard runFrame.LayoutOrder =runOrder runFrame.Parent =eggScroller;
        (Instance.new ( "UICorner" ,runFrame)).CornerRadius =UDim.new ( 0 , 8 )
        local rowSectTitle=Instance.new ( "TextLabel" )rowSectTitle.Size =UDim2.new ( 1 , -95 , 0 , 18 )rowSectTitle.Position =UDim2.new ( 0 , 10 , 0 , 6 )rowSectTitle.BackgroundTransparency = 1 rowSectTitle.Text =runTitle rowSectTitle.TextColor3 =runColor or fbColText rowSectTitle.TextSize = 13 rowSectTitle.Font =Enum.Font.GothamBold rowSectTitle.TextXAlignment =Enum.TextXAlignment.Left rowSectTitle.AutoLocalize = false rowSectTitle.Parent =runFrame
        local rowSectHint=Instance.new ( "TextLabel" )rowSectHint.Size =UDim2.new ( 1 , -95 , 0 , 16 )rowSectHint.Position =UDim2.new ( 0 , 10 , 0 , 24 )rowSectHint.BackgroundTransparency = 1 rowSectHint.Text =runDesc rowSectHint.TextColor3 =fbColSub rowSectHint.TextSize = 10 rowSectHint.Font =Enum.Font.Gotham rowSectHint.TextXAlignment =Enum.TextXAlignment.Left rowSectHint.AutoLocalize = false rowSectHint.Parent =runFrame
        local rowSectBtn=Instance.new ( "TextButton" )rowSectBtn.Size =UDim2.new ( 0 , 78 , 0 , 30 )rowSectBtn.Position =UDim2.new ( 1 , -86 , 0.5 , -15 )rowSectBtn.BackgroundColor3 =runColor rowSectBtn.Text = "RUN" rowSectBtn.TextColor3 =Color3.fromRGB ( 255 , 255 , 255 )rowSectBtn.TextSize = 11 rowSectBtn.Font =Enum.Font.GothamBold rowSectBtn.AutoButtonColor = false rowSectBtn.Parent =runFrame;
        (Instance.new ( "UICorner" ,rowSectBtn)).CornerRadius =UDim.new ( 0 , 6 )rowSectBtn.MouseButton1Click :Connect(runCb)
    end
    fbSection( "AUTO STEAL MODES" , 10 )
    local fbGuard= false
    local fbTweenRow=nil
    local fbWarpRow=nil fbTweenRow=fbRowToggle( "Auto Steal (Tween)" , "Fly to steal eggs & auto stash into backpack" ,h.pureTweenFarm ,Color3.fromRGB ( 0 , 195 , 255 ), 11 ,function(fbTweenOn,...)
        if fbGuard then
            return
        end
        if fbTweenOn then
            setFarmMode( "TWEEN" )
        else
            if farmMode== "TWEEN" or h.pureTweenFarm then
                setFarmMode( "NONE" )
            end
        end
    end
    )fbWarpRow=fbRowToggle( "Auto Steal (Teleport)" , "Teleport to steal eggs in continuous loop" ,h.autoFarmLoop ,Color3.fromRGB ( 168 , 85 , 247 ), 12 ,function(fbWarpOn,...)
        if fbGuard then
            return
        end
        if fbWarpOn then
            setFarmMode( "WARP" )
        else
            if farmMode== "WARP" or h.autoFarmLoop then
                setFarmMode( "NONE" )
            end
        end
    end
    )tweenToggleFn=function(setFbTweenOn,...) pcall(function(...)
            if fbTweenRow then
                fbGuard= true fbTweenRow(setFbTweenOn)fbGuard= false
            end
        end
        )
    end
    warpToggleFn=function(setFbWarpOn,...) pcall(function(...)
            if fbWarpRow then
                fbGuard= true fbWarpRow(setFbWarpOn)fbGuard= false
            end
        end
        )
    end
    fbRunButton( "Single Steal (Teleport)" , "Teleport to steal 1 target egg and return" ,Color3.fromRGB ( 59 , 130 , 246 ), 13 ,function(...) task.spawn (function(...)
            if farmMode~= "NONE" then
                setFarmMode( "NONE" )task.wait ( 0.2 )
            end
            local targetEgg=pickBestEgg()
            if targetEgg then
                local tripResult=snipeLoop(targetEgg,nil)
                if tripResult then
                    pcall(unequipAllTools)
                    if h.autoGlide then
                        returnHome(h.glideSpeed )unequipAllTools()
                    end
                end
            end
        end
        )
    end
    )fbSection( "PLACE EGG" , 20 )fbRunButton( "Place Egg" , "Tween home, place all carried eggs & hatch" ,Color3.fromRGB ( 16 , 215 , 130 ), 21 ,function(...) task.spawn (function(...) h.statusText = "[Manual] Depositing eggs..." placeEggsToStand(h.glideSpeed )autoPlaceLoop()unequipAllTools()h.isReturning = false h.delivering = false
        end
        )
    end
    )fbRowToggle( "Auto Place (Every 5)" , "Return home every 5 steals, place & wait 5s" ,h.autoPlaceEvery5 ,Color3.fromRGB ( 14 , 165 , 233 ), 22 ,function(fbAutoPlaceOn,...) h.autoPlaceEvery5 =fbAutoPlaceOn
        if not fbAutoPlaceOn then
            h.batchStealCount = 0
        end
    end
    )fbRowToggle( "Auto Hatch" , "Automatically hatch ready eggs continuously" ,h.autoHatch ,Color3.fromRGB ( 16 , 185 , 129 ), 22 ,function(fbHatchOn,...) h.autoHatch =fbHatchOn
    end
    )fbRowToggle( "Auto Return" , "Automatically return to safe area after stealing" ,h.autoGlide ,Color3.fromRGB ( 245 , 158 , 11 ), 23 ,function(fbReturnOn,...) h.autoGlide =fbReturnOn
    end
    )fbRowToggle( "Auto Treadmill" , "Run on base treadmill when no target eggs are spawned" ,h.autoTreadmill ,Color3.fromRGB ( 168 , 85 , 247 ), 24 ,function(fbTreadOn,...) h.autoTreadmill =fbTreadOn saveConfig()smartDoffTreadmill()
        if not fbTreadOn and((h.onTreadmill or mountAndFarm()))then
            dismountTreadmill()
        end
    end
    )fbSection( "CHARACTER & SAFETY" , 30 )fbRowToggle( "Godmode" , "Invincible against attacks and guards" , false ,Color3.fromRGB ( 244 , 63 , 94 ), 31 ,function(fbGodOn,...)
        if fbGodOn then
            enableGodmode()
        else
            disableGodmode()
        end
    end
    )fbRunButton( "Get Out Treadmill" , "Instantly escape from treadmill or gear" ,Color3.fromRGB ( 249 , 115 , 22 ), 32 ,function(...) pcall(dismountTreadmill)pcall(doffTreadmill)pcall(recoverAutoSteal)
    end
    )fbSection( "CONTROLS & SETTINGS" , 40 )
    local sniperFlightRow=Instance.new ( "Frame" )sniperFlightRow.Size =UDim2.new ( 1 , 0 , 0 , 48 )sniperFlightRow.BackgroundColor3 =fbColCard sniperFlightRow.LayoutOrder = 41 sniperFlightRow.Parent =eggScroller;
    (Instance.new ( "UICorner" ,sniperFlightRow)).CornerRadius =UDim.new ( 0 , 8 )
    local sniperFlightLabel=Instance.new ( "TextLabel" )sniperFlightLabel.Size =UDim2.new ( 1 , -130 , 0 , 18 )sniperFlightLabel.Position =UDim2.new ( 0 , 10 , 0 , 6 )sniperFlightLabel.BackgroundTransparency = 1 sniperFlightLabel.Text = "Flight Speed" sniperFlightLabel.TextColor3 =fbColText sniperFlightLabel.TextSize = 13 sniperFlightLabel.Font =Enum.Font.GothamBold sniperFlightLabel.TextXAlignment =Enum.TextXAlignment.Left sniperFlightLabel.AutoLocalize = false sniperFlightLabel.Parent =sniperFlightRow
    local sniperLabel=Instance.new ( "TextLabel" )sniperLabel.Size =UDim2.new ( 0 , 70 , 0 , 24 )sniperLabel.Position =UDim2.new ( 1 , -80 , 0.5 , -12 )sniperLabel.BackgroundColor3 =fbColBg sniperLabel.Text =string.format ( "%d Studs/s" ,h.glideSpeed or 600 )sniperLabel.TextColor3 =Color3.fromRGB ( 0 , 255 , 160 )sniperLabel.TextSize = 11 sniperLabel.Font =Enum.Font.GothamBold sniperLabel.AutoLocalize = false sniperLabel.Parent =sniperFlightRow;
    (Instance.new ( "UICorner" ,sniperLabel)).CornerRadius =UDim.new ( 0 , 6 )
    local sniperMinusBtn=Instance.new ( "TextButton" )sniperMinusBtn.Size =UDim2.new ( 0 , 24 , 0 , 24 )sniperMinusBtn.Position =UDim2.new ( 1 , -110 , 0.5 , -12 )sniperMinusBtn.BackgroundColor3 =fbColBtn sniperMinusBtn.Text = "-" sniperMinusBtn.TextColor3 =fbColText sniperMinusBtn.TextSize = 14 sniperMinusBtn.Font =Enum.Font.GothamBold sniperMinusBtn.Parent =sniperFlightRow;
    (Instance.new ( "UICorner" ,sniperMinusBtn)).CornerRadius =UDim.new ( 0 , 6 )
    local sniperPlusBtn=Instance.new ( "TextButton" )sniperPlusBtn.Size =UDim2.new ( 0 , 24 , 0 , 24 )sniperPlusBtn.Position =UDim2.new ( 1 , -138 , 0.5 , -12 )sniperPlusBtn.BackgroundColor3 =fbColBtn sniperPlusBtn.Text = "+" sniperPlusBtn.TextColor3 =fbColText sniperPlusBtn.TextSize = 14 sniperPlusBtn.Font =Enum.Font.GothamBold sniperPlusBtn.Parent =sniperFlightRow;
    (Instance.new ( "UICorner" ,sniperPlusBtn)).CornerRadius =UDim.new ( 0 , 6 )sniperMinusBtn.MouseButton1Click :Connect(function(...) h.glideSpeed =math.max ( 100 ,((h.glideSpeed or 600 ))- 25 )sniperLabel.Text =string.format ( "%d Studs/s" ,h.glideSpeed )saveFlightSpeed(h.glideSpeed )
    end
    )sniperPlusBtn.MouseButton1Click :Connect(function(...) h.glideSpeed =math.min ( 1000 ,((h.glideSpeed or 600 ))+ 25 )sniperLabel.Text =string.format ( "%d Studs/s" ,h.glideSpeed )saveFlightSpeed(h.glideSpeed )
    end
    )fbRunButton( "Reset Character State" , "Clear velocity, cancel push & unfreeze" ,Color3.fromRGB ( 99 , 102 , 241 ), 42 ,function(...) pcall(recoverAutoSteal)pcall(unequipAllTools)
    end
    )fbRunButton( "Unload Script" , "Destroy UI and stop all background loops" ,Color3.fromRGB ( 153 , 27 , 27 ), 43 ,function(...) eggSelectFrame()
    end
    )fbSection( "EGG SELECT (ZONES & RARITIES)" , 45 )
    local sniperZoneToggleRow=Instance.new ( "TextButton" )sniperZoneToggleRow.Size =UDim2.new ( 1 , 0 , 0 , 48 )sniperZoneToggleRow.BackgroundColor3 =fbColCard sniperZoneToggleRow.LayoutOrder = 46 sniperZoneToggleRow.Text = "" sniperZoneToggleRow.AutoButtonColor = false sniperZoneToggleRow.Parent =eggScroller;
    (Instance.new ( "UICorner" ,sniperZoneToggleRow)).CornerRadius =UDim.new ( 0 , 8 )
    local function fbZoneCount(...)
        local zoneActive= 0
        for zListIdx,zName in ipairs(zoneNames)do
            if h.selectedZones and h.selectedZones [zName]then
                zoneActive=zoneActive+ 1
            end
        end
        return zoneActive
    end
    local sniperZoneTitle=Instance.new ( "TextLabel" )sniperZoneTitle.Size =UDim2.new ( 1 , -50 , 0 , 18 )sniperZoneTitle.Position =UDim2.new ( 0 , 10 , 0 , 6 )sniperZoneTitle.BackgroundTransparency = 1 sniperZoneTitle.Text =string.format ( "📍 Target Zones (%d/12 Active)" ,fbZoneCount())sniperZoneTitle.TextColor3 =Color3.fromRGB ( 0 , 220 , 255 )sniperZoneTitle.TextSize = 13 sniperZoneTitle.Font =Enum.Font.GothamBold sniperZoneTitle.TextXAlignment =Enum.TextXAlignment.Left sniperZoneTitle.AutoLocalize = false sniperZoneTitle.Parent =sniperZoneToggleRow
    local sniperZoneHint=Instance.new ( "TextLabel" )sniperZoneHint.Size =UDim2.new ( 1 , -50 , 0 , 16 )sniperZoneHint.Position =UDim2.new ( 0 , 10 , 0 , 26 )sniperZoneHint.BackgroundTransparency = 1 sniperZoneHint.Text = "Click to expand / collapse zone selection" sniperZoneHint.TextColor3 =fbColSub sniperZoneHint.TextSize = 10 sniperZoneHint.Font =Enum.Font.Gotham sniperZoneHint.TextXAlignment =Enum.TextXAlignment.Left sniperZoneHint.AutoLocalize = false sniperZoneHint.Parent =sniperZoneToggleRow
    local sniperZoneChevron=Instance.new ( "TextLabel" )sniperZoneChevron.Size =UDim2.new ( 0 , 30 , 0 , 30 )sniperZoneChevron.Position =UDim2.new ( 1 , -38 , 0.5 , -15 )sniperZoneChevron.BackgroundTransparency = 1 sniperZoneChevron.Text = "▼" sniperZoneChevron.TextColor3 =fbColSub sniperZoneChevron.TextSize = 12 sniperZoneChevron.Font =Enum.Font.GothamBold sniperZoneChevron.Parent =sniperZoneToggleRow
    local sniperRowFrame=Instance.new ( "Frame" )sniperRowFrame.Size =UDim2.new ( 1 , 0 , 0 , 0 )sniperRowFrame.BackgroundColor3 =Color3.fromRGB ( 18 , 20 , 28 )sniperRowFrame.LayoutOrder = 47 sniperRowFrame.Visible = false sniperRowFrame.ClipsDescendants = true sniperRowFrame.Parent =eggScroller;
    (Instance.new ( "UICorner" ,sniperRowFrame)).CornerRadius =UDim.new ( 0 , 8 )
    local fbZoneGrid=Instance.new ( "UIGridLayout" )fbZoneGrid.CellSize =UDim2.new ( 0.48 , 0 , 0 , 32 )fbZoneGrid.CellPadding =UDim2.new ( 0.04 , 0 , 0 , 6 )fbZoneGrid.SortOrder =Enum.SortOrder.LayoutOrder fbZoneGrid.Parent =sniperRowFrame;
    (Instance.new ( "UIPadding" ,sniperRowFrame)).PaddingTop =UDim.new ( 0 , 8 )sniperRowFrame.UIPadding.PaddingBottom =UDim.new ( 0 , 8 )sniperRowFrame.UIPadding.PaddingLeft =UDim.new ( 0 , 8 )sniperRowFrame.UIPadding.PaddingRight =UDim.new ( 0 , 8 )
    local fbZoneBtns={}
    for zBtnIdx,zBtnName in ipairs(zoneNames)do
        local eggCheckBtn=Instance.new ( "TextButton" )eggCheckBtn.LayoutOrder =zBtnIdx eggCheckBtn.Font =Enum.Font.GothamBold eggCheckBtn.TextSize = 11 eggCheckBtn.AutoButtonColor = false eggCheckBtn.AutoLocalize = false ;
        (Instance.new ( "UICorner" ,eggCheckBtn)).CornerRadius =UDim.new ( 0 , 6 )
        local function zBtnRefresh(...)
            local zBtnSel=h.selectedZones and h.selectedZones [zBtnName]== true
            if zBtnSel then
                eggCheckBtn.BackgroundColor3 =zoneColors[zBtnName]or Color3.fromRGB ( 59 , 130 , 246 )eggCheckBtn.TextColor3 =Color3.new ( 1 , 1 , 1 )eggCheckBtn.Text = "✓ " ..zBtnName
            else
                eggCheckBtn.BackgroundColor3 =Color3.fromRGB ( 28 , 32 , 44 )eggCheckBtn.TextColor3 =Color3.fromRGB ( 140 , 150 , 170 )eggCheckBtn.Text =zBtnName
            end
        end
        zBtnRefresh()eggCheckBtn.MouseButton1Click :Connect(function(...)
            if not h.selectedZones then
                h.selectedZones ={}
            end
            h.selectedZones [zBtnName]=not((h.selectedZones [zBtnName]== true ))zBtnRefresh()saveConfig()sniperZoneTitle.Text =string.format ( "📍 Target Zones (%d/12 Active)" ,fbZoneCount())
        end
        )eggCheckBtn.Parent =sniperRowFrame fbZoneBtns[zBtnName]=eggCheckBtn
    end
    local fbZoneExp= false sniperZoneToggleRow.MouseButton1Click :Connect(function(...) fbZoneExp=not fbZoneExp sniperRowFrame.Visible =fbZoneExp sniperRowFrame.Size =fbZoneExp and UDim2.new ( 1 , 0 , 0 , 240 )or UDim2.new ( 1 , 0 , 0 , 0 )sniperZoneChevron.Text =fbZoneExp and "▲" or "▼"
    end
    )
    local function fbRarCount(...)
        local rarActive= 0
        for rListIdx,rName in ipairs(rarityNames)do
            if h.selectedRarities and h.selectedRarities [rName]then
                rarActive=rarActive+ 1
            end
        end
        return rarActive
    end
    local sniperRarityToggleRow=Instance.new ( "TextButton" )sniperRarityToggleRow.Size =UDim2.new ( 1 , 0 , 0 , 48 )sniperRarityToggleRow.BackgroundColor3 =fbColCard sniperRarityToggleRow.LayoutOrder = 48 sniperRarityToggleRow.Text = "" sniperRarityToggleRow.AutoButtonColor = false sniperRarityToggleRow.Parent =eggScroller;
    (Instance.new ( "UICorner" ,sniperRarityToggleRow)).CornerRadius =UDim.new ( 0 , 8 )
    local sniperRarityTitle=Instance.new ( "TextLabel" )sniperRarityTitle.Size =UDim2.new ( 1 , -50 , 0 , 18 )sniperRarityTitle.Position =UDim2.new ( 0 , 10 , 0 , 6 )sniperRarityTitle.BackgroundTransparency = 1 sniperRarityTitle.Text =string.format ( "🥚 Target Rarities (%d/%d Active)" ,fbRarCount(),#rarityNames)sniperRarityTitle.TextColor3 =Color3.fromRGB ( 255 , 180 , 0 )sniperRarityTitle.TextSize = 13 sniperRarityTitle.Font =Enum.Font.GothamBold sniperRarityTitle.TextXAlignment =Enum.TextXAlignment.Left sniperRarityTitle.AutoLocalize = false sniperRarityTitle.Parent =sniperRarityToggleRow
    local sniperRarityHint=Instance.new ( "TextLabel" )sniperRarityHint.Size =UDim2.new ( 1 , -50 , 0 , 16 )sniperRarityHint.Position =UDim2.new ( 0 , 10 , 0 , 26 )sniperRarityHint.BackgroundTransparency = 1 sniperRarityHint.Text = "Click to expand / collapse rarity selection" sniperRarityHint.TextColor3 =fbColSub sniperRarityHint.TextSize = 10 sniperRarityHint.Font =Enum.Font.Gotham sniperRarityHint.TextXAlignment =Enum.TextXAlignment.Left sniperRarityHint.AutoLocalize = false sniperRarityHint.Parent =sniperRarityToggleRow
    local sniperRarityChevron=Instance.new ( "TextLabel" )sniperRarityChevron.Size =UDim2.new ( 0 , 30 , 0 , 30 )sniperRarityChevron.Position =UDim2.new ( 1 , -38 , 0.5 , -15 )sniperRarityChevron.BackgroundTransparency = 1 sniperRarityChevron.Text = "▼" sniperRarityChevron.TextColor3 =fbColSub sniperRarityChevron.TextSize = 12 sniperRarityChevron.Font =Enum.Font.GothamBold sniperRarityChevron.Parent =sniperRarityToggleRow
    local eggRowFrame=Instance.new ( "Frame" )eggRowFrame.Size =UDim2.new ( 1 , 0 , 0 , 0 )eggRowFrame.BackgroundColor3 =Color3.fromRGB ( 18 , 20 , 28 )eggRowFrame.LayoutOrder = 49 eggRowFrame.Visible = false eggRowFrame.ClipsDescendants = true eggRowFrame.Parent =eggScroller;
    (Instance.new ( "UICorner" ,eggRowFrame)).CornerRadius =UDim.new ( 0 , 8 )
    local fbRarGrid=Instance.new ( "UIGridLayout" )fbRarGrid.CellSize =UDim2.new ( 0.48 , 0 , 0 , 32 )fbRarGrid.CellPadding =UDim2.new ( 0.04 , 0 , 0 , 6 )fbRarGrid.SortOrder =Enum.SortOrder.LayoutOrder fbRarGrid.Parent =eggRowFrame;
    (Instance.new ( "UIPadding" ,eggRowFrame)).PaddingTop =UDim.new ( 0 , 8 )eggRowFrame.UIPadding.PaddingBottom =UDim.new ( 0 , 8 )eggRowFrame.UIPadding.PaddingLeft =UDim.new ( 0 , 8 )eggRowFrame.UIPadding.PaddingRight =UDim.new ( 0 , 8 )
    for rBtnIdx,rBtnName in ipairs(rarityNames)do
        local eggCheckBtn2=Instance.new ( "TextButton" )eggCheckBtn2.LayoutOrder =rBtnIdx eggCheckBtn2.Font =Enum.Font.GothamBold eggCheckBtn2.TextSize = 11 eggCheckBtn2.AutoButtonColor = false eggCheckBtn2.AutoLocalize = false ;
        (Instance.new ( "UICorner" ,eggCheckBtn2)).CornerRadius =UDim.new ( 0 , 6 )
        local function rBtnRefresh(...)
            local rBtnSel=h.selectedRarities and h.selectedRarities [rBtnName]== true
            if rBtnSel then
                eggCheckBtn2.BackgroundColor3 =rarityColors[rBtnName]or Color3.fromRGB ( 249 , 115 , 22 )eggCheckBtn2.TextColor3 =Color3.new ( 1 , 1 , 1 )eggCheckBtn2.Text = "✓ " ..rBtnName
            else
                eggCheckBtn2.BackgroundColor3 =Color3.fromRGB ( 28 , 32 , 44 )eggCheckBtn2.TextColor3 =Color3.fromRGB ( 140 , 150 , 170 )eggCheckBtn2.Text =rBtnName
            end
        end
        rBtnRefresh()eggCheckBtn2.MouseButton1Click :Connect(function(...)
            if not h.selectedRarities then
                h.selectedRarities ={}
            end
            h.selectedRarities [rBtnName]=not((h.selectedRarities [rBtnName]== true ))rBtnRefresh()saveConfig()sniperRarityTitle.Text =string.format ( "🥚 Target Rarities (%d/%d Active)" ,fbRarCount(),#rarityNames)
        end
        )eggCheckBtn2.Parent =eggRowFrame
    end
    local fbRarExp= false sniperRarityToggleRow.MouseButton1Click :Connect(function(...) fbRarExp=not fbRarExp eggRowFrame.Visible =fbRarExp eggRowFrame.Size =fbRarExp and UDim2.new ( 1 , 0 , 0 , 160 )or UDim2.new ( 1 , 0 , 0 , 0 )sniperRarityChevron.Text =fbRarExp and "▲" or "▼"
    end
    )loaderHideFn(function(...) sniperMainFrame.Visible = true
    end
    )
end
Log( "[+] Initializing Dice Hub x WindUI v42.64 (Steal an Egg Edition)..." )buildMainUi()task.spawn (function(...) task.wait ( 0.5 )swapHumanoidAntiDesync()setGodmode( true )doffTreadmill()
    if LocalPlayer.Character then
        lockRigJoints(LocalPlayer.Character )
    end
    unequipAllTools()Log( "[+] Auto Humanoid Swap & Rigid Joint Locking Active." )
end
)LocalPlayer.CharacterAdded :Connect(function(newChar,...) task.wait ( 0.6 )
    if h.alive then
        recoverAutoSteal()smartDoffTreadmill()doffTreadmill()swapHumanoidAntiDesync()setGodmode( true )lockRigJoints(newChar)unequipAllTools()
    end
end
)
if h.performanceMode then
    task.spawn (enablePerfMode)
end
if h.disable3D then
    pcall(function(...) RunService:Set3dRenderingEnabled( false )
    end
    )
end
if h.antiAFK then
    task.spawn (startAntiAfk)
end
Log( "[+] Dice Hub v42.64 Ready! All-In-One Built-in Anti-AFK & Prometheus Ready!" )
