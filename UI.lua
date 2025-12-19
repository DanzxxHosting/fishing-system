-- NEON HUB v3.1 - FIXED & OPTIMIZED
-- UI Compact + All Features
-- Tema: hitam matte + merah neon

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG UI LEBIH KECIL
local WIDTH = 620
local HEIGHT = 460
local SIDEBAR_W = 200
local ACCENT = Color3.fromRGB(255, 62, 62)
local BG = Color3.fromRGB(12,12,12)
local SECOND = Color3.fromRGB(24,24,26)

-- ===========================================================
-- FISHING CONFIG - SEMUA FITUR DISABLE DEFAULT
-- ===========================================================
local fishingConfig = {
    autoFishing = false,
    instantFishing = false,          -- DISABLE DEFAULT
    fishingDelay = 0.1,
    ultraSpeed = false,              -- DISABLE DEFAULT
    perfectCast = false,             -- DISABLE DEFAULT
    autoReel = false,                -- DISABLE DEFAULT
    bypassDetection = false,         -- DISABLE DEFAULT
    skipMinigame = false,            -- DISABLE DEFAULT
    noAnimation = false,             -- DISABLE DEFAULT
    autoSell = false,                -- DISABLE DEFAULT
    disableNotifications = false     -- DISABLE DEFAULT
}

-- ===========================================================
-- SETTINGS CONFIG (FITUR BARU)
-- ===========================================================
local settingsConfig = {
    -- FLY SYSTEM
    flyEnabled = false,
    flySpeed = 50,
    flyKey = Enum.KeyCode.F,
    
    -- ESP SYSTEM
    espEnabled = false,
    espNames = true,
    espColor = Color3.fromRGB(255, 50, 50),
    espTransparency = 0.3,
    
    -- CHARACTER MODS
    infiniteJump = false,
    walkSpeed = 32,
    jumpPower = 50,
    
    -- OTHER
    noclip = false,
    autoFarm = false
}

-- ===========================================================
-- FISHING VARIABLES
-- ===========================================================
local fishingRemotes = {
    FishCaught = nil, 
    ObtainedNewFishNotification = nil,
    FishingCompleted = nil,   
    FishingStopped = nil,
    FishingMinigameChanged = nil,
    CaughtFishVisual = nil,
    FlyFishingEffect = nil,
    WaitingForBite = nil,
    MinigameStarted = nil  
}

local fishingStats = {
    fishCaught = 0,
    startTime = tick(),
    attempts = 0,
    successRate = 0,
    lastCatchTime = 0
}

local fishingActive = false
local fishingConnection

-- ===========================================================
-- SETTINGS VARIABLES (FITUR BARU)
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
-- DISABLE NOTIFICATION SYSTEM - FIXED
-- ===========================================================
local originalFireServer = nil
local notificationHookActive = false
local notificationHookEnabled = false

local function HookNotificationRemote()
    if fishingRemotes.ObtainedNewFishNotification and not notificationHookActive then
        originalFireServer = fishingRemotes.ObtainedNewFishNotification.FireServer
        
        -- Simpan original function dengan benar
        local originalFunc = originalFireServer
        
        -- Override fungsi FireServer
        fishingRemotes.ObtainedNewFishNotification.FireServer = function(self, ...)
            if notificationHookEnabled then
                print("[Notification] BLOCKED: ObtainedNewFishNotification")
                return nil -- Blokir notifikasi
            else
                -- Jalankan fungsi original
                return originalFunc(self, ...)
            end
        end
        
        notificationHookActive = true
        print("[Notification] Hook installed successfully!")
        return true
    end
    return false
end

local function UnhookNotificationRemote()
    if fishingRemotes.ObtainedNewFishNotification and notificationHookActive and originalFireServer then
        -- Restore ke fungsi original
        fishingRemotes.ObtainedNewFishNotification.FireServer = originalFireServer
        notificationHookActive = false
        print("[Notification] Hook removed successfully!")
        return true
    end
    return false
end

