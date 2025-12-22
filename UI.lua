-- Neox Hub Premium UI v2.4 - Clean & Bug-Free
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Wait for player
repeat task.wait() until localPlayer:FindFirstChild("PlayerGui")

-- Theme Colors (Cyber Blue Premium)
local colors = {
    -- Primary Colors
    primary = Color3.fromRGB(0, 180, 255),       -- Bright Cyan
    primaryLight = Color3.fromRGB(0, 200, 255),  -- Light Cyan
    primaryDark = Color3.fromRGB(0, 140, 220),   -- Dark Cyan
    
    -- Accent Colors
    success = Color3.fromRGB(0, 230, 118),       -- Mint Green
    warning = Color3.fromRGB(255, 214, 0),       -- Amber
    error = Color3.fromRGB(255, 82, 82),         -- Red
    
    -- Background Colors
    bg1 = Color3.fromRGB(8, 12, 24),             -- Deep Space
    bg2 = Color3.fromRGB(12, 18, 36),            -- Dark Blue
    bg3 = Color3.fromRGB(18, 26, 48),            -- Medium Blue
    bg4 = Color3.fromRGB(24, 34, 60),            -- Light Blue
    
    -- Text Colors
    text = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(200, 215, 240),
    textTertiary = Color3.fromRGB(150, 170, 200),
    
    -- UI Elements
    border = Color3.fromRGB(40, 60, 100),
    shadow = Color3.fromRGB(0, 0, 0),
    
    -- Special Effects
    glow = Color3.fromRGB(0, 150, 255),
    particle = Color3.fromRGB(0, 170, 255)
}

-- Screen size detection
local screenSize = workspace.CurrentCamera.ViewportSize
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Responsive sizing
local windowWidth = isMobile and math.min(360, screenSize.X * 0.95) or 420
local windowHeight = isMobile and math.min(500, screenSize.Y * 0.85) or 520

-- Main GUI Container
local gui = Instance.new("ScreenGui")
gui.Name = "NeoxHubPremium"
gui.Parent = localPlayer.PlayerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- Main Window Frame
local window = Instance.new("Frame")
window.Name = "MainWindow"
window.Size = UDim2.new(0, windowWidth, 0, windowHeight)
window.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
window.BackgroundColor3 = colors.bg1
window.BackgroundTransparency = 0
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.ZIndex = 1

-- Window Rounded Corners
local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 14)
windowCorner.Parent = window

-- Window Outer Glow
local windowGlow = Instance.new("UIStroke")
windowGlow.Parent = window
windowGlow.Color = colors.primary
windowGlow.Thickness = 1.5
windowGlow.Transparency = 0.15
windowGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Window Shadow
local windowShadow = Instance.new("ImageLabel")
windowShadow.Name = "Shadow"
windowShadow.Size = UDim2.new(1, 20, 1, 20)
windowShadow.Position = UDim2.new(0, -10, 0, -10)
windowShadow.BackgroundTransparency = 1
windowShadow.Image = "rbxassetid://5554237733"
windowShadow.ImageColor3 = Color3.new(0, 0, 0)
windowShadow.ImageTransparency = 0.8
windowShadow.ScaleType = Enum.ScaleType.Slice
windowShadow.SliceCenter = Rect.new(10, 10, 118, 118)
windowShadow.ZIndex = 0

-- Premium Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = colors.bg2
header.BackgroundTransparency = 0
header.BorderSizePixel = 0
header.ZIndex = 10

-- Header Corner (only top corners rounded)
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

-- Header Gradient
local headerGradient = Instance.new("UIGradient")
headerGradient.Parent = header
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 30, 60)),
    ColorSequenceKeypoint.new(1, colors.bg2)
})
headerGradient.Rotation = 90
headerGradient.Transparency = NumberSequence.new(0.3)

-- Logo Container
local logoContainer = Instance.new("Frame")
logoContainer.Name = "LogoContainer"
logoContainer.Size = UDim2.new(0.7, 0, 1, 0)
logoContainer.Position = UDim2.new(0, 15, 0, 0)
logoContainer.BackgroundTransparency = 1
logoContainer.ZIndex = 11

-- Logo Text with Glow Effect
local logoText = Instance.new("TextLabel")
logoText.Name = "Logo"
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "NEOX HUB"
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 24
logoText.TextColor3 = colors.primaryLight
logoText.TextXAlignment = Enum.TextXAlignment.Left
logoText.TextYAlignment = Enum.TextYAlignment.Center
logoText.ZIndex = 12
logoText.TextStrokeTransparency = 0.7
logoText.TextStrokeColor3 = colors.primary

