-- 🎣 FISH IT! HACKS - COMPLETE MOBILE UI
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
screenGui.Enabled = true

-- Main Container - Centered untuk Mobile
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0.85, 0, 0.8, 0)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
mainContainer.BackgroundTransparency = 0.1
mainContainer.BorderSizePixel = 0

-- Container styling
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 16)
containerCorner.Parent = mainContainer

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = Color3.fromRGB(40, 120, 220)
containerStroke.Thickness = 3
containerStroke.Transparency = 0.3
containerStroke.Parent = mainContainer

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 FISH IT! HACKS"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 60, 0, 60)
closeButton.Position = UDim2.new(1, -70, 0.5, -30)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Content Area
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -100)
content.Position = UDim2.new(0, 10, 0, 90)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 8
content.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 220)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.BorderSizePixel = 0

-- Main Features Title
local mainTitle = Instance.new("TextLabel")
mainTitle.Name = "MainTitle"
mainTitle.Size = UDim2.new(1, 0, 0, 40)
mainTitle.Position = UDim2.new(0, 0, 0, 0)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "⚡ FITUR UTAMA"
mainTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
mainTitle.TextSize = 22
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Feature Toggle Function
local function createFeatureToggle(featureName, description, icon, color, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = featureName .. "Frame"
    toggleFrame.Size = UDim2.new(1, 0, 0, 80)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPosition)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 70)
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = toggleFrame
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 50, 0, 50)
    iconLabel.Position = UDim2.new(0, 15, 0.5, -25)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = color
    iconLabel.TextSize = 30
    iconLabel.Font = Enum.Font.GothamBold
    
    -- Feature Info
    local featureInfo = Instance.new("Frame")
    featureInfo.Name = "FeatureInfo"
    featureInfo.Size = UDim2.new(0.5, 0, 1, 0)
    featureInfo.Position = UDim2.new(0, 80, 0, 0)
    featureInfo.BackgroundTransparency = 1
    
    local featureNameLabel = Instance.new("TextLabel")
    featureNameLabel.Name = "FeatureName"
    featureNameLabel.Size = UDim2.new(1, 0, 0, 35)
    featureNameLabel.Position = UDim2.new(0, 0, 0, 10)
    featureNameLabel.BackgroundTransparency = 1
    featureNameLabel.Text = featureName
    featureNameLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
    featureNameLabel.TextSize = 18
    featureNameLabel.Font = Enum.Font.GothamSemibold
    featureNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local featureDescLabel = Instance.new("TextLabel")
    featureDescLabel.Name = "FeatureDesc"
    featureDescLabel.Size = UDim2.new(1, 0, 0, 30)
    featureDescLabel.Position = UDim2.new(0, 0, 0, 45)
    featureDescLabel.BackgroundTransparency = 1
    featureDescLabel.Text = description
    featureDescLabel.TextColor3 = Color3.fromRGB(180, 200, 230)
    featureDescLabel.TextSize = 14
    featureDescLabel.Font = Enum.Font.Gotham
    featureDescLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle Switch
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 80, 0, 40)
    toggleButton.Position = UDim2.new(1, -20, 0.5, -20)
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "ToggleKnob"
    toggleKnob.Size = UDim2.new(0, 34, 0, 34)
    toggleKnob.Position = UDim2.new(0, 3, 0.5, -17)
    toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    toggleKnob.BorderSizePixel = 0
    
    local toggleKnobCorner = Instance.new("UICorner")
    toggleKnobCorner.CornerRadius = UDim.new(1, 0)
    toggleKnobCorner.Parent = toggleKnob
    
    local toggleStatus = Instance.new("TextLabel")
    toggleStatus.Name = "ToggleStatus"
    toggleStatus.Size = UDim2.new(1, 0, 0, 20)
    toggleStatus.Position = UDim2.new(0, 0, 1, 5)
    toggleStatus.BackgroundTransparency = 1
    toggleStatus.Text = "OFF"
    toggleStatus.TextColor3 = Color3.fromRGB(255, 120, 120)
    toggleStatus.TextSize = 14
    toggleStatus.Font = Enum.Font.GothamBold
    toggleStatus.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Assemble
    featureDescLabel.Parent = featureInfo
    featureNameLabel.Parent = featureInfo
    featureInfo.Parent = toggleFrame
    
    toggleKnob.Parent = toggleButton
    toggleStatus.Parent = toggleButton
    toggleButton.Parent = toggleFrame
    
    iconLabel.Parent = toggleFrame
    
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
        desc = "Tangkap ikan otomatis",
        icon = "🤖",
        color = Color3.fromRGB(0, 200, 255),
        yPos = 50
    },
    {
        name = "BLATANT FISHING", 
        desc = "Tangkap melalui rintangan",
        icon = "⚡",
        color = Color3.fromRGB(255, 170, 0),
        yPos = 140
    },
    {
        name = "INSTANT FISHING",
        desc = "Tidak perlu menunggu",
        icon = "🚀",
        color = Color3.fromRGB(0, 230, 118),
        yPos = 230
    },
    {
        name = "NO ANIMATION",
        desc = "Pancingan diam tapi jalan",
        icon = "🎬",
        color = Color3.fromRGB(170, 0, 255),
        yPos = 320
    }
}

