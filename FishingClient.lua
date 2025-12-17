-- Fishing Hack UI for "Fish It!"
-- fishing_hack_ui.lua - Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create RemoteEvents for fishing hacks
if not ReplicatedStorage:FindFirstChild("FishingHack") then
    Instance.new("RemoteEvent", ReplicatedStorage).Name = "FishingHack"
end

-- Create main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishingHackUI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.Enabled = false

-- Background Blur
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Name = "UIBlur"
blur.Parent = game:GetService("Lighting")

-- Main Container
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 450, 0, 550)
mainContainer.Position = UDim2.new(0.5, -225, 0.5, -275)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
mainContainer.BackgroundTransparency = 0.1
mainContainer.BorderSizePixel = 0

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = mainContainer

local containerStroke = Instance.new("UIStroke")
containerStroke.Name = "ContainerStroke"
containerStroke.Color = Color3.fromRGB(40, 100, 200)
containerStroke.Thickness = 2
containerStroke.Transparency = 0.3
containerStroke.Parent = mainContainer

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 FISH IT! HACKS"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local fishIcon = Instance.new("ImageLabel")
fishIcon.Name = "FishIcon"
fishIcon.Size = UDim2.new(0, 40, 0, 40)
fishIcon.Position = UDim2.new(0, 20, 0.5, -20)
fishIcon.AnchorPoint = Vector2.new(0, 0.5)
fishIcon.BackgroundTransparency = 1
fishIcon.Image = "rbxassetid://3926307971"
fishIcon.ImageRectOffset = Vector2.new(644, 324)
fishIcon.ImageRectSize = Vector2.new(48, 48)
fishIcon.ImageColor3 = Color3.fromRGB(100, 200, 255)

-- Close Button
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0.5, -20)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
closeButton.BackgroundTransparency = 0.3
closeButton.Image = "rbxassetid://3926305904"
closeButton.ImageRectOffset = Vector2.new(284, 4)
closeButton.ImageRectSize = Vector2.new(24, 24)
closeButton.ImageColor3 = Color3.fromRGB(200, 200, 200)

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Content Area
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -40, 1, -90)
content.Position = UDim2.new(0, 20, 0, 80)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 6
content.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 200)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Main Features Section
local mainSection = Instance.new("Frame")
mainSection.Name = "MainSection"
mainSection.Size = UDim2.new(1, 0, 0, 200)
mainSection.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
mainSection.BackgroundTransparency = 0.2
mainSection.BorderSizePixel = 0

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainSection

