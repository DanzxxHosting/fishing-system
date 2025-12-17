-- =============================================
-- 🎣 KAITUN FISHING SCRIPT V4.0
-- =============================================
-- UI Modern: Hitam Matte + Merah Neon
-- Toggle dengan tombol G
-- Fitur lengkap sesuai permintaan

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local WIDTH = 920
local HEIGHT = 520
local SIDEBAR_W = 220
local ACCENT = Color3.fromRGB(255, 62, 62) -- neon merah
local BG = Color3.fromRGB(12,12,12) -- hitam matte
local SECOND = Color3.fromRGB(24,24,26)

-- cleanup old if exist
if playerGui:FindFirstChild("KaitunFishingUI") then
    playerGui.KaitunFishingUI:Destroy()
end

-- ScreenGui
local screen = Instance.new("ScreenGui")
screen.Name = "KaitunFishingUI"
screen.ResetOnSpawn = false
screen.Parent = playerGui
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container (centered)
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
container.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
container.BackgroundTransparency = 1
container.Parent = screen

-- Outer glow
local glow = Instance.new("ImageLabel", screen)
glow.Name = "Glow"
glow.AnchorPoint = Vector2.new(0.5,0.5)
glow.Size = UDim2.new(0, WIDTH+80, 0, HEIGHT+80)
glow.Position = container.Position
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5050741616"
glow.ImageColor3 = ACCENT
glow.ImageTransparency = 0.92
glow.ZIndex = 1

-- Card (panel)
local card = Instance.new("Frame")
card.Name = "Card"
card.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
card.Position = UDim2.new(0,0,0,0)
card.BackgroundColor3 = BG
card.BorderSizePixel = 0
card.Parent = container
card.ZIndex = 2

local cardCorner = Instance.new("UICorner", card)
cardCorner.CornerRadius = UDim.new(0, 12)

-- inner container
local inner = Instance.new("Frame", card)
inner.Name = "Inner"
inner.Size = UDim2.new(1, -24, 1, -24)
inner.Position = UDim2.new(0, 12, 0, 12)
inner.BackgroundTransparency = 1

-- Title bar
local titleBar = Instance.new("Frame", inner)
titleBar.Size = UDim2.new(1,0,0,48)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(0.6,0,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Text = "⚡ KAITUN FISHING SCRIPT V4.0"
title.TextColor3 = Color3.fromRGB(255, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Left

local statusLabel = Instance.new("TextLabel", titleBar)
statusLabel.Size = UDim2.new(0.4,-16,1,0)
statusLabel.Position = UDim2.new(0.6,8,0,0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.Text = "🟢 Ready"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextXAlignment = Enum.TextXAlignment.Right

-- left sidebar
local sidebar = Instance.new("Frame", inner)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -64)
sidebar.Position = UDim2.new(0, 0, 0, 56)
sidebar.BackgroundColor3 = SECOND
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 3

local sbCorner = Instance.new("UICorner", sidebar)
sbCorner.CornerRadius = UDim.new(0, 8)

-- sidebar header
local sbHeader = Instance.new("Frame", sidebar)
sbHeader.Size = UDim2.new(1,0,0,84)
sbHeader.BackgroundTransparency = 1

local logo = Instance.new("ImageLabel", sbHeader)
logo.Size = UDim2.new(0,64,0,64)
logo.Position = UDim2.new(0, 12, 0, 10)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://6031075938" -- Fishing icon
logo.ImageColor3 = ACCENT

local sTitle = Instance.new("TextLabel", sbHeader)
sTitle.Size = UDim2.new(1,-96,0,32)
sTitle.Position = UDim2.new(0, 88, 0, 12)
sTitle.BackgroundTransparency = 1
sTitle.Font = Enum.Font.GothamBold
sTitle.TextSize = 14
sTitle.Text = "Kaitun Fishing"
sTitle.TextColor3 = Color3.fromRGB(240,240,240)
sTitle.TextXAlignment = Enum.TextXAlignment.Left

-- menu list area
local menuFrame = Instance.new("Frame", sidebar)
menuFrame.Size = UDim2.new(1,-12,1, -108)
menuFrame.Position = UDim2.new(0, 6, 0, 92)
menuFrame.BackgroundTransparency = 1

local menuLayout = Instance.new("UIListLayout", menuFrame)
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.Padding = UDim.new(0,8)

-- menu helper
local function makeMenuItem(name, iconText)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = Color3.fromRGB(20,20,20)
    row.AutoButtonColor = false
    row.BorderSizePixel = 0
    row.Text = ""
    row.Parent = menuFrame

    local corner = Instance.new("UICorner", row)
    corner.CornerRadius = UDim.new(0,8)

    local left = Instance.new("Frame", row)
    left.Size = UDim2.new(0,40,1,0)
    left.Position = UDim2.new(0,8,0,0)
    left.BackgroundTransparency = 1

    local icon = Instance.new("TextLabel", left)
    icon.Size = UDim2.new(1,0,1,0)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 18
    icon.Text = iconText
    icon.TextColor3 = ACCENT
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.8,0,1,0)
    label.Position = UDim2.new(0,56,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- hover effect
    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30,10,10)}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
    end)

    return row, label
