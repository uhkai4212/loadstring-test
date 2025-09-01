local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local button = script.Parent -- Button this LocalScript is inside
	
	local brickColorToZone = {
		["New Yeller"] = "New YellerZone",
		["Really red"] = "Really redZone",
		["Magenta"] = "MagentaZone",
		["Camo"] = "CamoZone",
		["Really blue"] = "Really blueZone",
		["White"] = "WhiteZone",
		["Black"] = "BlackZone"
	}
	
	local function getButterClickDetector()
		local zoneName = brickColorToZone[tostring(player.Team.TeamColor)]
		if not zoneName then return end
		local zone = workspace:FindFirstChild(zoneName)
		if not zone then return end
		local quest = zone:FindFirstChild("Quest")
		if not quest then return end
		local butter = quest:FindFirstChild("Butter")
		if not butter then return end
		local ppart = butter:FindFirstChild("PPart")
		if not ppart then return end
		return ppart:FindFirstChildOfClass("ClickDetector")
	end
	
	local function clickButter()
		local cd = getButterClickDetector()
		if cd then
			fireclickdetector(cd)
			print("Clicked butter for", player.Team.TeamColor.Name)
			return true
		else
			warn("No butter found for", player.Team.TeamColor.Name)
			return false
		end
	end
	
	button.MouseButton1Click:Connect(function()
		-- Step 1: Start the quest
		local args = { 4 }
		workspace:WaitForChild("QuestMakerEvent"):FireServer(unpack(args))
		print("Quest started.")
	
		-- Small delay so quest loads
		task.wait(0.5)
	
		-- Step 2: Run the butter-clicking loop
		local failCount = 0
		while true do
			if clickButter() then
				failCount = 0
			else
				failCount += 1
				if failCount >= 3 then
					warn("Quest seems to be over, stopping script.")
					break
				end
			end
			task.wait(0.5)
		end
	end)
	
end
coroutine.wrap(KKCGIY_fake_script)()
local function ETTVN_fake_script() -- TextButton_5.LocalScript 
	local script = Instance.new('LocalScript', TextButton_5)