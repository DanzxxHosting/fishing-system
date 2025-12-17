-- Fishing Hack Server Handler
-- fishing_hack.lua - Place in ServerScriptService

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
        
        -- Confirm to client
        fishingRemote:FireClient(player, "FeatureToggled", {
            Feature = featureName,
            Enabled = enabled,
            Message = featureName .. " " .. (enabled and "enabled!" or "disabled")
        })
        
        print(player.Name .. " toggled " .. featureName .. ": " .. tostring(enabled))
        
    elseif action == "UpdateSettings" then
        -- Update settings
        if playerSettings[player] then
            for setting, value in pairs(data) do
                playerSettings[player][setting] = value
            end
        end
    end
end)

-- Clean up when player leaves
Players.PlayerRemoving:Connect(function(player)
    playerSettings[player] = nil
end)

print("🎣 Fishing Hack System loaded!")