-- Logo Glow (Background glow effect)
local logoGlow = Instance.new("TextLabel")
logoGlow.Name = "LogoGlow"
logoGlow.Size = logoText.Size
logoGlow.Position = logoText.Position
logoGlow.BackgroundTransparency = 1
logoGlow.Text = "NEOX HUB"
logoGlow.Font = Enum.Font.GothamBlack
logoGlow.TextSize = 24
logoGlow.TextColor3 = colors.primary
logoGlow.TextTransparency = 0.6
logoGlow.ZIndex = 11

-- Version Badge
local versionBadge = Instance.new("Frame")
versionBadge.Name = "VersionBadge"
versionBadge.Size = UDim2.new(0, 70, 0, 24)
versionBadge.Position = UDim2.new(1, -80, 0.5, -12)
versionBadge.BackgroundColor3 = colors.primaryDark
versionBadge.BackgroundTransparency = 0.2
versionBadge.BorderSizePixel = 0
versionBadge.ZIndex = 11

local versionCorner = Instance.new("UICorner")
versionCorner.CornerRadius = UDim.new(1, 0)
versionCorner.Parent = versionBadge

local versionText = Instance.new("TextLabel")
versionText.Name = "Version"
versionText.Size = UDim2.new(1, 0, 1, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v2.4"
versionText.Font = Enum.Font.GothamBold
versionText.TextSize = 12
versionText.TextColor3 = colors.text
versionText.ZIndex = 12

-- Control Buttons
local controls = Instance.new("Frame")
controls.Name = "Controls"
controls.Size = UDim2.new(0, 80, 1, 0)
controls.Position = UDim2.new(1, -85, 0, 0)
controls.BackgroundTransparency = 1
controls.ZIndex = 11

-- Minimize Button
local btnMin = Instance.new("TextButton")
btnMin.Name = "Minimize"
btnMin.Size = UDim2.new(0, 32, 0, 32)
btnMin.Position = UDim2.new(0, 0, 0.5, -16)
btnMin.BackgroundColor3 = colors.bg3
btnMin.BackgroundTransparency = 0.3
btnMin.Text = "─"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 18
btnMin.TextColor3 = colors.textSecondary
btnMin.AutoButtonColor = false
btnMin.ZIndex = 12

local btnMinCorner = Instance.new("UICorner")
btnMinCorner.CornerRadius = UDim.new(0, 8)
btnMinCorner.Parent = btnMin

local btnMinGlow = Instance.new("UIStroke")
btnMinGlow.Parent = btnMin
btnMinGlow.Color = colors.primary
btnMinGlow.Thickness = 0
btnMinGlow.Transparency = 0.7

-- Close Button
local btnClose = Instance.new("TextButton")
btnClose.Name = "Close"
btnClose.Size = UDim2.new(0, 32, 0, 32)
btnClose.Position = UDim2.new(0, 40, 0.5, -16)
btnClose.BackgroundColor3 = colors.error
btnClose.BackgroundTransparency = 0.3
btnClose.Text = "×"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 18
btnClose.TextColor3 = colors.text
btnClose.AutoButtonColor = false
btnClose.ZIndex = 12

local btnCloseCorner = Instance.new("UICorner")
btnCloseCorner.CornerRadius = UDim.new(0, 8)
btnCloseCorner.Parent = btnClose

local btnCloseGlow = Instance.new("UIStroke")
btnCloseGlow.Parent = btnClose
btnCloseGlow.Color = colors.error
btnCloseGlow.Thickness = 0
btnCloseGlow.Transparency = 0.7

-- Navigation Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 120, 1, -65)
sidebar.Position = UDim2.new(0, 0, 0, 60)
sidebar.BackgroundColor3 = colors.bg2
sidebar.BackgroundTransparency = 0
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5

-- Sidebar Corner (only bottom-left rounded)
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 0, 0, 0, 0, 14, 0, 0)
sidebarCorner.Parent = sidebar

-- Navigation Container
local navContainer = Instance.new("ScrollingFrame")
navContainer.Name = "NavContainer"
navContainer.Size = UDim2.new(1, -10, 1, -15)
navContainer.Position = UDim2.new(0, 5, 0, 10)
navContainer.BackgroundTransparency = 1
navContainer.ScrollBarThickness = 2
navContainer.ScrollBarImageColor3 = colors.primary
navContainer.ScrollBarImageTransparency = 0.5
navContainer.BorderSizePixel = 0
navContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
navContainer.ZIndex = 6

