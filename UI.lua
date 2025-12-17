-- =============================================
-- 🎣 KAITUN FISHING SCRIPT V4.0 - COMPACT UI
-- =============================================
-- UI Compact: Hitam Matte + Merah Neon
-- Toggle dengan tombol UI, tanpa hotkeys

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG - UKURAN LEBIH KECIL
local WIDTH = 700  -- Diperkecil dari 920
local HEIGHT = 500 -- Diperkecil dari 520
local SIDEBAR_W = 180  -- Diperkecil dari 220
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
screen.IgnoreGuiInset = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container (positioned at top right)
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
container.Position = UDim2.new(1, -WIDTH - 10, 0.5, -HEIGHT/2) -- Posisi kanan atas
container.BackgroundTransparency = 1
container.Parent = screen

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
cardCorner.CornerRadius = UDim.new(0, 8)

-- inner container
local inner = Instance.new("Frame", card)
inner.Name = "Inner"
inner.Size = UDim2.new(1, -16, 1, -16)
inner.Position = UDim2.new(0, 8, 0, 8)
inner.BackgroundTransparency = 1

-- Title bar dengan close button
local titleBar = Instance.new("Frame", inner)
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(0.8,0,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Text = "🎣 KAITUN FISHING"
title.TextColor3 = Color3.fromRGB(255, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 80, 0, 30)
closeButton.Position = UDim2.new(1, -88, 0.5, -15)
closeButton.Text = "❌ Close"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.ZIndex = 3

local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 6)

-- left sidebar
local sidebar = Instance.new("Frame", inner)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -56)
sidebar.Position = UDim2.new(0, 0, 0, 48)
sidebar.BackgroundColor3 = SECOND
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 3

local sbCorner = Instance.new("UICorner", sidebar)
sbCorner.CornerRadius = UDim.new(0, 6)

-- sidebar header
local sbHeader = Instance.new("Frame", sidebar)
sbHeader.Size = UDim2.new(1,0,0,60)
sbHeader.BackgroundTransparency = 1

local sTitle = Instance.new("TextLabel", sbHeader)
sTitle.Size = UDim2.new(1,-16,1,0)
sTitle.Position = UDim2.new(0, 8, 0, 0)
sTitle.BackgroundTransparency = 1
sTitle.Font = Enum.Font.GothamBold
sTitle.TextSize = 14
sTitle.Text = "Navigation"
sTitle.TextColor3 = ACCENT
sTitle.TextXAlignment = Enum.TextXAlignment.Left

-- menu list area
local menuFrame = Instance.new("Frame", sidebar)
menuFrame.Size = UDim2.new(1,-8,1, -76)
menuFrame.Position = UDim2.new(0, 4, 0, 68)
menuFrame.BackgroundTransparency = 1

local menuLayout = Instance.new("UIListLayout", menuFrame)
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.Padding = UDim.new(0,6)

-- menu helper
local function makeMenuItem(name, iconText)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(20,20,20)
    row.AutoButtonColor = false
    row.BorderSizePixel = 0
    row.Text = ""
    row.Parent = menuFrame

    local corner = Instance.new("UICorner", row)
    corner.CornerRadius = UDim.new(0,6)

    local left = Instance.new("Frame", row)
    left.Size = UDim2.new(0,32,1,0)
    left.Position = UDim2.new(0,4,0,0)
    left.BackgroundTransparency = 1

    local icon = Instance.new("TextLabel", left)
    icon.Size = UDim2.new(1,0,1,0)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 16
    icon.Text = iconText
    icon.TextColor3 = ACCENT
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.8,0,1,0)
    label.Position = UDim2.new(0,40,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- hover effect
    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30,10,10)}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
    end)

    return row, label
end

