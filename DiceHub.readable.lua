local v0_1=game:GetService( "Players" )
local v0_2=game:GetService( "Workspace" )
local v0_3=game:GetService( "RunService" )
local v0_4=game:GetService( "TweenService" )
local v0_5=game:GetService( "UserInputService" )
local v0_6=game:GetService( "ReplicatedStorage" )
local v0_7=game:GetService( "ProximityPromptService" )
local v0_8=game:GetService( "HttpService" )
local v0_9=game:GetService( "TeleportService" )
local v0_10=v0_1.LocalPlayer
local v0_11=nil
local v0_12="EN"
local v0_13=typeof(checkcaller)=="function" and checkcaller or function() return false end
local v0_14=typeof(newcclosure)=="function" and newcclosure or function(v2_1) return v2_1 end
local v0_15=game:GetService( "ProximityPromptService" )pcall(function(...) v0_15.PromptButtonHoldBegan :Connect(function(v4_1,...) pcall(function(...)
            if typeof(fireproximityprompt)== "function" then
                fireproximityprompt(v4_1)
            end
        end
        )
    end
    )
end
)
local v0_16=function(...)
end
local v0_17=function(...)
end
local v0_18=nil pcall(function(...) v0_18=require((v0_6:WaitForChild( "Client" , 5 )):WaitForChild( "EggState" , 5 ))
end
)
if not v0_18 then
    pcall(function(...) v0_18=require(v0_6.Client.EggState )
    end
    )
end
local v0_19=nil pcall(function(...) v0_19=require(((v0_6:WaitForChild( "Shared" , 5 )):WaitForChild( "Util" , 5 )):WaitForChild( "AssetItems" , 5 ))
end
)
if not v0_19 then
    pcall(function(...) v0_19=require(v0_6.Shared.Util .AssetItems )
    end
    )
end
local v0_20=nil pcall(function(...) v0_20=require((v0_6:WaitForChild( "Shared" , 5 )):WaitForChild( "Remotes" , 5 ))
end
)
if not v0_20 then
    pcall(function(...) v0_20=require(v0_6.Shared.Remotes )
    end
    )
end
local function v0_21(v18_1,v18_2,...)
    local v18_3=(v0_6:FindFirstChild( "Packages" )and v0_6.Packages :FindFirstChild( "Networking" ))or v0_6:FindFirstChild( "Network" )or v0_6
    local v18_4=v18_3:FindFirstChild(v18_1)or v0_6:FindFirstChild(v18_1)
    if v18_4 then
        return v18_4
    end
    local v18_5=v18_3:FindFirstChild(v18_1, true )or v0_6:FindFirstChild(v18_1, true )
    if v18_5 then
        return v18_5
    end
    if v18_2 then
        local v21_1=v18_3:FindFirstChild(v18_2)or v0_6:FindFirstChild(v18_2)
        if v21_1 then
            return v21_1
        end
        local v21_2=v18_3:FindFirstChild(v18_2, true )or v0_6:FindFirstChild(v18_2, true )
        if v21_2 then
            return v21_2
        end
    end
    local v18_6=string.match (v18_1, "[^/]+$" )
    if v18_6 then
        local v24_1=v18_3:FindFirstChild(v18_6, true )or v0_6:FindFirstChild(v18_6, true )
        if v24_1 then
            return v24_1
        end
    end
    return nil
end

local v0_22=v0_21( "RF/EggWorld/AskPlaceEgg" , "AskPlaceEgg" ) 
local v0_23=v0_21( "RF/EggWorld/AskLiveSnapshot" , "AskLiveSnapshot" ) 
local v0_24=v0_21( "RF/Homestead/AskState" , "RF/Plots/AskState" )or v0_21( "AskState" )
local v0_25=v0_21( "RF/EggWorld/AskFieldEggCarry" , "AskFieldEggCarry" ) 
local v0_26=v0_21( "RF/EggWorld/AskFieldEggSnapshot" , "AskFieldEggSnapshot" )or v0_21( "Eggs: RequestAreaEggSnapshot" , "RequestAreaEggSnapshot" )
local v0_27=v0_21( "RF/EggWorld/AskHatch" , "AskHatch" )or v0_21( "Eggs: RequestHatchEgg" )
local v0_28=v0_21( "RF/EggWorld/AskFinishHatch" , "AskFinishHatch" )or v0_21( "Eggs: RequestCompleteHatchEgg" )
local v0_29=v0_21( "RE/GuardPatrol/ForestStrike" , "ForestStrike" )or(v0_20 and(v0_20.GuardPatrol and v0_20.GuardPatrol.ForestStrike ))
local v0_30=v0_21( "SpeedTollOffer" , "RE/GuardPatrol/SpeedTollOffer" )or(v0_20 and(v0_20.GuardPatrol and v0_20.GuardPatrol.SpeedTollOffer ))
local v0_31=v0_21( "RF/Treadmill/AskDoff" , "AskDoff" )
local v0_32=v0_21( "RF/Treadmill/AskDon" , "AskDon" )or v0_21( "RF/Treadmill/AskMount" , "AskMount" )
local v0_33=v0_21( "RF/Treadmill/AskTierRaise" , "Treadmills: RequestUpgrade" , "AskTierRaise" )
local v0_34=v0_21( "RF/Trailwear/AskPurchase" , "Trailwear: RequestPurchase" , "AskPurchase" )
local v0_35=v0_21( "RF/Trailwear/AskChoose" , "Trailwear: RequestEquip" , "AskChoose" )
local v0_36=v0_21( "RF/Trailwear/AskDoff" , "Trailwear: RequestUnequip" , "AskDoff" )v0_16(string.format ( "[RemoteCheck] Carry: %s | Snapshot: %s | Place: %s | Hatch: %s | FinishHatch: %s | Strike: %s | Toll: %s | Doff: %s" ,tostring(v0_25~=nil),tostring(v0_26~=nil),tostring(v0_22~=nil),tostring(v0_27~=nil),tostring(v0_28~=nil),tostring(v0_29~=nil),tostring(v0_30~=nil),tostring(v0_31~=nil)))

local v0_37={[ "Light Dark" ]= 1300 ,[ "LightDark" ]= 1300 ;
[ "Titan Temple" ]= 1100 ,[ "Cherry Blossom" ]= 1000 ,[ "Cosmic" ]= 900 ;
[ "Prehistoric" ]= 800 ;
[ "Abyss Ocean" ]= 700 ,[ "Volcano" ]= 600 ;
[ "Snow" ]= 500 ,[ "Jungle" ]= 400 ;
[ "Desert" ]= 300 ,[ "Lake" ]= 200 ;
[ "Forest" ]= 100 }
local v0_38={ "Light Dark" ;
"Titan Temple" ;
"Cherry Blossom" , "Cosmic" ;
"Prehistoric" , "Abyss Ocean" ;
"Volcano" ;
"Snow" , "Jungle" , "Desert" , "Lake" ;
"Forest" }
local v0_39={[ "Light Dark" ]= 420 ,[ "LightDark" ]= 420 ;
[ "Titan Temple" ]= 380 ,[ "Cherry Blossom" ]= 330 ,[ "Cosmic" ]= 280 ;
[ "Prehistoric" ]= 240 ,[ "Abyss Ocean" ]= 200 ;
[ "Volcano" ]= 180 ;
[ "Snow" ]= 160 ,[ "Jungle" ]= 140 ;
[ "Desert" ]= 130 ,[ "Lake" ]= 125 ,[ "Forest" ]= 125 }
local v0_40= -360
local v0_41= 525
local v0_42= 620
local v0_43= 130
local v0_44=CFrame.new ( 4773.7587890625 , 70.392112731934 , -315.73501586914 )

local v0_45= "DiceHub_FlightSpeed.txt"
local v0_46= "DiceHub_EggSelectConfig.json"
local v0_47={[ "Light Dark" ]=Color3.fromRGB ( 168 , 85 , 247 ),[ "Titan Temple" ]=Color3.fromRGB ( 245 , 158 , 11 );
[ "Cherry Blossom" ]=Color3.fromRGB ( 236 , 72 , 153 );
[ "Cosmic" ]=Color3.fromRGB ( 6 , 182 , 212 ),[ "Prehistoric" ]=Color3.fromRGB ( 16 , 185 , 129 ),[ "Abyss Ocean" ]=Color3.fromRGB ( 59 , 130 , 246 );
[ "Volcano" ]=Color3.fromRGB ( 239 , 68 , 68 ),[ "Snow" ]=Color3.fromRGB ( 147 , 197 , 253 ),[ "Jungle" ]=Color3.fromRGB ( 34 , 197 , 94 ),[ "Desert" ]=Color3.fromRGB ( 234 , 179 , 8 ),[ "Lake" ]=Color3.fromRGB ( 20 , 184 , 166 ),[ "Forest" ]=Color3.fromRGB ( 22 , 163 , 74 )}

local v0_48={ "Divine" , "Eternal" , "Secret" ;
"Cosmic" , "Mythic" , "Legendary" ;
"Epic" ;
"Rare" ;
"Uncommon" ;
"Common" }
local v0_49={[ "Divine" ]=Color3.fromRGB ( 244 , 63 , 94 );
[ "Eternal" ]=Color3.fromRGB ( 217 , 70 , 239 ),[ "Secret" ]=Color3.fromRGB ( 249 , 115 , 22 ),[ "Cosmic" ]=Color3.fromRGB ( 6 , 182 , 212 ),[ "Mythic" ]=Color3.fromRGB ( 139 , 92 , 246 ),[ "Legendary" ]=Color3.fromRGB ( 251 , 191 , 36 );
[ "Epic" ]=Color3.fromRGB ( 168 , 85 , 247 );
[ "Rare" ]=Color3.fromRGB ( 59 , 130 , 246 );
[ "Uncommon" ]=Color3.fromRGB ( 34 , 197 , 94 ),[ "Common" ]=Color3.fromRGB ( 148 , 163 , 184 )}
local v0_50={[ "Divine" ]= 6 ;
[ "Eternal" ]= 5 ;
[ "Secret" ]= 4 ,[ "Cosmic" ]= 3 ;
[ "Mythic" ]= 2 ;
[ "Legendary" ]= 1 ,[ "Epic" ]= 0.5 ,[ "Rare" ]= 0.3 ,[ "Uncommon" ]= 0.1 ;
[ "Common" ]= 0 }
local v0_51
local function v0_52(...)
    local v26_1= 600 pcall(function(...)
        local v27_1= false
        if isfile then
            v27_1=isfile(v0_45)
        elseif readfile then
            local v29_1,v29_2=pcall(readfile,v0_45)v27_1=v29_1 and(v29_2~=nil)
        end
        if v27_1 and readfile then
            local v30_1=readfile(v0_45)
            local v30_2=tonumber(v30_1)
            if v30_2 and(v30_2>= 100 and v30_2<= 1000 )then
                v26_1=math.floor (v30_2)
            end
        end
    end
    )
    return v26_1
end
local function v0_53(v32_1,...) pcall(function(...)
        if writefile then
            local v34_1=math.clamp (math.floor (tonumber(v32_1)or 600 ), 100 , 1000 )writefile(v0_45,tostring(v34_1))
        end
    end
    )
end
local function v0_54(...)
    local v35_1=nil pcall(function(...)
        local v36_1= false
        if isfile then
            v36_1=isfile(v0_46)
        elseif readfile then
            local v38_1,v38_2=pcall(readfile,v0_46)v36_1=v38_1 and(v38_2~=nil)
        end
        if v36_1 and(readfile and v0_8)then
            local v39_1=readfile(v0_46)
            if v39_1 and v39_1~= "" then
                local v40_1=v0_8:JSONDecode(v39_1)
                if type(v40_1)== "table" then
                    v35_1=v40_1
                end
            end
        end
    end
    )
    local v35_2={[ "Light Dark" ]= true ,[ "Titan Temple" ]= true ,[ "Cherry Blossom" ]= true ;
    [ "Cosmic" ]= false ;
    [ "Prehistoric" ]= false ,[ "Abyss Ocean" ]= false ;
    [ "Volcano" ]= false ,[ "Snow" ]= false ;
    [ "Jungle" ]= false ,[ "Desert" ]= false ;
    [ "Lake" ]= false ,[ "Forest" ]= false }
    local v35_3={[ "Divine" ]= true ,[ "Eternal" ]= true ,[ "Secret" ]= true ,[ "Cosmic" ]= true ,[ "Mythic" ]= true ;
    [ "Legendary" ]= false ,[ "Epic" ]= false ,[ "Rare" ]= false ;
    [ "Uncommon" ]= false ;
    [ "Common" ]= false }
    if type(v35_1)~= "table" then
        v35_1={[ "selectedZones" ]=v35_2;
        [ "selectedRarities" ]=v35_3,[ "alwaysCollectSecretPlus" ]= true ,[ "minRarityTier" ]= 2 ;
        [ "autoTreadmill" ]= true ;
        [ "autoUpgradeTreadmill" ]= true ,[ "autoBuyTrails" ]= true ;
        [ "hideNotEnoughMoney" ]= true ;
        [ "performanceMode" ]= false ,[ "disable3D" ]= false ,[ "antiAFK" ]= true ,[ "language" ]= "EN" }
    else
        if type(v35_1.selectedZones )~= "table" then
            v35_1.selectedZones =v35_2
        end
        if type(v35_1.selectedRarities )~= "table" then
            v35_1.selectedRarities =v35_3
        else
            for v47_1,v47_2 in ipairs(v0_48)do
                if v35_1.selectedRarities [v47_2]==nil then
                    v35_1.selectedRarities [v47_2]=(v35_3[v47_2]== true )
                end
            end
        end
        if v35_1.alwaysCollectSecretPlus ==nil then
            v35_1.alwaysCollectSecretPlus = true
        end
        if v35_1.minRarityTier ==nil then
            v35_1.minRarityTier = 2
        end
        if v35_1.autoTreadmill ==nil then
            v35_1.autoTreadmill = true
        end
        if v35_1.autoUpgradeTreadmill ==nil then
            v35_1.autoUpgradeTreadmill = true
        end
        if v35_1.autoBuyTrails ==nil then
            v35_1.autoBuyTrails = true
        end
        if v35_1.hideNotEnoughMoney ==nil then
            v35_1.hideNotEnoughMoney = true
        end
        if v35_1.performanceMode ==nil then
            v35_1.performanceMode = false
        end
        if v35_1.disable3D ==nil then
            v35_1.disable3D = false
        end
        if v35_1.antiAFK ==nil then
            v35_1.antiAFK = true
        end
        if v35_1.language and((v35_1.language == "EN" or v35_1.language == "TH" ))then
            v0_12=v35_1.language
        end
    end
    return v35_1
end
local function v0_55(...) pcall(function(...)
        if writefile and(v0_8 and v0_51)then
            local v61_1={[ "selectedZones" ]=v0_51.selectedZones or{};
            [ "selectedRarities" ]=v0_51.selectedRarities or{};
            [ "alwaysCollectSecretPlus" ]=(v0_51.alwaysCollectSecretPlus ~= false ),[ "minRarityTier" ]=v0_51.minRarityTier or 2 ,[ "autoTreadmill" ]=(v0_51.autoTreadmill == true );
            [ "autoUpgradeTreadmill" ]=(v0_51.autoUpgradeTreadmill == true ),[ "autoBuyTrails" ]=(v0_51.autoBuyTrails == true );
            [ "hideNotEnoughMoney" ]=(v0_51.hideNotEnoughMoney == true );
            [ "performanceMode" ]=(v0_51.performanceMode == true );
            [ "disable3D" ]=(v0_51.disable3D == true );
            [ "antiAFK" ]=(v0_51.antiAFK == true );
            [ "language" ]=v0_12 or "EN" }
            local v61_2=v0_8:JSONEncode(v61_1)writefile(v0_46,v61_2)
        end
    end
    )
end
local v0_56=v0_54()v0_51={[ "godmode" ]= true ,[ "autoGlide" ]= true ,[ "autoHatch" ]= true ;
[ "autoPlaceEvery5" ]= false ;
[ "batchStealCount" ]= 0 ,[ "isBatchPlacing" ]= false ,[ "isHatching" ]= false ;
[ "autoFarmLoop" ]= false ,[ "pureTweenFarm" ]= false ;
[ "glidingToTarget" ]= false ;
[ "securingEgg" ]= false ,[ "glideSpeed" ]=v0_52();
[ "selectedZones" ]=v0_56.selectedZones ;
[ "selectedRarities" ]=v0_56.selectedRarities ;
[ "alwaysCollectSecretPlus" ]=v0_56.alwaysCollectSecretPlus ,[ "minRarityTier" ]=v0_56.minRarityTier ,[ "autoTreadmill" ]=(v0_56.autoTreadmill ~= false );
[ "autoUpgradeTreadmill" ]=(v0_56.autoUpgradeTreadmill ~= false ),[ "autoBuyTrails" ]=(v0_56.autoBuyTrails ~= false ),[ "hideNotEnoughMoney" ]= true ;
[ "performanceMode" ]=(v0_56.performanceMode == true ),[ "disable3D" ]=(v0_56.disable3D == true ),[ "antiAFK" ]=(v0_56.antiAFK ~= false ),[ "onTreadmill" ]= false ,[ "lastTreadmillMount" ]= 0 ,[ "laneZ" ]= -360 ,[ "swapped" ]= false ;
[ "teleporting" ]= false ,[ "isReturning" ]= false ;
[ "delivering" ]= false ,[ "holdingEggForGuard" ]= false ,[ "currentTargetModel" ]=nil,[ "targetPosition" ]=nil;
[ "stateTime" ]=os.clock (),[ "statusText" ]= "Ready" ,[ "bestEggInfo" ]= "Scanning..." ;
[ "gui" ]=nil;
[ "alive" ]= true ,[ "plot" ]=nil;
[ "pen" ]=nil,[ "origin" ]=nil;
[ "tread" ]=nil}
local v0_57
local v0_58
local v0_59
local v0_60
local v0_61
local v0_62
local v0_63
local v0_64
local v0_65
local v0_66
local v0_67
local v0_68
local v0_69
local v0_70
local v0_71
local v0_72
local v0_73
local v0_74
local v0_75
local v0_76
local v0_77
local v0_78
local v0_79
local v0_80
local v0_81
local v0_82
local v0_83
local v0_84
local v0_85
local v0_86
local v0_87
local v0_88
local v0_89
local v0_90
local v0_91
local v0_92
local v0_93
local v0_94
local v0_95
local v0_96
local v0_97
local v0_98
local v0_99
local v0_100={}
local v0_101= 0
local v0_102=nil
local v0_103
local v0_104= 0
local v0_105= "NONE"
local v0_106
local v0_107=nil
local v0_108=nil pcall(function(...)
    local v62_1=game:GetService( "Lighting" );
    (v62_1:GetPropertyChangedSignal( "ClockTime" )):Connect(function(...) v0_100={}v0_101= 0
    end
    )
end
)pcall(function(...)
    local function v64_1(v65_1,...)
        if v65_1:IsA( "RemoteEvent" )then
            local v66_1=string.lower (v65_1.Name )
            if string.find (v66_1, "reset" )or string.find (v66_1, "night" )or string.find (v66_1, "spawn" )or string.find (v66_1, "countdown" )then
                pcall(function(...) v65_1.OnClientEvent :Connect(function(...) v0_100={}v0_101= 0
                    end
                    )
                end
                )
            end
        end
    end
    for v70_1,v70_2 in ipairs(v0_6:GetDescendants())do
        v64_1(v70_2)
    end
    v0_6.DescendantAdded :Connect(v64_1)
end
)v0_57=function(v71_1,...)
    if not v71_1 or not v71_1:IsA( "Tool" )then
        return false
    end
    local v71_2=string.lower (v71_1.Name )
    if string.find (v71_2, "sword" )or string.find (v71_2, "radar" )or string.find (v71_2, "basket" )or string.find (v71_2, "punch" )then
        return false
    end
    if v71_1:GetAttribute( "EggUid" )or v71_1:GetAttribute( "UID" )or string.find (v71_2, "egg" )or v71_1:GetAttribute( "Category" )or v71_1:GetAttribute( "ItemType" )== "Egg" then
        return true
    end
    return false
end
v0_58=function(...)
    local v75_1=v0_10.Character
    if v75_1 then
        for v77_1,v77_2 in ipairs(v75_1:GetChildren())do
            if v0_57(v77_2)then
                local v78_1=v77_2:GetAttribute( "UID" )or v77_2:GetAttribute( "EggUid" )
                return v77_2,v78_1 or v77_2.Name
            end
        end
    end
    return nil,nil
end
v0_59=function(...)
    local v79_1=v0_10:FindFirstChild( "Backpack" )
    if v79_1 then
        for v81_1,v81_2 in ipairs(v79_1:GetChildren())do
            if v0_57(v81_2)then
                local v82_1=v81_2:GetAttribute( "UID" )or v81_2:GetAttribute( "EggUid" )
                return v81_2,v82_1 or v81_2.Name
            end
        end
    end
    return nil,nil
end
v0_60=function(...)
    local v83_1= 0
    local v83_2=v0_10:FindFirstChild( "Backpack" )
    if v83_2 then
        for v85_1,v85_2 in ipairs(v83_2:GetChildren())do
            if v0_57(v85_2)then
                v83_1=v83_1+ 1
            end
        end
    end
    local v83_3=v0_10.Character
    if v83_3 then
        for v88_1,v88_2 in ipairs(v83_3:GetChildren())do
            if v0_57(v88_2)then
                v83_1=v83_1+ 1
            end
        end
    end
    return v83_1
end
v0_61=function(v90_1,...)
    if not v90_1 and not((v0_51.pureTweenFarm or v0_51.autoFarmLoop or v0_51.teleporting ))then
        return
    end
    local v90_2=v0_10.Character
    local v90_3=v90_2 and v90_2:FindFirstChildOfClass( "Humanoid" )
    local v90_4=v0_10:FindFirstChild( "Backpack" )
    if v90_3 then
        pcall(function(...) v90_3:UnequipTools()
        end
        )
    end
    if v90_2 and v90_4 then
        for v95_1,v95_2 in ipairs(v90_2:GetChildren())do
            if v95_2:IsA( "Tool" )then
                pcall(function(...) v95_2.Parent =v90_4
                end
                )
            end
        end
    end
end
v0_62=function(v98_1,...)
    if((v0_51.pureTweenFarm or v0_51.autoFarmLoop ))and not v0_51.holdingEggForGuard then
        local v99_1=v0_58()
        if v99_1 then
            pcall(v0_61)
        end
        return false
    end
    local v98_2,v98_3=v0_58()
    if v98_2 then
        if v98_1 then
            if v98_3==v98_1 or not v98_3 then
                return true
            end
        else
            return true
        end
    end
    local v98_4=v0_10.Character
    local v98_5=v98_4 and v98_4:FindFirstChild( "HumanoidRootPart" )
    if v98_5 and v98_5.Position.X <=(v0_41+ 15 )then
        return false
    end
    if v0_18 and v0_18.ReadFieldEggs then
        local v106_1,v106_2=pcall(v0_18.ReadFieldEggs )
        if v106_1 and(v106_2 and v106_2.Records )then
            for v108_1,v108_2 in ipairs(v106_2.Records )do
                if((v108_2.State == "Carried" or v108_2.State == 2 ))and((v108_2.CarrierUserId ==v0_10.UserId or v108_2.Carrier ==v0_10.UserId ))then
                    if v98_1 then
                        if v108_2.Uid ==v98_1 then
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
v0_63=function(v113_1,...)
    local v113_2,v113_3=v0_58()
    if v113_2 then
        if not v113_1 or v113_3==v113_1 or not v113_3 then
            return true
        end
    end
    local v113_4=v0_10:FindFirstChild( "Backpack" )
    if v113_4 then
        for v117_1,v117_2 in ipairs(v113_4:GetChildren())do
            if v0_57(v117_2)then
                local v118_1=v117_2:GetAttribute( "UID" )or v117_2:GetAttribute( "EggUid" )
                if not v113_1 or v118_1==v113_1 or v117_2.Name ==tostring(v113_1)then
                    return true
                end
            end
        end
    end
    if v113_1 and(v0_18 and v0_18.ReadFieldEggs )then
        local v120_1,v120_2=pcall(v0_18.ReadFieldEggs )
        if v120_1 and(v120_2 and v120_2.Records )then
            for v122_1,v122_2 in ipairs(v120_2.Records )do
                if v122_2.Uid ==v113_1 then
                    if(v122_2.State == "Carried" or v122_2.State == 2 )then
                        local v124_1=v122_2.CarrierUserId or v122_2.Carrier
                        if v124_1==v0_10.UserId then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end
local v0_109= false
local function v0_110(...)
    if v0_109 then
        return
    end
    local v126_1=v0_26 or v0_6:FindFirstChild( "RF/EggWorld/AskFieldEggSnapshot" , true )or v0_6:FindFirstChild( "AskFieldEggSnapshot" , true )or v0_6:FindFirstChild( "Eggs: RequestAreaEggSnapshot" , true )
    if not v126_1 or not v126_1:IsA( "RemoteFunction" )then
        return
    end
    v0_109= true task.spawn (function(...)
        local v129_1,v129_2=pcall(function(...)
            return v126_1:InvokeServer()
        end
        )
        if v129_1 and type(v129_2)== "table" then
            local v131_1={}
            local v131_2=v129_2.Records or v129_2
            if type(v131_2)== "table" then
                for v133_1,v133_2 in pairs(v131_2)do
                    if type(v133_2)== "table" then
                        if not v133_2.Uid and type(v133_1)== "string" then
                            v133_2.Uid =v133_1
                        end
                        table.insert (v131_1,v133_2)
                    end
                end
            end
            if#v131_1> 0 then
                v0_102=v131_1 v0_101=os.clock ()
            end
        end
        v0_109= false
    end
    )
end
task.spawn (function(...)
    while true do
        task.wait ( 1.5 )pcall(v0_110)
    end
end
)function h4(v139_1,...)
    local v139_2=os.clock ()
    if v139_1 or(v139_2-v0_101>= 1.5 )or not v0_102 then
        v0_110()
    end
    local v139_3=((v0_102 and#v0_102> 0 ))and v0_102 or nil
    local v139_4=nil
    if v0_18 and v0_18.ReadFieldEggs then
        local v141_1,v141_2=pcall(v0_18.ReadFieldEggs )
        if v141_1 and type(v141_2)== "table" then
            local v142_1={}
            local v142_2=v141_2.Records or v141_2
            if type(v142_2)== "table" then
                for v144_1,v144_2 in pairs(v142_2)do
                    if type(v144_2)== "table" then
                        if not v144_2.Uid and type(v144_1)== "string" then
                            v144_2.Uid =v144_1
                        end
                        table.insert (v142_1,v144_2)
                    end
                end
            end
            if#v142_1> 0 then
                v139_4=v142_1
            end
        end
    end
    local v139_5={}
    local v139_6={}
    if v139_3 then
        for v149_1,v149_2 in ipairs(v139_3)do
            if v149_2.Uid then
                v139_6[v149_2.Uid ]= true table.insert (v139_5,v149_2)
            end
        end
    end
    if v139_4 then
        for v152_1,v152_2 in ipairs(v139_4)do
            if v152_2.Uid and not v139_6[v152_2.Uid ]then
                v139_6[v152_2.Uid ]= true table.insert (v139_5,v152_2)
            end
        end
    end
    local v139_7=v0_2:FindFirstChild( "AreaEggSlotsClient" )
    if v139_7 then
        for v155_1,v155_2 in ipairs(v139_7:GetChildren())do
            local v155_3=v155_2.Name
            if v155_3 and v155_3~= "" then
                local v156_1=v155_2:GetPivot()
                local v156_2=v156_1.Position
                if v156_2.X >= 530 and not string.find (tostring(v155_3), "FirstArea" )then
                    if not v139_6[v155_3]then
                        v139_6[v155_3]= true
                        local v158_1=v155_2:GetAttribute( "Category" )or v155_2:GetAttribute( "AssetCategory" )or v155_2.Name
                        local v158_2=v155_2:GetAttribute( "AreaId" )or v155_2:GetAttribute( "Area" )
                        local v158_3=v155_2:GetAttribute( "Rarity" )or v155_2:GetAttribute( "RarityTier" )
                        local v158_4=v155_2:GetAttribute( "RarityRank" )or v155_2:GetAttribute( "Rank" )
                        local v158_5=v155_2:GetAttribute( "Income" )or v155_2:GetAttribute( "EarningRate" )
                        local v158_6=v155_2:GetAttribute( "Scale" )or v155_2:GetAttribute( "AssetScale" )or 1
                        local v158_7=v155_2:GetAttribute( "Mutations" )or v155_2:GetAttribute( "Mutation" )table.insert (v139_5,{[ "Uid" ]=v155_3,[ "AssetCategory" ]=v158_1,[ "AreaId" ]=v158_2;
                        [ "Rarity" ]=v158_3,[ "Rank" ]=v158_4,[ "Income" ]=v158_5,[ "BoundsCFrame" ]=v156_1;
                        [ "BottomCFrame" ]=v156_1,[ "CFrame" ]=v156_1;
                        [ "State" ]= "Slot" ;
                        [ "AssetScale" ]=v158_6,[ "Mutations" ]=v158_7,[ "PhysicalModel" ]=v155_2})
                    else
                        for v160_1,v160_2 in ipairs(v139_5)do
                            if v160_2.Uid ==v155_3 then
                                v160_2.PhysicalModel =v155_2
                                if not v160_2.BoundsCFrame then
                                    v160_2.BoundsCFrame =v156_1
                                end
                                if not v160_2.AreaId or v160_2.AreaId == "" or v160_2.AreaId == "Unknown" then
                                    v160_2.AreaId =v155_2:GetAttribute( "AreaId" )or v155_2:GetAttribute( "Area" )
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return v139_5
end
v0_64=function(v164_1,...)
    if not v164_1 then
        return false , "NoUid"
    end
    local v164_2=v0_103( false )
    if v164_2 and#v164_2> 0 then
        for v167_1,v167_2 in ipairs(v164_2)do
            if v167_2.Uid ==v164_1 then
                if(v167_2.State == "Carried" or v167_2.State == 2 )then
                    local v169_1=v167_2.CarrierUserId or v167_2.Carrier
                    if v169_1 and v169_1==v0_10.UserId then
                        return true , "CarriedBySelf"
                    else
                        return false , "CarriedByOther"
                    end
                end
                if(v167_2.State == "Slot" or v167_2.State == "Dropped" or v167_2.State == "GuardCarried" or v167_2.State == 1 )then
                    return true , "Available"
                end
                local v168_1=v167_2.CarrierUserId or v167_2.Carrier
                if v168_1 then
                    if v168_1==v0_10.UserId then
                        return true , "CarriedBySelf"
                    else
                        return false , "CarriedByOther"
                    end
                end
                return true , "Available"
            end
        end
    end
    local v164_3=v0_2:FindFirstChild( "AreaEggSlotsClient" )
    if v164_3 then
        for v177_1,v177_2 in ipairs(v164_3:GetChildren())do
            if v177_2.Name ==tostring(v164_1)or v177_2:GetAttribute( "UID" )==v164_1 or v177_2:GetAttribute( "Uid" )==v164_1 then
                return true , "Available"
            end
        end
    end
    return true , "Unchecked"
end
v0_65=function(...)
    local v179_1,v179_2=v0_58()
    if not v179_2 then
        local v180_1,v180_2=v0_59()v179_2=v180_2
    end
    if not v179_2 then
        return false
    end
    if v0_18 and v0_18.ReadFieldEggs then
        local v182_1,v182_2=pcall(v0_18.ReadFieldEggs )
        if v182_1 and(v182_2 and v182_2.Records )then
            for v184_1,v184_2 in ipairs(v182_2.Records )do
                if v184_2.Uid ==v179_2 then
                    local v185_1=tostring(v184_2.AreaId or "" )
                    if v185_1== "Lake" or string.find (string.lower (v185_1), "lake" )~=nil then
                        return true
                    end
                end
            end
        end
    end
    if string.find (string.lower (tostring(v179_2)), "lake" )~=nil then
        return true
    end
    return false
end
v0_66=function(...)
    local v188_1,v188_2=v0_58()
    if not v188_2 then
        local v189_1,v189_2=v0_59()v188_2=v189_2
    end
    if not v188_2 then
        return v0_51.glideSpeed or 350
    end
    if v0_18 and v0_18.ReadFieldEggs then
        local v191_1,v191_2=pcall(v0_18.ReadFieldEggs )
        if v191_1 and(v191_2 and v191_2.Records )then
            for v193_1,v193_2 in ipairs(v191_2.Records )do
                if v193_2.Uid ==v188_2 and v193_2.AreaId then
                    return v0_39[v193_2.AreaId ]or v0_51.glideSpeed or 350
                end
            end
        end
    end
    return v0_51.glideSpeed or 350
end
v0_67=function(v195_1,v195_2,...) v195_2=v195_2 or 8
    local v195_3=Instance.new ( "Part" )v195_3.Name = "SafetyFloorPad_AntiVoid" v195_3.Size =Vector3.new ( 28 , 1.5 , 28 )v195_3.Position =v195_1-Vector3.new ( 0 , 3.2 , 0 )v195_3.Anchored = true v195_3.Transparency = 1 v195_3.CanCollide = true v195_3.Parent =v0_2 task.delay (v195_2,function(...) pcall(function(...) v195_3:Destroy()
        end
        )
    end
    )
    return v195_3
end
v0_68=function(v198_1,...)
    if v0_29 and v198_1 then
        pcall(function(...)
            local v200_1=v0_10.Character
            local v200_2=v200_1 and v200_1:FindFirstChild( "HumanoidRootPart" )
            local v200_3=v200_2 and(v200_2.CFrame *CFrame.new ( 0 , 0 , -3 ))or CFrame.new ()
            if v0_29:IsA( "RemoteFunction" )then
                v0_29:InvokeServer({[ "EggUid" ]=v198_1,[ "GuardCFrame" ]=v200_3})
            else
                v0_29:FireServer({[ "EggUid" ]=v198_1;
                [ "GuardCFrame" ]=v200_3})
            end
        end
        )
    end
end
if typeof(hookmetamethod)== "function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked = true
    local v203_1 v203_1=hookmetamethod(game, "__newindex" ,v0_14(function(v204_1,v204_2,v204_3,...)
        if not v0_13()and typeof(v204_1)== "Instance" then
            if v204_1:IsA( "Motor6D" )and(v204_2== "Enabled" and v204_3== false )then
                return nil
            end
            if v204_1:IsA( "Humanoid" )then
                if v204_2== "PlatformStand" and v204_3== true then
                    return nil
                end
                if v204_2== "Sit" and(v204_3== true and((v0_51.pureTweenFarm or v0_51.autoFarmLoop or v0_51.isReturning or v0_51.glidingToTarget )))then
                    return nil
                end
            end
        end
        return v203_1(v204_1,v204_2,v204_3)
    end
    ))
end
v0_96=function(v210_1,...) v210_1=v210_1 or v0_10.Character
    if not v210_1 then
        return
    end
    local v210_2=v210_1:FindFirstChild( "HumanoidRootPart" )
    local v210_3=v210_1:FindFirstChild( "Torso" )or v210_1:FindFirstChild( "UpperTorso" )or v210_2
    if not v210_3 then
        return
    end
    for v213_1,v213_2 in ipairs(v210_1:GetDescendants())do
        if v213_2:IsA( "BallSocketConstraint" )or v213_2:IsA( "HingeConstraint" )or v213_2:IsA( "NoCollisionConstraint" )then
            pcall(function(...) v213_2:Destroy()
            end
            )
        end
    end
    for v216_1,v216_2 in ipairs(v210_1:GetDescendants())do
        if v216_2:IsA( "Motor6D" )and(v216_2.Part0 and v216_2.Part1 )then
            v216_2.Enabled = true
            local v217_1= "RigidJointWeld_" ..v216_2.Name
            local v217_2=v216_2.Part1 :FindFirstChild(v217_1)
            if not v217_2 then
                local v218_1=Instance.new ( "WeldConstraint" )v218_1.Name =v217_1 v218_1.Part0 =v216_2.Part0 v218_1.Part1 =v216_2.Part1 v218_1.Parent =v216_2.Part1
            end
        end
    end
end
v0_97=function(v219_1,...)
    if v0_51 and v0_51.onTreadmill then
        return
    end
    v219_1=v219_1 or v0_10.Character
    if not v219_1 then
        return
    end
    local v219_2=v219_1:FindFirstChildOfClass( "Humanoid" )
    if v219_2 then
        v219_2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll , false )v219_2:SetStateEnabled(Enum.HumanoidStateType.FallingDown , false )v219_2:SetStateEnabled(Enum.HumanoidStateType.Physics , false )v219_2:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding , false )v219_2:SetStateEnabled(Enum.HumanoidStateType.Seated , false )
        if v219_2.PlatformStand then
            v219_2.PlatformStand = false
        end
        if v219_2.Sit then
            v219_2.Sit = false
        end
    end
    for v225_1,v225_2 in ipairs(v219_1:GetDescendants())do
        if v225_2:IsA( "LocalScript" )and((string.find (string.lower (v225_2.Name ), "ragdoll" )or string.find (string.lower (v225_2.Name ), "fall" )))then
            v225_2.Disabled = true
        end
    end
    v0_96(v219_1)
