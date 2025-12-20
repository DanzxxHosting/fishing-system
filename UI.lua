-- NEON HUB v3.3 - ATOMIC FISHING STYLE
-- No Main Loop + Advanced Features
-- Tema: hitam matte + merah neon

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG UI
local WIDTH = 620
local HEIGHT = 460
local SIDEBAR_W = 200
local ACCENT = Color3.fromRGB(255, 62, 62)
local BG = Color3.fromRGB(12,12,12)
local SECOND = Color3.fromRGB(24,24,26)

-- ===========================================================
-- FISHING CONFIG - ATOMIC STYLE
-- ===========================================================
local fishingConfig = {
    autoFishing = false,
    instantFishing = false,
    ultraSpeed = false,
    skipMinigame = false,
    disableNotifications = false,
    notificationHookEnabled = false
}

-- ===========================================================
-- SETTINGS CONFIG
-- ===========================================================
local settingsConfig = {
    -- FLY SYSTEM
    flyEnabled = false,
    flySpeed = 50,
    
    -- ESP SYSTEM
    espEnabled = false,
    espNames = true,
    espColor = Color3.fromRGB(255, 50, 50),
    espTransparency = 0.3,
    
    -- CHARACTER MODS
    infiniteJump = false,
    walkSpeed = 32,           -- Default value
    jumpPower = 50,
    walkSpeedEnabled = false
}

-- ===========================================================
-- FISHING VARIABLES - NO MAIN LOOP
-- ===========================================================
local fishingRemotes = {
    FishCaught = nil, 
    ObtainedNewFishNotification = nil,
    FishingCompleted = nil,   
    FlyFishingEffect = nil,
    WaitingForBite = nil,
    MinigameStarted = nil
}

local fishingStats = {
    fishCaught = 0,
    startTime = tick(),
    attempts = 0,
    successRate = 0
}

local fishingActive = false
local fishingLoop
local atomicFishing = false

-- ===========================================================
-- SETTINGS VARIABLES
-- ===========================================================
local flyActive = false
local flyVelocity
local flyConnection

local espActive = false
local espBoxes = {}
local espConnection

local infiniteJumpActive = false
local jumpConnection

local walkSpeedActive = false
local originalWalkSpeed = 16
local originalJumpPower = 50

-- ===========================================================
-- ADVANCED NOTIFICATION SYSTEM - ATOMIC STYLE
-- ===========================================================
local originalNotificationFire = nil
local notificationHooked = false
local notificationBlacklist = {}

local function HookNotificationSystem()
    if fishingRemotes.ObtainedNewFishNotification and not notificationHooked then
        originalNotificationFire = fishingRemotes.ObtainedNewFishNotification.FireServer
        
        -- Hook untuk blokir notifikasi
        fishingRemotes.ObtainedNewFishNotification.FireServer = function(self, ...)
            if fishingConfig.notificationHookEnabled then
                -- Catat dalam blacklist untuk debug
                table.insert(notificationBlacklist, {
                    time = tick(),
                    args = {...}
                })
                -- Blokir notifikasi
                return nil
            else
                -- Jalankan fungsi original
                return originalNotificationFire(self, ...)
            end
        end
        
        notificationHooked = true
        print("[Notification] ✅ Hook installed - Notifications can be blocked")
        return true
    end
    return false
end

local function UnhookNotificationSystem()
    if fishingRemotes.ObtainedNewFishNotification and notificationHooked and originalNotificationFire then
        fishingRemotes.ObtainedNewFishNotification.FireServer = originalNotificationFire
        notificationHooked = false
        print("[Notification] ✅ Hook removed - Notifications restored")
        return true
    end
    return false
end

local function ToggleNotificationBlock(enabled)
    fishingConfig.disableNotifications = enabled
    fishingConfig.notificationHookEnabled = enabled
    
    if enabled then
        if fishingRemotes.ObtainedNewFishNotification then
            HookNotificationSystem()
        else
            print("[Notification] ⚠️ Remote not found yet, will hook when found")
        end
        print("[Notification] 🚫 Notifications will be blocked")
    else
        if notificationHooked then
            UnhookNotificationSystem()
        end
        print("[Notification] ✅ Notifications enabled")
    end
end

-- ===========================================================
-- WALK SPEED SLIDER SYSTEM
-- ===========================================================
local function UpdateWalkSpeed(value)
    settingsConfig.walkSpeed = math.clamp(value, 16, 200)
    
    if settingsConfig.walkSpeedEnabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = settingsConfig.walkSpeed
            end
        end
    end
end

local function ToggleWalkSpeed(enabled)
    settingsConfig.walkSpeedEnabled = enabled
    walkSpeedActive = enabled
    
    if enabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                originalWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = settingsConfig.walkSpeed
            end
        end
        
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = settingsConfig.walkSpeed
            end
        end)
    else
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
            end
        end
    end
end

