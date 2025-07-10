local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Local player
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart, Humanoid

-- Initialize character and components
local function initializeCharacter()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
    Humanoid = character:WaitForChild("Humanoid")
end

initializeCharacter()
LocalPlayer.CharacterAdded:Connect(initializeCharacter)

-- Periodically reinitialize character to handle respawns
task.spawn(function()
    while true do
        pcall(initializeCharacter)
        task.wait(3)
    end
end)

-- Load external GUI library
local guiLibrary = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()

-- Create main GUI window
local window = guiLibrary:TabsWindow({
    Title = "Pet Simulator GUI",
    Size = UDim2.fromOffset(650, 500),
    Position = UDim2.fromOffset(100, 100)
})

-- Create tabs
local mainTab = window:CreateTab({ Name = "Main" })
local eggTab = window:CreateTab({ Name = "Eggs & Pets" })
local movementTab = window:CreateTab({ Name = "Movement" })
local antiAfkTab = window:CreateTab({ Name = "Anti-AFK" })
local tradingTab = window:CreateTab({ Name = "Trading" })
local exploitsTab = window:CreateTab({ Name = "Exploits" })
local obbyTab = window:CreateTab({ Name = "Obbies" })

-- Variables for automation
local hitEnabled, teleportHit, hitWorld, winFarm, winWorld, buyEggWorld, selectedEgg = false, false, "1", false, "1", "1", nil
local autoEquip, autoMerge, autoRebirth, claimChest, playtime, autoGadget, autoAchieve = false, false, false, false, false, false, false
local autoPumpkin, acceptTrade, cancelTrade, antiAfk = false, false, false, false
local exploitBoost, exploitWins, exploitAchievements, autoTrade, selectedPlayer, exploitRebirths, exploitPetMult = false, false, false, false, nil, false, false
local selectedObby, selectedFinish = nil, nil

-- Populate egg and obby lists
local eggs = {}
for i = 1, 11 do
    local world = Workspace.Worlds[tostring(i)]
    local eggFolder = world:FindFirstChild("Eggs")
    if eggFolder then
        for _, egg in ipairs(eggFolder:GetChildren()) do
            table.insert(eggs, egg.Name)
        end
    end
end

local obbies = {}
local finishes = {}
for _, obby in ipairs(Workspace.Obbies:GetChildren()) do
    table.insert(obbies, obby.Name)
    if obby:FindFirstChild("Finish") then
        table.insert(finishes, obby.Name)
    end
end

-- Player list for trading
local playerList = {}
local function updatePlayerList()
    playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
end
updatePlayerList()

-- Main tab controls
mainTab:Combo({
    Label = "Select World for Hitting",
    Selected = "1",
    Items = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"},
    Callback = function(_, value) hitWorld = value end
})

mainTab:Checkbox({
    Label = "Teleport to Hit Blocks",
    Value = false,
    Callback = function(_, value) teleportHit = value end
})

mainTab:Checkbox({
    Label = "Auto Hit Blocks",
    Value = false,
    Callback = function(_, value) hitEnabled = value end
})

mainTab:Combo({
    Label = "Select World for Wins",
    Selected = "1",
    Items = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"},
    Callback = function(_, value) winWorld = value end
})

mainTab:Checkbox({
    Label = "Auto Farm Wins",
    Value = false,
    Callback = function(_, value) winFarm = value end
})

mainTab:Checkbox({
    Label = "Auto Merge Pets",
    Value = false,
    Callback = function(_, value) autoMerge = value end
})

mainTab:Checkbox({
    Label = "Auto Rebirth",
    Value = false,
    Callback = function(_, value) autoRebirth = value end
})

mainTab:Checkbox({
    Label = "Auto Claim Playtime Rewards",
    Value = false,
    Callback = function(_, value) playtime = value end
})

mainTab:Checkbox({
    Label = "Auto Claim Group Chest",
    Value = false,
    Callback = function(_, value) claimChest = value end
})

mainTab:Checkbox({
    Label = "Auto Buy Gadget",
    Value = false,
    Callback = function(_, value) autoGadget = value end
})

mainTab:Checkbox({
    Label = "Auto Collect Achievements",
    Value = false,
    Callback = function(_, value) autoAchieve = value end
})

mainTab:Checkbox({
    Label = "Auto Collect Pumpkins",
    Value = false,
    Callback = function(_, value) autoPumpkin = value end
})

-- Egg tab controls
eggTab:Combo({
    Label = "Select World for Egg",
    Selected = "1",
    Items = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"},
    Callback = function(_, value) buyEggWorld = value end
})

