-- NeoxHub Premium UI with Particles
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Theme Colors (Cyber Neon Blue)
local colors = {
    primary = Color3.fromRGB(0, 200, 255),       -- Bright Cyan
    secondary = Color3.fromRGB(0, 150, 255),     -- Medium Blue
    accent = Color3.fromRGB(0, 255, 255),        -- Pure Cyan
    galaxy1 = Color3.fromRGB(0, 100, 255),       -- Deep Blue
    galaxy2 = Color3.fromRGB(0, 50, 150),        -- Dark Blue
    success = Color3.fromRGB(0, 255, 150),       -- Mint Green
    warning = Color3.fromRGB(255, 200, 0),       -- Amber
    danger = Color3.fromRGB(255, 50, 100),       -- Pink Red
    
    bg1 = Color3.fromRGB(5, 5, 15),              -- Deep Space Blue
    bg2 = Color3.fromRGB(10, 10, 25),            -- Dark Blue
    bg3 = Color3.fromRGB(20, 20, 40),            -- Medium Blue
    bg4 = Color3.fromRGB(30, 30, 60),            -- Light Blue
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(200, 220, 255),
    textDimmer = Color3.fromRGB(150, 180, 220),
    
    border = Color3.fromRGB(0, 100, 200),
    glow = Color3.fromRGB(0, 150, 255),
}

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NeoxHub_Premium"
gui.Parent = localPlayer.PlayerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- Main Container with Glass Morphism Effect
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 850, 0, 450)
mainContainer.Position = UDim2.new(0.5, -425, 0.5, -300)
mainContainer.BackgroundColor3 = colors.bg1
mainContainer.BackgroundTransparency = 0.15
mainContainer.BorderSizePixel = 0
mainContainer.ClipsDescendants = false
mainContainer.ZIndex = 1

-- Glass Effect
local glassEffect = Instance.new("Frame")
glassEffect.Name = "GlassEffect"
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.BackgroundTransparency = 0.95
glassEffect.BorderSizePixel = 0
glassEffect.ZIndex = 2
Instance.new("UICorner", glassEffect).CornerRadius = UDim.new(0, 24)

-- Blur Background
local blur = Instance.new("ImageLabel")
blur.Name = "Blur"
blur.Size = UDim2.new(1, 0, 1, 0)
blur.BackgroundTransparency = 1
blur.Image = "rbxassetid://111416780887356" -- Noise texture
blur.ImageTransparency = 0.7
blur.ScaleType = Enum.ScaleType.Tile
blur.TileSize = UDim2.new(0, 100, 0, 100)
blur.ZIndex = 0

-- Outer Glow Effect
local glowStroke = Instance.new("UIStroke")
glowStroke.Parent = mainContainer
glowStroke.Color = colors.primary
glowStroke.Thickness = 2
glowStroke.Transparency = 0.3
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Inner Glow
local innerGlow = Instance.new("Frame")
innerGlow.Name = "InnerGlow"
innerGlow.Size = UDim2.new(1, -4, 1, -4)
innerGlow.Position = UDim2.new(0, 2, 0, 2)
innerGlow.BackgroundTransparency = 1
innerGlow.BorderSizePixel = 0
innerGlow.ZIndex = 3
local innerStroke = Instance.new("UIStroke")
innerStroke.Parent = innerGlow
innerStroke.Color = colors.accent
innerStroke.Thickness = 1
innerStroke.Transparency = 0.5

-- Corner Rounding
local corner = Instance.new("UICorner")
corner.Parent = mainContainer
corner.CornerRadius = UDim.new(0, 24)

-- Header Section
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 70)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = colors.bg2
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.ZIndex = 10

-- Header Corner
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 24)

-- Header Gradient
local headerGradient = Instance.new("UIGradient")
headerGradient.Parent = header
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, colors.galaxy1),
    ColorSequenceKeypoint.new(1, colors.galaxy2)
})
headerGradient.Rotation = 90
headerGradient.Transparency = NumberSequence.new(0.8)

