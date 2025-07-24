local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "GET STRONGER EVERY SECOND",
    LoadingTitle = "GET STRONGER EVERY SECOND",
    LoadingSubtitle = "Ultimate Auto Farm",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "StrongerConfig"
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
local MovementTab = Window:CreateTab("Movement", 7733925908)
local EggTab = Window:CreateTab("Eggs", 7733925123)

-- Main Tab Features
local tutorialRunning = false
local AutoTutorial = MainTab:CreateToggle({
    Name = "Auto Complete Tutorial",
    CurrentValue = false,
    Flag = "AutoTutorial",
    Callback = function(Value)
        tutorialRunning = Value
        while tutorialRunning do
            game:GetService("ReplicatedStorage").Remotes.CompleteTutorial:FireServer()
            wait(1)
        end
    end
})

local dumbbellRunning = false
local AutoDumbbell = MainTab:CreateToggle({
    Name = "Auto Dumbbell Farm",
    CurrentValue = false,
    Flag = "AutoDumbbell",
    Callback = function(Value)
        dumbbellRunning = Value
        while dumbbellRunning do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Dumbell") then
                char.Dumbell.ActivateFromAuto:FireServer()
            end
            wait(0.5)
        end
    end
})

local rewardRunning = false
local AutoReward = MainTab:CreateToggle({
    Name = "Auto Claim Rewards (1-8)",
    CurrentValue = false,
    Flag = "AutoReward",
    Callback = function(Value)
        rewardRunning = Value
        while rewardRunning do
            for i = 1, 8 do
                game:GetService("ReplicatedStorage").Remotes.ClaimTimedReward:FireServer(i)
            end
            wait(1)
        end
    end
})

local spinRunning = false
local AutoSpin = MainTab:CreateToggle({
    Name = "Auto Spin Reward",
    CurrentValue = false,
    Flag = "AutoSpin",
    Callback = function(Value)
        spinRunning = Value
        while spinRunning do
            game:GetService("ReplicatedStorage").Remotes.SpinReward:FireServer()
            wait(1)
        end
    end
})

local cashRunning = false
local AutoCash = MainTab:CreateToggle({
    Name = "Auto Cash",
    CurrentValue = false,
    Flag = "AutoCash",
    Callback = function(Value)
        cashRunning = Value
        while cashRunning do
            game:GetService("ReplicatedStorage").Remotes.GiveCash:FireServer()
            wait(0.5)
        end
    end
})

local BagDropdown = MainTab:CreateDropdown({
    Name = "Select Bag to Punch",
    Options = {"1", "2", "3", "4"},
    CurrentOption = {"1"},
    MultipleOptions = false,
    Flag = "BagSelect"
})

local punchRunning = false
local AutoPunch = MainTab:CreateToggle({
    Name = "Auto Punch Bag",
    CurrentValue = false,
    Flag = "AutoPunch",
    Callback = function(Value)
        punchRunning = Value
        while punchRunning do
            local bagNum = BagDropdown.CurrentOption[1]
            if bagNum then
                game:GetService("ReplicatedStorage").Remotes.PunchingBags.Events.Punch:FireServer(workspace.BoxingBags[bagNum])
            end
            wait(0.2)
        end
    end
})

local claimRunning = false
local AutoClaim = MainTab:CreateToggle({
    Name = "Auto Claim Trophies",
    CurrentValue = false,
    Flag = "AutoClaim",
    Callback = function(Value)
        claimRunning = Value
        while claimRunning do
            for _, trophyType in ipairs({"Cash", "Strength", "PlayTime"}) do
                for i = 1, 20 do
                    game:GetService("ReplicatedStorage").Remotes.Trophies.Events.UnlockTrophy:FireServer(trophyType, i)
                end
            end
            wait(1)
        end
    end
})

local tradeRunning = false
local playerList = {}
local PlayerDropdown = MainTab:CreateDropdown({
    Name = "Select Player",
    Options = {"No players found"},
    CurrentOption = {"No players found"},
    MultipleOptions = false,
    Flag = "PlayerSelect"
})

local function updatePlayerList()
    local players = game:GetService("Players"):GetPlayers()
    playerList = {}
    for _, player in ipairs(players) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    if #playerList == 0 then
        PlayerDropdown:Refresh({"No players available"})
    else
        PlayerDropdown:Refresh(playerList)
    end
