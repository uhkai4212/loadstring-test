--end
	
	
	script.Parent.SettingsWindow.ScrollingFrame.S1.SubmitAccent.MouseButton1Click:Connect(function()
		writefile("theme_vegax_color.txt", script.Parent.SettingsWindow.ScrollingFrame.S1.AccentTextBox.Text)
		ChosenColor = script.Parent.SettingsWindow.ScrollingFrame.S1.AccentTextBox.Text
		LoadColors()
	end)
	
	script.Parent.SettingsWindow.ScrollingFrame.S2.SubmitFPS.MouseButton1Click:Connect(function()
		writefile("settings_fps.txt", script.Parent.SettingsWindow.ScrollingFrame.S2.FPSTextBox.Text)
		setfpscap(tonumber(script.Parent.SettingsWindow.ScrollingFrame.S2.FPSTextBox.Text))
	end)
	
	script.Parent.SettingsWindow.ScrollingFrame.S2.ResetFPS.MouseButton1Click:Connect(function()
		writefile("settings_fps.txt", "60")
		setfpscap(60)
	end)
	
	script.Parent.SettingsWindow.ScrollingFrame.S3.SubmitCode.MouseButton1Click:Connect(function()
		writefile("injectcode.txt", script.Parent.SettingsWindow.ScrollingFrame.S3.InjectCodeTextbox.Text)
		DevConnect(script.Parent.SettingsWindow.ScrollingFrame.S3.InjectCodeTextbox.Text)
	end)
	
	script.Parent.SettingsWindow.ScrollingFrame.S3.ResetCode.MouseButton1Click:Connect(function()
		script.Parent.SettingsWindow.ScrollingFrame.S3.InjectCodeTextbox.Text = ""
		delfile("injectcode.txt")
	end)
	
	script.Parent.SettingsWindow.ScrollingFrame.S4.ToggleBTN.MouseButton1Click:Connect(function()
	
	end)
