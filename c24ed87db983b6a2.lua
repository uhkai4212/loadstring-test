-- and game configs in a separate folder per game
	InterfaceManager:SetFolder("Nekohub/Islands")
	SaveManager:SetFolder("Nekohub/Islands")

	InterfaceManager:BuildInterfaceSection(Tabs.Settings)
	SaveManager:BuildConfigSection(Tabs.Settings)


	Window:SelectTab(1)

	Fluent:Notify({
		Title = "Fluent",
		Content = "The script has been loaded.",
		Duration = 8
	})

	-- You can use the SaveManager:LoadAutoloadConfig() to load a config
	-- which has been marked to be one that auto loads!
	SaveManager:LoadAutoloadConfig()

	print("Script Loaded!")





	-- end