-- ===========================================================
-- FLY SYSTEM
-- ===========================================================
local function ToggleFly(enabled)
    settingsConfig.flyEnabled = enabled
    
    if enabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
                
                flyVelocity = Instance.new("BodyVelocity")
                flyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                flyVelocity.P = 1000
                flyVelocity.Parent = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
                
                flyConnection = RunService.Heartbeat:Connect(function()
                    if character and flyVelocity then
                        local root = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
                        if root then
                            local direction = Vector3.new(0, 0, 0)
                            
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
                            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                direction = direction - Vector3.new(0, 1, 0)
                            end
                            
                            if direction.Magnitude > 0 then
                                direction = direction.Unit * settingsConfig.flySpeed
                            end
                            
                            flyVelocity.Velocity = direction
                        end
                    end
                end)
            end
        end
    else
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
            
            local root = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
            if root then
                for _, v in pairs(root:GetChildren()) do
                    if v:IsA("BodyVelocity") then
                        v:Destroy()
                    end
                end
            end
        end
    end
end

-- ===========================================================
-- INFINITE JUMP
-- ===========================================================
local function ToggleInfiniteJump(enabled)
    settingsConfig.infiniteJump = enabled
    
    if enabled then
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end

-- ===========================================================
-- REMOTE FINDER - ATOMIC STYLE
-- ===========================================================
local function FindFishingRemotesAtomic()
    print("[Fishing] Atomic remote scanning...")
    
    -- Cari remote dengan pattern Atomic Fishing
    local function QuickRemoteScan(parent, depth)
        if depth > 3 then return end
        
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("RemoteEvent") then
                local name = child.Name:lower()
                
                if name:find("fish") or name:find("catch") or name:find("fishing") then
                    if name:find("caught") then
                        fishingRemotes.FishCaught = fishingRemotes.FishCaught or child
                    elseif name:find("obtained") or name:find("notification") then
                        fishingRemotes.ObtainedNewFishNotification = fishingRemotes.ObtainedNewFishNotification or child
                    elseif name:find("complete") then
                        fishingRemotes.FishingCompleted = fishingRemotes.FishingCompleted or child
                    elseif name:find("fly") or name:find("cast") then
                        fishingRemotes.FlyFishingEffect = fishingRemotes.FlyFishingEffect or child
                    elseif name:find("wait") or name:find("bite") then
                        fishingRemotes.WaitingForBite = fishingRemotes.WaitingForBite or child
                    elseif name:find("minigame") or name:find("started") then
                        fishingRemotes.MinigameStarted = fishingRemotes.MinigameStarted or child
                    end
                end
            end
            
            QuickRemoteScan(child, depth + 1)
        end
    end
    
    -- Scan area yang penting
    QuickRemoteScan(ReplicatedStorage, 0)
    
    -- Cek jika ada Packages
    if ReplicatedStorage:FindFirstChild("Packages") then
        QuickRemoteScan(ReplicatedStorage.Packages, 0)
    end
    
    -- Print hasil
    print("[Fishing] Atomic scan results:")
    for name, remote in pairs(fishingRemotes) do
        print(string.format("  %s: %s", name, remote and "✅ Found" or "❌ Not Found"))
    end
    
    return fishingRemotes.FishCaught ~= nil
end

-- ===========================================================
-- ATOMIC FISHING SYSTEM - NO MAIN LOOP
-- ===========================================================
local function AtomicFishAction()
    if not fishingActive then return end
    
    fishingStats.attempts = fishingStats.attempts + 1
    
    -- 1. CAST menggunakan remote yang ada
    local function PerformCast()
        if fishingRemotes.FlyFishingEffect then
            pcall(function()
                fishingRemotes.FlyFishingEffect:FireServer()
                return true
            end)
        end
        
        if fishingRemotes.WaitingForBite then
            pcall(function()
                fishingRemotes.WaitingForBite:FireServer()
                return true
            end)
        end
        
        return false
    end
    
    -- 2. CATCH langsung tanpa delay berlebihan
    local function PerformCatch()
        -- Priority 1: FishCaught
        if fishingRemotes.FishCaught then
            pcall(function()
                fishingRemotes.FishCaught:FireServer()
                return true
            end)
        end
        
        -- Priority 2: ObtainedNewFishNotification (mungkin di-block)
        if fishingRemotes.ObtainedNewFishNotification then
            pcall(function()
                fishingRemotes.ObtainedNewFishNotification:FireServer()
                return true
            end)
        end
        
        -- Priority 3: FishingCompleted
        if fishingRemotes.FishingCompleted then
            pcall(function()
                fishingRemotes.FishingCompleted:FireServer()
                return true
            end)
        end
        
        return false
    end
    
    -- 3. SKIP MINIGAME jika ada
    local function SkipMinigameIfEnabled()
        if fishingConfig.skipMinigame and fishingRemotes.MinigameStarted then
            pcall(function()
                fishingRemotes.MinigameStarted:FireServer("Skip")
            end)
        end
    end
    
    -- EXECUTE ATOMIC FISHING
    if PerformCast() then
        -- Delay minimal berdasarkan mode
        local delayTime = fishingConfig.ultraSpeed and 0.01 or 
                         fishingConfig.instantFishing and 0.05 or 0.1
        
        task.wait(delayTime)
        
        if PerformCatch() then
            fishingStats.fishCaught = fishingStats.fishCaught + 1
        end
        
        SkipMinigameIfEnabled()
    end
