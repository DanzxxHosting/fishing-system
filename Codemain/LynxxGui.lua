-- game_fisher_gui.lua
-- Advanced game data fishing interface

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Data storage
local FishedData = {
    Remotes = {},
    Modules = {},
    Scripts = {},
    Instances = {},
    GameInfo = {}
}

-- Main GUI
local FisherGUI = Instance.new("ScreenGui")
FisherGUI.Name = "GameFisherV3"
FisherGUI.Parent = CoreGui

-- Main container
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0.4, 0, 0.8, 0)
MainContainer.Position = UDim2.new(0.3, 0, 0.1, 0)
MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainContainer.BorderSizePixel = 0
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = FisherGUI

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0.07, 0)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Header.BorderSizePixel = 0
Header.Parent = MainContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Text = "🎣 GAME FISHER v3.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.4, 0, 1, 0)
StatusLabel.Position = UDim2.new(0.6, 0, 0, 0)
StatusLabel.Text = "READY"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
StatusLabel.Parent = Header

-- Tabs
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0.05, 0)
TabsFrame.Position = UDim2.new(0, 0, 0.07, 0)
TabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainContainer

local tabs = {"SCANNER", "REMOTES", "MODULES", "PLAYERS", "LOOT", "EXPLOIT", "SETTINGS"}
local currentTab = "SCANNER"
local TabButtons = {}

