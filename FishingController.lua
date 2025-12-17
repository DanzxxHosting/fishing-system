-- ServerScriptService.Controllers.FishingController
local FishingController = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local FishingSystem = require(ReplicatedStorage.Modules.FishingSystem)
local PlayerSystems = {}

function FishingController.Init()
    -- Player joined
    Players.PlayerAdded:Connect(function(player)
        wait(1) -- Wait for character to load
        local system = FishingSystem.new(player)
        PlayerSystems[player.UserId] = system
        
        -- Send initial data to client
        Remotes.UpdateUI:FireClient(player, "InitData", {
            Stats = system:GetPlayerStats(),
            EquippedRod = system.EquippedRod,
            OwnedRods = system.PlayerData.OwnedRods
        })
        
        -- Setup remotes
        SetupPlayerRemotes(player, system)
    end)
    
    -- Player leaving
    Players.PlayerRemoving:Connect(function(player)
        local system = PlayerSystems[player.UserId]
        if system then
            system:SaveData()
            PlayerSystems[player.UserId] = nil
        end
    end)
    
    print("✅ Fishing Controller Initialized")
end

function SetupPlayerRemotes(player, system)
    -- CAST ROD
    Remotes.FishingCast.OnServerEvent:Connect(function(plr, position)
        if plr ~= player then return end
        
        local result = system:CastRod(position)
        Remotes.UpdateUI:FireClient(player, "FishingUpdate", result)
        
        if result.Success then
            -- Play animation
            require(ReplicatedStorage.Controllers.AnimationController).PlayCastAnimation(player)
        end
    end)
    
    -- REEL IN
    Remotes.FishingReel.OnServerEvent:Connect(function(plr)
        if plr ~= player then return end
        
        local result = system:ReelIn()
        
        if result.Success then
            -- Play success animation
            require(ReplicatedStorage.Controllers.AnimationController).PlayReelAnimation(player, true)
            
            -- Show fish effect
            Remotes.ShowFishEffect:FireClient(player, result.Fish)
        else
            -- Play fail animation
            require(ReplicatedStorage.Controllers.AnimationController).PlayReelAnimation(player, false)
        end
        
        Remotes.UpdateUI:FireClient(player, "CatchResult", result)
    end)
    
    -- EQUIP ROD
    Remotes.EquipRod.OnServerEvent:Connect(function(plr, rodName)
        if plr ~= player then return end
        
        local result = system:EquipRod(rodName)
        Remotes.UpdateUI:FireClient(player, "EquipmentUpdate", result)
    end)
    
    -- BUY ITEM
    Remotes.BuyItem.OnServerEvent:Connect(function(plr, itemType, itemName)
        if plr ~= player then return end
        
        local result = system:BuyItem(itemType, itemName)
        Remotes.UpdateUI:FireClient(player, "PurchaseResult", result)
    end)
    
    -- AUTO FISHING
    Remotes.ToggleAutoFishing.OnServerEvent:Connect(function(plr, enabled)
        if plr ~= player then return end
        
        local result = system:ToggleAutoFishing(enabled)
        Remotes.UpdateUI:FireClient(player, "AutoFishingUpdate", result)
    end)
end

return FishingController