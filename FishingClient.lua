-- 🎣 FISH IT! HACKS - PROFESSIONAL UI
-- fishing_hack_ui.lua - Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create RemoteEvents
if not ReplicatedStorage:FindFirstChild("FishingHack") then
    Instance.new("RemoteEvent", ReplicatedStorage).Name = "FishingHack"
end

local fishingRemote = ReplicatedStorage:WaitForChild("FishingHack")

-- Create main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishingHackUI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.Enabled = false

-- Background Overlay
local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.7
overlay.BorderSizePixel = 0
overlay.Parent = screenGui

-- Main Container - Centered with elegant design
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 500, 0, 600)
mainContainer.Position = UDim2.new(0.5, -250, 0.5, -300)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
mainContainer.BackgroundTransparency = 0.05
mainContainer.BorderSizePixel = 0

-- Glass effect
local glassEffect = Instance.new("Frame")
glassEffect.Name = "GlassEffect"
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassEffect.BackgroundTransparency = 0.95
glassEffect.BorderSizePixel = 0

-- Container styling
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 16)
containerCorner.Parent = mainContainer

local containerStroke = Instance.new("UIStroke")
containerStroke.Name = "ContainerStroke"
containerStroke.Color = Color3.fromRGB(40, 120, 220)
containerStroke.Thickness = 2
containerStroke.Transparency = 0.3
containerStroke.Parent = mainContainer

-- Drop shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23, 23, 277, 277)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0.5, -20, 0.5, -20)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1

-- Header with gradient
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = Color3.fromRGB(15, 25, 50)
header.BorderSizePixel = 0

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 40, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 40))
})
headerGradient.Rotation = 90
headerGradient.Parent = header

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- Header content
local titleContainer = Instance.new("Frame")
titleContainer.Name = "TitleContainer"
titleContainer.Size = UDim2.new(1, -120, 1, 0)
titleContainer.Position = UDim2.new(0, 20, 0, 0)
titleContainer.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "🎣 FISH IT! HACKS"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0.8
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Professional Fishing Assistant"
subtitle.TextColor3 = Color3.fromRGB(180, 220, 255)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextTransparency = 0.3

-- Close button (elegant X)
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0.5, -20)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 50, 90)
closeButton.BackgroundTransparency = 0.3
closeButton.Image = "rbxassetid://3926305904"
closeButton.ImageRectOffset = Vector2.new(284, 4)
closeButton.ImageRectSize = Vector2.new(24, 24)
closeButton.ImageColor3 = Color3.fromRGB(200, 220, 255)

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

local closeGlow = Instance.new("UIStroke")
closeGlow.Color = Color3.fromRGB(100, 180, 255)
closeGlow.Thickness = 2
closeGlow.Transparency = 0.7
closeGlow.Parent = closeButton

-- Content Area
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -40, 1, -100)
content.Position = UDim2.new(0, 20, 0, 90)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 6
content.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 220)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.ScrollingDirection = Enum.ScrollingDirection.Y

-- Main Features Section
local mainSection = Instance.new("Frame")
mainSection.Name = "MainSection"
mainSection.Size = UDim2.new(1, 0, 0, 280)
mainSection.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
mainSection.BackgroundTransparency = 0.1
mainSection.BorderSizePixel = 0

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainSection

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 80, 160)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.5
mainStroke.Parent = mainSection

