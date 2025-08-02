local function UENDBFZ_fake_script() -- VegaXAndroidUI.EverythingElse 
	local script = Instance.new('LocalScript', VegaXAndroidUI)

	--local WriteToMocorFolder = clonefunction(arceus.writearceusfile)
	
	-- Dev Connect
	
	getgenv().DevConnect = function(devcode)
		warn("(Panda-Pelican Development | HTTP Protocol [ Beta ])")
		local No_Execute = "No_Data_Set_Here"
		local IPv4 = base64.decode(devcode)
		if IPv4 == "" or IPv4 == nil then
			warn("[Unable to Start HTTP-Protocol] - Missing IP Address / Port")
			return
		end
		task.spawn(function() 
			script.Parent.ExecutorWindow.DevModeB.BackgroundColor3 = Color3.fromRGB(57, 195, 57)
			while true do
				wait(0.1)
				local content = game:HttpGet("http://"..IPv4..":2023".."/readcontent")     
				if content ~= No_Execute then
					local success, result = pcall(function()
						runcode(content)
						local a = tostring(game:HttpGet("http://"..IPv4..":2023".."/clear"))
					end)
	
					if not success then
						-- Handle the exception here
						warn("Error executing loaded code:", result)
						local b = tostring(game:HttpGet("http://"..IPv4..":2023".."/clear"))
					end        
				end
			end
		end) 
	end
	
	-- Dragging Menu
	
	local UserInputService = game:GetService("UserInputService")
	
	local gui = script.Parent.VegaXMenuToggleFrame
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	gui.DragTouch.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
	
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
	
	
	local TweenService = game:GetService("TweenService")
	local ExecutorWindowOpen = false
	local ScriptHubWindowOpen = false
	local SettingsWindowOpen = false
	
	_G.MenuOpen = true
	
	script.Parent.VegaXMenuToggleFrame.VegaXMenuToggle.MouseButton1Click:connect(function()	
		if _G.MenuOpen == false then
			_G.MenuOpen = true
			script.Parent.SidebarFrame:TweenPosition(UDim2.new(0,0,0.5,0), "Out", "Quint", 1, true)
			
			if ExecutorWindowOpen == true then
				script.Parent.ExecutorWindow:TweenPosition(UDim2.new(0,200,0.5,-20), "Out", "Quint", 1, true)
			end
			if ScriptHubWindowOpen == true then
				script.Parent.ScriptHubWindow:TweenPosition(UDim2.new(0,200,0.5,-20), "Out", "Quint", 1, true)
			end
			if SettingsWindowOpen == true then
				script.Parent.SettingsWindow:TweenPosition(UDim2.new(0,200,0.5,-20), "Out", "Quint", 1, true)
			end
		else
			_G.MenuOpen = false
			script.Parent.SidebarFrame:TweenPosition(UDim2.new(0,-200,0.5,0), "Out", "Quint", 1, true)
			
			script.Parent.ExecutorWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
			script.Parent.ScriptHubWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
			script.Parent.SettingsWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
		end
	end)
	
	-- Menu Switching
	
	script.Parent.SidebarFrame.ScrollingFrame.Choice1.C1EB.MouseButton1Click:connect(function()
		if ExecutorWindowOpen == false then
			ExecutorWindowOpen = true
			script.Parent.ExecutorWindow:TweenPosition(UDim2.new(0,200,0.5,-20), "Out", "Quint", 1, true)
			
			ScriptHubWindowOpen = false
			script.Parent.ScriptHubWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
			SettingsWindowOpen = false
			script.Parent.SettingsWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
			
		else
			ExecutorWindowOpen = false
			script.Parent.ExecutorWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
		end
	end)
	
	script.Parent.SidebarFrame.ScrollingFrame.Choice2.C2EB.MouseButton1Click:connect(function()
		if ScriptHubWindowOpen == false then
			ScriptHubWindowOpen = true
			script.Parent.ScriptHubWindow:TweenPosition(UDim2.new(0,200,0.5,-20), "Out", "Quint", 1, true)
			
			ExecutorWindowOpen = false
			script.Parent.ExecutorWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
			SettingsWindowOpen = false
			script.Parent.SettingsWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
		else
			ScriptHubWindowOpen = false
			script.Parent.ScriptHubWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
		end
	end)
	
	script.Parent.SidebarFrame.ScrollingFrame.Choice3.C3EB.MouseButton1Click:connect(function()
		if SettingsWindowOpen == false then
			SettingsWindowOpen = true
			script.Parent.SettingsWindow:TweenPosition(UDim2.new(0,200,0.5,-20), "Out", "Quint", 1, true)
			
			ExecutorWindowOpen = false
			script.Parent.ExecutorWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
			ScriptHubWindowOpen = false
			script.Parent.ScriptHubWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
		else
			SettingsWindowOpen = false
			script.Parent.SettingsWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
		end
	end)
	
	-- Executor Window
	
	script.Parent.ExecutorWindow.CloseB.MouseButton1Click:connect(function()
		ExecutorWindowOpen = false
		script.Parent.ExecutorWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
	end)
	
	script.Parent.ExecutorWindow.ExecuteB.MouseButton1Click:connect(function()