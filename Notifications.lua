-- 🎣 FISH IT! HACK SERVER HANDLER
-- fishing_hack_server.lua - Place in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent if needed
if not ReplicatedStorage:FindFirstChild("FishingHack") then
    Instance.new("RemoteEvent", ReplicatedStorage).Name = "FishingHack"
end

local fishingRemote = ReplicatedStorage:WaitForChild("FishingHack")

-- Player settings storage
local playerSettings = {}

-- Handle fishing hack requests
fishingRemote.OnServerEvent:Connect(function(player, action, data)
    if action == "ToggleFeature" then
        -- Initialize player settings if not exists
        if not playerSettings[player] then
            playerSettings[player] = {
                AutoFish = false,
                BlantantFish = false,
                InstantFish = false,
                NoAnimation = false,
                CatchDelay = 0.5
            }
        end
        
        -- Update feature
        local featureName = data.Feature
        local enabled = data.Enabled
        
        if featureName == "AUTO FISHING" then
            playerSettings[player].AutoFish = enabled
        elseif featureName == "BLATANT FISHING" then
            playerSettings[player].BlantantFish = enabled
        elseif featureName == "INSTANT FISHING" then
            playerSettings[player].InstantFish = enabled
        elseif featureName == "NO ANIMATION" then
            playerSettings[player].NoAnimation = enabled
        end
        
        -- Update all settings if provided
        if data.Settings then
            for setting, value in pairs(data.Settings) do
                playerSettings[player][setting] = value
            end
        end
        
        -- Confirm to client
        fishingRemote:FireClient(player, "FeatureToggled", {
            Feature = featureName,
            Enabled = enabled,
            Message = featureName .. " " .. (enabled and "diaktifkan!" or "dinonaktifkan"),
            Settings = playerSettings[player]
        })
        
        print(player.Name .. " mengaktifkan " .. featureName .. ": " .. tostring(enabled))
        
    elseif action == "UpdateSettings" then
        -- Update settings
        if playerSettings[player] then
            for setting, value in pairs(data) do
                playerSettings[player][setting] = value
            end
            
            -- Send confirmation
            fishingRemote:FireClient(player, "UpdateSettings", {
                CatchDelay = playerSettings[player].CatchDelay
            })
        end
    end
end)

-- Clean up when player leaves
Players.PlayerRemoving:Connect(function(player)
    playerSettings[player] = nil
end)

-- Monitor fishing activities (optional anti-cheat bypass)
local function monitorFishing()
    while true do
        task.wait(5)
        
        for _, player in pairs(Players:GetPlayers()) do
            local settings = playerSettings[player]
            if settings then
                -- Log fishing activities
                if settings.AutoFish then
                    -- Player is auto fishing
                    print(player.Name .. " sedang auto fishing...")
                end
                
                if settings.BlantantFish then
                    -- Player can fish through walls
                    print(player.Name .. " menggunakan blatant fishing")
                end
            end
        end
    end
end

task.spawn(monitorFishing)

print("🎣 Fishing Hack Server System dimuat!")
print("👥 Total players: " .. #Players:GetPlayers())
