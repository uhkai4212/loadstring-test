-- maybe if i'm not lazy then i will start to make my own
		if debug.traceback():find("Taser") and configs.combat.silentaim.enabled and configs.combat.silentaim.includetaser then
			local character = client.getNearestToCursor() and client.getNearestToCursor().Character
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			if hrp then
				return hrp, hrp.Position, hrp.Position, ... -- not doing args table thing cuz that didn't work for some reason (skill issue tbh)
			end
		end
		return client.ori.rayignore(...)
	end)

	client.raycast.RayIgnoreNonCollide = (function(...)
		local args = {...}
		if configs.vehicle.driveonwater and debug.traceback():find("AlexChassis") then
			args[6] = true
		end
		return client.ori.rayignorenon(unpack(args))
	end)

	client.gamepasssystem.doesPlayerOwnCached = (function(...)
		local args = {...}
		if configs.combat.pistolswat and tostring(args[1]) == game:GetService("Players").LocalPlayer.Name and debug.traceback():find("tem.Pistol") then
			return true
		end
		return client.ori.doesplayerowncached(...)
	end)

	client.gunutil.getEquipTime = (function(...)
		return configs.combat.noequipt and 0 or client.ori.getequiptime(...)
	end)

	client.circleac.Update = (function(...) -- who knows if this is better
		local mymom = ...
		pcall(function()
			client.ori.update(mymom)
			if configs.player.nocircwait then
				client.circleac.Spec.PressedAt = 0.01
			end
		end)
	end)

	client.paraglide.IsFlying = (function(...)
		return configs.player.nosky and debug.traceback():find("Falling") and true or client.ori.isflying(...)
	end)

	client.vehiclelinkbinder._constructor._updateSeeking = (function(ropedata)
		client.ropedata = ropedata
		return client.ori.updateseeking(ropedata)
	end)

	game:GetService("Players").LocalPlayer:GetMouse().Move:Connect(function()
		local Mouse = game:GetService"UserInputService":GetMouseLocation()
		Circle.Position = Vector2.new(Mouse.X, Mouse.Y)
	end)
    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
        local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if hrp then
            if configs.player.nofall then 
                hrp:AddTag("NoFallDamage")
			end
            if configs.player.norag then
                hrp:AddTag("NoRagdoll")
            end
        end
    end)
	game:GetService("UserInputService").JumpRequest:Connect(function()
		if configs.player.infjump then
			game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end)
	game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(mama)
		if mama.Name == "LoadingBarGui" then
			if client.ropedata.nearestObj ~= nil then
				if configs.vehicle.instanttow and client.ropedata.obj.Name == "MetalHook" then
					client.hookNearestObj()
				elseif configs.vehicle.helipick and client.ropedata.obj.Name == "RopePull" then
					client.hookNearestObj()
				end
			end
			print("wow mama is exist in playergui!@!!!!") -- idk what happened here 
		end
	end)
	game.Lighting.ChildAdded:connect(function(mama)
		if configs.combat.snipernoblur and mama.Name == "Blur" then
			mama:GetPropertyChangedSignal("Size"):connect(function()
				mama.Enabled = false
			end)
		end
	end)
	client.onvehicleentered:Connect(function(arg1)
		client.vehicleEntered = true
		if arg1.Model ~= client.lastvehiclemodel and arg1.Type == "Chassis" then
			client.lastvehiclemodel = arg1.Model
			--table.clear(client.lastvehiclestats)
			client.lastvehiclestats.GarageEngineSpeed = arg1.GarageEngineSpeed
			client.lastvehiclestats.TurnSpeed = arg1.TurnSpeed
			client.lastvehiclestats.Height = arg1.Height
			print("changed")
		end
		if configs.vehicle.ftog then
			client.launchVehicleFlight()
		end
		if arg1.Type == "Heli" then
			arg1.MaxHeight = configs.vehicle.heliheight and 9e9 or 400
			arg1.FallOutOfSkyDuration = configs.vehicle.helibreak and 0 or 10
			arg1.DisableDuration = configs.vehicle.helibreak and 0 or 10
		elseif arg1.Type == "Chassis" then
			arg1.TirePopDuration = configs.vehicle.nopop and 0 or 7.5
			arg1.DisableDuration = configs.vehicle.nopop and 0 or 7.5
			arg1.TirePopProportion = configs.vehicle.nopop and 0 or 0.5
		end
	end)
	client.onvehicleexited:Connect(function()
		client.vehicleEntered = false
	end)
	client.onlocalitemequipped:Connect(function(equippeddata) 
		--client.originalequippeddata = equippeddata
		local getdata = client.getOldWeaponData
		local a = client.itemsys.GetLocalEquipped()
		if a.FakeName ~= "Sniper" then
			a.FakeName = "Sniper"
		end
		task.spawn(function()
			client.onHitSurfaceHook()
		end)
		if getdata(a.__ClassName, "EquipTime") ~= nil then -- just realized that this shit didn't do anything 😑
			a.Config.EquipTime = configs.combat.noequipt and 0 or getdata(a.__ClassName, "EquipTime")
		end
		if getdata(a.__ClassName, "FireAuto") ~= nil then
			a.Config.FireAuto = configs.combat.alwaysauto and true or getdata(a.__ClassName, "FireAuto") 
		end
		if getdata(a.__ClassName, "BulletSpread") ~= nil then
			a.Config.BulletSpread = configs.combat.nospread and 0 or getdata(a.__ClassName, "BulletSpread")
		end
		if getdata(a.__ClassName, "CamShakeMagnitude") ~= nil then
			a.Config.CamShakeMagnitude = configs.combat.norecoil and 0 or getdata(a.__ClassName, "CamShakeMagnitude")
		end
		if a.__ClassName == "Taser" and getdata(a.__ClassName, "ReloadTimeHit") ~= nil and getdata(a.__ClassName, "ReloadTime") ~= nil then
			a.Config.ReloadTimeHit = configs.combat.tasermodz and 0 or getdata(a.__ClassName, "ReloadTimeHit")
			a.Config.ReloadTime = configs.combat.tasermodz and 0 or getdata(a.__ClassName, "ReloadTime")
		end
		if a and a.BulletEmitter and a.BulletEmitter.GravityVector then
			a.BulletEmitter.GravityVector = configs.combat.nobulletg and nil or Vector3.new(0, -workspace.Gravity / 10, 0)
		end
	end)

	task.spawn(function()
		while true do task.wait()
			pcall(function()
				local humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid or nil
				local gvp = require(game:GetService("ReplicatedStorage").Vehicle.VehicleUtils).GetLocalVehiclePacket() or nil
				if humanoid ~= nil and gvp ~= nil and client.vehicleEntered then
					if gvp.Type == "Chassis" then
						if configs.vehicle.engine then
							gvp.GarageEngineSpeed = configs.vehicle.enginesp
						end
						-- if configs.vehicle.brake then
						-- 	gvp.GarageBrakes = configs.vehicle.brakesp
						-- end
						if configs.vehicle.suspension then
							gvp.Height = configs.vehicle.suspensionhe
						end
						if configs.vehicle.turn then
							gvp.TurnSpeed = configs.vehicle.turnsp
						end
					end
				end
			end)
		end
	end)
