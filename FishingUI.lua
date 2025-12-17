-- StarterPlayer.StarterPlayerScripts.FishingUI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishingGameUI"
ScreenGui.Parent = PlayerGui

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(1, 0, 1, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = ScreenGui

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainContainer

local CoinsFrame = Instance.new("Frame")
CoinsFrame.Size = UDim2.new(0, 200, 0, 40)
CoinsFrame.Position = UDim2.new(0, 10, 0, 5)
CoinsFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
CoinsFrame.Parent = TopBar

local CoinsIcon = Instance.new("ImageLabel")
CoinsIcon.Size = UDim2.new(0, 30, 0, 30)
CoinsIcon.Position = UDim2.new(0, 5, 0, 5)
CoinsIcon.Image = "rbxassetid://6755033111" -- Coin icon
CoinsIcon.Parent = CoinsFrame

local CoinsText = Instance.new("TextLabel")
CoinsText.Size = UDim2.new(0, 150, 1, 0)
CoinsText.Position = UDim2.new(0, 40, 0, 0)
CoinsText.Text = "Coins: 1000"
CoinsText.TextColor3 = Color3.new(1, 1, 1)
CoinsText.Font = Enum.Font.GothamBold
CoinsText.TextSize = 18
CoinsText.Parent = CoinsFrame

-- LEFT SIDEBAR (Equipment)
local LeftSidebar = Instance.new("Frame")
LeftSidebar.Size = UDim2.new(0, 200, 0.8, 0)
LeftSidebar.Position = UDim2.new(0, 10, 0, 60)
LeftSidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
LeftSidebar.Parent = MainContainer

local RodsTitle = Instance.new("TextLabel")
RodsTitle.Size = UDim2.new(1, 0, 0, 40)
RodsTitle.Text = "🎣 EQUIPPED ROD"
RodsTitle.TextColor3 = Color3.new(1, 1, 1)
RodsTitle.Font = Enum.Font.GothamBold
RodsTitle.TextSize = 16
RodsTitle.Parent = LeftSidebar

local CurrentRodText = Instance.new("TextLabel")
CurrentRodText.Size = UDim2.new(1, -20, 0, 30)
CurrentRodText.Position = UDim2.new(0, 10, 0, 50)
CurrentRodText.Text = "Basic Rod"
CurrentRodText.TextColor3 = Color3.fromRGB(0, 255, 255)
CurrentRodText.Font = Enum.Font.Gotham
CurrentRodText.TextSize = 14
CurrentRodText.Parent = LeftSidebar

-- FISHING PANEL (Center)
local FishingPanel = Instance.new("Frame")
FishingPanel.Size = UDim2.new(0.4, 0, 0.5, 0)
FishingPanel.Position = UDim2.new(0.3, 0, 0.25, 0)
FishingPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FishingPanel.Parent = MainContainer

local WaterImage = Instance.new("ImageLabel")
WaterImage.Size = UDim2.new(1, 0, 0.7, 0)
WaterImage.Image = "rbxassetid://6755033222" -- Water texture
WaterImage.Parent = FishingPanel

-- CAST BUTTON
local CastButton = Instance.new("TextButton")
CastButton.Size = UDim2.new(0, 150, 0, 50)
CastButton.Position = UDim2.new(0.5, -75, 0.85, 0)
CastButton.Text = "🎣 CAST"
CastButton.Font = Enum.Font.GothamBold
CastButton.TextSize = 18
CastButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CastButton.Parent = FishingPanel

CastButton.MouseButton1Click:Connect(function()
    Remotes.FishingCast:FireServer(Vector3.new(0, 0, 0))
    CastButton.Visible = false
    ReelButton.Visible = true
end)

-- REEL BUTTON
local ReelButton = Instance.new("TextButton")
ReelButton.Size = UDim2.new(0, 150, 0, 50)
ReelButton.Position = UDim2.new(0.5, -75, 0.85, 0)
ReelButton.Text = "🎯 REEL IN!"
ReelButton.Font = Enum.Font.GothamBold
ReelButton.TextSize = 18
ReelButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ReelButton.Visible = false
ReelButton.Parent = FishingPanel

ReelButton.MouseButton1Click:Connect(function()
    Remotes.FishingReel:FireServer()
    ReelButton.Visible = false
    CastButton.Visible = true
end)

-- RIGHT SIDEBAR (Shop & Quests)
local RightSidebar = Instance.new("Frame")
RightSidebar.Size = UDim2.new(0, 250, 0.8, 0)
RightSidebar.Position = UDim2.new(1, -260, 0, 60)
RightSidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
RightSidebar.Parent = MainContainer

-- SHOP TAB
local ShopTab = Instance.new("TextButton")
ShopTab.Size = UDim2.new(0.5, 0, 0, 40)
ShopTab.Text = "🛒 SHOP"
ShopTab.Font = Enum.Font.GothamBold
ShopTab.TextSize = 14
ShopTab.Parent = RightSidebar

-- QUESTS TAB
local QuestsTab = Instance.new("TextButton")
QuestsTab.Size = UDim2.new(0.5, 0, 0, 40)
QuestsTab.Position = UDim2.new(0.5, 0, 0, 0)
QuestsTab.Text = "📜 QUESTS"
QuestsTab.Font = Enum.Font.GothamBold
QuestsTab.TextSize = 14
QuestsTab.Parent = RightSidebar

-- BOTTOM BAR (Notifications)
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0.4, 0, 0, 80)
NotificationFrame.Position = UDim2.new(0.3, 0, 0.85, 0)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
NotificationFrame.Visible = false
NotificationFrame.Parent = MainContainer

local NotificationText = Instance.new("TextLabel")
NotificationText.Size = UDim2.new(1, -20, 1, -20)
NotificationText.Position = UDim2.new(0, 10, 0, 10)
NotificationText.Text = ""
NotificationText.TextColor3 = Color3.new(1, 1, 1)
NotificationText.Font = Enum.Font.Gotham
NotificationText.TextSize = 16
NotificationText.Parent = NotificationFrame

-- NOTIFICATION FUNCTION
function ShowNotification(message, duration)
    NotificationText.Text = message
    NotificationFrame.Visible = true
    
    task.spawn(function()
        wait(duration or 3)
        NotificationFrame.Visible = false
    end)
end

-- REMOTE EVENT HANDLERS
Remotes.UpdateUI.OnClientEvent:Connect(function(updateType, data)
    if updateType == "FishingUpdate" then
        if data.Success then
            ShowNotification("🎣 Rod cast! Waiting for bite...", 2)
        else
            ShowNotification("❌ " .. data.Message, 2)
        end
        
    elseif updateType == "CatchResult" then
        if data.Success then
            ShowNotification(string.format("✅ %s +%d Coins!", data.Message, data.Reward), 3)
            CoinsText.Text = "Coins: " .. tostring(tonumber(CoinsText.Text:match("%d+")) + data.Reward)
        else
            ShowNotification("❌ " .. data.Message, 2)
        end
        
    elseif updateType == "EquipmentUpdate" then
        ShowNotification("⚙️ " .. data.Message, 2)
        CurrentRodText.Text = data.Rod
        
    elseif updateType == "PurchaseResult" then
        ShowNotification("🛒 " .. data.Message, 2)
        CoinsText.Text = "Coins: " .. tostring(data.Remaining)
        
    elseif updateType == "InitData" then
        CoinsText.Text = "Coins: " .. tostring(data.Stats.Coins)
        CurrentRodText.Text = data.EquippedRod
    end
end)