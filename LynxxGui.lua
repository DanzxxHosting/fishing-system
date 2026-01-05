-- DYRON MODE v1: CUSTOM PREMIUM UI
-- STATUS: BUILDING ADVANCED CUSTOM INTERFACE

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- VARIABLES
local LocalPlayer = Players.LocalPlayer
local AutoFishing = false
local PerfectFishing = false
local InstantFishing = false
local InfinityJump = false
local AntiAFK = false
local WalkSpeed = 16
local JumpPower = 50

-- NETWORK REFERENCES
local NetPackage = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local UpdateAutoFishingState = NetPackage:WaitForChild("RF/UpdateAutoFishingState")
local ChargeFishingRod = NetPackage:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigameStarted = NetPackage:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = NetPackage:WaitForChild("RE/FishingCompleted")

-- CUSTOM UI LIBRARY
local FishItUI = {}
FishItUI.__index = FishItUI

function FishItUI.new(title)
    local self = setmetatable({}, FishItUI)
    
    -- Create main screen GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "FishItPremiumUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game.CoreGui
    
    -- Main container
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 450, 0, 500)
    self.MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    self.MainFrame.BackgroundTransparency = 0.1
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Add gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    })
    gradient.Rotation = 45
    gradient.Parent = self.MainFrame
    
    -- Add subtle noise texture
    local noise = Instance.new("ImageLabel")
    noise.Name = "NoiseTexture"
    noise.Size = UDim2.new(1, 0, 1, 0)
    noise.BackgroundTransparency = 1
    noise.Image = "rbxassetid://8344712084"
    noise.ImageTransparency = 0.95
    noise.ScaleType = Enum.ScaleType.Tile
    noise.TileSize = UDim2.new(0, 100, 0, 100)
    noise.Parent = self.MainFrame
    
    -- Header
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 60)
    self.Header.BackgroundTransparency = 1
    self.Header.Parent = self.MainFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0.15, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "FISH IT PRO"
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextSize = 28
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.Header
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(0.7, 0, 0, 20)
    subtitle.Position = UDim2.new(0.15, 0, 0.6, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium Fishing Suite"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = self.Header
    
    -- Logo/Icon
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 40, 0, 40)
    logo.Position = UDim2.new(0.03, 0, 0.15, 0)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://6031075938" -- Fish icon
    logo.ImageColor3 = Color3.fromRGB(0, 200, 255)
    logo.Parent = self.Header
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(0.95, -30, 0.02, 0)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    self.CloseButton.AutoButtonColor = false
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    self.CloseButton.TextSize = 24
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.Header
    
    -- Close button hover effect
    self.CloseButton.MouseEnter:Connect(function()
        game.TweenService:Create(self.CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 40, 40),
            TextColor3 = Color3.fromRGB(255, 150, 150)
        }):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        game.TweenService:Create(self.CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 60),
            TextColor3 = Color3.fromRGB(255, 100, 100)
        }):Play()
    end)
    
    -- Tab container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, -20, 0, 40)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 70)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainFrame
    
    -- Content container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -20, 1, -130)
    self.ContentContainer.Position = UDim2.new(0, 10, 0, 120)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ScrollBarThickness = 4
    self.ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentContainer.Parent = self.MainFrame
    
    -- UI State
    self.Tabs = {}
    self.CurrentTab = nil
    self.Visible = true
    
    -- Initialize
    self:CreateTabs({"MAIN", "TELEPORT", "UTILITY"})
    self:SelectTab("MAIN")
    
    -- Make draggable
    self:MakeDraggable(self.Header)
    
    -- Close button functionality
    self.CloseButton.MouseButton1Click:Connect(function()
        self:ToggleVisibility()
    end)
    
    -- Keybind for toggle (RightShift)
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.F6 then
            self:ToggleVisibility()
        end
    end)
    
    return self
end

function FishItUI:CreateTabs(tabNames)
    local tabWidth = 1 / #tabNames
    
    for i, tabName in ipairs(tabNames) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Tab"
        tabButton.Size = UDim2.new(tabWidth, 0, 1, 0)
        tabButton.Position = UDim2.new(tabWidth * (i - 1), 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        tabButton.AutoButtonColor = false
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(150, 150, 200)
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Parent = self.TabContainer
        
        -- Tab hover effects
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tabName then
                game.TweenService:Create(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 60),
                    TextColor3 = Color3.fromRGB(200, 200, 255)
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tabName then
                game.TweenService:Create(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 45),
                    TextColor3 = Color3.fromRGB(150, 150, 200)
                }):Play()
            end
        end)
        
        -- Tab click
        tabButton.MouseButton1Click:Connect(function()
            self:SelectTab(tabName)
        end)
        
        self.Tabs[tabName] = {
            Button = tabButton,
            Content = {}
        }
    end
