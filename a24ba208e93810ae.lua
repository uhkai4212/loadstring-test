local radius = 15
local weaponName = "WoodenSword"
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

local toolService = ReplicatedStorage:WaitForChild("Modules", 9e9)
    :WaitForChild("Knit", 9e9)
    :WaitForChild("Services", 9e9)
    :WaitForChild("ToolService", 9e9)

local attackFunction = toolService:WaitForChild("RF", 9e9):WaitForChild("AttackPlayerWithSword", 9e9)

RunService.RenderStepped:Connect(function()
    local character = localPlayer.Character
    if not character then return end
    local myHRP = character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetChar = player.Character
            local targetHRP = targetChar.HumanoidRootPart
            if (myHRP.Position - targetHRP.Position).Magnitude <= radius then
                local args = {
                    [1] = workspace:FindFirstChild(targetChar.Name),
                    [2] = false,
                    [3] = weaponName,
                    [4] = "â€‹"
                }
                attackFunction:InvokeServer(unpack(args))
            end
        end
    end
end)