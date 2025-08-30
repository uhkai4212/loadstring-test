local lib = loadstring(Game:HttpGet("https://raw.githubusercontent.com/NoobHubV1/NoobHubV1/main/Wizard%20Lib.lua"))()
local autoRespawn, autoKill, sent, sent2
local SavedPositions = {AutoRe = nil;}
local Connections = {Died = nil, CharacterAdded = nil, Stepped = nil}
local Camera = game:FindService("Workspace").CurrentCamera
local Rservice = game:GetService("RunService")
local Hbeat = Rservice.Heartbeat
local Rstep = Rservice.RenderStepped
local Stepped = Rservice.Stepped
local LocalPlayer = game.Players.localPlayer
local Window = lib:NewWindow("Hypershot")
local Main = Window:NewSection("Main")
local time
function LocTP(arg)
    LocalPlayer.Character.HumanoidRootPart.CFrame = arg
end
function SafeWait(timer)
    time = tick()
    repeat game.RunService.Stepped:Wait() until tick() - time >= timer
end
function SaveCamPos()
	SavedPositions.OldCameraPos = Camera.CFrame
end
function LoadCamPos()
	Rstep:Wait()
	Camera.CFrame = SavedPositions.OldCameraPos or Camera.CFrame
end
Main:CreateButton("Refresh", function()
    SavedPositions.AutoRe = LocalPlayer.Character.HumanoidRootPart.CFrame; sent2 = true
    SaveCamPos(); LocalPlayer.Character:BreakJoints(); SafeWait(0.2); game.ReplicatedStorage.Network.Remotes.Spawn:FireServer()
end)
Main:CreateToggle("Auto Respawn", function(state)
  autoRespawn = state
end)
Main:CreateToggle("Auto Kill", function(state)
  autoKill = state
  if autoKill then
    Connections.Stepped = Rstep:Connect(function()
      if LocalPlayer.Character:GetAttribute("Team") == 1 then
        for i,v in next, game.workspace:GetChildren() do
          if v:IsA("Model") and v ~= workspace:FindFirstChild(LocalPlayer.Name) then
            if v:GetAttribute("Team") == 2 then
              v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -9)
            end
          end
        end
      elseif LocalPlayer.Character:GetAttribute("Team") == 2 then
        for i,v in next, game.workspace:GetChildren() do
          if v:IsA("Model") and v ~= workspace:FindFirstChild(LocalPlayer.Name) then
            if v:GetAttribute("Team") == 1 then
              v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -9)
            end
          end
        end
      end
    end)
  else
    Connections.Stepped:Disconnect(); Connections.Stepped = nil
  end
end)
local lochar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local function ondiedevent()
	coroutine.wrap(function()
		Connections.Died:Disconnect(); SaveCamPos()
		SavedPositions.AutoRe = lochar:WaitForChild("HumanoidRootPart", 1) and LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame; sent = true
        if autoRespawn then
               SafeWait(0.2)
               game.ReplicatedStorage.Network.Remotes.Spawn:FireServer()
        end
	end)()
end
getfenv()["\112\114\105\110\116"]("\70\73\88\69\68\32\66\89\32\72\49\55\83\51") 
local function charaddtask()
	Connections.Died:Disconnect()
	local LHuman = lochar:WaitForChild("Humanoid", 1)
	if LHuman then
		Connections.Died = LHuman.Died:Connect(ondiedevent)
	end
end
local function oncharadded()
	lochar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	if SavedPositions.AutoRe and autoRespawn and sent then
		local LRoot = lochar:WaitForChild("HumanoidRootPart", 1)
		if LRoot then
			LRoot.CFrame = SavedPositions.AutoRe; LoadCamPos(); LRoot.CFrame = SavedPositions.AutoRe; sent = nil
			task.spawn(function()
				for i = 1, 4 do
					task.wait(); LRoot.CFrame = SavedPositions.AutoRe
				end
			end)
		end
	end
    if sent2 then
        local LRoot = lochar:WaitForChild("HumanoidRootPart", 1)
		if LRoot then
			LRoot.CFrame = SavedPositions.AutoRe; LoadCamPos(); LRoot.CFrame = SavedPositions.AutoRe; sent2 = nil
			task.spawn(function()
				for i = 1, 4 do
					task.wait(); LRoot.CFrame = SavedPositions.AutoRe
				end
			end)
		end
    end
	lochar:WaitForChild("Humanoid", 1):SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	lochar:WaitForChild("Humanoid", 1):SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    coroutine.wrap(charaddtask)()
end
Connections.Died = lochar:WaitForChild("Humanoid").Died:Connect(ondiedevent)
Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(oncharadded)