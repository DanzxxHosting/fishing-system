-- UI-Only: Neon Panel dengan Tray Icon + Enhanced Instant Fishing
-- paste ke StarterPlayer -> StarterPlayerScripts (LocalScript)
-- Tema: hitam matte + merah neon. Close/minimize akan menyisakan tray icon.
-- Nama: NEON HUB

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local WIDTH = 720
local HEIGHT = 520 -- Diperbesar agar semua fitur kelihatan
local SIDEBAR_W = 220
local ACCENT = Color3.fromRGB(255, 62, 62) -- neon merah
local BG = Color3.fromRGB(12,12,12) -- hitam matte
local SECOND = Color3.fromRGB(24,24,26)

-- FISHING CONFIG
local fishingConfig = {
    autoFishing = false,
    instantFishing = true,
    fishingDelay = 0.001,
    blantantMode = false,
    ultraSpeed = false,
    perfectCast = true,
    autoReel = true,
    bypassDetection = true
}

-- SETTINGS CONFIG
local settingsConfig = {
    flyEnabled = false,
    flySpeed = 50,
    walkSpeed = 32,
    jumpPower = 50,
    infiniteJump = false,
    espEnabled = false,
    espColor = Color3.fromRGB(255, 0, 0),
    espTransparency = 0.5
}

local fishingStats = {
    fishCaught = 0,
    startTime = tick(),
    attempts = 0,
    successRate = 0
}

local fishingActive = false
local fishingConnection
local reelConnection

-- FITUR VARIABLES
local flyActive = false
local flyConnection
local infiniteJumpActive = false
local jumpConnection
local espEnabled = false
local espBoxes = {}
local espConnection

-- PERUBAHAN: Remote fishing yang ditemukan di console
local fishingRemotes = {
    FlyFishingEffect = nil,
    FishCaught = nil,
    ObtainedNewFishNotification = nil,
    FishingStopped = nil,
    FishingCompleted = nil,
    FishingMinigameChanged = nil,
    CaughtFishVisual = nil
}

-- Cleanup old UI
if playerGui:FindFirstChild("NeonDashboardUI") then
    playerGui.NeonDashboardUI:Destroy()
end

-- Cleanup ESP jika ada
for _, box in pairs(espBoxes) do
    if box then
        box:Destroy()
    end
end
espBoxes = {}

-- ScreenGui
local screen = Instance.new("ScreenGui")
screen.Name = "NeonDashboardUI"
screen.ResetOnSpawn = false
screen.Parent = playerGui
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

print("[NEON HUB] ScreenGui created")

-- TRAY ICON
local trayIcon = Instance.new("ImageButton")
trayIcon.Name = "TrayIcon"
trayIcon.Size = UDim2.new(0, 60, 0, 60)
trayIcon.Position = UDim2.new(1, -70, 0, 20)
trayIcon.BackgroundColor3 = ACCENT
trayIcon.Image = "rbxassetid://3926305904"
trayIcon.Visible = false
trayIcon.ZIndex = 10
trayIcon.Parent = screen

local trayCorner = Instance.new("UICorner")
trayCorner.CornerRadius = UDim.new(0, 12)
trayCorner.Parent = trayIcon

local trayGlow = Instance.new("ImageLabel")
trayGlow.Name = "TrayGlow"
trayGlow.Size = UDim2.new(1, 20, 1, 20)
trayGlow.Position = UDim2.new(0, -10, 0, -10)
trayGlow.BackgroundTransparency = 1
trayGlow.Image = "rbxassetid://5050741616"
trayGlow.ImageColor3 = ACCENT
trayGlow.ImageTransparency = 0.8
trayGlow.ZIndex = 9
trayGlow.Parent = trayIcon

-- Main container
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
container.Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
container.BackgroundTransparency = 1
container.Parent = screen

-- Outer glow
local glow = Instance.new("ImageLabel")
glow.Name = "Glow"
glow.AnchorPoint = Vector2.new(0.5,0.5)
glow.Size = UDim2.new(0, WIDTH+80, 0, HEIGHT+80)
glow.Position = UDim2.new(0.5, 0, 0.5, 0)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5050741616"
glow.ImageColor3 = ACCENT
glow.ImageTransparency = 0.92
glow.ZIndex = 1
glow.Parent = container

-- Card
local card = Instance.new("Frame")
card.Name = "Card"
card.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
card.Position = UDim2.new(0,0,0,0)
card.BackgroundColor3 = BG
card.BorderSizePixel = 0
card.Parent = container
card.ZIndex = 2

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 12)
cardCorner.Parent = card

-- inner container
local inner = Instance.new("Frame")
inner.Name = "Inner"
inner.Size = UDim2.new(1, -24, 1, -24)
inner.Position = UDim2.new(0, 12, 0, 12)
inner.BackgroundTransparency = 1
inner.Parent = card

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,48)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = inner

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6,0,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Text = "⚡ NEON HUB"
title.TextColor3 = Color3.fromRGB(255, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Window Controls
local windowControls = Instance.new("Frame")
windowControls.Size = UDim2.new(0, 120, 1, 0)
windowControls.Position = UDim2.new(1, -125, 0, 0)
windowControls.BackgroundTransparency = 1
windowControls.Parent = titleBar

-- Tombol Minimize (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
minimizeBtn.Position = UDim2.new(0, 0, 0.5, -16)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = windowControls

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Tombol Maximize (□)
local maximizeBtn = Instance.new("TextButton")
maximizeBtn.Name = "MaximizeBtn"
maximizeBtn.Size = UDim2.new(0, 32, 0, 32)
maximizeBtn.Position = UDim2.new(0, 40, 0.5, -16)
maximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
maximizeBtn.Font = Enum.Font.GothamBold
maximizeBtn.TextSize = 14
maximizeBtn.Text = "□"
maximizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
maximizeBtn.AutoButtonColor = false
maximizeBtn.Parent = windowControls

local maxCorner = Instance.new("UICorner")
maxCorner.CornerRadius = UDim.new(0, 6)
maxCorner.Parent = maximizeBtn

-- Tombol Close (🗙)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(0, 80, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Text = "🗙"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.AutoButtonColor = false
closeBtn.Parent = windowControls

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

local memLabel = Instance.new("TextLabel")
memLabel.Size = UDim2.new(0.4,-100,1,0)
memLabel.Position = UDim2.new(0.6,8,0,0)
memLabel.BackgroundTransparency = 1
memLabel.Font = Enum.Font.Gotham
memLabel.TextSize = 11
memLabel.Text = "Memory: 0 KB | FPS: 0"
memLabel.TextColor3 = Color3.fromRGB(200,200,200)
memLabel.TextXAlignment = Enum.TextXAlignment.Left
memLabel.Parent = titleBar

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -64)
sidebar.Position = UDim2.new(0, 0, 0, 56)
sidebar.BackgroundColor3 = SECOND
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 3
sidebar.Parent = inner

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 8)
sbCorner.Parent = sidebar

local sbHeader = Instance.new("Frame")
sbHeader.Size = UDim2.new(1,0,0,84)
sbHeader.BackgroundTransparency = 1
sbHeader.Parent = sidebar

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0,64,0,64)
logo.Position = UDim2.new(0, 12, 0, 10)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://3926305904"
logo.ImageColor3 = ACCENT
logo.Parent = sbHeader

local sTitle = Instance.new("TextLabel")
sTitle.Size = UDim2.new(1,-96,0,32)
sTitle.Position = UDim2.new(0, 88, 0, 12)
sTitle.BackgroundTransparency = 1
sTitle.Font = Enum.Font.GothamBold
sTitle.TextSize = 14
sTitle.Text = "NEON HUB"
sTitle.TextColor3 = Color3.fromRGB(240,240,240)
sTitle.TextXAlignment = Enum.TextXAlignment.Left
sTitle.Parent = sbHeader

