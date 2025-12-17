-- 🎣 FISH IT! HACK SYSTEM - Client Side
-- fishing_hack_system.lua - Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local fishingRemote = ReplicatedStorage:WaitForChild("FishingHack")

-- Fishing hack settings
local fishingSettings = {
    AutoFish = false,
    BlantantFish = false,
    InstantFish = false,
    NoAnimation = false,
    CatchDelay = 0.5
}

-- State variables
local isFishingActive = false
local autoFishingConnection = nil
local lastCatchTime = 0
local originalAnimations = {}

-- Find fishing tools
local function findFishingRod()
    local character = player.Character
    if not character then return nil end
    
    -- Check equipped tool
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("rod") or name:find("fish") or name:find("pancing") then
                return tool
            end
        end
    end
    
    -- Check backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("rod") or name:find("fish") or name:find("pancing") then
                    return tool
                end
            end
        end
    end
    
    return nil
end

-- Find fish in workspace
local function findFish()
    local fishList = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local name = obj.Name:lower()
            if name:find("fish") or name:find("ikan") or 
               name:find("salmon") or name:find("tuna") or
               name:find("cod") or name:find("bass") then
                table.insert(fishList, obj)
            end
        end
    end
    
    return fishList
end

-- Hook into fishing events
local function hookFishingEvents()
    -- Look for fishing remote events
    local fishingRemotes = {}
    
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name:lower()
            if name:find("fish") or name:find("cast") or name:find("catch") or name:find("reel") then
                table.insert(fishingRemotes, remote)
            end
        end
    end
    
    return fishingRemotes
end

-- No Animation Feature: Pancingan diam tapi jalan
local function applyNoAnimation()
    if not fishingSettings.NoAnimation then
        -- Restore original animations if they were saved
        for animTrack, originalSpeed in pairs(originalAnimations) do
            if animTrack and animTrack.Parent then
                animTrack:AdjustSpeed(originalSpeed)
            end
        end
        originalAnimations = {}
        return
    end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Stop all fishing animations
    for _, animTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
        if animTrack.Name:lower():find("fish") or 
           animTrack.Name:lower():find("cast") or 
           animTrack.Name:lower():find("reel") then
            -- Save original speed
            if not originalAnimations[animTrack] then
                originalAnimations[animTrack] = animTrack.Speed
            end
            -- Set speed to 0 (diam)
            animTrack:AdjustSpeed(0)
        end
    end
    
    -- Also try to find and stop tool animations
    local fishingRod = findFishingRod()
    if fishingRod then
        for _, animator in pairs(fishingRod:GetDescendants()) do
            if animator:IsA("Animator") then
                for _, animTrack in pairs(animator:GetPlayingAnimationTracks()) do
                    if animTrack.Name:lower():find("fish") then
                        if not originalAnimations[animTrack] then
                            originalAnimations[animTrack] = animTrack.Speed
                        end
                        animTrack:AdjustSpeed(0)
                    end
                end
            end
        end
    end
end

-- Instant Fishing Feature
local function applyInstantFishing(fishingRemotes)
    if not fishingSettings.InstantFish then return end
    
    for _, remote in pairs(fishingRemotes) do
        if remote:IsA("RemoteEvent") then
            -- Hook the remote event to modify timing
            local originalFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                
                -- Check if this is a fishing-related event
                local eventName = tostring(args[1] or "")
                local isFishingEvent = eventName:lower():find("fish") or 
                                      eventName:lower():find("cast") or 
                                      eventName:lower():find("catch")
                
                if isFishingEvent then
                    -- Modify wait times if they exist in the arguments
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            if arg.waitTime or arg.WaitTime then
                                arg.waitTime = 0.1
                                arg.WaitTime = 0.1
                            end
                            if arg.delay or arg.Delay then
                                arg.delay = 0.1
                                arg.Delay = 0.1
                            end
                        end
                    end
                end
                
                return originalFireServer(self, unpack(args))
            end
        end
    end
end

-- Blatant Fishing Feature: Tangkap melalui rintangan
local function canCatchFish(fishPart)
    if not fishPart then return false end
    
    if fishingSettings.BlantantFish then
        return true -- Bisa tangkap melalui apapun
    end
    
    -- Normal fishing: Check distance and line of sight
    local character = player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local distance = (humanoidRootPart.Position - fishPart.Position).Magnitude
    
    -- Max distance for normal fishing
    if distance > 50 then
        return false
    end
    
    -- Check line of sight (simple raycast)
    local rayOrigin = humanoidRootPart.Position
    local rayDirection = (fishPart.Position - rayOrigin).Unit
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character, fishPart}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local rayResult = Workspace:Raycast(rayOrigin, rayDirection * distance, raycastParams)
    
    if rayResult then
        -- Something is blocking the line of sight
        return false
    end
    
    return true