local function ToggleDisableNotifications(enabled)
    fishingConfig.disableNotifications = enabled
    notificationHookEnabled = enabled
    
    if enabled then
        if fishingRemotes.ObtainedNewFishNotification then
            HookNotificationRemote()
        else
            print("[Notification] WARNING: Remote not found, hook will be installed when remote is found")
        end
        print("[Notification] Notifications: DISABLED")
    else
        if notificationHookActive then
            UnhookNotificationRemote()
        end
        print("[Notification] Notifications: ENABLED")
    end
end

-- ===========================================================
-- FLY SYSTEM (FITUR BARU)
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
-- ESP SYSTEM (FITUR BARU)
-- ===========================================================
local function CreateESPBox(player)
    local character = player.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not head or not humanoidRootPart then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_" .. player.Name
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = settingsConfig.espTransparency
    box.Color3 = settingsConfig.espColor
    box.Parent = Workspace
    
    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "ESP_Name_" .. player.Name
    nameTag.Adornee = head
    nameTag.AlwaysOnTop = true
    nameTag.Size = UDim2.new(0, 100, 0, 50)
    nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
    nameTag.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = settingsConfig.espColor
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = nameTag
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = settingsConfig.espColor
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = nameTag
    
    espBoxes[player] = {box = box, nameTag = nameTag, nameLabel = nameLabel, distanceLabel = distanceLabel}
end

local function UpdateESP()
    for player, esp in pairs(espBoxes) do
        if player.Character and esp.box and esp.nameTag then
            local character = player.Character
            local head = character:FindFirstChild("Head")
            local root = character:FindFirstChild("HumanoidRootPart")
            
            if head and root then
                -- Update distance
                local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                
                if playerRoot and localRoot then
                    local distance = (playerRoot.Position - localRoot.Position).Magnitude
                    esp.distanceLabel.Text = string.format("%.1f studs", distance)
                end
                
                -- Update color
                esp.box.Color3 = settingsConfig.espColor
                esp.nameLabel.TextColor3 = settingsConfig.espColor
                esp.distanceLabel.TextColor3 = settingsConfig.espColor
                
                -- Update visibility
                esp.nameTag.Enabled = settingsConfig.espNames
            end
        end
    end
end

local function ToggleESP(enabled)
    settingsConfig.espEnabled = enabled
    
    if enabled then
        -- Create ESP for all players
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                CreateESPBox(otherPlayer)
            end
        end
        
        -- Update loop
        espConnection = RunService.Heartbeat:Connect(UpdateESP)
        
        -- Listen for new players
        Players.PlayerAdded:Connect(function(newPlayer)
            task.wait(1)
            CreateESPBox(newPlayer)
        end)
        
        -- Remove ESP when player leaves
        Players.PlayerRemoving:Connect(function(leftPlayer)
            if espBoxes[leftPlayer] then
                if espBoxes[leftPlayer].box then espBoxes[leftPlayer].box:Destroy() end
                if espBoxes[leftPlayer].nameTag then espBoxes[leftPlayer].nameTag:Destroy() end
                espBoxes[leftPlayer] = nil
            end
        end)
    else
        -- Remove all ESP
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        
        for _, esp in pairs(espBoxes) do
            if esp.box then esp.box:Destroy() end
            if esp.nameTag then esp.nameTag:Destroy() end
        end
        espBoxes = {}
    end
end

-- ===========================================================
-- INFINITE JUMP (FITUR BARU)
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
-- WALK SPEED & JUMP POWER (FITUR BARU)
-- ===========================================================
local function ToggleWalkSpeed(enabled)
    walkSpeedActive = enabled
    
    if enabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                originalWalkSpeed = humanoid.WalkSpeed
                originalJumpPower = humanoid.JumpPower
                
                humanoid.WalkSpeed = settingsConfig.walkSpeed
                humanoid.JumpPower = settingsConfig.jumpPower
            end
        end
        
        -- Apply when character respawns
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = settingsConfig.walkSpeed
                humanoid.JumpPower = settingsConfig.jumpPower
            end
        end)
    else
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
                humanoid.JumpPower = originalJumpPower
            end
        end
    end
end

