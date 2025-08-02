local function C_177()
local script = DELTA["177"];
script.Parent:GetPropertyChangedSignal("Text"):Connect(function()
    if script.Parent.Text ~= '' then
    for i, v in pairs(script.Parent.Parent.Console.ScrollingFrame.Header:GetChildren()) do
    if v:IsA("Frame") then
    local lowered = string.lower(v.Content.Text)
    local lowered1 = string.lower(script.Parent.Text)

    local matched = string.find(lowered, lowered1)
    if matched then
    v.Visible = true
    else
        v.Visible = false
    end
    end
    end
    else
        for i, v in pairs(script.Parent.Parent.Console.ScrollingFrame.Header:GetChildren()) do
    if v:IsA("Frame") then
    v.Visible = true
    end
    end
    end
    end)

end;
task.spawn(C_177);