for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1/#tabs, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    TabButton.BorderSizePixel = 0
    TabButton.Font = Enum.Font.Code
    TabButton.TextSize = 12
    TabButton.Parent = TabsFrame
    
    TabButton.MouseButton1Click:Connect(function()
        currentTab = tabName
        updateTab()
        for _, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
    
    table.insert(TabButtons, TabButton)
end

-- Content area
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, 0, 0.88, 0)
ContentFrame.Position = UDim2.new(0, 0, 0.12, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
ContentFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
ContentFrame.Parent = MainContainer

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentFrame

-- Update status
local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
end

-- UI Creation Functions
local function createSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.95, 0, 0, 40)
    section.Position = UDim2.new(0.025, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
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
    button.AutoButtonColor = true
    
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
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
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
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    return frame
end

-- Fishing Functions
local function deepScan(gameObject)
    local data = {
        Remotes = {},
        Modules = {},
        Scripts = {},
        Values = {},
        Configs = {}
    }
    
    local function scan(obj, depth)
        if depth > 5 then return end
        
        if obj:IsA("RemoteFunction") then
            table.insert(data.Remotes, {
                Name = obj.Name,
                Type = "RemoteFunction",
                Path = obj:GetFullName(),
                Parent = obj.Parent.Name
            })
        elseif obj:IsA("RemoteEvent") then
            table.insert(data.Remotes, {
                Name = obj.Name,
                Type = "RemoteEvent",
                Path = obj:GetFullName(),
                Parent = obj.Parent.Name
            })
        elseif obj:IsA("ModuleScript") then
            table.insert(data.Modules, {
                Name = obj.Name,
                Path = obj:GetFullName()
            })
        elseif obj:IsA("Script") or obj:IsA("LocalScript") then
            table.insert(data.Scripts, {
                Name = obj.Name,
                Type = obj.ClassName,
                Path = obj:GetFullName()
            })
        elseif obj:IsA("Configuration") or obj:IsA("Folder") then
            if string.find(obj.Name:lower(), "config") or 
               string.find(obj.Name:lower(), "setting") or
               string.find(obj.Name:lower(), "data") then
                table.insert(data.Configs, {
                    Name = obj.Name,
                    Path = obj:GetFullName(),
                    Children = #obj:GetChildren()
                })
            end
        end
        
        for _, child in pairs(obj:GetChildren()) do
            scan(child, depth + 1)
        end
    end
    
    scan(gameObject, 0)
    return data
end

local function fishRemotes()
    updateStatus("FISHING REMOTES...", Color3.fromRGB(255, 255, 0))
    
    FishedData.Remotes = {}
    local containers = {
        ReplicatedStorage,
        Workspace,
        game:GetService("ServerScriptService"),
        game:GetService("ServerStorage"),
        game:GetService("Lighting")
    }
    
    for _, container in pairs(containers) do
        for _, remote in pairs(container:GetDescendants()) do
            if remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent") then
                table.insert(FishedData.Remotes, {
                    Object = remote,
                    Name = remote.Name,
                    Type = remote.ClassName,
                    Path = remote:GetFullName(),
                    Parent = remote.Parent.Name
                })
            end
        end
    end
    
    updateStatus(string.format("FOUND %d REMOTES", #FishedData.Remotes), Color3.fromRGB(0, 255, 0))
    return #FishedData.Remotes
end

local function fishModules()
    updateStatus("FISHING MODULES...", Color3.fromRGB(255, 255, 0))
    
    FishedData.Modules = {}
    local containers = {
        ReplicatedStorage,
        game:GetService("ServerScriptService"),
        game:GetService("StarterPlayer").StarterPlayerScripts,
        game:GetService("StarterPack"),
        game:GetService("StarterGui")
    }
    
    for _, container in pairs(containers) do
        for _, module in pairs(container:GetDescendants()) do
            if module:IsA("ModuleScript") then
                local success, source = pcall(function()
                    return require(module)
                end)
                
                table.insert(FishedData.Modules, {
                    Object = module,
                    Name = module.Name,
                    Path = module:GetFullName(),
                    HasSource = success,
                    Source = success and source or nil
                })
            end
        end
    end
    
    updateStatus(string.format("FOUND %d MODULES", #FishedData.Modules), Color3.fromRGB(0, 255, 0))
    return #FishedData.Modules
end

local function fishPlayers()
    FishedData.Players = {}
    for _, player in pairs(Players:GetPlayers()) do
        local data = {
            Name = player.Name,
            UserId = player.UserId,
            DisplayName = player.DisplayName,
            AccountAge = player.AccountAge,
            Character = player.Character,
            Team = player.Team,
            Leaderstats = {}
        }
        
        if player:FindFirstChild("leaderstats") then
            for _, stat in pairs(player.leaderstats:GetChildren()) do
                data.Leaderstats[stat.Name] = stat.Value
            end
        end
        
        table.insert(FishedData.Players, data)
    end
    return #FishedData.Players
end

local function fishGameInfo()
    FishedData.GameInfo = {
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        CreatorId = game.CreatorId,
        Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
        Description = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Description,
        Players = #Players:GetPlayers(),
        MaxPlayers = game:GetService("Players").MaxPlayers
    }
end

local function exportData()
    local export = {
        Timestamp = os.time(),
        GameInfo = FishedData.GameInfo,
        Remotes = {},
        Modules = {},
        Players = FishedData.Players
    }
    
    for _, remote in pairs(FishedData.Remotes) do
        table.insert(export.Remotes, {
            Name = remote.Name,
            Type = remote.Type,
            Path = remote.Path
        })
    end
    
    for _, module in pairs(FishedData.Modules) do
        table.insert(export.Modules, {
            Name = module.Name,
            Path = module.Path,
            HasSource = module.HasSource
        })
    end
    
    local json = HttpService:JSONEncode(export)
    
    if writefile then
        local filename = string.format("fished_%s_%s.json", game.PlaceId, os.time())
        writefile(filename, json)
        updateStatus("EXPORTED: " .. filename, Color3.fromRGB(0, 255, 0))
    else
        setclipboard(json)
        updateStatus("COPIED TO CLIPBOARD", Color3.fromRGB(0, 255, 0))
    end
end

-- Tab update function
local function updateTab()
    for _, child in pairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    if currentTab == "SCANNER" then
        createSection("GAME SCANNER").Parent = ContentFrame
        createButton("🔍 DEEP SCAN GAME", function()
            local data = deepScan(game)
            updateStatus("DEEP SCAN COMPLETE", Color3.fromRGB(0, 255, 0))
        end).Parent = ContentFrame
        
        createButton("🎣 FISH ALL REMOTES", fishRemotes).Parent = ContentFrame
        createButton("📦 FISH ALL MODULES", fishModules).Parent = ContentFrame
        createButton("👥 SCAN PLAYERS", fishPlayers).Parent = ContentFrame
        createButton("ℹ️ GET GAME INFO", fishGameInfo).Parent = ContentFrame
        
        createSection("EXPORT").Parent = ContentFrame
        createButton("💾 EXPORT TO FILE", exportData, Color3.fromRGB(0, 200, 100)).Parent = ContentFrame
        
        createInfoBox("Found: " .. #FishedData.Remotes .. " remotes, " .. #FishedData.Modules .. " modules").Parent = ContentFrame
        
    elseif currentTab == "REMOTES" then
        createSection("REMOTE FUNCTIONS & EVENTS").Parent = ContentFrame
        
        for _, remote in pairs(FishedData.Remotes) do
            local btn = createButton(remote.Type .. ": " .. remote.Name, function()
                if remote.Type == "RemoteEvent" then
                    pcall(function()
                        remote.Object:FireServer()
                        updateStatus("FIRED: " .. remote.Name, Color3.fromRGB(0, 255, 0))
                    end)
                else
                    pcall(function()
                        remote.Object:InvokeServer()
                        updateStatus("INVOKED: " .. remote.Name, Color3.fromRGB(0, 255, 0))
                    end)
                end
            end)
            
            local info = Instance.new("TextLabel")
            info.Size = UDim2.new(1, 0, 0, 15)
            info.Position = UDim2.new(0, 0, 0.7, 0)
            info.Text = "Path: " .. string.sub(remote.Path, 1, 30) .. "..."
            info.TextColor3 = Color3.fromRGB(150, 150, 150)
            info.BackgroundTransparency = 1
            info.Font = Enum.Font.Code
            info.TextSize = 10
            info.TextXAlignment = Enum.TextXAlignment.Left
            info.Parent = btn
            
            btn.Parent = ContentFrame
        end
        
        if #FishedData.Remotes == 0 then
            createInfoBox("No remotes found. Run scanner first.").Parent = ContentFrame
        end
        
    elseif currentTab == "MODULES" then
        createSection("MODULE SCRIPTS").Parent = ContentFrame
        
        for _, module in pairs(FishedData.Modules) do
            local btn = createButton("📜 " .. module.Name, function()
                if module.HasSource then
                    print("Module Source:", module.Source)
                    if setclipboard then
                        setclipboard(tostring(module.Source))
                        updateStatus("COPIED MODULE SOURCE", Color3.fromRGB(0, 255, 0))
                    end
                end
            end, module.HasSource and Color3.fromRGB(0, 150, 200) or Color3.fromRGB(150, 150, 150))
            
            btn.Parent = ContentFrame
        end
        
    elseif currentTab == "PLAYERS" then
        createSection("PLAYER INFORMATION").Parent = ContentFrame
        
        for _, player in pairs(FishedData.Players or {}) do
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0.95, 0, 0, 60)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            frame.BorderSizePixel = 0
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Font = Enum.Font.Code
            nameLabel.TextSize = 14
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = frame
            
            local idLabel = Instance.new("TextLabel")
            idLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
            idLabel.Position = UDim2.new(0, 0, 0.5, 0)
            idLabel.Text = "ID: " .. player.UserId .. " | Age: " .. player.AccountAge
            idLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            idLabel.BackgroundTransparency = 1
            idLabel.Font = Enum.Font.Code
            idLabel.TextSize = 12
            idLabel.TextXAlignment = Enum.TextXAlignment.Left
            idLabel.Parent = frame
            
            if player.Leaderstats then
                local statsText = ""
                for statName, value in pairs(player.Leaderstats) do
                    statsText = statsText .. statName .. ": " .. tostring(value) .. "  "
                end
                
                if statsText ~= "" then
                    local statsLabel = Instance.new("TextLabel")
                    statsLabel.Size = UDim2.new(1, 0, 0.5, 0)
                    statsLabel.Position = UDim2.new(0, 0, 1, 0)
                    statsLabel.Text = statsText
                    statsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
                    statsLabel.BackgroundTransparency = 1
                    statsLabel.Font = Enum.Font.Code
                    statsLabel.TextSize = 11
                    statsLabel.Parent = frame
                    frame.Size = UDim2.new(0.95, 0, 0, 80)
                end
            end
            
            frame.Parent = ContentFrame
        end
        
    elseif currentTab == "LOOT" then
        createSection("LOOT FINDER").Parent = ContentFrame
        
        createButton("💰 FIND MONEY VALUES", function()
            local moneyItems = {}
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("StringValue") or obj:IsA("IntValue") or obj:IsA("NumberValue") then
                    if string.find(obj.Name:lower(), "money") or 
                       string.find(obj.Name:lower(), "cash") or
                       string.find(obj.Name:lower(), "coin") or
                       string.find(obj.Name:lower(), "gem") then
                        table.insert(moneyItems, {
                            Name = obj.Name,
                            Value = obj.Value,
                            Path = obj:GetFullName()
                        })
                    end
                end
            end
            
            for _, item in pairs(moneyItems) do
                createInfoBox(item.Name .. ": " .. tostring(item.Value)).Parent = ContentFrame
            end
        end).Parent = ContentFrame
        
        createButton("📦 FIND COLLECTIBLES", function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") and (obj.Name:lower():find("coin") or 
                   obj.Name:lower():find("gem") or 
                   obj.Name:lower():find("reward")) then
                    createButton("🎁 " .. obj.Name, function()
                        LocalPlayer.Character:MoveTo(obj.Position)
                    end).Parent = ContentFrame
                end
            end
        end).Parent = ContentFrame
        
    elseif currentTab == "EXPLOIT" then
        createSection("EXPLOIT TOOLS").Parent = ContentFrame
        
        createToggle("AUTO-FARM MODE", false, function(value)
            if value then
                spawn(function()
                    while task.wait(0.1) do
                        for _, remote in pairs(FishedData.Remotes) do
                            if string.find(remote.Name:lower(), "collect") or
                               string.find(remote.Name:lower(), "click") or
                               string.find(remote.Name:lower(), "farm") then
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
            end
        end).Parent = ContentFrame
        
        createButton("SPOOF ALL REMOTES", function()
            for _, remote in pairs(FishedData.Remotes) do
                if remote.Type == "RemoteFunction" then
                    pcall(function()
                        local oldInvoke = remote.Object.InvokeServer
                        remote.Object.InvokeServer = function(self, ...)
                            return 999999
                        end
                    end)
                end
            end
            updateStatus("ALL REMOTES SPOOFED", Color3.fromRGB(255, 100, 0))
        end).Parent = ContentFrame
        
        createButton("TELEPORT TO SPAWN", function()
            local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
            if spawn then
                LocalPlayer.Character:MoveTo(spawn.Position)
            end
        end).Parent = ContentFrame
        
    elseif currentTab == "SETTINGS" then
        createSection("CONFIGURATION").Parent = ContentFrame
        
        createToggle("AUTO-SCAN ON LOAD", true, function(value)
            -- Save to config
        end).Parent = ContentFrame
        
        createToggle("SHOW NOTIFICATIONS", true, function(value)
            -- Notification setting
        end).Parent = ContentFrame
        
        createButton("CLEAR ALL DATA", function()
            FishedData = {Remotes = {}, Modules = {}, Players = {}, GameInfo = {}}
            updateStatus("DATA CLEARED", Color3.fromRGB(255, 100, 0))
            updateTab()
        end, Color3.fromRGB(255, 50, 50)).Parent = ContentFrame
        
        createButton("HIDE GUI", function()
            MainContainer.Visible = false
        end).Parent = ContentFrame
        
        createButton("DESTROY GUI", function()
            FisherGUI:Destroy()
        end, Color3.fromRGB(255, 0, 0)).Parent = ContentFrame
    end
    
    -- Update canvas size
    task.wait()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end

-- Keybinds
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.F4 then
            MainContainer.Visible = not MainContainer.Visible
        elseif input.KeyCode == Enum.KeyCode.F5 then
            updateTab()
        end
    end
end)

-- Initial scan
fishGameInfo()
fishPlayers()
updateTab()

print("🎣 Game Fisher v3.0 loaded!")
print("Press F4 to toggle GUI")
print("Press F5 to refresh")