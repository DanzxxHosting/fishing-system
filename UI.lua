-- NEON HUB v3.3 - UTILITY HUB
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
-- UTILITY CONFIG
-- ===========================================================
local utilityConfig = {
    -- FLY SYSTEM
    flyEnabled = false,
    flySpeed = 50,
    
    -- CHARACTER MODS
    infiniteJump = false,
    walkSpeed = 32,
    jumpPower = 50,
    walkSpeedEnabled = false,
    
    -- VISUAL MODS
    noclipEnabled = false,
    espEnabled = false,
    fpsBoost = false,
    
    -- TELEPORT
    teleportSpeed = 100,
    teleportKey = Enum.KeyCode.T,
    
    -- MISC
    autoRespawn = false,
    hideName = false,
    antiAfk = false
}

-- ===========================================================
-- UTILITY VARIABLES
-- ===========================================================
local flyActive = false
local flyVelocity
local flyConnection

local infiniteJumpActive = false
local jumpConnection

local walkSpeedActive = false
local originalWalkSpeed = 16
local originalJumpPower = 50

local noclipActive = false
local noclipConnection

local espActive = false
local espBoxes = {}
local espConnection

local antiAfkActive = false
local antiAfkConnection

-- ===========================================================
-- WALK SPEED SLIDER SYSTEM
-- ===========================================================
local function UpdateWalkSpeed(value)
    utilityConfig.walkSpeed = math.clamp(value, 16, 200)
    
    if utilityConfig.walkSpeedEnabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = utilityConfig.walkSpeed
            end
        end
    end
end

local function ToggleWalkSpeed(enabled)
    utilityConfig.walkSpeedEnabled = enabled
    walkSpeedActive = enabled
    
    if enabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                originalWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = utilityConfig.walkSpeed
            end
        end
        
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = utilityConfig.walkSpeed
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
    utilityConfig.flyEnabled = enabled
    
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
                                direction = direction.Unit * utilityConfig.flySpeed
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
    utilityConfig.infiniteJump = enabled
    
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
-- NOCLIP SYSTEM
-- ===========================================================
local function ToggleNoclip(enabled)
    utilityConfig.noclipEnabled = enabled
    noclipActive = enabled
    
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- ===========================================================
-- ESP SYSTEM
-- ===========================================================
local function ToggleESP(enabled)
    utilityConfig.espEnabled = enabled
    espActive = enabled
    
    if enabled then
        local function CreateESPBox(character)
            if not character then return end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "NEON_ESP"
            highlight.Adornee = character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.FillTransparency = 0.7
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = character
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "NEON_ESP_Name"
            billboard.Adornee = character:WaitForChild("Head", 5) or character.PrimaryPart
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.MaxDistance = 1000
            billboard.Parent = character
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = character.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Parent = billboard
            
            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = "0 studs"
            distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            distLabel.TextScaled = true
            distLabel.Font = Enum.Font.Gotham
            distLabel.Parent = billboard
            
            espBoxes[character] = {highlight, billboard}
        end
        
        -- Add ESP to existing players
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                CreateESPBox(otherPlayer.Character)
            end
        end
        
        -- Listen for new players
        Players.PlayerAdded:Connect(function(otherPlayer)
            otherPlayer.CharacterAdded:Connect(function(character)
                if espActive then
                    CreateESPBox(character)
                end
            end)
        end)
        
        -- Update distance
        espConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character.PrimaryPart then
                local playerPos = player.Character.PrimaryPart.Position
                
                for character, espParts in pairs(espBoxes) do
                    if character and character.PrimaryPart then
                        local distance = (playerPos - character.PrimaryPart.Position).Magnitude
                        local billboard = espParts[2]
                        
                        if billboard and billboard:FindFirstChild("NEON_ESP_Name") then
                            local distLabel = billboard.NEON_ESP_Name:FindFirstChildWhichIsA("TextLabel", true)
                            if distLabel then
                                distLabel.Text = math.floor(distance) .. " studs"
                            end
                        end
                    end
                end
            end
        end)
    else
        -- Remove all ESP
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        
        for character, espParts in pairs(espBoxes) do
            for _, part in pairs(espParts) do
                if part then
                    part:Destroy()
                end
            end
        end
        espBoxes = {}
    end
end

-- ===========================================================
-- FPS BOOST
-- ===========================================================
local function ToggleFPSBoost(enabled)
    utilityConfig.fpsBoost = enabled
    
    if enabled then
        -- Reduce graphics quality
        settings().Rendering.QualityLevel = 1
        Workspace.CurrentCamera:ClearAllChildren()
        
        -- Disable shadows
        lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.Brightness = 2
        
        -- Reduce particle effects
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end
    else
        -- Restore default settings
        settings().Rendering.QualityLevel = 21
        lighting.GlobalShadows = true
        lighting.Brightness = 1
    end