end

function FishItUI:SelectTab(tabName)
    if self.CurrentTab then
        -- Deselect old tab
        local oldTab = self.Tabs[self.CurrentTab]
        game.TweenService:Create(oldTab.Button, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 45),
            TextColor3 = Color3.fromRGB(150, 150, 200)
        }):Play()
        
        -- Hide old content
        for _, element in pairs(oldTab.Content) do
            if element then
                element.Visible = false
            end
        end
    end
    
    -- Select new tab
    self.CurrentTab = tabName
    local newTab = self.Tabs[tabName]
    
    game.TweenService:Create(newTab.Button, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(0, 150, 200),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    
    -- Show content
    for _, element in pairs(newTab.Content) do
        if element then
            element.Visible = true
        end
    end
    
    -- Play sound effect (optional)
    -- game.SoundService.UI.Click:Play()
end

function FishItUI:MakeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function FishItUI:ToggleVisibility()
    self.Visible = not self.Visible
    
    if self.Visible then
        self.MainFrame.Visible = true
        game.TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 450, 0, 500)
        }):Play()
    else
        game.TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 500)
        }):Play()
        
        delay(0.3, function()
            self.MainFrame.Visible = false
        end)
    end
end

function FishItUI:CreateSection(title)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. title
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundTransparency = 1
    section.Parent = self.ContentContainer
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "Title"
    sectionTitle.Size = UDim2.new(1, 0, 0, 30)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = " " .. title
    sectionTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    sectionTitle.TextSize = 18
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = section
    
    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.Size = UDim2.new(1, 0, 0, 2)
    underline.Position = UDim2.new(0, 0, 0, 28)
    underline.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    underline.BorderSizePixel = 0
    underline.Parent = section
    
    return section
end

function FishItUI:CreateToggle(name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. name
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = self.ContentContainer
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "  " .. name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(0.85, -50, 0.5, -12)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(60, 60, 80)
    toggleButton.AutoButtonColor = false
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    -- Make circle rounded
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggleCircle
    
    -- Toggle button corner
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton
    
    local state = default
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        
        local targetColor = state and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(60, 60, 80)
        local targetPos = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        
        game.TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = targetColor
        }):Play()
        
        game.TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            Position = targetPos
        }):Play()
        
        callback(state)
    end)
    
    -- Store in current tab
    table.insert(self.Tabs[self.CurrentTab].Content, toggleFrame)
    
    return toggleFrame
end

function FishItUI:CreateButton(name, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. name
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.AutoButtonColor = false
    button.Text = name
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.TextSize = 16
    button.Font = Enum.Font.Gotham
    button.Parent = self.ContentContainer
    
    -- Button corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        game.TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 150, 200),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game.TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 60),
            TextColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
    end)
    
    -- Click effect
    button.MouseButton1Click:Connect(function()
        game.TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(0, 100, 150)
        }):Play()
        
        wait(0.1)
        
        game.TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(0, 150, 200)
        }):Play()
        
        callback()
    end)
    
    -- Store in current tab
    table.insert(self.Tabs[self.CurrentTab].Content, button)
    
    return button
end

function FishItUI:CreateSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider_" .. name
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = self.ContentContainer
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = "  " .. name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "Background"
    sliderBackground.Size = UDim2.new(1, -20, 0, 8)
    sliderBackground.Position = UDim2.new(0, 10, 0, 35)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.AutoButtonColor = false
    sliderButton.Text = ""
    sliderButton.Parent = sliderBackground
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    local dragging = false
    
    local function updateSlider(input)
        local xPos = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * xPos)
        
        sliderFill.Size = UDim2.new(xPos, 0, 1, 0)
        sliderButton.Position = UDim2.new(xPos, -10, 0.5, -10)
        label.Text = "  " .. name .. ": " .. value
        
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
            updateSlider(input)
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    -- Store in current tab
    table.insert(self.Tabs[self.CurrentTab].Content, sliderFrame)
    
    return sliderFrame
end

