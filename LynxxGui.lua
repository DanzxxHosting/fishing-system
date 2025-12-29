-- [DYRON-V1] Fish It! Remote-Specific Bruteforce
-- Tidak perlu animasi, tidak perlu menunggu, langsung spam complete

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Cari network package
local netPackage = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- Remote references
local RequestFishingMinigameStarted = netPackage:WaitForChild("RF/RequestFishingMinigameStarted")
local ChargeFishingRod = netPackage:WaitForChild("RF/ChargeFishingRod")
local FishingCompleted = netPackage:WaitForChild("RE/FishingCompleted")

-- KILL ANIMATIONS & OPTIMIZE
local function nukeVisuals()
    -- Kill semua animasi character
    local humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
    
    -- Destroy fishing UI jika ada
    local gui = player:FindFirstChild("PlayerGui")
    if gui then
        for _, v in pairs({"FishingUI", "FishingMinigame", "FishingProgress"}) do
            local ui = gui:FindFirstChild(v)
            if ui then ui:Destroy() end
        end
    end
    
    -- Disable AFK detection
    for _, conn in pairs(getconnections(player.Idled)) do
        conn:Disable()
    end
end

-- EXPLOIT CORE: INSTANT FISHING LOOP
local catchCount = 0
local lastCatchTime = tick()

spawn(function()
    while true do
        nukeVisuals()
        
        -- AMBIL POSISI MOUSE (atau random position untuk hindari pattern)
        local hitPos = mouse.Hit.Position
        local randomOffset = Vector3.new(
            math.random(-5, 5),
            0,
            math.random(-5, 5)
        )
        local fishingPos = hitPos + randomOffset
        
        -- GENERATE ARGUMEN DENGAN SPOOFED TIMESTAMP
        local spoofedTime = tick() - math.random(1, 10) -- Timestamp masa lalu untuk bypass cooldown
        
        local args = {
            fishingPos.X,  -- X position
            fishingPos.Z,  -- Y position (mungkin Z, bukan Y)
            spoofedTime    -- Spoofed timestamp
        }
        
        -- EXECUTE SEQUENCE DENGAN RATE LIMIT BYPASS
        -- Step 1: Request minigame (langsung invoke tanpa delay)
        pcall(function()
            RequestFishingMinigameStarted:InvokeServer(unpack(args))
        end)
        
        -- Step 2: Charge rod (langsung invoke)
        pcall(function()
            ChargeFishingRod:InvokeServer()
        end)
        
        -- Step 3: Complete fishing (FIRE SERVER - ini yang beri reward)
        pcall(function()
            FishingCompleted:FireServer()
            catchCount += 1
            
            -- Visual feedback brutal
            if tick() - lastCatchTime > 1 then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "DYRON FISHING BOT",
                    Text = string.format("Caught: %d fish | %.1f fish/sec", catchCount, catchCount/(tick()-lastCatchTime)),
                    Duration = 0.5,
                    Icon = "rbxassetid://0"
                })
                lastCatchTime = tick()
            end
        end)
        
        -- ADAPTIVE DELAY: Mulai cepat, turunkan jika error
        local currentDelay = 0.95 -- 20 fish per second default
        
        -- Deteksi rate limit (jika ada error)
        local success, errorMsg = pcall(function()
            FishingCompleted:FireServer()
        end)
        
        if not success then
            if string.find(errorMsg:lower(), "rate") or string.find(errorMsg:lower(), "wait") then
                currentDelay = math.min(currentDelay * 2, 2) -- Double delay, max 2 detik
                warn("[RATE LIMIT DETECTED] Increasing delay to:", currentDelay)
            end
        end
        
        task.wait(currentDelay)
    end
end)

-- UI BRUTAL MONITOR
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DyronFishBot"
screenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = string.format("DYRON FISHING EXPLOIT ACTIVE\n\nCatch Count: %d\nStatus: MAXIMUM OVERDRIVE\n\nTarget: Fish It!\nMethod: Remote Spam", catchCount)
label.TextColor3 = Color3.fromRGB(255, 50, 50)
label.TextScaled = true
label.Font = Enum.Font.Code
label.BackgroundTransparency = 1
label.Parent = frame

-- Update counter
spawn(function()
    while task.wait(0.1) do
        label.Text = string.format("DYRON FISHING EXPLOIT ACTIVE\n\nCatch Count: %d\nRate: %.1f fish/sec\n\nTarget: Fish It!\nMethod: Remote Sequence Bypass", 
            catchCount, 
            catchCount/(tick()-lastCatchTime)
        )
    end
end)

-- ANTI-AFK EXTREME
local virtualInput = game:GetService("VirtualInputManager")
spawn(function()
    while task.wait(60) do
        -- Simulate minimal movement setiap menit
        virtualInput:SendMouseMoveEvent(100, 100)
        virtualInput:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
        task.wait(0.1)
        virtualInput:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
    end
end)

warn("[DYRON EXPLOIT LOADED] Fishing sequence bypass active. Server will be flooded.")
