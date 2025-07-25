local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Window = Fluent:CreateWindow({
    Title = "Goiaba.lua Hub",
    SubTitle = "DIG 💛",
    TabWidth = 100,
    Size = UDim2.fromOffset(670, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "shovel" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "navigation" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

local function safeFire(eventPath, ...)
    local args = {...}
    local success, err = pcall(function()
        if eventPath then
            local event = eventPath()
            if event then
                local realArgs = {}
                for _, v in ipairs(args) do
                    table.insert(realArgs, (type(v) == "function") and v() or v)
                end
                event:FireServer(unpack(realArgs))
            else
                error("Event not found")
            end
        else
            local realArgs = {}
            for _, v in ipairs(args) do
                if type(v) == "function" then
                    table.insert(realArgs, v())
                else
                    table.insert(realArgs, v)
                end
            end
        end
    end)
    if not success then
        Fluent:Notify({ Title = "Error", Content = tostring(err), Duration = 3 })
    end
end

local function safeExecute(func)
    local success, err = pcall(func)
    if not success then
        Fluent:Notify({ Title = "Error", Content = tostring(err), Duration = 3 })
    end
end

-- local function capitalize(name)
--     return name and name:gsub("(%a)(%w*)", function(a,b) return a:upper()..b:lower() end) or ""
-- end

local function createInput(tab, id, title, description, placeholder, default, isNumeric)
    tab:AddInput(id, {
        Title = title,
        Description = description,
        Default = default,
        Placeholder = placeholder,
        Numeric = isNumeric or false,
        Callback = function() end
    })
end

local function createButton(tab, title, eventName, argsFunc)
    tab:AddButton({
        Title = title,
        Callback = function()
            safeFire(eventName, unpack(argsFunc()))
        end
    })
end

local function autoFire(tab, toggleName, desc, interval, eventName, argsFunc)
    local running = false
    tab:AddToggle(toggleName, {
        Title = toggleName,
        Description = desc,
        Default = false,
        Callback = function(state)
            running = state
            if state then
                task.spawn(function()
                    while running do
                        safeFire(eventName, unpack(argsFunc()))
                        task.wait(interval)
                    end
                end)
            end
        end
    })
end

local AutoDigSection = Tabs.Main:AddSection("⛏️ ‣ Dig")

-- Toggle: Auto Dig Rocks
local runningAutoDig = false
Tabs.Main:AddToggle("AutoDig", {
    Title = "Auto Dig",
    Description = "Automatically digs.\nEquip a shovel First.",
    Default = false,
    Callback = function(state)
        runningAutoDig = state
        if state then
            task.spawn(function()
                while runningAutoDig do
                    -- Clique LMB
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)

                    -- -- Dig_Replicate x17
                    -- local replicateArgs = {
                    --     "Progress",
                    --     {
                    --         LocalPlayer.Character,
                    --         5.52,
                    --         "Strong",
                    --         {
                    --             Rarity = "Common",
                    --             Rock = false
                    --         }
                    --     }
                    -- }

                    -- for i = 1, 17 do
                    --     safeFire(function()
                    --         return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Dig_Replicate")
                    --     end, unpack(replicateArgs))
                    --     task.wait(0.3)
                    -- end

                    task.wait(1.5)

                    -- Dig_Finished
                    local vector = Vector3
                    local finishArgs = {
                        0,
                        {
                            {
                                Orientation = vector.zero,
                                Transparency = 1,
                                Name = "PositionPart",
                                Position = vector.new(2048.3315, 108.6206, -321.5524),
                                Color = Color3.fromRGB(163, 162, 165),
                                Material = Enum.Material.Plastic,
                                Shape = Enum.PartType.Block,
                                Size = vector.new(0.1, 0.1, 0.1)
                            },
                            {
                                Orientation = vector.new(0, 90, 90),
                                Transparency = 0,
                                Name = "CenterCylinder",
                                Position = vector.new(2048.3315, 108.5706, -321.5524),
                                Color = Color3.fromRGB(135, 114, 85),
                                Material = Enum.Material.Pebble,
                                Shape = Enum.PartType.Cylinder,
                                Size = vector.new(0.2, 6.4162, 5.5873)
                            }
                        }
                    }

                    safeFire(function()
                        return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Dig_Finished")
                    end, unpack(finishArgs))

                    --task.wait(1.5)

                    local player = game:GetService("Players").LocalPlayer
                    local backpack = player:WaitForChild("Backpack")
                    local character = player.Character or player.CharacterAdded:Wait()

                    local validShovelsFolder = ReplicatedStorage:WaitForChild("PlayerItems"):WaitForChild("Shovels")
                    local validShovelNames = {}
                    for _, shovel in ipairs(validShovelsFolder:GetChildren()) do
                        validShovelNames[shovel.Name] = true
                    end

                    -- 1. Desequipar qualquer Tool equipada
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = backpack
                        end
                    end

                    task.wait(0)

                    -- 2. Equipar a primeira Tool válida (shovel) encontrada
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and validShovelNames[tool.Name] then
                            tool.Parent = character
                            break
                        end
                    end

                    task.wait(0.5) -- tempo entre os ciclos
                end
            end)
        end
    end
})

-- Botão: Fix UI
-- Tabs.Main:AddButton({
--     Title = "Fix UI",