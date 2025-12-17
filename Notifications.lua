 -- Fishing Game Injector for "Fish It!"
-- fishing_injector.lua - Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

-- Game ID for "Fish It!" (you may need to update this)
local FISH_IT_GAME_ID = 4525709961

-- Check if we're in the right game
local function isFishItGame()
    -- Multiple ways to check
    if game.PlaceId == FISH_IT_GAME_ID then
        return true
    end
    
    -- Check for fishing-related content
    local fishingIndicators = {
        "Fish", "Fishing", "Rod", "Pond", "Ocean", "Water",
        "Bait", "Hook", "Reel", "Catch", "Tackle"
    }
    
    for _, name in pairs(fishingIndicators) do
        if workspace:FindFirstChild(name) or 
           ReplicatedStorage:FindFirstChild(name) or
           game:GetService("StarterPack"):FindFirstChild(name) then
            return true
        end
    end
    
    return false
end

-- Find fishing game modules
local function findFishingModules()
    local modules = {}
    
    -- Check for common fishing module names
    local moduleNames = {
        "FishingModule",
        "FishSystem",
        "FishingSystem",
        "RodSystem",
        "CatchSystem",
        "FishingGame",
        "FishHandler"
    }
    
    for _, name in pairs(moduleNames) do
        local module = ReplicatedStorage:FindFirstChild(name) or
                      workspace:FindFirstChild(name) or
                      game:GetService("ServerScriptService"):FindFirstChild(name) or
                      game:GetService("ServerStorage"):FindFirstChild(name)
        
        if module and module:IsA("ModuleScript") then
            modules[name] = module
        end
    end
    
    return modules
end