end
coroutine.wrap(VJJF_fake_script)()
local function KJDH_fake_script() -- VegaXAndroidUI.Loading 
	local script = Instance.new('LocalScript', VegaXAndroidUI)

	ATime = 2
	zidongjiaobenyunxinglujingzifuchuan = "自动脚本运行"
	
	-- Key System Pre-Requisities
	
	local PandaAuth = loadstring(game:HttpGet('https://pandadevelopment.net/servicelib?service=vegax&core=roblox&param=v2'))()
	
	function Generate_Key()
		return PandaAuth:GetKey("vegax");
	end
	
	function ValidateKey(Key)
		return PandaAuth:ValidateKey("vegax", tostring(Key))
	end
	
	function CheckIfAutoexecExists()
		
		if (arceus.isarceusfolder(zidongjiaobenyunxinglujingzifuchuan) == false) then
			arceus.makearceusfolder("自动脚本运行")
		end
		
	end
	
	function LoadAutoexec()
		if (arceus.isarceusfolder(zidongjiaobenyunxinglujingzifuchuan) == false) then
			for _, scriptfile in pairs(arceus.listarceusfiles(zidongjiaobenyunxinglujingzifuchuan)) do
				executecode(arceus.readarceusfile(scriptfile))
			end
		end
	end
	
	-- Multi-Language Key System Variables
	local KSSubTitleNotif1 = "The Key System Link has been pasted into your Clipboard, insert it into your Browser (Desktop Recommended)."
	local KSSubTitleNotif2 = "This key is not valid, go to our Discord Server if this is not correct."
	local KSSubTitleNotif3 = "The Discord Link has been pasted into your Clipboard, insert it into the Discord app."
	local KSSubTitleNotif4 = "This key is valid, enjoy Vega X!"
	
	-- Loading
	
	--CheckIfAutoexecExists()
	
	if not isfile("vegax_key.txt") then
		writefile("vegax_key.txt", "")
	end
	
	script.Parent.VegaXMenuToggleFrame.Visible = true
	
	
	repeat until game:IsLoaded()
	for _,Key in pairs(script.Parent.IntroFrame.BackgroundFrame:GetChildren()) do
		game:GetService("TweenService"):Create(Key, TweenInfo.new(ATime), {BackgroundTransparency = 0}):Play()
		Key:TweenSize(UDim2.new(0.075,0,1,0), "Out", "Quad", ATime, true)
		wait(0.05)
	end
	
	wait(0.25)
	
	game:GetService("TweenService"):Create(script.Parent.IntroFrame.VegaXLogo, TweenInfo.new(1), {ImageTransparency = 0}):Play()
	script.Parent.IntroFrame.VegaXLogo:TweenPosition(UDim2.new(0.5,0,0.5,0), "Out", "Quad", 1, true)
	
	wait(1.5)
	
	game:GetService("TweenService"):Create(script.Parent.IntroFrame.VegaXLogo, TweenInfo.new(1), {ImageTransparency = 1}):Play()
	script.Parent.IntroFrame.VegaXLogo:TweenPosition(UDim2.new(0.5,0,0.3,0), "Out", "Quad", 1, true)
	
	for _,Key in pairs(script.Parent.IntroFrame.BackgroundFrame:GetChildren()) do
		game:GetService("TweenService"):Create(Key, TweenInfo.new(ATime), {BackgroundTransparency = 1}):Play()
		Key:TweenSize(UDim2.new(0.075,0,0,0), "Out", "Quad", ATime, true)
		wait(0.05)
	end
	
	wait(1)
	
	script.Parent.IntroFrame:Destroy()
	
	local success, result = pcall(function()
		return ValidateKey(readfile("vegax_key.txt"))
	end)
	
	if success and result then
		-- LoadAutoexec()
		script.Parent.KeySystem.Visible = false
		script.Parent.VegaXMenuToggleFrame.Visible = true
		_G.MenuOpen = true
		script.Parent.SidebarFrame:TweenPosition(UDim2.new(0, 0, 0.5, 0), "Out", "Quint", 1, true)
		getgenv().arceus = nil
	else
		script.Parent.KeySystem:TweenPosition(UDim2.new(0, 0, 0.5, -20), "Out", "Quad", 1, true)
	end
	
	
	-- Key System Stuff --
	script.Parent.KeySystem.CloseB.MouseButton1Click:connect(function()
		script.Parent.KeySystem:TweenPosition(UDim2.new(0,0,2,-20), "Out", "Quint", 1, true)
		wait(1)
		script.Parent.KSMenuToggleFrame.Visible = true
		script.Parent.KSMenuToggleFrame:TweenSize(UDim2.new(0,32,0,32), "Out", "Quint", 1, true)
	end)
	
	script.Parent.KSMenuToggleFrame.VegaXKSToggle.MouseButton1Click:connect(function()
		script.Parent.KSMenuToggleFrame:TweenSize(UDim2.new(0,0,0,0), "Out", "Quint", 1, true)
		wait(1)
		script.Parent.KSMenuToggleFrame.Visible = false
		script.Parent.KeySystem:TweenPosition(UDim2.new(0,0,0.5,-20), "Out", "Quint", 1, true)
	end)
	
	script.Parent.KeySystem.GetKeyB.MouseButton1Click:connect(function()
		script.Parent.KeySystem.SubTitle.FontFace.Weight = Enum.FontWeight.Bold
		script.Parent.KeySystem.SubTitle.Text = KSSubTitleNotif1
		setclipboard(Generate_Key())
	end)
	
	script.Parent.KeySystem.ApproveKeyB.MouseButton1Click:connect(function()
		script.Parent.KeySystem.SubTitle.FontFace.Weight = Enum.FontWeight.Regular
		if ValidateKey(script.Parent.KeySystem.TextBox.Text) then
			writefile("vegax_key.txt", script.Parent.KeySystem.TextBox.Text)
			-- LoadAutoexec()
			script.Parent.KeySystem.SubTitle.Text = KSSubTitleNotif4
	
			script.Parent.KeySystem:TweenPosition(UDim2.new(0, 0, 2, -20), "Out", "Quad", 1, true)
	
			wait(1)
	
			script.Parent.KeySystem.Visible = false;
			script.Parent.VegaXMenuToggleFrame.Visible = true;
	
			_G.MenuOpen = true;
	
			script.Parent.SidebarFrame:TweenPosition(UDim2.new(0,0,0.5,0), "Out", "Quint", 1, true)
			getgenv().arceus = nil
		else
			script.Parent.KeySystem.SubTitle.Text = KSSubTitleNotif2
		end
	end)
	
	script.Parent.KeySystem.JoinDiscordB.MouseButton1Click:connect(function()
		script.Parent.KeySystem.SubTitle.FontFace.Weight = Enum.FontWeight.Regular
		script.Parent.KeySystem.SubTitle.Text = KSSubTitleNotif3
		setclipboard("https://vegax.gg/discord.html")
	end)

	
end
coroutine.wrap(KJDH_fake_script)()