-- [DYRON-V1] Fish It! Phantom UI v4.0
-- UI yang sepenuhnya transparan sampai dihover, lalu muncul seperti hantu

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Stealth fishing core (sama seperti sebelumnya)
local remotes = {
    RequestFishing = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/RequestFishingMinigameStarted"),
    ChargeRod = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/ChargeFishingRod"),
    CompleteFishing = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/FishingCompleted")
}

-- State variables
local isActive = false
local catchCount = 0
local sessionStart = tick()
local currentSpeed = 0.5
local stealthLevel = 10 -- 1-10, 10 = maximum stealth

-- Fishing execution dengan stealth
local function executeStealthFishing()
    if not isActive then return end
    
    local posArgs = {
        math.random(-100, 100),
        math.random(-100, 100),
        tick() - math.random(1, 10)
    }
    
    -- Step 1
    pcall(function()
        remotes.RequestFishing:InvokeServer(unpack(posArgs))
    end)
    
    task.wait(math.random(5, 15) / 100)
    
    -- Step 2
    pcall(function()
        remotes.ChargeRod:InvokeServer()
    end)
    
    task.wait(math.random(5, 15) / 100)
    
    -- Step 3
    pcall(function()
        remotes.CompleteFishing:FireServer()
        catchCount += 1
    end)
end

-- Main fishing loop
local fishingThread
local function startFishing()
    if fishingThread then
        coroutine.close(fishingThread)
    end
    
    fishingThread = coroutine.create(function()
        while isActive do
            executeStealthFishing()
            
            -- Dynamic delay based on stealth level
            local baseDelay = currentSpeed
            local randomFactor = math.random(80, 120) / 100
            local stealthFactor = 1 + (stealthLevel * 0.1)
            local finalDelay = (baseDelay * randomFactor * stealthFactor) / 2
            
            task.wait(math.max(0.05, finalDelay))
        end
    end)
    
    coroutine.resume(fishingThread)
end

-- PHANTOM UI SYSTEM
local phantomUI = {}
local uiVisible = false
local uiFadeTime = 0.3