local mainTitle = Instance.new("TextLabel")
mainTitle.Name = "MainTitle"
mainTitle.Size = UDim2.new(1, -20, 0, 40)
mainTitle.Position = UDim2.new(0, 15, 0, 10)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "⚡ MAIN FEATURES"
mainTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
mainTitle.TextSize = 20
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Feature Toggle Function (Improved Design)
local function createFeatureToggle(featureName, description, icon, color, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = featureName .. "Frame"
    toggleFrame.Size = UDim2.new(1, -30, 0, 70)
    toggleFrame.Position = UDim2.new(0, 15, 0, yPosition)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 70)
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = toggleFrame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(50, 100, 180)
    frameStroke.Thickness = 1
    frameStroke.Transparency = 0.5
    frameStroke.Parent = toggleFrame
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 15, 0.5, -20)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = color
    iconLabel.TextSize = 24
    iconLabel.Font = Enum.Font.GothamBold
    
    -- Feature Info
    local featureInfo = Instance.new("Frame")
    featureInfo.Name = "FeatureInfo"
    featureInfo.Size = UDim2.new(0.6, 0, 1, 0)
    featureInfo.Position = UDim2.new(0, 70, 0, 0)
    featureInfo.BackgroundTransparency = 1
    
    local featureNameLabel = Instance.new("TextLabel")
    featureNameLabel.Name = "FeatureName"
    featureNameLabel.Size = UDim2.new(1, 0, 0, 30)
    featureNameLabel.Position = UDim2.new(0, 0, 0, 10)
    featureNameLabel.BackgroundTransparency = 1
    featureNameLabel.Text = featureName
    featureNameLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
    featureNameLabel.TextSize = 16
    featureNameLabel.Font = Enum.Font.GothamSemibold
    featureNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local featureDescLabel = Instance.new("TextLabel")
    featureDescLabel.Name = "FeatureDesc"
    featureDescLabel.Size = UDim2.new(1, 0, 0, 30)
    featureDescLabel.Position = UDim2.new(0, 0, 0, 35)
    featureDescLabel.BackgroundTransparency = 1
    featureDescLabel.Text = description
    featureDescLabel.TextColor3 = Color3.fromRGB(180, 200, 230)
    featureDescLabel.TextSize = 12
    featureDescLabel.Font = Enum.Font.Gotham
    featureDescLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle Switch (Modern Design)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "ToggleContainer"
    toggleContainer.Size = UDim2.new(0.25, 0, 1, 0)
    toggleContainer.Position = UDim2.new(0.75, 0, 0, 0)
    toggleContainer.BackgroundTransparency = 1
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 70, 0, 36)
    toggleButton.Position = UDim2.new(1, -75, 0.5, -18)
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleButtonStroke = Instance.new("UIStroke")
    toggleButtonStroke.Color = Color3.fromRGB(80, 120, 200)
    toggleButtonStroke.Thickness = 2
    toggleButtonStroke.Transparency = 0.5
    toggleButtonStroke.Parent = toggleButton
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "ToggleKnob"
    toggleKnob.Size = UDim2.new(0, 28, 0, 28)
    toggleKnob.Position = UDim2.new(0, 4, 0.5, -14)
    toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    toggleKnob.BorderSizePixel = 0
    
    local toggleKnobCorner = Instance.new("UICorner")
    toggleKnobCorner.CornerRadius = UDim.new(1, 0)
    toggleKnobCorner.Parent = toggleKnob
    
    local toggleKnobGlow = Instance.new("UIStroke")
    toggleKnobGlow.Color = Color3.fromRGB(255, 180, 180)
    toggleKnobGlow.Thickness = 2
    toggleKnobGlow.Transparency = 0.7
    toggleKnobGlow.Parent = toggleKnob
    
    local toggleStatus = Instance.new("TextLabel")
    toggleStatus.Name = "ToggleStatus"
    toggleStatus.Size = UDim2.new(1, 0, 0, 15)
    toggleStatus.Position = UDim2.new(0, 0, 1, 8)
    toggleStatus.BackgroundTransparency = 1
    toggleStatus.Text = "OFF"
    toggleStatus.TextColor3 = Color3.fromRGB(255, 120, 120)
    toggleStatus.TextSize = 12
    toggleStatus.Font = Enum.Font.GothamBold
    toggleStatus.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Assemble
    featureDescLabel.Parent = featureInfo
    featureNameLabel.Parent = featureInfo
    featureInfo.Parent = toggleFrame
    
    toggleKnob.Parent = toggleButton
    toggleStatus.Parent = toggleButton
    toggleButton.Parent = toggleContainer
    toggleContainer.Parent = toggleFrame
    
    iconLabel.Parent = toggleFrame
    toggleFrame.Parent = mainSection
    
    return {
        frame = toggleFrame,
        button = toggleButton,
        knob = toggleKnob,
        status = toggleStatus,
        icon = iconLabel,
        enabled = false,
        color = color
    }
