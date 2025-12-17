local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG - UKURAN LEBIH KECIL
local WIDTH = 400  -- Diperkecil dari 920
local HEIGHT = 350 -- Diperkecil dari 520
local SIDEBAR_W = 120  -- Diperkecil dari 220
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
    {"Radar", "📡"}, -- Ditambahkan menu Radar
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
-- 🎯 FISHING RADAR SYSTEM (UPDATE)
-- =============================================
local FishingRadar = {
    Active = false,
    Enabled = false,
    ScanRadius = 200,
    Markers = {},
    RadarThread = nil,
    RadarUI = nil,
    BestSpot = nil,
    Spots = {}
}

function FishingRadar:Initialize()
    -- Inisialisasi module dari ReplicatedStorage
    self.Modules = {
        FishingController = ReplicatedStorage:FindFirstChild("Controllers.FishingController"),
        AutoFishingController = ReplicatedStorage:FindFirstChild("Controllers.AutoFishingController"),
        FishingRodModifier = ReplicatedStorage:FindFirstChild("Shared.FishingRodModifier$")
    }
    
    -- Cari modul Radar
    if self.Modules.FishingController then
        local gears = self.Modules.FishingController:FindFirstChild("Gears")
        if gears then
            self.RadarModule = gears:FindFirstChild("Fishing Radar")
            self.DivingGear = gears:FindFirstChild("Diving Gear")
        end
    end
end

function FishingRadar:CreateRadarUI()
    if self.RadarUI and self.RadarUI.Parent then
        self.RadarUI:Destroy()
    end
    
    local radarScreen = Instance.new("ScreenGui")
    radarScreen.Name = "FishingRadarDisplay"
    radarScreen.Parent = playerGui
    radarScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Radar frame
    local radarFrame = Instance.new("Frame")
    radarFrame.Name = "Radar"
    radarFrame.Size = UDim2.new(0, 300, 0, 300)
    radarFrame.Position = UDim2.new(1, -320, 0, 10)
    radarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40, 0.7)
    radarFrame.BackgroundTransparency = 0.7
    radarFrame.BorderSizePixel = 0
    radarFrame.Parent = radarScreen
    
    local frameCorner = Instance.new("UICorner", radarFrame)
    frameCorner.CornerRadius = UDim.new(0, 8)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "📡 FISHING RADAR"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = radarFrame
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Text = "Status: Scanning..."
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0, 35)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.Parent = radarFrame
    
    -- Spot count
    local spotCount = Instance.new("TextLabel")
    spotCount.Text = "Spots: 0"
    spotCount.Size = UDim2.new(1, 0, 0, 20)
    spotCount.Position = UDim2.new(0, 0, 0, 55)
    spotCount.BackgroundTransparency = 1
    spotCount.TextColor3 = Color3.fromRGB(200, 200, 200)
    spotCount.Font = Enum.Font.Gotham
    spotCount.TextSize = 12
    spotCount.Parent = radarFrame
    
    self.RadarUI = {
        Screen = radarScreen,
        Frame = radarFrame,
        Status = status,
        SpotCount = spotCount
    }
    
    return self.RadarUI
end

function FishingRadar:Start()
    if not self.Enabled then return end
    
    self.Active = true
    self:CreateRadarUI()
    
    self.RadarThread = task.spawn(function()
        while self.Active do
            self:ScanForSpots()
            task.wait(2) -- Scan setiap 2 detik
        end
    end)
    
    self:Notify("Radar Activated! Scanning for fish spots...")
end

function FishingRadar:Stop()
    self.Active = false
    
    if self.RadarThread then
        task.cancel(self.RadarThread)
        self.RadarThread = nil
    end
    
    -- Hapus markers
    self:ClearMarkers()
    
    -- Hapus UI
    if self.RadarUI and self.RadarUI.Screen then
        self.RadarUI.Screen:Destroy()
        self.RadarUI = nil
    end
    
    self:Notify("Radar Deactivated!")
