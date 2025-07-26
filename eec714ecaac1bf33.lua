-- Main Loop while task.wait(0.01) do if InfStaminaOn then game.Players.LocalPlayer.Energy.Value = math.huge end

if FlingBossOn then
    local HRP = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local existing = HRP:FindFirstChild("FlingSpin")
    if not existing then
        local bav = Instance.new("BodyAngularVelocity")
        bav.Name = "FlingSpin"
        bav.AngularVelocity = Vector3.new(0, 99999, 0)
        bav.MaxTorque = Vector3.new(0, math.huge, 0)
        bav.P = math.huge
        bav.Parent = HRP
    end

    for _, boss in pairs(workspace.Characters.Enemies:GetChildren()) do
        if boss.Name ~= "Training Dummy" then
            HRP.CFrame = boss.HumanoidRootPart.CFrame
        end
    end
end

if KillAuraOn then
    for _, v in pairs(workspace.Characters.Enemies:GetChildren()) do
        if v.Name ~= "Training Dummy" then
            if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Combonum.Value = 0
            end

            game:GetService("ReplicatedStorage").Remotes.Charge:FireServer(Class, {
                Mousepos = Vector3.new(477.8, 58, -88.05)
            })

            game:GetService("ReplicatedStorage").Remotes.Activate:FireServer(Class, {
                Charge = 0,
                Mousepos = Vector3.new(477.8, 58, -88.05),
                ComboNum = 1
            }, 1, "196⒤563041248341425220142Accelerate")

            game:GetService("ReplicatedStorage").Remotes.Damage:FireServer(v:WaitForChild("Humanoid"), Class)

            if v.Humanoid.Health == 0 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
            end
        end
    end
end

end