local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Utilities = {}

function Utilities.getDistance(position)
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return 9999 end
    return (Player.Character.HumanoidRootPart.Position - position).Magnitude
end

function Utilities.getPosition(object)
    if object:IsA("Model") then
        local primaryPart = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
        return primaryPart and primaryPart.Position or Vector3.new(0, 0, 0)
    end
    return object:IsA("BasePart") and object.Position or Vector3.new(0, 0, 0)
end

function Utilities.isSameTeam(player1, player2)
    -- Default team check: assumes players have a "Team" property or TeamColor
    if not player1 or not player2 then return false end
    local team1 = player1.Team or player1.TeamColor
    local team2 = player2.Team or player2.TeamColor
    return team1 and team2 and team1 == team2
end

function Utilities.safeDestroy(instance)
    pcall(function()
        if instance and instance.Parent then
            instance:Destroy()
        end
    end)
end

return Utilities