function FishItUI:CreateDropdown(name, options, default, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown_" .. name
    dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.Parent = self.ContentContainer
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, 40)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    dropdownButton.AutoButtonColor = false
    dropdownButton.Text = name .. ": " .. (options[default] or default)
    dropdownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    dropdownButton.TextSize = 16
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.Parent = dropdownFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = dropdownButton
    
    local arrow = Instance.new("ImageLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -30, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://6031091002"
    arrow.ImageColor3 = Color3.fromRGB(150, 150, 200)
    arrow.Rotation = 0
    arrow.Parent = dropdownButton
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ClipsDescendants = true
    optionsFrame.Visible = false
    optionsFrame.Parent = dropdownFrame
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 8)
    optionsCorner.Parent = optionsFrame
    
    local optionsList = Instance.new("UIListLayout")
    optionsList.Parent = optionsFrame
    
    local selected = default
    local open = false
    
    -- Create option buttons
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. option
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        optionButton.AutoButtonColor = false
        optionButton.Text = "  " .. option
        optionButton.TextColor3 = Color3.fromRGB(180, 180, 220)
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Parent = optionsFrame
        
        optionButton.MouseEnter:Connect(function()
            game.TweenService:Create(optionButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            game.TweenService:Create(optionButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            }):Play()
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            selected = i
            dropdownButton.Text = name .. ": " .. option
            callback(option)
            self:ToggleDropdown(dropdownFrame)
        end)
    end
    
    -- Update options frame size
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    
    -- Toggle function
    function self:ToggleDropdown(frame)
        open = not open
        
        if open then
            frame.OptionsFrame.Visible = true
            game.TweenService:Create(frame.DropdownButton.Arrow, TweenInfo.new(0.3), {
                Rotation = 180
            }):Play()
        else
            game.TweenService:Create(frame.DropdownButton.Arrow, TweenInfo.new(0.3), {
                Rotation = 0
            }):Play()
            
            wait(0.3)
            frame.OptionsFrame.Visible = false
        end
    end
    
    -- Button click
    dropdownButton.MouseButton1Click:Connect(function()
        self:ToggleDropdown(dropdownFrame)
    end)
    
    -- Store in current tab
    table.insert(self.Tabs[self.CurrentTab].Content, dropdownFrame)
    
    return dropdownFrame
end

-- INITIALIZE UI
local UI = FishItUI.new("Fish It Pro")

-- ============================================
-- MAIN TAB CONTENT
-- ============================================
UI:SelectTab("MAIN")
UI:CreateSection("Fishing Features")

UI:CreateToggle("Auto Fishing", false, function(state)
    AutoFishing = state
    print("[+] Auto Fishing:", state)
    
    if state then
        UpdateAutoFishingState:InvokeServer(true)
        
        local function fishingLoop()
            while AutoFishing do
                ChargeFishingRod:InvokeServer()
                wait(0.5)
                
                local args = {
                    -0.233184814453125,
                    0.1,
                    tick()
                }
                RequestFishingMinigameStarted:InvokeServer(unpack(args))
                wait(0.5)
                
                FishingCompleted:FireServer()
                wait(math.random(2, 4))
            end
            
            UpdateAutoFishingState:InvokeServer(false)
        end
        
        spawn(fishingLoop)
    end
end)

UI:CreateToggle("Instant Fishing", false, function(state)
    InstantFishing = state
    print("[+] Instant Fishing:", state)
    
    if state then
        AutoFishing = false
        
        local function instantLoop()
            while InstantFishing do
                ChargeFishingRod:InvokeServer()
                
                local args = {
                    -0.233184814453125,
                    0.01,
                    tick()
                }
                
                RequestFishingMinigameStarted:InvokeServer(unpack(args))
                FishingCompleted:FireServer()
                wait(0.2)
            end
        end
        
        spawn(instantLoop)
    end
end)

UI:CreateToggle("Auto Perfect Fishing", false, function(state)
    PerfectFishing = state
    print("[+] Perfect Fishing:", state)
    
    if state then
        AutoFishing = false
        InstantFishing = false
        
        UpdateAutoFishingState:InvokeServer(true)
        
        local function perfectLoop()
            while PerfectFishing do
                ChargeFishingRod:InvokeServer()
                wait(0.7)
                
                local args = {
                    -0.233184814453125,
                    0.05,
                    tick() + 0.1
                }
                
                RequestFishingMinigameStarted:InvokeServer(unpack(args))
                wait(0.3)
                
                FishingCompleted:FireServer()
                wait(math.random(1, 2))
            end
            
            UpdateAutoFishingState:InvokeServer(false)
        end
        
        spawn(perfectLoop)
    end
end)

UI:CreateButton("Manual Fish Catch", function()
    ChargeFishingRod:InvokeServer()
    wait(0.5)
    
    local args = {
        -0.233184814453125,
        0.1,
        tick()
    }
    RequestFishingMinigameStarted:InvokeServer(unpack(args))
    wait(1)
    
    FishingCompleted:FireServer()
    print("[✓] Manual catch completed")
end)

-- ============================================
-- TELEPORT TAB CONTENT
-- ============================================
UI:SelectTab("TELEPORT")
UI:CreateSection("Teleport Locations")