local mainTitle = Instance.new("TextLabel")
mainTitle.Name = "MainTitle"
mainTitle.Size = UDim2.new(1, -20, 0, 40)
mainTitle.Position = UDim2.new(0, 15, 0, 10)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "MAIN FEATURES"
mainTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
mainTitle.TextSize = 18
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Create toggle feature function
local function createFeatureToggle(parent, featureName, description, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = featureName .. "Frame"
    toggleFrame.Size = UDim2.new(1, -30, 0, 50)
    toggleFrame.Position = UDim2.new(0, 15, 0, yPosition)
    toggleFrame.BackgroundTransparency = 1
    
    -- Feature info
    local featureInfo = Instance.new("Frame")
    featureInfo.Name = "FeatureInfo"
    featureInfo.Size = UDim2.new(0.7, 0, 1, 0)
    featureInfo.BackgroundTransparency = 1
    
    local featureNameLabel = Instance.new("TextLabel")
    featureNameLabel.Name = "FeatureName"
    featureNameLabel.Size = UDim2.new(1, 0, 0, 25)
    featureNameLabel.BackgroundTransparency = 1
    featureNameLabel.Text = featureName
    featureNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    featureNameLabel.TextSize = 16
    featureNameLabel.Font = Enum.Font.GothamSemibold
    featureNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local featureDescLabel = Instance.new("TextLabel")
    featureDescLabel.Name = "FeatureDesc"
    featureDescLabel.Size = UDim2.new(1, 0, 0, 20)
    featureDescLabel.Position = UDim2.new(0, 0, 0, 25)
    featureDescLabel.BackgroundTransparency = 1
    featureDescLabel.Text = description
    featureDescLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    featureDescLabel.TextSize = 12
    featureDescLabel.Font = Enum.Font.Gotham
    featureDescLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle switch
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "ToggleContainer"
    toggleContainer.Size = UDim2.new(0.3, 0, 1, 0)
    toggleContainer.Position = UDim2.new(0.7, 0, 0, 0)
    toggleContainer.BackgroundTransparency = 1
    
    local toggleBackground = Instance.new("Frame")
    toggleBackground.Name = "ToggleBackground"
    toggleBackground.Size = UDim2.new(0, 60, 0, 30)
    toggleBackground.Position = UDim2.new(1, -60, 0.5, -15)
    toggleBackground.AnchorPoint = Vector2.new(1, 0.5)
    toggleBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggleBackground.BorderSizePixel = 0
    
    local toggleBgCorner = Instance.new("UICorner")
    toggleBgCorner.CornerRadius = UDim.new(1, 0)
    toggleBgCorner.Parent = toggleBackground
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 26, 0, 26)
    toggleButton.Position = UDim2.new(0, 2, 0.5, -13)
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleStatus = Instance.new("TextLabel")
    toggleStatus.Name = "ToggleStatus"
    toggleStatus.Size = UDim2.new(1, 0, 0, 15)
    toggleStatus.Position = UDim2.new(0, 0, 1, 5)
    toggleStatus.BackgroundTransparency = 1
    toggleStatus.Text = "OFF"
    toggleStatus.TextColor3 = Color3.fromRGB(255, 120, 120)
    toggleStatus.TextSize = 11
    toggleStatus.Font = Enum.Font.GothamSemibold
    toggleStatus.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Assemble toggle
    featureDescLabel.Parent = featureInfo
    featureNameLabel.Parent = featureInfo
    featureInfo.Parent = toggleFrame
    
    toggleButton.Parent = toggleBackground
    toggleStatus.Parent = toggleBackground
    toggleBackground.Parent = toggleContainer
    toggleContainer.Parent = toggleFrame
    
    toggleFrame.Parent = parent
    
    return {
        frame = toggleFrame,
        button = toggleButton,
        background = toggleBackground,
        status = toggleStatus,
        enabled = false
    }
end

-- Create main features
local mainFeatures = {}
local featureYPositions = {60, 120, 180, 240}

mainFeatures.AutoFish = createFeatureToggle(mainSection, "🤖 AUTO FISHING", "Automatically catch fish without interaction", featureYPositions[1])
mainFeatures.BlantantFish = createFeatureToggle(mainSection, "⚡ BLATANT FISHING", "Catch fish through obstacles/walls", featureYPositions[2])
mainFeatures.InstantFish = createFeatureToggle(mainSection, "🚀 INSTANT FISHING", "Instant catch - no waiting time", featureYPositions[3])
mainFeatures.NoAnimation = createFeatureToggle(mainSection, "🎬 NO ANIMATION", "Skip fishing animations", featureYPositions[4])

-- Settings Section
local settingsSection = Instance.new("Frame")
settingsSection.Name = "SettingsSection"
settingsSection.Size = UDim2.new(1, 0, 0, 250)
settingsSection.Position = UDim2.new(0, 0, 0, 220)
settingsSection.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
settingsSection.BackgroundTransparency = 0.2
settingsSection.BorderSizePixel = 0

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = settingsSection

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Name = "SettingsTitle"
settingsTitle.Size = UDim2.new(1, -20, 0, 40)
settingsTitle.Position = UDim2.new(0, 15, 0, 10)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "SETTINGS"
settingsTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
settingsTitle.TextSize = 18
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Auto Fishing Settings
local autoFishSettings = Instance.new("Frame")
autoFishSettings.Name = "AutoFishSettings"
autoFishSettings.Size = UDim2.new(1, -30, 0, 80)
autoFishSettings.Position = UDim2.new(0, 15, 0, 50)
autoFishSettings.BackgroundColor3 = Color3.fromRGB(35, 45, 80)
autoFishSettings.BackgroundTransparency = 0.3
autoFishSettings.BorderSizePixel = 0

local autoFishCorner = Instance.new("UICorner")
autoFishCorner.CornerRadius = UDim.new(0, 6)
autoFishCorner.Parent = autoFishSettings

