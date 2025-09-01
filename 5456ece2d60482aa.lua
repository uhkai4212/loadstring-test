local EntityModules = game:GetService("ReplicatedStorage").ModulesClient.EntityModules
local gameData = game.ReplicatedStorage:WaitForChild("GameData")
local floor = gameData:WaitForChild("Floor")
local isMines = floor.Value == "Mines"
local isHotel = floor.Value == "Hotel"
local isBackdoor = floor.Value == "Backdoor"
local isGarden = floor.Value == "Garden"

function Distance(pos)
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude
	end
end

_G.GetOldBright = {
	Brightness = game.Lighting.Brightness,
	ClockTime = game.Lighting.ClockTime,
	FogEnd = game.Lighting.FogEnd,
	GlobalShadows = game.Lighting.GlobalShadows,
	OutdoorAmbient = game.Lighting.OutdoorAmbient
}