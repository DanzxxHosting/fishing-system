-- ReplicatedStorage.Shared.Products
local Products = {
    Rods = {
        AdvancedRod = {
            Price = 5000,
            Currency = "Coins",
            Description = "Better cast distance and catch rate"
        },
        ProfessionalRod = {
            Price = 15000,
            Currency = "Coins",
            Description = "Professional grade fishing rod"
        },
        LegendaryRod = {
            Price = 50000,
            Currency = "Coins",
            Description = "The ultimate fishing experience"
        }
    },
    
    Bait = {
        Worm = {
            Price = 10,
            Currency = "Coins",
            Quantity = 10,
            Description = "Basic bait"
        },
        Shrimp = {
            Price = 50,
            Currency = "Coins",
            Quantity = 10,
            Description = "Attracts uncommon fish"
        },
        SpecialBait = {
            Price = 200,
            Currency = "Coins",
            Quantity = 5,
            Description = "Attracts rare fish"
        }
    },
    
    Coins = {
        SmallCoinPack = {
            Price = 49,
            Currency = "Robux",
            Coins = 1000,
            Description = "1000 Coins"
        },
        MediumCoinPack = {
            Price = 99,
            Currency = "Robux",
            Coins = 2500,
            Description = "2500 Coins"
        },
        LargeCoinPack = {
            Price = 199,
            Currency = "Robux",
            Coins = 6000,
            Description = "6000 Coins"
        }
    }
}

return Products