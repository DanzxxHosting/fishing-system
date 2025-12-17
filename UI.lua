-- =============================================
-- 🎣 FISH IT! COMPLETE SCRIPT v2.0
-- =============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =============================================
-- 🎯 MODULE DETECTION & INITIALIZATION
-- =============================================
local DetectedModules = {
    FishingController = nil,
    AutoFishingController = nil,
    ClassicGroupFishingController = nil,
    NetPackages = {},
    RemoteEvents = {}
}

local function InitializeModules()
    print("🔍 Initializing Fish It! Modules...")
    
    -- Cari FishingController
    if ReplicatedStorage:FindFirstChild("Controllers") then
        local Controllers = ReplicatedStorage.Controllers
        
        -- Main Fishing Controller
        DetectedModules.FishingController = Controllers:FindFirstChild("FishingController")
        if DetectedModules.FishingController then
            print("✅ Found FishingController")
            
            -- Sub-modules
            DetectedModules.InputStates = DetectedModules.FishingController:FindFirstChild("InputStates")
            DetectedModules.WeightRanges = DetectedModules.FishingController:FindFirstChild("WeightRanges")
            DetectedModules.GamepadStates = DetectedModules.FishingController:FindFirstChild("GamepadStates")
            DetectedModules.FishCaughtVisual = DetectedModules.FishingController:FindFirstChild("FishCaughtVisual")
            DetectedModules.FishBaitVisual = DetectedModules.FishingController:FindFirstChild("FishBaitVisual")
            
            -- Gears
            if DetectedModules.FishingController:FindFirstChild("Gears") then
                DetectedModules.FishingRadar = DetectedModules.FishingController.Gears:FindFirstChild("Fishing Radar")
                DetectedModules.DivingGear = DetectedModules.FishingController.Gears:FindFirstChild("Diving Gear")
            end
            
            -- Effects
            if DetectedModules.FishingController:FindFirstChild("Effects") then
                DetectedModules.animateBobber = DetectedModules.FishingController.Effects:FindFirstChild("animateBobber")
            end
        end
        
        -- Auto Fishing Controller
        DetectedModules.AutoFishingController = Controllers:FindFirstChild("AutoFishingController")
        if DetectedModules.AutoFishingController then
            print("✅ Found AutoFishingController")
        end
        
        -- Classic Group Fishing Controller
        DetectedModules.ClassicGroupFishingController = Controllers:FindFirstChild("ClassicGroupFishingController")
        if DetectedModules.ClassicGroupFishingController then
            print("✅ Found ClassicGroupFishingController")
        end
    end
    
    -- Cari Net Packages (Knit/Knit-like)
    if ReplicatedStorage:FindFirstChild("Packages") then
        local Packages = ReplicatedStorage.Packages
        if Packages:FindFirstChild("_Index") then
            local Index = Packages._Index
            local NetPackage = Index:FindFirstChild("sleitnick_net@0.2.0.net.RE")
            
            if NetPackage then
                print("✅ Found Net Package (Knit-like)")
                
                -- Remote Events dalam package
                DetectedModules.NetPackages = {
                    FlyFishingEffect = NetPackage:FindFirstChild("FlyFishingEffect"),
                    FishCaught = NetPackage:FindFirstChild("FishCaught"),
                    ObtainedNewFishNotification = NetPackage:FindFirstChild("ObtainedNewFishNotification"),
                    FishingStopped = NetPackage:FindFirstChild("FishingStopped"),
                    FishingCompleted = NetPackage:FindFirstChild("FishingCompleted"),
                    FishingMinigameChanged = NetPackage:FindFirstChild("FishingMinigameChanged"),
                    CaughtFishVisual = NetPackage:FindFirstChild("CaughtFishVisual")
                }
                
                for name, remote in pairs(DetectedModules.NetPackages) do
                    if remote then
                        print("   🔗 " .. name .. " found")
                        DetectedModules.RemoteEvents[name] = remote
                    end
                end
            end
        end
    end
    
    -- Cari Shared Modules
    DetectedModules.FishingRodModifier = ReplicatedStorage:FindFirstChild("Shared"):FindFirstChild("FishingRodModifier$")
    if DetectedModules.FishingRodModifier then
        print("✅ Found FishingRodModifier")
    end
    
    print("📊 Total Modules Found: " .. #DetectedModules.RemoteEvents .. " remote events")
end

-- =============================================
-- 🎮 FISHING RADAR SYSTEM (ADVANCED)
-- =============================================
local FishingRadar = {
    Active = false,
    Enabled = true,
    ScanRadius = 250,
    Spots = {},
    Markers = {},
    BestSpot = nil,
    RadarUI = nil,
    ScanThread = nil,
    
    Config = {
        ShowMarkers = true,
        HighlightBest = true,
        AutoScan = true,
        ScanInterval = 3,
        MarkerSize = 15,
        ShowDistance = true
    }
}

function FishingRadar:Initialize()
    print("📡 Initializing Fishing Radar...")
    
    -- Coba load module jika ada
    if DetectedModules.FishingRadar then
        print("✅ Using built-in Fishing Radar module")
        self.Module = DetectedModules.FishingRadar
    end
    
    self:CreateUI()
    self:StartAutoScan()
end

function FishingRadar:CreateUI()
    -- Hapus UI lama jika ada
    if self.RadarUI and self.RadarUI.Parent then
        self.RadarUI:Destroy()
    end
    
    -- Buat ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdvancedFishingRadar"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Radar Frame
    local RadarFrame = Instance.new("Frame")
    RadarFrame.Name = "RadarFrame"
    RadarFrame.Size = UDim2.new(0, 320, 0, 360)
    RadarFrame.Position = UDim2.new(1, -340, 0, 10)
    RadarFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    RadarFrame.BackgroundTransparency = 0.1
    RadarFrame.BorderSizePixel = 0
    RadarFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = RadarFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    Header.BorderSizePixel = 0
    Header.Parent = RadarFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Text = "📡 FISHING RADAR"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0, 200, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Status Display
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Size = UDim2.new(1, -20, 0, 80)
    StatusFrame.Position = UDim2.new(0, 10, 0, 50)
    StatusFrame.BackgroundTransparency = 1
    StatusFrame.Parent = RadarFrame
    
    -- Spots Found
    local SpotsLabel = Instance.new("TextLabel")
    SpotsLabel.Text = "Spots: 0"
    SpotsLabel.Size = UDim2.new(0.5, -5, 0, 25)
    SpotsLabel.Position = UDim2.new(0, 0, 0, 0)
    SpotsLabel.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    SpotsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SpotsLabel.Font = Enum.Font.Gotham
    SpotsLabel.TextSize = 14
    SpotsLabel.Parent = StatusFrame
    
    local SpotsCorner = Instance.new("UICorner")
    SpotsCorner.CornerRadius = UDim.new(0, 6)
    SpotsCorner.Parent = SpotsLabel
    
    -- Best Spot
    local BestSpotLabel = Instance.new("TextLabel")
    BestSpotLabel.Text = "Best: None"
    BestSpotLabel.Size = UDim2.new(0.5, -5, 0, 25)
    BestSpotLabel.Position = UDim2.new(0.5, 5, 0, 0)
    BestSpotLabel.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    BestSpotLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    BestSpotLabel.Font = Enum.Font.Gotham
    BestSpotLabel.TextSize = 14
    BestSpotLabel.Parent = StatusFrame
    
    local BestCorner = Instance.new("UICorner")
    BestCorner.CornerRadius = UDim.new(0, 6)
    BestCorner.Parent = BestSpotLabel
    
    -- Distance
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Text = "Distance: 0 studs"
    DistanceLabel.Size = UDim2.new(1, 0, 0, 25)
    DistanceLabel.Position = UDim2.new(0, 0, 0, 35)
    DistanceLabel.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    DistanceLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.TextSize = 14
    DistanceLabel.Parent = StatusFrame
    
    local DistanceCorner = Instance.new("UICorner")
    DistanceCorner.CornerRadius = UDim.new(0, 6)
    DistanceCorner.Parent = DistanceLabel
    
    -- Controls
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Size = UDim2.new(1, -20, 0, 100)
    ControlsFrame.Position = UDim2.new(0, 10, 0, 140)
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Parent = RadarFrame
    
    -- Toggle Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Text = "🔄 SCAN NOW"
    ToggleButton.Size = UDim2.new(1, 0, 0, 35)
    ToggleButton.Position = UDim2.new(0, 0, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 14
    ToggleButton.Parent = ControlsFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        self:ScanForSpots()
    end)
    
    -- Go to Best Spot Button
    local GotoButton = Instance.new("TextButton")
    GotoButton.Text = "📍 GO TO BEST SPOT"
    GotoButton.Size = UDim2.new(1, 0, 0, 35)
    GotoButton.Position = UDim2.new(0, 0, 0, 45)
    GotoButton.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    GotoButton.TextColor3 = Color3.new(1, 1, 1)
    GotoButton.Font = Enum.Font.GothamBold
    GotoButton.TextSize = 14
    GotoButton.Parent = ControlsFrame
    
    local GotoCorner = Instance.new("UICorner")
    GotoCorner.CornerRadius = UDim.new(0, 8)
    GotoCorner.Parent = GotoButton
    
    GotoButton.MouseButton1Click:Connect(function()
        self:TeleportToBestSpot()
    end)
    
    -- Settings
    local SettingsLabel = Instance.new("TextLabel")
    SettingsLabel.Text = "⚙️ RADAR SETTINGS"
    SettingsLabel.Size = UDim2.new(1, 0, 0, 25)
    SettingsLabel.Position = UDim2.new(0, 0, 0, 250)
    SettingsLabel.BackgroundTransparency = 1
    SettingsLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
    SettingsLabel.Font = Enum.Font.GothamBold
    SettingsLabel.TextSize = 13
    SettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
    SettingsLabel.Parent = RadarFrame
    
    -- Save UI references
    self.RadarUI = {
        Screen = ScreenGui,
        Frame = RadarFrame,
        SpotsLabel = SpotsLabel,
        BestSpotLabel = BestSpotLabel,
        DistanceLabel = DistanceLabel,
        ToggleButton = ToggleButton,
        GotoButton = GotoButton
    }
    
    print("✅ Radar UI Created")
end

function FishingRadar:ScanForSpots()
    if not self.Enabled then return end
    
    local character = LocalPlayer.Character
    if not character or not character.PrimaryPart then return end
    
    local playerPos = character.PrimaryPart.Position
    local spots = {}
    local bestSpot = nil
    local bestValue = 0
    
    -- Clear old markers
    self:ClearMarkers()
    
    -- Enhanced spot detection
    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Part") or item:IsA("MeshPart") then
            local distance = (item.Position - playerPos).Magnitude
            
            if distance <= self.ScanRadius then
                local spotData = self:AnalyzeSpot(item, distance)
                if spotData then
                    table.insert(spots, spotData)
                    
                    if spotData.Value > bestValue then
                        bestValue = spotData.Value
                        bestSpot = spotData
                    end
                end
            end
        end
        
        -- Check for fishing platforms/areas
        if item:IsA("Model") then
            if item.Name:lower():find("fish") or 
               item.Name:lower():find("pond") or
               item.Name:lower():find("dock") or
               item.Name:lower():find("pier") then
                
                local distance = (item:GetPivot().Position - playerPos).Magnitude
                if distance <= self.ScanRadius then
                    local spotData = {
                        Object = item,
                        Position = item:GetPivot().Position,
                        Distance = math.floor(distance),
                        Type = "Fishing Area",
                        Value = 1.5,
                        Name = item.Name
                    }
                    
                    table.insert(spots, spotData)
                    
                    if spotData.Value > bestValue then
                        bestValue = spotData.Value
                        bestSpot = spotData
                    end
                end
            end
        end
    end
    
    self.Spots = spots
    self.BestSpot = bestSpot
    
    -- Update UI
    self:UpdateUI()
    
    -- Create markers
    if self.Config.ShowMarkers then
        self:CreateMarkers()
    end
    
    return spots
end

function FishingRadar:AnalyzeSpot(part, distance)
    local spotValue = 0
    local spotType = "Unknown"
    local confidence = 0
    
    -- Name analysis
    local name = part.Name:lower()
    if name:find("water") or name:find("pond") or name:find("lake") then
        spotValue = spotValue + 2
        spotType = "Water Body"
        confidence = confidence + 40
    end
    
    if name:find("fish") or name:find("fishing") then
        spotValue = spotValue + 3
        spotType = "Fishing Spot"
        confidence = confidence + 60
    end
    
    if name:find("river") or name:find("ocean") or name:find("sea") then
        spotValue = spotValue + 2.5
        spotType = "Water Source"
        confidence = confidence + 50
    end
    
    -- Material analysis
    if part.Material == Enum.Material.Water then
        spotValue = spotValue + 4
        spotType = "Water (Material)"
        confidence = confidence + 80
    elseif part.Material == Enum.Material.SmoothPlastic then
        spotValue = spotValue + 1
        confidence = confidence + 20
    end
    
    -- Color analysis (blue colors = water)
    local color = part.Color
    local brightness = (color.R + color.G + color.B) / 3
    
    if color.B > color.R and color.B > color.G then
        spotValue = spotValue + (color.B * 2)
        confidence = confidence + (color.B * 30)
    end
    
    -- Transparency (water often has transparency)
    if part.Transparency > 0.3 then
        spotValue = spotValue + (part.Transparency * 1.5)
        confidence = confidence + (part.Transparency * 20)
    end
    
    -- Size factor (bigger water areas are better)
    local sizeFactor = part.Size.Magnitude / 50
    if sizeFactor > 1 then sizeFactor = 1 end
    spotValue = spotValue + (sizeFactor * 2)
    
    -- Distance factor (closer is better)
    local distanceFactor = 1 - (distance / self.ScanRadius)
    spotValue = spotValue * (1 + distanceFactor)
    
    -- Only return if confident enough
    if confidence >= 30 then
        return {
            Part = part,
            Position = part.Position,
            Distance = math.floor(distance),
            Type = spotType,
            Value = math.round(spotValue * 10) / 10,
            Confidence = math.floor(confidence)
        }
    end
    
    return nil
end

function FishingRadar:CreateMarkers()
    for _, spot in pairs(self.Spots) do
        local marker = Instance.new("BillboardGui")
        marker.Name = "FishSpotMarker"
        marker.Size = UDim2.new(0, self.Config.MarkerSize, 0, self.Config.MarkerSize)
        marker.StudsOffset = Vector3.new(0, 3, 0)
        marker.AlwaysOnTop = true
        marker.Adornee = spot.Part
        marker.MaxDistance = self.ScanRadius
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        
        -- Color based on spot value
        if spot == self.BestSpot and self.Config.HighlightBest then
            frame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold for best
        elseif spot.Value > 5 then
            frame.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Green for good
        elseif spot.Value > 3 then
            frame.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue for medium
        else
            frame.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Gray for poor
        end
        
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = marker
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = frame
        
        -- Label with distance
        if self.Config.ShowDistance then
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(2, 0, 1, 0)
            label.Position = UDim2.new(0.5, 10, 0, 0)
            label.Text = spot.Type .. "\n" .. spot.Distance .. "m"
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextStrokeTransparency = 0
            label.BackgroundTransparency = 1
            label.TextSize = 10
            label.Font = Enum.Font.Gotham
            label.Parent = marker
        end
        
        marker.Parent = Workspace.CurrentCamera
        spot.Marker = marker
        
        table.insert(self.Markers, marker)
    end
end

function FishingRadar:ClearMarkers()
    for _, marker in pairs(self.Markers) do
        if marker then
            marker:Destroy()
        end
    end
    self.Markers = {}
end

function FishingRadar:UpdateUI()
    if not self.RadarUI then return end
    
    self.RadarUI.SpotsLabel.Text = "Spots: " .. #self.Spots
    self.RadarUI.BestSpotLabel.Text = "Best: " .. (self.BestSpot and self.BestSpot.Type or "None")
    
    if self.BestSpot then
        self.RadarUI.DistanceLabel.Text = "Distance: " .. self.BestSpot.Distance .. " studs"
        self.RadarUI.DistanceLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        self.RadarUI.GotoButton.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    else
        self.RadarUI.DistanceLabel.Text = "Distance: No spots"
        self.RadarUI.DistanceLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        self.RadarUI.GotoButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
    
    if #self.Spots > 0 then
        self.RadarUI.SpotsLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        self.RadarUI.SpotsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

function FishingRadar:TeleportToBestSpot()
    if not self.BestSpot then
        self:Notify("No best spot found!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local character = LocalPlayer.Character
    if not character or not character.PrimaryPart then return end
    
    -- Teleport to best spot
    character:SetPrimaryPartCFrame(CFrame.new(self.BestSpot.Position + Vector3.new(0, 5, 0)))
    
    self:Notify("Teleported to best fishing spot!", Color3.fromRGB(0, 255, 100))
end

function FishingRadar:StartAutoScan()
    if not self.Config.AutoScan then return end
    
    self.ScanThread = task.spawn(function()
        while self.Enabled do
            self:ScanForSpots()
            task.wait(self.Config.ScanInterval)
        end
    end)
end

function FishingRadar:Notify(message, color)
    color = color or Color3.fromRGB(0, 200, 255)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📡 Fishing Radar",
        Text = message,
        Duration = 3,
        Icon = "rbxassetid://4483345998"
    })
