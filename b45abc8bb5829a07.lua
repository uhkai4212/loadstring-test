local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ionlyusegithubformcmods/1-Line-Scripts/main/Mobile%20Friendly%20Orion')))()
local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local setclipboard = setclipboard or function(text)
    if syn then
        syn.write_clipboard(text)
    elseif clipboard_set then
        clipboard_set(text)
    else
        print("Clipboard not supported. Link: https://discord.gg/WA2XTGMM")
    end
end