-- Logo and Title
local logoContainer = Instance.new("Frame")
logoContainer.Name = "LogoContainer"
logoContainer.Size = UDim2.new(0, 200, 1, 0)
logoContainer.Position = UDim2.new(0, 20, 0, 0)
logoContainer.BackgroundTransparency = 1
logoContainer.ZIndex = 11

-- Animated Logo Text
local logoText = Instance.new("TextLabel")
logoText.Name = "LogoText"
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "NEOX HUB"
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 32
logoText.TextColor3 = colors.primary
logoText.TextXAlignment = Enum.TextXAlignment.Left
logoText.TextYAlignment = Enum.TextYAlignment.Center
logoText.ZIndex = 12

-- Logo Glow Effect
local logoGlow = Instance.new("TextLabel")
logoGlow.Name = "LogoGlow"
logoGlow.Size = logoText.Size
logoGlow.Position = logoText.Position
logoGlow.BackgroundTransparency = 1
logoGlow.Text = "NEOX HUB"
logoGlow.Font = Enum.Font.GothamBlack
logoGlow.TextSize = 32
logoGlow.TextColor3 = colors.primary
logoGlow.TextTransparency = 0.7
logoGlow.TextXAlignment = Enum.TextXAlignment.Left
logoGlow.TextYAlignment = Enum.TextYAlignment.Center
logoGlow.ZIndex = 11

-- Animated Logo
local logoAnimation = Instance.new("Frame")
logoAnimation.Name = "LogoAnimation"
logoAnimation.Size = UDim2.new(0, 40, 0, 40)
logoAnimation.Position = UDim2.new(0, -50, 0.5, -20)
logoAnimation.BackgroundTransparency = 1
logoAnimation.ZIndex = 12

-- Particle System for Logo
local particles = Instance.new("Folder")
particles.Name = "Particles"
particles.Parent = logoAnimation

-- Create Floating Particles
for i = 1, 8 do
    local particle = Instance.new("Frame")
    particle.Name = "Particle" .. i
    particle.Size = UDim2.new(0, math.random(4, 8), 0, math.random(4, 8))
    particle.BackgroundColor3 = colors.primary
    particle.BackgroundTransparency = 0.3
    particle.BorderSizePixel = 0
    particle.ZIndex = 13
    Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
    
    -- Animate particle
    task.spawn(function()
        while particle.Parent do
            local xPos = math.random(-30, 30)
            local yPos = math.random(-30, 30)
            local duration = math.random(2, 4)
            
            TweenService:Create(particle, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0, xPos, 0, yPos),
                BackgroundTransparency = math.random(0.2, 0.5)
            }):Play()
            
            task.wait(duration)
        end
    end)
end

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(0, 200, 0, 20)
subtitle.Position = UDim2.new(0, 20, 0, 50)
subtitle.BackgroundTransparency = 1
subtitle.Text = "PREMIUM EDITION • v2.3"
subtitle.Font = Enum.Font.GothamBold
subtitle.TextSize = 12
subtitle.TextColor3 = colors.textDim
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 11

-- Animated Divider
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(1, -40, 0, 2)
divider.Position = UDim2.new(0, 20, 0, 68)
divider.BackgroundColor3 = colors.primary
divider.BackgroundTransparency = 0.3
divider.BorderSizePixel = 0
divider.ZIndex = 11
Instance.new("UICorner", divider).CornerRadius = UDim.new(1, 0)

-- Animated divider
task.spawn(function()
    while divider.Parent do
        TweenService:Create(divider, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 0.1
        }):Play()
        task.wait(1.5)
        TweenService:Create(divider, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 0.3
        }):Play()
        task.wait(1.5)
    end
end)

-- Control Buttons
local controlButtons = Instance.new("Frame")
controlButtons.Name = "ControlButtons"
controlButtons.Size = UDim2.new(0, 120, 1, 0)
controlButtons.Position = UDim2.new(1, -140, 0, 0)
controlButtons.BackgroundTransparency = 1
controlButtons.ZIndex = 11