-- ===========================================================
-- REMOTE FINDER
-- ===========================================================
local function FindUpdatedFishingRemotes()
    print("[Fishing] Searching for fishing remotes...")
    
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages then
        local netIndex = packages:FindFirstChild("_Index")
        if netIndex then
            local sleitnick = netIndex:FindFirstChild("sleitnick_net@0.2.0")
            if sleitnick then
                local netRE = sleitnick:FindFirstChild("net.RE")
                if netRE then
                    fishingRemotes.FishCaught = netRE:FindFirstChild("FishCaught")
                    fishingRemotes.ObtainedNewFishNotification = netRE:FindFirstChild("ObtainedNewFishNotification")
                    fishingRemotes.FishingCompleted = netRE:FindFirstChild("FishingCompleted")
                    fishingRemotes.FishingStopped = netRE:FindFirstChild("FishingStopped")
                    fishingRemotes.FishingMinigameChanged = netRE:FindFirstChild("FishingMinigameChanged")
                    fishingRemotes.CaughtFishVisual = netRE:FindFirstChild("CaughtFishVisual")
                    fishingRemotes.FlyFishingEffect = netRE:FindFirstChild("FlyFishingEffect")
                    
                    if not fishingRemotes.ObtainedNewFishNotification then
                        fishingRemotes.ObtainedNewFishNotification = netRE:FindFirstChild("ObfainedNewFishNotification")
                    end
                    if not fishingRemotes.FishingMinigameChanged then
                        fishingRemotes.FishingMinigameChanged = netRE:FindFirstChild("FishingWinigameChanged")
                    end
                    
                    print("[Fishing] ✅ Found remotes in Packages/sleitnick_net!")
                    return true
                end
            end
        end
    end
    
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            local name = child.Name
            if name == "FishCaught" then fishingRemotes.FishCaught = child
            elseif name == "ObtainedNewFishNotification" or name == "ObfainedNewFishNotification" then fishingRemotes.ObtainedNewFishNotification = child
            elseif name == "FishingCompleted" then fishingRemotes.FishingCompleted = child
            elseif name == "FishingStopped" then fishingRemotes.FishingStopped = child
            elseif name == "FishingMinigameChanged" or name == "FishingWinigameChanged" then fishingRemotes.FishingMinigameChanged = child
            elseif name == "CaughtFishVisual" then fishingRemotes.CaughtFishVisual = child
            elseif name == "FlyFishingEffect" then fishingRemotes.FlyFishingEffect = child
            elseif name == "WaitingForBite" then fishingRemotes.WaitingForBite = child
            elseif name == "MinigameStarted" then fishingRemotes.MinigameStarted = child end
        end
    end
    
    -- Check which remotes were found
    local foundCount = 0
    for name, remote in pairs(fishingRemotes) do
        if remote then
            foundCount = foundCount + 1
            print("[Fishing] ✓ " .. name .. " found")
        else
            print("[Fishing] ✗ " .. name .. " not found")
        end
    end
    
    return foundCount > 0
end

