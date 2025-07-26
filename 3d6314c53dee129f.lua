AutoUpdate = true

}

local UserSettings = {

	TeleportMethod = "Tween" -- or Instant


}

local MaxCropDis = 30




local FloatRender
local FloatPart
local UseFloat = false

local Float_Part = Instance.new('Part')
Float_Part.Name = "floatName"
Float_Part.Parent = game.Players.LocalPlayer.Character
Float_Part.Transparency = 1
Float_Part.Size = Vector3.new(2,0.2,1.5)
Float_Part.Anchored = true
FloatPart = Float_Part
FloatRender = game:GetService("RunService").RenderStepped:Connect(function()
	if UseFloat == true then
		Float_Part.CanCollide = true
		Float_Part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-3.1,0) 
	else
		Float_Part.CanCollide = false
	end
end)

function MiniTpBlocks(Model,position)

	if Model then
		for i,v in pairs(Model:GetDescendants()) do
			if v:IsA("Part") or v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end

	local function MiniTpV2(position)

		Model:SetPrimaryPartCFrame(CFrame.new(position))

	end

	local myPart = Model.PrimaryPart
	local targetPosition = position
	local minDistance = 3 -- Minimum distance to target to trigger teleport
	local maxIterations = 3 -- Maximum number of iterations to allow with no progress

	DebugCheck(0,"Initial Position: " .. tostring(myPart.Position))
	DebugCheck(0,"Target Position: " .. tostring(targetPosition))

	local prevDistance = (myPart.Position - targetPosition).magnitude
	local noProgressCount = 0
	while (myPart.Position - targetPosition).magnitude > minDistance do
		local offset = targetPosition - myPart.Position
		local distance = offset.Magnitude

		local step
		local waitTime
		step = Vector3.new(3, 3, 3)
		waitTime = 0

		local direction = offset.Unit
		local steps = math.ceil(distance / step.Magnitude)
		local newStep = offset / steps

		local progress = false
		for i = 1, steps do
			local newPos = myPart.Position + newStep * i
			if newPos.X > targetPosition.X and newStep.X > 0 then
				newStep = Vector3.new(0, newStep.Y, newStep.Z)
			elseif newPos.X < targetPosition.X and newStep.X < 0 then 
				newStep = Vector3.new(0, newStep.Y, newStep.Z) 
			end 
			if newPos.Y > targetPosition.Y and newStep.Y > 0 then 
				newStep = Vector3.new(newStep.X, 0, newStep.Z) 
			elseif newPos.Y < targetPosition.Y and newStep.Y < 0 then 
				newStep = Vector3.new(newStep.X, 0, newStep.Z) 
			end 
			if newPos.Z > targetPosition.Z and newStep.Z > 0 then 
				newStep = Vector3.new(newStep.X, newStep.Y, 0) 
			elseif newPos.Z < targetPosition.Z and newStep.Z < 0 then 
				newStep = Vector3.new(newStep.X, newStep.Y, 0) 
			end 
			newPos = myPart.Position + newStep
			MiniTpV2(newPos)
			DebugCheck(0,"Current Position: " .. tostring(myPart.Position))
			DebugCheck(0,"In radius!") -- Ausgabe, wenn der Spieler innerhalb des Radius ist
			wait(waitTime)
			local currDistance = (myPart.Position - targetPosition).magnitude
			if currDistance >= prevDistance then
				noProgressCount = noProgressCount + 1
			else
				prevDistance = currDistance
				noProgressCount = 0
				progress = true
			end
			if noProgressCount >= maxIterations then
				DebugCheck(0,"Stuck! Breaking out of loop...")
				break
			end
		end
		if not progress then
			DebugCheck(0,"Stuck! Breaking out of loop...")
			break
		end
	end

	--[[

		-- Teleport to target position if close enough
	if (myPart.Position - targetPosition).magnitude <= minDistance then
		MiniTpV2(targetPosition)
	end

	DebugCheck(0,"Final Position: " .. tostring(myPart.Position))
	DebugCheck(0,"Reached Target Position!")
	FloatRender:Disconnect()
	FloatPart:Destroy()

	]]
end


function MiniTp(position)
	UseFloat = true
	local function MiniTpV2(position)
		local player = game:GetService("Players").LocalPlayer
		local character = player.Character
		if character and character.PrimaryPart then
			character:SetPrimaryPartCFrame(CFrame.new(position))
		end
	end

	local myPart = game.Players.LocalPlayer.Character.HumanoidRootPart
	local targetPosition = position
	local minDistance = 3 -- Minimum distance to target to trigger teleport
	local maxIterations = 3 -- Maximum number of iterations to allow with no progress

	DebugCheck(0,"Initial Position: " .. tostring(myPart.Position))
	DebugCheck(0,"Target Position: " .. tostring(targetPosition))

	local prevDistance = (myPart.Position - targetPosition).magnitude
	local noProgressCount = 0
	while (myPart.Position - targetPosition).magnitude > minDistance do
		local offset = targetPosition - myPart.Position
		local distance = offset.Magnitude

		local step
		local waitTime
		if distance <= 50 then
			step = Vector3.new(1, 2, 1)
			waitTime = 0.04
		elseif distance <= 30 then
			step = Vector3.new(1, 2, 1)
			waitTime = 0.005
		else
			step = Vector3.new(2.5, 4.5, 2.5)
			waitTime = 0.20
		end

		local direction = offset.Unit
		local steps = math.ceil(distance / step.Magnitude)
		local newStep = offset / steps

		local progress = false
		for i = 1, steps do
			local newPos = myPart.Position + newStep * i
			if newPos.X > targetPosition.X and newStep.X > 0 then
				newStep = Vector3.new(0, newStep.Y, newStep.Z)
			elseif newPos.X < targetPosition.X and newStep.X < 0 then 
				newStep = Vector3.new(0, newStep.Y, newStep.Z) 
			end 
			if newPos.Y > targetPosition.Y and newStep.Y > 0 then 
				newStep = Vector3.new(newStep.X, 0, newStep.Z) 
			elseif newPos.Y < targetPosition.Y and newStep.Y < 0 then 
				newStep = Vector3.new(newStep.X, 0, newStep.Z) 
			end 
			if newPos.Z > targetPosition.Z and newStep.Z > 0 then 
				newStep = Vector3.new(newStep.X, newStep.Y, 0) 
			elseif newPos.Z < targetPosition.Z and newStep.Z < 0 then 
				newStep = Vector3.new(newStep.X, newStep.Y, 0) 
			end 
			newPos = myPart.Position + newStep
			MiniTpV2(newPos)
			DebugCheck(0,"Current Position: " .. tostring(myPart.Position))
			DebugCheck(0,"In radius!") -- Ausgabe, wenn der Spieler innerhalb des Radius ist
			wait(waitTime)
			local currDistance = (myPart.Position - targetPosition).magnitude
			if currDistance >= prevDistance then
				noProgressCount = noProgressCount + 1
			else
				prevDistance = currDistance
				noProgressCount = 0
				progress = true
			end
			if noProgressCount >= maxIterations then
				DebugCheck(0,"Stuck! Breaking out of loop...")
				break
			end
		end
		if not progress then
			DebugCheck(0,"Stuck! Breaking out of loop...")
			break
		end
	end
	-- Teleport to target position if close enough
	if (myPart.Position - targetPosition).magnitude <= minDistance then
		MiniTpV2(targetPosition)
	end

	DebugCheck(0,"Final Position: " .. tostring(myPart.Position))
	DebugCheck(0,"Reached Target Position!")
	UseFloat = false
end

