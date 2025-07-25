local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Squid Game GUI", "DarkTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Main")

Section:NewButton(
    "TugWar Auto Jumper",
    "Keybind to toggle: J",
    function()
        local waitt = 0.01
        local autoclickKey = "j"
        print("AutoClick Keybind is: ", autoclickKey)

        toggle = true
        m = game.Players.LocalPlayer:GetMouse()
        m.KeyDown:connect(
            function(key)
                key = string.lower(key)
                if key == autoclickKey then
                    if toggle then
                        toggle = false
                    else
                        toggle = true

                        while toggle == true do
                            wait(waitt)
                            print("Jumped")
                            game.workspace.Map.TugOfWar.Remotes.HakerPT:FireServer()
                        end
                    end
                end
            end
        )
    end
)

Section:NewButton(
    "Reward TP",
    "RL,GL-keep running after winning to confuse people",
    function()
        local playerLocal = game.Players.LocalPlayer
        local leHuman

        if game.Workspace[tostring(playerLocal)].HumanoidRootPart then
            leHuman = game.Workspace[tostring(playerLocal)].HumanoidRootPart
        end
        local tp = leHuman.CFrame

        for a, b in pairs(game.ReplicatedStorage.Shared.Maps:GetChildren()) do
            print(a, b)
            if leHuman then
                leHuman.CFrame = game.ReplicatedStorage.Shared.Maps[tostring(b)].Reward.CFrame
                wait(0.5)
                leHuman.CFrame = tp
            else
                wait(0.2)
            end
        end
    end
)

Section:NewButton(
    "FP Camera",
    "First Person Camera",
    function()
        local playerLocal = game.Players.LocalPlayer
        playerLocal.CameraMode = Enum.CameraMode.LockFirstPerson
    end
)

Section:NewButton(
    "TP Camera",
    "Third Person Camera",
    function()
        local playerLocal = game.Players.LocalPlayer
        playerLocal.CameraMode = Enum.CameraMode.Classic
    end
)