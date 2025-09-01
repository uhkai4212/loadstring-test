local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local button = script.Parent -- The button this LocalScript is inside
	
	-- Function to start quest
	local function startQuest()
		local args = {1}
		workspace:WaitForChild("QuestMakerEvent"):FireServer(unpack(args))
	end
	
	-- Map BrickColor names to cloud parts
	local brickColorToCloud = {
		["Magenta"] = function()
			return workspace["MagentaZone"].Quest.Cloud.Part1
		end,
		["Really red"] = function()
			return workspace["Really redZone"].Quest.Cloud.Part1
		end,
		["Camo"] = function()
			return workspace["CamoZone"].Quest.Cloud.Part1
		end,
		["Really blue"] = function()
			return workspace["Really blueZone"].Quest.Cloud.Part1
		end,
		["Black"] = function()
			return workspace["BlackZone"].Quest.Cloud.Part1
		end,
		["White"] = function()
			return workspace["WhiteZone"].Quest.Cloud.Part1
		end,
		["New Yeller"] = function()
			return workspace["New YellerZone"].Quest.Cloud.Part1
		end
	}
	
	-- Function to touch the cloud
	local function touchCloud()
		local brickColorName = tostring(player.Team.TeamColor)
		local cloudGetter = brickColorToCloud[brickColorName]
	
		if not cloudGetter then
			warn("No cloud path for", brickColorName)
			return
		end
	
		local cloudPart = cloudGetter()
		if not cloudPart or not cloudPart:FindFirstChild("TouchInterest") then
			warn("TouchInterest not found for", brickColorName)
			return
		end
	
		firetouchinterest(player.Character.HumanoidRootPart, cloudPart, 0)
		task.wait(0.1)
		firetouchinterest(player.Character.HumanoidRootPart, cloudPart, 1)
		print("Touched cloud for team:", brickColorName)
	end
	
	-- When button clicked: start quest + touch cloud
	button.MouseButton1Click:Connect(function()
		startQuest()
		task.wait(0.5) -- small delay to make sure quest starts
		touchCloud()
	end)
	
end
coroutine.wrap(FOHUNTA_fake_script)()
local function VAIPA_fake_script() -- TextButton_2.LocalScript 
	local script = Instance.new('LocalScript', TextButton_2)

	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local button = script.Parent -- The button this script is inside
	
	-- Map BrickColor names to TouchInterest paths
	local brickColorToTouchInterest = {
		["Really red"] = function()
			return workspace["Really redZone"].Quest.Ramp:GetChildren()[20]:FindFirstChildOfClass("TouchTransmitter")
				or workspace["Really redZone"].Quest.Ramp:GetChildren()[20]:FindFirstChild("TouchInterest")
		end,
		["Really blue"] = function()
			return workspace["Really blueZone"].Quest.Ramp:GetChildren()[20]:FindFirstChildOfClass("TouchTransmitter")
				or workspace["Really blueZone"].Quest.Ramp:GetChildren()[20]:FindFirstChild("TouchInterest")
		end,
		["Camo"] = function()
			return workspace["CamoZone"].Quest.Ramp:GetChildren()[20]:FindFirstChildOfClass("TouchTransmitter")
				or workspace["CamoZone"].Quest.Ramp:GetChildren()[20]:FindFirstChild("TouchInterest")
		end,
		["Magenta"] = function()
			return workspace["MagentaZone"].Quest.Ramp:GetChildren()[20]:FindFirstChildOfClass("TouchTransmitter")
				or workspace["MagentaZone"].Quest.Ramp:GetChildren()[20]:FindFirstChild("TouchInterest")
		end,
		["Black"] = function()
			return workspace["BlackZone"].Quest.Ramp:GetChildren()[20]:FindFirstChildOfClass("TouchTransmitter")
				or workspace["BlackZone"].Quest.Ramp:GetChildren()[20]:FindFirstChild("TouchInterest")
		end,
		["White"] = function()
			return workspace["WhiteZone"].Quest.Ramp:GetChildren()[20]:FindFirstChildOfClass("TouchTransmitter")
				or workspace["WhiteZone"].Quest.Ramp:GetChildren()[20]:FindFirstChild("TouchInterest")
		end,
		["New Yeller"] = function()
			return workspace["New YellerZone"].Quest.Ramp:GetChildren()[20]:FindFirstChildOfClass("TouchTransmitter")
				or workspace["New YellerZone"].Quest.Ramp:GetChildren()[20]:FindFirstChild("TouchInterest")
		end
	}
	
	-- Function to simulate touching
	local function simulateTouch()
		local brickColorName = tostring(player.Team.TeamColor)
		local touchInterestGetter = brickColorToTouchInterest[brickColorName]
	
		if not touchInterestGetter then
			warn("No TouchInterest path for", brickColorName)
			return
		end
	
		local touchInterest = touchInterestGetter()
		if not touchInterest then
			warn("TouchInterest not found for", brickColorName)
			return
		end
	
		firetouchinterest(player.Character.HumanoidRootPart, touchInterest.Parent, 0) -- Touch start
		task.wait(0.1)
		firetouchinterest(player.Character.HumanoidRootPart, touchInterest.Parent, 1) -- Touch end
		print("Simulated touch for team:", brickColorName)
	end
	
	-- Button click starts quest and simulates touch
	button.MouseButton1Click:Connect(function()
		-- START QUEST
		local args = { 3 }
		workspace:WaitForChild("QuestMakerEvent"):FireServer(unpack(args))
		print("Quest started!")
	
		-- Wait a little before simulating touch (ensures quest objects load)
		task.wait(0.5)
		simulateTouch()
	end)
	