end

function FishingRadar:ScanForSpots()
    if not self.Active then return end
    
    local character = player.Character
    if not character or not character.PrimaryPart then return end
    
    local playerPos = character.PrimaryPart.Position
    local spots = {}
    local bestSpot = nil
    local bestValue = 0
    
    -- Clear old markers
    self:ClearMarkers()
    
    -- Scan workspace
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("Part") or part:IsA("MeshPart") then
            local distance = (part.Position - playerPos).Magnitude
            
            if distance <= self.ScanRadius then
                local isWaterSpot = false
                local spotValue = 0
                
                -- Deteksi water berdasarkan nama
                local name = part.Name:lower()
                if name:find("water") or name:find("pond") or name:find("lake") 
                   or name:find("river") or name:find("ocean") or name:find("sea") 
                   or name:find("fish") or name:find("fishing") then
                    isWaterSpot = true
                    spotValue = 1
                end
                
                -- Deteksi berdasarkan material
                if part.Material == Enum.Material.Water or part.Material == Enum.Material.SmoothPlastic then
                    isWaterSpot = true
                    spotValue = spotValue + 0.5
                end
                
                -- Deteksi berdasarkan warna (biru)
                local color = part.Color
                if color.B > color.R and color.B > color.G then
                    isWaterSpot = true
                    spotValue = spotValue + 0.3
                end
                
                if isWaterSpot then
                    -- Hitung nilai spot
                    local distanceFactor = 1 - (distance / self.ScanRadius)
                    spotValue = spotValue * (1 + distanceFactor)
                    
                    local spotData = {
                        Part = part,
                        Position = part.Position,
                        Distance = math.floor(distance),
                        Value = spotValue,
                        Marker = nil
                    }
                    
                    table.insert(spots, spotData)
                    
                    -- Update spot terbaik
                    if spotValue > bestValue then
                        bestValue = spotValue
                        bestSpot = spotData
                    end
                end
            end
        end
    end
    
    self.Spots = spots
    self.BestSpot = bestSpot
    
    -- Update UI
    if self.RadarUI then
        self.RadarUI.Status.Text = "Status: " .. (#spots .. " spots found")
        self.RadarUI.SpotCount.Text = "Best: " .. (bestSpot and math.floor(bestSpot.Distance) .. " studs" or "None")
        
        if bestSpot then
            self.RadarUI.Status.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            self.RadarUI.Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
    
    -- Create markers
    self:CreateMarkers()
end

function FishingRadar:CreateMarkers()
    for _, spot in pairs(self.Spots) do
        local marker = Instance.new("BillboardGui")
        marker.Name = "FishSpotMarker"
        marker.Size = UDim2.new(0, 20, 0, 20)
        marker.StudsOffset = Vector3.new(0, 3, 0)
        marker.AlwaysOnTop = true
        marker.Adornee = spot.Part
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = spot == self.BestSpot and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 255)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = marker
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = frame
        
        -- Label
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(2, 0, 1, 0)
        label.Position = UDim2.new(0.5, 10, 0, 0)
        label.Text = "🎣 " .. math.floor(spot.Distance) .. "m"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.BackgroundTransparency = 1
        label.TextSize = 10
        label.Font = Enum.Font.GothamBold
        label.Parent = marker
        
        marker.Parent = Workspace.CurrentCamera
        spot.Marker = marker
        
        table.insert(self.Markers, marker)
    end
end

function FishingRadar:ClearMarkers()
    for _, marker in pairs(self.Markers) do
        if marker then
            marker:Destroy()
        end
    end
    self.Markers = {}
end

function FishingRadar:Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📡 Fishing Radar",
        Text = msg,
        Duration = 3
    })
end

function FishingRadar:Toggle(state)
    self.Enabled = state
    
    if state then
        self:Start()
    else
        self:Stop()
    end
end

