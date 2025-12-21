-- NeoxHub Mobile UI - Compact & Responsive
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Check if mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Theme Colors (Cyber Neon Blue - Mobile Friendly)
local colors = {
    primary = Color3.fromRGB(0, 180, 255),       -- Bright Cyan
    secondary = Color3.fromRGB(0, 140, 220),     -- Medium Blue
    accent = Color3.fromRGB(0, 220, 255),        -- Pure Cyan
    success = Color3.fromRGB(0, 255, 150),       -- Mint Green
    warning = Color3.fromRGB(255, 200, 0),       -- Amber
    danger = Color3.fromRGB(255, 80, 100),       -- Pink Red
    
    bg1 = Color3.fromRGB(10, 10, 20),            -- Deep Space Blue
    bg2 = Color3.fromRGB(15, 15, 30),            -- Dark Blue
    bg3 = Color3.fromRGB(25, 25, 45),            -- Medium Blue
    bg4 = Color3.fromRGB(35, 35, 60),            -- Light Blue
    
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(200, 220, 255),
    textDimmer = Color3.fromRGB(150, 180, 220),
    
    border = Color3.fromRGB(0, 100, 180),
    glow = Color3.fromRGB(0, 150, 220),
}

-- Mobile optimized window size
local screenSize = workspace.CurrentCamera.ViewportSize
local windowWidth = math.min(480, screenSize.X * 0.9)  -- Max 380px atau 90% layar
local windowHeight = math.min(500, screenSize.Y * 0.8) -- Max 500px atau 80% layar

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NeoxHub_Mobile"
gui.Parent = localPlayer.PlayerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- Main Container
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, windowWidth, 0, windowHeight)
mainContainer.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
mainContainer.BackgroundColor3 = colors.bg1
mainContainer.BackgroundTransparency = 0.05
mainContainer.BorderSizePixel = 0
mainContainer.ClipsDescendants = true
mainContainer.ZIndex = 1

-- Glass Effect
local glassEffect = Instance.new("Frame")
glassEffect.Name = "GlassEffect"
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.BackgroundTransparency = 0.9
glassEffect.BorderSizePixel = 0
glassEffect.ZIndex = 2

-- Corner Rounding
local corner = Instance.new("UICorner")
corner.Parent = mainContainer
corner.CornerRadius = UDim.new(0, 16)

-- Outer Glow
local glowStroke = Instance.new("UIStroke")
glowStroke.Parent = mainContainer
glowStroke.Color = colors.primary
glowStroke.Thickness = 1.5
glowStroke.Transparency = 0.2

-- Compact Header (Mobile Optimized)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = colors.bg2
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.ZIndex = 10

-- Header Corner
local headerCorner = Instance.new("UICorner")
headerCorner.Parent = header
headerCorner.CornerRadius = UDim.new(0, 16)

-- Logo and Title (Compact)
local logoContainer = Instance.new("Frame")
logoContainer.Name = "LogoContainer"
logoContainer.Size = UDim2.new(0.6, 0, 1, 0)
logoContainer.Position = UDim2.new(0, 10, 0, 0)
logoContainer.BackgroundTransparency = 1
logoContainer.ZIndex = 11

-- Logo Text
local logoText = Instance.new("TextLabel")
logoText.Name = "LogoText"
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "NEOX HUB"
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 22
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
logoGlow.TextSize = 22
logoGlow.TextColor3 = colors.primary
logoGlow.TextTransparency = 0.6
logoGlow.ZIndex = 11

-- Version Badge
local versionBadge = Instance.new("Frame")
versionBadge.Name = "VersionBadge"
versionBadge.Size = UDim2.new(0, 60, 0, 22)
versionBadge.Position = UDim2.new(1, -70, 0.5, -11)
versionBadge.BackgroundColor3 = colors.primary
versionBadge.BackgroundTransparency = 0.2
versionBadge.BorderSizePixel = 0
versionBadge.ZIndex = 11