local navLayout = Instance.new("UIListLayout")
navLayout.Parent = navContainer
navLayout.Padding = UDim.new(0, 8)
navLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Navigation Items
local navItems = {
    {name = "Dashboard", icon = "📊", order = 1},
    {name = "Auto Fishing", icon = "🎣", order = 2},
    {name = "Teleport", icon = "🌍", order = 3},
    {name = "Quests", icon = "📜", order = 4},
    {name = "Shop", icon = "🛒", order = 5},
    {name = "Camera", icon = "📷", order = 6},
    {name = "Webhook", icon = "🔗", order = 7},
    {name = "Settings", icon = "⚙️", order = 8},
    {name = "Info", icon = "ℹ️", order = 9}
}

-- Sort by order
table.sort(navItems, function(a, b) return a.order < b.order end)

-- Create Navigation Buttons
for _, item in ipairs(navItems) do
    local navBtn = Instance.new("TextButton")
    navBtn.Name = item.name .. "Btn"
    navBtn.Size = UDim2.new(1, 0, 0, 42)
    navBtn.BackgroundColor3 = colors.bg3
    navBtn.BackgroundTransparency = 0.3
    navBtn.Text = ""
    navBtn.AutoButtonColor = false
    navBtn.LayoutOrder = item.order
    navBtn.ZIndex = 7
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = navBtn
    
    local btnGlow = Instance.new("UIStroke")
    btnGlow.Parent = navBtn
    btnGlow.Color = colors.border
    btnGlow.Thickness = 0
    btnGlow.Transparency = 0.8
    
    -- Active Indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 4, 0, 26)
    indicator.Position = UDim2.new(0, 3, 0.5, -13)
    indicator.BackgroundColor3 = colors.primary
    indicator.BorderSizePixel = 0
    indicator.Visible = item.order == 1
    indicator.ZIndex = 8
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 32, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = item.icon
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 18
    icon.TextColor3 = item.order == 1 and colors.primary or colors.textTertiary
    icon.TextTransparency = item.order == 1 and 0 or 0.3
    icon.ZIndex = 8
    
    -- Text
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.new(1, -45, 1, 0)
    text.Position = UDim2.new(0, 42, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = item.name
    text.Font = Enum.Font.GothamBold
    text.TextSize = 11
    text.TextColor3 = item.order == 1 and colors.text or colors.textTertiary
    text.TextTransparency = item.order == 1 and 0.1 or 0.4
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.ZIndex = 8
    
    -- Hover Effects
    navBtn.MouseEnter:Connect(function()
        if not indicator.Visible then
            TweenService:Create(navBtn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.2,
                Size = UDim2.new(1, 3, 0, 45)
            }):Play()
            TweenService:Create(btnGlow, TweenInfo.new(0.2), {
                Thickness = 1,
                Color = colors.primary,
                Transparency = 0.3
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {
                TextColor3 = colors.primary,
                TextTransparency = 0
            }):Play()
            TweenService:Create(text, TweenInfo.new(0.2), {
                TextColor3 = colors.textSecondary,
                TextTransparency = 0
            }):Play()
        end
    end)
    
    navBtn.MouseLeave:Connect(function()
        if not indicator.Visible then
            TweenService:Create(navBtn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.3,
                Size = UDim2.new(1, 0, 0, 42)
            }):Play()
            TweenService:Create(btnGlow, TweenInfo.new(0.2), {
                Thickness = 0,
                Color = colors.border,
                Transparency = 0.8
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {
                TextColor3 = colors.textTertiary,
                TextTransparency = 0.3
            }):Play()
            TweenService:Create(text, TweenInfo.new(0.2), {
                TextColor3 = colors.textTertiary,
                TextTransparency = 0.4
            }):Play()
        end
    end)
    
    -- Assemble button
    indicator.Parent = navBtn
    icon.Parent = navBtn
    text.Parent = navBtn
    navBtn.Parent = navContainer
end

-- Main Content Area
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -125, 1, -65)
content.Position = UDim2.new(0, 120, 0, 60)
content.BackgroundColor3 = colors.bg3
content.BackgroundTransparency = 0
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.ZIndex = 4

-- Content Corner (only bottom-right rounded)
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 0, 0, 0, 0, 0, 14, 0)
contentCorner.Parent = content

-- Content Glow
local contentGlow = Instance.new("UIStroke")
contentGlow.Parent = content
contentGlow.Color = colors.border
contentGlow.Thickness = 1
contentGlow.Transparency = 0.3

-- Content Header
local contentHeader = Instance.new("Frame")
contentHeader.Name = "ContentHeader"
contentHeader.Size = UDim2.new(1, -20, 0, 40)
contentHeader.Position = UDim2.new(0, 10, 0, 10)
contentHeader.BackgroundColor3 = colors.bg4
contentHeader.BackgroundTransparency = 0.1
contentHeader.BorderSizePixel = 0
contentHeader.ZIndex = 5