end)


local FolderName = "Jailbreak secret dev tool"
local FileName = FolderName.."\\configs.json"


local ui =eleriumremake.SetupUI("bru what", function() end)

local page = ui.NewPage("Players")

-- // Character
local sec = page.NewSection("Character")
sec.NewSlider("Walkspeed", 0, 10, 5, configs.player.walkval, function(a)
	configs.player.walkval = a
end)
sec.NewToggle("Enable Walkspeed", function(a)
	configs.player.walktog = a
end, configs.player.walktog)
sec.NewToggle("Inf Jump", function(a)
	configs.player.infjump = a
end, configs.player.infjump)

-- // Utilities
local sec = page.NewSection("Utilities")
sec.NewToggle("Automatic Escape(BETA)", function(a)
	configs.player.autoescape = a
end, configs.player.autoescape)
sec.NewToggle("No Ragdoll", function(a)
	configs.player.norag = a
	local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart") or nil
	if configs.player.norag == false and hrp ~= nil then
		hrp:RemoveTag("NoRagdoll")
	elseif configs.player.norag == true and hrp ~= nil then
		hrp:AddTag("NoRagdoll")
	end
end, configs.player.norag)
sec.NewToggle("No Fall Injury", function(a)
	configs.player.nofall = a
	local hrp = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart") or nil
	if configs.player.nofall == false and hrp ~= nil then
		hrp:RemoveTag("NoFallDamage")
	elseif configs.player.nofall == true and hrp ~= nil then
		hrp:AddTag("NoFallDamage")
	end
end, configs.player.nofall)
sec.NewToggle("No Skydive", function(a)
	configs.player.nosky = a
end, configs.player.nosky)
sec.NewToggle("No Ragdoll Stun", function(a)
	configs.player.nostun = a
	client.settingss.Time.Stunned = configs.player.nostun and 0 or 5
	setupvalue(client.stunnedragdoll, 1, configs.player.nostun and nil)
end, configs.player.nostun)