local versionCorner = Instance.new("UICorner")
versionCorner.Parent = versionBadge
versionCorner.CornerRadius = UDim.new(1, 0)

local versionText = Instance.new("TextLabel")
versionText.Name = "VersionText"
versionText.Size = UDim2.new(1, 0, 1, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v2.3"
versionText.Font = Enum.Font.GothamBold
versionText.TextSize = 11
versionText.TextColor3 = colors.text
versionText.ZIndex = 12

-- Control Buttons (Compact)
local controlButtons = Instance.new("Frame")
controlButtons.Name = "ControlButtons"
controlButtons.Size = UDim2.new(0, 80, 1, 0)
controlButtons.Position = UDim2.new(1, -90, 0, 0)
controlButtons.BackgroundTransparency = 1
controlButtons.ZIndex = 11

-- Minimize Button
local btnMinimize = Instance.new("TextButton")
btnMinimize.Name = "Minimize"
btnMinimize.Size = UDim2.new(0, 30, 0, 30)
btnMinimize.Position = UDim2.new(0, 5, 0.5, -15)
btnMinimize.BackgroundColor3 = colors.bg3
btnMinimize.BackgroundTransparency = 0.3
btnMinimize.Text = "─"
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.TextSize = 16
btnMinimize.TextColor3 = colors.text
btnMinimize.AutoButtonColor = false
btnMinimize.ZIndex = 12
Instance.new("UICorner", btnMinimize).CornerRadius = UDim.new(0, 6)

-- Close Button
local btnClose = Instance.new("TextButton")
btnClose.Name = "Close"
btnClose.Size = UDim2.new(0, 30, 0, 30)
btnClose.Position = UDim2.new(0, 40, 0.5, -15)
btnClose.BackgroundColor3 = colors.danger
btnClose.BackgroundTransparency = 0.3
btnClose.Text = "×"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 16
btnClose.TextColor3 = colors.text
btnClose.AutoButtonColor = false
btnClose.ZIndex = 12
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)

-- Navigation Tabs (Mobile Style - Horizontal)
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, 40)
tabContainer.Position = UDim2.new(0, 10, 0, 55)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 5

-- Tab Scroller (for many tabs)
local tabScroller = Instance.new("ScrollingFrame")
tabScroller.Name = "TabScroller"
tabScroller.Size = UDim2.new(1, 0, 1, 0)
tabScroller.BackgroundTransparency = 1
tabScroller.ScrollBarThickness = 2
tabScroller.ScrollBarImageColor3 = colors.primary
tabScroller.BorderSizePixel = 0
tabScroller.AutomaticCanvasSize = Enum.AutomaticSize.X
tabScroller.ZIndex = 6

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabScroller
tabLayout.Padding = UDim.new(0, 8)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

-- Tabs Data
local tabs = {
    {name = "Main", icon = "🏠"},
    {name = "Fishing", icon = "🎣"},
    {name = "Teleport", icon = "🌍"},
    {name = "Quest", icon = "📜"},
    {name = "Shop", icon = "🛒"},
    {name = "Camera", icon = "📷"},
    {name = "Webhook", icon = "🔗"},
    {name = "Settings", icon = "⚙️"},
}