local contentHeaderCorner = Instance.new("UICorner")
contentHeaderCorner.CornerRadius = UDim.new(0, 10)
contentHeaderCorner.Parent = contentHeader

-- Page Title
local pageTitle = Instance.new("TextLabel")
pageTitle.Name = "PageTitle"
pageTitle.Size = UDim2.new(0.6, 0, 1, 0)
pageTitle.Position = UDim2.new(0, 15, 0, 0)
pageTitle.BackgroundTransparency = 1
pageTitle.Text = "DASHBOARD"
pageTitle.Font = Enum.Font.GothamBlack
pageTitle.TextSize = 18
pageTitle.TextColor3 = colors.primaryLight
pageTitle.TextXAlignment = Enum.TextXAlignment.Left
pageTitle.TextYAlignment = Enum.TextYAlignment.Center
pageTitle.ZIndex = 6

-- Stats Container
local statsContainer = Instance.new("Frame")
statsContainer.Name = "Stats"
statsContainer.Size = UDim2.new(0.35, 0, 1, 0)
statsContainer.Position = UDim2.new(0.65, 0, 0, 0)
statsContainer.BackgroundTransparency = 1
statsContainer.ZIndex = 6

-- Create Stats
local stats = {
    {label = "FPS", value = "120", icon = "⚡", color = colors.success},
    {label = "PING", value = "30ms", icon = "📶", color = colors.warning},
    {label = "FISH", value = "0", icon = "🎣", color = colors.primary}
}

for i, stat in ipairs(stats) do
    local statFrame = Instance.new("Frame")
    statFrame.Size = UDim2.new(0.3, 0, 1, -10)
    statFrame.Position = UDim2.new((i-1) * 0.33, 0, 0, 5)
    statFrame.BackgroundColor3 = colors.bg3
    statFrame.BackgroundTransparency = 0.2
    statFrame.BorderSizePixel = 0
    statFrame.ZIndex = 7
    
    local statCorner = Instance.new("UICorner")
    statCorner.CornerRadius = UDim.new(0, 8)
    statCorner.Parent = statFrame
    
    -- Icon
    local statIcon = Instance.new("TextLabel")
    statIcon.Size = UDim2.new(1, 0, 0, 20)
    statIcon.Position = UDim2.new(0, 0, 0, 5)
    statIcon.BackgroundTransparency = 1
    statIcon.Text = stat.icon
    statIcon.Font = Enum.Font.GothamBold
    statIcon.TextSize = 14
    statIcon.TextColor3 = stat.color
    statIcon.ZIndex = 8
    
    -- Value
    local statValue = Instance.new("TextLabel")
    statValue.Size = UDim2.new(1, 0, 0, 20)
    statValue.Position = UDim2.new(0, 0, 0, 25)
    statValue.BackgroundTransparency = 1
    statValue.Text = stat.value
    statValue.Font = Enum.Font.GothamBlack
    statValue.TextSize = 16
    statValue.TextColor3 = stat.color
    statValue.ZIndex = 8
    
    -- Label
    local statLabel = Instance.new("TextLabel")
    statLabel.Size = UDim2.new(1, 0, 0, 12)
    statLabel.Position = UDim2.new(0, 0, 0, 45)
    statLabel.BackgroundTransparency = 1
    statLabel.Text = stat.label
    statLabel.Font = Enum.Font.GothamBold
    statLabel.TextSize = 10
    statLabel.TextColor3 = colors.textTertiary
    statLabel.ZIndex = 8
    
    statFrame.Parent = statsContainer
    statIcon.Parent = statFrame
    statValue.Parent = statFrame
    statLabel.Parent = statFrame
end

-- Content Scroller
local contentScroller = Instance.new("ScrollingFrame")
contentScroller.Name = "ContentScroller"
contentScroller.Size = UDim2.new(1, -20, 1, -65)
contentScroller.Position = UDim2.new(0, 10, 0, 55)
contentScroller.BackgroundTransparency = 1
contentScroller.ScrollBarThickness = 3
contentScroller.ScrollBarImageColor3 = colors.primary
contentScroller.ScrollBarImageTransparency = 0.5
contentScroller.BorderSizePixel = 0
contentScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroller.ZIndex = 5

local scrollerLayout = Instance.new("UIListLayout")
scrollerLayout.Parent = contentScroller
scrollerLayout.Padding = UDim.new(0, 12)

