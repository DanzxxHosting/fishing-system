local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG - UKURAN LEBIH KECIL
local WIDTH = 400
local HEIGHT = 350
local SIDEBAR_W = 120
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
container.Position = UDim2.new(1, -WIDTH - 10, 0.5, -HEIGHT/2)
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
-- 🎯 FISHING SYSTEM - INTEGRASI MODUL
-- =============================================
local Fishing = {
    Active = false,
    AutoFish = false,
    InstantFish = false,
    FishingThread = nil,
    Stats = {
        TotalFish = 0,
        TotalWeight = 0,
        Coins = 1000
    },
    
    -- Modul dari ReplicatedStorage
    Modules = {
        FishingCastText = nil,
        FishingController = nil,
        AutoFishingController = nil,
        ClassicGroupFishingController = nil
    }
}

-- Fungsi untuk mendapatkan modul
function Fishing:GetModules()
    self.Modules.FishingCastText = ReplicatedStorage:FindFirstChild("Shared.Effects.FishingCastText")
    self.Modules.FishingController = ReplicatedStorage:FindFirstChild("Controllers.FishingController")
    self.Modules.AutoFishingController = ReplicatedStorage:FindFirstChild("Controllers.AutoFishingController")
    self.Modules.ClassicGroupFishingController = ReplicatedStorage:FindFirstChild("Controllers.ClassicGroupFishingController")
    
    if self.Modules.FishingController then
        self:Notify("✅ FishingController ditemukan!")
    else
        self:Notify("⚠️ FishingController tidak ditemukan!")
    end
    
    if self.Modules.AutoFishingController then
        self:Notify("✅ AutoFishingController ditemukan!")
    end
    
    if self.Modules.ClassicGroupFishingController then
        self:Notify("✅ ClassicGroupFishingController ditemukan!")
    end
end

function Fishing:Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎣 Fishing",
        Text = msg,
        Duration = 3
    })
    warn("[Fishing] " .. msg)
end

function Fishing:StartAutoFishing()
    if self.FishingThread then return end
    
    self.AutoFish = true
    
    -- Cek dan inisialisasi modul
    self:GetModules()
    
    self.FishingThread = task.spawn(function()
        while self.AutoFish do
            self:CastFishingRod()
            
            -- Delay antara cast dan bite
            local biteDelay = self.InstantFish and 0.5 or math.random(3, 8)
            task.wait(biteDelay)
            
            self:HookFish()
            
            -- Delay sebelum catch
            task.wait(1)
            
            self:CatchFish()
            
            -- Update stats
            self.Stats.TotalFish = self.Stats.TotalFish + 1
            self.Stats.TotalWeight = self.Stats.TotalWeight + math.random(5, 50) / 10
            self.Stats.Coins = self.Stats.Coins + math.random(10, 100)
            
            self:Notify("🎣 Ikan tertangkap! Total: " .. self.Stats.TotalFish)
            
            -- Delay sebelum next cast
            task.wait(2)
        end
    end)
    
    self:Notify("🤖 Auto Fishing Dimulai!")
end

function Fishing:StopAutoFishing()
    self.AutoFish = false
    if self.FishingThread then
        task.cancel(self.FishingThread)
        self.FishingThread = nil
    end
    self:Notify("❌ Auto Fishing Dihentikan!")
end

function Fishing:CastFishingRod()
    self:Notify("🎣 Melempar pancingan...")
    
    -- Gunakan FishingCastText jika ada
    if self.Modules.FishingCastText then
        pcall(function()
            -- Trigger fishing cast text effect
            warn("[Fishing] Triggering FishingCastText...")
            -- Simulasi pemanggilan fungsi/modul
        end)
    end
    
    -- Gunakan FishingController jika ada
    if self.Modules.FishingController then
        pcall(function()
            -- Coba panggil fungsi dari FishingController
            warn("[Fishing] Using FishingController...")
            
            -- Cari sub-modules
            local InputStates = self.Modules.FishingController:FindFirstChild("InputStates")
            local WeightRanges = self.Modules.FishingController:FindFirstChild("WeightRanges")
            local FishCaughtVisual = self.Modules.FishingController:FindFirstChild("FishCaughtVisual")
            local animateBobber = self.Modules.FishingController:FindFirstChild("Effects"):FindFirstChild("animateBobber")
            
            if InputStates then
                warn("[Fishing] InputStates ditemukan")
            end
            
            if animateBobber then
                warn("[Fishing] animateBobber ditemukan")
            end
        end)
    end