-- Create Tabs
for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.name .. "Tab"
    tabButton.Size = UDim2.new(0, 70, 1, 0)
    tabButton.BackgroundColor3 = colors.bg3
    tabButton.BackgroundTransparency = 0.4
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.ZIndex = 7
    
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)
    
    -- Tab Icon
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Name = "Icon"
    tabIcon.Size = UDim2.new(0, 24, 0, 24)
    tabIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = tab.icon
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.TextSize = 16
    tabIcon.TextColor3 = colors.textDim
    tabIcon.ZIndex = 8
    
    -- Tab Name (small)
    local tabName = Instance.new("TextLabel")
    tabName.Name = "Name"
    tabName.Size = UDim2.new(1, 0, 0, 12)
    tabName.Position = UDim2.new(0, 0, 1, -12)
    tabName.BackgroundTransparency = 1
    tabName.Text = tab.name
    tabName.Font = Enum.Font.GothamBold
    tabName.TextSize = 10
    tabName.TextColor3 = colors.textDimmer
    tabName.TextXAlignment = Enum.TextXAlignment.Center
    tabName.ZIndex = 8
    
    -- Active Indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 0, 0, 3)
    indicator.Position = UDim2.new(0.5, 0, 1, -3)
    indicator.BackgroundColor3 = colors.primary
    indicator.BorderSizePixel = 0
    indicator.Visible = i == 1
    indicator.ZIndex = 9
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    -- Hover Effects
    tabButton.MouseEnter:Connect(function()
        if not indicator.Visible then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.2
            }):Play()
            TweenService:Create(tabIcon, TweenInfo.new(0.2), {
                TextColor3 = colors.primary,
                TextTransparency = 0
            }):Play()
            TweenService:Create(tabName, TweenInfo.new(0.2), {
                TextColor3 = colors.text,
                TextTransparency = 0
            }):Play()
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if not indicator.Visible then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.4
            }):Play()
            TweenService:Create(tabIcon, TweenInfo.new(0.2), {
                TextColor3 = colors.textDim,
                TextTransparency = 0.2
            }):Play()
            TweenService:Create(tabName, TweenInfo.new(0.2), {
                TextColor3 = colors.textDimmer,
                TextTransparency = 0.3
            }):Play()
        end
    end)
    
    tabButton.Parent = tabScroller
end

-- Content Area (Main area for features)
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -20, 1, -120)
contentArea.Position = UDim2.new(0, 10, 0, 100)
contentArea.BackgroundColor3 = colors.bg3
contentArea.BackgroundTransparency = 0.1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.ZIndex = 4
Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 12)

-- Content Glow
local contentGlow = Instance.new("UIStroke")
contentGlow.Parent = contentArea
contentGlow.Color = colors.primary
contentGlow.Thickness = 1
contentGlow.Transparency = 0.3

-- Content Scroller
local contentScroller = Instance.new("ScrollingFrame")
contentScroller.Name = "ContentScroller"
contentScroller.Size = UDim2.new(1, -10, 1, -10)
contentScroller.Position = UDim2.new(0, 5, 0, 5)
contentScroller.BackgroundTransparency = 1
contentScroller.ScrollBarThickness = 3
contentScroller.ScrollBarImageColor3 = colors.primary
contentScroller.BorderSizePixel = 0
contentScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroller.ZIndex = 5

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentScroller
contentLayout.Padding = UDim.new(0, 8)