-- Minimize Button
local btnMinimize = Instance.new("TextButton")
btnMinimize.Name = "Minimize"
btnMinimize.Size = UDim2.new(0, 35, 0, 35)
btnMinimize.Position = UDim2.new(0, 5, 0.5, -17.5)
btnMinimize.BackgroundColor3 = colors.bg3
btnMinimize.BackgroundTransparency = 0.3
btnMinimize.Text = "─"
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.TextSize = 20
btnMinimize.TextColor3 = colors.text
btnMinimize.AutoButtonColor = false
btnMinimize.ZIndex = 12
Instance.new("UICorner", btnMinimize).CornerRadius = UDim.new(0, 8)

-- Close Button
local btnClose = Instance.new("TextButton")
btnClose.Name = "Close"
btnClose.Size = UDim2.new(0, 35, 0, 35)
btnClose.Position = UDim2.new(0, 50, 0.5, -17.5)
btnClose.BackgroundColor3 = colors.danger
btnClose.BackgroundTransparency = 0.3
btnClose.Text = "×"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 20
btnClose.TextColor3 = colors.text
btnClose.AutoButtonColor = false
btnClose.ZIndex = 12
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 8)

-- Sidebar Navigation
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 220, 1, -70)
sidebar.Position = UDim2.new(0, 0, 0, 70)
sidebar.BackgroundColor3 = colors.bg2
sidebar.BackgroundTransparency = 0.1
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5

-- Sidebar Gradient
local sidebarGradient = Instance.new("UIGradient")
sidebarGradient.Parent = sidebar
sidebarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 25))
})
sidebarGradient.Rotation = 90

-- Navigation Items
local navItems = {
    {name = "Dashboard", icon = "📊"},
    {name = "Auto Fishing", icon = "🎣"},
    {name = "Teleport", icon = "🌍"},
    {name = "Quests", icon = "📜"},
    {name = "Shop", icon = "🛒"},
    {name = "Camera", icon = "📷"},
    {name = "Webhook", icon = "🔗"},
    {name = "Settings", icon = "⚙️"},
    {name = "Info", icon = "ℹ️"}
}

local navContainer = Instance.new("ScrollingFrame")
navContainer.Name = "NavContainer"
navContainer.Size = UDim2.new(1, -20, 1, -20)
navContainer.Position = UDim2.new(0, 10, 0, 10)
navContainer.BackgroundTransparency = 1
navContainer.ScrollBarThickness = 3
navContainer.ScrollBarImageColor3 = colors.primary
navContainer.BorderSizePixel = 0
navContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
navContainer.ZIndex = 6

local navLayout = Instance.new("UIListLayout")
navLayout.Parent = navContainer
navLayout.Padding = UDim.new(0, 8)

-- Create Navigation Buttons
for i, item in ipairs(navItems) do
    local navButton = Instance.new("TextButton")
    navButton.Name = item.name
    navButton.Size = UDim2.new(1, 0, 0, 50)
    navButton.BackgroundColor3 = colors.bg3
    navButton.BackgroundTransparency = 0.3
    navButton.Text = ""
    navButton.AutoButtonColor = false
    navButton.ZIndex = 7
    
    Instance.new("UICorner", navButton).CornerRadius = UDim.new(0, 12)
    
    -- Button Glow
    local buttonGlow = Instance.new("UIStroke")
    buttonGlow.Parent = navButton
    buttonGlow.Color = colors.primary
    buttonGlow.Thickness = 0
    buttonGlow.Transparency = 0.7
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 40, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = item.icon
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 20
    icon.TextColor3 = colors.primary
    icon.TextTransparency = 0.2
    icon.ZIndex = 8
    
    -- Text
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.new(1, -60, 1, 0)
    text.Position = UDim2.new(0, 50, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = item.name
    text.Font = Enum.Font.GothamBold
    text.TextSize = 14
    text.TextColor3 = colors.text
    text.TextTransparency = 0.2
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.ZIndex = 8
    
    -- Active Indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 4, 0, 30)
    indicator.Position = UDim2.new(0, 0, 0.5, -15)
    indicator.BackgroundColor3 = colors.primary
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 9
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    -- Hover Effects
    navButton.MouseEnter:Connect(function()
        TweenService:Create(navButton, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1, 5, 0, 55)
        }):Play()
        TweenService:Create(buttonGlow, TweenInfo.new(0.3), {
            Thickness = 2,
            Transparency = 0.3
        }):Play()
        TweenService:Create(icon, TweenInfo.new(0.3), {
            TextTransparency = 0
        }):Play()
        TweenService:Create(text, TweenInfo.new(0.3), {
            TextTransparency = 0
        }):Play()
    end)
    
    navButton.MouseLeave:Connect(function()
        if not indicator.Visible then
            TweenService:Create(navButton, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.3,
                Size = UDim2.new(1, 0, 0, 50)
            }):Play()
            TweenService:Create(buttonGlow, TweenInfo.new(0.3), {
                Thickness = 0,
                Transparency = 0.7
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.3), {
                TextTransparency = 0.2
            }):Play()
            TweenService:Create(text, TweenInfo.new(0.3), {
                TextTransparency = 0.2
            }):Play()
        end
    end)
    
    navButton.Parent = navContainer
