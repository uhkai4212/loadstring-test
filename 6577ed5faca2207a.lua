local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local HRP, Humanoid

local function refreshCharacter()
    local char = LP.Character or LP.CharacterAdded:Wait()
    HRP = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end

refreshCharacter()
LP.CharacterAdded:Connect(refreshCharacter)


local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/main/ReGui.lua"))()


local autoSwing = false
local autoRebirth = false
local autoEquip = false
local autoUltraSwing = false
local autoUpgradeAll = false
local selectedUpgrade = nil
local autoUpgradeSelected = false
local selectedEgg = nil
local autoBuyEgg = false
local infJump = false
local noclip = false
local killAura = false
local killAuraRange = 20
local noCooldown = false
local autoDash = false
local autoQuest = false


local UI = ReGui:TabsWindow({
    Title = "Ninja Katana Simulator GUI",
    Size = UDim2.fromOffset(600, 450),
    Position = UDim2.fromOffset(100, 100),
})


local TabMain = UI:CreateTab({ Name = "Main" })
local TabCombat = UI:CreateTab({ Name = "Combat" })
local TabUpgrade = UI:CreateTab({ Name = "Upgrade" })
local TabEgg = UI:CreateTab({ Name = "Egg" })
local TabMove = UI:CreateTab({ Name = "Movement" })


TabMain:CollapsingHeader({ Title = "Main Features" }):Checkbox({
    Label = "Auto Swing (Basic)",
    Value = false,
    Callback = function(_, v) autoSwing = v end
})

TabMain:Checkbox({
    Label = "Auto Rebirth",
    Value = false,
    Callback = function(_, v) autoRebirth = v end
})

TabMain:Checkbox({
    Label = "Auto Equip Best Pet",
    Value = false,
    Callback = function(_, v) autoEquip = v end
})

TabMain:Checkbox({
    Label = "Auto Ultra Swing + TP to Crown",
    Value = false,
    Callback = function(_, v) autoUltraSwing = v end
})

TabMain:Checkbox({
    Label = "Auto Claim Quests",
    Value = false,
    Callback = function(_, v) autoQuest = v end
})


local combatHeader = TabCombat:CollapsingHeader({ Title = "Combat Hacks" })

combatHeader:Checkbox({
    Label = "Kill Aura (Auto Damage Nearby)",
    Value = false,
    Callback = function(_, v) killAura = v end
})

combatHeader:SliderFloat({
    Label = "Kill Aura Range",
    Minimum = 10,
    Maximum = 100,
    Value = 20,
    Callback = function(_, v) killAuraRange = v end
})

combatHeader:Checkbox({
    Label = "No Attack Cooldown",
    Value = false,
    Callback = function(_, v) noCooldown = v end
})

combatHeader:Checkbox({
    Label = "Auto Dash (Spam Q)",
    Value = false,
    Callback = function(_, v) autoDash = v end
})


TabUpgrade:CollapsingHeader({ Title = "Upgrade System" }):Checkbox({
    Label = "Auto Upgrade All",
    Value = false,
    Callback = function(_, v) autoUpgradeAll = v end
})

TabUpgrade:Combo({
    Label = "Select Upgrade",
    Selected = "",
    Items = { "Damage", "JumpPower", "PetStorage", "PetEquip", "Health" },
    Callback = function(_, v) selectedUpgrade = v end
})

TabUpgrade:Checkbox({
    Label = "Auto Upgrade Selected",
    Value = false,
    Callback = function(_, v) autoUpgradeSelected = v end
})


TabEgg:CollapsingHeader({ Title = "Pet System" }):Combo({
    Label = "Select Egg",
    Selected = "",
    Items = { "Basic Egg", "Dessert Egg", "Lava Egg", "Space Egg" },
    Callback = function(_, v) selectedEgg = v end
})

TabEgg:Checkbox({
    Label = "Auto Buy Selected Egg",
    Value = false,
    Callback = function(_, v) autoBuyEgg = v end
})


local move = TabMove:CollapsingHeader({ Title = "Player Movement" })

move:SliderFloat({
    Label = "WalkSpeed",
    Minimum = 16,
    Maximum = 200,
    Value = 16,
    Callback = function(_, v)
        if Humanoid then Humanoid.WalkSpeed = v end
    end
})

move:SliderFloat({
    Label = "JumpPower",
    Minimum = 50,
    Maximum = 200,
    Value = 50,
    Callback = function(_, v)
        if Humanoid then Humanoid.JumpPower = v end
    end
})

move:Checkbox({
    Label = "Infinite Jump",
    Value = false,
    Callback = function(_, v) infJump = v end
})

move:Checkbox({
    Label = "Noclip",
    Value = false,
    Callback = function(_, v) noclip = v end
})


UIS.JumpRequest:Connect(function()
    if infJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)


RunService.Stepped:Connect(function()
    if noclip and HRP then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)


RunService.Heartbeat:Connect(function()
    
    if autoSwing and HRP then
        ReplicatedStorage.Remotes.Swing:FireServer(HRP.CFrame, HRP.CFrame)
    end
    
    
    if autoRebirth then
        ReplicatedStorage.Remotes.Rebirth:FireServer()
    end
    
    
    if autoEquip then
        ReplicatedStorage.Remotes.Pets.EquipBest:FireServer()
    end
    
    
    if autoUltraSwing and HRP then
        local crown = Workspace:FindFirstChild("KOTH") and Workspace.KOTH:FindFirstChild("Crown")
        if crown then
            HRP.CFrame = crown.CFrame + Vector3.new(0, 3, 0)
            ReplicatedStorage.Remotes.Swing:FireServer(HRP.CFrame, HRP.CFrame)
        end
    end
    
    
    if autoUpgradeAll then
        for _, upg in ipairs({ "Damage", "JumpPower", "PetStorage", "PetEquip", "Health" }) do
            ReplicatedStorage.Remotes.Upgrade:FireServer(upg)
        end
    end
    
    
    if autoUpgradeSelected and selectedUpgrade then
        ReplicatedStorage.Remotes.Upgrade:FireServer(selectedUpgrade)
    end
    
    
    if autoBuyEgg and selectedEgg then
        ReplicatedStorage.Remotes.Pets.BuyEgg:FireServer(selectedEgg, 1, {}, false)
    end
    
    
    if killAura and HRP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP and (HRP.Position - targetHRP.Position).Magnitude <= killAuraRange then
                    ReplicatedStorage.Remotes.Swing:FireServer(HRP.CFrame, targetHRP.Position)
                end
            end
        end
    end
    
    
    if autoDash then
        ReplicatedStorage.Remotes.Dash:FireServer()
    end
    
    
    if autoQuest then
        ReplicatedStorage.Remotes.ClaimQuest:FireServer()
    end
end)


if noCooldown then
    local old; old = hookfunction(getupvalue(Swing, "v_u_96"), function() return false end)
end


game.StarterGui:SetCore("SendNotification", {
    Title = "Script Loaded",
    Text = "Ultimate Sword Simulator GUI Activated!",
    Duration = 5
})