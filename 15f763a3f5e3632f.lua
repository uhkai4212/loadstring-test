local function C_bd()
local script = DELTA["bd"];
local module = require(script.Parent.Parent.Parent.Parent.Parent.Parent.UILibrary)
script.Parent.MouseButton1Click:Connect(function()
    module:AddTab()
    end)
end;
task.spawn(C_bd);