-- ===========================================================
-- FISHING SYSTEM - SEMUA FITUR HANYA AKTIF SAAT DITOGGLE
-- ===========================================================
local function SimpleAutoFishingCycle()
    if not fishingActive then return end
    
    fishingStats.attempts = fishingStats.attempts + 1
    
    -- 1. CAST - Hanya jika ada remote atau fallback
    local castSuccess = false
    if fishingRemotes.FlyFishingEffect then
        pcall(function() 
            fishingRemotes.FlyFishingEffect:FireServer() 
            castSuccess = true 
        end)
    end
    
    if not castSuccess and fishingRemotes.WaitingForBite then
        pcall(function() 
            fishingRemotes.WaitingForBite:FireServer() 
            castSuccess = true 
        end)
    end
    
    if not castSuccess then
        -- Fallback mouse click
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.001)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            castSuccess = true
        end)
    end
    
    if castSuccess then
        -- Tunggu berdasarkan mode
        if fishingConfig.ultraSpeed then
            task.wait(0.005)
        elseif fishingConfig.instantFishing then
            task.wait(0.01)
        else
            task.wait(fishingConfig.fishingDelay)
        end
        
        -- 2. CATCH FISH
        local catchSuccess = false
        
        -- Gunakan FishCaught jika ada
        if fishingRemotes.FishCaught then
            pcall(function()
                fishingRemotes.FishCaught:FireServer()
                catchSuccess = true
            end)
        end
        
        -- Gunakan ObtainedNewFishNotification JIKA NOT DISABLED
        if not catchSuccess and fishingRemotes.ObtainedNewFishNotification and not notificationHookEnabled then
            pcall(function()
                fishingRemotes.ObtainedNewFishNotification:FireServer()
                catchSuccess = true
            end)
        end
        
        -- Gunakan CaughtFishVisual
        if not catchSuccess and fishingRemotes.CaughtFishVisual then
            pcall(function()
                fishingRemotes.CaughtFishVisual:FireServer()
                catchSuccess = true
            end)
        end
        
        -- Gunakan FishingCompleted
        if not catchSuccess and fishingRemotes.FishingCompleted then
            pcall(function()
                fishingRemotes.FishingCompleted:FireServer()
                catchSuccess = true
            end)
        end
        
        -- 3. UPDATE STATS JIKA BERHASIL
        if catchSuccess then
            fishingStats.fishCaught = fishingStats.fishCaught + 1
            fishingStats.lastCatchTime = tick()
        else
            -- Fallback dengan tombol
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.001)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                
                fishingStats.fishCaught = fishingStats.fishCaught + 1
                fishingStats.lastCatchTime = tick()
            end)
        end
        
        -- 4. COMPLETE FISHING
        if fishingRemotes.FishingCompleted then
            pcall(function()
                fishingRemotes.FishingCompleted:FireServer()
            end)
        end
        
        if fishingRemotes.FishingStopped then
            pcall(function()
                fishingRemotes.FishingStopped:FireServer()
            end)
        end
        
        -- 5. SKIP MINIGAME JIKA FITUR AKTIF
        if fishingConfig.skipMinigame then
            if fishingRemotes.FishingMinigameChanged then
                pcall(function()
                    fishingRemotes.FishingMinigameChanged:FireServer("Complete")
                    fishingRemotes.FishingMinigameChanged:FireServer("Skip")
                end)
            end
            
            if fishingRemotes.MinigameStarted then
                pcall(function()
                    fishingRemotes.MinigameStarted:FireServer("Skip")
                end)
            end
        end
        
        -- 6. DELAY BERDASARKAN SETTINGS
        if fishingConfig.ultraSpeed then
            task.wait(0.005) -- Ultra fast
        elseif fishingConfig.instantFishing then
            task.wait(0.01)  -- Fast
        else
            task.wait(0.1)   -- Normal
        end
    end
end

local function StartFishing()
    if fishingActive then 
        print("[Fishing] Already fishing!")
        return 
    end
    
    fishingActive = true
    fishingStats.startTime = tick()
    fishingStats.lastCatchTime = tick()
    
    print("[Fishing] =========================================")
    print("[Fishing] STARTING FISHING")
    print("[Fishing] =========================================")
    print("[Fishing] Mode: " .. (fishingConfig.instantFishing and "INSTANT" or fishingConfig.ultraSpeed and "ULTRA" or "NORMAL"))
    print("[Fishing] Skip Minigame: " .. tostring(fishingConfig.skipMinigame))
    print("[Fishing] Disable Notifications: " .. tostring(fishingConfig.disableNotifications))
    print("[Fishing] =========================================")
    
    -- Setup notification hook jika perlu
    if fishingConfig.disableNotifications and fishingRemotes.ObtainedNewFishNotification and not notificationHookActive then
        HookNotificationRemote()
    end
    
    -- Start fishing loop
    fishingConnection = RunService.Heartbeat:Connect(function()
        if not fishingActive then return end
        pcall(SimpleAutoFishingCycle)
    end)
    
    print("[Fishing] Fishing started successfully!")
end

local function StopFishing()
    fishingActive = false
    
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
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

-- ===========================================================
-- UI SETUP
-- ===========================================================
if playerGui:FindFirstChild("NeonDashboardUI") then
    playerGui.NeonDashboardUI:Destroy()
end

for _, esp in pairs(espBoxes) do
    if esp.box then esp.box:Destroy() end
    if esp.nameTag then esp.nameTag:Destroy() end
