end
	
		for _, sourceGameInfo in pairs(scriptsData["games"]) do
			local scriptsMerged = false
			for _, sourcePlaceId in ipairs(sourceGameInfo["placeIds"]) do
				if checkPlaceId(sourcePlaceId, targetData) then
					Add_Merge(sourcePlaceId, sourceGameInfo["_scripts"], targetData)
					scriptsMerged = true
					break 
				end
			end
			if not scriptsMerged then
				-- no matching placeIds
			end
		end
	end
	
	
	mergeScripts(jsonScriptData, reaperscriptsData)
	
	updatedJsonString = HttpService:JSONEncode(jsonScriptData)
	NewjsonScriptData = HttpService:JSONDecode(updatedJsonString)

	
	local scriptList = NewjsonScriptData
	local scriptsFrame = MainFrame.homeFrame.scriptsFrame
	local scriptButton = scriptsFrame.TextButton
	local currentPlaceId = tostring(game.PlaceId)
	
	scriptsFrame["#GameHeader"].Title.Text = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
	
	local function createscriptButtons(_scripts)
		local yPos = 0
		for i, scriptData in ipairs(_scripts) do
			local newButton = scriptButton:Clone()
			newButton.Parent = scriptsFrame
			newButton.Text = scriptData.scriptName
			newButton.Position = UDim2.new(newButton.Position.X.Scale, newButton.Position.X.Offset, newButton.Position.Y.Scale, yPos)
			yPos = yPos + newButton.Size.Y.Offset + 5
			newButton.Visible = true
	
			newButton.MouseButton1Click:Connect(function()
				executecode(scriptData.text)
			end)
		end
	end
	
	local function findScriptsForCurrentPlace()
		for _, gameData in pairs(scriptList.games) do
			if table.find(gameData.placeIds, currentPlaceId) then
				return gameData._scripts
			end
		end
		return nil 
	end
	
	local scriptToUse = findScriptsForCurrentPlace() or scriptList.global._scripts
	
	if scriptToUse then
		createscriptButtons(scriptToUse)
	else
		print("No _scripts available.")
	end
	
	scriptButton.Visible = false
	

	----//////////////////----
	----/// Console Log Page
	----//////////////////----

	logButtons = logFrame.logButtons
	consoleFrame = logFrame.consoleFrame

	outputCBX = logButtons.logOutput.Button
	warningCBX = logButtons.logWarning.Button
	errorCBX = logButtons.logError.Button
	infoCBX = logButtons.logInfo.Button
	consoleclrbtn = logButtons.cclrbtn
	consoleexebtn = logButtons.excp 

	function cboxCheck(button)
		button.Image = "rbxassetid://3926311105" -- check   
		button.ImageRectSize = Vector2.new(48, 48) 
		button.ImageRectOffset = Vector2.new(4, 836) 
	end

	function cboxUnCheck(button)
		button.Image = "rbxassetid://3926305904" --uncheck
		button.ImageRectSize = Vector2.new(36, 36) 
		button.ImageRectOffset = Vector2.new(724, 724) 
	end

	local function cobxUpdate(value, button)
		if Settings[value] then
			cboxCheck(button)
		else
			cboxUnCheck(button)
		end
	end

	consoleexebtn.Activated:Connect(function()
		executecode(getclipboard())
	end)

	outputCBX.Activated:Connect(function()
		Settings.logPrint = not Settings.logPrint
		cobxUpdate("logPrint",outputCBX)
		saveSettings()
	end)

	warningCBX.Activated:Connect(function()
		Settings.logWarn = not Settings.logWarn
		cobxUpdate("logWarn",warningCBX)
		saveSettings()
	end)

	errorCBX.Activated:Connect(function()
		Settings.logError = not Settings.logError
		cobxUpdate("logError",errorCBX)
		saveSettings()
	end)

	infoCBX.Activated:Connect(function()
		Settings.logInfo = not Settings.logInfo
		cobxUpdate("logInfo",infoCBX)
		saveSettings()
	end)

	consoleclrbtn.Activated:Connect(function()
		consoleFrame.TextBox.Text = ""
	end)


	----//////////////////----
	----/// Settings Page
	----//////////////////----

	---General Tab
	if Settings.autohideui then script.Parent.Enabled = false end

	GeneralTab = settingsFrame.GeneralTab

	autoexecSS = GeneralTab.autoexecSS.button
	autohideuiSS = GeneralTab.autohideuiSS.button
	trigonSS = GeneralTab.trigonSS

	Sidebar = settingsFrame.Sidebar.Buttons

	generalBtn = Sidebar.generalBtn
	themesBtn = Sidebar.themesBtn


	autoexecSS.Activated:Connect(function()
		Settings.autoexec = not Settings.autoexec
		cobxUpdate("autoexec",autoexecSS)
		saveSettings()
	end)


	autohideuiSS.Activated:Connect(function()
		Settings.autohideui = not Settings.autohideui
		cobxUpdate("autohideui",autohideuiSS)
		saveSettings()
	end)


	local checkboxList = {
		autohideui = autohideuiSS,
		autoexec = autoexecSS,
		
		logPrint = outputCBX,
		logWarn = warningCBX,
		logError = errorCBX,
		logInfo = infoCBX
	}

	local function initializeCheckBoxes()
		for value, button in pairs(checkboxList) do
			if Settings[value] then
				cboxCheck(button) 
			else
				cboxUnCheck(button) 
			end
		end
	end

	initializeCheckBoxes()


