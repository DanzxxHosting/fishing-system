-- dyron_unified.lua
-- Complete exploit framework with dashboard structure

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configuration
local Config = {
    UI = {
        Theme = "Dark",
        Transparency = 0.1,
        Keybinds = {
            ToggleUI = Enum.KeyCode.RightControl,
            ToggleESP = Enum.KeyCode.F1,
            ToggleFarm = Enum.KeyCode.F2,
            ToggleNoclip = Enum.KeyCode.F3
        }
    },
    Features = {
        ESP = {Enabled = false, Box = true, Name = true, Distance = true},
        AutoFarm = {Enabled = false, Range = 50, Speed = 0.2},
        Aimbot = {Enabled = false, FOV = 100, Smoothness = 0.2},
        Character = {WalkSpeed = 16, JumpPower = 50, Noclip = false},
        Remotes = {AutoDetect = true, Logging = true}
    },
    Data = {
        ScannedRemotes = {},
        ScannedModules = {},
        PlayersData = {},
        GameInfo = {}
    }
}

-- Feature Modules
local Modules = {}

-- Dashboard Module
Modules.Dashboard = {
    GameInfo = function()
        return {
            Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
            PlaceId = game.PlaceId,
            Players = #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
            ServerTime = os.date("%H:%M:%S"),
            Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue(),
            FPS = math.floor(1/RunService.RenderStepped:Wait())
        }
    end,
    
    QuickActions = {
        "Toggle ESP",
        "Start Auto-Farm", 
        "Teleport to Spawn",
        "Server Hop",
        "Scan Game"
    },
    
    Performance = function()
        return {
            Memory = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb()),
            Remotes = #Config.Data.ScannedRemotes,
            Modules = #Config.Data.ScannedModules,
            Scripts = 0
        }
    end
}

