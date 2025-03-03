return function(Config, ESP, Aimbot, MiddleClick)
    local CensuraDev = loadstring(game:HttpGet("https://raw.githubusercontent.com/LxckStxp/Censura/main/CensuraDev.lua"))()
    local UI = CensuraDev.new("FPS Combo")
    
    -- Toggle ESP Enable
    UI:CreateToggle("ESP Enable", Config.Enabled, function(state)
        Config.Enabled = state
        if state then
            ESP.Initialize()
            ESP.Update()
        else
            ESP.Cleanup()
        end
    end)
    
    -- Max Distance Slider
    UI:CreateSlider("Max Distance", 100, 2000, Config.MaxDistance, function(value)
        Config.MaxDistance = value
    end)
    
    -- Aimbot Toggle
    UI:CreateToggle("Aimbot", Aimbot.Enabled, function(state)
        Aimbot.Enabled = state
    end)
    
    -- Team Check Toggle
    UI:CreateToggle("Team Check", Config.TeamCheck, function(state)
        Config.TeamCheck = state
        ESP.Update() -- Refresh ESP to apply team colors
    end)
    
    -- Middle Click Utility Toggle
    UI:CreateToggle("Middle Click Utility", MiddleClick.Enabled, function(state)
        MiddleClick.Enabled = state
    end)
    
    return UI
end