-- =============================================
-- 🤖 AUTO FISHING SYSTEM (UPDATE)
-- =============================================
local AutoFishing = {
    Active = false,
    Enabled = false,
    CatchSpeed = 1,
    InstantFish = false,
    AutoSell = false,
    FishingThread = nil,
    UseRadar = true,
    Stats = {
        TotalFish = 0,
        TotalWeight = 0,
        Coins = 1000,
        Level = 1
    }
}

function AutoFishing:Initialize()
    -- Inisialisasi module
    self.Modules = {}
    
    -- Cari fishing controller
    if ReplicatedStorage:FindFirstChild("Controllers.FishingController") then
        self.Modules.FishingController = ReplicatedStorage.Controllers.FishingController
        
        -- Cari sub-modules
        self.Modules.InputStates = self.Modules.FishingController:FindFirstChild("InputStates")
        self.Modules.WeightRanges = self.Modules.FishingController:FindFirstChild("WeightRanges")
        self.Modules.FishCaughtVisual = self.Modules.FishingController:FindFirstChild("FishCaughtVisual")
        self.Modules.FishBaitVisual = self.Modules.FishingController:FindFirstChild("FishBaitVisual")
        self.Modules.animateBobber = self.Modules.FishingController:FindFirstChild("Effects"):FindFirstChild("animateBobber")
    end
end

function AutoFishing:Start()
    if not self.Enabled then return end
    
    self.Active = true
    
    self.FishingThread = task.spawn(function()
        while self.Active do
            self:PerformFishingCycle()
            task.wait(2 / self.CatchSpeed) -- Delay berdasarkan catch speed
        end
    end)
    
    self:Notify("Auto Fishing Started!")
end

function AutoFishing:Stop()
    self.Active = false
    
    if self.FishingThread then
        task.cancel(self.FishingThread)
        self.FishingThread = nil
    end
    
    self:Notify("Auto Fishing Stopped!")
end

function AutoFishing:PerformFishingCycle()
    if not self.Active then return end
    
    -- Gunakan radar untuk mencari spot terbaik
    local targetSpot = nil
    if self.UseRadar and FishingRadar.BestSpot then
        targetSpot = FishingRadar.BestSpot.Part
        self:Notify("Moving to best fishing spot...")
    end
    
    -- Cast fishing
    self:CastFishingRod(targetSpot)
    
    -- Tunggu fish bite
    local biteTime = self.InstantFish and 0.5 or math.random(3, 8)
    task.wait(biteTime)
    
    -- Hook fish
    self:HookFish()
    
    -- Reel in
    task.wait(1)
    
    -- Update stats
    self.Stats.TotalFish = self.Stats.TotalFish + 1
    self.Stats.TotalWeight = self.Stats.TotalWeight + math.random(5, 50) / 10
    self.Stats.Coins = self.Stats.Coins + math.random(10, 100)
    
    -- Auto sell jika enabled
    if self.AutoSell then
        task.wait(0.5)
        self:SellFish()
    end
    
    self:Notify("Fish caught! Total: " .. self.Stats.TotalFish)
end

function AutoFishing:CastFishingRod(spot)
    -- Simulasi cast fishing rod
    self:Notify("Casting rod...")
    
    -- Gunakan fishing controller jika ada
    if self.Modules.FishingController then
        pcall(function()
            -- Simulasi remote event call
            local args = {
                position = spot and spot.Position or Workspace.CurrentCamera.CFrame.LookVector * 20,
                timestamp = os.time()
            }
            
            -- Trigger fishing effects
            if self.Modules.FishCaughtVisual then
                -- Trigger visual effect
            end
        end)
    end
    
    -- Trigger fishing cast text jika ada
    local FishingCastText = ReplicatedStorage:FindFirstChild("Shared.Effects.FishingCastText")
    if FishingCastText then
        -- Trigger effect
    end
end

function AutoFishing:HookFish()
    -- Hook fish
    self:Notify("Fish bite! Hooking...")
    
    -- Trigger bobber animation jika ada
    if self.Modules.animateBobber then
        -- Trigger animation
    end
