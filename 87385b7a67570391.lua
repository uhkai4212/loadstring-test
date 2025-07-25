game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RLGLPassed"):FireServer()
end

-- this one turns off the red light green light detection
local detecthook;
detecthook = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if tostring(self) == "PlayerTargetForElimination" and method == "FireServer" then
    return nil
end
return detecthook(self, unpack(args))

end)

-- this one just gives a badge

local args = {
	4072071116660681
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("GetBadge"):FireServer(unpack(args))