local sSubtitle = Instance.new("TextLabel")
sSubtitle.Size = UDim2.new(1,-96,0,20)
sSubtitle.Position = UDim2.new(0, 88, 0, 44)
sSubtitle.BackgroundTransparency = 1
sSubtitle.Font = Enum.Font.Gotham
sSubtitle.TextSize = 10
sSubtitle.Text = "by Kaitun"
sSubtitle.TextColor3 = Color3.fromRGB(180,180,180)
sSubtitle.TextXAlignment = Enum.TextXAlignment.Left
sSubtitle.Parent = sbHeader

-- Menu
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(1,-12,1, -108)
menuFrame.Position = UDim2.new(0, 6, 0, 92)
menuFrame.BackgroundTransparency = 1
menuFrame.Parent = sidebar

local menuLayout = Instance.new("UIListLayout")
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.Padding = UDim.new(0,8)
menuLayout.Parent = menuFrame

local function makeMenuItem(name, iconText)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = Color3.fromRGB(20,20,20)
    row.AutoButtonColor = false
    row.BorderSizePixel = 0
    row.Text = ""
    row.Parent = menuFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = row

    local left = Instance.new("Frame")
    left.Size = UDim2.new(0,40,1,0)
    left.Position = UDim2.new(0,8,0,0)
    left.BackgroundTransparency = 1
    left.Parent = row

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1,0,1,0)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 18
    icon.Text = iconText
    icon.TextColor3 = ACCENT
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center
    icon.Parent = left

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8,0,1,0)
    label.Position = UDim2.new(0,56,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30,10,10)}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
    end)

    return row, label
end

local items = {
    {"Fishing", "🎣"},
    {"Teleport", "📍"},
    {"Settings", "⚙"},
}
local menuButtons = {}
for i, v in ipairs(items) do
    local btn, lbl = makeMenuItem(v[1], v[2])
    btn.LayoutOrder = i
    menuButtons[v[1]] = btn
end

-- Content panel
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -SIDEBAR_W - 36, 1, -64)
content.Position = UDim2.new(0, SIDEBAR_W + 24, 0, 56)
content.BackgroundColor3 = Color3.fromRGB(18,18,20)
content.BorderSizePixel = 0
content.Parent = inner

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = content

local cTitle = Instance.new("TextLabel")
cTitle.Size = UDim2.new(1, -24, 0, 44)
cTitle.Position = UDim2.new(0,12,0,12)
cTitle.BackgroundTransparency = 1
cTitle.Font = Enum.Font.GothamBold
cTitle.TextSize = 16
cTitle.Text = "Fishing"
cTitle.TextColor3 = Color3.fromRGB(245,245,245)
cTitle.TextXAlignment = Enum.TextXAlignment.Left
cTitle.Parent = content

-- ═══════════════════════════════════════════════════════════
-- PERUBAHAN BESAR: ENHANCED INSTANT FISHING FUNCTIONS BERDASARKAN CONSOLE
-- ═══════════════════════════════════════════════════════════

-- FUNGSI UNTUK MENDAPATKAN REMOTE DARI CONSOLE
local function FindFishingRemotes()
    print("[Fishing] Mencari fishing remotes berdasarkan console...")
    
    -- Coba cari dari Packages
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages then
        local net = packages:FindFirstChild("_Index")
        if net then
            local sleitnick = net:FindFirstChild("sleitnick_net@0.2.0")
            if sleitnick then
                local netRE = sleitnick:FindFirstChild("net.RE")
                if netRE then
                    fishingRemotes.FlyFishingEffect = netRE:FindFirstChild("FlyFishingEffect")
                    fishingRemotes.FishCaught = netRE:FindFirstChild("FishCaught")
                    fishingRemotes.ObtainedNewFishNotification = netRE:FindFirstChild("ObtainedNewFishNotification")
                    fishingRemotes.FishingStopped = netRE:FindFirstChild("FishingStopped")
                    fishingRemotes.FishingCompleted = netRE:FindFirstChild("FishingCompleted")
                    fishingRemotes.FishingMinigameChanged = netRE:FindFirstChild("FishingMinigameChanged")
                    fishingRemotes.CaughtFishVisual = netRE:FindFirstChild("CaughtFishVisual")
                    
                    print("[Fishing] Found remotes in Packages!")
                end
            end
        end
    end
    
    -- Coba cari dari Controllers
    local controllers = ReplicatedStorage:FindFirstChild("_Controllers")
    if controllers then
        local fishingController = controllers:FindFirstChild("FishingController")
        if fishingController then
            print("[Fishing] Found FishingController in _Controllers")
            
            -- Cari InputStates untuk simulasi input
            local inputStates = fishingController:FindFirstChild("InputStates")
            if inputStates then
                print("[Fishing] Found InputStates")
            end
            
            -- Cari WeightRanges untuk fish weight
            local weightRanges = fishingController:FindFirstChild("WeightRanges")
            if weightRanges then
                print("[Fishing] Found WeightRanges")
            end
            
            -- Cari GamepadStates untuk kontrol
            local gamepadStates = fishingController:FindFirstChild("GamepadStates")
            if gamepadStates then
                print("[Fishing] Found GamepadStates")
            end
        end
        
        local autoFishingController = controllers:FindFirstChild("AutoFishingController")
        if autoFishingController then
            print("[Fishing] Found AutoFishingController")
        end
    end
    
    -- Print status remotes
    for name, remote in pairs(fishingRemotes) do
        if remote then
            print("[Fishing] ✓ " .. name .. " found")
        else
            print("[Fishing] ✗ " .. name .. " not found")
        end
    end
end

-- Panggil fungsi untuk mencari remotes
FindFishingRemotes()

local function SafeGetCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function SafeGetHumanoid()
    local char = SafeGetCharacter()
    return char and char:FindFirstChild("Humanoid")
end

-- FUNGSI UTAMA: AUTO CAST (Melempar kail)
local function AutoCast()
    if not fishingActive then return false end
    
    -- Coba semua metode casting
    local success = false
    
    -- Method 1: Gunakan remote FlyFishingEffect untuk casting
    if fishingRemotes.FlyFishingEffect then
        pcall(function()
            fishingRemotes.FlyFishingEffect:FireServer("Cast")
            success = true
            print("[Fishing] Cast menggunakan FlyFishingEffect")
        end)
    end
    
    -- Method 2: Gunakan remote FishingCompleted untuk memulai fishing
    if fishingRemotes.FishingCompleted then
        pcall(function()
            fishingRemotes.FishingCompleted:FireServer("Start")
            success = true
            print("[Fishing] Start fishing menggunakan FishingCompleted")
        end)
    end
    
    -- Method 3: Simulasi input menggunakan InputStates jika ada
    pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild("_Controllers")
        if controllers then
            local fishingController = controllers:FindFirstChild("FishingController")
            if fishingController then
                local inputStates = fishingController:FindFirstChild("InputStates")
                if inputStates then
                    -- Simulasi input fishing
                    inputStates:FireServer("Fishing", true)
                    task.wait(0.1)
                    inputStates:FireServer("Fishing", false)
                    success = true
                    print("[Fishing] Cast menggunakan InputStates")
                end
            end
        end
    end)
    
    -- Method 4: Virtual input fallback
    if not success then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.001)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            success = true
            print("[Fishing] Cast menggunakan Virtual Input")
        end)
    end
    
    return success
end