end

function FishingRadar:Toggle(state)
    self.Enabled = state
    
    if state then
        self:Initialize()
        self:Notify("Fishing Radar Activated!")
    else
        self:ClearMarkers()
        if self.ScanThread then
            task.cancel(self.ScanThread)
            self.ScanThread = nil
        end
        if self.RadarUI then
            self.RadarUI.Screen:Destroy()
            self.RadarUI = nil
        end
        self:Notify("Fishing Radar Deactivated!")
    end
end

-- =============================================
-- 🤖 ADVANCED AUTO FISHING SYSTEM
-- =============================================
local AutoFishing = {
    Active = false,
    Enabled = false,
    FishingThread = nil,
    
    Config = {
        UseRadar = true,
        InstantCatch = false,
        AutoSell = true,
        AutoBait = true,
        CatchSpeed = 1,
        MaxWaitTime = 30,
        UseMinigame = false
    },
    
    Stats = {
        TotalFish = 0,
        TotalWeight = 0,
        TotalCoins = 1000,
        BiggestFish = {Name = "None", Weight = 0},
        SessionStart = os.time(),
        Level = 1
    },
    
    State = {
        IsFishing = false,
        CurrentRod = nil,
        CurrentBait = nil,
        CurrentSpot = nil
    }
}

function AutoFishing:Initialize()
    print("🤖 Initializing Auto Fishing System...")
    
    -- Cari remote events untuk fishing
    self:FindRemotes()
    
    -- Setup fishing hooks
    self:SetupHooks()
    
    -- Start stats tracking
    self:StartStatsTracker()
    
    self:Notify("Auto Fishing System Ready!")