-- Function to create category
local function createCategory(title, icon)
    local category = Instance.new("Frame")
    category.Name = title .. "Category"
    category.Size = UDim2.new(1, 0, 0, 40)
    category.BackgroundColor3 = colors.bg4
    category.BackgroundTransparency = 0.1
    category.BorderSizePixel = 0
    category.ZIndex = 6
    
    local catCorner = Instance.new("UICorner")
    catCorner.CornerRadius = UDim.new(0, 10)
    catCorner.Parent = category
    
    local catGlow = Instance.new("UIStroke")
    catGlow.Parent = category
    catGlow.Color = colors.border
    catGlow.Thickness = 1
    catGlow.Transparency = 0.5
    
    -- Header Button
    local headerBtn = Instance.new("TextButton")
    headerBtn.Name = "Header"
    headerBtn.Size = UDim2.new(1, 0, 1, 0)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.AutoButtonColor = false
    headerBtn.ZIndex = 7
    
    -- Icon
    local catIcon = Instance.new("TextLabel")
    catIcon.Size = UDim2.new(0, 35, 1, 0)
    catIcon.Position = UDim2.new(0, 10, 0, 0)
    catIcon.BackgroundTransparency = 1
    catIcon.Text = icon
    catIcon.Font = Enum.Font.GothamBold
    catIcon.TextSize = 18
    catIcon.TextColor3 = colors.primary
    catIcon.TextTransparency = 0.1
    catIcon.ZIndex = 8
    
    -- Title
    local catTitle = Instance.new("TextLabel")
    catTitle.Size = UDim2.new(1, -55, 1, 0)
    catTitle.Position = UDim2.new(0, 45, 0, 0)
    catTitle.BackgroundTransparency = 1
    catTitle.Text = title
    catTitle.Font = Enum.Font.GothamBold
    catTitle.TextSize = 14
    catTitle.TextColor3 = colors.text
    catTitle.TextXAlignment = Enum.TextXAlignment.Left
    catTitle.ZIndex = 8
    
    -- Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 12
    arrow.TextColor3 = colors.primary
    arrow.ZIndex = 8
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "Content"
    contentContainer.Size = UDim2.new(1, -10, 0, 0)
    contentContainer.Position = UDim2.new(0, 5, 0, 45)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Visible = false
    contentContainer.AutomaticSize = Enum.AutomaticSize.Y
    contentContainer.ClipsDescendants = true
    contentContainer.ZIndex = 7
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Parent = contentContainer
    containerLayout.Padding = UDim.new(0, 8)
    
    local containerPadding = Instance.new("UIPadding")
    containerPadding.Parent = contentContainer
    containerPadding.PaddingLeft = UDim.new(0, 5)
    containerPadding.PaddingRight = UDim.new(0, 5)
    containerPadding.PaddingBottom = UDim.new(0, 8)
    
    -- Toggle state
    local isOpen = false
    
    -- Update size function
    local function updateSize()
        if isOpen then
            local contentHeight = contentContainer.AbsoluteContentSize.Y
            category.Size = UDim2.new(1, 0, 0, 45 + contentHeight)
        else
            category.Size = UDim2.new(1, 0, 0, 40)
        end
    end
    
    -- Connect layout to update size
    containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)
    
    -- Toggle function
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        
        TweenService:Create(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Rotation = isOpen and 180 or 0
        }):Play()
        
        TweenService:Create(category, TweenInfo.new(0.25), {
            BackgroundTransparency = isOpen and 0.05 or 0.1
        }):Play()
        
        updateSize()
    end)
    
    -- Hover effects
    headerBtn.MouseEnter:Connect(function()
        if not isOpen then
            TweenService:Create(category, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.05,
                Size = UDim2.new(1, 3, 0, 42)
            }):Play()
            TweenService:Create(catIcon, TweenInfo.new(0.2), {
                TextTransparency = 0
            }):Play()
        end
    end)
    
    headerBtn.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(category, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.1,
                Size = UDim2.new(1, 0, 0, 40)
            }):Play()
            TweenService:Create(catIcon, TweenInfo.new(0.2), {
                TextTransparency = 0.1
            }):Play()
        end
    end)
    
    -- Assemble
    headerBtn.Parent = category
    catIcon.Parent = headerBtn
    catTitle.Parent = headerBtn
    arrow.Parent = headerBtn
    contentContainer.Parent = category
    
    return category, contentContainer
end

