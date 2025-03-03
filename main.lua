-- FPS Combo Cheat by LxckStxp
-- Injected via Executor

local baseUrl = "https://raw.githubusercontent.com/LxckStxp/FPSCombo/main/modules/"

local Config = loadstring(game:HttpGet(baseUrl .. "Config.lua"))()
local Utilities = loadstring(game:HttpGet(baseUrl .. "Utilities.lua"))()
local ESP = loadstring(game:HttpGet(baseUrl .. "ESP/ESP.lua"))()(Config, Utilities)
local Aimbot = loadstring(game:HttpGet(baseUrl .. "Aimbot.lua"))()
local MiddleClick = loadstring(game:HttpGet(baseUrl .. "MiddleClick.lua"))()
local UI = loadstring(game:HttpGet(baseUrl .. "UI.lua"))()(Config, ESP, Aimbot, MiddleClick)

ESP.Initialize()
Aimbot.Initialize()
MiddleClick.Initialize()

print("FPS Combo Loaded Successfully!")
