-- ReplicatedStorage.Shared.FishingRodModifiers
local RodModifiers = {
    ["BasicRod"] = {
        CastDistance = 50,
        CatchRate = 0.5,
        CatchSpeed = 1.0,
        WeightBonus = 1.0,
        Price = 0,
        Rarity = "Common"
    },
    
    ["AdvancedRod"] = {
        CastDistance = 75,
        CatchRate = 0.65,
        CatchSpeed = 1.2,
        WeightBonus = 1.3,
        Price = 5000,
        Rarity = "Uncommon"
    },
    
    ["ProfessionalRod"] = {
        CastDistance = 100,
        CatchRate = 0.8,
        CatchSpeed = 1.5,
        WeightBonus = 1.8,
        Price = 15000,
        Rarity = "Rare"
    },
    
    ["LegendaryRod"] = {
        CastDistance = 150,
        CatchRate = 0.95,
        CatchSpeed = 2.0,
        WeightBonus = 2.5,
        Price = 50000,
        Rarity = "Legendary"
    },
    
    ["ChristmasRod"] = {
        CastDistance = 90,
        CatchRate = 0.75,
        CatchSpeed = 1.4,
        WeightBonus = 1.6,
        Price = 10000,
        Rarity = "Event",
        SpecialEffect = "Holiday"
    }
}

return RodModifiers