end

function AutoFishing:SellFish()
    -- Auto sell fish
    self:Notify("Auto selling fish...")
    
    -- Update coins
    local profit = math.random(20, 50)
    self.Stats.Coins = self.Stats.Coins + profit
    
    self:Notify("Sold fish for " .. profit .. " coins!")
end

function AutoFishing:Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🤖 Auto Fishing",
        Text = msg,
        Duration = 2
    })
end

function AutoFishing:Toggle(state)
    self.Enabled = state
    
    if state then
        self:Start()
    else
        self:Stop()
    end
end

function AutoFishing:SetCatchSpeed(speed)
    self.CatchSpeed = math.clamp(speed, 1, 5)
    self:Notify("Catch Speed: " .. self.CatchSpeed .. "x")
end

-- =============================================
-- 🎯 UTILITY FUNCTIONS (UPDATE)
-- =============================================
local Utility = {}

function Utility:SetWalkSpeed(speed)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
        self:Notify("Walk Speed: " .. speed)
    end
end

function Utility:SetJumpPower(power)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = power
        self:Notify("Jump Power: " .. power)
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
        self:Notify("Infinite Jump: ON")
    else
        self:Notify("Infinite Jump: OFF")
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
        self:Notify("ESP: ON")
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
        self:Notify("ESP: OFF")
    end
end

function Utility:ToggleFly(state)
    if state then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        self:Notify("Fly: ON")
    else
        self:Notify("Fly: OFF")
    end
end

function Utility:Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Utility",
        Text = msg,
        Duration = 3
    })
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
statsCard.Size = UDim2.new(1, 0, 0, 120) -- Diperbesar untuk radar info
statsCard.Position = UDim2.new(0, 0, 0, 0)
statsCard.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
statsCard.BorderSizePixel = 0

local statsCorner = Instance.new("UICorner", statsCard)
statsCorner.CornerRadius = UDim.new(0, 6)

local statsTitle = Instance.new("TextLabel", statsCard)
statsTitle.Size = UDim2.new(1, -12, 0, 24)
statsTitle.Position = UDim2.new(0, 6, 0, 6)
statsTitle.Text = "📊 Fishing Stats & Radar"
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
    {"📡 Spots:", "0"},
    {"⭐ Level:", "1"},
    {"🎯 Best Spot:", "None"}
}

for i, data in ipairs(statData) do
    local label = Instance.new("TextLabel", statsCard)
    label.Size = UDim2.new(0.5, -10, 0, 18)
    label.Position = UDim2.new((i-1)%2*0.5 + 0.02, 8, 0, yOffset + math.floor((i-1)/2)*20)
    label.Text = data[1] .. " " .. data[2]
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    statLabels[data[1]] = label
end

-- Quick Actions
local yPos = 130
UIComponents:CreateSection(mainPage, "⚡ Quick Actions", yPos)
yPos = yPos + 30