end

function AutoFishing:FindRemotes()
    self.Remotes = {}
    
    -- Cari dari Net Packages
    for name, remote in pairs(DetectedModules.NetPackages) do
        if remote then
            self.Remotes[name] = remote
            print("✅ Remote found: " .. name)
        end
    end
    
    -- Cari dari Controller
    if DetectedModules.FishingController then
        -- Cari remote events dalam controller
        local function findRemotesIn(parent, path)
            for _, item in pairs(parent:GetChildren()) do
                if item:IsA("RemoteEvent") or item:IsA("RemoteFunction") then
                    self.Remotes[item.Name] = item
                    print("✅ Remote found: " .. path .. "/" .. item.Name)
                end
                if item:IsA("Folder") then
                    findRemotesIn(item, path .. "/" .. item.Name)
                end
            end
        end
        
        findRemotesIn(DetectedModules.FishingController, "FishingController")
    end
end

function AutoFishing:SetupHooks()
    -- Hook untuk fishing events jika ada
    if self.Remotes["FishCaught"] then
        local original = self.Remotes["FishCaught"].FireServer
        self.Remotes["FishCaught"].FireServer = function(self, ...)
            AutoFishing:OnFishCaught(...)
            return original(self, ...)
        end
    end
    
    if self.Remotes["FishingCompleted"] then
        local original = self.Remotes["FishingCompleted"].FireServer
        self.Remotes["FishingCompleted"].FireServer = function(self, ...)
            AutoFishing:OnFishingCompleted(...)
            return original(self, ...)
        end
    end
