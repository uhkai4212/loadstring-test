if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingScreenPrefab") == nil

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(false)

if not game.CoreGui:FindFirstChild("BondFarm") then
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "BondFarm"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    local black = Instance.new("Frame", gui)
    black.Size = UDim2.new(1, 0, 1, 0)
    black.BackgroundColor3 = Color3.new(0, 0, 0)
    black.BackgroundTransparency = 0.4
    black.ZIndex = 0

    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Name = "mainFrame"
    mainFrame.Size = UDim2.new(0.4, 0, 0.2, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundTransparency = 1
    mainFrame.ZIndex = 2

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(0.8, 0, 0.3, 0)
    title.Position = UDim2.new(0.5, 0, 0.1, 0)
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = "Bond Farm V1"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.ZIndex = 2

    local bondCount = Instance.new("TextLabel", mainFrame)
    bondCount.Name = "bondCount"
    bondCount.Size = UDim2.new(0.6, 0, 0.2, 0)
    bondCount.Position = UDim2.new(0.5, 0, 0.6, 0)
    bondCount.AnchorPoint = Vector2.new(0.5, 0)
    bondCount.BackgroundTransparency = 1
    bondCount.Text = "Collected Bonds: 0"
    bondCount.TextColor3 = Color3.new(1, 1, 1)
    bondCount.TextScaled = true
    bondCount.Font = Enum.Font.SourceSans
    bondCount.ZIndex = 2

    local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
    blur.Size = 12
    blur.Name = "Blur"
end

_G.Bond = 0
workspace.RuntimeItems.ChildAdded:Connect(function(v)
    if v.Name:find("Bond") and v:FindFirstChild("Part") then
        v.Destroying:Connect(function() _G.Bond += 1 end)
    end
end)

task.spawn(function()
    while true do
        local gui = game.CoreGui:FindFirstChild("BondFarm")
        if gui and gui:FindFirstChild("mainFrame") and gui.mainFrame:FindFirstChild("bondCount") then
            gui.mainFrame.bondCount.Text = "Collected Bonds: " .. tostring(_G.Bond)
        end
        task.wait(0.1)
    end
end)

local player = game.Players.LocalPlayer
player.CameraMode = "Classic"
player.CameraMaxZoomDistance = math.huge
player.CameraMinZoomDistance = 30
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
workspace.CurrentCamera.CameraSubject = hum
hrp.Anchored = true
task.wait(0.2)

hrp.CFrame = CFrame.new(80, 3, -9000)
repeat task.wait() until workspace.RuntimeItems:FindFirstChild("MaximGun")
task.wait(0.2)

for _,v in pairs(workspace.RuntimeItems:GetChildren()) do
    if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
        v.VehicleSeat.Disabled = false
        v.VehicleSeat:SetAttribute("Disabled", false)
        v.VehicleSeat:Sit(hum)
    end
end

task.wait(0.2)
for _,v in pairs(workspace.RuntimeItems:GetChildren()) do
    if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (hrp.Position - v.VehicleSeat.Position).Magnitude < 400 then
        hrp.CFrame = v.VehicleSeat.CFrame
    end
end

task.wait(0.5)
hrp.Anchored = false
repeat task.wait(0.1) until hum.Sit
task.wait(0.3)
hum.Sit = false
task.wait(0.2)
repeat
    for _,v in pairs(workspace.RuntimeItems:GetChildren()) do
        if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (hrp.Position - v.VehicleSeat.Position).Magnitude < 400 then
            hrp.CFrame = v.VehicleSeat.CFrame
        end
    end
    task.wait(0.2)
until hum.Sit
task.wait(0.4)

for _,v in pairs(workspace:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
        local seat = v.RequiredComponents:FindFirstChild("Controls") and v.RequiredComponents.Controls:FindFirstChild("ConductorSeat") and v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat")
        if seat then
            local tp = game:GetService("TweenService"):Create(hrp, TweenInfo.new(15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = seat.CFrame * CFrame.new(0, 20, 0)})
            tp:Play()
            if not hrp:FindFirstChild("VelocityHandler") then
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Name = "VelocityHandler"
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Velocity = Vector3.zero
            end
            tp.Completed:Wait()
        end
    end
end

task.wait(0.5)
while true do
    if hum.Sit then
        local tp = game:GetService("TweenService"):Create(hrp, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = CFrame.new(0.5, -78, -49429)})
        tp:Play()
        if not hrp:FindFirstChild("VelocityHandler") then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "VelocityHandler"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
        end
        repeat task.wait() until workspace.RuntimeItems:FindFirstChild("Bond")
        tp:Cancel()

        for _,v in pairs(workspace.RuntimeItems:GetChildren()) do
            if v.Name:find("Bond") and v:FindFirstChild("Part") then
                repeat
                    if v:FindFirstChild("Part") then
                        hrp.CFrame = v.Part.CFrame
                        game:GetService("ReplicatedStorage").Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
                    end
                    task.wait(0.1)
                until not v:FindFirstChild("Part")
            end
        end
    end
    task.wait(0.1)
end