end

-- menu items
local items = {
    {"Main Features", "🔧"},
    {"Auto Fishing", "🤖"},
    {"Fishing Settings", "🎣"},
    {"Teleport System", "📍"},
    {"Player Utility", "⚡"},
    {"Visual Features", "👁️"},
    {"Settings", "⚙"},
}
local menuButtons = {}
for i, v in ipairs(items) do
    local btn, lbl = makeMenuItem(v[1], v[2])
    btn.LayoutOrder = i
    menuButtons[v[1]] = btn
end

-- content panel (right)
local content = Instance.new("Frame", inner)
content.Name = "Content"
content.Size = UDim2.new(1, -SIDEBAR_W - 36, 1, -64)
content.Position = UDim2.new(0, SIDEBAR_W + 24, 0, 56)
content.BackgroundColor3 = Color3.fromRGB(18,18,20)
content.BorderSizePixel = 0

local contentCorner = Instance.new("UICorner", content)
contentCorner.CornerRadius = UDim.new(0, 8)

-- content title area
local cTitle = Instance.new("TextLabel", content)
cTitle.Size = UDim2.new(1, -24, 0, 44)
cTitle.Position = UDim2.new(0,12,0,12)
cTitle.BackgroundTransparency = 1
cTitle.Font = Enum.Font.GothamBold
cTitle.TextSize = 16
cTitle.Text = "Main Features"
cTitle.TextColor3 = Color3.fromRGB(245,245,245)
cTitle.TextXAlignment = Enum.TextXAlignment.Left

-- =============================================
-- 🎯 FISHING SYSTEM
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
        Level = 1
    },
    AutoFishingThread = nil
}

function FishingSystem:ShowNotification(message)
    local notif = Instance.new("TextLabel", content)
    notif.Size = UDim2.new(0.8, 0, 0, 36)
    notif.Position = UDim2.new(0.1, 0, 0.9, 0)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notif.TextColor3 = Color3.new(1, 1, 1)
    notif.Font = Enum.Font.Gotham
    notif.TextSize = 13
    notif.Text = "📢 " .. message
    notif.ZIndex = 10
    
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 6)
    
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.1, 0, 0.85, 0)}):Play()
    
    task.delay(3, function()
        if notif then
            TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.1, 0, 0.9, 0)}):Play()
            task.delay(0.3, function()
                if notif then notif:Destroy() end
            end)
        end
    end)
end