end

-- ===========================================================
-- ANTI-AFK
-- ===========================================================
local function ToggleAntiAFK(enabled)
    utilityConfig.antiAfk = enabled
    antiAfkActive = enabled
    
    if enabled then
        antiAfkConnection = RunService.Heartbeat:Connect(function()
            local virtualUser = game:GetService("VirtualUser")
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end
end

-- ===========================================================
-- TELEPORT SYSTEM
-- ===========================================================
local function GetMouseTarget()
    local mouse = player:GetMouse()
    return mouse.Hit
end

local function TeleportTo(position)
    local character = player.Character
    if character and character.PrimaryPart then
        character.PrimaryPart.CFrame = CFrame.new(position)
    end
end

local function SetupTeleportHotkey()
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == utilityConfig.teleportKey and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local target = GetMouseTarget()
            TeleportTo(target.Position + Vector3.new(0, 5, 0))
        end
    end)
end

-- ===========================================================
-- AUTO RESPAWN
-- ===========================================================
local function ToggleAutoRespawn(enabled)
    utilityConfig.autoRespawn = enabled
    
    if enabled then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(function()
                        task.wait(2)
                        player:LoadCharacter()
                    end)
                end
            end
        end)
    end
end

-- ===========================================================
-- UI SETUP
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
sSubtitle.Text = "Utility Hub v3.3"
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
    {"Player", "👤"},
    {"Visual", "👁️"},
    {"Teleport", "📍"},
    {"Misc", "🔧"},
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
cTitle.Text = "Player"
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
-- PLAYER UI CONTENT
-- ===========================================================
local playerContent = Instance.new("Frame")
playerContent.Name = "PlayerContent"
playerContent.Size = UDim2.new(1, -20, 1, -20)
playerContent.Position = UDim2.new(0, 10, 0, 10)
playerContent.BackgroundTransparency = 1
playerContent.Visible = true
playerContent.Parent = content

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Name = "PlayerScroll"
playerScroll.Size = UDim2.new(1, 0, 1, 0)
playerScroll.Position = UDim2.new(0, 0, 0, 0)
playerScroll.BackgroundTransparency = 1
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 5
playerScroll.ScrollBarImageColor3 = ACCENT
playerScroll.Parent = playerContent

local playerList = Instance.new("UIListLayout")
playerList.SortOrder = Enum.SortOrder.LayoutOrder
playerList.Padding = UDim.new(0, 10)
playerList.Parent = playerScroll

-- Movement Panel
local movementPanel = Instance.new("Frame")
movementPanel.Size = UDim2.new(1, -20, 0, 200)
movementPanel.Position = UDim2.new(0, 10, 0, 0)
movementPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
movementPanel.BorderSizePixel = 0
movementPanel.LayoutOrder = 1
movementPanel.Parent = playerScroll

local movementCorner = Instance.new("UICorner")
movementCorner.CornerRadius = UDim.new(0,6)
movementCorner.Parent = movementPanel

local movementTitle = Instance.new("TextLabel")
movementTitle.Size = UDim2.new(1, -20, 0, 24)
movementTitle.Position = UDim2.new(0,10,0,6)
movementTitle.BackgroundTransparency = 1
movementTitle.Font = Enum.Font.GothamBold
movementTitle.TextSize = 13
movementTitle.Text = "🏃 Movement"
movementTitle.TextColor3 = Color3.fromRGB(235,235,235)
movementTitle.TextXAlignment = Enum.TextXAlignment.Left
movementTitle.Parent = movementPanel

CreateModernToggle("✈️ Fly", "Enable flying (WASD + Space/Shift)", utilityConfig.flyEnabled, function(v)
    ToggleFly(v)
end, movementPanel, 35)

CreateModernToggle("🦘 Infinite Jump", "Enable infinite jumping", utilityConfig.infiniteJump, function(v)
    ToggleInfiniteJump(v)
end, movementPanel, 80)

CreateModernToggle("🚶 Walk Speed", "Enable custom walk speed", utilityConfig.walkSpeedEnabled, function(v)
    ToggleWalkSpeed(v)
end, movementPanel, 125)

-- Slider untuk Walk Speed
CreateSlider("Walk Speed Value", 16, 200, utilityConfig.walkSpeed, function(value)
    UpdateWalkSpeed(value)
end, movementPanel, 170)