-- menu items (hanya yang penting)
local items = {
    {"Main", "🏠"},
    {"Auto Fish", "🤖"},
    {"Fishing", "🎣"},
    {"Teleport", "📍"},
    {"Player", "⚡"},
    {"Visual", "👁️"},
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
content.Size = UDim2.new(1, -SIDEBAR_W - 24, 1, -56)
content.Position = UDim2.new(0, SIDEBAR_W + 16, 0, 48)
content.BackgroundColor3 = Color3.fromRGB(18,18,20)
content.BorderSizePixel = 0

local contentCorner = Instance.new("UICorner", content)
contentCorner.CornerRadius = UDim.new(0, 6)

-- content title area
local cTitle = Instance.new("TextLabel", content)
cTitle.Size = UDim2.new(1, -16, 0, 32)
cTitle.Position = UDim2.new(0,8,0,8)
cTitle.BackgroundTransparency = 1
cTitle.Font = Enum.Font.GothamBold
cTitle.TextSize = 15
cTitle.Text = "Main Dashboard"
cTitle.TextColor3 = Color3.fromRGB(245,245,245)
cTitle.TextXAlignment = Enum.TextXAlignment.Left

-- =============================================
-- 🎯 FISHING SYSTEM (SIMPLIFIED)
-- =============================================
local FishingSystem = {
    Config = {
        AutoFishing = false,
        InstantFishing = false,
        AutoSell = false,
        CatchSpeed = 1,
        Radar = false,
        NoAnimation = false,
    },
    Stats = {
        TotalFish = 0,
        TotalWeight = 0,
        BiggestFish = "None",
        Coins = 1000,
        Level = 1
    },
    AutoThread = nil
}

function FishingSystem:Notify(msg)
    -- Simple notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎣 Fishing Script",
        Text = msg,
        Duration = 3
    })
end

function FishingSystem:ToggleAutoFishing(state)
    self.Config.AutoFishing = state
    self:Notify("Auto Fishing: " .. (state and "ON" or "OFF"))
    
    if state then
        self.AutoThread = task.spawn(function()
            while self.Config.AutoFishing do
                self.Stats.TotalFish = self.Stats.TotalFish + 1
                self.Stats.TotalWeight = self.Stats.TotalWeight + math.random(1, 30) / 10
                self.Stats.Coins = self.Stats.Coins + math.random(5, 50)
                task.wait(1 / self.Config.CatchSpeed)
            end
        end)
    elseif self.AutoThread then
        task.cancel(self.AutoThread)
        self.AutoThread = nil
    end
end

function FishingSystem:SetInstantFishing(state)
    self.Config.InstantFishing = state
    self:Notify("Instant Fishing: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleAutoSell(state)
    self.Config.AutoSell = state
    self:Notify("Auto Sell: " .. (state and "ON" or "OFF"))
end

function FishingSystem:SetCatchSpeed(speed)
    self.Config.CatchSpeed = speed
    self:Notify("Catch Speed: " .. speed .. "x")
end

function FishingSystem:ToggleRadar(state)
    self.Config.Radar = state
    self:Notify("Radar: " .. (state and "ON" or "OFF"))
end

function FishingSystem:ToggleNoAnimation(state)
    self.Config.NoAnimation = state
    self:Notify("No Animation: " .. (state and "ON" or "OFF"))
end

function FishingSystem:EquipBestRod()
    self:Notify("Equipping best rod...")
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
        FishingSystem:Notify("Walk Speed: " .. speed)
    end
end

function Utility:SetJumpPower(power)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = power
        FishingSystem:Notify("Jump Power: " .. power)
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
        FishingSystem:Notify("Infinite Jump: ON")
    else
        FishingSystem:Notify("Infinite Jump: OFF")
    end
end

function Utility:ToggleESP(state)
    if state then
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= player and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 80, 0, 30)
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
        FishingSystem:Notify("ESP: ON")
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
        FishingSystem:Notify("ESP: OFF")
    end
end

function Utility:ToggleFly(state)
    if state then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        FishingSystem:Notify("Fly: ON")
    else
        FishingSystem:Notify("Fly: OFF")
    end
end

function Utility:ToggleNoClip(state)
    if state then
        local conn
        conn = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        FishingSystem:Notify("NoClip: ON")
    else
        FishingSystem:Notify("NoClip: OFF")
    end
end

-- =============================================
-- 🎨 UI COMPONENT CREATION
-- =============================================
local UIComponents = {}

function UIComponents:CreateSection(parent, title, yPos)
    local section = Instance.new("Frame", parent)
    section.Size = UDim2.new(1, -16, 0, 24)
    section.Position = UDim2.new(0, 8, 0, yPos)
    section.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel", section)
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.Text = "  " .. title
    titleLabel.TextColor3 = ACCENT
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return section, yPos + 30
end