end

local function StartAtomicFishing()
    if fishingActive then return end
    
    fishingActive = true
    fishingStats.startTime = tick()
    
    -- Setup notification hook
    if fishingConfig.disableNotifications and fishingRemotes.ObtainedNewFishNotification and not notificationHooked then
        HookNotificationSystem()
    end
    
    -- ATOMIC STYLE: Gunakan task.spawn tanpa loop terus menerus
    fishingLoop = task.spawn(function()
        while fishingActive do
            AtomicFishAction()
            
            -- Delay berdasarkan mode (Atomic style)
            local delay = fishingConfig.ultraSpeed and 0.05 or 
                         fishingConfig.instantFishing and 0.1 or 0.2
            
            -- Tambahkan random variance untuk menghindari pattern detection
            delay = delay + (math.random() * 0.05)
            
            task.wait(delay)
        end
    end)
    
    print("[Fishing] 🎣 ATOMIC FISHING STARTED")
    print("[Fishing] Mode:", fishingConfig.ultraSpeed and "ULTRA" or fishingConfig.instantFishing and "INSTANT" or "NORMAL")
end

local function StopAtomicFishing()
    fishingActive = false
    
    if fishingLoop then
        task.cancel(fishingLoop)
        fishingLoop = nil
    end
    
    if notificationHooked then
        UnhookNotificationSystem()
    end
    
    print("[Fishing] ⏹️ ATOMIC FISHING STOPPED")
    print("[Fishing] Fish caught:", fishingStats.fishCaught)
end

-- ===========================================================
-- UI SETUP - ATOMIC STYLE
-- ===========================================================
if playerGui:FindFirstChild("NeonDashboardUI") then
    playerGui.NeonDashboardUI:Destroy()
end

local screen = Instance.new("ScreenGui")
screen.Name = "NeonDashboardUI"
screen.ResetOnSpawn = false
screen.Parent = playerGui
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- TRAY ICON
local trayIcon = Instance.new("ImageButton")
trayIcon.Name = "TrayIcon"
trayIcon.Size = UDim2.new(0, 50, 0, 50)
trayIcon.Position = UDim2.new(1, -60, 0, 20)
trayIcon.BackgroundColor3 = ACCENT
trayIcon.Image = "rbxassetid://3926305904"
trayIcon.Visible = false
trayIcon.ZIndex = 10
trayIcon.Parent = screen

local trayCorner = Instance.new("UICorner")
trayCorner.CornerRadius = UDim.new(0, 10)
trayCorner.Parent = trayIcon

local trayGlow = Instance.new("ImageLabel")
trayGlow.Name = "TrayGlow"
trayGlow.Size = UDim2.new(1, 15, 1, 15)
trayGlow.Position = UDim2.new(0, -7.5, 0, -7.5)
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

local glow = Instance.new("ImageLabel")
glow.Name = "Glow"
glow.AnchorPoint = Vector2.new(0.5,0.5)
glow.Size = UDim2.new(0, WIDTH+60, 0, HEIGHT+60)
glow.Position = UDim2.new(0.5, 0, 0.5, 0)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5050741616"
glow.ImageColor3 = ACCENT
glow.ImageTransparency = 0.92
glow.ZIndex = 1
glow.Parent = container

local card = Instance.new("Frame")
card.Name = "Card"
card.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
card.Position = UDim2.new(0,0,0,0)
card.BackgroundColor3 = BG
card.BorderSizePixel = 0
card.Parent = container
card.ZIndex = 2

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 10)
cardCorner.Parent = card

local inner = Instance.new("Frame")
inner.Name = "Inner"
inner.Size = UDim2.new(1, -20, 1, -20)
inner.Position = UDim2.new(0, 10, 0, 10)
inner.BackgroundTransparency = 1
inner.Parent = card

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = inner

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6,0,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Text = "⚡ NEON HUB v3.3"
title.TextColor3 = Color3.fromRGB(255, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local windowControls = Instance.new("Frame")
windowControls.Size = UDim2.new(0, 100, 1, 0)
windowControls.Position = UDim2.new(1, -105, 0, 0)
windowControls.BackgroundTransparency = 1
windowControls.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(0, 0, 0.5, -14)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = windowControls

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = minimizeBtn

local maximizeBtn = Instance.new("TextButton")
maximizeBtn.Name = "MaximizeBtn"
maximizeBtn.Size = UDim2.new(0, 28, 0, 28)
maximizeBtn.Position = UDim2.new(0, 36, 0.5, -14)
maximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
maximizeBtn.Font = Enum.Font.GothamBold
maximizeBtn.TextSize = 12
maximizeBtn.Text = "□"
maximizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
maximizeBtn.AutoButtonColor = false
maximizeBtn.Parent = windowControls

local maxCorner = Instance.new("UICorner")
maxCorner.CornerRadius = UDim.new(0, 5)
maxCorner.Parent = maximizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(0, 72, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Text = "🗙"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.AutoButtonColor = false
closeBtn.Parent = windowControls

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

local memLabel = Instance.new("TextLabel")
memLabel.Size = UDim2.new(0.4,-100,1,0)
memLabel.Position = UDim2.new(0.6,8,0,0)
memLabel.BackgroundTransparency = 1
memLabel.Font = Enum.Font.Gotham
memLabel.TextSize = 10
memLabel.Text = "Memory: 0 KB | FPS: 0"
memLabel.TextColor3 = Color3.fromRGB(200,200,200)
memLabel.TextXAlignment = Enum.TextXAlignment.Left
memLabel.Parent = titleBar

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -56)
sidebar.Position = UDim2.new(0, 0, 0, 48)
sidebar.BackgroundColor3 = SECOND
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 3
sidebar.Parent = inner

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 8)
sbCorner.Parent = sidebar