end

game:GetService("Players").PlayerAdded:Connect(updatePlayerList)
game:GetService("Players").PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

local AutoTrade = MainTab:CreateToggle({
    Name = "Auto Trade Request",
    CurrentValue = false,
    Flag = "AutoTrade",
    Callback = function(Value)
        tradeRunning = Value
        while tradeRunning do
            local selected = PlayerDropdown.CurrentOption[1]
            if selected and selected ~= "No players available" then
                game:GetService("ReplicatedStorage").Remotes.Trading.SendTradeRequest:FireServer(selected)
            end
            wait(1)
        end
    end
})

local teleportAttackRunning = false
local AutoTeleportAttack = MainTab:CreateToggle({
    Name = "Teleport Attack Player",
    CurrentValue = false,
    Flag = "AutoTeleportAttack",
    Callback = function(Value)
        teleportAttackRunning = Value
        while teleportAttackRunning do
            local selected = PlayerDropdown.CurrentOption[1]
            if selected and selected ~= "No players available" then
                local target = game:GetService("Players")[selected].Character
                local gloves = game.Players.LocalPlayer.Backpack:FindFirstChild("Boxing Gloves")
                if target and target.PrimaryPart then
                    if gloves then
                        gloves.Parent = game.Players.LocalPlayer.Character
                    end
                    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(target.PrimaryPart.CFrame * CFrame.new(0, 0, -2))
                end
            end
            wait(0.1)
        end
    end
})

MainTab:CreateButton({
    Name = "Unlock Auto Clicker",
    Callback = function()
        game:GetService("Players").LocalPlayer.OwnedPasses.Luck.Value = true
    end
})

MainTab:CreateButton({
    Name = "STOP ALL AUTOMATION",
    Callback = function()
        tutorialRunning = false
        dumbbellRunning = false
        rewardRunning = false
        spinRunning = false
        cashRunning = false
        tradeRunning = false
        punchRunning = false
        claimRunning = false
        teleportAttackRunning = false
        AutoTutorial:Set(false)
        AutoDumbbell:Set(false)
        AutoReward:Set(false)
        AutoSpin:Set(false)
        AutoCash:Set(false)
        AutoTrade:Set(false)
        AutoPunch:Set(false)
        AutoClaim:Set(false)
        AutoTeleportAttack:Set(false)
    end
})

-- Egg Tab
local eggList = {}
for _, egg in ipairs(workspace.Eggs:GetChildren()) do
    if egg:IsA("Model") then
        table.insert(eggList, egg.Name)
    end
end

local EggDropdown = EggTab:CreateDropdown({
    Name = "Select Egg",
    Options = eggList,
    CurrentOption = {eggList[1]},
    MultipleOptions = false,
    Flag = "EggSelect"
})

local hatchRunning = false
local AutoHatch = EggTab:CreateToggle({
    Name = "Auto Hatch Egg",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(Value)
        hatchRunning = Value
        while hatchRunning do
            local selected = EggDropdown.CurrentOption[1]
            if selected then
                game:GetService("ReplicatedStorage").Remotes.Eggs.Events.Hatch1:FireServer(workspace.Eggs[selected])
            end
            wait(0.5)
        end
    end
})

-- Movement Tab
local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local WalkSpeedSlider = MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = humanoid.WalkSpeed,
    Flag = "WalkSpeed",
    Callback = function(Value)
        humanoid.WalkSpeed = Value
    end
})

local JumpPowerSlider = MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = humanoid.JumpPower,
    Flag = "JumpPower",
    Callback = function(Value)
        humanoid.JumpPower = Value
    end
})

local infJumpEnabled = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpEnabled then
        humanoid:ChangeState("Jumping")
    end
end)

MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value)
        infJumpEnabled = Value
    end
})

local noclipEnabled = false
local function noclipLoop()
    while noclipEnabled do
        if game.Players.LocalPlayer.Character then
            for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        game:GetService("RunService").Stepped:wait()
    end
end

MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        noclipEnabled = Value
        if Value then
            noclipLoop()
        end
    end
})

local antiAfkEnabled = false
local antiAfkConnection
MovementTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        antiAfkEnabled = Value
        if Value then
            antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
            end
        end
    end
})