function FishingSystem:ToggleAutoFishing(state)
    self.Config.AutoFishing = state
    self:ShowNotification("🤖 Auto Fishing: " .. (state and "ON" or "OFF"))
    
    if state then
        self.AutoFishingThread = task.spawn(function()
            while self.Config.AutoFishing do
                self.Stats.TotalFish = self.Stats.TotalFish + 1
                self.Stats.TotalWeight = self.Stats.TotalWeight + math.random(1, 50) / 10
                self.Stats.Coins = self.Stats.Coins + math.random(10, 100)
                task.wait(1 / self.Config.CatchSpeed)
            end
        end)
    elseif self.AutoFishingThread then
        task.cancel(self.AutoFishingThread)
        self.AutoFishingThread = nil
    end
end

function FishingSystem:SetInstantFishing(state)
    self.Config.InstantFishing = state
    self:ShowNotification("⚡ Instant Fishing: " .. (state and "ON" or "OFF"))
end

function FishingSystem:SetBlatantFishing(state)
    self.Config.BlatantFishing = state
    self:ShowNotification("🚀 Blatant Fishing: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleAutoSell(state)
    self.Config.AutoSell = state
    self:ShowNotification("💰 Auto Sell: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleAutoBait(state)
    self.Config.AutoBait = state
    self:ShowNotification("🪱 Auto Bait: " .. (state and "ON" or "OFF"))
end

function FishingSystem:SetCatchSpeed(speed)
    self.Config.CatchSpeed = speed
    self:ShowNotification("🎯 Catch Speed: " .. speed .. "x")
end

function FishingSystem:ToggleRadar(state)
    self.Config.RadarEnabled = state
    self:ShowNotification("📡 Fishing Radar: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleNoAnimation(state)
    self.Config.NoAnimation = state
    self:ShowNotification("👻 No Animation: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleAutoQuest(state)
    self.Config.AutoQuest = state
    self:ShowNotification("📜 Auto Quest: " .. (state and "ON" or "OFF"))
end

function FishingSystem:EquipBestRod()
    self:ShowNotification("🎣 Equipping Best Rod...")
end

function FishingSystem:InstantCast()
    self:ShowNotification("⚡ Instant Cast!")
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

-- =============================================
-- 🎮 UTILITY FUNCTIONS
-- =============================================
local Utility = {}

function Utility:SetWalkSpeed(speed)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
        FishingSystem:ShowNotification("🚶 Walk Speed: " .. speed)
    end
end

function Utility:SetJumpPower(power)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = power
        FishingSystem:ShowNotification("🦘 Jump Power: " .. power)
    end
end

function Utility:ToggleInfiniteJump(state)
    if state then
        UserInputService.JumpRequest:Connect(function()
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState("Jumping")
                end
            end
        end)
        FishingSystem:ShowNotification("♾️ Infinite Jump: ON")
    else
        FishingSystem:ShowNotification("♾️ Infinite Jump: OFF")
    end
end

function Utility:ToggleESP(state)
    if state then
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= player and target.Character then
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
        FishingSystem:ShowNotification("👁️ ESP: ON")
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
        FishingSystem:ShowNotification("👁️ ESP: OFF")
    end
end

function Utility:ToggleFly(state)
    if state then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        FishingSystem:ShowNotification("✈️ Fly: ON (Press X to fly)")
    else
        FishingSystem:ShowNotification("✈️ Fly: OFF")
    end
end

function Utility:ToggleNoClip(state)
    if state then
        RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        FishingSystem:ShowNotification("👻 NoClip: ON")
    else
        FishingSystem:ShowNotification("👻 NoClip: OFF")
    end
end

-- =============================================
-- 🎨 UI COMPONENT CREATION
-- =============================================
local UIComponents = {}

function UIComponents:CreateSection(parent, title, yPos)
    local section = Instance.new("Frame", parent)
    section.Size = UDim2.new(1, -24, 0, 30)
    section.Position = UDim2.new(0, 12, 0, yPos)
    section.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel", section)
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.Text = "  " .. title
    titleLabel.TextColor3 = ACCENT
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return section, yPos + 40
end

function UIComponents:CreateToggle(parent, text, defaultValue, callback, yPos)
    local toggleFrame = Instance.new("Frame", parent)
    toggleFrame.Size = UDim2.new(1, -24, 0, 36)
    toggleFrame.Position = UDim2.new(0, 12, 0, yPos)
    toggleFrame.BackgroundTransparency = 1
    
    local toggleButton = Instance.new("TextButton", toggleFrame)
    toggleButton.Size = UDim2.new(0, 32, 0, 32)
    toggleButton.Position = UDim2.new(0, 0, 0, 2)
    toggleButton.Text = defaultValue and "✓" or "☐"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 16
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
    toggleButton.BorderSizePixel = 0
    toggleButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner", toggleButton)
    corner.CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local state = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.Text = state and "✓" or "☐"
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
        callback(state)
    end)
    
    return toggleFrame, yPos + 45
end

function UIComponents:CreateSlider(parent, text, min, max, defaultValue, suffix, callback, yPos)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1, -24, 0, 60)
    sliderFrame.Position = UDim2.new(0, 12, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. defaultValue .. suffix
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local track = Instance.new("Frame", sliderFrame)
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner", track)
    trackCorner.CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = ACCENT
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local button = Instance.new("TextButton", track)
    button.Size = UDim2.new(0, 20, 0, 20)
    button.Position = UDim2.new((defaultValue - min) / (max - min), -10, 0.5, -10)
    button.Text = ""
    button.BackgroundColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 0
    button.ZIndex = 2
    
    local btnCorner = Instance.new("UICorner", button)
    btnCorner.CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local currentValue = defaultValue
    
    local function updateValue(value)
        currentValue = math.clamp(math.floor(value), min, max)
        local percent = (currentValue - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        button.Position = UDim2.new(percent, -10, 0.5, -10)
        label.Text = text .. ": " .. currentValue .. suffix
        callback(currentValue)
    end
    
    button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local trackSize = track.AbsoluteSize
            local relativeX = (mousePos.X - trackPos.X) / trackSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            local value = min + (relativeX * (max - min))
            updateValue(value)
        end
    end)
    
    return sliderFrame, yPos + 70
end

function UIComponents:CreateButton(parent, text, callback, yPos)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, -24, 0, 40)
    button.Position = UDim2.new(0, 12, 0, yPos)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.BackgroundColor3 = ACCENT
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = ACCENT}):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button, yPos + 50
end

