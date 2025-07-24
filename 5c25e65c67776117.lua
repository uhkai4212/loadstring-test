while true do
task.wait()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end
      
   end,
})

local Button = MainTab:CreateButton({
   Name = "Medium speed",
   Callback = function()
            --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local speed = 175 -- speed that you wanted