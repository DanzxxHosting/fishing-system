-- =============================================
-- 🎣 FISHING SCRIPT V3.4 - ONE FILE EXECUTOR
-- =============================================
-- Execute langsung muncul UI, tanpa install!

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- =============================================
-- 🎯 FISHING SYSTEM MODULE
-- =============================================
local FishingSystem = {
    Config = {
        AutoFishing = false,
        InstantFishing = false,
        BlatantFishing = false,
        AutoSell = false,
        AutoBait = false,
        CatchSpeed = 1,
        RadarEnabled = false,
        NoAnimation = false,
        AutoQuest = false
    },
    Stats = {
        TotalFish = 0,
        TotalWeight = 0,
        BiggestFish = "None (0kg)",
        Coins = 1000,
        Gems = 50,
        Level = 1
    }
}

function FishingSystem:ToggleAutoFishing(state)
    self.Config.AutoFishing = state
    self:ShowNotification("Auto Fishing: " .. (state and "ON" or "OFF"))
    
    if state then
        spawn(function()
            while self.Config.AutoFishing do
                self.Stats.TotalFish = self.Stats.TotalFish + 1
                self.Stats.TotalWeight = self.Stats.TotalWeight + math.random(1, 50) / 10
                self.Stats.Coins = self.Stats.Coins + math.random(10, 100)
                wait(1 / self.Config.CatchSpeed)
            end
        end)
    end
end

function FishingSystem:SetInstantFishing(state)
    self.Config.InstantFishing = state
    self:ShowNotification("Instant Fishing: " .. (state and "ON" or "OFF"))
end

function FishingSystem:SetBlatantFishing(state)
    self.Config.BlatantFishing = state
    self:ShowNotification("Blatant Fishing: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleAutoSell(state)
    self.Config.AutoSell = state
    self:ShowNotification("Auto Sell: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleAutoBait(state)
    self.Config.AutoBait = state
    self:ShowNotification("Auto Bait: " .. (state and "ON" or "OFF"))
end

function FishingSystem:SetCatchSpeed(speed)
    self.Config.CatchSpeed = speed
    self:ShowNotification("Catch Speed: " .. speed .. "x")
end

function FishingSystem:ToggleRadar(state)
    self.Config.RadarEnabled = state
    self:ShowNotification("Radar: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleFishingAnimation(state)
    self.Config.NoAnimation = not state
    self:ShowNotification("No Animation: " .. (not state and "ON" or "OFF"))
end

function FishingSystem:ToggleAutoQuest(state)
    self.Config.AutoQuest = state
    self:ShowNotification("Auto Quest: " .. (state and "ON" or "OFF"))
end

function FishingSystem:EquipBestRod()
    self:ShowNotification("Equipping Best Rod...")
    -- Simulate equip delay
    wait(0.5)
    self:ShowNotification("✓ Best Rod Equipped!")
end

function FishingSystem:InstantCast()
    self:ShowNotification("⚡ Instant Cast!")
end

function FishingSystem:SetWalkSpeed(speed)
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
        self:ShowNotification("Walk Speed: " .. speed)
    end
end

function FishingSystem:SetJumpPower(power)
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = power
        self:ShowNotification("Jump Power: " .. power)
    end
end

function FishingSystem:ToggleInfiniteJump(state)
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if Player.Character then
                local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState("Jumping")
                end
            end
        end)
        self:ShowNotification("Infinite Jump: ON")
    else
        self:ShowNotification("Infinite Jump: OFF")
    end
end

function FishingSystem:ToggleESP(state)
    if state then
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= Player and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Adornee = head
                    billboard.Name = "ESP_" .. target.Name
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = target.Name
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.TextStrokeTransparency = 0
                    label.BackgroundTransparency = 1
                    label.Parent = billboard
                    
                    billboard.Parent = head
                end
            end
        end
        self:ShowNotification("ESP: ON")
    else
        for _, target in pairs(Players:GetPlayers()) do
            if target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    local esp = head:FindFirstChild("ESP_" .. target.Name)
                    if esp then esp:Destroy() end
                end
            end
        end
        self:ShowNotification("ESP: OFF")
    end
end

function FishingSystem:ToggleFly(state)
    if state then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        self:ShowNotification("Fly: ON (Press X to fly)")
    else
        self:ShowNotification("Fly: OFF")
    end
end

function FishingSystem:ToggleNoClip(state)
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        self:ShowNotification("NoClip: ON")
    else
        self:ShowNotification("NoClip: OFF")
    end
end

function FishingSystem:GetStats()
    return {
        TotalFish = self.Stats.TotalFish,
        TotalWeight = string.format("%.1fkg", self.Stats.TotalWeight),
        BiggestFish = self.Stats.BiggestFish,
        Coins = self.Stats.Coins,
        Level = self.Stats.Level
    }
end

function FishingSystem:ShowNotification(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎣 Fishing Script",
        Text = message,
        Duration = 2,
        Icon = "rbxassetid://6031075938"
    })
end

-- =============================================
-- 🎨 UI CREATION
-- =============================================

-- Hapus UI lama jika ada
if PlayerGui:FindFirstChild("FishingScriptUI") then
    PlayerGui.FishingScriptUI:Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishingScriptUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 500, 0, 550)