-- Main Menu Module
Modules.MainMenu = {
    AutoFarm = {
        Start = function()
            Config.Features.AutoFarm.Enabled = true
            spawn(function()
                while Config.Features.AutoFarm.Enabled do
                    task.wait(Config.Features.AutoFarm.Speed)
                    
                    -- Find collectibles
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Part") and obj.Name:lower():find("coin") then
                            if LocalPlayer.Character then
                                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if root and (root.Position - obj.Position).Magnitude < Config.Features.AutoFarm.Range then
                                    firetouchinterest(root, obj, 0)
                                    firetouchinterest(root, obj, 1)
                                end
                            end
                        end
                    end
                    
                    -- Fire collect remotes
                    for _, remote in pairs(Config.Data.ScannedRemotes) do
                        if remote.Name:lower():find("collect") then
                            pcall(function()
                                if remote.Type == "RemoteEvent" then
                                    remote.Object:FireServer()
                                else
                                    remote.Object:InvokeServer()
                                end
                            end)
                        end
                    end
                end
            end)
        end,
        
        Stop = function()
            Config.Features.AutoFarm.Enabled = false
        end
    },
    
    Combat = {
        Aimbot = function(enabled)
            if enabled then
                RunService.RenderStepped:Connect(function()
                    local closest = nil
                    local closestDist = math.huge
                    
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                            local mousePos = Mouse.Hit.Position
                            
                            if root then
                                local dist = (root.Position - mousePos).Magnitude
                                if dist < closestDist and dist < Config.Features.Aimbot.FOV then
                                    closestDist = dist
                                    closest = root
                                end
                            end
                        end
                    end
                    
                    if closest then
                        Mouse.TargetFilter = closest
                    end
                end)
            end
        end,
        
        KillAll = function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    for _, remote in pairs(Config.Data.ScannedRemotes) do
                        if remote.Name:lower():find("damage") or remote.Name:lower():find("kill") then
                            pcall(function()
                                remote.Object:FireServer(player, math.huge)
                            end)
                        end
                    end
                end
            end
        end
    },
    
    Teleport = {
        ToPlayer = function(playerName)
            local target = Players:FindFirstChild(playerName)
            if target and target.Character then
                local root = target.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if root and localRoot then
                    Config.Features.Character.Noclip = true
                    localRoot.CFrame = root.CFrame
                end
            end
        end,
        
        ToSpawn = function()
            local spawns = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
            if spawns then
                LocalPlayer.Character:MoveTo(spawns.Position)
            end
        end,
        
        BringPlayer = function(playerName)
            local target = Players:FindFirstChild(playerName)
            if target and target.Character then
                local root = target.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if root and localRoot then
                    root.CFrame = localRoot.CFrame
                end
            end
        end
    },
    
    ESP = {
        Toggle = function(enabled)
            Config.Features.ESP.Enabled = enabled
            
            if enabled then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        Modules.MainMenu.ESP.Create(player)
                    end
                end
                
                Players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Connect(function()
                        task.wait(1)
                        Modules.MainMenu.ESP.Create(player)
                    end)
                end)
            else
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:FindFirstChild("ESP_Highlight") then
                        obj.ESP_Highlight:Destroy()
                    end
                end
            end
        end,
        
        Create = function(player)
            if not player.Character then return end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.FillColor = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.7
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = player.Character
            highlight.Adornee = player.Character
            
            if Config.Features.ESP.Name then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = player.Character
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = player.Name
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Code
                label.TextSize = 14
                label.Parent = billboard
            end
        end
    },
    
    Character = {
        SetWalkSpeed = function(speed)
            Config.Features.Character.WalkSpeed = speed
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speed
                end
            end
        end,
        
        SetJumpPower = function(power)
            Config.Features.Character.JumpPower = power
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = power
                end
            end
        end,
        
        ToggleNoclip = function(enabled)
            Config.Features.Character.Noclip = enabled
            if enabled then
                RunService.Stepped:Connect(function()
                    if LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end
        end,
        
        GodMode = function(enabled)
            if enabled then
                LocalPlayer.CharacterAdded:Connect(function(char)
                    local humanoid = char:WaitForChild("Humanoid")
                    humanoid.HealthChanged:Connect(function()
                        humanoid.Health = humanoid.MaxHealth
                    end)
                end)
            end
        end
    },
    
    Remotes = {
        Scan = function()
            Config.Data.ScannedRemotes = {}
            
            for _, container in pairs({ReplicatedStorage, Workspace}) do
                for _, remote in pairs(container:GetDescendants()) do
                    if remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent") then
                        table.insert(Config.Data.ScannedRemotes, {
                            Object = remote,
                            Name = remote.Name,
                            Type = remote.ClassName,
                            Path = remote:GetFullName()
                        })
                    end
                end
            end
            
            return #Config.Data.ScannedRemotes
        end,
        
        FireAll = function()
            for _, remote in pairs(Config.Data.ScannedRemotes) do
                spawn(function()
                    while task.wait(0.1) do
                        pcall(function()
                            if remote.Type == "RemoteEvent" then
                                remote.Object:FireServer()
                            end
                        end)
                    end
                end)
            end
        end,
        
        SpoofAll = function()
            for _, remote in pairs(Config.Data.ScannedRemotes) do
                if remote.Type == "RemoteFunction" then
                    local oldInvoke = remote.Object.InvokeServer
                    remote.Object.InvokeServer = function(self, ...)
                        return 999999
                    end
                end
            end
        end
    }
}