-- Function to Create Compact Category
function createCompactCategory(title, icon)
    local category = Instance.new("Frame")
    category.Name = title .. "Category"
    category.Size = UDim2.new(1, 0, 0, 40)
    category.BackgroundColor3 = colors.bg4
    category.BackgroundTransparency = 0.2
    category.BorderSizePixel = 0
    category.ZIndex = 6
    
    Instance.new("UICorner", category).CornerRadius = UDim.new(0, 10)
    
    -- Category Header
    local headerBtn = Instance.new("TextButton")
    headerBtn.Name = "Header"
    headerBtn.Size = UDim2.new(1, 0, 1, 0)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.AutoButtonColor = false
    headerBtn.ZIndex = 7
    
    -- Icon
    local catIcon = Instance.new("TextLabel")
    catIcon.Name = "Icon"
    catIcon.Size = UDim2.new(0, 30, 1, 0)
    catIcon.Position = UDim2.new(0, 8, 0, 0)
    catIcon.BackgroundTransparency = 1
    catIcon.Text = icon
    catIcon.Font = Enum.Font.GothamBold
    catIcon.TextSize = 18
    catIcon.TextColor3 = colors.primary
    catIcon.TextTransparency = 0.2
    catIcon.ZIndex = 8
    
    -- Title
    local catTitle = Instance.new("TextLabel")
    catTitle.Name = "Title"
    catTitle.Size = UDim2.new(1, -80, 1, 0)
    catTitle.Position = UDim2.new(0, 38, 0, 0)
    catTitle.BackgroundTransparency = 1
    catTitle.Text = title
    catTitle.Font = Enum.Font.GothamBold
    catTitle.TextSize = 13
    catTitle.TextColor3 = colors.text
    catTitle.TextXAlignment = Enum.TextXAlignment.Left
    catTitle.ZIndex = 8
    
    -- Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
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
    containerLayout.Padding = UDim.new(0, 6)
    
    local containerPadding = Instance.new("UIPadding")
    containerPadding.Parent = contentContainer
    containerPadding.PaddingBottom = UDim.new(0, 8)
    
    -- Toggle function
    local isOpen = false
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        contentContainer.Visible = isOpen
        TweenService:Create(arrow, TweenInfo.new(0.2), {
            Rotation = isOpen and 180 or 0
        }):Play()
        TweenService:Create(category, TweenInfo.new(0.2), {
            Size = isOpen and UDim2.new(1, 0, 0, 45 + contentContainer.AbsoluteContentSize.Y) 
                   or UDim2.new(1, 0, 0, 40)
        }):Play()
    end)
    
    -- Hover effect
    headerBtn.MouseEnter:Connect(function()
        TweenService:Create(category, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1
        }):Play()
        TweenService:Create(catIcon, TweenInfo.new(0.2), {
            TextTransparency = 0
        }):Play()
        TweenService:Create(catTitle, TweenInfo.new(0.2), {
            TextTransparency = 0
        }):Play()
    end)
    
    headerBtn.MouseLeave:Connect(function()
        TweenService:Create(category, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(catIcon, TweenInfo.new(0.2), {
            TextTransparency = 0.2
        }):Play()
        TweenService:Create(catTitle, TweenInfo.new(0.2), {
            TextTransparency = 0
        }):Play()
    end)
    
    return category, contentContainer
end

-- Function to Create Toggle Switch
function createToggle(label)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = label .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.ZIndex = 7
    
    -- Label
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = label
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.TextSize = 12
    toggleLabel.TextColor3 = colors.text
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.ZIndex = 8
    
    -- Toggle Switch
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "Switch"
    toggleSwitch.Size = UDim2.new(0, 50, 0, 25)
    toggleSwitch.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleSwitch.BackgroundColor3 = colors.bg4
    toggleSwitch.BackgroundTransparency = 0.3
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.ZIndex = 8
    Instance.new("UICorner", toggleSwitch).CornerRadius = UDim.new(1, 0)
    
    -- Toggle Circle
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10.5)
    toggleCircle.BackgroundColor3 = colors.textDim
    toggleCircle.BorderSizePixel = 0
    toggleCircle.ZIndex = 9
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
    
    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Button"
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 10
    
    local isOn = false
    
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.primary
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -23, 0.5, -10.5),
                BackgroundColor3 = colors.text
            }):Play()
        else
            TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {
                BackgroundColor3 = colors.bg4
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -10.5),
                BackgroundColor3 = colors.textDim
            }):Play()
        end
        return isOn
    end)
    
    toggleBtn.Parent = toggleSwitch
    return toggleFrame, toggleBtn
end