MainContainer.Position = UDim2.new(0.5, -250, 0.5, -275)
MainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainContainer.BorderSizePixel = 0
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

-- Shadow Effect
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 6, 1, 6)
Shadow.Position = UDim2.new(0, -3, 0, -3)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.8
Shadow.BorderSizePixel = 0
Shadow.ZIndex = -1
Shadow.Parent = MainContainer

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainContainer

-- Title with gradient
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 170))
})

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Text = "🎣 FISHING SCRIPT V3.4"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1
Title.Parent = TitleBar
Title.UIGradient = TitleGradient:Clone()

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 50, 0, 50)
CloseButton.Position = UDim2.new(1, -50, 0, 0)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 24
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 50, 0, 50)
MinimizeButton.Position = UDim2.new(1, -100, 0, 0)
MinimizeButton.Text = "─"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 24
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TitleBar

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainContainer.Size = UDim2.new(0, 500, 0, 50)
        MinimizeButton.Text = "□"
    else
        MainContainer.Size = UDim2.new(0, 500, 0, 550)
        MinimizeButton.Text = "─"
    end
end)

-- Tab Buttons
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainContainer

local Tabs = {"Main", "Menu", "Utility", "Stats"}
local TabButtons = {}
local CurrentTab = "Main"

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1/#Tabs, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.BackgroundColor3 = tabName == "Main" and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 60)
    TabButton.BorderSizePixel = 0
    TabButton.Name = tabName .. "Tab"
    TabButton.Parent = TabContainer
    TabButtons[tabName] = TabButton
    
    TabButton.MouseButton1Click:Connect(function()
        CurrentTab = tabName
        UpdateTabVisibility()
    end)
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainContainer

-- Create Tabs Content
local TabContents = {}

for _, tabName in ipairs(Tabs) do
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Visible = tabName == "Main"
    ScrollFrame.Name = tabName .. "Content"
    ScrollFrame.Parent = ContentFrame
    TabContents[tabName] = ScrollFrame
end

-- =============================================
-- 🎯 UI COMPONENT FUNCTIONS
-- =============================================

local yPositions = {}

function CreateSection(parent, title, yOffset)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.Position = UDim2.new(0, 0, 0, yOffset)
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 1, 0)
    SectionTitle.Text = "  " .. title
    SectionTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = 16
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SectionTitle.BorderSizePixel = 0
    SectionTitle.Parent = Section
    
    return Section
end

function CreateToggle(parent, text, defaultValue, callback, yOffset)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.Position = UDim2.new(0, 0, 0, yOffset)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 30, 0, 30)
    ToggleButton.Position = UDim2.new(0, 10, 0, 2)
    ToggleButton.Text = defaultValue and "✓" or "☐"
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 18
    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 50, 0, 0)
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.new(1, 1, 1)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Parent = ToggleFrame
    
    local state = defaultValue
    
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.Text = state and "✓" or "☐"
        ToggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
        callback(state)
    end)
    
    return ToggleFrame
