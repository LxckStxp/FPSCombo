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

-- Utility function to get players (excluding local player)
local function getPlayers()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(players, player)
        end
    end
    return players
end

-- Find closest player to crosshair (with team check)
local function findClosestPlayer()
    local mouse = UserInputService:GetMouseLocation()
    local ray = Camera:ScreenPointToRay(mouse.X, mouse.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local closestPlayer, closestDistance = nil, math.huge
    local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
    
    if raycastResult and raycastResult.Instance then
        local character = raycastResult.Instance:FindFirstAncestorOfClass("Model")
        local targetPlayer = Players:GetPlayerFromCharacter(character)
        if targetPlayer and targetPlayer ~= Player then
            local isAlly = getgenv().Config.TeamCheck and Players.LocalPlayer and Utilities.isSameTeam(Players.LocalPlayer, targetPlayer)
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
                local isAlly = getgenv().Config.TeamCheck and Utilities.isSameTeam(Player, player)
                if distance < closestDistance and not isAlly then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aim at target’s head instantly
local function aimAtTarget()
    if not Aimbot.Target or not Aimbot.Target.Character or not Aimbot.Target.Character:FindFirstChild("Head") then return end
    
    local head = Aimbot.Target.Character.Head
    local targetPos = head.Position -- Direct head targeting, no offset
    local lookVector = (targetPos - Camera.CFrame.Position).Unit
    local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + lookVector)
    
    -- Instant aim (no smoothing, overpowered)
    Camera.CFrame = newCFrame
end

-- Handle input for aimbot
function Aimbot.Initialize()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not Aimbot.Enabled then return end
        if input.UserInputType == Aimbot.Settings.AimKey then
            Aimbot.Aiming = true
            Aimbot.Target = findClosestPlayer()
            if Aimbot.Target and Aimbot.Target.Character then
                Aimbot.RenderConnection = RunService.RenderStepped:Connect(aimAtTarget)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed or not Aimbot.Enabled then return end
        if input.UserInputType == Aimbot.Settings.AimKey then
            Aimbot.Aiming = false
            Aimbot.Target = nil
            if Aimbot.RenderConnection then
                Aimbot.RenderConnection:Disconnect()
                Aimbot.RenderConnection = nil
            end
        end
    end)
end

return Aimbot