local sbHeader = Instance.new("Frame")
sbHeader.Size = UDim2.new(1,0,0,70)
sbHeader.BackgroundTransparency = 1
sbHeader.Parent = sidebar

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0,50,0,50)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://3926305904"
logo.ImageColor3 = ACCENT
logo.Parent = sbHeader

local sTitle = Instance.new("TextLabel")
sTitle.Size = UDim2.new(1,-70,0,24)
sTitle.Position = UDim2.new(0, 68, 0, 12)
sTitle.BackgroundTransparency = 1
sTitle.Font = Enum.Font.GothamBold
sTitle.TextSize = 13
sTitle.Text = "NEON HUB"
sTitle.TextColor3 = Color3.fromRGB(240,240,240)
sTitle.TextXAlignment = Enum.TextXAlignment.Left
sTitle.Parent = sbHeader

local sSubtitle = Instance.new("TextLabel")
sSubtitle.Size = UDim2.new(1,-70,0,18)
sSubtitle.Position = UDim2.new(0, 68, 0, 36)
sSubtitle.BackgroundTransparency = 1
sSubtitle.Font = Enum.Font.Gotham
sSubtitle.TextSize = 9
sSubtitle.Text = "Atomic Style v3.3"
sSubtitle.TextColor3 = Color3.fromRGB(180,180,180)
sSubtitle.TextXAlignment = Enum.TextXAlignment.Left
sSubtitle.Parent = sbHeader

-- Menu
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(1,-8,1, -86)
menuFrame.Position = UDim2.new(0, 4, 0, 78)
menuFrame.BackgroundTransparency = 1
menuFrame.Parent = sidebar

local menuLayout = Instance.new("UIListLayout")
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.Padding = UDim.new(0,6)
menuLayout.Parent = menuFrame

local function makeMenuItem(name, iconText)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(20,20,20)
    row.AutoButtonColor = false
    row.BorderSizePixel = 0
    row.Text = ""
    row.Parent = menuFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = row

    local left = Instance.new("Frame")
    left.Size = UDim2.new(0,36,1,0)
    left.Position = UDim2.new(0,6,0,0)
    left.BackgroundTransparency = 1
    left.Parent = row

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1,0,1,0)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 16
    icon.Text = iconText
    icon.TextColor3 = ACCENT
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center
    icon.Parent = left

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8,0,1,0)
    label.Position = UDim2.new(0,48,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
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
    {"Settings", "⚙"},
    {"Teleport", "📍"},
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
content.Size = UDim2.new(1, -SIDEBAR_W - 28, 1, -56)
content.Position = UDim2.new(0, SIDEBAR_W + 20, 0, 48)
content.BackgroundColor3 = Color3.fromRGB(18,18,20)
content.BorderSizePixel = 0
content.Parent = inner

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = content

local cTitle = Instance.new("TextLabel")
cTitle.Size = UDim2.new(1, -20, 0, 36)
cTitle.Position = UDim2.new(0,10,0,8)
cTitle.BackgroundTransparency = 1
cTitle.Font = Enum.Font.GothamBold
cTitle.TextSize = 15
cTitle.Text = "Fishing"
cTitle.TextColor3 = Color3.fromRGB(245,245,245)
cTitle.TextXAlignment = Enum.TextXAlignment.Left
cTitle.Parent = content

-- ===========================================================
-- MODERN TOGGLE FUNCTION
-- ===========================================================
local function CreateModernToggle(name, desc, default, callback, parent, yPos)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 45)
    toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent

    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(0.7, 0, 1, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = toggleFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.Position = UDim2.new(0, 0, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = textContainer

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, 0, 0, 18)
    descLabel.Position = UDim2.new(0, 0, 0, 24)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = textContainer

    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, 50, 0, 26)
    toggleContainer.Position = UDim2.new(1, -52, 0.5, -13)
    toggleContainer.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    toggleContainer.Parent = toggleFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleContainer

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.Parent = toggleContainer

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle

    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.Parent = toggleContainer

    local function toggleState()
        local newState = not default
        default = newState
        
        if newState then
            TweenService:Create(toggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 0)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10)}):Play()
        else
            TweenService:Create(toggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
        end
        
        callback(newState)
    end

    clickArea.MouseButton1Click:Connect(toggleState)
    
    if not default then
        toggleContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
    end

    return toggleFrame
end

-- ===========================================================
-- SLIDER FUNCTION
-- ===========================================================
local function CreateSlider(name, minValue, maxValue, defaultValue, callback, parent, yPos)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 11
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = ACCENT
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame

    local sliderBackground = Instance.new("Frame")
    sliderBackground.Size = UDim2.new(1, 0, 0, 20)
    sliderBackground.Position = UDim2.new(0, 0, 0, 25)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderFrame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 4)
    bgCorner.Parent = sliderBackground

    local sliderFill = Instance.new("Frame")
    local fillWidth = ((defaultValue - minValue) / (maxValue - minValue)) * 100
    sliderFill.Size = UDim2.new(0, fillWidth, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = ACCENT
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = sliderFill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 30, 2, 0)
    sliderButton.Position = UDim2.new(0, fillWidth - 15, -0.5, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBackground

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = sliderButton

    local dragging = false
    
    local function updateSlider(xPos)
        local relativeX = math.clamp(xPos, 0, sliderBackground.AbsoluteSize.X)
        local percentage = relativeX / sliderBackground.AbsoluteSize.X
        local value = math.floor(minValue + (maxValue - minValue) * percentage)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, -15, -0.5, 0)
        valueLabel.Text = tostring(value)
        
        callback(value)
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local xPos = input.Position.X - sliderBackground.AbsolutePosition.X
            updateSlider(xPos)
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local xPos = input.Position.X - sliderBackground.AbsolutePosition.X
            updateSlider(xPos)
        end
    end)
    
    return sliderFrame
