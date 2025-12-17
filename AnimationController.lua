-- ReplicatedStorage.Controllers.AnimationController
local AnimationController = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = ReplicatedStorage:WaitForChild("Animations")

function AnimationController.Init()
    print("🎬 Animation Controller Initialized")
end

function AnimationController.PlayCastAnimation(player)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then return end
    
    local animation = Animations:FindFirstChild("FishingCast")
    if animation then
        local track = animator:LoadAnimation(animation)
        track:Play()
    end
end

function AnimationController.PlayReelAnimation(player, success)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then return end
    
    local animName = success and "FishingReelSuccess" or "FishingReelFail"
    local animation = Animations:FindFirstChild(animName)
    
    if animation then
        local track = animator:LoadAnimation(animation)
        track:Play()
    end
end

return AnimationController