local function erstellePart(position)
	local part = Instance.new("Part")
	part.Position = position
	part.Anchored = true
	part.Size = Vector3.new(1, 1, 1)
	part.BrickColor = BrickColor.new("Bright red")
	part.Parent = game.Workspace
	part.CanCollide = false
	part.Transparency = 0.65

	task.spawn(function()
		task.wait(10)
		part:Destroy()
	end)

end

local function followPathV2(destination)

	local PathfindingService = game:GetService("PathfindingService")
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")


	local player = Players.LocalPlayer
	local character = player.Character
	local humanoid = character:WaitForChild("Humanoid")
	local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

	local path = PathfindingService:CreatePath()

	local GoodAndFinished = false

	-- Compute the path
	local success, errorMessage = pcall(function()
		path:ComputeAsync(character.PrimaryPart.Position, destination)
	end)

	if success and path.Status == Enum.PathStatus.Success then
		-- Get the path waypoints
		waypoints = path:GetWaypoints()

		-- Detect if path becomes blocked
		blockedConnection = path.Blocked:Connect(function(blockedWaypointIndex)
			-- Check if the obstacle is further down the path
			if blockedWaypointIndex >= nextWaypointIndex then
				-- Stop detecting path blockage until path is re-computed
				blockedConnection:Disconnect()
				-- Call function to re-compute new path
				followPath(destination)
			end
		end)

		-- Detect when movement to next waypoint is complete
		if not reachedConnection then
			reachedConnection = humanoid.MoveToFinished:Connect(function(reached)
				if reached and nextWaypointIndex < #waypoints then
					-- Increase waypoint index and move to next waypoint
					nextWaypointIndex = nextWaypointIndex + 1
					humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
				else
					reachedConnection:Disconnect()
					blockedConnection:Disconnect()
				end
			end)
		end

		-- Initially move to second waypoint (first waypoint is path start; skip it)
		if GoodAndFinished == true then return nil end
		nextWaypointIndex = 2
		for i = 1,#waypoints do
			erstellePart(waypoints[i].Position + Vector3.new(0,2,0))
		end

		for i = 1,#waypoints do
			HumanoidRootPart.CFrame = CFrame.new(waypoints[i].Position + Vector3.new(0,2,0))
			task.wait(0.2) -- 0.1
		end

		task.wait(2)

		GoodAndFinished = true

		return true

	else
		warn("Path not computed!", errorMessage)
		local tpservice= game:GetService("TeleportService")
		local plr = game.Players.LocalPlayer
		task.wait(1)
		--tpservice:Teleport(game.PlaceId, plr)
		return errorMessage
	end
end

local TeleportV4Wait = false
function TeleportV4(Position)

	local ISARENDER = nil

	--[[

	if LASTTWEEN == nil then
		warn("Tween ist nil!")
	else
		LASTTWEEN:Cancel()
	end

	]]

	if Position ~= nil then
		--[[

	if typeof(Position)=="Vector3" then
		local dist=(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-Position).Magnitude
		if dist < 3 then
			game.Players.LocalPlayer.Character:MoveTo(Position)
			task.wait()
			return nil
		end
	end

		]]
		if _G.TeleportMethod == "Tween" then
			TweenTp(Position)
			task.wait()
			return true
		elseif _G.TeleportMethod == "TweenV2" then	

			if typeof(Position)=="Vector3" then
				if Position.Y then
					local HUM = game.Players.LocalPlayer.Character.HumanoidRootPart
					game.Players.LocalPlayer.Character:MoveTo(Vector3.new(HUM.Position.X, Position.Y, HUM.Position.Z))
				end
			end

			local dist=(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position-Position).Magnitude
			tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(dist/30, Enum.EasingStyle.Linear)
			local ALRE = true
			tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(Position)})
			CROPTWEEN22 = tween
			LASTTWEEN = tween
			tween:Play()

			task.wait()
			return true
		elseif _G.TeleportMethod == "TweenV3" then	
			local PartToMove = game.Players.LocalPlayer.Character.HumanoidRootPart
			local TargetPos = CFrame.new(Position)
			local Dis = (PartToMove.Position - Vector3.new(TargetPos.X, TargetPos.Y, TargetPos.Z)).Magnitude
			local _speed = 15

			local Completed = false
			if Dis < 30 then
				_speed = 15
			end

			if Dis < 10 then
				_speed = 20
			end


			_speed = _speed


			local TimeToRun = TweenInfo.new(Dis/_speed)

			local WhatToChange = {
				CFrame = TargetPos
			} -- sets CFrame to localplayers position + 30 on the Y axis (brings you upwards)
			-- to limit the player and to not allow them to move, you can uncomment anchored below


			function Noclip(V)
				if V == true then
					V = false
				else
					V = true
				end
				for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if child:IsA("BasePart") and child.CanCollide == true then
						child.CanCollide = V
					end
				end
			end

			function DoAfter()
				PartToMove.Anchored = false
				Noclip(false)
				Completed = true
			end



			local tween = game:GetService("TweenService"):Create(PartToMove, TimeToRun, WhatToChange)
			CROPTWEEN22 = tween
			LASTTWEEN = tween
			Noclip(true)
			task.spawn(function()
				repeat 
					task.wait()
					game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(PartToMove.Position.X, TargetPos.Y, PartToMove.Position.Z))

				until Completed == true
			end)
			tween:Play()
			tween.Completed:Connect(DoAfter)

		elseif _G.TeleportMethod == "Instant" then
			UseFloat = true
			game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(Position)
			FloatRender:Disconnect()
			FloatPart:Destroy()
			task.spawn(function()
				task.wait(0.2)
				UseFloat = false
			end)
			return true
		elseif _G.TeleportMethod == "MiniTp" then
			if TeleportV4Wait == false then
				TeleportV4Wait = true
				MiniTp(Position)
				task.wait()
				TeleportV4Wait = false
				FloatRender:Disconnect()
				FloatPart:Destroy()
				task.wait()
				return true
			end
		elseif _G.TeleportMethod == "Pathfinding" then
			local PART = Instance.new("Part")
			PART.CFrame = CFrame.new(Position)
			PART.Anchored = true
			PART.Transparency = 1
			PathFindingSystem(PART)
			return true
		elseif _G.TeleportMethod == "PathfindingV2" then
			followPathV2(Position)
			return true
		elseif _G.TeleportMethod == "Bypass" then
			ISARENDER = game:GetService("RunService").RenderStepped:Connect(function()
				for i = 1,5 do
					wait(0.1)
					task.spawn(function()
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Position)
					end)
				end
			end)
		end
	else
		warn("Position ist nil!")
	end

	if ISARENDER then
		task.wait(5)
		ISARENDER:Disconnect()
	end

end
-- Tables --

local currentDate = os.date("*t")
local month = currentDate.month
local day = currentDate.day

local holidayMessage = ""

if month == 12 and day == 25 then
	holidayMessage = "🎄"
elseif month == 10 and day == 31 then
	holidayMessage = "🎃"
elseif month == 12 and day == 31 then
	holidayMessage = "🎆"
else
	holidayMessage = ""
end



local Window 
local Tabs


