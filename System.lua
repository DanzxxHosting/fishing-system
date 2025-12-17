-- 🎣 FISH IT! HACK INJECTOR - AGGRESSIVE VERSION
-- fishing_hack_injector.lua - Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local fishingRemote = ReplicatedStorage:WaitForChild("FishingHack")

-- Fishing settings from UI
local fishingSettings = {
    AutoFish = false,
    BlantantFish = false,
    InstantFish = false,
    NoAnimation = false,
    CatchDelay = 0.5
}

-- State variables
local isSystemActive = false
local originalFunctions = {}
local hookedRemotes = {}
local fishingModules = {}

-- AGGRESSIVE FISHING DETECTION
local function detectFishingGame()
    print("🔍 Mencari sistem fishing game...")
    
    local detectedSystems = {}
    
    -- 1. Cari semua ModuleScript yang berhubungan dengan fishing
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ModuleScript") then
            local name = obj.Name:lower()
            if name:find("fish") or name:find("rod") or name:find("catch") or 
               name:find("bait") or name:find("hook") or name:find("reel") then
                table.insert(detectedSystems, {type = "Module", obj = obj})
                print("📦 Found module:", obj:GetFullName())
            end
        end
        
        -- 2. Cari semua RemoteEvent/Function
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            if name:find("fish") or name:find("cast") or name:find("catch") or 
               name:find("reel") or name:find("rod") then
                table.insert(detectedSystems, {type = "Remote", obj = obj})
                print("📡 Found remote:", obj:GetFullName())
            end
        end
        
        -- 3. Cari semua Script fishing
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local name = obj.Name:lower()
            if name:find("fish") or name:find("rod") then
                table.insert(detectedSystems, {type = "Script", obj = obj})
                print("📝 Found script:", obj:GetFullName())
            end
        end
    end
    
    return detectedSystems
end

-- HOOK ALL FISHING MODULES AGGRESSIVELY
local function hookFishingModules()
    print("🎣 Meng-hook semua module fishing...")
    
    local allModules = {}
    
    -- Collect all modules
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ModuleScript") then
            local success, module = pcall(function()
                return require(obj)
            end)
            
            if success and type(module) == "table" then
                allModules[obj] = module
                
                -- Check if this is a fishing module
                local hasFishingFunctions = false
                for key, value in pairs(module) do
                    if type(key) == "string" then
                        if key:lower():find("fish") or key:lower():find("catch") or 
                           key:lower():find("cast") or key:lower():find("reel") then
                            hasFishingFunctions = true
                            break
                        end
                    end
                end
                
                if hasFishingFunctions then
                    fishingModules[obj] = module
                    print("✅ Fishing module found:", obj.Name)
                end
            end
        end
    end
    
    return fishingModules
end

-- MODIFY FISHING MODULE VALUES
local function modifyFishingModules()
    print("⚡ Memodifikasi fishing modules...")
    
    for moduleScript, module in pairs(fishingModules) do
        print("🔧 Modifying module:", moduleScript.Name)
        
        -- Save original module
        originalFunctions[moduleScript] = table.clone(module)
        
        -- Apply Instant Fishing modifications
        if fishingSettings.InstantFish then
            if module.CatchTime then module.CatchTime = 0.1 end
            if module.WaitTime then module.WaitTime = 0.1 end
            if module.CastTime then module.CastTime = 0.1 end
            if module.ReelTime then module.ReelTime = 0.1 end
            if module.Delay then module.Delay = 0.1 end
            
            -- Set success rates to 100%
            if module.SuccessRate then module.SuccessRate = 100 end
            if module.CatchChance then module.CatchChance = 100 end
            if module.SuccessChance then module.SuccessChance = 100 end
            
            print("🚀 Applied Instant Fishing to module")
        end
        
        -- Apply Blatant Fishing modifications
        if fishingSettings.BlantantFish then
            if module.MaxDistance then module.MaxDistance = 9999 end
            if module.Range then module.Range = 9999 end
            if module.Distance then module.Distance = 9999 end
            if module.LineLength then module.LineLength = 9999 end
            
            print("⚡ Applied Blatant Fishing to module")
        end
        
        -- Create new require hook
        local originalRequire = require
        local function newRequire(script)
            if script == moduleScript then
                return module
            end
            return originalRequire(script)
        end
        
        -- Replace require function
        getfenv(0).require = newRequire
        
        print("✅ Module modified successfully:", moduleScript.Name)
    end
end

