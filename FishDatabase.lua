-- ReplicatedStorage.Shared.FishDatabase
local FishDatabase = {}

FishDatabase.FishList = {
    -- COMMON FISH
    {Name = "Minnow", Type = "Common", Rarity = 1, BaseValue = 10, WeightRange = {0.1, 0.5}},
    {Name = "Bluegill", Type = "Common", Rarity = 1, BaseValue = 15, WeightRange = {0.3, 1.0}},
    {Name = "Perch", Type = "Common", Rarity = 1, BaseValue = 20, WeightRange = {0.5, 1.5}},
    
    -- UNCOMMON FISH
    {Name = "Bass", Type = "Uncommon", Rarity = 2, BaseValue = 50, WeightRange = {1.0, 3.0}},
    {Name = "Trout", Type = "Uncommon", Rarity = 2, BaseValue = 60, WeightRange = {1.5, 4.0}},
    {Name = "Salmon", Type = "Uncommon", Rarity = 2, BaseValue = 75, WeightRange = {2.0, 5.0}},
    
    -- RARE FISH
    {Name = "Tuna", Type = "Rare", Rarity = 3, BaseValue = 200, WeightRange = {5.0, 15.0}},
    {Name = "Swordfish", Type = "Rare", Rarity = 3, BaseValue = 300, WeightRange = {10.0, 25.0}},
    {Name = "Marlin", Type = "Rare", Rarity = 3, BaseValue = 400, WeightRange = {15.0, 30.0}},
    
    -- EPIC FISH
    {Name = "Shark", Type = "Epic", Rarity = 4, BaseValue = 1000, WeightRange = {20.0, 50.0}},
    {Name = "Whale", Type = "Epic", Rarity = 4, BaseValue = 5000, WeightRange = {50.0, 100.0}},
    
    -- LEGENDARY FISH
    {Name = "Kraken", Type = "Legendary", Rarity = 5, BaseValue = 10000, WeightRange = {100.0, 200.0}},
    {Name = "Leviathan", Type = "Legendary", Rarity = 5, BaseValue = 25000, WeightRange = {150.0, 300.0}},
    
    -- EVENT FISH
    {Name = "Santa Fish", Type = "Event", Rarity = 4, BaseValue = 1500, WeightRange = {5.0, 20.0}, Event = "Christmas"},
    {Name = "Ghost Fish", Type = "Event", Rarity = 4, BaseValue = 1500, WeightRange = {5.0, 20.0}, Event = "Halloween"}
}

function FishDatabase.GetAvailableFish(rodData, baitData)
    local availableFish = {}
    local rodRarity = RodRarityToNumber(rodData.Rarity)
    
    for _, fish in pairs(FishDatabase.FishList) do
        -- Check if fish rarity is available for this rod
        if fish.Rarity <= rodRarity + 1 then -- Can catch fish up to 1 rarity higher
            table.insert(availableFish, fish)
        end
    end
    
    return availableFish
end

function RodRarityToNumber(rarity)
    local rarityMap = {
        ["Common"] = 1,
        ["Uncommon"] = 2,
        ["Rare"] = 3,
        ["Epic"] = 4,
        ["Legendary"] = 5,
        ["Event"] = 3
    }
    return rarityMap[rarity] or 1
end

return FishDatabase