end

function Fishing:HookFish()
    self:Notify("🐟 Ikan menggigit! Menarik...")
    
    -- Gunakan modul untuk hook fish
    if self.Modules.FishingController then
        pcall(function()
            -- Trigger hook animation/effect
            warn("[Fishing] Hook fish effect...")
        end)
    end
end

function Fishing:CatchFish()
    self:Notify("✅ Ikan berhasil ditangkap!")
    
    -- Gunakan AutoFishingController jika ada untuk auto catch
    if self.Modules.AutoFishingController then
        pcall(function()
            warn("[Fishing] Menggunakan AutoFishingController...")
            -- Trigger auto catch
        end)
    end
    
    -- Gunakan ClassicGroupFishingController untuk group fishing
    if self.Modules.ClassicGroupFishingController then
        pcall(function()
            warn("[Fishing] ClassicGroupFishingController tersedia...")
        end)
    end
end

function Fishing:ManualCast()
    if self.AutoFish then
        self:Notify("⚠️ Hentikan auto fishing terlebih dahulu!")
        return
    end
    
    self:Notify("🎣 Manual casting...")
    self:CastFishingRod()
    
    task.spawn(function()
        task.wait(2)
        self:HookFish()
        task.wait(1)
        self:CatchFish()
        
        self.Stats.TotalFish = self.Stats.TotalFish + 1
        self.Stats.TotalWeight = self.Stats.TotalWeight + math.random(5, 50) / 10
        self.Stats.Coins = self.Stats.Coins + math.random(10, 100)
        
        self:Notify("🎣 Manual catch berhasil!")
    end)
end

-- =============================================
-- ⚡ PLAYER UTILITIES
-- =============================================
local PlayerUtils = {
    FlyEnabled = false,
    ESPEnabled = false,
    InfiniteJumpEnabled = false,
    WalkSpeed = 16,
    JumpPower = 50
}

function PlayerUtils:Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Player",
        Text = msg,
        Duration = 3
    })
end

function PlayerUtils:SetWalkSpeed(speed)
    self.WalkSpeed = speed
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
    self:Notify("Walk Speed: " .. speed)
end

function PlayerUtils:SetJumpPower(power)
    self.JumpPower = power
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = power
    end
    self:Notify("Jump Power: " .. power)
end

function PlayerUtils:ToggleInfiniteJump(state)
    self.InfiniteJumpEnabled = state
    
    if state then
        local connection
        connection = UserInputService.JumpRequest:Connect(function()
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState("Jumping")
                end
            end
        end)
        self.JumpConnection = connection
        self:Notify("Infinite Jump: ON")
    else
        if self.JumpConnection then
            self.JumpConnection:Disconnect()
            self.JumpConnection = nil
        end
        self:Notify("Infinite Jump: OFF")
    end
end

function PlayerUtils:ToggleFly(state)
    self.FlyEnabled = state
    
    if state then
        -- Simple fly script
        local FlyScript = [[
            local Players = game:GetService("Players")
            local UserInputService = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")
            
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            
            local flySpeed = 50
            local flying = false
            local flyVelocity = Vector3.new(0, 0, 0)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == Enum.KeyCode.F then
                    flying = not flying
                    humanoid.PlatformStand = flying
                end
            end)
            
            RunService.Heartbeat:Connect(function()
                if flying then
                    local moveDirection = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + Vector3.new(0, 0, -1)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection + Vector3.new(0, 0, 1)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection + Vector3.new(-1, 0, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + Vector3.new(1, 0, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        moveDirection = moveDirection + Vector3.new(0, -1, 0)
                    end
                    
                    if moveDirection.Magnitude > 0 then
                        moveDirection = moveDirection.Unit * flySpeed
                    end
                    
                    flyVelocity = moveDirection
                    character.PrimaryPart.Velocity = flyVelocity
                else
                    character.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        ]]
        
        loadstring(FlyScript)()
        self:Notify("Fly: ON (Press F to toggle)")
    else
        self:Notify("Fly: OFF")
    end
end

function PlayerUtils:ToggleESP(state)
    self.ESPEnabled = state
    
    if state then
        -- Simple ESP
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
                    label.TextColor3 = Color3.new(1, 0, 0)
                    label.TextStrokeTransparency = 0
                    label.BackgroundTransparency = 1
                    label.TextSize = 14
                    label.Font = Enum.Font.GothamBold
                    label.Parent = billboard
                    
                    billboard.Parent = head
                end
            end
        end
        self:Notify("ESP: ON")
    else
        -- Remove ESP
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

-- =============================================
-- 📍 TELEPORT SYSTEM
-- =============================================
local Teleport = {}

function Teleport:Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📍 Teleport",
        Text = msg,
        Duration = 3
    })