-- HOOK ALL FISHING REMOTES AGGRESSIVELY
local function hookAllFishingRemotes()
    print("🔗 Meng-hook semua remote fishing...")
    
    local remotesFound = 0
    
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local remoteName = remote.Name:lower()
            
            -- Hook jika namanya berhubungan dengan fishing
            if remoteName:find("fish") or remoteName:find("cast") or 
               remoteName:find("catch") or remoteName:find("reel") or
               remoteName:find("rod") or remoteName:find("bait") then
                
                remotesFound = remotesFound + 1
                
                if remote:IsA("RemoteEvent") then
                    -- Hook RemoteEvent
                    local originalFire = remote.FireServer
                    remote.FireServer = function(self, ...)
                        local args = {...}
                        local eventName = tostring(args[1] or "")
                        
                        print("🎣 Fishing Event Fired:", eventName)
                        
                        -- Apply Instant Fishing
                        if fishingSettings.InstantFish then
                            if eventName:lower():find("fish") or eventName:lower():find("catch") then
                                print("🚀 Instant Fishing applied to event")
                                -- Modify wait times in arguments
                                for i, arg in ipairs(args) do
                                    if type(arg) == "table" then
                                        arg.waitTime = 0.1
                                        arg.WaitTime = 0.1
                                        arg.delay = 0.1
                                        arg.Delay = 0.1
                                    end
                                end
                            end
                        end
                        
                        return originalFire(self, unpack(args))
                    end
                    
                elseif remote:IsA("RemoteFunction") then
                    -- Hook RemoteFunction
                    local originalInvoke = remote.InvokeServer
                    remote.InvokeServer = function(self, ...)
                        local args = {...}
                        local eventName = tostring(args[1] or "")
                        
                        print("🎣 Fishing Function Invoked:", eventName)
                        
                        -- Apply Instant Fishing
                        if fishingSettings.InstantFish then
                            if eventName:lower():find("fish") or eventName:lower():find("catch") then
                                print("🚀 Instant Fishing applied to function")
                                -- Modify wait times in arguments
                                for i, arg in ipairs(args) do
                                    if type(arg) == "table" then
                                        arg.waitTime = 0.1
                                        arg.WaitTime = 0.1
                                        arg.delay = 0.1
                                        arg.Delay = 0.1
                                    end
                                end
                            end
                        end
                        
                        return originalInvoke(self, unpack(args))
                    end
                end
                
                hookedRemotes[remote] = true
                print("✅ Hooked remote:", remote:GetFullName())
            end
        end
    end
    
    print("📊 Total remotes hooked:", remotesFound)
    return remotesFound > 0
end

-- AUTO FISHING SYSTEM
local autoFishingConnection = nil
local lastCatchTime = 0

local function startAutoFishing()
    if autoFishingConnection then
        autoFishingConnection:Disconnect()
        autoFishingConnection = nil
    end
    
    if not fishingSettings.AutoFish then
        print("🤖 Auto Fishing: OFF")
        return
    end
    
    print("🤖 Auto Fishing: ON")
    
    autoFishingConnection = RunService.Heartbeat:Connect(function(deltaTime)
        -- Check catch delay
        if tick() - lastCatchTime < fishingSettings.CatchDelay then
            return
        end
        
        -- Find fishing rod in character
        local character = player.Character
        if not character then return end
        
        local fishingRod = nil
        
        -- Check equipped tools
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("rod") or name:find("fish") or name:find("pancing") then
                    fishingRod = tool
                    break
                end
            end
        end
        
        -- Check backpack if not equipped
        if not fishingRod then
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        local name = tool.Name:lower()
                        if name:find("rod") or name:find("fish") or name:find("pancing") then
                            fishingRod = tool
                            -- Auto equip
                            tool.Parent = character
                            task.wait(0.5)
                            break
                        end
                    end
                end
            end
        end
        
        if not fishingRod then
            print("❌ No fishing rod found")
            return
        end
        
        -- AGGRESSIVE FISH FINDING
        local fishFound = false
        
        -- Method 1: Look for fish parts
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                local name = obj.Name:lower()
                
                if name:find("fish") or name:find("ikan") or 
                   name:find("salmon") or name:find("tuna") or
                   name:find("trout") or name:find("bass") or
                   name:find("cod") or name:find("mackerel") then
                    
                    fishFound = true
                    
                    -- Check if we can catch it
                    local canCatch = false
                    if fishingSettings.BlantantFish then
                        canCatch = true
                    else
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local distance = (humanoidRootPart.Position - obj.Position).Magnitude
                            if distance < 50 then
                                canCatch = true
                            end
                        end
                    end
                    
                    if canCatch then
                        -- Try to fire all fishing remotes
                        for remote, _ in pairs(hookedRemotes) do
                            pcall(function()
                                if remote:IsA("RemoteEvent") then
                                    remote:FireServer("CatchFish", {
                                        Fish = obj,
                                        Position = obj.Position,
                                        Instant = fishingSettings.InstantFish
                                    })
                                    print("🎣 Attempted catch via:", remote.Name)
                                elseif remote:IsA("RemoteFunction") then
                                    remote:InvokeServer("CatchFish", {
                                        Fish = obj,
                                        Position = obj.Position,
                                        Instant = fishingSettings.InstantFish
                                    })
                                    print("🎣 Attempted catch via:", remote.Name)
                                end
                            end)
                        end
                        
                        -- Also try common fishing events
                        local commonEvents = {
                            "FishCaught", "CatchFish", "ReelFish", "CastLine",
                            "StartFishing", "FishBite", "PullFish"
                        }
                        
                        for _, eventName in pairs(commonEvents) do
                            pcall(function()
                                -- Fire to all hooked remotes
                                for remote, _ in pairs(hookedRemotes) do
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer(eventName, {
                                            Target = obj,
                                            Location = obj.Position
                                        })
                                    end
                                end
                            end)
                        end
                        
                        lastCatchTime = tick()
                        print("✅ Fish caught:", obj.Name)
                        break
                    end
                end
            end
        end
        
        -- Method 2: Look for fishing zones/areas
        if not fishFound then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:lower():find("pond") or obj.Name:lower():find("lake") or
                   obj.Name:lower():find("river") or obj.Name:lower():find("ocean") or
                   obj.Name:lower():find("water") then
                    
                    -- Cast fishing line into water
                    for remote, _ in pairs(hookedRemotes) do
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer("CastLine", {
                                    Location = obj.Position,
                                    Instant = true
                                })
                                print("🎣 Casting line into:", obj.Name)
                            end
                        end)
                    end
                    
                    lastCatchTime = tick()
                    break
                end
            end
        end
    end)