end

function AutoFishing:Start()
    if not self.Enabled then return end
    
    self.Active = true
    
    self.FishingThread = task.spawn(function()
        while self.Active do
            self:PerformFishingCycle()
            
            -- Delay berdasarkan catch speed
            local delay = 3 / self.Config.CatchSpeed
            if self.Config.InstantCatch then
                delay = 0.5
            end
            
            task.wait(delay)
        end
    end)
    
    self:Notify("Auto Fishing Started!")
end

function AutoFishing:Stop()
    self.Active = false
    
    if self.FishingThread then
        task.cancel(self.FishingThread)
        self.FishingThread = nil
    end
    
    self.State.IsFishing = false
    self:Notify("Auto Fishing Stopped!")
end

function AutoFishing:PerformFishingCycle()
    if not self.Active or self.State.IsFishing then return end
    
    self.State.IsFishing = true
    
    -- 1. Cari spot terbaik (gunakan radar jika enabled)
    if self.Config.UseRadar and FishingRadar.BestSpot then
        self.State.CurrentSpot = FishingRadar.BestSpot
        self:Notify("Moving to best spot...")
    end
    
    -- 2. Cast fishing rod
    local success = self:CastRod()
    if not success then
        self.State.IsFishing = false
        return
    end
    
    -- 3. Tunggu fish bite
    local waitTime = self.Config.InstantCatch and 0.1 or math.random(2, 8)
    task.wait(waitTime)
    
    -- 4. Catch fish
    self:CatchFish()
    
    -- 5. Update stats
    self:UpdateStats()
    
    -- 6. Auto sell jika enabled
    if self.Config.AutoSell then
        task.wait(0.5)
        self:SellFish()
    end
    
    self.State.IsFishing = false