-- FUNGSI UTAMA: AUTO REEL (Menarik ikan)
local function AutoReel()
    if not fishingActive then return false end
    
    local success = false
    
    -- Method 1: Gunakan remote FishCaught untuk reel
    if fishingRemotes.FishCaught then
        pcall(function()
            fishingRemotes.FishCaught:FireServer("Reel")
            success = true
            print("[Fishing] Reel menggunakan FishCaught")
        end)
    end
    
    -- Method 2: Gunakan remote CaughtFishVisual
    if fishingRemotes.CaughtFishVisual then
        pcall(function()
            fishingRemotes.CaughtFishVisual:FireServer()
            success = true
            print("[Fishing] Reel menggunakan CaughtFishVisual")
        end)
    end
    
    -- Method 3: Gunakan remote FishingCompleted untuk complete
    if fishingRemotes.FishingCompleted then
        pcall(function()
            fishingRemotes.FishingCompleted:FireServer("Complete")
            success = true
            print("[Fishing] Complete menggunakan FishingCompleted")
        end)
    end
    
    -- Method 4: Simulasi input reel
    pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild("_Controllers")
        if controllers then
            local fishingController = controllers:FindFirstChild("FishingController")
            if fishingController then
                local inputStates = fishingController:FindFirstChild("InputStates")
                if inputStates then
                    -- Simulasi input reel
                    inputStates:FireServer("Reel", true)
                    task.wait(0.1)
                    inputStates:FireServer("Reel", false)
                    success = true
                    print("[Fishing] Reel menggunakan InputStates")
                end
            end
        end
    end)
    
    -- Method 5: Virtual input untuk reel (biasanya tombol E atau F)
    if not success then
        pcall(function()
            -- Coba tombol E
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.001)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            
            -- Coba tombol F
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.001)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            
            success = true
            print("[Fishing] Reel menggunakan Virtual Input (E/F)")
        end)
    end
    
    return success
end

-- FUNGSI UTAMA: AUTO CATCH (Menangkap ikan)
local function AutoCatch()
    if not fishingActive then return false end
    
    local success = false
    
    -- Method 1: Gunakan remote FishingCompleted untuk catch
    if fishingRemotes.FishingCompleted then
        pcall(function()
            fishingRemotes.FishingCompleted:FireServer("Catch")
            success = true
            print("[Fishing] Catch menggunakan FishingCompleted")
        end)
    end
    
    -- Method 2: Gunakan remote FishCaught untuk catch
    if fishingRemotes.FishCaught then
        pcall(function()
            fishingRemotes.FishCaught:FireServer("Catch")
            success = true
            print("[Fishing] Catch menggunakan FishCaught")
        end)
    end
    
    -- Method 3: Notifikasi ikan baru
    if fishingRemotes.ObtainedNewFishNotification then
        pcall(function()
            fishingRemotes.ObtainedNewFishNotification:FireServer()
            success = true
            print("[Fishing] Notifikasi ikan baru")
        end)
    end
    
    -- Method 4: Simulasi mouse click untuk catch
    if not success then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.001)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            success = true
            print("[Fishing] Catch menggunakan Mouse Click")
        end)
    end
    
    if success then
        fishingStats.fishCaught = fishingStats.fishCaught + 1
        print("[Fishing] 🎣 Fish caught! Total: " .. fishingStats.fishCaught)
    end
    
    return success
end

-- FUNGSI AUTO FISHING COMPLETE CYCLE
local function AutoFishingCycle()
    if not fishingActive then return end
    
    fishingStats.attempts = fishingStats.attempts + 1
    
    -- 1. Cast fishing rod
    if AutoCast() then
        task.wait(0.2) -- Tunggu sedikit setelah cast
        
        -- 2. Auto reel (jika setting aktif)
        if fishingConfig.autoReel then
            for i = 1, 10 do -- Reel beberapa kali
                AutoReel()
                task.wait(0.05)
            end
        end
        
        -- 3. Catch fish
        AutoCatch()
        
        -- 4. Tunggu sebelum cast lagi
        if fishingConfig.blantantMode then
            task.wait(0.001) -- Ultra fast
        elseif fishingConfig.instantFishing then
            task.wait(0.01) -- Fast
        else
            task.wait(fishingConfig.fishingDelay)
        end
    end
end

-- START FISHING dengan semua remotes
local function StartFishing()
    if fishingActive then 
        print("[Fishing] Already fishing!")
        return 
    end
    
    fishingActive = true
    fishingStats.startTime = tick()
    
    print("[Fishing] =========================================")
    print("[Fishing] STARTING ENHANCED INSTANT FISHING")
    print("[Fishing] =========================================")
    print("[Fishing] Mode: " .. (fishingConfig.blantantMode and "BLASTANT" or "INSTANT"))
    print("[Fishing] Delay: " .. fishingConfig.fishingDelay)
    print("[Fishing] Auto Reel: " .. tostring(fishingConfig.autoReel))
    print("[Fishing] =========================================")
    
    -- Main fishing loop
    fishingConnection = RunService.Heartbeat:Connect(function()
        if not fishingActive then return end
        pcall(AutoFishingCycle)
    end)
    
    -- Extra reel loop untuk minigame (jika ada)
    if fishingConfig.autoReel then
        reelConnection = RunService.RenderStepped:Connect(function()
            if not fishingActive then return end
            pcall(function()
                -- Extra reel untuk memastikan
                AutoReel()
            end)
        end)
    end
end

local function StopFishing()
    fishingActive = false
    
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
    end
    
    if reelConnection then
        reelConnection:Disconnect()
        reelConnection = nil
    end
    
    print("[Fishing] =========================================")
    print("[Fishing] FISHING STOPPED")
    print("[Fishing] Total fish caught: " .. fishingStats.fishCaught)
    print("[Fishing] Total attempts: " .. fishingStats.attempts)
    if fishingStats.attempts > 0 then
        local successRate = (fishingStats.fishCaught / fishingStats.attempts) * 100
        print("[Fishing] Success rate: " .. string.format("%.2f", successRate) .. "%")
    end
    print("[Fishing] =========================================")
end

-- ═══════════════════════════════════════════════════════════
-- PERUBAHAN: FISHING UI MENJADI TOGGLE SWITCH SAJA
-- Layout yang lebih rapi dengan toggle switch tanpa button
-- ═══════════════════════════════════════════════════════════

local fishingContent = Instance.new("Frame")
fishingContent.Name = "FishingContent"
fishingContent.Size = UDim2.new(1, -24, 1, -24)
fishingContent.Position = UDim2.new(0, 12, 0, 12)
fishingContent.BackgroundTransparency = 1
fishingContent.Visible = true
fishingContent.Parent = content

-- Fishing Scroll Container
local fishingScroll = Instance.new("ScrollingFrame")
fishingScroll.Name = "FishingScroll"
fishingScroll.Size = UDim2.new(1, 0, 1, 0)
fishingScroll.Position = UDim2.new(0, 0, 0, 0)
fishingScroll.BackgroundTransparency = 1
fishingScroll.BorderSizePixel = 0
fishingScroll.ScrollBarThickness = 6
fishingScroll.ScrollBarImageColor3 = ACCENT
fishingScroll.Parent = fishingContent

local fishingList = Instance.new("UIListLayout")
fishingList.SortOrder = Enum.SortOrder.LayoutOrder
fishingList.Padding = UDim.new(0, 12)
fishingList.Parent = fishingScroll

-- ===========================================================
-- 1. STATUS PANEL
-- ===========================================================

local statsPanel = Instance.new("Frame")
statsPanel.Size = UDim2.new(1, -24, 0, 120)
statsPanel.Position = UDim2.new(0, 12, 0, 0)
statsPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
statsPanel.BorderSizePixel = 0
statsPanel.LayoutOrder = 1
statsPanel.Parent = fishingScroll

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0,8)
statsCorner.Parent = statsPanel

local statsTitle = Instance.new("TextLabel")
statsTitle.Size = UDim2.new(1, -24, 0, 28)
statsTitle.Position = UDim2.new(0,12,0,8)
statsTitle.BackgroundTransparency = 1
statsTitle.Font = Enum.Font.GothamBold
statsTitle.TextSize = 14
statsTitle.Text = "📊 Fishing Status"
statsTitle.TextColor3 = Color3.fromRGB(235,235,235)
statsTitle.TextXAlignment = Enum.TextXAlignment.Left
statsTitle.Parent = statsPanel