-- Fishing Spots
UI:CreateDropdown("Fishing Spots", 
    {"River Spot", "Lake Center", "Ocean Dock", "Deep Water", "Waterfall", "Pier", "Bridge", "Hidden Pond"}, 
    1, 
    function(spot)
        print("[*] Teleporting to:", spot)
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local positions = {
                ["River Spot"] = Vector3.new(100, 5, 50),
                ["Lake Center"] = Vector3.new(200, 5, 150),
                ["Ocean Dock"] = Vector3.new(-50, 10, 300),
                ["Deep Water"] = Vector3.new(0, 5, 500),
                ["Waterfall"] = Vector3.new(300, 20, 200),
                ["Pier"] = Vector3.new(-200, 8, 250),
                ["Bridge"] = Vector3.new(150, 10, 0),
                ["Hidden Pond"] = Vector3.new(-150, 5, -100)
            }
            
            local targetPos = positions[spot] or Vector3.new(0, 10, 0)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            print("[✓] Arrived at", spot)
        end
    end
)

-- Teleport to Player
local playerNames = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerNames, player.Name)
    end
end

UI:CreateDropdown("Teleport to Player", 
    playerNames,
    1,
    function(playerName)
        local targetPlayer = Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                print("[✓] Teleported to", playerName)
            end
        end
    end
)

-- Teleport to NPC
UI:CreateDropdown("Teleport to NPC", 
    {"Fishing Master", "Shopkeeper", "Banker", "Quest Giver", "Equipment Vendor", "Boat Captain"}, 
    1,
    function(npcName)
        print("[*] Finding NPC:", npcName)
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local npcPositions = {
                ["Fishing Master"] = Vector3.new(50, 5, -30),
                ["Shopkeeper"] = Vector3.new(80, 5, -10),
                ["Banker"] = Vector3.new(120, 5, 40),
                ["Quest Giver"] = Vector3.new(-30, 5, 60),
                ["Equipment Vendor"] = Vector3.new(-80, 5, 20),
                ["Boat Captain"] = Vector3.new(-150, 8, 300)
            }
            
            local targetPos = npcPositions[npcName] or Vector3.new(0, 10, 0)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            print("[✓] Teleported to", npcName)
        end
    end
)

UI:CreateButton("Save Current Position", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        print("[SAVED] Position: X=" .. math.floor(pos.X) .. " Y=" .. math.floor(pos.Y) .. " Z=" .. math.floor(pos.Z))
    end
end)

UI:CreateButton("Teleport to Base", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        print("[✓] Teleported to base")
    end
end)

-- ============================================
-- UTILITY TAB CONTENT
-- ============================================
UI:SelectTab("UTILITY")
UI:CreateSection("Player Modifications")

-- Walk Speed Slider
UI:CreateSlider("Walk Speed", 16, 500, 16, function(value)
    WalkSpeed = value
    
    local function applySpeed(character)
        local humanoid = character:WaitForChild("Humanoid", 1)
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
    
    if LocalPlayer.Character then
        applySpeed(LocalPlayer.Character)
    end
    
    LocalPlayer.CharacterAdded:Connect(applySpeed)
    print("[*] Walk Speed:", value)
end)

-- Jump Power Slider
UI:CreateSlider("Jump Power", 50, 500, 50, function(value)
    JumpPower = value
    
    local function applyJump(character)
        local humanoid = character:WaitForChild("Humanoid", 1)
        if humanoid then
            humanoid.JumpPower = value
        end
    end
    
    if LocalPlayer.Character then
        applyJump(LocalPlayer.Character)
    end
    
    LocalPlayer.CharacterAdded:Connect(applyJump)
    print("[*] Jump Power:", value)
end)

-- Infinity Jump
UI:CreateToggle("Infinity Jump", false, function(state)
    InfinityJump = state
    print("[+] Infinity Jump:", state)
    
    if state then
        local jumpConnection = UserInputService.JumpRequest:Connect(function()
            if InfinityJump and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        
        -- Store connection
        UI.JumpConnection = jumpConnection
    else
        if UI.JumpConnection then
            UI.JumpConnection:Disconnect()
            UI.JumpConnection = nil
        end
    end
end)

-- Anti AFK
UI:CreateToggle("Anti AFK", false, function(state)
    AntiAFK = state
    print("[+] Anti-AFK:", state)
    
    if state then
        local function antiAFKLoop()
            while AntiAFK do
                wait(30)
                
                -- Simulate movement
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = LocalPlayer.Character.HumanoidRootPart
                    local original = root.CFrame
                    root.CFrame = original * CFrame.new(0, 0.01, 0)
                    wait(0.1)
                    root.CFrame = original
                end
            end
        end
        
        spawn(antiAFKLoop)
    end
end)

UI:CreateButton("Noclip (Toggle)", function()
    -- Noclip implementation would go here
    print("[!] Noclip feature")
end)

UI:CreateButton("Reset Character", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
        print("[✓] Character reset")
    end
end)
