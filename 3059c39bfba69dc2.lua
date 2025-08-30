-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TokkenDev/clock.lua-v2/refs/heads/main/7979341445"))()

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TokkenDev/clock.lua-v2/refs/heads/main/XSX%20Library%20Fixed"))()
library:Watermark("clock.lua | WHG | v2.0.0 | " .. library:GetUsername())
local Notifications = library:InitNotifications()
library.title = "clock.lua"
local Init = library:Init()
local MainTab = Init:NewTab("Game")
local UITab = Init:NewTab("UI")

-- Init --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local Char = LPlayer.Character
local HRP = Char.HumanoidRootPart

LPlayer.CharacterAdded:Connect(function(char)
    Char = LPlayer.Character
    HRP = Char.HumanoidRootPart
end)

-- Variables --
local nocliptable = {"Corner", "Torso", "Troll", "HumanoidRootPart", "omg"}
local badpartstable = {"KillerPath", "Kill", "Spinner", "Void", "Water", }

-- Functions --
local function getLevelsTable()
    local levelstable = {}
    for _, levelfolder in workspace:GetChildren() do task.wait()
        if levelfolder:IsA("Folder") and tonumber(levelfolder.Name) then
            table.insert(levelstable, {object = levelfolder, number = tonumber(levelfolder.Name)})
        end
    end
    table.sort(levelstable, function(a, b)
        return a.number < b.number
    end)
    return levelstable
end

-- Library Components --
-- MainTab --
MainTab:NewToggle("No Clip", false, function(bool)
    Notifications:Notify("No Clip "..(bool and "ON" or "OFF"), 3, (bool and "success" or "error"))
    for _, playerpart in pairs(Char:GetChildren()) do
        for _,partname in nocliptable do
            if playerpart.Name == partname then
                playerpart.CanCollide = not bool
            end
        end
    end
end)

MainTab:NewButton("Destroy All Death Balls", function()
    Notifications:Notify("Please wait...", 3, "information")
    local success, fail = pcall(function()
        for _, levelpart in pairs(getLevelsTable()) do
            for _, sublevelpart in pairs(levelpart.object:GetChildren()) do
                for _, partname in badpartstable do
                    if sublevelpart.Name == partname then
                        sublevelpart:Destroy()
                    elseif sublevelpart.Name == "Text" then
                        sublevelpart.Value = "clock.lua on top :3"
                    end
                end
            end
        end
    end)
    if success then
        Notifications:Notify("Destroyed all Death Balls", 3, "success")
    else
        Notifications:Notify("Error in console :c", 3, "error")
        error("[clock.lua] [ERROR] "..fail)
    end
end)

MainTab:NewButton("Destroy Kill Barriers", function()
    if workspace:FindFirstChild("KillBarriers") then
        workspace:FindFirstChild("KillBarriers"):Destroy()
        Notifications:Notify("Destroyed all Kill Barriers", 3, "success")
    else
        Notifications:Notify("Kill Barriers no exist :c", 3, "error")
    end
end)

MainTab:NewButton("Collect All Coins From Current Level", function()
    local currentlv = tostring(LPlayer.currentlvlValue.Value)
    local workspacelv = workspace:FindFirstChild(currentlv)
    local success, fail = pcall(function()
        if firetouchinterest then
            for _, coins in workspacelv:GetChildren() do
                if coins.Name == "Coin" then
                    firetouchinterest(Char.Troll, coins, 1)
                    firetouchinterest(Char.Troll, coins, 0)
                end
            end
        else
            Notifications:Notify("Your executor does NOT support firetouchinterest", 3, "error")
            error("cause of error: shit executor lol")
        end
    end)
    if success then
        Notifications:Notify("Collected All Coins From Current Level", 3, "success")
    else
        Notifications:Notify("Error in console :c", 3, "error")
        error("[clock.lua] [ERROR] "..fail)
    end
end)

MainTab:NewButton("Get 1000 Deaths (Achievement)", function()
    for i = 1, 1000 do
        ReplicatedStorage.Death:FireServer()
    end
    Notifications:Notify("Added 1000 Deaths", 3, "success")
end)

MainTab:NewButton("Get 50 Wins (Skin)", function()
    for i = 1, 50 do
        ReplicatedStorage.Win:FireServer(32)
    end
    Notifications:Notify("Added 50 Wins", 3, "success")
end)

MainTab:NewTextbox("Set custom level", "", "1337", "numbers", "medium", true, false, function(val)
    ReplicatedStorage.Win:FireServer(val)
end)

local LvTeleportSelector = MainTab:NewSelector("Switch Levels", nil, {}, function(Value)
    ReplicatedStorage.Win:FireServer(tonumber(Value))
    Notifications:Notify("Switched to level "..Value, 3, "success")
end)

for _, level in ipairs(getLevelsTable()) do
    LvTeleportSelector:AddOption(tostring(level.number))
end

-- UITab --
UITab:NewButton("Destroy UI", function()
    library:Remove()
end)

UITab:NewLabel("working on modifying the library for more ui functions", "center")