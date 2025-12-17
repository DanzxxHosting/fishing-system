local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumWindow"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame utama window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- Gradiasi untuk efek premium
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Efek shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://5554236805"
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23, 23, 277, 277)
shadow.Size = UDim2.new(1, 50, 1, 50)
shadow.Position = UDim2.new(0, -25, 0, -25)
shadow.BackgroundTransparency = 1
shadow.ImageTransparency = 0.5
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Header/title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0

-- Gradiasi title bar
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
})
titleGradient.Parent = titleBar

-- Judul window
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Premium Window"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Icon judul
local icon = Instance.new("ImageLabel")
icon.Name = "Icon"
icon.Size = UDim2.new(0, 20, 0, 20)
icon.Position = UDim2.new(0, 10, 0.5, -10)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://6031302931" -- Icon bintang premium
icon.ImageColor3 = Color3.fromRGB(255, 215, 0)

-- Container untuk tombol window control
local windowControls = Instance.new("Frame")
windowControls.Name = "WindowControls"
windowControls.Size = UDim2.new(0, 90, 1, 0)
windowControls.Position = UDim2.new(1, -90, 0, 0)
windowControls.BackgroundTransparency = 1

-- Tombol Minimize
local minimizeButton = Instance.new("ImageButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimizeButton.BorderSizePixel = 0
minimizeButton.Image = "rbxassetid://6031302931" -- Ikon minus
minimizeButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
minimizeButton.ScaleType = Enum.ScaleType.Fit

-- Efek hover untuk tombol minimize
local minimizeHover = Instance.new("Frame")
minimizeHover.Name = "Hover"
minimizeHover.Size = UDim2.new(1, 0, 1, 0)
minimizeHover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeHover.BackgroundTransparency = 0.9
minimizeHover.Visible = false
minimizeHover.Parent = minimizeButton

-- Tombol Maximize/Restore
local maximizeButton = Instance.new("ImageButton")
maximizeButton.Name = "MaximizeButton"
maximizeButton.Size = UDim2.new(0, 30, 1, 0)
maximizeButton.Position = UDim2.new(0, 30, 0, 0)
maximizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
maximizeButton.BorderSizePixel = 0
maximizeButton.Image = "rbxassetid://6031302931" -- Ikon kotak
maximizeButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
maximizeButton.ScaleType = Enum.ScaleType.Fit

-- Efek hover untuk tombol maximize
local maximizeHover = Instance.new("Frame")
maximizeHover.Name = "Hover"
maximizeHover.Size = UDim2.new(1, 0, 1, 0)
maximizeHover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
maximizeHover.BackgroundTransparency = 0.9
maximizeHover.Visible = false
maximizeHover.Parent = maximizeButton

-- Tombol Close
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(0, 60, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
closeButton.BorderSizePixel = 0
closeButton.Image = "rbxassetid://6031302931" -- Ikon X
closeButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
closeButton.ScaleType = Enum.ScaleType.Fit

-- Efek hover untuk tombol close
local closeHover = Instance.new("Frame")
closeHover.Name = "Hover"
closeHover.Size = UDim2.new(1, 0, 1, 0)
closeHover.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeHover.BackgroundTransparency = 0.9
closeHover.Visible = false
closeHover.Parent = closeButton

-- Content area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
contentFrame.BorderSizePixel = 0

-- Sample content
local sampleLabel = Instance.new("TextLabel")
sampleLabel.Name = "SampleText"
sampleLabel.Size = UDim2.new(1, -40, 0, 100)
sampleLabel.Position = UDim2.new(0, 20, 0, 20)
sampleLabel.BackgroundTransparency = 1
sampleLabel.Text = "Premium Window Content\n\nThis window has minimize and maximize functionality with smooth animations."
sampleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
sampleLabel.Font = Enum.Font.Gotham
sampleLabel.TextSize = 16
sampleLabel.TextXAlignment = Enum.TextXAlignment.Left
sampleLabel.TextYAlignment = Enum.TextYAlignment.Top
sampleLabel.TextWrapped = true

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Name = "StatusBar"
statusBar.Size = UDim2.new(1, 0, 0, 25)
statusBar.Position = UDim2.new(0, 0, 1, -25)
statusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
statusBar.BorderSizePixel = 0

local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0, 10, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Ready"
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 12
statusText.TextXAlignment = Enum.TextXAlignment.Left

-- Variabel state
local isMinimized = false
local isMaximized = false
local originalSize = mainFrame.Size
local originalPosition = mainFrame.Position
local minimizedPosition = UDim2.new(1, -100, 1, -50)

-- Parent semua elemen
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
windowControls.Parent = titleBar
icon.Parent = titleBar
titleLabel.Parent = titleBar
minimizeButton.Parent = windowControls
maximizeButton.Parent = windowControls
closeButton.Parent = windowControls
titleBar.Parent = mainFrame
contentFrame.Parent = mainFrame
sampleLabel.Parent = contentFrame
statusBar.Parent = contentFrame
statusText.Parent = statusBar
mainFrame.Parent = screenGui

-- Fungsi untuk drag window
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
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

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Fungsi animasi
local function createTween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    return tween
end

-- Fungsi minimize
local function minimizeWindow()
    if isMinimized then return end
    
    isMinimized = true
    statusText.Text = "Minimized"
    
    local tween = createTween(mainFrame, {
        Size = UDim2.new(0, 200, 0, 40),
        Position = minimizedPosition
    }, 0.3)
    
    contentFrame.Visible = false
    tween:Play()
end

-- Fungsi restore dari minimize
local function restoreWindow()
    if not isMinimized then return end
    
    isMinimized = false
    statusText.Text = "Restored"
    
    local tween = createTween(mainFrame, {
        Size = isMaximized and UDim2.new(1, -40, 1, -40) or originalSize,
        Position = isMaximized and UDim2.new(0, 20, 0, 20) or originalPosition
    }, 0.3)
    
    tween.Completed:Connect(function()
        contentFrame.Visible = true
    end)
    
    tween:Play()
end

-- Fungsi maximize
local function maximizeWindow()
    if isMaximized then return end
    
    isMaximized = true
    statusText.Text = "Maximized"
    
    local tween = createTween(mainFrame, {
        Size = UDim2.new(1, -40, 1, -40),
        Position = UDim2.new(0, 20, 0, 20)
    }, 0.3)
    
    tween:Play()
end

-- Fungsi restore dari maximize
local function restoreFromMaximize()
    if not isMaximized then return end
    
    isMaximized = false
    statusText.Text = "Restored"
    
    local tween = createTween(mainFrame, {
        Size = originalSize,
        Position = originalPosition
    }, 0.3)
    
    tween:Play()
end

-- Fungsi toggle maximize
local function toggleMaximize()
    if isMaximized then
        restoreFromMaximize()
    else
        maximizeWindow()
    end
end

-- Event handlers untuk tombol
minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        restoreWindow()
    else
        minimizeWindow()
    end
end)

maximizeButton.MouseButton1Click:Connect(function()
    toggleMaximize()
end)

closeButton.MouseButton1Click:Connect(function()
    -- Animasi fade out sebelum menutup
    local fadeTween = createTween(mainFrame, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, 0.3)
    
    fadeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
    
    fadeTween:Play()
end)

-- Efek hover untuk tombol
local function setupButtonHover(button, hoverFrame, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        hoverFrame.Visible = true
        local tween = createTween(hoverFrame, {BackgroundTransparency = 0.7}, 0.2)
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = createTween(hoverFrame, {BackgroundTransparency = 0.9}, 0.2)
        tween.Completed:Connect(function()
            hoverFrame.Visible = false
        end)
        tween:Play()
    end)
end

-- Setup efek hover
setupButtonHover(minimizeButton, minimizeHover)
setupButtonHover(maximizeButton, maximizeHover)
setupButtonHover(closeButton, closeHover)

-- Tambahkan animasi masuk
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local entranceTween = createTween(mainFrame, {
    Size = originalSize,
    Position = originalPosition
}, 0.5)

entranceTween:Play()