end

-- Auto Fishing Feature
local function startAutoFishing()
    if autoFishingConnection then
        autoFishingConnection:Disconnect()
        autoFishingConnection = nil
    end
    
    if not fishingSettings.AutoFish then return end
    
    autoFishingConnection = RunService.Heartbeat:Connect(function(deltaTime)
        -- Check cooldown
        if tick() - lastCatchTime < fishingSettings.CatchDelay then
            return
        end
        
        -- Find fishing rod
        local fishingRod = findFishingRod()
        if not fishingRod then return end
        
        -- Find fish
        local fishList = findFish()
        if #fishList == 0 then return end
        
        -- Find closest fish that can be caught
        local character = player.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local closestFish = nil
        local closestDistance = math.huge
        
        for _, fish in pairs(fishList) do
            if canCatchFish(fish) then
                local distance = (humanoidRootPart.Position - fish.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestFish = fish
                end
            end
        end
        
        if closestFish then
            -- Try to catch the fish
            local fishingRemotes = hookFishingEvents()
            
            for _, remote in pairs(fishingRemotes) do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer("CatchFish", {
                            fish = closestFish,
                            position = closestFish.Position,
                            instant = fishingSettings.InstantFish
                        })
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer("CatchFish", {
                            fish = closestFish,
                            position = closestFish.Position,
                            instant = fishingSettings.InstantFish
                        })
                    end
                end)
            end
            
            lastCatchTime = tick()
            
            -- Apply no animation if enabled
            if fishingSettings.NoAnimation then
                applyNoAnimation()
            end
        end
    end)
end

-- Main system update
local function updateFishingSystem()
    -- Start/stop auto fishing
    if fishingSettings.AutoFish and not autoFishingConnection then
        startAutoFishing()
    elseif not fishingSettings.AutoFish and autoFishingConnection then
        autoFishingConnection:Disconnect()
        autoFishingConnection = nil
    end
    
    -- Apply no animation
    applyNoAnimation()
    
    -- Apply instant fishing
    if fishingSettings.InstantFish then
        local fishingRemotes = hookFishingEvents()
        applyInstantFishing(fishingRemotes)
    end
end

-- Listen for settings updates from UI
fishingRemote.OnClientEvent:Connect(function(action, data)
    if action == "FeatureToggled" then
        -- Update specific feature
        local featureName = data.Feature
        local enabled = data.Enabled
        
        if featureName == "AUTO FISHING" then
            fishingSettings.AutoFish = enabled
        elseif featureName == "BLATANT FISHING" then
            fishingSettings.BlantantFish = enabled
        elseif featureName == "INSTANT FISHING" then
            fishingSettings.InstantFish = enabled
        elseif featureName == "NO ANIMATION" then
            fishingSettings.NoAnimation = enabled
        end
        
        -- Update all settings if provided
        if data.Settings then
            for setting, value in pairs(data.Settings) do
                fishingSettings[setting] = value
            end
        end
        
        -- Update the fishing system
        updateFishingSystem()
        
        print("🎣 " .. featureName .. " " .. (enabled and "diaktifkan" or "dinonaktifkan"))
        
    elseif action == "UpdateSettings" then
        -- Update catch delay
        if data.CatchDelay then
            fishingSettings.CatchDelay = data.CatchDelay
        end
    end
end)

-- Monitor character changes
player.CharacterAdded:Connect(function(character)
    task.wait(1) -- Wait for character to load
    
    -- Reapply no animation if enabled
    if fishingSettings.NoAnimation then
        applyNoAnimation()
    end
end)

-- Start monitoring for fishing tools
local function monitorFishingTools()
    while true do
        task.wait(2)
        
        -- Check if we have a fishing rod
        local fishingRod = findFishingRod()
        if fishingRod then
            -- Apply no animation to the rod if enabled
            if fishingSettings.NoAnimation then
                applyNoAnimation()
            end
        end
    end
end

-- Start the system
task.spawn(monitorFishingTools)
updateFishingSystem()

print("🎣 Fishing Hack System dimuat!")
print("🤖 Auto Fishing: " .. tostring(fishingSettings.AutoFish))
print("⚡ Blatant Fishing: " .. tostring(fishingSettings.BlantantFish))
print("🚀 Instant Fishing: " .. tostring(fishingSettings.InstantFish))
print("🎬 No Animation: " .. tostring(fishingSettings.NoAnimation))
print("⏱️ Catch Delay: " .. fishingSettings.CatchDelay .. "s")
