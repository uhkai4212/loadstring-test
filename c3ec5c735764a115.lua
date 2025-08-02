Create_Script_Rectangle(scriptData.title, gameData.name, gameData.gameId, scriptData.script);
		end
	end
	
	]]
	
	function Handle_Results(results)
		if results then
			Clear()
	
			for _, scriptData in pairs(results) do
				local gameData = scriptData.game
				Create_Script_Rectangle(scriptData.title, gameData.name, gameData.gameId, scriptData.script)
			end
		else
			error("Invalid JSON structure. Unable to process results.")
		end
	end
	
	
	function Search(query) -- Searches using a query and parses the result into a script list
		page = 1
		script.Parent.PaginationFrame.PageLabel.Text = page
		if query == "" then
			searchstring = "a"
		else
			searchstring = httpService:UrlEncode(query)
		end
		
		local searchResults = scriptBlox:getScripts(searchstring, 1, 20);
		Handle_Results(searchResults);
	end
	
	-- Front page
	
	local frontPage = scriptBlox:getScripts("a", 1, 20);
	
	Handle_Results(frontPage);
	
	script.Parent.SearchBox.FocusLost:connect(function()
		script.Parent.PaginationFrame.PageLabel.Text = page
		Search(script.Parent.SearchBox.Text)
	end)
	
	script.Parent.PaginationFrame.LeftPage.MouseButton1Click:connect(function()	
		if page ~= 1 then
			page -= 1
			Handle_Results(scriptBlox:getScripts(searchstring, page, 20));
		end
		script.Parent.PaginationFrame.PageLabel.Text = page
	end)
	
	script.Parent.PaginationFrame.RightPage.MouseButton1Click:connect(function()
		page += 1	
		Handle_Results(scriptBlox:getScripts(searchstring, page, 20));
		script.Parent.PaginationFrame.PageLabel.Text = page
	end)
end
coroutine.wrap(KEARIL_fake_script)()
local function WVKWVWW_fake_script() -- ScrollingBox.TextBoxCode 
	local script = Instance.new('LocalScript', ScrollingBox)

	local TextBox = script.Parent.TextBox
	local LineWatcher = script.Parent.Line
	local FontSize = TextBox.TextSize
	local TopCount
	-----
	local function resize(iter, subtract, maxsize)
	    for i = 1,iter do
			maxsize.CanvasSize = UDim2.new(0,maxsize.CanvasSize.X.Offset,0,(iter * FontSize))
			maxsize.CanvasPosition = Vector2.new(maxsize.CanvasPosition.X, (iter * FontSize))
	    end
	end
	-----
	TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		local str = TextBox.Text
	    local offset = 32
		local textsize = TextBox.TextBounds.X + offset
		script.Parent.CanvasSize = UDim2.new(0,textsize,0,script.Parent.CanvasSize.Y.Offset)
		script.Parent.CanvasPosition = Vector2.new(textsize, script.Parent.CanvasPosition.Y)
	    local _,count = str:gsub('\n','\n')
	    local NewCount = count + 1
		if not LineWatcher.Text:find(NewCount) then
			TopCount = NewCount
			for i = 1,TopCount do
				local PreviousText = LineWatcher.Text
				if not LineWatcher.Text:find(i) then
					LineWatcher.Text = tostring(PreviousText..i..'\n')
	            end
	        end
			resize(TopCount,false,script.Parent)
		else if TopCount ~= NewCount and TopCount ~= nil then
				LineWatcher.Text = ""
				TopCount = NewCount
				for i = 1,TopCount do
					LineWatcher.Text = tostring(LineWatcher.Text..i..'\n')
	            end
				resize(TopCount,true,script.Parent)
	        end
	    end
	end)
end
coroutine.wrap(WVKWVWW_fake_script)()
local function VJJF_fake_script() -- VegaXAndroidUI.SettingsSystem 
	local script = Instance.new('LocalScript', VegaXAndroidUI)

	ChosenColor = "#C33939"
	
	function LoadColors()
		script.Parent.SidebarFrame.Banner.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.SidebarFrame.ScrollingFrame.UsernamePlace.Icon.BackgroundColor3 = Color3.fromHex(ChosenColor)
	
		script.Parent.SidebarFrame.ScrollingFrame.Choice1.Icon.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.SidebarFrame.ScrollingFrame.Choice1.C1EB.BackgroundColor3 = Color3.fromHex(ChosenColor)
	
		script.Parent.SidebarFrame.ScrollingFrame.Choice2.Icon.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.SidebarFrame.ScrollingFrame.Choice2.C2EB.BackgroundColor3 = Color3.fromHex(ChosenColor)
	
		script.Parent.SidebarFrame.ScrollingFrame.Choice3.Icon.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.SidebarFrame.ScrollingFrame.Choice3.C3EB.BackgroundColor3 = Color3.fromHex(ChosenColor)
	
		script.Parent.KeySystem.Banner.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.KeySystem.GetKeyB.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.KeySystem.ApproveKeyB.BackgroundColor3 = Color3.fromHex(ChosenColor)
	
		script.Parent.ExecutorWindow.TabbingSystem.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.ExecutorWindow.ExecuteB.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.ExecutorWindow.PasteandExecuteB.BackgroundColor3 = Color3.fromHex(ChosenColor)
		script.Parent.ExecutorWindow.DevModeB.BackgroundColor3 = Color3.fromHex(ChosenColor)
	
		script.Parent.SettingsWindow.ScrollingFrame.S1.AccentColorPreview.BackgroundColor3 = Color3.fromHex(ChosenColor)
	end
	
	-- Set Color
	
	if not isfile("theme_vegax_color.txt") then
		writefile("theme_vegax_color.txt", "#C33939")
	else
		local success, ChosenColor = pcall(readfile, "theme_vegax_color.txt")
	
		if success then
			LoadColors()
		else
			warn("无法读取文件: " .. ChosenColor)
		end
	end
	
	
	--if not isfile("theme_vegax_color.txt") then
		--writefile("theme_vegax_color.txt", "#C33939")
	--else
		--ChosenColor = readfile("theme_vegax_color.txt")