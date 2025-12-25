-- 🕵️ FISHING NETWORK SPY TOOL v2.0
-- Advanced monitoring untuk semua fishing-related network calls

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- CONFIGURATION
----------------------------------------------------------------

local CONFIG = {
    -- Warna untuk tipe event berbeda
    COLORS = {
        FireServer = Color3.fromRGB(255, 100, 100),    -- Merah
        InvokeServer = Color3.fromRGB(100, 200, 255),  -- Biru
        OnClientEvent = Color3.fromRGB(100, 255, 100), -- Hijau
        OnServerEvent = Color3.fromRGB(255, 255, 100)  -- Kuning
    },
    
    -- Filter events (opsional)
    FILTERS = {
        include = {"Fishing", "Fish", "Rod", "Catch", "Minigame", "Complete", "Cancel"},
        exclude = {}
    },
    
    -- Auto-save settings
    AUTO_SAVE = {
        enabled = true,
        interval = 60,  -- detik
        maxEntries = 1000
    },
    
    -- UI settings
    MAX_DISPLAY = 50,
    MAX_ARG_LENGTH = 100
}

----------------------------------------------------------------
-- SPY ENGINE CORE
----------------------------------------------------------------

local FishingSpy = {
    Logs = {},
    HookedEvents = {},
    IsRunning = false,
    UI = nil
}

-- Format data untuk display
local function formatValue(value)
    if type(value) == "table" then
        local str = "{"
        local count = 0
        for k, v in pairs(value) do
            if count < 3 then  -- Batasi untuk UI
                str = str .. tostring(k) .. "=" .. tostring(v) .. ", "
                count = count + 1
            else
                str = str .. "..."
                break
            end
        end
        return str:gsub(", $", "") .. "}"
    elseif type(value) == "string" then
        if #value > CONFIG.MAX_ARG_LENGTH then
            return '"' .. value:sub(1, CONFIG.MAX_ARG_LENGTH) .. '..."'
        end
        return '"' .. value .. '"'
    else
        return tostring(value)
    end
end

-- Filter events berdasarkan konfigurasi
local function shouldLogEvent(eventName)
    -- Jika ada filter include, hanya log yang mengandung kata kunci
    if #CONFIG.FILTERS.include > 0 then
        for _, keyword in ipairs(CONFIG.FILTERS.include) do
            if string.find(string.lower(eventName), string.lower(keyword)) then
                return true
            end
        end
        return false
    end
    
    -- Jika ada filter exclude, skip yang mengandung kata kunci
    if #CONFIG.FILTERS.exclude > 0 then
        for _, keyword in ipairs(CONFIG.FILTERS.exclude) do
            if string.find(string.lower(eventName), string.lower(keyword)) then
                return false
            end
        end
    end
    
    return true
end