end

-- Create Main Features (Improved)
local mainFeatures = {}
local featureData = {
    {
        name = "AUTO FISHING",
        desc = "Automatically catch fish without interaction",
        icon = "🤖",
        color = Color3.fromRGB(0, 200, 255),
        yPos = 60
    },
    {
        name = "BLATANT FISHING", 
        desc = "Catch fish through obstacles and walls",
        icon = "⚡",
        color = Color3.fromRGB(255, 170, 0),
        yPos = 140
    },
    {
        name = "INSTANT FISHING",
        desc = "Instant catch - no waiting time",
        icon = "🚀",
        color = Color3.fromRGB(0, 230, 118),
        yPos = 220
    }
}

for i, feature in ipairs(featureData) do
    mainFeatures[feature.name] = createFeatureToggle(
        feature.name,
        feature.desc,
        feature.icon,
        feature.color,
        feature.yPos
    )
end

-- Settings Section
local settingsSection = Instance.new("Frame")
settingsSection.Name = "SettingsSection"
settingsSection.Size = UDim2.new(1, 0, 0, 200)
settingsSection.Position = UDim2.new(0, 0, 0, 300)
settingsSection.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
settingsSection.BackgroundTransparency = 0.1
settingsSection.BorderSizePixel = 0

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 12)
settingsCorner.Parent = settingsSection

local settingsStroke = Instance.new("UIStroke")
settingsStroke.Color = Color3.fromRGB(40, 80, 160)
settingsStroke.Thickness = 1
settingsStroke.Transparency = 0.5
settingsStroke.Parent = settingsSection

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Name = "SettingsTitle"
settingsTitle.Size = UDim2.new(1, -20, 0, 40)
settingsTitle.Position = UDim2.new(0, 15, 0, 10)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "⚙️ SETTINGS"
settingsTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
settingsTitle.TextSize = 20
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Catch Delay Setting
local delayFrame = Instance.new("Frame")
delayFrame.Name = "DelayFrame"
delayFrame.Size = UDim2.new(1, -30, 0, 70)
delayFrame.Position = UDim2.new(0, 15, 0, 50)
delayFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 70)
delayFrame.BackgroundTransparency = 0.2
delayFrame.BorderSizePixel = 0

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 8)
delayCorner.Parent = delayFrame

local delayIcon = Instance.new("TextLabel")
delayIcon.Name = "DelayIcon"
delayIcon.Size = UDim2.new(0, 40, 0, 40)
delayIcon.Position = UDim2.new(0, 15, 0.5, -20)
delayIcon.AnchorPoint = Vector2.new(0, 0.5)
delayIcon.BackgroundTransparency = 1
delayIcon.Text = "⏱️"
delayIcon.TextColor3 = Color3.fromRGB(100, 200, 255)
delayIcon.TextSize = 24
delayIcon.Font = Enum.Font.GothamBold

local delayInfo = Instance.new("Frame")
delayInfo.Name = "DelayInfo"
delayInfo.Size = UDim2.new(0.6, 0, 1, 0)
delayInfo.Position = UDim2.new(0, 70, 0, 0)
delayInfo.BackgroundTransparency = 1

local delayTitle = Instance.new("TextLabel")
delayTitle.Name = "DelayTitle"
delayTitle.Size = UDim2.new(1, 0, 0, 30)
delayTitle.Position = UDim2.new(0, 0, 0, 10)
delayTitle.BackgroundTransparency = 1
delayTitle.Text = "CATCH DELAY"
delayTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
delayTitle.TextSize = 16
delayTitle.Font = Enum.Font.GothamSemibold
delayTitle.TextXAlignment = Enum.TextXAlignment.Left