local autoFishTitle = Instance.new("TextLabel")
autoFishTitle.Name = "AutoFishTitle"
autoFishTitle.Size = UDim2.new(1, -10, 0, 25)
autoFishTitle.Position = UDim2.new(0, 10, 0, 5)
autoFishTitle.BackgroundTransparency = 1
autoFishTitle.Text = "Auto Fishing Settings"
autoFishTitle.TextColor3 = Color3.fromRGB(180, 220, 255)
autoFishTitle.TextSize = 14
autoFishTitle.Font = Enum.Font.GothamSemibold
autoFishTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Catch Delay Slider
local catchDelayFrame = Instance.new("Frame")
catchDelayFrame.Name = "CatchDelayFrame"
catchDelayFrame.Size = UDim2.new(1, -20, 0, 30)
catchDelayFrame.Position = UDim2.new(0, 10, 0, 35)
catchDelayFrame.BackgroundTransparency = 1

local catchDelayLabel = Instance.new("TextLabel")
catchDelayLabel.Name = "CatchDelayLabel"
catchDelayLabel.Size = UDim2.new(0.6, 0, 1, 0)
catchDelayLabel.BackgroundTransparency = 1
catchDelayLabel.Text = "Catch Delay: 0.5s"
catchDelayLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
catchDelayLabel.TextSize = 12
catchDelayLabel.Font = Enum.Font.Gotham
catchDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local catchDelaySlider = Instance.new("Frame")
catchDelaySlider.Name = "CatchDelaySlider"
catchDelaySlider.Size = UDim2.new(0.4, 0, 0, 6)
catchDelaySlider.Position = UDim2.new(0.6, 0, 0.5, -3)
catchDelaySlider.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
catchDelaySlider.BorderSizePixel = 0

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = catchDelaySlider

local catchDelayFill = Instance.new("Frame")
catchDelayFill.Name = "CatchDelayFill"
catchDelayFill.Size = UDim2.new(0.5, 0, 1, 0)
catchDelayFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
catchDelayFill.BorderSizePixel = 0

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = catchDelayFill

local catchDelayHandle = Instance.new("Frame")
catchDelayHandle.Name = "CatchDelayHandle"
catchDelayHandle.Size = UDim2.new(0, 16, 0, 16)
catchDelayHandle.Position = UDim2.new(0.5, -8, 0.5, -8)
catchDelayHandle.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
catchDelayHandle.BorderSizePixel = 0

local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(1, 0)
handleCorner.Parent = catchDelayHandle

-- Fish Filter Settings
local fishFilterFrame = Instance.new("Frame")
fishFilterFrame.Name = "FishFilterFrame"
fishFilterFrame.Size = UDim2.new(1, -30, 0, 80)
fishFilterFrame.Position = UDim2.new(0, 15, 0, 140)
fishFilterFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 80)
fishFilterFrame.BackgroundTransparency = 0.3
fishFilterFrame.BorderSizePixel = 0

local fishFilterCorner = Instance.new("UICorner")
fishFilterCorner.CornerRadius = UDim.new(0, 6)
fishFilterCorner.Parent = fishFilterFrame

local fishFilterTitle = Instance.new("TextLabel")
fishFilterTitle.Name = "FishFilterTitle"
fishFilterTitle.Size = UDim2.new(1, -10, 0, 25)
fishFilterTitle.Position = UDim2.new(0, 10, 0, 5)
fishFilterTitle.BackgroundTransparency = 1
fishFilterTitle.Text = "Fish Filter Settings"
fishFilterTitle.TextColor3 = Color3.fromRGB(180, 220, 255)
fishFilterTitle.TextSize = 14
fishFilterTitle.Font = Enum.Font.GothamSemibold
fishFilterTitle.TextXAlignment = Enum.TextXAlignment.Left

local rarityCheckboxes = {}
local rarities = {
    {"🟢 Common", Color3.fromRGB(0, 200, 83)},
    {"🔵 Rare", Color3.fromRGB(0, 150, 255)},
    {"🟣 Epic", Color3.fromRGB(170, 0, 255)},
    {"🟡 Legendary", Color3.fromRGB(255, 214, 0)},
    {"🔴 Mythical", Color3.fromRGB(255, 60, 60)}
}

