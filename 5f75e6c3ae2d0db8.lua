local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create the main UI window
local Window = Rayfield:CreateWindow({
    Name = "Plutonium.lua",
    LoadingTitle = "Plutonium V3",
    LoadingSubtitle = "by PawsThePaw",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Plutonium",
        FileName = "PlutoniumConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "vKfJNqC2US",
        RememberJoins = true
    },
    KeySystem = false
})

-- Tabs
local HomeTab = Window:CreateTab("Home", 4483362458)
local MainTab = Window:CreateTab("Main", 4483362458)
local GunModsTab = Window:CreateTab("Gun Mods", 4483362458)
local AdjustmentsTab = Window:CreateTab("Adjustments", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Home Tab
HomeTab:CreateParagraph({
    Title = "Welcome",
    Content = "Welcome to Plutonium V3, " .. LocalPlayer.DisplayName .. "! Join our Discord for support."
})

HomeTab:CreateButton({
    Name = "Join Our Discord",
    Callback = function()
        setclipboard("https://discord.gg/vKfJNqC2US")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Invite copied to clipboard!",
            Duration = 3
        })
    end
})

-- Main [Combat]
local hitboxEnabled = false
local visualizeHitbox = false
local hitboxSize = 25
local visualMaterial = Enum.Material.Neon

-- Update hitboxes
local function updateHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            if hitboxEnabled then
                root.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                root.Transparency = visualizeHitbox and 0.5 or 1
                root.Material = visualMaterial
                root.CanCollide = false
            else
                root.Size = Vector3.new(2, 2, 1)
                root.Transparency = 1
                root.Material = Enum.Material.Plastic
                root.CanCollide = true
            end
        end
    end
end

-- Hitbox Expander Toggle
MainTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(value)
        hitboxEnabled = value
        updateHitboxes()
    end
})

-- Visualize Hitbox Toggle
MainTab:CreateToggle({
    Name = "Visualize Hitbox",
    CurrentValue = false,
    Callback = function(value)
        visualizeHitbox = value
        updateHitboxes()
    end
})

-- Gun Mods
GunModsTab:CreateButton({
    Name = "Infinite Ammo",
    Callback = function()
        RunService.PreRender:Connect(function()
            local guiVars = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("GUI") and LocalPlayer.PlayerGui.GUI:FindFirstChild("Client") and LocalPlayer.PlayerGui.GUI.Client:FindFirstChild("Variables")
            if guiVars then
                guiVars.ammocount.Value = 999
                guiVars.ammocount2.Value = 999
            end
        end)
    end
})

GunModsTab:CreateButton({
    Name = "Fast Fire Rate",
    Callback = function()
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "FireRate" and v:IsA("NumberValue") then
                v.Value = 0.05
            end
        end
    end
})

GunModsTab:CreateButton({
    Name = "Fast Reload Time",
    Callback = function()
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "ReloadTime" and v:IsA("NumberValue") then
                v.Value = 0.1
            end
        end
    end
})

GunModsTab:CreateButton({
    Name = "No Recoil",
    Callback = function()
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "Recoil" and v:IsA("NumberValue") then
                v.Value = 0
            end
        end
    end
})

GunModsTab:CreateButton({
    Name = "No Spread",
    Callback = function()
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "Spread" and v:IsA("NumberValue") then
                v.Value = 0
            end
        end
    end
})

-- Adjustments Tab
AdjustmentsTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {5, 100},
    Increment = 1,
    CurrentValue = hitboxSize,
    Callback = function(value)
        hitboxSize = value
        updateHitboxes()
    end
})

AdjustmentsTab:CreateDropdown({
    Name = "Hitbox Material",
    Options = {
        "Plastic", "Neon", "Glass", "Metal", "ForceField",
        "WoodPlanks", "Brick", "Fabric", "Foil", "Marble",
        "Concrete", "Granite", "Ice", "Sand", "Slate", "SmoothPlastic"
    },
    CurrentOption = "Neon",
    Callback = function(option)
        visualMaterial = Enum.Material[option]
        updateHitboxes()
    end
})

-- Settings Tab
SettingsTab:CreateButton({
    Name = "Reset UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Notification
Rayfield:Notify({
    Title = "Plutonium.lua",
    Content = "The script has been loaded successfully. Enjoy!",
    Duration = 5
})