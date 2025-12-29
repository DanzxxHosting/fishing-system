-- [DYRON-V1] Fish It! Instant UI v5.0
-- UI langsung muncul saat execute, tetap stealth-designed

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Get remotes
local remotes = {
    RequestFishing = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/RequestFishingMinigameStarted"),
    ChargeRod = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/ChargeFishingRod"),
    CompleteFishing = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/FishingCompleted")
}

-- State
local isActive = false
local catchCount = 0
local sessionStart = tick()
local currentSpeed = 0.5
local stealthLevel = 8
local fishingThread

-- Fishing execution
local function executeFishing()
    if not isActive then return end
    
    local posArgs = {
        math.random(-100, 100),
        math.random(-100, 100),
        tick() - math.random(1, 10)
    }
    
    pcall(function() remotes.RequestFishing:InvokeServer(unpack(posArgs)) end)
    task.wait(math.random(5, 15) / 100)
    
    pcall(function() remotes.ChargeRod:InvokeServer() end)
    task.wait(math.random(5, 15) / 100)
    
    pcall(function() 
        remotes.CompleteFishing:FireServer()
        catchCount += 1
    end)
end

-- Start fishing loop
local function startFishingLoop()
    if fishingThread then
        coroutine.close(fishingThread)
    end
    
    fishingThread = coroutine.create(function()
        while isActive do
            executeFishing()
            
            local baseDelay = currentSpeed
            local randomFactor = math.random(80, 120) / 100
            local stealthFactor = 1 + (stealthLevel * 0.1)
            local finalDelay = (baseDelay * randomFactor * stealthFactor) / 2
            
            task.wait(math.max(0.05, finalDelay))
        end
    end)
    
    coroutine.resume(fishingThread)
end

-- Create UI that appears immediately
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DyronInstantUI"
screenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Container (Visible immediately)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100) -- Center screen
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.15 -- Visible but dark
mainFrame.BorderSizePixel = 0

-- Glass effect
local blur = Instance.new("BlurEffect")
blur.Size = 8
blur.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(0, 30, 60)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Text = "DYRON FISHING BOT"
title.Size = UDim2.new(1, 0, 1, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.BackgroundTransparency = 1

local subtitle = Instance.new("TextLabel")
subtitle.Text = "v5.0 - Instant UI"
subtitle.Size = UDim2.new(1, 0, 0, 15)
subtitle.Position = UDim2.new(0, 0, 1, -15)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
subtitle.BackgroundTransparency = 1

-- Status Display
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -20, 0, 25)
statusFrame.Position = UDim2.new(0, 10, 0, 40)
statusFrame.BackgroundTransparency = 1

local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 12, 0, 12)
statusDot.Position = UDim2.new(0, 0, 0.5, -6)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
statusDot.BorderSizePixel = 0

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Text = "READY TO FISH"
statusLabel.Size = UDim2.new(1, -20, 1, 0)
statusLabel.Position = UDim2.new(0, 20, 0, 0)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Main Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Text = "▶ START FISHING"
toggleButton.Size = UDim2.new(1, -20, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 75)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 15
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleButton.AutoButtonColor = false

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Control Panel
local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.new(1, -20, 0, 70)
controlFrame.Position = UDim2.new(0, 10, 0, 125)
controlFrame.BackgroundTransparency = 1

-- Speed Control
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "SPEED:"
speedLabel.Size = UDim2.new(0, 50, 0, 20)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedValue = Instance.new("TextLabel")
speedValue.Name = "SpeedValue"
speedValue.Text = "0.5s"
speedValue.Size = UDim2.new(0, 40, 0, 20)
speedValue.Position = UDim2.new(1, -40, 0, 0)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextSize = 12
speedValue.TextColor3 = Color3.fromRGB(0, 200, 255)
speedValue.BackgroundTransparency = 1
speedValue.TextXAlignment = Enum.TextXAlignment.Right

local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Size = UDim2.new(1, -100, 0, 6)
speedSlider.Position = UDim2.new(0, 60, 0, 7)
speedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedSlider.BorderSizePixel = 0

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderFill.BorderSizePixel = 0

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = speedSlider

-- Stealth Control
local stealthLabel = Instance.new("TextLabel")
stealthLabel.Text = "STEALTH:"
stealthLabel.Size = UDim2.new(0, 60, 0, 20)
stealthLabel.Position = UDim2.new(0, 0, 0, 30)
stealthLabel.Font = Enum.Font.Gotham
stealthLabel.TextSize = 12
stealthLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
stealthLabel.BackgroundTransparency = 1
stealthLabel.TextXAlignment = Enum.TextXAlignment.Left

local stealthValue = Instance.new("TextLabel")
stealthValue.Name = "StealthValue"
stealthValue.Text = "8/10"
stealthValue.Size = UDim2.new(0, 40, 0, 20)
stealthValue.Position = UDim2.new(1, -40, 0, 30)
stealthValue.Font = Enum.Font.GothamBold
stealthValue.TextSize = 12
stealthValue.TextColor3 = Color3.fromRGB(50, 255, 100)
stealthValue.BackgroundTransparency = 1
stealthValue.TextXAlignment = Enum.TextXAlignment.Right

local stealthSlider = Instance.new("Frame")
stealthSlider.Name = "StealthSlider"
stealthSlider.Size = UDim2.new(1, -100, 0, 6)
stealthSlider.Position = UDim2.new(0, 70, 0, 37)
stealthSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
stealthSlider.BorderSizePixel = 0