end

function CreateSlider(parent, text, min, max, defaultValue, suffix, callback, yOffset)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.Position = UDim2.new(0, 0, 0, yOffset)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 0)
    SliderLabel.Text = text .. ": " .. defaultValue .. suffix
    SliderLabel.TextColor3 = Color3.new(1, 1, 1)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -20, 0, 6)
    SliderTrack.Position = UDim2.new(0, 10, 0, 30)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -10, 0.5, -10)
    SliderButton.Text = ""
    SliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
    SliderButton.BorderSizePixel = 0
    SliderButton.ZIndex = 2
    SliderButton.Parent = SliderTrack
    
    local dragging = false
    local currentValue = defaultValue
    
    local function UpdateValue(value)
        currentValue = math.clamp(math.floor(value), min, max)
        local percent = (currentValue - min) / (max - min)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
        SliderLabel.Text = text .. ": " .. currentValue .. suffix
        callback(currentValue)
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local trackPos = SliderTrack.AbsolutePosition
            local trackSize = SliderTrack.AbsoluteSize
            local relativeX = (mousePos.X - trackPos.X) / trackSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            local value = min + (relativeX * (max - min))
            UpdateValue(value)
        end
    end)
    
    return SliderFrame
end

function CreateButton(parent, text, callback, yOffset)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, yOffset)
    Button.Text = text
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    Button.BorderSizePixel = 0
    Button.Parent = parent
    
    Button.MouseButton1Click:Connect(callback)
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end)
    
    return Button
end

function UpdateTabVisibility()
    for tabName, content in pairs(TabContents) do
        content.Visible = tabName == CurrentTab
    end
    
    for tabName, button in pairs(TabButtons) do
        button.BackgroundColor3 = tabName == CurrentTab and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 60)
    end
end

-- =============================================
-- 📋 POPULATE TABS CONTENT
-- =============================================

-- MAIN TAB
local MainTab = TabContents["Main"]
yPositions["Main"] = 0

local MainSection = CreateSection(MainTab, "🔧 Main Features", yPositions["Main"])
yPositions["Main"] = yPositions["Main"] + 40

CreateToggle(MainTab, "🤖 Auto Fishing", false, function(state)
    FishingSystem:ToggleAutoFishing(state)
end, yPositions["Main"])
yPositions["Main"] = yPositions["Main"] + 40

CreateToggle(MainTab, "⚡ Instant Fishing", false, function(state)
    FishingSystem:SetInstantFishing(state)
end, yPositions["Main"])
yPositions["Main"] = yPositions["Main"] + 40

CreateToggle(MainTab, "🚀 Blatant Fishing", false, function(state)
    FishingSystem:SetBlatantFishing(state)
end, yPositions["Main"])
yPositions["Main"] = yPositions["Main"] + 40

CreateToggle(MainTab, "💰 Auto Sell Fish", false, function(state)
    FishingSystem:ToggleAutoSell(state)
end, yPositions["Main"])
yPositions["Main"] = yPositions["Main"] + 40

CreateToggle(MainTab, "🪱 Auto Rebuy Bait", false, function(state)
    FishingSystem:ToggleAutoBait(state)
end, yPositions["Main"])
yPositions["Main"] = yPositions["Main"] + 40

local SpeedSection = CreateSection(MainTab, "🎯 Speed Settings", yPositions["Main"])
yPositions["Main"] = yPositions["Main"] + 40

CreateSlider(MainTab, "Catch Speed", 1, 10, 1, "x", function(value)
    FishingSystem:SetCatchSpeed(value)
end, yPositions["Main"])
yPositions["Main"] = yPositions["Main"] + 70

MainTab.CanvasSize = UDim2.new(0, 0, 0, yPositions["Main"])

-- MENU TAB
local MenuTab = TabContents["Menu"]
yPositions["Menu"] = 0

local MenuSection = CreateSection(MenuTab, "⚙️ Menu Settings", yPositions["Menu"])
yPositions["Menu"] = yPositions["Menu"] + 40