-- sec.NewToggle("No Punch Wait", function(a) 
-- 	configs.player.nopwait = a
-- end, false)
sec.NewToggle("No Roll Wait", function(a)
	configs.player.norwait = a
	client.activeaction.roll.useEvery = configs.player.norwait and 0 or 5
end, configs.player.norwait)
sec.NewToggle("No Crawling Slow", function(a)
	configs.player.nocslow = a
	setconstant(client.walkspeedfun, 16, configs.player.nocslow and 1 or 0.4)
end, configs.player.nocslow)
sec.NewToggle("No Circle Hold", function(a)
	configs.player.nocircwait = a
	--setconstant(client.circleac.Press, 3, a and "yousuck" or "Timed")
end, configs.player.nocircwait)
sec.NewToggle("No Injury Slow", function(a)
	configs.player.noislow = a
	setconstant(client.walkspeedfun, 8, configs.player.noislow and 1 or 0.5)
end, configs.player.noislow)
sec.NewToggle("No Spotlight Slow", function(a)
	configs.player.nospslow = a
	setconstant(client.walkspeedfun, 35, configs.player.nospslow and 1 or 0.8)
end, configs.player.nospslow)
-- sec.NewToggle("No Shield Swat Slow", function(a)
-- 	configs.player.noswatslow = a
-- end, configs.player.noswatslow)
-- sec.NewToggle("Always Punch", function(a)
-- 	configs.player.alwaysp = a
-- 	if configs.player.alwaysp == true then
-- 		client.punchCorrection()
-- 	end
-- end, false)
-- sec.NewToggle("Always Silent Punch", function(a)
-- 	configs.player.alwayssilentp = a
-- end, false)
sec.NewToggle("Always Keycard", function(a)
	configs.player.bypasskd = a
	client.hasKeyCorrection(configs.player.bypasskd)
end, configs.player.bypasskd)
sec.NewToggle("Allow Equip While Crawling", function(a)
	configs.player.crawlequip = a
	if configs.player.crawlequip then
		client.isCrawlingCorrection()
	end
end, configs.player.crawlequip)
sec.NewToggle("Allow Walk When Arrested", function(a)
	configs.player.allowwalkcuffed = a
end, configs.player.allowwalkcuffed)
sec.NewToggle("Break Your Back Bone", function(a)
	configs.player.backbone = a
	if configs.player.backbone then
		client.duckCorrection()
	end
end, configs.player.backbone)
sec.NewToggle("Get Avatar Outfit On Respawn", function(a)
	configs.player.getclothes = a
end, configs.player.getclothes)
sec.NewButton("Get Avatar Outfit", function()

end)
sec.NewButton("Get Police Outfit", function()

end)
sec.NewLabel("NOTE: No Circle Hold might broke/not working on some actions")

-- --// Projectiles
-- local sec = page.NewSection("Projectiles")
-- sec.NewToggle("Disable Military Turret", function(a)
	
-- end, false)
-- sec.NewToggle("Disable House Turret", function(a)
	
-- end, false)


-- // Vehicle Page
local page = ui.NewPage("Vehicle")

-- // Utilities
local sec = page.NewSection("Utilities")
sec.NewSlider("Flight Speed", 10, 1000, configs.vehicle.fspeed, true, function(a)
	configs.vehicle.fspeed = a
end)
sec.NewSlider("Flight Rotation X", 0, 360, configs.vehicle.fx, false, function(a)
	configs.vehicle.fx = a
end)
sec.NewSlider("Flight Rotation Y", 0, 360, configs.vehicle.fy, false, function(a)
	configs.vehicle.fy = a
end)
sec.NewSlider("Flight Rotation Z", 0, 360, configs.vehicle.fz, false, function(a)
	configs.vehicle.fz = a
end)
sec.NewToggle("Vehicle Flight", function(a)
	configs.vehicle.ftog = a
	if configs.vehicle.ftog and client.vehicleEntered == true then
		client.launchVehicleFlight()
	end
end, configs.vehicle.ftog)
sec.NewToggle("Infinite Nitro", function(a)
	configs.vehicle.infnitro = a
	if configs.vehicle.infnitro then
		client.nitroCorrection()
	end
end, configs.vehicle.infnitro)
sec.NewToggle("Random Infinite Nitro", function(a)
	configs.vehicle.rinfnitro = a
end, configs.vehicle.rinfnitro)
sec.NewToggle("Always Nitro", function(a)
	configs.vehicle.alwaysnit = a	
end, configs.vehicle.alwaysnit)
sec.NewToggle("No Hijack Vehicle", function(a)
	configs.vehicle.alwayshij = a
end, configs.vehicle.alwayshij)