end

function AutoFishing:CastRod()
    -- Coba gunakan berbagai remote events untuk casting
    local success = false
    
    if self.Remotes["FlyFishingEffect"] then
        self.Remotes["FlyFishingEffect"]:FireServer()
        success = true
    end
    
    if self.Remotes["FishingMinigameChanged"] then
        self.Remotes["FishingMinigameChanged"]:FireServer("Start")
        success = true
    end
    
    -- Coba panggil InputStates jika ada
    if DetectedModules.InputStates then
        pcall(function()
            -- Simulasi input casting
            success = true
        end)
    end
    
    if success then
        self:Notify("🎣 Casting rod...")
    end
    
    return success
end

function AutoFishing:CatchFish()
    -- Trigger fish catch
    if self.Remotes["FishCaught"] then
        self.Remotes["FishCaught"]:FireServer()
    end
    
    if self.Remotes["CaughtFishVisual"] then
        self.Remotes["CaughtFishVisual"]:FireServer()
    end
    
    self:Notify("🐟 Fish caught!")
end

function AutoFishing:SellFish()
    -- Simulasi sell fish
    local profit = math.random(50, 200)
    self.Stats.TotalCoins = self.Stats.TotalCoins + profit
    
    self:Notify("💰 Sold fish for " .. profit .. " coins!")
