-- ServerScriptService.InitializeRemotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Remotes Folder
local RemotesFolder = Instance.new("Folder")
RemotesFolder.Name = "Remotes"
RemotesFolder.Parent = ReplicatedStorage

-- FISHING REMOTES
local FishingCast = Instance.new("RemoteEvent")
FishingCast.Name = "FishingCast"
FishingCast.Parent = RemotesFolder

local FishingReel = Instance.new("RemoteEvent")
FishingReel.Name = "FishingReel"
FishingReel.Parent = RemotesFolder

local ToggleAutoFishing = Instance.new("RemoteEvent")
ToggleAutoFishing.Name = "ToggleAutoFishing"
ToggleAutoFishing.Parent = RemotesFolder

-- UI REMOTES
local EquipRod = Instance.new("RemoteEvent")
EquipRod.Name = "EquipRod"
EquipRod.Parent = RemotesFolder

local BuyItem = Instance.new("RemoteEvent")
BuyItem.Name = "BuyItem"
BuyItem.Parent = RemotesFolder

local ClaimQuest = Instance.new("RemoteEvent")
ClaimQuest.Name = "ClaimQuest"
ClaimQuest.Parent = RemotesFolder

local UpdateUI = Instance.new("RemoteEvent")
UpdateUI.Name = "UpdateUI"
UpdateUI.Parent = RemotesFolder

-- EVENT REMOTES
local JoinEvent = Instance.new("RemoteEvent")
JoinEvent.Name = "JoinEvent"
JoinEvent.Parent = RemotesFolder

local EventUpdate = Instance.new("RemoteEvent")
EventUpdate.Name = "EventUpdate"
EventUpdate.Parent = RemotesFolder

print("✅ Remotes initialized successfully!")