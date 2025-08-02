scripts[scriptamt] = script.Parent.ExecutorWindow.ScrollingBox.TextBox.Text
		scriptamt = scriptamt + 1
	
		if scriptamt ~= listamt then
			table.insert(scripts, "")
			table.insert(scriptsname, "Script "..scriptamt)
			listamt = listamt + 1
		end
	
		script.Parent.ExecutorWindow.ScrollingBox.TextBox.Text = scripts[scriptamt]
		script.Parent.ExecutorWindow.TabbingSystem.ScriptPage.Text = scriptsname[scriptamt]
	end)
	
	script.Parent.ExecutorWindow.TabbingSystem.EditTabName.MouseButton1Click:connect(function()
		script.Parent.ExecutorWindow.TabbingSystem.ScriptPage.Visible = false
		script.Parent.ExecutorWindow.TabbingSystem.EditTabBox.Visible = true
	end)
	
	script.Parent.ExecutorWindow.TabbingSystem.EditTabBox.FocusLost:connect(function()
		scriptsname[scriptamt] = script.Parent.ExecutorWindow.TabbingSystem.EditTabBox.Text
		script.Parent.ExecutorWindow.TabbingSystem.ScriptPage.Text = scriptsname[scriptamt]
	
		script.Parent.ExecutorWindow.TabbingSystem.ScriptPage.Visible = true
		script.Parent.ExecutorWindow.TabbingSystem.EditTabBox.Visible = false
	
		script.Parent.ExecutorWindow.TabbingSystem.EditTabBox.Text = ""
	end)
	
	
	script.Parent.ExecutorWindow.ClearB.MouseButton1Click:connect(function()
		script.Parent.ExecutorWindow.ScrollingBox.TextBox.Text = ""
	end)