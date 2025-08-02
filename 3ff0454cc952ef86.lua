local function C_19b()
local script = DELTA["19b"];
local elements = script.Parent.Parent.ConsoleElements
local lib = require(script.Parent.Parent.Parent.UILibrary)

local function rprint(text: string)
local msg = elements.Output:Clone()
msg.Parent = script.Parent.Console.ScrollingFrame.Header
msg.Visible = true
msg.Content.Text = text
end
local function rerror(text: string)
local msg = elements.Error:Clone()
msg.Parent = script.Parent.Console.ScrollingFrame.Header
msg.Visible = true
msg.Content.Text = text
end
local function rwarn(text: string)
local msg = elements.Warn:Clone()
msg.Parent = script.Parent.Console.ScrollingFrame.Header
msg.Visible = true
msg.Content.Text = text
end
local function rinfo(text: string)
local msg = elements.Info:Clone()
msg.Parent = script.Parent.Console.ScrollingFrame.Header
msg.Visible = true
msg.Content.Text = text
end
local function rinput()
local msg = elements.Input:Clone()
msg.Parent = script.Parent.Console.ScrollingFrame.Header
msg.Visible = true
msg.Content:CaptureFocus()
lib.Console:GoToConsole()
msg.Content.FocusLost:Wait()
msg.Content.TextEditable = false
return msg.Content.Text
end
--[[
	local msg = elements.Info:Clone()
	msg.Parent = script.Parent.Console.ScrollingFrame.Header
	msg.Visible = true
	msg.Content.Text = output
	]]



-- Expose the function as global env
getgenv().rconsoleprint = rprint
getgenv().rconsoleerror = rerror
getgenv().rconsolewarn = rwarn
getgenv().rconsoleinfo = rinfo

getgenv().consoleprint = rprint
getgenv().consoleerror = rerror
getgenv().consolewarn = rwarn
getgenv().consoleinfo = rinfo

getgenv().rconsoleinput = rinput
getgenv().consoleinput = rinput

getgenv().rconsoleclear = function()
for i,v in pairs(script.Parent.Console.ScrollingFrame.Header:GetChildren()) do
if v:IsA("Frame") then
v:Destroy()
end

end
end
getgenv().consoleclear = function()
for i,v in pairs(script.Parent.Console.ScrollingFrame.Header:GetChildren()) do
if v:IsA("Frame") then
v:Destroy()
end

end
end
end;
task.spawn(C_19b);