-- sec.NewToggle("Automatic Lock Vehicle", function(a)
-- 	configs.vehicle.autolock = a
-- end, false)

-- // Car Modification
local sec = page.NewSection("Car Mods")
sec.NewSlider("Engine Speed", 1, 200, configs.vehicle.enginesp, false, function(a)
	configs.vehicle.enginesp = a
end)
sec.NewToggle("Apply Engine Speed", function(a)
	configs.vehicle.engine = a
	if configs.vehicle.engine == false then
		client.updateToOriginalChassisStats()
	end
end, configs.vehicle.engine)
-- sec.NewSlider("Brake Speed", 1, 5, configs.vehicle.brakesp, true, function(a)
-- 	configs.vehicle.brakesp = a
-- end)
-- sec.NewToggle("Apply Brake Speed", function(a)
-- 	configs.vehicle.brake = a
-- end, configs.vehicle.brake)
sec.NewSlider("Suspension Height", 1, 150, configs.vehicle.suspensionhe, false, function(a)
	configs.vehicle.suspensionhe = a
end)
sec.NewToggle("Apply Suspension Height", function(a)
	configs.vehicle.suspension = a
	if configs.vehicle.suspension == false then
		client.updateToOriginalChassisStats()
	end
end, configs.vehicle.suspension)
sec.NewSlider("Turn Speed", 1, 5, configs.vehicle.turnsp, true, function(a)
	configs.vehicle.turnsp = a
end)
sec.NewToggle("Apply Turn Speed", function(a)
	configs.vehicle.turn = a
	if configs.vehicle.suspension == false then
		client.updateToOriginalChassisStats()
	end
end, configs.vehicle.turn)
sec.NewToggle("Anti Tire Pop", function(a)
	configs.vehicle.nopop = a
	-- if configs.vehicle.nopop then
	-- 	client.popCorrection()
	-- end
end, configs.vehicle.nopop)
sec.NewToggle("Automatic Flip", function(a)
	configs.vehicle.autoflip = a
	if configs.vehicle.autoflip then
		client.flipCorrection()
	end
end, configs.vehicle.autoflip)
sec.NewToggle("Instant Tow", function(a)
	configs.vehicle.instanttow = a
end, configs.vehicle.instanttow)
sec.NewToggle("Drive On Water", function(a)
	configs.vehicle.driveonwater = a
	setconstant(client.alexchassis.UpdateEngine, 280, configs.vehicle.driveonwater and 1 or 0.625)
end, configs.vehicle.driveonwater)

--// Helicopter Mods
local sec = page.NewSection("Heli Mods")
sec.NewSlider("Engine Speed", 1, 100, configs.vehicle.helienginesp, false, function(a)
	configs.vehicle.helienginesp = a / 1000
end)
-- sec.NewToggle("Apply Engine Speed", function(a)
-- 	configs.vehicle.heliengine = a
-- end, false)
sec.NewToggle("Infinite Height", function(a)
	configs.vehicle.heliheight = a
end, configs.vehicle.heliheight)
sec.NewToggle("Anti Heli Break", function(a)
	configs.vehicle.helibreak = a
	if configs.vehicle.helibreak then
		client.heliBreakCorrection()
	end
end, configs.vehicle.helibreak)
sec.NewToggle("Instant Pickup", function(a)
	configs.vehicle.helipick = a
end, configs.vehicle.helipick)


-- // Combat Page

local page = ui.NewPage("Combats")