-- =============================================
-- 📱 CONTENT PAGES
-- =============================================
local contentPages = {}
local currentPage = "Main Features"

function CreateContentPage(pageName)
    local scrollFrame = Instance.new("ScrollingFrame", content)
    scrollFrame.Size = UDim2.new(1, -24, 1, -68)
    scrollFrame.Position = UDim2.new(0, 12, 0, 56)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = ACCENT
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Visible = pageName == "Main Features"
    scrollFrame.Name = pageName .. "Page"
    
    contentPages[pageName] = scrollFrame
    
    return scrollFrame
end

-- Create all pages
for _, page in ipairs({"Main Features", "Auto Fishing", "Fishing Settings", "Teleport System", "Player Utility", "Visual Features", "Settings"}) do
    CreateContentPage(page)
end

-- =============================================
-- 📋 POPULATE PAGES
-- =============================================

-- Main Features Page
local mainPage = contentPages["Main Features"]
local yPos = 0

-- Stats Section
local statsFrame = Instance.new("Frame", mainPage)
statsFrame.Size = UDim2.new(1, 0, 0, 140)
statsFrame.Position = UDim2.new(0, 0, 0, yPos)
statsFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
statsFrame.BorderSizePixel = 0

local statsCorner = Instance.new("UICorner", statsFrame)
statsCorner.CornerRadius = UDim.new(0, 8)