-- Add features to a container
local featuresContainer = Instance.new("Frame")
featuresContainer.Name = "FeaturesContainer"
featuresContainer.Size = UDim2.new(1, 0, 0, 420)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Position = UDim2.new(0, 0, 0, 40)

for i, feature in ipairs(featureData) do
    mainFeatures[feature.name] = createFeatureToggle(
        feature.name,
        feature.desc,
        feature.icon,
        feature.color,
        feature.yPos
    )
    mainFeatures[feature.name].frame.Parent = featuresContainer
end

-- Settings Section
local settingsSection = Instance.new("Frame")
settingsSection.Name = "SettingsSection"
settingsSection.Size = UDim2.new(1, 0, 0, 120)
settingsSection.Position = UDim2.new(0, 0, 0, 470)
settingsSection.BackgroundTransparency = 1

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Name = "SettingsTitle"
settingsTitle.Size = UDim2.new(1, 0, 0, 40)
settingsTitle.Position = UDim2.new(0, 0, 0, 0)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "⚙️ PENGATURAN"
settingsTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
settingsTitle.TextSize = 22
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Catch Delay Setting
local delayFrame = Instance.new("Frame")
delayFrame.Name = "DelayFrame"
delayFrame.Size = UDim2.new(1, 0, 0, 80)
delayFrame.Position = UDim2.new(0, 0, 0, 40)
delayFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 70)
delayFrame.BackgroundTransparency = 0.2
delayFrame.BorderSizePixel = 0

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 12)
delayCorner.Parent = delayFrame

local delayIcon = Instance.new("TextLabel")
delayIcon.Name = "DelayIcon"
delayIcon.Size = UDim2.new(0, 50, 0, 50)
delayIcon.Position = UDim2.new(0, 15, 0.5, -25)
delayIcon.AnchorPoint = Vector2.new(0, 0.5)
delayIcon.BackgroundTransparency = 1
delayIcon.Text = "⏱️"
delayIcon.TextColor3 = Color3.fromRGB(100, 200, 255)
delayIcon.TextSize = 30
delayIcon.Font = Enum.Font.GothamBold

local delayInfo = Instance.new("Frame")
delayInfo.Name = "DelayInfo"
delayInfo.Size = UDim2.new(0.6, 0, 1, 0)
delayInfo.Position = UDim2.new(0, 80, 0, 0)
delayInfo.BackgroundTransparency = 1