-- Character Panel
local characterPanel = Instance.new("Frame")
characterPanel.Size = UDim2.new(1, -20, 0, 120)
characterPanel.Position = UDim2.new(0, 10, 0, 0)
characterPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
characterPanel.BorderSizePixel = 0
characterPanel.LayoutOrder = 2
characterPanel.Parent = playerScroll

local characterCorner = Instance.new("UICorner")
characterCorner.CornerRadius = UDim.new(0,6)
characterCorner.Parent = characterPanel

local characterTitle = Instance.new("TextLabel")
characterTitle.Size = UDim2.new(1, -20, 0, 24)
characterTitle.Position = UDim2.new(0,10,0,6)
characterTitle.BackgroundTransparency = 1
characterTitle.Font = Enum.Font.GothamBold
characterTitle.TextSize = 13
characterTitle.Text = "👤 Character"
characterTitle.TextColor3 = Color3.fromRGB(235,235,235)
characterTitle.TextXAlignment = Enum.TextXAlignment.Left
characterTitle.Parent = characterPanel

CreateModernToggle("👻 Noclip", "Walk through walls", utilityConfig.noclipEnabled, function(v)
    ToggleNoclip(v)
end, characterPanel, 35)

CreateModernToggle("🔄 Auto Respawn", "Automatically respawn on death", utilityConfig.autoRespawn, function(v)
    ToggleAutoRespawn(v)
end, characterPanel, 80)

playerScroll.CanvasSize = UDim2.new(0, 0, 0, 350)

-- ===========================================================
-- VISUAL UI CONTENT
-- ===========================================================
local visualContent = Instance.new("Frame")
visualContent.Name = "VisualContent"
visualContent.Size = UDim2.new(1, -20, 1, -20)
visualContent.Position = UDim2.new(0, 10, 0, 10)
visualContent.BackgroundTransparency = 1
visualContent.Visible = false
visualContent.Parent = content

local visualScroll = Instance.new("ScrollingFrame")
visualScroll.Name = "VisualScroll"
visualScroll.Size = UDim2.new(1, 0, 1, 0)
visualScroll.Position = UDim2.new(0, 0, 0, 0)
visualScroll.BackgroundTransparency = 1
visualScroll.BorderSizePixel = 0
visualScroll.ScrollBarThickness = 5
visualScroll.ScrollBarImageColor3 = ACCENT
visualScroll.Parent = visualContent

local visualList = Instance.new("UIListLayout")
visualList.SortOrder = Enum.SortOrder.LayoutOrder
visualList.Padding = UDim.new(0, 10)
visualList.Parent = visualScroll

-- ESP Panel
local espPanel = Instance.new("Frame")
espPanel.Size = UDim2.new(1, -20, 0, 100)
espPanel.Position = UDim2.new(0, 10, 0, 0)
espPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
espPanel.BorderSizePixel = 0
espPanel.LayoutOrder = 1
espPanel.Parent = visualScroll

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0,6)
espCorner.Parent = espPanel

local espTitle = Instance.new("TextLabel")
espTitle.Size = UDim2.new(1, -20, 0, 24)
espTitle.Position = UDim2.new(0,10,0,6)
espTitle.BackgroundTransparency = 1
espTitle.Font = Enum.Font.GothamBold
espTitle.TextSize = 13
espTitle.Text = "👁️ ESP & Visuals"
espTitle.TextColor3 = Color3.fromRGB(235,235,235)
espTitle.TextXAlignment = Enum.TextXAlignment.Left
espTitle.Parent = espPanel

CreateModernToggle("🎯 ESP", "Show player locations", utilityConfig.espEnabled, function(v)
    ToggleESP(v)
end, espPanel, 35)

-- Performance Panel
local perfPanel = Instance.new("Frame")
perfPanel.Size = UDim2.new(1, -20, 0, 100)
perfPanel.Position = UDim2.new(0, 10, 0, 0)
perfPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
perfPanel.BorderSizePixel = 0
perfPanel.LayoutOrder = 2
perfPanel.Parent = visualScroll

local perfCorner = Instance.new("UICorner")
perfCorner.CornerRadius = UDim.new(0,6)
perfCorner.Parent = perfPanel

local perfTitle = Instance.new("TextLabel")
perfTitle.Size = UDim2.new(1, -20, 0, 24)
perfTitle.Position = UDim2.new(0,10,0,6)
perfTitle.BackgroundTransparency = 1
perfTitle.Font = Enum.Font.GothamBold
perfTitle.TextSize = 13
perfTitle.Text = "⚡ Performance"
perfTitle.TextColor3 = Color3.fromRGB(235,235,235)
perfTitle.TextXAlignment = Enum.TextXAlignment.Left
perfTitle.Parent = perfPanel

