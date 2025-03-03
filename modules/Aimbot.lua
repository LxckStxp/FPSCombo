local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer

local Aimbot = {
    Enabled = false, -- Controlled by UI
    Aiming = false, -- Tracks right-click state
    Target = nil,   -- Current player target
    RenderConnection = nil, -- Store RenderStepped connection
    Settings = {
        AimKey = Enum.UserInputType.MouseButton2, -- RightClick
    }
}

-- Wait for Camera to be valid
local function waitForCamera()
    while not Camera do
        Camera = workspace.CurrentCamera
        task.wait(0.1) -- Wait briefly before retrying
    end
end

-- Utility function to get players (excluding local player and teammates if team check is on)
local function getPlayers()
    local players = {}
    local config = getgenv().Config or {}
    local teamCheck = config.TeamCheck or false
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local isAlly = teamCheck and Utilities.isSameTeam(Player, player)
            if not isAlly then
                table.insert(players, player)
            end
        end
    end
    return players
end

-- Find closest enemy player to crosshair (excluding teammates if team check is on)
local function findClosestPlayer()
    waitForCamera() -- Ensure Camera is valid
    local mouse = UserInputService:GetMouseLocation()
    local ray = Camera:ScreenPointToRay(mouse.X, mouse.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local closestPlayer, closestDistance = nil, math.huge
    local config = getgenv().Config or {}
    local teamCheck = config.TeamCheck or false
    
    local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
    if raycastResult and raycastResult.Instance then
        local character = raycastResult.Instance:FindFirstAncestorOfClass("Model")
        local targetPlayer = Players:GetPlayerFromCharacter(character)
        if targetPlayer and targetPlayer ~= Player then
            local isAlly = teamCheck and Utilities.isSameTeam(Player, targetPlayer)
            if not isAlly then
                closestPlayer = targetPlayer
                closestDistance = (Camera.CFrame.Position - raycastResult.Position).Magnitude
            end
        end
    end

    -- Fallback: Check all players for closest to crosshair
    for _, player in pairs(getPlayers()) do
        local character = player.Character
        if character and character:FindFirstChild("Head") then
            local head = character.Head
            local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aim at target’s head instantly (with Camera check)
local function aimAtTarget()
    waitForCamera() -- Ensure Camera is valid
    if not Camera or not Aimbot.Target or not Aimbot.Target.Character or not Aimbot.Target.Character:FindFirstChild("Head") then
        print("Invalid target or Camera, stopping aimbot...")
        if Aimbot.RenderConnection then
            Aimbot.RenderConnection:Disconnect()
            Aimbot.RenderConnection = nil
            Aimbot.Aiming = false
            Aimbot.Target = nil
        end
        return
    end
    
    local head = Aimbot.Target.Character.Head
    local targetPos = head.Position -- Direct head targeting, no offset
    local lookVector = (targetPos - Camera.CFrame.Position).Unit
    local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + lookVector)
    
    -- Instant aim (no smoothing, overpowered)
    Camera.CFrame = newCFrame
    print("Aiming at:", Aimbot.Target.Name) -- Debug
end

-- Handle input for aimbot
function Aimbot.Initialize()
    print("Aimbot initializing...")
    waitForCamera() -- Ensure Camera is ready before initializing
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not Aimbot.Enabled then return end
        if input.UserInputType == Aimbot.Settings.AimKey then
            print("RightClick pressed, checking for target...")
            Aimbot.Aiming = true
            Aimbot.Target = findClosestPlayer()
            if Aimbot.Target and Aimbot.Target.Character then
                print("Targeting:", Aimbot.Target.Name)
                Aimbot.RenderConnection = RunService.RenderStepped:Connect(aimAtTarget)
            else
                print("No valid target found")
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed or not Aimbot.Enabled then return end
        if input.UserInputType == Aimbot.Settings.AimKey then
            print("RightClick released, stopping aimbot...")
            Aimbot.Aiming = false
            Aimbot.Target = nil
            if Aimbot.RenderConnection then
                Aimbot.RenderConnection:Disconnect()
                Aimbot.RenderConnection = nil
                print("Aimbot stopped")
            end
        end
    end)
end

return Aimbot
