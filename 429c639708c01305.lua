local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local dailyRemote = ReplicatedStorage.CratesUtilities.Remotes:FindFirstChild("GiveReward")

-- Mac-style animations
local function createMacButton(parent, size, position, text, bgColor, textColor)
	local button = Instance.new("TextButton", parent)
	button.Size = size
	button.Position = position
	button.BackgroundColor3 = bgColor
	button.Text = text
	button.TextColor3 = textColor
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 16
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	
	-- Rounded corners
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 8)
	
	-- Mac-style hover and click animations
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
			Size = UDim2.new(size.X.Scale, size.X.Offset + 4, size.Y.Scale, size.Y.Offset + 2),
			BackgroundColor3 = Color3.new(bgColor.R + 0.1, bgColor.G + 0.1, bgColor.B + 0.1)
		}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
			Size = size,
			BackgroundColor3 = bgColor
		}):Play()
	end)
	
	return button
end

local function createCloseButton(parent)
	local closeBtn = Instance.new("TextButton", parent)
	closeBtn.Size = UDim2.new(0, 20, 0, 20)
	closeBtn.Position = UDim2.new(0, 15, 0, 15)
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
	closeBtn.Text = ""
	closeBtn.BorderSizePixel = 0
	closeBtn.AutoButtonColor = false
	
	-- Perfect circle
	local corner = Instance.new("UICorner", closeBtn)
	corner.CornerRadius = UDim.new(0.5, 0)
	
	-- Mac close button animations
	closeBtn.MouseEnter:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 22, 0, 22),
			Position = UDim2.new(0, 14, 0, 14),
			BackgroundColor3 = Color3.fromRGB(255, 105, 96)
		}):Play()
		
		-- Show X on hover
		closeBtn.Text = "×"
		closeBtn.TextSize = 14
		closeBtn.Font = Enum.Font.GothamBold
		closeBtn.TextColor3 = Color3.fromRGB(130, 0, 0)
	end)
	
	closeBtn.MouseLeave:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 15, 0, 15),
			BackgroundColor3 = Color3.fromRGB(255, 95, 86)
		}):Play()
		
		-- Hide X when not hovering
		closeBtn.Text = ""
	end)
	
	return closeBtn
end

-- Create main GUI with Mac styling
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MacMoneyHub"
gui.ResetOnSpawn = false

-- Main frame with Mac window styling
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
frame.BorderSizePixel = 0
frame.Active = true
frame.Visible = true

-- Mac-style rounded corners
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

-- Mac window top bar
local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
topBar.BorderSizePixel = 0

local topBarCorner = Instance.new("UICorner", topBar)
topBarCorner.CornerRadius = UDim.new(0, 12)

-- Fix bottom corners of top bar
local topBarFix = Instance.new("Frame", topBar)
topBarFix.Size = UDim2.new(1, 0, 0, 12)
topBarFix.Position = UDim2.new(0, 0, 1, -12)
topBarFix.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
topBarFix.BorderSizePixel = 0

-- Window title
local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 50, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Money Hub"
title.TextColor3 = Color3.new(0.9, 0.9, 0.9)
title.Font = Enum.Font.GothamMedium
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center

-- Creator info
local creator = Instance.new("TextLabel", topBar)
creator.Size = UDim2.new(0, 120, 0, 20)
creator.Position = UDim2.new(1, -125, 1, -25)
creator.BackgroundTransparency = 1
creator.Text = "by-- cilo"
creator.TextColor3 = Color3.fromRGB(150, 150, 150)
creator.Font = Enum.Font.Gotham
creator.TextSize = 11
creator.TextXAlignment = Enum.TextXAlignment.Right

-- Mac close button
local closeBtn = createCloseButton(topBar)
closeBtn.MouseButton1Click:Connect(function()
	-- Smooth close animation
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}):Play()
	
	task.wait(0.3)
	frame.Visible = false
	-- Reset size for next time
	frame.Size = UDim2.new(0, 320, 0, 180)
	frame.Position = UDim2.new(0.5, -160, 0.5, -90)
end)

-- Money button with synchronized animation
local moneyBtn = createMacButton(
	frame,
	UDim2.new(0.8, 0, 0, 45),
	UDim2.new(0.1, 0, 0.45, 0),
	"Infinite Money",
	Color3.fromRGB(0, 122, 255),
	Color3.new(1, 1, 1)
)

-- Rainbow effect for money button
task.spawn(function()
	local hue = 0
	while true do
		if moneyBtn.Parent then
			hue = (hue + 0.01) % 1
			local newColor = Color3.fromHSV(hue, 0.8, 0.9)
			
			-- Only tween if not being hovered
			if not moneyBtn:FindFirstChild("HoverTween") then
				TweenService:Create(moneyBtn, TweenInfo.new(0.05), {
					BackgroundColor3 = newColor
				}):Play()
			end
		end
		task.wait(0.05)
	end
end)

-- Synchronized button press animation
moneyBtn.MouseButton1Click:Connect(function()
	-- Create synchronized scaling animation for button and text
	local originalSize = moneyBtn.Size
	local scaleDown = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local scaleUp = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	
	-- Scale down animation
	local downTween = TweenService:Create(moneyBtn, scaleDown, {
		Size = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset * 0.95, 
						originalSize.Y.Scale * 0.9, originalSize.Y.Offset * 0.9),
		TextSize = 14
	})
	
	-- Scale up animation
	local upTween = TweenService:Create(moneyBtn, scaleUp, {
		Size = originalSize,
		TextSize = 16
	})
	
	-- Execute animations in sequence
	downTween:Play()
	downTween.Completed:Connect(function()
		upTween:Play()
	end)
	
	-- Fire the remote
	if dailyRemote then
		dailyRemote:FireServer("inf")
	end
end)

-- Dragging functionality
local dragging, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)

-- Entrance animation
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 320, 0, 180),
	Position = UDim2.new(0.5, -160, 0.5, -90)
}):Play()