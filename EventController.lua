-- ReplicatedStorage.Controllers.EventController
local EventController = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ActiveEvents = {}

function EventController.Init()
    -- Start Christmas event automatically
    StartEvent("Christmas2024", 7 * 24 * 60 * 60) -- 7 days
    
    -- Handle event joins
    Remotes.JoinEvent.OnServerEvent:Connect(function(player, eventName)
        JoinEvent(player, eventName)
    end)
end

function StartEvent(eventName, duration)
    local eventData = {
        Name = eventName,
        StartTime = os.time(),
        EndTime = os.time() + duration,
        Participants = {},
        Rewards = GetEventRewards(eventName)
    }
    
    ActiveEvents[eventName] = eventData
    
    -- Notify all players
    Remotes.EventUpdate:FireAllClients({
        Type = "EventStarted",
        Event = eventData
    })
    
    print(string.format("🎄 %s event started!", eventName))
end

function JoinEvent(player, eventName)
    local event = ActiveEvents[eventName]
    if not event then return false end
    
    table.insert(event.Participants, player.UserId)
    
    -- Give event starter items
    if eventName == "Christmas2024" then
        Remotes.UpdateUI:FireClient(player, "EventReward", {
            Item = "ChristmasRod",
            Message = "🎁 You received a Christmas Rod!"
        })
    end
    
    return true
end

function GetEventRewards(eventName)
    if eventName == "Christmas2024" then
        return {
            {Type = "Rod", Name = "ChristmasRod", Requirement = "Participate"},
            {Type = "Bait", Name = "CandyCaneBait", Requirement = "Catch 50 fish"},
            {Type = "Title", Name = "Santa's Helper", Requirement = "Complete all tasks"}
        }
    end
    return {}
end

return EventController