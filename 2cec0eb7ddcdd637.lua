local player = game.Players.LocalPlayer
	local button = script.Parent -- The button this LocalScript is inside
	
	-- Function to start quest
	local function startQuest()
		local args = { 9 }
		workspace:WaitForChild("QuestMakerEvent"):FireServer(unpack(args))
	end
	
	-- List of positions
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
		Vector3.new(-57, -312, 9497) -- last position
	}
	
	-- Function to teleport
	local function teleportTo(pos)
		local character = player.Character or player.CharacterAdded:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")
		hrp.CFrame = CFrame.new(pos)
	end
	
	-- Button click event
	button.MouseButton1Click:Connect(function()
		startQuest() -- Start the quest first
		task.wait(0.5) -- Small delay before teleporting
		for i, pos in ipairs(positions) do
			teleportTo(pos)
			if i < #positions then
				task.wait(0.2)
				teleportTo(Vector3.new(pos.X, pos.Y + 10, pos.Z))
			end
			task.wait(0.3)
		end
	end)
	
end
coroutine.wrap(ETTVN_fake_script)()
local function PHFXBE_fake_script() -- Soccer.LocalScript 
	local script = Instance.new('LocalScript', Soccer)