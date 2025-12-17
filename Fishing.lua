-- FishingSystem.Fishing.lua
local FishingSystem = {}
FishingSystem.__index = FishingSystem

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
Player.CharacterAdded:Connect(function(char)
    Character = char
end)

-- Configuration
local Config = {
    AutoFishing = false,
    InstantFishing = false,
    BlatantFishing = false,
    AutoSell = false,
    AutoBait = false,
    CatchSpeed = 1,
    RadarEnabled = false,
    NoAnimation = false,
    AutoQuest = false
}

-- Fishing Variables
local FishingThread = nil
local CurrentRod = nil
local FishCaught = 0
local TotalWeight = 0
local BiggestFish = {Name = "None", Weight = 0}

-- Find Remotes
local function FindRemotes()
    local remotes = {
        Cast = nil,
        Reel = nil,
        Equip = nil,
        Sell = nil,
        Buy = nil,
        Quest = nil
    }
    
    -- Search for fishing remotes
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            
            if name:find("cast") or name:find("fish") then
                remotes.Cast = obj
            elseif name:find("reel") or name:find("catch") then
                remotes.Reel = obj
            elseif name:find("equip") or name:find("rod") then
                remotes.Equip = obj
            elseif name:find("sell") then
                remotes.Sell = obj
            elseif name:find("buy") or name:find("shop") then
                remotes.Buy = obj
            elseif name:find("quest") or name:find("mission") then
                remotes.Quest = obj
            end
        end
    end
    
    return remotes
end

local Remotes = FindRemotes()

-- Fishing Functions
function FishingSystem:GetBestRod()
    -- Find the best rod in player's inventory
    local bestRod = "BasicRod"
    local rodValue = 0
    
    -- Check backpack
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:find("Rod") or item.Name:find("rod") then
                -- Simulate rod value calculation
                local value = 0
                if item.Name:find("Legendary") then value = 100
                elseif item.Name:find("Epic") then value = 75
                elseif item.Name:find("Rare") then value = 50
                elseif item.Name:find("Advanced") then value = 25
                else value = 10 end
                
                if value > rodValue then
                    rodValue = value
                    bestRod = item.Name
                end
            end
        end
    end
    
    return bestRod
end

function FishingSystem:EquipBestRod()
    local bestRod = self:GetBestRod()
    
    if Remotes.Equip then
        Remotes.Equip:FireServer(bestRod)
        CurrentRod = bestRod
        return true
    end
    
    return false
end

function FishingSystem:FindFishingSpot()
    -- Look for water or fishing spots
    local bestSpot = Character.HumanoidRootPart.Position
    
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("Part") then
            if part.Name:find("Water") or part.Name:find("Lake") or part.Name:find("River") then
                if part.Material == Enum.Material.Water or part.Color.B > 0.7 then
                    -- Find surface position
                    local surfacePos = part.Position + Vector3.new(0, part.Size.Y/2, 0)
                    if (surfacePos - Character.HumanoidRootPart.Position).Magnitude < 100 then
                        bestSpot = surfacePos
                        break
                    end
                end
            end
        end
    end
    
    return bestSpot
end

function FishingSystem:CastRod()
    if not Remotes.Cast then return false end
    
    local spot = self:FindFishingSpot()
    local success = pcall(function()
        Remotes.Cast:FireServer(spot)
    end)
    
    return success
end

function FishingSystem:ReelIn()
    if not Remotes.Reel then return false end
    
    local success = pcall(function()
        Remotes.Reel:FireServer()
    end)
    
    return success
end