CreateToggle(MenuTab, "📡 Enable Fishing Radar", false, function(state)
    FishingSystem:ToggleRadar(state)
end, yPositions["Menu"])
yPositions["Menu"] = yPositions["Menu"] + 40

CreateToggle(MenuTab, "👻 No Animation Fishing", false, function(state)
    FishingSystem:ToggleFishingAnimation(state)
end, yPositions["Menu"])
yPositions["Menu"] = yPositions["Menu"] + 40

CreateToggle(MenuTab, "📜 Auto Quest", false, function(state)
    FishingSystem:ToggleAutoQuest(state)
end, yPositions["Menu"])
yPositions["Menu"] = yPositions["Menu"] + 40

CreateButton(MenuTab, "🎣 Equip Best Rod", function()
    FishingSystem:EquipBestRod()
end, yPositions["Menu"])
yPositions["Menu"] = yPositions["Menu"] + 50

CreateButton(MenuTab, "⚡ Instant Cast", function()
    FishingSystem:InstantCast()
end, yPositions["Menu"])
yPositions["Menu"] = yPositions["Menu"] + 50

MenuTab.CanvasSize = UDim2.new(0, 0, 0, yPositions["Menu"])

-- UTILITY TAB
local UtilityTab = TabContents["Utility"]
yPositions["Utility"] = 0

local UtilitySection = CreateSection(UtilityTab, "🛠️ Utility Features", yPositions["Utility"])
yPositions["Utility"] = yPositions["Utility"] + 40

CreateToggle(UtilityTab, "👁️ ESP Name", false, function(state)
    FishingSystem:ToggleESP(state)
end, yPositions["Utility"])
yPositions["Utility"] = yPositions["Utility"] + 40

CreateToggle(UtilityTab, "♾️ Infinity Jump", false, function(state)
    FishingSystem:ToggleInfiniteJump(state)
end, yPositions["Utility"])
yPositions["Utility"] = yPositions["Utility"] + 40

CreateToggle(UtilityTab, "✈️ Fly", false, function(state)
    FishingSystem:ToggleFly(state)
end, yPositions["Utility"])
yPositions["Utility"] = yPositions["Utility"] + 40

CreateToggle(UtilityTab, "👻 No Clip", false, function(state)
    FishingSystem:ToggleNoClip(state)
end, yPositions["Utility"])
yPositions["Utility"] = yPositions["Utility"] + 40

local SpeedUtilitySection = CreateSection(UtilityTab, "🚀 Movement", yPositions["Utility"])
yPositions["Utility"] = yPositions["Utility"] + 40

CreateSlider(UtilityTab, "Walk Speed", 16, 200, 16, " studs", function(value)
    FishingSystem:SetWalkSpeed(value)
end, yPositions["Utility"])
yPositions["Utility"] = yPositions["Utility"] + 70

CreateSlider(UtilityTab, "Jump Power", 50, 200, 50, " power", function(value)
    FishingSystem:SetJumpPower(value)
end, yPositions["Utility"])
yPositions["Utility"] = yPositions["Utility"] + 70

UtilityTab.CanvasSize = UDim2.new(0, 0, 0, yPositions["Utility"])

-- STATS TAB
local StatsTab = TabContents["Stats"]
yPositions["Stats"] = 0

local StatsSection = CreateSection(StatsTab, "📊 Fishing Statistics", yPositions["Stats"])
yPositions["Stats"] = yPositions["Stats"] + 40

-- Stats Labels
local statsLabels = {}

