local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

local active = false
local farmConnection

-- Change this to the game's actual RemoteEvent for attacking.
local AttackRemote = ReplicatedStorage:WaitForChild("CombatRemote")

-- Function to find nearest enemy player
local function getClosestEnemy()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local targetHumanoid = player.Character.Humanoid
            if targetHumanoid.Health > 0 then
                local distance = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closest = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

-- Auto-farm logic
local function startFarm()
    farmConnection = RunService.RenderStepped:Connect(function()
        local enemy = getClosestEnemy()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = enemy.Character.HumanoidRootPart
            RootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 2)

            -- Attack spam
            pcall(function()
                AttackRemote:FireServer()
            end)
        end
    end)
end

local function stopFarm()
    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end
end

-- Simple GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "AutoFarmKills"

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.9, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Text = "Enable Auto-Farm Kills"

Button.MouseButton1Click:Connect(function()
    active = not active
    if active then
        startFarm()
        Button.Text = "Disable Auto-Farm Kills"
        Button.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    else
        stopFarm()
        Button.Text = "Enable Auto-Farm Kills"
        Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)