-- Fishing Status Toggle (Auto Fishing)
local fishingStatusFrame = Instance.new("Frame")
fishingStatusFrame.Size = UDim2.new(1, -24, 0, 40)
fishingStatusFrame.Position = UDim2.new(0, 12, 0, 40)
fishingStatusFrame.BackgroundTransparency = 1
fishingStatusFrame.Parent = statsPanel

local fishingStatusLabel = Instance.new("TextLabel")
fishingStatusLabel.Size = UDim2.new(0.7, 0, 1, 0)
fishingStatusLabel.BackgroundTransparency = 1
fishingStatusLabel.Font = Enum.Font.GothamBold
fishingStatusLabel.TextSize = 12
fishingStatusLabel.Text = "⚡ Auto Fishing"
fishingStatusLabel.TextColor3 = Color3.fromRGB(230,230,230)
fishingStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
fishingStatusLabel.Parent = fishingStatusFrame

local fishingToggle = Instance.new("TextButton")
fishingToggle.Size = UDim2.new(0, 60, 0, 28)
fishingToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
fishingToggle.BackgroundColor3 = fishingActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
fishingToggle.Font = Enum.Font.GothamBold
fishingToggle.TextSize = 11
fishingToggle.Text = fishingActive and "ON" or "OFF"
fishingToggle.TextColor3 = Color3.fromRGB(30,30,30)
fishingToggle.Parent = fishingStatusFrame

local fishingToggleCorner = Instance.new("UICorner")
fishingToggleCorner.CornerRadius = UDim.new(0,4)
fishingToggleCorner.Parent = fishingToggle

-- Status Indicator
local fishingIndicator = Instance.new("TextLabel")
fishingIndicator.Size = UDim2.new(1, -24, 0, 20)
fishingIndicator.Position = UDim2.new(0, 12, 0, 85)
fishingIndicator.BackgroundTransparency = 1
fishingIndicator.Font = Enum.Font.Gotham
fishingIndicator.TextSize = 10
fishingIndicator.Text = fishingActive and "✅ FISHING ACTIVE" or "⭕ FISHING OFF"
fishingIndicator.TextColor3 = fishingActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
fishingIndicator.TextXAlignment = Enum.TextXAlignment.Left
fishingIndicator.Parent = statsPanel

-- Fishing Toggle Handler
fishingToggle.MouseButton1Click:Connect(function()
    if fishingActive then
        StopFishing()
        fishingToggle.Text = "OFF"
        fishingToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        fishingIndicator.Text = "⭕ FISHING OFF"
        fishingIndicator.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        StartFishing()
        fishingToggle.Text = "ON"
        fishingToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        fishingIndicator.Text = "✅ FISHING ACTIVE"
        fishingIndicator.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

-- ===========================================================
-- 2. STATISTICS PANEL
-- ===========================================================

local statisticsPanel = Instance.new("Frame")
statisticsPanel.Size = UDim2.new(1, -24, 0, 100)
statisticsPanel.Position = UDim2.new(0, 12, 0, 0)
statisticsPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
statisticsPanel.BorderSizePixel = 0
statisticsPanel.LayoutOrder = 2
statisticsPanel.Parent = fishingScroll

local statisticsCorner = Instance.new("UICorner")
statisticsCorner.CornerRadius = UDim.new(0,8)
statisticsCorner.Parent = statisticsPanel

local statisticsTitle = Instance.new("TextLabel")
statisticsTitle.Size = UDim2.new(1, -24, 0, 28)
statisticsTitle.Position = UDim2.new(0,12,0,8)
statisticsTitle.BackgroundTransparency = 1
statisticsTitle.Font = Enum.Font.GothamBold
statisticsTitle.TextSize = 14
statisticsTitle.Text = "📈 Fishing Statistics"
statisticsTitle.TextColor3 = Color3.fromRGB(235,235,235)
statisticsTitle.TextXAlignment = Enum.TextXAlignment.Left
statisticsTitle.Parent = statisticsPanel

-- Fish Count
local fishCountLabel = Instance.new("TextLabel")
fishCountLabel.Size = UDim2.new(0.5, -8, 0, 24)
fishCountLabel.Position = UDim2.new(0,12,0,40)
fishCountLabel.BackgroundTransparency = 1
fishCountLabel.Font = Enum.Font.Gotham
fishCountLabel.TextSize = 12
fishCountLabel.Text = "🎣 Fish: 0"
fishCountLabel.TextColor3 = Color3.fromRGB(200,255,200)
fishCountLabel.TextXAlignment = Enum.TextXAlignment.Left
fishCountLabel.Parent = statisticsPanel

-- Rate
local rateLabel = Instance.new("TextLabel")
rateLabel.Size = UDim2.new(0.5, -8, 0, 24)
rateLabel.Position = UDim2.new(0.5,4,0,40)
rateLabel.BackgroundTransparency = 1
rateLabel.Font = Enum.Font.Gotham
rateLabel.TextSize = 12
rateLabel.Text = "📊 Rate: 0/s"
rateLabel.TextColor3 = Color3.fromRGB(200,220,255)
rateLabel.TextXAlignment = Enum.TextXAlignment.Left
rateLabel.Parent = statisticsPanel

-- Attempts
local attemptsLabel = Instance.new("TextLabel")
attemptsLabel.Size = UDim2.new(0.5, -8, 0, 24)
attemptsLabel.Position = UDim2.new(0,12,0,68)
attemptsLabel.BackgroundTransparency = 1
attemptsLabel.Font = Enum.Font.Gotham
attemptsLabel.TextSize = 12
attemptsLabel.Text = "🎯 Attempts: 0"
attemptsLabel.TextColor3 = Color3.fromRGB(255,220,200)
attemptsLabel.TextXAlignment = Enum.TextXAlignment.Left
attemptsLabel.Parent = statisticsPanel

-- Success Rate
local successLabel = Instance.new("TextLabel")
successLabel.Size = UDim2.new(0.5, -8, 0, 24)
successLabel.Position = UDim2.new(0.5,4,0,68)
successLabel.BackgroundTransparency = 1
successLabel.Font = Enum.Font.Gotham
successLabel.TextSize = 12
successLabel.Text = "✅ Success: 0%"
successLabel.TextColor3 = Color3.fromRGB(255,200,255)
successLabel.TextXAlignment = Enum.TextXAlignment.Left
successLabel.Parent = statisticsPanel

-- ===========================================================
-- 3. FISHING SETTINGS PANEL
-- ===========================================================

local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.new(1, -24, 0, 180)
settingsPanel.Position = UDim2.new(0, 12, 0, 0)
settingsPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
settingsPanel.BorderSizePixel = 0
settingsPanel.LayoutOrder = 3
settingsPanel.Parent = fishingScroll

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0,8)
settingsCorner.Parent = settingsPanel

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, -24, 0, 28)
settingsTitle.Position = UDim2.new(0,12,0,8)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 14
settingsTitle.Text = "⚙️ Fishing Settings"
settingsTitle.TextColor3 = Color3.fromRGB(235,235,235)
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = settingsPanel

-- Toggle Helper Function
local function CreateFishingToggle(name, desc, default, callback, parent, yPos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -24, 0, 36)
    frame.Position = UDim2.new(0, 12, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.7, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 0, 0, 18)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(180,180,180)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 24)
    button.Position = UDim2.new(0.75, 0, 0.2, 0)
    button.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 11
    button.Text = default and "ON" or "OFF"
    button.TextColor3 = Color3.fromRGB(30,30,30)
    button.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,4)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        local new = button.Text == "OFF"
        button.Text = new and "ON" or "OFF"
        button.BackgroundColor3 = new and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(new)
    end)

    return frame
