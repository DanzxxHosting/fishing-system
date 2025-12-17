-- ServerScriptService.Main
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Initialize all systems
wait(1)

print("🚀 Initializing Fishing Game Systems...")

-- Initialize Remotes
require(script.Parent.InitializeRemotes)

-- Initialize Controllers
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
local EventController = require(ReplicatedStorage.Controllers.EventController)
local AnimationController = require(ReplicatedStorage.Controllers.AnimationController)

-- Start controllers
FishingController.Init()
EventController.Init()
AnimationController.Init()

print("✅ All systems initialized successfully!")