--LoadColors()
	--end
	
	
	-- Set FPS
	local success, result = pcall(function()
		if isfile("settings_fps.txt") == true then
			setfpscap(tonumber(readfile("settings_fps.txt")))
		end
	end)
	
	if not success then
		-- Handle the error, you can print a message or take other appropriate actions
		print("无法读取文件:", result)
	end
	
	
	--if isfile("settings_fps.txt") == true then
		--setfpscap(tonumber(readfile("settings_fps.txt")))
	--end
	
	-- Set Inject Code
	local success, result = pcall(function()
		if isfile("injectcode.txt") then
			script.Parent.SettingsWindow.ScrollingFrame.S3.InjectCodeTextbox.Text = readfile("injectcode.txt")
		end
	end)
	
	if not success then
		print("无法读取文件:", result)
	end
	
	--if isfile("injectcode.txt") == true then