-- Utility Module
Modules.Utility = {
    ScriptHub = {
        LoadScript = function(url)
            local success, script = pcall(function()
                return game:HttpGet(url)
            end)
            
            if success then
                loadstring(script)()
                return true
            end
            return false
        end,
        
        PopularScripts = {
            {"Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
            {"Remote Spy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"},
            {"Chat Bypass", "https://raw.githubusercontent.com/DaFrenchToker/chat-bypass/main/source.lua"}
        }
    },
    
    GameScanner = {
        DeepScan = function()
            local results = {
                Remotes = 0,
                Modules = 0,
                Scripts = 0,
                Values = 0,
                Configs = 0
            }
            
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") then
                    results.Remotes = results.Remotes + 1
                elseif obj:IsA("ModuleScript") then
                    results.Modules = results.Modules + 1
                elseif obj:IsA("Script") or obj:IsA("LocalScript") then
                    results.Scripts = results.Scripts + 1
                elseif obj:IsA("IntValue") or obj:IsA("StringValue") or obj:IsA("NumberValue") then
                    results.Values = results.Values + 1
                end
            end
            
            return results
        end,
        
        DumpScripts = function()
            local scripts = {}
            for _, script in pairs(game:GetDescendants()) do
                if script:IsA("Script") or script:IsA("ModuleScript") then
                    table.insert(scripts, {
                        Name = script.Name,
                        Type = script.ClassName,
                        Path = script:GetFullName()
                    })
                end
            end
            return scripts
        end
    },
    
    PlayerManager = {
        List = function()
            local players = {}
            for _, player in pairs(Players:GetPlayers()) do
                table.insert(players, {
                    Name = player.Name,
                    UserId = player.UserId,
                    AccountAge = player.AccountAge,
                    Team = player.Team and player.Team.Name or "None"
                })
            end
            return players
        end,
        
        GetInventory = function(playerName)
            local target = Players:FindFirstChild(playerName)
            if target and target:FindFirstChild("Backpack") then
                local items = {}
                for _, item in pairs(target.Backpack:GetChildren()) do
                    table.insert(items, item.Name)
                end
                return items
            end
            return {}
        end
    },
    
    ServerTools = {
        ServerHop = function()
            local servers = {}
            local success, data = pcall(function()
                return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
            end)
            
            if success then
                data = HttpService:JSONDecode(data)
                for _, server in pairs(data.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        table.insert(servers, server.id)
                    end
                end
                
                if #servers > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
                end
            end
        end,
        
        Rejoin = function()
            TeleportService:Teleport(game.PlaceId)
        end,
        
        CopyJobId = function()
            if setclipboard then
                setclipboard(game.JobId)
            end
        end
    },
    
    Developer = {
        Decompile = function(object)
            if object:IsA("Script") or object:IsA("ModuleScript") then
                return tostring(object.Source)
            end
            return "Not a script"
        end,
        
        GetProperties = function(object)
            local props = {}
            for _, prop in pairs(getproperties(object)) do
                table.insert(props, prop)
            end
            return props
        end,
        
        FireClickDetector = function(detector)
            if detector:IsA("ClickDetector") then
                fireclickdetector(detector)
            end
        end
    }
}

-- Settings Module
Modules.Settings = {
    UI = {
        Themes = {"Dark", "Light", "Blue", "Red", "Green"},
        SetTheme = function(theme)
            Config.UI.Theme = theme
            -- Update UI colors
        end,
        
        SetTransparency = function(value)
            Config.UI.Transparency = value
            -- Update UI transparency
        end
    },
    
    Keybinds = {
        Set = function(action, key)
            Config.UI.Keybinds[action] = key
        end,
        
        Reset = function()
            Config.UI.Keybinds = {
                ToggleUI = Enum.KeyCode.RightControl,
                ToggleESP = Enum.KeyCode.F1,
                ToggleFarm = Enum.KeyCode.F2,
                ToggleNoclip = Enum.KeyCode.F3
            }
        end
    },
    
    Profiles = {
        Save = function(name)
            local profile = {
                Features = Config.Features,
                UI = Config.UI
            }
            
            if writefile then
                writefile("dyron_profile_" .. name .. ".json", HttpService:JSONEncode(profile))
            end
        end,
        
        Load = function(name)
            if readfile then
                local success, data = pcall(function()
                    return readfile("dyron_profile_" .. name .. ".json")
                end)
                
                if success then
                    local profile = HttpService:JSONDecode(data)
                    Config.Features = profile.Features
                    Config.UI = profile.UI
                end
            end
        end,
        
        Delete = function(name)
            if delfile then
                delfile("dyron_profile_" .. name .. ".json")
            end
        end
    },
    
    System = {
        Unload = function()
            -- Clean up all hooks and instances
            for _, connection in pairs(getconnections(RunService.Stepped)) do
                connection:Disconnect()
            end
        end,
        
        ExportConfig = function()
            if setclipboard then
                setclipboard(HttpService:JSONEncode(Config))
            end
        end,
        
        ImportConfig = function(json)
            local success, data = pcall(function()
                return HttpService:JSONDecode(json)
            end)
            
            if success then
                Config = data
            end
        end
    }
}

-- GUI Creation
local function createGUI()
    local DyronUI = Instance.new("ScreenGui")
    DyronUI.Name = "DyronUnifiedUI"
    DyronUI.Parent = CoreGui
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Size = UDim2.new(0.35, 0, 0.75, 0)
    MainContainer.Position = UDim2.new(0.325, 0, 0.125, 0)
    MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainContainer.BackgroundTransparency = Config.UI.Transparency
    MainContainer.Active = true
    MainContainer.Draggable = true
    MainContainer.Parent = DyronUI
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0.08, 0)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Header.BorderSizePixel = 0
    Header.Parent = MainContainer
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Text = "DYRON EXPLOIT v4.0"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.Code
    Title.TextSize = 18
    Title.Parent = Header
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0.3, 0, 1, 0)
    Status.Position = UDim2.new(0.7, 0, 0, 0)
    Status.Text = "ACTIVE"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.Code
    Status.TextSize = 14
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.Parent = Header
    
    -- Navigation
    local NavFrame = Instance.new("Frame")
    NavFrame.Size = UDim2.new(1, 0, 0.07, 0)
    NavFrame.Position = UDim2.new(0, 0, 0.08, 0)
    NavFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    NavFrame.BorderSizePixel = 0
    NavFrame.Parent = MainContainer
    
    local navButtons = {}
    local navPages = {"DASHBOARD", "MAIN MENU", "UTILITY", "SETTINGS"}
    local currentPage = "DASHBOARD"
    
    for i, page in ipairs(navPages) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/#navPages, 0, 1, 0)
        btn.Position = UDim2.new((i-1)/#navPages, 0, 0, 0)
        btn.Text = page
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        btn.Font = Enum.Font.Code
        btn.TextSize = 12
        btn.Parent = NavFrame
        
        btn.MouseButton1Click:Connect(function()
            currentPage = page
            updatePage()
            for _, button in pairs(navButtons) do
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end)
        
        table.insert(navButtons, btn)
    end
    
    -- Content Area
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, 0, 0.85, 0)
    ContentFrame.Position = UDim2.new(0, 0, 0.15, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    ContentFrame.Parent = MainContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentFrame
    
    -- UI Creation Functions
    local function createSection(title)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(0.95, 0, 0, 40)
        section.Position = UDim2.new(0.025, 0, 0, 0)
        section.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        section.BorderSizePixel = 0
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "  " .. title
        label.TextColor3 = Color3.fromRGB(0, 255, 255)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Code
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = section
        
        return section
    end
    
    local function createButton(text, callback, color)
        color = color or Color3.fromRGB(0, 150, 255)
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.95, 0, 0, 35)
        button.Position = UDim2.new(0.025, 0, 0, 0)
        button.Text = text
        button.BackgroundColor3 = color
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Code
        button.TextSize = 13
        
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    local function createToggle(text, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.95, 0, 0, 30)
        frame.BackgroundTransparency = 1
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Code
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0.25, 0, 0.8, 0)
        toggle.Position = UDim2.new(0.7, 0, 0.1, 0)
        toggle.Text = default and "ON" : "OFF"
        toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.Font = Enum.Font.Code
        toggle.TextSize = 12
        toggle.Parent = frame
        
        toggle.MouseButton1Click:Connect(function()
            default = not default
            toggle.Text = default and "ON" : "OFF"
            toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            callback(default)
        end)
        
        return frame
    end
    
    local function createInfoBox(text)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.95, 0, 0, 50)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        frame.BorderSizePixel = 0
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.9, 0, 0.8, 0)
        label.Position = UDim2.new(0.05, 0, 0.1, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Code
        label.TextSize = 12
        label.TextWrapped = true
        label.Parent = frame
        
        return frame
    end
    
    -- Page Update Function
    local function updatePage()
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        if currentPage == "DASHBOARD" then
            -- Game Info
            createSection("GAME INFORMATION").Parent = ContentFrame
            
            local gameInfo = Modules.Dashboard.GameInfo()
            for key, value in pairs(gameInfo) do
                createInfoBox(key .. ": " .. value).Parent = ContentFrame
            end
            
            -- Quick Actions
            createSection("QUICK ACTIONS").Parent = ContentFrame
            
            for _, action in pairs(Modules.Dashboard.QuickActions) do
                createButton("⚡ " .. action, function()
                    if action == "Toggle ESP" then
                        Modules.MainMenu.ESP.Toggle(not Config.Features.ESP.Enabled)
                    elseif action == "Start Auto-Farm" then
                        Modules.MainMenu.AutoFarm.Start()
                    elseif action == "Teleport to Spawn" then
                        Modules.MainMenu.Teleport.ToSpawn()
                    elseif action == "Server Hop" then
                        Modules.Utility.ServerTools.ServerHop()
                    elseif action == "Scan Game" then
                        local count = Modules.MainMenu.Remotes.Scan()
                        Status.Text = "SCANNED: " .. count
                    end
                end).Parent = ContentFrame
            end
            
            -- Performance
            createSection("PERFORMANCE").Parent = ContentFrame
            
            local perf = Modules.Dashboard.Performance()
            for key, value in pairs(perf) do
                createInfoBox(key .. ": " .. value).Parent = ContentFrame
            end
            
        elseif currentPage == "MAIN MENU" then
            -- Auto-Farm
            createSection("AUTO-FARM").Parent = ContentFrame
            
            createToggle("Enable Auto-Farm", Config.Features.AutoFarm.Enabled, function(value)
                if value then
                    Modules.MainMenu.AutoFarm.Start()
                else
                    Modules.MainMenu.AutoFarm.Stop()
                end
            end).Parent = ContentFrame
            
            createButton("Start Farming", Modules.MainMenu.AutoFarm.Start).Parent = ContentFrame
            createButton("Stop Farming", Modules.MainMenu.AutoFarm.Stop).Parent = ContentFrame
            
            -- Combat
            createSection("COMBAT").Parent = ContentFrame
            
            createToggle("Aimbot", Config.Features.Aimbot.Enabled, Modules.MainMenu.Combat.Aimbot).Parent = ContentFrame
            createButton("Kill All Players", Modules.MainMenu.Combat.KillAll, Color3.fromRGB(255, 50, 50)).Parent = ContentFrame
            
            -- Teleport
            createSection("TELEPORT").Parent = ContentFrame
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createButton("TP to " .. player.Name, function()
                        Modules.MainMenu.Teleport.ToPlayer(player.Name)
                    end).Parent = ContentFrame
                end
            end
            
            createButton("Teleport to Spawn", Modules.MainMenu.Teleport.ToSpawn).Parent = ContentFrame
            
            -- ESP
            createSection("ESP/VISUALS").Parent = ContentFrame
            
            createToggle("Enable ESP", Config.Features.ESP.Enabled, Modules.MainMenu.ESP.Toggle).Parent = ContentFrame
            
            -- Character
            createSection("CHARACTER").Parent = ContentFrame
            
            createButton("Set WalkSpeed 50", function()
                Modules.MainMenu.Character.SetWalkSpeed(50)
            end).Parent = ContentFrame
            
            createButton("Set JumpPower 100", function()
                Modules.MainMenu.Character.SetJumpPower(100)
            end).Parent = ContentFrame
            
            createToggle("NoClip", Config.Features.Character.Noclip, Modules.MainMenu.Character.ToggleNoclip).Parent = ContentFrame
            createToggle("God Mode", false, Modules.MainMenu.Character.GodMode).Parent = ContentFrame
            
            -- Remotes
            createSection("REMOTES").Parent = ContentFrame
            
            createButton("Scan Remotes", function()
                local count = Modules.MainMenu.Remotes.Scan()
                Status.Text = "REMOTES: " .. count
            end).Parent = ContentFrame
            
            createButton("Fire All Remotes", Modules.MainMenu.Remotes.FireAll, Color3.fromRGB(255, 150, 0)).Parent = ContentFrame
            createButton("Spoof All Remotes", Modules.MainMenu.Remotes.SpoofAll, Color3.fromRGB(255, 100, 0)).Parent = ContentFrame
            
        elseif currentPage == "UTILITY" then
            -- Script Hub
            createSection("SCRIPT HUB").Parent = ContentFrame
            
            for _, script in pairs(Modules.Utility.ScriptHub.PopularScripts) do
                createButton("📜 " .. script[1], function()
                    Modules.Utility.ScriptHub.LoadScript(script[2])
                end).Parent = ContentFrame
            end
            
            -- Game Scanner
            createSection("GAME SCANNER").Parent = ContentFrame
            
            createButton("Deep Scan Game", function()
                local results = Modules.Utility.GameScanner.DeepScan()
                Status.Text = "SCANNED"
                for key, value in pairs(results) do
                    createInfoBox(key .. ": " .. value).Parent = ContentFrame
                end
            end).Parent = ContentFrame
            
            -- Player Manager
            createSection("PLAYER MANAGER").Parent = ContentFrame
            
            for _, player in pairs(Modules.Utility.PlayerManager.List()) do
                createInfoBox(player.Name .. " | Age: " .. player.AccountAge).Parent = ContentFrame
            end
            
            -- Server Tools
            createSection("SERVER TOOLS").Parent = ContentFrame
            
            createButton("Server Hop", Modules.Utility.ServerTools.ServerHop).Parent = ContentFrame
            createButton("Rejoin Server", Modules.Utility.ServerTools.Rejoin).Parent = ContentFrame
            createButton("Copy Job ID", Modules.Utility.ServerTools.CopyJobId).Parent = ContentFrame
            
            -- Developer
            createSection("DEVELOPER TOOLS").Parent = ContentFrame
            
            createButton("Dump Scripts", function()
                local scripts = Modules.Utility.GameScanner.DumpScripts()
                Status.Text = "DUMPED: " .. #scripts
            end).Parent = ContentFrame
            
        elseif currentPage == "SETTINGS" then
            -- UI Settings
            createSection("UI SETTINGS").Parent = ContentFrame
            
            for _, theme in pairs(Modules.Settings.UI.Themes) do
                createButton(theme, function()
                    Modules.Settings.UI.SetTheme(theme)
                end).Parent = ContentFrame
            end
            
            -- Keybinds
            createSection("KEYBINDS").Parent = ContentFrame
            
            for action, key in pairs(Config.UI.Keybinds) do
                createInfoBox(action .. ": " .. tostring(key)).Parent = ContentFrame
            end
            
            createButton("Reset Keybinds", Modules.Settings.Keybinds.Reset).Parent = ContentFrame
            
            -- Profiles
            createSection("PROFILES").Parent = ContentFrame
            
            createButton("Save Profile", function()
                Modules.Settings.Profiles.Save("default")
            end).Parent = ContentFrame
            
            createButton("Load Profile", function()
                Modules.Settings.Profiles.Load("default")
            end).Parent = ContentFrame
            
            -- System
            createSection("SYSTEM").Parent = ContentFrame
            
            createButton("Export Config", Modules.Settings.System.ExportConfig).Parent = ContentFrame
            createButton("Unload Script", function()
                Modules.Settings.System.Unload()
                DyronUI:Destroy()
            end, Color3.fromRGB(255, 50, 50)).Parent = ContentFrame
        end
        
        -- Update canvas size
        task.wait()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end
    
    -- Keybinds
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Config.UI.Keybinds.ToggleUI then
                MainContainer.Visible = not MainContainer.Visible
            elseif input.KeyCode == Config.UI.Keybinds.ToggleESP then
                Modules.MainMenu.ESP.Toggle(not Config.Features.ESP.Enabled)
            elseif input.KeyCode == Config.UI.Keybinds.ToggleFarm then
                if Config.Features.AutoFarm.Enabled then
                    Modules.MainMenu.AutoFarm.Stop()
                else
                    Modules.MainMenu.AutoFarm.Start()
                end
            elseif input.KeyCode == Config.UI.Keybinds.ToggleNoclip then
                Modules.MainMenu.Character.ToggleNoclip(not Config.Features.Character.Noclip)
            end
        end
    end)
    
    -- Initialize
    navButtons[1].BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    updatePage()
    
    -- Auto-scan on load
    spawn(function()
        task.wait(2)
        local count = Modules.MainMenu.Remotes.Scan()
        Status.Text = "READY | " .. count .. " REMOTES"
    end)
    
    return DyronUI
end

-- Initialize
local GUI = createGUI()

print("========================================")
print("DYRON UNIFIED EXPLOIT FRAMEWORK v4.0")
print("========================================")
print("Dashboard: Game info & quick actions")
print("Main Menu: All exploit features")
print("Utility: Advanced tools & scripts")
print("Settings: Configuration & profiles")
print("")
print("Keybinds:")
print("RightControl - Toggle UI")
print("F1 - Toggle ESP")
print("F2 - Toggle Auto-Farm")
print("F3 - Toggle NoClip")
print("========================================")