end

-- Main Content Area
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -240, 1, -90)
contentArea.Position = UDim2.new(0, 230, 0, 80)
contentArea.BackgroundColor3 = colors.bg3
contentArea.BackgroundTransparency = 0.1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.ZIndex = 4
Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 20)

-- Content Glow
local contentGlow = Instance.new("UIStroke")
contentGlow.Parent = contentArea
contentGlow.Color = colors.primary
contentGlow.Thickness = 1
contentGlow.Transparency = 0.4

-- Content Header
local contentHeader = Instance.new("Frame")
contentHeader.Name = "ContentHeader"
contentHeader.Size = UDim2.new(1, 0, 0, 60)
contentHeader.Position = UDim2.new(0, 0, 0, 0)
contentHeader.BackgroundColor3 = colors.bg4
contentHeader.BackgroundTransparency = 0.2
contentHeader.BorderSizePixel = 0
contentHeader.ZIndex = 5
Instance.new("UICorner", contentHeader).CornerRadius = UDim.new(0, 20)

-- Page Title
local pageTitle = Instance.new("TextLabel")
pageTitle.Name = "PageTitle"
pageTitle.Size = UDim2.new(0.5, 0, 1, 0)
pageTitle.Position = UDim2.new(0, 20, 0, 0)
pageTitle.BackgroundTransparency = 1
pageTitle.Text = "DASHBOARD"
pageTitle.Font = Enum.Font.GothamBlack
pageTitle.TextSize = 24
pageTitle.TextColor3 = colors.primary
pageTitle.TextXAlignment = Enum.TextXAlignment.Left
pageTitle.TextYAlignment = Enum.TextYAlignment.Center
pageTitle.ZIndex = 6

-- Stats Bar
local statsBar = Instance.new("Frame")
statsBar.Name = "StatsBar"
statsBar.Size = UDim2.new(0.4, 0, 1, 0)
statsBar.Position = UDim2.new(0.55, 0, 0, 0)
statsBar.BackgroundTransparency = 1
statsBar.ZIndex = 6

-- Stat Items
local stats = {
    {label = "FPS", value = "120", color = colors.success},
    {label = "PING", value = "30ms", color = colors.warning},
    {label = "FISH", value = "0", color = colors.primary}
}