end

-- Create Fishing Toggles
CreateFishingToggle("⚡ Instant Fishing", "Max speed casting & catching", fishingConfig.instantFishing, function(v)
    fishingConfig.instantFishing = v
    if v then
        fishingConfig.fishingDelay = 0.01
        print("[Fishing] Instant Fishing: ENABLED")
    else
        fishingConfig.fishingDelay = 0.1
        print("[Fishing] Instant Fishing: DISABLED")
    end
end, settingsPanel, 36)

CreateFishingToggle("💥 Blatant Mode", "Ultra fast (may be detected)", fishingConfig.blantantMode, function(v)
    fishingConfig.blantantMode = v
    if v then
        fishingConfig.fishingDelay = 0.001
        fishingConfig.instantFishing = true
        print("[Fishing] Blatant Mode: ENABLED (0.001s delay)")
    else
        fishingConfig.fishingDelay = 0.1
        fishingConfig.instantFishing = false
        print("[Fishing] Blatant Mode: DISABLED")
    end
end, settingsPanel, 76)

CreateFishingToggle("🎯 Perfect Cast", "Always perfect casting", fishingConfig.perfectCast, function(v)
    fishingConfig.perfectCast = v
    print("[Fishing] Perfect Cast:", v and "ENABLED" or "DISABLED")
end, settingsPanel, 116)

CreateFishingToggle("🔄 Auto Reel", "Auto reel minigame", fishingConfig.autoReel, function(v)
    fishingConfig.autoReel = v
    print("[Fishing] Auto Reel:", v and "ENABLED" or "DISABLED")
end, settingsPanel, 156)

-- ===========================================================
-- 4. REMOTE STATUS PANEL
-- ===========================================================

local remotePanel = Instance.new("Frame")
remotePanel.Size = UDim2.new(1, -24, 0, 80)
remotePanel.Position = UDim2.new(0, 12, 0, 0)
remotePanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
remotePanel.BorderSizePixel = 0
remotePanel.LayoutOrder = 4
remotePanel.Parent = fishingScroll

local remoteCorner = Instance.new("UICorner")
remoteCorner.CornerRadius = UDim.new(0,8)
remoteCorner.Parent = remotePanel

local remoteTitle = Instance.new("TextLabel")
remoteTitle.Size = UDim2.new(1, -24, 0, 28)
remoteTitle.Position = UDim2.new(0,12,0,8)
remoteTitle.BackgroundTransparency = 1
remoteTitle.Font = Enum.Font.GothamBold
remoteTitle.TextSize = 14
remoteTitle.Text = "🔗 Remote Status"
remoteTitle.TextColor3 = Color3.fromRGB(235,235,235)
remoteTitle.TextXAlignment = Enum.TextXAlignment.Left
remoteTitle.Parent = remotePanel

-- Remote Status
local remoteStatus = Instance.new("TextLabel")
remoteStatus.Size = UDim2.new(1, -24, 0, 40)
remoteStatus.Position = UDim2.new(0,12,0,40)
remoteStatus.BackgroundTransparency = 1
remoteStatus.Font = Enum.Font.Gotham
remoteStatus.TextSize = 11
remoteStatus.Text = "Searching for fishing remotes..."
remoteStatus.TextColor3 = Color3.fromRGB(180,180,180)
remoteStatus.TextXAlignment = Enum.TextXAlignment.Left
remoteStatus.TextWrapped = true
remoteStatus.Parent = remotePanel

-- Update remote status
spawn(function()
    task.wait(2)
    local foundCount = 0
    for _, remote in pairs(fishingRemotes) do
        if remote then foundCount = foundCount + 1 end
    end
    
    if foundCount > 0 then
        remoteStatus.Text = "✅ " .. foundCount .. " fishing remotes found!\nUsing optimized fishing methods."
        remoteStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        remoteStatus.Text = "⚠️ No fishing remotes found.\nUsing fallback fishing methods."
        remoteStatus.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
end)

-- Set Canvas Size
fishingScroll.CanvasSize = UDim2.new(0, 0, 0, 500)

-- ===========================================================
-- TELEPORT UI (DIPERBAIKI)
-- ===========================================================

local teleportContent = Instance.new("Frame")
teleportContent.Name = "TeleportContent"
teleportContent.Size = UDim2.new(1, -24, 1, -24)
teleportContent.Position = UDim2.new(0, 12, 0, 12)
teleportContent.BackgroundTransparency = 1
teleportContent.Visible = false
teleportContent.Parent = content

local teleportTitle = Instance.new("TextLabel")
teleportTitle.Size = UDim2.new(1, -24, 0, 28)
teleportTitle.Position = UDim2.new(0,12,0,8)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Font = Enum.Font.GothamBold
teleportTitle.TextSize = 14
teleportTitle.Text = "📍 Teleport Locations"
teleportTitle.TextColor3 = Color3.fromRGB(235,235,235)
teleportTitle.TextXAlignment = Enum.TextXAlignment.Left
teleportTitle.Parent = teleportContent

-- Teleport Locations List
local teleportScroll = Instance.new("ScrollingFrame")
teleportScroll.Size = UDim2.new(1, 0, 1, -40)
teleportScroll.Position = UDim2.new(0, 0, 0, 40)
teleportScroll.BackgroundTransparency = 1
teleportScroll.BorderSizePixel = 0
teleportScroll.ScrollBarThickness = 6
teleportScroll.ScrollBarImageColor3 = ACCENT
teleportScroll.Parent = teleportContent

local teleportList = Instance.new("UIListLayout")
teleportList.SortOrder = Enum.SortOrder.LayoutOrder
teleportList.Padding = UDim.new(0, 8)
teleportList.Parent = teleportScroll

-- Default Teleport Locations
local teleportLocations = {
    {Name = "🏝️ Spawn Point", Position = Vector3.new(0, 10, 0)},
    {Name = "🌊 Fishing Spot 1", Position = Vector3.new(50, 5, 50)},
    {Name = "🎣 Fishing Spot 2", Position = Vector3.new(-50, 5, -50)},
    {Name = "🏔️ Mountain Top", Position = Vector3.new(0, 100, 0)},
    {Name = "🏠 Village Center", Position = Vector3.new(100, 10, 100)},
    {Name = "🌲 Forest Area", Position = Vector3.new(-100, 5, 100)},
    {Name = "🏭 Factory Area", Position = Vector3.new(100, 5, -100)},
    {Name = "🚤 Boat Dock", Position = Vector3.new(0, 5, 150)}
}

-- Function to create teleport button
local function CreateTeleportButton(name, position, index)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 50)
    button.Position = UDim2.new(0, 12, 0, (index-1)*58)
    button.BackgroundColor3 = Color3.fromRGB(30,30,32)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Text = name
    button.TextColor3 = Color3.fromRGB(220,220,220)
    button.AutoButtonColor = false
    button.LayoutOrder = index
    button.Parent = teleportScroll

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0,6)
    buttonCorner.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,42)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30,30,32)}):Play()
    end)

    button.MouseButton1Click:Connect(function()
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(position)
                print("[Teleport] Teleported to: " .. name)
            end
        end
    end)

    return button
end

-- Create teleport buttons
for i, location in ipairs(teleportLocations) do
    CreateTeleportButton(location.Name, location.Position, i)
end

teleportScroll.CanvasSize = UDim2.new(0, 0, 0, #teleportLocations * 58)

-- ===========================================================
-- SETTINGS UI (DIPERBAIKI DENGAN FITUR BARU)
-- ===========================================================

local settingsContent = Instance.new("Frame")
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1, -24, 1, -24)
settingsContent.Position = UDim2.new(0, 12, 0, 12)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false
settingsContent.Parent = content

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, -24, 0, 28)
settingsTitle.Position = UDim2.new(0,12,0,8)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 14
settingsTitle.Text = "⚙️ Settings - NEON HUB"
settingsTitle.TextColor3 = Color3.fromRGB(235,235,235)
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = settingsContent

