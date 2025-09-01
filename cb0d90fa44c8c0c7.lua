local button = script.Parent
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Workspace = game:GetService("Workspace")
	
	local QuestEvent = Workspace:WaitForChild("QuestMakerEvent")
	
	-- Block placement data
	local teamBlocks = {
		green = {
			zone = "CamoZone",
			placeCF = CFrame.new(49, 6.1, -27),
			targetCF = CFrame.new(-355.9657, -11.89999, 222.89316, 0, 0, 1, 0, 1, 0, -1, 0, 0)
		},
		magenta = {
			zone = "MagentaZone",
			placeCF = CFrame.new(49, 6.1, -27),
			targetCF = CFrame.new(248.83432, -11.89999, 710.69318, 0, 0, -1, 0, 1, 0, 1, 0, 0)
		},
		blue = {
			zone = "Really blueZone",
			placeCF = CFrame.new(49, 6.1, -27),
			targetCF = CFrame.new(248.83432, -11.89999, 352.49319, 0, 0, -1, 0, 1, 0, 1, 0, 0)
		},
		red = {
			zone = "Really redZone",
			placeCF = CFrame.new(49, 6.1, -28),
			targetCF = CFrame.new(249.83432, -11.89999, -5.70679, 0, 0, -1, 0, 1, 0, 1, 0, 0)
		},
		black = {
			zone = "BlackZone",
			placeCF = CFrame.new(48.99999, 6.1, -27),
			targetCF = CFrame.new(-355.9657, -11.89999, -136.10684, 0, 0, 1, 0, 1, 0, -1, 0, 0)
		},
		white = {
			zone = "WhiteZone",
			placeCF = CFrame.new(49, 6.1, -27),
			targetCF = CFrame.new(9.43431, -11.89999, -372.50687, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		},
		yellow = {
			zone = "New YellerZone",
			placeCF = CFrame.new(49, 6.1, -27),
			targetCF = CFrame.new(-355.9657, -11.89999, 580.89319, 0, 0, 1, 0, 1, 0, -1, 0, 0)
		}
	}
	
	local function findTeamData(teamName)
		if not teamName then return nil end
		local nameLower = string.lower(teamName)
		for keyword, data in pairs(teamBlocks) do
			if string.find(nameLower, keyword) then
				return data
			end
		end
		return nil
	end
	
	local function runBlockScript()
		local teamName = LocalPlayer.Team and LocalPlayer.Team.Name or nil
		print("Detected team:", teamName)
	
		local data = findTeamData(teamName)
		if not data then
			warn("No block data for team:", teamName)
			return
		end
	
		QuestEvent:FireServer(8)
	
		local tool = LocalPlayer.Character:FindFirstChild("BuildingTool") or LocalPlayer.Backpack:FindFirstChild("BuildingTool")
		while not tool do
			LocalPlayer.CharacterAdded:Wait()
			tool = LocalPlayer.Character:FindFirstChild("BuildingTool") or LocalPlayer.Backpack:FindFirstChild("BuildingTool")
		end
	
		local args = {
			"WoodBlock",
			9,
			Workspace:WaitForChild(data.zone),
			data.placeCF,
			true,
			data.targetCF,
			false
		}
		tool:WaitForChild("RF"):InvokeServer(unpack(args))
	
		Workspace:WaitForChild("ClearAllPlayersBoatParts"):FireServer()
	end