for i, stat in ipairs(stats) do
    local statFrame = Instance.new("Frame")
    statFrame.Size = UDim2.new(0.3, 0, 1, -20)
    statFrame.Position = UDim2.new((i-1) * 0.33, 0, 0, 10)
    statFrame.BackgroundColor3 = colors.bg3
    statFrame.BackgroundTransparency = 0.3
    statFrame.BorderSizePixel = 0
    statFrame.ZIndex = 7
    Instance.new("UICorner", statFrame).CornerRadius = UDim.new(0, 10)
    
    local statLabel = Instance.new("TextLabel")
    statLabel.Size = UDim2.new(1, 0, 0, 20)
    statLabel.Position = UDim2.new(0, 0, 0, 5)
    statLabel.BackgroundTransparency = 1
    statLabel.Text = stat.label
    statLabel.Font = Enum.Font.GothamBold
    statLabel.TextSize = 12
    statLabel.TextColor3 = colors.textDim
    statLabel.ZIndex = 8
    
    local statValue = Instance.new("TextLabel")
    statValue.Size = UDim2.new(1, 0, 0, 25)
    statValue.Position = UDim2.new(0, 0, 0, 25)
    statValue.BackgroundTransparency = 1
    statValue.Text = stat.value
    statValue.Font = Enum.Font.GothamBlack
    statValue.TextSize = 18
    statValue.TextColor3 = stat.color
    statValue.ZIndex = 8
    
    statFrame.Parent = statsBar
end

-- Content Scroller
local contentScroller = Instance.new("ScrollingFrame")
contentScroller.Name = "ContentScroller"
contentScroller.Size = UDim2.new(1, -20, 1, -80)
contentScroller.Position = UDim2.new(0, 10, 0, 70)
contentScroller.BackgroundTransparency = 1
contentScroller.ScrollBarThickness = 4
contentScroller.ScrollBarImageColor3 = colors.primary
contentScroller.BorderSizePixel = 0
contentScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroller.ZIndex = 5

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentScroller
contentLayout.Padding = UDim.new(0, 15)

-- Footer
local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 1, -40)
footer.BackgroundColor3 = colors.bg2
footer.BackgroundTransparency = 0.1
footer.BorderSizePixel = 0
footer.ZIndex = 10
Instance.new("UICorner", footer).CornerRadius = UDim.new(0, 24)

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(0.5, 0, 1, 0)
footerText.Position = UDim2.new(0, 20, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "© 2024 Neox Hub • Premium Edition"
footerText.Font = Enum.Font.Gotham
footerText.TextSize = 12
footerText.TextColor3 = colors.textDim
footerText.TextXAlignment = Enum.TextXAlignment.Left
footerText.ZIndex = 11

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.4, 0, 1, 0)
statusText.Position = UDim2.new(0.55, 0, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🟢 CONNECTED • v2.3"
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 12
statusText.TextColor3 = colors.success
statusText.TextXAlignment = Enum.TextXAlignment.Right
statusText.ZIndex = 11

-- Particle System for Background
local backgroundParticles = Instance.new("Folder")
backgroundParticles.Name = "BackgroundParticles"
backgroundParticles.Parent = mainContainer

-- Create Background Particles
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Name = "BgParticle" .. i
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(0, math.random(0, 800), 0, math.random(0, 500))
    particle.BackgroundColor3 = colors.primary
    particle.BackgroundTransparency = math.random(0.7, 0.9)
    particle.BorderSizePixel = 0
    particle.ZIndex = 0
    
    Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
    
    -- Floating animation
    task.spawn(function()
        while particle.Parent do
            local targetX = particle.Position.X.Offset + math.random(-50, 50)
            local targetY = particle.Position.Y.Offset + math.random(-50, 50)
            local duration = math.random(3, 6)
            
            TweenService:Create(particle, TweenInfo.new(duration, Enum.EasingStyle.Sine), {
                Position = UDim2.new(0, math.clamp(targetX, 0, 800), 0, math.clamp(targetY, 0, 500))
            }):Play()
            
            task.wait(duration)
        end
    end)
    
    particle.Parent = backgroundParticles
end

-- Function to Create Category Card
function createCategoryCard(title, icon)
    local card = Instance.new("Frame")
    card.Name = title .. "Card"
    card.Size = UDim2.new(1, 0, 0, 100)
    card.BackgroundColor3 = colors.bg4
    card.BackgroundTransparency = 0.2
    card.BorderSizePixel = 0
    card.ZIndex = 6
    
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 15)
    
    -- Card Glow
    local cardGlow = Instance.new("UIStroke")
    cardGlow.Parent = card
    cardGlow.Color = colors.primary
    cardGlow.Thickness = 1
    cardGlow.Transparency = 0.5
    
    -- Card Header
    local cardHeader = Instance.new("Frame")
    cardHeader.Size = UDim2.new(1, 0, 0, 40)
    cardHeader.Position = UDim2.new(0, 0, 0, 0)
    cardHeader.BackgroundTransparency = 1
    cardHeader.ZIndex = 7
    
    local cardIcon = Instance.new("TextLabel")
    cardIcon.Size = UDim2.new(0, 40, 1, 0)
    cardIcon.Position = UDim2.new(0, 10, 0, 0)
    cardIcon.BackgroundTransparency = 1
    cardIcon.Text = icon
    cardIcon.Font = Enum.Font.GothamBlack
    cardIcon.TextSize = 24
    cardIcon.TextColor3 = colors.primary
    cardIcon.TextTransparency = 0.1
    cardIcon.ZIndex = 8
    
    local cardTitle = Instance.new("TextLabel")
    cardTitle.Size = UDim2.new(1, -60, 1, 0)
    cardTitle.Position = UDim2.new(0, 50, 0, 0)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Text = title
    cardTitle.Font = Enum.Font.GothamBlack
    cardTitle.TextSize = 18
    cardTitle.TextColor3 = colors.text
    cardTitle.TextXAlignment = Enum.TextXAlignment.Left
    cardTitle.ZIndex = 8
    
    -- Hover Effect
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1, 5, 0, 105)
        }):Play()
        TweenService:Create(cardGlow, TweenInfo.new(0.3), {
            Thickness = 2,
            Transparency = 0.2
        }):Play()
    end)
    
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(1, 0, 0, 100)
        }):Play()
        TweenService:Create(cardGlow, TweenInfo.new(0.3), {
            Thickness = 1,
            Transparency = 0.5
        }):Play()
    end)
    
    return card