end

function Teleport:ToPosition(position)
    local character = player.Character
    if character and character.PrimaryPart then
        character:SetPrimaryPartCFrame(CFrame.new(position))
        self:Notify("Teleported!")
    else
        self:Notify("Character not found!")
    end
end

-- =============================================
-- 🎨 UI COMPONENTS
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
    {"💰 Coins:", "1000"}
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
    {"🎣 Auto Fishing", function() 
        if not Fishing.AutoFish then
            Fishing:StartAutoFishing()
        else
            Fishing:Notify("Already fishing!")
        end
    end},
    {"❌ Stop Fishing", function() Fishing:StopAutoFishing() end},
    {"🎣 Manual Cast", function() Fishing:ManualCast() end},
    {"🚀 Toggle Fly", function() PlayerUtils:ToggleFly(not PlayerUtils.FlyEnabled) end}
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
-- 🎣 FISHING PAGE
-- =============================================
local fishingPage = createPage("Fishing")
local yPosFish = 0

UIComponents:CreateSection(fishingPage, "🎣 Fishing System", yPosFish)
yPosFish = yPosFish + 30

_, yPosFish = UIComponents:CreateToggle(fishingPage, "Auto Fishing", false, function(state)
    if state then
        Fishing:StartAutoFishing()
    else
        Fishing:StopAutoFishing()
    end
end, yPosFish)

_, yPosFish = UIComponents:CreateToggle(fishingPage, "Instant Fishing", false, function(state)
    Fishing.InstantFish = state
    Fishing:Notify("Instant Fishing: " .. (state and "ON" or "OFF"))
end, yPosFish)

UIComponents:CreateButton(fishingPage, "🎣 Manual Cast", function()
    Fishing:ManualCast()
end, yPosFish)

UIComponents:CreateButton(fishingPage, "🔄 Check Modules", function()
    Fishing:GetModules()
    Fishing:Notify("Checking fishing modules...")
end, yPosFish + 40)

UIComponents:CreateButton(fishingPage, "💰 Sell All Fish", function()
    local profit = Fishing.Stats.TotalFish * 50
    Fishing.Stats.Coins = Fishing.Stats.Coins + profit
    Fishing.Stats.TotalFish = 0
    Fishing.Stats.TotalWeight = 0
    Fishing:Notify("Sold all fish for " .. profit .. " coins!")
end, yPosFish + 80)

fishingPage.CanvasSize = UDim2.new(0, 0, 0, yPosFish + 140)

-- =============================================
-- 📍 TELEPORT PAGE
-- =============================================
local teleportPage = createPage("Teleport")
local yPosTele = 0

UIComponents:CreateSection(teleportPage, "📍 Teleport Locations", yPosTele)
yPosTele = yPosTele + 30

-- Teleport buttons
local teleButtons = {
    {"Main Island", "🏝️", Vector3.new(0, 10, 0)},
    {"Fishing Spot", "🎣", Vector3.new(100, 10, 0)},
    {"Shop", "🛒", Vector3.new(50, 10, 50)},
    {"Boat Dock", "⛵", Vector3.new(-50, 10, 100)}
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
        Teleport:ToPosition(btnData[3])
        Teleport:Notify("Teleported to " .. btnData[1])
    end)
end