function phantomUI:Create()
    -- Main container (99% transparent)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PhantomUI"
    screenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Control Panel (invisible by default)
    local controlPanel = Instance.new("Frame")
    controlPanel.Name = "ControlPanel"
    controlPanel.Size = UDim2.new(0, 250, 0, 180)
    controlPanel.Position = UDim2.new(0.02, 0, 0.7, 0)
    controlPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    controlPanel.BackgroundTransparency = 0.95 -- Hampir tak terlihat
    controlPanel.BorderSizePixel = 0
    
    -- Smooth corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = controlPanel
    
    -- Very subtle border (hanya 5% opacity)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.95
    stroke.Parent = controlPanel
    
    -- Header (transparent)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    
    local title = Instance.new("TextLabel")
    title.Text = "PHANTOM FISHING"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextTransparency = 0.9 -- Hampir tak terlihat
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Status indicator
    local statusDot = Instance.new("Frame")
    statusDot.Name = "StatusDot"
    statusDot.Size = UDim2.new(0, 10, 0, 10)
    statusDot.Position = UDim2.new(0, 10, 0, 35)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Red = inactive
    statusDot.BackgroundTransparency = 0.7
    statusDot.BorderSizePixel = 0
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = statusDot
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Text = "INACTIVE"
    statusLabel.Size = UDim2.new(1, -30, 0, 20)
    statusLabel.Position = UDim2.new(0, 25, 0, 32)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextTransparency = 0.8
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle Button (transparent)
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Text = "▶ START FISHING"
    toggleButton.Size = UDim2.new(1, -20, 0, 35)
    toggleButton.Position = UDim2.new(0, 10, 0, 60)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 13
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextTransparency = 0.7
    toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleButton.BackgroundTransparency = 0.9
    toggleButton.BorderSizePixel = 0
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    -- Speed Control
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Text = "SPEED:"
    speedLabel.Size = UDim2.new(0, 50, 0, 20)
    speedLabel.Position = UDim2.new(0, 10, 0, 105)
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 11
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    speedLabel.TextTransparency = 0.8
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local speedValue = Instance.new("TextLabel")
    speedValue.Name = "SpeedValue"
    speedValue.Text = "0.5s"
    speedValue.Size = UDim2.new(0, 40, 0, 20)
    speedValue.Position = UDim2.new(1, -50, 0, 105)
    speedValue.Font = Enum.Font.GothamBold
    speedValue.TextSize = 11
    speedValue.TextColor3 = Color3.fromRGB(0, 200, 255)
    speedValue.TextTransparency = 0.8
    speedValue.BackgroundTransparency = 1
    speedValue.TextXAlignment = Enum.TextXAlignment.Right
    
    local speedSlider = Instance.new("Frame")
    speedSlider.Name = "SpeedSlider"
    speedSlider.Size = UDim2.new(1, -100, 0, 5)
    speedSlider.Position = UDim2.new(0, 60, 0, 115)
    speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedSlider.BackgroundTransparency = 0.8
    speedSlider.BorderSizePixel = 0
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BackgroundTransparency = 0.6
    sliderFill.BorderSizePixel = 0
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = speedSlider
    
    -- Stealth Control
    local stealthLabel = Instance.new("TextLabel")
    stealthLabel.Text = "STEALTH:"
    stealthLabel.Size = UDim2.new(0, 60, 0, 20)
    stealthLabel.Position = UDim2.new(0, 10, 0, 135)
    stealthLabel.Font = Enum.Font.Gotham
    stealthLabel.TextSize = 11
    stealthLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    stealthLabel.TextTransparency = 0.8
    stealthLabel.BackgroundTransparency = 1
    stealthLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local stealthValue = Instance.new("TextLabel")
    stealthValue.Name = "StealthValue"
    stealthValue.Text = "10/10"
    stealthValue.Size = UDim2.new(0, 40, 0, 20)
    stealthValue.Position = UDim2.new(1, -50, 0, 135)
    stealthValue.Font = Enum.Font.GothamBold
    stealthValue.TextSize = 11
    stealthValue.TextColor3 = Color3.fromRGB(50, 255, 100)
    stealthValue.TextTransparency = 0.8
    stealthValue.BackgroundTransparency = 1
    stealthValue.TextXAlignment = Enum.TextXAlignment.Right
    
    local stealthSlider = Instance.new("Frame")
    stealthSlider.Name = "StealthSlider"
    stealthSlider.Size = UDim2.new(1, -100, 0, 5)
    stealthSlider.Position = UDim2.new(0, 70, 0, 145)
    stealthSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    stealthSlider.BackgroundTransparency = 0.8
    stealthSlider.BorderSizePixel = 0
    
    local stealthFill = Instance.new("Frame")
    stealthFill.Name = "StealthFill"
    stealthFill.Size = UDim2.new(1, 0, 1, 0) -- 10/10 = full
    stealthFill.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
    stealthFill.BackgroundTransparency = 0.6
    stealthFill.BorderSizePixel = 0
    
    local stealthCorner = Instance.new("UICorner")
    stealthCorner.CornerRadius = UDim.new(1, 0)
    stealthCorner.Parent = stealthSlider
    
    -- Assembly
    sliderFill.Parent = speedSlider
    stealthFill.Parent = stealthSlider
    
    header.Parent = controlPanel
    title.Parent = header
    statusDot.Parent = controlPanel
    statusLabel.Parent = controlPanel
    toggleButton.Parent = controlPanel
    speedLabel.Parent = controlPanel
    speedValue.Parent = controlPanel
    speedSlider.Parent = controlPanel
    stealthLabel.Parent = controlPanel
    stealthValue.Parent = controlPanel
    stealthSlider.Parent = controlPanel
    
    controlPanel.Parent = screenGui
    
    -- UI Fade Functions
    local function fadeIn()
        uiVisible = true
        
        local fadeInfo = TweenInfo.new(uiFadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        TweenService:Create(controlPanel, fadeInfo, {
            BackgroundTransparency = 0.7
        }):Play()
        
        TweenService:Create(stroke, fadeInfo, {
            Transparency = 0.7
        }):Play()
        
        TweenService:Create(title, fadeInfo, {
            TextTransparency = 0.3
        }):Play()
        
        TweenService:Create(statusLabel, fadeInfo, {
            TextTransparency = 0.3
        }):Play()
        
        TweenService:Create(toggleButton, fadeInfo, {
            BackgroundTransparency = 0.7,
            TextTransparency = 0.3
        }):Play()
        
        TweenService:Create(speedLabel, fadeInfo, {
            TextTransparency = 0.3
        }):Play()
        
        TweenService:Create(speedValue, fadeInfo, {
            TextTransparency = 0.3
        }):Play()
        
        TweenService:Create(stealthLabel, fadeInfo, {
            TextTransparency = 0.3
        }):Play()
        
        TweenService:Create(stealthValue, fadeInfo, {
            TextTransparency = 0.3
        }):Play()
    end
    
    local function fadeOut()
        uiVisible = false
        
        local fadeInfo = TweenInfo.new(uiFadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        TweenService:Create(controlPanel, fadeInfo, {
            BackgroundTransparency = 0.95
        }):Play()
        
        TweenService:Create(stroke, fadeInfo, {
            Transparency = 0.95
        }):Play()
        
        TweenService:Create(title, fadeInfo, {
            TextTransparency = 0.9
        }):Play()
        
        TweenService:Create(statusLabel, fadeInfo, {
            TextTransparency = 0.8
        }):Play()
        
        TweenService:Create(toggleButton, fadeInfo, {
            BackgroundTransparency = 0.9,
            TextTransparency = 0.7
        }):Play()
        
        TweenService:Create(speedLabel, fadeInfo, {
            TextTransparency = 0.8
        }):Play()
        
        TweenService:Create(speedValue, fadeInfo, {
            TextTransparency = 0.8
        }):Play()
        
        TweenService:Create(stealthLabel, fadeInfo, {
            TextTransparency = 0.8
        }):Play()
        
        TweenService:Create(stealthValue, fadeInfo, {
            TextTransparency = 0.8
        }):Play()
    end
    
    -- Hover detection
    local hoverDebounce = false
    controlPanel.MouseEnter:Connect(function()
        if hoverDebounce then return end
        hoverDebounce = true
        
        fadeIn()
        
        task.wait(0.5)
        hoverDebounce = false
    end)
    
    controlPanel.MouseLeave:Connect(function()
        if hoverDebounce then return end
        hoverDebounce = true
        
        fadeOut()
        
        task.wait(0.5)
        hoverDebounce = false
    end)
    
    -- Toggle button click
    toggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        
        if isActive then
            -- Start fishing
            toggleButton.Text = "⏸ STOP FISHING"
            statusLabel.Text = "ACTIVE"
            statusLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
            statusDot.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
            
            startFishing()
            
            -- Brief visual feedback (minimal)
            task.spawn(function()
                local originalColor = toggleButton.BackgroundColor3
                toggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                task.wait(0.1)
                toggleButton.BackgroundColor3 = originalColor
            end)
        else
            -- Stop fishing
            toggleButton.Text = "▶ START FISHING"
            statusLabel.Text = "INACTIVE"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            
            if fishingThread then
                coroutine.close(fishingThread)
                fishingThread = nil
            end
        end
    end)
    
    -- Speed slider interaction
    local speedSliderDragging = false
    speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            speedSliderDragging = true
            
            local function updateSpeed(x)
                local relativeX = math.clamp(x - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
                local ratio = relativeX / speedSlider.AbsoluteSize.X
                
                -- Convert ratio to delay (0.1s to 2s)
                currentSpeed = 0.1 + (1.9 * (1 - ratio))
                sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
                speedValue.Text = string.format("%.1fs", currentSpeed)
            end
            
            updateSpeed(input.Position.X)
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    speedSliderDragging = false
                    connection:Disconnect()
                elseif speedSliderDragging then
                    updateSpeed(input.Position.X)
                end
            end)
        end
    end)
    
    -- Stealth slider interaction
    local stealthSliderDragging = false
    stealthSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            stealthSliderDragging = true
            
            local function updateStealth(x)
                local relativeX = math.clamp(x - stealthSlider.AbsolutePosition.X, 0, stealthSlider.AbsoluteSize.X)
                local ratio = relativeX / stealthSlider.AbsoluteSize.X
                
                -- Convert ratio to stealth level (1-10)
                stealthLevel = math.floor(1 + (ratio * 9))
                stealthFill.Size = UDim2.new(ratio, 0, 1, 0)
                stealthValue.Text = string.format("%d/10", stealthLevel)
            end
            
            updateStealth(input.Position.X)
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    stealthSliderDragging = false
                    connection:Disconnect()
                elseif stealthSliderDragging then
                    updateStealth(input.Position.X)
                end
            end)
        end
    end)
    
    -- Draggable UI
    local dragging = false
    local dragStart, startPos
    
    controlPanel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = controlPanel.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            controlPanel.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Hotkey: Ctrl+Shift+P untuk toggle UI visibility
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.P then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 
               UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                
                controlPanel.Visible = not controlPanel.Visible
            end
        end
        
        -- Space untuk quick toggle fishing
        if not processed and input.KeyCode == Enum.KeyCode.Space then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                toggleButton:MouseButton1Click()
            end
        end
    end)
    
    -- Auto-fade out after 5 seconds of inactivity
    local lastInteraction = tick()
    local function recordInteraction()
        lastInteraction = tick()
        if not uiVisible then
            fadeIn()
        end
    end
    
    controlPanel.MouseEnter:Connect(recordInteraction)
    toggleButton.MouseEnter:Connect(recordInteraction)
    speedSlider.MouseEnter:Connect(recordInteraction)
    stealthSlider.MouseEnter:Connect(recordInteraction)
    
    -- Auto-fade thread
    task.spawn(function()
        while true do
            task.wait(1)
            if uiVisible and tick() - lastInteraction > 5 then
                fadeOut()
            end
        end
    end)
    
    -- Stats display (very subtle)
    local statsText = Instance.new("TextLabel")
    statsText.Name = "StatsText"
    statsText.Text = "Fish: 0"
    statsText.Size = UDim2.new(1, 0, 0, 15)
    statsText.Position = UDim2.new(0, 0, 1, 5)
    statsText.Font = Enum.Font.Gotham
    statsText.TextSize = 10
    statsText.TextColor3 = Color3.fromRGB(150, 150, 150)
    statsText.TextTransparency = 0.9
    statsText.BackgroundTransparency = 1
    statsText.TextXAlignment = Enum.TextXAlignment.Center
    statsText.Parent = controlPanel
    
    -- Update stats
    task.spawn(function()
        while true do
            task.wait(2)
            if uiVisible then
                local sessionTime = tick() - sessionStart
                local fps = catchCount / math.max(1, sessionTime)
                statsText.Text = string.format("Fish: %d | %.1f/s", catchCount, fps)
            end
        end
    end)
    
    -- Initial fade out
    task.wait(1)
    fadeOut()
    
    return {
        GUI = screenGui,
        ToggleVisibility = function()
            controlPanel.Visible = not controlPanel.Visible
        end,
        SetActive = function(state)
            isActive = state
            toggleButton:MouseButton1Click()
        end
    }
end

-- Initialize
local ui = phantomUI:Create()

-- Minimal startup notification (hanya di output)
print("========================================")
print("PHANTOM FISHING UI v4.0")
print("Controls:")
print("  - Hover over invisible panel to reveal")
print("  - Ctrl+Shift+P: Toggle UI visibility")
print("  - Ctrl+Space: Quick start/stop")
print("  - UI auto-fades after 5s inactivity")
print("========================================")

-- Anti-AFK (silent)
task.spawn(function()
    while true do
        task.wait(58)
        if isActive then
            pcall(function()
                local virtualInput = game:GetService("VirtualInputManager")
                virtualInput:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
                task.wait(0.05)
                virtualInput:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
            end)
        end
    end
end)

-- Error suppression
pcall(function()
    game:GetService("ScriptContext").Error:Connect(function() end)
end)