-- Settings Scroll
local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, 0, 1, -40)
settingsScroll.Position = UDim2.new(0, 0, 0, 40)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 6
settingsScroll.ScrollBarImageColor3 = ACCENT
settingsScroll.Parent = settingsContent

local settingsList = Instance.new("UIListLayout")
settingsList.SortOrder = Enum.SortOrder.LayoutOrder
settingsList.Padding = UDim.new(0, 12)
settingsList.Parent = settingsScroll

-- ===========================================================
-- FLY FUNCTION
-- ===========================================================

local flySection = Instance.new("Frame")
flySection.Size = UDim2.new(1, -24, 0, 120)
flySection.Position = UDim2.new(0, 12, 0, 0)
flySection.BackgroundColor3 = Color3.fromRGB(14,14,16)
flySection.BorderSizePixel = 0
flySection.LayoutOrder = 1
flySection.Parent = settingsScroll

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0,8)
flyCorner.Parent = flySection

local flyTitle = Instance.new("TextLabel")
flyTitle.Size = UDim2.new(1, -24, 0, 28)
flyTitle.Position = UDim2.new(0,12,0,8)
flyTitle.BackgroundTransparency = 1
flyTitle.Font = Enum.Font.GothamBold
flyTitle.TextSize = 14
flyTitle.Text = "✈️ Fly"
flyTitle.TextColor3 = Color3.fromRGB(235,235,235)
flyTitle.TextXAlignment = Enum.TextXAlignment.Left
flyTitle.Parent = flySection

-- Fly Toggle
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0, 80, 0, 32)
flyToggle.Position = UDim2.new(0, 12, 0, 40)
flyToggle.BackgroundColor3 = settingsConfig.flyEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 12
flyToggle.Text = settingsConfig.flyEnabled and "ON" or "OFF"
flyToggle.TextColor3 = Color3.fromRGB(30,30,30)
flyToggle.Parent = flySection

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0,4)
flyToggleCorner.Parent = flyToggle

-- Fly Speed Slider
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.5, -20, 0, 20)
flySpeedLabel.Position = UDim2.new(0, 120, 0, 45)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextSize = 12
flySpeedLabel.Text = "Speed: " .. settingsConfig.flySpeed
flySpeedLabel.TextColor3 = Color3.fromRGB(200,200,200)
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = flySection

local flySpeedSlider = Instance.new("TextBox")
flySpeedSlider.Size = UDim2.new(0, 60, 0, 24)
flySpeedSlider.Position = UDim2.new(0, 12, 0, 80)
flySpeedSlider.BackgroundColor3 = Color3.fromRGB(30,30,32)
flySpeedSlider.Font = Enum.Font.Gotham
flySpeedSlider.TextSize = 12
flySpeedSlider.Text = tostring(settingsConfig.flySpeed)
flySpeedSlider.TextColor3 = Color3.fromRGB(220,220,220)
flySpeedSlider.PlaceholderText = "Speed"
flySpeedSlider.Parent = flySection

local flySpeedSliderCorner = Instance.new("UICorner")
flySpeedSliderCorner.CornerRadius = UDim.new(0,4)
flySpeedSliderCorner.Parent = flySpeedSlider

-- Fly Controls Info
local flyInfo = Instance.new("TextLabel")
flyInfo.Size = UDim2.new(1, -24, 0, 40)
flyInfo.Position = UDim2.new(0, 12, 0, 110)
flyInfo.BackgroundTransparency = 1
flyInfo.Font = Enum.Font.Gotham
flyInfo.TextSize = 10
flyInfo.Text = "Controls: W/A/S/D to move, Space to go up, Ctrl to go down"
flyInfo.TextColor3 = Color3.fromRGB(150,150,150)
flyInfo.TextXAlignment = Enum.TextXAlignment.Left
flyInfo.Parent = flySection

-- Fly Functionality
local function ToggleFly()
    settingsConfig.flyEnabled = not settingsConfig.flyEnabled
    
    if settingsConfig.flyEnabled then
        flyToggle.Text = "ON"
        flyToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("[Fly] ENABLED")
        
        -- Start fly
        flyActive = true
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
            
            flyConnection = RunService.RenderStepped:Connect(function()
                if not flyActive then return end
                
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    local direction = Vector3.new(0, 0, 0)
                    
                    -- Movement controls
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        direction = direction + root.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        direction = direction - root.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        direction = direction - root.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        direction = direction + root.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        direction = direction + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                        direction = direction - Vector3.new(0, 1, 0)
                    end
                    
                    if direction.Magnitude > 0 then
                        direction = direction.Unit * settingsConfig.flySpeed
                        root.Velocity = direction
                    else
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        end
    else
        flyToggle.Text = "OFF"
        flyToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("[Fly] DISABLED")
        
        -- Stop fly
        flyActive = false
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

flyToggle.MouseButton1Click:Connect(ToggleFly)

flySpeedSlider.FocusLost:Connect(function()
    local speed = tonumber(flySpeedSlider.Text)
    if speed and speed >= 1 and speed <= 500 then
        settingsConfig.flySpeed = speed
        flySpeedLabel.Text = "Speed: " .. speed
        print("[Fly] Speed set to: " .. speed)
    else
        flySpeedSlider.Text = tostring(settingsConfig.flySpeed)
    end
end)

-- ===========================================================
-- WALK SPEED FUNCTION
-- ===========================================================

local walkSpeedSection = Instance.new("Frame")
walkSpeedSection.Size = UDim2.new(1, -24, 0, 100)
walkSpeedSection.Position = UDim2.new(0, 12, 0, 0)
walkSpeedSection.BackgroundColor3 = Color3.fromRGB(14,14,16)
walkSpeedSection.BorderSizePixel = 0
walkSpeedSection.LayoutOrder = 2
walkSpeedSection.Parent = settingsScroll

local walkSpeedCorner = Instance.new("UICorner")
walkSpeedCorner.CornerRadius = UDim.new(0,8)
walkSpeedCorner.Parent = walkSpeedSection

local walkSpeedTitle = Instance.new("TextLabel")
walkSpeedTitle.Size = UDim2.new(1, -24, 0, 28)
walkSpeedTitle.Position = UDim2.new(0,12,0,8)
walkSpeedTitle.BackgroundTransparency = 1
walkSpeedTitle.Font = Enum.Font.GothamBold
walkSpeedTitle.TextSize = 14
walkSpeedTitle.Text = "🏃‍♂️ Walk Speed"
walkSpeedTitle.TextColor3 = Color3.fromRGB(235,235,235)
walkSpeedTitle.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedTitle.Parent = walkSpeedSection

-- Walk Speed Slider
local walkSpeedValueLabel = Instance.new("TextLabel")
walkSpeedValueLabel.Size = UDim2.new(1, -24, 0, 20)
walkSpeedValueLabel.Position = UDim2.new(0, 12, 0, 40)
walkSpeedValueLabel.BackgroundTransparency = 1
walkSpeedValueLabel.Font = Enum.Font.Gotham
walkSpeedValueLabel.TextSize = 12
walkSpeedValueLabel.Text = "Current: " .. settingsConfig.walkSpeed
walkSpeedValueLabel.TextColor3 = Color3.fromRGB(200,200,200)
walkSpeedValueLabel.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedValueLabel.Parent = walkSpeedSection

local walkSpeedSlider = Instance.new("TextBox")
walkSpeedSlider.Size = UDim2.new(0, 100, 0, 24)
walkSpeedSlider.Position = UDim2.new(0, 12, 0, 65)
walkSpeedSlider.BackgroundColor3 = Color3.fromRGB(30,30,32)
walkSpeedSlider.Font = Enum.Font.Gotham
walkSpeedSlider.TextSize = 12
walkSpeedSlider.Text = tostring(settingsConfig.walkSpeed)
walkSpeedSlider.TextColor3 = Color3.fromRGB(220,220,220)
walkSpeedSlider.PlaceholderText = "Speed (16-200)"
walkSpeedSlider.Parent = walkSpeedSection

local walkSpeedSliderCorner = Instance.new("UICorner")
walkSpeedSliderCorner.CornerRadius = UDim.new(0,4)
walkSpeedSliderCorner.Parent = walkSpeedSlider

-- Apply Walk Speed Button
local applyWalkSpeedBtn = Instance.new("TextButton")
applyWalkSpeedBtn.Size = UDim2.new(0, 60, 0, 24)
applyWalkSpeedBtn.Position = UDim2.new(0, 120, 0, 65)
applyWalkSpeedBtn.BackgroundColor3 = ACCENT
applyWalkSpeedBtn.Font = Enum.Font.GothamBold
applyWalkSpeedBtn.TextSize = 12
applyWalkSpeedBtn.Text = "APPLY"
applyWalkSpeedBtn.TextColor3 = Color3.fromRGB(30,30,30)
applyWalkSpeedBtn.Parent = walkSpeedSection

local applyWalkSpeedCorner = Instance.new("UICorner")
applyWalkSpeedCorner.CornerRadius = UDim.new(0,4)
applyWalkSpeedCorner.Parent = applyWalkSpeedBtn

walkSpeedSlider.FocusLost:Connect(function()
    local speed = tonumber(walkSpeedSlider.Text)
    if speed and speed >= 16 and speed <= 200 then
        walkSpeedValueLabel.Text = "Current: " .. speed
        settingsConfig.walkSpeed = speed
    else
        walkSpeedSlider.Text = tostring(settingsConfig.walkSpeed)
    end
end)

applyWalkSpeedBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = settingsConfig.walkSpeed
            print("[Walk Speed] Set to: " .. settingsConfig.walkSpeed)
        end
    end
end)