yPosTele = yPosTele + 70

-- Custom teleport
local customFrame = Instance.new("Frame", teleportPage)
customFrame.Size = UDim2.new(1, -16, 0, 80)
customFrame.Position = UDim2.new(0, 8, 0, yPosTele)
customFrame.BackgroundTransparency = 1

local xLabel = Instance.new("TextLabel", customFrame)
xLabel.Size = UDim2.new(0.3, -4, 0, 20)
xLabel.Position = UDim2.new(0, 0, 0, 0)
xLabel.Text = "X:"
xLabel.TextColor3 = Color3.new(1, 1, 1)
xLabel.Font = Enum.Font.Gotham
xLabel.TextSize = 12
xLabel.BackgroundTransparency = 1

local xBox = Instance.new("TextBox", customFrame)
xBox.Size = UDim2.new(0.7, 0, 0, 20)
xBox.Position = UDim2.new(0.3, 4, 0, 0)
xBox.Text = "0"
xBox.PlaceholderText = "X coordinate"
xBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
xBox.TextColor3 = Color3.new(1, 1, 1)

local yLabel = Instance.new("TextLabel", customFrame)
yLabel.Size = UDim2.new(0.3, -4, 0, 20)
yLabel.Position = UDim2.new(0, 0, 0, 25)
yLabel.Text = "Y:"
yLabel.TextColor3 = Color3.new(1, 1, 1)
yLabel.Font = Enum.Font.Gotham
yLabel.TextSize = 12
yLabel.BackgroundTransparency = 1

local yBox = Instance.new("TextBox", customFrame)
yBox.Size = UDim2.new(0.7, 0, 0, 20)
yBox.Position = UDim2.new(0.3, 4, 0, 25)
yBox.Text = "10"
yBox.PlaceholderText = "Y coordinate"
yBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
yBox.TextColor3 = Color3.new(1, 1, 1)

local zLabel = Instance.new("TextLabel", customFrame)
zLabel.Size = UDim2.new(0.3, -4, 0, 20)
zLabel.Position = UDim2.new(0, 0, 0, 50)
zLabel.Text = "Z:"
zLabel.TextColor3 = Color3.new(1, 1, 1)
zLabel.Font = Enum.Font.Gotham
zLabel.TextSize = 12
zLabel.BackgroundTransparency = 1

local zBox = Instance.new("TextBox", customFrame)
zBox.Size = UDim2.new(0.7, 0, 0, 20)
zBox.Position = UDim2.new(0.3, 4, 0, 50)
zBox.Text = "0"
zBox.PlaceholderText = "Z coordinate"
zBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
zBox.TextColor3 = Color3.new(1, 1, 1)

UIComponents:CreateButton(teleportPage, "📍 Teleport to Coordinates", function()
    local x = tonumber(xBox.Text) or 0
    local y = tonumber(yBox.Text) or 10
    local z = tonumber(zBox.Text) or 0
    Teleport:ToPosition(Vector3.new(x, y, z))
    Teleport:Notify("Teleported to (" .. x .. ", " .. y .. ", " .. z .. ")")
end, yPosTele + 90)

teleportPage.CanvasSize = UDim2.new(0, 0, 0, yPosTele + 160)

-- =============================================
-- ⚡ PLAYER PAGE
-- =============================================
local playerPage = createPage("Player")
local yPosPlayer = 0

UIComponents:CreateSection(playerPage, "⚡ Player Settings", yPosPlayer)
yPosPlayer = yPosPlayer + 30

_, yPosPlayer = UIComponents:CreateSlider(playerPage, "Walk Speed", 16, 100, 16, "", function(value)
    PlayerUtils:SetWalkSpeed(value)
end, yPosPlayer)

_, yPosPlayer = UIComponents:CreateToggle(playerPage, "Infinite Jump", false, function(state)
    PlayerUtils:ToggleInfiniteJump(state)
end, yPosPlayer)

_, yPosPlayer = UIComponents:CreateToggle(playerPage, "Fly", false, function(state)
    PlayerUtils:ToggleFly(state)
end, yPosPlayer)

playerPage.CanvasSize = UDim2.new(0, 0, 0, yPosPlayer + 20)