end

-- ===========================================================
-- FISHING UI CONTENT
-- ===========================================================
local fishingContent = Instance.new("Frame")
fishingContent.Name = "FishingContent"
fishingContent.Size = UDim2.new(1, -20, 1, -20)
fishingContent.Position = UDim2.new(0, 10, 0, 10)
fishingContent.BackgroundTransparency = 1
fishingContent.Visible = true
fishingContent.Parent = content

local fishingScroll = Instance.new("ScrollingFrame")
fishingScroll.Name = "FishingScroll"
fishingScroll.Size = UDim2.new(1, 0, 1, 0)
fishingScroll.Position = UDim2.new(0, 0, 0, 0)
fishingScroll.BackgroundTransparency = 1
fishingScroll.BorderSizePixel = 0
fishingScroll.ScrollBarThickness = 5
fishingScroll.ScrollBarImageColor3 = ACCENT
fishingScroll.Parent = fishingContent

local fishingList = Instance.new("UIListLayout")
fishingList.SortOrder = Enum.SortOrder.LayoutOrder
fishingList.Padding = UDim.new(0, 10)
fishingList.Parent = fishingScroll

-- Status Panel
local statsPanel = Instance.new("Frame")
statsPanel.Size = UDim2.new(1, -20, 0, 120)
statsPanel.Position = UDim2.new(0, 10, 0, 0)
statsPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
statsPanel.BorderSizePixel = 0
statsPanel.LayoutOrder = 1
statsPanel.Parent = fishingScroll

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0,6)
statsCorner.Parent = statsPanel

local statsTitle = Instance.new("TextLabel")
statsTitle.Size = UDim2.new(1, -20, 0, 24)
statsTitle.Position = UDim2.new(0,10,0,6)
statsTitle.BackgroundTransparency = 1
statsTitle.Font = Enum.Font.GothamBold
statsTitle.TextSize = 13
statsTitle.Text = "📊 Fishing Status"
statsTitle.TextColor3 = Color3.fromRGB(235,235,235)
statsTitle.TextXAlignment = Enum.TextXAlignment.Left
statsTitle.Parent = statsPanel

CreateModernToggle("⚡ Auto Fishing", "Atomic style - no main loop", fishingActive, function(v)
    if v then
        StartAtomicFishing()
    else
        StopAtomicFishing()
    end
end, statsPanel, 35)

local fishingIndicator = Instance.new("TextLabel")
fishingIndicator.Size = UDim2.new(1, -20, 0, 18)
fishingIndicator.Position = UDim2.new(0, 10, 0, 90)
fishingIndicator.BackgroundTransparency = 1
fishingIndicator.Font = Enum.Font.Gotham
fishingIndicator.TextSize = 9
fishingIndicator.Text = fishingActive and "✅ FISHING ACTIVE" or "⭕ FISHING OFF"
fishingIndicator.TextColor3 = fishingActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
fishingIndicator.TextXAlignment = Enum.TextXAlignment.Left
fishingIndicator.Parent = statsPanel

