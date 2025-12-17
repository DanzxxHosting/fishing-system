--====================================================
-- FISHING HUB - CLIENT ONLY (FIXED)
-- Features:
-- 1. Skip Minigame (WORKING)
-- 2. Instant Fishing (STATE-BASED)
--====================================================

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Controllers
local Controllers = game.ReplicatedStorage:WaitForChild("Controllers")
local FishingController = require(Controllers:WaitForChild("FishingController"))

--====================================================
-- STATE
--====================================================
local State = {
    SkipMinigame = false,
    InstantFishing = false,
    Busy = false
}

--====================================================
-- UI
--====================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FishingHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.45, 0.48)
main.Position = UDim2.fromScale(0.275, 0.26)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

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

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-30,1,-65)
content.Position = UDim2.new(0,15,0,55)
content.BackgroundTransparency = 1

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

makeToggle("Skip Minigame", 0, function(v)
    State.SkipMinigame = v
end)

makeToggle("Instant Fishing", 52, function(v)
    State.InstantFishing = v
end)

--====================================================
-- CORE LOGIC
--====================================================

-- EVENT-BASED COMPLETE (AMAN)
if FishingController.FishingMinigameChanged then
    FishingController.FishingMinigameChanged:Connect(function(state)
        if (State.SkipMinigame or State.InstantFishing) and state == "Started" then
            task.wait(0.05)
            pcall(function()
                FishingController.CompleteFishing()
            end)
            State.Busy = false
        end
    end)
end

-- INSTANT FISHING LOOP (STATE-DRIVEN)
task.spawn(function()
    while task.wait(0.3) do
        if State.InstantFishing and not State.Busy then
            State.Busy = true

            pcall(function()
                -- STEP 1: Start fishing
                if FishingController.StartFishing then
                    FishingController.StartFishing()
                end

                -- STEP 2: FORCE minigame path
                if FishingController.BeginMinigame then
                    FishingController.BeginMinigame()
                end
            end)

            -- FAILSAFE reset
            task.delay(2, function()
                State.Busy = false
            end)
        end
    end
end)

print("[FishingHub] Loaded (FIXED)")
print("[FishingHub] Instant Fishing uses STATE flow")

