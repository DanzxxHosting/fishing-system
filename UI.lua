--====================================================
-- FISHING HUB - CLIENT ONLY
-- Features:
-- 1. Skip Minigame (Perfect Catch)
-- 2. Instant Fishing
--====================================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Controllers
local Controllers = game.ReplicatedStorage:WaitForChild("Controllers")
local FishingController = require(Controllers:WaitForChild("FishingController"))

local AutoFishingController = Controllers:FindFirstChild("AutoFishingController")
AutoFishingController = AutoFishingController and require(AutoFishingController)

--====================================================
-- STATE
--====================================================
local State = {
    SkipMinigame = false,
    InstantFishing = false
}

--====================================================
-- UI
--====================================================
local gui = Instance.new("ScreenGui")
gui.Name = "FishingHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromScale(0.45, 0.48)
main.Position = UDim2.fromScale(0.275, 0.26)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,45)
header.BackgroundColor3 = Color3.fromRGB(20,20,20)
header.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "FISHING HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,60,60)

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0,45,1,0)
close.Position = UDim2.new(1,-45,0,0)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(255,80,80)
close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Content
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-30,1,-65)
content.Position = UDim2.new(0,15,0,55)
content.BackgroundTransparency = 1

-- Toggle creator
local function makeToggle(text, y, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1,0,0,42)
    btn.Position = UDim2.new(0,0,0,y)
    btn.Text = text .. " : OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = text .. (on and " : ON" or " : OFF")
        btn.BackgroundColor3 = on and Color3.fromRGB(90,25,25) or Color3.fromRGB(30,30,30)
        callback(on)
    end)
end

-- Toggles
makeToggle("Skip Minigame (Perfect Catch)", 0, function(v)
    State.SkipMinigame = v
end)

makeToggle("Instant Fishing", 52, function(v)
    State.InstantFishing = v
end)

--====================================================
-- CORE FEATURE 1: SKIP MINIGAME
--====================================================
task.spawn(function()
    while task.wait() do
        if State.SkipMinigame then
            pcall(function()
                if FishingController.SetMinigameResult then
                    FishingController.SetMinigameResult(true)
                end
                if FishingController.CompleteFishing then
                    FishingController.CompleteFishing()
                end
            end)
        end
    end
end)

if FishingController.FishingMinigameChanged then
    FishingController.FishingMinigameChanged:Connect(function(state)
        if State.SkipMinigame and (state == "Started" or state == true) then
            task.wait(0.05)
            pcall(function()
                FishingController.CompleteFishing()
            end)
        end
    end)
end

--====================================================
-- CORE FEATURE 2: INSTANT FISHING
--====================================================
task.spawn(function()
    while task.wait(0.2) do
        if State.InstantFishing then
            pcall(function()
                -- Start fishing
                if FishingController.StartFishing then
                    FishingController.StartFishing()
                elseif AutoFishingController and AutoFishingController.Start then
                    AutoFishingController.Start()
                end

                -- Instantly complete
                if FishingController.SetMinigameResult then
                    FishingController.SetMinigameResult(true)
                end
                if FishingController.CompleteFishing then
                    FishingController.CompleteFishing()
                end
            end)
        end
    end
end)

--====================================================
-- LOG
--====================================================
print("[FishingHub] Loaded")
print("[FishingHub] Skip Minigame + Instant Fishing ready")