-- ===========================================================
-- INFINITY JUMP FUNCTION
-- ===========================================================

local jumpSection = Instance.new("Frame")
jumpSection.Size = UDim2.new(1, -24, 0, 80)
jumpSection.Position = UDim2.new(0, 12, 0, 0)
jumpSection.BackgroundColor3 = Color3.fromRGB(14,14,16)
jumpSection.BorderSizePixel = 0
jumpSection.LayoutOrder = 3
jumpSection.Parent = settingsScroll

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0,8)
jumpCorner.Parent = jumpSection

local jumpTitle = Instance.new("TextLabel")
jumpTitle.Size = UDim2.new(1, -24, 0, 28)
jumpTitle.Position = UDim2.new(0,12,0,8)
jumpTitle.BackgroundTransparency = 1
jumpTitle.Font = Enum.Font.GothamBold
jumpTitle.TextSize = 14
jumpTitle.Text = "∞ Infinity Jump"
jumpTitle.TextColor3 = Color3.fromRGB(235,235,235)
jumpTitle.TextXAlignment = Enum.TextXAlignment.Left
jumpTitle.Parent = jumpSection

-- Infinity Jump Toggle
local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0, 80, 0, 32)
jumpToggle.Position = UDim2.new(0, 12, 0, 40)
jumpToggle.BackgroundColor3 = settingsConfig.infiniteJump and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
jumpToggle.Font = Enum.Font.GothamBold
jumpToggle.TextSize = 12
jumpToggle.Text = settingsConfig.infiniteJump and "ON" or "OFF"
jumpToggle.TextColor3 = Color3.fromRGB(30,30,30)
jumpToggle.Parent = jumpSection

local jumpToggleCorner = Instance.new("UICorner")
jumpToggleCorner.CornerRadius = UDim.new(0,4)
jumpToggleCorner.Parent = jumpToggle

-- Infinity Jump Function
local function ToggleInfiniteJump()
    settingsConfig.infiniteJump = not settingsConfig.infiniteJump
    
    if settingsConfig.infiniteJump then
        jumpToggle.Text = "ON"
        jumpToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("[Infinity Jump] ENABLED")
        
        infiniteJumpActive = true
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            if infiniteJumpActive then
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    else
        jumpToggle.Text = "OFF"
        jumpToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("[Infinity Jump] DISABLED")
        
        infiniteJumpActive = false
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end

jumpToggle.MouseButton1Click:Connect(ToggleInfiniteJump)

-- ===========================================================
-- ESP FUNCTION
-- ===========================================================

local espSection = Instance.new("Frame")
espSection.Size = UDim2.new(1, -24, 0, 100)
espSection.Position = UDim2.new(0, 12, 0, 0)
espSection.BackgroundColor3 = Color3.fromRGB(14,14,16)
espSection.BorderSizePixel = 0
espSection.LayoutOrder = 4
espSection.Parent = settingsScroll

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0,8)
espCorner.Parent = espSection

local espTitle = Instance.new("TextLabel")
espTitle.Size = UDim2.new(1, -24, 0, 28)
espTitle.Position = UDim2.new(0,12,0,8)
espTitle.BackgroundTransparency = 1
espTitle.Font = Enum.Font.GothamBold
espTitle.TextSize = 14
espTitle.Text = "👁️ ESP (Player Names)"
espTitle.TextColor3 = Color3.fromRGB(235,235,235)
espTitle.TextXAlignment = Enum.TextXAlignment.Left
espTitle.Parent = espSection

-- ESP Toggle
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 80, 0, 32)
espToggle.Position = UDim2.new(0, 12, 0, 40)
espToggle.BackgroundColor3 = settingsConfig.espEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 12
espToggle.Text = settingsConfig.espEnabled and "ON" or "OFF"
espToggle.TextColor3 = Color3.fromRGB(30,30,30)
espToggle.Parent = espSection

local espToggleCorner = Instance.new("UICorner")
espToggleCorner.CornerRadius = UDim.new(0,4)
espToggleCorner.Parent = espToggle

-- ESP Color Picker
local espColorLabel = Instance.new("TextLabel")
espColorLabel.Size = UDim2.new(0.5, -20, 0, 20)
espColorLabel.Position = UDim2.new(0, 120, 0, 45)
espColorLabel.BackgroundTransparency = 1
espColorLabel.Font = Enum.Font.Gotham
espColorLabel.TextSize = 11
espColorLabel.Text = "Color: RED"
espColorLabel.TextColor3 = Color3.fromRGB(200,200,200)
espColorLabel.TextXAlignment = Enum.TextXAlignment.Left
espColorLabel.Parent = espSection

-- ESP Function
local function CreateESP(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Create BillboardGui for name
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500
    billboard.Parent = humanoidRootPart
    
    -- Name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = settingsConfig.espColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Parent = billboard
    
    -- Distance label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.TextColor3 = settingsConfig.espColor
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.Parent = billboard
    
    -- Update distance
    espConnection = RunService.Heartbeat:Connect(function()
        if not espEnabled then return end
        
        local localPlayer = Players.LocalPlayer
        local localCharacter = localPlayer.Character
        if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then
            local distance = (humanoidRootPart.Position - localCharacter.HumanoidRootPart.Position).Magnitude
            distanceLabel.Text = string.format("%.1f studs", distance)
        end
    end)
    
    espBoxes[player] = billboard
    return billboard
end

local function ToggleESP()
    settingsConfig.espEnabled = not settingsConfig.espEnabled
    
    if settingsConfig.espEnabled then
        espToggle.Text = "ON"
        espToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("[ESP] ENABLED")
        
        espEnabled = true
        
        -- Create ESP for all players
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                if otherPlayer.Character then
                    CreateESP(otherPlayer)
                end
                
                otherPlayer.CharacterAdded:Connect(function(character)
                    if espEnabled then
                        wait(1) -- Wait for character to load
                        CreateESP(otherPlayer)
                    end
                end)
            end
        end
        
        -- Listen for new players
        Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(character)
                if espEnabled then
                    wait(1)
                    CreateESP(newPlayer)
                end
            end)
        end)
    else
        espToggle.Text = "OFF"
        espToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("[ESP] DISABLED")
        
        espEnabled = false
        
        -- Remove all ESP
        for _, box in pairs(espBoxes) do
            if box then
                box:Destroy()
            end
        end
        espBoxes = {}
        
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
    end
