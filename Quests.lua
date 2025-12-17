-- ReplicatedStorage.Shared.Quests
local Quests = {
    Daily = {
        {
            Id = "DAILY_CATCH_10",
            Name = "Catch 10 Fish",
            Description = "Catch 10 fish of any type",
            Type = "CatchFish",
            Target = 10,
            Reward = {Coins = 500, XP = 100},
            Progress = 0
        },
        {
            Id = "DAILY_BIG_FISH",
            Name = "Catch Big Fish",
            Description = "Catch a fish weighing over 5kg",
            Type = "CatchWeight",
            Target = 5,
            Reward = {Coins = 1000, XP = 200},
            Progress = 0
        }
    },
    
    Weekly = {
        {
            Id = "WEEKLY_100_FISH",
            Name = "Catch 100 Fish",
            Description = "Catch 100 fish this week",
            Type = "CatchFish",
            Target = 100,
            Reward = {Coins = 5000, Gems = 10, XP = 1000},
            Progress = 0
        },
        {
            Id = "WEEKLY_VARIETY",
            Name = "Fish Variety",
            Description = "Catch 10 different fish species",
            Type = "CatchVariety",
            Target = 10,
            Reward = {Coins = 3000, Gems = 5, XP = 500},
            Progress = 0
        }
    },
    
    Achievements = {
        {
            Id = "ACH_FIRST_CATCH",
            Name = "First Catch",
            Description = "Catch your first fish",
            Type = "CatchFish",
            Target = 1,
            Reward = {Coins = 100, Title = "Fisherman"},
            Progress = 0
        },
        {
            Id = "ACH_MASTER_FISHER",
            Name = "Master Fisher",
            Description = "Catch 1000 fish total",
            Type = "TotalFish",
            Target = 1000,
            Reward = {Coins = 10000, Gems = 50, Title = "Master Fisher"},
            Progress = 0
        }
    }
}

return Quests