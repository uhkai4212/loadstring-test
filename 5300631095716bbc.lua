local function C_178()
if not isfile("useconsole") then
    return -- This will exit the script
end

local script = DELTA["178"];
local logserv = game:GetService("LogService")
local elements = script.Parent.Parent.ConsoleElements

local function GetTotalOutputs()
local total = 0
for i,_ in pairs(script.Parent.Console.ScrollingFrame.Header:GetChildren()) do
if _:IsA("Frame") then
total += 1
end
end
return total
end

logserv.MessageOut:Connect(function(output, OutputType)
    if OutputType == Enum.MessageType.MessageOutput then
    local msg = elements.Output:Clone()
    msg.Parent = script.Parent.Console.ScrollingFrame.Header
    msg.Name = tostring(GetTotalOutputs())..msg.Name
    msg.Visible = true
    msg.Content.Text = output

    elseif OutputType == Enum.MessageType.MessageError then
    local msg = elements.Error:Clone()
    msg.Parent = script.Parent.Console.ScrollingFrame.Header
    msg.Name = tostring(GetTotalOutputs())..msg.Name
    msg.Visible = true
    msg.Content.Text = output
    elseif OutputType == Enum.MessageType.MessageWarning then
    local msg = elements.Warn:Clone()
    msg.Parent = script.Parent.Console.ScrollingFrame.Header
    msg.Name = tostring(GetTotalOutputs())..msg.Name
    msg.Visible = true
    msg.Content.Text = output
    elseif OutputType == Enum.MessageType.MessageInfo then
    local msg = elements.Info:Clone()
    msg.Parent = script.Parent.Console.ScrollingFrame.Header
    msg.Name = tostring(GetTotalOutputs())..msg.Name
    msg.Visible = true
    msg.Content.Text = output
    end
    end)
script.Parent.Buttons.Clear.MouseButton1Click:Connect(function()
    for i,v in pairs(script.Parent.Console.ScrollingFrame.Header:GetChildren()) do
    if v:IsA("Frame") then
    v:Destroy()
    end
    end
    end)
end;
task.spawn(C_178);