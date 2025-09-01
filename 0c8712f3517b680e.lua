local button = script.Parent
	button.MouseButton1Click:Connect(function()
		isRunning = not isRunning
		if isRunning then
			button.Text = "Stop"
			task.spawn(runLoop)
		else
			button.Text = "Start"
			removePlatforms()
		end
	end)
	
end
coroutine.wrap(HWYAXBM_fake_script)()
local function FOHUNTA_fake_script() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript', TextButton)