-- Hook RemoteEvent
local function hookRemoteEvent(event)
    if FishingSpy.HookedEvents[event] then
        return false  -- Sudah di-hook
    end
    
    local eventName = event.Name
    local eventPath = event:GetFullName()
    
    -- Skip jika tidak perlu di-log
    if not shouldLogEvent(eventName) then
        return false
    end
    
    -- Simpan fungsi asli
    local oldFireServer = event.FireServer
    local oldOnClientEvent = event.OnClientEvent
    
    -- Hook FireServer (Client → Server)
    if oldFireServer then
        event.FireServer = function(self, ...)
            local args = {...}
            local timestamp = tick()
            
            -- Log the call
            local logEntry = {
                type = "FireServer",
                name = eventName,
                path = eventPath,
                args = args,
                timestamp = timestamp,
                player = player.Name,
                stack = debug.traceback()
            }
            
            table.insert(FishingSpy.Logs, 1, logEntry)  -- Insert di awal
            
            -- Truncate jika terlalu banyak
            if #FishingSpy.Logs > CONFIG.AUTO_SAVE.maxEntries then
                table.remove(FishingSpy.Logs, #FishingSpy.Logs)
            end
            
            -- Update UI
            if FishingSpy.UI and FishingSpy.UI.addLog then
                local displayArgs = ""
                for i, arg in ipairs(args) do
                    if i <= 3 then  -- Hanya tampilkan 3 argumen pertama
                        displayArgs = displayArgs .. formatValue(arg) .. ", "
                    end
                end
                displayArgs = displayArgs:gsub(", $", "")
                
                FishingSpy.UI.addLog(
                    string.format("🔥 [FireServer] %s(%s)", eventName, displayArgs),
                    CONFIG.COLORS.FireServer
                )
            end
            
            -- Panggil fungsi asli
            return oldFireServer(self, ...)
        end
    end
    
    -- Hook OnClientEvent (Server → Client)
    if oldOnClientEvent then
        -- Tambahkan connection baru tanpa menghapus yang lama
        event.OnClientEvent:Connect(function(...)
            local args = {...}
            local timestamp = tick()
            
            -- Log the call
            local logEntry = {
                type = "OnClientEvent",
                name = eventName,
                path = eventPath,
                args = args,
                timestamp = timestamp,
                player = player.Name
            }
            
            table.insert(FishingSpy.Logs, 1, logEntry)
            
            -- Truncate jika terlalu banyak
            if #FishingSpy.Logs > CONFIG.AUTO_SAVE.maxEntries then
                table.remove(FishingSpy.Logs, #FishingSpy.Logs)
            end
            
            -- Update UI
            if FishingSpy.UI and FishingSpy.UI.addLog then
                local displayArgs = ""
                for i, arg in ipairs(args) do
                    if i <= 2 then  -- Hanya tampilkan 2 argumen pertama
                        displayArgs = displayArgs .. formatValue(arg) .. ", "
                    end
                end
                displayArgs = displayArgs:gsub(", $", "")
                
                FishingSpy.UI.addLog(
                    string.format("📥 [OnClientEvent] %s(%s)", eventName, displayArgs),
                    CONFIG.COLORS.OnClientEvent
                )
            end
        end)
    end
    
    FishingSpy.HookedEvents[event] = true
    
    print(string.format("✅ Hooked: %s (%s)", eventName, eventPath))
    return true
end

-- Hook RemoteFunction
local function hookRemoteFunction(func)
    if FishingSpy.HookedEvents[func] then
        return false
    end
    
    local funcName = func.Name
    local funcPath = func:GetFullName()
    
    -- Skip jika tidak perlu di-log
    if not shouldLogEvent(funcName) then
        return false
    end
    
    -- Simpan fungsi asli
    local oldInvokeServer = func.InvokeServer
    local oldOnClientInvoke = func.OnClientInvoke
    
    -- Hook InvokeServer (Client → Server)
    if oldInvokeServer then
        func.InvokeServer = function(self, ...)
            local args = {...}
            local timestamp = tick()
            
            -- Log the call
            local logEntry = {
                type = "InvokeServer",
                name = funcName,
                path = funcPath,
                args = args,
                timestamp = timestamp,
                player = player.Name,
                stack = debug.traceback()
            }
            
            table.insert(FishingSpy.Logs, 1, logEntry)
            
            -- Truncate jika terlalu banyak
            if #FishingSpy.Logs > CONFIG.AUTO_SAVE.maxEntries then
                table.remove(FishingSpy.Logs, #FishingSpy.Logs)
            end
            
            -- Update UI
            if FishingSpy.UI and FishingSpy.UI.addLog then
                local displayArgs = ""
                for i, arg in ipairs(args) do
                    if i <= 3 then
                        displayArgs = displayArgs .. formatValue(arg) .. ", "
                    end
                end
                displayArgs = displayArgs:gsub(", $", "")
                
                FishingSpy.UI.addLog(
                    string.format("📞 [InvokeServer] %s(%s)", funcName, displayArgs),
                    CONFIG.COLORS.InvokeServer
                )
            end
            
            -- Eksekusi dan tangkap return value
            local returnValues = {oldInvokeServer(self, ...)}
            
            -- Log return values
            if #returnValues > 0 then
                local returnLogEntry = {
                    type = "InvokeServer_Return",
                    name = funcName,
                    returnValues = returnValues,
                    timestamp = tick(),
                    player = player.Name
                }
                
                table.insert(FishingSpy.Logs, 1, returnLogEntry)
                
                if FishingSpy.UI and FishingSpy.UI.addLog then
                    local returnStr = ""
                    for i, val in ipairs(returnValues) do
                        if i <= 2 then
                            returnStr = returnStr .. formatValue(val) .. ", "
                        end
                    end
                    returnStr = returnStr:gsub(", $", "")
                    
                    FishingSpy.UI.addLog(
                        string.format("📤 [Return] %s → %s", funcName, returnStr),
                        Color3.fromRGB(200, 150, 255)
                    )
                end
            end
            
            return unpack(returnValues)
        end
    end
    
    FishingSpy.HookedEvents[func] = true
    
    print(string.format("✅ Hooked: %s (%s)", funcName, funcPath))
    return true
end

----------------------------------------------------------------
-- AUTO-DISCOVERY ENGINE
----------------------------------------------------------------

-- Cari semua fishing-related network objects
local function discoverFishingNetworkObjects()
    local foundObjects = {}
    
    -- Cari di sleitnick_net
    local function searchInNetFolder(folder)
        if not folder then return end
        
        for _, obj in pairs(folder:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and shouldLogEvent(obj.Name) then
                table.insert(foundObjects, {
                    object = obj,
                    name = obj.Name,
                    path = obj:GetFullName(),
                    type = obj.ClassName
                })
            end
        end
    end
    
    -- Cari di berbagai lokasi yang mungkin
    local searchPaths = {
        ReplicatedStorage,
        ReplicatedStorage:FindFirstChild("Packages"),
        ReplicatedStorage:FindFirstChild("Events"),
        ReplicatedStorage:FindFirstChild("Remotes"),
        game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts"),
        game:GetService("StarterPlayer"):FindFirstChild("StarterCharacterScripts")
    }
    
    for _, path in pairs(searchPaths) do
        if path then
            searchInNetFolder(path)
        end
    end
    
    -- Cari khusus sleitnick_net
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages then
        local _Index = packages:FindFirstChild("_Index")
        if _Index then
            local sleitnick = _Index:FindFirstChild("sleitnick_net@0.2.0")
            if sleitnick then
                local net = sleitnick:FindFirstChild("net")
                if net then
                    searchInNetFolder(net)
                end
            end
        end
    end
    
    return foundObjects
end

-- Hook semua yang ditemukan
local function hookDiscoveredObjects()
    local objects = discoverFishingNetworkObjects()
    local hookedCount = 0
    
    print("🔍 Discovering network objects...")
    print("📊 Found", #objects, "potential fishing network objects")
    
    for _, objInfo in pairs(objects) do
        if objInfo.object:IsA("RemoteEvent") then
            if hookRemoteEvent(objInfo.object) then
                hookedCount = hookedCount + 1
            end
        elseif objInfo.object:IsA("RemoteFunction") then
            if hookRemoteFunction(objInfo.object) then
                hookedCount = hookedCount + 1
            end
        end
    end
    
    print(string.format("✅ Successfully hooked %d/%d objects", hookedCount, #objects))
    return hookedCount
end

----------------------------------------------------------------
-- EXPORT & IMPORT FUNCTIONS
----------------------------------------------------------------

-- Export logs ke JSON
function FishingSpy.exportLogs(format)
    if format == "json" then
        local exportData = {
            metadata = {
                exportTime = os.date("%Y-%m-%d %H:%M:%S"),
                player = player.Name,
                gameId = game.GameId,
                placeId = game.PlaceId,
                totalLogs = #FishingSpy.Logs
            },
            logs = FishingSpy.Logs
        }
        
        local json = HttpService:JSONEncode(exportData)
        if game:GetService("RunService"):IsStudio() then
            writefile("fishing_spy_logs_" .. os.time() .. ".json", json)
            print("💾 Logs saved to file!")
        end
        
        return json
    elseif format == "lua" then
        local luaTable = "return {\n"
        for i, log in ipairs(FishingSpy.Logs) do
            luaTable = luaTable .. string.format("  [%d] = {type = '%s', name = '%s', args = %s},\n", 
                i, log.type, log.name, formatValue(log.args))
        end
        luaTable = luaTable .. "}"
        return luaTable
    end
end

-- Import logs dari JSON
function FishingSpy.importLogs(jsonData)
    local success, data = pcall(function()
        return HttpService:JSONDecode(jsonData)
    end)
    
    if success then
        FishingSpy.Logs = data.logs or {}
        print(string.format("📥 Imported %d logs", #FishingSpy.Logs))
        return true
    else
        warn("Failed to import logs:", data)
        return false
    end
end

-- Clear logs
function FishingSpy.clearLogs()
    FishingSpy.Logs = {}
    if FishingSpy.UI then
        FishingSpy.UI.clearLogs()
    end
    print("🧹 Logs cleared")
end

-- Get statistics
function FishingSpy.getStats()
    local stats = {
        totalLogs = #FishingSpy.Logs,
        hookedEvents = 0,
        byType = {}
    }
    
    for _ in pairs(FishingSpy.HookedEvents) do
        stats.hookedEvents = stats.hookedEvents + 1
    end
    
    for _, log in ipairs(FishingSpy.Logs) do
        stats.byType[log.type] = (stats.byType[log.type] or 0) + 1
    end
    
    return stats
end

----------------------------------------------------------------
-- SPY UI
----------------------------------------------------------------

function FishingSpy.createUI()
    -- Hapus UI lama jika ada
    if playerGui:FindFirstChild("SpyUI") then
        playerGui.SpyUI:Destroy()
    end
    
    -- Buat ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpyUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main window
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- Glass effect
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    titleBar.BackgroundTransparency = 0.2
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -100, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "🕵️ Fishing Network Spy v2.0"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 15, 0, 0)
    
    -- Stats display
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Name = "Stats"
    statsLabel.Size = UDim2.new(0, 200, 0, 40)
    statsLabel.Position = UDim2.new(1, -210, 0, 0)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "Logs: 0 | Hooked: 0"
    statsLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    statsLabel.TextSize = 14
    statsLabel.Font = Enum.Font.GothamMedium
    statsLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Control buttons
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -20, 0, 40)
    buttonContainer.Position = UDim2.new(0, 10, 0, 45)
    buttonContainer.BackgroundTransparency = 1
    
    local function createControlButton(text, color, position)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 80, 0, 30)
        button.Position = position
        button.BackgroundColor3 = color
        button.BackgroundTransparency = 0.2
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.GothamMedium
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = button
        
        return button
    end
    
    local clearBtn = createControlButton("Clear", Color3.fromRGB(255, 100, 100), UDim2.new(0, 0, 0, 0))
    local exportBtn = createControlButton("Export", Color3.fromRGB(100, 200, 100), UDim2.new(0, 90, 0, 0))
    local hookBtn = createControlButton("Re-Hook", Color3.fromRGB(100, 150, 255), UDim2.new(0, 180, 0, 0))
    local filterBtn = createControlButton("Filter", Color3.fromRGB(255, 200, 100), UDim2.new(0, 270, 0, 0))
    
    -- Log display
    local logFrame = Instance.new("ScrollingFrame")
    logFrame.Name = "LogFrame"
    logFrame.Size = UDim2.new(1, -20, 1, -140)
    logFrame.Position = UDim2.new(0, 10, 0, 95)
    logFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    logFrame.BackgroundTransparency = 0.1
    logFrame.BorderSizePixel = 0
    logFrame.ScrollBarThickness = 8
    logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local logList = Instance.new("UIListLayout")
    logList.Padding = UDim.new(0, 2)
    logList.Parent = logFrame
    
    -- Detail panel
    local detailFrame = Instance.new("Frame")
    detailFrame.Name = "DetailFrame"
    detailFrame.Size = UDim2.new(1, -20, 0, 100)
    detailFrame.Position = UDim2.new(0, 10, 1, -110)
    detailFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    detailFrame.BackgroundTransparency = 0.1
    detailFrame.Visible = false
    
    local detailCorner = Instance.new("UICorner")
    detailCorner.CornerRadius = UDim.new(0, 8)
    detailCorner.Parent = detailFrame
    
    local detailText = Instance.new("TextLabel")
    detailText.Name = "DetailText"
    detailText.Size = UDim2.new(1, -10, 1, -10)
    detailText.Position = UDim2.new(0, 5, 0, 5)
    detailText.BackgroundTransparency = 1
    detailText.Text = "Select a log to view details"
    detailText.TextColor3 = Color3.fromRGB(200, 200, 220)
    detailText.TextSize = 12
    detailText.Font = Enum.Font.Code
    detailText.TextXAlignment = Enum.TextXAlignment.Left
    detailText.TextYAlignment = Enum.TextYAlignment.Top
    detailText.TextWrapped = true
    
    -- Assembly
    detailText.Parent = detailFrame
    detailFrame.Parent = mainFrame
    
    clearBtn.Parent = buttonContainer
    exportBtn.Parent = buttonContainer
    hookBtn.Parent = buttonContainer
    filterBtn.Parent = buttonContainer
    buttonContainer.Parent = mainFrame
    
    title.Parent = titleBar
    statsLabel.Parent = titleBar
    titleBar.Parent = mainFrame
    logFrame.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = playerGui
    
    -- UI Functions
    local uiFunctions = {
        addLog = function(text, color)
            local logEntry = Instance.new("TextLabel")
            logEntry.Size = UDim2.new(1, -10, 0, 20)
            logEntry.BackgroundTransparency = 1
            logEntry.Text = text
            logEntry.TextColor3 = color or Color3.fromRGB(255, 255, 255)
            logEntry.TextSize = 12
            logEntry.Font = Enum.Font.Code
            logEntry.TextXAlignment = Enum.TextXAlignment.Left
            logEntry.TextYAlignment = Enum.TextYAlignment.Top
            logEntry.TextWrapped = true
            logEntry.TextTruncate = Enum.TextTruncate.AtEnd
            logEntry.ClipsDescendants = true
            
            -- Click to view details
            logEntry.MouseButton1Click:Connect(function()
                detailFrame.Visible = true
                -- Cari log yang sesuai
                for _, log in ipairs(FishingSpy.Logs) do
                    if string.find(text, log.name) then
                        local detail = string.format(
                            "🔍 DETAILS:\n" ..
                            "Type: %s\n" ..
                            "Name: %s\n" ..
                            "Path: %s\n" ..
                            "Time: %s\n" ..
                            "Args: %s\n" ..
                            "Player: %s",
                            log.type,
                            log.name,
                            log.path,
                            os.date("%H:%M:%S", log.timestamp),
                            formatValue(log.args),
                            log.player
                        )
                        
                        if log.stack then
                            detail = detail .. "\n\nStack Trace:\n" .. log.stack
                        end
                        
                        detailText.Text = detail
                        break
                    end
                end
            end)
            
            logEntry.Parent = logFrame
            
            -- Auto scroll
            task.wait()
            logFrame.CanvasPosition = Vector2.new(0, logFrame.CanvasSize.Y.Offset)
            
            -- Update canvas size
            logFrame.CanvasSize = UDim2.new(0, 0, 0, logList.AbsoluteContentSize.Y)
        end,
        
        clearLogs = function()
            for _, child in pairs(logFrame:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end
            detailFrame.Visible = false
        end,
        
        updateStats = function()
            local stats = FishingSpy.getStats()
            statsLabel.Text = string.format("Logs: %d | Hooked: %d", 
                stats.totalLogs, stats.hookedEvents)
        end
    }
    
    -- Button functionality
    clearBtn.MouseButton1Click:Connect(function()
        FishingSpy.clearLogs()
        uiFunctions.updateStats()
    end)
    
    exportBtn.MouseButton1Click:Connect(function()
        local json = FishingSpy.exportLogs("json")
        if game:GetService("RunService"):IsStudio() then
            uiFunctions.addLog("💾 Logs exported to file", Color3.fromRGB(100, 255, 100))
        else
            setclipboard(json)
            uiFunctions.addLog("📋 Logs copied to clipboard", Color3.fromRGB(100, 255, 100))
        end
    end)
    
    hookBtn.MouseButton1Click:Connect(function()
        local hooked = hookDiscoveredObjects()
        uiFunctions.addLog(string.format("🔍 Re-hooked %d objects", hooked), Color3.fromRGB(255, 200, 100))
        uiFunctions.updateStats()
    end)
    
    FishingSpy.UI = uiFunctions
    
    -- Initial message
    uiFunctions.addLog("🕵️ Fishing Network Spy Started", Color3.fromRGB(0, 200, 255))
    uiFunctions.addLog("📡 Monitoring all fishing network traffic...", Color3.fromRGB(150, 200, 255))
    uiFunctions.updateStats()
    
    -- Auto-update stats
    RunService.Heartbeat:Connect(function()
        uiFunctions.updateStats()
    end)
    
    return screenGui
end

----------------------------------------------------------------
-- START SPY TOOL
----------------------------------------------------------------

function FishingSpy.start()
    if FishingSpy.IsRunning then
        print("⚠️ Spy tool is already running!")
        return false
    end
    
    print([[
╔══════════════════════════════════════════════╗
║        🕵️ FISHING NETWORK SPY v2.0         ║
║  • Advanced network monitoring              ║
║  • Auto-discovery of fishing events        ║
║  • Real-time logging with UI               ║
║  • Export/Import capabilities              ║
╚══════════════════════════════════════════════╝
]])
    
    FishingSpy.IsRunning = true
    
    -- Buat UI
    FishingSpy.createUI()
    
    -- Mulai auto-discovery
    task.spawn(function()
        while FishingSpy.IsRunning do
            hookDiscoveredObjects()
            
            -- Update stats di UI
            if FishingSpy.UI then
                FishingSpy.UI.updateStats()
            end
            
            -- Auto-save jika diaktifkan
            if CONFIG.AUTO_SAVE.enabled and #FishingSpy.Logs > 0 then
                if tick() % CONFIG.AUTO_SAVE.interval < 0.1 then
                    if game:GetService("RunService"):IsStudio() then
                        FishingSpy.exportLogs("json")
                        if FishingSpy.UI then
                            FishingSpy.UI.addLog("💾 Auto-saved logs", Color3.fromRGB(100, 200, 100))
                        end
                    end
                end
            end
            
            task.wait(5)  -- Scan ulang setiap 5 detik
        end
    end)
    
    print("✅ Fishing Network Spy started successfully!")
    print("📊 Open UI to view real-time network traffic")
    
    return true
end

function FishingSpy.stop()
    FishingSpy.IsRunning = false
    print("🛑 Fishing Network Spy stopped")
    
    -- Clear UI jika ada
    if playerGui:FindFirstChild("SpyUI") then
        playerGui.SpyUI:Destroy()
    end
end

----------------------------------------------------------------
-- PUBLIC API
----------------------------------------------------------------

-- Mulai spy tool
FishingSpy.start()

-- Return module untuk akses eksternal
return FishingSpy