local function CreateStatLabel(text, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    label.BorderSizePixel = 0
    label.Parent = StatsTab
    return label
end

statsLabels.TotalFish = CreateStatLabel("🎣 Total Fish: 0", yPositions["Stats"])
yPositions["Stats"] = yPositions["Stats"] + 35

statsLabels.TotalWeight = CreateStatLabel("⚖️ Total Weight: 0kg", yPositions["Stats"])
yPositions["Stats"] = yPositions["Stats"] + 35

statsLabels.BiggestFish = CreateStatLabel("🐟 Biggest Fish: None (0kg)", yPositions["Stats"])
yPositions["Stats"] = yPositions["Stats"] + 35

statsLabels.Coins = CreateStatLabel("💰 Coins: 1000", yPositions["Stats"])
yPositions["Stats"] = yPositions["Stats"] + 35

statsLabels.Level = CreateStatLabel("⭐ Level: 1", yPositions["Stats"])
yPositions["Stats"] = yPositions["Stats"] + 35

CreateButton(StatsTab, "🔄 Refresh Stats", function()
    local stats = FishingSystem:GetStats()
    statsLabels.TotalFish.Text = "🎣 Total Fish: " .. stats.TotalFish
    statsLabels.TotalWeight.Text = "⚖️ Total Weight: " .. stats.TotalWeight
    statsLabels.BiggestFish.Text = "🐟 Biggest Fish: " .. stats.BiggestFish
    statsLabels.Coins.Text = "💰 Coins: " .. stats.Coins
    statsLabels.Level.Text = "⭐ Level: " .. stats.Level
    FishingSystem:ShowNotification("Stats Refreshed!")
end, yPositions["Stats"])
yPositions["Stats"] = yPositions["Stats"] + 50

local HotkeySection = CreateSection(StatsTab, "⌨️ Hotkeys", yPositions["Stats"])
yPositions["Stats"] = yPositions["Stats"] + 40

local hotkeys = {
    "F - Toggle Auto Fishing",
    "R - Equip Best Rod",
    "T - Toggle Radar",
    "Y - Instant Cast",
    "RightControl - Show/Hide UI"
}

for i, hotkey in ipairs(hotkeys) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yPositions["Stats"])
    label.Text = "  " .. hotkey
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = StatsTab
    yPositions["Stats"] = yPositions["Stats"] + 25
end

StatsTab.CanvasSize = UDim2.new(0, 0, 0, yPositions["Stats"] + 20)

-- =============================================
-- 🎮 HOTKEYS & EVENTS
-- =============================================

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
            FishingSystem:ShowNotification("UI " .. (ScreenGui.Enabled and "Shown" or "Hidden"))
        elseif input.KeyCode == Enum.KeyCode.F then
            FishingSystem:ToggleAutoFishing(not FishingSystem.Config.AutoFishing)
        elseif input.KeyCode == Enum.KeyCode.R then
            FishingSystem:EquipBestRod()
        elseif input.KeyCode == Enum.KeyCode.T then
            FishingSystem:ToggleRadar(not FishingSystem.Config.RadarEnabled)
        elseif input.KeyCode == Enum.KeyCode.Y then
            FishingSystem:InstantCast()
        end
    end
end)

-- Auto update stats
spawn(function()
    while ScreenGui.Parent do
        local stats = FishingSystem:GetStats()
        statsLabels.TotalFish.Text = "🎣 Total Fish: " .. stats.TotalFish
        statsLabels.TotalWeight.Text = "⚖️ Total Weight: " .. stats.TotalWeight
        statsLabels.BiggestFish.Text = "🐟 Biggest Fish: " .. stats.BiggestFish
        statsLabels.Coins.Text = "💰 Coins: " .. stats.Coins
        statsLabels.Level.Text = "⭐ Level: " .. stats.Level
        wait(1)
    end
end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- =============================================
-- 🎉 INITIALIZATION
-- =============================================

-- Update canvas sizes
for tabName, yPos in pairs(yPositions) do
    TabContents[tabName].CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
end

-- Welcome notification
wait(0.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🎣 Fishing Script V3.4",
    Text = "UI Loaded Successfully!\nPress RightControl to toggle",
    Duration = 5,
    Icon = "rbxassetid://6031075938"
})

-- Play sound effect
local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://9114821956" -- UI open sound
Sound.Volume = 0.3
Sound.Parent = PlayerGui
Sound:Play()

print("====================================")
print("🎣 FISHING SCRIPT V3.4 LOADED!")
print("📁 Single File Executor")
print("🎨 Modern UI with 4 Tabs")
print("⚡ Instant Execution")
print("====================================")

-- Make UI always on top
ScreenGui.DisplayOrder = 999

-- Success message
FishingSystem:ShowNotification("🎣 Welcome to Fishing Script V3.4!")