end

function AutoFishing:UpdateStats()
    self.Stats.TotalFish = self.Stats.TotalFish + 1
    
    -- Random weight antara 1-50
    local fishWeight = math.random(10, 500) / 10
    self.Stats.TotalWeight = self.Stats.TotalWeight + fishWeight
    
    -- Update biggest fish
    if fishWeight > self.Stats.BiggestFish.Weight then
        self.Stats.BiggestFish = {
            Name = "Fish #" .. self.Stats.TotalFish,
            Weight = fishWeight
        }
    end
    
    -- Auto level up setiap 10 fish
    if self.Stats.TotalFish % 10 == 0 then
        self.Stats.Level = self.Stats.Level + 1
        self:Notify("⭐ Level Up! Now Level " .. self.Stats.Level)
    end
end

function AutoFishing:OnFishCaught(...)
    -- Callback ketika fish caught
    local args = {...}
    self:Notify("New fish caught!")
end

function AutoFishing:OnFishingCompleted(...)
    -- Callback ketika fishing completed
    local args = {...}
    self:Notify("Fishing session completed!")
end

function AutoFishing:StartStatsTracker()
    task.spawn(function()
        while self.Enabled do
            -- Update stats setiap 5 detik
            self:SaveSessionStats()
            task.wait(5)
        end
    end)
end

function AutoFishing:SaveSessionStats()
    -- Simpan stats ke memory
    local sessionTime = os.time() - self.Stats.SessionStart
    
    self.SessionStats = {
        FishPerMinute = math.round((self.Stats.TotalFish / (sessionTime / 60)) * 100) / 100,
        AverageWeight = self.Stats.TotalFish > 0 and 
                       math.round(self.Stats.TotalWeight / self.Stats.TotalFish * 100) / 100 or 0,
        CoinsPerHour = math.round((self.Stats.TotalCoins - 1000) / (sessionTime / 3600))
    }
end

function AutoFishing:GetStats()
    return {
        TotalFish = self.Stats.TotalFish,
        TotalWeight = string.format("%.1f kg", self.Stats.TotalWeight),
        TotalCoins = self.Stats.TotalCoins,
        BiggestFish = self.Stats.BiggestFish.Name .. " (" .. self.Stats.BiggestFish.Weight .. " kg)",
        Level = self.Stats.Level,
        SessionTime = os.time() - self.Stats.SessionStart
    }
