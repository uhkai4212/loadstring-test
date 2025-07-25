-- and game configs in a separate folder per game
InterfaceManager:SetFolder("CROW")
SaveManager:SetFolder("CROW/games")

Window:SelectTab(1)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Fluent:Notify({
    Title = "Interface",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
implementPersistentScript()
end