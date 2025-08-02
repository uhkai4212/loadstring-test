DELTA["19c"] = Instance.new("LocalScript", DELTA["1"]);
DELTA["19c"]["Name"] = [[MainScript]];

-- Require DELTA wrapper
local DELTA_REQUIRE = require;
local DELTA_MODULES = {};
local function require(Module:ModuleScript)
local ModuleState = DELTA_MODULES[Module];
if ModuleState then
if not ModuleState.Required then
ModuleState.Required = true;
ModuleState.Value = ModuleState.Closure();
end
return ModuleState.Value;
end;
return DELTA_REQUIRE(Module);
end

getgenv().total_tabs = 0

DELTA_MODULES[DELTA["160"]] = {
    Closure = function()
    local script = DELTA["160"];
    local module = {}
    module.Console = {}
    module.Settings = {}
    module.SavedScripts = {}
    local reserved = script.Parent.Executor.Executor.Overlay.Reserved
    local ts = game:GetService("TweenService")
    local isTween = script.Parent.IsTween
    module.ScriptSearch = {}
    local executor = script.Parent.Executor.Executor.Overlay

    local function GetTotalTabs()
        return total_tabs
    end


    function module:AddTab(name: string, source: string)
    total_tabs +=1
    local newTab = script.Parent.Executor.Executor.Overlay.Reserved.TabX:Clone()
    local newTextbox = script.Parent.Executor.Executor.Overlay.Reserved.Textbox:Clone()

    newTextbox.Parent = script.Parent.Executor.Executor.Overlay.Code

    newTab.Parent = script.Parent.Executor.Executor.Overlay.Tabs
    newTab.Visible = true

    if type(name) == "string" then
    newTab.Title.Text = name
    newTab.Name = name

    newTextbox.Name = name
    else
        newTab.Title.Text = "script"..(GetTotalTabs())..'.lua'
    newTab.Name = "script"..(GetTotalTabs())..'.lua'
    newTextbox.Name = "script"..(GetTotalTabs())..'.lua'
    end

    if type(source) == "string" then
    newTextbox.Text = source
    end

    newTab.MouseButton1Click:Connect(function()
        for i,v in pairs(script.Parent.Executor.Executor.Overlay.Tabs:GetChildren()) do
        if v.Name ~= "AddTab" and v.Name ~= newTab.Name and v:IsA("ImageButton") then
        v.Transparency = 1
        elseif v.Name ~= "AddTab" and v.Name == newTab.Name and v:IsA("ImageButton") then
        v.Transparency = 0
        end
        end
        for i,v in pairs(script.Parent.Executor.Executor.Overlay.Code:GetChildren()) do
        if v.Name ~= "AddTab" and v.Name ~= newTab.Name and v:IsA("TextBox") then
        v.Visible = false
        elseif v.Name ~= "AddTab" and v.Name == newTab.Name and v:IsA("TextBox") then
        v.Visible = true
        end
        end
        newTextbox.Visible = true
        newTab.Visible = true
        end)
    newTab.ImageButton.MouseButton1Click:Connect(function()
        newTextbox:Destroy()
        newTab:Destroy()
        end)

    for i,v in pairs(executor.Code:GetChildren()) do
    if v.Name ~= newTextbox.Name then
    v.Visible = false
    end
    end
    for i,v in pairs(script.Parent.Executor.Executor.Overlay.Code:GetChildren()) do
    if v:IsA("TextBox") then
    if v.Name ~= newTab.Name then
    v.Visible = false
    elseif v.Name == newTab.Name then
    v.Visible = true
    end
    end
    end
    for i,v in pairs(script.Parent.Executor.Executor.Overlay.Tabs:GetChildren()) do
    if v.Name ~= "AddTab" and v.Name ~= newTab.Name and v:IsA("ImageButton") then
    v.Transparency = 1
    elseif v.Name ~= "AddTab" and v.Name == newTab.Name and v:IsA("ImageButton") then
    v.Transparency = 0
    end
    end
    end




    function module:SetCurrentSuggestionScript(title: string, desc: string, source: string)
    script.Parent.Executor.Sidemenu.Script.Overlay.Holder.Showcase.Title.Text = title
    script.Parent.Executor.Sidemenu.Script.Overlay.Holder.Showcase.Description.Text = desc
    getgenv().ExecuteSuggestedScript = function()
    loadstring(source)()
    end
    end

    function module.Console:GoToConsole()
    for i,v in pairs(script.Parent:GetChildren()) do
    if v:IsA("Frame") then
    if v:FindFirstChild("Menu") then
    if v.Name ~= "Console" then
    v.Visible = false
    end
    end
    end
    end
    script.Parent.Console.Visible = true
    end

    function module.Settings:AddSwitch(title: string, description: string, enabled: boolean, func, ...)
    if enabled == false then
    local newSwitch = reserved.SettingSwitch:Clone()
    local args = {
        ...
    }
    newSwitch.Parent = script.Parent.Settings.Holder

    newSwitch.Title.Text = title
    newSwitch.Desc.Text = description
    newSwitch.Visible = true
    newSwitch.Switch.MouseButton1Click:Connect(function()
        if enabled == true then
        ts:Create(newSwitch, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(37, 40, 49)
        }):Play()
        ts:Create(newSwitch.Switch.ImageButton, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(135, 139, 150)
        }):Play()
        ts:Create(newSwitch.Switch, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(60, 65, 80)
        }):Play()
        ts:Create(newSwitch.Switch.ImageButton, TweenInfo.new(.2), {
            Position = UDim2.new(0.112, 0,0.5, 0)
        }):Play()

        ts:Create(newSwitch.Desc, TweenInfo.new(.2), {
            TextColor3 = Color3.fromRGB(102, 108, 125)
        }):Play()
        elseif enabled == false then
        ts:Create(newSwitch, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(30, 50, 79)
        }):Play()
        ts:Create(newSwitch.Switch.ImageButton, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(255,255,255)
        }):Play()
        ts:Create(newSwitch.Switch, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(58, 138, 253)
        }):Play()
        ts:Create(newSwitch.Switch.ImageButton, TweenInfo.new(.2), {
            Position = UDim2.new(0.55, 0,0.5, 0)
        }):Play()

        ts:Create(newSwitch.Desc, TweenInfo.new(.2), {
            TextColor3 = Color3.fromRGB(125, 138, 175)
        }):Play()
        end
        enabled = not enabled
        newSwitch.Enabled.Value = enabled
        func(enabled, unpack(args))
        end)
    elseif enabled == true then
    local newSwitch = reserved.SettingSwitchOn:Clone()
    local args = {
        ...
    }
    newSwitch.Parent = script.Parent.Settings.Holder
    newSwitch.Visible = true
    newSwitch.Title.Text = title
    newSwitch.Desc.Text = description

    newSwitch.Switch.MouseButton1Click:Connect(function()
        if enabled == true then
        ts:Create(newSwitch, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(37, 40, 49)
        }):Play()
        ts:Create(newSwitch.Switch.ImageButton, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(135, 139, 150)
        }):Play()
        ts:Create(newSwitch.Switch, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(60, 65, 80)
        }):Play()
        ts:Create(newSwitch.Switch.ImageButton, TweenInfo.new(.2), {
            Position = UDim2.new(0.46, 0,0.5, 0)
        }):Play()

        ts:Create(newSwitch.Desc, TweenInfo.new(.2), {
            TextColor3 = Color3.fromRGB(102, 108, 125)
        }):Play()
        elseif enabled == false then
        ts:Create(newSwitch, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(30, 50, 79)
        }):Play()
        ts:Create(newSwitch.Switch.ImageButton, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(255,255,255)
        }):Play()
        ts:Create(newSwitch.Switch, TweenInfo.new(.2), {
            BackgroundColor3 = Color3.fromRGB(58, 138, 253)
        }):Play()
        ts:Create(newSwitch.Switch.ImageButton, TweenInfo.new(.2), {
            Position = UDim2.new(0.888, 0,0.5, 0)
        }):Play()

        ts:Create(newSwitch.Desc, TweenInfo.new(.2), {
            TextColor3 = Color3.fromRGB(125, 138, 175)
        }):Play()
        end
        enabled = not enabled
        newSwitch.Enabled.Value = enabled
        func(enabled, unpack(args))
        end)
    end
    end

    function module.Settings:AddButton(title: string, description: string, func)
    local newButton = reserved.Button:Clone()
    newButton.Parent = script.Parent.Settings.Holder
    newButton.Visible = true
    newButton.Title.Text = title
    newButton.Desc.Text = description

    newButton.Button.MouseButton1Click:Connect(function()
        func()
        local color = ts:Create(newButton, TweenInfo.new(.13), {
            BackgroundColor3 = Color3.fromRGB(30, 50, 79)
        })
        color:Play()
        color.Completed:Wait()
        ts:Create(newButton, TweenInfo.new(.13), {
            BackgroundColor3 = Color3.fromRGB(37, 40, 49)
        }):Play()
        end)
    end

    function module.Settings:AddDropdown(title: string, description: string, defaulttext: string, options: SharedTable, func, ...)
    if #options > 3 then
    error("Please add 3 options (err: more than 3, expected 3)")
    elseif #options < 3 then
    error("Please add 3 options (err: below 3, expected 3)")
    end
    local newDropdown = reserved.SettingDropdown:Clone()
    local args = {
        ...
    }
    newDropdown.Visible = true
    newDropdown.Parent = script.Parent.Settings.Holder

    newDropdown.Title.Text = title
    newDropdown.Desc.Text = description
    newDropdown.Button.Title.Text = defaulttext

    local objLists = {}

    local function visible()
        for i, item in pairs(script.Parent.Settings.Holder:GetChildren()) do
            if not item:IsA("UIListLayout") and objLists[item.Title.Text] == true and item.Visible == false then
                    objLists[item.Title.Text] = false
                    item.Visible = true  
            end
        end
    end
    
    local function hide()
        for i, item in pairs(script.Parent.Settings.Holder:GetChildren()) do
            if not item:IsA("UIListLayout") then
                if item.AbsolutePosition.Y > newDropdown.AbsolutePosition.Y and item.Visible == true then
                    objLists[item.Title.Text] = true
                    item.Visible = false
                end
            end
        end
    end

    newDropdown.Button.MouseButton1Click:Connect(function()
        --close
        if newDropdown.Dropdown.Visible == true then
            visible()
            newDropdown.Dropdown.Visible = false
        elseif newDropdown.Dropdown.Visible == false then -- open
            hide()
            newDropdown.Dropdown.Visible = true

        end
    end)

    for i,v in ipairs(options) do
        
        if i == 1 then
            newDropdown.Dropdown.Option1.Title.Text = v
        elseif i == 2 then
            newDropdown.Dropdown.Option2.Title.Text = v
        elseif i == 3 then
            newDropdown.Dropdown.Option3.Title.Text = v
        end
    end

    newDropdown.Dropdown.Option1.MouseButton1Click:Connect(function()
        newDropdown.Dropdown.Option1.Checked.Visible = true
        newDropdown.Dropdown.Option2.Checked.Visible = false
        newDropdown.Dropdown.Option3.Checked.Visible = false
        newDropdown.Dropdown.Visible = false
        newDropdown.Button.Title.Text = newDropdown.Dropdown.Option1.Title.Text
        visible()
        func(newDropdown.Dropdown.Option1.Title.Text, unpack(args))
        end)
    newDropdown.Dropdown.Option2.MouseButton1Click:Connect(function()
        newDropdown.Dropdown.Option1.Checked.Visible = false
        newDropdown.Dropdown.Option2.Checked.Visible = true
        newDropdown.Dropdown.Option3.Checked.Visible = false
        newDropdown.Dropdown.Visible = false
        newDropdown.Button.Title.Text = newDropdown.Dropdown.Option2.Title.Text
        visible()
        func(newDropdown.Dropdown.Option2.Title.Text, unpack(args))
        end)

    newDropdown.Dropdown.Option3.MouseButton1Click:Connect(function()
        newDropdown.Dropdown.Option1.Checked.Visible = false
        newDropdown.Dropdown.Option2.Checked.Visible = false
        newDropdown.Dropdown.Option3.Checked.Visible = true
        newDropdown.Dropdown.Visible = false
        newDropdown.Button.Title.Text = newDropdown.Dropdown.Option3.Title.Text
        visible()
        func(newDropdown.Dropdown.Option3.Title.Text, unpack(args))
        end)
    end

    function module.Settings:AddTextbox(title: string, description: string, func, ...)
    local newTextbox = reserved.SettingTextbox:Clone()
    local args = {
        ...
    }

    newTextbox.Title.Text = title
    newTextbox.Desc.Text = description

    newTextbox.Visible = true
    newTextbox.Parent = script.Parent.Settings.Holder

    newTextbox.InputText.FocusLost:Connect(function()
        func(newTextbox.InputText.Text, unpack(args))
        end)
    end

    function module.ScriptSearch:OpenPopup()
    script.Parent.Scripthub.Popup.Visible = true
    script.Parent.Scripthub.DarkOverlay.Visible = true
    script.Parent.Scripthub.DarkOverlay.Transparency = 1
    if isTween.Value == true then
    script.Parent.Scripthub.Popup.Position = UDim2.new(0.5, 0,1.58, 0)
    ts:Create(script.Parent.Scripthub.Popup, TweenInfo.new(.2), {
        Position = UDim2.new(0.5, 0,0.5, 0)
    }):Play()
    end
    ts:Create(script.Parent.Scripthub.DarkOverlay, TweenInfo.new(.15), {
        Transparency = 0.5
    }):Play()
    end
    local Script = ''
    function module.ScriptSearch:Add(title: string, description: string, source: string, image, isverified: boolean, views)
    local newSc = script.Parent.Scripthub.Holder.Reserved.OldThumbnail:Clone()
    newSc.Parent = script.Parent.Scripthub.Holder
    newSc.Visible = true
    newSc.Overlay.Title.Title.Text = title
    newSc.Overlay.Title.Paragraph.Text = description
    newSc.Image = image
    newSc.Overlay.Title.Verified.Visible = isverified

    newSc.Overlay.Views.Title.Text = tostring(views).." Views"


    newSc.MouseButton1Click:Connect(function()
        module.ScriptSearch:OpenPopup()
        Script = source
        Title = title
        end)
    end

    function module:GetSelectedScript()
    return Script
    end
    function module:GetSelectedScriptTitle()
    return Title
    end

    function module:GoToExecutor()
    for i,v in pairs(script.Parent:GetChildren()) do
    if v:IsA("Frame") then
    if v:FindFirstChild("Marker") then
    if v.Marker.Value == "Menu" then
    v.Visible = false
    end
    end
    end
    end
    script.Parent.Executor.Visible = true
    script.Parent.Executor.Position = UDim2.new(0.4824247360229492, 0, 0.524213433265686, 0)
    end