local delayValue = Instance.new("TextLabel")
delayValue.Name = "DelayValue"
delayValue.Size = UDim2.new(1, 0, 0, 30)
delayValue.Position = UDim2.new(0, 0, 0, 35)
delayValue.BackgroundTransparency = 1
delayValue.Text = "0.5 seconds"
delayValue.TextColor3 = Color3.fromRGB(180, 220, 255)
delayValue.TextSize = 14
delayValue.Font = Enum.Font.Gotham
delayValue.TextXAlignment = Enum.TextXAlignment.Left

-- Delay Slider
local delaySlider = Instance.new("Frame")
delaySlider.Name = "DelaySlider"
delaySlider.Size = UDim2.new(0, 100, 0, 20)
delaySlider.Position = UDim2.new(1, -110, 0.5, -10)
delaySlider.AnchorPoint = Vector2.new(1, 0.5)
delaySlider.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
delaySlider.BorderSizePixel = 0

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = delaySlider

local delayFill = Instance.new("Frame")
delayFill.Name = "DelayFill"
delayFill.Size = UDim2.new(0.5, 0, 1, 0)
delayFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
delayFill.BorderSizePixel = 0

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = delayFill

local delayHandle = Instance.new("Frame")
delayHandle.Name = "DelayHandle"
delayHandle.Size = UDim2.new(0, 24, 0, 24)
delayHandle.Position = UDim2.new(0.5, -12, 0.5, -12)
delayHandle.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
delayHandle.BorderSizePixel = 0

local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(1, 0)
handleCorner.Parent = delayHandle

local handleGlow = Instance.new("UIStroke")
handleGlow.Color = Color3.fromRGB(100, 180, 255)
handleGlow.Thickness = 2
handleGlow.Transparency = 0.5
handleGlow.Parent = delayHandle

-- No Animation Toggle
local noAnimFrame = Instance.new("Frame")
noAnimFrame.Name = "NoAnimFrame"
noAnimFrame.Size = UDim2.new(1, -30, 0, 70)
noAnimFrame.Position = UDim2.new(0, 15, 0, 130)
noAnimFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 70)
noAnimFrame.BackgroundTransparency = 0.2
noAnimFrame.BorderSizePixel = 0

local noAnimCorner = Instance.new("UICorner")
noAnimCorner.CornerRadius = UDim.new(0, 8)
noAnimCorner.Parent = noAnimFrame

local noAnimIcon = Instance.new("TextLabel")
noAnimIcon.Name = "NoAnimIcon"
noAnimIcon.Size = UDim2.new(0, 40, 0, 40)
noAnimIcon.Position = UDim2.new(0, 15, 0.5, -20)
noAnimIcon.AnchorPoint = Vector2.new(0, 0.5)
noAnimIcon.BackgroundTransparency = 1
noAnimIcon.Text = "🎬"
noAnimIcon.TextColor3 = Color3.fromRGB(170, 0, 255)
noAnimIcon.TextSize = 24
noAnimIcon.Font = Enum.Font.GothamBold

local noAnimInfo = Instance.new("Frame")
noAnimInfo.Name = "NoAnimInfo"
noAnimInfo.Size = UDim2.new(0.6, 0, 1, 0)
noAnimInfo.Position = UDim2.new(0, 70, 0, 0)
noAnimInfo.BackgroundTransparency = 1

local noAnimTitle = Instance.new("TextLabel")
noAnimTitle.Name = "NoAnimTitle"
noAnimTitle.Size = UDim2.new(1, 0, 0, 30)
noAnimTitle.Position = UDim2.new(0, 0, 0, 10)
noAnimTitle.BackgroundTransparency = 1
noAnimTitle.Text = "NO ANIMATION"
noAnimTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
noAnimTitle.TextSize = 16
noAnimTitle.Font = Enum.Font.GothamSemibold
noAnimTitle.TextXAlignment = Enum.TextXAlignment.Left

