local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "Screech" and method == "FireServer" and Screech == true then
        args[1] = true
        return old(self,unpack(args))
    end
    if tostring(self) == "ClutchHeartbeat" and method == "FireServer" and ClutchHeart == true then
        args[2] = true
        return old(self,unpack(args))
    end
    if self.Name == "Crouch" and method == "FireServer" and AutoUseCrouch == true then
        args[1] = true
        return old(self,unpack(args))
    end
    return old(self,...)
end))

workspace.DescendantAdded:Connect(function(v)
if v:IsA("Model") and v.Name == "Screech" then
v:Destroy()
end
end)