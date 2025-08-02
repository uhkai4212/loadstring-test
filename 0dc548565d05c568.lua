local function C_69()
local script = DELTA["69"];

local lib = require(script.Parent.Parent.Parent.Parent.UILibrary)
local btns = script.Parent
btns.Parent.Parent.Visible = false
btns.Button1.MouseButton1Click:Connect(function()
    loadstring(lib:GetSelectedScript())()

    if(not isfile("preventautoclose")) then
        btns.Parent.Visible = false
        btns.Parent.Parent.DarkOverlay.Visible = false
    end

    end)
btns.Button2.MouseButton1Click:Connect(function()
    lib:GoToExecutor()
    lib:AddTab(lib:GetSelectedScriptTitle(), lib:GetSelectedScript())

    if(not isfile("preventautoclose")) then
        btns.Parent.Visible = false
        btns.Parent.Parent.DarkOverlay.Visible = false
    end

    end)
btns.Button3.MouseButton1Click:Connect(function()
    lib.SavedScripts:Add(lib:GetSelectedScriptTitle(), lib:GetSelectedScript())
    writefile("d_android_script_dir/" .. lib:GetSelectedScriptTitle(), lib:GetSelectedScript())
    
    if(not isfile("preventautoclose")) then
        btns.Parent.Visible = false
        btns.Parent.Parent.DarkOverlay.Visible = false
    end

    end)
btns.Button4.MouseButton1Click:Connect(function()
    setclipboard(lib:GetSelectedScript())

    if(not isfile("preventautoclose")) then
        btns.Parent.Visible = false
        btns.Parent.Parent.DarkOverlay.Visible = false
    end

    end)
btns.Parent.ImageButton.MouseButton1Click:Connect(function()
    btns.Parent.Visible = false
    btns.Parent.Parent.DarkOverlay.Visible = false
    end)
end;
task.spawn(C_69);
-- StarterGui.Delta.Settings.Searchbar.SettingsSearchHandler
local function C_74()
local script = DELTA["74"];
local textbox = script.Parent.Input
textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local matched = textbox.Text
    if matched ~= '' then
    for _,v in pairs(script.Parent.Parent.Holder:GetChildren()) do
    if v:IsA("Frame") then
    if v:FindFirstChild("Title") and v:FindFirstChild("Desc") then
    if string.find(string.lower(v.Title.Text), string.lower(matched)) or string.find(string.lower(v.Desc.Text), string.lower(matched)) then
    v.Visible = true
    else
        v.Visible = false
    end
    end
    end
    end
    else
        for _,v in pairs(script.Parent.Parent.Holder:GetChildren()) do
    if v:IsA("Frame") then
    v.Visible = true
    end
    end
    end
    end)
end;
task.spawn(C_74);
-- StarterGui.Delta.Settings.Sort.SettingsFilterHandler
local function C_81()
local script = DELTA["81"];
local btns = script.Parent
local reserved = script.Parent.Parent.Parent.Executor.Executor.Overlay.Reserved
local ts = game:GetService("TweenService")

btns.All.MouseButton1Click:Connect(function()
    ts:Create(btns.Disabled, TweenInfo.new(.15), {
        BackgroundTransparency = 1
    }):Play()
    ts:Create(btns.Enabled, TweenInfo.new(.15), {
        BackgroundTransparency = 1
    }):Play()
    ts:Create(btns.All, TweenInfo.new(.15), {
        BackgroundTransparency = 0
    }):Play()
    for i,v in pairs(btns.Parent.Holder:GetChildren()) do
    if v:IsA("Frame") then
    v.Visible = true
    end
    end
    end)
btns.Enabled.MouseButton1Click:Connect(function()
    ts:Create(btns.Disabled, TweenInfo.new(.15), {
        BackgroundTransparency = 1
    }):Play()
    ts:Create(btns.Enabled, TweenInfo.new(.15), {
        BackgroundTransparency = 0
    }):Play()
    ts:Create(btns.All, TweenInfo.new(.15), {
        BackgroundTransparency = 1
    }):Play()
    for i,v in pairs(btns.Parent.Holder:GetChildren()) do
    if v:IsA("Frame") then
    if v:FindFirstChild("Enabled") then
    if v.Enabled.value == true then
    v.Visible = true
    else
        v.Visible = false
    end
    else
        v.Visible = false
    end
    end
    end
    end)
btns.Disabled.MouseButton1Click:Connect(function()
    ts:Create(btns.Disabled, TweenInfo.new(.15), {
        BackgroundTransparency = 0
    }):Play()
    ts:Create(btns.Enabled, TweenInfo.new(.15), {
        BackgroundTransparency = 1
    }):Play()
    ts:Create(btns.All, TweenInfo.new(.15), {
        BackgroundTransparency = 1
    }):Play()
    for i,v in pairs(btns.Parent.Holder:GetChildren()) do
    if v:IsA("Frame") then
    if v:FindFirstChild("Enabled") then
    if v.Enabled.value == false then
    v.Visible = true
    else
        v.Visible = false
    end
    else
        v.Visible = false
    end
    end
    end
    end)
end;
task.spawn(C_81);