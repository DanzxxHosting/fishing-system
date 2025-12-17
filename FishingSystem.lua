-- ReplicatedStorage.Modules.FishingSystem
local FishingSystem = {}
FishingSystem.__index = FishingSystem

local DataStoreService = game:GetService("DataStoreService")
local FishingDataStore = DataStoreService:GetDataStore("FishingPlayerData")

function FishingSystem.new(player)
    local self = setmetatable({}, FishingSystem)
    
    self.Player = player
    self.PlayerData = self:LoadData()
    
    self.EquippedRod = self.PlayerData.EquippedRod or "BasicRod"
    self.CurrentBait = self.PlayerData.CurrentBait or "Worm"
    self.IsFishing = false
    self.FishOnHook = false
    self.AutoFishing = false
    
    return self
end

-- LOAD/SAVE DATA
function FishingSystem:LoadData()
    local success, data = pcall(function()
        return FishingDataStore:GetAsync(self.Player.UserId)
    end)
    
    if success and data then
        return data
    else
        -- Default data for new players
        return {
            Coins = 1000,
            Gems = 50,
            Level = 1,
            XP = 0,
            TotalFishCaught = 0,
            TotalWeight = 0,
            BiggestFish = {Name = "None", Weight = 0},
            OwnedRods = {"BasicRod"},
            OwnedBait = {"Worm": 10},
            CurrentQuests = {},
            CompletedQuests = {},
            FishCollection = {}
        }
    end
end

function FishingSystem:SaveData()
    pcall(function()
        FishingDataStore:SetAsync(self.Player.UserId, self.PlayerData)
    end)
end

-- FISHING METHODS
function FishingSystem:CastRod(position)
    if self.IsFishing then
        return {Success = false, Message = "Already fishing!"}
    end
    
    local rodData = self:GetRodData(self.EquippedRod)
    if not rodData then
        return {Success = false, Message = "Invalid rod equipped!"}
    end
    
    self.IsFishing = true
    self.FishOnHook = false
    
    -- Calculate cast
    local castPower = math.random(70, 100) / 100
    local distance = rodData.CastDistance * castPower
    
    -- Start fishing timer
    task.spawn(function()
        local waitTime = math.random(3, 10) / rodData.CatchSpeed
        
        wait(waitTime)
        
        if self.IsFishing then
            self.FishOnHook = true
            return {FishReady = true}
        end
    end)
    
    return {
        Success = true,
        Distance = distance,
        Position = position
    }
end

function FishingSystem:ReelIn()
    if not self.FishOnHook then
        return {Success = false, Message = "No fish on hook!"}
    end
    
    local rodData = self:GetRodData(self.EquippedRod)
    local baitData = self:GetBaitData(self.CurrentBait)
    
    -- Calculate catch chance
    local catchChance = rodData.CatchRate * (baitData.Effectiveness or 1)
    local success = math.random() <= catchChance
    
    if success then
        local fish = self:GenerateFish(rodData, baitData)
        
        -- Update player data
        self.PlayerData.Coins += fish.Value
        self.PlayerData.TotalFishCaught += 1
        self.PlayerData.TotalWeight += fish.Weight
        
        if fish.Weight > self.PlayerData.BiggestFish.Weight then
            self.PlayerData.BiggestFish = {Name = fish.Name, Weight = fish.Weight}
        end
        
        -- Add to collection
        if not self.PlayerData.FishCollection[fish.Name] then
            self.PlayerData.FishCollection[fish.Name] = 0
        end
        self.PlayerData.FishCollection[fish.Name] += 1
        
        -- Save data
        self:SaveData()
        
        return {
            Success = true,
            Fish = fish,
            Reward = fish.Value,
            Message = string.format("Caught %s! (%.1f kg)", fish.Name, fish.Weight)
        }
    else
        return {
            Success = false,
            Message = "Fish got away!"
        }
    end
end

function FishingSystem:GenerateFish(rodData, baitData)
    local fishDatabase = require(game.ReplicatedStorage.Shared.FishDatabase)
    local availableFish = fishDatabase.GetAvailableFish(rodData, baitData)
    
    -- Weight calculation
    local baseWeight = math.random(10, 1000) / 100
    local weightBonus = rodData.WeightBonus * (baitData.WeightMultiplier or 1)
    local finalWeight = baseWeight * weightBonus
    
    -- Select random fish
    local randomIndex = math.random(1, #availableFish)
    local selectedFish = availableFish[randomIndex]
    
    return {
        Name = selectedFish.Name,
        Weight = finalWeight,
        Rarity = selectedFish.Rarity,
        Type = selectedFish.Type,
        Value = math.floor(selectedFish.BaseValue * finalWeight)
    }
end

-- EQUIPMENT METHODS
function FishingSystem:EquipRod(rodName)
    if not table.find(self.PlayerData.OwnedRods, rodName) then
        return {Success = false, Message = "You don't own this rod!"}
    end
    
    self.EquippedRod = rodName
    self.PlayerData.EquippedRod = rodName
    self:SaveData()
    
    return {
        Success = true,
        Rod = rodName,
        Message = string.format("Equipped %s!", rodName)
    }
end

function FishingSystem:BuyItem(itemType, itemName)
    local products = require(game.ReplicatedStorage.Shared.Products)
    local itemData = products[itemType][itemName]
    
    if not itemData then
        return {Success = false, Message = "Item not found!"}
    end
    
    -- Check currency
    local currency = itemData.Currency or "Coins"
    if self.PlayerData[currency] < itemData.Price then
        return {Success = false, Message = string.format("Not enough %s!", currency)}
    end
    
    -- Deduct currency
    self.PlayerData[currency] -= itemData.Price
    
    -- Add to inventory
    if itemType == "Rods" then
        table.insert(self.PlayerData.OwnedRods, itemName)
    elseif itemType == "Bait" then
        if not self.PlayerData.OwnedBait[itemName] then
            self.PlayerData.OwnedBait[itemName] = 0
        end
        self.PlayerData.OwnedBait[itemName] += itemData.Quantity or 1
    end
    
    self:SaveData()
    
    return {
        Success = true,
        Item = itemName,
        Remaining = self.PlayerData[currency],
        Message = string.format("Purchased %s!", itemName)
    }
end

-- AUTO FISHING
function FishingSystem:ToggleAutoFishing(enabled)
    self.AutoFishing = enabled
    
    if enabled then
        self:StartAutoFishingLoop()
    end
    
    return {Success = true, AutoFishing = enabled}
end

function FishingSystem:StartAutoFishingLoop()
    while self.AutoFishing do
        if not self.IsFishing then
            self:CastRod(Vector3.new(
                math.random(-50, 50),
                0,
                math.random(-50, 50)
            ))
            
            wait(math.random(3, 8))
            
            if self.FishOnHook then
                self:ReelIn()
            end
        end
        wait(1)
    end
end

-- UTILITY METHODS
function FishingSystem:GetRodData(rodName)
    local rodModifiers = require(game.ReplicatedStorage.Shared.FishingRodModifiers)
    return rodModifiers[rodName]
end

function FishingSystem:GetBaitData(baitName)
    local baitModifiers = require(game.ReplicatedStorage.Shared.BaitModifiers)
    return baitModifiers[baitName] or {Effectiveness = 1}
end

function FishingSystem:GetPlayerStats()
    return {
        Coins = self.PlayerData.Coins,
        Gems = self.PlayerData.Gems,
        Level = self.PlayerData.Level,
        TotalFish = self.PlayerData.TotalFishCaught,
        TotalWeight = self.PlayerData.TotalWeight,
        BiggestFish = self.PlayerData.BiggestFish
    }
end

return FishingSystem