function UIComponents:CreateToggle(parent, text, defaultValue, callback, yPos)
    local toggleFrame = Instance.new("Frame", parent)
    toggleFrame.Size = UDim2.new(1, -16, 0, 28)
    toggleFrame.Position = UDim2.new(0, 8, 0, yPos)
    toggleFrame.BackgroundTransparency = 1
    
    local toggleButton = Instance.new("TextButton", toggleFrame)
    toggleButton.Size = UDim2.new(0, 24, 0, 24)
    toggleButton.Position = UDim2.new(0, 0, 0, 2)
    toggleButton.Text = defaultValue and "✓" or "☐"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 14
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
    toggleButton.BorderSizePixel = 0
    toggleButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner", toggleButton)
    corner.CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local state = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.Text = state and "✓" or "☐"
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
        callback(state)
    end)
    
    return toggleFrame, yPos + 35
end

function UIComponents:CreateSlider(parent, text, min, max, defaultValue, suffix, callback, yPos)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1, -16, 0, 50)
    sliderFrame.Position = UDim2.new(0, 8, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Text = text .. ": " .. defaultValue .. suffix
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local track = Instance.new("Frame", sliderFrame)
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0, 25)
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
    button.Size = UDim2.new(0, 16, 0, 16)
    button.Position = UDim2.new((defaultValue - min) / (max - min), -8, 0.5, -8)
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
        button.Position = UDim2.new(percent, -8, 0.5, -8)
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
    
    return sliderFrame, yPos + 60
end

function UIComponents:CreateButton(parent, text, callback, yPos)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, -16, 0, 32)
    button.Position = UDim2.new(0, 8, 0, yPos)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
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
    
    return button, yPos + 40
end

-- =============================================
-- 📱 CREATE CONTENT PAGES
-- =============================================
local contentPages = {}
local currentPage = "Main"

