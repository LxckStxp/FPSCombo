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

-- Detect team markers (BillboardGui or SurfaceGui with ImageLabel/TextLabel)
local function hasTeamMarker(character)
    if not character then return false end
    
    -- Common marker locations: above head (e.g., BillboardGui) or on torso (e.g., SurfaceGui)
    for _, descendant in pairs(character:GetDescendants()) do
        if (descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui")) then
            for _, child in pairs(descendant:GetChildren()) do
                if child:IsA("ImageLabel") or child:IsA("TextLabel") then
                    -- Check for team-specific patterns (customize as needed for your FPS game)
                    if child:IsA("ImageLabel") then
                        -- Example: Check for a specific team badge image (e.g., ImageId)
                        if child.Image == "rbxassetid://1234567890" then -- Replace with actual team marker ImageId
                            return true
                        end
                    elseif child:IsA("TextLabel") then
                        -- Example: Check for team-specific text (e.g., "TeamBlue", "Ally")
                        local text = child.Text:lower()
                        if text:match("team") or text:match("ally") or text:match("friend") then
                            return true
                        end
                        -- Check color (e.g., blue for allies, adjust based on game)
                        if child.TextColor3 == Color3.fromRGB(0, 0, 255) then -- Blue for allies
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function Utilities.isSameTeam(player1, player2)
    if not player1 or not player2 then return false end
    
    -- First, check for team markers
    local char1 = player1.Character
    local char2 = player2.Character
    if char1 and char2 then
        local hasMarker1 = hasTeamMarker(char1)
        local hasMarker2 = hasTeamMarker(char2)
        if hasMarker1 and hasMarker2 then
            return true -- Both have team markers, assume teammates
        elseif hasMarker1 or hasMarker2 then
            return false -- One has a marker, one doesn’t—assume different teams
        end
    end
    
    -- Fallback: Use Roblox's default team system if no markers
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
