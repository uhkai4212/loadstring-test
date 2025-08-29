local function getCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	return char, hrp
end

local followConnection
local selectedPlayer
local followAll = false
local t = 0

--// Fancy follow function
local function followTarget(targetPlayer)
	if followConnection then
		followConnection:Disconnect()
		local _, hrp = getCharacter()
		hrp.CFrame = hrp.CFrame
	end

	if not targetPlayer then return end
	selectedPlayer = targetPlayer
	t = 0

	followConnection = RunService.Heartbeat:Connect(function(dt)
		local char, hrp = getCharacter()
		if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local humanoid = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Sit then
				if followAll then
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character then
							local hum = p.Character:FindFirstChildOfClass("Humanoid")
							if hum and not hum.Sit then
								selectedPlayer = p
								t = 0
								return
							end
						end
					end
				else
					hrp.CFrame = hrp.CFrame
					followConnection:Disconnect()
				end
				return
			end

			t = t + dt
			local yOffset = math.sin(t * 2 * math.pi) * 3
			local zOffset = math.sin(t * 1.5 * math.pi) * 2
			local rotation = CFrame.Angles(0, math.rad(t*90), 0)
			local targetCFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
			hrp.CFrame = targetCFrame * CFrame.new(0,3+yOffset,zOffset) * rotation
		elseif followAll then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					local hum = p.Character:FindFirstChildOfClass("Humanoid")
					if hum and not hum.Sit then
						selectedPlayer = p
						t = 0
						return
					end
				end
			end
		end
	end)
end

--// Follow All Button
allButton.MouseButton1Click:Connect(function()
	followAll = true
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			if hum and not hum.Sit then
				followTarget(p)
				break
			end
		end
	end
end)

--// Create Player Buttons
local function addPlayerButton(p)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -5, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(20,20,30)
	button.TextColor3 = Color3.fromRGB(0,255,255)
	button.Font = Enum.Font.GothamBold
	button.Text = p.Name
	button.TextScaled = true
	button.Parent = scrollingFrame

	Instance.new("UICorner", button).CornerRadius = UDim.new(0,6)
	local btnStroke = Instance.new("UIStroke", button)
	btnStroke.Color = Color3.fromRGB(0,255,255)
	btnStroke.Thickness = 1

	button.MouseButton1Click:Connect(function()
		followAll = false
		followTarget(p)
	end)
	scrollingFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y)
end

--// Remove button
local function removePlayerButton(p)
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextButton") and child.Text == p.Name then
			child:Destroy()
		end
	end
	scrollingFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y)
end

--// Populate
for _, p in pairs(Players:GetPlayers()) do
	if p ~= player then addPlayerButton(p) end
end

Players.PlayerAdded:Connect(addPlayerButton)
Players.PlayerRemoving:Connect(removePlayerButton)

--// Minimize Toggle (fixed)
local minimized = false
local oldSize = frame.Size
local oldBG = frame.BackgroundColor3
minButton.MouseButton1Click:Connect(function()
	if minimized then
		frame:TweenSize(oldSize,"Out","Quad",0.4,true)
		frame.BackgroundColor3 = oldBG
		minimized = false
	else
		oldSize = frame.Size
		frame:TweenSize(UDim2.new(0, oldSize.X.Offset, 0, 40),"Out","Quad",0.4,true)
		frame.BackgroundColor3 = Color3.fromRGB(0,0,0) -- hides background
		minimized = true
	end
end)

--// Draggable Title
local dragging = false
local dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

--// Reset Follow on Character Respawn
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	if selectedPlayer then
		followTarget(selectedPlayer)
	elseif followAll then
		allButton:MouseButton1Click()
	end
end)