CreateModernToggle("🚀 FPS Boost", "Reduce graphics for better FPS", utilityConfig.fpsBoost, function(v)
    ToggleFPSBoost(v)
end, perfPanel, 35)

visualScroll.CanvasSize = UDim2.new(0, 0, 0, 230)

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

local teleportScroll = Instance.new("ScrollingFrame")
teleportScroll.Name = "TeleportScroll"
teleportScroll.Size = UDim2.new(1, 0, 1, 0)
teleportScroll.Position = UDim2.new(0, 0, 0, 0)
teleportScroll.BackgroundTransparency = 1
teleportScroll.BorderSizePixel = 0
teleportScroll.ScrollBarThickness = 5
teleportScroll.ScrollBarImageColor3 = ACCENT
teleportScroll.Parent = teleportContent

local teleportList = Instance.new("UIListLayout")
teleportList.SortOrder = Enum.SortOrder.LayoutOrder
teleportList.Padding = UDim.new(0, 10)
teleportList.Parent = teleportScroll

-- Teleport Panel
local teleportPanel = Instance.new("Frame")
teleportPanel.Size = UDim2.new(1, -20, 0, 150)
teleportPanel.Position = UDim2.new(0, 10, 0, 0)
teleportPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
teleportPanel.BorderSizePixel = 0
teleportPanel.LayoutOrder = 1
teleportPanel.Parent = teleportScroll

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0,6)
teleportCorner.Parent = teleportPanel

local teleportTitle = Instance.new("TextLabel")
teleportTitle.Size = UDim2.new(1, -20, 0, 24)
teleportTitle.Position = UDim2.new(0,10,0,6)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Font = Enum.Font.GothamBold
teleportTitle.TextSize = 13
teleportTitle.Text = "📍 Teleport"
teleportTitle.TextColor3 = Color3.fromRGB(235,235,235)
teleportTitle.TextXAlignment = Enum.TextXAlignment.Left
teleportTitle.Parent = teleportPanel

local teleportInfo = Instance.new("TextLabel")
teleportInfo.Size = UDim2.new(1, -20, 0, 40)
teleportInfo.Position = UDim2.new(0,10,0,35)
teleportInfo.BackgroundTransparency = 1
teleportInfo.Font = Enum.Font.Gotham
teleportInfo.TextSize = 11
teleportInfo.Text = "Hotkey: Ctrl + T\nAim at location and press hotkey"
teleportInfo.TextColor3 = Color3.fromRGB(200,200,200)
teleportInfo.TextXAlignment = Enum.TextXAlignment.Left
teleportInfo.TextYAlignment = Enum.TextYAlignment.Top
teleportInfo.Parent = teleportPanel

-- Quick Teleport Buttons
local teleportButtonContainer = Instance.new("Frame")
teleportButtonContainer.Size = UDim2.new(1, -20, 0, 60)
teleportButtonContainer.Position = UDim2.new(0,10,0,85)
teleportButtonContainer.BackgroundTransparency = 1
teleportButtonContainer.Parent = teleportPanel

local function CreateTeleportButton(text, position, parent)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -5, 0, 25)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    return button
end

-- Player Teleport Panel
local playerTeleportPanel = Instance.new("Frame")
playerTeleportPanel.Size = UDim2.new(1, -20, 0, 200)
playerTeleportPanel.Position = UDim2.new(0, 10, 0, 0)
playerTeleportPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
playerTeleportPanel.BorderSizePixel = 0
playerTeleportPanel.LayoutOrder = 2
playerTeleportPanel.Parent = teleportScroll

local playerTeleportCorner = Instance.new("UICorner")
playerTeleportCorner.CornerRadius = UDim.new(0,6)
playerTeleportCorner.Parent = playerTeleportPanel

local playerTeleportTitle = Instance.new("TextLabel")
playerTeleportTitle.Size = UDim2.new(1, -20, 0, 24)
playerTeleportTitle.Position = UDim2.new(0,10,0,6)
playerTeleportTitle.BackgroundTransparency = 1
playerTeleportTitle.Font = Enum.Font.GothamBold
playerTeleportTitle.TextSize = 13
playerTeleportTitle.Text = "👥 Teleport to Players"
playerTeleportTitle.TextColor3 = Color3.fromRGB(235,235,235)
playerTeleportTitle.TextXAlignment = Enum.TextXAlignment.Left
playerTeleportTitle.Parent = playerTeleportPanel

