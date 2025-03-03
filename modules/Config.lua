local Config = {
    Enabled = true,
    MaxDistance = 1000,
    Colors = {
        Ally = Color3.fromRGB(0, 0, 255),    -- Blue for teammates
        Enemy = Color3.fromRGB(255, 0, 0),   -- Red for enemies
        Default = Color3.fromRGB(200, 200, 200) -- Gray for uncategorized players
    },
    TeamCheck = true, -- Toggle for team-based coloring (true = use team colors, false = all enemies)
    AimbotEnabled = false -- For UI toggle
}

return Config
