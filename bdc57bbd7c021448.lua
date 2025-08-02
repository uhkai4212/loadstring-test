end
	
	--[[
	function Handle_Results(results) 
		if results.error then
			print("Error: "..results.error);
			--table.foreach(results.error, print)
			return
		end
	
		Clear();
	
		for _, scriptData in pairs(results) do
			local gameData = scriptData.game;