local delayTitle = Instance.new("TextLabel")
delayTitle.Name = "DelayTitle"
delayTitle.Size = UDim2.new(1, 0, 0, 35)
delayTitle.Position = UDim2.new(0, 0, 0, 10)
delayTitle.BackgroundTransparency = 1
delayTitle.Text = "WAKTU TANGKAP"
delayTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
delayTitle.TextSize = 18
delayTitle.Font = Enum.Font.GothamSemibold
delayTitle.TextXAlignment = Enum.TextXAlignment.Left

local delayValue = Instance.new("TextLabel")
delayValue.Name = "DelayValue"
delayValue.Size = UDim2.new(1, 0, 0, 30)
delayValue.Position = UDim2.new(0, 0, 0, 45)
delayValue.BackgroundTransparency = 1
delayValue.Text = "0.5 detik"
delayValue.TextColor3 = Color3.fromRGB(180, 220, 255)
delayValue.TextSize = 16
delayValue.Font = Enum.Font.Gotham
delayValue.TextXAlignment = Enum.TextXAlignment.Left

-- Delay Slider
local delaySlider = Instance.new("Frame")
delaySlider.Name = "DelaySlider"
delaySlider.Size = UDim2.new(0, 120, 0, 25)
delaySlider.Position = UDim2.new(1, -20, 0.5, -12.5)
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
delayHandle.Size = UDim2.new(0, 30, 0, 30)
delayHandle.Position = UDim2.new(0.5, -15, 0.5, -15)
delayHandle.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
delayHandle.BorderSizePixel = 0

local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(1, 0)
handleCorner.Parent = delayHandle

-- Status Display
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, 0, 0, 100)
statusFrame.Position = UDim2.new(0, 0, 0, 600)
statusFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 70)
statusFrame.BackgroundTransparency = 0.2
statusFrame.BorderSizePixel = 0

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 12)
statusCorner.Parent = statusFrame

local statusIcon = Instance.new("TextLabel")
statusIcon.Name = "StatusIcon"
statusIcon.Size = UDim2.new(0, 50, 0, 50)
statusIcon.Position = UDim2.new(0, 15, 0.5, -25)
statusIcon.AnchorPoint = Vector2.new(0, 0.5)
statusIcon.BackgroundTransparency = 1
statusIcon.Text = "📊"
statusIcon.TextColor3 = Color3.fromRGB(100, 200, 255)
statusIcon.TextSize = 30
statusIcon.Font = Enum.Font.GothamBold

local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, -80, 0, 30)
statusTitle.Position = UDim2.new(0, 80, 0, 15)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "STATUS SISTEM"
statusTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
statusTitle.TextSize = 18
statusTitle.Font = Enum.Font.GothamSemibold
statusTitle.TextXAlignment = Enum.TextXAlignment.Left

local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -80, 0, 40)
statusText.Position = UDim2.new(0, 80, 0, 45)
statusText.BackgroundTransparency = 1
statusText.Text = "Siap memancing! 🎣"
statusText.TextColor3 = Color3.fromRGB(180, 220, 255)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.TextWrapped = true

-- Assemble all UI elements
mainTitle.Parent = content
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

statusText.Parent = statusFrame
statusTitle.Parent = statusFrame
statusIcon.Parent = statusFrame
statusFrame.Parent = content

title.Parent = header
closeButton.Parent = header
header.Parent = mainContainer
content.Parent = mainContainer
mainContainer.Parent = screenGui
screenGui.Parent = playerGui

-- Status update function
local function updateStatus(message)
    statusText.Text = message
    print("🎣 " .. message)
end

-- Toggle animation function
local function animateToggle(toggleData, enabled)
    if enabled then
        -- Move knob to right
        TweenService:Create(toggleData.knob, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(80, 255, 140),
            Position = UDim2.new(1, -37, 0.5, -17)
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
            Position = UDim2.new(0, 3, 0.5, -17)
        }):Play()
        
        TweenService:Create(toggleData.button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(60, 80, 120)
        }):Play()
        
        toggleData.status.Text = "OFF"
        toggleData.status.TextColor3 = Color3.fromRGB(255, 120, 120)
        toggleData.icon.TextColor3 = toggleData.color
    end
