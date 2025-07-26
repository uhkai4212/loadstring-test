end
end

game.Players.LocalPlayer:Kick("SCRIPT IS BROKE! WE ARE SORRY. Reload the script :D")

]]










	-- Addons:
	-- SaveManager (Allows you to have a configuration system)
	-- InterfaceManager (Allows you to have a interface managment system)

	-- Hand the library over to our managers
	SaveManager:SetLibrary(Fluent)
	InterfaceManager:SetLibrary(Fluent)

	-- Ignore keys that are used by ThemeManager.
	-- (we dont want configs to save themes, do we?)
	SaveManager:IgnoreThemeSettings()

	-- You can add indexes of elements the save manager should ignore
	SaveManager:SetIgnoreIndexes({})

	-- use case for doing it this way: