local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Naval Warfare",
    SubTitle = "CRACKED BY CRUCIFIX",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local infiniteAmmoEnabled = false
local killEnemyEnabled = false
local espEnabled = false

local function InfiniteAmmo(state)
    infiniteAmmoEnabled = state
    if state then
        spawn(function()
            while infiniteAmmoEnabled and wait(3) do
                pcall(function()
                    local oh_get_gc = getgc or false
                    local oh_is_x_closure = is_synapse_function or issentinelclosure or is_protosmasher_closure or is_sirhurt_closure or checkclosure or false
                    local oh_get_info = debug.getinfo or getinfo or false
                    local oh_set_upvalue = debug.setupvalue or setupvalue or setupval or false

                    if not oh_get_gc or not oh_get_info or not oh_set_upvalue then
                        return
                    end

                    local function oh_find_function(name)
                        for _, v in pairs(oh_get_gc()) do
                            if type(v) == "function" and not oh_is_x_closure(v) then
                                if oh_get_info(v).name == name then
                                    return v
                                end
                            end
                        end
                    end

                    local oh_reload = oh_find_function("reload")
                    if oh_reload then
                        local oh_index = 4
                        local oh_new_value = math.huge
                        oh_set_upvalue(oh_reload, oh_index, oh_new_value)
                    end
                end)
            end
        end)
    end
end

local function KillEnemy()
    print("Kill Enemy Enabled")
    killEnemyEnabled = true
    
    spawn(function()
        while killEnemyEnabled and wait(0.1) do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    for _, v in pairs(game.Workspace:GetDescendants()) do
                        if v:IsA("Humanoid") and v.Parent and v.Parent:FindFirstChild("HumanoidRootPart") then
                            local targetPlayer = game.Players:GetPlayerFromCharacter(v.Parent)
                            if targetPlayer and targetPlayer.Team ~= LocalPlayer.Team then
                                local Event = game:GetService("ReplicatedStorage"):WaitForChild("Event")
                                Event:FireServer("shootRifle", "", {v.Parent.HumanoidRootPart})
                                Event:FireServer("shootRifle", "hit", {v})
                            end
                        end
                    end
                end
            end)
        end
    end)
end

local function ESPS(state)
    espEnabled = state
    print("ESP: " .. tostring(state))
    
    if not state then 
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if player.Character:FindFirstChild("Totally NOT Esp") then
                    player.Character:FindFirstChild("Totally NOT Esp"):Destroy()
                end
                if player.Character:FindFirstChild("Icon") then
                    player.Character:FindFirstChild("Icon"):Destroy()
                end
            end
        end
        return
    end
    
    spawn(function()
        while espEnabled do
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude)
                        
                        if not player.Character:FindFirstChild("Totally NOT Esp") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "Totally NOT Esp"
                            highlight.Adornee = player.Character
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.FillColor = player.TeamColor.Color
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Parent = player.Character
                        end
                        
                        if not player.Character:FindFirstChild("Icon") then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "Icon"
                            billboard.AlwaysOnTop = true
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.Adornee = player.Character.Head
                            billboard.Parent = player.Character
                            
                            local label = Instance.new("TextLabel")
                            label.Name = "ESP Text"
                            label.BackgroundTransparency = 1
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.Font = Enum.Font.SciFi
                            label.Text = player.Name .. " | " .. distance
                            label.TextColor3 = player.TeamColor.Color
                            label.TextSize = 18
                            label.Parent = billboard
                        else
                            player.Character.Icon["ESP Text"].Text = player.Name .. " | " .. distance
                        end
                    end
                end
            end)
            wait(1)
        end
    end)
end

-- Create tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- MAIN TAB
local MainSection = Tabs.Main:AddSection("Combat Features", { Columns = 1 })

MainSection:AddToggle("InfiniteAmmoToggle", {
    Title = "Infinite Ammo",
    Default = false,
    Callback = InfiniteAmmo
})

MainSection:AddButton({
    Title = "Kill Enemy",
    Description = "Automatically kills nearby enemies",
    Callback = KillEnemy
})