teleportScroll.CanvasSize = UDim2.new(0, 0, 0, 380)

-- ===========================================================
-- MISC UI CONTENT
-- ===========================================================
local miscContent = Instance.new("Frame")
miscContent.Name = "MiscContent"
miscContent.Size = UDim2.new(1, -20, 1, -20)
miscContent.Position = UDim2.new(0, 10, 0, 10)
miscContent.BackgroundTransparency = 1
miscContent.Visible = false
miscContent.Parent = content

local miscScroll = Instance.new("ScrollingFrame")
miscScroll.Name = "MiscScroll"
miscScroll.Size = UDim2.new(1, 0, 1, 0)
miscScroll.Position = UDim2.new(0, 0, 0, 0)
miscScroll.BackgroundTransparency = 1
miscScroll.BorderSizePixel = 0
miscScroll.ScrollBarThickness = 5
miscScroll.ScrollBarImageColor3 = ACCENT
miscScroll.Parent = miscContent

local miscList = Instance.new("UIListLayout")
miscList.SortOrder = Enum.SortOrder.LayoutOrder
miscList.Padding = UDim.new(0, 10)
miscList.Parent = miscScroll

-- Miscellaneous Panel
local miscPanel = Instance.new("Frame")
miscPanel.Size = UDim2.new(1, -20, 0, 150)
miscPanel.Position = UDim2.new(0, 10, 0, 0)
miscPanel.BackgroundColor3 = Color3.fromRGB(14,14,16)
miscPanel.BorderSizePixel = 0
miscPanel.LayoutOrder = 1
miscPanel.Parent = miscScroll

local miscCorner = Instance.new("UICorner")
miscCorner.CornerRadius = UDim.new(0,6)
miscCorner.Parent = miscPanel

local miscTitle = Instance.new("TextLabel")
miscTitle.Size = UDim2.new(1, -20, 0, 24)
miscTitle.Position = UDim2.new(0,10,0,6)
miscTitle.BackgroundTransparency = 1
miscTitle.Font = Enum.Font.GothamBold
miscTitle.TextSize = 13
miscTitle.Text = "🔧 Miscellaneous"
miscTitle.TextColor3 = Color3.fromRGB(235,235,235)
miscTitle.TextXAlignment = Enum.TextXAlignment.Left
miscTitle.Parent = miscPanel

CreateModernToggle("⏰ Anti-AFK", "Prevent being kicked for AFK", utilityConfig.antiAfk, function(v)
    ToggleAntiAFK(v)
end, miscPanel, 35)

CreateModernToggle("👤 Hide Name", "Hide your username", utilityConfig.hideName, function(v)
    utilityConfig.hideName = v
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.DisplayName = v and "" or player.Name
        end
    end
end, miscPanel, 80)

miscScroll.CanvasSize = UDim2.new(0, 0, 0, 180)

-- ===========================================================
-- MENU NAVIGATION
-- ===========================================================
local activeMenu = "Player"
for name, btn in pairs(menuButtons) do
    btn.MouseButton1Click:Connect(function()
        for n, b in pairs(menuButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20,20,20)
        end
        btn.BackgroundColor3 = Color3.fromRGB(32,8,8)
        
        cTitle.Text = name
        
        playerContent.Visible = (name == "Player")
        visualContent.Visible = (name == "Visual")
        teleportContent.Visible = (name == "Teleport")
        miscContent.Visible = (name == "Misc")
    end)
end

menuButtons["Player"].BackgroundColor3 = Color3.fromRGB(32,8,8)

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
    -- Setup teleport hotkey
    SetupTeleportHotkey()
    
    -- Update loop
    while task.wait(1) do
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
print("⚡ NEON HUB v3.3 - UTILITY HUB")
print("==========================================")
print("🎮 PLAYER FEATURES:")
print("→ Fly system (WASD + Space/Shift)")
print("→ Infinite jump")
print("→ Walk speed slider (16-200)")
print("→ Noclip mode")
print("==========================================")
print("👁️ VISUAL FEATURES:")
print("→ ESP (Player locations)")
print("→ FPS Boost (Graphics optimization)")
print("==========================================")
print("📍 TELEPORT FEATURES:")
print("→ Ctrl + T teleport to mouse position")
print("→ Quick teleport buttons")
print("→ Player teleport (Coming soon)")
print("==========================================")
print("🔧 MISC FEATURES:")
print("→ Anti-AFK system")
print("→ Hide username")
print("→ Auto respawn")
print("==========================================")
print("📊 STATUS: Utility hub ready!")
print("==========================================")