if DeveloperVersion == false then
	if DidKey == true then
		Window = Fluent:CreateWindow({
			Title = "Islands.God "..ScriptVersion.." [FREE!] "..holidayMessage,
			SubTitle = "by NtOpenProcess and soldo_io", -- neverloseyoursmile_88
			TabWidth = 160,
			Size = UDim2.fromOffset(580, 460),
			Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
			Theme = "Dark",
			MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
		})

		Tabs = {
			Main = Window:AddTab({ Title = "Main", Icon = "sword" }),
			Teleports = Window:AddTab({ Title = "Teleports", Icon = "bus" }),
			BlockPrinter = Window:AddTab({ Title = "Block Printer", Icon = "printer" }),
			Player = Window:AddTab({ Title = "Player", Icon = "PlayerIcon" }),
			VendingSniper = Window:AddTab({ Title = "Vending Sniper", Icon = "file-search" }),
			BypassFun = Window:AddTab({ Title = "Bypass.Fun", Icon = "server" }),
			Other = Window:AddTab({ Title = "Other", Icon = "sidebar" }),
			Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
			Premium = Window:AddTab({ Title = "Premium", Icon = "star" })
		}

	else

		Window = Fluent:CreateWindow({
			Title = "Islands.God "..ScriptVersion.." [Premium!] "..holidayMessage,
			SubTitle = "by NtOpenProcess and soldo_io", -- neverloseyoursmile_88
			TabWidth = 160,
			Size = UDim2.fromOffset(580, 460),
			Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
			Theme = "Dark",
			MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
		})

		Tabs = {
			Main = Window:AddTab({ Title = "Main", Icon = "sword" }),
			Teleports = Window:AddTab({ Title = "Teleports", Icon = "bus" }),
			BlockPrinter = Window:AddTab({ Title = "Block Printer", Icon = "printer" }),
			Player = Window:AddTab({ Title = "Player", Icon = "PlayerIcon" }),
			VendingSniper = Window:AddTab({ Title = "Vending Sniper", Icon = "file-search" }),
			BypassFun = Window:AddTab({ Title = "Bypass.Fun", Icon = "server" }),
			Other = Window:AddTab({ Title = "Other", Icon = "sidebar" }),
			Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
		}
	end
else
	Window = Fluent:CreateWindow({
		Title = "Islands.God "..ScriptVersion.." [Developer!] "..holidayMessage,
		SubTitle = "by NtOpenprocess and soldo_io", -- neverloseyoursmile_88
		TabWidth = 160,
		Size = UDim2.fromOffset(580, 460),
		Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
	})

	Tabs = {
		Main = Window:AddTab({ Title = "Main", Icon = "sword" }),
		Teleports = Window:AddTab({ Title = "Teleports", Icon = "bus" }),
		BlockPrinter = Window:AddTab({ Title = "Block Printer", Icon = "printer" }),
		Player = Window:AddTab({ Title = "Player", Icon = "PlayerIcon" }),
		VendingSniper = Window:AddTab({ Title = "Vending Sniper", Icon = "file-search" }),
		BypassFun = Window:AddTab({ Title = "Bypass.Fun", Icon = "server" }),
		Other = Window:AddTab({ Title = "Other", Icon = "sidebar" }),
		Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
		DeveloperTab = Window:AddTab({ Title = "Dev", Icon = "" }),
	}
end 


local Options = Fluent.Options

if DidKey == true then 

	local H = Tabs.Premium:AddParagraph({
		Title = "Why Premium?",
		Content = "with Premium you Get Faster&Beta Updates!"
	})

	local H = Tabs.Premium:AddParagraph({
		Title = "How to buy?",
		Content = "Join discord.gg/MbsxuDEzgT and open a ticket."
	})

	local H = Tabs.Premium:AddParagraph({
		Title = "What Payment Methods?",
		Content = "You can buy the Script with:\n1.Paypal\n2.Robux"
	})

	local H = Tabs.Premium:AddParagraph({
		Title = "How much does it cost?",
		Content = "1.Paypal: 2$\n2.Robux:800R$"
	})

	local H = Tabs.Premium:AddParagraph({
		Title = "Why do you wait?",
		Content = "Go buy Premium!"
	})

	Tabs.Premium:AddButton({
		Title = "Copy Server Invite",
		Description = "",
		Callback = function()
			setclipboard("discord.gg/MbsxuDEzgT")
		end
	})

end


-- // functions \\ --

IYMouse = game.Players.LocalPlayer:GetMouse()
Players = game.Players
iyflyspeed = 1
function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end