end

espToggle.MouseButton1Click:Connect(ToggleESP)

-- Set Canvas Size
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 500)

-- ===========================================================
-- MENU NAVIGATION
-- ===========================================================

local activeMenu = "Fishing"
for name, btn in pairs(menuButtons) do
    btn.MouseButton1Click:Connect(function()
        for n, b in pairs(menuButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20,20,20)
        end
        btn.BackgroundColor3 = Color3.fromRGB(32,8,8)
        
        cTitle.Text = name
        
        fishingContent.Visible = (name == "Fishing")
        teleportContent.Visible = (name == "Teleport")
        settingsContent.Visible = (name == "Settings")
        
        print("[UI] Switched to:", name)
    end)
end

-- Highlight fishing menu by default
menuButtons["Fishing"].BackgroundColor3 = Color3.fromRGB(32,8,8)

-- ===========================================================
-- WINDOW CONTROLS FUNCTIONALITY
-- ===========================================================

local uiOpen = true
local isMaximized = false
local originalSize = UDim2.new(0, WIDTH, 0, HEIGHT)
local originalPosition = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
local maximizedSize = UDim2.new(1, -40, 1, -40)
local maximizedPosition = UDim2.new(0, 20, 0, 20)

-- Show Tray Icon
local function showTrayIcon()
    trayIcon.Visible = true
    TweenService:Create(trayIcon, TweenInfo.new(0.3), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    TweenService:Create(trayGlow, TweenInfo.new(0.3), {ImageTransparency = 0.7}):Play()
end

-- Hide Tray Icon  
local function hideTrayIcon()
    TweenService:Create(trayIcon, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(trayGlow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
    wait(0.3)
    trayIcon.Visible = false
end

-- Show Main UI
local function showMainUI()
    container.Visible = true
    local targetSize = isMaximized and maximizedSize or originalSize
    local targetPosition = isMaximized and maximizedPosition or originalPosition
    
    TweenService:Create(container, TweenInfo.new(0.4), {
        Size = targetSize,
        Position = targetPosition
    }):Play()
    TweenService:Create(glow, TweenInfo.new(0.4), {ImageTransparency = 0.85}):Play()
    
    hideTrayIcon()
    uiOpen = true
    print("[UI] Main UI shown")
end

-- Hide Main UI (ke tray)
local function hideMainUI()
    TweenService:Create(container, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    TweenService:Create(glow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
    
    wait(0.3)
    container.Visible = false
    
    showTrayIcon()
    uiOpen = false
    print("[UI] Main UI hidden to tray")
end

-- Minimize Function
local function minimizeUI()
    hideMainUI()
end

-- Close Function  
local function closeUI()
    hideMainUI()
end

-- Maximize Function
local function maximizeUI()
    if not uiOpen then
        showMainUI()
        wait(0.4)
    end
    
    if isMaximized then
        -- Restore to original size
        TweenService:Create(container, TweenInfo.new(0.3), {
            Size = originalSize,
            Position = originalPosition
        }):Play()
        maximizeBtn.Text = "□"
        maximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        isMaximized = false
        print("[UI] Window restored to normal size")
    else
        -- Maximize to full screen
        TweenService:Create(container, TweenInfo.new(0.3), {
            Size = maximizedSize,
            Position = maximizedPosition
        }):Play()
        maximizeBtn.Text = "⧉"
        maximizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        isMaximized = true
        print("[UI] Window maximized")
    end
end

-- Tray Icon Click - Show Main UI
trayIcon.MouseButton1Click:Connect(function()
    showMainUI()
end)

-- Tray Icon Hover Effects
trayIcon.MouseEnter:Connect(function()
    TweenService:Create(trayIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 70, 0, 70)}):Play()
    TweenService:Create(trayGlow, TweenInfo.new(0.2), {ImageTransparency = 0.6}):Play()
end)

trayIcon.MouseLeave:Connect(function()
    TweenService:Create(trayIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    TweenService:Create(trayGlow, TweenInfo.new(0.2), {ImageTransparency = 0.7}):Play()
end)

-- Window Controls Hover Effects
minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
end)

minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
end)

maximizeBtn.MouseEnter:Connect(function()
    TweenService:Create(maximizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
end)

maximizeBtn.MouseLeave:Connect(function()
    if not isMaximized then
        TweenService:Create(maximizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    else
        TweenService:Create(maximizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 100)}):Play()
    end
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}):Play()
end)

-- Button Clicks
minimizeBtn.MouseButton1Click:Connect(minimizeUI)
maximizeBtn.MouseButton1Click:Connect(maximizeUI)
closeBtn.MouseButton1Click:Connect(closeUI)

-- Draggable Window
local dragging = false
local dragStart = Vector2.new(0, 0)
local containerStart = Vector2.new(0, 0)

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMaximized then
        dragging = true
        dragStart = input.Position
        containerStart = Vector2.new(container.Position.X.Offset, container.Position.Y.Offset)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        container.Position = UDim2.new(
            0, containerStart.X + delta.X,
            0, containerStart.Y + delta.Y
        )
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        container.Position = UDim2.new(
            0, containerStart.X + delta.X,
            0, containerStart.Y + delta.Y
        )
    end
end)

-- ===========================================================
-- STATS UPDATE LOOP
-- ===========================================================

local fps = 0
local frames = 0
local lastTime = tick()

spawn(function()
    while true do
        local elapsed = math.max(1, tick() - fishingStats.startTime)
        local rate = fishingStats.fishCaught / elapsed
        local successRate = fishingStats.attempts > 0 and (fishingStats.fishCaught / fishingStats.attempts) * 100 or 0
        
        fishCountLabel.Text = string.format("🎣 Fish: %d", fishingStats.fishCaught)
        rateLabel.Text = string.format("📊 Rate: %.2f/s", rate)
        attemptsLabel.Text = string.format("🎯 Attempts: %d", fishingStats.attempts)
        successLabel.Text = string.format("✅ Success: %.1f%%", successRate)
        
        -- Update FPS
        frames = frames + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            fps = frames
            frames = 0
            lastTime = currentTime
            memLabel.Text = string.format("Memory: %d KB | FPS: %d", math.floor(collectgarbage("count")), fps)
        end
        
        wait(0.5)
    end
end)

-- Start dengan UI terbuka
showMainUI()

print("==========================================")
print("⚡ NEON HUB LOADED SUCCESSFULLY!")
print("==========================================")
print("🎣 Fishing - Toggle switch only, clean layout")
print("📍 Teleport - 8 preset locations")
print("⚙️ Settings - Fly, Walk Speed, Infinity Jump, ESP")
print("==========================================")
print("🎯 Click - to minimize to tray")
print("🎯 Click □ to maximize window") 
print("🎯 Click 🗙 to close to tray")
print("🎯 Click tray icon to reopen UI")
print("🎯 Drag title bar to move window")
print("==========================================")

-- Test jika UI muncul
wait(1)
if screen and screen.Parent then
    print("✅ UI successfully created!")
else
    print("❌ UI failed to create!")
end