-- Auto Fishing System
function FishingSystem:StartAutoFishing()
    if FishingThread then
        coroutine.close(FishingThread)
    end
    
    FishingThread = coroutine.create(function()
        while Config.AutoFishing do
            -- Equip rod
            self:EquipBestRod()
            wait(0.5)
            
            -- Cast
            self:CastRod()
            wait(Config.InstantFishing and 0.1 or math.random(2, 5))
            
            -- Reel
            self:ReelIn()
            
            -- Update stats
            FishCaught = FishCaught + 1
            local fishWeight = math.random(10, 1000) / 100
            TotalWeight = TotalWeight + fishWeight
            
            if fishWeight > BiggestFish.Weight then
                BiggestFish = {Name = "Fish", Weight = fishWeight}
            end
            
            -- Auto sell if enabled
            if Config.AutoSell and Remotes.Sell then
                wait(0.5)
                Remotes.Sell:FireServer("All")
            end
            
            -- Wait before next cast
            local waitTime = Config.BlatantFishing and 0.1 or 
                            Config.InstantFishing and 0.5 or 
                            math.random(3, 7) / Config.CatchSpeed
            
            wait(waitTime)
        end
    end)
    
    coroutine.resume(FishingThread)
end

function FishingSystem:StopAutoFishing()
    if FishingThread then
        coroutine.close(FishingThread)
        FishingThread = nil
    end
end

-- Configuration Setters
function FishingSystem.ToggleAutoFishing(enable)
    Config.AutoFishing = enable
    
    if enable then
        FishingSystem:StartAutoFishing()
    else
        FishingSystem:StopAutoFishing()
    end
end

function FishingSystem.SetInstantFishing(enable)
    Config.InstantFishing = enable
end

function FishingSystem.SetBlatantFishing(enable)
    Config.BlatantFishing = enable
end

function FishingSystem.ToggleAutoSell(enable)
    Config.AutoSell = enable
end

function FishingSystem.ToggleAutoBait(enable)
    Config.AutoBait = enable
end

function FishingSystem.SetCatchSpeed(speed)
    Config.CatchSpeed = speed
end

function FishingSystem.ToggleRadar(enable)
    Config.RadarEnabled = enable
    
    if enable then
        -- Create fishing radar
        local radarPart = Instance.new("Part")
        radarPart.Name = "FishingRadar"
        radarPart.Size = Vector3.new(50, 1, 50)
        radarPart.Position = Character.HumanoidRootPart.Position
        radarPart.Transparency = 0.7
        radarPart.Color = Color3.fromRGB(0, 255, 255)
        radarPart.Anchored = true
        radarPart.CanCollide = false
        radarPart.Parent = Workspace
        
        -- Make radar follow player
        RunService.Heartbeat:Connect(function()
            if radarPart and Config.RadarEnabled then
                radarPart.Position = Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
            elseif radarPart then
                radarPart:Destroy()
            end
        end)
    end
end

function FishingSystem.ToggleFishingAnimation(enable)
    Config.NoAnimation = not enable
end

function FishingSystem.ToggleAutoQuest(enable)
    Config.AutoQuest = enable
    
    if enable and Remotes.Quest then
        -- Auto claim quests
        while Config.AutoQuest do
            Remotes.Quest:FireServer("ClaimAll")
            wait(10) -- Check every 10 seconds
        end
    end
end

function FishingSystem.InstantCast()
    if Remotes.Cast then
        Remotes.Cast:FireServer(Character.HumanoidRootPart.Position)
    end
end

function FishingSystem.GetStats()
    -- This would normally fetch from game
    return {
        TotalFish = FishCaught,
        TotalWeight = TotalWeight,
        BiggestFish = BiggestFish.Name .. " (" .. BiggestFish.Weight .. "kg)",
        Coins = 0, -- Would fetch from game
        Level = 1   -- Would fetch from game
    }
end

-- Initialize
function FishingSystem.Init()
    print("🎣 Fishing System Initialized")
    
    -- Auto reconnect if character dies
    Character = Player.Character or Player.CharacterAdded:Wait()
    Player.CharacterAdded:Connect(function(char)
        Character = char
        if Config.AutoFishing then
            wait(3)
            FishingSystem:StartAutoFishing()
        end
    end)
    
    return FishingSystem
end

return FishingSystem.Init()