eggTab:Combo({
    Label = "Select Egg",
    Selected = nil,
    Items = eggs,
    Callback = function(_, value) selectedEgg = value end
})

eggTab:Checkbox({
    Label = "Auto Buy Egg",
    Value = false,
    Callback = function(_, value) _G._autobuy = value end
})

eggTab:Checkbox({
    Label = "Auto Equip Best Pet",
    Value = false,
    Callback = function(_, value) autoEquip = value end
})

eggTab:Button({
    Text = "Teleport to Selected Egg",
    Callback = function()
        local eggFolder = Workspace.Worlds[tostring(buyEggWorld)]:FindFirstChild("Eggs")
        if eggFolder and selectedEgg and eggFolder:FindFirstChild(selectedEgg) then
            HumanoidRootPart.CFrame = eggFolder[selectedEgg].CFrame + Vector3.new(0, 3, 0)
        end
    end
})

eggTab:Button({
    Text = "Teleport to World Door",
    Callback = function()
        local world = Workspace.Worlds[tostring(winWorld)]
        local doorFolder = world:FindFirstChild("Doors")
        if doorFolder then
            for _, door in ipairs(doorFolder:GetChildren()) do
                if door:IsA("BasePart") then
                    HumanoidRootPart.CFrame = door.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end
    end
})

-- Movement tab controls
local movementHeader = movementTab:CollapsingHeader({ Title = "Movement Settings" })

movementHeader:SliderFloat({
    Label = "Walk Speed",
    Minimum = 16,
    Maximum = 200,
    Value = 16,
    Callback = function(_, value) if Humanoid then Humanoid.WalkSpeed = value end end
})

movementHeader:SliderFloat({
    Label = "Jump Power",
    Minimum = 50,
    Maximum = 200,
    Value = 50,
    Callback = function(_, value) if Humanoid then Humanoid.JumpPower = value end end
})

local infJump, noclip, gravityDelay = false, false, 0.05

movementHeader:Checkbox({
    Label = "Infinite Jump",
    Value = false,
    Callback = function(_, value) infJump = value end
})

movementHeader:Checkbox({
    Label = "Noclip",
    Value = false,
    Callback = function(_, value) noclip = value end
})

movementHeader:SliderFloat({
    Label = "Gravity Delay",
    Minimum = 0,
    Maximum = 1,
    Value = 0.05,
    Callback = function(_, value) gravityDelay = value end
})

-- Anti-AFK tab
antiAfkTab:Checkbox({
    Label = "Anti-AFK",
    Value = false,
    Callback = function(_, value) antiAfk = value end
})

-- Trading tab
tradingTab:Checkbox({
    Label = "Auto Accept Trades",
    Value = false,
    Callback = function(_, value) acceptTrade = value end
})

tradingTab:Checkbox({
    Label = "Auto Cancel Trades",
    Value = false,
    Callback = function(_, value) cancelTrade = value end
})

tradingTab:Checkbox({
    Label = "Auto Send Trade Requests",
    Value = false,
    Callback = function(_, value) autoTrade = value end
})

local playerCombo = tradingTab:Combo({
    Label = "Select Player for Trading",
    Selected = nil,
    Items = playerList,
    Callback = function(_, value) selectedPlayer = value end
})

Players.PlayerAdded:Connect(function()
    updatePlayerList()
    playerCombo:Update({ Items = playerList })
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerList()
    playerCombo:Update({ Items = playerList })
end)

-- Exploits tab
local exploitsHeader = exploitsTab:CollapsingHeader({ Title = "Exploit Settings" })

exploitsHeader:Checkbox({
    Label = "Exploit Boost",
    Value = false,
    Callback = function(_, value) exploitBoost = value end
})

exploitsHeader:Checkbox({
    Label = "Exploit Wins",
    Value = false,
    Callback = function(_, value) exploitWins = value end
})

exploitsHeader:Checkbox({
    Label = "Exploit Achievements",
    Value = false,
    Callback = function(_, value) exploitAchievements = value end
})

exploitsHeader:Checkbox({
    Label = "Exploit Rebirths",
    Value = false,
    Callback = function(_, value) exploitRebirths = value end
})

exploitsHeader:Checkbox({
    Label = "Exploit Pet Multiplier",
    Value = false,
    Callback = function(_, value) exploitPetMult = value end
})