end
v0_98=function(v227_1,...)
    if not v227_1 then
        return
    end
    v0_97(v227_1)
    for v229_1,v229_2 in ipairs(v227_1:GetDescendants())do
        if v229_2:IsA( "Motor6D" )then
            (v229_2:GetPropertyChangedSignal( "Enabled" )):Connect(function(...)
                if not v229_2.Enabled then
                    v229_2.Enabled = true
                end
            end
            )
        end
    end
    v227_1.DescendantAdded :Connect(function(v233_1,...)
        if v233_1:IsA( "BallSocketConstraint" )or v233_1:IsA( "HingeConstraint" )or v233_1:IsA( "NoCollisionConstraint" )then
            task.defer (function(...) pcall(function(...) v233_1:Destroy()
                end
                )v0_97(v227_1)
            end
            )
        elseif v233_1:IsA( "LocalScript" )and((string.find (string.lower (v233_1.Name ), "ragdoll" )or string.find (string.lower (v233_1.Name ), "fall" )))then
            v233_1.Disabled = true
        end
    end
    )v227_1.ChildAdded :Connect(function(v238_1,...)
        if v238_1:IsA( "Tool" )and(((v0_51.pureTweenFarm or v0_51.autoFarmLoop ))and not v0_51.holdingEggForGuard )then
            task.defer (function(...) v0_61()
            end
            )
        end
    end
    )
end
v0_86=function(...)
    if v0_51 then
        v0_51.onTreadmill = false
    end
    local v241_1=v0_10.Character
    local v241_2=v241_1 and v241_1:FindFirstChildOfClass( "Humanoid" )
    local v241_3=v241_1 and v241_1:FindFirstChild( "HumanoidRootPart" )
    if v0_31 then
        task.spawn (function(...) pcall(function(...) v0_31:InvokeServer()
            end
            )
        end
        )
    end
    if v241_2 then
        pcall(function(...)
            for v248_1,v248_2 in ipairs(v241_2:GetPlayingAnimationTracks())do
                local v248_3=v248_2.Animation
                local v248_4=v248_3 and v248_3.AnimationId or ""
                if string.find (v248_4, "10921259953" )or string.find (string.lower (v248_2.Name ), "treadmill" )or string.find (string.lower (v248_2.Name ), "run" )then
                    v248_2:Stop( 0 )
                end
            end
            v241_2.PlatformStand = false v241_2.Sit = false v241_2:SetStateEnabled(Enum.HumanoidStateType.Running , true )v241_2:SetStateEnabled(Enum.HumanoidStateType.Jumping , true )v241_2:ChangeState(Enum.HumanoidStateType.Running )
        end
        )
    end
    local v241_4=v0_10:FindFirstChild( "PlayerGui" )
    if v241_4 then
        local v250_1=v241_4:FindFirstChild( "SpeedGainAnimation" )
        if v250_1 then
            pcall(function(...) v250_1:Destroy()
            end
            )
        end
    end
    if v241_3 then
        v241_3.AssemblyLinearVelocity =Vector3.zero v241_3.AssemblyAngularVelocity =Vector3.zero
    end
    v0_97(v241_1)
end
local v0_111= 0
local v0_112= false v0_93=function(...)
    local v254_1=v0_10:FindFirstChild( "PlayerGui" )
    if not v254_1 then
        return false
    end
    local v254_2= false pcall(function(...)
        for v257_1,v257_2 in ipairs(v254_1:GetChildren())do
            if v257_2:IsA( "ScreenGui" )and v257_2.Enabled then
                for v259_1,v259_2 in ipairs(v257_2:GetDescendants())do
                    if((v259_2:IsA( "TextButton" )or v259_2:IsA( "ImageButton" )))and v259_2.Visible then
                        local v260_1=(v259_2:IsA( "TextButton" )and v259_2.Text )or v259_2.Name
                        local v260_2=string.lower (v260_1 or "" )
                        if string.find (v260_2, "get out" )or string.find (v260_2, "treadmill" )or string.find (v260_2, "doff" )or string.find (v260_2, "leave" )or string.find (v260_2, "exit" )then
                            if typeof(firesignal)== "function" and v259_2.Activated then
                                pcall(firesignal,v259_2.Activated )
                            elseif typeof(firesignal)== "function" and v259_2.MouseButton1Click then
                                pcall(firesignal,v259_2.MouseButton1Click )
                            elseif typeof(getconnections)== "function" then
                                local v264_1=getconnections(v259_2.MouseButton1Click )or getconnections(v259_2.Activated )or{}
                                for v265_1,v265_2 in ipairs(v264_1)do
                                    pcall(function(...) v265_2:Fire()
                                    end
                                    )
                                    break
                                end
                            end
                            v254_2= true
                            break
                        end
                    end
                end
                if v254_2 then
                    break
                end
            end
        end
    end
    )
    return v254_2
end
v0_92=function(...)
    local v268_1=v0_10.Character
    local v268_2=v268_1 and v268_1:FindFirstChild( "HumanoidRootPart" )
    if not v268_2 then
        return false
    end
    local v268_3=(typeof(v0_91)== "function" )and v0_91()or nil
    if v268_3 then
        local v270_1=v268_3.Position +Vector3.new ( 0 , 1.8 , 0 )
        local v270_2=((v268_2.Position -v270_1)).Magnitude
        if v270_2> 6 then
            if v0_51 then
                v0_51.onTreadmill = false
            end
            return false
        end
    else
        if v268_2.Position.X > 535 then
            if v0_51 then
                v0_51.onTreadmill = false
            end
            return false
        end
    end
    if v0_51 and v0_51.onTreadmill then
        return true
    end
    local v268_4=v268_1 and v268_1:FindFirstChildOfClass( "Humanoid" )
    if v268_4 then
        for v278_1,v278_2 in ipairs(v268_4:GetPlayingAnimationTracks())do
            local v278_3=v278_2.Animation
            local v278_4=v278_3 and v278_3.AnimationId or ""
            local v278_5=string.lower (v278_2.Name or "" )
            if string.find (v278_4, "10921259953" )or string.find (v278_5, "treadmill" )or string.find (v278_5, "run" )then
                return true
            end
        end
    end
    local v268_5=v0_10:FindFirstChild( "PlayerGui" )
    if v268_5 and v268_5:FindFirstChild( "SpeedGainAnimation" )then
        return true
    end
    return false
end
v0_90=function(...)
    if v0_112 then
        return
    end
    if os.clock ()-v0_111< 0.8 then
        if v0_51 then
            v0_51.onTreadmill = false
        end
        return
    end
    v0_112= true v0_111=os.clock ()
    if v0_51 then
        v0_51.onTreadmill = false
    end
    v0_93()
    if v0_31 then
        pcall(function(...) v0_31:InvokeServer()
        end
        )
    end
    local v281_1=v0_10.Character
    local v281_2=v281_1 and v281_1:FindFirstChildOfClass( "Humanoid" )
    local v281_3=v281_1 and v281_1:FindFirstChild( "HumanoidRootPart" )
    if v281_2 then
        pcall(function(...)
            for v290_1,v290_2 in ipairs(v281_2:GetPlayingAnimationTracks())do
                local v290_3=v290_2.Animation
                local v290_4=v290_3 and v290_3.AnimationId or ""
                local v290_5=string.lower (v290_2.Name or "" )
                if string.find (v290_4, "10921259953" )or string.find (v290_5, "treadmill" )or string.find (v290_5, "run" )then
                    v290_2:Stop( 0 )
                end
            end
            v281_2.PlatformStand = false v281_2.Sit = false v281_2:SetStateEnabled(Enum.HumanoidStateType.Running , true )v281_2:SetStateEnabled(Enum.HumanoidStateType.Jumping , true )v281_2:ChangeState(Enum.HumanoidStateType.Running )
        end
        )
    end
    local v281_4=v0_10:FindFirstChild( "PlayerGui" )
    if v281_4 then
        local v292_1=v281_4:FindFirstChild( "SpeedGainAnimation" )
        if v292_1 then
            pcall(function(...) v292_1:Destroy()
            end
            )
        end
    end
    if v281_3 then
        v281_3.AssemblyLinearVelocity =Vector3.zero v281_3.AssemblyAngularVelocity =Vector3.zero
    end
    v0_97(v281_1)task.wait ( 0.15 )v0_112= false
end
v0_87=v0_90 v0_88=function(...) pcall(function(...)
        local v297_1=v0_2:FindFirstChild( "Plots" )
        if v297_1 then
            local v298_1=v0_51 and v0_51.plot
            if not v298_1 and v0_69 then
                v298_1=select( 1 ,v0_69())
            end
            for v300_1,v300_2 in ipairs(v297_1:GetChildren())do
                local v300_3=(v298_1~=nil and v300_2==v298_1)
                local v300_4=v300_2:FindFirstChild( "TreadmillBottom" )
                if v300_4 and v300_4:IsA( "BasePart" )then
                    if v300_3 and(v0_51 and v0_51.autoTreadmill )then
                        v300_4.CanTouch = true v300_4.CanCollide = true
                    else
                        v300_4.CanTouch = false v300_4.CanCollide = false
                    end
                end
                local v300_5=v300_2:FindFirstChild( "TreadmillUpgrade" )
                if v300_5 then
                    for v305_1,v305_2 in ipairs(v300_5:GetDescendants())do
                        if v305_2:IsA( "BasePart" )then
                            if v300_3 and(v0_51 and v0_51.autoTreadmill )then
                                v305_2.CanTouch = true
                            else
                                v305_2.CanTouch = false v305_2.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end
    )
end
v0_88()v0_2.DescendantAdded :Connect(function(v309_1,...) pcall(function(...)
        local v310_1=(v309_1.Name == "TreadmillBottom" and v309_1:IsA( "BasePart" ))
        local v310_2=(v309_1.Name == "TreadmillUpgrade" and v309_1:IsA( "Model" ))
        if v310_1 or v310_2 then
            local v311_1=v0_51 and v0_51.plot
            if not v311_1 and v0_69 then
                v311_1=select( 1 ,v0_69())
            end
            local v311_2=v311_1 and v309_1:IsDescendantOf(v311_1)
            if v311_2 and(v0_51 and v0_51.autoTreadmill )then
                if v310_1 then
                    v309_1.CanTouch = true v309_1.CanCollide = true
                else
                    for v316_1,v316_2 in ipairs(v309_1:GetDescendants())do
                        if v316_2:IsA( "BasePart" )then
                            v316_2.CanTouch = true
                        end
                    end
                end
            else
                if v310_1 then
                    v309_1.CanTouch = false v309_1.CanCollide = false
                else
                    for v321_1,v321_2 in ipairs(v309_1:GetDescendants())do
                        if v321_2:IsA( "BasePart" )then
                            v321_2.CanTouch = false v321_2.CanCollide = false
                        end
                    end
                end
            end
        end
    end
    )
end
)v0_85=function(...) v0_51.onTreadmill = false v0_51.teleporting = false v0_51.glidingToTarget = false v0_51.securingEgg = false v0_51.isReturning = false v0_51.delivering = false v0_51.holdingEggForGuard = false v0_51.currentTargetModel =nil v0_51.targetPosition =nil v0_51.stateTime =os.clock ()
    local v323_1=v0_10.Character
    local v323_2=v323_1 and v323_1:FindFirstChild( "HumanoidRootPart" )
    if v323_2 then
        pcall(function(...) v323_2.Anchored = false v323_2.AssemblyLinearVelocity =Vector3.zero v323_2.AssemblyAngularVelocity =Vector3.zero
        end
        )
    end
    pcall(function(...)
        if v0_86 then
            v0_86()
        end
    end
    )pcall(function(...)
        if v0_97 and v323_1 then
            v0_97(v323_1)
        end
    end
    )pcall(function(...)
        if v0_61 and((v0_51.pureTweenFarm or v0_51.autoFarmLoop ))then
            v0_61()
        end
    end
    )
end
v0_99=function(v332_1,v332_2,...)
    if v332_1 then
        for v334_1,v334_2 in ipairs(v332_1:GetDescendants())do
            if v334_2:IsA( "ProximityPrompt" )then
                pcall(function(...) v334_2.RequiresLineOfSight = false v334_2.HoldDuration = 0
                    if typeof(fireproximityprompt)== "function" then
                        fireproximityprompt(v334_2, 0 )fireproximityprompt(v334_2)
                    end
                end
                )
            end
        end
    end
    local v332_3=v0_2:FindFirstChild( "AreaEggSlotsClient" )
    if v332_3 and v332_2 then
        for v339_1,v339_2 in ipairs(v332_3:GetChildren())do
            local v339_3=v339_2:FindFirstChildWhichIsA( "BasePart" )or v339_2.PrimaryPart
            if v339_3 and((v339_3.Position -v332_2)).Magnitude <= 18 then
                for v341_1,v341_2 in ipairs(v339_2:GetDescendants())do
                    if v341_2:IsA( "ProximityPrompt" )then
                        pcall(function(...) v341_2.RequiresLineOfSight = false v341_2.HoldDuration = 0
                            if typeof(fireproximityprompt)== "function" then
                                fireproximityprompt(v341_2, 0 )fireproximityprompt(v341_2)
                            end
                        end
                        )
                    end
                end
            end
        end
    end
end
v0_94=function(v345_1,...) v0_51.godmode =v345_1
    local v345_2=v0_10.Character
    if not v345_2 then
        return
    end
    local v345_3=v345_2:FindFirstChildOfClass( "Humanoid" )
    if v345_3 then
        v345_3:SetStateEnabled(Enum.HumanoidStateType.Dead ,not v345_1)
        if v345_1 and v345_3.Health < 100 then
            v345_3.Health = 100
        end
    end
    for v349_1,v349_2 in ipairs(v345_2:GetDescendants())do
        if v349_2:IsA( "BasePart" )then
            if v345_1 then
                v349_2.CanTouch = false v349_2.CanCollide = false
            end
        end
    end
    v0_97(v345_2)
end
local function v0_113()
    v0_94(true)
end
local function v0_114()
    v0_94(false)
end

v0_95=function(...)
    local v354_1=v0_10.Character
    local v354_2=v354_1 and v354_1:FindFirstChildOfClass( "Humanoid" )
    if not v354_1 or not v354_2 then
        return false
    end
    pcall(function(...) v354_2.BreakJointsOnDeath = false
        local v356_1=v354_2:Clone()v356_1.Parent =v354_1 v354_2:Destroy()
        local v356_2=v356_1:FindFirstChildOfClass( "Animator" )
        if not v356_2 then
            v356_2=Instance.new ( "Animator" )v356_2.Parent =v356_1
        end
        v0_2.CurrentCamera.CameraSubject =v356_1
        local v356_3=v354_1:FindFirstChild( "Animate" )
        if v356_3 and v356_3:IsA( "LocalScript" )then
            v356_3.Disabled = true task.defer (function(...) task.wait ( 0.05 )v356_3.Disabled = false
            end
            )
        end
        v356_1:SetStateEnabled(Enum.HumanoidStateType.Jumping , true )v356_1:SetStateEnabled(Enum.HumanoidStateType.Freefall , true )v356_1:SetStateEnabled(Enum.HumanoidStateType.Running , true )v356_1:SetStateEnabled(Enum.HumanoidStateType.Climbing , true )v356_1.JumpPower =math.max ( 50 ,v356_1.JumpPower )v356_1.JumpHeight =math.max ( 7.2 ,v356_1.JumpHeight )v356_1:ChangeState(Enum.HumanoidStateType.Running )
    end
    )v0_51.swapped = true
    if v0_51.godmode then
        v0_94( true )
    end
    v0_98(v354_1)
    return true
end
v0_69=function(...)
    if v0_51.plot and(v0_51.plot.Parent and(v0_51.pen and(v0_51.origin and v0_51.plotVerified )))then
        return v0_51.plot ,v0_51.pen ,v0_51.origin
    end
    local v361_1=v0_2:FindFirstChild( "Plots" )
    if not v361_1 then
        return nil,nil,nil
    end
    local v361_2=v0_10.UserId
    local v361_3=v0_10.Name
    local v361_4=v0_10.DisplayName
    local v361_5=nil
    local v361_6= false
    if v0_24 then
        local v364_1,v364_2=pcall(function(...)
            return v0_24:InvokeServer()
        end
        )
        if v364_1 and(type(v364_2)== "table" and type(v364_2.OwnersBySlot )== "table" )then
            for v367_1,v367_2 in pairs(v364_2.OwnersBySlot )do
                if v367_2==v361_2 or tostring(v367_2)==tostring(v361_2)or v367_2==v361_3 then
                    v361_5=v361_1:FindFirstChild(tostring(v367_1))
                    if v361_5 then
                        v361_6= true
                        break
                    end
                end
            end
        end
    end
    if not v361_5 and v0_23 then
        local v370_1,v370_2=pcall(function(...)
            return v0_23:InvokeServer()
        end
        )
        if v370_1 and type(v370_2)== "table" then
            for v373_1,v373_2 in pairs(v370_2)do
                if type(v373_2)== "table" and((v373_2.OwnerUserId ==v361_2 or tostring(v373_2.OwnerUserId )==tostring(v361_2)))then
                    local v374_1=v373_2.Slot or v373_1 v361_5=v361_1:FindFirstChild(tostring(v374_1))or v361_1:FindFirstChild(tostring(v373_1))
                    if v361_5 then
                        v361_6= true
                        break
                    end
                end
            end
        end
    end
    if not v361_5 then
        for v377_1,v377_2 in ipairs(v361_1:GetChildren())do
            local v377_3=v377_2:GetAttribute( "Owner" )or v377_2:GetAttribute( "OwnerUserId" )or v377_2:GetAttribute( "UserId" )or v377_2:GetAttribute( "OwnerId" )or v377_2:GetAttribute( "Player" )
            if v377_3 and((v377_3==v361_2 or tostring(v377_3)==tostring(v361_2)or v377_3==v361_3 or tostring(v377_3)==v361_3 or v377_3==v361_4))then
                v361_5=v377_2 v361_6= true
                break
            end
            for v379_1,v379_2 in ipairs({ "Owner" , "OwnerUserId" , "OwnerId" ;
                "UserId" ;
                "Player" ;
                "PlayerName" })do
                local v379_3=v377_2:FindFirstChild(v379_2)
                if v379_3 and((v379_3.Value ==v361_2 or tostring(v379_3.Value )==tostring(v361_2)or v379_3.Value ==v361_3 or v379_3.Value ==v361_4))then
                    v361_5=v377_2 v361_6= true
                    break
                end
            end
            if v361_5 then
                break
            end
        end
    end
    if not v361_5 then
        for v383_1,v383_2 in ipairs(v361_1:GetChildren())do
            for v384_1,v384_2 in ipairs(v383_2:GetDescendants())do
                if v384_2:IsA( "TextLabel" )and v384_2.Text ~= "" then
                    local v385_1=string.lower (v384_2.Text )
                    if string.find (v385_1,string.lower (v361_3), 1 , true )or(v361_4 and string.find (v385_1,string.lower (v361_4), 1 , true ))then
                        v361_5=v383_2 v361_6= true
                        break
                    end
                end
            end
            if v361_5 then
                break
            end
        end
    end
    if not v361_5 then
        local v388_1=v0_10.Character
        local v388_2=v388_1 and v388_1:FindFirstChild( "HumanoidRootPart" )
        if v388_2 and v388_2.Position.X <=(v0_41+ 30 )then
            local v389_1=nil
            local v389_2= 999999
            for v390_1,v390_2 in ipairs(v361_1:GetChildren())do
                local v390_3=v390_2:FindFirstChild( "CenterPoint" )or v390_2.PrimaryPart or v390_2:FindFirstChildWhichIsA( "BasePart" )
                if v390_3 then
                    local v391_1=((v388_2.Position -v390_3.Position )).Magnitude
                    if v391_1<v389_2 then
                        v389_2=v391_1 v389_1=v390_2
                    end
                end
            end
            if v389_1 and v389_2< 160 then
                v361_5=v389_1
            end
        end
    end
    if not v361_5 then
        v361_5=v361_1:FindFirstChild( "2" )or v361_1:FindFirstChild( "1" )or(v361_1:GetChildren())[ 1 ]
    end
    if not v361_5 then
        return nil,nil,nil
    end
    v0_51.plot =v361_5 v0_51.plotVerified =v361_6 v0_51.origin =v361_5:FindFirstChild( "CenterPoint" )
    local v361_7=v361_5:FindFirstChild( "ToUpdate" )v0_51.pen =(v361_7 and v361_7:FindFirstChild( "PetArea" ))or v361_5:FindFirstChild( "PetArea" )v0_51.tread =v361_5:FindFirstChild( "TreadmillBottom" )
    if not v0_51.pen and v361_7 then
        for v397_1,v397_2 in ipairs(v361_7:GetChildren())do
            if v397_2:IsA( "BasePart" )and string.find (string.lower (v397_2.Name ), "pet" )then
                v0_51.pen =v397_2
                break
            end
        end
    end
    if not v0_51.origin then
        v0_51.origin =v361_5:FindFirstChild( "CenterPoint" )or v0_51.pen or v361_5.PrimaryPart
    end
    if not v0_51.pen then
        v0_51.pen =v0_51.origin
    end
    return v0_51.plot ,v0_51.pen ,v0_51.origin
end
v0_70=function(...)
    local v401_1,v401_2,v401_3=v0_69()
    if v401_2 then
        return v401_2.Position +Vector3.new ( 0 , 3.5 , 0 )
    end
    if v401_3 then
        return v401_3.Position +Vector3.new ( 0 , 3.5 , 0 )
    end
    return Vector3.new ( 464.7 , 71.7 , -304 )
end
v0_71=function(v404_1,...)
    local v404_2,v404_3,v404_4=v0_69()
    if not v404_3 then
        return nil
    end
    local v404_5=v404_3.Size
    local v404_6=math.max ( 4 ,v404_5.X / 2 - 5 )
    local v404_7=math.max ( 4 ,v404_5.Z / 2 - 5 )
    for v406_1= 1 , 60 , 1 do
        local v406_2=math.random (-math.floor (v404_6),math.floor (v404_6))
        local v406_3=math.random (-math.floor (v404_7),math.floor (v404_7))
        local v406_4=v404_3.CFrame *CFrame.new (v406_2,v404_5.Y / 2 + 1 ,v406_3)
        local v406_5= true
        for v407_1,v407_2 in ipairs(v404_1)do
            if((v407_2-v406_4.Position )).Magnitude < 5.5 then
                v406_5= false
                break
            end
        end
        if v406_5 then
            return v406_4
        end
    end
    return v404_3.CFrame *CFrame.new (math.random ( -8 , 8 ),v404_5.Y / 2 + 1 ,math.random ( -8 , 8 ))