-- // Weapons
local sec = page.NewSection("Weapons")
sec.NewToggle("Always Auto", function(a)
	configs.combat.alwaysauto = a
end, configs.combat.alwaysauto)
sec.NewToggle("No Recoil", function(a)
	configs.combat.norecoil = a
end, configs.combat.norecoil)
sec.NewToggle("No Spread", function(a)
	configs.combat.nospread = a
end, configs.combat.nospread)
sec.NewToggle("No Bullet Gravity", function(a)
	configs.combat.nobulletg = a
end, configs.combat.nobulletg)  
sec.NewToggle("No Equip Time", function(a)
	configs.combat.noequipt = a
end, configs.combat.noequipt)
sec.NewToggle("Wallbang", function(a)
	configs.combat.wallbang = a
end, configs.combat.wallbang)
sec.NewToggle("Headshot Only", function(a)
	configs.combat.alwaysheadshot =a
	--client.headshotCorrection(configs.combat.alwaysheadshot)
end, configs.combat.alwaysheadshot)
sec.NewToggle("Increase Takedown Damage", function(a)
	configs.combat.increasetakedowndamage =a
end, configs.combat.increasetakedowndamage)
sec.NewToggle("Free Pistol Swat", function(a)
	configs.combat.pistolswat = a
end, configs.combat.pistolswat)
sec.NewToggle("Fast Taser", function(a)
	configs.combat.tasermodz = a
end, configs.combat.tasermodz)
sec.NewToggle("Forcefield Anti Misses", function(a) -- if you don't know what this does, it basically makes your forcefield ball/bullet always hitting yourself
	configs.combat.forcefieldnomiss = a
end, configs.combat.forcefieldnomiss)
sec.NewToggle("No Sniper Scope Gui", function(a)
	configs.combat.snipernogui = a
end, false)
sec.NewToggle("No Sniper Scope Blur", function(a)
	configs.combat.snipernoblur = a
end, false)
sec.NewToggle("No Grenade Smoke", function(a)
	configs.combat.nogrenadesmoke = a
	client.smokeGrenadeHook(configs.combat.nogrenadesmoke)
end, configs.combat.nogrenadesmoke)
-- sec.NewToggle("Increase Vehicle & Forcefield Bullet Damage", function(a)

-- end, false)
sec.NewButton("Open Gunstore Ui", function()
	set_thread_identity(2) 
	require(game:GetService("ReplicatedStorage").Game.GunShop.GunShopUI).open()
	set_thread_identity(10)
end)


--// Sword & Baton
local sec = page.NewSection("Melee")
sec.NewToggle("No Reload Time", function(a)
	configs.combat.batonsword.noreloadtime = a
	if configs.combat.batonsword.noreloadtime then
		client.setBatonSwordTime(configs.combat.batonsword.noreloadtime)
	end
end, configs.combat.batonsword.noreloadtime)

sec.NewToggle("Always Swoosh", function(a)
	configs.combat.batonsword.spamswoosh = a
	if configs.combat.batonsword.spamswoosh then
		client.spamBatonSwordSwoosh()
	end
end, configs.combat.batonsword.spamswoosh)
sec.NewToggle("Always Lunge", function(a)
	configs.combat.batonsword.spamlunge = a
	if configs.combat.batonsword.spamlunge then
		client.spamBatonSwordLunge()
	end
end, configs.combat.batonsword.spamlunge)

--// Silent Aim [please don't use this cuz it sucks trust me]
local sec = page.NewSection("Silent Aim [Unoptimized]")

sec.NewToggle("Enabled", function(a)
	configs.combat.silentaim.enabled = a
end, false)
sec.NewToggle("Include Taser", function(a)
	configs.combat.silentaim.includetaser = a
end, false)
sec.NewToggle("Include Plasma Gun", function(a)
	configs.combat.silentaim.includetaser = a
end, false)
sec.NewSlider("Radius", 10, 1000, 250, false, function(a)
	configs.combat.silentaim.radius = a
	Circle.Radius = a
end)
sec.NewToggle("Wallcheck", function(a)
	configs.combat.silentaim.wallcheck = a
end, false)
sec.NewToggle("FOV Circle", function(a)
	configs.combat.silentaim.fovcirc = a
	Circle.Visible = a
end, false)
sec.NewSlider("Circle Thickness", 0, 10, 0, true, function(a)
	configs.combat.silentaim.fovthick = a
	Circle.Thickness = a
end)
sec.NewSlider("Circle Transparency", 1, 0, 0, true, function(a)
	configs.combat.silentaim.fovtransp = a
	Circle.Transparency = a
end)
local sec = page.NewSection("Arrest Aura")
-- sec.NewLabel("NOTE: this features is not optimized well and rushed")
-- sec.NewLabel("soo expect some bugs occuring")
sec.NewToggle("Enabled", function(a)
	configs.combat.arrestaura.enabled = a
	if configs.combat.arrestaura.enabled then
		client.launchArrestAura()
	end	
end, configs.combat.arrestaura.enabled)


-- local sec = page.NewSection("Tase Aura")
-- sec.NewLabel("not done yet lmao")
-- sec.NewSlider("Tase Distance", 10, 85, 25, false, function(a)
	
-- end)
-- sec.NewToggle("Enabled", function(a)
	
-- end, false)


local sec = page.NewSection("Others")
sec.NewSlider("Hitbox Radius", 3, 50, configs.combat.hitboxradius, true, function(a)
	configs.combat.hitboxradius = a
	client.changeHitboxRadius(configs.combat.hitboxradius)
end)