end
coroutine.wrap(VAIPA_fake_script)()
local function HIKS_fake_script() -- TextButton_3.LocalScript 
	local script = Instance.new('LocalScript', TextButton_3)

	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local button = script.Parent -- Put this inside your TextButton
	
	-- Map BrickColor names to target parts
	local brickColorToTarget = {
		["Magenta"] = function()
			return workspace["MagentaZone"].Quest.Target.Part
		end,
		["Really red"] = function()
			return workspace["Really redZone"].Quest.Target.Part
		end,
		["Camo"] = function()
			return workspace["CamoZone"].Quest.Target.Part
		end,
		["Really blue"] = function()
			return workspace["Really blueZone"].Quest.Target.Part
		end,
		["Black"] = function()
			return workspace["BlackZone"].Quest.Target.Part
		end,
		["White"] = function()
			return workspace["WhiteZone"].Quest.Target.Part
		end,
		["New Yeller"] = function()
			return workspace["New YellerZone"].Quest.Target.Part
		end
	}
	
	-- Function to start the quest
	local function startQuest()
		local args = { 2 }
		workspace:WaitForChild("QuestMakerEvent"):FireServer(unpack(args))
		print("Quest started!")
	end
	
	-- Function to simulate touching
	local function simulateTouch()
		local brickColorName = tostring(player.Team.TeamColor)
		local targetGetter = brickColorToTarget[brickColorName]
	
		if not targetGetter then
			warn("No target path for", brickColorName)
			return
		end
	
		local targetPart = targetGetter()
		if not targetPart or not targetPart:FindFirstChild("TouchInterest") then
			warn("TouchInterest not found for", brickColorName)
			return
		end
	
		firetouchinterest(player.Character.HumanoidRootPart, targetPart, 0) -- touch start
		task.wait(0.1)
		firetouchinterest(player.Character.HumanoidRootPart, targetPart, 1) -- touch end
		print("Simulated target touch for team:", brickColorName)
	end
	
	-- When button clicked: start quest, then simulate touch
	button.MouseButton1Click:Connect(function()
		startQuest()
		task.wait(0.5) -- small delay so quest registers before touching
		simulateTouch()
	end)
	
end
coroutine.wrap(HIKS_fake_script)()
local function KKCGIY_fake_script() -- TextButton_4.LocalScript 
	local script = Instance.new('LocalScript', TextButton_4)