local noAnimDesc = Instance.new("TextLabel")
noAnimDesc.Name = "NoAnimDesc"
noAnimDesc.Size = UDim2.new(1, 0, 0, 30)
noAnimDesc.Position = UDim2.new(0, 0, 0, 35)
noAnimDesc.BackgroundTransparency = 1
noAnimDesc.Text = "Skip fishing animations"
noAnimDesc.TextColor3 = Color3.fromRGB(180, 200, 230)
noAnimDesc.TextSize = 12
noAnimDesc.Font = Enum.Font.Gotham
noAnimDesc.TextXAlignment = Enum.TextXAlignment.Left

-- No Animation Toggle
local noAnimToggle = Instance.new("TextButton")
noAnimToggle.Name = "NoAnimToggle"
noAnimToggle.Size = UDim2.new(0, 70, 0, 36)
noAnimToggle.Position = UDim2.new(1, -75, 0.5, -18)
noAnimToggle.AnchorPoint = Vector2.new(1, 0.5)
noAnimToggle.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
noAnimToggle.Text = ""
noAnimToggle.AutoButtonColor = false

local noAnimToggleCorner = Instance.new("UICorner")
noAnimToggleCorner.CornerRadius = UDim.new(1, 0)
noAnimToggleCorner.Parent = noAnimToggle

local noAnimToggleStroke = Instance.new("UIStroke")
noAnimToggleStroke.Color = Color3.fromRGB(80, 120, 200)
noAnimToggleStroke.Thickness = 2
noAnimToggleStroke.Transparency = 0.5
noAnimToggleStroke.Parent = noAnimToggle

local noAnimKnob = Instance.new("Frame")
noAnimKnob.Name = "NoAnimKnob"
noAnimKnob.Size = UDim2.new(0, 28, 0, 28)
noAnimKnob.Position = UDim2.new(0, 4, 0.5, -14)
noAnimKnob.AnchorPoint = Vector2.new(0, 0.5)
noAnimKnob.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
noAnimKnob.BorderSizePixel = 0

local noAnimKnobCorner = Instance.new("UICorner")
noAnimKnobCorner.CornerRadius = UDim.new(1, 0)
noAnimKnobCorner.Parent = noAnimKnob

local noAnimStatus = Instance.new("TextLabel")
noAnimStatus.Name = "NoAnimStatus"
noAnimStatus.Size = UDim2.new(1, 0, 0, 15)
noAnimStatus.Position = UDim2.new(0, 0, 1, 8)
noAnimStatus.BackgroundTransparency = 1
noAnimStatus.Text = "OFF"
noAnimStatus.TextColor3 = Color3.fromRGB(255, 120, 120)
noAnimStatus.TextSize = 12
noAnimStatus.Font = Enum.Font.GothamBold
noAnimStatus.TextXAlignment = Enum.TextXAlignment.Center

-- Status Panel
local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.new(1, 0, 0, 80)
statusPanel.Position = UDim2.new(0, 0, 0, 520)
statusPanel.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
statusPanel.BackgroundTransparency = 0.1
statusPanel.BorderSizePixel = 0

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 12)
statusCorner.Parent = statusPanel

local statusStroke = Instance.new("UIStroke")
statusStroke.Color = Color3.fromRGB(40, 80, 160)
statusStroke.Thickness = 1
statusStroke.Transparency = 0.5
statusStroke.Parent = statusPanel

local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, -20, 0, 30)
statusTitle.Position = UDim2.new(0, 15, 0, 10)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "📊 SYSTEM STATUS"
statusTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
statusTitle.TextSize = 18
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextXAlignment = Enum.TextXAlignment.Left

local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -30, 0, 40)
statusText.Position = UDim2.new(0, 15, 0, 40)
statusText.BackgroundTransparency = 1
statusText.Text = "Ready to fish! 🎣\nPress F6 to hide/show"
statusText.TextColor3 = Color3.fromRGB(180, 220, 255)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.TextWrapped = true

-- Assemble UI
glassEffect.Parent = mainContainer
shadow.Parent = mainContainer

subtitle.Parent = titleContainer
title.Parent = titleContainer
titleContainer.Parent = header
closeButton.Parent = header
header.Parent = mainContainer

