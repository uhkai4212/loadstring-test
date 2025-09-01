local TweenService = game:GetService("TweenService")
	
	local sidebar = script.Parent
	local main = sidebar.Parent
	
	-- Frames and corresponding buttons
	local frames = {
		AutoBuyButton = main.AutoBuyFrame,
		AutoFarmButton = main.AutoFarmFrame,
		AutoQuestButton = main.AutoQuestFrame,
		MiscButton = main.MiscFrame,
		HomeButton = main.HomeFrame
	}
	
	-- Button highlight settings
	local selectedColor = Color3.fromRGB(170, 170, 170)
	local selectedTransparency = 0.7
	local defaultColor = Color3.fromRGB(66, 66, 66)
	local defaultTransparency = 0.4
	
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	-- Function to show the correct frame
	local function showFrame(frameToShow)
		for _, frame in pairs(frames) do
			frame.Visible = false
		end
		frameToShow.Visible = true
	end
	
	-- Function to smoothly highlight the selected button
	local function highlightButton(selectedButton)
		for buttonName in pairs(frames) do
			local btn = sidebar:FindFirstChild(buttonName)
			if btn and btn:IsA("TextButton") then
				local goal = {}
				if btn == selectedButton then
					goal.BackgroundColor3 = selectedColor
					goal.BackgroundTransparency = selectedTransparency
				else
					goal.BackgroundColor3 = defaultColor
					goal.BackgroundTransparency = defaultTransparency
				end
				TweenService:Create(btn, tweenInfo, goal):Play()
			end
		end
	end
	
	-- Connect buttons
	for buttonName, frame in pairs(frames) do
		local button = sidebar:FindFirstChild(buttonName)
		if button then
			button.MouseButton1Click:Connect(function()
				showFrame(frame)
				highlightButton(button)
			end)
		end
	end
	
	-- Default tab (Home)
	showFrame(main.HomeFrame)
	highlightButton(sidebar.HomeButton)
	
end
coroutine.wrap(VNBWB_fake_script)()
local function HWYAXBM_fake_script() -- StartButton.LocalScript 
	local script = Instance.new('LocalScript', StartButton)

	-- Build A Boat Autofarm - Teleport + Platform Spawn
	-- Platforms appear when started, disappear when stopped
	
	local player = game.Players.LocalPlayer
	local isRunning = false
	local spawnedPlatforms = {}
	
	local positions = {
		Vector3.new(-62, 67, 1363),
		Vector3.new(-65, 58, 2135),
		Vector3.new(-52, 73, 2903),
		Vector3.new(-58, 76, 3672),
		Vector3.new(-60, 80, 4445),
		Vector3.new(-55, 73, 5217),
		Vector3.new(-53, 64, 5984),
		Vector3.new(-63, 63, 6751),
		Vector3.new(-50, 28, 7527),
		Vector3.new(-104, 37, 8298),
		Vector3.new(-57, -358, 9491)
	}
	
	local function removePlatforms()
		-- Remove all platforms stored in the local table
		for _, p in ipairs(spawnedPlatforms) do
			if p and p.Parent then
				p:Destroy()
			end
		end
		table.clear(spawnedPlatforms)
	
		-- Also remove any leftover platforms in the workspace
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj:IsA("Part") and obj.Name == "TeleportPlatform" then
				obj:Destroy()
			end
		end
	end
	
	local function platformExistsAt(pos)
		for _, part in ipairs(spawnedPlatforms) do
			if part and part.Parent and (part.Position - Vector3.new(pos.X, pos.Y - 3, pos.Z)).Magnitude < 0.1 then
				return true
			end
		end
		return false
	end
	
	local function placePlatform(pos)
		if platformExistsAt(pos) then return end
		local platform = Instance.new("Part")
		platform.Size = Vector3.new(10, 1, 10)
		platform.Position = Vector3.new(pos.X, pos.Y - 3, pos.Z)
		platform.Anchored = true
		platform.CanCollide = true
		platform.Material = Enum.Material.SmoothPlastic
		platform.BrickColor = BrickColor.new("Bright yellow")
		platform.Name = "TeleportPlatform"
		platform.Parent = workspace
		table.insert(spawnedPlatforms, platform)
	
		local surfaceGui = Instance.new("SurfaceGui")
		surfaceGui.Face = Enum.NormalId.Top
		surfaceGui.Adornee = platform
		surfaceGui.Parent = platform
	
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "Made By D3IVI5420"
		textLabel.TextColor3 = Color3.new(0, 0, 0)
		textLabel.TextScaled = true
		textLabel.Font = Enum.Font.SourceSansBold
		textLabel.Parent = surfaceGui
	end
	
	local function runLoop()
		while isRunning do
			local character = player.Character
			if not character then
				player.CharacterAdded:Wait()
				continue
			end
	
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if not hrp then
				task.wait(0.5)
				continue
			end
	
			for _, pos in ipairs(positions) do
				if not isRunning then break end
				placePlatform(pos)
				hrp.CFrame = CFrame.new(pos)
				task.wait(2)
			end
	
			task.wait(16)
		end
	
		removePlatforms()
	end