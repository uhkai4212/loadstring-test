local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ScriptBoxHub"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(0, 200, 0, 40)
title.Position = UDim2.new(1, -210, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Animal Simulator"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Right

local credit = Instance.new("TextLabel", mainFrame)
credit.Size = UDim2.new(0, 220, 0, 35)
credit.Position = UDim2.new(0, 10, 0, 5)
credit.BackgroundTransparency = 1
credit.Text = "Script Created By ScriptBox"
credit.TextColor3 = Color3.fromRGB(255, 255, 255)
credit.Font = Enum.Font.SourceSansItalic
credit.TextSize = 16
credit.TextXAlignment = Enum.TextXAlignment.Left

local toggleVisibility = Instance.new("TextButton", gui)
toggleVisibility.Size = UDim2.new(0, 100, 0, 30)
toggleVisibility.Position = UDim2.new(0, 10, 0, 10)
toggleVisibility.Text = "Hide"
toggleVisibility.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleVisibility.TextColor3 = Color3.new(1, 1, 1)

local isVisible = true
toggleVisibility.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    mainFrame.Visible = isVisible
    toggleVisibility.Text = isVisible and "Hide" or "Show"
end)

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(
        math.clamp(startPos.X.Scale, 0, 1),
        math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - toggleVisibility.AbsoluteSize.X),
        math.clamp(startPos.Y.Scale, 0, 1),
        math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - toggleVisibility.AbsoluteSize.Y)
    )
    toggleVisibility.Position = newPos
end

toggleVisibility.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleVisibility.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleVisibility.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.TouchMoved:Connect(function(input, gameProcessed)
    if dragging and dragInput and input == dragInput then
        update(input)
    end
end)

local tabFarm = Instance.new("TextButton", mainFrame)
tabFarm.Size = UDim2.new(0, 100, 0, 40)
tabFarm.Position = UDim2.new(0, 0, 0, 50)
tabFarm.Text = "Farm (Auto)"
tabFarm.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabFarm.TextColor3 = Color3.new(1, 1, 1)

local tabEvent = Instance.new("TextButton", mainFrame)
tabEvent.Size = UDim2.new(0, 100, 0, 40)
tabEvent.Position = UDim2.new(0, 0, 0, 95)
tabEvent.Text = "Chicken Event"
tabEvent.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabEvent.TextColor3 = Color3.new(1, 1, 1)

local farmPanel = Instance.new("Frame", mainFrame)
farmPanel.Size = UDim2.new(1, -110, 1, -60)
farmPanel.Position = UDim2.new(0, 110, 0, 50)
farmPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
farmPanel.Visible = true

local eventPanel = Instance.new("Frame", mainFrame)
eventPanel.Size = farmPanel.Size
eventPanel.Position = farmPanel.Position
eventPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
eventPanel.Visible = false

tabFarm.MouseButton1Click:Connect(function()
    farmPanel.Visible = true
    eventPanel.Visible = false
end)

tabEvent.MouseButton1Click:Connect(function()
    farmPanel.Visible = false
    eventPanel.Visible = true
end)

local function updateToggle(button, enabled, label)
    button.Text = label .. (enabled and "ON" or "OFF")
    button.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end

local toggleFarm = Instance.new("TextButton", farmPanel)
toggleFarm.Size = UDim2.new(0, 180, 0, 40)
toggleFarm.Position = UDim2.new(0, 20, 0, 20)
toggleFarm.TextColor3 = Color3.new(1, 1, 1)
toggleFarm.Font = Enum.Font.SourceSansBold
toggleFarm.TextSize = 18

local farmEnabled = false
updateToggle(toggleFarm, farmEnabled, "Coin Farm: ")

toggleFarm.MouseButton1Click:Connect(function()
    farmEnabled = not farmEnabled
    updateToggle(toggleFarm, farmEnabled, "Coin Farm: ")
end)

task.spawn(function()
    while true do
        task.wait(0)
        if farmEnabled then
            local eventFolder = ReplicatedStorage:FindFirstChild("Events")
            if eventFolder and eventFolder:FindFirstChild("CoinEvent") then
                eventFolder.CoinEvent:FireServer()
            end
        end
    end
end)

local toggleChicken = Instance.new("TextButton", eventPanel)
toggleChicken.Size = UDim2.new(0, 220, 0, 40)
toggleChicken.Position = UDim2.new(0, 20, 0, 20)
toggleChicken.TextColor3 = Color3.new(1, 1, 1)
toggleChicken.Font = Enum.Font.SourceSansBold
toggleChicken.TextSize = 18

local chickenEnabled = false
updateToggle(toggleChicken, chickenEnabled, "Auto Unlock Chicken: ")