-- Hook into fishing events
local function hookFishingEvents()
    local hookedEvents = {}
    
    -- Look for remote events related to fishing
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name:lower()
            if name:find("fish") or name:find("rod") or name:find("catch") then
                table.insert(hookedEvents, remote)
            end
        end
    end
    
    -- Hook into workspace events too
    for _, remote in pairs(workspace:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name:lower()
            if name:find("fish") or name:find("rod") or name:find("catch") then
                table.insert(hookedEvents, remote)
            end
        end
    end
    
    return hookedEvents
end

-- Modify fishing modules for hacks
local function modifyFishingModules(hackSettings)
    local modules = findFishingModules()
    
    for name, module in pairs(modules) do
        local success, originalModule = pcall(function()
            return require(module)
        end)
        
        if success and type(originalModule) == "table" then
            -- Create modified module
            local modifiedModule = setmetatable({}, {
                __index = originalModule,
                __newindex = function(self, key, value)
                    -- Apply hacks
                    if hackSettings.InstantFish then
                        if key == "WaitTime" or key == "CatchTime" then
                            value = 0.1 -- Instant catch
                        elseif key == "CatchChance" or key == "SuccessChance" then
                            value = 100 -- 100% success
                        end
                    end
                    
                    if hackSettings.NoAnimation then
                        if key == "AnimationTime" or key == "CastTime" or key == "ReelTime" then
                            value = 0 -- No animation time
                        end
                    end
                    
                    rawset(self, key, value)
                end
            })
            
            -- Apply modifications
            if hackSettings.InstantFish then
                modifiedModule.WaitTime = 0.1
                modifiedModule.CatchTime = 0.1
                modifiedModule.CatchChance = 100
                modifiedModule.SuccessChance = 100
            end
            
            if hackSettings.NoAnimation then
                modifiedModule.AnimationTime = 0
                modifiedModule.CastTime = 0
                modifiedModule.ReelTime = 0
            end
            
            if hackSettings.BlantantFish then
                modifiedModule.DistanceLimit = 9999
                modifiedModule.Range = 9999
            end
            
            -- Replace the module
            local function requireHook(moduleScript)
                if moduleScript == module then
                    return modifiedModule
                end
                return require(moduleScript)
            end
            
            -- Hook require function
            local originalRequire = require
            getfenv(0).require = function(moduleScript)
                if moduleScript == module then
                    return modifiedModule
                end
                return originalRequire(moduleScript)
            end
            
            print("✅ Modified fishing module:", name)
        end
    end
end

-- Auto detect and catch fish
local function setupAutoFishing(hackSettings)
    local autoFishConnection
    local lastCatchTime = 0
    
    if hackSettings.AutoFish then
        autoFishConnection = RunService.Heartbeat:Connect(function(deltaTime)
            local character = player.Character
            if not character then return end
            
            -- Look for fish in workspace
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("fish") and obj:IsA("BasePart") then
                    local distance = (character:GetPivot().Position - obj.Position).Magnitude
                    
                    -- Check if we can catch it (distance check or blatant)
                    if hackSettings.BlantantFish or distance < 50 then
                        -- Check catch delay
                        if tick() - lastCatchTime >= hackSettings.CatchDelay then
                            -- Try to catch the fish
                            local fishingRod
                            local backpack = player:FindFirstChild("Backpack")
                            if backpack then
                                for _, tool in pairs(backpack:GetChildren()) do
                                    if tool.Name:lower():find("rod") or tool.Name:lower():find("fish") then
                                        fishingRod = tool
                                        break
                                    end
                                end
                            end
                            
                            if fishingRod then
                                -- Equip rod if not equipped
                                if not character:FindFirstChild(fishingRod.Name) then
                                    fishingRod.Parent = character
                                    task.wait(0.1)
                                end
                                
                                -- Simulate fishing action
                                if hackSettings.InstantFish then
                                    -- Fire fishing event if found
                                    local fishingEvents = hookFishingEvents()
                                    
                                    for _, event in pairs(fishingEvents) do
                                        pcall(function()
                                            if event:IsA("RemoteEvent") then
                                                event:FireServer({
                                                    Action = "Catch",
                                                    Fish = obj,
                                                    Position = obj.Position,
                                                    Instant = true
                                                })
                                            elseif event:IsA("RemoteFunction") then
                                                event:InvokeServer({
                                                    Action = "Catch",
                                                    Fish = obj,
                                                    Position = obj.Position,
                                                    Instant = true
                                                })
                                            end
                                        end)
                                    end
                                end
                                
                                lastCatchTime = tick()
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
    
    return autoFishConnection
end

-- Main injection function
local function injectFishingHacks(hackSettings)
    if not isFishItGame() then
        warn("⚠️ Not in a fishing game!")
        return false
    end
    
    print("🎣 Injecting fishing hacks...")
    
    -- Modify fishing modules
    modifyFishingModules(hackSettings)
    
    -- Setup auto fishing
    local autoFishConnection = setupAutoFishing(hackSettings)
    
    -- Hook fishing events
    local hookedEvents = hookFishingEvents()
    print("✅ Hooked", #hookedEvents, "fishing events")
    
    -- Return cleanup function
    return function()
        if autoFishConnection then
            autoFishConnection:Disconnect()
        end
        print("🎣 Fishing hacks cleaned up")
    end
end

-- Listen for hack settings from UI
local fishingRemote = ReplicatedStorage:WaitForChild("FishingHack")
local currentCleanup

fishingRemote.OnClientEvent:Connect(function(action, data)
    if action == "FeatureToggled" then
        print("🎣", data.Message)
        
        -- Collect current settings
        local hackSettings = {
            AutoFish = false,
            BlantantFish = false,
            InstantFish = false,
            NoAnimation = false,
            CatchDelay = 0.5
        }
        
        -- Get settings from UI (you would need to communicate with UI script)
        -- For now, we'll use dummy settings
        
        -- Clean up old injection
        if currentCleanup then
            currentCleanup()
        end
        
        -- Inject new hacks
        currentCleanup = injectFishingHacks(hackSettings)
    end
end)

-- Auto-detect and inject on game load
task.wait(5) -- Wait for game to load

if isFishItGame() then
    print("🎣 Detected fishing game! Ready for hacks.")
    
    -- Initial injection with default settings
    local defaultSettings = {
        AutoFish = false,
        BlantantFish = false,
        InstantFish = false,
        NoAnimation = false,
        CatchDelay = 0.5
    }
    
    currentCleanup = injectFishingHacks(defaultSettings)
else
    print("⚠️ Not a fishing game. Hacks disabled.")
end

print("🎣 Fishing Hack Injector loaded!")
