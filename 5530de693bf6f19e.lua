local Library = loadstring(Game:HttpGet('https://raw.githubusercontent.com/NoobHubV1/NoobHubV1/main/Wizard%20Lib.lua'))()
local Window = Library:NewWindow("Evade")
local Rstorage = game.ReplicatedStorage
local Players = game.Players
local plr = Players.LocalPlayer
local Main = Window:NewSection("Main")
local Instant = Window:NewSection("Instant")
local Esp = Window:NewSection("Esp")
local autoRespawn
local SavedPositions = {AutoRe = nil; OldCameraPos = nil}
local Camera = workspace.Camera
local instantRevive
local instantCarry
local autoRevive
local sent
local connection
local active

function SaveCamPos()
	SavedPositions.OldCameraPos = Camera.CFrame
end
function LoadCamPos()
	Camera.CFrame = SavedPositions.OldCameraPos or Camera.CFrame
end

function TP(cframe)
    plr.Character.HumanoidRootPart.CFrame = cframe
end

local function setupHUDListener(hud)
    if not hud then return end

    hud:GetPropertyChangedSignal("Visible"):Connect(function()
        if not hud.Visible and autoRespawn then
            SavedPositions.AutoRe = plr.Character:WaitForChild("HumanoidRootPart", 1) and plr.Character:FindFirstChild("HumanoidRootPart").CFrame; SaveCamPos(); sent = true
            Rstorage.Events.Player.ChangePlayerMode:FireServer(true)
        end
    end)
end

local function listenToShared(shared)
    if not shared then return end

    local hud = shared:FindFirstChild("HUD")
    if hud then
        setupHUDListener(hud)
    end

    shared.ChildAdded:Connect(function(child)
        if child.Name == "HUD" then
            setupHUDListener(child)
        end
    end)
end

local function listenToPlayerGui()
    local playerGui = plr:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local shared = playerGui:FindFirstChild("Shared")
    if shared then
        listenToShared(shared)
    end

    playerGui.ChildAdded:Connect(function(child)
        if child.Name == "Shared" then
            listenToShared(child)
        end
    end)
end
local function oncharadded()
	lochar = plr.Character or plr.CharacterAdded:Wait()
	if SavedPositions.AutoRe and autoRespawn and sent then
		local LRoot = lochar:WaitForChild("HumanoidRootPart", 1)
		if LRoot then
			LRoot.CFrame = SavedPositions.AutoRe; LoadCamPos(); LRoot.CFrame = SavedPositions.AutoRe; sent = false
			task.spawn(function()
				for i = 1, 5 do
					task.wait(); LRoot.CFrame = SavedPositions.AutoRe
				end
			end)
		end
	end
end
Main:CreateButton("Refresh", function()
     local tmp = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame; SavedPositions.AutoRe = tmp; SaveCamPos()
     Rstorage.Events.Player.ChangePlayerMode:FireServer(true)
     plr.CharacterAdded:Wait()
     TP(tmp)
     for i = 1,5 do
         task.wait(); TP(tmp)
     end; LoadCamPos()
end)
Instant:CreateToggle("Instant Revive", function(state)
     instantRevive = state
end)
Main:CreateToggle("Auto Respawn", function(state)
     autoRespawn = state
end)
Instant:CreateToggle("Instant Grab", function(state)
     instantCarry = state
end)
Main:CreateToggle("Auto Revive", function(state)
     autoRevive = state
end)
Esp:CreateToggle("Esp All", function(state)
     if state then
          active = true
          while task.wait() do
               if not active then
                    break
               end
               for i,v in ipairs(game.Players:GetPlayers()) do
                    if v ~= plr and not v.Character:FindFirstChild("esp") then
                         local highlight = Instance.new("Highlight", v.Character)
                         highlight.Name = "esp"
                         highlight.FillColor = Color3.fromRGB(0, 255, 0)
                         highlight.FillTransparency = 0.5
                         highlight.DepthMode = "AlwaysOnTop"
                    end
               end
          end
     else
          active = false; task.wait(.075)
          for i,v in ipairs(game.Players:GetPlayers()) do
               if v ~= plr then
                    for i,v in pairs(v.Character:GetChildren()) do
                         if v.Name == "esp" and v.ClassName == "Highlight" then
                              v:Destroy()
                         end
                    end
               end
          end
     end
end)
spawn(function()
     function task0()
          if instantRevive then
               for i,v in ipairs(game.Players:GetPlayers()) do
                    if v and v.Character then
                         if v.Character.Humanoid.Health == 0 and (plr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude <= 15 and v ~= plr then
                              Rstorage.Events.Character.Interact:FireServer("Revive", true, v.Name)
                         end
                    end
               end
          end
          if instantCarry then
               for i,v in ipairs(game.Players:GetPlayers()) do
                    if v and v.Character then
                         if v.Character.Humanoid.Health == 0 and (plr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude <= 15 and v ~= plr then
                              Rstorage.Events.Character.Interact:FireServer("Carry", true, v.Name)
                         end
                    end
               end
          end
          if autoRevive then
               for i,v in ipairs(game.Players:GetPlayers()) do
                    if v and v.Character and v.Character.HumanoidRootPart then
                         if v.Character.Humanoid.Health == 0 and v ~= plr then
                              plr.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.CFrame.p + Vector3.new(0, 8, 0))
                              Rstorage.Events.Character.Interact:FireServer("Revive", true, v.Name)
                         end
                    end
               end
          end
     end
     while task.wait() do
          task.spawn(task0)
     end
end)
listenToPlayerGui()
plr.CharacterAdded:Connect(oncharadded)