end)

task.spawn(function()
	local script = trigok.savescripts

	HttpService = game:GetService("HttpService")
	folderName = 'Local_Scripts'
	fileName = 'list.json'
	filePath = folderName .. '/' .. fileName
	
	lsf = gethui()[_G.TrigonMain].MainFrame.homeFrame.localscriptsFrame
	alsf = gethui()[_G.TrigonMain].MainFrame.homeFrame.addlocalscriptsFrame
	
	add_btn = lsf["#GameHeader"].Add_btn.TextButton
	script_placeholder = lsf.script_placeholder
	script_placeholder.Visible = false
	title = script_placeholder.scriptTitle
	buttons = script_placeholder.Buttons
	run = buttons.run.button
	autoload = buttons.autoload.button
	delete = buttons.delete.button
	
	scriptNameinput = alsf.addFrame.input.TextBox
	confirm_btn = alsf.addFrame.confrim_btn.TextButton
	cancel_btn = alsf.addFrame.cancel_btn.TextButton
	
	
	local default_scripts = {
		localscripts = {
			REJOIN = {
				name = "Rejoin",
				script = "warn('Rejoinning....'); game:GetService('TeleportService'):Teleport(game.PlaceId, game.Players.LocalPlayer)",
				auto_load = false
			},
			BYPASS_DEX = {
				name = "Bypassed Dark Dex v3",
				script = "repeat  task.wait() until game:IsLoaded() loadstring(game:HttpGet('https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua', true))()",
				auto_load = false
			},
			DARKDEXF = {
				name = "Dark Dex v4",
				script = "repeat  task.wait() until game:IsLoaded() getgenv().Key = \"Bash\" loadstring(game:HttpGet(\"https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3AIY%20Dex\",true))()",
				auto_load = false
			},
			INFY = {
				name = "Infinite Yield",
				script = "repeat  task.wait() until game:IsLoaded() loadstring(game:HttpGet(\"https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source\",true))()",
				auto_load = false
			}
		}
	}
	



	local _scripts = {}
	
	local function merge_scripts(defaults, loaded_scripts)
		for key, value in pairs(defaults) do
			if type(value) == "table" then
				loaded_scripts[key] = loaded_scripts[key] or {}
				merge_scripts(value, loaded_scripts[key])
			else
				loaded_scripts[key] = loaded_scripts[key] or value
			end
		end
	end
	
	local function read_scripts()
		if not isfolder(folderName) then
			makefolder(folderName)
		end
	
		if isfile(filePath) then
			local fileContents = readfile(filePath)
			local success, decoded = pcall(function()
				return HttpService:JSONDecode(fileContents)
			end)
			if success then
				merge_scripts(default_scripts, decoded)
				return decoded
			end
		end
	
		return default_scripts
	end
	
	
	local function save_scripts()
		local encoded = HttpService:JSONEncode(_scripts)
		writefile(filePath, encoded)
		print("_scripts saved.")
	end
	
	
	local function deleteScript(scriptName)
		if _scripts.localscripts[scriptName] then
			_scripts.localscripts[scriptName] = nil
			warn("Deleted: " .. scriptName)
			save_scripts()
		else
			warn("Script not found: " .. scriptName)
		end
	end
	

	_scripts = read_scripts()
	
	local function execute_(scriptName)
		if isfile(filePath) then
			local fileContents = readfile(filePath)
			local success, decoded = pcall(function()
				return HttpService:JSONDecode(fileContents)
			end)
	
			if success and decoded.localscripts then
				local scriptData = decoded.localscripts[scriptName]
				if scriptData then
					executecode(scriptData.script)
				else
					warn("Script not found:", scriptName)
				end
			else
				warn("Failed to decode _scripts or 'localscripts' not found.")
			end
		else
			print(filePath)
			warn("_scripts file does not exist.")
		end
	end
	
	local function updateAutoLoad(scriptName, autoLoadValue, btn)
		if _scripts.localscripts and _scripts.localscripts[scriptName] then
			_scripts.localscripts[scriptName].auto_load = autoLoadValue
			save_scripts()  -- Save after updating the autoload value
			print("Updated auto_load for", _scripts.localscripts[scriptName].name, "to", autoLoadValue)
			
			if not autoLoadValue then
				btn.Image = "rbxassetid://3926305904"
				btn.ImageRectSize = Vector2.new(36, 36) 
				btn.ImageRectOffset = Vector2.new(724, 724) 
			else
				btn.Image = "rbxassetid://3926311105"        
				btn.ImageRectSize = Vector2.new(48, 48) 
				btn.ImageRectOffset = Vector2.new(4, 836) 
			end
		else
			warn("Failed to update auto_load. Script not found or error in _scripts.")
		end
	end
	
	local function convertScriptName(name)
		local convertedName = name:gsub("%s+", "_") 
		convertedName = convertedName:gsub("%W", "") 
		return convertedName
	end
	
	
	local function setupScriptUI(scriptName, scriptData)
		local scriptUI = script_placeholder:Clone()
		scriptUI.Visible = true
		scriptUI.scriptTitle.Text = scriptData.name
	
		scriptUI.Buttons.run.button.Activated:Connect(function()
			execute_(scriptName)
		end)
	
		scriptUI.Buttons.autoload.button.Activated:Connect(function()
			local newAutoLoadValue = not scriptData.auto_load
			updateAutoLoad(scriptName, newAutoLoadValue, scriptUI.Buttons.autoload.button)
			scriptData.auto_load = newAutoLoadValue
		end)
	
		scriptUI.Buttons.delete.button.Activated:Connect(function()
			deleteScript(scriptName)
			scriptUI:Destroy()
		end)
	
		scriptUI.Parent = lsf
	
		if scriptData.auto_load then
			scriptUI.Buttons.autoload.button.Image = "rbxassetid://3926311105"        
			scriptUI.Buttons.autoload.button.ImageRectSize = Vector2.new(48, 48) 
			scriptUI.Buttons.autoload.button.ImageRectOffset = Vector2.new(4, 836) 
			execute_(scriptName)        
		end 
	end

	
	local function setupAllScriptsUI()
		for scriptName, scriptData in pairs(_scripts.localscripts) do
			setupScriptUI(scriptName, scriptData)
		end
	end
	
	local function add_update(scriptName, name, scriptContent, autoLoad)
		print("adding")
		local isNewScript = not _scripts.localscripts[tostring(scriptName)]
		_scripts.localscripts[tostring(scriptName)] = {
			name = tostring(name),
			script = tostring(scriptContent),
			auto_load = autoLoad
		}
		save_scripts()
	
		if isNewScript then
			setupScriptUI(tostring(scriptName), _scripts.localscripts[tostring(scriptName)])
		end
	end
	
	confirm_btn.Activated:Connect(function()
	
		local scriptName = scriptNameinput.Text
		local convertedName = convertScriptName(scriptName)
		local xscript = getclipboard()
		
		warn(scriptName, convertedName, xscript)
		task.wait()
		if convertedName ~= "" then
			print("correct")        
			lsf.Visible = true
			add_update(convertedName, scriptName, xscript, false)
			scriptNameinput.Text = ""
		else
			scriptNameinput.Parent.Parent.Title.Text =  "Script Name: Invalid script name"
			wait(2)
			scriptNameinput.Parent.Parent.Title.Text =  "Script Name:"
			warn("Invalid script name")
		end
	
	
	end)
	
	add_btn.Activated:Connect(function()
		lsf.Visible = false
	end)
	cancel_btn.Activated:Connect(function()
		lsf.Visible = true
	end)
	
	setupAllScriptsUI()
	
end)

end

----------------------------------------
----------------------------------------
----------------------------------------

wait()

main()

loader()

print("-----] Trigon Loaded [-----")