for i, rarity in ipairs(rarities) do
    local yPos = 30 + (i-1) * 25
    
    local checkboxFrame = Instance.new("Frame")
    checkboxFrame.Name = rarity[1] .. "Checkbox"
    checkboxFrame.Size = UDim2.new(1, -20, 0, 20)
    checkboxFrame.Position = UDim2.new(0, 10, 0, yPos)
    checkboxFrame.BackgroundTransparency = 1
    
    local checkboxButton = Instance.new("TextButton")
    checkboxButton.Name = "CheckboxButton"
    checkboxButton.Size = UDim2.new(0, 16, 0, 16)
    checkboxButton.Position = UDim2.new(0, 0, 0.5, -8)
    checkboxButton.AnchorPoint = Vector2.new(0, 0.5)
    checkboxButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
    checkboxButton.Text = ""
    checkboxButton.AutoButtonColor = false
    
    local checkboxCorner = Instance.new("UICorner")
    checkboxCorner.CornerRadius = UDim.new(0, 4)
    checkboxCorner.Parent = checkboxButton
    
    local checkmark = Instance.new("ImageLabel")
    checkmark.Name = "Checkmark"
    checkmark.Size = UDim2.new(0.8, 0, 0.8, 0)
    checkmark.Position = UDim2.new(0.1, 0, 0.1, 0)
    checkmark.BackgroundTransparency = 1
    checkmark.Image = "rbxassetid://3926307971"
    checkmark.ImageRectOffset = Vector2.new(364, 284)
    checkmark.ImageRectSize = Vector2.new(36, 36)
    checkmark.ImageColor3 = rarity[2]
    checkmark.Visible = true
    
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Name = "RarityLabel"
    rarityLabel.Size = UDim2.new(1, -25, 1, 0)
    rarityLabel.Position = UDim2.new(0, 25, 0, 0)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = rarity[1]
    rarityLabel.TextColor3 = rarity[2]
    rarityLabel.TextSize = 12
    rarityLabel.Font = Enum.Font.GothamSemibold
    rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    checkmark.Parent = checkboxButton
    checkboxButton.Parent = checkboxFrame
    rarityLabel.Parent = checkboxFrame
    checkboxFrame.Parent = fishFilterFrame
    
    rarityCheckboxes[rarity[1]] = {
        button = checkboxButton,
        checkmark = checkmark,
        enabled = true,
        color = rarity[2]
    }
end

-- Status Panel
local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.new(1, 0, 0, 100)
statusPanel.Position = UDim2.new(0, 0, 0, 490)
statusPanel.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
statusPanel.BackgroundTransparency = 0.2
statusPanel.BorderSizePixel = 0

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusPanel

local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, -20, 0, 30)
statusTitle.Position = UDim2.new(0, 15, 0, 10)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "📊 STATUS"
statusTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
statusTitle.TextSize = 16
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextXAlignment = Enum.TextXAlignment.Left

local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -30, 0, 50)
statusText.Position = UDim2.new(0, 15, 0, 40)
statusText.BackgroundTransparency = 1
statusText.Text = "Ready to fish! 🎣"
statusText.TextColor3 = Color3.fromRGB(180, 220, 255)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.TextWrapped = true

-- Assemble UI
catchDelayFill.Parent = catchDelaySlider
catchDelayHandle.Parent = catchDelaySlider
catchDelayLabel.Parent = catchDelayFrame
catchDelaySlider.Parent = catchDelayFrame
catchDelayFrame.Parent = autoFishSettings
autoFishTitle.Parent = autoFishSettings
autoFishSettings.Parent = settingsSection

fishFilterTitle.Parent = fishFilterFrame
fishFilterFrame.Parent = settingsSection

statusText.Parent = statusPanel
statusTitle.Parent = statusPanel
statusPanel.Parent = content

settingsTitle.Parent = settingsSection
settingsSection.Parent = content

mainTitle.Parent = mainSection
mainSection.Parent = content

content.Parent = mainContainer

fishIcon.Parent = header
title.Parent = header
closeButton.Parent = header
header.Parent = mainContainer

mainContainer.Parent = screenGui
screenGui.Parent = playerGui

