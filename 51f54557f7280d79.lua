local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

-- Headsup Modal
local screenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
screenGui.Name = "Headsup"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local blur = Instance.new("Frame", screenGui)
blur.Size = UDim2.fromScale(1, 1)
blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blur.BackgroundTransparency = 0.2
blur.ZIndex = 1

local modal = Instance.new("Frame", screenGui)
modal.AnchorPoint = Vector2.new(0.5, 0.5)
modal.Position = UDim2.fromScale(0.5, 0.5)
modal.Size = UDim2.new(0, 340, 0, 290)
modal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
modal.BorderSizePixel = 0
modal.ZIndex = 2
modal.ClipsDescendants = true
Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 12)

local close = Instance.new("TextButton", modal)
close.Position = UDim2.new(1, -32, 0, 8)
close.Size = UDim2.new(0, 24, 0, 24)
close.Text = "X"
close.ZIndex = 3
close.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
close.TextColor3 = Color3.fromRGB(100, 100, 100)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)
close.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local iconFrame = Instance.new("Frame", modal)
iconFrame.Size = UDim2.new(0, 64, 0, 64)
iconFrame.Position = UDim2.new(0.5, -32, 0, 24)
iconFrame.BackgroundColor3 = Color3.fromRGB(255, 204, 204)
Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(1, 0)

local inner = Instance.new("Frame", iconFrame)
inner.AnchorPoint = Vector2.new(0.5, 0.5)
inner.Position = UDim2.fromScale(0.5, 0.5)
inner.Size = UDim2.new(0, 32, 0, 32)
inner.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Instance.new("UICorner", inner).CornerRadius = UDim.new(1, 0)

local exclam = Instance.new("TextLabel", inner)
exclam.Text = "!"
exclam.Font = Enum.Font.GothamBlack
exclam.TextColor3 = Color3.fromRGB(255, 255, 255)
exclam.Size = UDim2.fromScale(1, 1)
exclam.BackgroundTransparency = 1
exclam.TextScaled = true

local title = Instance.new("TextLabel", modal)
title.Position = UDim2.new(0, 0, 0, 100)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Heads up"
title.TextColor3 = Color3.fromRGB(30, 30, 30)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

local divider = Instance.new("Frame", modal)
divider.Position = UDim2.new(0.1, 0, 0, 135)
divider.Size = UDim2.new(0.8, 0, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

local message = Instance.new("TextLabel", modal)
message.Position = UDim2.new(0, 20, 0, 150)
message.Size = UDim2.new(1, -40, 0, 40)
message.TextWrapped = true
message.TextYAlignment = Enum.TextYAlignment.Top
message.Text = "If you stop claiming balls stop the loop then start, same thing for if you die and it stops."
message.TextColor3 = Color3.fromRGB(100, 100, 100)
message.Font = Enum.Font.Gotham
message.TextSize = 16
message.BackgroundTransparency = 1

local ok = Instance.new("TextButton", modal)
ok.Position = UDim2.new(0.1, 0, 0, 200)
ok.Size = UDim2.new(0.8, 0, 0, 40)
ok.Text = "Ok"
ok.Font = Enum.Font.GothamSemibold
ok.TextColor3 = Color3.fromRGB(60, 60, 60)
ok.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
Instance.new("UICorner", ok).CornerRadius = UDim.new(0, 6)
ok.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Pro GUI
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "ProBallGUI"
gui.ResetOnSpawn = false

local function makeInvincible(char)
	local hum = char:WaitForChild("Humanoid", 5)
	if not hum then return end
	hum.MaxHealth = math.huge
	hum.Health = hum.MaxHealth
	task.spawn(function()
		while hum and hum.Parent do
			if hum.Health < hum.MaxHealth then
				hum.Health = hum.MaxHealth
			end
			task.wait(0.1)
		end
	end)
end

local function onCharAdded(char)
	task.wait(0.5)
	makeInvincible(char)
end

plr.CharacterAdded:Connect(onCharAdded)
if plr.Character then onCharAdded(plr.Character) end

local function createButton(parent, yOffset, label)
	local container = Instance.new("Frame", parent)
	container.Size = UDim2.new(0, 160, 0, 45)
	container.Position = UDim2.new(1, -180, 0, yOffset)
	container.BackgroundTransparency = 1

	local shadow = Instance.new("ImageLabel", container)
	shadow.Image = "rbxassetid://1316045217"
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.Size = UDim2.new(1, 6, 1, 6)
	shadow.Position = UDim2.new(0, -3, 0, -3)
	shadow.BackgroundTransparency = 1
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.6
	shadow.ZIndex = 0

	local btn = Instance.new("TextButton", container)
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 17
	btn.Text = label
	btn.AutoButtonColor = false
	btn.ZIndex = 2
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Thickness = 1.3
	stroke.Color = Color3.fromRGB(80, 80, 80)
	stroke.Transparency = 0.2

	return btn
end

local tpBtn = createButton(gui, 20, "Start Loop")
local speedBtn = createButton(gui, 75, "Loop Buy Speed Multi")
local cashBtn = createButton(gui, 130, "Loop Buy Cash Multi")

local loopingTP, loopingSpeed, loopingCash = false, false, false

local function startTPLoop()
	task.spawn(function()
		while loopingTP do
			local balls = workspace:FindFirstChild("SpawnedBalls")
			if not balls then task.wait(1) continue end
			local char = plr.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if not hrp then
				char = plr.CharacterAdded:Wait()
				hrp = char:WaitForChild("HumanoidRootPart")
			end
			for _, ball in ipairs(balls:GetChildren()) do
				if not loopingTP then break end
				if ball:IsA("BasePart") then
					hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						hrp.CFrame = ball.CFrame + Vector3.new(0, 5, 0)
						task.wait(0.3)
					else
						break
					end
				end
			end
		end
	end)
end

local function startSpeedLoop()
	task.spawn(function()
		while loopingSpeed do
			ReplicatedStorage.Events.Upgrade:FireServer("SpeedUpgrade")
			task.wait(0.00000000000001)
		end
	end)
end

local function startCashLoop()
	task.spawn(function()
		while loopingCash do
			ReplicatedStorage.Events.Upgrade:FireServer("CashUpgrade")
			task.wait(0.00000000000001)
		end
	end)
end

tpBtn.MouseButton1Click:Connect(function()
	loopingTP = not loopingTP
	tpBtn.Text = loopingTP and "Stop Loop" or "Start Loop"
	tpBtn.BackgroundColor3 = loopingTP and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(35, 35, 35)
	if loopingTP then startTPLoop() end
end)

speedBtn.MouseButton1Click:Connect(function()
	loopingSpeed = not loopingSpeed
	speedBtn.Text = loopingSpeed and "Stop Buy Speed Multi" or "Loop Buy Speed Multi"
	speedBtn.BackgroundColor3 = loopingSpeed and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(35, 35, 35)
	if loopingSpeed then startSpeedLoop() end
end)

cashBtn.MouseButton1Click:Connect(function()
	loopingCash = not loopingCash
	cashBtn.Text = loopingCash and "Stop Buy Cash Multi" or "Loop Buy Cash Multi"
	cashBtn.BackgroundColor3 = loopingCash and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(35, 35, 35)
	if loopingCash then startCashLoop() end
end)