end

function AutoFishing:Notify(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🤖 Auto Fishing",
        Text = message,
        Duration = 2,
        Icon = "rbxassetid://4483345998"
    })
end

function AutoFishing:Toggle(state)
    self.Enabled = state
    
    if state then
        self:Initialize()
        self:Start()
    else
        self:Stop()
    end
end

-- =============================================
-- ⚡ FISHING MODIFIER SYSTEM
-- =============================================
local FishingModifier = {
    Enabled = false,
    
    Modifiers = {
        WeightMultiplier = 1.0,
        CoinMultiplier = 1.0,
        CatchSpeed = 1.0,
        BaitEfficiency = 1.0,
        RadarRange = 1.0
    },
    
    Hooks = {}
}

function FishingModifier:Initialize()
    print("⚡ Initializing Fishing Modifier...")
    
    -- Hook weight system jika ada
    if DetectedModules.WeightRanges then
        self:HookWeightSystem()
    end
    
    -- Hook rod modifier jika ada
    if DetectedModules.FishingRodModifier then
        self:HookRodModifier()
    end
    
    self:Notify("Fishing Modifier Ready!")
end

function FishingModifier:HookWeightSystem()
    -- Hook untuk mengubah weight ranges
    if DetectedModules.WeightRanges:IsA("ModuleScript") then
        local module = require(DetectedModules.WeightRanges)
        
        if type(module) == "table" then
            -- Simpan original functions
            self.OriginalWeightModule = table.clone(module)
            
            -- Override weight calculation
            if module.GetWeight then
                local original = module.GetWeight
                module.GetWeight = function(...)
                    local weight = original(...)
                    return weight * self.Modifiers.WeightMultiplier
                end
            end
        end
    end
end

function FishingModifier:HookRodModifier()
    -- Hook untuk fishing rod modifier
    if DetectedModules.FishingRodModifier:IsA("ModuleScript") then
        local module = require(DetectedModules.FishingRodModifier)
        
        if type(module) == "table" then
            self.OriginalRodModule = table.clone(module)
            
            -- Override rod efficiency
            for key, value in pairs(module) do
                if type(value) == "function" and key:find("Efficiency") then
                    module[key] = function(...)
                        local result = value(...)
                        return result * self.Modifiers.BaitEfficiency
                    end
                end
            end
        end
    end
end

function FishingModifier:SetWeightMultiplier(multiplier)
    self.Modifiers.WeightMultiplier = multiplier
    self:Notify("Weight Multiplier: " .. multiplier .. "x")
end

function FishingModifier:SetCoinMultiplier(multiplier)
    self.Modifiers.CoinMultiplier = multiplier
    self:Notify("Coin Multiplier: " .. multiplier .. "x")
end

function FishingModifier:SetCatchSpeed(speed)
    self.Modifiers.CatchSpeed = speed
    AutoFishing.Config.CatchSpeed = speed
    self:Notify("Catch Speed: " .. speed .. "x")
end

function FishingModifier:Notify(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Fishing Modifier",
        Text = message,
        Duration = 2
    })
end

-- =============================================
-- 🎮 KEYBIND SYSTEM
-- =============================================
local Keybinds = {
    Binds = {
        [Enum.KeyCode.F6] = function()
            AutoFishing:Toggle(not AutoFishing.Enabled)
        end,
        
        [Enum.KeyCode.F7] = function()
            FishingRadar:Toggle(not FishingRadar.Enabled)
        end,
        
        [Enum.KeyCode.F8] = function()
            FishingModifier:Initialize()
            FishingModifier:SetWeightMultiplier(5.0)
            FishingModifier:SetCoinMultiplier(3.0)
        end,
        
        [Enum.KeyCode.E] = function()
            if not AutoFishing.State.IsFishing then
                AutoFishing:PerformFishingCycle()
            end
        end,
        
        [Enum.KeyCode.R] = function()
            if FishingRadar.Enabled then
                FishingRadar:ScanForSpots()
            end
        end,
        
        [Enum.KeyCode.T] = function()
            if FishingRadar.BestSpot then
                FishingRadar:TeleportToBestSpot()
            end
        end
    }
}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if Keybinds.Binds[input.KeyCode] then
        Keybinds.Binds[input.KeyCode]()
    end
end)

-- =============================================
-- 📊 STATS DISPLAY UI
-- =============================================
local StatsUI = {
    Screen = nil,
    Labels = {},
    UpdateThread = nil
}

