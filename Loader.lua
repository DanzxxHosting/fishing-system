-- FishingSystem.Loader.lua
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Wait for character
if not Player.Character then
    Player.CharacterAdded:Wait()
end

wait(2) -- Additional loading time

-- Load Libraries
local function LoadLibrary(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("Failed to load library from: " .. url)
        return nil
    end
    
    return result
end

print("📦 Loading Fishing System...")

-- Create notification
local Notification = Instance.new("ScreenGui")
Notification.Name = "LoadingNotification"
Notification.Parent = Player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Frame.Parent = Notification

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🎣 Fishing Script V3.4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 0, 60)
LoadingText.Position = UDim2.new(0, 0, 0, 50)
LoadingText.Text = "Loading modules..."
LoadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingText.Font = Enum.Font.Gotham
LoadingText.TextSize = 16
LoadingText.Parent = Frame

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 0, 10)
ProgressBar.Position = UDim2.new(0, 10, 0, 120)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProgressBar.Parent = Frame

local ProgressBack = Instance.new("Frame")
ProgressBack.Size = UDim2.new(1, -20, 0, 10)
ProgressBack.Position = UDim2.new(0, 10, 0, 120)
ProgressBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ProgressBack.Parent = Frame
ProgressBar.Parent = ProgressBack

-- Update loading progress
local function UpdateProgress(step, total, message)
    local percent = step / total
    ProgressBar.Size = UDim2.new(percent, 0, 1, 0)
    LoadingText.Text = message
    
    wait(0.1)
end

-- Load steps
local loadSteps = {
    "Initializing system...",
    "Loading UI library...",
    "Loading fishing module...",
    "Setting up interfaces...",
    "Finalizing..."
}

for i, step in ipairs(loadSteps) do
    UpdateProgress(i, #loadSteps, step)
end

-- Load main system
local success, err = pcall(function()
    -- Load Fishing Module
    local FishingModule = require(script.Parent.Fishing)
    
    -- Load UI
    local UIScript = script.Parent.UI
    UIScript.Enabled = true
    
    -- Hide loading screen
    wait(1)
    Notification:Destroy()
    
    -- Play sound effect
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://9125326374" -- Success sound
    Sound.Volume = 0.5
    Sound.Parent = Player.PlayerGui
    Sound:Play()
    
    print("✅ Fishing System loaded successfully!")
    
    -- Welcome message
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎣 Fishing Script V3.4",
        Text = "Loaded successfully! Press RightControl to open UI.",
        Duration = 5,
        Icon = "http://www.roblox.com/asset/?id=6031075938"
    })
end)

if not success then
    -- Show error
    LoadingText.Text = "Error: " .. err
    LoadingText.TextColor3 = Color3.fromRGB(255, 50, 50)
    
    warn("❌ Failed to load Fishing System: " .. err)
    
    -- Retry button
    local RetryButton = Instance.new("TextButton")
    RetryButton.Size = UDim2.new(0, 100, 0, 30)
    RetryButton.Position = UDim2.new(0.5, -50, 0, 100)
    RetryButton.Text = "Retry"
    RetryButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    RetryButton.TextColor3 = Color3.new(1, 1, 1)
    RetryButton.Parent = Frame
    
    RetryButton.MouseButton1Click:Connect(function()
        RetryButton:Destroy()
        script.Disabled = true
        wait(0.1)
        script.Disabled = false
    end)
end

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("🔧 Anti-AFK enabled")