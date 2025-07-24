local var3, var4, var5 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
Rayfield = var3
local var7 = var3:CreateWindow({
    LoadingTitle = "KhSaeedHub",
    KeySettings = {
        Subtitle = "Key System",
        Title = "KhSaeedHub",
        Key = {
            "https://pastebin.com/raw/QKZGwRWK"
        },
        GrabKeyFromSite = true,
        SaveKey = true,
        FileName = "KhSaeedHub",
        Note = "https://link-target.net/897280/khsaeed90"
    },
    Name = "The $1,000,000 Jump Rope",
    KeySystem = true,
    LoadingSubtitle = "Please, Join discord for more scripts!",
    Discord = {
        Enabled = true,
        RememberJoins = true,
        Invite = "37xqzu6eBF"
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = KhSaeedHub,
        FileName = "KhSaeedHub"
    }
})
Window = var7
local Tab = var7:CreateTab("Main")
Tab = Tab
Section = Tab:CreateSection("Win")
Button = Tab:CreateButton({
    Name = "Instant Win",
    Callback = function()
        getWin()
    end
})
Button = Tab:CreateButton({
    Name = "Instant Cash (100K)",
    Callback = function()
        getCash()
    end
})
Toggle = Tab:CreateToggle({
    CurrentValue = false,
    Callback = function(arg1_3)
        Cash = arg1_3
        CashHeart = game:GetService("RunService").Heartbeat:Connect(function()
            local _ = game:GetService("Players").LocalPlayer.Character
            getCash()
        end)
    end,
    Name = "Infinite Cash",
    Flag = "Toggle"
})
Section = Tab:CreateSection("Frontman")
Toggle = Tab:CreateToggle({
    CurrentValue = false,
    Callback = function()
        getFrontman(arg1_5)
    end,
    Name = "Toggle Frontman Morph",
    Flag = "Toggle"
})
Section = Tab:CreateSection("OP Gear")
Button = Tab:CreateButton({
    Name = "Instant Giant Glove",
    Callback = function()
        getSpin("Giant")
    end
})
Button = Tab:CreateButton({
    Name = "Instant Quantum Glove",
    Callback = function()
        getSpin("Quantum")
    end
})
Button = Tab:CreateButton({
    Name = "Instant Rainbow Carpet",
    Callback = function()
        getSpin("Carpet")
    end
})
Button = Tab:CreateButton({
    Name = "Instant Space Carpet",
    Callback = function()
        getSpin("Space")
    end
})
Button = Tab:CreateButton({
    Name = "Instant Rainbow Laser Gun",
    Callback = function()
        getSpin("Gun")
    end
})
Section = Tab:CreateSection("Gear")
Button = Tab:CreateButton({
    Name = "Instant Free OP Gear",
    Callback = function()
        getGear()
    end
})
local Tab2 = var7:CreateTab("Misc")
Tab = Tab2
Section = Tab2:CreateSection("Skip")
Button = Tab2:CreateButton({
    Name = "Skip Ahead (Tele)",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:PivotTo(workspace.TeleportUp.Prompt:GetPivot() * CFrame.new(0, 3, 0))
    end
})
Button = Tab2:CreateButton({
    Name = "Spawn Location (Tele)",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:PivotTo(workspace.Spawn:GetPivot() * CFrame.new(0, 3, 0))
    end
})
Section = Tab2:CreateSection("VIP")
Button = Tab2:CreateButton({
    Name = "Gold Coil (Tele)",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:PivotTo(workspace.FreeToolsOfTime.coil:GetPivot())
    end
})
Button = Tab2:CreateButton({
    Name = "Golden Glove (Tele)",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:PivotTo(workspace.FreeToolsOfTime.glove:GetPivot())
    end
})
Button = Tab2:CreateButton({
    Name = "Lion Morph (Tele)",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:PivotTo(workspace.MorphsFolder.Pad_Lion:GetPivot())
    end
})
Button = Tab2:CreateButton({
    Name = "Gold Women Morph (Tele)",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:PivotTo(workspace.MorphsFolder.Pad_GoldWoman:GetPivot())
    end
})
Section = Tab2:CreateSection("Glove")
Button = Tab2:CreateButton({
    Name = "Free Guard Glove (Tele)",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:PivotTo(workspace.PromptGuardGlove:GetPivot())
    end
})
local Tab3 = var7:CreateTab("Credits", 14848261712)
Tab = Tab3
Section = Tab3:CreateSection("Credits to: KhSaeedHub")
Button = Tab3:CreateButton({
    Name = "Scriptblox Profile",
    Callback = function()
        setclipboard("https://scriptblox.com/u/KhSaeed90")
        var3:Notify({
            Image = 14848261712,
            Duration = 5,
            Title = "Link is copied",
            Content = "Check scriptblox profile page for more Scripts!"
        })
    end
})
Button = Tab3:CreateButton({
    Name = "Discord Server",
    Callback = function()
        setclipboard("https://controlc.com/5572471c")
        var3:Notify({
            Image = 14848261712,
            Duration = 5,
            Title = "Link is copied",
            Content = "Join discord server for more Scripts!"
        })
    end
})
function getWin()
    game:GetService("ReplicatedStorage").RestartRemotes.Loader:FireServer(false)
end
function getCash()
    game:GetService("ReplicatedStorage").Spin_Remotes.QuintoPremio:FireServer()
end
function getSpin()
    game:GetService("ReplicatedStorage").CratesUtilities.Remotes.GiveReward:FireServer(Value)
end
function getGear()
    game:GetService("ReplicatedStorage").FreeGear_Remotes.FreeGearEvent:FireServer()
end
function getFrontman()
    game:GetService("ReplicatedStorage").Frontman_Remotes.morph:FireServer("ON")
end
function getKillAll()
    game:GetService("ReplicatedStorage").Frontman_Remotes.red:FireServer()
end