-- Quick action buttons
local quickActions = {
    {"🤖 Start Auto", function() AutoFishing:Toggle(true) end},
    {"📡 Radar ON", function() FishingRadar:Toggle(true) end},
    {"🎣 Equip Rod", function() AutoFishing:Notify("Equipping best rod...") end},
    {"💰 Auto Sell", function() AutoFishing.AutoSell = not AutoFishing.AutoSell 
        AutoFishing:Notify("Auto Sell: " .. (AutoFishing.AutoSell and "ON" or "OFF")) end}
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

mainPage.CanvasSize = UDim2.new(0, 0, 0, yPos + 100)

-- =============================================
-- 🤖 AUTO FISH PAGE
-- =============================================
local autoPage = createPage("Auto Fish")
local yPosAuto = 0

UIComponents:CreateSection(autoPage, "🤖 Auto Fishing System", yPosAuto)
yPosAuto = yPosAuto + 30

_, yPosAuto = UIComponents:CreateToggle(autoPage, "Enable Auto Fishing", false, function(state)
    AutoFishing:Toggle(state)
end, yPosAuto)

_, yPosAuto = UIComponents:CreateToggle(autoPage, "Instant Fishing", false, function(state)
    AutoFishing.InstantFish = state
    AutoFishing:Notify("Instant Fishing: " .. (state and "ON" or "OFF"))
end, yPosAuto)

_, yPosAuto = UIComponents:CreateToggle(autoPage, "Auto Sell Fish", false, function(state)
    AutoFishing.AutoSell = state
    AutoFishing:Notify("Auto Sell: " .. (state and "ON" or "OFF"))
end, yPosAuto)

_, yPosAuto = UIComponents:CreateToggle(autoPage, "Use Radar Guide", true, function(state)
    AutoFishing.UseRadar = state
    AutoFishing:Notify("Use Radar: " .. (state and "ON" or "OFF"))
end, yPosAuto)

_, yPosAuto = UIComponents:CreateSlider(autoPage, "Catch Speed", 1, 5, 1, "x", function(value)
    AutoFishing:SetCatchSpeed(value)
end, yPosAuto)

UIComponents:CreateButton(autoPage, "🎣 Start Fishing Session", function()
    if not AutoFishing.Enabled then
        AutoFishing:Toggle(true)
    end
    AutoFishing:Notify("Starting fishing session...")
end, yPosAuto)

autoPage.CanvasSize = UDim2.new(0, 0, 0, yPosAuto + 80)

-- =============================================
-- 🎣 FISHING PAGE
-- =============================================
local fishingPage = createPage("Fishing")
local yPosFish = 0

UIComponents:CreateSection(fishingPage, "🎣 Fishing Settings", yPosFish)
yPosFish = yPosFish + 30

_, yPosFish = UIComponents:CreateToggle(fishingPage, "No Animation", false, function(state)
    AutoFishing:Notify("No Animation: " .. (state and "ON" or "OFF"))
end, yPosFish)

_, yPosFish = UIComponents:CreateToggle(fishingPage, "Auto Bait", false, function(state)
    AutoFishing:Notify("Auto Bait: " .. (state and "ON" or "OFF"))
end, yPosFish)

_, yPosFish = UIComponents:CreateSlider(fishingPage, "Max Wait Time", 5, 30, 15, "s", function(value)
    AutoFishing:Notify("Max Wait: " .. value .. "s")
end, yPosFish)

UIComponents:CreateButton(fishingPage, "🔧 Advanced Settings", function()
    AutoFishing:Notify("Advanced Fishing Settings")
end, yPosFish)

fishingPage.CanvasSize = UDim2.new(0, 0, 0, yPosFish + 100)

-- =============================================
-- 📡 RADAR PAGE (BARU)
-- =============================================
local radarPage = createPage("Radar")
local yPosRadar = 0

UIComponents:CreateSection(radarPage, "📡 Fishing Radar System", yPosRadar)
yPosRadar = yPosRadar + 30

_, yPosRadar = UIComponents:CreateToggle(radarPage, "Enable Fishing Radar", false, function(state)
    FishingRadar:Toggle(state)
end, yPosRadar)

_, yPosRadar = UIComponents:CreateSlider(radarPage, "Scan Radius", 50, 500, 200, " studs", function(value)
    FishingRadar.ScanRadius = value
    FishingRadar:Notify("Scan Radius: " .. value .. " studs")
end, yPosRadar)

_, yPosRadar = UIComponents:CreateToggle(radarPage, "Show Markers", true, function(state)
    FishingRadar:Notify("Markers: " .. (state and "ON" or "OFF"))
end, yPosRadar)

_, yPosRadar = UIComponents:CreateToggle(radarPage, "Highlight Best", true, function(state)
    FishingRadar:Notify("Highlight Best: " .. (state and "ON" or "OFF"))
end, yPosRadar)

UIComponents:CreateButton(radarPage, "🎯 Scan Now", function()
    if FishingRadar.Active then
        FishingRadar:ScanForSpots()
        FishingRadar:Notify("Manual scan complete!")
    else
        FishingRadar:Notify("Activate radar first!")
    end
end, yPosRadar)

UIComponents:CreateButton(radarPage, "📍 Go to Best Spot", function()
    if FishingRadar.BestSpot then
        local character = player.Character
        if character and character.PrimaryPart then
            character:SetPrimaryPartCFrame(CFrame.new(FishingRadar.BestSpot.Position + Vector3.new(0, 5, 0)))
            AutoFishing:Notify("Teleported to best fishing spot!")
        end
    else
        FishingRadar:Notify("No spot found!")
    end
end, yPosRadar)

radarPage.CanvasSize = UDim2.new(0, 0, 0, yPosRadar + 120)

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
    AutoFishing:Notify("Teleporting to: " .. teleDropdown.Text)
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
        AutoFishing:Notify("Teleporting to " .. btnData[1])
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
    AutoFishing:Notify("FPS Display: " .. (state and "ON" or "OFF"))
end, yPosVisual)

