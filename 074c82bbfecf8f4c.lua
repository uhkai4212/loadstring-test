local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
	local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" then
	    if tostring(self) == "Screech" and Screech == true then
	        args[1] = true
	        return old(self,unpack(args))
	    end
	    if tostring(self) == "ClutchHeartbeat" and ClutchHeart == true then
	        args[2] = true
	        return old(self,unpack(args))
	    end
	    if tostring(self) == "Crouch" and AutoUseCrouch == true then
	        args[1] = true
	        return old(self,unpack(args))
	    end
    end
    return old(self,...)
end))
end

function Distance(pos)
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude
	end
end

function Deciphercode(v)
local Hints = game.Players.LocalPlayer.PlayerGui:WaitForChild("PermUI"):WaitForChild("Hints")
local code = {[1] = "_",[2] = "_", [3] = "_", [4] = "_", [5] = "_"}
    for i, v in pairs(v:WaitForChild("UI"):GetChildren()) do
        if v:IsA("ImageLabel") and v.Name ~= "Image" then
            for b, n in pairs(Hints:GetChildren()) do
                if n:IsA("ImageLabel") and n.Visible and v.ImageRectOffset == n.ImageRectOffset then
                    code[tonumber(v.Name)] = n:FindFirstChild("TextLabel").Text 
                end
            end
        end
    end 
    return code
end

if game.CoreGui:FindFirstChild("Gui Track") == nil then
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Gui Track"
gui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.2, 0, 0.1, 0)
Frame.Position = UDim2.new(0.02, 0, 0.87, 0)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderColor3 = Color3.new(0, 0, 0)
Frame.BorderSizePixel = 1
Frame.Active = true
Frame.BackgroundTransparency = 0 
Frame.Parent = gui

local UICorner = Instance.new("UIStroke")
UICorner.Color = Color3.new(0, 0, 0)
UICorner.Thickness = 2.5
UICorner.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Frame1 = Instance.new("Frame")
Frame1.Size = UDim2.new(1, 0, 1, 0)
Frame1.Position = UDim2.new(0, 0, 0, 0)
Frame1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame1.BorderColor3 = Color3.new(0, 0, 0)
Frame1.BorderSizePixel = 1
Frame1.Active = true
Frame1.BackgroundTransparency = 0.3
Frame1.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame1

local Frame2 = Instance.new("Frame")
Frame2.Name = "Frame1"
Frame2.Size = UDim2.new(1, 0, 1, 0)
Frame2.Position = UDim2.new(0, 0, 0, 0)
Frame2.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Frame2.BorderColor3 = Color3.new(0, 0, 0)
Frame2.BorderSizePixel = 1
Frame2.Active = true
Frame2.BackgroundTransparency = 0.15
Frame2.Parent = Frame1

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame2

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.BorderSizePixel = 1
TextLabel.Text = ""
TextLabel.TextSize = 16
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.Font = Enum.Font.Code
TextLabel.TextWrapped = true
TextLabel.Parent = Frame

local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)
UITextSizeConstraint.MaxTextSize = 35
end

function UpdateTrack(enabled, update)
update.Name = update.Name or "Bruh"
update.Size = update.Size or 1
if game.CoreGui:FindFirstChild("Gui Track") then
game.CoreGui["Gui Track"].Enabled = enabled or false
game.CoreGui["Gui Track"].Frame:FindFirstChild("TextLabel").Text = update.Name
local TweenService = game:GetService("TweenService")
local TweenBar = TweenService:Create(game.CoreGui["Gui Track"].Frame.Frame:FindFirstChild("Frame1"), TweenInfo.new(2), {Size = UDim2.new(update.Size, 0, 1, 0)})
TweenBar:Play()
end
end