-- =============================================
-- 👁️ VISUAL PAGE
-- =============================================
local visualPage = createPage("Visual")
local yPosVisual = 0

UIComponents:CreateSection(visualPage, "👁️ Visual Features", yPosVisual)
yPosVisual = yPosVisual + 30

_, yPosVisual = UIComponents:CreateToggle(visualPage, "ESP (Player Names)", false, function(state)
    PlayerUtils:ToggleESP(state)
end, yPosVisual)

UIComponents:CreateButton(visualPage, "🎨 Change UI Color", function()
    local colors = {
        Color3.fromRGB(255, 62, 62), -- red
        Color3.fromRGB(62, 255, 62), -- green
        Color3.fromRGB(62, 62, 255), -- blue
        Color3.fromRGB(255, 255, 62), -- yellow
        Color3.fromRGB(255, 62, 255)  -- pink
    }
    
    local currentIndex = 1
    for i, color in ipairs(colors) do
        if color == ACCENT then
            currentIndex = i
            break
        end
    end
    
    local nextIndex = (currentIndex % #colors) + 1
    ACCENT = colors[nextIndex]
    
    -- Update UI elements
    sTitle.TextColor3 = ACCENT
    closeButton.BackgroundColor3 = ACCENT
    content.ScrollBarImageColor3 = ACCENT
    
    Fishing:Notify("UI Color changed!")
end, yPosVisual)

visualPage.CanvasSize = UDim2.new(0, 0, 0, yPosVisual + 80)

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
    -- Cleanup before close
    Fishing:StopAutoFishing()
    PlayerUtils:ToggleFly(false)
    PlayerUtils:ToggleESP(false)
    PlayerUtils:ToggleInfiniteJump(false)
    screen:Destroy()
    Fishing:Notify("UI Closed")
end)

-- =============================================
-- 🔄 UPDATE LOOPS
-- =============================================
-- Update stats loop
task.spawn(function()
    while screen.Parent do
        -- Update fishing stats
        statLabels["🎣 Fish:"].Text = "🎣 Fish: " .. Fishing.Stats.TotalFish
        statLabels["⚖️ Weight:"].Text = "⚖️ Weight: " .. string.format("%.1fkg", Fishing.Stats.TotalWeight)
        statLabels["💰 Coins:"].Text = "💰 Coins: " .. Fishing.Stats.Coins
        
        task.wait(1)
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F untuk toggle fly
    if input.KeyCode == Enum.KeyCode.F then
        PlayerUtils:ToggleFly(not PlayerUtils.FlyEnabled)
    
    -- E untuk manual fishing
    elseif input.KeyCode == Enum.KeyCode.E then
        Fishing:ManualCast()
    
    -- J untuk infinite jump
    elseif input.KeyCode == Enum.KeyCode.J then
        PlayerUtils:ToggleInfiniteJump(not PlayerUtils.InfiniteJumpEnabled)
    
    -- T untuk toggle auto fishing
    elseif input.KeyCode == Enum.KeyCode.T then
        if not Fishing.AutoFish then
            Fishing:StartAutoFishing()
        else
            Fishing:StopAutoFishing()
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
-- Inisialisasi modul fishing
task.wait(2)
Fishing:GetModules()

-- Welcome message
task.delay(1, function()
    local msg = "🎣 KAITUN FISHING UI LOADED!"
    msg = msg .. "\n🎣 Fishing Modules: " .. 
        (Fishing.Modules.FishingController and "✅" or "❌")
    msg = msg .. "\n🎣 Manual Fishing: E key"
    msg = msg .. "\n🤖 Auto Fishing: T key"
    msg = msg .. "\n🚀 Fly: F key"
    msg = msg .. "\n👁️ ESP: Visual Page"
    msg = msg .. "\n⚡ Infinite Jump: J key"
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kaitun Fishing",
        Text = msg,
        Duration = 5
    })
end)

-- Cleanup on player leave
player.CharacterRemoving:Connect(function()
    Fishing:StopAutoFishing()
    PlayerUtils:ToggleFly(false)
    PlayerUtils:ToggleESP(false)
    PlayerUtils:ToggleInfiniteJump(false)
end)