function sFLY(vfly)
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	T = Players.LocalPlayer.Character.HumanoidRootPart
	CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R =  (iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = iyflyspeed*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -iyflyspeed*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end



function Hash()
	local HttpService = game:GetService("HttpService")
	local Abd = HttpService:GenerateGUID(false)..HttpService:GenerateGUID(false)..HttpService:GenerateGUID(false)
	return Abd
end

local _WAIT = false
function TweenTp(...)

	local _speed=_G.TweenFlySpeed or 30

	local TFS = SettingsTable

	if not game.Players.LocalPlayer.Character then return end
	if _WAIT == false then
		_WAIT = true

		if TFS.TweenFly == true then
			sFLY(true)
		end


		if TFS.Twennnoclip == true then
			for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end
		end

		local plr=game.Players.LocalPlayer
		local args={...}
		if typeof(args[1])=="number"and args[2]and args[3]then
			args=Vector3.new(args[1],args[2],args[3])
		elseif typeof(args[1])=="Vector3" then
			args=args[1]    
		elseif typeof(args[1])=="CFrame" then
			args=args[1].Position
		end
		if plr.Character:FindFirstChild("HumanoidRootPart") then

			local dist=(plr.Character:FindFirstChild("HumanoidRootPart").Position-args).Magnitude

			--[[

			if dist > 100 then
				if TFS.TweenFast == true then
					_speed = math.random(25,30)
				end
			end


			]]


			local Tween = game:GetService("TweenService"):Create(
			plr.Character.HumanoidRootPart,
			TweenInfo.new(dist/_speed,Enum.EasingStyle.Linear),
			{CFrame=CFrame.new(args)}
			)

			CROPTWEEN22 = Tween
			LASTTWEEN = Tween
			Tween:Play()
			Tween.Completed:Connect(function()
				_WAIT = false
				if TFS.PlayerFly == false then
					NOFLY()
				end
				if TFS.Twennnoclip == true then
					for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if child:IsA("BasePart") and child.CanCollide == false and child.Name ~= floatName then
							child.CanCollide = true
						end
					end
				end
				return true
			end)
			return Tween
		end
	end
end

function PathFindingSystem(dest)
	local serv = game:GetService("PathfindingService")
	local human = game.Players.LocalPlayer.Character.Humanoid 
	local body = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or game.Players.LocalPlayer.Character:FindFirstChild("Torso")
	if dest == nil then return end
	if dest:IsA("Part") then else DebugCheck(0,"Fehler kein Part!") end
	local path = serv:CreatePath()
	path:ComputeAsync(body.Position,dest.Position)
	if path.Status == Enum.PathStatus.Success then
		local wayPoints = path:GetWaypoints()
		for i = 1,#wayPoints do
			local point = wayPoints[i]
			human:MoveTo(point.Position)
			local success = human.MoveToFinished:Wait()
			if point.Action == Enum.PathWaypointAction.Jump then
				human.WalkSpeed = 0
				wait(0.2)
				human.WalkSpeed = 16
				human.Jump = true
			end
			if not success then
				human.Jump = true
				human:MoveTo(point.Position)
				if not human.MoveToFinished:Wait() then
					break
				end
			end
		end
	end
end

function ChestAura()
	for i,Chest in pairs(GetIsland():FindFirstChild("Blocks"):GetChildren()) do
		if Chest:FindFirstChild("Contents") then
			for i,Tool in pairs(Chest:FindFirstChild("Contents"):GetChildren()) do
				local args = {
					[1] = {
						["chest"] = Chest,
						["player_tracking_category"] = "join_from_web",
						["amount"] = Tool:FindFirstChild("Amount").Value,
						["tool"] = Tool,
						["action"] = "withdraw"
					}
				}

				game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("CLIENT_CHEST_TRANSACTION"):InvokeServer(unpack(args))

			end
		end
	end
	task.wait()
end

function GetTreeName(TreeArt)
	_G.ZahlenTree = false
	_G.OakSelected = false
	if TreeArt == "all" then
		return "tree"
	elseif TreeArt == "Oak" then
		_G.OakSelected = true
		return "tree"
	elseif TreeArt == "Birch" then
		return "treeBirch"
	elseif TreeArt == "Maple" then
		return "treeMaple"
	elseif TreeArt == "Pine" then
		return "treePine"
	elseif TreeArt == "Hickory" then
		return "treeHickory"
	elseif TreeArt == "Spirit" then
		_G.ZahlenTree = true
		return "treeSpirit"
	end
end


function IsSynapse()
	if (syn) then
		return true
	else
		return false
	end
end


function GetIsland()
	local FOUND = false
	local islandName
	local _________Inseln = game:GetService("Workspace").Islands:GetChildren()
	for i = 1, #_________Inseln do
		if _________Inseln[i]:FindFirstChild("Owners"):FindFirstChild(_G.Island_USERID) then
			islandName = _________Inseln[i]
			FOUND = true
			return islandName
		end
	end 
	task.wait()
	if not FOUND then
		return game:GetService("Workspace").Islands:FindFirstChildWhichIsA("Model")
	end
end


function OwnISland()
	local islandName = GetIsland()
	local args = {
		[1] = {
			["island"] = islandName
		}
	}
	if islandName and islandName ~= nil then
		game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_VISIT_ISLAND_REQUEST:InvokeServer(unpack(args))
	end
end

local SAVEDBlocksPos = {}

function GetBlockUpdate()
	local Island = GetIsland()
	if Island then
		local Blocks = Island:FindFirstChild("Blocks")

		for i,v in pairs(Blocks:GetChildren()) do
			if v:IsA("Part") or v:IsA("MeshPart") then
				table.insert(SAVEDBlocksPos, v)
			end
		end 
	end
end

GetBlockUpdate()

function GetBlock(Name, Pos)


	if SAVEDBlocksPos == {} or SAVEDBlocksPos == nil then
		GetBlockUpdate()
	end

	local Island = GetIsland()
	local Blocks = Island:FindFirstChild("Blocks")
	if not Blocks then return nil end

	for i,v in ipairs(SAVEDBlocksPos) do
		if v:FindFirstChild("Health") then
			if Name == false then
				if v.Position == Pos then
					return v
				end
			else
				if v.Name == Name then
					if v.Position == Pos then
						return v
					end
				end
			end
		end
	end
end

function GetBlocks(position, size, Part)

	local mainPart

	if Part then

		mainPart = Part

	else
		local position = position or Vector3.new(0,0, 0) -- Ersetzen Sie die Position nach Bedarf
		local halfSize = size or Vector3.new(0,0,0) -- Regiongröße von 10x10x10


		-- Erstellen eines Parts und Platzierung innerhalb der Region
		mainPart = Instance.new("Part")
		mainPart.Size = halfSize
		mainPart.CFrame = CFrame.new(position)
		mainPart.Anchored = true
		mainPart.Parent = workspace
		mainPart.Transparency = 0.5
		mainPart.CanCollide = false

		-- Erstellen einer SelectionBox und Platzierung um die Region

		print("Erstellen einer SelectionBox und Platzierung um die Region")

		local selectionBox = Instance.new("SelectionBox")
		selectionBox.Adornee = mainPart
		selectionBox.LineThickness = 0.1
		selectionBox.Color3 = Color3.new(1, 0, 0)
		selectionBox.Transparency = 0.5
		selectionBox.Parent = mainPart

	end


	local FoundBlocks  = {}

	-- Drucken der Blöcke innerhalb der Region mit ihren Namen
	local blockCount = 0
	for _, part in pairs(workspace:GetPartsInPart(mainPart)) do
		blockCount = blockCount + 1
		DebugCheck(0,"Block", blockCount, "Name:", part.Name, "Position:", part.Position)
		table.insert(FoundBlocks, part)
	end
	return FoundBlocks
end

function GetMobName(Mob)
	if Mob == "Slime" then
		return "slime"
	end
end

function Message(Title1, Context1, ButtonText1, DurationTime)
	Fluent:Notify({
		Title = Title1,
		Content = Context1,
		Duration = DurationTime
	})
end



local RemoteMobCooldown = false
game:GetService("RunService").RenderStepped:Connect(function()
	if _G.MobRemoteSpamming == true then
		local MOB = _G.MobRemoteSpammingSelectedMob
		local args = {
			[1] = Hash(),
			[2] = {
				[1] = {
					["direction"] = Vector3.new(0,-90,0), -- MOB:FindFirstChild("HumanoidRootPart").Position
					["shootType"] = 0,
					["acaanSbvNqmvUwqyaPbPdbs"] = "\7\240\159\164\163\240\159\164\161\7\n\7\n\7\niDtnsvjyuiGm",
					["spellBook"] = game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"),
					["charge"] = 1,
					["time"] = game.Workspace.DistributedGameTime
				}
			}
		}


		if RemoteMobCooldown == false then
			RemoteMobCooldown = true
			game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild("kthdgIcgPfwv/tyTrpdkeydznlntEvsjocmEixLw"):FireServer(unpack(args))
			task.wait()
			RemoteMobCooldown = false
		end
	end
end)



function DoubleFarmMob(V)
	DebugCheck(0,"DoubleFarmMob")
	local SelectedMob
	local ISAMOB = false
	for i,v in pairs(_G.SelectedMobs) do
		task.wait()
		if game:GetService("Workspace").WildernessIsland.Entities:FindFirstChild(v) then
			if ISAMOB == false then 
				ISAMOB = true
				SelectedMob = game:GetService("Workspace").WildernessIsland.Entities:FindFirstChild(v)
				DebugCheck(0,SelectedMob.Name)
			end
		end
	end

	if SelectedMob ~= nil and SelectedMob then

		local YVALUE = _G.MobTpYPos

		if SelectedMob:FindFirstChild("HumanoidRootPart") == nil then SelectedMob:Destroy() return end


		TeleportV4(SelectedMob:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,YVALUE,0))


		for i = 1,3 do
			if SelectedMob then
				if SelectedMob:FindFirstChild("HumanoidRootPart") then

					TeleportV4(SelectedMob:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,YVALUE,0))


					if CANUSEAUTOCLICKER == true then
						if _G.MobBookFarm == true then
							_G.MobRemoteSpammingSelectedMob = SelectedMob
							_G.MobRemoteSpamming = true
						else

							game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
							task.wait()
							game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
						end
					end
					if _G.MobBookFarm == false then 
						if 	SelectedMob:FindFirstChild("HumanoidRootPart") then
							--[[
														if SelectedMob:FindFirstChild("Humanoid") then
								SelectedMob:FindFirstChild("Humanoid"):Destroy()
							end
							]]
							--SelectedMob:FindFirstChild("HumanoidRootPart").Size = Vector3.new(8,YVALUE+4,8)
							--SelectedMob:FindFirstChild("HumanoidRootPart").CanCollide = false
						end
					end
					task.wait()
				end
			end
		end
	end
end



local MOBSWORDBYPASSED = false
local ANTIBANMOB = false

local ANTICONSOLEWARNLOGANIMATION = false

local LastMob = nil