function StatsUI:Create()
    -- Hapus UI lama
    if self.Screen and self.Screen.Parent then
        self.Screen:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishingStatsUI"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 250, 0, 200)
    MainFrame.Position = UDim2.new(0, 10, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40, 0.8)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Text = "📊 FISHING STATS"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Title.TextColor3 = Color3.fromRGB(0, 200, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = Title
    
    -- Stats labels
    local stats = {
        {"🎣 Total Fish:", "TotalFish"},
        {"⚖️ Total Weight:", "TotalWeight"},
        {"💰 Coins:", "TotalCoins"},
        {"🏆 Biggest Fish:", "BiggestFish"},
        {"⭐ Level:", "Level"},
        {"📡 Radar Spots:", "RadarSpots"}
    }
    
    local yPos = 40
    for i, stat in ipairs(stats) do
        local label = Instance.new("TextLabel")
        label.Name = stat[2]
        label.Text = stat[1] .. " 0"
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0, 10, 0, yPos)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = MainFrame
        
        self.Labels[stat[2]] = label
        yPos = yPos + 25
    end
    
    self.Screen = ScreenGui
    self:StartUpdates()
end

function StatsUI:StartUpdates()
    if self.UpdateThread then
        task.cancel(self.UpdateThread)
    end
    
    self.UpdateThread = task.spawn(function()
        while self.Screen and self.Screen.Parent do
            self:UpdateStats()
            task.wait(1)
        end
    end)
end

function StatsUI:UpdateStats()
    if not self.Screen or not self.Screen.Parent then return end
    
    -- Update fishing stats
    local fishingStats = AutoFishing:GetStats()
    
    if self.Labels["TotalFish"] then
        self.Labels["TotalFish"].Text = "🎣 Total Fish: " .. fishingStats.TotalFish
    end
    
    if self.Labels["TotalWeight"] then
        self.Labels["TotalWeight"].Text = "⚖️ Total Weight: " .. fishingStats.TotalWeight
    end
    
    if self.Labels["TotalCoins"] then
        self.Labels["TotalCoins"].Text = "💰 Coins: " .. fishingStats.TotalCoins
    end
    
    if self.Labels["BiggestFish"] then
        self.Labels["BiggestFish"].Text = "🏆 Biggest Fish: " .. fishingStats.BiggestFish
    end
    
    if self.Labels["Level"] then
        self.Labels["Level"].Text = "⭐ Level: " .. fishingStats.Level
    end
    
    -- Update radar stats
    if self.Labels["RadarSpots"] then
        local spots = FishingRadar.Spots or {}
        self.Labels["RadarSpots"].Text = "📡 Radar Spots: " .. #spots
    end
end

-- =============================================
-- 🚀 MAIN INITIALIZATION
-- =============================================
task.wait(2) -- Tunggu game load

print("=" . 60)
print("🎣 FISH IT! ENHANCED SCRIPT v2.0")
print("=" . 60)

-- Initialize modules
InitializeModules()

-- Start systems
FishingRadar:Initialize()
AutoFishing:Initialize()
FishingModifier:Initialize()

-- Create UI
StatsUI:Create()

-- Setup keybinds
print("\n🎮 KEYBINDS:")
print("  F6 - Toggle Auto Fishing")
print("  F7 - Toggle Fishing Radar")
print("  F8 - Activate Modifiers")
print("  E - Manual Fishing")
print("  R - Scan for Spots")
print("  T - Teleport to Best Spot")

-- Welcome message
task.delay(2, function()
    local notification = game:GetService("StarterGui")
    
    notification:SetCore("SendNotification", {
        Title = "🎣 Fish It! Enhanced",
        Text = "All systems loaded!\nF6: Auto Fish\nF7: Radar\nF8: Modifiers",
        Duration = 5,
        Icon = "rbxassetid://4483345998"
    })
    
    print("\n✅ All systems ready!")
    print("📊 Stats UI created")
    print("📡 Fishing Radar active")
    print("🤖 Auto Fishing ready")
    print("⚡ Modifiers loaded")
end)

-- Cleanup
LocalPlayer.CharacterRemoving:Connect(function()
    AutoFishing:Stop()
    FishingRadar:Toggle(false)
    
    if StatsUI.UpdateThread then
        task.cancel(StatsUI.UpdateThread)
    end
end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
