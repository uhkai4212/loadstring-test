local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua"))()

    local game = game

    local players = game:GetService("Players")

    local player = players.LocalPlayer

    local UIS = game:GetService("UserInputService")

    local rs = game:GetService("RunService")

    local cg = cloneref(game:GetService("CoreGui"))

    local camera = workspace.CurrentCamera

    local instance = Instance.new

    local udim2 = UDim2.new

    local vector2 = Vector2.new

    local vector3 = Vector3.new

    local color3 = Color3.new

    local cframe = CFrame.new

    local enum = Enum.KeyCode

    local silentaim = false

    local silentkeybindtoggle = false

    local silentkeybind = false

    local noforcefields = false

    local weapons = {}

    if not game:GetService("ReplicatedStorage"):FindFirstChild("Weapons") then

        NotificationLibrary:SendNotification("Warning", "Weapons couldn't be found in ReplicatedStorage. Join Gunfight Arena for this script to work properly.", 5)

    else

        for _,v in pairs(game:GetService("ReplicatedStorage").Weapons:GetChildren()) do

            table.insert(weapons,v.Name)

        end

    end

    local camos = {}

    for _,v in pairs(game:GetService("ReplicatedStorage").Camos:GetChildren()) do

        table.insert(camos,v.Name)

    end

    local primary

    local secondary

    local primarycamo

    local secondarycamo

    local s=player.PlayerScripts.Vortex.Modifiers.Steadiness

    local m=player.PlayerScripts.Vortex.Modifiers.Mobility

    local function r()

        if s and s.Value>0 then s.Value=0 end

        if m and m.Value>0 then m.Value=0 end

    end

    if s then s.Changed:Connect(r) end

    if m then m.Changed:Connect(r) end

    r()

    local function visible(origin, direction, target, ignore)

        local params = RaycastParams.new()

        local filterList = {game.Players.LocalPlayer.Character, target}

        if ignore then

            for _, v in ipairs(ignore) do

                table.insert(filterList, v)

            end

        end

        params.FilterDescendantsInstances = filterList

        return (not workspace:Raycast(origin, direction, params))

    end

    local closestPlayer = nil

    local team = nil

    local function getClosestPlayer()

        team = player:GetAttribute("Team")

        local closest, distance = nil, math.huge

        for _, character in ipairs(workspace:GetChildren()) do

            local humanoid = character:FindFirstChild("Humanoid")

            if character and humanoid and humanoid.Health > 0 then

                local player = players:FindFirstChild(character.Name)

                if player and player:GetAttribute("Team") ~= team then

                    local head = character:FindFirstChild("Head")

                    if head then

                        local w2s, onscreen = camera:WorldToViewportPoint(head.Position)

                        if onscreen then

                            local dist = (vector2(w2s.X, w2s.Y) - vector2(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude

                            if dist < distance then

                                local origin = camera.CFrame.Position

                                local direction = head.Position - origin

                                if visible(origin, direction, character, nil) then

                                    closest = character

                                    distance = dist

                                end

                            end

                        end

                    end

                end

            end

        end

        return closest

    end

    rs.RenderStepped:Connect(function()

        closestPlayer = getClosestPlayer()

    end)

    local oldIndex

    oldIndex = hookmetamethod(game, "__index", function(self, index)

        local func = debug.getinfo(3, "n")

        if func and func.name then

            if func.name == "Fire" and index == "CFrame" and closestPlayer then

                local head = closestPlayer:FindFirstChild("Head")

                if head then

                    local origin = camera.CFrame.Position

                    local direction = head.Position - origin

                    if visible(origin, direction, closestPlayer, nil) and silentaim then

                        if silentkeybindtoggle then

                            if silentkeybind then

                                return cframe(head.Position)

                            end

                        else

                            return cframe(head.Position)

                        end

                    end

                end

            end

        end

        return oldIndex(self, index)

    end)

    rs.RenderStepped:Connect(function()

        for _,v in pairs(game:GetService("Workspace").Env:GetChildren()) do

            if string.find(v.Name, "Forcefield") and noforcefields then

                if v.FullSphere.Color ~= Color3.fromRGB(0, 102, 255) then

                    v:Destroy()

                end

            end

        end

    end)

    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

    OrionLib:MakeNotification({

        Name = "Info",

        Content = "Made By Mev.",

        Time = 7

    })

    local Window = OrionLib:MakeWindow({Name = "Gunfight Arena", HidePremium = false, SaveConfig = true, ConfigFolder = "Gunfight Arena Configuration Saving", IntroEnabled = true, IntroText = "Gunfight Arena Script"})

    local aimtab = Window:MakeTab({

        Name = "Aim",

        Icon = "rbxassetid://4483345998",

        PremiumOnly = false

    })

    local weapontab = Window:MakeTab({

        Name = "Weapons",

        Icon = "rbxassetid://4483345998",

        PremiumOnly = false

    })

    local aimsection = aimtab:AddSection({

        Name = "Silent Aim"

    })

    aimsection:AddToggle({

        Name = "Silent Aim",

        Default = false,

        Callback = function(Value)

            silentaim = Value

        end    

    })

    aimsection:AddToggle({

        Name = "Silent Aim Keybind Toggle",

        Default = false,

        Callback = function(Value)

            silentkeybindtoggle = Value

        end    

    })

    aimsection:AddBind({

        Name = "Silent Aim Keybind",

        Default = enum.E,

        Hold = false,

        Callback = function()

            if silentkeybindtoggle then

                silentkeybind = not silentkeybind

            end

        end    

    })

    local miscsection = aimtab:AddSection({

        Name = "Misc"

    })

    miscsection:AddToggle({

        Name = "No Enemy Forcefields",

        Default = false,

        Callback = function(Value)

            noforcefields = Value

        end    

    })

    weapontab:AddParagraph("Note","If you have equipped any of these (Primary Weapon Or Secondary Weapon/Primary Weapon Camo Or Secondary Weapon Camo), and it's not working, it's because you need to reset your character.")

    local primarySection = weapontab:AddSection({

        Name = "Primary Weapon Changer"

    })

    local primaryDropdown = primarySection:AddDropdown({

        Name = "Gun Selector",

        Default = weapons[1],

        Options = weapons,

        Callback = function(Value)

            primary = Value

        end,

    })

    local primarybutton = primarySection:AddButton({

        Name = "Equip Gun",

        Callback = function()

            player:SetAttribute("Primary",primary)

        end,

    })

    local primarySection2 = weapontab:AddSection({

        Name = "Primary Weapon Camo Changer"

    })

    local primaryDropdown2 = primarySection2:AddDropdown({

        Name = "Camo Selector",

        Default = camos[1],

        Options = camos,

        Callback = function(Value)

            primarycamo = Value

        end,

    })

    local primarybutton2 = primarySection2:AddButton({

        Name = "Equip Camo",

        Callback = function()

            player:SetAttribute("PrimaryCamo",primarycamo)

        end,

    })

    local secondarySection = weapontab:AddSection({

        Name = "Secondary Weapon Changer"

    })

    local secondarydropdown = secondarySection:AddDropdown({

        Name = "Gun Selector",

        Default = weapons[1],

        Options = weapons,

        Callback = function(Value)

            secondary = Value

        end,

    })

    local secondarybutton = secondarySection:AddButton({

        Name = "Equip Gun",

        Callback = function()

            player:SetAttribute("Secondary",secondary)

        end,

    })

    local secondarySection2 = weapontab:AddSection({

        Name = "Secondary Weapon Camo Changer"

    })

    local secondarydropdown2 = secondarySection2:AddDropdown({

        Name = "Camo Selector",

        Default = camos[1],

        Options = camos,

        Callback = function(Value)

            secondarycamo = Value

        end,

    })

    local secondarybutton2 = secondarySection2:AddButton({

        Name = "Equip Camo",

        Callback = function()

            player:SetAttribute("SecondaryCamo",secondarycamo)

        end,

    })

    local SettingsTab = Window:MakeTab({

        Name = "Settings",

        Icon = "rbxassetid://4483345998",

        PremiumOnly = false

    })

    local SettingsSection = SettingsTab:AddSection({

        Name = "Settings"

    })

    SettingsSection:AddButton({

        Name = "Destroy UI",

        Callback = function()

            OrionLib:Destroy()

        end    

    })

    OrionLib:Init()