mainTitle.Parent = mainSection
mainSection.Parent = content

settingsTitle.Parent = settingsSection

delayFill.Parent = delaySlider
delayHandle.Parent = delaySlider
delayValue.Parent = delayInfo
delayTitle.Parent = delayInfo
delayInfo.Parent = delayFrame
delayIcon.Parent = delayFrame
delaySlider.Parent = delayFrame
delayFrame.Parent = settingsSection

noAnimKnob.Parent = noAnimToggle
noAnimStatus.Parent = noAnimToggle
noAnimToggle.Parent = noAnimFrame
noAnimDesc.Parent = noAnimInfo
noAnimTitle.Parent = noAnimInfo
noAnimInfo.Parent = noAnimFrame
noAnimIcon.Parent = noAnimFrame
noAnimFrame.Parent = settingsSection

settingsSection.Parent = content

statusText.Parent = statusPanel
statusTitle.Parent = statusPanel
statusPanel.Parent = content

content.Parent = mainContainer
mainContainer.Parent = screenGui
screenGui.Parent = playerGui

-- Update status function
local function updateStatus(message)
    statusText.Text = message
end

-- Toggle animation with smooth effects
local function animateToggle(toggleData, enabled)
    if enabled then
        -- Move knob to right
        TweenService:Create(toggleData.knob, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(80, 255, 140),
            Position = UDim2.new(1, -32, 0.5, -14)
        }):Play()
        
        TweenService:Create(toggleData.button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(40, 100, 60)
        }):Play()
        
        toggleData.status.Text = "ON"
        toggleData.status.TextColor3 = Color3.fromRGB(80, 255, 140)
        
        -- Icon glow effect
        TweenService:Create(toggleData.icon, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = toggleData.color,
            TextSize = 26
        }):Play()
        
        task.wait(0.1)
        TweenService:Create(toggleData.icon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            TextSize = 24
        }):Play()
        
    else
        -- Move knob to left
        TweenService:Create(toggleData.knob, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Position = UDim2.new(0, 4, 0.5, -14)
        }):Play()
        
        TweenService:Create(toggleData.button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(60, 80, 120)
        }):Play()
        
        toggleData.status.Text = "OFF"
        toggleData.status.TextColor3 = Color3.fromRGB(255, 120, 120)
        
        -- Icon dim effect
        TweenService:Create(toggleData.icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(100, 100, 150)
        }):Play()
    end
    
    -- Button press animation
    TweenService:Create(toggleData.button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 66, 0, 34)
        }):Play()
        
    task.wait(0.1)
    
    TweenService:Create(toggleData.button, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 70, 0, 36)
        }):Play()
end

-- Setup main feature toggles
for featureName, toggleData in pairs(mainFeatures) do
    toggleData.button.MouseButton1Click:Connect(function()
        toggleData.enabled = not toggleData.enabled
        animateToggle(toggleData, toggleData.enabled)
        
        -- Prepare settings
        local settings = {
            AutoFish = false,
            BlantantFish = false,
            InstantFish = false,
            NoAnimation = false,
            CatchDelay = 0.5
        }
        
        -- Update specific feature
        if featureName == "AUTO FISHING" then
            settings.AutoFish = toggleData.enabled
        elseif featureName == "BLATANT FISHING" then
            settings.BlantantFish = toggleData.enabled
        elseif featureName == "INSTANT FISHING" then
            settings.InstantFish = toggleData.enabled
        end
        
        -- Send to server
        fishingRemote:FireServer("ToggleFeature", {
            Feature = featureName,
            Enabled = toggleData.enabled,
            Settings = settings
        })
        
        updateStatus(featureName .. " " .. (toggleData.enabled and "ENABLED 🎣" or "disabled"))
    end)
end

