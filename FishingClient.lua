-- 🎣 FISH IT! HACKS - PROPERLY CENTERED UI
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

-- Semi-transparent background overlay
local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BackgroundTransparency = 0.5
background.BorderSizePixel = 0
background.Parent = screenGui

-- Main Container - Centered with proper dimensions
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 500, 0, 600)
mainContainer.Position = UDim2.new(0.5, -250, 0.5, -300) -- Center of screen
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5) -- Pivot from center
mainContainer.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
mainContainer.BackgroundTransparency = 0.1
mainContainer.BorderSizePixel = 0

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

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 FISH IT! HACKS"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, -100, 0, 20)
subtitle.Position = UDim2.new(0, 20, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Professional Fishing Assistant"
subtitle.TextColor3 = Color3.fromRGB(180, 220, 255)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextTransparency = 0.3

-- Close Button
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -20, 0.5, -20)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
closeButton.BackgroundTransparency = 0.3
closeButton.Image = "rbxassetid://3926305904"
closeButton.ImageRectOffset = Vector2.new(284, 4)
closeButton.ImageRectSize = Vector2.new(24, 24)
closeButton.ImageColor3 = Color3.fromRGB(200, 220, 255)

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Scrollable Content Area
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -40, 1, -90) -- Leaves room for header
content.Position = UDim2.new(0, 20, 0, 80) -- Starts below header
content.BackgroundTransparency = 1
content.ScrollBarThickness = 6
content.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 220)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.BorderSizePixel = 0

-- Main Features Container
local featuresContainer = Instance.new("Frame")
featuresContainer.Name = "FeaturesContainer"
featuresContainer.Size = UDim2.new(1, 0, 0, 450) -- Fixed height
featuresContainer.BackgroundTransparency = 1
featuresContainer.Position = UDim2.new(0, 0, 0, 0)

-- Main Features Title
local mainTitle = Instance.new("TextLabel")
mainTitle.Name = "MainTitle"
mainTitle.Size = UDim2.new(1, 0, 0, 40)
mainTitle.Position = UDim2.new(0, 0, 0, 0)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "⚡ MAIN FEATURES"
mainTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
mainTitle.TextSize = 20
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Feature Toggle Function
local function createFeatureToggle(featureName, description, icon, color, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = featureName .. "Frame"
    toggleFrame.Size = UDim2.new(1, 0, 0, 70)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPosition)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 70)
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = toggleFrame
    
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
    
    -- Toggle Switch
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "ToggleContainer"
    toggleContainer.Size = UDim2.new(0.3, 0, 1, 0)
    toggleContainer.Position = UDim2.new(0.7, 0, 0, 0)
    toggleContainer.BackgroundTransparency = 1
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 70, 0, 36)
    toggleButton.Position = UDim2.new(1, -15, 0.5, -18)
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
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
    
    local toggleStatus = Instance.new("TextLabel")
    toggleStatus.Name = "ToggleStatus"
    toggleStatus.Size = UDim2.new(1, 0, 0, 15)
    toggleStatus.Position = UDim2.new(0, 0, 1, 5)
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
    toggleFrame.Parent = featuresContainer
    
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

-- Create Main Features
local mainFeatures = {}
local featureData = {
    {
        name = "AUTO FISHING",
        desc = "Automatically catch fish",
        icon = "🤖",
        color = Color3.fromRGB(0, 200, 255),
        yPos = 50
    },
    {
        name = "BLATANT FISHING", 
        desc = "Catch through obstacles",
        icon = "⚡",
        color = Color3.fromRGB(255, 170, 0),
        yPos = 130
    },
    {
        name = "INSTANT FISHING",
        desc = "No waiting time",
        icon = "🚀",
        color = Color3.fromRGB(0, 230, 118),
        yPos = 210
    },
    {
        name = "NO ANIMATION",
        desc = "Skip fishing animations",
        icon = "🎬",
        color = Color3.fromRGB(170, 0, 255),
        yPos = 290
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
settingsSection.Size = UDim2.new(1, 0, 0, 150)
settingsSection.Position = UDim2.new(0, 0, 0, 380)
settingsSection.BackgroundTransparency = 1

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Name = "SettingsTitle"
settingsTitle.Size = UDim2.new(1, 0, 0, 40)
settingsTitle.Position = UDim2.new(0, 0, 0, 0)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "⚙️ SETTINGS"
settingsTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
settingsTitle.TextSize = 20
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Catch Delay Setting
local delayFrame = Instance.new("Frame")
delayFrame.Name = "DelayFrame"
delayFrame.Size = UDim2.new(1, 0, 0, 70)
delayFrame.Position = UDim2.new(0, 0, 0, 50)
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
delaySlider.Position = UDim2.new(1, -15, 0.5, -10)
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

-- Assemble all UI elements
mainTitle.Parent = featuresContainer
featuresContainer.Parent = content

settingsTitle.Parent = settingsSection

delayFill.Parent = delaySlider
delayHandle.Parent = delaySlider
delayValue.Parent = delayInfo
delayTitle.Parent = delayInfo
delayInfo.Parent = delayFrame
delayIcon.Parent = delayFrame
delaySlider.Parent = delayFrame
delayFrame.Parent = settingsSection

settingsSection.Parent = content

subtitle.Parent = header
title.Parent = header
closeButton.Parent = header
header.Parent = mainContainer
content.Parent = mainContainer
mainContainer.Parent = screenGui
screenGui.Parent = playerGui

-- Status update function
local function updateStatus(message)
    print("🎣 " .. message)
end

-- Toggle animation function
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
        toggleData.icon.TextColor3 = Color3.fromRGB(toggleData.color.R * 1.5, toggleData.color.G * 1.5, toggleData.color.B * 1.5)
        
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
        toggleData.icon.TextColor3 = toggleData.color
    end
end

-- Setup main feature toggles
for featureName, toggleData in pairs(mainFeatures) do
    toggleData.button.MouseButton1Click:Connect(function()
        toggleData.enabled = not toggleData.enabled
        animateToggle(toggleData, toggleData.enabled)
        
        -- Send to server
        fishingRemote:FireServer("ToggleFeature", {
            Feature = featureName,
            Enabled = toggleData.enabled
        })
        
        updateStatus(featureName .. " " .. (toggleData.enabled and "ENABLED 🎣" or "disabled"))
    end)
end

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

-- Toggle UI function
local function toggleUI()
    if screenGui.Enabled then
        -- Close animation
        TweenService:Create(mainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        TweenService:Create(background, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.3)
        screenGui.Enabled = false
    else
        -- Open animation
        screenGui.Enabled = true
        
        -- Reset size for animation
        mainContainer.Size = UDim2.new(0, 0, 0, 0)
        background.BackgroundTransparency = 1
        
        TweenService:Create(background, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.5
        }):Play()
        
        TweenService:Create(mainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 600)
        }):Play()
        
        updateStatus("Fishing Hacks Ready! Toggle features to begin.")
    end
end

-- Close button
closeButton.MouseButton1Click:Connect(function()
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

print("🎣 Fishing Hack UI loaded!")
print("📏 UI Position: Centered at (50%, 50%)")
print("🎮 Press F6 to open/close the UI")
