local mouseEmoji = "🖱️"
local rebirthEmoji = "🔁"
local upgradeEmoji = "⤴️"

local versionVHX = "1.7.3"
local NoCooldownWait = 0.00000000000000001

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow{
    Title = "Veltrix Hub X | Version: " .. versionVHX,
    SubTitle = "by 67_mangogod_67",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "align-justify"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local Options = Library.Options

Library:Notify{
    Title = "Veltrix Hub X",
    Content = "Script loaded successfully.",
    SubContent = "Press Right Ctrl to minimize.",
    Duration = 6
}

Tabs.Main:CreateSection(mouseEmoji .. " FARMING " .. mouseEmoji)

local AutoClick = false

local ClickToggle = Tabs.Main:CreateToggle("AutoClickToggle", {
    Title = "Auto Click",
    Default = false
})

ClickToggle:OnChanged(function(state)
    AutoClick = state
    if AutoClick then
        task.spawn(function()
            while AutoClick do
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Click4"):FireServer()
                task.wait(NoCooldownWait)
            end
        end)
    end
end)

Options.AutoClickToggle:SetValue(false)

local SelectedRebirthFarmAmount = 1

local Dropdown = Tabs.Main:CreateDropdown("RebirthAmountDropdown", {
    Title = "Choose How Many\nRebirths At A Time",
    Values = {"1", "5", "10", "25", "50", "100", "200", "500", "1000", "2000", "5000"},
    Multi = false,
    Default = "1",
})

Dropdown:SetValue("1")

Dropdown:OnChanged(function(Value)
    local map = {
        ["1"] = 1, ["5"] = 2, ["10"] = 3, ["25"] = 4, ["50"] = 5,
        ["100"] = 6, ["200"] = 7, ["500"] = 8, ["1000"] = 9,
        ["2000"] = 10, ["5000"] = 11,
    }
    SelectedRebirthFarmAmount = map[Value] or 1
end)

local AutoFarm = false

local FarmToggle = Tabs.Main:CreateToggle("AutoFarmToggle", {
    Title = "Auto Farm",
    Default = false,
})

FarmToggle:OnChanged(function(state)
    AutoFarm = state
    if AutoFarm then
        task.spawn(function()
            while AutoFarm do
                local events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
                events:WaitForChild("Click4"):FireServer()
                events:WaitForChild("Rebirth"):FireServer(SelectedRebirthFarmAmount)
                task.wait(NoCooldownWait)
            end
        end)
    end
end)

Options.AutoFarmToggle:SetValue(false)

Tabs.Main:CreateSection(rebirthEmoji .. " REBIRTHS " .. rebirthEmoji)

local AutoRebirth = false

function AutoRebirthFunction()
    while AutoRebirth do
        local args = {1}
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Rebirth"):FireServer(unpack(args))
        task.wait(NoCooldownWait)
    end
end

local RebirthToggle = Tabs.Main:CreateToggle("RebirthToggle", {Title = "Auto Rebirth", Default = false })

RebirthToggle:OnChanged(function(Value)
    AutoRebirth = Value
    if Value then
        task.spawn(AutoRebirthFunction)
    end
end)

Options.RebirthToggle:SetValue(false)

Tabs.Main:CreateSection(upgradeEmoji .. " UPGRADES " .. upgradeEmoji)

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}

InterfaceManager:SetFolder("VeltrixHubX")
SaveManager:SetFolder("VeltrixHubX/Configs")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Library:Notify{
    Title = "Veltrix Hub X",
    Content = "Welcome to Veltrix.",
    Duration = 8
}

SaveManager:LoadAutoloadConfig()