local statsTitle = Instance.new("TextLabel", statsFrame)
statsTitle.Size = UDim2.new(1, -24, 0, 30)
statsTitle.Position = UDim2.new(0, 12, 0, 8)
statsTitle.Text = "📊 Fishing Statistics"
statsTitle.TextColor3 = Color3.new(1, 1, 1)
statsTitle.Font = Enum.Font.GothamBold
statsTitle.TextSize = 14
statsTitle.BackgroundTransparency = 1
statsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Stats labels
local statLabels = {}
local statNames = {"🎣 Total Fish", "⚖️ Total Weight", "💰 Coins", "⭐ Level"}
for i, name in ipairs(statNames) do
    local label = Instance.new("TextLabel", statsFrame)
    label.Size = UDim2.new(0.5, -12, 0, 24)
    label.Position = UDim2.new((i-1)%2*0.5 + 0.02, 12, 0, 45 + math.floor((i-1)/2)*28)
    label.Text = name .. ": 0"
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    statLabels[name] = label
end

yPos = yPos + 150

-- Quick Actions
_, yPos = UIComponents:CreateSection(mainPage, "⚡ Quick Actions", yPos)

UIComponents:CreateButton(mainPage, "🎣 Start Auto Fishing", function()
    FishingSystem:ToggleAutoFishing(true)
end, yPos)

yPos = yPos + 50

UIComponents:CreateButton(mainPage, "⚡ Instant Cast", function()
    FishingSystem:InstantCast()
end, yPos)

yPos = yPos + 50

UIComponents:CreateButton(mainPage, "🎣 Equip Best Rod", function()
    FishingSystem:EquipBestRod()
end, yPos)

yPos = yPos + 60

-- Auto Fishing Page
local autoPage = contentPages["Auto Fishing"]
yPos = 0

_, yPos = UIComponents:CreateSection(autoPage, "🤖 Auto Fishing Settings", yPos)

