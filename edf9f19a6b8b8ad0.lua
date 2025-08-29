local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
LocalPlayer.PlayerGui.Notifications.Normal.Visible = false
local AutoFarm = false
local AutoStar = false
local AutoSword = false
local AutoFruit = false
local AutoDragon = false
local AutoSaiyan = false
local AutoRank = false
local AutoHaki = false
local AutoPirate = false
local AutoReiatsu = false
local AutoSpirit = false
local AutoZanpakuto = false
local AutoCurse = false
local AutoCurseProgress = false
local AutoDemonArts = false
local Star = 1
local Stars = {}
for i = 1,20 do
    table.insert(Stars,i)
end
local Library = loadstring(game:HttpGet(("https://raw.githubusercontent.com/theneutral0ne/wally-modified/refs/heads/main/wally-modified.lua")))()
local AutoFarmWindow = Library:CreateWindow('Credit: Neutral')
AutoFarmWindow:Toggle("Auto Farm",{},function(value)
AutoFarm = value
end)
local AutoUpgradeWindow = Library:CreateWindow("Auto Upgrade")
AutoUpgradeWindow:Toggle("Auto Rank Up",{},function(value)
AutoRank = value
end)
AutoUpgradeWindow:Toggle("Auto Upgrade Haki",{},function(value)
AutoHaki = value
end)
AutoUpgradeWindow:Toggle("Auto Upgrade Spiritual",{},function(value)
AutoSpirit = value
end)
AutoUpgradeWindow:Toggle("Auto Upgrade Curse",{},function(value)
AutoCurseProgress = value
end)
local AutoRollWindow = Library:CreateWindow("Auto Roll")
AutoRollWindow:Toggle("Auto Star",{},function(value)
AutoStar = value
end)
AutoRollWindow:Dropdown("Star",{list = Stars},function(value)
Star = value
end)
AutoRollWindow:Toggle("Auto Roll Dragon Race",{},function(value)
AutoDragon = value
end)
AutoRollWindow:Toggle("Auto Roll Saiyan Evo",{},function(value)
AutoSaiyan = value
end)
AutoRollWindow:Toggle("Auto Roll Sword",{},function(value)
AutoSword = value
end)
AutoRollWindow:Toggle("Auto Roll Fruit",{},function(value)
AutoFruit = value
end)
AutoRollWindow:Toggle("Auto Roll Pirate Crew",{},function(value)
AutoPirate = value
end)
AutoRollWindow:Toggle("Auto Roll Reiatsu Color",{},function(value)
AutoReiatsu = value
end)
AutoRollWindow:Toggle("Auto Roll Zanpakuto",{},function(value)
AutoZanpakuto = value
end)
AutoRollWindow:Toggle("Auto Roll Curse",{},function(value)
AutoCurse = value
end)
AutoRollWindow:Toggle("Auto Roll Demon Arts",{},function(value)
AutoDemonArts = value
end)

RunService.RenderStepped:Connect(function()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if Character and AutoFarm then
        local Closest
        local ClosestMag = 30
        for _,Enemy in workspace.Debris.Monsters:GetChildren() do
            if Enemy:FindFirstChild("HumanoidRootPart") and (Character.HumanoidRootPart.Position - Enemy.HumanoidRootPart.Position).Magnitude < ClosestMag and Enemy:GetAttribute("Health") and Enemy:FindFirstChild("Humanoid") then
                ClosestMag = (Character.HumanoidRootPart.Position - Enemy.HumanoidRootPart.Position).Magnitude
                Closest = Enemy
            end
        end
        if Closest then
            ReplicatedStorage.Events.To_Server:FireServer({Id = Closest.name,Action = "_Mouse_Click"})
        else
            ReplicatedStorage.Events.To_Server:FireServer({Action = "_Mouse_Click"})
        end
    end
    if AutoStar then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 15,Action = "_Stars",Name = "Star_"..Star})
    end
    if AutoSword then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Swords"})
    end
    if AutoFruit then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Demon_Fruits"})
    end
    if AutoDragon then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Dragon_Race"})
    end
    if AutoSaiyan then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Saiyan_Evolution"})
    end
    if AutoRank then
        ReplicatedStorage.Events.To_Server:FireServer({Upgrading_Name = "Rank",Action = "_Upgrades",Upgrade_Name = "Rank_Up"})
    end
    if AutoHaki then
        ReplicatedStorage.Events.To_Server:FireServer({Upgrading_Name = "Haki_Upgrade",Action = "_Upgrades",Upgrade_Name = "Haki_Upgrade"})
    end
    if AutoPirate then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Pirate_Crew"})
    end
    if AutoReiatsu then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Reiatsu_Color"})
    end
    if AutoSpirit then
        ReplicatedStorage.Events.To_Server:FireServer({Upgrading_Name = "Spiritual_Pressure",Action = "_Upgrades",Upgrade_Name = "Spiritual_Pressure"})
    end
    if AutoZanpakuto then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Zanpakuto"})
    end
    if AutoCurse then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Curses"})
    end
    if AutoCurseProgress then
        ReplicatedStorage.Events.To_Server:FireServer({Upgrading_Name = "Curse",Action = "_Upgrades",Upgrade_Name = "Cursed_Progression"})
    end
    if AutoDemonArts then
        ReplicatedStorage.Events.To_Server:FireServer({Open_Amount = 1,Action = "_Gacha_Activate",Name = "Demon_Arts"})
    end
end)