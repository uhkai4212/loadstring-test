local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local gamename = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local player = game:GetService("Players").LocalPlayer

local Window = Fluent:CreateWindow({
    Title = game:GetService("MarketplaceService"):GetProductInfo(109983668079237).Name .. " 〢 Stellar",
    SubTitle = "discord.gg/FmMuvkaWvG",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Updates = Window:AddTab({ Title = "Home", Icon = "home" }),
    Main = Window:AddTab({ Title = "Main", Icon = "play" }),
}

local Side = nil

local Toggle = Tabs.Main:AddToggle("Toggle", {
    Title = "Auto Player",
    Description = "Automatically Hit Notes (toggle after joining a match)",
    Default = false
})

Toggle:OnChanged(function()
    if Toggle.Value then
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")

        _G.auto = true
        _G.Delay = _G.Delay or 0

        local keymap = {
            key1,
            key2,
            key3,
            key4,
            key5,
            key6,
            key7,
            key8,
            key9,
        }

        local function setupColumns(side)
            local columns = {}
            pcall(function()
                local ap = Players.LocalPlayer.PlayerGui.Window.Game.Fields[side].Inner
                
                for i = 1, 9 do
                    pcall(function()
                        local lane = ap["Lane"..i]
                        if lane then
                            columns[i] = lane.Notes
                        end
                    end)
                end
            end)
            return columns
        end

        local function autoplay()
            while _G.auto do
                pcall(function()
                    local columns = setupColumns(Side)
                    local trackedChildren = {}
                    local activationThreshold = 0.4 + 1e-9 + _G.Delay

                    for columnNum, column in pairs(columns) do
                        pcall(function()
                            trackedChildren[columnNum] = {}
                            for _, child in ipairs(column:GetChildren()) do
                                pcall(function()
                                    if child:IsA("GuiObject") and child.Position.Y.Scale > activationThreshold then
                                        trackedChildren[columnNum][child] = true
                                        VirtualInputManager:SendKeyEvent(true, keymap[columnNum], false, game)
                                    end
                                end)
                            end
                        end)
                    end

                    while _G.auto do
                        pcall(function()
                            for columnNum, column in pairs(columns) do
                                pcall(function()
                                    for _, child in ipairs(column:GetChildren()) do
                                        pcall(function()
                                            if child:IsA("GuiObject") and not trackedChildren[columnNum][child] and child.Position.Y.Scale > activationThreshold then
                                                trackedChildren[columnNum][child] = true
                                                VirtualInputManager:SendKeyEvent(true, keymap[columnNum], false, game)
                                                
                                                if #child:GetChildren() == 2 then
                                                    coroutine.wrap(function()
                                                        pcall(function()
                                                            while child.Parent and child.Position.Y.Scale > activationThreshold and _G.auto do
                                                                RunService.Heartbeat:Wait()
                                                            end
                                                            VirtualInputManager:SendKeyEvent(false, keymap[columnNum], false, game)
                                                            trackedChildren[columnNum][child] = nil
                                                        end)
                                                    end)()
                                                end
                                            end
                                        end)
                                    end
                                    
                                    for child in pairs(trackedChildren[columnNum]) do
                                        pcall(function()
                                            if not child:IsDescendantOf(column) or 
                                               (child:IsA("GuiObject") and child.Position.Y.Scale <= activationThreshold) then
                                                if trackedChildren[columnNum][child] then
                                                    VirtualInputManager:SendKeyEvent(false, keymap[columnNum], false, game)
                                                end
                                                trackedChildren[columnNum][child] = nil
                                            end
                                        end)
                                    end
                                end)
                            end
                            RunService.Heartbeat:Wait()
                        end)
                    end
                end)
            end
        end

        coroutine.wrap(autoplay)()
    else
        _G.auto = false
    end
end)

Toggle:SetValue(false)


game.GuiService.MenuOpened:Connect(function()
    if Toggle.Value then
        _G.Toggled = true
        Toggle:SetValue(false)
    end
end)

game.GuiService.MenuClosed:Connect(function()
    if not Toggle.Value and _G.Toggled then
        _G.Toggled = false
        Toggle:SetValue(true)
    end
end)

local Keybind = Tabs.Main:AddKeybind("Keybind", {
    Title = "Auto Player Keybind",
    Mode = "Toggle",
    Default = "Insert",

    Callback = function(Value)
        if Toggle.Value then
            Toggle:SetValue(false)
        else
            Toggle:SetValue(true)
        end
    end,
})

local Section = Tabs.Main:AddParagraph({
    Title = "Use DownScroll",
})

Tabs.Main:AddSection("Adjustments")

local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Delay Mode",
    Values = {"Static", "Random"},
    Multi = false,
    Default = 1,
    Callback = function(Value)
        _G.Mode = Value
    end
})

_G.Mode = "Static"

