-- Load Rayfield Library local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Feature Toggles local KillAuraOn = false local InfStaminaOn = false local FlingBossOn = false

local Class = "Vortex" -- Change this to your current equipped class

-- Rayfield Window local Window = Rayfield:CreateWindow({ Name = "Skill Based Boss Fights V5.0", LoadingTitle = "Boss Fight Utility", LoadingSubtitle = "by XPCallFunction", ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "BossFightConfig" }, Discord = { Enabled = false }, KeySystem = false })

-- Tabs local MainTab = Window:CreateTab("KillAura") local CharTab = Window:CreateTab("Character") local TrollTab = Window:CreateTab("Troll") local CreditsTab = Window:CreateTab("Credits")

-- KillAura Buttons MainTab:CreateButton({ Name = "Start KillAura", Callback = function() KillAuraOn = true end })

MainTab:CreateButton({ Name = "Stop KillAura", Callback = function() KillAuraOn = false end })

-- Character Toggles CharTab:CreateToggle({ Name = "Infinite Stamina", CurrentValue = false, Callback = function(Value) InfStaminaOn = Value if not Value then game.Players.LocalPlayer.Energy.Value = 100 end end })

-- Troll Toggle TrollTab:CreateToggle({ Name = "Fling Boss", CurrentValue = false, Callback = function(Value) FlingBossOn = Value if not Value then for _, BAV in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do if BAV:IsA("BodyAngularVelocity") then BAV:Destroy() end end game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(472.48, 55.85, -13.65) + Vector3.new(0, 10, 0) end end })