game:GetService("RunService").RenderStepped:Connect(function()
	if _G.AutoFarm == true or _G.BossAutoFarm == true then	
		if LastMob and LastMob:FindFirstChild("Humanoid") and LastMob:FindFirstChild("Humanoid").Health > 0 and LastMob:FindFirstChild("HumanoidRootPart") then
			local YVALUE = _G.MobTpYPos
			TeleportV4(LastMob:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,YVALUE,0))
		end
	end
end)

function FarmMob(V)

	print("FarmMob:",V)

	local function findNearestMob(A)
		local closestPart = nil
		local closestDistance = math.huge
		local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

		local Table = A

		for i, part in ipairs(Table) do
			local distance = (part:FindFirstChild("HumanoidRootPart").Position - playerPosition).magnitude
			if distance < closestDistance then
				closestPart = part
				closestDistance = distance
			end
		end

		DebugCheck(0,"findNearestPart")

		return closestPart
	end

	if _G.AutoFarm == false and _G.BossAutoFarm == false then return nil end
	DebugCheck(0,"FarmMob")
	local SelectedMob

	local MobsToScan = {}
	if V == true then
		SelectedMob = game:GetService("Workspace").WildernessIsland.Entities:FindFirstChild(_G.SelectedBoss)
	else


		for i,v in pairs(game:GetService("Workspace").WildernessIsland.Entities:GetChildren()) do
			if v and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
				print("HUMANOID/ROOTAPRT")
				if type(_G.SelectedMob) == "table" then
					for i,x in pairs(_G.SelectedMob) do
						if v.Name == x then
							print("ADDED!",v.Name)
							table.insert(MobsToScan, v)
						else
							print("x ist:",x.." Mob heißt:",v)
						end
					end
				else
					if v.Name == _G.SelectedMob then
						print("ADDED!",v.Name)
						table.insert(MobsToScan, v)
					else
						print(v.Name)
					end
				end
			end
		end

		SelectedMob = findNearestMob(MobsToScan)
		print("NEWMOB:",SelectedMob)
	end
	if SelectedMob ~= nil and SelectedMob then

		LastMob = SelectedMob

		print(0,"Farm Mob:", SelectedMob.Name)

		local YVALUE = _G.MobTpYPos

		task.spawn(function()
			TeleportV4(SelectedMob:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,YVALUE,0))
		end)
		print(0,"MOB FARM ON TOP!")

		if MOBSWORDBYPASSED == false then
			if _G.ragebladeMobFarm == true then

				local success, result = pcall(function()
					local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua"))()

					local Tool = game:GetService("Players").LocalPlayer.Character:FindFirstChild("rageblade")
					if Tool then
						local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua"))()

						local scriptPath = Tool:FindFirstChild("rageblade")
						local closureName = "Unnamed function"
						local upvalueIndex = 1
						local closureConstants = {
							[1] = "isHitting",
							[2] = "getLivingEntityFromChildPart",
							[3] = "attemptHit"
						}
						print("scriptPath:",scriptPath)


						local closure = aux.searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
						local value = 0
						local elementIndex = "lastClicked"

						game:GetService("RunService").RenderStepped:Connect(function()
							debug.getupvalue(closure, upvalueIndex)[elementIndex] = value
						end)

					end
					-- Generated by Hydroxide's Upvalue Scanner: https://github.com/Upbolt/Hydroxide



					local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua"))()

					local Tool = game:GetService("Players").LocalPlayer.Character:FindFirstChild("rageblade")
					if Tool then
						local scriptPath = Tool:FindFirstChild("rageblade")
						local closureName = "Unnamed function"
						local upvalueIndex = 1
						local closureConstants = {
							[1] = "isHitting",
							[2] = "getLivingEntityFromChildPart",
							[3] = "attemptHit"
						}

						local closure = aux.searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
						local value = 4
						local elementIndex = "speed"


						debug.getupvalue(closure, upvalueIndex)[elementIndex] = value
						MOBSWORDBYPASSED = true
					end
				end)
			end
		end

		for i = 1,1 do
			if _G.AutoFarm == false and _G.BossAutoFarm == false then return end
			if SelectedMob then
				if SelectedMob:FindFirstChild("HumanoidRootPart") then

					TeleportV4(SelectedMob:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,YVALUE,0))


					if CANUSEAUTOCLICKER == true then
						if _G.MobBookFarm == true then
							_G.MobRemoteSpammingSelectedMob = SelectedMob
							_G.MobRemoteSpamming = true
						else

							--if ANTIBANMOB == false then
							--	ANTIBANMOB = true

							task.spawn(function()
								if ANTICONSOLEWARNLOGANIMATION == false then
									ANTICONSOLEWARNLOGANIMATION = true
									for i,v in pairs(game:GetService('Players'):GetChildren()) do
										if v and v.Character and v.Character:FindFirstChild("Humanoid") then
											Player = v.Name
											AnimationId = "5328169716"
											local Anim = Instance.new("Animation")
											Anim.AnimationId = "rbxassetid://"..AnimationId
											local k = game.Players[Player].Character.Humanoid:LoadAnimation(Anim)
											k:Play() --Play the animation
											k:AdjustSpeed(0)
											task.spawn(function()
												task.wait(8)
												Anim:Destroy()
											end)	
												--[[

												if _G.MobFarmAnimationBypass == true then
													k:AdjustSpeed(0)
												else
													k:AdjustSpeed(1)
												end

												]]
										end
									end
									task.wait(1)
									ANTICONSOLEWARNLOGANIMATION = false
								end
							end)

								--[[

								game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
								game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)

								]]

							task.wait(0.5)

							local args = {
								[1] = Hash(),
								[2] = {
									[1] = {
										[MotHitH1] = MotHitH2,
										["hitUnit"] = SelectedMob
									}
								}
							}

							if  _G.ragebladeMobFarm == true  then
								for i = 1,50 do
									game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("KillRemote").Value):FireServer(unpack(args))
									task.wait()
								end
							else
								for i = 1,5 do
									game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("KillRemote").Value):FireServer(unpack(args))
									task.wait(0.3)
								end
							end

							--ANTIBANMOB = false
							--end
						end

					end
				end
			end
		end
	else
		print("No SelectedMob!")
	end
end

function GetProxNameFromBoss(BossName)
	if BossName == "slimeKing" then
		return "slime_king_spawn"
	elseif BossName == "slimeQueen" then
		return "slime_queen_spawn"
	elseif BossName == "desertBoss" then
		return "desert_boss_spawn"
	elseif BossName == "golem" then
		return "golem_spawn"
	end 
end


function SpawnBoss(BossName)
	if BossName then
		local PProx = game:GetService("Workspace").spawnPrefabs.WildEventTriggers:FindFirstChild(BossName)
		if PProx then
			local RealProx = PProx:FindFirstChild("ProximityPrompt")
			if RealProx then
				TeleportV4(PProx.Position)
				fireproximityprompt(RealProx)
			end 
		end
	end
end

local BossCheckCOOLDOWN = false
function BossCheck(BossName)
	if BossCheckCOOLDOWN == false then
		BossCheckCOOLDOWN = true
		local SelectedMob = game:GetService("Workspace").WildernessIsland.Entities:FindFirstChild(BossName)
		if SelectedMob then
			FarmMob(true)
		else 
			if _G.BossAutoSpawn == true then
				SpawnBoss(GetProxNameFromBoss(BossName))
			else
				print("Auto Spawn ist off, ich warte dann mal ^^")
			end
		end
		task.wait(0.1)
		BossCheckCOOLDOWN = false
	end
end