-- Function to Create Button
function createButton(label, widthPercent)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = label .. "Button"
    buttonFrame.Size = UDim2.new(widthPercent or 1, 0, 0, 32)
    buttonFrame.BackgroundColor3 = colors.primary
    buttonFrame.BackgroundTransparency = 0.3
    buttonFrame.BorderSizePixel = 0
    buttonFrame.ZIndex = 7
    Instance.new("UICorner", buttonFrame).CornerRadius = UDim.new(0, 8)
    
    -- Button Glow
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
    
    -- Hover effect
    buttonText.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(widthPercent or 1, 3, 0, 35)
        }):Play()
        TweenService:Create(buttonGlow, TweenInfo.new(0.2), {
            Thickness = 2
        }):Play()
    end)
    
    buttonText.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(widthPercent or 1, 0, 0, 32)
        }):Play()
        TweenService:Create(buttonGlow, TweenInfo.new(0.2), {
            Thickness = 0
        }):Play()
    end)
    
    -- Click effect
    buttonText.MouseButton1Down:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            Size = UDim2.new((widthPercent or 1) - 0.02, 0, 0, 30)
        }):Play()
    end)
    
    buttonText.MouseButton1Up:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            Size = UDim2.new(widthPercent or 1, 3, 0, 35)
        }):Play()
    end)
    
    return buttonFrame, buttonText
end

-- Function to Create Input Field
function createInput(label, placeholder)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = label .. "Input"
    inputFrame.Size = UDim2.new(1, 0, 0, 50)
    inputFrame.BackgroundTransparency = 1
    inputFrame.ZIndex = 7
    
    -- Label
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Name = "Label"
    inputLabel.Size = UDim2.new(1, 0, 0, 18)
    inputLabel.Position = UDim2.new(0, 0, 0, 0)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = label
    inputLabel.Font = Enum.Font.GothamBold
    inputLabel.TextSize = 11
    inputLabel.TextColor3 = colors.textDim
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    inputLabel.ZIndex = 8
    
    -- Input Box
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "Input"
    inputBox.Size = UDim2.new(1, 0, 0, 28)
    inputBox.Position = UDim2.new(0, 0, 0, 22)
    inputBox.BackgroundColor3 = colors.bg4
    inputBox.BackgroundTransparency = 0.3
    inputBox.BorderSizePixel = 0
    inputBox.Text = ""
    inputBox.PlaceholderText = placeholder or "Enter value..."
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 12
    inputBox.TextColor3 = colors.text
    inputBox.PlaceholderColor3 = colors.textDimmer
    inputBox.ClearTextOnFocus = false
    inputBox.ZIndex = 8
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)
    
    -- Input Glow
    local inputGlow = Instance.new("UIStroke")
    inputGlow.Parent = inputBox
    inputGlow.Color = colors.border
    inputGlow.Thickness = 1
    inputGlow.Transparency = 0.5
    
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
            Transparency = 0.5
        }):Play()
    end)
    
    return inputFrame, inputBox
end