-- Statistics Panel
local statisticsPanel = Instance.new("Frame")
statisticsPanel.Size = UDim2.new(1, -20, 0, 100)
statisticsPanel.Position = UDim2.new(0, 10, 0, 0)
statisticsPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
statisticsPanel.BorderSizePixel = 0
statisticsPanel.LayoutOrder = 2
statisticsPanel.Parent = fishingScroll

local statisticsCorner = Instance.new("UICorner")
statisticsCorner.CornerRadius = UDim.new(0,6)
statisticsCorner.Parent = statisticsPanel

local statisticsTitle = Instance.new("TextLabel")
statisticsTitle.Size = UDim2.new(1, -20, 0, 24)
statisticsTitle.Position = UDim2.new(0,10,0,6)
statisticsTitle.BackgroundTransparency = 1
statisticsTitle.Font = Enum.Font.GothamBold
statisticsTitle.TextSize = 13
statisticsTitle.Text = "📈 Fishing Statistics"
statisticsTitle.TextColor3 = Color3.fromRGB(235,235,235)
statisticsTitle.TextXAlignment = Enum.TextXAlignment.Left
statisticsTitle.Parent = statisticsPanel

local fishCountLabel = Instance.new("TextLabel")
fishCountLabel.Size = UDim2.new(0.5, -6, 0, 20)
fishCountLabel.Position = UDim2.new(0,10,0,34)
fishCountLabel.BackgroundTransparency = 1
fishCountLabel.Font = Enum.Font.Gotham
fishCountLabel.TextSize = 11
fishCountLabel.Text = "🎣 Fish: 0"
fishCountLabel.TextColor3 = Color3.fromRGB(200,255,200)
fishCountLabel.TextXAlignment = Enum.TextXAlignment.Left
fishCountLabel.Parent = statisticsPanel

local rateLabel = Instance.new("TextLabel")
rateLabel.Size = UDim2.new(0.5, -6, 0, 20)
rateLabel.Position = UDim2.new(0.5,2,0,34)
rateLabel.BackgroundTransparency = 1
rateLabel.Font = Enum.Font.Gotham
rateLabel.TextSize = 11
rateLabel.Text = "📊 Rate: 0/s"
rateLabel.TextColor3 = Color3.fromRGB(200,220,255)
rateLabel.TextXAlignment = Enum.TextXAlignment.Left
rateLabel.Parent = statisticsPanel

local attemptsLabel = Instance.new("TextLabel")
attemptsLabel.Size = UDim2.new(0.5, -6, 0, 20)
attemptsLabel.Position = UDim2.new(0,10,0,58)
attemptsLabel.BackgroundTransparency = 1
attemptsLabel.Font = Enum.Font.Gotham
attemptsLabel.TextSize = 11
attemptsLabel.Text = "🎯 Attempts: 0"
attemptsLabel.TextColor3 = Color3.fromRGB(255,220,200)
attemptsLabel.TextXAlignment = Enum.TextXAlignment.Left
attemptsLabel.Parent = statisticsPanel

local successLabel = Instance.new("TextLabel")
successLabel.Size = UDim2.new(0.5, -6, 0, 20)
successLabel.Position = UDim2.new(0.5,2,0,58)
successLabel.BackgroundTransparency = 1
successLabel.Font = Enum.Font.Gotham
successLabel.TextSize = 11
successLabel.Text = "✅ Success: 0%"
successLabel.TextColor3 = Color3.fromRGB(255,200,255)
successLabel.TextXAlignment = Enum.TextXAlignment.Left
successLabel.Parent = statisticsPanel

-- Fishing Settings Panel
local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.new(1, -20, 0, 260)
settingsPanel.Position = UDim2.new(0, 10, 0, 0)
settingsPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
settingsPanel.BorderSizePixel = 0
settingsPanel.LayoutOrder = 3
settingsPanel.Parent = fishingScroll

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0,6)
settingsCorner.Parent = settingsPanel

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, -20, 0, 24)
settingsTitle.Position = UDim2.new(0,10,0,6)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 13
settingsTitle.Text = "⚙️ Fishing Settings"
settingsTitle.TextColor3 = Color3.fromRGB(235,235,235)
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = settingsPanel

local yPos = 35
CreateModernToggle("⚡ Instant Fishing", "Atomic instant fishing", fishingConfig.instantFishing, function(v)
    fishingConfig.instantFishing = v
end, settingsPanel, yPos)

yPos = yPos + 45
CreateModernToggle("🚀 Ultra Speed", "Maximum atomic speed", fishingConfig.ultraSpeed, function(v)
    fishingConfig.ultraSpeed = v
end, settingsPanel, yPos)

yPos = yPos + 45
CreateModernToggle("🎮 Skip Minigame", "Skip fishing minigame", fishingConfig.skipMinigame, function(v)
    fishingConfig.skipMinigame = v
end, settingsPanel, yPos)

yPos = yPos + 45
CreateModernToggle("🔇 Block Notifications", "Hide fish catch notifications", fishingConfig.disableNotifications, function(v)
    ToggleNotificationBlock(v)
end, settingsPanel, yPos)