toggleChicken.MouseButton1Click:Connect(function()
    chickenEnabled = not chickenEnabled
    updateToggle(toggleChicken, chickenEnabled, "Auto Unlock Chicken: ")
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if chickenEnabled then
            local chickenEvent = ReplicatedStorage:FindFirstChild("ChickenEvent")
            if chickenEvent and chickenEvent:FindFirstChild("RemoteEvent") then
                local combos = {
                    {},
                    {"Ice"},
                    {"Fire"},
                    {"Grass"},
                    {"Ice", "Fire", "Grass"}
                }
                for _, elements in ipairs(combos) do
                    local args = {
                        [1] = {
                            ["action"] = "craft",
                            ["element_table"] = elements
                        }
                    }
                    chickenEvent.RemoteEvent:FireServer(unpack(args))
                    task.wait(0.2)
                end
            end
        end
    end
end)

local autoPuzzleEnabled = false
local autoPuzzleToggle = Instance.new("TextButton", eventPanel)
autoPuzzleToggle.Size = UDim2.new(0, 220, 0, 40)
autoPuzzleToggle.Position = UDim2.new(0, 20, 0, 70)
autoPuzzleToggle.TextColor3 = Color3.new(1, 1, 1)
autoPuzzleToggle.Font = Enum.Font.SourceSansBold
autoPuzzleToggle.TextSize = 18

updateToggle(autoPuzzleToggle, autoPuzzleEnabled, "Auto Puzzle Solve: ")

autoPuzzleToggle.MouseButton1Click:Connect(function()
    autoPuzzleEnabled = not autoPuzzleEnabled
    updateToggle(autoPuzzleToggle, autoPuzzleEnabled, "Auto Puzzle Solve: ")

    task.spawn(function()
        while autoPuzzleEnabled do
            for i = 1, 25 do
                local puzzleName = "PUZ" .. i

                local args1 = {
                    [1] = {
                        ["action"] = "pick_up",
                        ["puzzle_name"] = puzzleName
                    }
                }
                ReplicatedStorage.Easter2025.RemoteEvent:FireServer(unpack(args1))

                task.wait(1)

                local args2 = {
                    [1] = {
                        ["action"] = "put",
                        ["puzzle_name"] = puzzleName
                    }
                }
                ReplicatedStorage.Easter2025.RemoteEvent:FireServer(unpack(args2))

                task.wait(0.2)
            end
        end
    end)
end)

local targetPlayerInput = Instance.new("TextBox", farmPanel)
targetPlayerInput.Size = UDim2.new(0, 180, 0, 35)
targetPlayerInput.Position = UDim2.new(0, 20, 0, 160)
targetPlayerInput.PlaceholderText = "Target Player Name"
targetPlayerInput.Text = ""
targetPlayerInput.Font = Enum.Font.SourceSans
targetPlayerInput.TextSize = 16
targetPlayerInput.TextColor3 = Color3.new(1, 1, 1)
targetPlayerInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
targetPlayerInput.ClearTextOnFocus = false

local spamRemoteToggle = Instance.new("TextButton", farmPanel)
spamRemoteToggle.Size = UDim2.new(0, 180, 0, 35)
spamRemoteToggle.Position = UDim2.new(0, 20, 0, 205)
spamRemoteToggle.TextColor3 = Color3.new(1, 1, 1)
spamRemoteToggle.Font = Enum.Font.SourceSansBold
spamRemoteToggle.TextSize = 16

local spamRemoteEnabled = false
updateToggle(spamRemoteToggle, spamRemoteEnabled, "Spam Remote: ")

local lastPosition = nil

spamRemoteToggle.MouseButton1Click:Connect(function()
    spamRemoteEnabled = not spamRemoteEnabled
    updateToggle(spamRemoteToggle, spamRemoteEnabled, "Spam Remote: ")

    local localCharacter = player.Character
    if spamRemoteEnabled then
        local targetName = targetPlayerInput.Text
        if targetName and targetName ~= "" then
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                lastPosition = localCharacter.HumanoidRootPart.CFrame
            end
        end
    else
        if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and lastPosition then
            localCharacter.HumanoidRootPart.CFrame = lastPosition
            lastPosition = nil
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if spamRemoteEnabled then
            local targetName = targetPlayerInput.Text
            local localCharacter = player.Character
            if targetName and targetName ~= "" and localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then
                local targetPlayer = Players:FindFirstChild(targetName)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localCharacter.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)

                    local args = {
                        [1] = targetPlayer.Character.Humanoid,
                        [2] = 11
                    }
                    local remote = ReplicatedStorage:FindFirstChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
                    if remote then
                        remote:FireServer(unpack(args))
                    end
                end
            end
        end
    end
end)