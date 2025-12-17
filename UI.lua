-- FishingSystem.UI.lua
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingSystem = require(ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("Fishing"))

-- Create Rayfield Library (or use your favorite UI library)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Main Window
local Window = Rayfield:CreateWindow({
   Name = "🎣 Fishing Script V3.4",
   LoadingTitle = "Loading Fishing System...",
   LoadingSubtitle = "by InfinityX",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FishingScript",
      FileName = "Config"
   },
   Discord = {
      Enabled = true,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Fishing Script",
      Subtitle = "Key System",
      Note = "No key required",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"FISHING2024"}
   }
})

-- ============ MAIN TAB ============
local MainTab = Window:CreateTab("Main", "🔧")
local MainSection = MainTab:CreateSection("Main Features")

-- Auto Fishing
local AutoFishingToggle = MainSection:CreateToggle({
   Name = "🤖 Auto Fishing",
   CurrentValue = false,
   Flag = "AutoFishing",
   Callback = function(Value)
       FishingSystem.ToggleAutoFishing(Value)
       if Value then
           Rayfield:Notify({
               Title = "Auto Fishing",
               Content = "Auto fishing enabled!",
               Duration = 3,
               Image = "http://www.roblox.com/asset/?id=6031075938"
           })
       end
   end,
})

-- Instant Fishing
local InstantFishingToggle = MainSection:CreateToggle({
   Name = "⚡ Instant Fishing",
   CurrentValue = false,
   Flag = "InstantFishing",
   Callback = function(Value)
       FishingSystem.SetInstantFishing(Value)
   end,
})

-- Blatant Fishing
local BlatantFishingToggle = MainSection:CreateToggle({
   Name = "🚀 Blatant Fishing",
   CurrentValue = false,
   Flag = "BlatantFishing",
   Callback = function(Value)
       FishingSystem.SetBlatantFishing(Value)
   end,
})

-- Auto Sell Fish
local AutoSellToggle = MainSection:CreateToggle({
   Name = "💰 Auto Sell Fish",
   CurrentValue = false,
   Flag = "AutoSell",
   Callback = function(Value)
       FishingSystem.ToggleAutoSell(Value)
   end,
})

-- Auto Rebuy Bait
local AutoBaitToggle = MainSection:CreateToggle({
   Name = "🪱 Auto Rebuy Bait",
   CurrentValue = false,
   Flag = "AutoBait",
   Callback = function(Value)
       FishingSystem.ToggleAutoBait(Value)
   end,
})

-- Catch Speed Slider
local CatchSpeedSlider = MainSection:CreateSlider({
   Name = "🎯 Catch Speed Multiplier",
   Range = {1, 10},
   Increment = 0.1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "CatchSpeed",
   Callback = function(Value)
       FishingSystem.SetCatchSpeed(Value)
   end,
})

-- ============ MENU TAB ============
local MenuTab = Window:CreateTab("Menu", "⚙️")
local MenuSection = MenuTab:CreateSection("Menu Settings")

-- Enable Radar
local RadarToggle = MenuSection:CreateToggle({
   Name = "📡 Enable Fishing Radar",
   CurrentValue = false,
   Flag = "Radar",
   Callback = function(Value)
       FishingSystem.ToggleRadar(Value)
   end,
})

-- Equip Best Rod
local EquipRodButton = MenuSection:CreateButton({
   Name = "🎣 Equip Best Rod",
   Callback = function()
       FishingSystem.EquipBestRod()
       Rayfield:Notify({
           Title = "Rod Equipped",
           Content = "Best rod has been equipped!",
           Duration = 3,
           Image = "http://www.roblox.com/asset/?id=6031075938"
       })
   end,
})

-- No Animation Fishing
local NoAnimToggle = MenuSection:CreateToggle({
   Name = "👻 No Animation Fishing",
   CurrentValue = false,
   Flag = "NoAnimation",
   Callback = function(Value)
       FishingSystem.ToggleFishingAnimation(not Value)
   end,
})

-- Auto Quest
local AutoQuestToggle = MenuSection:CreateToggle({
   Name = "📜 Auto Quest",
   CurrentValue = false,
   Flag = "AutoQuest",
   Callback = function(Value)
       FishingSystem.ToggleAutoQuest(Value)
   end,
})

-- UI Customization Section
local UISection = MenuTab:CreateSection("UI Customization")

-- UI Transparency
local UITransparency = UISection:CreateSlider({
   Name = "UI Transparency",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 0,
   Flag = "UITransparency",
   Callback = function(Value)
       Window:SetTransparency(Value/100)
   end,
})

-- UI Toggle Keybind
local ToggleKeybind = UISection:CreateKeybind({
   Name = "Toggle UI Keybind",
   CurrentKeybind = "RightControl",
   HoldToInteract = false,
   Flag = "ToggleUIKey",
   Callback = function(Key)
       Rayfield:Notify({
           Title = "Keybind Set",
           Content = "UI toggle keybind: " .. Key,
           Duration = 2
       })
   end,
})

-- ============ UTILITY TAB ============
local UtilityTab = Window:CreateTab("Utility", "🛠️")
local UtilitySection = UtilityTab:CreateSection("Utility Features")

-- Walk Speed
local WalkSpeedSlider = UtilitySection:CreateSlider({
   Name = "🚶 Walk Speed",
   Range = {16, 200},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
       local Humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
       if Humanoid then
           Humanoid.WalkSpeed = Value
       end
   end,
})

-- Jump Power
local JumpPowerSlider = UtilitySection:CreateSlider({
   Name = "🦘 Jump Power",
   Range = {50, 200},
   Increment = 1,
   Suffix = " power",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
       local Humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
       if Humanoid then
           Humanoid.JumpPower = Value
       end
   end,
})