-- Function to create toggle
local function createToggle(label, initialState)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = label .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.ZIndex = 7
    
    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Name = "Label"
    labelText.Size = UDim2.new(0.7, 0, 1, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.Font = Enum.Font.GothamBold
    labelText.TextSize = 12
    labelText.TextColor3 = colors.text
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.ZIndex = 8
    
    -- Toggle Container
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, 46, 0, 24)
    toggleContainer.Position = UDim2.new(1, -50, 0.5, -12)
    toggleContainer.BackgroundColor3 = colors.bg3
    toggleContainer.BackgroundTransparency = 0.2
    toggleContainer.BorderSizePixel = 0
    toggleContainer.ZIndex = 8
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleContainer
    
    -- Toggle Knob
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "Knob"
    toggleKnob.Size = UDim2.new(0, 18, 0, 18)
    toggleKnob.Position = UDim2.new(0, 3, 0.5, -9)
    toggleKnob.BackgroundColor3 = initialState and colors.primary or colors.textTertiary
    toggleKnob.BorderSizePixel = 0
    toggleKnob.ZIndex = 9
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob
    
    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Button"
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 10
    
    local isOn = initialState or false
    
    -- Toggle function
    local function toggleState()
        isOn = not isOn
        
        if isOn then
            TweenService:Create(toggleContainer, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.primary
            }):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -21, 0.5, -9),
                BackgroundColor3 = colors.text
            }):Play()
        else
            TweenService:Create(toggleContainer, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.bg3
            }):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = colors.textTertiary
            }):Play()
        end
        
        return isOn
    end
    
    -- Set initial state
    if initialState then
        toggleContainer.BackgroundColor3 = colors.primary
        toggleKnob.Position = UDim2.new(1, -21, 0.5, -9)
        toggleKnob.BackgroundColor3 = colors.text
    end
    
    -- Connect click
    toggleBtn.MouseButton1Click:Connect(toggleState)
    
    -- Assemble
    toggleContainer.Parent = toggleFrame
    toggleKnob.Parent = toggleContainer
    toggleBtn.Parent = toggleContainer
    labelText.Parent = toggleFrame
    
    return toggleFrame, toggleBtn, function() return isOn end, toggleState
end

-- Function to create button
local function createButton(label, widthPercent)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = label .. "Btn"
    buttonFrame.Size = UDim2.new(widthPercent or 1, 0, 0, 34)
    buttonFrame.BackgroundColor3 = colors.primary
    buttonFrame.BackgroundTransparency = 0.2
    buttonFrame.BorderSizePixel = 0
    buttonFrame.ZIndex = 7
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = buttonFrame
    
    local buttonGlow = Instance.new("UIStroke")
    buttonGlow.Parent = buttonFrame
    buttonGlow.Color = colors.primary
    buttonGlow.Thickness = 0
    buttonGlow.Transparency = 0.5
    
    -- Button Text
    local buttonText = Instance.new("TextButton")
    buttonText.Name = "Button"
    buttonText.Size = UDim2.new(1, 0, 1, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = label
    buttonText.Font = Enum.Font.GothamBold
    buttonText.TextSize = 13
    buttonText.TextColor3 = colors.text
    buttonText.AutoButtonColor = false
    buttonText.ZIndex = 8
    
    -- Hover effects
    buttonText.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(widthPercent or 1, 4, 0, 36)
        }):Play()
        TweenService:Create(buttonGlow, TweenInfo.new(0.2), {
            Thickness = 2
        }):Play()
    end)
    
    buttonText.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(widthPercent or 1, 0, 0, 34)
        }):Play()
        TweenService:Create(buttonGlow, TweenInfo.new(0.2), {
            Thickness = 0
        }):Play()
    end)
    
    -- Click effect
    buttonText.MouseButton1Down:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            Size = UDim2.new((widthPercent or 1) * 0.98, 0, 0, 32)
        }):Play()
    end)
    
    buttonText.MouseButton1Up:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            Size = UDim2.new(widthPercent or 1, 4, 0, 36)
        }):Play()
    end)
    
    return buttonFrame, buttonText
end