local CropAntiLag = false
function CropFarm(TP)
	if CropAntiLag == false then
		CropAntiLag = true

		local Island = GetIsland() 
		local Blocks = Island:FindFirstChild("Blocks") 

		local ToFarm = {}
		local ReplaceCFrame = {}

		local Count = 1

		local CC = 0


		for i,v in pairs(Blocks:GetChildren()) do
			if v.Name == _G.SelectedCrop then
				local dis = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

				local MAXDIS = _G.SichleCropRange or 30

				if dis < MAXDIS then
					--table.insert(ToFarm, v) -- add the light
					CC = CC +1
					ToFarm[CC] = v
					ReplaceCFrame[CC] = v.CFrame
				end
			end
		end



		if TP == true then
			if Blocks:FindFirstChild(_G.SelectedCrop) then
				local A =  Blocks:FindFirstChild(_G.SelectedCrop)
				TeleportV4(A.Position)
				task.wait(0.5)
			end
		end

		for i,v in pairs(ToFarm) do

			local H1 = RemoteData:FindFirstChild("CropHashData").Value
			local H2 = _G.CropHash

			local ohTable1 = {
				[H1] = H2,
				["player"] = game:GetService("Players").LocalPlayer,
				["model"] = ToFarm[Count]
			}


			task.wait()
			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_HARVEST_CROP_REQUEST:InvokeServer(ohTable1)
			Count = Count + 1
		end


		task.wait()

		for i,v in ipairs(ReplaceCFrame) do		



			local ohTable1 = {
				["upperBlock"] = false,
				["cframe"] = v,
				["blockType"] = "wheat",
				[PlaceHASHName] = CropPlaceH2
			}

			if _G.AutoReplaceCrop == true then
				game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(ohTable1)
			end

			v = nil
		end


	end
	task.wait(5)
	CropAntiLag = false
end

local AutoCollectFruitsCooldown = false
function AutoCollectFruits()
	if AutoCollectFruitsCooldown == false then
		AutoCollectFruitsCooldown = true
		local Island = GetIsland()
		for i,v in pairs(Island:FindFirstChild("Blocks"):GetChildren()) do
			if v:FindFirstChild("FruitLocations") then
				for i,v in pairs(v:FindFirstChild("FruitLocations"):GetChildren()) do
					if v:IsA("Part") then
						if v:FindFirstChild("Targettable") then
							if v:FindFirstChildWhichIsA("Tool") then
								local dis = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								if dis < 30 then
									local args = {
										[1] = {
											["tool"] = v:FindFirstChildWhichIsA("Tool"),
											[PickupH1] = PickupH2
										}
									}

									game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer(unpack(args))

								else
									repeat TeleportV4(v.Position)
										local args = {
											[1] = {
												["tool"] = v:FindFirstChildWhichIsA("Tool"),
												[PickupH1] = PickupH2
											}
										}

										game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer(unpack(args))

										task.wait(1)
									until v:FindFirstChildWhichIsA("Tool") == nil
								end
							end
						end
					end
				end
			end
		end
		task.wait()
		AutoCollectFruitsCooldown = false
	end
end

local FishFarmCooldown = false
function FishFarm()
	local dis = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-91, 29, -897)).Magnitude

	if dis > 30 then
		TeleportV4(Vector3.new(-91, 34, -897))
		repeat wait() until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-91, 29, -897)).Magnitude < 5
		task.wait(0.5)
	end 

	if FishFarmCooldown == false then
		FishFarmCooldown = true
		local args = {
			[1] = Hash(),
			[2] = {
				[1] = {
					["playerLocation"] = Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position),
					["direction"] = Vector3.new(-0.9983646869659424, -9.509330567425422e-08, 0.057165950536727905),
					["strength"] = math.random(0.5, 2)
				}
			}
		}

		game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("AngelRemote").Value):FireServer(unpack(args))

		task.wait(math.random(13,15))
		local args = {
			[1] = {
				["success"] = true
			}
		}
		game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("FishFarmFinishRemote").Value):FireServer(unpack(args))

	--[[

		local args = {
		[1] = Hash(),
		[2] = {
			[1] = {}
		}
	}
	
	game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild("jmqvFcP/dgikodtTfngoBWdtu"):FireServer(unpack(args))
	

	]]

		if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Jump = true
		end 
		task.wait(math.random(0.1,0.3))
		FishFarmCooldown = false
	end
end	

-- Funktion zum Finden des nächsten Teils
local function findNearestPart(A)
	local closestPart = nil
	local closestDistance = math.huge
	local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

	local Table = A

	for i, part in ipairs(Table) do
		local distance = (part.Position - playerPosition).magnitude
		if distance < closestDistance then
			closestPart = part
			closestDistance = distance
		end
	end

	DebugCheck(0,"findNearestPart")

	return closestPart
end

local AutoCollectTotemItemsCooldown = false
function AutoCollectTotemItems()
	if _G.AutoCollectTotemItems == true then
		if AutoCollectTotemItemsCooldown == false then
			AutoCollectTotemItemsCooldown = true
			local Island = GetIsland()
			if Island and Island:FindFirstChild("Blocks") then

				local Totems = {}



				for i,v in pairs(Island:FindFirstChild("Blocks"):GetChildren()) do

					local Items = v:FindFirstChild("WorkerContents") 
					if Items and Items:FindFirstChildWhichIsA("Tool") then
						if v.Name == _G.SelectedTotem then
							table.insert(Totems, v)
						end

					end
				end

				local Totem = findNearestPart(Totems)

				if Totem then
					local v = Totem
					TeleportV4(v.Position)
					repeat wait() until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude < 3
					repeat
						for i,v in pairs(v:FindFirstChild("WorkerContents"):GetChildren()) do
							local args = {
								[1] = {
									["tool"] = v,
									[PickupH1] = PickupH2
								}
							}

							game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer(unpack(args))
							task.wait()
						end	
						task.wait(0.3)
					until v:FindFirstChild("WorkerContents") == nil or v:FindFirstChild("WorkerContents"):FindFirstChildWhichIsA("Tool") == nil
					task.wait(1)
				end

			end
		end 
		task.wait(2)
		AutoCollectTotemItemsCooldown = false
	end
end


