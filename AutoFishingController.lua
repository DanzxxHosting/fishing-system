-- ReplicatedStorage.Controllers.AutoFishingController
local AutoFishingController = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ActiveAutoFishers = {}

function AutoFishingController.Init()
    Remotes.ToggleAutoFishing.OnServerEvent:Connect(function(player, enabled)
        if enabled then
            StartAutoFishing(player)
        else
            StopAutoFishing(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        StopAutoFishing(player)
    end)
end

function StartAutoFishing(player)
    if ActiveAutoFishers[player.UserId] then return end
    
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
        -- Auto fishing logic here
        -- This would be called every frame for auto fishing
    end)
    
    ActiveAutoFishers[player.UserId] = connection
    print(string.format("🤖 %s started auto fishing", player.Name))
end

function StopAutoFishing(player)
    local connection = ActiveAutoFishers[player.UserId]
    if connection then
        connection:Disconnect()
        ActiveAutoFishers[player.UserId] = nil
        print(string.format("🤖 %s stopped auto fishing", player.Name))
    end
end

return AutoFishingController