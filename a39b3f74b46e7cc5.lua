local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "RainbowEdgeGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 130)
frame.Position = UDim2.new(0.5, -160, 0.5, -65)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local function addRainbowGradient(parent)
	local grad = Instance.new("UIGradient", parent)
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 127, 0)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 0, 255)),
	}
	grad.Rotation = 45
	local info = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
	TweenService:Create(grad, info, {Rotation = 405}):Play()
end

addRainbowGradient(frame)
addRainbowGradient(topBar)

local discordLabel = Instance.new("TextLabel", topBar)
discordLabel.Size = UDim2.new(0, 200, 1, 0)
discordLabel.Position = UDim2.new(0, 10, 0, 0)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord:1w69"
discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
discordLabel.Font = Enum.Font.SourceSansBold
discordLabel.TextSize = 16
discordLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
closeBtn.Text = "❌"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 12)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local buttonHolder = Instance.new("Frame", frame)
buttonHolder.Size = UDim2.new(1, 0, 0, 50)
buttonHolder.Position = UDim2.new(0, 0, 0, 75)
buttonHolder.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", buttonHolder)
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(40, 70, 120)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = text
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
	addRainbowGradient(btn)
	btn.Parent = buttonHolder
	return btn
end

local teleportBtn = createButton("📍النقل التلقائي ❌")
local active = false
local looping = false

local isArabic = true

local translateBtn = Instance.new("TextButton", frame)
translateBtn.Size = UDim2.new(0, 120, 0, 30)
translateBtn.Position = UDim2.new(0.5, -60, 0, 40)
translateBtn.BackgroundColor3 = Color3.new(1, 1, 1)
translateBtn.BackgroundTransparency = 0.7
translateBtn.Text = "Translate / ترجم"
translateBtn.TextColor3 = Color3.fromRGB(50, 50, 50)
translateBtn.Font = Enum.Font.SourceSansBold
translateBtn.TextSize = 16
translateBtn.AutoButtonColor = true
Instance.new("UICorner", translateBtn).CornerRadius = UDim.new(0, 8)
translateBtn.Parent = frame

translateBtn.MouseButton1Click:Connect(function()
	isArabic = not isArabic
	if isArabic then
		teleportBtn.Text = "📍النقل التلقائي " .. (active and "✅" or "❌")
	else
		teleportBtn.Text = "📍Auto Teleport " .. (active and "✅" or "❌")
	end
end)

teleportBtn.MouseButton1Click:Connect(function()
	active = not active
	teleportBtn.Text = (isArabic and "📍النقل التلقائي " or "📍Auto Teleport ") .. (active and "✅" or "❌")

	if active and not looping then
		looping = true
		coroutine.wrap(function()
			local positions = {
				Vector3.new(-5.91, 1706.79, -4224.89),
				Vector3.new(-1.08, 1463.54, -6431.42),
			}
			local index = 1
			while active do
				local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				local root = character:WaitForChild("HumanoidRootPart")
				local tween = TweenService:Create(root, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
					Position = positions[index]
				})
				tween:Play()
				tween.Completed:Wait()

				index = index % #positions + 1
				RunService.Heartbeat:Wait()
			end
			looping = false
		end)()
	end
end)