-- Infinite Jump
local InfiniteJumpToggle = UtilitySection:CreateToggle({
   Name = "♾️ Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJump",
   Callback = function(Value)
       getgenv().InfiniteJumpEnabled = Value
       
       if Value then
           game:GetService("UserInputService").JumpRequest:Connect(function()
               if getgenv().InfiniteJumpEnabled then
                   Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
               end
           end)
       end
   end,
})

-- Fly
local FlyToggle = UtilitySection:CreateToggle({
   Name = "✈️ Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
       loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
   end,
})

-- ESP Name
local ESPToggle = UtilitySection:CreateToggle({
   Name = "👁️ ESP Name",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
       if Value then
           -- Simple ESP Implementation
           for _, v in pairs(game:GetService("Players"):GetPlayers()) do
               if v ~= Player and v.Character then
                   local BillboardGui = Instance.new("BillboardGui")
                   local TextLabel = Instance.new("TextLabel")
                   
                   BillboardGui.Adornee = v.Character:WaitForChild("Head")
                   BillboardGui.Size = UDim2.new(0, 100, 0, 40)
                   BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                   BillboardGui.AlwaysOnTop = true
                   
                   TextLabel.Parent = BillboardGui
                   TextLabel.BackgroundTransparency = 1
                   TextLabel.Size = UDim2.new(1, 0, 1, 0)
                   TextLabel.Text = v.Name
                   TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                   TextLabel.TextStrokeTransparency = 0
                   TextLabel.TextScaled = true
                   
                   BillboardGui.Parent = v.Character.Head
               end
           end
       else
           -- Remove ESP
           for _, v in pairs(game:GetService("Players"):GetPlayers()) do
               if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                   local gui = v.Character.Head:FindFirstChildWhichIsA("BillboardGui")
                   if gui then
                       gui:Destroy()
                   end
               end
           end
       end
   end,
})

-- No Clip
local NoClipToggle = UtilitySection:CreateToggle({
   Name = "👻 No Clip",
   CurrentValue = false,
   Flag = "NoClip",
   Callback = function(Value)
       getgenv().NoClip = Value
       
       if Value then
           game:GetService("RunService").Stepped:Connect(function()
               if getgenv().NoClip and Player.Character then
                   for _, v in pairs(Player.Character:GetDescendants()) do
                       if v:IsA("BasePart") then
                           v.CanCollide = false
                       end
                   end
               end
           end)
       end
   end,
})

-- ============ STATS TAB ============
local StatsTab = Window:CreateTab("Stats", "📊")
local StatsSection = StatsTab:CreateSection("Fishing Statistics")

-- Stats Labels
local TotalFishLabel = StatsSection:CreateLabel("Total Fish: 0")
local TotalWeightLabel = StatsSection:CreateLabel("Total Weight: 0kg")
local BiggestFishLabel = StatsSection:CreateLabel("Biggest Fish: None")
local CoinsLabel = StatsSection:CreateLabel("Coins: 0")
local LevelLabel = StatsSection:CreateLabel("Level: 1")

-- Update Stats Function
function UpdateStats()
   local stats = FishingSystem.GetStats()
   
   TotalFishLabel:Set("Total Fish: " .. (stats.TotalFish or 0))
   TotalWeightLabel:Set("Total Weight: " .. (stats.TotalWeight or 0) .. "kg")
   BiggestFishLabel:Set("Biggest Fish: " .. (stats.BiggestFish or "None"))
   CoinsLabel:Set("Coins: " .. (stats.Coins or 0))
   LevelLabel:Set("Level: " .. (stats.Level or 1))
end

-- Refresh Button
local RefreshButton = StatsSection:CreateButton({
   Name = "🔄 Refresh Stats",
   Callback = function()
       UpdateStats()
   end,
})

-- Auto Update Stats
game:GetService("RunService").Heartbeat:Connect(function()
   UpdateStats()
end)

-- ============ HOTKEYS SECTION ============
local HotkeysSection = StatsTab:CreateSection("Hotkeys")

HotkeysSection:CreateLabel("F - Start/Stop Auto Fishing")
HotkeysSection:CreateLabel("R - Equip Best Rod")
HotkeysSection:CreateLabel("T - Toggle Radar")
HotkeysSection:CreateLabel("Y - Instant Cast")

-- Hotkey Setup
local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(Input, Processed)
   if not Processed then
       if Input.KeyCode == Enum.KeyCode.F then
           AutoFishingToggle:Set(not AutoFishingToggle.CurrentValue)
       elseif Input.KeyCode == Enum.KeyCode.R then
           FishingSystem.EquipBestRod()
       elseif Input.KeyCode == Enum.KeyCode.T then
           RadarToggle:Set(not RadarToggle.CurrentValue)
       elseif Input.KeyCode == Enum.KeyCode.Y then
           FishingSystem.InstantCast()
       end
   end
end)

-- ============ CREDITS ============
local CreditsTab = Window:CreateTab("Credits", "⭐")
local CreditsSection = CreditsTab:CreateSection("Script Information")

CreditsSection:CreateLabel("Fishing Script V3.4")
CreditsSection:CreateLabel("Created by: InfinityX")
CreditsSection:CreateLabel("UI Library: Rayfield")
CreditsSection:CreateLabel("Version: 1.0.0")

CreditsSection:CreateButton({
   Name = "📋 Copy Discord",
   Callback = function()
       setclipboard("discord.gg/example")
       Rayfield:Notify({
           Title = "Discord Copied",
           Content = "Discord link copied to clipboard!",
           Duration = 3
       })
   end,
})

-- Initialize
Rayfield:Notify({
   Title = "Fishing Script Loaded",
   Content = "Welcome to Fishing Script V3.4!",
   Duration = 5,
   Image = "http://www.roblox.com/asset/?id=6031075938"
})