--====================================================
-- FISHING HUB - CLIENT ONLY
-- Feature: Skip Minigame / Perfect Catch
-- UI: Premium Black + Red
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
    SkipMinigame = false
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
main.Size = UDim2.fromScale(0.45, 0.45)
main.Position = UDim2.fromScale(0.275, 0.28)
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

-- Close
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

-- Toggle Button Creator
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

-- Toggle: Skip Minigame
makeToggle("Skip Minigame (Perfect Catch)", 0, function(v)
    State.SkipMinigame = v
end)

--====================================================
-- CORE FEATURE: SKIP MINIGAME
--====================================================

-- Loop-based fallback (safe)
task.spawn(function()
    while task.wait() do
        if State.SkipMinigame then
            pcall(function()
                if FishingController.CompleteFishing then
                    FishingController.CompleteFishing()
                end
                if FishingController.SetMinigameResult then
                    FishingController.SetMinigameResult(true)
                end
            end)
        end
    end
end)

-- Event-based (if available)
if FishingController.FishingMinigameChanged then
    FishingController.FishingMinigameChanged:Connect(function(state)
        if State.SkipMinigame and (state == "Started" or state == true) then
            task.wait(0.1)
            pcall(function()
                FishingController.CompleteFishing()
            end)
        end
    end)
end

--====================================================
-- INFO LOG
--====================================================
print("[FishingHub] Loaded")
print("[FishingHub] Skip Minigame ready")