UIComponents:CreateButton(visualPage, "🎨 UI Theme Settings", function()
    AutoFishing:Notify("Theme Settings")
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
    -- Cleanup sebelum close
    AutoFishing:Stop()
    FishingRadar:Stop()
    screen:Destroy()
    AutoFishing:Notify("UI Closed")
end)

-- =============================================
-- 🔄 UPDATE LOOPS
-- =============================================
-- Update stats loop
task.spawn(function()
    while screen.Parent do
        -- Update auto fishing stats
        statLabels["🎣 Fish:"].Text = "🎣 Fish: " .. AutoFishing.Stats.TotalFish
        statLabels["⚖️ Weight:"].Text = "⚖️ Weight: " .. string.format("%.1fkg", AutoFishing.Stats.TotalWeight)
        statLabels["💰 Coins:"].Text = "💰 Coins: " .. AutoFishing.Stats.Coins
        statLabels["⭐ Level:"].Text = "⭐ Level: " .. AutoFishing.Stats.Level
        
        -- Update radar stats
        if FishingRadar.Active then
            statLabels["📡 Spots:"].Text = "📡 Spots: " .. #FishingRadar.Spots
            statLabels["🎯 Best Spot:"].Text = "🎯 Best Spot: " .. 
                (FishingRadar.BestSpot and math.floor(FishingRadar.BestSpot.Distance) .. " studs" or "None")
        else
            statLabels["📡 Spots:"].Text = "📡 Spots: Radar OFF"
            statLabels["🎯 Best Spot:"].Text = "🎯 Best Spot: Radar OFF"
        end
        
        task.wait(1)
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F6 untuk toggle auto fishing
    if input.KeyCode == Enum.KeyCode.F6 then
        AutoFishing:Toggle(not AutoFishing.Enabled)
    
    -- F7 untuk toggle radar
    elseif input.KeyCode == Enum.KeyCode.F7 then
        FishingRadar:Toggle(not FishingRadar.Enabled)
    
    -- E untuk manual fishing
    elseif input.KeyCode == Enum.KeyCode.E then
        if not AutoFishing.Active then
            AutoFishing:PerformFishingCycle()
        end
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
-- Initialize systems
task.wait(1)
FishingRadar:Initialize()
AutoFishing:Initialize()

-- Welcome message
task.delay(1, function()
    local msg = "🎣 KAITUN FISHING UI LOADED!"
    msg = msg .. "\n📡 Radar: F7"
    msg = msg .. "\n🤖 Auto Fish: F6"
    msg = msg .. "\n🎣 Manual: E"
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kaitun Fishing",
        Text = msg,
        Duration = 5
    })
end)

-- Cleanup on player leave
player.CharacterRemoving:Connect(function()
    AutoFishing:Stop()
    FishingRadar:Stop()
end)