end
v0_72=function(...)
    local v410_1,v410_2,v410_3=v0_69()
    if not v410_3 or not v0_22 then
        return 0
    end
    local v410_4= 0
    local v410_5={}
    if v0_23 then
        local v412_1,v412_2=pcall(function(...)
            return v0_23:InvokeServer()
        end
        )
        if v412_1 and type(v412_2)== "table" then
            local v414_1={}
            for v415_1,v415_2 in pairs(v412_2)do
                if type(v415_2)== "table" and v415_2.OwnerUserId ==v0_10.UserId then
                    for v417_1,v417_2 in pairs(v415_2.Records or{})do
                        v414_1[v417_1]=v417_2
                    end
                end
            end
            for v418_1,v418_2 in pairs(v414_1)do
                if v418_2.Placement and v418_2.Placement.LocalCFrame then
                    v410_5[#v410_5+ 1 ]=((v410_3.CFrame *v418_2.Placement.LocalCFrame )).Position
                else
                    local v420_1=v0_71(v410_5)
                    if v420_1 then
                        local v421_1=v410_3.CFrame :ToObjectSpace(v420_1)
                        local v421_2,v421_3=pcall(function(...)
                            return v0_22:InvokeServer({[ "Uid" ]=v418_1;
                            [ "LocalCFrame" ]=v421_1})
                        end
                        )
                        if v421_2 and v421_3 then
                            v410_4=v410_4+ 1 v410_5[#v410_5+ 1 ]=v420_1.Position
                        end
                    end
                end
            end
        end
    end
    local v410_6={}
    local v410_7=v0_10.Character
    if v410_7 then
        for v425_1,v425_2 in ipairs(v410_7:GetChildren())do
            if v0_57(v425_2)then
                table.insert (v410_6,v425_2)
            end
        end
    end
    local v410_8=v0_10:FindFirstChild( "Backpack" )
    if v410_8 then
        for v428_1,v428_2 in ipairs(v410_8:GetChildren())do
            if v0_57(v428_2)then
                table.insert (v410_6,v428_2)
            end
        end
    end
    for v430_1,v430_2 in ipairs(v410_6)do
        if not v0_51.alive then
            break
        end
        local v430_3=v430_2:GetAttribute( "UID" )or v430_2:GetAttribute( "EggUid" )or v430_2.Name
        local v430_4=v0_71(v410_5)
        if v430_4 then
            local v432_1=v410_3.CFrame :ToObjectSpace(v430_4)
            local v432_2,v432_3=pcall(function(...)
                return v0_22:InvokeServer({[ "Uid" ]=v430_3,[ "LocalCFrame" ]=v432_1})
            end
            )
            if v432_2 and v432_3~= false then
                v410_4=v410_4+ 1 v410_5[#v410_5+ 1 ]=v430_4.Position v0_16(string.format ( "[PlaceEgg] Placed egg %s from inventory" ,tostring(v430_3)))
            end
            task.wait ( 0.04 )
        end
    end
    return v410_4
end
v0_73=function(v435_1,...)
    if(not v435_1 and not v0_51.autoHatch )or not v0_27 or not v0_28 or not v0_23 then
        return 0
    end
    if v0_51.isHatching then
        return 0
    end
    v0_51.isHatching = true
    local v435_2,v435_3=pcall(function(...)
        return v0_23:InvokeServer()
    end
    )
    if not v435_2 or type(v435_3)~= "table" then
        return 0
    end
    local v435_4={}
    for v440_1,v440_2 in pairs(v435_3)do
        if type(v440_2)== "table" and v440_2.OwnerUserId ==v0_10.UserId then
            for v442_1,v442_2 in pairs(v440_2.Records or{})do
                v435_4[v442_1]=v442_2
            end
        end
    end
    local v435_5={}
    local v435_6=v0_2:GetServerTimeNow()
    for v443_1,v443_2 in pairs(v435_4)do
        if not v0_51.alive then
            break
        end
        if v443_2.Placement then
            local v445_1=nil
            if v0_18 then
                local v446_1=v0_18.IsReadyToHatch or v0_18.IsLocalEggReady
                if v446_1 then
                    local v447_1,v447_2=pcall(v446_1,v443_1)
                    if v447_1 and type(v447_2)== "boolean" then
                        v445_1=v447_2
                    end
                end
            end
            if v445_1==nil then
                local v449_1=v443_2.Placement.PlacedAt or v443_2.Placement.Time or 0
                local v449_2= 30
                if v0_19 and(v0_19.Assets and v0_19.Assets [v443_2.AssetCategory ])then
                    local v450_1=v0_19.Assets [v443_2.AssetCategory ]v449_2=(v450_1 and(v450_1.Egg and v450_1.Egg.GrowthTime ))or 30
                end
                local v449_3=v449_2/math.max ( 0.01 ,v443_2.GrowthSpeedMultiplier or 1 )v445_1=(v435_6-v449_1)>=v449_3
            end
            if v445_1 then
                table.insert (v435_5,{[ "uid" ]=v443_1;
                [ "category" ]=v443_2.AssetCategory or "Egg" })
            end
        end
    end
    if#v435_5== 0 then
        v0_51.isHatching = false
        return 0
    end
    v0_16(string.format ( "[AutoHatch] Found %d eggs ready to hatch! Starting hatch sequence..." ,#v435_5))v0_51.statusText =string.format ( "[Hatch] Hatching %d ready eggs..." ,#v435_5)
    local v435_7= 0
    for v453_1,v453_2 in ipairs(v435_5)do
        task.spawn (function(...)
            local v454_1,v454_2=pcall(function(...)
                if v0_27:IsA( "RemoteFunction" )then
                    return v0_27:InvokeServer(v453_2.uid )
                else
                    v0_27:FireServer(v453_2.uid )
                    return true
                end
            end
            )
            if v454_1 and v454_2~= false then
                task.wait ( 0.9 )
                local v458_1,v458_2=pcall(function(...)
                    if v0_28:IsA( "RemoteFunction" )then
                        return v0_28:InvokeServer(v453_2.uid )
                    else
                        v0_28:FireServer(v453_2.uid )
                        return true
                    end
                end
                )
                if v458_1 and v458_2~= false then
                    v435_7=v435_7+ 1 v0_51.hatched =((v0_51.hatched or 0 ))+ 1 v0_16(string.format ( "[+] [AutoHatch] Hatched %s (UID: %s) -> Total Hatched: %d" ,v453_2.category ,tostring(v453_2.uid ),v0_51.hatched ))
                end
            end
        end
        )task.wait ( 0.04 )
    end
    task.wait ( 0.95 )v0_51.isHatching = false v0_16(string.format ( "[AutoHatch] Finished! Hatched %d eggs." ,v435_7))
    return v435_7
end
v0_77=function(...)
    local v463_1={}
    local v463_2=v0_2:FindFirstChild( "__DEBRIS" )
    if v463_2 then
        for v465_1,v465_2 in ipairs(v463_2:GetChildren())do
            local v465_3=v465_2:FindFirstChild( "Hitbox" )
            if v465_3 and v465_3:IsA( "BasePart" )then
                table.insert (v463_1,v465_3)
            elseif v465_2:IsA( "BasePart" )and string.find (v465_2.Name :lower(), "hitbox" )then
                table.insert (v463_1,v465_2)
            end
        end
    end
    local v463_3=v0_2:FindFirstChild( "BossArenaTeleport" )
    if v463_3 then
        local v468_1=v463_3:FindFirstChild( "Hitbox" )or v463_3:FindFirstChildWhichIsA( "BasePart" )or(v463_3:IsA( "BasePart" )and v463_3)
        if v468_1 and v468_1:IsA( "BasePart" )then
            table.insert (v463_1,v468_1)
        end
    end
    return v463_1
end
v0_79=function(v470_1,v470_2,v470_3,...)
    local v470_4=v0_10.Character
    local v470_5=v470_4 and v470_4:FindFirstChild( "HumanoidRootPart" )
    local v470_6=v470_4 and v470_4:FindFirstChildOfClass( "Humanoid" )
    if not v470_5 then
        return false
    end
    if v470_6 then
        v470_6.AutoRotate = false
    end
    local v470_7=v0_70()v470_1=math.max ( 100 ,v470_1 or v0_51.glideSpeed or 600 )
    local v470_8=v0_51.laneZ or v0_40 v0_51.isReturning = true v0_51.stateTime =os.clock ()v0_67(v470_7, 20 )v470_5.AssemblyLinearVelocity =Vector3.zero v470_5.AssemblyAngularVelocity =Vector3.zero
    local v470_9=v0_66()
    local v470_10=math.max (v470_1,v470_9)
    local v470_11=os.clock ()+ 25
    while v0_51.alive and(v0_51.isReturning and os.clock ()<v470_11)do
        if v470_2 and v0_104~=v470_2 then
            if v470_6 then
                v470_6.AutoRotate = true
            end
            v0_51.isReturning = false
            return false
        end
        if not v470_3 and(not v0_51.pureTweenFarm and not v0_51.autoFarmLoop )then
            if v470_6 then
                v470_6.AutoRotate = true
            end
            v0_51.isReturning = false
            return false
        end
        local v473_1=v470_5.Position
        local v473_2=((v470_7-v473_1)).Magnitude
        if(v473_1.X <=(v470_7.X + 3 )and math.abs (v473_1.Z -v470_7.Z )<= 8 )or v473_2<= 6 then
            break
        end
        local v473_3=v0_3.Heartbeat :Wait()v473_1=v470_5.Position
        local v473_4=v470_10
        if v473_1.X <=v0_42 and v473_1.X >v0_41 then
            local v479_1=math.clamp (((v473_1.X -v0_41))/((v0_42-v0_41)), 0 , 1 )v473_4=v0_43+(((v470_10-v0_43))*v479_1)
        elseif v473_1.X <=v0_41 then
            v473_4=v0_43
        end
        local v473_5=v470_7.Z
        if v473_1.X > 540 then
            v473_5=v470_8
        end
        local v473_6=math.sign (v470_7.X -v473_1.X )
        local v473_7=v473_6*math.min (math.abs (v470_7.X -v473_1.X ),v473_4*v473_3)
        local v473_8=v473_1.X +v473_7
        local v473_9=math.sign (v470_7.Y -v473_1.Y )
        local v473_10=v473_9*math.min (math.abs (v470_7.Y -v473_1.Y ),(v473_4*v473_3)* 0.5 )
        local v473_11=v473_1.Y +v473_10
        local v473_12=v473_5-v473_1.Z
        local v473_13=math.sign (v473_12)*math.min (math.abs (v473_12),v473_4*v473_3)
        local v473_14=v473_1.Z +v473_13
        local v473_15=v0_77()
        local v473_16= false
        if v473_1.X >v0_41 then
            for v483_1,v483_2 in ipairs(v473_15)do
                local v483_3=v483_2.Position
                local v483_4=((Vector3.new (v473_8,v473_11,v473_14)-v483_3)).Magnitude
                local v483_5=math.abs (v473_8-v483_3.X )
                local v483_6=math.abs (v473_14-v483_3.Z )
                if v483_4< 22 or(v483_5< 18 and v483_6< 14 )then
                    v473_16= true
                    local v484_1=v483_3.Y + 16
                    if v473_11<v484_1 then
                        v473_11=math.min (v473_11+((v473_4*v473_3)* 1.5 ),v484_1)
                    end
                    break
                end
            end
        end
        local v473_17=Vector3.new (v473_8,v473_11,v473_14)
        local v473_18=((v473_17-v473_1)).Magnitude > 0.05 and((v473_17-v473_1)).Unit or v470_5.CFrame.LookVector v470_5.CFrame =CFrame.lookAt (v473_17,v473_17+v473_18)v470_5.AssemblyLinearVelocity =Vector3.zero v470_5.AssemblyAngularVelocity =Vector3.zero
        if v473_16 then
            v0_51.statusText =string.format ( "Tweening Home (Z: %.0f) [DODGING TRAP!]" ,v473_14)
        else
            v0_51.statusText =string.format ( "Tweening Home (%.0f studs | Z: %.0f | Spd: %.0f)" ,v473_2,v473_14,v473_4)
        end
    end
    v470_5.CFrame =CFrame.new (v470_7)v470_5.AssemblyLinearVelocity =Vector3.zero v470_5.AssemblyAngularVelocity =Vector3.zero
    if v470_6 then
        v470_6.AutoRotate = true
    end
    v0_61()v0_51.isReturning = false v0_51.delivering = false v0_51.statusText = "Arrived at Base PetArea!"
    return true
end
v0_76=function(v489_1,v489_2,v489_3,...)
    local v489_4=v0_10.Character
    local v489_5=v489_4 and v489_4:FindFirstChild( "HumanoidRootPart" )
    local v489_6=v489_4 and v489_4:FindFirstChildOfClass( "Humanoid" )
    if not v489_5 or not v489_6 then
        return
    end
    local v489_7=v0_70()
    local v489_8=((v489_5.Position -v489_7)).Magnitude
    if v489_8> 8 then
        v0_51.statusText = "[Place] Tweening back to base plot..." v0_79(v489_1 or v0_51.glideSpeed or 600 ,v489_2, true )
    end
    v0_67(v489_7, 15 )v489_5.CFrame =CFrame.new (v489_7)v489_5.AssemblyLinearVelocity =Vector3.zero v0_51.statusText = "[Place] Placing All Eggs to Stand..."
    local v489_9=os.clock ()+ 3
    while v0_60()> 0 and(os.clock ()<v489_9 and v0_51.alive )do
        v0_72()task.wait ( 0.06 )
    end
    v0_51.statusText = "[Place] Hatching ready eggs..." v0_73( true )v0_61()v0_51.isReturning = false v0_51.delivering = false v0_51.currentTargetModel =nil v0_51.targetPosition =nil
    local v489_10=v0_60()v0_51.statusText =string.format ( "Placed & Hatched (Left: %d)! Hands Free." ,v489_10)
end
local v0_115= 5 v0_74=function(v493_1,...)
    if v0_51.isBatchPlacing then
        return
    end
    v0_51.isBatchPlacing = true v0_16(string.format ( "[AutoPlace] %d steals done! Batch placing (%s mode)..." ,v0_115,tostring(v493_1)))
    local v493_2=v0_104 v0_51.pureTweenFarm =(v493_1== "TWEEN" )v0_51.autoFarmLoop =(v493_1== "WARP" )
    local v493_3=v0_10.Character
    local v493_4=v493_3 and v493_3:FindFirstChild( "HumanoidRootPart" )
    local v493_5=v493_3 and v493_3:FindFirstChildOfClass( "Humanoid" )
    local v493_6=v0_70()
    local v493_7=v493_4 and((v493_4.Position -v493_6)).Magnitude or 999
    if v493_7> 8 then
        v0_51.statusText = "[AutoPlace] Tweening home to base plot..." v0_79(v0_51.glideSpeed or 600 ,v493_2, true )
    end
    if v493_4 then
        v0_67(v493_6, 20 )v493_4.CFrame =CFrame.new (v493_6)v493_4.AssemblyLinearVelocity =Vector3.zero v493_4.AssemblyAngularVelocity =Vector3.zero
        if v493_5 then
            v493_5.AutoRotate = true
        end
    end
    task.spawn (function(...) pcall(v0_72)pcall(v0_73, true )
    end
    )v0_61()v0_51.isReturning = false v0_51.delivering = false v0_51.glidingToTarget = false v0_51.securingEgg = false v0_51.teleporting = false v0_51.currentTargetModel =nil v0_51.targetPosition =nil
    for v499_1= 5 , 1 , -1 do
        if not v0_51.alive then
            break
        end
        v0_51.statusText =string.format ( "[AutoPlace] At Base: Resuming in %ds..." ,v499_1)task.wait ( 1 )
    end
    v0_51.isBatchPlacing = false
    if v0_51.alive and v0_104==v493_2 then
        v0_16(string.format ( "[AutoPlace] Done! Continuing %s farm." ,v493_1))v0_51.statusText =string.format ( "[AutoPlace] Resuming %s farm..." ,v493_1)
        if v493_1== "TWEEN" then
            v0_51.pureTweenFarm = true v0_51.autoFarmLoop = false
        elseif v493_1== "WARP" then
            v0_51.autoFarmLoop = true v0_51.pureTweenFarm = false
        end
        v0_105=v493_1
    end
end
v0_75=function(v504_1,...)
    if not v0_51.autoPlaceEvery5 then
        return false
    end
    v0_51.batchStealCount =((v0_51.batchStealCount or 0 ))+ 1 v0_16(string.format ( "[AutoPlace] Steal trip %d / %d completed successfully." ,v0_51.batchStealCount ,v0_115))
    if v0_51.batchStealCount >=v0_115 then
        v0_51.batchStealCount = 0 task.spawn (function(...) v0_74(v504_1)
        end
        )
        return true
    end
    return false
end
local function v0_116(v508_1,v508_2,v508_3,v508_4,...)
    local v508_5=v0_10.Character
    local v508_6=v508_5 and v508_5:FindFirstChild( "HumanoidRootPart" )
    local v508_7=v508_5 and v508_5:FindFirstChildOfClass( "Humanoid" )
    if not v508_6 then
        return false
    end
    if v508_7 then
        v508_7.AutoRotate = false
    end
    v508_2=math.max ( 60 ,v508_2 or v0_51.glideSpeed or 350 )
    local v508_8=v508_1.Position v0_67(v508_8, 14 )pcall(function(...) v0_10:RequestStreamAroundAsync(v508_8)
    end
    )v508_6.AssemblyLinearVelocity =Vector3.zero v508_6.AssemblyAngularVelocity =Vector3.zero
    local v508_9=v0_51.laneZ or v0_40 v0_51.glidingToTarget = true v0_51.stateTime =os.clock ()
    local v508_10= 0
    local v508_11=os.clock ()+ 15
    while v0_51.alive and(v0_51.glidingToTarget and os.clock ()<v508_11)do
        if v508_4 and v0_104~=v508_4 then
            if v508_7 then
                v508_7.AutoRotate = true
            end
            v0_51.glidingToTarget = false
            return false
        end
        if not v0_51.pureTweenFarm and(not v0_51.autoFarmLoop and not v0_51.teleporting )then
            if v508_7 then
                v508_7.AutoRotate = true
            end
            v0_51.glidingToTarget = false
            return false
        end
        local v512_1=v508_6.Position
        local v512_2=((v508_8-v512_1)).Magnitude
        local v512_3=((Vector2.new (v512_1.X ,v512_1.Z )-Vector2.new (v508_8.X ,v508_8.Z ))).Magnitude
        local v512_4=math.abs (v512_1.Y -v508_8.Y )
        if v512_2<= 6 or(v512_3<= 3.5 and v512_4<= 6 )then
            break
        end
        local v512_5=v0_3.Heartbeat :Wait()v512_1=v508_6.Position v512_2=((v508_8-v512_1)).Magnitude v512_3=((Vector2.new (v512_1.X ,v512_1.Z )-Vector2.new (v508_8.X ,v508_8.Z ))).Magnitude
        local v512_6=math.abs (v512_1.X -v508_8.X )
        if v508_3 and(os.clock ()-v508_10> 0.5 )then
            v508_10=os.clock ()
            local v518_1,v518_2=v0_64(v508_3)
            if not v518_1 and v518_2== "CarriedByOther" then
                if v508_7 then
                    v508_7.AutoRotate = true
                end
                v0_51.glidingToTarget = false
                return false
            end
        end
        local v512_7=v508_8.Z
        if v512_6> 40 then
            v512_7=v508_9
        end
        local v512_8=math.sign (v508_8.X -v512_1.X )
        local v512_9=v512_8*math.min (math.abs (v508_8.X -v512_1.X ),v508_2*v512_5)
        local v512_10=v512_1.X +v512_9
        local v512_11=(v512_3<= 25 )and 1.2 or 0.5
        local v512_12=math.sign (v508_8.Y -v512_1.Y )
        local v512_13=v512_12*math.min (math.abs (v508_8.Y -v512_1.Y ),(v508_2*v512_5)*v512_11)
        local v512_14=v512_1.Y +v512_13
        local v512_15=v512_7-v512_1.Z
        local v512_16=math.sign (v512_15)*math.min (math.abs (v512_15),v508_2*v512_5)
        local v512_17=v512_1.Z +v512_16
        local v512_18= false
        if v512_3> 25 then
            local v522_1=v0_77()
            for v523_1,v523_2 in ipairs(v522_1)do
                local v523_3=v523_2.Position
                local v523_4=((Vector3.new (v512_10,v512_14,v512_17)-v523_3)).Magnitude
                local v523_5=math.abs (v512_10-v523_3.X )
                local v523_6=math.abs (v512_17-v523_3.Z )
                if v523_4< 22 or(v523_5< 18 and v523_6< 14 )then
                    v512_18= true
                    local v524_1=v523_3.Y + 16
                    if v512_14<v524_1 then
                        v512_14=math.min (v512_14+((v508_2*v512_5)* 1.5 ),v524_1)
                    end
                    break
                end
            end
        end
        local v512_19=Vector3.new (v512_10,v512_14,v512_17)
        local v512_20=((v512_19-v512_1)).Magnitude > 0.05 and((v512_19-v512_1)).Unit or v508_6.CFrame.LookVector v508_6.CFrame =CFrame.lookAt (v512_19,v512_19+v512_20)v508_6.AssemblyLinearVelocity =Vector3.zero v508_6.AssemblyAngularVelocity =Vector3.zero
        if v512_18 then
            v0_51.statusText =string.format ( "Gliding Out (Z: %.0f) [DODGING TRAP!]" ,v512_17)
        else
            v0_51.statusText =string.format ( "Gliding -> Egg (%.0f studs | H: %.0f)" ,v512_2,v512_3)
        end
    end
    v508_6.CFrame =v508_1*CFrame.new ( 0 , 0.4 , 0 )v508_6.AssemblyLinearVelocity =Vector3.zero v508_6.AssemblyAngularVelocity =Vector3.zero
    if v508_7 then
        v508_7.AutoRotate = true
    end
    v0_51.glidingToTarget = false
    return true
end
v0_78=function(v529_1,v529_2,v529_3,v529_4,...)
    local v529_5=v0_10.Character
    local v529_6=v529_5 and v529_5:FindFirstChild( "HumanoidRootPart" )
    if v529_6 then
        local v530_1=v529_6.Position.X
        local v530_2=v529_1.Position.X
        if v530_1<= 535 and v530_2> 510 then
            local v531_1=CFrame.new ( 500 , 70 , -364 )
            local v531_2=((v529_6.Position -v531_1.Position )).Magnitude
            if v531_2> 5 then
                v0_51.statusText = "[AutoSteal] Exiting Base -> Waypoint (500, 70, -364)..." v0_16(string.format ( "[AutoSteal] Leaving base (X=%.1f): Gliding to waypoint (500, 70, -364) first (dist=%.1f studs)..." ,v530_1,v531_2))
                local v532_1=v0_116(v531_1,v529_2,v529_3,v529_4)
                if not v532_1 then
                    return false
                end
                task.wait ( 0.04 )
            end
        end
    end
    return v0_116(v529_1,v529_2,v529_3,v529_4)
end
v0_80=function(v534_1,v534_2,...)
    local v534_3=v0_10.Character
    local v534_4=v534_3 and v534_3:FindFirstChild( "HumanoidRootPart" )
    local v534_5=v534_3 and v534_3:FindFirstChildOfClass( "Humanoid" )
    if not v534_4 then
        return false
    end
    if v534_5 then
        v534_5.AutoRotate = false
    end
    local v534_6=v0_51.laneZ or v0_40
    local v534_7=Vector3.new (v0_41- 10 , 70 ,v534_6)v534_1=math.max ( 100 ,v534_1 or v0_51.glideSpeed or 350 )v0_51.isReturning = true v0_51.stateTime =os.clock ()v0_67(Vector3.new (v0_41, 70 ,v534_6), 20 )pcall(v0_61)v534_4.AssemblyLinearVelocity =Vector3.zero v534_4.AssemblyAngularVelocity =Vector3.zero
    local v534_8=v0_66()
    local v534_9=math.max (v534_1,v534_8)
    local v534_10=os.clock ()+ 15
    while v0_51.alive and(v0_51.isReturning and os.clock ()<v534_10)do
        if v534_2 and v0_104~=v534_2 then
            v0_17( "[Return] Aborted by session switch!" )
            if v534_5 then
                v534_5.AutoRotate = true
            end
            v0_51.isReturning = false
            return false
        end
        if not v0_51.pureTweenFarm and not v0_51.autoFarmLoop then
            v0_17( "[Return] Aborted (all farms disabled)" )
            if v534_5 then
                v534_5.AutoRotate = true
            end
            v0_51.isReturning = false
            return false
        end
        local v537_1=v534_4.Position
        local v537_2=((v534_7-v537_1)).Magnitude
        if v537_1.X <=(v0_41+ 10 )or v537_2<= 6 then
            v0_61()
            break
        end
        if v534_3 then
            for v544_1,v544_2 in ipairs(v534_3:GetChildren())do
                if v544_2:IsA( "Tool" )then
                    pcall(v0_61)
                    break
                end
            end
        end
        local v537_3=v0_3.Heartbeat :Wait()v537_1=v534_4.Position
        local v537_4=v534_9
        if v537_1.X <=v0_42 and v537_1.X >v0_41 then
            local v546_1=math.clamp (((v537_1.X -v0_41))/((v0_42-v0_41)), 0 , 1 )v537_4=v0_43+(((v534_9-v0_43))*v546_1)
        elseif v537_1.X <=v0_41 then
            v537_4=v0_43
        end
        local v537_5=math.sign (v534_7.X -v537_1.X )
        local v537_6=v537_5*math.min (math.abs (v534_7.X -v537_1.X ),v537_4*v537_3)
        local v537_7=v537_1.X +v537_6
        local v537_8=math.sign (v534_7.Y -v537_1.Y )
        local v537_9=v537_8*math.min (math.abs (v534_7.Y -v537_1.Y ),(v537_4*v537_3)* 0.5 )
        local v537_10=v537_1.Y +v537_9
        local v537_11=v534_6-v537_1.Z
        local v537_12=math.sign (v537_11)*math.min (math.abs (v537_11),v537_4*v537_3)
        local v537_13=v537_1.Z +v537_12
        local v537_14=v0_77()
        local v537_15= false
        for v548_1,v548_2 in ipairs(v537_14)do
            local v548_3=v548_2.Position
            local v548_4=((Vector3.new (v537_7,v537_10,v537_13)-v548_3)).Magnitude
            local v548_5=math.abs (v537_7-v548_3.X )
            local v548_6=math.abs (v537_13-v548_3.Z )
            if v548_4< 22 or(v548_5< 18 and v548_6< 14 )then
                v537_15= true
                local v549_1=v548_3.Y + 16
                if v537_10<v549_1 then
                    v537_10=math.min (v537_10+((v537_4*v537_3)* 1.5 ),v549_1)
                end
                break
            end
        end
        local v537_16=Vector3.new (v537_7,v537_10,v537_13)
        local v537_17=((v537_16-v537_1)).Magnitude > 0.05 and((v537_16-v537_1)).Unit or v534_4.CFrame.LookVector v534_4.CFrame =CFrame.lookAt (v537_16,v537_16+v537_17)v534_4.AssemblyLinearVelocity =Vector3.zero v534_4.AssemblyAngularVelocity =Vector3.zero
        if v537_15 then
            v0_51.statusText =string.format ( "Tweening Safe Line (Z: %.0f) [DODGING!]" ,v537_13)
        else
            v0_51.statusText =string.format ( "Tweening to Safe Line (%.0f studs | X: %.0f)" ,v537_2,v537_1.X )
        end
    end
    v534_4.CFrame =CFrame.new (v0_41,math.max ( 68 ,v534_4.Position.Y ),v534_6)v534_4.AssemblyLinearVelocity =Vector3.zero v534_4.AssemblyAngularVelocity =Vector3.zero
    if v534_5 then
        v534_5.AutoRotate = true
    end
    v0_61()v0_51.isReturning = false v0_51.delivering = false
    if v0_51 then
        v0_51.onTreadmill = false
    end
    v0_51.statusText = "Arrived at Safe Line (X=525)! Hands Free."
    return true
end
local function v0_117(v555_1,...)
    if not v555_1 then
        return nil
    end
    local v555_2=v555_1:FindFirstChild( "TreadmillBottom" )
    if v555_2 and v555_2:IsA( "BasePart" )then
        return v555_2
    end
    v555_2=v555_1:FindFirstChild( "TreadmillBottom" , true )
    if v555_2 and v555_2:IsA( "BasePart" )then
        return v555_2
    end
    local v555_3=v555_1:FindFirstChild( "TreadmillUpgrade" , true )
    if v555_3 then
        for v560_1,v560_2 in ipairs({ "TreadmillBottom" , "Belt" , "RunArea" ;
            "Run" ;
            "Platform" ;
            "Pad" , "Floor" ;
            "Base" })do
            local v560_3=v555_3:FindFirstChild(v560_2, true )
            if v560_3 and v560_3:IsA( "BasePart" )then
                return v560_3
            end
        end
        local v559_1=nil
        local v559_2= 999999
        for v562_1,v562_2 in ipairs(v555_3:GetDescendants())do
            if v562_2:IsA( "BasePart" )and(v562_2.Size.X >= 1.2 and v562_2.Size.Z >= 1.2 )then
                if v562_2.Position.Y <v559_2 then
                    v559_2=v562_2.Position.Y v559_1=v562_2
                end
            end
        end
        if v559_1 then
            return v559_1
        end
        if v555_3.PrimaryPart then
            return v555_3.PrimaryPart
        end
        local v559_3=v555_3:FindFirstChildWhichIsA( "BasePart" , true )
        if v559_3 then
            return v559_3
        end
    end
    for v568_1,v568_2 in ipairs(v555_1:GetDescendants())do
        if v568_2:IsA( "BasePart" )and string.find (string.lower (v568_2.Name ), "treadmill" )then
            return v568_2
        end
    end
    return nil
end
v0_91=function(...)
    local v570_1=v0_69()
    if v0_51.tread and v0_51.tread.Parent then
        return v0_51.tread
    end
    local v570_2=nil
    if v570_1 then
        v570_2=v0_117(v570_1)
    end
    if not v570_2 then
        local v573_1=v0_2:FindFirstChild( "Plots" )
        if v573_1 then
            local v574_1=string.lower (v0_10.Name )
            local v574_2=v0_10.DisplayName and string.lower (v0_10.DisplayName )
            for v575_1,v575_2 in ipairs(v573_1:GetChildren())do
                local v575_3=v0_117(v575_2)
                if v575_3 then
                    local v576_1= false
                    for v577_1,v577_2 in ipairs(v575_2:GetDescendants())do
                        if v577_2:IsA( "TextLabel" )and v577_2.Text ~= "" then
                            local v578_1=string.lower (v577_2.Text )
                            if string.find (v578_1,v574_1, 1 , true )or(v574_2 and string.find (v578_1,v574_2, 1 , true ))then
                                v576_1= true
                                break
                            end
                        end
                    end
                    if v576_1 then
                        v0_51.plot =v575_2 v0_51.plotVerified = true v570_2=v575_3
                        break
                    end
                end
            end
            if not v570_2 and v570_1 then
                v570_2=v0_117(v570_1)
            end
        end
    end
    v0_51.tread =v570_2
    return v570_2
end
v0_89=function(v582_1,...)
    local v582_2=v0_10.Character
    local v582_3=v582_2 and v582_2:FindFirstChild( "HumanoidRootPart" )
    local v582_4=v582_2 and v582_2:FindFirstChildOfClass( "Humanoid" )
    if not v582_3 or not v582_4 then
        return false
    end
    if v582_4.PlatformStand then
        v582_4.PlatformStand = false
    end
    if v582_4.Sit then
        v582_4.Sit = false
    end
    v582_4:ChangeState(Enum.HumanoidStateType.Running )
    local v582_5=v0_69()
    local v582_6=v0_91()
    if not v582_6 then
        v0_17( "[AutoTreadmill] Treadmill part not found! Retrying next loop..." )
        return false
    end
    pcall(function(...)
        for v588_1,v588_2 in ipairs(v582_2:GetChildren())do
            if v588_2:IsA( "BasePart" )and v588_2.Name ~= "HumanoidRootPart" then
                v588_2.CanCollide = false
            end
        end
    end
    )pcall(function(...) v582_6.CanTouch = true v582_6.CanCollide = true
        local v590_1=v582_5 and v582_5:FindFirstChild( "TreadmillUpgrade" , true )
        if v590_1 then
            for v592_1,v592_2 in ipairs(v590_1:GetDescendants())do
                if v592_2:IsA( "BasePart" )then
                    v592_2.CanTouch = true v592_2.CanCollide = true
                end
            end
        end
        if v582_6.Parent and v582_6.Parent :IsA( "Model" )then
            for v595_1,v595_2 in ipairs(v582_6.Parent :GetDescendants())do
                if v595_2:IsA( "BasePart" )then
                    v595_2.CanTouch = true v595_2.CanCollide = true
                end
            end
        end
    end
    )
    local v582_7=v582_6.Position +Vector3.new ( 0 , 1.8 , 0 )
    if v582_3.Position.X > 535 then
        v0_51.statusText = "[AutoTreadmill] Returning along highway to base..." v0_80(v0_51.glideSpeed ,v582_1)
        if v582_1 and v0_104~=v582_1 then
            return false
        end
        if v582_3.Position.X > 535 then
            if v582_3.Position.X <= 560 then
                v582_3.CFrame =CFrame.new (v0_41, 70 ,v0_51.laneZ or v0_40)
            else
                return false
            end
        end
    end
    if v582_1 and v0_104~=v582_1 then
        return false
    end
    local v582_8=((Vector2.new (v582_3.Position.X ,v582_3.Position.Z )-Vector2.new (v582_7.X ,v582_7.Z ))).Magnitude
    if v582_8> 4 then
        v0_51.statusText = "[AutoTreadmill] Elevated flyover to base plot..."
        local v603_1=math.max ( 250 ,v0_51.glideSpeed or 400 )
        local v603_2=os.clock ()
        while v0_51.alive and(((Vector2.new (v582_3.Position.X ,v582_3.Position.Z )-Vector2.new (v582_7.X ,v582_7.Z ))).Magnitude > 4 and(os.clock ()-v603_2< 4 ))do
            if v582_1 and v0_104~=v582_1 then
                return false
            end
            local v604_1=v0_3.Heartbeat :Wait()
            local v604_2=v582_3.Position
            local v604_3=Vector3.new (v582_7.X , 70 ,v582_7.Z )
            local v604_4=(v604_3-v604_2)
            local v604_5=v604_4.Unit *math.min (v604_4.Magnitude ,v603_1*v604_1)
            local v604_6=v604_2+v604_5 v582_3.CFrame =CFrame.lookAt (v604_6,v604_6+((v604_4.Magnitude > 0.05 and v604_4.Unit or v582_3.CFrame.LookVector )))v582_3.AssemblyLinearVelocity =Vector3.zero v582_3.AssemblyAngularVelocity =Vector3.zero
            if v582_4 then
                if v582_4.PlatformStand then
                    v582_4.PlatformStand = false
                end
                if v582_4.Sit then
                    v582_4.Sit = false
                end
                v582_4:ChangeState(Enum.HumanoidStateType.Running )
            end
        end
    end
    if v582_1 and v0_104~=v582_1 then
        return false
    end
    local v582_9=os.clock ()
    while v0_51.alive and(math.abs (v582_3.Position.Y -v582_7.Y )> 2 and(os.clock ()-v582_9< 1.5 ))do
        if v582_1 and v0_104~=v582_1 then
            return false
        end
        local v610_1=v0_3.Heartbeat :Wait()
        local v610_2=v582_3.Position
        local v610_3=v582_7
        local v610_4=(v610_3-v610_2)
        local v610_5=v610_4.Unit *math.min (v610_4.Magnitude , 150 *v610_1)
        local v610_6=v610_2+v610_5 v582_3.CFrame =CFrame.new (v610_6)v582_3.AssemblyLinearVelocity =Vector3.zero v582_3.AssemblyAngularVelocity =Vector3.zero
    end
    v582_3.CFrame =CFrame.new (v582_7)v582_3.AssemblyLinearVelocity =Vector3.zero v582_3.AssemblyAngularVelocity =Vector3.zero
    local v582_10=((v582_3.Position -v582_7)).Magnitude
    if v582_10<= 6 then
        pcall(function(...)
            if typeof(firetouchinterest)== "function" then
                firetouchinterest(v582_3,v582_6, 0 )task.wait ( 0.02 )firetouchinterest(v582_3,v582_6, 1 )
            end
        end
        )pcall(function(...)
            for v616_1,v616_2 in ipairs(v582_6:GetDescendants())do
                if v616_2:IsA( "ProximityPrompt" )and v616_2.Enabled then
                    if typeof(fireproximityprompt)== "function" then
                        fireproximityprompt(v616_2)
                    end
                end
            end
            if v582_6.Parent then
                for v620_1,v620_2 in ipairs(v582_6.Parent :GetDescendants())do
                    if v620_2:IsA( "ProximityPrompt" )and v620_2.Enabled then
                        if typeof(fireproximityprompt)== "function" then
                            fireproximityprompt(v620_2)
                        end
                    end
                end
            end
        end
        )
        if v0_32 then
            pcall(function(...) v0_32:InvokeServer()
            end
            )
        end
        v0_51.onTreadmill = true v0_51.lastTreadmillMount =os.clock ()v0_51.statusText = "[AutoTreadmill] Running on treadmill (Waiting for eggs...)"
        return true
    else
        v0_51.onTreadmill = false v0_17(string.format ( "[AutoTreadmill] Not yet at treadmill pad (dist=%.1f studs). Will retry!" ,v582_10))
        return false
    end
end
local function v0_118(...)
    if not v0_51 or not v0_51.hideNotEnoughMoney then
        return
    end
    local v626_1=v0_10:FindFirstChild( "PlayerGui" )
    if not v626_1 then
        return
    end
    pcall(function(...)
        for v630_1,v630_2 in ipairs(v626_1:GetDescendants())do
            if v630_2:IsA( "TextLabel" )and v630_2.Visible then
                local v631_1=(tostring(v630_2.Text or "" )):lower()
                if v631_1:find( "not enough money" )or v631_1:find( "not enough cash" )or(v631_1:find( "not enough" )and((v631_1:find( "money" )or v631_1:find( "cash" )or v631_1:find( "coin" )or v631_1:find( "fund" ))))then
                    v630_2.Visible = false v630_2.TextTransparency = 1 v630_2.TextStrokeTransparency = 1
                    local v632_1=v630_2.Parent
                    if v632_1 and(((v632_1:IsA( "Frame" )or v632_1:IsA( "CanvasGroup" )))and#v632_1:GetChildren()<= 3 )then
                        v632_1.Visible = false
                    end
                end
            end
        end
    end
    )
end
local function v0_119(...)
    local v634_1=v0_10:FindFirstChild( "PlayerGui" )
    if not v634_1 then
        return
    end
    local function v634_2(v636_1,...)
        if v636_1:IsA( "TextLabel" )then
            local function v637_1(...)
                if not v0_51 or not v0_51.hideNotEnoughMoney then
                    return
                end
                local v638_1=(tostring(v636_1.Text or "" )):lower()
                if v638_1:find( "not enough money" )or v638_1:find( "not enough cash" )or(v638_1:find( "not enough" )and((v638_1:find( "money" )or v638_1:find( "cash" )or v638_1:find( "coin" )or v638_1:find( "fund" ))))then
                    v636_1.Visible = false v636_1.TextTransparency = 1 v636_1.TextStrokeTransparency = 1
                    local v640_1=v636_1.Parent
                    if v640_1 and(((v640_1:IsA( "Frame" )or v640_1:IsA( "CanvasGroup" )))and#v640_1:GetChildren()<= 3 )then
                        v640_1.Visible = false
                    end
                end
            end
            v637_1();
            (v636_1:GetPropertyChangedSignal( "Text" )):Connect(v637_1);
            (v636_1:GetPropertyChangedSignal( "Visible" )):Connect(function(...)
                if v636_1.Visible then
                    v637_1()
                end
            end
            )
        end
    end
    pcall(function(...)
        for v645_1,v645_2 in ipairs(v634_1:GetDescendants())do
            task.spawn (v634_2,v645_2)
        end
        v634_1.DescendantAdded :Connect(v634_2)
    end
    )task.spawn (function(...)
        while v0_51 and v0_51.alive do
            if v0_51.hideNotEnoughMoney then
                v0_118()
            end
            task.wait ( 0.25 )
        end
    end
    )
end
task.spawn (v0_119)
local function v0_120(v649_1,...)
    if not v649_1 then
        return 0
    end
    local v649_2=(((tostring(v649_1)):gsub( "[$,]" , "" )):gsub( "%s+" , "" )):lower()
    local v649_3=v649_2:match( "[%d%.]+" )
    if not v649_3 then
        return 0
    end
    local v649_4=tonumber(v649_3)
    if not v649_4 then
        return 0
    end
    if v649_2:find( "sp" )then
        return v649_4* 999999999999999983222784
    elseif v649_2:find( "sx" )then
        return v649_4* 1000000000000000000000
    elseif v649_2:find( "qi" )then
        return v649_4* 1000000000000000000
    elseif v649_2:find( "qa" )or v649_2:find( "q" )then
        return v649_4* 1000000000000000
    elseif v649_2:find( "t" )then
        return v649_4* 1000000000000
    elseif v649_2:find( "b" )then
        return v649_4* 1000000000
    elseif v649_2:find( "m" )then
        return v649_4* 1000000
    elseif v649_2:find( "k" )then
        return v649_4* 1000
    end
    return v649_4
end
local function v0_121(...)
    local v661_1=v0_10:FindFirstChild( "leaderstats" )
    if v661_1 then
        for v663_1,v663_2 in ipairs({ "Money" , "Cash" , "Coins" ;
            "Currency" })do
            local v663_3=v661_1:FindFirstChild(v663_2)
            if v663_3 then
                local v664_1=tonumber(v663_3.Value )or v0_120(v663_3.Value )
                if v664_1 and v664_1> 0 then
                    return v664_1
                end
            end
        end
    end
    local v661_2=v0_10:FindFirstChild( "PlayerGui" )
    if v661_2 then
        local v666_1=v661_2:FindFirstChild( "HUD" )or v661_2:FindFirstChild( "GameHUD" )or v661_2:FindFirstChild( "MainHUD" )or v661_2:FindFirstChild( "Main" )
        if v666_1 then
            for v668_1,v668_2 in ipairs(v666_1:GetDescendants())do
                if v668_2:IsA( "TextLabel" )and v668_2.Visible then
                    local v669_1=v668_2.Name :lower()
                    if v669_1== "money" or v669_1== "cash" or v669_1== "coins" or v669_1== "currency" or v669_1== "value" then
                        local v670_1=v0_120(v668_2.Text )
                        if v670_1 and v670_1> 0 then
                            return v670_1
                        end
                    end
                end
            end
        end
    end
    return 0
end
local function v0_122(...)
    local v672_1=v0_51.plot or(v0_69 and v0_69())
    if not v672_1 then
        return nil
    end
    local v672_2=v672_1:FindFirstChild( "TreadmillUpgrade" , true )
    if not v672_2 then
        return nil
    end
    local v672_3=nil
    for v675_1,v675_2 in ipairs(v672_2:GetDescendants())do
        if v675_2:IsA( "TextLabel" )or v675_2:IsA( "TextButton" )then
            local v676_1=tostring(v675_2.Text or "" )
            local v676_2=v676_1:match( "%$([%d%.,]+%s*[kKmMbBtTqQ]?[aA]?)" )
            if v676_2 then
                local v677_1=v0_120(v676_2)
                if v677_1 and v677_1> 0 then
                    if not v672_3 or v677_1>v672_3 then
                        v672_3=v677_1
                    end
                end
            end
        end
    end
    return v672_3
end
local v0_123= 0
local v0_124= 10
local function v0_125(...)
    if not v0_51.autoUpgradeTreadmill then
        return
    end
    if os.clock ()-v0_123<v0_124 then
        return
    end
    local v680_1=v0_51.plot or(v0_69 and v0_69())
    if not v680_1 then
        return
    end
    local v680_2=v680_1:FindFirstChild( "TreadmillUpgrade" , true )
    if not v680_2 then
        return
    end
    local v680_3=v0_121()
    local v680_4=v0_122()
    if v680_4 and(v680_4> 0 and v680_3<v680_4)then
        return
    end
    v0_123=os.clock ()
    if v0_33 then
        pcall(function(...) v0_33:InvokeServer()
        end
        )
    end
    local v680_5=v0_10.Character
    local v680_6=v680_5 and v680_5:FindFirstChild( "HumanoidRootPart" )pcall(function(...)
        for v689_1,v689_2 in ipairs(v680_2:GetDescendants())do
            if v689_2:IsA( "ProximityPrompt" )and v689_2.Enabled then
                if typeof(fireproximityprompt)== "function" then
                    fireproximityprompt(v689_2, 0 )fireproximityprompt(v689_2)
                end
            end
            if v689_2:IsA( "GuiButton" )and v689_2.Visible then
                local v692_1=(v689_2:IsA( "TextButton" )and v689_2.Text )or v689_2.Name
                local v692_2=string.lower (v692_1)
                if not string.find (v692_2, "robux" )and(not string.find (v692_2, "r%$" )and((string.find (v692_2, "%$" )or string.find (v692_2, "upgrade" )or string.find (v692_2, "cash" )or(v689_2.BackgroundColor3 and v689_2.BackgroundColor3.G >v689_2.BackgroundColor3.R ))))then
                    if typeof(firesignal)== "function" and v689_2.Activated then
                        firesignal(v689_2.Activated )
                    elseif typeof(firesignal)== "function" and v689_2.MouseButton1Click then
                        firesignal(v689_2.MouseButton1Click )
                    end
                end
            end
            if v689_2:IsA( "BasePart" )and(v689_2.Name :find( "Pad" )and v680_6)then
                if((v680_6.Position -v689_2.Position )).Magnitude < 10 then
                    if typeof(firetouchinterest)== "function" then
                        firetouchinterest(v680_6,v689_2, 0 )task.wait ( 0.02 )firetouchinterest(v680_6,v689_2, 1 )
                    end
                end
            end
        end
    end
    )
end
local v0_126={{[ "id" ]= "GreyTrail" ,[ "base" ]= "Grey" ,[ "name" ]= "Grey Trail" ;
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
local function v0_127(...)
    return v0_126
end
local function v0_128(...)
    local v700_1={}
    local v700_2=v0_10:FindFirstChild( "PlayerGui" )
    local v700_3=v700_2 and((v700_2:FindFirstChild( "TrailShop" )or v700_2:FindFirstChild( "TrailShop" , true )))
    local v700_4=v700_3 and v700_3:FindFirstChild( "ScrollingFrame" , true )
    if v700_4 then
        pcall(function(...)
            for v703_1,v703_2 in ipairs(v700_4:GetChildren())do
                if v703_2:IsA( "GuiObject" )and(not v703_2:IsA( "UIListLayout" )and not v703_2:IsA( "UIPadding" ))then
                    local v704_1=v703_2.Name
                    for v705_1,v705_2 in ipairs(v703_2:GetDescendants())do
                        if v705_2:IsA( "GuiButton" )or v705_2:IsA( "TextButton" )then
                            local v706_1=(v705_2:IsA( "TextButton" )and v705_2.Text :lower())or v705_2.Name :lower()
                            if v706_1:find( "unequip" )or(v706_1:find( "equip" )and not v706_1:find( "unequip" ))then
                                v700_1[v704_1]= true v700_1[v704_1:lower()]= true
                                local v707_1=v704_1:gsub( "Trail" , "" )v700_1[v707_1]= true v700_1[v707_1:lower()]= true
                            end
                        end
                    end
                end
            end
        end
        )
    end
    return v700_1
end
local function v0_129(v708_1,...)
    if not v708_1 then
        return false
    end
    pcall(function(...)
        if typeof(firebutton1click)== "function" then
            firebutton1click(v708_1)
        elseif typeof(firesignal)== "function" and v708_1.Activated then
            firesignal(v708_1.Activated )
        elseif typeof(firesignal)== "function" and v708_1.MouseButton1Click then
            firesignal(v708_1.MouseButton1Click )
        end
    end
    )
    return true
end
local function v0_130(...)
    local v714_1=v0_127()
    local v714_2=v0_128()
    local v714_3=v0_10:FindFirstChild( "PlayerGui" )
    local v714_4=v714_3 and((v714_3:FindFirstChild( "TrailShop" )or v714_3:FindFirstChild( "TrailShop" , true )))
    local v714_5=v714_4 and v714_4:FindFirstChild( "ScrollingFrame" , true )
    if v714_5 then
        for v716_1=#v714_1, 1 , -1 do
            local v716_2=v714_1[v716_1]
            local v716_3=v714_5:FindFirstChild(v716_2.id )or v714_5:FindFirstChild(v716_2.base )or v714_5:FindFirstChild(v716_2.name )
            if not v716_3 then
                for v718_1,v718_2 in ipairs(v714_5:GetChildren())do
                    if v718_2:IsA( "GuiObject" )and((v718_2.Name :lower()==v716_2.id :lower()or v718_2.Name :lower()==v716_2.base :lower()or v718_2.Name :lower()==v716_2.name :lower()))then
                        v716_3=v718_2
                        break
                    end
                end
            end
            if v716_3 then
                local v720_1= false
                local v720_2=nil
                for v721_1,v721_2 in ipairs(v716_3:GetDescendants())do
                    if v721_2:IsA( "GuiButton" )or v721_2:IsA( "TextButton" )then
                        local v722_1=(v721_2:IsA( "TextButton" )and v721_2.Text :lower())or v721_2.Name :lower()
                        if v722_1:find( "unequip" )then
                            v720_1= true
                            break
                        elseif v722_1:find( "equip" )and not v722_1:find( "unequip" )then
                            v720_2=v721_2
                        end
                    end
                end
                if v720_1 then
                    return true
                end
                if v720_2 then
                    v0_129(v720_2)
                    if v0_35 then
                        pcall(function(...) v0_35:InvokeServer(v716_2.id )
                        end
                        )
                    end
                    task.wait ( 0.2 )
                    return true
                end
            end
        end
    end
    if v0_35 then
        for v730_1=#v714_1, 1 , -1 do
            local v730_2=v714_1[v730_1]
            local v730_3=v714_2[v730_2.id ]or v714_2[v730_2.id :lower()]or v714_2[v730_2.base ]or v714_2[v730_2.base :lower()]or v714_2[v730_2.name ]or v714_2[v730_2.name :lower()]
            if v730_3 then
                pcall(function(...) v0_35:InvokeServer(v730_2.id )
                end
                )
                return true
            end
        end
    end
    return false
end
local v0_131= 0
local v0_132= 8
local function v0_133(...)
    if not v0_51.autoBuyTrails then
        return
    end
    v0_130()
    if os.clock ()-v0_131<v0_132 then
        return
    end
    local v733_1=v0_121()
    if v733_1<= 0 then
        return
    end
    local v733_2=v0_127()
    local v733_3=v0_128()
    local v733_4=v0_10:FindFirstChild( "PlayerGui" )
    local v733_5=v733_4 and((v733_4:FindFirstChild( "TrailShop" )or v733_4:FindFirstChild( "TrailShop" , true )))
    local v733_6=v733_5 and v733_5:FindFirstChild( "ScrollingFrame" , true )
    for v737_1=#v733_2, 1 , -1 do
        local v737_2=v733_2[v737_1]
        local v737_3=v733_3[v737_2.id ]or v733_3[v737_2.id :lower()]or v733_3[v737_2.base ]or v733_3[v737_2.base :lower()]or v733_3[v737_2.name ]or v733_3[v737_2.name :lower()]
        if not v737_3 and(v737_2.price > 0 and v733_1>=v737_2.price )then
            v0_131=os.clock ()
            local v738_1= false
            if v733_6 then
                local v739_1=v733_6:FindFirstChild(v737_2.id )or v733_6:FindFirstChild(v737_2.base )or v733_6:FindFirstChild(v737_2.name )
                if not v739_1 then
                    for v741_1,v741_2 in ipairs(v733_6:GetChildren())do
                        if v741_2:IsA( "GuiObject" )and((v741_2.Name :lower()==v737_2.id :lower()or v741_2.Name :lower()==v737_2.base :lower()or v741_2.Name :lower()==v737_2.name :lower()))then
                            v739_1=v741_2
                            break
                        end
                    end
                end
                if v739_1 then
                    for v744_1,v744_2 in ipairs(v739_1:GetDescendants())do
                        if v744_2:IsA( "GuiButton" )or v744_2:IsA( "TextButton" )then
                            local v745_1=(v744_2:IsA( "TextButton" )and v744_2.Text :lower())or v744_2.Name :lower()
                            if not v745_1:find( "robux" )and(not v745_1:find( "r%$" )and(not v745_1:find( "unequip" )and not v745_1:find( "equip" )))then
                                if v745_1:find( "%$" )or v745_1:find( "buy" )then
                                    v0_129(v744_2)v738_1= true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if v0_34 then
                pcall(function(...) v0_34:InvokeServer(v737_2.id )
                end
                )v738_1= true
            end
            if v738_1 then
                task.wait ( 0.3 )v0_130()
                break
            end
        end
    end
end
v0_81=function(...)
    local v751_1=v0_10.Character
    local v751_2=v751_1 and v751_1:FindFirstChild( "HumanoidRootPart" )
    if not v751_2 then
        return nil
    end
    local v751_3={}
    local v751_4=v0_2:FindFirstChild( "AreaEggSlotsClient" )
    local v751_5=v0_103( false )
    if v751_5 and#v751_5> 0 then
        for v754_1,v754_2 in ipairs(v751_5)do
            local v754_3=(v754_2.State == "Slot" or v754_2.State == "Dropped" or v754_2.State == 1 )
            local v754_4=(v754_2.AreaId == "Lake" )or(string.find (string.lower (tostring(v754_2.AreaId )), "lake" )~=nil)or(string.find (string.lower (tostring(v754_2.Uid )), "lake" )~=nil)
            local v754_5=v0_100[v754_2.Uid ]and(os.clock ()<v0_100[v754_2.Uid ])
            if v754_3 and(v754_4 and(v754_2.BoundsCFrame and not v754_5))then
                local v755_1=v754_2.BoundsCFrame.Position
                local v755_2=((v751_2.Position -v755_1)).Magnitude table.insert (v751_3,{[ "Uid" ]=v754_2.Uid ;
                [ "Model" ]=nil;
                [ "Hitbox" ]=nil;
                [ "CFrame" ]=v754_2.BoundsCFrame ,[ "Position" ]=v755_1,[ "Distance" ]=v755_2;
                [ "Area" ]= "Lake" })
            end
        end
    end
    if#v751_3== 0 and(v751_5 and#v751_5> 0 )then
        for v757_1,v757_2 in ipairs(v751_5)do
            local v757_3=(v757_2.State == "Slot" or v757_2.State == "Dropped" or v757_2.State == 1 )
            local v757_4=v757_2.BoundsCFrame and v757_2.BoundsCFrame.Position
            local v757_5=v757_4 and((v757_4.X >= 545 and v757_4.X < 850 ))
            local v757_6=v0_100[v757_2.Uid ]and(os.clock ()<v0_100[v757_2.Uid ])
            if v757_3 and(v757_5 and not v757_6)then
                table.insert (v751_3,{[ "Uid" ]=v757_2.Uid ,[ "Model" ]=nil;
                [ "Hitbox" ]=nil;
                [ "CFrame" ]=v757_2.BoundsCFrame ;
                [ "Position" ]=v757_4;
                [ "Distance" ]=((v751_2.Position -v757_4)).Magnitude ;
                [ "Area" ]=v757_2.AreaId or "Field" })
            end
        end
    end
    if#v751_3== 0 then
        return nil
    end
    table.sort (v751_3,function(v760_1,v760_2,...)
        return v760_1.Distance <v760_2.Distance
    end
    )
    local v751_6=v751_3[ 1 ]
    if v751_6 and v751_4 then
        for v762_1,v762_2 in ipairs(v751_4:GetChildren())do
            local v762_3=v762_2:FindFirstChildWhichIsA( "BasePart" )or v762_2.PrimaryPart
            if v762_3 and((v762_3.Position -v751_6.Position )).Magnitude <= 8 then
                v751_6.Model =v762_2
                break
            end
        end
    end
    return v751_6
end
local v0_134=nil
local v0_135=nil
local v0_136= 350
local function v0_137(...)
    local v764_1=v0_2:FindFirstChild( "__OBJECTS" )or v0_2:FindFirstChild( "Objects" )
    local v764_2=v764_1 and((v764_1:FindFirstChild( "Areas" )or v764_1:FindFirstChild( "Area" )))
    local v764_3=v764_2 and((v764_2:FindFirstChild( "GuardAreas" )or v764_2:FindFirstChild( "Guards" )))
    if v764_3 then
        local v765_1=v764_3:FindFirstChild( "Light Dark" )or v764_3:FindFirstChild( "LightDark" )or v764_3:FindFirstChild( "Light_Dark" )or v764_3:FindFirstChild( "Light-Dark" )
        if v765_1 then
            return v765_1
        end
        for v767_1,v767_2 in ipairs(v764_3:GetChildren())do
            local v767_3=string.lower (v767_2.Name )
            if string.find (v767_3, "light" )and string.find (v767_3, "dark" )then
                return v767_2
            end
        end
    end
    if v764_2 then
        local v769_1=v764_2:FindFirstChild( "Light Dark" )or v764_2:FindFirstChild( "LightDark" )or v764_2:FindFirstChild( "Light_Dark" )
        if v769_1 then
            return v769_1
        end
        for v771_1,v771_2 in ipairs(v764_2:GetChildren())do
            local v771_3=string.lower (v771_2.Name )
            if string.find (v771_3, "light" )and string.find (v771_3, "dark" )then
                return v771_2
            end
        end
    end
    for v773_1,v773_2 in ipairs(v0_2:GetChildren())do
        local v773_3=v773_2.Name
        if v773_3== "__OBJECTS" or v773_3== "Objects" or v773_3== "Areas" or v773_3== "Map" then
            for v775_1,v775_2 in ipairs(v773_2:GetDescendants())do
                local v775_3=string.lower (v775_2.Name )
                if(v775_3== "light dark" or v775_3== "lightdark" or(string.find (v775_3, "light" )and string.find (v775_3, "dark" )))then
                    if v775_2:IsA( "BasePart" )or v775_2:IsA( "Model" )or v775_2:IsA( "Folder" )then
                        return v775_2
                    end
                end
            end
        end
    end
    return nil
end
local function v0_138(v778_1,...)
    if not v778_1 then
        return false
    end
    if v0_134 then
        local v780_1=((Vector3.new (v778_1.X , 0 ,v778_1.Z )-Vector3.new (v0_134.X , 0 ,v0_134.Z ))).Magnitude
        if v780_1<=v0_136 then
            return true
        end
    end
    local v778_2=v0_137()
    if not v778_2 then
        if v778_1.X >= 5200 then
            return true
        end
        return false
    end
    local v778_3= false pcall(function(...)
        local v784_1,v784_2=nil,nil
        if v778_2:IsA( "BasePart" )then
            v784_1=v778_2.CFrame v784_2=v778_2.Size
        elseif v778_2:IsA( "Model" )then
            v784_1,v784_2=v778_2:GetBoundingBox()
        else
            local v787_1,v787_2=nil,nil
            for v788_1,v788_2 in ipairs(v778_2:GetChildren())do
                if v788_2:IsA( "BasePart" )then
                    local v789_1=v788_2.CFrame
                    local v789_2=v788_2.Size / 2
                    local v789_3=v789_1.Position -v789_2
                    local v789_4=v789_1.Position +v789_2
                    if not v787_1 then
                        v787_1=v789_3 v787_2=v789_4
                    else
                        v787_1=Vector3.new (math.min (v787_1.X ,v789_3.X ),math.min (v787_1.Y ,v789_3.Y ),math.min (v787_1.Z ,v789_3.Z ))v787_2=Vector3.new (math.max (v787_2.X ,v789_4.X ),math.max (v787_2.Y ,v789_4.Y ),math.max (v787_2.Z ,v789_4.Z ))
                    end
                end
            end
            if v787_1 and v787_2 then
                v784_1=CFrame.new (((v787_1+v787_2))/ 2 )v784_2=v787_2-v787_1
            end
        end
        if v784_1 and v784_2 then
            v0_134=v784_1.Position v0_135=v784_1 v0_136=math.max ( 350 ,math.max (v784_2.X ,v784_2.Z )/ 2 + 150 )
            local v793_1=((Vector3.new (v778_1.X , 0 ,v778_1.Z )-Vector3.new (v784_1.Position.X , 0 ,v784_1.Position.Z ))).Magnitude
            if v793_1<=v0_136 then
                v778_3= true
                return
            end
            local v793_2=v784_1:PointToObjectSpace(v778_1)
            local v793_3=v784_2/ 2
            if math.abs (v793_2.X )<=(v793_3.X + 200 )and math.abs (v793_2.Z )<=(v793_3.Z + 200 )then
                v778_3= true
                return
            end
        end
        for v796_1,v796_2 in ipairs(v778_2:GetDescendants())do
            if v796_2:IsA( "BasePart" )then
                if((v778_1-v796_2.Position )).Magnitude <= 250 then
                    v778_3= true
                    if not v0_134 then
                        v0_134=v796_2.Position
                    end
                    return
                end
            end
        end
    end
    )
    return v778_3
end
local function v0_139(v800_1,v800_2,v800_3,...)
    local v800_4=v800_2 and v800_2.X or 0
    local v800_5=string.lower (tostring(v800_1 or "" ))
    local v800_6=string.lower (tostring(v800_3 or "" ))
    if v800_6~= "" and v800_6~= "egg" then
        if string.find (v800_6, "spideron" )or string.find (v800_6, "crustacia" )or string.find (v800_6, "bladehide" )or string.find (v800_6, "mantaris" )or string.find (v800_6, "rhinotaur" )or string.find (v800_6, "mutantshark" )or string.find (v800_6, "mutant shark" )or string.find (v800_6, "gorillaking" )or string.find (v800_6, "gorilla king" )or string.find (v800_6, "nightflame" )then
            return "Titan Temple"
        end
        if string.find (v800_6, "crane" )or string.find (v800_6, "salamander" )or string.find (v800_6, "redpanda" )or string.find (v800_6, "red panda" )or string.find (v800_6, "snowyowl" )or string.find (v800_6, "snowy owl" )or string.find (v800_6, "koiegg" )or string.find (v800_6, "koi egg" )or string.find (v800_6, "stagegg" )or string.find (v800_6, "stag egg" )or string.find (v800_6, "onitiger" )or string.find (v800_6, "oni tiger" )or string.find (v800_6, "kitsune" )then
            return "Cherry Blossom"
        end
        if string.find (v800_6, "centapede" )or string.find (v800_6, "cosmicgecko" )or string.find (v800_6, "cosmic gecko" )or string.find (v800_6, "cosmicgorilla" )or string.find (v800_6, "cosmic gorilla" )or string.find (v800_6, "saturno" )or string.find (v800_6, "saturnita" )or string.find (v800_6, "vacca" )or string.find (v800_6, "cosmic skeleton" )or string.find (v800_6, "skeletonboss" )or string.find (v800_6, "skeleton boss" )or string.find (v800_6, "cosmicdragon" )or string.find (v800_6, "cosmic dragon" )or string.find (v800_6, "lunardragon" )or string.find (v800_6, "lunar dragon" )or string.find (v800_6, "unicornegg" )or string.find (v800_6, "unicorn egg" )then
            return "Cosmic"
        end
        if string.find (v800_6, "dodo" )or string.find (v800_6, "pterodactyl" )or string.find (v800_6, "ankylosaurus" )or string.find (v800_6, "triceratops" )or string.find (v800_6, "bronto" )or string.find (v800_6, "trex" )or string.find (v800_6, "t-rex" )or string.find (v800_6, "tralaledon" )or string.find (v800_6, "mosasaurus" )then
            return "Prehistoric"
        end
        if string.find (v800_6, "parrotfish" )or string.find (v800_6, "swordfish" )or string.find (v800_6, "whaleshark" )or string.find (v800_6, "whale shark" )or string.find (v800_6, "belugawhale" )or string.find (v800_6, "beluga whale" )or string.find (v800_6, "kraken" )or string.find (v800_6, "elmaja" )or string.find (v800_6, "el maja" )then
            return "Abyss Ocean"
        end
        if string.find (v800_6, "lava gecko" )or string.find (v800_6, "lava frog" )or string.find (v800_6, "flaming bull" )or string.find (v800_6, "lava iguana" )or string.find (v800_6, "chillin chilli" )or string.find (v800_6, "cerberus" )or string.find (v800_6, "phoenix" )or string.find (v800_6, "lava dragon" )then
            return "Volcano"
        end
        if string.find (v800_6, "penguin" )or string.find (v800_6, "walrus" )or string.find (v800_6, "polar bear" )or string.find (v800_6, "polarbear" )or string.find (v800_6, "sabertooth" )or string.find (v800_6, "mammoth" )or string.find (v800_6, "yeti" )or string.find (v800_6, "ice dragon" )or string.find (v800_6, "icedragon" )then
            return "Snow"
        end
        if string.find (v800_6, "sand spider" )or string.find (v800_6, "sandspider" )or string.find (v800_6, "royal sphinx" )or string.find (v800_6, "sphinx" )or string.find (v800_6, "tob tobi" )or string.find (v800_6, "tobtobi" )or string.find (v800_6, "jerboa" )or string.find (v800_6, "fennec" )or string.find (v800_6, "camel" )then
            return "Desert"
        end
        if string.find (v800_6, "chimpanzee" )or string.find (v800_6, "toucan" )or string.find (v800_6, "crocodile" )or string.find (v800_6, "orangutini" )or string.find (v800_6, "ananassini" )or string.find (v800_6, "king snake" )or string.find (v800_6, "kingsnake" )then
            return "Jungle"
        end
        if string.find (v800_6, "duckling" )or string.find (v800_6, "catfish" )or string.find (v800_6, "turtle" )or string.find (v800_6, "trulimero" )or string.find (v800_6, "trulicina" )or string.find (v800_6, "swan" )or string.find (v800_6, "axolotl" )or string.find (v800_6, "leviathan" )then
            return "Lake"
        end
        if string.find (v800_6, "burrowing owl" )or string.find (v800_6, "burrowingowl" )or string.find (v800_6, "brr brr" )or string.find (v800_6, "patapim" )or string.find (v800_6, "chicken" )or string.find (v800_6, "dog" )or string.find (v800_6, "bird" )or string.find (v800_6, "raccoon" )or string.find (v800_6, "fox" )then
            return "Forest"
        end
        if string.find (v800_6, "shark" )then
            return "Abyss Ocean"
        end
        if string.find (v800_6, "snake" )then
            return "Desert"
        end
        if string.find (v800_6, "spider" )then
            return "Jungle"
        end
        if string.find (v800_6, "gorilla" )then
            return "Jungle"
        end
        if string.find (v800_6, "tiger" )then
            return "Jungle"
        end
        if string.find (v800_6, "frog" )then
            return "Lake"
        end
        if string.find (v800_6, "bear" )then
            return "Forest"
        end
    end
    if(string.find (v800_5, "light" )and string.find (v800_5, "dark" ))or v800_5== "lightdark" then
        return "Light Dark"
    elseif string.find (v800_5, "titan" )then
        return "Titan Temple"
    elseif string.find (v800_5, "cherry" )then
        return "Cherry Blossom"
    elseif string.find (v800_5, "cosmic" )then
        return "Cosmic"
    elseif string.find (v800_5, "prehistoric" )or string.find (v800_5, "dino" )then
        return "Prehistoric"
    elseif string.find (v800_5, "abyss" )or string.find (v800_5, "ocean" )then
        return "Abyss Ocean"
    elseif string.find (v800_5, "volcano" )or string.find (v800_5, "lava" )then
        return "Volcano"
    elseif string.find (v800_5, "snow" )or string.find (v800_5, "ice" )or string.find (v800_5, "winter" )then
        return "Snow"
    elseif string.find (v800_5, "jungle" )then
        return "Jungle"
    elseif string.find (v800_5, "desert" )or string.find (v800_5, "sand" )then
        return "Desert"
    elseif string.find (v800_5, "lake" )or string.find (v800_5, "water" )then
        return "Lake"
    elseif string.find (v800_5, "forest" )then
        return "Forest"
    end
    if v800_4> 0 then
        if v800_4>= 5200 then
            return "Light Dark"
        elseif v800_4>= 4750 then
            return "Titan Temple"
        elseif v800_4>= 4000 then
            return "Cherry Blossom"
        elseif v800_4>= 3350 then
            return "Cosmic"
        elseif v800_4>= 2780 then
            return "Prehistoric"
        elseif v800_4>= 2250 then
            return "Abyss Ocean"
        elseif v800_4>= 1850 then
            return "Volcano"
        elseif v800_4>= 1450 then
            return "Snow"
        elseif v800_4>= 1150 then
            return "Jungle"
        elseif v800_4>= 920 then
            return "Desert"
        elseif v800_4>= 720 then
            return "Lake"
        else
            return "Forest"
        end
    end
    return "Forest"
end
v0_82=function(...)
    local v845_1=v0_103( false )
    if not v845_1 or#v845_1== 0 then
        v845_1=v0_103( true )
    end
    if not v845_1 or#v845_1== 0 then
        return nil
    end
    local v845_2=v0_10.Character
    local v845_3=v845_2 and v845_2:FindFirstChild( "HumanoidRootPart" )
    local v845_4=v845_3 and v845_3.Position or Vector3.new ( 525 , 70 , -360 )
    local function v845_5(v848_1,...) v848_1=tonumber(v848_1)or 0
        if v848_1>= 1000000000000 then
            return string.format ( "%.1fT" ,v848_1/ 1000000000000 )
        end
        if v848_1>= 1000000000 then
            return string.format ( "%.1fB" ,v848_1/ 1000000000 )
        end
        if v848_1>= 1000000 then
            return string.format ( "%.1fM" ,v848_1/ 1000000 )
        end
        if v848_1>= 1000 then
            return string.format ( "%.1fK" ,v848_1/ 1000 )
        end
        return string.format ( "%.0f" ,v848_1)
    end
    local function v845_6(v853_1,v853_2,v853_3,v853_4,...)
        if v853_1 and v853_1.PhysicalModel then
            local v854_1=v853_1.PhysicalModel
            local v854_2=v854_1:GetAttribute( "Rarity" )or v854_1:GetAttribute( "RarityTier" )or v854_1:GetAttribute( "Tier" )
            if v854_2 and(tostring(v854_2)~= "" and tostring(v854_2)~= "Unknown" )then
                v853_3=tostring(v854_2)
            end
            if not v853_2 or v853_2== "Egg" or v853_2== "" then
                v853_2=v854_1:GetAttribute( "Category" )or v854_1:GetAttribute( "AssetCategory" )or v854_1.Name
            end
        end
        local v853_5=string.lower (tostring(v853_1.Rarity or "" ))
        local v853_6=string.lower (tostring(v853_3 or "" ))
        for v857_1,v857_2 in ipairs({v853_5,v853_6})do
            if v857_2~= "" and(v857_2~= "unknown" and v857_2~= "nil" )then
                if string.find (v857_2, "divine" )then
                    return 6 , "Divine"
                end
                if string.find (v857_2, "eternal" )then
                    return 5 , "Eternal"
                end
                if string.find (v857_2, "secret" )then
                    return 4 , "Secret"
                end
                if string.find (v857_2, "cosmic" )then
                    return 3 , "Cosmic"
                end
                if string.find (v857_2, "mythic" )then
                    return 2 , "Mythic"
                end
                if string.find (v857_2, "legendary" )then
                    return 1 , "Legendary"
                end
                if string.find (v857_2, "epic" )then
                    return 0.5 , "Epic"
                end
                if string.find (v857_2, "rare" )then
                    return 0.3 , "Rare"
                end
                if string.find (v857_2, "uncommon" )then
                    return 0.1 , "Uncommon"
                end
                if string.find (v857_2, "common" )then
                    return 0 , "Common"
                end
            end
        end
        if v853_4 and v853_4>= 10 then
            return 6 , "Divine"
        elseif v853_4 and v853_4>= 9 then
            return 5 , "Eternal"
        elseif v853_4 and v853_4>= 8 then
            return 4 , "Secret"
        elseif v853_4 and v853_4>= 7 then
            return 3 , "Cosmic"
        elseif v853_4 and v853_4>= 6 then
            return 2 , "Mythic"
        elseif v853_4 and v853_4>= 5 then
            return 1 , "Legendary"
        elseif v853_4 and v853_4>= 4 then
            return 0.5 , "Epic"
        elseif v853_4 and v853_4>= 3 then
            return 0.3 , "Rare"
        elseif v853_4 and v853_4>= 2 then
            return 0.1 , "Uncommon"
        elseif v853_4 and v853_4>= 1 then
            return 0 , "Common"
        end
        local v853_7=string.lower (string.format ( "%s %s %s %s %s" ,tostring(v853_2 or "" ),tostring(v853_1.Uid or "" ),tostring(v853_1.Name or "" ),tostring(v853_1.DisplayName or "" ),tostring(v853_1.EggName or "" )))
        if string.find (v853_7, "nightflame" )or string.find (v853_7, "unicornegg" )or string.find (v853_7, "unicorn egg" )or string.find (v853_7, "shatteredcolossus" )or string.find (v853_7, "kitsune" )or string.find (v853_7, "elmaja" )or string.find (v853_7, "el maja" )then
            return 6 , "Divine"
        end
        if string.find (v853_7, "gorillaking" )or string.find (v853_7, "gorilla king" )or string.find (v853_7, "lunardragon" )or string.find (v853_7, "lunar dragon" )or string.find (v853_7, "onitiger" )or string.find (v853_7, "oni tiger" )or string.find (v853_7, "mosasaurus" )then
            return 5 , "Eternal"
        end
        if string.find (v853_7, "mutantshark" )or string.find (v853_7, "mutant shark" )or string.find (v853_7, "skeletonboss" )or string.find (v853_7, "skeleton boss" )or string.find (v853_7, "stagegg" )or string.find (v853_7, "stag egg" )or string.find (v853_7, "cosmicdragon" )or string.find (v853_7, "cosmic dragon" )or string.find (v853_7, "trex" )or string.find (v853_7, "t-rex" )or string.find (v853_7, "tralaledon" )or string.find (v853_7, "kraken" )then
            return 4 , "Secret"
        end
        if string.find (v853_7, "saturnita" )or string.find (v853_7, "saturno" )or string.find (v853_7, "mantaris" )or string.find (v853_7, "rhinotaur" )or string.find (v853_7, "snowyowl" )or string.find (v853_7, "snowy owl" )or string.find (v853_7, "koiegg" )or string.find (v853_7, "koi egg" )or string.find (v853_7, "triceratops" )or string.find (v853_7, "bronto" )or string.find (v853_7, "whaleshark" )or string.find (v853_7, "whale shark" )or string.find (v853_7, "belugawhale" )or string.find (v853_7, "beluga whale" )then
            return 3 , "Cosmic"
        end
        if string.find (v853_7, "bladehide" )or string.find (v853_7, "redpanda" )or string.find (v853_7, "red panda" )or string.find (v853_7, "cosmicgorilla" )or string.find (v853_7, "cosmic gorilla" )or string.find (v853_7, "ankylosaurus" )or string.find (v853_7, "orca" )then
            return 2 , "Mythic"
        end
        if string.find (v853_7, "spideron" )or string.find (v853_7, "crustacia" )or string.find (v853_7, "salamander" )or string.find (v853_7, "cosmicgecko" )or string.find (v853_7, "cosmic gecko" )or string.find (v853_7, "pterodactyl" )or string.find (v853_7, "sharkegg" )or string.find (v853_7, "shark egg" )then
            return 1 , "Legendary"
        end
        if string.find (v853_7, "crane" )or string.find (v853_7, "centapede" )or string.find (v853_7, "swordfish" )then
            return 0.5 , "Epic"
        end
        if string.find (v853_7, "dodo" )or string.find (v853_7, "parrotfish" )then
            return 0.3 , "Rare"
        end
        local v853_8=tonumber(v853_1.EarningRate or v853_1.Income or 0 )
        if v853_8 and v853_8>= 150000000 then
            return 4 , "Secret"
        end
        local v853_9=(v853_3 and(v853_3~= "Unknown" and v853_3))or "Common"
        local v853_10=v0_50[v853_9]or 0
        return v853_10,v853_9
    end
    local function v845_7(v888_1,v888_2,...)
        local v888_3={}
        for v889_1,v889_2 in ipairs(v845_1)do
            local v889_3=(v889_2.State == "Slot" or v889_2.State == "Dropped" or v889_2.State == "GuardCarried" or v889_2.State == 1 )
            local v889_4=(v889_2.BoundsCFrame and v889_2.BoundsCFrame.Position .X < 530 )or string.find (tostring(v889_2.Uid ), "FirstArea" )
            local v889_5=v0_100[v889_2.Uid ]and(os.clock ()<v0_100[v889_2.Uid ])
            if v889_3 and(not v889_4 and(((v888_2 or not v889_5))and v889_2.BoundsCFrame ))then
                local v890_1=v889_2.AssetCategory or "Egg"
                local v890_2= 0
                local v890_3= 0
                local v890_4= 0
                local v890_5= "Unknown"
                if v0_19 then
                    pcall(function(...)
                        if v0_19.RarityRankForCategory then
                            v890_2=v0_19.RarityRankForCategory (v890_1)or 0
                        end
                        if v0_19.ProfileIncomePerSecond then
                            v890_3=v0_19.ProfileIncomePerSecond (v890_1)or 0
                        end
                        if v0_19.SalePrice then
                            v890_4=v0_19.SalePrice (v890_1)or 0
                        end
                        if v0_19.Assets and v0_19.Assets [v890_1]then
                            local v896_1=v0_19.Assets [v890_1]v890_5=v896_1.Rarity or(v896_1.Egg and v896_1.Egg.Rarity )or "Unknown"
                            if not v890_3 or v890_3== 0 then
                                v890_3=v896_1.EarningRate or(v896_1.Egg and v896_1.Egg.EarningRate )or 0
                            end
                        end
                    end
                    )
                end
                local v890_6=v889_2.BoundsCFrame.Position .X
                local v890_7=v889_2.BoundsCFrame.Position
                local v890_8=v889_2.AreaId
                if((not v890_8 or v890_8== "" or v890_8== "Unknown" ))and v889_2.PhysicalModel then
                    v890_8=v889_2.PhysicalModel :GetAttribute( "AreaId" )or v889_2.PhysicalModel :GetAttribute( "Area" )
                end
                local v890_9=string.format ( "%s %s %s %s" ,tostring(v890_1 or "" ),tostring(v889_2.Uid or "" ),tostring(v889_2.Name or "" ),(v889_2.PhysicalModel and v889_2.PhysicalModel.Name )or "" )
                local v890_10=v0_139(v890_8,v890_7,v890_9)
                local v890_11,v890_12=v845_6(v889_2,v890_1,v890_5,v890_2)
                local v890_13=(v890_11>= 4 or v890_12== "Secret" or v890_12== "Eternal" or v890_12== "Divine" )
                local v890_14=(v0_51.selectedZones and v0_51.selectedZones [v890_10]== true )
                local v890_15=(v0_51.selectedRarities and v0_51.selectedRarities [v890_12]== true )
                local v890_16= false
                if v890_13 then
                    v890_16= true
                else
                    if v890_14 and v890_15 then
                        v890_16= true
                    end
                end
                if v890_16 then
                    local v902_1=tonumber(v889_2.AssetScale or v889_2.Scale )or 1
                    local v902_2= 1
                    if v889_2.Mutations and type(v889_2.Mutations )== "table" then
                        for v904_1,v904_2 in pairs(v889_2.Mutations )do
                            local v904_3=(type(v904_2)== "table" and tonumber(v904_2.Multiplier or v904_2.Value ))or tonumber(v904_2)or 1.5 v902_2=v902_2*v904_3
                        end
                    elseif v889_2.Mutation then
                        v902_2= 1.5
                    end
                    local v902_3=(v890_3*v902_1)*v902_2
                    local v902_4=v0_37[v890_10]or 50
                    if v902_3<= 0 then
                        v902_3=(((v902_4^ 2 )*v902_1)*v902_2)* 10
                    end
                    local v902_5=((v845_4-v889_2.BoundsCFrame.Position )).Magnitude table.insert (v888_3,{[ "Uid" ]=v889_2.Uid ,[ "Category" ]=tostring(v890_1),[ "Area" ]=tostring(v890_10),[ "ZoneWeight" ]=v902_4,[ "Rarity" ]=tostring(v890_12);
                    [ "RarityTier" ]=v890_11;
                    [ "Rank" ]=v890_2;
                    [ "Income" ]=v890_3,[ "RealIncome" ]=v902_3;
                    [ "Scale" ]=v902_1,[ "MutMultiplier" ]=v902_2,[ "CFrame" ]=v889_2.BoundsCFrame ;
                    [ "Position" ]=v889_2.BoundsCFrame.Position ,[ "Distance" ]=v902_5,[ "Model" ]=v889_2.PhysicalModel })
                end
            end
        end
        if#v888_3== 0 then
            return nil
        end
        local function v888_4(v908_1,...)
            local v908_2=v908_1.RarityTier or 0
            local v908_3=v908_1.ZoneWeight or 50
            if v908_2>= 4 then
                return( 400000 +(v908_2* 10000 ))+v908_3
            else
                return(v908_3* 11 )+(v908_2* 1000 )
            end
        end
        table.sort (v888_3,function(v911_1,v911_2,...)
            local v911_3=v888_4(v911_1)
            local v911_4=v888_4(v911_2)
            if v911_3~=v911_4 then
                return v911_3>v911_4
            end
            if v911_1.ZoneWeight ~=v911_2.ZoneWeight then
                return v911_1.ZoneWeight >v911_2.ZoneWeight
            end
            if math.abs (v911_1.RealIncome -v911_2.RealIncome )> 1 then
                return v911_1.RealIncome >v911_2.RealIncome
            end
            if math.abs (v911_1.Scale -v911_2.Scale )> 0.05 then
                return v911_1.Scale >v911_2.Scale
            end
            return v911_1.Distance <v911_2.Distance
        end
        )
        local v888_5=v888_3[ 1 ]
        local v888_6={}
        for v916_1= 1 ,math.min ( 3 ,#v888_3), 1 do
            local v916_2=v888_3[v916_1]table.insert (v888_6,string.format ( "#%d %s[%s|%s] Score:%d $%s/s (%.1fx) dist=%dm" ,v916_1,tostring(v916_2.Category ),tostring(v916_2.Rarity ),tostring(v916_2.Area ),v888_4(v916_2),v845_5(v916_2.RealIncome ),tonumber(v916_2.Scale )or 1 ,math.floor (tonumber(v916_2.Distance )or 0 )))
        end
        if#v888_6> 0 then
            v0_16( "[AutoSteal v42.44] " ..table.concat (v888_6, " | " ))
        end
        return v888_5
    end
    local v845_8=v845_7( false , false )
    if not v845_8 then
        v0_100={}v845_8=v845_7( false , true )
    end
    if not v845_8 then
        v845_1=v0_103( true )v845_8=v845_7( false , true )
    end
    if v845_8 and v0_2:FindFirstChild( "AreaEggSlotsClient" )then
        for v921_1,v921_2 in ipairs(v0_2.AreaEggSlotsClient :GetChildren())do
            local v921_3=v921_2:FindFirstChildWhichIsA( "BasePart" )or v921_2.PrimaryPart
            if v921_3 and((v921_3.Position -v845_8.Position )).Magnitude <= 12 then
                v845_8.Model =v921_2
                break
            end
        end
    end
    return v845_8
end
v0_83=function(v923_1,v923_2,v923_3,v923_4,...)
    local v923_5=v0_10.Character
    local v923_6=v923_5 and v923_5:FindFirstChild( "HumanoidRootPart" )
    local v923_7=v923_5 and v923_5:FindFirstChildOfClass( "Humanoid" )
    if not v923_6 or not v923_7 then
        return false
    end
    v0_51.securingEgg = true v0_51.isReturning = false v0_51.stateTime =os.clock ()v0_51.holdingEggForGuard = true
    local v923_8=v923_2.Position v0_67(v923_8, 14 )v0_51.currentTargetModel =v923_3 v0_51.targetPosition =v923_8 v923_6.AssemblyLinearVelocity =Vector3.zero v923_6.AssemblyAngularVelocity =Vector3.zero v0_97(v923_5)pcall(function(...) v0_10:RequestStreamAroundAsync(v923_8)
    end
    )
    if not v923_3 and v0_2:FindFirstChild( "AreaEggSlotsClient" )then
        for v927_1,v927_2 in ipairs(v0_2.AreaEggSlotsClient :GetChildren())do
            local v927_3=v927_2:FindFirstChildWhichIsA( "BasePart" )or v927_2.PrimaryPart
            if v927_3 and((v927_3.Position -v923_8)).Magnitude <= 16 then
                v923_3=v927_2 v0_51.currentTargetModel =v927_2
                break
            end
        end
    end
    if v923_3 then
        pcall(function(...)
            for v931_1,v931_2 in ipairs(v923_3:GetDescendants())do
                if v931_2:IsA( "BasePart" )and(v931_2.Transparency > 0.8 and(v931_2.Name ~= "Hitbox" and(v931_2.Name ~= "Root" and not v931_2.Name :find( "Pad" ))))then
                    v931_2.Transparency = 0
                end
            end
        end
        )
    end
    v0_51.statusText = "[1/4] Lifting Egg to Trigger Guard..." v0_16(string.format ( "[GuardStrike] Step 1: Lifting target egg (%s)..." ,tostring(v923_1)))
    local v923_9=os.clock ()+ 3.5
    local v923_10= 0
    while not v0_62()and(os.clock ()<v923_9 and(v0_51.alive and v0_51.securingEgg ))do
        if v923_4 and v0_104~=v923_4 then
            v0_17( "[GuardStrike] Cancelled by session switch in Step 1" )
            break
        end
        if not v0_51.pureTweenFarm and(not v0_51.autoFarmLoop and not v0_51.teleporting )then
            break
        end
        if v923_1 and(os.clock ()-v923_10> 0.4 )then
            v923_10=os.clock ()
            local v936_1,v936_2=v0_64(v923_1)
            if not v936_1 and v936_2== "CarriedByOther" then
                v0_17(string.format ( "[GuardStrike] Target egg %s was snatched by another player! Aborting pickup..." ,tostring(v923_1)))
                break
            end
        end
        v923_5:PivotTo(v923_2*CFrame.new ( 0 , 0.4 , 0 ))v0_99(v923_3,v923_8)
        if v923_1 and v0_25 then
            task.spawn (function(...) pcall(function(...)
                    if v0_25:IsA( "RemoteFunction" )then
                        v0_25:InvokeServer({[ "Uid" ]=v923_1})v0_25:InvokeServer(v923_1)
                    else
                        v0_25:FireServer({[ "Uid" ]=v923_1})v0_25:FireServer(v923_1)
                    end
                end
                )
            end
            )
        end
        v0_3.Heartbeat :Wait()
    end
    if not v0_62()then
        v0_17( "[GuardStrike] Initial egg pickup timed out or egg was stolen" )
        if v923_1 then
            v0_100[v923_1]=os.clock ()+ 2
        end
        v0_51.currentTargetModel =nil v0_51.targetPosition =nil v0_51.securingEgg = false v0_51.holdingEggForGuard = false
        return false
    end
    v0_51.statusText = "[2/4] Waiting for Guard Strike..." v0_16( "[GuardStrike] Step 2: Egg lifted! Triggering guard strike..." )
    local v923_11=os.clock ()
    local v923_12=v923_11+ 4.5
    local v923_13= false
    while v0_62()and(os.clock ()<v923_12 and(v0_51.alive and v0_51.securingEgg ))do
        if v923_4 and v0_104~=v923_4 then
            v0_17( "[GuardStrike] Cancelled by session switch in Step 2" )
            break
        end
        if not v0_51.pureTweenFarm and(not v0_51.autoFarmLoop and not v0_51.teleporting )then
            break
        end
        v923_5:PivotTo(v923_2*CFrame.new ( 0 , 0.4 , 0 ))v0_67(v923_8, 14 )
        if v0_29 and not v923_13 then
            task.spawn (function(...) pcall(function(...)
                    if v0_29:IsA( "RemoteFunction" )then
                        v0_29:InvokeServer()
                    else
                        v0_29:FireServer()
                    end
                end
                )
            end
            )v923_13= true
        end
        v0_3.Heartbeat :Wait()
    end
    v0_51.statusText = "[3/4] Re-grabbing Egg..." v0_16( "[GuardStrike] Step 3: Guard struck! Re-grabbing egg..." )
    local v923_14=os.clock ()+ 3
    while not v0_62()and(os.clock ()<v923_14 and(v0_51.alive and v0_51.securingEgg ))do
        if v923_4 and v0_104~=v923_4 then
            v0_17( "[GuardStrike] Cancelled by session switch in Step 3" )
            break
        end
        if not v0_51.pureTweenFarm and(not v0_51.autoFarmLoop and not v0_51.teleporting )then
            break
        end
        v923_5:PivotTo(v923_2*CFrame.new ( 0 , 0.4 , 0 ))v0_99(v923_3,v923_8)
        if v923_1 and v0_25 then
            task.spawn (function(...) pcall(function(...)
                    if v0_25:IsA( "RemoteFunction" )then
                        v0_25:InvokeServer({[ "Uid" ]=v923_1})v0_25:InvokeServer(v923_1)
                    else
                        v0_25:FireServer({[ "Uid" ]=v923_1})v0_25:FireServer(v923_1)
                    end
                end
                )
            end
            )
        end
        v0_3.Heartbeat :Wait()
    end
    local v923_15=v0_63(v923_1)
    if not v923_15 then
        task.wait ( 0.12 )v923_15=v0_63(v923_1)
    end
    v0_51.currentTargetModel =nil v0_51.targetPosition =nil v0_51.securingEgg = false v0_51.holdingEggForGuard = false
    if v923_4 and v0_104~=v923_4 then
        return false
    end
    if v923_15 then
        pcall(v0_61)v0_16( "[GuardStrike] Egg successfully secured after guard strike! Stashed in backpack." )v0_51.statusText = "Egg Secured! Tweening along Z=-360..."
    else
        v0_17( "[-] Failed to re-grab egg after guard strike (stolen or despawned)" )v0_51.statusText = "[-] Failed to re-grab egg"
        if v923_1 then
            v0_100[v923_1]=os.clock ()+ 2
        end
    end
    return v923_15
end
v0_84=function(v966_1,v966_2,...)
    if v0_51.teleporting or v0_51.glidingToTarget or v0_51.delivering or v0_51.securingEgg then
        return false
    end
    v0_51.teleporting = true v0_51.isReturning = false v0_51.stateTime =os.clock ()
    local v966_3=v0_10.Character
    local v966_4=v966_3 and v966_3:FindFirstChild( "HumanoidRootPart" )
    local v966_5=v966_3 and v966_3:FindFirstChildOfClass( "Humanoid" )
    if not v966_4 or not v966_5 then
        v0_85()
        return false
    end
    if v966_5 then
        v966_5:UnequipTools()
    end
    v0_51.statusText = "[1/7] Pre-Flight Desync..."
    if not v0_51.swapped then
        v0_95()
    end
    if not v0_51.godmode then
        v0_94( true )
    end
    v0_97(v966_3)
    if not v966_1 then
        v966_1=v0_82()
    end
    local v966_6=v966_1 and v966_1.CFrame or v0_44
    local v966_7=v966_1 and v966_1.Uid
    local v966_8=v966_6.Position
    if v966_7 then
        local v973_1,v973_2=v0_64(v966_7)
        if not v973_1 and v973_2~= "CarriedBySelf" then
            v0_17(string.format ( "[Snipe] Target egg %s is already taken (%s)! Selecting next target..." ,tostring(v966_7),tostring(v973_2)))v0_51.statusText = "Target taken by another player!" v0_100[v966_7]=os.clock ()+ 5 v0_85()
            return false
        end
    end
    local v966_9=select( 2 ,v0_58())
    if not v966_9 then
        local v975_1=v0_81()
        if not v975_1 then
            v0_17( "[-] Lake egg not found" )v0_51.statusText = "[-] No Lake egg found" v0_85()
            return false
        end
        v0_51.currentTargetModel =v975_1.Model v0_51.targetPosition =v975_1.Position
        local v975_2=((v966_4.Position -v975_1.Position )).Magnitude
        local v975_3=v975_1.CFrame *CFrame.new ( 0 , 0.4 , 0 )pcall(function(...) v0_10:RequestStreamAroundAsync(v975_1.Position )
        end
        )v0_67(v975_1.Position , 8 )
        if v975_2> 60 then
            v0_51.statusText =string.format ( "[2/7] Gliding to Lake Egg (%.0f studs)..." ,v975_2)v0_51.glidingToTarget = true
            local v978_1=v0_78(v975_3,v0_51.glideSpeed ,v975_1.Uid ,v966_2)v0_51.glidingToTarget = false
            if not v978_1 then
                v0_17( "[-] Lake starter egg was taken during flight" )v0_100[v975_1.Uid ]=os.clock ()+ 5 v0_85()
                return false
            end
        else
            v0_51.statusText = "[2/7] Aligning with Lake Egg..." v966_4.CFrame =v975_3 v966_4.AssemblyLinearVelocity =Vector3.zero task.wait ( 0.04 )
        end
        v966_4.Anchored = true task.wait ( 0.06 )v966_4.Anchored = false v0_51.holdingEggForGuard = true
        local v975_4=os.clock ()+ 3
        while not v0_62()and(os.clock ()<v975_4 and(v0_51.alive and v0_51.teleporting ))do
            if v966_2 and v0_104~=v966_2 then
                v0_17( "[Snipe] Cancelled by session switch during Lake egg pickup" )v0_85()
                return false
            end
            if not v0_51.autoFarmLoop and not v0_51.teleporting then
                v0_85()
                return false
            end
            v0_99(v975_1.Model ,v975_1.Position )
            if v975_1.Uid and v0_25 then
                task.spawn (function(...) pcall(function(...)
                        if v0_25:IsA( "RemoteFunction" )then
                            v0_25:InvokeServer({[ "Uid" ]=v975_1.Uid })
                        else
                            v0_25:FireServer({[ "Uid" ]=v975_1.Uid })
                        end
                    end
                    )
                end
                )
            end
            v0_3.Heartbeat :Wait()
        end
        v966_9=select( 2 ,v0_58())
        if not v0_62()then
            v0_17( "[-] Lake egg pickup failed" )v0_51.statusText = "[-] Lake pickup failed" v0_85()
            return false
        end
    end
    v0_51.statusText = "[3/7] Pre-streaming Target..." pcall(function(...) v0_10:RequestStreamAroundAsync(v966_8)
    end
    )v0_67(v966_8, 12 )v0_51.statusText = "[4/7] Waiting for physical bounce..." v966_4.Anchored = false v966_5:ChangeState(Enum.HumanoidStateType.Running )
    local v966_10=(v966_5.WalkSpeed > 0 )and v966_5.WalkSpeed or 16 v966_5.WalkSpeed = 0 v966_5:Move(Vector3.zero , false )v966_4.AssemblyLinearVelocity =Vector3.zero v966_4.AssemblyAngularVelocity =Vector3.zero task.wait ( 0.04 )
    local v966_11=v966_4.Position
    local v966_12=v966_11.Y
    local v966_13=select( 2 ,v0_58())or v966_9
    local v966_14= false
    local v966_15=nil
    if v0_30 and v0_30:IsA( "RemoteEvent" )then
        v966_15=v0_30.OnClientEvent :Connect(function(...) v966_14= true
            if v966_15 then
                v966_15:Disconnect()
            end
        end
        )
    end
    v0_51.holdingEggForGuard = true v0_68(v966_13)
    local v966_16=os.clock ()
    local v966_17= false
    local v966_18=os.clock ()+ 2.5
    local v966_19= false
    while os.clock ()<v966_18 and(v0_51.alive and v0_51.teleporting )do
        if v966_2 and v0_104~=v966_2 then
            v0_17( "[Snipe] Cancelled by session switch during strike bounce" )
            if v966_15 then
                v966_15:Disconnect()
            end
            v966_5.WalkSpeed =v966_10 v0_85()
            return false
        end
        local v994_1=os.clock ()-v966_16
        local v994_2=v966_4.AssemblyLinearVelocity
        local v994_3=v966_4.Position
        local v994_4=v994_3.Y -v966_12
        local v994_5=((v994_3-v966_11)).Magnitude
        if v994_1>= 0.08 then
            local v997_1=v966_14 or(v994_2.Y >= 10 )or(v994_4>= 1.5 and v994_2.Magnitude >= 16 )or(v994_5>= 2 )or(v994_2.Magnitude >= 20 )
            if v997_1 then
                v966_17= true
                break
            end
        end
        if v994_1>= 0.5 and not v966_19 then
            v966_19= true v0_68(v966_13)
        end
        v0_3.Heartbeat :Wait()
    end
    if v966_15 then
        v966_15:Disconnect()
    end
    v966_5.WalkSpeed =v966_10 v0_51.holdingEggForGuard = false
    if not v966_17 then
        v0_17( "[-] No bounce detected, aborting" )v0_51.statusText = "[-] Aborted (No bounce detected)" v0_85()pcall(v0_61)
        return false
    end
    task.wait ( 0.05 )
    if v966_7 then
        local v1002_1,v1002_2=v0_64(v966_7)
        if not v1002_1 and v1002_2== "CarriedByOther" then
            v0_17(string.format ( "[Snipe] Target egg %s was snatched while bouncing (%s)! Aborting warp..." ,tostring(v966_7),tostring(v1002_2)))v0_51.statusText = "Target taken! Aborting warp..." v0_100[v966_7]=os.clock ()+ 5 v0_85()
            return false
        end
    end
    v0_51.currentTargetModel =v966_1 and v966_1.Model v0_51.targetPosition =v966_8 v0_51.statusText = "[5/7] Warping to Target Egg..." v0_67(v966_8, 8 )v966_3:PivotTo(v966_6*CFrame.new ( 0 , 0.4 , 0 ))v966_4.Anchored = true
    for v1004_1,v1004_2 in ipairs(v966_3:GetDescendants())do
        if v1004_2:IsA( "BasePart" )then
            v1004_2.AssemblyLinearVelocity =Vector3.zero v1004_2.AssemblyAngularVelocity =Vector3.zero
        end
    end
    v0_51.statusText = "[6/7] Picking up Target Egg..."
    local v966_20=v0_10:FindFirstChild( "Backpack" )
    for v1006_1,v1006_2 in ipairs(v966_3:GetChildren())do
        if v1006_2:IsA( "Tool" )then
            pcall(function(...)
                if v966_20 then
                    v1006_2.Parent =v966_20
                else
                    v1006_2.Parent =v0_2
                end
            end
            )
        end
    end
    task.wait ( 0.06 )v966_4.Anchored = false v966_5:ChangeState(Enum.HumanoidStateType.Running )
    local v966_21=v0_83(v966_7,v966_6,v966_1 and v966_1.Model ,v966_2)v966_4.Anchored = false v966_5:ChangeState(Enum.HumanoidStateType.Running )
    for v1011_1,v1011_2 in ipairs(v966_3:GetDescendants())do
        if v1011_2:IsA( "BasePart" )then
            v1011_2.AssemblyLinearVelocity =Vector3.zero v1011_2.AssemblyAngularVelocity =Vector3.zero
        end
    end
    if not v966_21 then
        v0_17( "[-] Guard Strike criteria not met" )v0_51.statusText = "[-] Guard Strike criteria failed" v0_85()
        return false
    else
        v0_51.statusText = "[7/7] Target Secured! Stashing into Backpack..." v0_51.teleporting = false pcall(v0_61)
        return true
    end
end
v0_106=function(v1015_1,...)
    if v0_105==v1015_1 then
        return
    end
    v0_104=v0_104+ 1
    local v1015_2=v0_104 v0_105= "SWITCHING" v0_51.pureTweenFarm = false v0_51.autoFarmLoop = false pcall(v0_85)pcall(v0_61)
    if v1015_1== "TWEEN" then
        if v0_108 then
            v0_108( false , true )
        end
        if v0_107 then
            v0_107( true , true )
        end
    elseif v1015_1== "WARP" then
        if v0_107 then
            v0_107( false , true )
        end
        if v0_108 then
            v0_108( true , true )
        end
    else
        if v0_107 then
            v0_107( false , true )
        end
        if v0_108 then
            v0_108( false , true )
        end
    end
    task.delay ( 0.06 ,function(...)
        if v0_104==v1015_2 then
            v0_105=v1015_1
            if v1015_1== "TWEEN" then
                v0_51.pureTweenFarm = true v0_51.autoFarmLoop = false pcall(v0_61)v0_16( "[FarmController] Pure Auto Steal (Tween) ACTIVATED exclusively." )
            elseif v1015_1== "WARP" then
                v0_51.autoFarmLoop = true v0_51.pureTweenFarm = false pcall(v0_61)v0_16( "[FarmController] Snipe Auto Loop (Warp) ACTIVATED exclusively." )
            else
                v0_51.pureTweenFarm = false v0_51.autoFarmLoop = false
                if not v0_51.isBatchPlacing then
                    v0_51.batchStealCount = 0
                end
                v0_16( "[FarmController] All farms DEACTIVATED. Bot idle." )
            end
        end
    end
    )
end
local v0_140=os.clock ()task.spawn (function(...)
    while v0_51.alive do
        local v1033_1,v1033_2=pcall(function(...)
            if v0_51.pureTweenFarm and(not v0_51.autoFarmLoop and(v0_105== "TWEEN" and(not v0_51.isBatchPlacing and(not v0_51.teleporting and(not v0_51.glidingToTarget and(not v0_51.securingEgg and(not v0_51.delivering and not v0_51.isReturning )))))))then
                local v1035_1=v0_10.Character
                local v1035_2=v1035_1 and v1035_1:FindFirstChild( "HumanoidRootPart" )
                local v1035_3=v1035_1 and v1035_1:FindFirstChildOfClass( "Humanoid" )
                if v1035_2 and v1035_3 then
                    pcall(v0_61)
                    local v1036_1=v0_62()
                    if not v1036_1 then
                        local v1037_1=v0_104
                        local v1037_2=v0_82()
                        if v1037_2 and(v0_51.pureTweenFarm and(v0_105== "TWEEN" and v0_104==v1037_1))then
                            if v0_51.onTreadmill or v0_92()then
                                v0_51.statusText = "[AutoSteal] Target found! Getting off treadmill..." v0_90()task.wait ( 0.08 )
                            end
                            local v1038_1,v1038_2=v0_64(v1037_2.Uid )
                            if not v1038_1 and v1038_2~= "CarriedBySelf" then
                                v0_16(string.format ( "[AutoSteal] Egg %s already taken (%s). Switching to next target..." ,tostring(v1037_2.Uid ),tostring(v1038_2)))v0_100[v1037_2.Uid ]=os.clock ()+ 5 task.wait ( 0.12 )
                                return
                            end
                            v0_51.currentTargetModel =v1037_2.Model v0_51.targetPosition =v1037_2.Position v0_51.glidingToTarget = true v0_51.stateTime =os.clock ()
                            local v1038_3=((v1037_2.Scale and v1037_2.Scale > 1.05 ))and string.format ( " | %.1fx" ,v1037_2.Scale )or "" v0_51.statusText =string.format ( "[AutoSteal] Flying to %s (%s%s)..." ,tostring(v1037_2.Category or "Egg" ),tostring(v1037_2.Area or "Field" ),v1038_3)v0_16(string.format ( "[AutoSteal] Flying to %s | Zone: %s%s | Rank: %d (Corridor Z=-360)" ,tostring(v1037_2.Category or "Egg" ),tostring(v1037_2.Area or "Field" ),v1038_3,tonumber(v1037_2.Rank )or 1 ))
                            if not v0_51.swapped then
                                v0_95()
                            end
                            if not v0_51.godmode then
                                v0_94( true )
                            end
                            v0_97(v1035_1)pcall(function(...) v0_10:RequestStreamAroundAsync(v1037_2.Position )
                            end
                            )
                            local v1038_4=v1037_2.CFrame *CFrame.new ( 0 , 0.4 , 0 )
                            local v1038_5=v0_78(v1038_4,v0_51.glideSpeed ,v1037_2.Uid ,v1037_1)v0_51.glidingToTarget = false
                            if v0_104~=v1037_1 or not v0_51.pureTweenFarm or v0_105~= "TWEEN" then
                                return
                            end
                            if not v1038_5 then
                                v0_17( "[AutoSteal] Egg was taken during flight. Switching to next target..." )v0_100[v1037_2.Uid ]=os.clock ()+ 5 v0_85()
                                return
                            end
                            if v0_51.pureTweenFarm and(v0_105== "TWEEN" and((v1035_2.Position -v1037_2.Position )).Magnitude <= 22 )then
                                local v1046_1=v0_83(v1037_2.Uid ,v1038_4,v1037_2.Model ,v1037_1)
                                if not v1046_1 and v0_62()then
                                    v1046_1= true
                                end
                                if v0_104~=v1037_1 or not v0_51.pureTweenFarm or v0_105~= "TWEEN" then
                                    return
                                end
                                if v1046_1 then
                                    pcall(v0_61)
                                    if v0_51.autoGlide then
                                        v0_51.statusText = "[AutoSteal] Secured! Tweening to Safe Line X=525..." v0_16( "[AutoSteal] Egg secured after Guard Strike! Returning smoothly to Safe Line X=525 along Z=-360..." )v0_80(v0_51.glideSpeed ,v1037_1)pcall(v0_61)
                                        local v1050_1=v0_60()v0_51.statusText =string.format ( "Stashed in Bag (%d Eggs). Next steal..." ,v1050_1)v0_16(string.format ( "[AutoSteal] Egg stashed in bag (%d total eggs). Hands-Free ready for next steal..." ,v1050_1))
                                    else
                                        v0_51.statusText = "[AutoSteal] Secured! (Auto Return is OFF)" v0_16( "[AutoSteal] Egg secured! Staying at target (Auto Return is OFF)." )
                                    end
                                    pcall(v0_61)v0_51.isReturning = false v0_51.delivering = false v0_51.glidingToTarget = false v0_51.securingEgg = false v0_51.currentTargetModel =nil v0_51.targetPosition =nil
                                    if v0_75( "TWEEN" )then
                                        return
                                    end
                                else
                                    if v0_104==v1037_1 and(v0_51.pureTweenFarm and v0_105== "TWEEN" )then
                                        v0_17( "[AutoSteal] Guard Strike or Re-grab failed. Retrying with next egg..." )v0_100[v1037_2.Uid ]=os.clock ()+ 5 v0_85()
                                    end
                                end
                            else
                                v0_51.currentTargetModel =nil v0_51.targetPosition =nil v0_51.glidingToTarget = false
                            end
                        else
                            if os.clock ()-v0_140> 5 then
                                v0_100={}v0_140=os.clock ()
                            end
                            if v0_51.autoTreadmill and(not v0_51.isBatchPlacing and not v0_51.isHatching )then
                                if not v0_51.onTreadmill and not v0_92()then
                                    v0_51.statusText = "[AutoTreadmill] No targets. Mounting treadmill..." v0_89(v1037_1)
                                else
                                    v0_51.statusText = "[AutoTreadmill] Running on treadmill (Waiting for eggs...)"
                                end
                            else
                                v0_51.statusText = "[AutoSteal] Scanning for targets..."
                            end
                        end
                    end
                end
            end
        end
        )
        if not v1033_1 then
            v0_17( "[AutoSteal Loop Recovered]:" ,tostring(v1033_2))pcall(v0_85)
        end
        task.wait ( 0.08 )
    end
end
)
local v0_141=os.clock ()task.spawn (function(...)
    while v0_51.alive do
        local v1064_1,v1064_2=pcall(function(...)
            if v0_51.autoFarmLoop and(not v0_51.pureTweenFarm and(v0_105== "WARP" and(not v0_51.isBatchPlacing and(not v0_51.teleporting and(not v0_51.glidingToTarget and(not v0_51.securingEgg and(not v0_51.delivering and not v0_51.isReturning )))))))then
                local v1066_1=v0_10.Character
                local v1066_2=v1066_1 and v1066_1:FindFirstChild( "HumanoidRootPart" )
                local v1066_3=v1066_1 and v1066_1:FindFirstChildOfClass( "Humanoid" )
                if v1066_2 and v1066_3 then
                    pcall(v0_61)
                    local v1067_1=v0_62()
                    if not v1067_1 then
                        local v1068_1=v0_104
                        local v1068_2=v0_82()
                        if v1068_2 and(v0_51.autoFarmLoop and(v0_105== "WARP" and v0_104==v1068_1))then
                            if v0_51.onTreadmill or v0_92()then
                                v0_51.statusText = "[SnipeLoop] Target found! Getting off treadmill..." v0_90()task.wait ( 0.08 )
                            end
                            local v1069_1=((v1068_2.Scale and v1068_2.Scale > 1.05 ))and string.format ( " | %.1fx" ,v1068_2.Scale )or "" v0_16(string.format ( "[SnipeLoop] Starting Warp Snipe: %s | Zone: %s%s (Rank %d)" ,tostring(v1068_2.Category or "Egg" ),tostring(v1068_2.Area or "Field" ),v1069_1,tonumber(v1068_2.Rank )or 1 ))v0_51.statusText =string.format ( "[SnipeLoop] Warping for %s%s..." ,tostring(v1068_2.Category or "Egg" ),v1069_1)
                            local v1069_2=v0_84(v1068_2,v1068_1)
                            if v0_104~=v1068_1 or not v0_51.autoFarmLoop or v0_105~= "WARP" then
                                return
                            end
                            if v1069_2 then
                                pcall(v0_61)
                                if v0_51.autoGlide then
                                    v0_51.statusText = "[SnipeLoop] Target secured! Tweening to Safe Line X=525..." v0_80(v0_51.glideSpeed ,v1068_1)pcall(v0_61)
                                    local v1073_1=v0_60()v0_51.statusText =string.format ( "Stashed in Bag (%d Eggs). Next snipe..." ,v1073_1)v0_16(string.format ( "[SnipeLoop] Egg stashed in bag (%d total eggs). Hands-Free ready for next snipe..." ,v1073_1))
                                else
                                    v0_51.statusText = "[SnipeLoop] Target secured! (Auto Return is OFF)" v0_16( "[SnipeLoop] Snipe successful! Staying at target (Auto Return is OFF)." )
                                end
                                pcall(v0_61)v0_51.isReturning = false v0_51.delivering = false
                                if v0_75( "WARP" )then
                                    return
                                end
                            else
                                if v0_104==v1068_1 and(v0_51.autoFarmLoop and v0_105== "WARP" )then
                                    v0_17( "[SnipeLoop] Snipe cycle failed. Resetting for next target..." )
                                    if v1068_2 and v1068_2.Uid then
                                        v0_100[v1068_2.Uid ]=os.clock ()+ 5
                                    end
                                    pcall(v0_85)
                                end
                            end
                        else
                            if os.clock ()-v0_141> 5 then
                                v0_100={}v0_141=os.clock ()
                            end
                            if v0_51.autoTreadmill and(not v0_51.isBatchPlacing and not v0_51.isHatching )then
                                if not v0_51.onTreadmill and not v0_92()then
                                    v0_51.statusText = "[AutoTreadmill] No targets. Mounting treadmill..." v0_89(v1068_1)
                                else
                                    v0_51.statusText = "[AutoTreadmill] Running on treadmill (Waiting for eggs...)"
                                end
                            else
                                v0_51.statusText = "[SnipeLoop] Searching for targets..."
                            end
                        end
                    end
                end
            end
        end
        )
        if not v1064_1 then
            v0_17( "[SnipeLoop Loop Recovered]:" ,tostring(v1064_2))pcall(v0_85)
        end
        task.wait ( 0.08 )
    end
end
)task.spawn (function(...)
    while v0_51.alive do
        local v1087_1,v1087_2=pcall(function(...)
            if v0_51.autoTreadmill and(not v0_51.pureTweenFarm and(not v0_51.autoFarmLoop and(not v0_51.isBatchPlacing and(not v0_51.isHatching and(not v0_51.teleporting and(not v0_51.glidingToTarget and(not v0_51.securingEgg and(not v0_51.delivering and not v0_51.isReturning ))))))))then
                local v1089_1=v0_10.Character
                local v1089_2=v1089_1 and v1089_1:FindFirstChild( "HumanoidRootPart" )
                if v1089_2 and not v0_62()then
                    if not v0_51.onTreadmill and not v0_92()then
                        v0_51.statusText = "[AutoTreadmill] Idle without farm. Mounting treadmill..." v0_89()
                    end
                end
            end
        end
        )task.wait ( 0.5 )
    end
end
)task.spawn (function(...)
    while v0_51.alive do
        pcall(function(...)
            if v0_51.autoUpgradeTreadmill then
                v0_125()
            end
        end
        )task.wait ( 5 )pcall(function(...)
            if v0_51.autoBuyTrails then
                v0_133()
            end
        end
        )task.wait ( 5 )
    end
end
)task.spawn (function(...)
    while v0_51.alive do
        if v0_51.autoHatch and(not v0_51.securingEgg and(not v0_51.teleporting and not v0_51.isHatching ))then
            pcall(function(...) v0_73( false )
            end
            )
        end
        task.wait ( 4 )
    end
end
)
local v0_142=nil
local function v0_143(v1102_1,...) pcall(function(...)
        if v1102_1:IsA( "BasePart" )then
            v1102_1.Material =Enum.Material.SmoothPlastic v1102_1.Reflectance = 0 v1102_1.CastShadow = false
            if v1102_1:IsA( "MeshPart" )then
                v1102_1.TextureID = "" pcall(function(...) v1102_1.RenderFidelity =Enum.RenderFidelity.Performance
                end
                )pcall(function(...) v1102_1.CollisionFidelity =Enum.CollisionFidelity.Box
                end
                )
            end
        elseif v1102_1:IsA( "SpecialMesh" )then
            v1102_1.TextureId = ""
        elseif v1102_1:IsA( "Decal" )or v1102_1:IsA( "Texture" )or v1102_1:IsA( "SurfaceAppearance" )then
            v1102_1.Transparency = 1
        elseif v1102_1:IsA( "ParticleEmitter" )or v1102_1:IsA( "Trail" )or v1102_1:IsA( "Smoke" )or v1102_1:IsA( "Fire" )or v1102_1:IsA( "Sparkles" )then
            v1102_1.Enabled = false
        elseif v1102_1:IsA( "Beam" )then
            v1102_1.Enabled = false
        elseif v1102_1:IsA( "Explosion" )then
            v1102_1.Visible = false
        elseif v1102_1:IsA( "Light" )or v1102_1:IsA( "PointLight" )or v1102_1:IsA( "SpotLight" )or v1102_1:IsA( "SurfaceLight" )then
            v1102_1.Enabled = false
        elseif v1102_1:IsA( "Highlight" )and v1102_1.Name ~= "EggESP_Highlight" then
            v1102_1.Enabled = false
        end
    end
    )
end
local function v0_144(...) v0_51.performanceMode = true pcall(function(...)
        local v1116_1=v0_2:FindFirstChild( "DiceHub_EggESP" )
        if v1116_1 then
            v1116_1:Destroy()
        end
        local v1116_2=game:GetService( "Lighting" )v1116_2.GlobalShadows = false v1116_2.FogEnd = 9000000000 v1116_2.Brightness = 1 v1116_2.ClockTime = 14 v1116_2.OutdoorAmbient =Color3.fromRGB ( 128 , 128 , 128 )
        for v1118_1,v1118_2 in ipairs(v1116_2:GetChildren())do
            if v1118_2:IsA( "PostEffect" )or v1118_2:IsA( "BloomEffect" )or v1118_2:IsA( "BlurEffect" )or v1118_2:IsA( "ColorCorrectionEffect" )or v1118_2:IsA( "SunRaysEffect" )or v1118_2:IsA( "DepthOfFieldEffect" )or v1118_2:IsA( "Atmosphere" )then
                pcall(function(...) v1118_2.Enabled = false
                end
                )
            elseif v1118_2:IsA( "Sky" )then
                pcall(function(...) v1118_2.Parent =nil
                end
                )
            end
        end
        local v1116_3=workspace:FindFirstChildOfClass( "Terrain" )
        if v1116_3 then
            pcall(function(...) v1116_3.Decoration = false v1116_3.WaterWaveSize = 0 v1116_3.WaterWaveSpeed = 0 v1116_3.WaterReflectance = 0 v1116_3.WaterTransparency = 0
            end
            )
        end
        for v1125_1,v1125_2 in ipairs(workspace:GetDescendants())do
            v0_143(v1125_2)
        end
        if not v0_142 then
            v0_142=workspace.DescendantAdded :Connect(function(v1127_1,...)
                if v0_51.performanceMode then
                    v0_143(v1127_1)
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
local function v0_145(...) v0_51.performanceMode = false
    if v0_142 then
        pcall(function(...) v0_142:Disconnect()
        end
        )v0_142=nil
    end
    pcall(function(...)
        local v1134_1=game:GetService( "Lighting" )v1134_1.GlobalShadows = true
        for v1135_1,v1135_2 in ipairs(v1134_1:GetChildren())do
            if v1135_2:IsA( "PostEffect" )or v1135_2:IsA( "BloomEffect" )or v1135_2:IsA( "BlurEffect" )or v1135_2:IsA( "ColorCorrectionEffect" )or v1135_2:IsA( "SunRaysEffect" )or v1135_2:IsA( "DepthOfFieldEffect" )or v1135_2:IsA( "Atmosphere" )then
                pcall(function(...) v1135_2.Enabled = true
                end
                )
            end
        end
        local v1134_2=workspace:FindFirstChildOfClass( "Terrain" )
        if v1134_2 then
            pcall(function(...) v1134_2.Decoration = true
            end
            )
        end
    end
    )
end
local v0_146= false
local function v0_147(...) pcall(function(...)
        local v1141_1=game:GetService( "VirtualInputManager" )
        if v1141_1 then
            v1141_1:SendKeyEvent( true ,Enum.KeyCode.Escape , false ,game)task.wait ( 0.12 )v1141_1:SendKeyEvent( false ,Enum.KeyCode.Escape , false ,game)task.wait ( 0.35 )v1141_1:SendKeyEvent( true ,Enum.KeyCode.Escape , false ,game)task.wait ( 0.12 )v1141_1:SendKeyEvent( false ,Enum.KeyCode.Escape , false ,game)pcall(function(...)
                if typeof(v1141_1.SendTouchEvent )== "function" then
                    v1141_1:SendTouchEvent( 99999 , 0 , 15 , 15 )task.wait ( 0.04 )v1141_1:SendTouchEvent( 99999 , 2 , 15 , 15 )
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
local function v0_148(...)
    if v0_146 then
        return
    end
    v0_146= true task.spawn (function(...)
        while v0_51 and(v0_51.alive and v0_51.antiAFK )do
            local v1150_1= 0
            while v1150_1< 600 and(v0_51 and(v0_51.alive and(v0_51.antiAFK and v0_146)))do
                task.wait ( 5 )v1150_1=v1150_1+ 5
            end
            if not v0_51.antiAFK or not v0_146 then
                break
            end
            v0_147()
        end
        v0_146= false
    end
    )
end
local function v0_149(...) v0_146= false
end
v0_3.Heartbeat :Connect(function(...)
    local v1154_1=v0_10.Character
    local v1154_2=v1154_1 and v1154_1:FindFirstChild( "HumanoidRootPart" )
    local v1154_3=v1154_1 and v1154_1:FindFirstChildOfClass( "Humanoid" )
    if not v1154_2 then
        return
    end
    if v1154_3 and not((v0_51 and v0_51.onTreadmill ))then
        if v1154_3.PlatformStand then
            v1154_3.PlatformStand = false v1154_3:ChangeState(Enum.HumanoidStateType.Running )
        end
        if v1154_3.Sit and((v0_51.pureTweenFarm or v0_51.autoFarmLoop or v0_51.isReturning or v0_51.glidingToTarget ))then
            v1154_3.Sit = false v1154_3:ChangeState(Enum.HumanoidStateType.Running )
        end
    end
    local v1154_4=v1154_2.Position
    local v1154_5=v0_62()
    if v1154_4.Y < 45 then
        v1154_2.CFrame =CFrame.new (v1154_4.X , 72 ,v1154_4.Z )v1154_2.AssemblyLinearVelocity =Vector3.zero
        return
    end
    if((v0_51.pureTweenFarm or v0_51.autoFarmLoop ))and not v0_51.holdingEggForGuard then
        local v1160_1= false
        for v1161_1,v1161_2 in ipairs(v1154_1:GetChildren())do
            if v1161_2:IsA( "Tool" )then
                v1160_1= true
                break
            end
        end
        if v1160_1 then
            v0_61()
        end
    end
    if v0_51.pureTweenFarm or v0_51.autoFarmLoop or v0_51.teleporting or v0_51.glidingToTarget or v0_51.delivering or v0_51.securingEgg or v0_51.isReturning then
        return
    end
    if v0_51.alive and(v0_51.autoGlide and(v1154_5 and(not v0_65()and v1154_4.X >v0_41)))then
        task.spawn (function(...) v0_80(v0_51.glideSpeed )v0_61()v0_51.isReturning = false v0_51.delivering = false
        end
        )
    end
end
)
local v0_150= "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAedEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjEw/7R3GwAAA6BJREFUeN7tW01oE1EQnk0qih4sevCiF/Wg4kEPgqeCHsSDhyIeVIoHDx48KIKHIh48ePAgePBiPRQ8eBA8COJBD4L4B8WD4kHxov7cm2yT3WzeZjdps7t58CG72bebzPfevPlmdg3DMFwul8vlcv13qampWSKi82S2kxgiVpLZZ2T2G5lDZHaRmU9mDxEViOgqEZ1Np9N3V1ZWLlutFh1vNJvN5+12+4bf77+s/p5zIuKCiAgiGhcRLkRkCRkH+rYikYjlOE7G87w/wWBwLxKJbIeDk8mky3q31xG/37/FwR1Fq9V6Q0SX1N9tIuKNiKgiIo/bbrfb+zwez44qchRzHMcioh2Xy6Xb7fYDIsrqu5WIeBDRoohwJ2VlZaWRSCS2VNEdzZTL5ctEdF1V5Yj4QUQ8EXG73e51j8ejiojOa/V6/ZaI7tDfvUS0SUQJEXFeRNRUVVW5mZmZe/R7kZ2cTCZ1vV4/yXfO/4eQeC4iWqpQKJRkZWWl9XrdISJDRMKIyKqqqjIjI2Pj4uLiGef8lMvlYg4eE9E1VVVP9ff/c5z4n04Gg0F3PB7/TkR5dF6k4/F4v9frdc3NzbV1XW/R/2lEVBER91RVVV1TU8OHr1gsVpP198lkct5xnM/q73kiOq+O37G6uvrVdV2u1+vv6XkRkS8UCr3xeDybyuVydWVlZZlOp9v0/y/O+X41538j1b+/qKurW1bVjYg4b0xMTKyqPZ8gIs7pYx7e1/V6/bKa1xEi6k9OTnZVVVW/IqI7RLRJRHkikVhyHGdBVff9+/cf6LpOU1NTD/T3NBFxRkR00Xm1Xq/fV0U+JqK/RETJ7OzsM7vdzhw81nW9RURDRHSpWCze13Wd6/X6bVV0u6qq6mUkEtnSdV3S10z9vUtE3InpdPrB8vLybSLiTk5OTg1tQ7eP8+jo6Jqqwscikcj2wsLCGuf8FBFxJycnJ7sNDQ1rV1dXWzQ4JCKHqnK6XC5bVfS06rp+k6ry8ZWVFR4eHl4jIs4jIyN9hmF81HX9B1Xl9MTERD8RcfN4PDupVOq+67pP1H1bJpPpvb6+7hPRfVVVV0ZGRtiVlRWWSCReZ7PZX36//6Cvr48PDQ09y2azVzwez7Kqqk8556fdbvdnItpVVdUaGRmZoKqaoP6sUjKZ3B8YGGBd122qyu3j/Ojo6F1N034MDAyw6elpW1VVLhQKzH1HRkZ6m4qKiicikajlOI7ler3e9y6X643L5dqi/+NyuZ6rqvpOVdV/Kysr51wu17fW3w8AAAD//wMAe7/lQy8mR0AAAAAElFTkSuQmCC"
local function v0_151(v1167_1,...)
    if crypt and crypt.base64decode then
        return crypt.base64decode (v1167_1)
    end
    if base64_decode then
        return base64_decode(v1167_1)
    end
    if syn and(syn.crypt and(syn.crypt.base64 and syn.crypt.base64 .decode ))then
        return syn.crypt.base64 .decode (v1167_1)
    end
    local v1167_2= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local v1167_3={}
    for v1171_1= 1 ,#v1167_2, 1 do
        v1167_3[v1167_2:sub(v1171_1,v1171_1)]=v1171_1- 1
    end
    v1167_1=(v1167_1:gsub( "[^" ..(v1167_2.. "=]" ), "" )):gsub( "=" , "" )
    local v1167_4={}
    for v1172_1= 1 ,#v1167_1, 4 do
        local v1172_2=v1167_3[v1167_1:sub(v1172_1,v1172_1)]or 0
        local v1172_3=v1167_3[v1167_1:sub(v1172_1+ 1 ,v1172_1+ 1 )]or 0
        local v1172_4=v1167_3[v1167_1:sub(v1172_1+ 2 ,v1172_1+ 2 )]
        local v1172_5=v1167_3[v1167_1:sub(v1172_1+ 3 ,v1172_1+ 3 )]table.insert (v1167_4,string.char (bit32.bor (bit32.lshift (v1172_2, 2 ),bit32.rshift (v1172_3, 4 ))))
        if v1172_4 then
            table.insert (v1167_4,string.char (bit32.bor (bit32.lshift (bit32.band (v1172_3, 15 ), 4 ),bit32.rshift (v1172_4, 2 ))))
            if v1172_5 then
                table.insert (v1167_4,string.char (bit32.bor (bit32.lshift (bit32.band (v1172_4, 3 ), 6 ),v1172_5)))
            end
        end
    end
    return table.concat (v1167_4)
end
local v0_152= "Dice_Hub_Icon.png"
local v0_153= "rbxassetid://10734950309" pcall(function(...)
    if writefile and((getcustomasset or getsynasset))then
        local v1176_1=getcustomasset or getsynasset
        if not((isfile and isfile(v0_152)))then
            writefile(v0_152,v0_151(v0_150))
        end
        v0_153=v1176_1(v0_152)
    end
end
)
local v0_154=v0_12 or "EN"
local v0_155={[ "EN" ]={[ "StatusTagReady" ]= "Status: Ready" ,[ "Tabs" ]={[ "Farm" ]= "Auto Farm" ;
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
local v0_156={}
local v0_157,v0_158,v0_159,v0_160
local v0_161={ "Farm" ;
"EggSelect" ;
"Character" , "Settings" }
local function v0_162(v1178_1,...)
    local v1178_2=(v1178_1== "TH" )
    if v0_51.delivering then
        return v1178_2 and "กำลังวางไข่" or "Placing Egg"
    elseif v0_51.securingEgg or v0_51.holdingEggForGuard then
        return v1178_2 and "กำลังหยิบไข่" or "Securing Egg"
    elseif v0_51.teleporting then
        return v1178_2 and "กำลังวาร์ป" or "Teleporting"
    elseif v0_51.isReturning then
        return v1178_2 and "กำลังบินกลับ" or "Returning"
    elseif v0_51.glidingToTarget then
        return v1178_2 and "กำลังบินไปขโมย" or "Stealing"
    elseif v0_51.onTreadmill or(v0_92 and v0_92())then
        return v1178_2 and "อยู่บนลู่วิ่ง" or "On Treadmill"
    elseif v0_105== "TWEEN" and not v0_51.isReturning then
        return v1178_2 and "กำลังหาไข่" or "Searching"
    elseif v0_105== "WARP" and not v0_51.isReturning then
        return v1178_2 and "กำลังหาไข่" or "Searching"
    else
        return v1178_2 and "พร้อมทำงาน" or "Ready"
    end
end
local function v0_163(v1188_1,...) pcall(function(...)
        if v1188_1:IsA( "TextLabel" )or v1188_1:IsA( "TextButton" )or v1188_1:IsA( "TextBox" )then
            v1188_1.AutoLocalize = false
        end
        for v1191_1,v1191_2 in ipairs(v1188_1:GetDescendants())do
            if v1191_2:IsA( "TextLabel" )or v1191_2:IsA( "TextButton" )or v1191_2:IsA( "TextBox" )then
                v1191_2.AutoLocalize = false
            end
        end
    end
    )
end
local function v0_164(v1193_1,v1193_2,v1193_3,...)
    if not v1193_1 then
        return
    end
    pcall(function(...)
        if v1193_2 and v1193_1.SetTitle then
            v1193_1:SetTitle(v1193_2)
        end
        if v1193_3 and v1193_1.SetDesc then
            v1193_1:SetDesc(v1193_3)
        end
    end
    )pcall(function(...)
        if v1193_1.UIElements then
            if v1193_2 and(v1193_1.UIElements.Title and v1193_1.UIElements.Title :IsA( "TextLabel" ))then
                v1193_1.UIElements.Title .AutoLocalize = false v1193_1.UIElements.Title .Text =v1193_2
            end
            if v1193_3 and(v1193_1.UIElements.Desc and v1193_1.UIElements.Desc :IsA( "TextLabel" ))then
                v1193_1.UIElements.Desc .AutoLocalize = false v1193_1.UIElements.Desc .Text =v1193_3
            end
        end
    end
    )
end
local function v0_165(v1202_1,v1202_2,v1202_3,...) pcall(function(...)
        if not v1202_1 then
            return
        end
        if v1202_1.UIElements and(v1202_1.UIElements.Title and v1202_1.UIElements.Title :IsA( "TextLabel" ))then
            v1202_1.UIElements.Title .TextColor3 =v1202_2
        end
        if v1202_1.UIElements and v1202_1.UIElements.ButtonIcon then
            local v1206_1=v1202_1.UIElements.ButtonIcon :FindFirstChildOfClass( "ImageLabel" )or v1202_1.UIElements.ButtonIcon
            if v1206_1 and v1206_1:IsA( "ImageLabel" )then
                v1206_1.ImageColor3 =v1202_2
            end
        end
        local v1203_1=nil
        if v1202_1.ButtonFrame and(v1202_1.ButtonFrame.UIElements and v1202_1.ButtonFrame.UIElements .Main )then
            v1203_1=v1202_1.ButtonFrame.UIElements .Main
        elseif v1202_1.ToggleFrame and(v1202_1.ToggleFrame.UIElements and v1202_1.ToggleFrame.UIElements .Main )then
            v1203_1=v1202_1.ToggleFrame.UIElements .Main
        elseif v1202_1.ElementFrame then
            v1203_1=v1202_1.ElementFrame
        elseif v1202_1.UIElements and v1202_1.UIElements.Main then
            v1203_1=v1202_1.UIElements.Main
        end
        if v1203_1 and v1203_1:IsA( "GuiObject" )then
            local v1212_1=v1203_1:FindFirstChild( "AccentCorner" )or v1203_1:FindFirstChildOfClass( "UICorner" )
            if v1212_1 then
                v1212_1:Destroy()
            end
            local v1212_2=v1203_1:FindFirstChild( "DiceAccentStroke" )or v1203_1:FindFirstChildOfClass( "UIStroke" )
            if v1212_2 then
                v1212_2:Destroy()
            end
            local v1212_3=v1203_1:FindFirstChild( "AccentSquircleOutline" )
            if v1212_3 then
                v1212_3:Destroy()
            end
            for v1216_1,v1216_2 in ipairs(v1203_1:GetDescendants())do
                if v1216_2:IsA( "ImageLabel" )and((string.find (tostring(v1216_2.Image ), "117817408534198" )or string.find (v1216_2.Name :lower(), "outline" )))then
                    v1216_2.Visible = false v1216_2.ImageTransparency = 1
                end
            end
            local v1212_4=v1202_3
            if not v1212_4 then
                local v1218_1,v1218_2,v1218_3=v1202_2:ToHSV()v1212_4=Color3.fromHSV (v1218_1,math.clamp (v1218_2* 0.4 , 0.18 , 0.45 ), 0.18 )
            end
            v1203_1.ThemeTag =nil v1203_1.ImageColor3 =v1212_4 v1203_1.ImageTransparency = 0.08
        end
    end
    )
end
local function v0_166(...) v0_165(v0_156.togTween ,Color3.fromRGB ( 0 , 195 , 255 ),Color3.fromRGB ( 24 , 40 , 46 ))v0_165(v0_156.togTeleport ,Color3.fromRGB ( 168 , 85 , 247 ),Color3.fromRGB ( 36 , 24 , 46 ))v0_165(v0_156.btnPlaceEgg ,Color3.fromRGB ( 16 , 215 , 130 ),Color3.fromRGB ( 24 , 45 , 36 ))v0_165(v0_156.togAutoPlaceEvery5 ,Color3.fromRGB ( 14 , 165 , 233 ),Color3.fromRGB ( 24 , 38 , 46 ))v0_165(v0_156.togGodmode ,Color3.fromRGB ( 244 , 63 , 94 ),Color3.fromRGB ( 46 , 24 , 28 ))v0_165(v0_156.btnUnstick ,Color3.fromRGB ( 249 , 115 , 22 ),Color3.fromRGB ( 46 , 32 , 24 ))v0_165(v0_156.btnReset ,Color3.fromRGB ( 99 , 102 , 241 ),Color3.fromRGB ( 25 , 26 , 46 ))v0_165(v0_156.btnLangSettings ,Color3.fromRGB ( 245 , 180 , 30 ),Color3.fromRGB ( 46 , 38 , 24 ))
end
local function v0_167(v1220_1,...)
    local v1220_2=v1220_1 or v0_154 or "EN"
    local v1220_3=v0_155[v1220_2]or v0_155.EN
    local v1220_4={v0_157,v0_158;
    v0_159;
    v0_160}
    local v1220_5={ "Farm" ;
    "EggSelect" , "Character" ;
    "Settings" }
    for v1221_1,v1221_2 in ipairs(v1220_4)do
        local v1221_3=v1220_5[v1221_1]
        local v1221_4=v1220_3.Tabs [v1221_3]or v1221_3
        if v1221_2 then
            v1221_2.Title =v1221_4 pcall(function(...)
                if v1221_2.SetTitle then
                    v1221_2:SetTitle(v1221_4)
                end
            end
            )pcall(function(...)
                if v1221_2.UIElements and v1221_2.UIElements.Main then
                    for v1227_1,v1227_2 in ipairs(v1221_2.UIElements.Main :GetDescendants())do
                        if v1227_2:IsA( "TextLabel" )then
                            v1227_2.AutoLocalize = false v1227_2.Text =v1221_4
                        end
                    end
                end
                if v1221_2.UIElements and v1221_2.UIElements.TabItem then
                    for v1230_1,v1230_2 in ipairs(v1221_2.UIElements.TabItem :GetDescendants())do
                        if v1230_2:IsA( "TextLabel" )then
                            v1230_2.AutoLocalize = false v1230_2.Text =v1221_4
                        end
                    end
                end
            end
            )
        end
    end
    pcall(function(...)
        if v0_11 and(v0_11.TabModule and v0_11.TabModule.Tabs )then
            for v1234_1= 1 ,#v0_161, 1 do
                local v1234_2=v0_11.TabModule.Tabs [v1234_1]
                local v1234_3=v0_161[v1234_1]
                local v1234_4=v1220_3.Tabs [v1234_3]or v1234_3
                if v1234_2 and v1234_4 then
                    v1234_2.Title =v1234_4
                    if v1234_2.UIElements and v1234_2.UIElements.Main then
                        for v1237_1,v1237_2 in ipairs(v1234_2.UIElements.Main :GetDescendants())do
                            if v1237_2:IsA( "TextLabel" )then
                                v1237_2.AutoLocalize = false v1237_2.Text =v1234_4
                            end
                        end
                    end
                    if v1234_2.UIElements and v1234_2.UIElements.TabItem then
                        for v1240_1,v1240_2 in ipairs(v1234_2.UIElements.TabItem :GetDescendants())do
                            if v1240_2:IsA( "TextLabel" )then
                                v1240_2.AutoLocalize = false v1240_2.Text =v1234_4
                            end
                        end
                    end
                end
            end
        end
    end
    )
end
local function v0_168(v1242_1,...)
    local v1242_2=v0_155[v1242_1]or v0_155.EN v0_167(v1242_1)v0_164(v0_156.secModes ,v1242_2.Farm.SecModes )v0_164(v0_156.togTween ,v1242_2.Farm.TweenTitle ,v1242_2.Farm.TweenDesc )v0_164(v0_156.togTeleport ,v1242_2.Farm.TeleportTitle ,v1242_2.Farm.TeleportDesc )v0_164(v0_156.secPlace ,v1242_2.Farm.SecPlace )v0_164(v0_156.btnPlaceEgg ,v1242_2.Farm.PlaceTitle ,v1242_2.Farm.PlaceDesc )v0_164(v0_156.togAutoPlaceEvery5 ,v1242_2.Farm.AutoPlaceTitle ,v1242_2.Farm.AutoPlaceDesc )v0_164(v0_156.togAutoHatch ,v1242_2.Farm.HatchTitle ,v1242_2.Farm.HatchDesc )v0_164(v0_156.togAutoReturn ,v1242_2.Farm.ReturnTitle ,v1242_2.Farm.ReturnDesc )v0_164(v0_156.togAutoTreadmill ,v1242_2.Farm.AutoTreadmillTitle ,v1242_2.Farm.AutoTreadmillDesc )v0_164(v0_156.togAutoUpgradeTreadmill ,v1242_2.Farm.UpgradeTreadmillTitle ,v1242_2.Farm.UpgradeTreadmillDesc )v0_164(v0_156.togAutoBuyTrails ,v1242_2.Farm.BuyTrailsTitle ,v1242_2.Farm.BuyTrailsDesc )
    if v1242_2.EggSelect then
        v0_164(v0_156.secEggZones ,v1242_2.EggSelect.SecZones ,v1242_2.EggSelect.SecZonesDesc )v0_164(v0_156.dropTargetZones ,v1242_2.EggSelect.DropZonesTitle ,v1242_2.EggSelect.DropZonesDesc )v0_164(v0_156.secEggRarity ,v1242_2.EggSelect.SecRarities ,v1242_2.EggSelect.SecRaritiesDesc )v0_164(v0_156.secEggRarities ,v1242_2.EggSelect.SecRarities ,v1242_2.EggSelect.SecRaritiesDesc )v0_164(v0_156.dropTargetRarities ,v1242_2.EggSelect.DropRaritiesTitle ,v1242_2.EggSelect.DropRaritiesDesc )v0_164(v0_156.togAlwaysSecret ,v1242_2.EggSelect.AlwaysSecretPlus ,v1242_2.EggSelect.AlwaysSecretPlusDesc )
    end
    v0_164(v0_156.secSafety ,v1242_2.Character.SecSafety )v0_164(v0_156.togGodmode ,v1242_2.Character.GodmodeTitle ,v1242_2.Character.GodmodeDesc )v0_164(v0_156.btnUnstick ,v1242_2.Character.UnstickTitle ,v1242_2.Character.UnstickDesc )v0_164(v0_156.secFlight ,v1242_2.Character.SecFlight )v0_164(v0_156.sliderSpeed ,v1242_2.Character.SpeedTitle ,v1242_2.Character.SpeedDesc )v0_164(v0_156.secDashboard ,v1242_2.Settings.SecDashboard )v0_164(v0_156.paraLiveDash ,v1242_2.Settings.DashTitle )v0_164(v0_156.secBlacklist ,v1242_2.Settings.SecBlacklist )v0_164(v0_156.secUI ,v1242_2.Settings.SecUI )v0_164(v0_156.dropLang ,v1242_2.Settings.LangTitle )v0_164(v0_156.sliderTransp ,v1242_2.Settings.TranspTitle ,v1242_2.Settings.TranspDesc )v0_164(v0_156.dropTheme ,v1242_2.Settings.ThemeTitle )v0_164(v0_156.secPerformance ,v1242_2.Settings.SecPerformance )v0_164(v0_156.togPerformance ,v1242_2.Settings.PerformanceTitle ,v1242_2.Settings.PerformanceDesc )v0_164(v0_156.togDisable3D ,v1242_2.Settings.Disable3DTitle ,v1242_2.Settings.Disable3DDesc )v0_164(v0_156.secSystem ,v1242_2.Settings.SecSystem )v0_164(v0_156.togAntiAFK ,v1242_2.Settings.AntiAFKTitle ,v1242_2.Settings.AntiAFKDesc )v0_164(v0_156.btnReset ,v1242_2.Settings.ResetTitle ,v1242_2.Settings.ResetDesc )v0_164(v0_156.btnRejoin ,v1242_2.Settings.RejoinTitle ,v1242_2.Settings.RejoinDesc )v0_164(v0_156.btnUnload ,v1242_2.Settings.UnloadTitle ,v1242_2.Settings.UnloadDesc )v0_166()
end
local function v0_169(...)
    local v1244_1=Instance.new ( "ScreenGui" )v1244_1.Name = "Dice_LOADER_SCREEN" v1244_1.ResetOnSpawn = false v1244_1.DisplayOrder = 9999999 v1244_1.ZIndexBehavior =Enum.ZIndexBehavior.Sibling v1244_1.AutoLocalize = false pcall(function(...)
        if syn and syn.protect_gui then
            syn.protect_gui (v1244_1)v1244_1.Parent =game:GetService( "CoreGui" )
        else
            v1244_1.Parent =v0_10:FindFirstChild( "PlayerGui" )or game:GetService( "CoreGui" )
        end
    end
    )
    if not v1244_1.Parent then
        v1244_1.Parent =game:GetService( "CoreGui" )
    end
    local v1244_2=Instance.new ( "Frame" )v1244_2.Name = "Card" v1244_2.Size =UDim2.fromOffset ( 336 , 140 )v1244_2.Position =UDim2.new ( 0.5 , -168 , 0.5 , -70 )v1244_2.BackgroundColor3 =Color3.fromRGB ( 16 , 16 , 22 )v1244_2.BorderSizePixel = 0 v1244_2.Parent =v1244_1;
    (Instance.new ( "UICorner" ,v1244_2)).CornerRadius =UDim.new ( 0 , 14 )
    local v1244_3=Instance.new ( "UIStroke" ,v1244_2)v1244_3.Color =Color3.fromRGB ( 0 , 185 , 255 )v1244_3.Thickness = 1.4 v1244_3.ApplyStrokeMode =Enum.ApplyStrokeMode.Border
    local v1244_4=Instance.new ( "TextLabel" )v1244_4.Size =UDim2.new ( 1 , -28 , 0 , 24 )v1244_4.Position =UDim2.new ( 0 , 14 , 0 , 14 )v1244_4.BackgroundTransparency = 1 v1244_4.Text = "Dice Hub" v1244_4.TextColor3 =Color3.fromRGB ( 245 , 248 , 255 )v1244_4.TextSize = 18 v1244_4.Font =Enum.Font.GothamBold v1244_4.TextXAlignment =Enum.TextXAlignment.Left v1244_4.AutoLocalize = false v1244_4.Parent =v1244_2
    local v1244_5=Instance.new ( "TextLabel" )v1244_5.Size =UDim2.new ( 1 , -28 , 0 , 16 )v1244_5.Position =UDim2.new ( 0 , 14 , 0 , 38 )v1244_5.BackgroundTransparency = 1 v1244_5.Text = "Steal an Egg Suite v42.64" v1244_5.TextColor3 =Color3.fromRGB ( 140 , 150 , 175 )v1244_5.TextSize = 12 v1244_5.Font =Enum.Font.Gotham v1244_5.TextXAlignment =Enum.TextXAlignment.Left v1244_5.AutoLocalize = false v1244_5.Parent =v1244_2
    local v1244_6=Instance.new ( "TextLabel" )v1244_6.Size =UDim2.new ( 0 , 50 , 0 , 24 )v1244_6.Position =UDim2.new ( 1 , -64 , 0 , 14 )v1244_6.BackgroundTransparency = 1 v1244_6.Text = "0%" v1244_6.TextColor3 =Color3.fromRGB ( 0 , 255 , 160 )v1244_6.TextSize = 14 v1244_6.Font =Enum.Font.GothamBold v1244_6.TextXAlignment =Enum.TextXAlignment.Right v1244_6.AutoLocalize = false v1244_6.Parent =v1244_2
    local v1244_7=Instance.new ( "Frame" )v1244_7.Size =UDim2.new ( 1 , -28 , 0 , 10 )v1244_7.Position =UDim2.new ( 0 , 14 , 0 , 74 )v1244_7.BackgroundColor3 =Color3.fromRGB ( 25 , 27 , 38 )v1244_7.BorderSizePixel = 0 v1244_7.Parent =v1244_2;
    (Instance.new ( "UICorner" ,v1244_7)).CornerRadius =UDim.new ( 0 , 5 )
    local v1244_8=Instance.new ( "Frame" )v1244_8.Size =UDim2.new ( 0 , 0 , 1 , 0 )v1244_8.BackgroundColor3 =Color3.fromRGB ( 0 , 185 , 255 )v1244_8.BorderSizePixel = 0 v1244_8.Parent =v1244_7;
    (Instance.new ( "UICorner" ,v1244_8)).CornerRadius =UDim.new ( 0 , 5 )
    local v1244_9=Instance.new ( "UIGradient" ,v1244_8)v1244_9.Color =ColorSequence.new ({ColorSequenceKeypoint.new ( 0 ,Color3.fromRGB ( 0 , 185 , 255 )),ColorSequenceKeypoint.new ( 1 ,Color3.fromRGB ( 0 , 255 , 160 ))})
    local v1244_10=Instance.new ( "TextLabel" )v1244_10.Size =UDim2.new ( 1 , -28 , 0 , 16 )v1244_10.Position =UDim2.new ( 0 , 14 , 0 , 94 )v1244_10.BackgroundTransparency = 1 v1244_10.Text = "Initializing Dice Hub..." v1244_10.TextColor3 =Color3.fromRGB ( 130 , 140 , 165 )v1244_10.TextSize = 11 v1244_10.Font =Enum.Font.Gotham v1244_10.TextXAlignment =Enum.TextXAlignment.Left v1244_10.AutoLocalize = false v1244_10.Parent =v1244_2 task.spawn (function(...)
        for v1250_1= 1 , 100 , 1 do
            if not v1244_1.Parent then
                break
            end
            v1244_6.Text =tostring(v1250_1).. "%" v1244_8.Size =UDim2.new (v1250_1/ 100 , 0 , 1 , 0 )
            if v1250_1== 25 then
                v1244_10.Text = "Loading interface modules..."
            elseif v1250_1== 60 then
                v1244_10.Text = "Setting up auto-steal controllers..."
            elseif v1250_1== 85 then
                v1244_10.Text = "Syncing server telemetry..."
            elseif v1250_1== 100 then
                v1244_10.Text = "Ready!"
            end
            task.wait ( 0.008 )
        end
    end
    )
    local function v1244_11(v1256_1,...) task.spawn (function(...) task.wait ( 0.9 )
            local v1257_1=TweenInfo.new ( 0.35 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out );
            (v0_4:Create(v1244_2,v1257_1,{[ "BackgroundTransparency" ]= 1 })):Play();
            (v0_4:Create(v1244_3,v1257_1,{[ "Transparency" ]= 1 })):Play();
            (v0_4:Create(v1244_4,v1257_1,{[ "TextTransparency" ]= 1 })):Play();
            (v0_4:Create(v1244_5,v1257_1,{[ "TextTransparency" ]= 1 })):Play();
            (v0_4:Create(v1244_6,v1257_1,{[ "TextTransparency" ]= 1 })):Play();
            (v0_4:Create(v1244_7,v1257_1,{[ "BackgroundTransparency" ]= 1 })):Play();
            (v0_4:Create(v1244_8,v1257_1,{[ "BackgroundTransparency" ]= 1 })):Play();
            (v0_4:Create(v1244_10,v1257_1,{[ "TextTransparency" ]= 1 })):Play()task.wait ( 0.4 )pcall(function(...) v1244_1:Destroy()
            end
            )
            if v1256_1 then
                v1256_1()
            end
        end
        )
    end
    return v1244_11
end
local v0_170={}v0_170.Gui =Instance.new ( "ScreenGui" )v0_170.Gui.Name = "Dice_RESTORE_BAR" v0_170.Gui.ResetOnSpawn = false v0_170.Gui.DisplayOrder = 999999 v0_170.Gui.ZIndexBehavior =Enum.ZIndexBehavior.Sibling v0_170.Gui.AutoLocalize = false pcall(function(...)
    if syn and syn.protect_gui then
        syn.protect_gui (v0_170.Gui )v0_170.Gui.Parent =game:GetService( "CoreGui" )
    else
        v0_170.Gui.Parent =v0_10:FindFirstChild( "PlayerGui" )or game:GetService( "CoreGui" )
    end
end
)
if not v0_170.Gui.Parent then
    v0_170.Gui.Parent =game:GetService( "CoreGui" )
end
v0_170.Btn =Instance.new ( "ImageButton" )v0_170.Btn.Name = "Dice_SquareLogoButton" v0_170.Btn.Size =UDim2.fromOffset ( 46 , 46 )v0_170.Btn.Position =UDim2.new ( 0 , 20 , 0 , 20 )v0_170.Btn.BackgroundColor3 =Color3.fromRGB ( 18 , 18 , 24 )v0_170.Btn.Active = true v0_170.Btn.Selectable = true v0_170.Btn.Visible = false v0_170.Btn.ZIndex = 999999 v0_170.Btn.AutoLocalize = false v0_170.Btn.Parent =v0_170.Gui ;
(Instance.new ( "UICorner" ,v0_170.Btn )).CornerRadius =UDim.new ( 0 , 10 )v0_170.Stroke =Instance.new ( "UIStroke" ,v0_170.Btn )v0_170.Stroke.Color =Color3.fromRGB ( 0 , 185 , 255 )v0_170.Stroke.Thickness = 1.6 v0_170.Stroke.ApplyStrokeMode =Enum.ApplyStrokeMode.Border v0_170.Logo =Instance.new ( "ImageLabel" ,v0_170.Btn )v0_170.Logo.Name = "LogoIcon" v0_170.Logo.Size =UDim2.fromOffset ( 36 , 36 )v0_170.Logo.Position =UDim2.new ( 0.5 , 0 , 0.5 , 0 )v0_170.Logo.AnchorPoint =Vector2.new ( 0.5 , 0.5 )v0_170.Logo.BackgroundTransparency = 1 v0_170.Logo.Image =v0_153 v0_170.Logo.ImageColor3 =Color3.fromRGB ( 255 , 255 , 255 )v0_170.Logo.ZIndex = 1000000 ;
(Instance.new ( "UICorner" ,v0_170.Logo )).CornerRadius =UDim.new ( 0 , 8 )v0_170.isDragging = false v0_170.dragStart =nil v0_170.startPos =nil v0_170.Btn.InputBegan :Connect(function(v1264_1,...)
    if v1264_1.UserInputType ==Enum.UserInputType.MouseButton1 or v1264_1.UserInputType ==Enum.UserInputType.Touch then
        v0_170.isDragging = true v0_170.dragStart =v1264_1.Position v0_170.startPos =v0_170.Btn.Position
    end
end
)v0_5.InputEnded :Connect(function(v1266_1,...)
    if v1266_1.UserInputType ==Enum.UserInputType.MouseButton1 or v1266_1.UserInputType ==Enum.UserInputType.Touch then
        v0_170.isDragging = false
    end
end
)v0_5.InputChanged :Connect(function(v1268_1,...)
    if v0_170.isDragging and((v1268_1.UserInputType ==Enum.UserInputType.MouseMovement or v1268_1.UserInputType ==Enum.UserInputType.Touch ))then
        local v1269_1=v1268_1.Position -v0_170.dragStart v0_170.Btn.Position =UDim2.new (v0_170.startPos.X .Scale ,v0_170.startPos.X .Offset +v1269_1.X ,v0_170.startPos.Y .Scale ,v0_170.startPos.Y .Offset +v1269_1.Y )
    end
end
)
local function v0_171(...) v0_51.alive = false pcall(v0_145)pcall(v0_149)pcall(function(...) v0_3:Set3dRenderingEnabled( true )
    end
    )pcall(function(...)
        local v1272_1=v0_2:FindFirstChild( "DiceHub_EggESP" )
        if v1272_1 then
            v1272_1:Destroy()
        end
    end
    )pcall(v0_85)pcall(v0_61)
    if v0_170 and v0_170.Gui then
        pcall(function(...) v0_170.Gui :Destroy()
        end
        )
    end
    if v0_51.gui then
        pcall(function(...) v0_51.gui :Destroy()
        end
        )
    end
    pcall(function(...)
        for v1279_1,v1279_2 in ipairs(game.CoreGui :GetChildren())do
            if v1279_2.Name :find( "Dice_" )or v1279_2.Name :find( "DesyncSniperUI" )or v1279_2.Name :find( "WindUI" )then
                v1279_2:Destroy()
            end
        end
    end
    )
end
local function v0_172(...)
    local v1281_1=v0_169()
    local v1281_2=nil pcall(function(...) v1281_2=(loadstring(game:HttpGet( "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua" )))()
    end
    )
    local function v1281_3(v1283_1,...)
        if not v1283_1 then
            return
        end
        local v1283_2= false
        if v1281_2 and v1281_2.Notify then
            local v1285_1=pcall(function(...) v1281_2:Notify(v1283_1)v1283_2= true
            end
            )
        end
        if not v1283_2 then
            pcall(function(...)
                (game:GetService( "StarterGui" )):SetCore( "SendNotification" ,{[ "Title" ]=tostring(v1283_1.Title or "Dice Hub" ),[ "Text" ]=tostring(v1283_1.Content or "" );
                [ "Duration" ]= 3 })
            end
            )
        end
    end
    if v1281_2 then
        pcall(function(...)
            local v1290_1=v1281_2.Notify
            if v1290_1 then
                v1281_2.Notify =function(v1292_1,v1292_2,...)
                    local v1292_3=pcall(function(...) v1290_1(v1292_1,v1292_2)
                    end
                    )
                    if not v1292_3 then
                        pcall(function(...)
                            (game:GetService( "StarterGui" )):SetCore( "SendNotification" ,{[ "Title" ]=tostring(v1292_2 and v1292_2.Title or "Dice Hub" );
                            [ "Text" ]=tostring(v1292_2 and v1292_2.Content or "" ),[ "Duration" ]= 3 })
                        end
                        )
                    end
                end
            end
        end
        )
        local v1289_1=workspace.CurrentCamera
        local v1289_2=v1289_1 and v1289_1.ViewportSize or Vector2.new ( 1280 , 720 )
        local v1289_3=v0_5.TouchEnabled and not v0_5.KeyboardEnabled
        local v1289_4=v1289_3 and math.clamp (v1289_2.X * 0.7 , 440 , 500 )or 500
        local v1289_5=v1289_3 and math.clamp (v1289_2.Y * 0.72 , 280 , 340 )or 340
        local v1289_6=UDim2.fromOffset (v1289_4,v1289_5)
        local v1289_7=v1281_2:CreateWindow({[ "Title" ]= "Dice Hub" ;
        [ "Author" ]= "Steal An Egg V1" ;
        [ "Folder" ]= "Dice_StealAnEgg" ;
        [ "Icon" ]=v0_153;
        [ "Theme" ]= "Dark" ,[ "IconSize" ]= 28 ,[ "Size" ]=v1289_6,[ "MinSize" ]=Vector2.new ( 400 , 240 );
        [ "MaxSize" ]=Vector2.new ( 900 , 600 ),[ "Resizable" ]= true ,[ "SideBarWidth" ]=v1289_3 and 140 or 160 ,[ "ToggleKey" ]=Enum.KeyCode.RightShift ;
        [ "IgnoreAlerts" ]= true ,[ "Topbar" ]={[ "Height" ]= 44 ,[ "ButtonsType" ]= "Default" }})
        v0_11=v1289_7
        v1289_7.IgnoreAlerts = true pcall(function(...)
            if v1289_7.UIElements and v1289_7.UIElements.Main then
                v1289_7.UIElements.Main .Visible = false
            end
        end
        )
        local v1289_8=v1289_7:Tag({[ "Title" ]= "Status: Ready" ;
        [ "Color" ]=Color3.fromRGB ( 0 , 255 , 160 ),[ "Border" ]= true })
        local v1289_9= 44
        local v1289_10= false
        local v1289_11= false
        local v1289_12=v1289_5 task.spawn (function(...) task.wait ( 0.1 )
            local v1298_1=v1289_7.UIElements and v1289_7.UIElements.Main
            if v1298_1 then
                if v1298_1.AnchorPoint.Y ~= 0 then
                    local v1300_1=v1298_1.Size.Y .Offset > 0 and v1298_1.Size.Y .Offset or v1289_5 v1298_1.Position =UDim2.new (v1298_1.Position.X .Scale ,v1298_1.Position.X .Offset ,v1298_1.Position.Y .Scale ,v1298_1.Position.Y .Offset -(v1300_1*v1298_1.AnchorPoint.Y ))v1298_1.AnchorPoint =Vector2.new ( 0.5 , 0 )
                end
                v1298_1.ClipsDescendants = false v0_163(v1298_1)
            end
        end
        )
        local function v1289_13(...)
            local v1301_1=v1289_7.UIElements and v1289_7.UIElements.Main
            if not v1301_1 or v1289_11 then
                return
            end
            v1289_11= true v1289_10=not v1289_10
            local v1301_2=v1289_7.UIElements.SideBarContainer
            local v1301_3=v1289_7.UIElements.MainBar
            local v1301_4=v1301_1:FindFirstChild( "Background" )
            local v1301_5=v1301_1:FindFirstChild( "Main" )
            if v1301_1.AnchorPoint.Y ~= 0 then
                local v1303_1=v1301_1.Size.Y .Offset > 0 and v1301_1.Size.Y .Offset or v1289_12 v1301_1.Position =UDim2.new (v1301_1.Position.X .Scale ,v1301_1.Position.X .Offset ,v1301_1.Position.Y .Scale ,v1301_1.Position.Y .Offset -(v1303_1*v1301_1.AnchorPoint.Y ))v1301_1.AnchorPoint =Vector2.new ( 0.5 , 0 )
            end
            local v1301_6=v1301_1.Size.X .Scale
            local v1301_7=v1301_1.Size.X .Offset
            if v1289_10 then
                if v1301_1.Size.Y .Offset >v1289_9 then
                    v1289_12=v1301_1.Size.Y .Offset
                end
                v1301_1.ClipsDescendants = true
                if v1301_4 then
                    v1301_4.ClipsDescendants = true
                end
                if v1301_5 then
                    v1301_5.ClipsDescendants = true
                end
                if v1301_2 then
                    v1301_2.Visible = false
                end
                if v1301_3 then
                    v1301_3.Visible = false
                end
                v1301_1.Visible = true
                if v1301_5 then
                    v1301_5.Visible = true
                end
                local v1304_1=v0_4:Create(v1301_1,TweenInfo.new ( 0.24 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out ),{[ "Size" ]=UDim2.new (v1301_6,v1301_7, 0 ,v1289_9)})v1304_1:Play()task.delay ( 0.25 ,function(...) v1289_11= false
                end
                )
            else
                v1301_1.Visible = true
                if v1301_5 then
                    v1301_5.Visible = true
                end
                local v1312_1=v1289_12 or v1289_5
                if v1301_2 then
                    v1301_2.Visible = true
                end
                if v1301_3 then
                    v1301_3.Visible = true
                end
                if v1289_7.TabModule and v1289_7.TabModule.SelectedTab then
                    pcall(function(...) v1289_7.TabModule :SelectTab(v1289_7.TabModule.SelectedTab )
                    end
                    )
                end
                local v1312_2=v0_4:Create(v1301_1,TweenInfo.new ( 0.24 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out ),{[ "Size" ]=UDim2.new (v1301_6,v1301_7, 0 ,v1312_1)})v1312_2:Play()task.delay ( 0.25 ,function(...)
                    if not v1289_10 then
                        v1301_1.ClipsDescendants = false
                        if v1301_4 then
                            v1301_4.ClipsDescendants = false
                        end
                        if v1301_5 then
                            v1301_5.ClipsDescendants = false
                        end
                        if v1301_2 then
                            v1301_2.Visible = true
                        end
                        if v1301_3 then
                            v1301_3.Visible = true
                        end
                        if v1289_7.TabModule and v1289_7.TabModule.SelectedTab then
                            pcall(function(...) v1289_7.TabModule :SelectTab(v1289_7.TabModule.SelectedTab )
                            end
                            )
                        end
                    end
                    v1289_11= false
                end
                )
            end
        end
        v1289_7.Close =function(v1326_1,...) v1289_13()
            local v1326_2={}function r.Destroy(v1327_1,...) v0_171()
            end
            return v1326_2
        end
        local function v1289_14(...)
            if v1289_7.UIElements and v1289_7.UIElements.Main then
                (v0_4:Create(v0_170.Btn ,TweenInfo.new ( 0.12 ,Enum.EasingStyle.Quart ),{[ "Size" ]=UDim2.fromOffset ( 42 , 42 )})):Play()task.wait ( 0.08 )v0_170.Btn.Size =UDim2.fromOffset ( 46 , 46 )v1289_7.UIElements.Main .Visible = true v0_170.Btn.Visible = false
                if v1289_7.TabModule and v1289_7.TabModule.SelectedTab then
                    pcall(function(...) v1289_7.TabModule :SelectTab(v1289_7.TabModule.SelectedTab )
                    end
                    )
                end
            end
        end
        local function v1289_15(...)
            if v1289_7.UIElements and v1289_7.UIElements.Main then
                v1289_7.UIElements.Main .Visible = false v0_170.Btn.Visible = true
            end
        end
        v0_170.Btn.MouseButton1Click :Connect(v1289_14)v1289_7.Destroy =function(v1334_1,...) v1289_15()
        end
        v0_5.InputBegan :Connect(function(v1335_1,v1335_2,...)
            if not v1335_2 and v1335_1.KeyCode ==Enum.KeyCode.RightShift then
                if v1289_7.UIElements and v1289_7.UIElements.Main then
                    if v1289_7.UIElements.Main .Visible then
                        v1289_15()
                    else
                        v1289_14()
                    end
                end
            end
        end
        )
        local function v1289_16(v1340_1,...)
            local v1340_2=math.clamp (tonumber(v1340_1)or 0 , 0 , 90 )
            local v1340_3=v1340_2/ 100 pcall(function(...)
                local v1341_1=v1289_7.UIElements and v1289_7.UIElements.Main
                if not v1341_1 then
                    return
                end
                if v1289_7.AcrylicPaint and v1289_7.AcrylicPaint.Frame then
                    v1289_7.AcrylicPaint.Frame .Visible =(v1340_2== 0 )
                end
                local v1341_2=v1341_1:FindFirstChild( "Background" )
                if v1341_2 then
                    if v1341_2:IsA( "ImageLabel" )then
                        v1341_2.ImageTransparency =v1340_3
                    elseif v1341_2:IsA( "Frame" )then
                        v1341_2.BackgroundTransparency =v1340_3
                    end
                end
            end
            )
        end
        local v1289_17=v0_155[v0_154]or v0_155.EN v0_157=v1289_7:Tab({[ "Title" ]=v1289_17.Tabs.Farm ;
        [ "Icon" ]= "solar:box-minimalistic-bold" })v0_158=v1289_7:Tab({[ "Title" ]=v1289_17.Tabs.EggSelect or "Egg Selection" ;
        [ "Icon" ]= "lucide:egg" })v0_159=v1289_7:Tab({[ "Title" ]=v1289_17.Tabs.Character ;
        [ "Icon" ]= "solar:user-bold" })v0_160=v1289_7:Tab({[ "Title" ]=v1289_17.Tabs.Settings ;
        [ "Icon" ]= "solar:settings-bold" })v0_156.secModes =v0_157:Section({[ "Title" ]=v1289_17.Farm.SecModes })
        local v1289_18= false
        local v1289_19=nil
        local v1289_20=nil v0_156.togTween =v0_157:Toggle({[ "Title" ]=v1289_17.Farm.TweenTitle ,[ "Desc" ]=v1289_17.Farm.TweenDesc ,[ "Icon" ]= "solar:compass-bold" ;
        [ "Value" ]=v0_51.pureTweenFarm ;
        [ "Callback" ]=function(v1347_1,...)
            if v1289_18 then
                return
            end
            if v1347_1 then
                v0_106( "TWEEN" )
            else
                if v0_105== "TWEEN" or v0_51.pureTweenFarm then
                    v0_106( "NONE" )
                end
            end
        end
        })v1289_19=v0_156.togTween v0_156.togTeleport =v0_157:Toggle({[ "Title" ]=v1289_17.Farm.TeleportTitle ;
        [ "Desc" ]=v1289_17.Farm.TeleportDesc ,[ "Icon" ]= "solar:magic-stick-3-bold" ,[ "Value" ]=v0_51.autoFarmLoop ,[ "Callback" ]=function(v1352_1,...)
            if v1289_18 then
                return
            end
            if v1352_1 then
                v0_106( "WARP" )
            else
                if v0_105== "WARP" or v0_51.autoFarmLoop then
                    v0_106( "NONE" )
                end
            end
        end
        })v1289_20=v0_156.togTeleport v0_107=function(v1357_1,...) pcall(function(...)
                if v1289_19 and v1289_19.Set then
                    v1289_18= true v1289_19:Set(v1357_1)v1289_18= false
                end
            end
            )
        end
        v0_108=function(v1360_1,...) pcall(function(...)
                if v1289_20 and v1289_20.Set then
                    v1289_18= true v1289_20:Set(v1360_1)v1289_18= false
                end
            end
            )
        end
        v0_156.secPlace =v0_157:Section({[ "Title" ]=v1289_17.Farm.SecPlace })v0_156.btnPlaceEgg =v0_157:Button({[ "Title" ]=v1289_17.Farm.PlaceTitle ,[ "Desc" ]=v1289_17.Farm.PlaceDesc ,[ "Icon" ]= "solar:box-bold" ;
        [ "Callback" ]=function(...) task.spawn (function(...) v1281_3({[ "Title" ]= "Steal An Egg V1" ,[ "Content" ]=v0_155[v0_154].Notifications.PlaceStarted ,[ "Icon" ]= "loader" })v0_51.statusText = "[Manual] Tweening to base..." v0_76(v0_51.glideSpeed ,nil, true )v1281_3({[ "Title" ]= "Steal An Egg V1" ,[ "Content" ]=v0_155[v0_154].Notifications.PlaceDone ,[ "Icon" ]= "check-circle" })
            end
            )
        end
        })v0_156.togAutoPlaceEvery5 =v0_157:Toggle({[ "Title" ]=v1289_17.Farm.AutoPlaceTitle or "Auto Place (Every 5)" ;
        [ "Desc" ]=v1289_17.Farm.AutoPlaceDesc or "Return home every 5 steals, place & wait 5s" ;
        [ "Icon" ]= "solar:box-minimalistic-bold" ;
        [ "Value" ]=v0_51.autoPlaceEvery5 ;
        [ "Callback" ]=function(v1365_1,...) v0_51.autoPlaceEvery5 =v1365_1
            if not v1365_1 then
                v0_51.batchStealCount = 0
            end
            local v1365_2=v0_155[v0_154]or v0_155.EN v1281_3({[ "Title" ]= "Auto Place (Every 5)" ,[ "Content" ]=v1365_1 and((v1365_2.Notifications.AutoPlaceStarted or "Auto Place (Every 5) enabled" ))or(v1365_2.Notifications.AutoPlaceStopped or "Auto Place (Every 5) disabled" ),[ "Icon" ]=v1365_1 and "check-circle" or "x-circle" })
        end
        })v0_156.togAutoHatch =v0_157:Toggle({[ "Title" ]=v1289_17.Farm.HatchTitle ;
        [ "Desc" ]=v1289_17.Farm.HatchDesc ,[ "Icon" ]= "solar:star-bold" ;
        [ "Value" ]=v0_51.autoHatch ,[ "Callback" ]=function(v1367_1,...) v0_51.autoHatch =v1367_1 v1281_3({[ "Title" ]= "Auto Hatch" ,[ "Content" ]=v1367_1 and v0_155[v0_154].Notifications.HatchStarted or v0_155[v0_154].Notifications.HatchStopped ,[ "Icon" ]=v1367_1 and "check-circle" or "x-circle" })
        end
        })v0_156.togAutoReturn =v0_157:Toggle({[ "Title" ]=v1289_17.Farm.ReturnTitle ;
        [ "Desc" ]=v1289_17.Farm.ReturnDesc ;
        [ "Icon" ]= "solar:undo-left-round-bold" ,[ "Value" ]=v0_51.autoGlide ;
        [ "Callback" ]=function(v1368_1,...) v0_51.autoGlide =v1368_1 v1281_3({[ "Title" ]= "Auto Return" ;
            [ "Content" ]=v1368_1 and v0_155[v0_154].Notifications.ReturnStarted or v0_155[v0_154].Notifications.ReturnStopped ;
            [ "Icon" ]=v1368_1 and "check-circle" or "x-circle" })
        end
        })v0_156.togAutoTreadmill =v0_157:Toggle({[ "Title" ]=v1289_17.Farm.AutoTreadmillTitle or "Auto Treadmill" ;
        [ "Desc" ]=v1289_17.Farm.AutoTreadmillDesc or "Run on base treadmill when no target eggs are spawned" ;
        [ "Icon" ]= "solar:running-bold" ;
        [ "Value" ]=v0_51.autoTreadmill ;
        [ "Callback" ]=function(v1369_1,...) v0_51.autoTreadmill =v1369_1 v0_55()v0_88()
            if not v1369_1 and((v0_51.onTreadmill or v0_92()))then
                v0_90()
            end
            local v1369_2=v0_155[v0_154]or v0_155.EN v1281_3({[ "Title" ]= "Auto Treadmill" ;
            [ "Content" ]=v1369_1 and((v1369_2.Notifications.AutoTreadmillStarted or "Auto Treadmill enabled (Runs when idle)" ))or(v1369_2.Notifications.AutoTreadmillStopped or "Auto Treadmill disabled" );
            [ "Icon" ]=v1369_1 and "check-circle" or "x-circle" })
        end
        })v0_156.togAutoUpgradeTreadmill =v0_157:Toggle({[ "Title" ]=v1289_17.Farm.UpgradeTreadmillTitle or "Auto Upgrade Treadmill" ;
        [ "Desc" ]=v1289_17.Farm.UpgradeTreadmillDesc or "Automatically upgrade base treadmill tier when you have enough cash" ;
        [ "Icon" ]= "solar:double-alt-arrow-up-bold" ;
        [ "Value" ]=v0_51.autoUpgradeTreadmill ,[ "Callback" ]=function(v1371_1,...) v0_51.autoUpgradeTreadmill =v1371_1 v0_55()
            local v1371_2=v0_155[v0_154]or v0_155.EN v1281_3({[ "Title" ]=(v0_154== "TH" )and "อัปเกรดลู่วิ่ง" or "Upgrade Treadmill" ,[ "Content" ]=v1371_1 and((v1371_2.Notifications.UpgradeTreadmillStarted or "Auto Upgrade Treadmill enabled" ))or(v1371_2.Notifications.UpgradeTreadmillStopped or "Auto Upgrade Treadmill disabled" ),[ "Icon" ]=v1371_1 and "check-circle" or "x-circle" })
        end
        })v0_156.togAutoBuyTrails =v0_157:Toggle({[ "Title" ]=v1289_17.Farm.BuyTrailsTitle or "Auto Buy & Equip Trails" ;
        [ "Desc" ]=v1289_17.Farm.BuyTrailsDesc or "Automatically purchase and equip the best speed trail available" ;
        [ "Icon" ]= "solar:fire-bold" ;
        [ "Value" ]=v0_51.autoBuyTrails ;
        [ "Callback" ]=function(v1372_1,...) v0_51.autoBuyTrails =v1372_1 v0_55()
            local v1372_2=v0_155[v0_154]or v0_155.EN v1281_3({[ "Title" ]=(v0_154== "TH" )and "ซื้อ Trail" or "Buy Trails" ,[ "Content" ]=v1372_1 and((v1372_2.Notifications.BuyTrailsStarted or "Auto Buy Trails enabled" ))or(v1372_2.Notifications.BuyTrailsStopped or "Auto Buy Trails disabled" );
            [ "Icon" ]=v1372_1 and "check-circle" or "x-circle" })
        end
        })v0_156.secEggZones =v0_158:Section({[ "Title" ]=(v1289_17.EggSelect and v1289_17.EggSelect.SecZones )or "Target Zones" })
        local v1289_21={ "🟣 Light Dark" ;
        "🟡 Titan Temple" , "🌸 Cherry Blossom" ;
        "🌌 Cosmic" ;
        "🦖 Prehistoric" , "🌊 Abyss Ocean" , "🌋 Volcano" ;
        "❄️ Snow" ;
        "🌴 Jungle" ;
        "🏜️ Desert" , "💧 Lake" ;
        "🌲 Forest" }
        local v1289_22={[ "🟣 Light Dark" ]= "Light Dark" ,[ "🟡 Titan Temple" ]= "Titan Temple" ,[ "🌸 Cherry Blossom" ]= "Cherry Blossom" ,[ "🌌 Cosmic" ]= "Cosmic" ;
        [ "🦖 Prehistoric" ]= "Prehistoric" ,[ "🌊 Abyss Ocean" ]= "Abyss Ocean" ;
        [ "🌋 Volcano" ]= "Volcano" ;
        [ "❄️ Snow" ]= "Snow" ;
        [ "🌴 Jungle" ]= "Jungle" ,[ "🏜️ Desert" ]= "Desert" ,[ "💧 Lake" ]= "Lake" ,[ "🌲 Forest" ]= "Forest" }
        local v1289_23={[ "Light Dark" ]= "🟣 Light Dark" ,[ "Titan Temple" ]= "🟡 Titan Temple" ;
        [ "Cherry Blossom" ]= "🌸 Cherry Blossom" ;
        [ "Cosmic" ]= "🌌 Cosmic" ,[ "Prehistoric" ]= "🦖 Prehistoric" ;
        [ "Abyss Ocean" ]= "🌊 Abyss Ocean" ;
        [ "Volcano" ]= "🌋 Volcano" ;
        [ "Snow" ]= "❄️ Snow" ,[ "Jungle" ]= "🌴 Jungle" ,[ "Desert" ]= "🏜️ Desert" ;
        [ "Lake" ]= "💧 Lake" ,[ "Forest" ]= "🌲 Forest" }
        local v1289_24={}
        for v1373_1,v1373_2 in pairs(v0_51.selectedZones or{})do
            if v1373_2 and v1289_23[v1373_1]then
                table.insert (v1289_24,v1289_23[v1373_1])
            end
        end
        v0_156.dropTargetZones =v0_158:Dropdown({[ "Title" ]=(v1289_17.EggSelect and v1289_17.EggSelect.DropZonesTitle )or "Selected Zones" ,[ "Desc" ]=(v1289_17.EggSelect and v1289_17.EggSelect.DropZonesDesc )or "Click to choose which zones to farm eggs from" ,[ "Values" ]=v1289_21,[ "Value" ]=v1289_24,[ "Multi" ]= true ;
        [ "Callback" ]=function(v1375_1,...)
            local v1375_2={}
            local function v1375_3(v1376_1,...)
                if type(v1376_1)== "table" then
                    v1376_1=v1376_1.Title or v1376_1.Name or v1376_1[ 1 ]or ""
                end
                local v1376_2=tostring(v1376_1 or "" )
                local v1376_3=v1289_22[v1376_2]
                if not v1376_3 and(v1376_2~= "" and(v1376_2~= "true" and v1376_2~= "false" ))then
                    for v1379_1,v1379_2 in ipairs(v0_38)do
                        if string.find (string.lower (v1376_2),string.lower (v1379_2))then
                            v1376_3=v1379_2
                            break
                        end
                    end
                end
                if v1376_3 and v0_37[v1376_3]then
                    v1375_2[v1376_3]= true
                end
            end
            if type(v1375_1)== "table" then
                for v1383_1,v1383_2 in pairs(v1375_1)do
                    if type(v1383_2)== "string" or type(v1383_2)== "table" then
                        v1375_3(v1383_2)
                    elseif type(v1383_1)== "string" and v1383_2== true then
                        v1375_3(v1383_1)
                    end
                end
            elseif type(v1375_1)== "string" then
                v1375_3(v1375_1)
            end
            v0_51.selectedZones =v1375_2 v0_55()
        end
        })v0_156.secEggRarity =v0_158:Section({[ "Title" ]=(v1289_17.EggSelect and v1289_17.EggSelect.SecRarities )or "Target Rarities" })
        local v1289_25={ "👑 Divine (Tier 6)" ;
        "⚡ Eternal (Tier 5)" , "🔥 Secret (Tier 4)" , "✨ Cosmic (Tier 3)" , "🔮 Mythic (Tier 2)" ;
        "⭐ Legendary (Tier 1)" ;
        "💜 Epic" ;
        "🔷 Rare" ;
        "🟢 Uncommon" , "⚪ Common" }
        local v1289_26={[ "👑 Divine (Tier 6)" ]= "Divine" ,[ "⚡ Eternal (Tier 5)" ]= "Eternal" ,[ "🔥 Secret (Tier 4)" ]= "Secret" ;
        [ "✨ Cosmic (Tier 3)" ]= "Cosmic" ;
        [ "🔮 Mythic (Tier 2)" ]= "Mythic" ;
        [ "⭐ Legendary (Tier 1)" ]= "Legendary" ,[ "💜 Epic" ]= "Epic" ,[ "🔷 Rare" ]= "Rare" ,[ "🟢 Uncommon" ]= "Uncommon" ,[ "⚪ Common" ]= "Common" }
        local v1289_27={[ "Divine" ]= "👑 Divine (Tier 6)" ,[ "Eternal" ]= "⚡ Eternal (Tier 5)" ;
        [ "Secret" ]= "🔥 Secret (Tier 4)" ;
        [ "Cosmic" ]= "✨ Cosmic (Tier 3)" ,[ "Mythic" ]= "🔮 Mythic (Tier 2)" ,[ "Legendary" ]= "⭐ Legendary (Tier 1)" ,[ "Epic" ]= "💜 Epic" ,[ "Rare" ]= "🔷 Rare" ;
        [ "Uncommon" ]= "🟢 Uncommon" ;
        [ "Common" ]= "⚪ Common" }
        local v1289_28={}
        for v1387_1,v1387_2 in pairs(v0_51.selectedRarities or{})do
            if v1387_2 and v1289_27[v1387_1]then
                table.insert (v1289_28,v1289_27[v1387_1])
            end
        end
        v0_156.dropTargetRarities =v0_158:Dropdown({[ "Title" ]=(v1289_17.EggSelect and v1289_17.EggSelect.DropRaritiesTitle )or "Selected Rarities" ;
        [ "Desc" ]=(v1289_17.EggSelect and v1289_17.EggSelect.DropRaritiesDesc )or "Click to choose which rarities to collect" ,[ "Values" ]=v1289_25;
        [ "Value" ]=v1289_28,[ "Multi" ]= true ;
        [ "Callback" ]=function(v1389_1,...)
            local v1389_2={}
            local function v1389_3(v1390_1,...)
                if type(v1390_1)== "table" then
                    v1390_1=v1390_1.Title or v1390_1.Name or v1390_1[ 1 ]or ""
                end
                local v1390_2=string.lower (tostring(v1390_1 or "" ))
                for v1392_1,v1392_2 in ipairs(v0_48)do
                    if string.find (v1390_2,string.lower (v1392_2))then
                        v1389_2[v1392_2]= true
                        break
                    end
                end
            end
            if type(v1389_1)== "table" then
                for v1395_1,v1395_2 in pairs(v1389_1)do
                    if type(v1395_2)== "string" or type(v1395_2)== "table" then
                        v1389_3(v1395_2)
                    elseif type(v1395_1)== "string" and v1395_2== true then
                        v1389_3(v1395_1)
                    end
                end
            elseif type(v1389_1)== "string" then
                v1389_3(v1389_1)
            end
            v0_51.selectedRarities =v1389_2 v0_55()
        end
        })v0_156.secSafety =v0_159:Section({[ "Title" ]=v1289_17.Character.SecSafety })v0_156.togGodmode =v0_159:Toggle({[ "Title" ]=v1289_17.Character.GodmodeTitle ;
        [ "Desc" ]=v1289_17.Character.GodmodeDesc ,[ "Icon" ]= "solar:shield-check-bold" ,[ "Value" ]= false ;
        [ "Callback" ]=function(v1399_1,...)
            if v1399_1 then
                v0_113()v1281_3({[ "Title" ]= "Godmode" ,[ "Content" ]=v0_155[v0_154].Notifications.GodmodeStarted ,[ "Icon" ]= "shield-check" })
            else
                v0_114()v1281_3({[ "Title" ]= "Godmode" ,[ "Content" ]=v0_155[v0_154].Notifications.GodmodeStopped ,[ "Icon" ]= "shield-off" })
            end
        end
        })v0_156.btnUnstick =v0_159:Button({[ "Title" ]=v1289_17.Character.UnstickTitle ,[ "Desc" ]=v1289_17.Character.UnstickDesc ,[ "Icon" ]= "solar:exit-bold" ;
        [ "Callback" ]=function(...) pcall(v0_90)pcall(v0_86)pcall(v0_85)v1281_3({[ "Title" ]= "Unstick" ;
            [ "Content" ]=v0_155[v0_154].Notifications.UnstickDone ,[ "Icon" ]= "check" })
        end
        })v0_156.secFlight =v0_159:Section({[ "Title" ]=v1289_17.Character.SecFlight })v0_156.sliderSpeed =v0_159:Slider({[ "Title" ]=v1289_17.Character.SpeedTitle ,[ "Desc" ]=v1289_17.Character.SpeedDesc ,[ "Step" ]= 25 ,[ "Value" ]={[ "Min" ]= 100 ;
        [ "Max" ]= 1000 ;
        [ "Default" ]=v0_51.glideSpeed or 600 },[ "Callback" ]=function(v1403_1,...) v0_51.glideSpeed =v1403_1 v0_53(v1403_1)
        end
        })v0_156.secDashboard =v0_160:Section({[ "Title" ]=v1289_17.Settings.SecDashboard })v0_156.paraLiveDash =v0_160:Paragraph({[ "Title" ]=v1289_17.Settings.DashTitle ;
        [ "Desc" ]=string.format ( "Status: Ready\nFarm Mode: Idle\nCarried Eggs: 0\nFlight Speed: %d Studs/s" ,v0_51.glideSpeed or 600 )})v0_156.secUI =v0_160:Section({[ "Title" ]=v1289_17.Settings.SecUI })v0_156.dropLang =v0_160:Dropdown({[ "Title" ]=v1289_17.Settings.LangTitle ,[ "Values" ]={ "English" , "ไทย" },[ "Value" ]=(v0_154== "EN" and "English" or "ไทย" ),[ "Callback" ]=function(v1404_1,...)
            local v1404_2=(v1404_1== "ไทย" )and "TH" or "EN"
            if v1404_2~=v0_154 then
                v0_154=v1404_2 v0_168(v0_154)pcall(v0_55)v1281_3({[ "Title" ]=(v0_154== "TH" )and "ภาษา" or "Language" ,[ "Content" ]=v0_155[v0_154].Notifications.LangSwitched ,[ "Icon" ]= "check-circle" })
            end
        end
        })v0_156.sliderTransp =v0_160:Slider({[ "Title" ]=v1289_17.Settings.TranspTitle ;
        [ "Desc" ]=v1289_17.Settings.TranspDesc ;
        [ "Step" ]= 5 ;
        [ "Value" ]={[ "Min" ]= 0 ;
        [ "Max" ]= 90 ,[ "Default" ]= 0 },[ "Callback" ]=function(v1406_1,...) v1289_16(v1406_1)
        end
        })v0_156.dropTheme =v0_160:Dropdown({[ "Title" ]=v1289_17.Settings.ThemeTitle ;
        [ "Values" ]={ "Dark" ;
        "Rose" , "Plant" ;
        "Red" , "Sky" , "Purple" },[ "Value" ]= "Dark" ;
        [ "Callback" ]=function(v1407_1,...) pcall(function(...) v1281_2:SetTheme(v1407_1)
            end
            )
        end
        })v0_156.secPerformance =v0_160:Section({[ "Title" ]=(v1289_17.Settings and v1289_17.Settings.SecPerformance )or "Performance & Graphics" })v0_156.togPerformance =v0_160:Toggle({[ "Title" ]=(v1289_17.Settings and v1289_17.Settings.PerformanceTitle )or "Ultra Potato Mode (Maximum FPS Boost)" ;
        [ "Desc" ]=(v1289_17.Settings and v1289_17.Settings.PerformanceDesc )or "Disables shadows, textures, particles, and shaders for maximum FPS smoothness" ,[ "Icon" ]= "solar:bolt-bold" ,[ "Value" ]=v0_51.performanceMode ,[ "Callback" ]=function(v1409_1,...) v0_51.performanceMode =v1409_1 v0_55()
            if v1409_1 then
                v0_144()
            else
                v0_145()
            end
            local v1409_2=v0_155[v0_154]or v0_155.EN v1281_3({[ "Title" ]= "Performance Mode" ,[ "Content" ]=v1409_1 and((v1409_2.Notifications.PerformanceStarted or "Performance Mode enabled" ))or(v1409_2.Notifications.PerformanceStopped or "Performance Mode disabled" ),[ "Icon" ]=v1409_1 and "check-circle" or "x-circle" })
        end
        })v0_156.togDisable3D =v0_160:Toggle({[ "Title" ]=(v1289_17.Settings and v1289_17.Settings.Disable3DTitle )or "Disable 3D Rendering (GPU Saver 95%)" ;
        [ "Desc" ]=(v1289_17.Settings and v1289_17.Settings.Disable3DDesc )or "Freezes 3D viewport rendering to drop GPU usage to ~1%. Perfect for overnight farming!" ;
        [ "Icon" ]= "solar:monitor-camera-bold" ;
        [ "Value" ]=v0_51.disable3D ,[ "Callback" ]=function(v1412_1,...) v0_51.disable3D =v1412_1 v0_55()pcall(function(...) v0_3:Set3dRenderingEnabled(not v1412_1)
            end
            )
            local v1412_2=v0_155[v0_154]or v0_155.EN v1281_3({[ "Title" ]= "3D Rendering" ,[ "Content" ]=v1412_1 and((v1412_2.Notifications.Disable3DStarted or "3D Rendering disabled (GPU Saver)" ))or(v1412_2.Notifications.Disable3DStopped or "3D Rendering restored" ),[ "Icon" ]=v1412_1 and "check-circle" or "x-circle" })
        end
        })v0_156.secSystem =v0_160:Section({[ "Title" ]=v1289_17.Settings.SecSystem })v0_156.togAntiAFK =v0_160:Toggle({[ "Title" ]=(v1289_17.Settings and v1289_17.Settings.AntiAFKTitle )or "Anti-AFK (Double-Esc 10m / Mobile)" ,[ "Desc" ]=(v1289_17.Settings and v1289_17.Settings.AntiAFKDesc )or "Double-Esc menu pulse every 10m + Mobile touch + PC jitter resets idle timer safely without Idled" ;
        [ "Icon" ]= "solar:shield-check-bold" ;
        [ "Value" ]=v0_51.antiAFK ,[ "Callback" ]=function(v1414_1,...) v0_51.antiAFK =v1414_1 v0_55()
            if v1414_1 then
                v0_148()
            else
                v0_149()
            end
            local v1414_2=v0_155[v0_154]or v0_155.EN v1281_3({[ "Title" ]= "Anti-AFK" ,[ "Content" ]=v1414_1 and((v1414_2.Notifications.AntiAFKStarted or "Safe Anti-AFK enabled" ))or(v1414_2.Notifications.AntiAFKStopped or "Safe Anti-AFK disabled" ),[ "Icon" ]=v1414_1 and "check-circle" or "x-circle" })
        end
        })v0_156.btnReset =v0_160:Button({[ "Title" ]=v1289_17.Settings.ResetTitle ;
        [ "Desc" ]=v1289_17.Settings.ResetDesc ,[ "Icon" ]= "solar:restart-bold" ;
        [ "Callback" ]=function(...) pcall(v0_85)pcall(v0_61)v1281_3({[ "Title" ]= "Reset State" ;
            [ "Content" ]= "Character state reset successfully" ,[ "Icon" ]= "check-circle" })
        end
        })v0_156.btnRejoin =v0_160:Button({[ "Title" ]=v1289_17.Settings.RejoinTitle ;
        [ "Desc" ]=v1289_17.Settings.RejoinDesc ;
        [ "Icon" ]= "solar:logout-2-bold" ,[ "Callback" ]=function(...) pcall(function(...) v0_9:TeleportToPlaceInstance(game.PlaceId,game.JobId,v0_10)
            end
            )
        end
        })v0_156.btnUnload =v0_160:Button({[ "Title" ]=v1289_17.Settings.UnloadTitle ,[ "Desc" ]=v1289_17.Settings.UnloadDesc ;
        [ "Icon" ]= "solar:trash-bin-trash-bold" ,[ "Callback" ]=function(...) v0_171()
        end
        })v0_166()task.spawn (function(...)
            while v0_51.alive do
                pcall(function(...)
                    local v1423_1=v0_60()
                    local v1423_2=(v0_154== "TH" )
                    local v1423_3=v0_162(v0_154)
                    if v1289_8 then
                        local v1424_1=Color3.fromRGB ( 0 , 255 , 160 )
                        if v0_51.securingEgg or v0_51.teleporting then
                            v1424_1=Color3.fromRGB ( 249 , 115 , 22 )
                        elseif v0_51.isReturning or v0_51.glidingToTarget then
                            v1424_1=Color3.fromRGB ( 59 , 130 , 246 )
                        elseif v0_51.delivering then
                            v1424_1=Color3.fromRGB ( 16 , 185 , 129 )
                        end
                        pcall(function(...)
                            if v1289_8.SetTitle then
                                v1289_8:SetTitle(((v1423_2 and "สถานะ: " or "Status: " ))..v1423_3)
                            end
                            if v1289_8.SetColor then
                                v1289_8:SetColor(v1424_1)
                            end
                        end
                        )
                    end
                    if v0_156.paraLiveDash and v0_156.paraLiveDash.SetDesc then
                        local v1431_1=v1423_2 and "หยุดพัก" or "Idle"
                        if v0_105== "TWEEN" then
                            v1431_1=v1423_2 and "ขโมยไข่ (บินเร็ว)" or "Auto Steal (Tween)"
                        elseif v0_105== "WARP" then
                            v1431_1=v1423_2 and "ขโมยไข่ (วาร์ป)" or "Auto Steal (Teleport)"
                        end
                        local v1431_2=v1423_2 and "สถานะ: %s\nโหมดฟาร์ม: %s\nจำนวนไข่ในตัว: %d ฟอง\nความเร็วบิน: %d Studs/s" or "Status: %s\nFarm Mode: %s\nCarried Eggs: %d\nFlight Speed: %d Studs/s"
                        local v1431_3=string.format (v1431_2,v1423_3,v1431_1,v1423_1,v0_51.glideSpeed or 600 )pcall(function(...) v0_156.paraLiveDash :SetDesc(v1431_3)
                        end
                        )
                    end
                end
                )task.wait ( 0.5 )
            end
        end
        )v1281_1(v1289_14)
        return
    end
    if v0_51.gui then
        pcall(function(...) v0_51.gui :Destroy()
        end
        )v0_51.gui =nil
    end
    local v1281_4=Instance.new ( "ScreenGui" )v1281_4.Name = "DesyncSniperUI_v41_5" v1281_4.ResetOnSpawn = false v1281_4.DisplayOrder = 99999 v1281_4.ZIndexBehavior =Enum.ZIndexBehavior.Sibling v1281_4.AutoLocalize = false
    local v1281_5=v0_10:FindFirstChild( "PlayerGui" )or game:GetService( "CoreGui" )pcall(function(...)
        if syn and syn.protect_gui then
            syn.protect_gui (v1281_4)v1281_4.Parent =game:GetService( "CoreGui" )
        else
            v1281_4.Parent =v1281_5
        end
    end
    )
    if not v1281_4.Parent then
        v1281_4.Parent =v1281_5
    end
    v0_51.gui =v1281_4
    local v1281_6=Color3.fromRGB ( 15 , 17 , 24 )
    local v1281_7=Color3.fromRGB ( 20 , 24 , 34 )
    local v1281_8=Color3.fromRGB ( 22 , 26 , 38 )
    local v1281_9=Color3.fromRGB ( 28 , 33 , 48 )
    local v1281_10=Color3.fromRGB ( 45 , 52 , 75 )
    local v1281_11=Color3.fromRGB ( 240 , 243 , 255 )
    local v1281_12=Color3.fromRGB ( 140 , 148 , 170 )
    local v1281_13=Color3.fromRGB ( 38 , 43 , 60 )
    local v1281_14=Color3.fromRGB ( 150 , 158 , 180 )
    local v1281_15=Color3.fromRGB ( 255 , 255 , 255 )
    local v1281_16= 475
    local v1281_17= 46
    local v1281_18= false
    local v1281_19=Instance.new ( "Frame" )v1281_19.Name = "MainFrame" v1281_19.Size =UDim2.new ( 0 , 330 , 0 ,v1281_16)v1281_19.Position =UDim2.new ( 0.04 , 0 , 0.22 , 0 )v1281_19.BackgroundColor3 =v1281_6 v1281_19.BorderSizePixel = 0 v1281_19.Active = true v1281_19.Draggable = true v1281_19.ClipsDescendants = true v1281_19.Parent =v1281_4
    local v1281_20=Instance.new ( "UICorner" )v1281_20.CornerRadius =UDim.new ( 0 , 12 )v1281_20.Parent =v1281_19
    local v1281_21=Instance.new ( "UIStroke" )v1281_21.Color =v1281_10 v1281_21.Thickness = 1.4 v1281_21.Parent =v1281_19
    local v1281_22=Instance.new ( "Frame" )v1281_22.Name = "Header" v1281_22.Size =UDim2.new ( 1 , 0 , 0 , 46 )v1281_22.BackgroundColor3 =v1281_7 v1281_22.BorderSizePixel = 0 v1281_22.Parent =v1281_19;
    (Instance.new ( "UICorner" ,v1281_22)).CornerRadius =UDim.new ( 0 , 12 )
    local v1281_23=Instance.new ( "TextLabel" )v1281_23.Size =UDim2.new ( 1 , -90 , 0 , 22 )v1281_23.Position =UDim2.new ( 0 , 12 , 0 , 6 )v1281_23.BackgroundTransparency = 1 v1281_23.Text = "Dice Hub (Fallback)" v1281_23.TextColor3 =v1281_11 v1281_23.TextSize = 14 v1281_23.Font =Enum.Font.GothamBold v1281_23.TextXAlignment =Enum.TextXAlignment.Left v1281_23.AutoLocalize = false v1281_23.Parent =v1281_22
    local v1281_24=Instance.new ( "TextLabel" )v1281_24.Size =UDim2.new ( 1 , -90 , 0 , 14 )v1281_24.Position =UDim2.new ( 0 , 12 , 0 , 26 )v1281_24.BackgroundTransparency = 1 v1281_24.Text = "Steal an Egg v42.64" v1281_24.TextColor3 =Color3.fromRGB ( 0 , 255 , 160 )v1281_24.TextSize = 11 v1281_24.Font =Enum.Font.Gotham v1281_24.TextXAlignment =Enum.TextXAlignment.Left v1281_24.AutoLocalize = false v1281_24.Parent =v1281_22
    local v1281_25=Instance.new ( "TextButton" )v1281_25.Size =UDim2.new ( 0 , 28 , 0 , 28 )v1281_25.Position =UDim2.new ( 1 , -68 , 0 , 9 )v1281_25.BackgroundColor3 =v1281_8 v1281_25.Text = "-" v1281_25.TextColor3 =v1281_11 v1281_25.TextSize = 16 v1281_25.Font =Enum.Font.GothamBold v1281_25.AutoButtonColor = false v1281_25.Parent =v1281_22;
    (Instance.new ( "UICorner" ,v1281_25)).CornerRadius =UDim.new ( 0 , 6 )
    local v1281_26=Instance.new ( "TextButton" )v1281_26.Size =UDim2.new ( 0 , 28 , 0 , 28 )v1281_26.Position =UDim2.new ( 1 , -36 , 0 , 9 )v1281_26.BackgroundColor3 =Color3.fromRGB ( 239 , 68 , 68 )v1281_26.Text = "X" v1281_26.TextColor3 =v1281_11 v1281_26.TextSize = 12 v1281_26.Font =Enum.Font.GothamBold v1281_26.AutoButtonColor = false v1281_26.Parent =v1281_22;
    (Instance.new ( "UICorner" ,v1281_26)).CornerRadius =UDim.new ( 0 , 6 )
    local v1281_27=Instance.new ( "ScrollingFrame" )v1281_27.Size =UDim2.new ( 1 , 0 , 1 , -46 )v1281_27.Position =UDim2.new ( 0 , 0 , 0 , 46 )v1281_27.BackgroundTransparency = 1 v1281_27.BorderSizePixel = 0 v1281_27.ScrollBarThickness = 3 v1281_27.ScrollBarImageColor3 =v1281_10 v1281_27.CanvasSize =UDim2.new ( 0 , 0 , 0 , 0 )v1281_27.AutomaticCanvasSize =Enum.AutomaticSize.Y v1281_27.Parent =v1281_19
    local v1281_28=Instance.new ( "UIListLayout" )v1281_28.SortOrder =Enum.SortOrder.LayoutOrder v1281_28.Padding =UDim.new ( 0 , 7 )v1281_28.Parent =v1281_27
    local v1281_29=Instance.new ( "UIPadding" )v1281_29.PaddingTop =UDim.new ( 0 , 8 )v1281_29.PaddingBottom =UDim.new ( 0 , 12 )v1281_29.PaddingLeft =UDim.new ( 0 , 10 )v1281_29.PaddingRight =UDim.new ( 0 , 10 )v1281_29.Parent =v1281_27 v1281_25.MouseButton1Click :Connect(function(...) v1281_18=not v1281_18 v1281_25.Text =v1281_18 and "+" or "-" ;
        (v0_4:Create(v1281_19,TweenInfo.new ( 0.25 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out ),{[ "Size" ]=v1281_18 and UDim2.new ( 0 , 330 , 0 ,v1281_17)or UDim2.new ( 0 , 330 , 0 ,v1281_16)})):Play()
    end
    )v1281_26.MouseButton1Click :Connect(function(...) v0_171()
    end
    )
    local function v1281_30(v1443_1,v1443_2,...)
        local v1443_3=Instance.new ( "Frame" )v1443_3.Size =UDim2.new ( 1 , 0 , 0 , 20 )v1443_3.BackgroundTransparency = 1 v1443_3.LayoutOrder =v1443_2 v1443_3.Parent =v1281_27
        local v1443_4=Instance.new ( "TextLabel" )v1443_4.Size =UDim2.new ( 1 , 0 , 1 , 0 )v1443_4.BackgroundTransparency = 1 v1443_4.Text =v1443_1 v1443_4.TextColor3 =Color3.fromRGB ( 0 , 185 , 255 )v1443_4.TextSize = 11 v1443_4.Font =Enum.Font.GothamBold v1443_4.TextXAlignment =Enum.TextXAlignment.Left v1443_4.AutoLocalize = false v1443_4.Parent =v1443_3
        return v1443_3
    end
    local function v1281_31(v1444_1,v1444_2,v1444_3,v1444_4,v1444_5,v1444_6,...)
        local v1444_7=Instance.new ( "Frame" )v1444_7.Size =UDim2.new ( 1 , 0 , 0 , 52 )v1444_7.BackgroundColor3 =v1281_8 v1444_7.LayoutOrder =v1444_5 v1444_7.Parent =v1281_27;
        (Instance.new ( "UICorner" ,v1444_7)).CornerRadius =UDim.new ( 0 , 8 )
        local v1444_8=Instance.new ( "TextLabel" )v1444_8.Size =UDim2.new ( 1 , -60 , 0 , 18 )v1444_8.Position =UDim2.new ( 0 , 10 , 0 , 8 )v1444_8.BackgroundTransparency = 1 v1444_8.Text =v1444_1 v1444_8.TextColor3 =v1444_4 or v1281_11 v1444_8.TextSize = 13 v1444_8.Font =Enum.Font.GothamBold v1444_8.TextXAlignment =Enum.TextXAlignment.Left v1444_8.AutoLocalize = false v1444_8.Parent =v1444_7
        local v1444_9=Instance.new ( "TextLabel" )v1444_9.Size =UDim2.new ( 1 , -60 , 0 , 16 )v1444_9.Position =UDim2.new ( 0 , 10 , 0 , 26 )v1444_9.BackgroundTransparency = 1 v1444_9.Text =v1444_2 v1444_9.TextColor3 =v1281_12 v1444_9.TextSize = 10 v1444_9.Font =Enum.Font.Gotham v1444_9.TextXAlignment =Enum.TextXAlignment.Left v1444_9.AutoLocalize = false v1444_9.Parent =v1444_7
        local v1444_10=Instance.new ( "TextButton" )v1444_10.Size =UDim2.new ( 0 , 44 , 0 , 24 )v1444_10.Position =UDim2.new ( 1 , -54 , 0.5 , -12 )v1444_10.BackgroundColor3 =v1444_3 and v1444_4 or v1281_13 v1444_10.Text = "" v1444_10.AutoButtonColor = false v1444_10.Parent =v1444_7;
        (Instance.new ( "UICorner" ,v1444_10)).CornerRadius =UDim.new ( 1 , 0 )
        local v1444_11=Instance.new ( "Frame" )v1444_11.Size =UDim2.new ( 0 , 18 , 0 , 18 )v1444_11.Position =v1444_3 and UDim2.new ( 1 , -21 , 0.5 , -9 )or UDim2.new ( 0 , 3 , 0.5 , -9 )v1444_11.BackgroundColor3 =v1444_3 and v1281_15 or v1281_14 v1444_11.Parent =v1444_10;
        (Instance.new ( "UICorner" ,v1444_11)).CornerRadius =UDim.new ( 1 , 0 )
        local v1444_12=v1444_3
        local function v1444_13(v1445_1,...) v1444_12=v1445_1
            local v1445_2=TweenInfo.new ( 0.18 ,Enum.EasingStyle.Quart ,Enum.EasingDirection.Out );
            (v0_4:Create(v1444_10,v1445_2,{[ "BackgroundColor3" ]=v1444_12 and v1444_4 or v1281_13})):Play();
            (v0_4:Create(v1444_11,v1445_2,{[ "Position" ]=v1444_12 and UDim2.new ( 1 , -21 , 0.5 , -9 )or UDim2.new ( 0 , 3 , 0.5 , -9 );
            [ "BackgroundColor3" ]=v1444_12 and v1281_15 or v1281_14})):Play()
        end
        v1444_10.MouseButton1Click :Connect(function(...)
            local v1446_1=not v1444_12 v1444_13(v1446_1)v1444_6(v1446_1)
        end
        )
        return v1444_13
    end
    local function v1281_32(v1447_1,v1447_2,v1447_3,v1447_4,v1447_5,...)
        local v1447_6=Instance.new ( "Frame" )v1447_6.Size =UDim2.new ( 1 , 0 , 0 , 48 )v1447_6.BackgroundColor3 =v1281_8 v1447_6.LayoutOrder =v1447_4 v1447_6.Parent =v1281_27;
        (Instance.new ( "UICorner" ,v1447_6)).CornerRadius =UDim.new ( 0 , 8 )
        local v1447_7=Instance.new ( "TextLabel" )v1447_7.Size =UDim2.new ( 1 , -95 , 0 , 18 )v1447_7.Position =UDim2.new ( 0 , 10 , 0 , 6 )v1447_7.BackgroundTransparency = 1 v1447_7.Text =v1447_1 v1447_7.TextColor3 =v1447_3 or v1281_11 v1447_7.TextSize = 13 v1447_7.Font =Enum.Font.GothamBold v1447_7.TextXAlignment =Enum.TextXAlignment.Left v1447_7.AutoLocalize = false v1447_7.Parent =v1447_6
        local v1447_8=Instance.new ( "TextLabel" )v1447_8.Size =UDim2.new ( 1 , -95 , 0 , 16 )v1447_8.Position =UDim2.new ( 0 , 10 , 0 , 24 )v1447_8.BackgroundTransparency = 1 v1447_8.Text =v1447_2 v1447_8.TextColor3 =v1281_12 v1447_8.TextSize = 10 v1447_8.Font =Enum.Font.Gotham v1447_8.TextXAlignment =Enum.TextXAlignment.Left v1447_8.AutoLocalize = false v1447_8.Parent =v1447_6
        local v1447_9=Instance.new ( "TextButton" )v1447_9.Size =UDim2.new ( 0 , 78 , 0 , 30 )v1447_9.Position =UDim2.new ( 1 , -86 , 0.5 , -15 )v1447_9.BackgroundColor3 =v1447_3 v1447_9.Text = "RUN" v1447_9.TextColor3 =Color3.fromRGB ( 255 , 255 , 255 )v1447_9.TextSize = 11 v1447_9.Font =Enum.Font.GothamBold v1447_9.AutoButtonColor = false v1447_9.Parent =v1447_6;
        (Instance.new ( "UICorner" ,v1447_9)).CornerRadius =UDim.new ( 0 , 6 )v1447_9.MouseButton1Click :Connect(v1447_5)
    end
    v1281_30( "AUTO STEAL MODES" , 10 )
    local v1281_33= false
    local v1281_34=nil
    local v1281_35=nil v1281_34=v1281_31( "Auto Steal (Tween)" , "Fly to steal eggs & auto stash into backpack" ,v0_51.pureTweenFarm ,Color3.fromRGB ( 0 , 195 , 255 ), 11 ,function(v1448_1,...)
        if v1281_33 then
            return
        end
        if v1448_1 then
            v0_106( "TWEEN" )
        else
            if v0_105== "TWEEN" or v0_51.pureTweenFarm then
                v0_106( "NONE" )
            end
        end
    end
    )v1281_35=v1281_31( "Auto Steal (Teleport)" , "Teleport to steal eggs in continuous loop" ,v0_51.autoFarmLoop ,Color3.fromRGB ( 168 , 85 , 247 ), 12 ,function(v1453_1,...)
        if v1281_33 then
            return
        end
        if v1453_1 then
            v0_106( "WARP" )
        else
            if v0_105== "WARP" or v0_51.autoFarmLoop then
                v0_106( "NONE" )
            end
        end
    end
    )v0_107=function(v1458_1,...) pcall(function(...)
            if v1281_34 then
                v1281_33= true v1281_34(v1458_1)v1281_33= false
            end
        end
        )
    end
    v0_108=function(v1461_1,...) pcall(function(...)
            if v1281_35 then
                v1281_33= true v1281_35(v1461_1)v1281_33= false
            end
        end
        )
    end
    v1281_32( "Single Steal (Teleport)" , "Teleport to steal 1 target egg and return" ,Color3.fromRGB ( 59 , 130 , 246 ), 13 ,function(...) task.spawn (function(...)
            if v0_105~= "NONE" then
                v0_106( "NONE" )task.wait ( 0.2 )
            end
            local v1465_1=v0_82()
            if v1465_1 then
                local v1467_1=v0_84(v1465_1,nil)
                if v1467_1 then
                    pcall(v0_61)
                    if v0_51.autoGlide then
                        v0_80(v0_51.glideSpeed )v0_61()
                    end
                end
            end
        end
        )
    end
    )v1281_30( "PLACE EGG" , 20 )v1281_32( "Place Egg" , "Tween home, place all carried eggs & hatch" ,Color3.fromRGB ( 16 , 215 , 130 ), 21 ,function(...) task.spawn (function(...) v0_51.statusText = "[Manual] Depositing eggs..." v0_79(v0_51.glideSpeed )v0_76()v0_61()v0_51.isReturning = false v0_51.delivering = false
        end
        )
    end
    )v1281_31( "Auto Place (Every 5)" , "Return home every 5 steals, place & wait 5s" ,v0_51.autoPlaceEvery5 ,Color3.fromRGB ( 14 , 165 , 233 ), 22 ,function(v1472_1,...) v0_51.autoPlaceEvery5 =v1472_1
        if not v1472_1 then
            v0_51.batchStealCount = 0
        end
    end
    )v1281_31( "Auto Hatch" , "Automatically hatch ready eggs continuously" ,v0_51.autoHatch ,Color3.fromRGB ( 16 , 185 , 129 ), 22 ,function(v1474_1,...) v0_51.autoHatch =v1474_1
    end
    )v1281_31( "Auto Return" , "Automatically return to safe area after stealing" ,v0_51.autoGlide ,Color3.fromRGB ( 245 , 158 , 11 ), 23 ,function(v1475_1,...) v0_51.autoGlide =v1475_1
    end
    )v1281_31( "Auto Treadmill" , "Run on base treadmill when no target eggs are spawned" ,v0_51.autoTreadmill ,Color3.fromRGB ( 168 , 85 , 247 ), 24 ,function(v1476_1,...) v0_51.autoTreadmill =v1476_1 v0_55()v0_88()
        if not v1476_1 and((v0_51.onTreadmill or v0_92()))then
            v0_90()
        end
    end
    )v1281_30( "CHARACTER & SAFETY" , 30 )v1281_31( "Godmode" , "Invincible against attacks and guards" , false ,Color3.fromRGB ( 244 , 63 , 94 ), 31 ,function(v1478_1,...)
        if v1478_1 then
            v0_113()
        else
            v0_114()
        end
    end
    )v1281_32( "Get Out Treadmill" , "Instantly escape from treadmill or gear" ,Color3.fromRGB ( 249 , 115 , 22 ), 32 ,function(...) pcall(v0_90)pcall(v0_86)pcall(v0_85)
    end
    )v1281_30( "CONTROLS & SETTINGS" , 40 )
    local v1281_36=Instance.new ( "Frame" )v1281_36.Size =UDim2.new ( 1 , 0 , 0 , 48 )v1281_36.BackgroundColor3 =v1281_8 v1281_36.LayoutOrder = 41 v1281_36.Parent =v1281_27;
    (Instance.new ( "UICorner" ,v1281_36)).CornerRadius =UDim.new ( 0 , 8 )
    local v1281_37=Instance.new ( "TextLabel" )v1281_37.Size =UDim2.new ( 1 , -130 , 0 , 18 )v1281_37.Position =UDim2.new ( 0 , 10 , 0 , 6 )v1281_37.BackgroundTransparency = 1 v1281_37.Text = "Flight Speed" v1281_37.TextColor3 =v1281_11 v1281_37.TextSize = 13 v1281_37.Font =Enum.Font.GothamBold v1281_37.TextXAlignment =Enum.TextXAlignment.Left v1281_37.AutoLocalize = false v1281_37.Parent =v1281_36
    local v1281_38=Instance.new ( "TextLabel" )v1281_38.Size =UDim2.new ( 0 , 70 , 0 , 24 )v1281_38.Position =UDim2.new ( 1 , -80 , 0.5 , -12 )v1281_38.BackgroundColor3 =v1281_6 v1281_38.Text =string.format ( "%d Studs/s" ,v0_51.glideSpeed or 600 )v1281_38.TextColor3 =Color3.fromRGB ( 0 , 255 , 160 )v1281_38.TextSize = 11 v1281_38.Font =Enum.Font.GothamBold v1281_38.AutoLocalize = false v1281_38.Parent =v1281_36;
    (Instance.new ( "UICorner" ,v1281_38)).CornerRadius =UDim.new ( 0 , 6 )
    local v1281_39=Instance.new ( "TextButton" )v1281_39.Size =UDim2.new ( 0 , 24 , 0 , 24 )v1281_39.Position =UDim2.new ( 1 , -110 , 0.5 , -12 )v1281_39.BackgroundColor3 =v1281_9 v1281_39.Text = "-" v1281_39.TextColor3 =v1281_11 v1281_39.TextSize = 14 v1281_39.Font =Enum.Font.GothamBold v1281_39.Parent =v1281_36;
    (Instance.new ( "UICorner" ,v1281_39)).CornerRadius =UDim.new ( 0 , 6 )
    local v1281_40=Instance.new ( "TextButton" )v1281_40.Size =UDim2.new ( 0 , 24 , 0 , 24 )v1281_40.Position =UDim2.new ( 1 , -138 , 0.5 , -12 )v1281_40.BackgroundColor3 =v1281_9 v1281_40.Text = "+" v1281_40.TextColor3 =v1281_11 v1281_40.TextSize = 14 v1281_40.Font =Enum.Font.GothamBold v1281_40.Parent =v1281_36;
    (Instance.new ( "UICorner" ,v1281_40)).CornerRadius =UDim.new ( 0 , 6 )v1281_39.MouseButton1Click :Connect(function(...) v0_51.glideSpeed =math.max ( 100 ,((v0_51.glideSpeed or 600 ))- 25 )v1281_38.Text =string.format ( "%d Studs/s" ,v0_51.glideSpeed )v0_53(v0_51.glideSpeed )
    end
    )v1281_40.MouseButton1Click :Connect(function(...) v0_51.glideSpeed =math.min ( 1000 ,((v0_51.glideSpeed or 600 ))+ 25 )v1281_38.Text =string.format ( "%d Studs/s" ,v0_51.glideSpeed )v0_53(v0_51.glideSpeed )
    end
    )v1281_32( "Reset Character State" , "Clear velocity, cancel push & unfreeze" ,Color3.fromRGB ( 99 , 102 , 241 ), 42 ,function(...) pcall(v0_85)pcall(v0_61)
    end
    )v1281_32( "Unload Script" , "Destroy UI and stop all background loops" ,Color3.fromRGB ( 153 , 27 , 27 ), 43 ,function(...) v0_171()
    end
    )v1281_30( "EGG SELECT (ZONES & RARITIES)" , 45 )
    local v1281_41=Instance.new ( "TextButton" )v1281_41.Size =UDim2.new ( 1 , 0 , 0 , 48 )v1281_41.BackgroundColor3 =v1281_8 v1281_41.LayoutOrder = 46 v1281_41.Text = "" v1281_41.AutoButtonColor = false v1281_41.Parent =v1281_27;
    (Instance.new ( "UICorner" ,v1281_41)).CornerRadius =UDim.new ( 0 , 8 )
    local function v1281_42(...)
        local v1486_1= 0
        for v1487_1,v1487_2 in ipairs(v0_38)do
            if v0_51.selectedZones and v0_51.selectedZones [v1487_2]then
                v1486_1=v1486_1+ 1
            end
        end
        return v1486_1
    end
    local v1281_43=Instance.new ( "TextLabel" )v1281_43.Size =UDim2.new ( 1 , -50 , 0 , 18 )v1281_43.Position =UDim2.new ( 0 , 10 , 0 , 6 )v1281_43.BackgroundTransparency = 1 v1281_43.Text =string.format ( "📍 Target Zones (%d/12 Active)" ,v1281_42())v1281_43.TextColor3 =Color3.fromRGB ( 0 , 220 , 255 )v1281_43.TextSize = 13 v1281_43.Font =Enum.Font.GothamBold v1281_43.TextXAlignment =Enum.TextXAlignment.Left v1281_43.AutoLocalize = false v1281_43.Parent =v1281_41
    local v1281_44=Instance.new ( "TextLabel" )v1281_44.Size =UDim2.new ( 1 , -50 , 0 , 16 )v1281_44.Position =UDim2.new ( 0 , 10 , 0 , 26 )v1281_44.BackgroundTransparency = 1 v1281_44.Text = "Click to expand / collapse zone selection" v1281_44.TextColor3 =v1281_12 v1281_44.TextSize = 10 v1281_44.Font =Enum.Font.Gotham v1281_44.TextXAlignment =Enum.TextXAlignment.Left v1281_44.AutoLocalize = false v1281_44.Parent =v1281_41
    local v1281_45=Instance.new ( "TextLabel" )v1281_45.Size =UDim2.new ( 0 , 30 , 0 , 30 )v1281_45.Position =UDim2.new ( 1 , -38 , 0.5 , -15 )v1281_45.BackgroundTransparency = 1 v1281_45.Text = "▼" v1281_45.TextColor3 =v1281_12 v1281_45.TextSize = 12 v1281_45.Font =Enum.Font.GothamBold v1281_45.Parent =v1281_41
    local v1281_46=Instance.new ( "Frame" )v1281_46.Size =UDim2.new ( 1 , 0 , 0 , 0 )v1281_46.BackgroundColor3 =Color3.fromRGB ( 18 , 20 , 28 )v1281_46.LayoutOrder = 47 v1281_46.Visible = false v1281_46.ClipsDescendants = true v1281_46.Parent =v1281_27;
    (Instance.new ( "UICorner" ,v1281_46)).CornerRadius =UDim.new ( 0 , 8 )
    local v1281_47=Instance.new ( "UIGridLayout" )v1281_47.CellSize =UDim2.new ( 0.48 , 0 , 0 , 32 )v1281_47.CellPadding =UDim2.new ( 0.04 , 0 , 0 , 6 )v1281_47.SortOrder =Enum.SortOrder.LayoutOrder v1281_47.Parent =v1281_46;
    (Instance.new ( "UIPadding" ,v1281_46)).PaddingTop =UDim.new ( 0 , 8 )v1281_46.UIPadding.PaddingBottom =UDim.new ( 0 , 8 )v1281_46.UIPadding.PaddingLeft =UDim.new ( 0 , 8 )v1281_46.UIPadding.PaddingRight =UDim.new ( 0 , 8 )
    local v1281_48={}
    for v1489_1,v1489_2 in ipairs(v0_38)do
        local v1489_3=Instance.new ( "TextButton" )v1489_3.LayoutOrder =v1489_1 v1489_3.Font =Enum.Font.GothamBold v1489_3.TextSize = 11 v1489_3.AutoButtonColor = false v1489_3.AutoLocalize = false ;
        (Instance.new ( "UICorner" ,v1489_3)).CornerRadius =UDim.new ( 0 , 6 )
        local function v1489_4(...)
            local v1490_1=v0_51.selectedZones and v0_51.selectedZones [v1489_2]== true
            if v1490_1 then
                v1489_3.BackgroundColor3 =v0_47[v1489_2]or Color3.fromRGB ( 59 , 130 , 246 )v1489_3.TextColor3 =Color3.new ( 1 , 1 , 1 )v1489_3.Text = "✓ " ..v1489_2
            else
                v1489_3.BackgroundColor3 =Color3.fromRGB ( 28 , 32 , 44 )v1489_3.TextColor3 =Color3.fromRGB ( 140 , 150 , 170 )v1489_3.Text =v1489_2
            end
        end
        v1489_4()v1489_3.MouseButton1Click :Connect(function(...)
            if not v0_51.selectedZones then
                v0_51.selectedZones ={}
            end
            v0_51.selectedZones [v1489_2]=not((v0_51.selectedZones [v1489_2]== true ))v1489_4()v0_55()v1281_43.Text =string.format ( "📍 Target Zones (%d/12 Active)" ,v1281_42())
        end
        )v1489_3.Parent =v1281_46 v1281_48[v1489_2]=v1489_3
    end
    local v1281_49= false v1281_41.MouseButton1Click :Connect(function(...) v1281_49=not v1281_49 v1281_46.Visible =v1281_49 v1281_46.Size =v1281_49 and UDim2.new ( 1 , 0 , 0 , 240 )or UDim2.new ( 1 , 0 , 0 , 0 )v1281_45.Text =v1281_49 and "▲" or "▼"
    end
    )
    local function v1281_50(...)
        local v1496_1= 0
        for v1497_1,v1497_2 in ipairs(v0_48)do
            if v0_51.selectedRarities and v0_51.selectedRarities [v1497_2]then
                v1496_1=v1496_1+ 1
            end
        end
        return v1496_1
    end
    local v1281_51=Instance.new ( "TextButton" )v1281_51.Size =UDim2.new ( 1 , 0 , 0 , 48 )v1281_51.BackgroundColor3 =v1281_8 v1281_51.LayoutOrder = 48 v1281_51.Text = "" v1281_51.AutoButtonColor = false v1281_51.Parent =v1281_27;
    (Instance.new ( "UICorner" ,v1281_51)).CornerRadius =UDim.new ( 0 , 8 )
    local v1281_52=Instance.new ( "TextLabel" )v1281_52.Size =UDim2.new ( 1 , -50 , 0 , 18 )v1281_52.Position =UDim2.new ( 0 , 10 , 0 , 6 )v1281_52.BackgroundTransparency = 1 v1281_52.Text =string.format ( "🥚 Target Rarities (%d/%d Active)" ,v1281_50(),#v0_48)v1281_52.TextColor3 =Color3.fromRGB ( 255 , 180 , 0 )v1281_52.TextSize = 13 v1281_52.Font =Enum.Font.GothamBold v1281_52.TextXAlignment =Enum.TextXAlignment.Left v1281_52.AutoLocalize = false v1281_52.Parent =v1281_51
    local v1281_53=Instance.new ( "TextLabel" )v1281_53.Size =UDim2.new ( 1 , -50 , 0 , 16 )v1281_53.Position =UDim2.new ( 0 , 10 , 0 , 26 )v1281_53.BackgroundTransparency = 1 v1281_53.Text = "Click to expand / collapse rarity selection" v1281_53.TextColor3 =v1281_12 v1281_53.TextSize = 10 v1281_53.Font =Enum.Font.Gotham v1281_53.TextXAlignment =Enum.TextXAlignment.Left v1281_53.AutoLocalize = false v1281_53.Parent =v1281_51
    local v1281_54=Instance.new ( "TextLabel" )v1281_54.Size =UDim2.new ( 0 , 30 , 0 , 30 )v1281_54.Position =UDim2.new ( 1 , -38 , 0.5 , -15 )v1281_54.BackgroundTransparency = 1 v1281_54.Text = "▼" v1281_54.TextColor3 =v1281_12 v1281_54.TextSize = 12 v1281_54.Font =Enum.Font.GothamBold v1281_54.Parent =v1281_51
    local v1281_55=Instance.new ( "Frame" )v1281_55.Size =UDim2.new ( 1 , 0 , 0 , 0 )v1281_55.BackgroundColor3 =Color3.fromRGB ( 18 , 20 , 28 )v1281_55.LayoutOrder = 49 v1281_55.Visible = false v1281_55.ClipsDescendants = true v1281_55.Parent =v1281_27;
    (Instance.new ( "UICorner" ,v1281_55)).CornerRadius =UDim.new ( 0 , 8 )
    local v1281_56=Instance.new ( "UIGridLayout" )v1281_56.CellSize =UDim2.new ( 0.48 , 0 , 0 , 32 )v1281_56.CellPadding =UDim2.new ( 0.04 , 0 , 0 , 6 )v1281_56.SortOrder =Enum.SortOrder.LayoutOrder v1281_56.Parent =v1281_55;
    (Instance.new ( "UIPadding" ,v1281_55)).PaddingTop =UDim.new ( 0 , 8 )v1281_55.UIPadding.PaddingBottom =UDim.new ( 0 , 8 )v1281_55.UIPadding.PaddingLeft =UDim.new ( 0 , 8 )v1281_55.UIPadding.PaddingRight =UDim.new ( 0 , 8 )
    for v1499_1,v1499_2 in ipairs(v0_48)do
        local v1499_3=Instance.new ( "TextButton" )v1499_3.LayoutOrder =v1499_1 v1499_3.Font =Enum.Font.GothamBold v1499_3.TextSize = 11 v1499_3.AutoButtonColor = false v1499_3.AutoLocalize = false ;
        (Instance.new ( "UICorner" ,v1499_3)).CornerRadius =UDim.new ( 0 , 6 )
        local function v1499_4(...)
            local v1500_1=v0_51.selectedRarities and v0_51.selectedRarities [v1499_2]== true
            if v1500_1 then
                v1499_3.BackgroundColor3 =v0_49[v1499_2]or Color3.fromRGB ( 249 , 115 , 22 )v1499_3.TextColor3 =Color3.new ( 1 , 1 , 1 )v1499_3.Text = "✓ " ..v1499_2
            else
                v1499_3.BackgroundColor3 =Color3.fromRGB ( 28 , 32 , 44 )v1499_3.TextColor3 =Color3.fromRGB ( 140 , 150 , 170 )v1499_3.Text =v1499_2
            end
        end
        v1499_4()v1499_3.MouseButton1Click :Connect(function(...)
            if not v0_51.selectedRarities then
                v0_51.selectedRarities ={}
            end
            v0_51.selectedRarities [v1499_2]=not((v0_51.selectedRarities [v1499_2]== true ))v1499_4()v0_55()v1281_52.Text =string.format ( "🥚 Target Rarities (%d/%d Active)" ,v1281_50(),#v0_48)
        end
        )v1499_3.Parent =v1281_55
    end
    local v1281_57= false v1281_51.MouseButton1Click :Connect(function(...) v1281_57=not v1281_57 v1281_55.Visible =v1281_57 v1281_55.Size =v1281_57 and UDim2.new ( 1 , 0 , 0 , 160 )or UDim2.new ( 1 , 0 , 0 , 0 )v1281_54.Text =v1281_57 and "▲" or "▼"
    end
    )v1281_1(function(...) v1281_19.Visible = true
    end
    )
end
v0_16( "[+] Initializing Dice Hub x WindUI v42.64 (Steal an Egg Edition)..." )v0_172()task.spawn (function(...) task.wait ( 0.5 )v0_95()v0_94( true )v0_86()
    if v0_10.Character then
        v0_98(v0_10.Character )
    end
    v0_61()v0_16( "[+] Auto Humanoid Swap & Rigid Joint Locking Active." )
end
)v0_10.CharacterAdded :Connect(function(v1509_1,...) task.wait ( 0.6 )
    if v0_51.alive then
        v0_85()v0_88()v0_86()v0_95()v0_94( true )v0_98(v1509_1)v0_61()
    end
end
)
if v0_51.performanceMode then
    task.spawn (v0_144)
end
if v0_51.disable3D then
    pcall(function(...) v0_3:Set3dRenderingEnabled( false )
    end
    )
end
if v0_51.antiAFK then
    task.spawn (v0_148)
end
v0_16( "[+] Dice Hub v42.64 Ready! All-In-One Built-in Anti-AFK & Prometheus Ready!" )