-- Create Sample Features for Main Tab
local function createMainTabContent()
    -- Clear existing content
    for _, child in ipairs(contentScroller:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Auto Fishing Category
    local fishingCategory, fishingContent = createCompactCategory("Auto Fishing", "🎣")
    
    local instantToggle, instantBtn = createToggle("Instant Fishing")
    instantToggle.Parent = fishingContent
    
    local speedInput, speedBox = createInput("Fishing Speed", "0.05")
    speedInput.Parent = fishingContent
    
    local startBtn, startText = createButton("Start Fishing")
    startBtn.Parent = fishingContent
    
    fishingCategory.Parent = contentScroller
    
    -- Support Features Category
    local supportCategory, supportContent = createCompactCategory("Support Features", "🛠️")
    
    local noAnimToggle, noAnimBtn = createToggle("No Fishing Animation")
    noAnimToggle.Parent = supportContent
    
    local lockToggle, lockBtn = createToggle("Lock Position")
    lockToggle.Parent = supportContent
    
    local walkToggle, walkBtn = createToggle("Walk on Water")
    walkToggle.Parent = supportContent
    
    supportCategory.Parent = contentScroller
    
    -- Skin Animation Category
    local skinCategory, skinContent = createCompactCategory("Skin Animation", "✨")
    
    local skinToggle, skinBtn = createToggle("Enable Skin FX")
    skinToggle.Parent = skinContent
    
    local katanaBtn, katanaText = createButton("Eclipse Katana", 0.9)
    katanaBtn.Parent = skinContent
    
    local tridentBtn, tridentText = createButton("Holy Trident", 0.9)
    tridentBtn.Parent = skinContent
    
    skinCategory.Parent = contentScroller
    
    -- Stats Display
    local statsCategory, statsContent = createCompactCategory("Stats", "📊")
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.Size = UDim2.new(1, 0, 0, 60)
    statsFrame.BackgroundTransparency = 1
    statsFrame.ZIndex = 7
    
    local statLabels = {
        {label = "FPS", value = "120", color = colors.success},
        {label = "PING", value = "30ms", color = colors.warning},
        {label = "FISH", value = "0", color = colors.primary}
    }
    
    for i, stat in ipairs(statLabels) do
        local statItem = Instance.new("Frame")
        statItem.Size = UDim2.new(0.32, 0, 1, 0)
        statItem.Position = UDim2.new((i-1) * 0.33, 0, 0, 0)
        statItem.BackgroundColor3 = colors.bg4
        statItem.BackgroundTransparency = 0.3
        statItem.BorderSizePixel = 0
        statItem.ZIndex = 8
        Instance.new("UICorner", statItem).CornerRadius = UDim.new(0, 8)
        
        local statLabel = Instance.new("TextLabel")
        statLabel.Size = UDim2.new(1, 0, 0, 20)
        statLabel.Position = UDim2.new(0, 0, 0, 5)
        statLabel.BackgroundTransparency = 1
        statLabel.Text = stat.label
        statLabel.Font = Enum.Font.GothamBold
        statLabel.TextSize = 11
        statLabel.TextColor3 = colors.textDim
        statLabel.ZIndex = 9
        
        local statValue = Instance.new("TextLabel")
        statValue.Size = UDim2.new(1, 0, 0, 25)
        statValue.Position = UDim2.new(0, 0, 0, 25)
        statValue.BackgroundTransparency = 1
        statValue.Text = stat.value
        statValue.Font = Enum.Font.GothamBlack
        statValue.TextSize = 16
        statValue.TextColor3 = stat.color
        statValue.ZIndex = 9
        
        statItem.Parent = statsFrame
        statLabel.Parent = statItem
        statValue.Parent = statItem
    end
    
    statsFrame.Parent = statsContent
    statsCategory.Parent = contentScroller
end

-- Parent all elements
glassEffect.Parent = mainContainer
header.Parent = mainContainer
logoContainer.Parent = header
logoGlow.Parent = logoContainer
logoText.Parent = logoContainer
versionBadge.Parent = header
versionText.Parent = versionBadge
controlButtons.Parent = header
btnMinimize.Parent = controlButtons
btnClose.Parent = controlButtons
tabContainer.Parent = mainContainer
tabScroller.Parent = tabContainer
contentArea.Parent = mainContainer
contentScroller.Parent = contentArea
mainContainer.Parent = gui

-- Create initial content
createMainTabContent()

-- Opening Animation
mainContainer.Size = UDim2.new(0, 0, 0, 0)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)

task.wait(0.1)

TweenService:Create(mainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, windowWidth, 0, windowHeight),
    Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
}):Play()

-- Logo Animation
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

-- Minimize function
local minimized = false
btnMinimize.MouseButton1Click:Connect(function()
    if not minimized then
        TweenService:Create(mainContainer, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0, 20, 0, 20)
        }):Play()
        minimized = true
    else
        TweenService:Create(mainContainer, TweenInfo.new(0.3), {
            Size = UDim2.new(0, windowWidth, 0, windowHeight),
            Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
        }):Play()
        minimized = false
    end
end)

-- Close function
btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(mainContainer, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    gui:Destroy()
end)

print("📱 Neox Hub Mobile UI Loaded!")
print("📐 Size: " .. windowWidth .. "x" .. windowHeight .. " pixels")
print("🎯 Optimized for Mobile/Tablet")
print("📱 Touch-friendly design")