-- Setup no animation toggle
local noAnimEnabled = false
noAnimToggle.MouseButton1Click:Connect(function()
    noAnimEnabled = not noAnimEnabled
    
    -- Animate no animation toggle
    if noAnimEnabled then
        TweenService:Create(noAnimKnob, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(170, 0, 255),
            Position = UDim2.new(1, -32, 0.5, -14)
        }):Play()
        
        TweenService:Create(noAnimToggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(80, 40, 120)
        }):Play()
        
        noAnimStatus.Text = "ON"
        noAnimStatus.TextColor3 = Color3.fromRGB(170, 0, 255)
        
        -- Icon glow
        TweenService:Create(noAnimIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(200, 100, 255),
            TextSize = 26
        }):Play()
        
    else
        TweenService:Create(noAnimKnob, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Position = UDim2.new(0, 4, 0.5, -14)
        }):Play()
        
        TweenService:Create(noAnimToggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(60, 80, 120)
        }):Play()
        
        noAnimStatus.Text = "OFF"
        noAnimStatus.TextColor3 = Color3.fromRGB(255, 120, 120)
        
        -- Icon dim
        TweenService:Create(noAnimIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(170, 0, 255)
        }):Play()
    end
    
    -- Send to server
    fishingRemote:FireServer("ToggleFeature", {
        Feature = "NO ANIMATION",
        Enabled = noAnimEnabled,
        Settings = {NoAnimation = noAnimEnabled}
    })
    
    updateStatus("No Animation " .. (noAnimEnabled and "ENABLED 🎬" or "disabled"))
end)

-- Delay slider functionality
local catchDelay = 0.5
local isDraggingDelay = false

local function updateDelayValue(xPosition)
    local absoluteX = delaySlider.AbsolutePosition.X
    local absoluteWidth = delaySlider.AbsoluteSize.X
    local percent = math.clamp((xPosition - absoluteX) / absoluteWidth, 0, 1)
    
    catchDelay = math.floor((0.1 + (percent * 1.9)) * 10) / 10 -- Range: 0.1s to 2.0s
    delayValue.Text = string.format("%.1f seconds", catchDelay)
    delayFill.Size = UDim2.new(percent, 0, 1, 0)
    delayHandle.Position = UDim2.new(percent, -12, 0.5, -12)
    
    -- Update server
    fishingRemote:FireServer("UpdateSettings", {
        CatchDelay = catchDelay
    })
    
    updateStatus("Catch delay set to " .. catchDelay .. "s")
end

delaySlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingDelay = true
        updateDelayValue(input.Position.X)
    end
end)

delaySlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingDelay = false
    end
end)

delayHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingDelay = true
    end
end)

delayHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingDelay = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingDelay and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDelayValue(input.Position.X)
    end
end)

-- Toggle UI function with animations
local function toggleUI()
    screenGui.Enabled = not screenGui.Enabled
    
    if screenGui.Enabled then
        -- Fade in overlay
        overlay.BackgroundTransparency = 0.7
        TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.5
        }):Play()
        
        -- Scale in animation with bounce
        mainContainer.Size = UDim2.new(0, 0, 0, 0)
        mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        TweenService:Create(mainContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 600),
            Position = UDim2.new(0.5, -250, 0.5, -300)
        }):Play()
        
        updateStatus("🎣 Fishing Hacks Ready!\nToggle features to begin...")
        
    else
        -- Fade out overlay
        TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.7
        }):Play()
        
        -- Scale out animation
        TweenService:Create(mainContainer, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        task.wait(0.4)
        screenGui.Enabled = false
    end
end

-- Close button
closeButton.MouseButton1Click:Connect(function()
    -- Button press animation
    TweenService:Create(closeButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 36, 0, 36)
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(closeButton, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 40, 0, 40)
    }):Play()
    
    toggleUI()
end)

-- Keyboard shortcut (F6)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F6 then
        toggleUI()
    end
end)

-- Initialize all toggles to OFF
for _, toggleData in pairs(mainFeatures) do
    animateToggle(toggleData, false)
end

-- Initialize delay slider
updateDelayValue(delaySlider.AbsolutePosition.X + (delaySlider.AbsoluteSize.X * 0.5))

print("🎣 Professional Fishing Hack UI loaded! Press F6 to toggle.")