local TFCO = false
local RemoteAntiBan = false
function TreeFarm(TP)	

	local NE = {}

	if TFCO == true then return nil end

	TFCO = true

	if TP == true then
		DebugCheck(0,"TreeFarm (true)")
	else
		DebugCheck(0,"Tree Farm (false)")
	end


	if _G.SelectedTree == "all" then
		_G.SelectedTree = "tree"
	else
	end

	if _G.SelectedTree == "Oak" then
		DebugCheck(0,"IST OAK!!!")
	end

	DebugCheck(0,"JOA")
	DebugCheck(0,_G.SelectedTree)

	-- Funktion zum Finden des nächsten Teils
	local function findNearestPart(A)
		local closestPart = nil
		local closestDistance = math.huge
		local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

		local Table = A

		for i, part in ipairs(Table) do
			local distance = (part.Position - playerPosition).magnitude
			if distance < closestDistance then
				closestPart = part
				closestDistance = distance
			end
		end

		DebugCheck(0,"findNearestPart")

		return closestPart
	end

	local distance = 35000
	for i,v in pairs(GetIsland().Blocks:GetChildren()) do 

		local Art = string.sub(v.Name:lower(), 1, string.len(_G.SelectedTree)) 
		--if (Art == _G.SelectedTree) then 
		if string.match(v.Name, _G.SelectedTree) then
			if 	_G.OakSelected == true  then
				DebugCheck(0,"isTreeWithNumber")
				local isTreeWithNumber = string.match(v.Name, "^tree%d+$")
				DebugCheck(0,"ADD22???",v.name)
				if isTreeWithNumber then
					DebugCheck(0,"ADD22",v.name)
					table.insert(NE, v)
				end
			elseif _G.ZahlenTree == true then
				local isTreeWithNumber = string.match(v.Name, "^".._G.SelectedTree.."%d+$")
				if isTreeWithNumber then
					DebugCheck(0,"ADD35",v.name)
					table.insert(NE, v)
				end
			else

				DebugCheck(0,"ADD",v.name)
				table.insert(NE, v)
			end
		end
		-- end
	end	


	local v = findNearestPart(NE)

	DebugCheck(0,v)

	if v then

		local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude

		if mag < distance then 

			if _G.TreeAutoFarm == false and _G.TreeAura == false then return end


		--[[

				if TP == true then
			task.spawn(function()
				TeleportV4(v.Position + Vector3.new(0,0,6))
			end)
		end

		]]
			local T = v

			local H1 = RemoteData:FindFirstChild("TreeHashData").Value
			local H2 = _G.TreeHash

			local TFOUND = v:FindFirstChild("trunk") or v:FindFirstChildWhichIsA("MeshPart")

			local args1 = {
				[H1] = H2,
				["part"] = TFOUND,
				["block"] = v,
				["norm"] = Vector3.new(v.CFrame),
				["pos"] = v.Position
			}


			if v == nil then TFCO = false return end
			if TFOUND == nil then TFCO = false return end



		--[[

		if TP == true then
			task.spawn(function()
			TeleportV4(v.Position + Vector3.new(0,0,6))
			end)
		end

		]]

			if v == nil then TFCO = false return end
			if TFOUND == nil then TFCO = false return end

			while TFOUND do
				if v then
					task.wait()
					for i = 1,10 do
						if v ~= nil then
							if _G.TreeAutoFarm == false and _G.TreeAura == false then TFCO = false return end
							if not v or v == nil then TFCO = false return end
							if not TFOUND then TFCO = false return end
							task.wait()
							if RemoteAntiBan == false then
								RemoteAntiBan = true
								if TP == true then
									TeleportV4(v.Position + Vector3.new(0,0,6))
									task.wait()
								end
								game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(args1)
								-- task.wait()
								if v:FindFirstChild("trunk") or v:FindFirstChildWhichIsA("MeshPart") then
								else
									TFOUND = nil
								end
								RemoteAntiBan = false
							end
						end
					end
				else
					task.wait(0.2)
					TFCO = false
					break
				end 
			end
		else
			OwnISland()
		end	 

	end

	task.wait(0.8)

	TFCO = false

end


function ROCKHELPER_1()
	local ohTable1 = {
		[HitHASHName] = HitHASH,
		["part"] =    _G.Now_Rock_part,
		["block"] =  _G.Now_Rock_block,
		["norm"] =   _G.Now_Rock_norm,
		["pos"] = _G.Now_Rock_pos,
	}

	for i = 1,1 do
		if _G.Now_Rock_part then
			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("BlockRemote").Value):InvokeServer(ohTable1)
		end
	end
end

local IslandRockFarmCOOLDOWN = false
function IslandRockFarm(RockArt)
	if IslandRockFarmCOOLDOWN == false then
		IslandRockFarmCOOLDOWN = true
		print("IslandRockFarm")
		-- if _G.RockFarmonIsland ~= true then return nil end
		local function findNearestRock(A)
			local closestPart = nil
			local closestDistance = math.huge
			local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

			local Table = A

			for i, part in ipairs(Table) do
				task.wait()
				local distance = (part.Position - playerPosition).magnitude
				if distance < closestDistance then
					closestPart = part
					closestDistance = distance
				end
			end

			return closestPart
		end


		local Island = GetIsland()
		local Blocks = Island:FindFirstChild("Blocks")

		local RocksSaved = {}

		if type(RockArt) == "table" then
			for i,v in pairs(Blocks:GetChildren()) do

				function removeRock(itemName)
					task.wait()
					local index = string.find(itemName, "rock")
					if index ~= nil then
						return string.sub(itemName, 1, index - 1) .. string.sub(itemName, index + 4)
					else
						return itemName
					end
				end	

				local Name = removeRock(v.Name)

				local isALL = false

				if RockArt == "All" or table.find(RockArt,"All") then

					task.wait()

					if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart") then

						task.wait()

						table.insert(RocksSaved, v)

						isALL = true

					end

				end

				if table.find(RockArt,Name) and isALL == false then

					task.wait()

					if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart") then

						task.wait()

						table.insert(RocksSaved, v)

					end

				end
			end
		else
			if RockArt == "All"then
				for i,v in pairs(Blocks:GetChildren()) do
					if v:FindFirstChild("1") then

						if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart") then

							if _G.RockFarmonIsland ~= true then return nil end

							table.insert(RocksSaved, v)

						end

					end
				end
			else
				for i,v in pairs(Blocks:GetChildren()) do
					if v.Name == RockArt then

						if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart") then

							if _G.RockFarmonIsland ~= true then return nil end

							table.insert(RocksSaved, v)

						end

					end
				end
			end
		end

		print("HOL DEN BLOCK!!!")

		local v = findNearestRock(RocksSaved)

		if v then

			print("V gefunden!!!", v.Name)

			-- if _G.RockFarmonIsland ~= true then return nil end

			local dis = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude

			print("DISTANCE")

			if dis > 20 then
				print("YES")
				if v then
					TeleportV4(v.Position)
					repeat wait() until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude < 20
					task.wait()
					local ohTable1 = {
						[HitHASHName] = HitHASH,
						["part"] = v:FindFirstChild("1") or v,
						["block"] = v,
						["norm"] = Vector3.new(v.CFrame),
						["pos"] = v.Position
					}
					game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("BlockRemote").Value):InvokeServer(ohTable1)
				else
					v = nil 
				end
			else
				print("NOPE")
				if v then
					print("Es gibt v schicke remote")
					local ohTable1 = {
						[HitHASHName] = HitHASH,
						["part"] = v:FindFirstChild("1") or v,
						["block"] = v,
						["norm"] = Vector3.new(v.CFrame),
						["pos"] = v.Position
					}
					game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("BlockRemote").Value):InvokeServer(ohTable1)
				else
					v = nil
				end
			end

		else
			warn("Kein Block!!!")
		end

	end

	task.wait(1)

	print("WAIT 1 ist UM!!!")

	IslandRockFarmCOOLDOWN = false

end