fishingScroll.CanvasSize = UDim2.new(0, 0, 0, 450)

-- ===========================================================
-- SETTINGS UI CONTENT WITH SLIDERS
-- ===========================================================
local settingsContent = Instance.new("Frame")
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1, -20, 1, -20)
settingsContent.Position = UDim2.new(0, 10, 0, 10)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false
settingsContent.Parent = content

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Name = "SettingsScroll"
settingsScroll.Size = UDim2.new(1, 0, 1, 0)
settingsScroll.Position = UDim2.new(0, 0, 0, 0)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 5
settingsScroll.ScrollBarImageColor3 = ACCENT
settingsScroll.Parent = settingsContent

local settingsList = Instance.new("UIListLayout")
settingsList.SortOrder = Enum.SortOrder.LayoutOrder
settingsList.Padding = UDim.new(0, 10)
settingsList.Parent = settingsScroll

-- Walk Speed Slider Panel
local walkSpeedPanel = Instance.new("Frame")
walkSpeedPanel.Size = UDim2.new(1, -20, 0, 120)
walkSpeedPanel.Position = UDim2.new(0, 10, 0, 0)
walkSpeedPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
walkSpeedPanel.BorderSizePixel = 0
walkSpeedPanel.LayoutOrder = 1
walkSpeedPanel.Parent = settingsScroll

local wsCorner = Instance.new("UICorner")
wsCorner.CornerRadius = UDim.new(0,6)
wsCorner.Parent = walkSpeedPanel

local wsTitle = Instance.new("TextLabel")
wsTitle.Size = UDim2.new(1, -20, 0, 24)
wsTitle.Position = UDim2.new(0,10,0,6)
wsTitle.BackgroundTransparency = 1
wsTitle.Font = Enum.Font.GothamBold
wsTitle.TextSize = 13
wsTitle.Text = "🏃 Walk Speed Settings"
wsTitle.TextColor3 = Color3.fromRGB(235,235,235)
wsTitle.TextXAlignment = Enum.TextXAlignment.Left
wsTitle.Parent = walkSpeedPanel

CreateModernToggle("🚶 Enable Walk Speed", "Enable custom walk speed", settingsConfig.walkSpeedEnabled, function(v)
    ToggleWalkSpeed(v)
end, walkSpeedPanel, 30)

-- Slider untuk Walk Speed
CreateSlider("Walk Speed Value", 16, 200, settingsConfig.walkSpeed, function(value)
    UpdateWalkSpeed(value)
end, walkSpeedPanel, 75)

-- Fly Settings Panel
local flyPanel = Instance.new("Frame")
flyPanel.Size = UDim2.new(1, -20, 0, 100)
flyPanel.Position = UDim2.new(0, 10, 0, 0)
flyPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
flyPanel.BorderSizePixel = 0
flyPanel.LayoutOrder = 2
flyPanel.Parent = settingsScroll

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0,6)
flyCorner.Parent = flyPanel

local flyTitle = Instance.new("TextLabel")
flyTitle.Size = UDim2.new(1, -20, 0, 24)
flyTitle.Position = UDim2.new(0,10,0,6)
flyTitle.BackgroundTransparency = 1
flyTitle.Font = Enum.Font.GothamBold
flyTitle.TextSize = 13
flyTitle.Text = "🕊️ Fly Settings"
flyTitle.TextColor3 = Color3.fromRGB(235,235,235)
flyTitle.TextXAlignment = Enum.TextXAlignment.Left
flyTitle.Parent = flyPanel

CreateModernToggle("✈️ Enable Fly", "Enable flying ability", settingsConfig.flyEnabled, function(v)
    ToggleFly(v)
end, flyPanel, 35)

-- Character Settings Panel
local charPanel = Instance.new("Frame")
charPanel.Size = UDim2.new(1, -20, 0, 100)
charPanel.Position = UDim2.new(0, 10, 0, 0)
charPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
charPanel.BorderSizePixel = 0
charPanel.LayoutOrder = 3
charPanel.Parent = settingsScroll

local charCorner = Instance.new("UICorner")
charCorner.CornerRadius = UDim.new(0,6)
charCorner.Parent = charPanel

local charTitle = Instance.new("TextLabel")
charTitle.Size = UDim2.new(1, -20, 0, 24)
charTitle.Position = UDim2.new(0,10,0,6)
charTitle.BackgroundTransparency = 1
charTitle.Font = Enum.Font.GothamBold
charTitle.TextSize = 13
charTitle.Text = "🏃 Character Settings"
charTitle.TextColor3 = Color3.fromRGB(235,235,235)
charTitle.TextXAlignment = Enum.TextXAlignment.Left
charTitle.Parent = charPanel

CreateModernToggle("🦘 Infinite Jump", "Enable infinite jumping", settingsConfig.infiniteJump, function(v)
    ToggleInfiniteJump(v)
end, charPanel, 35)

settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 350)

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
        settingsContent.Visible = (name == "Settings")
    end)
end