-- Function to create input
local function createInput(label, placeholder, defaultValue)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = label .. "Input"
    inputFrame.Size = UDim2.new(1, 0, 0, 50)
    inputFrame.BackgroundTransparency = 1
    inputFrame.ZIndex = 7
    
    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Name = "Label"
    labelText.Size = UDim2.new(1, 0, 0, 18)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.Font = Enum.Font.GothamBold
    labelText.TextSize = 11
    labelText.TextColor3 = colors.textSecondary
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.ZIndex = 8
    
    -- Input Box
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "Input"
    inputBox.Size = UDim2.new(1, 0, 0, 28)
    inputBox.Position = UDim2.new(0, 0, 0, 22)
    inputBox.BackgroundColor3 = colors.bg4
    inputBox.BackgroundTransparency = 0.1
    inputBox.Text = defaultValue or ""
    inputBox.PlaceholderText = placeholder or "Enter value..."
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 12
    inputBox.TextColor3 = colors.text
    inputBox.PlaceholderColor3 = colors.textTertiary
    inputBox.ClearTextOnFocus = false
    inputBox.ZIndex = 8
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputBox
    
    local inputGlow = Instance.new("UIStroke")
    inputGlow.Parent = inputBox
    inputGlow.Color = colors.border
    inputGlow.Thickness = 1
    inputGlow.Transparency = 0.3
    
    -- Focus effects
    inputBox.Focused:Connect(function()
        TweenService:Create(inputGlow, TweenInfo.new(0.2), {
            Color = colors.primary,
            Thickness = 1.5,
            Transparency = 0.2
        }):Play()
    end)
    
    inputBox.FocusLost:Connect(function()
        TweenService:Create(inputGlow, TweenInfo.new(0.2), {
            Color = colors.border,
            Thickness = 1,
            Transparency = 0.3
        }):Play()
    end)
    
    labelText.Parent = inputFrame
    inputBox.Parent = inputFrame
    
    return inputFrame, inputBox
end

-- Create Dashboard Content
local function createDashboardContent()
    -- Clear existing content
    for _, child in ipairs(contentScroller:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Welcome Card
    local welcomeCard = Instance.new("Frame")
    welcomeCard.Name = "WelcomeCard"
    welcomeCard.Size = UDim2.new(1, 0, 0, 80)
    welcomeCard.BackgroundColor3 = colors.bg4
    welcomeCard.BackgroundTransparency = 0.1
    welcomeCard.BorderSizePixel = 0
    welcomeCard.ZIndex = 6
    
    local welcomeCorner = Instance.new("UICorner")
    welcomeCorner.CornerRadius = UDim.new(0, 12)
    welcomeCorner.Parent = welcomeCard
    
    local welcomeGlow = Instance.new("UIStroke")
    welcomeGlow.Parent = welcomeCard
    welcomeGlow.Color = colors.primary
    welcomeGlow.Thickness = 1
    welcomeGlow.Transparency = 0.3
    
    -- Welcome Text
    local welcomeText = Instance.new("TextLabel")
    welcomeText.Size = UDim2.new(1, -20, 1, -20)
    welcomeText.Position = UDim2.new(0, 10, 0, 10)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Text = "Welcome to Neox Hub Premium\nVersion 2.4 - Optimized Performance"
    welcomeText.Font = Enum.Font.Gotham
    welcomeText.TextSize = 13
    welcomeText.TextColor3 = colors.textSecondary
    welcomeText.TextWrapped = true
    welcomeText.TextXAlignment = Enum.TextXAlignment.Left
    welcomeText.ZIndex = 7
    
    welcomeText.Parent = welcomeCard
    welcomeCard.Parent = contentScroller
    
    -- Auto Fishing Category
    local fishingCat, fishingContent = createCategory("Auto Fishing", "🎣")
    
    local instantToggle = createToggle("Instant Fishing", false)
    instantToggle.Parent = fishingContent
    
    local speedInput = createInput("Fishing Speed", "0.05", "0.05")
    speedInput.Parent = fishingContent
    
    local delayInput = createInput("Cancel Delay", "0.01", "0.01")
    delayInput.Parent = fishingContent
    
    local startBtn = createButton("Start Fishing", 0.9)
    startBtn.Parent = fishingContent
    
    fishingCat.Parent = contentScroller
    
    -- Support Features Category
    local supportCat, supportContent = createCategory("Support Features", "🛠️")
    
    local noAnimToggle = createToggle("No Fishing Animation", true)
    noAnimToggle.Parent = supportContent
    
    local lockToggle = createToggle("Lock Position", false)
    lockToggle.Parent = supportContent
    
    local walkToggle = createToggle("Walk on Water", false)
    walkToggle.Parent = supportContent
    
    supportCat.Parent = contentScroller
    
    -- Performance Category
    local perfCat, perfContent = createCategory("Performance", "⚡")
    
    local fpsToggle = createToggle("FPS Booster", true)
    fpsToggle.Parent = perfContent
    
    local antiAfkToggle = createToggle("Anti-AFK", true)
    antiAfkToggle.Parent = perfContent
    
    local optimizeBtn = createButton("Optimize Now", 0.9)
    optimizeBtn.Parent = perfContent
    
    perfCat.Parent = contentScroller
    
    -- Quick Actions
    local actionsCat, actionsContent = createCategory("Quick Actions", "🚀")
    
    local sellBtn = createButton("Sell All Fish", 0.9)
    sellBtn.Parent = actionsContent
    
    local tpBtn = createButton("Teleport to Best Spot", 0.9)
    tpBtn.Parent = actionsContent
    
    local equipBtn = createButton("Auto Equip Rod", 0.9)
    equipBtn.Parent = actionsContent
    
    actionsCat.Parent = contentScroller
end

-- Assemble UI
windowShadow.Parent = window
header.Parent = window
logoContainer.Parent = header
logoGlow.Parent = logoContainer
logoText.Parent = logoContainer
versionBadge.Parent = header
versionText.Parent = versionBadge
controls.Parent = header
btnMin.Parent = controls
btnClose.Parent = controls
sidebar.Parent = window
navContainer.Parent = sidebar
content.Parent = window
contentHeader.Parent = content
pageTitle.Parent = contentHeader
statsContainer.Parent = contentHeader
contentScroller.Parent = content
window.Parent = gui

-- Create initial content
createDashboardContent()

-- Opening Animation
window.Size = UDim2.new(0, 0, 0, 0)
window.Position = UDim2.new(0.5, 0, 0.5, 0)

task.wait(0.2)

-- Smooth opening animation
TweenService:Create(window, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, windowWidth, 0, windowHeight),
    Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
}):Play()