end

-- NO ANIMATION SYSTEM
local function applyNoAnimation()
    if not fishingSettings.NoAnimation then
        print("🎬 No Animation: OFF")
        return
    end
    
    print("🎬 No Animation: ON - Pancingan diam tapi jalan")
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        -- Stop all animations
        for _, animTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
            animTrack:Stop()
        end
    end
    
    -- Also look for fishing rod animations
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, descendant in pairs(tool:GetDescendants()) do
                if descendant:IsA("Animation") then
                    local animator = descendant:FindFirstAncestorOfClass("Animator")
                    if animator then
                        for _, animTrack in pairs(animator:GetPlayingAnimationTracks()) do
                            animTrack:Stop()
                        end
                    end
                end
            end
        end
    end
end

-- MAIN SYSTEM UPDATE
local function updateFishingSystem()
    print("🔄 Updating fishing system...")
    
    -- Detect fishing game
    local detectedSystems = detectFishingGame()
    if #detectedSystems == 0 then
        print("⚠️ No fishing systems detected! Using aggressive mode")
    else
        print("✅ Found", #detectedSystems, "fishing systems")
    end
    
    -- Hook modules
    hookFishingModules()
    modifyFishingModules()
    
    -- Hook remotes
    local hasRemotes = hookAllFishingRemotes()
    
    -- Start/Stop auto fishing
    if fishingSettings.AutoFish then
        startAutoFishing()
    elseif autoFishingConnection then
        autoFishingConnection:Disconnect()
        autoFishingConnection = nil
    end
    
    -- Apply no animation
    applyNoAnimation()
    
    -- Apply instant fishing globally
    if fishingSettings.InstantFish then
        print("🚀 Instant Fishing aktif - Semua delay diubah ke 0.1s")
        
        -- Global wait time modification
        local originalWait = task.wait
        task.wait = function(seconds)
            if seconds and seconds > 0.1 then
                seconds = 0.1
            end
            return originalWait(seconds)
        end
    end
    
    isSystemActive = true
    print("✅ Fishing hack system aktif!")
end

-- Listen for settings from UI
fishingRemote.OnClientEvent:Connect(function(action, data)
    if action == "FeatureToggled" then
        -- Update settings
        local featureName = data.Feature
        local enabled = data.Enabled
        
        if featureName == "AUTO FISHING" then
            fishingSettings.AutoFish = enabled
            print("🤖 Auto Fishing:", enabled and "ON" or "OFF")
        elseif featureName == "BLATANT FISHING" then
            fishingSettings.BlantantFish = enabled
            print("⚡ Blatant Fishing:", enabled and "ON" or "OFF")
        elseif featureName == "INSTANT FISHING" then
            fishingSettings.InstantFish = enabled
            print("🚀 Instant Fishing:", enabled and "ON" or "OFF")
        elseif featureName == "NO ANIMATION" then
            fishingSettings.NoAnimation = enabled
            print("🎬 No Animation:", enabled and "ON" or "OFF")
        end
        
        -- Update system
        updateFishingSystem()
        
    elseif action == "UpdateSettings" then
        if data.CatchDelay then
            fishingSettings.CatchDelay = data.CatchDelay
            print("⏱️ Catch delay updated:", fishingSettings.CatchDelay)
        end
    end
end)

-- Auto-detect and inject on game load
task.wait(3) -- Wait for game to fully load

print("🎣 Fish It! Hack Injector dimuat!")
print("🔧 Meng-inject fishing hacks...")

-- Initial detection and injection
updateFishingSystem()

-- Monitor for new fishing systems
task.spawn(function()
    while true do
        task.wait(10)
        
        if isSystemActive then
            -- Check if we need to re-hook new systems
            local newRemotes = 0
            for _, remote in pairs(game:GetDescendants()) do
                if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and not hookedRemotes[remote] then
                    local name = remote.Name:lower()
                    if name:find("fish") or name:find("cast") or name:find("catch") then
                        hookAllFishingRemotes()
                        print("🔄 Re-hooked new fishing remotes")
                        break
                    end
                end
            end
            
            -- Re-apply no animation
            if fishingSettings.NoAnimation then
                applyNoAnimation()
            end
        end
    end
end)

print("✅ System ready! Waiting for UI commands...")
