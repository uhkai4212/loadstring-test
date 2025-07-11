if patricknpcpanel then return end; patricknpcpanel = true

local load = loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/fe-source/refs/heads/main/NPC/module.Luau"))()

local g2l = load.G2L
local new = load.create()

local lighting = game:GetService("Lighting")
local tweenservice = game:GetService("TweenService")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local mouse = lp:GetMouse()

local fast = TweenInfo.new(.5, Enum.EasingStyle.Exponential)
local medium = TweenInfo.new(.67)
local slow = TweenInfo.new(.8)

local rad = 100
local currentnpc

local highlight = Instance.new("Highlight")
highlight.Parent = lp
highlight.FillTransparency = 1
highlight.OutlineTransparency = 1

local light = function(adornee, color)
	task.spawn(function()
		highlight.Adornee = adornee
		highlight.OutlineColor = color
		tweenservice:Create(highlight, medium, {OutlineTransparency  = 0}):Play()
		task.wait(.5)
		tweenservice:Create(highlight, medium, {OutlineTransparency  = 1}):Play()
	end)	
end

local isnpc = function(ins)
	local humanoid = ins:FindFirstChildOfClass("Humanoid")
	local player = plrs:GetPlayerFromCharacter(ins)

	if humanoid and not player then
		return ins 
	end

	return nil
end


new:mainbutton("kill npc", "instant kill the npc", function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and part.ReceiveAge == 0 then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(15)
			end
		else
			print("no part found")
		end
	end
end)

new:mainbutton("bring npc", "teleport the npc to your position", function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and part.ReceiveAge == 0 then
			if lp and lp.Character then
				local char = lp.Character
				currentnpc:PivotTo(char:GetPivot())
			end
		else
			print("no part found")
		end
	end
end)

new:mainbutton("goto npc", "teleport your character to npc position", function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part then
			if lp and lp.Character then
				local char = lp.Character
				char:PivotTo(currentnpc:GetPivot())
			end
		else
			print("no part found")
		end
	end
end)


local chr
new:maintoggle("control npc", "control npc/dummy until the npc loses network ownership", function(a)
	if a then
		if currentnpc then
			local part = currentnpc:FindFirstChild("HumanoidRootPart")
			if part and part.ReceiveAge == 0 then
				if lp and lp.Character then
					chr = lp.Character
					lp.Character = currentnpc
					ws.CurrentCamera.CameraSubject = currentnpc:FindFirstChild("HumanoidRootPart")
				end
			else
				print("no part found")
			end
		end
	else
		if chr then
			lp.Character = chr
			ws.CurrentCamera.CameraSubject = chr.Humanoid
			chr = nil
		end
	end
end)

new:mainbutton("punish npc", "make npc disappear into space", function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and part.ReceiveAge == 0 then
			if lp and lp.Character then
				local char = lp.Character
				currentnpc:PivotTo(CFrame.new(0, 1000, 0))
			end
		else
			print("no part found")
		end
	end
end)

new:mainbutton("npc sit state", "make npc in sitting position", function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and part.ReceiveAge == 0 then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.Sit = not hum.Sit
			end
		else
			print("no part found")
		end
	end
end)

new:mainbutton("npc jump state", "make npc jump", function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and part.ReceiveAge == 0 then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(3)
			end
		else
			print("no part found")
		end
	end
end)

local con, follownpc
follownpc = new:maintoggle("following npc", "make npc follow you", function(a)
	if a then
		con=rs.RenderStepped:Connect(function()
			if currentnpc then
				local part = currentnpc:FindFirstChild("HumanoidRootPart")
				if part and part.ReceiveAge == 0 then
					local hum = currentnpc:FindFirstChildOfClass("Humanoid")
					if hum then
						local hrp=lp.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							hum:MoveTo(hrp.Position + Vector3.new(-4,0,0))
						end
					end
				else
					if con then
						follownpc:swich(false)
						con:Disconnect()
					end
				end
			else
				if con then
					follownpc:swich(false)
					con:Disconnect()
				end
			end
		end)
	else
		if con then
			con:Disconnect()
		end
	end
end)


local con1
new:extratoggle("kill aura any npc", function(a)
	if a then
		con1 = rs.Stepped:Connect(function()
			for _, v in pairs(ws:GetDescendants()) do
				if v:IsA("Model") and isnpc(v) then
					local npc = isnpc(v)
					local hrp = npc:FindFirstChild("HumanoidRootPart")
					local hrp1 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

					if hrp and hrp1 and hrp.ReceiveAge == 0 and hrp.Anchored == false then
						local distance = (hrp.Position - hrp1.Position).Magnitude
						if distance < 13 and npc ~= lp.Character then
							local hum = npc:FindFirstChildOfClass("Humanoid")
							if hum then
								hum:ChangeState(15) 
							end
						end
					end
				end
			end
		end)
	else
		if con1 then
			con1:Disconnect()
			con1 = nil
		end
	end
end)



mouse.Button1Down:Connect(function()
	if clicknpc and mouse.Target and mouse.Target.Parent:FindFirstChild("HumanoidRootPart") then
		if mouse.Target.Parent:FindFirstChild("HumanoidRootPart").Anchored == false then
			if not plrs:GetPlayerFromCharacter(mouse.Target.Parent) then
				if mouse.Target.Parent:FindFirstChild("HumanoidRootPart").ReceiveAge == 0 then
					currentnpc = mouse.Target.Parent
					light(currentnpc, Color3.fromRGB(0, 255, 0))
				else
					light(mouse.Target.Parent, Color3.fromRGB(255, 0, 0))
				end
			end
		else
			light(mouse.Target.Parent, Color3.fromRGB(255, 0, 0))
		end
	end
end)

rs.RenderStepped:Connect(function()
	if sethiddenproperty then
		sethiddenproperty(lp,"SimulationRadius",rad)
	else
		lp.SimulationRadius=rad
	end
end)


return g2l, require;