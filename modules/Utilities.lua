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

-- Detect team members using multiple methods
function Utilities.isSameTeam(player1, player2)
    if not player1 or not player2 then return false end
    
    local char1 = player1.Character
    local char2 = player2.Character
    if not char1 or not char2 then return false end
    
    -- Method 1: Check for custom TeamValue (e.g., StringValue, IntValue, BoolValue)
    local function getTeamValue(character)
        if not character then return nil end
        local teamValue = character:FindFirstChild("TeamValue") -- Common name for team indicators
        if teamValue and (teamValue:IsA("StringValue") or teamValue:IsA("IntValue") or teamValue:IsA("BoolValue")) then
            return teamValue.Value
        end
        return nil
    end
    
    local teamValue1 = getTeamValue(char1)
    local teamValue2 = getTeamValue(char2)
    if teamValue1 and teamValue2 and teamValue1 == teamValue2 then
        return true -- Same custom team value, assume teammates
    end
    
    -- Method 2: Check for color-based indicators (e.g., Head or Torso color)
    local function getPartColor(character, partName)
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            return part.BrickColor or part.Color -- Use BrickColor or Color3
        end
        return nil
    end
    
    local color1 = getPartColor(char1, "Head") or getPartColor(char1, "Torso") or getPartColor(char1, "HumanoidRootPart")
    local color2 = getPartColor(char2, "Head") or getPartColor(char2, "Torso") or getPartColor(char2, "HumanoidRootPart")
    if color1 and color2 then
        -- Convert to Color3 for comparison (simplified for BrickColor)
        local color3_1 = color1.Color or (color1 == BrickColor.White() and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0))
        local color3_2 = color2.Color or (color2 == BrickColor.White() and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0))
        -- Example: Blue (allies) vs. Red (enemies), adjust thresholds as needed
        if (color3_1:ToHSV() == color3_2:ToHSV()) and (color3_1 == Color3.fromRGB(0, 0, 255)) then -- Blue for allies
            return true
        end
    end
    
    -- Method 3: Check name patterns (e.g., prefixes/suffixes indicating teams)
    local function getNamePattern(player)
        local name = player.Name:lower()
        return name:match("team") or name:match("ally") or name:match("friend") or name:match("blue")
    end
    
    local pattern1 = getNamePattern(player1)
    local pattern2 = getNamePattern(player2)
    if pattern1 and pattern2 and pattern1 == pattern2 then
        return true -- Same name pattern, assume teammates
    end
    
    -- Method 4: Fallback to Roblox's default team system
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

-- Get health information for a player
function Utilities.getHealth(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid then
        return {
            Current = humanoid.Health,
            Max = humanoid.MaxHealth
        }
    end
    return { Current = 0, Max = 100 } -- Fallback if no humanoid found
end

return Utilities