-- Obby tab
obbyTab:Combo({
    Label = "Select Obby",
    Selected = nil,
    Items = obbies,
    Callback = function(_, value) selectedObby = value end
})

obbyTab:Button({
    Text = "Teleport to Obby Start",
    Callback = function()
        if selectedObby and Workspace.Obbies:FindFirstChild(selectedObby) then
            local obby = Workspace.Obbies[selectedObby]
            local startPart = obby:FindFirstChild("Start") or obby:FindFirstChildWhichIsA("BasePart")
            if startPart then
                HumanoidRootPart.CFrame = startPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

obbyTab:Combo({
    Label = "Select Obby Finish",
    Selected = nil,
    Items = finishes,
    Callback = function(_, value) selectedFinish = value end
})

obbyTab:Button({
    Text = "Teleport to Obby Finish",
    Callback = function()
        if selectedFinish and Workspace.Obbies:FindFirstChild(selectedFinish) and Workspace.Obbies[selectedFinish]:FindFirstChild("Finish") then
            HumanoidRootPart.CFrame = Workspace.Obbies[selectedFinish].Finish.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

-- Infinite jump handler
UserInputService.JumpRequest:Connect(function()
    if infJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Noclip handler
RunService.Stepped:Connect(function()
    if noclip and HumanoidRootPart then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Main automation loop
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if teleportHit then
                for _, block in ipairs(Workspace.Worlds[hitWorld].Blocks:GetChildren()) do
                    HumanoidRootPart.CFrame = block.CFrame + Vector3.new(0, 2, 0)
                    ReplicatedStorage.Communication.Hit:FireServer()
                    task.wait(0.1)
                end
            end

            if hitEnabled then
                for _, block in ipairs(Workspace.Worlds[hitWorld].Blocks:GetChildren()) do
                    if (HumanoidRootPart.Position - block.Position).Magnitude < 10 then
                        ReplicatedStorage.Communication.Hit:FireServer()
                        task.wait(0.05)
                    end
                end
            end

            if winFarm then
                ReplicatedStorage.Communication.StartRun:FireServer()
                task.wait(0.1)
                ReplicatedStorage.Communication.FinishRun:FireServer(999999)
            end

            if autoMerge then
                ReplicatedStorage.Communication.MergeAll:FireServer()
            end

            if autoRebirth then
                ReplicatedStorage.Communication.Rebirth:FireServer()
            end

            if playtime then
                for i = 1, 12 do
                    ReplicatedStorage.Communication.ClaimPlaytimeReward:FireServer(i)
                end
            end

            if claimChest then
                ReplicatedStorage.Communication.ClaimGroupChest:FireServer()
            end

            if autoGadget then
                ReplicatedStorage.Communication.BuyGadget:FireServer("GadgetName")
            end

            if autoAchieve then
                ReplicatedStorage.Communication.CollectAchievement:FireServer("AchievementName")
            end

            if autoPumpkin then
                for i = 1, 11 do
                    ReplicatedStorage.Communication.CollectPumpkin:FireServer(tostring(i))
                end
            end

            if acceptTrade then
                ReplicatedStorage.Communication.Trading.AcceptRequest:FireServer()
            end

            if cancelTrade then
                ReplicatedStorage.Communication.Trading.CancelTrade:FireServer()
            end

            if _G._autobuy and selectedEgg and buyEggWorld then
                ReplicatedStorage.Communication.Pet.BuyEgg:InvokeServer("EggType", selectedEgg)
            end

            if autoEquip then
                ReplicatedStorage.Communication.Pet.EquipBest:FireServer()
            end

            if autoTrade and selectedPlayer then
                local targetPlayer = Players:FindFirstChild(selectedPlayer)
                if targetPlayer then
                    ReplicatedStorage.Communication.Trading.TradeRequest:FireServer(targetPlayer)
                    task.wait(1)
                end
            end

            if exploitBoost then
                ReplicatedStorage.Communication.UseBoost:FireServer("BoostType")
            end

            if exploitWins then
                ReplicatedStorage.Communication.FinishRun:FireServer(999999)
            end

            if exploitAchievements then
                ReplicatedStorage.Communication.CollectAchievement:FireServer("AchievementName")
            end

            if exploitRebirths then
                ReplicatedStorage.Communication.Rebirth:FireServer()
            end

            if exploitPetMult then
                LocalPlayer:SetAttribute("PetMultiplier", 1000)
            end
        end)
    end
end)

-- Anti-AFK loop
task.spawn(function()
    while true do
        if antiAfk then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        end
        task.wait(60)
    end
end)