end
espBoxes = {}

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
title.Text = "⚡ NEON HUB v3.1"
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
sSubtitle.Text = "Fixed & Optimized"
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

-- Auto Fishing Toggle - SEMUA FITUR DISABLE DEFAULT
CreateModernToggle("⚡ Auto Fishing", "Click to enable fishing", fishingActive, function(v)
    if v then
        StartFishing()
    else
        StopFishing()
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

-- Fishing Settings Panel - SEMUA FITUR DISABLE DEFAULT
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
CreateModernToggle("⚡ Instant Fishing", "Click to enable faster fishing", fishingConfig.instantFishing, function(v)
    fishingConfig.instantFishing = v
    if v then 
        fishingConfig.fishingDelay = 0.01
        print("[Fishing] Instant Fishing: ENABLED")
    else
        fishingConfig.fishingDelay = 0.1
        print("[Fishing] Instant Fishing: DISABLED")
    end
end, settingsPanel, yPos)

yPos = yPos + 45
CreateModernToggle("🚀 Ultra Speed", "Click to enable ultra fast fishing", fishingConfig.ultraSpeed, function(v)
    fishingConfig.ultraSpeed = v
    if v then 
        fishingConfig.fishingDelay = 0.005
        fishingConfig.instantFishing = true
        print("[Fishing] Ultra Speed: ENABLED")
    else
        fishingConfig.fishingDelay = 0.01
        print("[Fishing] Ultra Speed: DISABLED")
    end
end, settingsPanel, yPos)

yPos = yPos + 45
CreateModernToggle("🎮 Skip Minigame", "Click to skip fishing minigame", fishingConfig.skipMinigame, function(v)
    fishingConfig.skipMinigame = v
    print("[Fishing] Skip Minigame:", v and "ENABLED" or "DISABLED")
end, settingsPanel, yPos)

yPos = yPos + 45
CreateModernToggle("🔇 Disable Notifications", "Click to block notifications", fishingConfig.disableNotifications, function(v)
    ToggleDisableNotifications(v)
end, settingsPanel, yPos)

yPos = yPos + 45
CreateModernToggle("⏭️ No Animation", "Click to skip fishing animations", fishingConfig.noAnimation, function(v)
    fishingConfig.noAnimation = v
    print("[Fishing] No Animation:", v and "ENABLED" or "DISABLED")
end, settingsPanel, yPos)

fishingScroll.CanvasSize = UDim2.new(0, 0, 0, 450)

-- ===========================================================
-- SETTINGS UI CONTENT (FITUR BARU)
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

-- Fly Settings Panel
local flyPanel = Instance.new("Frame")
flyPanel.Size = UDim2.new(1, -20, 0, 100)
flyPanel.Position = UDim2.new(0, 10, 0, 0)
flyPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
flyPanel.BorderSizePixel = 0
flyPanel.LayoutOrder = 1
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

CreateModernToggle("✈️ Enable Fly", "Click to enable flying", settingsConfig.flyEnabled, function(v)
    ToggleFly(v)
end, flyPanel, 35)

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.6, 0, 0, 20)
flySpeedLabel.Position = UDim2.new(0, 10, 0, 75)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextSize = 11
flySpeedLabel.Text = "Fly Speed: " .. settingsConfig.flySpeed
flySpeedLabel.TextColor3 = Color3.fromRGB(200,200,255)
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = flyPanel

-- ESP Settings Panel
local espPanel = Instance.new("Frame")
espPanel.Size = UDim2.new(1, -20, 0, 120)
espPanel.Position = UDim2.new(0, 10, 0, 0)
espPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
espPanel.BorderSizePixel = 0
espPanel.LayoutOrder = 2
espPanel.Parent = settingsScroll

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0,6)
espCorner.Parent = espPanel

local espTitle = Instance.new("TextLabel")
espTitle.Size = UDim2.new(1, -20, 0, 24)
espTitle.Position = UDim2.new(0,10,0,6)
espTitle.BackgroundTransparency = 1
espTitle.Font = Enum.Font.GothamBold
espTitle.TextSize = 13
espTitle.Text = "👁️ ESP Settings"
espTitle.TextColor3 = Color3.fromRGB(235,235,235)
espTitle.TextXAlignment = Enum.TextXAlignment.Left
espTitle.Parent = espPanel

