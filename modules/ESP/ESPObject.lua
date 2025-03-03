return function(Config, Utilities, ESPConfig)
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    
    local ESPObject = {}
    
    function ESPObject.Create(player, isAlly)
        local character = player.Character or player.CharacterAdded:Wait()
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 0.8
        highlight.OutlineTransparency = 0.1
        highlight.Adornee = character
        highlight.Parent = game.CoreGui
        
        local glow = Instance.new("Highlight")
        glow.FillTransparency = 0.95
        glow.OutlineTransparency = 0.6
        glow.Adornee = character
        glow.Parent = game.CoreGui
        
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 130, 0, 35) -- Taller for player info
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Adornee = character.HumanoidRootPart
        billboard.AlwaysOnTop = true
        billboard.Parent = game.CoreGui
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.6, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0.2
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Parent = billboard
        
        local shadow = Instance.new("TextLabel")
        shadow.Size = UDim2.new(1, 2, 0.6, 2)
        shadow.Position = UDim2.new(0, -1, 0, -1)
        shadow.BackgroundTransparency = 1
        shadow.TextSize = 14
        shadow.Font = Enum.Font.GothamBold
        shadow.TextStrokeTransparency = 1
        shadow.TextTransparency = 0.5
        shadow.Parent = billboard
        
        local healthBar, healthFill, healthBorder
        healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(0.9, 0, 0.15, 0)
        healthBar.Position = UDim2.new(0.05, 0, 0.75, 0)
        healthBar.BackgroundTransparency = 1
        healthBar.Parent = billboard
        
        healthBorder = Instance.new("Frame")
        healthBorder.Size = UDim2.new(1, 4, 1, 4)
        healthBorder.Position = UDim2.new(0, -2, 0, -2)
        healthBorder.BackgroundColor3 = isAlly and Config.Colors.Ally or Config.Colors.Enemy
        healthBorder.BackgroundTransparency = 0.5
        healthBorder.BorderSizePixel = 0
        healthBorder.ZIndex = 0
        healthBorder.Parent = healthBar
        
        healthFill = Instance.new("Frame")
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.Position = UDim2.new(0, 0, 0, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFill.BorderSizePixel = 0
        healthFill.ZIndex = 1
        healthFill.Parent = healthBar
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))
        })
        gradient.Rotation = 0
        gradient.Parent = healthFill
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 3)
        corner.Parent = healthBorder
        corner:Clone().Parent = healthFill
        
        local esp = {
            Highlight = highlight,
            Glow = glow,
            Billboard = billboard,
            Label = label,
            Shadow = shadow,
            HealthBar = healthBar,
            HealthFill = healthFill,
            HealthBorder = healthBorder,
            Object = character,
            Type = isAlly and "Ally" or "Enemy",
            LastPosition = nil,
            LastDistance = nil,
            
            Update = function(self)
                if not Config.Enabled or not self.Object.Parent or not self.Object:FindFirstChild("HumanoidRootPart") then
                    self.Highlight.Enabled = false
                    self.Glow.Enabled = false
                    self.Billboard.Enabled = false
                    if self.HealthBar then self.HealthBar.Visible = false end
                    return
                end
                
                local position = Utilities.getPosition(self.Object)
                local distance = Utilities.getDistance(position)
                
                if self.LastDistance and distance > Config.MaxDistance * ESPConfig.SpatialFilterThreshold and 
                   (self.LastPosition and (position - self.LastPosition).Magnitude < ESPConfig.SpatialMoveThreshold) then
                    return
                end
                
                self.LastPosition = position
                self.LastDistance = distance
                
                if distance > Config.MaxDistance then
                    self.Highlight.Enabled = false
                    self.Glow.Enabled = false
                    self.Billboard.Enabled = false
                    if self.HealthBar then self.HealthBar.Visible = false end
                    return
                end
                
                self.Highlight.Enabled = true
                self.Glow.Enabled = true
                self.Billboard.Enabled = true
                
                local fadeStart = Config.MaxDistance * ESPConfig.FadeStartMultiplier
                local fade = distance > fadeStart and math.clamp((distance - fadeStart) / (Config.MaxDistance - fadeStart), 0, 1) or 0
                self.Highlight.FillTransparency = 0.8 + fade * 0.2
                self.Highlight.OutlineTransparency = 0.1 + fade * 0.9
                self.Glow.FillTransparency = 0.95 + fade * 0.05
                self.Glow.OutlineTransparency = 0.6 + fade * 0.4
                self.Label.TextTransparency = fade
                self.Label.TextStrokeTransparency = 0.2 + fade * 0.8
                self.Shadow.TextTransparency = 0.5 + fade * 0.5
                
                local color = Config.Colors[self.Type] or Config.Colors.Default
                self.Highlight.FillColor = color
                self.Highlight.OutlineColor = color:Lerp(Color3.fromRGB(255, 255, 255), 0.4)
                self.Glow.FillColor = color:Lerp(Color3.fromRGB(255, 255, 255), 0.6)
                self.Glow.OutlineColor = color
                
                local name = player.Name
                if #name > 12 then name = name:sub(1, 10) .. "..." end
                local text = string.format("%s [%dm]", name, math.floor(distance))
                self.Label.TextColor3 = color
                self.Label.Text = text
                self.Shadow.TextColor3 = color:Lerp(Color3.fromRGB(255, 255, 255), 0.7)
                self.Shadow.Text = text
                
                if distance <= ESPConfig.HealthBarDistance then
                    self.HealthBar.Visible = true
                    local health = Utilities.getHealth(self.Object)
                    local healthPercent = math.clamp(health.Current / health.Max, 0, 1)
                    TweenService:Create(self.HealthFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Size = UDim2.new(healthPercent, 0, 1, 0)
                    }):Play()
                    self.HealthBorder.BackgroundTransparency = 0.5 + fade * 0.5
                    self.HealthFill.BackgroundTransparency = fade
                else
                    self.HealthBar.Visible = false
                end
            end,
            
            Destroy = function(self)
                Utilities.safeDestroy(self.Highlight)
                Utilities.safeDestroy(self.Glow)
                Utilities.safeDestroy(self.Billboard)
            end
        }
        
        return esp
    end
    
    return ESPObject
end
