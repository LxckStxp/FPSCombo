local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local MiddleClick = {
    Enabled = false, -- Controlled by UI
    RecordedTargets = {} -- Store targets and their original properties (position)
}

-- Check if a target is a player
local function isPlayer(target)
    local model = target:FindFirstAncestorOfClass("Model")
    return model and Players:GetPlayerFromCharacter(model) ~= nil
end

-- Record and teleport a part’s position, then return it after 10 seconds
local function modifyPart(part)
    if not part:IsA("BasePart") or MiddleClick.RecordedTargets[part] then return end
    
    -- Record original position
    local original = {
        Position = part.Position
    }
    MiddleClick.RecordedTargets[part] = original
    
    -- Teleport part far below the map (e.g., -1000 studs on Y-axis)
    part.Position = Vector3.new(part.Position.X, -1000, part.Position.Z)
    
    -- Return part to original position after 10 seconds
    task.delay(10, function()
        if part and part.Parent then
            part.Position = original.Position
        end
        MiddleClick.RecordedTargets[part] = nil
    end)
end

-- Initialize middle-click detection
function MiddleClick.Initialize()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not MiddleClick.Enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton3 then -- Middle click
            local mouse = Player:GetMouse()
            local target = mouse.Target
            if not target then return end
            
            -- Do nothing for players
            if isPlayer(target) then return end
            
            -- Teleport part (non-player) if it’s not a player
            modifyPart(target)
        end
    end)
end

return MiddleClick
