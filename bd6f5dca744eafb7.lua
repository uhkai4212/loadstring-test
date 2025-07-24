while true do
task.wait()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end
      
   end,
})


local Button = MainTab:CreateButton({
   Name = "max",
   Callback = function()
      --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local speed = 450 -- speed that you wanted