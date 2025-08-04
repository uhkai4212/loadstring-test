Players = game:GetService("Players")
Camera = workspace.CurrentCamera

SilentAimFOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2))

local function getClosestPlayerToCenter()
    local centerScreenPosition = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2))
    local closestPlayer
    local closestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerRootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(playerRootPart.Position)

            if onScreen then
                local distance = (centerScreenPosition - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude

                if distance < closestDistance and distance <= SilentAimFOVCircle.Radius then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end


local SilentTarget = nil

game:GetService("RunService").RenderStepped:Connect(function()
    SilentTarget = getClosestPlayerToCenter()
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if getgenv().Enabled and SilentTarget~=nil and SilentTarget.Character and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
            args[3] = SilentTarget.Character[getgenv().HitPart].Position + (SilentTarget.Character[getgenv().HitPart].Velocity*getgenv().Prediction)
        return old(unpack(args))
    end
    return old(...)
end)