local Slider = Tabs.Main:AddSlider("Slider", {
    Title = "Note ms Delay",
    Description = "More = Later",
    Default = 0,
    Min = -0.4,
    Max = 0.4,
    Rounding = 2,
    Callback = function(Value)
        pcall(function()
            if _G.Mode == "Static" then
                _G.Delay = Value
                local player = game.Players.LocalPlayer
                if player.PlayerGui.GameGui.Windows.Configuration.Frame.Body.Content.Settings.Entries.ScrollingFrame.DownScroll.Toggle.Inner.BackgroundColor3 == Color3.new(85/255, 255/255, 85/255) then
                    _G.Delay = _G.Delay - _G.Delay - _G.Delay
                    print("downscroll")
                else
                    _G.Delay = _G.Delay - _G.Delay - _G.Delay
                    print("upscroll")
                end
            else
                task.spawn(function()
                    while true do
                        _G.Delay = math.floor(math.random() * Value * 1000) / 1000
                        task.wait()
                    end
                end)
                
                local player = game:GetService("Players").LocalPlayer
                if player.PlayerGui.GameGui.Windows.Settings.Frame.Body.Settings.Settings.ScrollingFrame.DownScroll.Toggle.Outer.Inner.ImageColor3 == {85, 255, 85} then
                    _G.Delay = _G.Delay - _G.Delay - _G.Delay
                else
                    _G.Delay = math.floor(math.random() * Value * 1000) / 1000
                end
            end
        end)
    end
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

Window:SelectTab(1)

local Timer = Tabs.Updates:AddParagraph({
    Title = "Time: 00:00:00",
})

local st = os.time()

local function timer()
    while true do
        local et = os.difftime(os.time(), st)
        local h = math.floor(et / 3600)
        local m = math.floor((et % 3600) / 60)
        local s = et % 60
        local ft = string.format("Time: %02d:%02d:%02d", h, m, s)

        Timer:SetTitle(ft)
        task.wait(1)
    end
end

coroutine.wrap(timer)()

Tabs.Updates:AddButton({
    Title = "Discord Server",
    Description = "Copies Discord Invite Link",
    Callback = function()
        setclipboard("https://discord.gg/FmMuvkaWvG")
        Fluent:Notify({Title = "Stellar", Content = "Copied Successfuly", Duration = 2})
    end
})

Tabs.Updates:AddButton({
    Title = "Run Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})

local backpack = player:WaitForChild("Backpack")
if backpack:FindFirstChild("Ui") then
    backpack:FindFirstChild("Ui"):Destroy()
end

local tool = Instance.new("Tool")
tool.Name = "Ui"
tool.RequiresHandle = false
tool.TextureId = "rbxassetid://135519282079256"
tool.Parent = backpack

Open = true
tool.Activated:Connect(function()
    if Open then
        Window:Minimize()
    else
        Window:Minimize()
    end
end)

local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

function CheckSide()
    pcall(function ()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        local minDistTo11 = math.huge
        local minDistTo21 = math.huge

        for _, stage in pairs(workspace.Map.Stages:GetChildren()) do
            if stage:FindFirstChild("Teams") then
                local pads = stage.Teams
                local part11 = pads:FindFirstChild("Left")
                local part21 = pads:FindFirstChild("Right")
                
                if part11 and (rootPart.Position - part11.Position).magnitude <= 5 then
                    local distTo11 = (rootPart.Position - part11.Position).magnitude
                    if distTo11 < minDistTo11 then
                        minDistTo11 = distTo11
                    end
                end

                if part21 and (rootPart.Position - part21.Position).magnitude <= 5 then
                    local distTo21 = (rootPart.Position - part21.Position).magnitude
                    if distTo21 < minDistTo21 then
                        minDistTo21 = distTo21
                    end
                end
            end
        end

        if minDistTo11 < minDistTo21 then
            Side = "Left"
        elseif minDistTo21 < minDistTo11 then
            Side = "Right"
        else

        end
    end)
end

while true do
    local player = game:GetService("Players").LocalPlayer
    if player.PlayerGui.GameGui.Windows.SongSelector.Visible == true then
        CheckSide()
    end
    pcall(function()
        keymap = player.PlayerGui.Window.Game.Fields[Side].Inner
        key1 = Enum.KeyCode[keymap["Lane1"].Labels.Label.Text.text]
        key2 = Enum.KeyCode[keymap["Lane2"].Labels.Label.Text.text]
        key3 = Enum.KeyCode[keymap["Lane3"].Labels.Label.Text.text]
        key4 = Enum.KeyCode[keymap["Lane4"].Labels.Label.Text.text]
        key5 = Enum.KeyCode[keymap["Lane5"].Labels.Label.Text.text]
        key6 = Enum.KeyCode[keymap["Lane6"].Labels.Label.Text.text]
        key7 = Enum.KeyCode[keymap["Lane7"].Labels.Label.Text.text]
        key8 = Enum.KeyCode[keymap["Lane8"].Labels.Label.Text.text]
        key9 = Enum.KeyCode[keymap["Lane9"].Labels.Label.Text.text]
    end)
    task.wait()
end