executecode(script.Parent.ExecutorWindow.ScrollingBox.TextBox.Text)
	end)
	
	script.Parent.ExecutorWindow.PasteandExecuteB.MouseButton1Click:connect(function()
		executeclipboard()
	end)
	
	script.Parent.ExecutorWindow.DevModeB.MouseButton1Click:connect(function()
		if isfile("injectcode.txt") == false then
			script.Parent.ExecutorWindow.ScrollingBox.TextBox.Text = "The inject code for Dev Mode is not found, please open the Vega X Windows Client, get your inject code, and paste it in settings."
		else
			DevConnect(readfile("injectcode.txt"))
		end
		
	end)
	
	-- Executor Window Tabbing System
	
	local scriptamt = 1
	local listamt = 1
	local scripts = {""}
	local scriptsname = {"Script 1"}
	
	script.Parent.ExecutorWindow.TabbingSystem.LastPage.MouseButton1Click:connect(function()
		if scriptamt > 1 then
			scripts[scriptamt] = script.Parent.ExecutorWindow.ScrollingBox.TextBox.Text
			scriptamt = scriptamt - 1
			script.Parent.ExecutorWindow.ScrollingBox.TextBox.Text = scripts[scriptamt]
			script.Parent.ExecutorWindow.TabbingSystem.ScriptPage.Text = scriptsname[scriptamt]
		end
	end)
	
	script.Parent.ExecutorWindow.TabbingSystem.NextPage.MouseButton1Click:connect(function()