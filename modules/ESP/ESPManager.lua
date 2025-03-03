return function(Config, Utilities, ESPObject, ESPConfig)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Player = Players.LocalPlayer
    
    local ESPManager = {
        Players = {}, -- Track all players (no Items or Humanoids for simplicity)
        Connection = nil
    }
    
    function ESPManager.Update()
        if not Config.Enabled then return end
        
        local teamCheck = Config.TeamCheck or false
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and not ESPManager.Players[player] then
                local isAlly = teamCheck and Utilities.isSameTeam(Player, player)
                if not isAlly then
                    ESPManager.Players[player] = ESPObject.Create(player, false) -- Enemy (red)
                end
            end
        end
        
        for player, esp in pairs(ESPManager.Players) do
            if player.Parent and Players:GetPlayerFromCharacter(player.Character) then
                local isAlly = teamCheck and Utilities.isSameTeam(Player, player)
                if not isAlly then
                    esp:Update()
                else
                    esp:Destroy()
                    ESPManager.Players[player] = nil
                end
            else
                esp:Destroy()
                ESPManager.Players[player] = nil
            end
        end
    end
    
    function ESPManager.Initialize()
        local lastUpdate = 0
        ESPManager.Connection = RunService.Heartbeat:Connect(function()
            local currentTime = tick()
            if currentTime - lastUpdate >= ESPConfig.UpdateInterval then
                ESPManager.Update()
                lastUpdate = currentTime
            end
        end)
        ESPManager.Update()
    end
    
    function ESPManager.Cleanup()
        for _, esp in pairs(ESPManager.Players) do
            esp:Destroy()
        end
        ESPManager.Players = {}
        if ESPManager.Connection then
            ESPManager.Connection:Disconnect()
            ESPManager.Connection = nil
        end
    end
    
    function ESPManager.SetEnabled(enabled)
        Config.Enabled = enabled
        if enabled then
            ESPManager.Update()
        else
            ESPManager.Cleanup()
        end
    end
    
    function ESPManager.IsEnabled()
        return Config.Enabled
    end
    
    return ESPManager
end