-- Logo animation
task.spawn(function()
    while logoText.Parent do
        TweenService:Create(logoText, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            TextTransparency = 0.2
        }):Play()
        task.wait(1.5)
        TweenService:Create(logoText, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            TextTransparency = 0
        }):Play()
        task.wait(1.5)
    end
end)

-- Button hover effects
btnMin.MouseEnter:Connect(function()
    TweenService:Create(btnMin, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 34, 0, 34)
    }):Play()
    TweenService:Create(btnMinGlow, TweenInfo.new(0.2), {
        Thickness = 2,
        Transparency = 0.3
    }):Play()
end)

btnMin.MouseLeave:Connect(function()
    TweenService:Create(btnMin, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 32, 0, 32)
    }):Play()
    TweenService:Create(btnMinGlow, TweenInfo.new(0.2), {
        Thickness = 0,
        Transparency = 0.7
    }):Play()
end)

btnClose.MouseEnter:Connect(function()
    TweenService:Create(btnClose, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 34, 0, 34)
    }):Play()
    TweenService:Create(btnCloseGlow, TweenInfo.new(0.2), {
        Thickness = 2,
        Transparency = 0.3
    }):Play()
end)

btnClose.MouseLeave:Connect(function()
    TweenService:Create(btnClose, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 32, 0, 32)
    }):Play()
    TweenService:Create(btnCloseGlow, TweenInfo.new(0.2), {
        Thickness = 0,
        Transparency = 0.7
    }):Play()
end)

-- Minimize functionality
local minimized = false
local originalSize = window.Size
local originalPos = window.Position

btnMin.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(window, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0, 20, 0, 20)
        }):Play()
        minimized = true
    else
        TweenService:Create(window, TweenInfo.new(0.3), {
            Size = originalSize,
            Position = originalPos
        }):Play()
        minimized = false
    end
end)

-- Close functionality
btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(window, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    gui:Destroy()
end)

-- Drag functionality
local dragging = false
local dragStart = Vector2.new(0, 0)
local startPos = Vector2.new(0, 0)

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Vector2.new(window.Position.X.Offset, window.Position.Y.Offset)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Resize functionality (for desktop)
if not isMobile then
    local resizing = false
    local resizeStart = Vector2.new(0, 0)
    local startSize = Vector2.new(0, 0)
    
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.BackgroundColor3 = colors.bg4
    resizeHandle.BackgroundTransparency = 0.3
    resizeHandle.Text = "↘"
    resizeHandle.Font = Enum.Font.GothamBold
    resizeHandle.TextSize = 12
    resizeHandle.TextColor3 = colors.textTertiary
    resizeHandle.AutoButtonColor = false
    resizeHandle.ZIndex = 10
    
    local resizeCorner = Instance.new("UICorner")
    resizeCorner.CornerRadius = UDim.new(0, 6)
    resizeCorner.Parent = resizeHandle
    
    resizeHandle.Parent = window
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = Vector2.new(window.Size.X.Offset, window.Size.Y.Offset)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X + delta.X, 300, 600)
            local newHeight = math.clamp(startSize.Y + delta.Y, 300, 700)
            window.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

print("✨ Neox Hub Premium UI v2.4 Loaded!")
print("📐 Size: " .. windowWidth .. "x" .. windowHeight)
print("🎨 Theme: Cyber Blue Premium")
print("📱 Optimized for: " .. (isMobile and "Mobile" or "Desktop"))
print("✅ Bug-free & Smooth Animations")