menuButtons["Fishing"].BackgroundColor3 = Color3.fromRGB(32,8,8)

-- ===========================================================
-- WINDOW CONTROLS
-- ===========================================================
local uiOpen = true
local isMaximized = false
local originalSize = UDim2.new(0, WIDTH, 0, HEIGHT)
local originalPosition = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2)
local maximizedSize = UDim2.new(1, -30, 1, -30)
local maximizedPosition = UDim2.new(0, 15, 0, 15)

local function showTrayIcon()
    trayIcon.Visible = true
    TweenService:Create(trayIcon, TweenInfo.new(0.3), {Size = UDim2.new(0, 50, 0, 50)}):Play()
    TweenService:Create(trayGlow, TweenInfo.new(0.3), {ImageTransparency = 0.7}):Play()
end

local function hideTrayIcon()
    TweenService:Create(trayIcon, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(trayGlow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
    task.wait(0.3)
    trayIcon.Visible = false
end

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
end

local function hideMainUI()
    TweenService:Create(container, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    TweenService:Create(glow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
    
    task.wait(0.3)
    container.Visible = false
    
    showTrayIcon()
    uiOpen = false
end

local function minimizeUI() hideMainUI() end
local function closeUI() hideMainUI() end

local function maximizeUI()
    if not uiOpen then
        showMainUI()
        task.wait(0.4)
    end
    
    if isMaximized then
        TweenService:Create(container, TweenInfo.new(0.3), {
            Size = originalSize,
            Position = originalPosition
        }):Play()
        maximizeBtn.Text = "□"
        maximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        isMaximized = false
    else
        TweenService:Create(container, TweenInfo.new(0.3), {
            Size = maximizedSize,
            Position = maximizedPosition
        }):Play()
        maximizeBtn.Text = "⧉"
        maximizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        isMaximized = true
    end
end

trayIcon.MouseButton1Click:Connect(showMainUI)

trayIcon.MouseEnter:Connect(function()
    TweenService:Create(trayIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
    TweenService:Create(trayGlow, TweenInfo.new(0.2), {ImageTransparency = 0.6}):Play()
end)

trayIcon.MouseLeave:Connect(function()
    TweenService:Create(trayIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
    TweenService:Create(trayGlow, TweenInfo.new(0.2), {ImageTransparency = 0.7}):Play()
end)

minimizeBtn.MouseButton1Click:Connect(minimizeUI)
maximizeBtn.MouseButton1Click:Connect(maximizeUI)
closeBtn.MouseButton1Click:Connect(closeUI)

-- ===========================================================
-- STATS UPDATE LOOP
-- ===========================================================
local fps = 0
local frames = 0
local lastTime = tick()

task.spawn(function()
    FindFishingRemotesAtomic()
    
    -- Setup notification hook jika remote ditemukan
    if fishingConfig.disableNotifications and fishingRemotes.ObtainedNewFishNotification then
        HookNotificationSystem()
    end
    
    -- Update loop yang ringan
    while task.wait(1) do
        local elapsed = math.max(1, tick() - fishingStats.startTime)
        local rate = fishingStats.fishCaught / elapsed
        local successRate = fishingStats.attempts > 0 and (fishingStats.fishCaught / fishingStats.attempts) * 100 or 0
        
        fishCountLabel.Text = string.format("🎣 Fish: %d", fishingStats.fishCaught)
        rateLabel.Text = string.format("📊 Rate: %.1f/s", rate)
        attemptsLabel.Text = string.format("🎯 Attempts: %d", fishingStats.attempts)
        successLabel.Text = string.format("✅ Success: %.0f%%", successRate)
        fishingIndicator.Text = fishingActive and "✅ FISHING ACTIVE" or "⭕ FISHING OFF"
        fishingIndicator.TextColor3 = fishingActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        
        -- Update FPS
        frames = frames + 1
        local currentTime = tick()
        if currentTime - lastTime >= 2 then
            fps = math.floor(frames / 2)
            frames = 0
            lastTime = currentTime
            memLabel.Text = string.format("Memory: %d KB | FPS: %d", math.floor(collectgarbage("count")), fps)
        end
    end
end)

-- Start dengan UI terbuka
showMainUI()

print("==========================================")
print("⚡ NEON HUB v3.3 - ATOMIC STYLE")
print("==========================================")
print("🎯 ATOMIC FISHING FEATURES:")
print("→ No Main Loop (task.spawn based)")
print("→ Random delays for anti-pattern")
print("→ Notification blocking system")
print("→ Walk speed slider (16-200)")
print("==========================================")
print("🔧 NOTIFICATION SYSTEM:")
print("→ Hooks ObtainedNewFishNotification")
print("→ Completely blocks notifications when enabled")
print("→ Can be toggled on/off")
print("==========================================")
print("⚙️ WALK SPEED SYSTEM:")
print("→ Slider: 16 to 200")
print("→ Real-time updates")
print("→ Persists through character respawn")
print("==========================================")
print("📊 STATUS: Atomic fishing ready!")
print("==========================================")