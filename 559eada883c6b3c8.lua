local function C_a2()
local script = DELTA["a2"];
local btns = script.Parent.Dropdown

btns.Option1.MouseButton1Click:Connect(function()
    btns.Option1.Checked.Visible = true
    btns.Option2.Checked.Visible = false
    btns.Option3.Checked.Visible = false
    btns.Visible = false
    --print"Default"
    end)
btns.Option2.MouseButton1Click:Connect(function()
    btns.Option1.Checked.Visible = false
    btns.Option2.Checked.Visible = true
    btns.Option3.Checked.Visible = false
    btns.Visible = false
    --print"Light"
    end)
btns.Option3.MouseButton1Click:Connect(function()
    btns.Option1.Checked.Visible = false
    btns.Option2.Checked.Visible = false
    btns.Option3.Checked.Visible = true
    btns.Visible = false
    --print"Amoled"
    end)

script.Parent.MouseButton1Click:Connect(function()
    if btns.Visible == true then
    btns.Visible = false
    elseif btns.Visible == false then
    btns.Visible = true
    end
    end)
end;
task.spawn(C_a2);
-- StarterGui.Delta.Executor.Executor.Overlay.Buttons.ButtonHandlers
local function C_b2()
local script = DELTA["b2"];
local btns = script.Parent

local function getsize()
for i,v in pairs(script.Parent.Parent.Code:GetChildren()) do
if v:IsA("TextBox") then
return v.TextSize
end
end
end
--[[btns.Button3.Text = tostring(getsize())
	btns.Button3.FocusLost:Connect(function()
		for i,v in pairs(script.Parent.Parent.Code:GetChildren()) do
			if v:IsA("TextBox") then
				v.TextSize = tonumber(script.Parent.Text)
			end
		end
	end)]]
btns.Execute.MouseButton1Click:Connect(function()
    for i,v in pairs(btns.Parent.Code:GetChildren()) do
    if v:IsA("TextBox") then
    if v.Visible == true then
    loadstring(v.Text)()
    end
    end
    end
    end)

btns.Clear.MouseButton1Click:Connect(function()
    for i,v in pairs(btns.Parent.Code:GetChildren()) do
    if v:IsA("TextBox") then
    if v.Visible == true then
    v.Text = ""
    end
    end
    end
    end)
btns.ExecuteClipboard.MouseButton1Click:Connect(function()
    executeclipboard()
    end)
end;
task.spawn(C_b2);