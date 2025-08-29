local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua')))()

print([[

Lucent hub

]])

loadstring(game:HttpGet("https://pastefy.app/le3JMGVe/raw", true))()

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local CurrentCamera = Workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    
    local Window = OrionLib:MakeWindow({
        Name = "Lucent Hub | MM2 [Beta]",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "LucentHubConfig"
    })