local RF = false 
function RockFarm(RockArt, T)

	if RF == false then
		RF = true

		if _G.RockFarmonIsland == true then
			IslandRockFarm(RockArt)
			time.sleep(1)
			RF = false
			return 
		end



		local NowName = RockArt
		local Rocks = {}

		local function findNearestRock(A)
			local closestPart = nil
			local closestDistance = math.huge
			local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

			local Table = A

			for i, part in ipairs(Table) do
				local distance = (part.Position - playerPosition).magnitude
				if distance < closestDistance then
					closestPart = part
					closestDistance = distance
				end
			end

			DebugCheck(0,"findNearestPart")

			return closestPart
		end

		function IsInTable(Table, NameToCheck)
			task.wait()
			if NameToCheck and Table then
				if type(Table) == "table" then
					if table.find(Table, NameToCheck) then
						return true
					else
						return false
					end
				else
					if type(Table) == "string" then
						if Table == NameToCheck then
							return true
						else
							return false
						end
					end
				end
			else
				if NameToCheck == nil then
					print("NameToCheck is nil")
				end
				if Table == nil then
					print("Table is nil")
				end
				return false

			end
		end

		if T == "T" then
			for i,v in pairs(game:GetService("Workspace").WildernessBlocks:GetChildren()) do

				function removeRock(itemName)
					local index = string.find(itemName, "rock")
					if index ~= nil then
						return string.sub(itemName, 1, index - 1) .. string.sub(itemName, index + 4)
					else
						return itemName
					end
				end			

				local Name = removeRock(v.Name)


				if RockArt == "All" or table.find(RockArt, "All")  then
					table.insert(Rocks, v)
				else
					if table.find(RockArt, Name) then
						table.insert(Rocks, v)
					end
				end
			end

		else
			if RockArt == "All" then
				for i,v in pairs(game:GetService("Workspace").WildernessBlocks:GetChildren()) do
					table.insert(Rocks, v)
				end
			else
				for i,v in pairs(game:GetService("Workspace").WildernessBlocks:GetChildren()) do
					if v.Name == RockArt then
						table.insert(Rocks, v)
					end
				end
			end
		end


		local Rock = findNearestRock(Rocks)

		if not Rock then RF = false return end

		if Rock then
			if Rock.Position and Rock:FindFirstChild("0") or Rock:FindFirstChild("1") then

				TeleportV4(Rock.Position)

				repeat wait()

					TeleportV4(Rock.Position)

					local ohTable1 = {
						[HitHASHName] = HitHASH,
						["part"] = Rock:FindFirstChild("0") or Rock:FindFirstChild("1"),
						["block"] = Rock,
						["norm"] = Vector3.new(Rock.CFrame),
						["pos"] = Vector3.new(Rock:FindFirstChild("0").Position) or Vector3.new(Rock:FindFirstChild("1").Position)
					}

					game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("BlockRemote").Value):InvokeServer(ohTable1)	


				until Rock == nil or Rock:FindFirstChild("0") == nil or Rock:FindFirstChild("1") == nil

				RF = false

			end
		end

		RF = false

	end

end

function RockFarmV2(RockArt, b1,b2,b3)
	print("1. RockArt:",RockArt)
	if type(RockArt) == "table" then
		-- print("IST EIN TABLE!!!")
		if table.find(RockArt, "All") then
			print("ALL!!!")
			RockFarm("All", "T")
		else
			RockFarm(RockArt, "T")
		end
	else
		if RockArt == "All" then
			RockFarm("All") 
		elseif RockArt == "Iron" then
			RockFarm("rockIron") 
		elseif RockArt == "Gold" then
			RockFarm("rockGold")
		elseif RockArt == "Diamond" then
			RockFarm("rockDiamond")
		elseif RockArt == "Amethyst Stone" then
			RockFarm("rockAmethystStone")
		elseif RockArt == "Amethyst" then
			RockFarm("rockAmethyst")
		elseif RockArt == "Obsidian" then
			RockFarm("rockObsidian")
		elseif RockArt == "Opal" then
			RockFarm("rockOpal")
		elseif RockArt == "Copper" then
			RockFarm("rockCopper")
		elseif RockArt == "Diorite" then
			RockFarm("rockDiorite")
		elseif RockArt == "Coal" then
			RockFarm("rockCoal")
		elseif RockArt == "Stone" then
			RockFarm("rockStone")
		elseif RockArt == "Electrite" then
			RockFarm("rockElectrite")
		else
			function removeRock(itemName)
				local index = string.find(itemName, "rock")
				if index ~= nil then
					return string.sub(itemName, 1, index - 1) .. string.sub(itemName, index + 4)
				else
					return itemName
				end
			end	
			RockFarm(removeRock(RockArt));
		end
	end
end

function RockAura()

	local ToBreak = {}
	local Count = 1

	for i,v in pairs(game:GetService("Workspace").WildernessBlocks:GetChildren()) do 
		local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude

		if mag < 30 then
			ToBreak[Count] = v 
			Count = Count + 1
		end

	end

	-- game:GetService("Workspace").WildernessBlocks

	for i,v in pairs(ToBreak) do

		local args0 = {
			[1] = {
				[HitHASHName] = HitHASH,
				["part"] = v:FindFirstChild("1"),
				["block"] = v,
				["norm"] = Vector3.new(v.CFrame),
				["pos"] = v:FindFirstChild("1").Position
			}
		}

		local args1 = {
			[1] = {
				[HitHASHName] = HitHASH,
				["part"] = v:FindFirstChild("1"),
				["block"] = v,
				["norm"] = Vector3.new(v.CFrame),
				["pos"] = v:FindFirstChild("1").Position
			}
		}

		if v:FindFirstChild("1") then
			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(unpack(args1))
		elseif v:FindFirstChild("0") then
			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(unpack(args0))
		else
			DebugCheck(0,"Fehler!")
		end
	end

		--[[
	for i,v in pairs(game:GetService("Workspace").WildernessBlocks:GetChildren()) do 

			if v:IsA("Part") then DebugCheck(0,"RICHTIG!") else DebugCheck(0,"FALSCH") return nil end

			local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude

			if mag > 30 then DebugCheck(0,"ZU WEIT WEG!") return end

			DebugCheck(0,v.Name)

			if not v then DebugCheck(0,"v not found!") return end
			if not v:FindFirstChild("1") then DebugCheck(0,"1 nicht gefunden!") return end

			local args = {
				[1] = {
					["player_tracking_category"] = "join_from_web",
					["part"] = v:FindFirstChild("1"),
					["block"] = v,
					["norm"] = Vector3.new(v.CFrame),
					["pos"] = Vector3.new(v:FindFirstChild("1").Position)
				}
			}

			if mag < 30 then
				if not v then return end
				if not v:FindFirstChild("1") then return end
				game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(unpack(args))
				task.wait()
		end
	end
	--]]

end

-- AURA --

local F

if game:FindFirstChild("CROPBETA") == nil then
	local C = Instance.new("Folder")
	C.Parent = game
	C.Name = "CROPBETA"
	F = C
else
	F = game:FindFirstChild("CROPBETA") 
end

task.wait()

function Set(POS)
	if F ~= nil then
		local A = Instance.new("ObjectValue")
		A.Value = POS
		A.Parent = F
	else
		game.Players.LocalPlayer:Kick("Error Please Reexecute!")
	end
end


function GetIsland()
	local islandName
	local _________Inseln = game:GetService("Workspace").Islands:GetChildren()
	for i = 1, #_________Inseln do
		if _________Inseln[i]:FindFirstChild("Owners"):FindFirstChild(_G.Island_USERID) then
			islandName = _________Inseln[i]
			return islandName
		end
	end 
end


local KILLAURA_COOLDOWN = false
function KillAuraOLD()
	if KILLAURA_COOLDOWN == false then
		KILLAURA_COOLDOWN = true
		local YVALUE = _G.MobTpYPos
		if workspace:FindFirstChild("WildernessIsland"):FindFirstChild("Entities") then
			local CHILDEN = workspace:FindFirstChild("WildernessIsland"):FindFirstChild("Entities"):GetChildren()
			for i = 1,#CHILDEN do

				if _G.ragebladeMobFarm == true then
					DebugCheck(0,"ragebladeMobFarm")
					local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua"))()

					local Tool = game:GetService("Players").LocalPlayer.Character:FindFirstChild("rageblade")
					if Tool then
						local scriptPath = Tool:FindFirstChild("rageblade") -- Hier ist der error von Gestern.
						local closureName = "Unnamed function"
						local upvalueIndex = 1
						local closureConstants = {
							[1] = "isHitting",
							[2] = "getLivingEntityFromChildPart",
							[3] = "attemptHit"
						}

						local closure = aux.searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
						local value = 0
						local elementIndex = "lastClicked"