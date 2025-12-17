 -- Fishing Hack System for "Fish It!"
-- fishing_hack.lua - Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Create RemoteEvent if needed
if not ReplicatedStorage:FindFirstChild("FishingHack") then
    Instance.new("RemoteEvent", ReplicatedStorage).Name = "FishingHack"
end

local fishingRemote = ReplicatedStorage:WaitForChild("FishingHack")

-- Fishing hack data storage
local playerFishingHacks = {} -- [player] = {settings, connection}

-- Find fishing game components
local function findFishingGame()
    -- Look for fishing game modules/scripts
    local fishingModules = {}
    
    -- Check workspace for fishing spots
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("fish") or obj.Name:lower():find("pond") or obj.Name:lower():find("water") then
            table.insert(fishingModules, obj)
        end
    end
    
    -- Check for fishing tools
    for _, player in pairs(Players:GetPlayers()) do
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool.Name:lower():find("rod") or tool.Name:lower():find("fish") then
                    table.insert(fishingModules, tool)
                end
            end
        end
    end
    
    return fishingModules
end

-- Auto fishing system
local function startAutoFishing(player, settings)
    if playerFishingHacks[player] and playerFishingHacks[player].autoFishing then
        playerFishingHacks[player].autoFishing:Disconnect()
    end
    
    local connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not player or not player.Parent then
            if connection then connection:Disconnect() end
            return
        end
        
        -- Find fishing rod
        local character = player.Character
        if not character then return end
        
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
        
        if fishingRod and not character:FindFirstChild(fishingRod.Name) then
            -- Equip fishing rod
            fishingRod.Parent = character
        end
        
        -- Look for fish
        local fishFound = false
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("fish") and obj:IsA("BasePart") then
                local distance = (character:GetPivot().Position - obj.Position).Magnitude
                
                if settings.BlantantFish or distance < 50 then
                    fishFound = true
                    
                    -- Simulate fishing action
                    if settings.InstantFish then
                        -- Instant catch logic
                        task.spawn(function()
                            -- Fire fishing event
                            local args = {
                                fish = obj,
                                instant = true,
                                noAnimation = settings.NoAnimation
                            }
                            
                            -- Try to trigger fishing success
                            local fishingEvent = ReplicatedStorage:FindFirstChild("FishingEvent") or 
                                                workspace:FindFirstChild("FishingEvent") or
                                                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
                            
                            if fishingEvent then
                                pcall(function()
                                    fishingEvent:FireServer("CatchFish", args)
                                end)
                            end
                        end)
                    end
                    
                    break
                end
            end
        end
        
        if fishFound and settings.CatchDelay then
            task.wait(settings.CatchDelay)
        end
    end)
    
    if not playerFishingHacks[player] then
        playerFishingHacks[player] = {}
    end
    
    playerFishingHacks[player].autoFishing = connection
    playerFishingHacks[player].autoFishingEnabled = true
    
    print(player.Name .. " started auto fishing")
end

-- Stop auto fishing
local function stopAutoFishing(player)
    if playerFishingHacks[player] and playerFishingHacks[player].autoFishing then
        playerFishingHacks[player].autoFishing:Disconnect()
        playerFishingHacks[player].autoFishingEnabled = false
        print(player.Name .. " stopped auto fishing")
    end
end

-- Apply fishing hacks
local function applyFishingHacks(player, settings)
    -- Store settings
    if not playerFishingHacks[player] then
        playerFishingHacks[player] = {}
    end
    
    playerFishingHacks[player].settings = settings
    
    -- Apply auto fishing
    if settings.AutoFish then
        startAutoFishing(player, settings)
    else
        stopAutoFishing(player)
    end
    
    -- Apply instant fishing
    if settings.InstantFish then
        -- Hook into fishing mechanics
        task.spawn(function()
            -- Look for fishing modules to modify
            local fishingModules = findFishingGame()
            
            for _, module in pairs(fishingModules) do
                if module:IsA("ModuleScript") then
                    pcall(function()
                        local required = require(module)
                        if type(required) == "table" then
                            -- Try to modify fishing wait time
                            if required.WaitTime then
                                required.WaitTime = 0.1 -- Reduce wait time
                            end
                            
                            -- Try to modify catch chance
                            if required.CatchChance then
                                required.CatchChance = 100 -- 100% catch chance
                            end
                        end
                    end)
                end
            end
        end)
    end
    
    -- Apply no animation
    if settings.NoAnimation then
        -- Disable fishing animations
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                -- Clear animation tracks
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    if track.Name:lower():find("fish") then
                        track:Stop()
                    end
                end
            end
        end
    end
    
    print(player.Name .. " applied fishing hacks")
end

-- Handle fishing hack requests
fishingRemote.OnServerEvent:Connect(function(player, action, data)
    if action == "ToggleFeature" then
        local feature = data.Feature
        local enabled = data.Enabled
        local settings = data.Settings
        
        -- Update player settings
        if not playerFishingHacks[player] then
            playerFishingHacks[player] = {settings = {}}
        end
        
        playerFishingHacks[player].settings[feature] = enabled
        
        -- Apply all current settings
        if playerFishingHacks[player].settings then
            applyFishingHacks(player, playerFishingHacks[player].settings)
        end
        
        -- Notify player
        fishingRemote:FireClient(player, "FeatureToggled", {
            Feature = feature,
            Enabled = enabled,
            Message = feature .. " " .. (enabled and "enabled!" or "disabled")
        })
        
    elseif action == "UpdateSettings" then
        -- Update fishing settings
        if playerFishingHacks[player] then
            for setting, value in pairs(data.Settings) do
                playerFishingHacks[player].settings[setting] = value
            end
            applyFishingHacks(player, playerFishingHacks[player].settings)
        end
    end
end)

-- Clean up when player leaves
Players.PlayerRemoving:Connect(function(player)
    if playerFishingHacks[player] then
        stopAutoFishing(player)
        playerFishingHacks[player] = nil
    end
end)

-- Monitor fishing game
task.spawn(function()
    while true do
        task.wait(10)
        
        -- Detect fishing game changes
        for _, player in pairs(Players:GetPlayers()) do
            if playerFishingHacks[player] and playerFishingHacks[player].settings then
                if playerFishingHacks[player].settings.AutoFish then
                    -- Reapply auto fishing if needed
                    if not playerFishingHacks[player].autoFishingEnabled then
                        startAutoFishing(player, playerFishingHacks[player].settings)
                    end
                end
            end
        end
    end
end)

print("🎣 Fishing Hack System loaded!")