end

-- Fishing hack settings
local fishingSettings = {
    AutoFish = false,
    BlantantFish = false,
    InstantFish = false,
    NoAnimation = false,
    CatchDelay = 0.5
}

-- Setup main feature toggles
for featureName, toggleData in pairs(mainFeatures) do
    toggleData.button.MouseButton1Click:Connect(function()
        toggleData.enabled = not toggleData.enabled
        animateToggle(toggleData, toggleData.enabled)
        
        -- Update settings
        if featureName == "AUTO FISHING" then
            fishingSettings.AutoFish = toggleData.enabled
        elseif featureName == "BLATANT FISHING" then
            fishingSettings.BlantantFish = toggleData.enabled
        elseif featureName == "INSTANT FISHING" then
            fishingSettings.InstantFish = toggleData.enabled
        elseif featureName == "NO ANIMATION" then
            fishingSettings.NoAnimation = toggleData.enabled
        end
        
        -- Send to server
        fishingRemote:FireServer("ToggleFeature", {
            Feature = featureName,
            Enabled = toggleData.enabled,
            Settings = fishingSettings
        })
        
        updateStatus(featureName .. " " .. (toggleData.enabled and "DIAKTIFKAN 🎣" or "dinonaktifkan"))
    end)
end

-- Delay slider functionality
local isDraggingDelay = false

local function updateDelayValue(xPosition)
    local absoluteX = delaySlider.AbsolutePosition.X
    local absoluteWidth = delaySlider.AbsoluteSize.X
    local percent = math.clamp((xPosition - absoluteX) / absoluteWidth, 0, 1)
    
    fishingSettings.CatchDelay = math.floor((0.1 + (percent * 1.9)) * 10) / 10 -- Range: 0.1s to 2.0s
    delayValue.Text = string.format("%.1f detik", fishingSettings.CatchDelay)
    delayFill.Size = UDim2.new(percent, 0, 1, 0)
    delayHandle.Position = UDim2.new(percent, -15, 0.5, -15)
    
    -- Update server
    fishingRemote:FireServer("UpdateSettings", {
        CatchDelay = fishingSettings.CatchDelay
    })
    
    updateStatus("Waktu tangkap diatur ke " .. fishingSettings.CatchDelay .. "s")
end

delaySlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingDelay = true
        updateDelayValue(input.Position.X)
    end
end)

delaySlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingDelay = false
    end
end)

delayHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingDelay = true
    end
end)

delayHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingDelay = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingDelay and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        updateDelayValue(input.Position.X)
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(0.3)
    screenGui.Enabled = false
    updateStatus("UI ditutup")
end)

-- Floating button to reopen UI
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 80, 0, 80)
openButton.Position = UDim2.new(1, -90, 0.9, -90)
openButton.BackgroundColor3 = Color3.fromRGB(40, 120, 220)
openButton.Text = "🎣"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 36
openButton.Font = Enum.Font.GothamBold
openButton.Visible = false

local openButtonCorner = Instance.new("UICorner")
openButtonCorner.CornerRadius = UDim.new(1, 0)
openButtonCorner.Parent = openButton

openButton.Parent = screenGui

openButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = true
    openButton.Visible = false
    
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.85, 0, 0.8, 0)
    }):Play()
    
    updateStatus("UI dibuka kembali")
end)

-- When UI closes, show open button
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    openButton.Visible = true
end)

-- Initialize all toggles to OFF
for _, toggleData in pairs(mainFeatures) do
    animateToggle(toggleData, false)
end

-- Initialize delay slider
updateDelayValue(delaySlider.AbsolutePosition.X + (delaySlider.AbsoluteSize.X * 0.5))

-- Animation saat pertama kali muncul
mainContainer.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(mainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0.85, 0, 0.8, 0)
}):Play()

updateStatus("Fishing Hack siap digunakan! 🎣")

print("🎣 Fishing Hack UI Mobile dimuat!")