local stealthFill = Instance.new("Frame")
stealthFill.Name = "StealthFill"
stealthFill.Size = UDim2.new(0.8, 0, 1, 0) -- 8/10 = 0.8
stealthFill.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
stealthFill.BorderSizePixel = 0

local stealthCorner = Instance.new("UICorner")
stealthCorner.CornerRadius = UDim.new(1, 0)
stealthCorner.Parent = stealthSlider

-- Assembly
sliderFill.Parent = speedSlider
stealthFill.Parent = stealthSlider

header.Parent = mainFrame
title.Parent = header
subtitle.Parent = header
statusFrame.Parent = mainFrame
statusDot.Parent = statusFrame
statusLabel.Parent = statusFrame
toggleButton.Parent = mainFrame
controlFrame.Parent = mainFrame

speedLabel.Parent = controlFrame
speedValue.Parent = controlFrame
speedSlider.Parent = controlFrame

stealthLabel.Parent = controlFrame
stealthValue.Parent = controlFrame
stealthSlider.Parent = controlFrame

mainFrame.Parent = screenGui

-- Draggable UI
local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
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
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Close button (small X in corner)
local closeButton = Instance.new("TextButton")
closeButton.Text = "×"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 1
closeButton.Parent = header

closeButton.MouseButton1Click:Connect(function()
    -- Fade out animation before closing
    local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 1,
        Position = mainFrame.Position + UDim2.new(0, 0, 0, 50)
    })
    
    fadeOut:Play()
    fadeOut.Completed:Wait()
    screenGui:Destroy()
end)

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    if isActive then
        -- Start fishing
        toggleButton.Text = "⏸ STOP FISHING"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        statusLabel.Text = "FISHING..."
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
        statusDot.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
        
        startFishingLoop()
        
        -- Button click animation
        local clickAnim = TweenService:Create(toggleButton, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(30, 180, 30)
        })
        clickAnim:Play()
        clickAnim.Completed:Wait()
        
        TweenService:Create(toggleButton, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        }):Play()
    else
        -- Stop fishing
        toggleButton.Text = "▶ START FISHING"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "READY TO FISH"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        if fishingThread then
            coroutine.close(fishingThread)
            fishingThread = nil
        end
    end
end)

-- Speed slider interaction
speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local function updateSpeed(x)
            local relativeX = math.clamp(x - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
            local ratio = relativeX / speedSlider.AbsoluteSize.X
            
            currentSpeed = 0.1 + (1.9 * (1 - ratio))
            sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
            speedValue.Text = string.format("%.1fs", currentSpeed)
        end
        
        updateSpeed(input.Position.X)
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                connection:Disconnect()
            else
                updateSpeed(input.Position.X)
            end
        end)
    end
end)

-- Stealth slider interaction
stealthSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local function updateStealth(x)
            local relativeX = math.clamp(x - stealthSlider.AbsolutePosition.X, 0, stealthSlider.AbsoluteSize.X)
            local ratio = relativeX / stealthSlider.AbsoluteSize.X
            
            stealthLevel = math.floor(1 + (ratio * 9))
            stealthFill.Size = UDim2.new(ratio, 0, 1, 0)
            stealthValue.Text = string.format("%d/10", stealthLevel)
        end
        
        updateStealth(input.Position.X)
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                connection:Disconnect()
            else
                updateStealth(input.Position.X)
            end
        end)
    end
end)

-- Stats display at bottom
local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "StatsLabel"
statsLabel.Text = "Fish: 0 | 0.0/s"
statsLabel.Size = UDim2.new(1, -20, 0, 20)
statsLabel.Position = UDim2.new(0, 10, 1, -25)
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 11
statsLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
statsLabel.BackgroundTransparency = 1
statsLabel.TextXAlignment = Enum.TextXAlignment.Center
statsLabel.Parent = mainFrame

-- Update stats
task.spawn(function()
    while true do
        task.wait(1)
        if statsLabel then
            local sessionTime = tick() - sessionStart
            local fishPerSec = catchCount / math.max(1, sessionTime)
            statsLabel.Text = string.format("Fish: %d | %.1f/s", catchCount, fishPerSec)
        end
    end
end)

-- Entry animation
mainFrame.BackgroundTransparency = 1
mainFrame.Position = mainFrame.Position + UDim2.new(0, 0, 0, 50)

task.wait(0.1)

local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.15,
    Position = mainFrame.Position - UDim2.new(0, 0, 0, 50)
})

fadeIn:Play()

-- Anti-AFK
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

-- Hover effects for buttons
toggleButton.MouseEnter:Connect(function()
    if not isActive then
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(220, 70, 70)
        }):Play()
    else
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(70, 220, 70)
        }):Play()
    end
end)

toggleButton.MouseLeave:Connect(function()
    if not isActive then
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        }):Play()
    else
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        }):Play()
    end
end)

-- Close button hover
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(255, 150, 150)
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(255, 100, 100)
    }):Play()
end)

-- Error suppression
pcall(function()
    game:GetService("ScriptContext").Error:Connect(function() end)
end)

print("[DYRON] Instant UI loaded successfully!")
print("UI is now visible on screen.")
print("Drag to move, click X to close.")