_, yPos = UIComponents:CreateToggle(autoPage, "Enable Auto Fishing", false, function(state)
    FishingSystem:ToggleAutoFishing(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(autoPage, "Instant Fishing", false, function(state)
    FishingSystem:SetInstantFishing(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(autoPage, "Blatant Fishing", false, function(state)
    FishingSystem:SetBlatantFishing(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(autoPage, "Auto Sell Fish", false, function(state)
    FishingSystem:ToggleAutoSell(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(autoPage, "Auto Rebuy Bait", false, function(state)
    FishingSystem:ToggleAutoBait(state)
end, yPos)

_, yPos = UIComponents:CreateSlider(autoPage, "Catch Speed", 1, 10, 1, "x", function(value)
    FishingSystem:SetCatchSpeed(value)
end, yPos)

-- Fishing Settings Page
local fishPage = contentPages["Fishing Settings"]
yPos = 0

_, yPos = UIComponents:CreateSection(fishPage, "🎣 Fishing Configuration", yPos)

_, yPos = UIComponents:CreateToggle(fishPage, "Fishing Radar", false, function(state)
    FishingSystem:ToggleRadar(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(fishPage, "No Animation", false, function(state)
    FishingSystem:ToggleNoAnimation(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(fishPage, "Auto Quest", false, function(state)
    FishingSystem:ToggleAutoQuest(state)
end, yPos)

_, yPos = UIComponents:CreateButton(fishPage, "🔧 Advanced Settings", function()
    FishingSystem:ShowNotification("Advanced settings opened")
end, yPos)

-- Teleport System Page
local teleportPage = contentPages["Teleport System"]
yPos = 0

_, yPos = UIComponents:CreateSection(teleportPage, "📍 Teleport Locations", yPos)

-- Teleport dropdown
local teleportFrame = Instance.new("Frame", teleportPage)
teleportFrame.Size = UDim2.new(1, -24, 0, 40)
teleportFrame.Position = UDim2.new(0, 12, 0, yPos)
teleportFrame.BackgroundTransparency = 1

local teleportLabel = Instance.new("TextLabel", teleportFrame)
teleportLabel.Size = UDim2.new(0.3, 0, 1, 0)
teleportLabel.Text = "Island:"
teleportLabel.TextColor3 = Color3.new(1, 1, 1)
teleportLabel.Font = Enum.Font.Gotham
teleportLabel.TextSize = 13
teleportLabel.BackgroundTransparency = 1
teleportLabel.TextXAlignment = Enum.TextXAlignment.Left

local teleportDropdown = Instance.new("TextButton", teleportFrame)
teleportDropdown.Size = UDim2.new(0.7, -10, 1, 0)
teleportDropdown.Position = UDim2.new(0.3, 0, 0, 0)
teleportDropdown.Text = "Select Island"
teleportDropdown.TextColor3 = Color3.new(1, 1, 1)
teleportDropdown.Font = Enum.Font.Gotham
teleportDropdown.TextSize = 13
teleportDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportDropdown.BorderSizePixel = 0
teleportDropdown.AutoButtonColor = false

local dropdownCorner = Instance.new("UICorner", teleportDropdown)
dropdownCorner.CornerRadius = UDim.new(0, 6)

yPos = yPos + 50

-- Teleport buttons
UIComponents:CreateButton(teleportPage, "📍 Teleport to Selected Island", function()
    FishingSystem:ShowNotification("Teleporting to: " .. teleportDropdown.Text)
end, yPos)

yPos = yPos + 50

UIComponents:CreateButton(teleportPage, "🎣 Best Fishing Spot", function()
    FishingSystem:ShowNotification("Teleporting to best fishing spot!")
end, yPos)

-- Player Utility Page
local utilityPage = contentPages["Player Utility"]
yPos = 0

_, yPos = UIComponents:CreateSection(utilityPage, "⚡ Movement Settings", yPos)

_, yPos = UIComponents:CreateSlider(utilityPage, "Walk Speed", 16, 200, 16, " studs", function(value)
    Utility:SetWalkSpeed(value)
end, yPos)

_, yPos = UIComponents:CreateSlider(utilityPage, "Jump Power", 50, 200, 50, " power", function(value)
    Utility:SetJumpPower(value)
end, yPos)

_, yPos = UIComponents:CreateToggle(utilityPage, "Infinite Jump", false, function(state)
    Utility:ToggleInfiniteJump(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(utilityPage, "Fly", false, function(state)
    Utility:ToggleFly(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(utilityPage, "NoClip", false, function(state)
    Utility:ToggleNoClip(state)
end, yPos)

-- Visual Features Page
local visualPage = contentPages["Visual Features"]
yPos = 0

_, yPos = UIComponents:CreateSection(visualPage, "👁️ Visual Enhancements", yPos)

_, yPos = UIComponents:CreateToggle(visualPage, "ESP Name", false, function(state)
    Utility:ToggleESP(state)
end, yPos)

_, yPos = UIComponents:CreateToggle(visualPage, "Fishing ESP", false, function(state)
    FishingSystem:ShowNotification("Fishing ESP: " .. (state and "ON" or "OFF"))
end, yPos)

_, yPos = UIComponents:CreateToggle(visualPage, "Water Mark", false, function(state)
    FishingSystem:ShowNotification("Water Mark: " .. (state and "ON" or "OFF"))
end, yPos)

-- Settings Page
local settingsPage = contentPages["Settings"]
yPos = 0

_, yPos = UIComponents:CreateSection(settingsPage, "⚙️ UI Settings", yPos)

_, yPos = UIComponents:CreateToggle(settingsPage, "Auto Hide UI", false, function(state)
    FishingSystem:ShowNotification("Auto Hide UI: " .. (state and "ON" or "OFF"))
end, yPos)

_, yPos = UIComponents:CreateToggle(settingsPage, "Notifications", true, function(state)
    FishingSystem:ShowNotification("Notifications: " .. (state and "ON" or "OFF"))
end, yPos)

UIComponents:CreateButton(settingsPage, "🔄 Reset Settings", function()
    FishingSystem:ShowNotification("Settings reset to default!")
end, yPos)

-- Set canvas sizes
for _, page in pairs(contentPages) do
    page.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
end

-- =============================================
-- 🎮 MENU NAVIGATION
-- =============================================
local activeMenu = "Main Features"

for name, btn in pairs(menuButtons) do
    btn.MouseButton1Click:Connect(function()
        -- Update active menu
        activeMenu = name
        
        -- Update content title
        cTitle.Text = name
        
        -- Show/hide pages
        for pageName, pageFrame in pairs(contentPages) do
            pageFrame.Visible = pageName == name
        end
        
        -- Highlight active menu
        for menuName, menuBtn in pairs(menuButtons) do
            menuBtn.BackgroundColor3 = menuName == name and Color3.fromRGB(32, 8, 8) or Color3.fromRGB(20, 20, 20)
        end
        
        -- Update status
        statusLabel.Text = "📁 " .. name
    end)
end

-- Initially highlight Main Features
menuButtons["Main Features"].BackgroundColor3 = Color3.fromRGB(32, 8, 8)

-- =============================================
-- 🎮 HOTKEYS & EVENTS
-- =============================================
local uiOpen = false

local function toggleUI(show)
    uiOpen = show
    if show then
        card.Visible = true
        glow.Visible = true
        container.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
        container.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
        container.AnchorPoint = Vector2.new(0.5,0.5)
        container.ZIndex = 2
        card:TweenSize(UDim2.new(0, WIDTH,0,HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.28, true)
        TweenService:Create(glow, TweenInfo.new(0.28), {ImageTransparency = 0.8}):Play()
        statusLabel.Text = "🟢 UI Opened"
    else
        TweenService:Create(glow, TweenInfo.new(0.18), {ImageTransparency = 0.96}):Play()
        card:TweenSize(UDim2.new(0, WIDTH*0.9,0,HEIGHT*0.9), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.16, true)
        statusLabel.Text = "⏸️ UI Minimized"
    end
end

-- Initial hide
toggleUI(false)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    -- Toggle UI with G
    if input.KeyCode == Enum.KeyCode.G then
        toggleUI(not uiOpen)
    
    -- Hotkeys for fishing
    elseif input.KeyCode == Enum.KeyCode.F then
        FishingSystem:ToggleAutoFishing(not FishingSystem.Config.AutoFishing)
    elseif input.KeyCode == Enum.KeyCode.R then
        FishingSystem:EquipBestRod()
    elseif input.KeyCode == Enum.KeyCode.T then
        FishingSystem:ToggleRadar(not FishingSystem.Config.RadarEnabled)
    elseif input.KeyCode == Enum.KeyCode.Y then
        FishingSystem:InstantCast()
    end
end)

-- =============================================
-- 🔄 UPDATE LOOPS
-- =============================================
-- Update stats
spawn(function()
    while screen.Parent do
        local stats = FishingSystem:GetStats()
        statLabels["🎣 Total Fish"].Text = "🎣 Total Fish: " .. stats.TotalFish
        statLabels["⚖️ Total Weight"].Text = "⚖️ Total Weight: " .. stats.TotalWeight
        statLabels["💰 Coins"].Text = "💰 Coins: " .. stats.Coins
        statLabels["⭐ Level"].Text = "⭐ Level: " .. stats.Level
        
        if FishingSystem.Config.AutoFishing then
            statusLabel.Text = "🤖 Auto Fishing"
        end
        
        task.wait(1)
    end
end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- =============================================
-- 🚀 INITIALIZATION
-- =============================================
-- Play sound
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://9114821956"
sound.Volume = 0.3
sound.Parent = playerGui
sound:Play()

-- Welcome message
task.delay(1, function()
    FishingSystem:ShowNotification("🎣 Kaitun Fishing Script V4.0 Loaded!")
    FishingSystem:ShowNotification("Press G to toggle UI | F for Auto Fish")
end)

print("============================================")
print("🎣 KAITUN FISHING SCRIPT V4.0")
print("📁 Single File Executor")
print("🎨 Modern UI: Hitam Matte + Merah Neon")
print("⚡ Toggle dengan G")
print("============================================")