end

-- Parent all elements
blur.Parent = mainContainer
glassEffect.Parent = mainContainer
innerGlow.Parent = mainContainer
header.Parent = mainContainer
logoContainer.Parent = header
logoAnimation.Parent = logoContainer
logoGlow.Parent = logoContainer
logoText.Parent = logoContainer
subtitle.Parent = header
divider.Parent = header
controlButtons.Parent = header
btnMinimize.Parent = controlButtons
btnClose.Parent = controlButtons
sidebar.Parent = mainContainer
navContainer.Parent = sidebar
contentArea.Parent = mainContainer
contentHeader.Parent = contentArea
pageTitle.Parent = contentHeader
statsBar.Parent = contentHeader
contentScroller.Parent = contentArea
footer.Parent = mainContainer
footerText.Parent = footer
statusText.Parent = footer
mainContainer.Parent = gui

-- Create Sample Categories
local categories = {
    {title = "Auto Fishing", icon = "🎣"},
    {title = "Instant Fishing", icon = "⚡"},
    {title = "Teleport System", icon = "🌍"},
    {title = "Quest Automator", icon = "📜"},
    {title = "Shop Features", icon = "🛒"},
    {title = "Camera Control", icon = "📷"}
}

for i, category in ipairs(categories) do
    local card = createCategoryCard(category.title, category.icon)
    card.LayoutOrder = i
    card.Parent = contentScroller
end

-- Opening Animation
mainContainer.Size = UDim2.new(0, 0, 0, 0)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)

task.wait(0.2)

TweenService:Create(mainContainer, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 850, 0, 450),
    Position = UDim2.new(0.5, -425, 0.5, -300)
}):Play()

-- Logo Animation
task.spawn(function()
    while logoText.Parent do
        TweenService:Create(logoText, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            TextTransparency = 0.1
        }):Play()
        task.wait(1.5)
        TweenService:Create(logoText, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            TextTransparency = 0
        }):Play()
        task.wait(1.5)
    end
end)

print("✨ Neox Hub Premium UI Loaded Successfully!")
print("🎨 Theme: Cyber Neon Blue")
print("🔧 Features: Glass Morphism, Particles, Animations")
print("📱 Dimensions: 850x600")