-- Update status
local function updateStatus(message)
    statusText.Text = message
end

-- Toggle animation function
local function animateToggle(toggleData, enabled)
    if enabled then
        TweenService:Create(toggleData.button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(80, 255, 140),
            Position = UDim2.new(1, -28, 0.5, -13)
        }):Play()
        TweenService:Create(toggleData.background, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(40, 100, 60)
        }):Play()
        toggleData.status.Text = "ON"
        toggleData.status.TextColor3 = Color3.fromRGB(80, 255, 140)
    else
        TweenService:Create(toggleData.button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Position = UDim2.new(0, 2, 0.5, -13)
        }):Play()
        TweenService:Create(toggleData.background, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        }):Play()
        toggleData.status.Text = "OFF"
        toggleData.status.TextColor3 = Color3.fromRGB(255, 120, 120)
    end
end

-- Setup toggles
for featureName, toggleData in pairs(mainFeatures) do
    toggleData.button.MouseButton1Click:Connect(function()
        toggleData.enabled = not toggleData.enabled
        animateToggle(toggleData, toggleData.enabled)
        
        -- Send to server
        local settings = {
            AutoFish = mainFeatures.AutoFish.enabled,
            BlantantFish = mainFeatures.BlantantFish.enabled,
            InstantFish = mainFeatures.InstantFish.enabled,
            NoAnimation = mainFeatures.NoAnimation.enabled,
            CatchDelay = 0.5, -- Default value
            Rarities = {}
        }
        
        ReplicatedStorage.FishingHack:FireServer("ToggleFeature", {
            Feature = featureName,
            Enabled = toggleData.enabled,
            Settings = settings
        })
        
        updateStatus(featureName .. " " .. (toggleData.enabled and "enabled! 🎣" or "disabled"))
    end)
end

-- Setup sliders
local catchDelay = 0.5
local isDraggingCatchDelay = false

local function updateCatchDelayValue(xPosition)
    local absoluteX = catchDelaySlider.AbsolutePosition.X
    local absoluteWidth = catchDelaySlider.AbsoluteSize.X
    local percent = math.clamp((xPosition - absoluteX) / absoluteWidth, 0, 1)
    
    catchDelay = math.floor((0.1 + (percent * 1.9)) * 10) / 10 -- Range: 0.1s to 2.0s
    catchDelayLabel.Text = string.format("Catch Delay: %.1fs", catchDelay)
    catchDelayFill.Size = UDim2.new(percent, 0, 1, 0)
    catchDelayHandle.Position = UDim2.new(percent, -8, 0.5, -8)
end

catchDelaySlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingCatchDelay = true
        updateCatchDelayValue(input.Position.X)
    end
end)

catchDelaySlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingCatchDelay = false
    end
end)

catchDelayHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingCatchDelay = true
    end
end)

catchDelayHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingCatchDelay = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingCatchDelay and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateCatchDelayValue(input.Position.X)
    end
end)

-- Setup rarity checkboxes
for rarityName, checkboxData in pairs(rarityCheckboxes) do
    checkboxData.button.MouseButton1Click:Connect(function()
        checkboxData.enabled = not checkboxData.enabled
        checkboxData.checkmark.Visible = checkboxData.enabled
        
        -- Animate
        if checkboxData.enabled then
            TweenService:Create(checkboxData.button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(40, 60, 100)
            }):Play()
        else
            TweenService:Create(checkboxData.button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(60, 80, 120)
            }):Play()
        end
    end)
end

-- Toggle UI function
local function toggleUI()
    screenGui.Enabled = not screenGui.Enabled
    
    if screenGui.Enabled then
        -- Fade in blur
        TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = 12
        }):Play()
        
        -- Scale in animation
        mainContainer.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 450, 0, 550)
        }):Play()
        
        updateStatus("Fishing Hack UI Ready! 🎣")
    else
        -- Fade out blur
        TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = 0
        }):Play()
        
        -- Scale out animation
        TweenService:Create(mainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
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

-- Initialize all toggles
for _, toggleData in pairs(mainFeatures) do
    animateToggle(toggleData, false)
end

print("🎣 Fishing Hack UI loaded! Press F6 to toggle.")