MainSection:AddToggle("ESPToggle", {
    Title = "ESP",
    Default = false,
    Callback = ESPS
})

-- TELEPORT TAB
local TeleportSection = Tabs.Teleport:AddSection("Teleport Locations", { Columns = 2 })
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local teleportButtons = {
    {Title = "Japan Lobby", CFrame = CFrame.new(-4.103, -295.5, -36.644)},
    {Title = "America Lobby", CFrame = CFrame.new(15.0, -295.5, 46.504)},
    {Title = "America Harbour", CFrame = CFrame.new(-50.992, 23.0, 8129.594)},
    {Title = "Japan Harbour", CFrame = CFrame.new(-150.507, 23.0, -8160.172)}
}

for _, button in ipairs(teleportButtons) do
    TeleportSection:AddButton({
        Title = button.Title,
        Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = button.CFrame
                Fluent:Notify({
                    Title = "Teleported",
                    Content = "Moved to " .. button.Title,
                    Duration = 3
                })
            end
        end
    })
end

local function teleportToIsland(islandCode)
    local islands = workspace:FindFirstChild("Islands")
    if not islands then return end

    for _, island in pairs(islands:GetChildren()) do
        local islandValue = island:FindFirstChild("IslandCode")
        local flagPost = island:FindFirstChild("Flag") and island.Flag:FindFirstChild("Post")

        if islandValue and flagPost and islandValue:IsA("StringValue") then
            if islandValue.Value == islandCode then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = flagPost.CFrame
                    Fluent:Notify({
                        Title = "Teleported",
                        Content = "Moved to Island " .. islandCode,
                        Duration = 3
                    })
                end
                return -- Stop once found
            end
        end
    end

    Fluent:Notify({
        Title = "Teleport Failed",
        Content = "Island " .. islandCode .. " not found.",
        Duration = 3
    })
end

TeleportSection:AddButton({
    Title = "Island A",
    Callback = function()
        teleportToIsland("A")
    end
})

TeleportSection:AddButton({
    Title = "Island B",
    Callback = function()
        teleportToIsland("B")
    end
})

TeleportSection:AddButton({
    Title = "Island C",
    Callback = function()
        teleportToIsland("C")
    end
})

-- PLAYER TAB
local PlayerSection = Tabs.Player:AddSection("Player Options", { Columns = 2 })

PlayerSection:AddButton({
    Title = "GodMode",
    Description = "Teleport to safe zone",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local team = player.Team and player.Team.Name or "Unknown"
            if team == "Japan" then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(-150.50711059570312, 23.0000057220459, -8160.171875)
                Fluent:Notify({Title = "Teleported to Japan Harbor", Duration = 3})
            elseif team == "USA" then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(-50.992095947265625, 23.0000057220459, 8129.59423828125)
                Fluent:Notify({Title = "Teleported to USA Harbor", Duration = 3})
            else
                Fluent:Notify({Title = "Team not recognized", Duration = 3})
            end
        end
    end
})

PlayerSection:AddButton({
    Title = "Stop Kill Enemy",
    Description = "Disable auto-kill",
    Callback = function()
        killEnemyEnabled = false
        Fluent:Notify({Title = "Kill Enemy Disabled", Duration = 3})
    end
})

PlayerSection:AddButton({
    Title = "Inf Jump",
    Description = "Jump infinitely",
    Callback = function()
        Fluent:Notify({Title = "Feature Locked", Content = "Available in premium version", Duration = 3})
    end
})

PlayerSection:AddButton({
    Title = "Speed Boost",
    Description = "Increase movement speed",
    Callback = function()
        Fluent:Notify({Title = "Feature Locked", Content = "Available in premium version", Duration = 3})
    end
})
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("NavalWarfareScripts")
SaveManager:SetFolder("NavalWarfareConfig")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
do
    
end
Fluent:Notify({
    Title = "Naval Warfare Hub",
    Content = "Loaded successfully!",
    Duration = 5
})
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()