CreateModernToggle("📦 Enable ESP", "Click to show player boxes", settingsConfig.espEnabled, function(v)
    ToggleESP(v)
end, espPanel, 35)

CreateModernToggle("🏷️ Show Names", "Click to display player names", settingsConfig.espNames, function(v)
    settingsConfig.espNames = v
    if settingsConfig.espEnabled then
        for _, esp in pairs(espBoxes) do
            if esp.nameTag then
                esp.nameTag.Enabled = v
            end
        end
    end
end, espPanel, 80)

-- Character Settings Panel
local charPanel = Instance.new("Frame")
charPanel.Size = UDim2.new(1, -20, 0, 140)
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

CreateModernToggle("🏃‍♂️ Walk Speed", "Click to enable custom walk speed", walkSpeedActive, function(v)
    ToggleWalkSpeed(v)
end, charPanel, 35)

CreateModernToggle("🦘 Infinite Jump", "Click to enable infinite jump", settingsConfig.infiniteJump, function(v)
    ToggleInfiniteJump(v)
end, charPanel, 80)

local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Size = UDim2.new(1, -20, 0, 20)
walkSpeedLabel.Position = UDim2.new(0, 10, 0, 120)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Font = Enum.Font.Gotham
walkSpeedLabel.TextSize = 11
walkSpeedLabel.Text = "Walk Speed: " .. settingsConfig.walkSpeed .. " | Jump Power: " .. settingsConfig.jumpPower
walkSpeedLabel.TextColor3 = Color3.fromRGB(200,255,200)
walkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedLabel.Parent = charPanel

settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 400)

-- ===========================================================
-- TELEPORT UI CONTENT
-- ===========================================================
local teleportContent = Instance.new("Frame")
teleportContent.Name = "TeleportContent"
teleportContent.Size = UDim2.new(1, -20, 1, -20)
teleportContent.Position = UDim2.new(0, 10, 0, 10)
teleportContent.BackgroundTransparency = 1
teleportContent.Visible = false
teleportContent.Parent = content

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Size = UDim2.new(1, 0, 1, 0)
teleportLabel.BackgroundTransparency = 1
teleportLabel.Font = Enum.Font.GothamBold
teleportLabel.TextSize = 16
teleportLabel.Text = "📍 Teleport Feature\n\nComing Soon!"
teleportLabel.TextColor3 = Color3.fromRGB(200,200,200)
teleportLabel.TextYAlignment = Enum.TextYAlignment.Center
teleportLabel.TextWrapped = true
teleportLabel.Parent = teleportContent

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
        teleportContent.Visible = (name == "Teleport")
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

task.spawn(function()
    FindUpdatedFishingRemotes()
    
    -- Setup notification hook jika remote ditemukan dan fitur aktif
    if fishingConfig.disableNotifications and fishingRemotes.ObtainedNewFishNotification then
        HookNotificationRemote()
    end
    
    while true do
        local elapsed = math.max(1, tick() - fishingStats.startTime)
        local rate = fishingStats.fishCaught / elapsed
        local successRate = fishingStats.attempts > 0 and (fishingStats.fishCaught / fishingStats.attempts) * 100 or 0
        
        fishCountLabel.Text = string.format("🎣 Fish: %d", fishingStats.fishCaught)
        rateLabel.Text = string.format("📊 Rate: %.2f/s", rate)
        attemptsLabel.Text = string.format("🎯 Attempts: %d", fishingStats.attempts)
        successLabel.Text = string.format("✅ Success: %.1f%%", successRate)
        fishingIndicator.Text = fishingActive and "✅ FISHING ACTIVE" or "⭕ FISHING OFF"
        fishingIndicator.TextColor3 = fishingActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        
        -- Update FPS
        frames = frames + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            fps = frames
            frames = 0
            lastTime = currentTime
            memLabel.Text = string.format("Memory: %d KB | FPS: %d", math.floor(collectgarbage("count")), fps)
        end
        
        task.wait(0.5)
    end
end)

-- Start dengan UI terbuka
showMainUI()