-- Fungsi untuk membuat halaman
local function createPage(pageName)
    local scrollFrame = Instance.new("ScrollingFrame", content)
    scrollFrame.Size = UDim2.new(1, -16, 1, -48)
    scrollFrame.Position = UDim2.new(0, 8, 0, 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = ACCENT
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Visible = false
    scrollFrame.Name = pageName .. "Page"
    
    contentPages[pageName] = scrollFrame
    return scrollFrame
end

-- =============================================
-- 📋 MAIN PAGE
-- =============================================
local mainPage = createPage("Main")
mainPage.Visible = true

-- Stats Card
local statsCard = Instance.new("Frame", mainPage)
statsCard.Size = UDim2.new(1, 0, 0, 100)
statsCard.Position = UDim2.new(0, 0, 0, 0)
statsCard.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
statsCard.BorderSizePixel = 0

local statsCorner = Instance.new("UICorner", statsCard)
statsCorner.CornerRadius = UDim.new(0, 6)

local statsTitle = Instance.new("TextLabel", statsCard)
statsTitle.Size = UDim2.new(1, -12, 0, 24)
statsTitle.Position = UDim2.new(0, 6, 0, 6)
statsTitle.Text = "📊 Fishing Stats"
statsTitle.TextColor3 = Color3.new(1, 1, 1)
statsTitle.Font = Enum.Font.GothamBold
statsTitle.TextSize = 13
statsTitle.BackgroundTransparency = 1
statsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Stats labels
local statLabels = {}
local yOffset = 35
local statData = {
    {"🎣 Fish:", "0"},
    {"⚖️ Weight:", "0kg"},
    {"💰 Coins:", "1000"},
    {"⭐ Level:", "1"}
}

for i, data in ipairs(statData) do
    local label = Instance.new("TextLabel", statsCard)
    label.Size = UDim2.new(0.5, -10, 0, 20)
    label.Position = UDim2.new((i-1)%2*0.5 + 0.02, 8, 0, yOffset + math.floor((i-1)/2)*22)
    label.Text = data[1] .. " " .. data[2]
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    statLabels[data[1]] = label
end

-- Quick Actions
local yPos = 110
UIComponents:CreateSection(mainPage, "⚡ Quick Actions", yPos)
yPos = yPos + 30

-- Quick action buttons
local quickActions = {
    {"🤖 Start Auto Fish", function() FishingSystem:ToggleAutoFishing(true) end},
    {"🎣 Equip Best Rod", function() FishingSystem:EquipBestRod() end},
    {"⚡ Instant Cast", function() FishingSystem:Notify("Instant Cast!") end},
    {"📡 Toggle Radar", function() FishingSystem:ToggleRadar(not FishingSystem.Config.Radar) end}
}

for i, action in ipairs(quickActions) do
    local btn = Instance.new("TextButton", mainPage)
    btn.Size = UDim2.new(0.5, -10, 0, 28)
    btn.Position = UDim2.new((i-1)%2*0.5 + 0.02, 8, 0, yPos + math.floor((i-1)/2)*32)
    btn.Text = action[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(action[2])
end

mainPage.CanvasSize = UDim2.new(0, 0, 0, yPos + 80)

-- =============================================
-- 🤖 AUTO FISH PAGE
-- =============================================
local autoPage = createPage("Auto Fish")
local yPosAuto = 0

UIComponents:CreateSection(autoPage, "🤖 Auto Fishing", yPosAuto)
yPosAuto = yPosAuto + 30

_, yPosAuto = UIComponents:CreateToggle(autoPage, "Enable Auto Fishing", false, function(state)
    FishingSystem:ToggleAutoFishing(state)
end, yPosAuto)

_, yPosAuto = UIComponents:CreateToggle(autoPage, "Instant Fishing", false, function(state)
    FishingSystem:SetInstantFishing(state)
end, yPosAuto)

_, yPosAuto = UIComponents:CreateToggle(autoPage, "Auto Sell Fish", false, function(state)
    FishingSystem:ToggleAutoSell(state)
end, yPosAuto)

_, yPosAuto = UIComponents:CreateSlider(autoPage, "Catch Speed", 1, 5, 1, "x", function(value)
    FishingSystem:SetCatchSpeed(value)
end, yPosAuto)

autoPage.CanvasSize = UDim2.new(0, 0, 0, yPosAuto + 20)

-- =============================================
-- 🎣 FISHING PAGE
-- =============================================
local fishingPage = createPage("Fishing")
local yPosFish = 0

UIComponents:CreateSection(fishingPage, "🎣 Fishing Settings", yPosFish)
yPosFish = yPosFish + 30

_, yPosFish = UIComponents:CreateToggle(fishingPage, "Fishing Radar", false, function(state)
    FishingSystem:ToggleRadar(state)
end, yPosFish)

_, yPosFish = UIComponents:CreateToggle(fishingPage, "No Animation", false, function(state)
    FishingSystem:ToggleNoAnimation(state)
end, yPosFish)

UIComponents:CreateButton(fishingPage, "🔧 Advanced Settings", function()
    FishingSystem:Notify("Advanced Settings")
end, yPosFish)

fishingPage.CanvasSize = UDim2.new(0, 0, 0, yPosFish + 60)

-- =============================================
-- 📍 TELEPORT PAGE
-- =============================================
local teleportPage = createPage("Teleport")
local yPosTele = 0

UIComponents:CreateSection(teleportPage, "📍 Teleport Locations", yPosTele)
yPosTele = yPosTele + 30

-- Teleport dropdown
local teleFrame = Instance.new("Frame", teleportPage)
teleFrame.Size = UDim2.new(1, -16, 0, 30)
teleFrame.Position = UDim2.new(0, 8, 0, yPosTele)
teleFrame.BackgroundTransparency = 1

local teleLabel = Instance.new("TextLabel", teleFrame)
teleLabel.Size = UDim2.new(0.4, 0, 1, 0)
teleLabel.Text = "Location:"
teleLabel.TextColor3 = Color3.new(1, 1, 1)
teleLabel.Font = Enum.Font.Gotham
teleLabel.TextSize = 12
teleLabel.BackgroundTransparency = 1
teleLabel.TextXAlignment = Enum.TextXAlignment.Left

local teleDropdown = Instance.new("TextButton", teleFrame)
teleDropdown.Size = UDim2.new(0.6, -8, 1, 0)
teleDropdown.Position = UDim2.new(0.4, 0, 0, 0)
teleDropdown.Text = "Select"
teleDropdown.TextColor3 = Color3.new(1, 1, 1)
teleDropdown.Font = Enum.Font.Gotham
teleDropdown.TextSize = 12
teleDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleDropdown.BorderSizePixel = 0
teleDropdown.AutoButtonColor = false

local dropCorner = Instance.new("UICorner", teleDropdown)
dropCorner.CornerRadius = UDim.new(0, 4)

yPosTele = yPosTele + 40

UIComponents:CreateButton(teleportPage, "📍 Teleport to Selected", function()
    FishingSystem:Notify("Teleporting to: " .. teleDropdown.Text)
end, yPosTele)

yPosTele = yPosTele + 45

-- Quick teleport buttons
local teleButtons = {
    {"Main Island", "🏝️"},
    {"Fishing Spot", "🎣"},
    {"Shop", "🛒"},
    {"Boat Dock", "⛵"}
}

for i, btnData in ipairs(teleButtons) do
    local btn = Instance.new("TextButton", teleportPage)
    btn.Size = UDim2.new(0.5, -10, 0, 26)
    btn.Position = UDim2.new((i-1)%2*0.5 + 0.02, 8, 0, yPosTele + math.floor((i-1)/2)*30)
    btn.Text = btnData[2] .. " " .. btnData[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        FishingSystem:Notify("Teleporting to " .. btnData[1])
    end)
end

teleportPage.CanvasSize = UDim2.new(0, 0, 0, yPosTele + 80)

-- =============================================
-- ⚡ PLAYER PAGE
-- =============================================
local playerPage = createPage("Player")
local yPosPlayer = 0

UIComponents:CreateSection(playerPage, "⚡ Player Settings", yPosPlayer)
yPosPlayer = yPosPlayer + 30

_, yPosPlayer = UIComponents:CreateSlider(playerPage, "Walk Speed", 16, 100, 16, "", function(value)
    Utility:SetWalkSpeed(value)
end, yPosPlayer)

_, yPosPlayer = UIComponents:CreateSlider(playerPage, "Jump Power", 50, 150, 50, "", function(value)
    Utility:SetJumpPower(value)
end, yPosPlayer)

_, yPosPlayer = UIComponents:CreateToggle(playerPage, "Infinite Jump", false, function(state)
    Utility:ToggleInfiniteJump(state)
end, yPosPlayer)

_, yPosPlayer = UIComponents:CreateToggle(playerPage, "Fly", false, function(state)
    Utility:ToggleFly(state)
end, yPosPlayer)

_, yPosPlayer = UIComponents:CreateToggle(playerPage, "NoClip", false, function(state)
    Utility:ToggleNoClip(state)
end, yPosPlayer)

playerPage.CanvasSize = UDim2.new(0, 0, 0, yPosPlayer + 20)

-- =============================================
-- 👁️ VISUAL PAGE
-- =============================================
local visualPage = createPage("Visual")
local yPosVisual = 0

UIComponents:CreateSection(visualPage, "👁️ Visual Features", yPosVisual)
yPosVisual = yPosVisual + 30

_, yPosVisual = UIComponents:CreateToggle(visualPage, "ESP Name", false, function(state)
    Utility:ToggleESP(state)
end, yPosVisual)

_, yPosVisual = UIComponents:CreateToggle(visualPage, "Show FPS", false, function(state)
    FishingSystem:Notify("FPS Display: " .. (state and "ON" or "OFF"))
end, yPosVisual)

UIComponents:CreateButton(visualPage, "🎨 UI Theme Settings", function()
    FishingSystem:Notify("Theme Settings")
end, yPosVisual)

visualPage.CanvasSize = UDim2.new(0, 0, 0, yPosVisual + 60)

-- =============================================
-- 🎮 MENU NAVIGATION
-- =============================================
for name, btn in pairs(menuButtons) do
    btn.MouseButton1Click:Connect(function()
        -- Update active menu
        currentPage = name
        
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
    end)
end

-- Initially highlight Main
menuButtons["Main"].BackgroundColor3 = Color3.fromRGB(32, 8, 8)

-- =============================================
-- 🔧 CLOSE BUTTON FUNCTIONALITY
-- =============================================
closeButton.MouseButton1Click:Connect(function()
    screen:Destroy()
    FishingSystem:Notify("UI Closed")
end)

-- =============================================
-- 🔄 UPDATE LOOPS
-- =============================================
-- Update stats loop
spawn(function()
    while screen.Parent do
        local stats = FishingSystem:GetStats()
        statLabels["🎣 Fish:"].Text = "🎣 Fish: " .. stats.TotalFish
        statLabels["⚖️ Weight:"].Text = "⚖️ Weight: " .. stats.TotalWeight
        statLabels["💰 Coins:"].Text = "💰 Coins: " .. stats.Coins
        statLabels["⭐ Level:"].Text = "⭐ Level: " .. stats.Level
        
        task.wait(1)
    end
end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- =============================================
-- 🚀 INITIALIZATION
-- =============================================
-- Welcome message
task.delay(1, function()
    FishingSystem:Notify("🎣 Kaitun Fishing Script Loaded!")
end)

print("====================================")
print("🎣 KAITUN FISHING SCRIPT V4.0")
print("📏 Compact UI (700x500)")
print("🎨 Black/Red Theme")
print("❌ Close button only")
print("====================================")
