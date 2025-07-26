-- Finden der Insel des Benutzers
			local function GetIsland()
				for _, Island in ipairs(Islands:GetChildren()) do
					local Owners = Island:FindFirstChild("Owners")
					if Owners and Owners:FindFirstChild(Island_USERID) then
						return Island
					end
				end
			end

			-- Finden der Blöcke, die geerntet werden sollen
			local function GetToHarvest(Island)
				local Blocks = Island:FindFirstChild("Blocks")
				local ToHarvest = {}
				if IsInTable(SelectedCrop, "all") then
					for _, Block in ipairs(Blocks:GetChildren()) do
						if Block:FindFirstChild("Targettable") then
							local MeshPart = Block:FindFirstChildWhichIsA("MeshPart")
							if MeshPart and MeshPart:FindFirstChild("Harvestable") and MeshPart.Harvestable.Value then
								local dis = (Block.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								if dis < MAXDISCROPSICHLE then
									table.insert(ToHarvest, Block)
									GOTACROPTAGET = true
								end
							end
						end
					end
				elseif _G.SelectedCrop == {"allberrys"} then
					for _, Block in ipairs(Blocks:GetChildren()) do
						if Block and Block.Name == "berryBush" or Block.Name == "blueberryBush" or Block.Name == "blackberryBush" then
							local MeshPart = Block:FindFirstChildWhichIsA("MeshPart")
							if MeshPart and MeshPart:FindFirstChild("Harvestable") and MeshPart.Harvestable.Value then
								local dis = (Block.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								if dis < MAXDISCROPSICHLE then
									table.insert(ToHarvest, Block)
									GOTACROPTAGET = true
								end
							end
						end
					end
				else
					for _, Block in ipairs(Blocks:GetChildren()) do
						if IsInTable(SelectedCrop, Block.Name)  then
							local MeshPart = Block:FindFirstChildWhichIsA("MeshPart")
							if MeshPart and MeshPart:FindFirstChild("Harvestable") and MeshPart.Harvestable.Value then
								local dis = (Block.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								if dis < MAXDISCROPSICHLE then
									table.insert(ToHarvest, Block)
									GOTACROPTAGET = true
								end
							end
						end
					end
				end
				return ToHarvest
			end

			-- Finden der Blöcke, die geerntet werden sollen
			local function GetToHarvestTP(Island)
				local Blocks = Island:FindFirstChild("Blocks")
				local ToHarvesttp = {}
				if IsInTable(SelectedCrop, "all") then
					for _, Block in ipairs(Blocks:GetChildren()) do
						if Block:FindFirstChild("Targettable") then
							local MeshPart = Block:FindFirstChildWhichIsA("MeshPart")
							if MeshPart and MeshPart:FindFirstChild("Harvestable") and MeshPart.Harvestable.Value then
								local dis = (Block.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								--if dis < MAXDISCROPSICHLE then
								table.insert(ToHarvesttp, Block)
								DebugCheck(0,"GetToHarvestTP")
								--end
							end
						end
					end
				elseif _G.SelectedCrop == {"allberrys"} then
					for _, Block in ipairs(Blocks:GetChildren()) do
						if Block.Name == "berryBush" or Block.Name == "blueberryBush" or Block.Name == "blackberryBush" then
							local MeshPart = Block:FindFirstChildWhichIsA("MeshPart")
							if MeshPart and MeshPart:FindFirstChild("Harvestable") and MeshPart.Harvestable.Value then
								local dis = (Block.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								--if dis < MAXDISCROPSICHLE then
								table.insert(ToHarvesttp, Block)
								--end
							end
						end
					end
				else
					print("OTHER")
					for _, Block in ipairs(Blocks:GetChildren()) do
						if  IsInTable(SelectedCrop, Block.Name) then
							local MeshPart = Block:FindFirstChildWhichIsA("MeshPart")
							if MeshPart and MeshPart:FindFirstChild("Harvestable") and MeshPart.Harvestable.Value then
								local dis = (Block.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								--if dis < MAXDISCROPSICHLE then
								table.insert(ToHarvesttp, Block)
								DebugCheck(0,"GetToHarvestTP")
								--end
							end
						end
					end
				end
				return ToHarvesttp
			end


			task.wait()

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


			local function Ernte()
				DebugCheck(0,"Ernte")
				-- Ernte
				local ToHarvest = GetToHarvest(GetIsland())
				local ToHarvestLength = #ToHarvest
				local BlocksPerCall = 50
				local Count = 1

				BlocksPerCall = 150



				if _G.SuperFastCropFarm == true then
					BlocksPerCall = 300
				end



				if ToHarvest == nil or ToHarvest == {} then

					DebugCheck(0,"NICHTS GEFUNDEN!!!")

					return 0;
				end

			--[[

			
			if GOTACROPTAGET == false then
				task.wait()
				SICHLECROPFARMCOOLDOWN = false
				SichleAuraCooldown = false
				return nil 
			end

			if ToHarvest == nil then
				SICHLECROPFARMCOOLDOWN = false
				SichleAuraCooldown = false
				return nil 
			end

			]]

				-- Speichern der ursprünglichen Positionen der geernteten Blöcke
				local OriginalPositions = {}
				local OriginalNames = {}
				_G.OriginalNames = {}
				_G.OriginalPositions = {}
				for i, Block in ipairs(ToHarvest) do
					OriginalPositions[i] = Block.CFrame
					OriginalNames[i] = Block.Name
					_G.OriginalPositions[i] = Block.CFrame
					_G.OriginalNames[i] = Block.Name
				end

				DebugCheck(0,"while gay")

				local Args = {}

				DebugCheck(0,"Start While ")

				while Count <= ToHarvestLength do
					task.wait()
					local HarvestCount = math.min(ToHarvestLength - Count + 1, BlocksPerCall)
					for i = Count, Count + HarvestCount - 1 do
						Args[i - Count + 1] = ToHarvest[i]
					end
					Count = Count + HarvestCount
				end

				DebugCheck(0,"Finish While")

				task.wait(0.1)

				ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.SwingSickle:InvokeServer(UseSichleTool, Args)

				local A = 0

				local AACOUNT = 1

				local Placeing = true

				-- Zurücksetzen der Blöcke an den ursprünglichen CFrame

				local ISTTTTON = true

				-- task.wait(0.6)

				if _G.AutoReplaceCrop == true then
					local TTTT = game:GetService("RunService").RenderStepped:Connect(function()

						if A < 40 then
							task.wait()
							A = A + 1
							for Blocki = 1, #ToHarvest do
								if ISTTTTON == false then return nil end
								if OriginalPositions[AACOUNT] and OriginalPositions[AACOUNT] ~= nil and OriginalPositions[AACOUNT] ~= nil then
									_G.orgPos = OriginalPositions[AACOUNT]
									_G.AACOUNT = AACOUNT

									-- __IGNORESTR__
									-- loadstring("__IGNORESTR__local ohTable1 = {['upperBlock'] = false,[_G.CropPlaceH1] =  _G.CropPlaceHash,['cframe'] = _G.orgPos,['blockType'] = _G.OriginalNames[_G.AACOUNT]};game:GetService('ReplicatedStorage').rbxts_include.node_modules['@rbxts'].net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(ohTable1)")()
									loadstring("local ohTable1 = {['upperBlock'] = false,[_G.CropPlaceH1] =  _G.CropPlaceHash,['cframe'] = _G.orgPos,['blockType'] = _G.OriginalNames[_G.AACOUNT]};game:GetService('ReplicatedStorage').rbxts_include.node_modules['@rbxts'].net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(ohTable1)")()

									AACOUNT = AACOUNT + 1   
								else
									AACOUNT = AACOUNT + 1
									-- warn("Original position of block " .. Block.Name .. " is nil. Skipping reset.")
								end

							end
							Placeing = false
						end
					end)
				end
			end

			if _G.SuperFastCropFarm ~= true then
				task.wait(0.4)
			end

			if _G.SuperFastCropFarm ~= true then
				if _G.SafeUseSichle == true then 
					task.wait(1.5)
				end
			end

			local IsThere = false
			-- Teleportieren zur ausgewählten Ernte
			if SOLLICHAUCHTELEPORTENODERNICHT == true then
				DebugCheck(0,"SOLLICHAUCHTELEPORTENODERNICHT is true")

				local ToHarvest = GetToHarvestTP(GetIsland())

				task.wait(0.2)

				local PPPPPOSSS = findNearestPart(ToHarvest)

				if PPPPPOSSS then
					TeleportV4(PPPPPOSSS.Position)
					DebugCheck(0,"Tween Fertig!!!!")
					Completed = true
					Ernte()
					Harvesting = false
					SICHLECROPFARMCOOLDOWN = false
					SichleAuraCooldown = false
					SichleFarmCooldown = false
				else
					Completed = true
					Harvesting = false
					SICHLECROPFARMCOOLDOWN = false
					SichleAuraCooldown = false
					SichleFarmCooldown = false
				end

						--[[

						
			local Island = GetIsland()
			for i, Block in ipairs(Island:FindFirstChild("Blocks"):GetChildren()) do 
				if IsThere == true then return nil end
				if Block.Name == SelectedCrop then
				local MeshPart = Block:FindFirstChildWhichIsA("MeshPart")
				if MeshPart and MeshPart:FindFirstChild("Harvestable") and MeshPart.Harvestable.Value == true then
					local dis = (Block.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
					if dis < MAXDISCROPSICHLE then
						IsThere = true
						
					end
				end
				end
			end
						]]
			else
				Ernte()
				Harvesting = false
				SICHLECROPFARMCOOLDOWN = false
				SichleAuraCooldown = false
				SichleFarmCooldown = false
			end

			if TTTT then
				TTTT:Disconnect()
			end 
			ISTTTTON = false
			SICHLECROPFARMCOOLDOWN = false
			SichleFarmCooldown = false	
		end
	end







	local PLAC222 = false
	function SeedAura(V)
		if PLAC222 == false then
			PLAC222 = true
			local Island = GetIsland()

			local center = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
			local radius = _G.PlowDistance or 5
			local region = Region3.new(center - Vector3.new(radius, radius, radius), center + Vector3.new(radius, radius, radius))
			local Blocks = workspace:FindPartsInRegion3(region, nil, math.huge)

			local ANTILAG_BOSS_Crown_Crepper_Is_Gay = 0

			task.wait(0.1)

			local ToLace = "wheat"

			for i = 1,#Blocks do
				local v = Blocks[i]
				if v.Parent == Island:FindFirstChild("Blocks") then
					if v.Name == "soil" then
						task.wait()
						task.spawn(function()
							local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
							if Tool then
								if Tool:FindFirstChild("seeds") then
									function removeSeeds(itemName)
										local index = string.find(itemName, "Seeds")
										if index ~= nil then
											return string.sub(itemName, 1, index - 1)
										else
											return itemName
										end
									end
									ToLace = removeSeeds(Tool.Name)
								else
									task.wait(0.1)
									PLAC222 = false
									return nil
								end
							end

							task.wait()
							local ohTable1 = {
								["upperBlock"] = false,
								["cframe"] = CFrame.new(v.Position + Vector3.new(0,3,0)),
								["blockType"] = ToLace or "wheat",
								[PlaceHASHName] = PlaceHASH
							}
							game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(ohTable1)
						end)
					end
				end
			end

			task.wait(0.1)

			PLAC222 = false

		end
	end



	-- HHAHAHAHGZQ(AG)

	local PET_ANIMALFarmCoolDowm = false
	function PET_ANIMALFarm(V)
		if PET_ANIMALFarmCoolDowm == false then
			PET_ANIMALFarmCoolDowm = true
			local Island = GetIsland()
			local Entities = Island:FindFirstChild("Entities")
			if Entities then
				Entities = Island:FindFirstChild("Entities"):GetChildren()
				for i = 1,#Entities do 
					if Entities[i].Name == "cow" or Entities[i].Name == "pig" or Entities[i].Name == "sheep" or Entities[i].Name == "chicken" then
						if V == true then
							TeleportV4(Entities[i]:FindFirstChild("HumanoidRootPart").Position)


						else
							local args = {
								[1] = {
									["animal"] = Entities[i]
								}}
							game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("PetCollect").Value):InvokeServer(unpack(args)) 
						end
						wait()
						local args = {
							[1] = {
								["animal"] = Entities[i]
							}}
						for i = 1,1 do
							game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("PetCollect").Value):InvokeServer(unpack(args)) 
							if Entities[i]:FindFirstChild("oldName") == nil then
								local OLD = Instance.new("StringValue")
								OLD.Name = "oldName"
								OLD.Parent = Entities[i]
								OLD.Value = Entities[i].Name
								Entities[i] = "GG"
							end
							Entities[i] = "GG"
						end
					end
					Entities = Island:FindFirstChild("Entities"):GetChildren()
					for i = 1,#Entities do 
						if Entities[i]:FindFirstChild("oldName") then
							Entities[i].Name = Entities[i]:FindFirstChild("oldName").Value
						end
					end
				end
			end
			PET_ANIMALFarmCoolDowm = false
		end
	end

	AutoPickUpCooldown = false

	function AutoPickupItems()
		if AutoPickUpCooldown == true then return nil end
		AutoPickUpCooldown = true 
		local Island = GetIsland()
		local Tools = Island:FindFirstChild("Drops"):GetChildren()
		local PublicTools = game:GetService("Workspace"):FindFirstChild("game:WildernessDrops"):FindFirstChild("WildDropsFolder"):GetChildren()

		for i = 1,#Tools do 
			local ohTable1 = {
				["tool"] = Tools[i],
				[PickupH1] = PickupH2
			}

			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer(ohTable1)

		end

		for i = 1,#PublicTools do 

			local ohTable1 = {
				["tool"] = PublicTools[i],
				[PickupH1] = PickupH2
			}

			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_TOOL_PICKUP_REQUEST:InvokeServer(ohTable1)

		end
		AutoPickUpCooldown = false
	end

	local CIsland = false
	function CleanIsland()
		if CIsland == false then
			CIsland = true
			local Island = GetIsland()
			local Blocks = Island:FindFirstChild("Blocks")

			local Targets = {}

			local Targetnames = {"tallGrass", "naturalRock1"}

			for i,v in pairs(Blocks:GetChildren()) do
				for y,c in pairs(Targetnames) do
					if c == v.Name then
						table.insert(Targets, v)
						DebugCheck(0,"ADDED!",c)
					end
				end
			end

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

			local closestPart = findNearestPart(Targets)

			if closestPart then

				TeleportV4(closestPart.Position)

				task.wait()


				if closestPart then


					local GPART = closestPart:FindFirstChildWhichIsA("Part") or closestPart:FindFirstChildWhichIsA("MeshPart")
					local args = {
						[1] = {
							[HitHASHName] = HitHASH,
							["part"] = GPART,
							["block"] = closestPart,
							["norm"] = closestPart.Position,
							["pos"] = GPART.Position
						}
					}
					if closestPart then
						local dis = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - closestPart.Position).Magnitude

						if dis < 30 then

							for i = 1,3 do
								if closestPart then
									game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild(RemoteData:FindFirstChild("BlockRemote").Value):InvokeServer(unpack(args))
									task.wait()
								end
							end
							task.wait(0.5)
							CIsland = false
						else
							task.wait(0.5)
							CIsland = false
						end
					else
						task.wait(0.5)
						CIsland = falsec
					end
				end


			else
				task.wait(0.5)
				CIsland = false
			end
		end
	end

	local FFC = false
	function flowerFarm(V)
		if FFC == false then
			FFC = true



			local Island = GetIsland()
			local  Blocks = Island:FindFirstChild("Blocks"):GetChildren()
			if Island:FindFirstChild("Blocks") then
				for i,v in pairs(Blocks) do
					if v:FindFirstChild("flower") then
						if V == true then
							TeleportV4(v.Position)
							task.wait(0.5)
						end

						local args = {
							[1] = {
								["flower"] = v
							}
						}

						game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.client_request_1:InvokeServer(unpack(args))
					end
				end
			end
			task.wait(2)
			FFC = false
		end
	end


	local PLAC = false
	function PlowAura(V)
		if PLAC == false then
			PLAC = true
			local Island = GetIsland()

			local center = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
			local radius = _G.PlowDistance or 30
			local region = Region3.new(center - Vector3.new(radius, radius, radius), center + Vector3.new(radius, radius, radius))
			local Blocks = workspace:FindPartsInRegion3(region, nil, math.huge)

			local LMAO

			if V == true then
				LMAO = "grass"
			else
				LMAO = "soil"
			end

			local CVS = 0

			local A = 0
			for i = 1,#Blocks do
				task.spawn(function()
					local v = Blocks[i]
					if v.Parent == Island:FindFirstChild("Blocks") then
						if v.Name == LMAO then
							local ohTable1 = {
								["block"] = v
							}

							if LMAO == "grass" then
								if _G.PlowAura == true then
									game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_PLOW_BLOCK_REQUEST:InvokeServer(ohTable1) 
								end 
							elseif LMAO == "soil" then
								if _G.UnPlowAura == true then
									game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_PLOW_BLOCK_REQUEST:InvokeServer(ohTable1) 
								end
							end
						end
					end
				end)
			end
		end

		task.wait(0.1) -- Drecks obfuser

		PLAC = false
	end

	local Human = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
	Human:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		Human.WalkSpeed = _G.WalkSpeed or 30
	end)



	-- // functions \\ --


	local __CHECKVIP__ = game:GetService("Workspace"):WaitForChild("PrivateServer")

	if __CHECKVIP__ then
		if __CHECKVIP__.Value == false then
			Message("WARNING!", "THE SCRIPT IS SAFE ON VIP SERVERS! PUBLIC SERVERS ARE UNSAFE MODS CAN BAN YOU!", "Okay!")
		end
	end


	local OP = false 
	function OpenPresent()
		if OP == false then
			OP = true 
			local args = {
				[1] = {}
			}

			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.client_request_22:InvokeServer(unpack(args))

			task.wait(0.1)
			OP = false
		end
	end



	local GIftCO = false
	function GiftFarm()
		if GIftCO == false then
			GIftCO = true
			local distance = 10000
			for i,v in pairs(workspace.Islands:GetDescendants()) do
				if v.Name == "Owners" then 
					if v:FindFirstChild(_G.Island_USERID) then 
						for i,v in pairs(v.Parent.Blocks:GetChildren()) do
							local NekoHub_on_TOP = string.sub(v.Name:lower(), 1, string.len("christmas"))
							if (NekoHub_on_TOP == "christmas") then 
								local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude
								if mag < distance then 
									local ohTable1 = {["player_tracking_category"] = "join_from_web",["part"] = v:WaitForChild("Present"),["block"] = v,["norm"] = Vector3.new(v.CFrame),["pos"] = v.Position}
									if _G.Event_Presents_Farm == true then

										if _G.TeleportMethod == "Tween" then
											if v then
												TweenTp(v.Position + Vector3.new(0,1,0))
											end
										elseif _G.TeleportMethod == "Instant" then
											if v then
												game.Players.LocalPlayer.Character:MoveTo(v.Position + Vector3.new(0,1,0))
											end
										elseif _G.TeleportMethod == "Pathfinding" then
											if v then
												PathFindingSystem(v)
											end
										end
										while v and v ~= nil do
											task.wait()
											if v ~= nil then
												game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(ohTable1)
												if _G.TeleportMethod == "Tween" then
													if v ~= nil then
														TweenTp(v.Position + Vector3.new(0,1,0))
													else
														GIftCO = false
													end
												elseif _G.TeleportMethod == "Instant" then
													if v ~= nil then
														game.Players.LocalPlayer.Character:MoveTo(v.Position + Vector3.new(0,1,0))
													else
														GIftCO = false
													end
												elseif _G.TeleportMethod == "Pathfinding" then
													if v ~= nil then
														PathFindingSystem(v)
													else
														GIftCO = false
													end
												end
												game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(ohTable1)
											else
												DebugCheck(0,"OFF")
												GIftCO = false
											end
										end
										DebugCheck(0,"OFF")
										GIftCO = false
									end
								end
							end
						end
					end
				end
			end
			task.wait(5)
			GIftCO = false
		end
	end

	function CheckDouble(Option)
		if Option == "Skorpions" then
			_G.SelectedMobs = {"skorpRuby","skorpGold","skorpIron", "skorpSerpent"}
			_G.CheckDoubleIsTrue = true
			return {"skorpRuby","skorpGold","skorpIron", "skorpSerpent"}
		elseif type(Option) == "table" then
			for i,v in pairs(Option) do
				if v == "Skorpions" then
					local END = Option

					table.insert(END, "skorpRuby")
					table.insert(END, "skorpGold")
					table.insert(END, "skorpIron")
					table.insert(END, "skorpSerpent")


					return END
				end
			end
		else

			DebugCheck(0,"CheckDouble: false")
			return Option
		end
	end

	function GetPlayerInfos(PlayerName)
		if game:GetService("Players"):FindFirstChild(PlayerName) then
			local Player = game:GetService("Players"):FindFirstChild(PlayerName)
			local UserId = Player.UserId
			local AccountAge = game.Players.LocalPlayer.AccountAge

			local JoinCode = Player.JoinCode.Value
			local DeviceType = Player.DeviceType.Value
			local Locale = Player.Locale.Value
			local CountryCode = Player.CountryCode.Value

			local FinalInfos = {Player, UserId, AccountAge, JoinCode, DeviceType, Locale, CountryCode}

			return FinalInfos
		else
			return nil
		end
	end


	function GenInfos()
		if _G.SecureMode ~= true then
			local Infos = GetPlayerInfos(game.Players.LocalPlayer.Name)
			if Infos then
				local Section = Tab:CreateSection("Infos")
				local Player = Infos[1] 
				local UserId = Infos[2] 
				local AccountAge = Infos[3]

				local JoinCode = Infos[4]
				local DeviceType = Infos[5]
				local Locale = Infos[6]
				local CountryCode = Infos[7]

				local UsernameLabel = Tab:CreateLabel("Username: "..Player.Name.." ("..UserId..")")
				local AccountAgeLabel
				if AccountAge == 1 or AccountAge == 0 then
					AccountAgeLabel = Tab:CreateLabel("AccountAge: "..AccountAge.." Day")
				else
					AccountAgeLabel = Tab:CreateLabel("AccountAge: "..AccountAge.." Days")
				end
				local JoinCode = Tab:CreateLabel("JoinCode: "..JoinCode)
				local DeviceType = Tab:CreateLabel("DeviceType: "..DeviceType)

			end
		--[[
		Players.Chatted:Connect(function(MSG)
			DebugCheck(0,"Last Chat Message: "..MSG)
		end)
	
		]]
		end 
	end

--[[

GenInfos()

]]


	local LastTool = nil

	game:GetService("RunService").RenderStepped:Connect(function()
		local Player = game.Players.LocalPlayer
		if Player then
			local Character = Player.Character
			if Character then
				local Tool = Character:FindFirstChildWhichIsA("Tool")
				if Tool then
					LastTool = Tool.Name
				end
			end
		end
	end)

	game.Players.LocalPlayer.Character:FindFirstChild("CurrentHealth").Changed:Connect(function()
		local HUPVALUE = game.Players.LocalPlayer.Character:FindFirstChild("CurrentHealth")
		if HUPVALUE then
			if HUPVALUE.Value == 0 then
				repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("CurrentHealth").Value > 0

				task.wait()

				local Backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")

				if Backpack then
					if LastTool then
						if Backpack:FindFirstChild(LastTool) then
							if _G.AutoFarm == true then
								Backpack:FindFirstChild(LastTool).Parent = game.Players.LocalPlayer.Character
							end
						end
					end
				end 

			end
		end
	end)

	local MobSelection = Tabs.Main:AddSection("Mob Auto Farm")

	local MultiDropdown = MobSelection:AddDropdown("MultiDropdown", {
		Title = "Selected Mob",
		Description = "Mob to Farm",
		Values = {"wraithBoss","slime","buffalkor","wizardLizard","Skorpions","magmaBlob","magmaGolem","skeletonPirate","voidPup","voidDog"},
		Multi = true,
		Default = {"slime"},
	})

	MultiDropdown:OnChanged(function(Option)



		if type(Option) == "table" then
			local END = {}
			for i,v in pairs(Option) do
				table.insert(END,i)
			end

			Option = END

			if CheckDouble(Option) then
				_G.SelectedMob = CheckDouble(Option)
			else
				_G.SelectedMob = Option
			end
		else
			_G.SelectedMob = Option
		end
	end)

	local TeleportPositionSlider = MobSelection:AddSlider("Slider", {
		Title = "Teleport Position (Y)",
		Description = "",
		Default = 8,
		Min = -15,
		Max = 15,
		Rounding = 0,
		Callback = function(Value)
			_G.MobTpYPos = Value
		end
	})

	local MobAutoFarmToggle = MobSelection:AddToggle("MobAutoFarmToggle", {Title = "Mob Auto Farm", Default = false })

	MobAutoFarmToggle:OnChanged(function(Value)

		if Value == false then
			LastMob = nil
		end

		_G.AutoFarm = Value 
		if Value == true then
			UseFloat = true
			if _G.CheckDoubleIsTrue == true then
				_G.DoubleAutoFarm = true
				_G.AutoFarm = false
			else
				_G.AutoFarm = true 
			end
		else
			UseFloat = false
			if _G.CheckDoubleIsTrue == true then
				_G.AutoFarm = false
				_G.DoubleAutoFarm = true
			end
		end

		print(_G.AutoFarm)

	end)


	local MobKillAuraToggle = MobSelection:AddToggle("MobKillAuraToggle", {Title = "Mob Kill Aura", Default = false })

	MobKillAuraToggle:OnChanged(function()

		local Value = Options.MobKillAuraToggle.Value

		_G.MobKillAura = Value
	end)

	local MobUseRagebladeToggle = MobSelection:AddToggle("MobUseRagebladeToggle", {Title = "Use Rageblade for Mob Auto Farm", Default = false })

	MobUseRagebladeToggle:OnChanged(function()

		local Value = Options.MobUseRagebladeToggle.Value

		_G.ragebladeMobFarm = Value
	end)


	local BossSelection = Tabs.Main:AddSection("Boss Auto Farm")


	local BossAutoFarmDropdown = BossSelection:AddDropdown("BossAutoFarmDropdown", {
		Title = "Boss To Farm",
		Description = "Boss to Auto Farm",
		Values = {"slimeKing", "slimeQueen","desertBoss", "golem"},
		Multi = false,
		Default = 1,
	})

	BossAutoFarmDropdown:OnChanged(function(Option)
		if type(Option) == "table" then
			_G.SelectedBoss = Option[1]
		else
			_G.SelectedBoss = Option
		end
	end)

	local BossAutoFarm = BossSelection:AddToggle("BossAutoFarm", {Title = "Boss Auto Farm", Default = false })

	BossAutoFarm:OnChanged(function()

		local Value = Options.BossAutoFarm.Value

		UseFloat = Value
		if Value == true then
			_G.BossAutoFarm = true 
		else
			LastMob = nil
			_G.BossAutoFarm = false
		end
	end)

	local BossAutoSpawn = BossSelection:AddToggle("BossAutoSpawn", {Title = "Boss Auto Spawn", Default = false })

	BossAutoSpawn:OnChanged(function()

		local Value = Options.BossAutoSpawn.Value

		_G.BossAutoSpawn = Value
	end)

	local CropSelection = Tabs.Main:AddSection("Crop Farm")

	local CropDropdown = CropSelection:AddDropdown("CropDropdown", {
		Title = "Crop to Farm",
		Description = "Crop to Farm",
		Values = {"all", -- allberrys
			"berryBush",
			"blackberryBush",
			"blueberryBush",
			"candyCaneVine",
			"carrot",
			"chiliPepper",
			"dragonfruit",
			"grapeVine",
			"melon",
			"onion",
			"pineapple",
			"potato",
			"pumpkin",
			"spinach",
			"spiritCrop",
			"starfruit",
			"tomato",
			"wheat"},
		Multi = true,
		Default = {"wheat"},
	})

	CropDropdown:OnChanged(function(Option)

		if type(Option) == "table" then
			local END = {}
			for i,v in pairs(Option) do
				table.insert(END,i)
			end

			Option = END
		end

		if game:FindFirstChild("CropFarmData") then
			--if game:FindFirstChild("CropFarmData"):FindFirstChild("Value") then
			local ABCSWIFTERISGAY = game:FindFirstChild("CropFarmData"):GetChildren()
			for i = 1,#ABCSWIFTERISGAY do
				local v = ABCSWIFTERISGAY[i]
				if v then
					v:Destroy()
				end
			end
			--end
		end
		for i = 1,100 do
			_G.SelectedCrop = Option
		end
	end)


	local CropAutoFarm = CropSelection:AddToggle("CropAutoFarm", {Title = "Crop Auto Farm", Default = false })

	CropAutoFarm:OnChanged(function()

		local Value = Options.CropAutoFarm.Value

		_G.CropAutoFarm = Value
	end)

	local CropAura = CropSelection:AddToggle("CropAura", {Title = "Crop Aura", Default = false })

	CropAura:OnChanged(function()

		local Value = Options.CropAura.Value

		_G.CropAura_BETA = Value
	end)

	local CropAutoReplace = CropSelection:AddToggle("CropAutoReplace", {Title = "Auto Replace Crop", Default = TreeAura })

	CropAutoReplace:OnChanged(function()

		local Value = Options.CropAutoReplace.Value

		_G.AutoReplaceCrop = Value
	end)

	local CropFastMode = CropSelection:AddToggle("CropFastMode", {Title = "Fast Mode", Default = false })

	CropFastMode:OnChanged(function()

		local Value = Options.CropFastMode.Value

		_G.SafeUseSichle = Value
	end)

	local CropSuperFastMode = CropSelection:AddToggle("CropSuperFastMode", {Title = "Super Fast Mode", Default = false })

	CropSuperFastMode:OnChanged(function()

		local Value = Options.CropSuperFastMode.Value

		_G.SuperFastCropFarm = Value
	end)

--[[

local Dropdown = Tab:CreateDropdown({
	Name = "Sichle",
	Options = {"Stone","sickleIron","Diamond"},
	CurrentOption = "Stone",
	Flag = "SichleToUse", 
	Callback = function(Option)
		if Option == "Stone" then
			
			_G.UseSichleTool = "sickleStone"
		elseif Option == "Diamond" then
			_G.UseSichleTool = "sickleDiamond"
		else
			_G.UseSichleTool = Option
		end
	end,
})

]]


--[[

local Slider = Tab:CreateSlider({
	Name = "Sichle Delay",
	Range = {10, 30},
	Increment = 1,
	Suffix = "Sec",
	CurrentValue = 13,
	Flag = "SichleCropDelay",
	Callback = function(Value)
		_G.SichleCropDelay = Value
	end,
})

]]


--[[


local Slider = Tab:CreateSlider({
	Name = "Sichle Range",
	Range = {3, 30},
	Increment = 1,
	Suffix = "(Range)",
	CurrentValue = 30,
	Flag = "SichleCropRange",
	Callback = function(Value)
		_G.SichleCropRange = Value
	end,
})

]]


	local TreeFarmSelection = Tabs.Main:AddSection("Tree Farm")


	local TreeAutoFarmDropdown = TreeFarmSelection:AddDropdown("TreeAutoFarmDropdown", {
		Title = "Tree to Farm",
		Description = "Tree to Farm",
		Values = {"all","Oak","Birch","Maple", "Pine", "Hickory", "Spirit", "CherryBlossom"},
		Multi = false,
		Default = 1,
	})

	TreeAutoFarmDropdown:OnChanged(function(Option)
		local ENDT = GetTreeName(Option)
		print(ENDT)
		_G.SelectedTree = ENDT
	end)

	local TreeAutoFarm = TreeFarmSelection:AddToggle("TreeAutoFarm", {Title = "Tree Auto Farm", Default = false })

	TreeAutoFarm:OnChanged(function()

		local Value = Options.TreeAutoFarm.Value

		if Value == true then
			TREEFARMWAITBECAUSEOFKI = false
			_G.TreeAutoFarm = true 
			TFCO = false
		else
			_G.TreeAutoFarm = false
		end
	end)

	local TreeAura = TreeFarmSelection:AddToggle("TreeAura", {Title = "Tree Aura", Default = false })

	TreeAura:OnChanged(function()

		local Value = Options.TreeAura.Value

		if Value == true then
			_G.TreeAura = true
			TFCO = false
		else
			_G.TreeAura = false
		end
	end)

	local TreeFruitFarm = TreeFarmSelection:AddToggle("TreeFruitFarm", {Title = "Tree Fruit Farm", Default = false })

	TreeFruitFarm:OnChanged(function()

		local Value = Options.TreeFruitFarm.Value

		_G.AutoCollectFruits = Value
	end)




--[[

local Slider = Tab:CreateSlider({
	Name = "Tree Fly Speed",
	Range = {10, 40},
	Increment = 5,
	Suffix = "Speed",
	CurrentValue = 25,
	Flag = "TreeAutoFarmFlySpeed",
	Callback = function(Value)
		_G.TreeAutoFarmpeed = Value
	end,
})


]]


	local RockFarmSelection = Tabs.Main:AddSection("Rock Farm")

	local RockAutoFarmDropdown = RockFarmSelection:AddDropdown("RockAutoFarmDropdown", {
		Title = "Rock to Farm",
		Description = "",
		Values = {"All",
			"Amethyst",
			"Amethyst Stone",
			"Coal",
			"Copper",
			"Diamond",
			"Diorite",
			"Electrite",
			"Gold",
			"Iron",
			"Obsidian",
			"Opal",
			"Stone"},
		Multi = true,
		Default = {"Stone"},
	})

	RockAutoFarmDropdown:OnChanged(function(Option)

		if type(Option) == "table" then
			local END = {}
			for i,v in pairs(Option) do
				table.insert(END,i)
			end

			Option = END
		end	

		_G.RockTarget = Option
	end)

--[[

local Slider = Tab:CreateSlider({
	Name = "Rock Fly Speed",
	Range = {10, 40},
	Increment = 5,
	Suffix = "Speed",
	CurrentValue = 25,
	Flag = "RockAutoFarmFlySpeed",
	Callback = function(Value)
		_G.RockFarmSpeed = Value
	end,
})

]]

	local RockAutoFarm = RockFarmSelection:AddToggle("RockAutoFarm", {Title = "Rock Auto Farm", Default = false })

	RockAutoFarm:OnChanged(function()

		local Value = Options.RockAutoFarm.Value

		if Value == true then
			_G.RockAutoFarm = true
		else
			_G.RockAutoFarm = false
		end
	end)

	local RockAura = RockFarmSelection:AddToggle("RockAura", {Title = "Rock Aura", Default = false })

	RockAura:OnChanged(function()

		local Value = Options.RockAura.Value

		if Value == true then
			_G.RockAura = true
		else
			_G.RockAura = false
		end
	end)

	local RockAutoFarmOnIslandDropdown = RockFarmSelection:AddDropdown("RockAutoFarmOnIslandDropdown", {
		Title = "Rock to Farm (On island)",
		Description = "Rock to Farm (On island)",
		Values = {"All",
			"Amethyst",
			"Amethyst Stone",
			"Coal",
			"Copper",
			"Diamond",
			"Diorite",
			"Electrite",
			"Gold",
			"Iron",
			"Obsidian",
			"Opal",
			"Stone"},
		Multi = true,
		Default = {"Stone"},
	})

	RockAutoFarmOnIslandDropdown:OnChanged(function(Option)

		if type(Option) == "table" then
			local END = {}
			for i,v in pairs(Option) do
				table.insert(END,i)
			end

			Option = END
		end	

		_G.RockTargetonIsland = Option
	end)


	local RockAutoFarmOnIsland = RockFarmSelection:AddToggle("RockAutoFarmOnIsland", {Title = "Rock Auto Farm (On Island!)", Default = false })

	RockAutoFarmOnIsland:OnChanged(function()

		local Value = Options.RockAutoFarmOnIsland.Value

		_G.RockFarmonIsland = Value
	end)


	local FishFarmSelection = Tabs.Main:AddSection("Fish Farm")

	local FishAutoFarm = FishFarmSelection:AddToggle("FishAutoFarm", {Title = "Fish Auto Farm", Default = false })

	FishAutoFarm:OnChanged(function()

		local Value = Options.FishAutoFarm.Value

		if Value == true then
			_G.FishFarm = true
		else
			_G.FishFarm = false
		end
	end)


--[[

local Section = Tab:CreateSection("Auto Upgrade Totem (BETA)")


local Dropdown = Tab:CreateDropdown({
	Name = "Totem",
	Options = {"totemWheat", "totemPineapple", "totemCarrot", "totemDragonfruit", "totemGrape", "totemMelon", "totemOnion", "totemPotato", "totemPumpkin", "totemRadish", "totemSpinach", "totemTomato"},
	CurrentOption = "totemWheat",
	Flag = "TotemDrop", 
	Callback = function(Option)
		_G.SelectedTotem = Option
	end,
})


local Dropdown = Tab:CreateDropdown({
	Name = "To Upgrade",
	Options = {"utility", "efficiency", "quality"},
	CurrentOption = "utility",
	Flag = "TotemDropUpgrade", 
	Callback = function(Option)
		_G.SelectedUpgrade = Option
	end,
})


local Slider = Tab:CreateSlider({
	Name = "Level",
	Range = {1, 53},
	Increment = 1,
	Suffix = "Level",
	CurrentValue = 25,
	Flag = "TotemLevel",
	Callback = function(Value)
		_G.TotemLevel = Value
	end,
})

Toggle = Tab:CreateToggle({
	Name = "Auto Upgrade",
	CurrentValue = false,
	Flag = "MobAutoFarmButton", 
	Callback = function(Value)
		if Value == true then
			_G.AutoUpgradeTotem = true 
		else
			_G.AutoUpgradeTotem = false
		end
	end,
})

Toggle = Tab:CreateToggle({
	Name = "Auto Collect Items!",
	CurrentValue = false,
	Flag = "AJIGnb", 
	Callback = function(Value)
		if Value == true then
			_G.AutoCollectTotemItems = true 
		else
			_G.AutoCollectTotemItems = false
		end
	end,
})


local CropUpgrabers = {"totemWheat", "totemPineapple", "totemCarrot", "totemDragonfruit", "totemGrape", "totemMelon", "totemOnion", "totemPotato", "totemPumpkin", "totemRadish", "totemSpinach", "totemTomato"}
local StoneUpgrabers = {}

function GetName(Real)
	local Selected

	for i,v in pairs(CropUpgrabers) do
		if v == Real then
			Selected = "totem_crop"
		end
	end

	DebugCheck(0,"Selected: "..Selected)

	return Selected
end

]]

	local VoidFarmSelection = Tabs.Main:AddSection("Void Farm")

	local voidParasiteFarm = VoidFarmSelection:AddToggle("voidParasiteFarm", {Title = "voidParasiteFarm", Default = false })

	voidParasiteFarm:OnChanged(function()

		local Value = Options.voidParasiteFarm.Value

		if Value == true then
			_G.voidParasiteFarm = true
		else
			_G.voidParasiteFarm = false
		end
	end)

	local voidParasiteUseSichle = VoidFarmSelection:AddToggle("voidParasiteUseSichle", {Title = "voidParasiteUseSichle", Default = false })

	voidParasiteUseSichle:OnChanged(function()

		local Value = Options.voidParasiteUseSichle.Value

		if Value == true then
			_G.VoidParasiteSichle = true
		else
			_G.VoidParasiteSichle = false
		end
	end)

	local voidParasiteBypassCooldown = VoidFarmSelection:AddToggle("voidParasiteBypassCooldown", {Title = "Bypass Cooldown", Default = false })

	voidParasiteBypassCooldown:OnChanged(function()

		local Value = Options.voidParasiteBypassCooldown.Value

		if Value == true then
			_G.VoidParasiteBypass = true
		else
			_G.VoidParasiteBypass = false
		end
	end)

	local SpiritFarmSelection = Tabs.Main:AddSection("Spirit Farm")

	local SpiritFarm = SpiritFarmSelection:AddToggle("SpiritFarm", {Title = "SpiritFarm", Default = false })

	SpiritFarm:OnChanged(function()

		local Value = Options.SpiritFarm.Value

		if Value == true then
			_G.SpiritAutoFarmBool = true
		else
			_G.SpiritAutoFarmBool = false
		end
	end)

	local TeleportsSelection = Tabs.Teleports:AddSection("Teleports")

	TeleportsSelection:AddButton({
		Title = "Teleport Home",
		Description = "",
		Callback = function()
			OwnISland()
		end
	})

	TeleportsSelection:AddButton({
		Title = "Teleport Hub",
		Description = "",
		Callback = function()

			local Portal = nil

			local Island = GetIsland()
			local Blocks = Island:FindFirstChild("Blocks")

			if not Portal or Portal.Parent ~= GetIsland():FindFirstChild("Blocks") then
				print("No Portal set... Getting!")
				local Island = GetIsland()
				if Island and Island:FindFirstChild("Blocks") then
					for i,v in pairs(Island:FindFirstChild("Blocks"):GetChildren()) do 
						if v:FindFirstChild("PortalActive") and v:FindFirstChild("portal-to-spawn") then
							Portal = v
						end
					end 
				end 
			end

			if Blocks then
				-- local Portal = Blocks:FindFirstChild("portalToSpawn")
				if Portal then
					local CollisionBoxes = Portal:FindFirstChild("CollisionBoxes")
					if CollisionBoxes then
						Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CollisionBoxes:FindFirstChild("Part").CFrame
					end
				else
					local Island = GetIsland()
					if Island and Island:FindFirstChild("Blocks") then
						local Portal = game:FindFirstChild("portalToSpawn")
						if Portal then
							local CollisionBoxes = Portal:FindFirstChild("CollisionBoxes")
							if CollisionBoxes then
								Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CollisionBoxes:FindFirstChild("Part").CFrame
							end
						end
					end 
				end

			end
		end
	})

	TeleportsSelection:AddButton({
		Title = "Teleport Slime",
		Description = "",
		Callback = function()
			Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(151.095261, 37.1357651, -734.216797, 0.659632802, 0.00193329761, -0.751585543, 0.000203342643, 0.999996185, 0.00275074691, 0.751588047, -0.0019673123, 0.659629822)
		end
	})
	TeleportsSelection:AddButton({
		Title = "Teleport Buf",
		Description = "",
		Callback = function()
			Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(885.378052, 180.972031, 23.2142296, -0.869998932, 0, -0.493053645, 0, 1, 0, 0.493053645, 0, -0.869998932)
		end
	})

	TeleportsSelection:AddButton({
		Title = "Teleport witch",
		Description = "",
		Callback = function()
			Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1709.62317, 448.131409, -204.412949, 0.789979517, -0, -0.613133252, 0, 1, -0, 0.613133252, 0, 0.789979517)
		end
	})
	TeleportsSelection:AddButton({
		Title = "Teleport Desert",
		Description = "",
		Callback = function()
			Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1475.44434, 342.177856, -875.548889, -0.0172599554, 0, 0.999851167, 0, 1, 0, -0.999851167, 0, -0.0172599554)
		end
	})

	TeleportsSelection:AddButton({
		Title = "Teleport Hub Mine",
		Description = "",
		Callback = function()
			Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(686.588013, 200.419006, -229.044998, 0.792934179, 0, 0.609307289, 0, 1, 0, -0.609307289, 0, 0.792934179)
			task.wait(3)
			TeleportV4(Vector3.new(251.06788635253906, 25.95274543762207, -635.4160766601562))
		end
	})

	TeleportsSelection:AddButton({
		Title = "Teleport Pirat island",
		Description = "",
		Callback = function()
			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.TravelPirateIsland:FireServer(false)
		end
	})

	TeleportsSelection:AddButton({
		Title = "Teleport Spiret island",
		Description = "",
		Callback = function()
			Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(654.445801, 184.972031, -134.859695, 0.165726423, -0, -0.986171782, 0, 1, -0, 0.986171782, 0, 0.165726423)
		end
	})

	local BlockPrinterSelection = Tabs.BlockPrinter:AddSection("Block Printer")

	local StartBlock = nil
	local EndBlock = nil

	local BlockPrinterBlocks = BlockPrinterSelection:AddParagraph({
		Title = "- Blocks:",
		Content = "/"
	})
	local BlockPrinterTime = BlockPrinterSelection:AddParagraph({
		Title = "- Time:",
		Content = "/"
	})

	local BlockPrinterDestroyTime


	--local BlocksToPlaceParagraph = BP3Tab:CreateParagraph({Title = "Blocks: ", Content = "/"})
	--local BlocksTimeParagraph = BP3Tab:CreateParagraph({Title = "Time: ", Content = "/"})

	local DestroyBlocksTimeParagraph

	local selectionBox
	local selectionLasso
	local handles

	local MainPart 


	game:GetService("RunService").RenderStepped:Connect(function()
		if selectionBox then
			selectionBox.Color3 = _G.ResizeToolOutlineColor or Color3.fromRGB(65, 105, 225) -- dodger blue
		end
		if handles then
			handles.Color3 = _G.ResizeToolMoveButtonColor or Color3.fromRGB(65, 105, 225) -- dodger blue
		end
		if MainPart then
			MainPart.Transparency = _G.ResizeToolFillTransparency
			if _G.ResizeToolFillColor then
				MainPart.Color = _G.ResizeToolFillColor
			end
		end
	end)

	local previousDistance

	function GetBlockCount()
		local positions = {}

		local function checkPositions(start, finish)
			local minX = math.min(start.x, finish.x)
			local maxX = math.max(start.x, finish.x)
			local minY = math.min(start.y, finish.y)
			local maxY = math.max(start.y, finish.y)
			local minZ = math.min(start.z, finish.z)
			local maxZ = math.max(start.z, finish.z)
			return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
		end


		local start_BLOCK = _G.StartBlock or StartBlock
		local start = start_BLOCK.Position
		local finish_Block = _G.EndBlock or EndBlock
		local _finish = finish_Block.Position

		start, finish = checkPositions(start, _finish)



		for x = start.x, finish.x, 3 do
			for y = start.y, finish.y, 3 do
				for z = start.z, finish.z, 3 do
					positions[#positions + 1] = Vector3.new(x, y, z)
				end
			end
		end

		local BlockPlaceCount = 0
		for i,v in ipairs(positions) do
			BlockPlaceCount = BlockPlaceCount + 1
		end

		BlockPrinterBlocks:SetDesc(BlockPlaceCount)

		--BlocksToPlaceParagraph:Set({Title = "Blocks: ", Content = BlockPlaceCount/10})

		if BlockPrinterDestroyTime then
			BlockPrinterDestroyTime:SetDesc(BlockPlaceCount.." Secs")
		end	

		if _G.FastBlockPrinter == true then
			local TIME = BlockPlaceCount/30
			BlockPrinterTime:SetDesc(TIME.." sec")
		else
			local TIME = BlockPlaceCount/10
			BlockPrinterTime:SetDesc(TIME.." sec")
		end

		return BlockPlaceCount
	end


	function addBoxes(part)



		local position = part.Position
		local size = part.Size

		local oldPartR = game.Workspace:FindFirstChild("Part_R")
		if oldPartR then
			oldPartR:Destroy()
		end


		local part2 = Instance.new("Part")
		part2.Name = "Part_R"
		part2.Parent = game.Workspace
		part2.Size = Vector3.new(3, 3, 3)
		part2.Anchored = true
		part2.Transparency = 1
		part2.CanCollide = false
		part2.Position = Vector3.new(position.x + size.x/2 - part2.Size.x/2, position.y + size.y/2 - part2.Size.y/2, position.z + size.z/2 - part2.Size.z/2)
		part2.Color = Color3.new(1, 0, 0)
		part2.CastShadow = false
		part2.Material = Enum.Material.Neon


		local oldPartL = game.Workspace:FindFirstChild("Part_L")
		if oldPartL then
			oldPartL:Destroy()
		end


		local part3 = Instance.new("Part")
		part3.Name = "Part_L"
		part3.Parent = game.Workspace
		part3.Size = Vector3.new(3, 3, 3)
		part3.Anchored = true
		part3.Transparency = 1
		part3.CanCollide = false
		part3.Position = Vector3.new(position.x - size.x/2 + part3.Size.x/2, position.y - size.y/2 + part3.Size.y/2, position.z - size.z/2 + part3.Size.z/2)
		part3.Color = Color3.new(0, 0.6, 1)
		part3.CastShadow = false
		part3.Material = Enum.Material.Neon


		_G.StartBlock = game:GetService("Workspace")["Part_L"]
		_G.EndBlock = game:GetService("Workspace")["Part_R"]
		GetBlockCount()



	end

	function onHandlesDown(normal)
		DebugCheck(0,"handlesDown")
		previousDistance = 0
	end
	function onHandlesDrag(normal, distance)

		for i,v in pairs(game:GetService("Players"):GetChildren()) do
			if v.Character then
				for i,Part in pairs(v.Character:GetDescendants()) do
					if Part:IsA("MeshPart") or Part:IsA("Part") then
						if Part:FindFirstChild("OLD_CanTouch") then
							Part.CanTouch = false
						else
							local OLDSTATE = Instance.new("BoolValue", Part)
							OLDSTATE.Name = "OLD_CanTouch"
							OLDSTATE.Value = Part.CanTouch
							Part.CanTouch = false
						end
					end
				end
			end
		end

		local OldSIZE = nil
		local OldPOS = nil

		if handles.Adornee then
			local delta = distance - previousDistance
			if math.abs(delta) >= 3 then
				local sizeDelta = math.floor(delta / 3 + 0.5) * 3
				OldSIZE = handles.Adornee.Size
				OldPOS = handles.Adornee.Position
				if handles.Adornee:Resize(normal, sizeDelta) then
					print("Versuche zu Resizen")
					print("normal",normal)
					print("sizeDelta",sizeDelta)
					addBoxes(handles.Adornee)
					if handles.Adornee.Size.X < 3 or handles.Adornee.Size.Y < 3 or handles.Adornee.Size.Z < 3 then
						print("Kleiner als 0")
						handles.Adornee.Size = OldSIZE
						handles.Adornee.Position = OldPOS
					end
					previousDistance = distance
				else
					print(tostring(handles.Adornee.Size))
					print("Resize ging nicht!")
					print("normal",normal)
					print("sizeDelta",sizeDelta)
				end
			end
		end

		task.wait(1)

		for i,v in pairs(game:GetService("Players"):GetChildren()) do
			if v.Character then
				for i,Part in pairs(v.Character:GetDescendants()) do
					if Part:IsA("MeshPart") or Part:IsA("Part") then
						if Part:FindFirstChild("OLD_CanTouch") then
							local OLDSTATE = Part:FindFirstChild("OLD_CanTouch") 
							Part.CanTouch = OLDSTATE.Value
						end
					end
				end
			end
		end
	end

	function onButton1Down(mouse)
		if _G.ResizeTool == true and _G.ChangePartOfResizeTool == true then
			_G.ChangePartOfResizeTool = false
			DebugCheck(0,"3DButtonDown")
			if mouse.Target == nil or mouse.Target.Locked then
				print("No Target or Locked!")
				selectionBox.Adornee = nil
				handles.Adornee = nil
			else
				local OLD = mouse.Target

				if OLD:FindFirstChild("Health") and OLD.Size.X == 3 then
					local NP 

					if game:GetService("Workspace"):FindFirstChild("NewPart") then
						NP = game:GetService("Workspace"):FindFirstChild("NewPart") 
					else
						NP = Instance.new("Part",workspace)
					end


					NP.Name = "NewPart"
					NP.Transparency = 1
					NP.Anchored = true
					NP.Size = OLD.Size
					NP.Position = OLD.Position
					NP.CanCollide = false
					NP.CastShadow = false
					NP.Material = Enum.Material.Neon
					selectionBox.Adornee = NP
					handles.Adornee = NP
					handles.Faces = NP.ResizeableFaces
					MainPart = NP
				else
					print(tostring(OLD.Size))
				end 

			end
		end
	end




	function onEquippedLocal(mouse)
		mouse.Button1Down:connect(function() onButton1Down(mouse) end)

		local character = game.Players.LocalPlayer.Character
		local player = game.Players:GetPlayerFromCharacter(character)

		selectionBox = Instance.new("SelectionBox")
		selectionBox.Color = BrickColor.Blue()
		selectionBox.Adornee = nil
		selectionBox.Parent = game:GetService("CoreGui")

		handles = Instance.new("Handles")
		handles.Color3 = _G.ResizeToolMoveButtonColor or Color3.fromRGB(65, 105, 225) -- dodger blue
		handles.Adornee = nil
		handles.MouseDrag:connect(onHandlesDrag)
		handles.MouseButton1Down:connect(onHandlesDown)
		handles.Parent = game:GetService("CoreGui")
	end

	function onUnequippedLocal()
		if selectionBox then
			selectionBox:Remove()
		end
		if handles then
			handles:Remove()
		end
	end

	local UseResizeTool = BlockPrinterSelection:AddToggle("UseResizeTool", {Title = "Use Resize Tool", Default = false })

	UseResizeTool:OnChanged(function()
		local Value = Options.UseResizeTool.Value
		if Value == true then
			_G.ResizeTool = true 
			onEquippedLocal(game.Players.LocalPlayer:GetMouse())
			_G.ChangePartOfResizeTool = true
		else
			onUnequippedLocal(game.Players.LocalPlayer:GetMouse())
			if 	game:GetService("Workspace"):FindFirstChild("NewPart") then
				game:GetService("Workspace").NewPart:Destroy()
			end
			if 	game:GetService("Workspace"):FindFirstChild("Part_R") then
				game:GetService("Workspace").Part_R:Destroy()
			end
			if 	game:GetService("Workspace"):FindFirstChild("Part_L") then
				game:GetService("Workspace").Part_L:Destroy()
			end
			_G.ResizeTool = false 

			_G.ChangePartOfResizeTool = true
		end
	end)

	BlockPrinterSelection:AddButton({
		Title = "Change Position",
		Description = "",
		Callback = function()
			_G.ChangePartOfResizeTool = true
		end
	})

	function DebugCheck(N,Text)
		if _G.DebugMode == true then
			rconsolename("Debug")
			if N == nil then
				N = 0
			end 
			if N == 0 then
				rconsoleprint("\n"..Text)
			end
		end
	end

	function DebugCheck(N,Text)
		if _G.DebugMode == true then
			rconsolename("Debug")
			if N == nil then
				N = 0
			end 
			if N == 0 then
				rconsoleprint("\n"..Text)
			end
		end
	end

	function MoveToolGenPrimarypart(model)
		if model and model:IsA("Model") then
			if model:FindFirstChild("PrimaryPart") == nil then			
				local cf = model:GetBoundingBox()
				local prim = Instance.new("Part", model)
				prim.Anchored = true
				prim.Name = "PrimaryPart"
				-- prim.Size = model:GetModelSize()
				prim.Transparency = 0.5
				prim.CFrame = cf
				prim.CanCollide = false
				model.PrimaryPart = prim
				for i, v in next, model:GetDescendants() do
					if v.Parent == game.Players.LocalPlayer.Character or v.Parent.Name == game.Players.LocalPlayer.Name then

					else
						if (not v:IsA("BasePart")) and v ~= game.Players.LocalPlayer.Character and v.Parent ~= game.Players.LocalPlayer.Character then end -- continue
						local w = Instance.new("WeldConstraint", prim)
						w.Part0 = prim
						w.Part1 = v
					end
				end
				model.PrimaryPart = prim
			else
				-- gibts halt schon tf
			end
		end
	end

	function findCenter(Table)
		local parts = Table:GetChildren()
		local numVisibleParts = 0
		local totalPosition = Vector3.new(0, 0, 0)
		local MittigsterBlock = nil


		for _, part in ipairs(parts) do
			if part:IsA("Part") or part:IsA("MeshPart") then
				print(part.Name)
				totalPosition = totalPosition + part.Position
				MittigsterBlock = part
				numVisibleParts = numVisibleParts + 1
			else
				print(part.Name.." ist ein "..part.ClassName)
			end
		end


		if numVisibleParts > 0 then
			local centerPos = totalPosition / numVisibleParts
			return MittigsterBlock
		else
			return nil 
		end
	end

	function LoadRotateTool()
		local runService = game:GetService("RunService")
		local tweenService = game:GetService("TweenService")

		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()

		local playerGui = player.PlayerGui 
		local mouse = player:GetMouse()

		local ancestor = Instance.new("Folder", game:GetService("CoreGui"))


		local rotateHandles = Instance.new("Folder", game:GetService("CoreGui"))


		local X_AXIS = Instance.new("ArcHandles")
		X_AXIS.Color3 = Color3.new(250,0,0)
		X_AXIS.Transparency = 0
		X_AXIS.Visible = true
		X_AXIS.Parent = rotateHandles

		local Y_AXIS = Instance.new("ArcHandles")
		Y_AXIS.Color3 = Color3.new(0, 255, 0)
		Y_AXIS.Transparency = 0
		Y_AXIS.Visible = true
		Y_AXIS.Parent = rotateHandles


		local Z_AXIS = Instance.new("ArcHandles")
		Z_AXIS.Color3 = Color3.new(0, 0, 255)
		Z_AXIS.Transparency = 0
		Z_AXIS.Visible = true
		Z_AXIS.Parent = rotateHandles

		local hoverBox = Instance.new("SelectionBox")
		hoverBox.Color3 = Color3.fromRGB(25, 153, 255)
		hoverBox.LineThickness = 0.04
		hoverBox.SurfaceColor3 = Color3.fromRGB(25, 153, 255)
		hoverBox.Parent = game:GetService("StarterGui")

		local selectedBox = Instance.new("SelectionBox")
		selectedBox.Color3 = Color3.fromRGB(25, 153, 255)
		selectedBox.LineThickness = 0.02
		selectedBox.SurfaceColor3 = Color3.fromRGB(25, 153, 255)
		selectedBox.Parent = game:GetService("StarterGui")

		local selectionBoxes = hoverBox and selectedBox

		local lastCFrame = CFrame.identity

		local originalCollisions = nil
		local originalTransparency = nil

		if not _G.currentlySelected then
			_G.currentlySelected = nil
		end

		function animateHoverBox()
			local hoverTween = tweenService:Create(
				hoverBox,
				TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true, 0),
				{Color3 = Color3.fromRGB(25, 153, 255)})

			hoverTween:Play()
			return hoverTween
		end

		function rotateSnap(distance, step)
			return math.floor(distance / step) * step
		end

		local RotateCOoldown = false
		function onRotate(axis, angle)
			local step = (90 / 180) * math.pi
			local newAngle = CFrame.fromAxisAngle(Vector3.FromAxis(axis), rotateSnap(angle, step))

			local gewuenschteDrehung = CFrame.Angles(math.rad(90), 0, 0)

			if RotateCOoldown == false then
				RotateCOoldown = true
				CloneFolder:SetPrimaryPartCFrame(CloneFolder:GetPrimaryPartCFrame() * newAngle)
				task.wait(0.3)
				RotateCOoldown = false
			end

				--[[

				for i, v in pairs(CloneFolder:GetChildren()) do
					if v:IsA("Part") or v:IsA("MeshPart") then
						-- Speichere die ursprüngliche CFrame des Teils
						local originalCFrame = v.CFrame
						
						-- Berechne die neue CFrame unter Berücksichtigung der Rotation
						local rotatedCFrame = originalCFrame * newAngle
						
						-- Setze die CFrame des Teils auf die berechnete gedrehte CFrame
						v.CFrame = rotatedCFrame
					end
				end

				]]

			-- _G.currentlySelected.CFrame = lastCFrame * newAngle
		end


		function onSelect()
			local target = mouse.Target

			if target and target:IsA("Model") or target:IsA("BasePart") and target.Locked == false and target.ClassName ~= "Terrain" then
				originalCollisions = target.CanCollide
				originalTransparency = target.Transparency

				for i, handle in next, rotateHandles:GetChildren() do
					if handle:IsA("ArcHandles") then
						handle.Adornee = target
					end
				end

				_G.currentlySelected = target
				selectedBox.Adornee = target
			elseif not target then
				for i, handle in next, rotateHandles:GetChildren() do
					if handle:IsA("ArcHandles") then
						handle.Adornee = nil
					end
				end

				_G.currentlySelected = nil
				selectedBox.Adornee = nil
			end
		end

		function onEquipped()
			selectionBoxes.Name = "RotateSelectionBoxes"
			selectionBoxes.Parent = playerGui

			rotateHandles.Parent = playerGui

			if _G.currentlySelected then
				originalCollisions = _G.currentlySelected.CanCollide
				originalTransparency = _G.currentlySelected.Transparency

				for i, handle in next, rotateHandles:GetChildren() do
					if handle:IsA("ArcHandles") then
						handle.Adornee = _G.currentlySelected
					end
				end

				selectedBox.Adornee = _G.currentlySelected
			end
		end

		function onEquipped2()

			function findCenter(Table)
				local parts = Table:GetChildren()
				local numVisibleParts = 0
				local totalPosition = Vector3.new(0, 0, 0)
				local MittigsterBlock = nil


				for _, part in ipairs(parts) do
					if part:IsA("Part") or part:IsA("MeshPart") then
						print(part.Name)
						totalPosition = totalPosition + part.Position
						MittigsterBlock = part
						numVisibleParts = numVisibleParts + 1
					else
						print(part.Name.." ist ein "..part.ClassName)
					end
				end


				if numVisibleParts > 0 then
					local centerPos = totalPosition / numVisibleParts
					return MittigsterBlock
				else
					return nil 
				end
			end

			local MiddlePart = findCenter(CloneFolder)

			if not MiddlePart then return nil end;

			selectionBoxes.Name = "RotateSelectionBoxes"
			selectionBoxes.Parent = playerGui

			rotateHandles.Parent = playerGui

			_G.currentlySelected = MiddlePart

			if _G.currentlySelected then
				originalCollisions = _G.currentlySelected.CanCollide
				originalTransparency = _G.currentlySelected.Transparency

				for i, handle in next, rotateHandles:GetChildren() do
					if handle:IsA("ArcHandles") then
						handle.Adornee = _G.currentlySelected
					end
				end

				selectedBox.Adornee = _G.currentlySelected
			end
		end

		function onUnequipped()
			if _G.currentlySelected then
				_G.currentlySelected.CanCollide = originalCollisions
				_G.currentlySelected.Transparency = originalTransparency
			end

			rotateHandles.Parent = ancestor
			selectionBoxes.Parent = ancestor
		end

		function onHover()
			local target = mouse.Target

			if ancestor.Parent == character and target and target.Locked == false then
				hoverBox.Adornee = target
			else
				hoverBox.Adornee = nil
			end
		end

		function onHold()
			lastCFrame = _G.currentlySelected.CFrame

			_G.currentlySelected.Transparency = _G.currentlySelected.Transparency + 0.3
			_G.currentlySelected.CanCollide = false
		end

		function onRelease()
			if _G.currentlySelected then
				local object = _G.currentlySelected
				object.Size = _G.currentlySelected.Size
				object.Position = _G.currentlySelected.Position
				object.Orientation = _G.currentlySelected.Orientation

				_G.currentlySelected.Transparency = originalTransparency
				_G.currentlySelected.CanCollide = originalCollisions
			end
		end

		for i, handle in next, rotateHandles:GetChildren() do
			if handle:IsA("ArcHandles") then
				handle.MouseDrag:connect(onRotate)
				handle.MouseButton1Down:connect(onHold)
				handle.MouseButton1Up:connect(onRelease)
			end
		end

		animateHoverBox()

		mouse.Move:connect(onHover)

		game:GetService("Players").LocalPlayer:GetMouse().Button1Down:Connect(function()
			if _G.UseRotateTool == true then
				onSelect()
			end	
		end)

		_G.UseRotateTool = false

		Toggle = BP3Tab:CreateToggle({
			Name = "Use Rotation Tool [BETA!]",
			CurrentValue = false,
			Flag = "Use Rotation Tool", 
			Callback = function(Value)
				--_G.UseRotateTool = Value
				if Value == true then
					onEquipped2()
					--onEquipped()
				else
					pcall(onUnequipped)
				end
			end,
		})

	end

	--LoadRotateTool()

	function LoadMovingTool()
		local moveHandle = Instance.new("Handles")
		moveHandle.Parent = game:GetService("CoreGui")
		moveHandle.Color3 = Color3.fromRGB(218, 133, 65)
		moveHandle.Style = Enum.HandlesStyle.Movement

		local selectedBox = Instance.new("SelectionBox")
		selectedBox.Color3 = Color3.fromRGB(25, 153, 255)
		selectedBox.LineThickness = 0.02
		selectedBox.SurfaceColor3 = Color3.fromRGB(25, 153, 255)
		selectedBox.Parent = game:GetService("CoreGui")


		local hoverBox = Instance.new("SelectionBox")
		hoverBox.Color3 = Color3.fromRGB(25, 153, 255)
		hoverBox.LineThickness = 0.04
		hoverBox.SurfaceColor3 = Color3.fromRGB(25, 153, 255)
		hoverBox.Parent = game:GetService("CoreGui")

		local player = game.Players.LocalPlayer
		local mouse = player:GetMouse()

		local selected = nil
		local orignalTransparency = nil

		local lastCframe = CFrame.identity

		function activated()

			print("activated")

			function findCenter(Table)
				local parts = Table:GetChildren()
				local numVisibleParts = 0
				local totalPosition = Vector3.new(0, 0, 0)
				local MittigsterBlock = nil


				for _, part in ipairs(parts) do
					if part:IsA("Part") or part:IsA("MeshPart") then
						print(part.Name)
						totalPosition = totalPosition + part.Position
						MittigsterBlock = part
						numVisibleParts = numVisibleParts + 1
					else
						print(part.Name.." ist ein "..part.ClassName)
					end
				end


				if numVisibleParts > 0 then
					local centerPos = totalPosition / numVisibleParts
					return MittigsterBlock
				else
					return nil 
				end
			end

			local MiddlePart = findCenter(CloneFolder)

			if not MiddlePart then return nil end;

			if CloneFolder and CloneFolder.PrimaryPart then

			else
				CloneFolder.PrimaryPart = MiddlePart
			end	


			local target = CloneFolder:FindFirstChild("PrimaryPart") or CloneFolder.PrimaryPart

			if target and target.Locked == false then
				print("Jup")
				selected = target
				orignalTransparency = selected.Transparency

				moveHandle.Parent = game.Players.LocalPlayer.PlayerGui
				moveHandle.Adornee = selected

				hoverBox.Parent = selected
				hoverBox.Adornee = selected

				selectedBox.Parent = selected
				selectedBox.Adornee = selected
			else
				selected = nil
				orignalTransparency = nil

				hoverBox.Parent = game:GetService("CoreGui")
				hoverBox.Adornee = selected

				moveHandle.Parent = game:GetService("CoreGui")
				moveHandle.Adornee = selected

				selectedBox.Parent = game:GetService("CoreGui")
				selectedBox.Adornee = selected
			end
		end

		function hoverSelection()
			local target = mouse.Target

			if target and target.Locked == false then
				hoverBox.Parent = target
				hoverBox.Adornee = target
			else
				hoverBox.Parent = game:GetService("CoreGui")
				hoverBox.Adornee = target
			end
		end

		function moveSnap(distance, step)
			return math.round(distance / step) * step
		end

		function onMove(face, distance)
			local step = moveSnap(distance, selected.ResizeIncrement)
			local move = Vector3.FromNormalId(face) * step

			local stepSize = 3
			local roundedDistance = math.floor(distance / stepSize + 0.5) * stepSize
			local resizedStep = moveSnap(roundedDistance, selected.ResizeIncrement)
			local resizedMove = Vector3.FromNormalId(face) * resizedStep

			print("move:",move)

			print("roundedDistance:",roundedDistance)

			print("resizedStep:",resizedStep)

			print("resizedMove:",resizedMove)

			-- selected.CFrame = lastCframe * CFrame.new(resizedMove)

			CloneFolder:SetPrimaryPartCFrame(lastCframe * CFrame.new(resizedMove))

		end

		function onHold()
			lastCframe = selected.CFrame
			selected.Transparency = selected.Transparency + 0.3
			selected.CanCollide = false
		end

		function onRelease()	
			selected.Transparency = orignalTransparency
			--selected.CanCollide = true
		end

		function unequipped()
			moveHandle.Parent = game:GetService("CoreGui")
			moveHandle.Adornee = nil -- selected

			hoverBox.Parent = game:GetService("CoreGui")
			hoverBox.Adornee = nil -- selected

			selectedBox.Parent = game:GetService("CoreGui")
			selectedBox.Adornee = nil -- selected
		end

		moveHandle.MouseDrag:connect(onMove)
		moveHandle.MouseButton1Down:connect(onHold)
		moveHandle.MouseButton1Up:connect(onRelease)
		--mouse.Move:connect(hoverSelection)

		--[[

		game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
			if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
				activated()
			end
		end)

		]]


		local UseMovingTool = BlockPrinterSelection:AddToggle("UseMovingTool", {Title = "Use Moving Tool", Default = false })

		UseMovingTool:OnChanged(function()
			local Value = Options.UseMovingTool.Value
			if Value == true then
				activated()
			else
				pcall(unequipped)
			end
		end)


		-- unequipped()
	end

	LoadMovingTool()

	local BlockPrinterSpeed = BlockPrinterSelection:AddSlider("BlockPrinterSpeed", {
		Title = "Block Printer Speed",
		Description = "",
		Default = 5,
		Min = 1,
		Max = 20,
		Rounding = 0,
		Callback = function(Value)
			print("Slider was changed:", Value)
		end
	})

	BlockPrinterSpeed:OnChanged(function(Value)
		_G.PlayerBlockPrinterSpeed = Value
	end)



	function ADDUPPDATEEEEEEE()
		local positions = {}
		local function checkPositions(start, finish)
			local minX = math.min(start.x, finish.x)
			local maxX = math.max(start.x, finish.x)
			local minY = math.min(start.y, finish.y)
			local maxY = math.max(start.y, finish.y)
			local minZ = math.min(start.z, finish.z)
			local maxZ = math.max(start.z, finish.z)
			return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
		end

		local start = _G.StartBlock.Position
		local finish = _G.EndBlock.Position
		start, finish = checkPositions(start, finish)

		for x = start.x, finish.x, 3 do
			for y = start.y, finish.y, 3 do
				for z = start.z, finish.z, 3 do
					positions[#positions + 1] = Vector3.new(x, y, z)
				end
			end
		end
	end

	function ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD(positions,XX)

		local ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDANTILAG = false

		local MAXPLACEDIS = XX or 50

		for i,v in ipairs(positions) do
			if v ~= nil then
				-- TeleportV4(v + Vector3.new(0,10,0))
			end
		end


		local FFFFPOS = {}

		for i,v in pairs(positions) do
			if v then
				FFFFPOS[i] = v
			end
		end

		game:GetService("RunService").RenderStepped:connect(function()
			if ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDANTILAG == false then
				ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDANTILAG = true
				for i,v in ipairs(FFFFPOS) do
					if v then

						local ToLace
						local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
						if Tool then
							ToLace = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name
						end



						local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
						if Tool then
							if Tool:FindFirstChild("seeds") then
								function removeSeeds(itemName)
									local index = string.find(itemName, "Seeds")
									if index ~= nil then
										return string.sub(itemName, 1, index - 1)
									else
										return itemName
									end
								end
								ToLace = removeSeeds(ToLace)
								_G.CropModus = true
							else
								_G.CropModus = false
							end
						end
						local PlaceHASHName = RemoteData:FindFirstChild("BlockPlaceHashData").Value
						local PlaceHASH = _G.BlockPlaceHash
						if (v - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < MAXPLACEDIS  then
							local args = {
								["upperBlock"] = false,
								["cframe"] = CFrame.new(v),
								["blockType"] = ToLace,
								[PlaceHASHName] = PlaceHASH
							}


							game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(args)
							FFFFPOS[i] = nil
						end
					end
				end
				task.wait()
				ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDANTILAG = false
			end 
		end)
	end



	function PlaceBlocksNew()

		local BlockCount = 1

		local StartPosition = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		local function PlaceBlock(position, ToLace, PlaceHASHName, PlaceHASH)
			local args = {
				[PlaceHASHName] = PlaceHASH,
				["cframe"] = CFrame.new(position),
				["blockType"] = ToLace,
				["upperBlock"] = false
			}
			if _G.BlockPrinterTP == true then
				TeleportV4(position + Vector3.new(0,10,0))
			end
			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(args)
		end

		if not game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then Message("WARNING!","Please Hold the Block you want to Place!", "Okay!", 3) return nil end 

		if _G.StartBlock == nil and _G.EndBlock == nil then Message("WARNING!","StartBlock and Endblock are not Set!", "Okay!", 3) return nil end

		if _G.StartBlock == nil then Message("WARNING!","StartBlock is not Set!", "Okay!", 3) return nil end

		if _G.EndBlock == nil then Message("WARNING!","EndBlock is not Set!", "Okay!", 3) return nil end

		local ToLace

		local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if Tool then
			if Tool:FindFirstChild("seeds") then
				function removeSeeds(itemName)
					local index = string.find(itemName, "Seeds")
					if index ~= nil then
						return string.sub(itemName, 1, index - 1)
					else
						return itemName
					end
				end
				ToLace = removeSeeds(Tool.Name)
				_G.CropModus = true
				DebugCheck(0,"Crop Mode: true")
			else
				ToLace = Tool.Name
				_G.CropModus = false
			end
		end


		for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if child:IsA("BasePart") and child.CanCollide == true then
				child.CanCollide = false
			end
		end

		if _G.BlockPrinterTP == true then
			sFLY(true)
		end

		local positions = {}

		local function checkPositions(start, finish)
			local minX = math.min(start.x, finish.x)
			local maxX = math.max(start.x, finish.x)
			local minY = math.min(start.y, finish.y)
			local maxY = math.max(start.y, finish.y)
			local minZ = math.min(start.z, finish.z)
			local maxZ = math.max(start.z, finish.z)
			return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
		end

		local start = _G.StartBlock.Position
		local finish = _G.EndBlock.Position
		start, finish = checkPositions(start, finish)

		for x = start.x, finish.x, 3 do
			for y = start.y, finish.y, 3 do
				for z = start.z, finish.z, 3 do
					positions[#positions + 1] = Vector3.new(x, y, z)
				end
			end
		end



		local BlockPlaceCount = 0
		for i,v in ipairs(positions) do
			BlockPlaceCount = BlockPlaceCount + 1
		end

		task.spawn(function()
			if positions[1] then
				TeleportV4(positions[1] + Vector3.new(0,15,0))
				PlaceBlock(positions[1], ToLace, PlaceHASHName, PlaceHASH)
			end
		end)

		DebugCheck(0,"To Place: "..BlockPlaceCount)

		if _G.BlockPrinterTP == true then
			game.Players.LocalPlayer.Character:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,10,0))
		end

		task.wait(2)

		for i = 1,_G.PlayerBlockPrinterSpeed do
			for i,v in pairs(positions) do
				task.wait()
				task.spawn(function()
					if v then
						local dis = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v).Magnitude
						if dis > 30 then
							if _G.BlockPrinterTP == true then
								TeleportV4(v + Vector3.new(0,10,0))
								repeat wait(0.1) TeleportV4(v + Vector3.new(0,10,0)) until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v).Magnitude < 30
								if v then
									PlaceBlock(v, ToLace, PlaceHASHName, PlaceHASH)
									positions[i] = nil
								end
							else
								if v then
									PlaceBlock(v, ToLace, PlaceHASHName, PlaceHASH)
									positions[i] = nil
								end
							end
						else
							if v then
								PlaceBlock(v, ToLace, PlaceHASHName, PlaceHASH)
								positions[i] = nil
							end
						end
					end
				end)
			end
		end

		print("positions debug: ",type(positions))

		if type(positions) == "table" then
			for i,v in pairs(positions) do
				warn(i,v)
			end
		else
			print("OTHER TYPE OF POSITIONS!",type(positions))
		end

		repeat wait() print("Es gibt noch positions!", positions) until positions == nil or #positions == 0

		DebugCheck(0,"FERTIG!!!!!")

		NOFLY()

		Message("Finished!","Block Printer Finished! (Teleporting back to Start Position...)", "Nice!", 3)

		task.wait(0.1)

		TeleportV4(StartPosition)

	end


	local function DestroyBlocksNew()

		local BlockCount = 1

		local saved = {}

		local function DestroyBlock(Block)
			DebugCheck(0,"DestroyBlock_FUJNC")
			if Block then
				local H1 = RemoteData:FindFirstChild("TreeHashData").Value
				local H2 = _G.TreeHash

				local ohTable1 = {
					[H1] = H2,
					["part"] = Block,
					["block"] = Block,
					["norm"] = v,
					["pos"] = 0
				}
				TeleportV4(Block.Position + Vector3.new(0,10,0))
				game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(ohTable1)
				task.wait(1)
				if Block then
					table.insert(saved,Block)
				end
			end
		end

		if _G.StartBlock == nil and _G.EndBlock == nil then Message("WARNING!","StartBlock and Endblock are not Set!", "Okay!", 3) return nil end

		if _G.StartBlock == nil then Message("WARNING!","StartBlock is not Set!", "Okay!", 3) return nil end

		if _G.EndBlock == nil then Message("WARNING!","EndBlock is not Set!", "Okay!", 3) return nil end

		local ToLace


		for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if child:IsA("BasePart") and child.CanCollide == true then
				child.CanCollide = false
			end
		end

		if _G.BlockPrinterTP == true then
			sFLY(true)
		end


		task.wait(0.1)

		local positions = {}

		task.wait(1)

		-- AUG

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

		if 	game:GetService("Workspace"):FindFirstChild("NewPart") then

			local PART = game:GetService("Workspace"):FindFirstChild("NewPart")
			local BLOCKS = GetBlocks(PART.Position, PART.Size, PART)

			-- Funktion zum Finden des nächsten Teils


			for i = 1,_G.PlayerBlockPrinterSpeed do
				for i,SB in pairs(BLOCKS) do
					task.wait()
					task.spawn(function()
						if SB and SB.Parent and SB.Parent.Name == "Blocks" then
							DebugCheck(0,"SB:",SB.Name)
							local dis = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - SB.Position).Magnitude
							if dis > 30 then
								DebugCheck(0,"IDS")
								if _G.BlockPrinterTP == true then
									TeleportV4(SB.Position + Vector3.new(0,10,0))
									repeat wait(0.1) TeleportV4(SB.Position + Vector3.new(0,10,0)) until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - SB.Position).Magnitude < 30
									if v then
										DebugCheck(0,"VTRUE")
										DestroyBlock(SB)
										saved[i] = nil
									end
								else
									if v then
										DebugCheck(0,"VFALSE")
										DestroyBlock(SB)
										saved[i] = nil
									end
								end
							else
								DebugCheck(0,"NODIS")
								if SB then
									DebugCheck(0,"VELSEFALSE")
									DestroyBlock(SB)
									saved[i] = nil
								end
							end
						end
					end)
				end
			end
		end

		for i = 1,100 do
			if saved == {} then

			else
				local positions = {}

				local function checkPositions(start, finish)
					local minX = math.min(start.x, finish.x)
					local maxX = math.max(start.x, finish.x)
					local minY = math.min(start.y, finish.y)
					local maxY = math.max(start.y, finish.y)
					local minZ = math.min(start.z, finish.z)
					local maxZ = math.max(start.z, finish.z)
					return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
				end

				local start = _G.StartBlock.Position
				local finish = _G.EndBlock.Position
				start, finish = checkPositions(start, finish)

				for x = start.x, finish.x, 3 do
					for y = start.y, finish.y, 3 do
						for z = start.z, finish.z, 3 do
							positions[#positions + 1] = Vector3.new(x, y, z)
						end
					end
				end

				if 	game:GetService("Workspace"):FindFirstChild("NewPart") then
					local PART = game:GetService("Workspace"):FindFirstChild("NewPart")
					local BLOCKS = GetBlocks(PART.Position, PART.Size, PART)
					for i,SB in pairs(BLOCKS) do
						task.spawn(function()
							if SB and SB.Parent and SB.Parent.Name == "Blocks" then

								local H1 = RemoteData:FindFirstChild("TreeHashData").Value
								local H2 = _G.TreeHash

								local ohTable1 = {
									[H1] = H2,
									["part"] = SB,
									["block"] = SB,
									["norm"] = v,
									["pos"] = 0
								}


								local RemotesToSend = _G.RemotesToSendToDestroy or 3

								for i = 1,1 do
									game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(ohTable1)
								end



								task.wait()

							end
						end)

					end
				end

				for i = 1,_G.PlayerBlockPrinterSpeed do
					for i,SB in pairs(saved) do
						task.wait()
						task.spawn(function()
							if SB and SB.Parent and SB.Parent.Name == "Blocks" then
								DebugCheck(0,"SB:",SB.Name)
								local dis = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - SB.Position).Magnitude
								if dis > 10 then
									DebugCheck(0,"IDS")
									if _G.BlockPrinterTP == true then
										TeleportV4(SB.Position + Vector3.new(0,10,0))
										repeat wait(0.1) TeleportV4(SB.Position + Vector3.new(0,10,0)) until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - SB.Position).Magnitude < 10
										if v then
											DebugCheck(0,"VTRUE")
											DestroyBlock(SB)
											saved[i] = nil
										end
									else
										if v then
											DebugCheck(0,"VFALSE")
											DestroyBlock(SB)
											saved[i] = nil
										end
									end
								else
									DebugCheck(0,"NODIS")
									if SB then
										DebugCheck(0,"VELSEFALSE")
										DestroyBlock(SB)
										saved[i] = nil
									end
								end
							end

						end)
					end
				end
			end
			local positions = {}

			local function checkPositions(start, finish)
				local minX = math.min(start.x, finish.x)
				local maxX = math.max(start.x, finish.x)
				local minY = math.min(start.y, finish.y)
				local maxY = math.max(start.y, finish.y)
				local minZ = math.min(start.z, finish.z)
				local maxZ = math.max(start.z, finish.z)
				return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
			end

			local start = _G.StartBlock.Position
			local finish = _G.EndBlock.Position
			start, finish = checkPositions(start, finish)

			for x = start.x, finish.x, 3 do
				for y = start.y, finish.y, 3 do
					for z = start.z, finish.z, 3 do
						positions[#positions + 1] = Vector3.new(x, y, z)
					end
				end
			end

			if 	game:GetService("Workspace"):FindFirstChild("NewPart") then
				local PART = game:GetService("Workspace"):FindFirstChild("NewPart")
				local BLOCKS = GetBlocks(PART.Position, PART.Size, PART)
				for i,SB in pairs(BLOCKS) do
					task.spawn(function()
						if SB and SB.Parent and SB.Parent.Name == "Blocks" then

							local H1 = RemoteData:FindFirstChild("TreeHashData").Value
							local H2 = _G.TreeHash

							local ohTable1 = {
								[H1] = H2,
								["part"] = SB,
								["block"] = SB,
								["norm"] = v,
								["pos"] = 0
							}


							local RemotesToSend = _G.RemotesToSendToDestroy or 3

							for i = 1,1 do
								game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(ohTable1)
							end

							task.wait()

						end
					end)

				end
			end

		end

		DebugCheck(0,"FERTIG!!!!!")

		NOFLY()

	end

	BlockPrinterSelection:AddButton({
		Title = "Print Blocks",
		Description = "",
		Callback = function()
			PlaceBlocksNew()
		end
	})

	_G.GetBlockMethod = "Place Block"

	local InputService = game:GetService("UserInputService")
	InputService.InputBegan:Connect(function(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then

		--[[-
		local mouseHit = Vector3.new(game.Players.LocalPlayer:GetMouse().Hit
		if _G.GetBlockMethod == "MouseClick" then
			if _G.GetStartBlock == true then
				_G.StartBlock = mouseHit
				_G.GetStartBlock = false
			elseif _G.GetEndBlock == true then
				_G.EndBlock = mouseHit
				_G.GetEndBlock = false
			end
		--]]

			if _G.GetBlockMethod == "Place Block" then
				if _G.GetStartBlock == true then
					local Island = GetIsland()
					local Blocks  = Island:FindFirstChild("Blocks")

					local STARTADDED = Blocks.ChildAdded:connect(function(v)
						if _G.GetStartBlock == true then
							if v.Name == game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name then
								StartBlockParagraph:Set({Title = "StartBlock: ", Content = ":GreenCube: | "..v.Name})
								_G.StartBlock = v
								StartBlock = v
								_G.GetStartBlock = false
								if _G.StartBlock ~= nil and _G.EndBlock ~= nil then
									GetBlockCount()
								end
								STARTADDED:Disconnect()

							end
						end
					end)
				elseif _G.GetEndBlock == true then
					local Island = GetIsland()
					local Blocks  = Island:FindFirstChild("Blocks")

					local ENDADDED = Blocks.ChildAdded:connect(function(v)
						if _G.GetEndBlock == true then
							if v.Name == game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name then
								EndBlockParagraph:Set({Title = "EndBlock: ", Content = ":GreenCube: | "..v.Name})
								_G.EndBlock = v
								EndBlock = v
								_G.GetEndBlock = false
								if _G.StartBlock ~= nil and _G.EndBlock ~= nil then
									GetBlockCount()
								end
								ENDADDED:Disconnect()
							end
						end
					end)
				end
			end
		end
	end)


	function COPYPASTEGUI()
		-- Block Destroy -- 
		local BlockDestroySelection = Tabs.BlockPrinter:AddSection("Block Destroyer")

		BlockPrinterDestroyTime = BlockPrinterSelection:AddParagraph({
			Title = "- Time:",
			Content = "/"
		})


	--[[

	
	local Button = BP3Tab:CreateButton({
		Name = "Destroy Blocks",
		Callback = function()
			local positions = {}

			local function checkPositions(start, finish)
				local minX = math.min(start.x, finish.x)
				local maxX = math.max(start.x, finish.x)
				local minY = math.min(start.y, finish.y)
				local maxY = math.max(start.y, finish.y)
				local minZ = math.min(start.z, finish.z)
				local maxZ = math.max(start.z, finish.z)
				return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
			end

			local start = _G.StartBlock.Position
			local finish = _G.EndBlock.Position
			start, finish = checkPositions(start, finish)

			for x = start.x, finish.x, 3 do
				for y = start.y, finish.y, 3 do
					for z = start.z, finish.z, 3 do
						positions[#positions + 1] = Vector3.new(x, y, z)
					end
				end
			end

			if 	game:GetService("Workspace"):FindFirstChild("NewPart") then
				local PART = game:GetService("Workspace"):FindFirstChild("NewPart")
				local BLOCKS = GetBlocks(PART.Position, PART.Size, PART)
				for i,SB in pairs(BLOCKS) do
					if SB and SB.Parent and SB.Parent.Name == "Blocks" then
						
					local H1 = RemoteData:FindFirstChild("TreeHashData").Value
					local H2 = _G.TreeHash

					local ohTable1 = {
						[H1] = H2,
						["part"] = SB,
						["block"] = SB,
						["norm"] = v,
						["pos"] = 0
					}


					local RemotesToSend = _G.RemotesToSendToDestroy or 3

					for i = 1,1 do
						game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(ohTable1)
					end

					task.wait()

					end
				end
			end

		end,
	})

	]]

		BlockDestroySelection:AddButton({
			Title = "Instant Destroy Blocks (Greg´s Hammer)",
			Description = "",
			Callback = function()
				local positions = {}

				local function checkPositions(start, finish)
					local minX = math.min(start.x, finish.x)
					local maxX = math.max(start.x, finish.x)
					local minY = math.min(start.y, finish.y)
					local maxY = math.max(start.y, finish.y)
					local minZ = math.min(start.z, finish.z)
					local maxZ = math.max(start.z, finish.z)
					return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
				end

				local start = _G.StartBlock.Position
				local finish = _G.EndBlock.Position
				start, finish = checkPositions(start, finish)

				for x = start.x, finish.x, 3 do
					for y = start.y, finish.y, 3 do
						for z = start.z, finish.z, 3 do
							positions[#positions + 1] = Vector3.new(x, y, z)
						end
					end
				end

				if 	game:GetService("Workspace"):FindFirstChild("NewPart") then
					local PART = game:GetService("Workspace"):FindFirstChild("NewPart")
					local BLOCKS = GetBlocks(PART.Position, PART.Size, PART)
					for i,SB in pairs(BLOCKS) do
						task.spawn(function()
							if SB and SB.Parent and SB.Parent.Name == "Blocks" then

								local H1 = RemoteData:FindFirstChild("TreeHashData").Value
								local H2 = _G.TreeHash

								local ohTable1 = {
									[H1] = H2,
									["part"] = SB,
									["block"] = SB,
									["norm"] = v,
									["pos"] = 0
								}


								local RemotesToSend = _G.RemotesToSendToDestroy or 3

								for i = 1,1 do
									game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(ohTable1)
								end

								task.wait()

							end
						end)

					end
				end

			end
		})


		BlockDestroySelection:AddButton({
			Title = "Destroy Blocks [BETA!]",
			Description = "",
			Callback = function()
				DestroyBlocksNew()
			end
		})


		local LASTSAVEDSDATA

		local CopyPasteSelection = Tabs.BlockPrinter:AddSection("Copy / paste!")

		CopyPasteSelection:AddButton({
			Title = "Clone Blocks",
			Description = "",
			Callback = function()
				for i,v in ipairs(CloneFolder:GetChildren()) do
					v:Destroy()
					DebugCheck(0,v.Name.." Got Deleted!")
				end


				local positions = {}

				local function checkPositions(start, finish)
					local minX = math.min(start.x, finish.x)
					local maxX = math.max(start.x, finish.x)
					local minY = math.min(start.y, finish.y)
					local maxY = math.max(start.y, finish.y)
					local minZ = math.min(start.z, finish.z)
					local maxZ = math.max(start.z, finish.z)
					return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
				end

				local start = _G.StartBlock.Position
				local finish = _G.EndBlock.Position
				start, finish = checkPositions(start, finish)

				for x = start.x, finish.x, 3 do
					for y = start.y, finish.y, 3 do
						for z = start.z, finish.z, 3 do
							positions[#positions + 1] = Vector3.new(x, y, z)
						end
					end
				end

				if 	game:GetService("Workspace"):FindFirstChild("NewPart") then
					local PART = game:GetService("Workspace"):FindFirstChild("NewPart")
					local BLOCKS = GetBlocks(PART.Position, PART.Size, PART)
					for i,SB in pairs(BLOCKS) do
						if SB.Parent.Name == "Blocks" then
							local NEWSB = SB:Clone()
							NEWSB.Parent = CloneFolder
							NEWSB.Position = SB.Position + Vector3.new(0,3,0)

							NEWSB.Transparency = 0.5
						end
					end
				end

			end
		})

		CopyPasteSelection:AddButton({
			Title = "Paste Blocks",
			Description = "",
			Callback = function()
				a = pcall(function()
					unequipped()
				end)

				local WAITGAY_XE = 0

				local CCPL = 0

				local positions = {}

				for i,v in pairs(CloneFolder:GetChildren()) do
					if v then
						positions[i] = v
						DebugCheck(0,"Added:",v.Name)
					end
				end

				local PLOW = false

				--[[

					local BBBBBB = GetIsland():FindFirstChild("Blocks").ChildAdded:Connect(function(v)
					if PLOW == true and v and v.Name == "grass" then
						local DIS = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
						if DIS < 50 then
							PLOW = false
							local args = {
								[1] = {
									["block"] = v
								}
							}


							game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_PLOW_BLOCK_REQUEST:InvokeServer(unpack(args))	

						end
					else
						DebugCheck(0,"WARN GAY!!!")
					end
				end)

				]]

				for i,pos in pairs(positions) do
					task.spawn(function()

						local Block = positions[i]
						local pos = Block.CFrame
						--if pos and Block then
						if Block.Name == "soil" then
							Block.Name = "grass"
							PLOW = true
						end

						local distance = (Block.Position - game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude

						print("distance:",distance)

						if distance > 30 then

							TeleportV4(Block.Position)

							repeat wait() until (Block.Position - game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 30

							local args = {
								[1] = {
									["upperBlock"] = false,
									["cframe"] = pos, -- CFrame.new(Vector3.new(pos.x, pos.y, pos.z, 1, 0, 0, 0, 1, 0, 0, 0, 1))
									["blockType"] = Block.Name,
									[CropPlaceH1] = CropPlaceH2
								}
							}

							game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(unpack(args))	

						else
							local args = {
								[1] = {
									["upperBlock"] = false,
									["cframe"] = pos, -- CFrame.new(Vector3.new(pos.x, pos.y, pos.z, 1, 0, 0, 0, 1, 0, 0, 0, 1))
									["blockType"] = Block.Name,
									[CropPlaceH1] = CropPlaceH2
								}
							}

							game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(unpack(args))

						end


						--end
					end)
				end


				--[[

				for i, pos in ipairs(positions) do
					CCPL = CCPL + 1
					if positions[CCPL] then


						local Block = positions[CCPL]
						DebugCheck(0,Block.Name)
						local pos = Block.CFrame


						if pos and Block then

							if Block.Name == "soil" then
								Block.Name = "grass"
								PLOW = true
							end

							local args = {
								[1] = {
									["upperBlock"] = false,
									["cframe"] = pos, -- CFrame.new(Vector3.new(pos.x, pos.y, pos.z, 1, 0, 0, 0, 1, 0, 0, 0, 1))
									["blockType"] = Block.Name,
									[CropPlaceH1] = CropPlaceH2
								}
							}

							game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(unpack(args))

							if  positions[CCPL+1] then
								if positions[CCPL+1].Name == "soil" then
									positions[CCPL+1].Name = "grass"
									PLOW = true
								end

								local args = {
									[1] = {
										["upperBlock"] = false,
										["cframe"] = positions[CCPL+1].CFrame, -- CFrame.new(Vector3.new(pos.x, pos.y, pos.z, 1, 0, 0, 0, 1, 0, 0, 0, 1))
										["blockType"] = positions[CCPL+1].Name,
										[CropPlaceH1] = CropPlaceH2
									}
								}

								game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(unpack(args))
							end

							if  positions[CCPL+2] then
								if positions[CCPL+2].Name == "soil" then
									positions[CCPL+2].Name = "grass"
									PLOW = true
								end

								local args = {
									[1] = {
										["upperBlock"] = false,
										["cframe"] = positions[CCPL+2].CFrame, -- CFrame.new(Vector3.new(pos.x, pos.y, pos.z, 1, 0, 0, 0, 1, 0, 0, 0, 1))
										["blockType"] = positions[CCPL+2].Name,
										[CropPlaceH1] = CropPlaceH2
									}
								}

								game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(unpack(args))
							end

						end


					end
				end

				]]

				task.wait(5)

				for i,v in pairs(CloneFolder:GetChildren()) do
					if v then
						v:Destroy()
					end
				end
			end
		})


		local FileName = ""

		local Files = GetSchematicaFiles()

		local inputString = Files[1]
		if inputString then
			local parts = {}
			for part in inputString:gmatch("[^\\]+") do
				table.insert(parts, part)
			end
			local outputString = parts[#parts]
			FileName = outputString
		end

		local Dropdown_Files = CopyPasteSelection:AddDropdown("Dropdown_Files", {
			Title = "Files",
			Values = Files,
			Multi = false,
			Default = 1,
		})

		Dropdown_Files:OnChanged(function(Value)
			if type(Value) == "string" then
				local inputString = Value
				local parts = {}
				for part in inputString:gmatch("[^\\]+") do
					table.insert(parts, part)
				end
				local outputString = parts[#parts]
				FileName = outputString
			end


		end)

		task.spawn(function()
			while wait(5) do
				Dropdown_Files:SetValues(GetSchematicaFiles())
			end
		end)

		local FileNameInput = CopyPasteSelection:AddInput("FileName", {
			Title = "File Name",
			Default = "Template",
			Placeholder = "Template.tmp",
			Numeric = false, -- Only allows numbers
			Finished = false, -- Only calls callback when you press enter
			Callback = function(Value)
				FileName = Value
			end
		})

		CopyPasteSelection:AddButton({
			Title = "Save Blocks to File!",
			Description = "",
			Callback = function()
				for i,v in ipairs(CloneFolder:GetChildren()) do
					v:Destroy()
					DebugCheck(0,v.Name.." Got Deleted!")
				end


				local positions = {}

				local function checkPositions(start, finish)
					local minX = math.min(start.x, finish.x)
					local maxX = math.max(start.x, finish.x)
					local minY = math.min(start.y, finish.y)
					local maxY = math.max(start.y, finish.y)
					local minZ = math.min(start.z, finish.z)
					local maxZ = math.max(start.z, finish.z)
					return Vector3.new(minX, minY, minZ), Vector3.new(maxX, maxY, maxZ)
				end

				local start = _G.StartBlock.Position
				local finish = _G.EndBlock.Position
				start, finish = checkPositions(start, finish)

				for x = start.x, finish.x, 3 do
					for y = start.y, finish.y, 3 do
						for z = start.z, finish.z, 3 do
							positions[#positions + 1] = Vector3.new(x, y, z)
						end
					end
				end

				-- HIER --

				local function isVisible(part)
					return part.Transparency == 0 and part.CanCollide == true and part.Size.X > 0 and part.Size.Y > 0 and part.Size.Z > 0
				end

				function findCenter(Table)
					local parts = Table
					local numVisibleParts = 0
					local totalPosition = Vector3.new(0, 0, 0)
					local MittigsterBlock = nil


					for _, part in ipairs(parts) do
						if part:IsA("Part") or part:IsA("MeshPart") then
							print(part.Name)
							totalPosition = totalPosition + part.Position
							MittigsterBlock = part
							numVisibleParts = numVisibleParts + 1
						else
							print(part.Name.." ist ein "..part.ClassName)
						end
					end


					if numVisibleParts > 0 then
						local centerPos = totalPosition / numVisibleParts
						return centerPos
					else
						return nil 
					end
				end

				local SaveData = {}

				if 	game:GetService("Workspace"):FindFirstChild("NewPart") then
					local PART = game:GetService("Workspace"):FindFirstChild("NewPart")
					local BLOCKS = GetBlocks(PART.Position, PART.Size, PART)
					for i,v in pairs(BLOCKS) do
						if v.Parent.Name == "Blocks" then
							table.insert(SaveData, v)
						end
					end
				end

				local MittePosition = findCenter(SaveData)

				print("Der Part is ", tostring(MittePosition))

				local data = {
					Size = {tostring(game:GetService("Workspace"):FindFirstChild("NewPart").Size)},
					Blocks = {

					}
				}


				local function save(name, cframe)
					if not data.Blocks[name] then
						data.Blocks[name] = {}
					end
					table.insert(data.Blocks[name], {C = {cframe.components(cframe)}})
				end

				if 	game:GetService("Workspace"):FindFirstChild("NewPart") then
					local PART = game:GetService("Workspace"):FindFirstChild("NewPart")
					local BLOCKS = GetBlocks(PART.Position, PART.Size, PART)
					for i,v in pairs(BLOCKS) do
						if v.Parent.Name == "Blocks" then
							save(v.Name, v.CFrame)
						end
					end
				end

				DebugCheck(0,"PRINTING SOON!!!")

				task.wait()

				local json = game:GetService("HttpService")
				local dataString = json:JSONEncode(data)
				LASTSAVEDSDATA = dataString

				task.wait()

				if LASTSAVEDSDATA ~= nil then

					function GetMore()
						-- Beispiel-Tabelle von Strings
						local stringsTable = {"Nekohub on Top?",
							"BloodBath#9170 is Gay",
							"BloodBath#9170 is a Monkey",
							"BloodBath#9170 are you Mad? :clown:", 
							"Boss was here :)"
						}
						local randomIndex = math.random(#stringsTable)
						local randomString = stringsTable[randomIndex]
						return randomString or "Imagine you are Gay :skull:"

					end

					local WERBUNG = [[-- Generated With Islands.God (discord.gg/MbsxuDEzgT) Version: 0.4 Beta]].."\n".."--"..GetMore().." \n"

					CreateFile("/Schematica/"..FileName, WERBUNG.."\n"..LASTSAVEDSDATA, false)

					task.wait(0.5)

					Message("👍!", "Your File got successfully Saved! (Nekohub/Islands/Schematica)", "Nice!", 3)

				else
					DebugCheck(0,"LASTSAVEDSDATA ist nil")
				end

				DebugCheck(0,"done.")
			end
		})

		CopyPasteSelection:AddButton({
			Title = "Load File to Game!",
			Description = "",
			Callback = function()

				print("FileName:",FileName)

				local ALLBLOCKS = game:GetService("ReplicatedStorage").Blocks
				if IsFile("/Schematica/"..FileName) ~= nil then
					FILEDATA = ReadFile("/Schematica/"..FileName, LASTSAVEDSDATA)
					if FILEDATA then
						local text = FILEDATA
						local newText = text:gsub("%-%-.-\n", "\n")
						DebugCheck(0,newText)

						if newText then
							DebugCheck(0,"REMOVED!!!")
							FILEDATA = newText
						end

						DebugCheck(0,FILEDATA)

						task.wait()

						json = game:GetService("HttpService")
						jsonString = FILEDATA
						A = json:JSONDecode(jsonString)
						-- print the data
						if A.Blocks then
							for name, blocks in pairs(A.Blocks) do
								if ALLBLOCKS:FindFirstChild(name) then
									DebugCheck(0,name)
									if name == "dirt" then
										name = "soil" -- grass
									end
									for _, block in ipairs(blocks) do
										clone = ALLBLOCKS:FindFirstChild(name):FindFirstChild("Root"):Clone()
										if clone then
											clone.Transparency = 0.5
											clone.Name = name
											clone.Parent = CloneFolder
											clone.CFrame = CFrame.new(unpack(block.C))
											DebugCheck(0,"CE")
										else
											DebugCheck(0,"NO ROOT MONKEY!!")
										end
									end
								end
							end
						else
							print("Project Z file detected!")
							for name, blocks in pairs(A) do
								for _, block in ipairs(blocks) do
									local x, y, z = block[1], block[2], block[3]
									local position = Vector3.new(x, y, z)

									print("Block Name:", name)
									print("Block Position:", position)

									if ALLBLOCKS:FindFirstChild(name) then
										DebugCheck(0,name)
										if name == "dirt" then
											name = "soil" -- grass
										end
										clone = ALLBLOCKS:FindFirstChild(name):FindFirstChild("Root"):Clone()
										if clone then
											clone.Transparency = 0.5
											clone.Name = name
											clone.Parent = CloneFolder
											clone.CFrame = CFrame.new(position)
										end
									end
								end
							end
						end

						task.wait(0.3)

						activated()

						task.wait(0.2)

						Message("👍!", "Your File got Loaded successfully!", "Nice!", 3)

					end
				else
					DebugCheck(0,"LASTSAVEDSDATA ist nil")
				end
			end
		})



		local LastTarget = nil
		local NewTarget = false

		local BringParagraph

		local function onClick()
			if NewTarget then
				local mouse = game.Players.LocalPlayer:GetMouse()
				local Hit = mouse.Target 

				LastTarget = Hit 
				print("New Target",Hit)
				if Hit then
					BringParagraph:SetDesc("Target Found! "..Hit.Name)
					task.wait(1)
					BringParagraph:SetDesc("false")
				else
					BringParagraph:SetDesc("Error! Please try again!")
					task.wait(1)
					BringParagraph:SetDesc("false")
				end
				NewTarget = false
			end 
		end

		game:GetService("UserInputService").InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				onClick() 
			end
		end)

		local TeleportBuildSelection = Tabs.BlockPrinter:AddSection("Teleport")

		BringParagraph = TeleportBuildSelection:AddParagraph({
			Title = "- Waiting for Click:",
			Content = "false"
		})

		TeleportBuildSelection:AddButton({
			Title = "Teleport to Player!",
			Description = "",
			Callback = function()
				pcall(unequipped)

				local function roundToMultipleOfThree(value)
					local roundedValue = math.floor(value / 3 + 0.5) * 3
					return roundedValue
				end

				local player = game.Players.LocalPlayer 
				local Position = player.Character.HumanoidRootPart.Position

				local roundedNumber_x = roundToMultipleOfThree(Position.X)
				local roundedNumber_y = roundToMultipleOfThree(Position.Y)
				local roundedNumber_z = roundToMultipleOfThree(Position.Z)

				local Final = Vector3.new(roundedNumber_x, roundedNumber_y, roundedNumber_z)


				if not Final then Message("Error", "NBF", "?", 1) return nil end

				local TargetBlockPos = Final

				if CloneFolder.PrimaryPart then
					CloneFolder:SetPrimaryPartCFrame(CFrame.new(TargetBlockPos))
				else
					MoveToolGenPrimarypart(CloneFolder)
					task.wait()
					CloneFolder:SetPrimaryPartCFrame(CFrame.new(TargetBlockPos))
				end

				task.wait()

				activated()

			end
		})

		function GetUnder3x3Block()
			local function IsApproximatelySize(part, targetSize, tolerance)
				local partSize = part.Size
				local sizeDifference = math.abs(partSize.X - targetSize.X) + math.abs(partSize.Y - targetSize.Y) + math.abs(partSize.Z - targetSize.Z)
				return sizeDifference <= tolerance
			end

			local function FindPartBelow(part)
				local raycastOrigin = part.Position
				local raycastDirection = Vector3.new(0, -3, 0) -- Richtung nach unten

				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

				-- Ignoriere Teile im gleichen Objekt und Teile mit dem Namen "Top"
				raycastParams.FilterDescendantsInstances = {part.Parent}
				raycastParams.IgnoreWater = true -- Optional: Ignoriere Wasser

				local hitResult = game.Workspace:Raycast(raycastOrigin, raycastDirection, raycastParams)

				if hitResult then
					local hitPart = hitResult.Instance
					if hitPart:IsA("BasePart") then
						if IsApproximatelySize(hitPart, Vector3.new(3, 3, 3), 0.1) then
							return hitPart -- Return the position of the found part
						else
							if IsApproximatelySize(hitPart.Parent, Vector3.new(3, 3, 3), 0.1) then
								return hitPart.Parent
							else
								return FindPartBelow(hitPart) -- Suche weiter darunter
							end
						end
					end
				end
			end

			local player = game.Players.LocalPlayer
			local character = player.Character

			if character then
				local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
				local pos = FindPartBelow(humanoidRootPart)
				return pos
			else
				print("Charakter nicht gefunden.")
			end

		end

		TeleportBuildSelection:AddButton({
			Title = "Teleport to Nearest Block!",
			Description = "",
			Callback = function()
				unequipped()

				local C = CloneFolder:FindFirstChild("PrimaryPart") or CloneFolder.PrimaryPart

				local TargetBlock = GetUnder3x3Block()

				if not TargetBlock then Message("Error", "NBF", "?", 1) return nil end

				print("TargetBlock:",TargetBlock)

				local TargetBlockPos = TargetBlock.Position + Vector3.new(0,3,0)

				if CloneFolder.PrimaryPart then
					CloneFolder:SetPrimaryPartCFrame(CFrame.new(TargetBlockPos))
				else

					function findCenter(Table)
						local parts = Table:GetChildren()
						local numVisibleParts = 0
						local totalPosition = Vector3.new(0, 0, 0)
						local MittigsterBlock = nil


						for _, part in ipairs(parts) do
							if part:IsA("Part") or part:IsA("MeshPart") then
								print(part.Name)
								totalPosition = totalPosition + part.Position
								MittigsterBlock = part
								numVisibleParts = numVisibleParts + 1
							else
								print(part.Name.." ist ein "..part.ClassName)
							end
						end


						if numVisibleParts > 0 then
							local centerPos = totalPosition / numVisibleParts
							return MittigsterBlock
						else
							return nil 
						end
					end

					CloneFolder.PrimaryPart = findCenter(CloneFolder)
					task.wait()
					CloneFolder:SetPrimaryPartCFrame(CFrame.new(TargetBlockPos))
				end

				task.wait()

				activated()

			end
		})

		TeleportBuildSelection:AddButton({
			Title = "Teleport to Mouse!",
			Description = "",
			Callback = function()
				unequipped()





				LastTarget = nil
				NewTarget = false

				BringParagraph:SetDesc("true")

				function findCenter(Table)
					local parts = Table:GetChildren()
					local numVisibleParts = 0
					local totalPosition = Vector3.new(0, 0, 0)
					local MittigsterBlock = nil


					for _, part in ipairs(parts) do
						if part:IsA("Part") or part:IsA("MeshPart") then
							print(part.Name)
							totalPosition = totalPosition + part.Position
							MittigsterBlock = part
							numVisibleParts = numVisibleParts + 1
						else
							print(part.Name.." ist ein "..part.ClassName)
						end
					end


					if numVisibleParts > 0 then
						local centerPos = totalPosition / numVisibleParts
						return MittigsterBlock
					else
						return nil 
					end
				end

				local C = CloneFolder:FindFirstChild("PrimaryPart") or CloneFolder.PrimaryPart


				if CloneFolder.PrimaryPart then
					if LastTarget then
						if LastTarget.Name == "Top" then
							-- Preserve rotation and update X, Y, Z coordinates
							CloneFolder:SetPrimaryPartCFrame(CFrame.new(LastTarget.Parent.Position) * CFrame.fromMatrix(Vector3.new(), CloneFolder.PrimaryPart.CFrame.RightVector, CloneFolder.PrimaryPart.CFrame.UpVector))
						else
							-- Preserve rotation and update X, Y, Z coordinates
							CloneFolder:SetPrimaryPartCFrame(CFrame.new(LastTarget.Position) * CFrame.fromMatrix(Vector3.new(), CloneFolder.PrimaryPart.CFrame.RightVector, CloneFolder.PrimaryPart.CFrame.UpVector))
						end
					else
						NewTarget = true
						repeat wait() until LastTarget
						if LastTarget.Name == "Top" then
							-- Preserve rotation and update X, Y, Z coordinates
							CloneFolder:SetPrimaryPartCFrame(CFrame.new(LastTarget.Parent.Position) * CFrame.fromMatrix(Vector3.new(), CloneFolder.PrimaryPart.CFrame.RightVector, CloneFolder.PrimaryPart.CFrame.UpVector))
						else
							-- Preserve rotation and update X, Y, Z coordinates
							CloneFolder:SetPrimaryPartCFrame(CFrame.new(LastTarget.Position) * CFrame.fromMatrix(Vector3.new(), CloneFolder.PrimaryPart.CFrame.RightVector, CloneFolder.PrimaryPart.CFrame.UpVector))
						end
					end
				else
					DebugCheck(0, "NO PrimaryPart")
					MoveToolGenPrimarypart(CloneFolder)
					task.wait()
					if LastTarget then
						-- Preserve rotation and update X, Y, Z coordinates
						CloneFolder:SetPrimaryPartCFrame(CFrame.new(LastTarget.Position) * CFrame.fromMatrix(Vector3.new(), CloneFolder.PrimaryPart.CFrame.RightVector, CloneFolder.PrimaryPart.CFrame.UpVector))
					else
						NewTarget = true
						repeat wait() until LastTarget
						-- Preserve rotation and update X, Y, Z coordinates
						CloneFolder:SetPrimaryPartCFrame(CFrame.new(LastTarget.Position) * CFrame.fromMatrix(Vector3.new(), CloneFolder.PrimaryPart.CFrame.RightVector, CloneFolder.PrimaryPart.CFrame.UpVector))
					end
				end

				task.wait()

				activated()

			end
		})


		CopyPasteSelection:AddButton({
			Title = "unLoad file to game",
			Description = "",
			Callback = function()
				pcall(unequipped)

				task.wait()

				if CloneFolder then
					for i,v in pairs(CloneFolder:GetChildren()) do
						v:Destroy()
					end
				end
			end
		})

		_G.BuildCollision = true
		local BuildCollision = CopyPasteSelection:AddToggle("BuildCollision", {Title = "Build Collision", Default = true })

		BuildCollision:OnChanged(function(Value)
			_G.BuildCollision = Value
		end)

		task.spawn(function()
			while wait() do
				for i,v in pairs(CloneFolder:GetChildren()) do
					if v:IsA("Part") or v:IsA("MeshPart") then
						v.CanCollide = _G.BuildCollision
					end
				end	
			end
		end)

	end

	COPYPASTEGUI()



	-- Move --

	local OtherStuffSelection = Tabs.BlockPrinter:AddSection("Other Stuff")

	OtherStuffSelection:AddButton({
		Title = "Rotate 90 X",
		Description = "",
		Callback = function()

			function findCenter(Table)
				local parts = Table:GetChildren()
				local numVisibleParts = 0
				local totalPosition = Vector3.new(0, 0, 0)
				local MittigsterBlock = nil


				for _, part in ipairs(parts) do
					if part:IsA("Part") or part:IsA("MeshPart") then
						print(part.Name)
						totalPosition = totalPosition + part.Position
						MittigsterBlock = part
						numVisibleParts = numVisibleParts + 1
					else
						print(part.Name.." ist ein "..part.ClassName)
					end
				end


				if numVisibleParts > 0 then
					local centerPos = totalPosition / numVisibleParts
					return MittigsterBlock
				else
					return nil 
				end
			end

			if CloneFolder.PrimaryPart == nil then
				if CloneFolder:FindFirstChild("PrimaryPart") then
					CloneFolder:FindFirstChild("PrimaryPart"):Destroy()
				end

				local C = findCenter(CloneFolder)
				CloneFolder.PrimaryPart = C
				task.wait(0.5)
			end

			local gewuenschteDrehung = CFrame.Angles(math.rad(90), 0, 0)

			CloneFolder:SetPrimaryPartCFrame(CloneFolder:GetPrimaryPartCFrame() * gewuenschteDrehung)
		end
	})

	OtherStuffSelection:AddButton({
		Title = "Rotate 90 Y",
		Description = "",
		Callback = function()

			function findCenter(Table)
				local parts = Table:GetChildren()
				local numVisibleParts = 0
				local totalPosition = Vector3.new(0, 0, 0)
				local MittigsterBlock = nil


				for _, part in ipairs(parts) do
					if part:IsA("Part") or part:IsA("MeshPart") then
						print(part.Name)
						totalPosition = totalPosition + part.Position
						MittigsterBlock = part
						numVisibleParts = numVisibleParts + 1
					else
						print(part.Name.." ist ein "..part.ClassName)
					end
				end


				if numVisibleParts > 0 then
					local centerPos = totalPosition / numVisibleParts
					return MittigsterBlock
				else
					return nil 
				end
			end

			if CloneFolder.PrimaryPart == nil then
				if CloneFolder:FindFirstChild("PrimaryPart") then
					CloneFolder:FindFirstChild("PrimaryPart"):Destroy()
				end

				local C = findCenter(CloneFolder)
				CloneFolder.PrimaryPart = C
				task.wait(0.5)
			end

			local gewuenschteDrehung = CFrame.Angles(0, math.rad(90), 0)

			CloneFolder:SetPrimaryPartCFrame(CloneFolder:GetPrimaryPartCFrame() * gewuenschteDrehung)
		end
	})

	OtherStuffSelection:AddButton({
		Title = "Rotate 90 Z",
		Description = "",
		Callback = function()

			function findCenter(Table)
				local parts = Table:GetChildren()
				local numVisibleParts = 0
				local totalPosition = Vector3.new(0, 0, 0)
				local MittigsterBlock = nil


				for _, part in ipairs(parts) do
					if part:IsA("Part") or part:IsA("MeshPart") then
						print(part.Name)
						totalPosition = totalPosition + part.Position
						MittigsterBlock = part
						numVisibleParts = numVisibleParts + 1
					else
						print(part.Name.." ist ein "..part.ClassName)
					end
				end


				if numVisibleParts > 0 then
					local centerPos = totalPosition / numVisibleParts
					return MittigsterBlock
				else
					return nil 
				end
			end

			if CloneFolder.PrimaryPart == nil then
				if CloneFolder:FindFirstChild("PrimaryPart") then
					CloneFolder:FindFirstChild("PrimaryPart"):Destroy()
				end

				local C = findCenter(CloneFolder)
				CloneFolder.PrimaryPart = C
				task.wait(0.5)
			end

			local gewuenschteDrehung = CFrame.Angles(0, 0, math.rad(90))

			CloneFolder:SetPrimaryPartCFrame(CloneFolder:GetPrimaryPartCFrame() * gewuenschteDrehung)
		end
	})





	-- Player --
	local PlayerSelection = Tabs.Player:AddSection("Player")


--[[

local Button = Tab:CreateButton({
	Name = "God Mode",
	Callback = function()
		local Player=game.Players.LocalPlayer

		local Character=Player.Character

		function Bypass(S)

			local OLD = S
			if not OLD then return "Gay" end
			local NEW = OLD:Clone()
			OLD:Destroy()
			NEW.Parent = Character
		end

		Bypass(Character:FindFirstChild("LastDamagedTick"))

		game:GetService("Players").LocalPlayer.PlayerGui.Hotbar:FindFirstChild("1"):FindFirstChild("1"):FindFirstChild("1"):FindFirstChild("4").Text = "inf / inf"

	end,
})

]]

	PlayerSelection:AddButton({
		Title = "Cooldown bypass",
		Description = "",
		Callback = function()
			local Cooldown; Cooldown = hookfunction(wait, function(v)
				v = 0;
				return Cooldown(v);
			end);
		end
	})


	local PlayerFly = PlayerSelection:AddToggle("PlayerFly", {Title = "Fly", Default = false })

	PlayerFly:OnChanged(function(Value)
		if Value == true then
			sFLY(true)
		else
			NOFLY()
		end
	end)

	local AutoCompleteActionGame = PlayerSelection:AddToggle("Auto Complete Action Game", {Title = "Auto Complete Gam (SOON!)e", Default = false })

	AutoCompleteActionGame:OnChanged(function(Value)
		_G.AutoCompleteActionGame = Value
	end)

	local WaitUntilTheOldShitIsCompleted_MovingBarCompleteNiggaShit = false

	function checkPosition(frame, mid)
		local a1 = frame.AbsolutePosition.X
		local b1 = mid.AbsolutePosition.X

		local a2 = a1 + frame.AbsoluteSize.X
		local b2 = b1 + mid.AbsoluteSize.X


		if (b1 <= a1 and b2 <= a1) or (a2 <= b1 and a2 <= b2) then
			return false
		else
			task.wait(0.1)
			return true
		end
	end

	game:GetService("RunService").RenderStepped:Connect(function()

		if WaitUntilTheOldShitIsCompleted_MovingBarCompleteNiggaShit == true then return nil end

		function CompleteMovingBar()
			local re
			repeat
				re = checkPosition(game:GetService("Players").LocalPlayer.PlayerGui.ActionBarScreenGui.ActionBar.RoactTree:WaitForChild("3"):WaitForChild("Minigame"):WaitForChild("Marker"), game:GetService("Players").LocalPlayer.PlayerGui.ActionBarScreenGui.ActionBar.RoactTree:WaitForChild("3"):WaitForChild("Minigame"):WaitForChild("Marker")			)
				print(re)
				task.wait()
			until re == true
			game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
			game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
			task.wait(0.5)
			WaitUntilTheOldShitIsCompleted_MovingBarCompleteNiggaShit = false
		end
	
		if _G.AutoCompleteActionGame == true then
			if game:GetService("Players").LocalPlayer.PlayerGui.ActionBarScreenGui.ActionBar:FindFirstChild("RoactTree") then
				if game:GetService("Players").LocalPlayer.PlayerGui.ActionBarScreenGui.ActionBar.RoactTree:WaitForChild("3"):WaitForChild("Minigame"):WaitForChild("Marker") then
					WaitUntilTheOldShitIsCompleted_MovingBarCompleteNiggaShit = true
					CompleteMovingBar()
				end
			end
		end
	
	end)

	local FlySpeedSlider = PlayerSelection:AddSlider("FlySpeedSlider", {
		Title = "Fly Speed",
		Description = "",
		Default = 1,
		Min = 0,
		Max = 10,
		Rounding = 1,
		Callback = function(Value)
			iyflyspeed = Value
		end
	})

	local JumpPowerSlider = PlayerSelection:AddSlider("JumpPowerSlider", {
		Title = "Jump Power",
		Description = "",
		Default = 50,
		Min = 0,
		Max = 500,
		Rounding = 0,
		Callback = function(Value)
			_G.JumpPower = Value
		end
	})


	local SpeedSlider = PlayerSelection:AddSlider("SpeedSlider", {
		Title = "Walk Speed",
		Description = "",
		Default = 30,
		Min = 0,
		Max = 40,
		Rounding = 0,
		Callback = function(Value)
			_G.WalkSpeed = Value
		end
	})




	_G.BuySellType = 0
	_G.MaxPriceVendingSniper = 0

	local SelectedItemParagraph = Tabs.VendingSniper:AddParagraph({
		Title = "Selected Item:",
		Content = "-"
	})

	local StatusVendingParagraph = Tabs.VendingSniper:AddParagraph({
		Title = "Status:",
		Content = "-"
	})



	function FindWithVendingSniper(Target, MaxPrice)
		local ISTHERE = false
		DebugCheck(0,"FindWithVendingSniper")
		local Island = game:GetService("Workspace").Islands:FindFirstChildWhichIsA("Model")
		local Blocks = Island:FindFirstChild("Blocks")
		DebugCheck(0,"BLOCK1")
		for i,v in pairs(Blocks:GetChildren()) do
			if v.Name == "vendingMachine" or v.Name == "vendingMachine1" or v.Name == "vendingMachine2" then
				if v:FindFirstChild("SellingContents") then
					if v:FindFirstChild("SellingContents"):FindFirstChild(Target) then
						if v:FindFirstChild("Mode") then
							DebugCheck(0,"MODE")
							if v:FindFirstChild("Mode").Value == _G.BuySellType then
								if v:FindFirstChild("TransactionPrice") then
									if v:FindFirstChild("TransactionPrice").Value > MaxPrice then
										DebugCheck(0,"GOOD PRICE!! ")
										DebugCheck(0,v:FindFirstChild("SellingContents"):FindFirstChild(Target).Name)
										StatusVendingParagraph:SetDesc("The Item: "..Target.." Was Found!")
										MiniTp(v.Position + Vector3.new(0,10,0))
										ISTHERE = true
										task.wait(2)
										StatusVendingParagraph:SetDesc("-")
									end
								end
							end
						end
					end
				end
			end
		end
		if ISTHERE == false then
			DebugCheck(0,"No "..Target.." Found!")
			StatusVendingParagraph:SetDesc( "The Item: "..Target.." Was not Found or Cost too much!")
			task.wait(2)
			StatusVendingParagraph:SetDesc("-")
		else
			StatusVendingParagraph:SetDesc("The Item: "..Target.." Was Found!")
			task.wait(2)
			StatusVendingParagraph:SetDesc("-")
		end
	end

	local Input = Tabs.VendingSniper:AddInput("Input", {
		Title = "MaxPrice",
		Default = "0",
		Placeholder = "0",
		Numeric = true, -- Only allows numbers
		Finished = false, -- Only calls callback when you press enter
		Callback = function(Value)
			_G.MaxPriceVendingSniper = tonumber(Value)
		end
	})

	local BuyOrSellOption = Tabs.VendingSniper:AddDropdown("BuyOrSellOption", {
		Title = "Select Option",
		Values = {"Buy", "Sell"},
		Multi = false,
		Default = 1,
	})

	BuyOrSellOption:OnChanged(function(Value)
		if Option == "Buy" then
			_G.BuySellType = 0
		elseif Option == "Sell" then
			_G.BuySellType = 1
		end
	end)

	Tabs.VendingSniper:AddButton({
		Title = "Select Holding tool",
		Description = "",
		Callback = function()
			local TOOL = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
			if TOOL then
				_G.FindingItemVendingSniper = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool").Name
				SelectedItemParagraph:SetDesc(TOOL.Name)
			end
		end
	})

	Tabs.VendingSniper:AddButton({
		Title = "Find Item",
		Description = "",
		Callback = function()
			local MaxPrice = _G.MaxPriceVendingSniper
			local ITEMTOFIND = _G.FindingItemVendingSniper
			FindWithVendingSniper(ITEMTOFIND, MaxPrice)
		end
	})



	if DidKey == false then


--[[
_G.MobFarmAnimationBypass = true
local Section = Tab:CreateSection("Mob")
local BRINGMOBSDNJUGA = Tab:CreateToggle({
	Name = "Bypass Mob Farm Animation",
	CurrentValue = true,
	Flag = "Bypass Mob Farm Animation Toggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		if Value == true then
			game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
			_G.MobFarmAnimationBypass = true
			task.wait(0.5)
			game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
		else
			_G.MobFarmAnimationBypass = false
		end
	end,
})

]]
		local MobTeleportSelection = Tabs.BypassFun:AddSection("Mob Teleport [BETA!]")


		_G.MobBringY = 0
		_G.MobBringSelectedMob = "All"

		local MobYPosition = MobTeleportSelection:AddSlider("MobYPosition", {
			Title = "Y Position",
			Description = "",
			Default = 1,
			Min = -20,
			Max = 30,
			Rounding = 0,
			Callback = function(Value)
				_G.MobBringY = Value
			end
		})

		local SelectMobToBypass = MobTeleportSelection:AddDropdown("SelectMobToBypass", {
			Title = "Select Mob",
			Values = {"All","slime", "buffalkor", "wizardLizard","Skorpions","magmaBlob","magmaGolem","skeletonPirate","voidPup","voidDog"},
			Multi = false,
			Default = 2,
		})

		SelectMobToBypass:OnChanged(function(Option)
			if type(Option) == "table" then
				_G.MobBringSelectedMob = Option[1]
			else
				_G.MobBringSelectedMob = Option
			end
		end)

		local BringBypassedMobs = MobTeleportSelection:AddToggle("BringBypassedMobs", {Title = "Bring Mobs", Default = false })

		BringBypassedMobs:OnChanged(function(Value)
			_G.BringMobsEnabled = Value
		end)

		task.spawn(function()
			while  wait(0.1) do
				if _G.BringMobsEnabled == true then
					local speaker = game.Players.LocalPlayer
					local YPOS = _G.MobBringY or 20
					local TargetPos = speaker.Character.Head.Position + Vector3.new(0, YPOS, 0)
					local UnflyAfterSec = 2000000
					local Forces = {}

					for _, part in pairs(game:GetService("Workspace").WildernessIsland.Entities:GetDescendants()) do
						if speaker.Character:FindFirstChild('Head')
							and part:IsA("BasePart") or part:IsA("UnionOperation" or part:IsA("Model"))
							and not part.Anchored and not part:IsDescendantOf(speaker.Character)
							and part.Name ~= "Torso" and part.Name ~= "Head"
							and part.Name ~= "Right Arm" and part.Name ~= "Left Arm"
							and part.Name ~= "Right Leg" and part.Name ~= "Left Leg"
							and part.Name ~= "HumanoidRootPart" then

							if _G.MobBringSelectedMob == "All" then
								for i, c in pairs(part:GetChildren()) do
									if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
										c:Destroy()
									end
								end

								local ForceInstance = Instance.new("BodyPosition")
								ForceInstance.Parent = part
								ForceInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
								table.insert(Forces, ForceInstance)

								coroutine.wrap(function()
									wait(UnflyAfterSec)
									ForceInstance:Destroy()
								end)()
							else
								if part.Name == _G.MobBringSelectedMob or part.Parent.Name == _G.MobBringSelectedMob then
									for i, c in pairs(part:GetChildren()) do
										if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
											c:Destroy()
										end
									end

									local ForceInstance = Instance.new("BodyPosition")
									ForceInstance.Parent = part
									ForceInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
									table.insert(Forces, ForceInstance)

									coroutine.wrap(function()
										wait(UnflyAfterSec)
										ForceInstance:Destroy()
									end)()
								end
							end
						end
					end

					for i, c in pairs(Forces) do
						c.Position = TargetPos
					end



				else
					for _, part in pairs(game:GetService("Workspace").WildernessIsland.Entities:GetDescendants()) do
						for i, c in pairs(part:GetChildren()) do
							if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
								c:Destroy()
							end
						end
					end
				end
			end
		end)

		local BypassedToolsSelection = Tabs.BypassFun:AddSection("Tools")

		function GetTool(TOOLNAME, BackonChanged, BreakToolname)
			for i,v in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do
				if v.Name == TOOLNAME and v:IsA("Tool") then
					local Clone = v:Clone()
					Clone.Parent = game.Players.LocalPlayer.Backpack


					-- v:FindFirstChild("DisplayName").Value = ""
					if BackonChanged == true then

						function Invisble(Tool, V)
							local TOCHAN 
							if V == true then
								TOCHAN = 1
							else
								TOCHAN = 0
							end

							if Tool:FindFirstChild("Handle") then
								if Tool:FindFirstChild("Handle"):IsA("Part") or Tool:FindFirstChild("Handle"):IsA("MeshPart") then
									Tool:FindFirstChild("Handle").Transparency = TOCHAN
									for i,v in pairs(Tool:FindFirstChild("Handle"):GetChildren()) do
										if v then
											if v:IsA("Part") or v:IsA("MeshPart") then
												v.Transparency = TOCHAN
											end
										end
									end
								end
							end

						end 

						local Back = false
						if game.Players.LocalPlayer.Character:FindFirstChild(BreakToolname) then
							Back = true
						end
						game.Players.LocalPlayer.Character.ChildAdded:Connect(function(Added)
							if Added.Name == BreakToolname then
								Back = true
							end
						end)



						game.Players.LocalPlayer.Character.ChildRemoved:Connect(function(Added)
							if Added.Name == BreakToolname then
								if game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname) then
									if game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname):FindFirstChild("axe") then
										game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname):FindFirstChild("axe").Enabled = true
										Invisble(game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname), false)
									end
								end
								-- Back = false
							end
						end)

						Clone.Changed:Connect(function(Changed)
							if Changed == "Parent" then
								if Back == true then
									if game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname) then
										if game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname) then
											if game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname):FindFirstChild("axe") then
												game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname):FindFirstChild("axe").Enabled = false
												Invisble(game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname), true)
											end
										end
										game.Players.LocalPlayer.Backpack:FindFirstChild(BreakToolname).Parent = game.Players.LocalPlayer.Character 

									end
								end
							end
						end)
					end
				end
			end 
		end

		local W1Paragraph = BypassedToolsSelection:AddParagraph({
			Title = "Warning!",
			Content = "The gregsHammer has a few conditions: You have to have a good pickaxe/axe! (Recommendation: Opal) | Have Fun :)"
		})

		local W2Paragraph = BypassedToolsSelection:AddParagraph({
			Title = "How to use?",
			Content = "(before you click on the gregsHammer you have to equip a tool that you want to bypass!) | it doesn't bypass the Cooldown just gives you the Effect of the gregsHammer"
		})

		-- After you have pressed a button, you have to equip another item of your choice

		BypassedToolsSelection:AddButton({
			Title = "Get forgeHammer (Works!) [BYPASSED]",
			Description = "",
			Callback = function()
				if game.Players.LocalPlayer.Character:FindFirstChild("forgeHammer") == nil and game.Players.LocalPlayer.Backpack:FindFirstChild("forgeHammer") == nil then
					GetTool("forgeHammer")
				else
					Message("😎", "You got the forgeHammer Already!", "xD", "Woah")
				end
			end
		})

		BypassedToolsSelection:AddButton({
			Title = "Get gregsHammer (READ [How to use?] and [Warning!])",
			Description = "",
			Callback = function()
				if game.Players.LocalPlayer.Character:FindFirstChild("gregsHammer") == nil and game.Players.LocalPlayer.Backpack:FindFirstChild("gregsHammer") == nil then
					if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
						if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("axe") then
							GetTool("gregsHammer", true, game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool").Name)
						else
							Message("😳", "You can Only Bypass Axes and Pickaxes :)", "hehe", "Woah")
						end
					else
						Message("🤪", "equip the tool you want to bypass first!", "Ok :)))", "Woah")
					end
				else
					Message("😎", "You got the gregsHammer Already!", "xD", "Woah")
				end
			end
		})

		BypassedToolsSelection:AddButton({
			Title = "Get crystallinePlow (READ [How to use?] and [Warning!])",
			Description = "",
			Callback = function()
				if game.Players.LocalPlayer.Character:FindFirstChild("crystallinePlow") == nil and game.Players.LocalPlayer.Backpack:FindFirstChild("crystallinePlow") == nil then
					if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") or game.Players.LocalPlayer.Backpack:FindFirstChild("hoe") then
						local TOOL =  game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") or game.Players.LocalPlayer.Backpack:FindFirstChild("hoe") 
						if TOOL:FindFirstChild("hoe") then
							GetTool("crystallinePlow", true, TOOL.Name)
							task.wait()
							TOOL.Parent = game.Players.LocalPlayer.Character
							task.wait()
							TOOL.Parent = game.Players.LocalPlayer.Backpack
						else
							Message("😳", "You can Only Bypass Plows :)", "hehe", "Woah")
						end
					else
						Message("🤪", "equip the tool you want to bypass first!", "Ok :)))", "Woah")
					end
				else
					Message("😎", "You got the crystallinePlow Already!", "xD", "Woah")
				end
			end
		})

		function SecretHammer()		
			local player = game.Players.LocalPlayer
			local mouse = player:GetMouse()

			local Tool = Instance.new("Tool", game:GetService("ReplicatedStorage"))
			local Handle = Instance.new("Part", Tool)
			Tool.PrimaryPart = Handle
			Handle.CanCollide = false
			local Mesh = Instance.new("SpecialMesh", Handle)
			Mesh.MeshId = "http://www.roblox.com/asset/?id=12592754"
			Mesh.MeshType = Enum.MeshType.FileMesh
			Mesh.TextureId = "http://www.roblox.com/asset/?id=12592745"

			local hammerModel = Tool

			local throwForce = 80
			local returnSpeed = 70
			local intervalDistance = 3
			local maxDistance = 40

			local function throwHammer()
				if _G.UseSecretHammer == true then
					local hammer = hammerModel:Clone()
					hammer.Parent = game.Workspace

					local character = player.Character
					if character then
						local characterRoot = character:FindFirstChild("HumanoidRootPart")
						if characterRoot then
							local camera = game.Workspace.CurrentCamera
							local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
							local throwDirection = ray.Direction

							local normalizedThrowDirection = Vector3.new(throwDirection.X, 0, throwDirection.Z).unit

							hammer:SetPrimaryPartCFrame(CFrame.new(characterRoot.Position))
							local hammerVelocity = normalizedThrowDirection * throwForce

							local bodyVelocity = Instance.new("BodyVelocity")
							bodyVelocity.Velocity = hammerVelocity
							bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
							bodyVelocity.Parent = hammer.PrimaryPart

							local lastPosition = hammer.PrimaryPart.Position
							local distanceTraveled = 0

							while hammer.Parent and distanceTraveled < maxDistance do
								local newPosition = hammer.PrimaryPart.Position
								local stepDistance = (newPosition - lastPosition).Magnitude

								distanceTraveled = distanceTraveled + stepDistance

								if stepDistance >= intervalDistance then
									local direction = (newPosition - lastPosition).unit
									local distanceBetweenPoints = stepDistance

									for distance = intervalDistance, distanceBetweenPoints, intervalDistance do
										local positionOnPath = lastPosition + direction * distance
										local roundedPosition = Vector3.new(
											math.floor(positionOnPath.X / intervalDistance) * intervalDistance,
											math.floor(positionOnPath.Y / intervalDistance) * intervalDistance,
											math.floor(positionOnPath.Z / intervalDistance) * intervalDistance
										)

										if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then

											local args = {
												[1] = {
													["upperBlock"] = false,
													["cframe"] = CFrame.new(roundedPosition), -- CFrame.new(Vector3.new(pos.x, pos.y, pos.z, 1, 0, 0, 0, 1, 0, 0, 0, 1))
													["blockType"] = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool").Name,
													[CropPlaceH1] = CropPlaceH2
												}
											}

											game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("CLIENT_BLOCK_PLACE_REQUEST"):InvokeServer(unpack(args))

											print("Remote sent!")

										end


										print("Hammer Position:", roundedPosition)
										local Part = Instance.new("Part", nil)
										Part.Anchored = true
										Part.Size = Vector3.new(3, 3, 3)
										Part.Position = roundedPosition
									end

									lastPosition = newPosition
								end

								wait(0.1)
							end

							if hammer.Parent then
								local returnDirection = (characterRoot.Position - hammer.PrimaryPart.Position).unit
								local returnVelocity = returnDirection * returnSpeed
								bodyVelocity.Velocity = returnVelocity

								repeat wait(0.1)

									local returnDirection = (characterRoot.Position - hammer.PrimaryPart.Position).unit
									local returnVelocity = returnDirection * returnSpeed
									bodyVelocity.Velocity = returnVelocity

								until (hammer.PrimaryPart.Position - characterRoot.Position).Magnitude <= 10

								bodyVelocity:Destroy()
								hammer:Destroy()
							end
						end
					end
				end
			end

			mouse.Button1Down:Connect(throwHammer)

		end


		local TimesClicked = 0
		local GotSecretButton = false
		local HaveFunSecretButton

		local BypassedProblemsSelection = Tabs.BypassFun:AddSection("Problems with the Bypasses?")

		local BypassedProblemsButton = BypassedProblemsSelection:AddParagraph({
			Title = "Problems?",
			Content = "Report Problems to the Discord!"
		})

		BypassedProblemsSelection:AddButton({
			Title = "Have Fun 🤯",
			Description = "",
			Callback = function()
				if TimesClicked > 14 then
					if GotSecretButton == false then
						SecretHammer()
						GotSecretButton = true

						local SuperSecretProHammerSelection = Tabs.BypassFun:AddSection("Super Secret Pro Hammer")

						local GetSuperSecretProHammer = SuperSecretProHammerSelection:AddToggle("GetSuperSecretProHammer", {Title = "Secret Pro Hammer 😨", Default = false })

						GetSuperSecretProHammer:OnChanged(function(Value)
							_G.UseSecretHammer = Value
						end)

					end
				else
					TimesClicked = TimesClicked + 1
				end
			end
		})

	else
		--local Section = Tab:CreateSection("Fun [BETA!]")
		-- Paragraph = Tab:CreateParagraph({Title = "Premium only!", Content = ""})



		local BypassedProblemsButton = Tabs.BypassFun:AddParagraph({
			Title = "Premium only!",
			Content = PremiumText1
		})


	end

	local IslandFarmSelection = Tabs.Other:AddSection("Island Farm")

	_G.Island_USERID = game.Players.LocalPlayer.UserId

	local UserIdLabel = IslandFarmSelection:AddParagraph({
		Title = "UserId:",
		Content = game.Players.LocalPlayer.UserId
	})

	local Input = IslandFarmSelection:AddInput("Input", {
		Title = "Username to Farm",
		Default = game.Players.LocalPlayer.Name,
		Placeholder = game.Players.LocalPlayer.Name,
		Numeric = false, -- Only allows numbers
		Finished = false, -- Only calls callback when you press enter
		Callback = function(Text)
			if Text == nil or Text == "" or Text == " " then return nil end
			local ID = game:GetService("Players"):GetUserIdFromNameAsync(Text) 
			if not ID then return nil end 
			_G.Island_USERID = ID
			UserIdLabel:SetDesc("UserId: ".._G.Island_USERID.." ("..Text..")")
		end
	})

	local Input = IslandFarmSelection:AddInput("Input", {
		Title = "Userid to Farm",
		Default = game.Players.LocalPlayer.UserId,
		Placeholder = game.Players.LocalPlayer.UserId,
		Numeric = true, -- Only allows numbers
		Finished = false, -- Only calls callback when you press enter
		Callback = function(ID)
			if not ID then return nil end
			_G.Island_USERID = ID
			UserIdLabel:Set("UserId: ".._G.Island_USERID)
		end
	})

	local Portal

	local RemovePortal = IslandFarmSelection:AddToggle("RemovePortal", {Title = "Remove Portal", Default = false })

	RemovePortal:OnChanged(function(Value)
		if not Portal or Portal.Parent ~= GetIsland():FindFirstChild("Blocks") then
			print("No Portal set... Getting!")
			local Island = GetIsland()
			if Island and Island:FindFirstChild("Blocks") then
				for i,v in pairs(Island:FindFirstChild("Blocks"):GetChildren()) do 
					if v:FindFirstChild("PortalActive") and v:FindFirstChild("portal-to-spawn") then
						Portal = v
					end
				end 
			end 
		end
		if Value == true then
			local Island = GetIsland()
			if Island and Island:FindFirstChild("Blocks") then
				local Portal = Island:FindFirstChild("Blocks"):FindFirstChild("portalToSpawn")
				if Portal then
					Portal.Parent = game
				end
			end 
		else
			local Island = GetIsland()
			if Island and Island:FindFirstChild("Blocks") then
				local Portal = game:FindFirstChild("portalToSpawn")
				if Portal then
					Portal.Parent = Island:FindFirstChild("Blocks")
				end
			end 
		end
	end)

	local OtherSelection = Tabs.Other:AddSection("Other")


	OtherSelection:AddButton({
		Title = "Read all Mails",
		Description = "",
		Callback = function()
			for i = 1,1000 do
				local args = {
					[1] = "game_update_"..i
				}

				game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged:FindFirstChild("Mailbox/ReadMail"):FireServer(unpack(args))

				task.wait()    
			end
		end
	})

	OtherSelection:AddButton({
		Title = "No Fog",
		Description = "",
		Callback = function()
			_G.NoFog = true
			Message("Success!", "Anti Fog got successfully Enabled!", "Nice!", 1)
		end
	})

	OtherSelection:AddButton({
		Title = "Kick all NPCS",
		Description = "",
		Callback = function()
			Window:Dialog({
				Title = "Are you sure?",
				Content = "",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							local Island = GetIsland()
							local Entities = Island:FindFirstChild("Entities") 
							if Entities then
								for i,v in pairs(Entities:GetChildren()) do
									if v:FindFirstChild("VillagerID") then
										game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("RequestVillagerLeave"):FireServer(v)
									end
								end
							end
						end
					},
					{
						Title = "Cancel",
						Callback = function()

						end
					}
				}
			})
		end
	})


	local AutoPickupTools = OtherSelection:AddToggle("AutoPickupTools", {Title = "Auto Pickup Tools", Default = false })

	AutoPickupTools:OnChanged(function(Value)
		if Value == true then
			_G.AutoPickupItems = true
		else
			_G.AutoPickupItems = false
		end
	end)

	local CleanIslandToggle = OtherSelection:AddToggle("CleanIsland", {Title = "Clean Island", Default = false })

	CleanIslandToggle:OnChanged(function(Value)
		if Value == true then
			_G.AutoCleanIsland = true
		else
			_G.AutoCleanIsland = false
		end
	end)


--[[

local Section = Tab:CreateSection("Chest")

Toggle = Tab:CreateToggle({
	Name = "Chest Aura",
	CurrentValue = false,
	Flag = "Chest_Aura", 
	Callback = function(Value)
		_G.ChestAura = Value
	end,
})

]]

	local FlowerSelection = Tabs.Other:AddSection("Flower")

	local FlowerAutoFarm = FlowerSelection:AddToggle("FlowerAutoFarm", {Title = "Flower Auto Farm", Default = false })

	FlowerAutoFarm:OnChanged(function(Value)
		if Value == true then
			_G.flowerFarm = true
		else
			_G.flowerFarm = false
		end
	end)

	local FlowerAura = FlowerSelection:AddToggle("FlowerAura", {Title = "Flower Aura", Default = false })

	FlowerAura:OnChanged(function(Value)
		if Value == true then
			_G.flowerAura = true
		else
			_G.flowerAura = false
		end
	end)

	local PlowSelection = Tabs.Other:AddSection("Plow Island")

	local PlowAuraToggle = PlowSelection:AddToggle("PlowAura", {Title = "Plow Aura", Default = false })

	PlowAuraToggle:OnChanged(function(Value)
		if Value == true then
			_G.PlowAura = true
		else
			_G.PlowAura = false
		end
	end)

	local unPlowAuraToggle = PlowSelection:AddToggle("unPlowAura", {Title = "unPlow Aura", Default = false })

	unPlowAuraToggle:OnChanged(function(Value)
		if Value == true then
			_G.UnPlowAura = true
		else
			_G.UnPlowAura = false
		end
	end)

	local PlowDistanceSlider = PlowSelection:AddSlider("PlowDistanceSlider", {
		Title = "Plow Distance",
		Description = "",
		Default = 10,
		Min = 1,
		Max = 35,
		Rounding = 0,
		Callback = function(Value)
			_G.PlowDistance = Value
		end
	})


	local CropPlaceAuraSelection = Tabs.Other:AddSection("Crop Place Aura")

	local CropPlaceAura = CropPlaceAuraSelection:AddToggle("CropPlaceAura", {Title = "Crop Place Aura", Default = false })

	CropPlaceAura:OnChanged(function(Value)
		if Value == true then
			_G.AuraAuraPlace = true
		else
			_G.AuraAuraPlace = false
		end
	end)

	local CropPlaceAuraDistance = CropPlaceAuraSelection:AddSlider("CropPlaceAuraDistance", {
		Title = "Crop Distance",
		Description = "",
		Default = 25,
		Min = 1,
		Max = 25,
		Rounding = 0,
		Callback = function(Value)
			_G.PlaceCropsMaxArea = Value
		end
	})

	local AnimalSelection = Tabs.Other:AddSection("Pets/Animals")

	local AnimalAutoFarm = AnimalSelection:AddToggle("AnimalAutoFarm", {Title = "Pet Auto Farm", Default = false })

	AnimalAutoFarm:OnChanged(function(Value)
		if Value == true then
			_G.PET_ANIMALFarm = true
		else
			_G.PET_ANIMALFarm = false
		end
	end)


	local AnimalAura = AnimalSelection:AddToggle("AnimalAura", {Title = "Pet Aura", Default = false })

	AnimalAura:OnChanged(function(Value)
		if Value == true then
			_G.PET_ANIMALAura = true
		else
			_G.PET_ANIMALAura = false
		end
	end)


	local BankSelection = Tabs.Other:AddSection("Bank")

	local DeposittoBank = BankSelection:AddInput("DeposittoBank", {
		Title = "Deposit to Bank",
		Default = "0",
		Placeholder = "0",
		Numeric = true, -- Only allows numbers
		Finished = true, -- Only calls callback when you press enter
		Callback = function(Value)
			local args = {
				[1] = Hash(),
				[2] = {
					[1] = {
						["accountType"] = "PERSONAL",
						["transferType"] = "DEPOSIT",
						["amount"] = tonumber(Value)
					}
				}
			}

			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.TransactionBankBalance:FireServer(unpack(args))	
		end
	})

	local WithdrawFromBank = BankSelection:AddInput("WithdrawFromBank", {
		Title = "Withdraw From Bank",
		Default = "0",
		Placeholder = "0",
		Numeric = true, -- Only allows numbers
		Finished = true, -- Only calls callback when you press enter
		Callback = function(Value)
			local args = {
				[1] = Hash(),
				[2] = {
					[1] = {
						["accountType"] = "PERSONAL",
						["transferType"] = "WITHDRAWAL",
						["amount"] = tonumber(Value)
					}
				}
			}

			game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.TransactionBankBalance:FireServer(unpack(args))	
		end
	})

	local ScriptSettingsSelection = Tabs.Settings:AddSection("Script Settings")


	local TeleportMethod = ScriptSettingsSelection:AddDropdown("TeleportMethod", {
		Title = "Teleport Method",
		Values = {"Tween","TweenV3", "MiniTp", "Instant", "Pathfinding", "PathfindingV2"},
		Multi = false,
		Default = 1,
	})


	TeleportMethod:OnChanged(function(Value)
		_G.TeleportMethod = Value
	end)

	ScriptSettingsSelection:AddButton({
		Title = "Stop Gay Tween",
		Description = "",
		Callback = function()
			if LASTTWEEN == nil then
				-- warn("Tween ist nil!")
			else
				LASTTWEEN:Cancel()
			end
		end
	})

	local DisableXP = ScriptSettingsSelection:AddToggle("DisableXP", {Title = "Disable XP [ANTI LAG!]", Default = false })

	DisableXP:OnChanged(function(Value)
		local LocalPlayer = game.Players.LocalPlayer
		if Value == true then
			LocalPlayer.PlayerScripts.TS.modules.experience["experience-listener"].Disabled = true
		else
			LocalPlayer.PlayerScripts.TS.modules.experience["experience-listener"].Disabled = false
		end
	end)

	local originalValues = {}

	local AntilagV1L

	local Lighting = game:GetService("Lighting")

	local function AntiLag()
		local PCALL = pcall(function()
			-- Speichere die ursprünglichen Werte der Eigenschaften

			local Terrain = workspace:FindFirstChildOfClass('Terrain')
			originalValues.TerrainWaterWaveSize = Terrain.WaterWaveSize
			originalValues.TerrainWaterWaveSpeed = Terrain.WaterWaveSpeed
			originalValues.TerrainWaterReflectance = Terrain.WaterReflectance
			originalValues.TerrainWaterTransparency = Terrain.WaterTransparency

			originalValues.LightingGlobalShadows = Lighting.GlobalShadows
			originalValues.LightingFogEnd = Lighting.FogEnd
			originalValues.RenderingQualityLevel = settings().Rendering.QualityLevel

			for i, v in pairs(game.Workspace:GetDescendants()) do

				if v:IsA("MeshPart") and v.Parent and v.Parent.Name == "wheat" then

					print(v.Name)
					originalValues[v] = {
						Material = v.Material,
						Reflectance = v.Reflectance,
						MeshId = v.MeshId
					}
					v.Material = Enum.Material.Plastic
					v.Reflectance = 0
					v.MeshId = 0

				elseif v:IsA("BasePart") or v:IsA("UnionOperation") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then 


					if v.Name == "stage-3" then
						print(v.Name)
					end
					originalValues[v] = {
						Material = v.Material,
						Reflectance = v.Reflectance
					}
					v.Material = Enum.Material.Plastic
					v.Reflectance = 0

				elseif v:IsA("Decal") then
					originalValues[v] = {
						Transparency = v.Transparency
					}
					v.Transparency = 1
				elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
					originalValues[v] = {
						Lifetime = v.Lifetime
					}
					v.Lifetime = NumberRange.new(0)
				elseif v:IsA("Explosion") then
					originalValues[v] = {
						BlastPressure = v.BlastPressure,
						BlastRadius = v.BlastRadius
					}
					v.BlastPressure = 1
					v.BlastRadius = 1
				end

			end

			for i, v in pairs(Lighting:GetDescendants()) do
				if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
					originalValues[v] = {
						Enabled = v.Enabled
					}
					v.Enabled = false
				end
			end

			-- Überwache neue Kinder im Workspace und entferne bestimmte Elemente

			local function handleDescendantAdded(child)
				coroutine.wrap(function()
					local v = child
					if v:IsA("MeshPart") and v.Parent and v.Parent.Name == "wheat" then
						originalValues[v] = {
							Material = v.Material,
							Reflectance = v.Reflectance,
							MeshId = v.MeshId
						}
						v.Material = Enum.Material.Plastic
						v.Reflectance = 0
						v.MeshId = 0
					elseif child:IsA('ForceField') then
						task.wait()
						child:Destroy()
					elseif child:IsA('Sparkles') then
						task.wait()
						child:Destroy()
					elseif child:IsA('Smoke') or child:IsA('Fire') then
						task.wait()
						child:Destroy()
					end
				end)()
			end

			AntilagV1L = workspace.DescendantAdded:Connect(handleDescendantAdded)
		end)
	end

	local function UndoAntiLag()
		local Pcall = pcall(function()
			-- Stelle die ursprünglichen Werte der Eigenschaften wieder her

			local Terrain = workspace:FindFirstChildOfClass('Terrain')
			Terrain.WaterWaveSize = originalValues.TerrainWaterWaveSize
			Terrain.WaterWaveSpeed = originalValues.TerrainWaterWaveSpeed
			Terrain.WaterReflectance = originalValues.TerrainWaterReflectance
			Terrain.WaterTransparency = originalValues.TerrainWaterTransparency

			Lighting.FogEnd = originalValues.LightingFogEnd
			settings().Rendering.QualityLevel = originalValues.RenderingQualityLevel

			for i, v in pairs(game.Workspace:GetDescendants()) do
				if originalValues[v] then
					if v:IsA("MeshPart") and v.Parent and v.Parent.Name == "wheat"  then

						v.Material = originalValues[v].Material
						v.Reflectance = originalValues[v].Reflectance
						v.MeshId = originalValues[v].MeshId


					elseif  v:IsA("BasePart") or v:IsA("UnionOperation") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
						v.Material = originalValues[v].Material
						v.Reflectance = originalValues[v].Reflectance
					elseif v:IsA("Decal") then
						v.Transparency = originalValues[v].Transparency
					elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
						v.Lifetime = originalValues[v].Lifetime
					elseif v:IsA("Explosion") then
						v.BlastPressure = originalValues[v].BlastPressure
						v.BlastRadius = originalValues[v].BlastRadius
					end
					originalValues[v] = nil
				end
			end

			for i, v in pairs(Lighting:GetDescendants()) do
				if originalValues[v] then
					v.Enabled = originalValues[v].Enabled
					originalValues[v] = nil
				end
			end


			if AntilagV1L then
				AntilagV1L:Disconnect()
			end
		end)
	end



--[[

local AntiLagV2 = ScriptSettingsSelection:AddToggle("AntiLagV2", {Title = "Anti Lag V2", Default = false })

AntiLagV2:OnChanged(function(Value)
	local LocalPlayer = game.Players.LocalPlayer
		if Value == true then
			LocalPlayer.PlayerScripts.TS.modules.experience["experience-listener"].Disabled = true
		else
			LocalPlayer.PlayerScripts.TS.modules.experience["experience-listener"].Disabled = false
		end
		if Value == true then
			-- AntiLag()
		else
			UndoAntiLag()
		end

end)

]]

	ScriptSettingsSelection:AddButton({
		Title = "Stop Script",
		Description = "",
		Callback = function()
			if MAINSCRIPTHANDLER ~= nil then
				MAINSCRIPTHANDLER:Disconnect()
			end
		end
	})

	local FlyKeyBind = ScriptSettingsSelection:AddKeybind("FlyKeyBind", {
		Title = "Fly Key",
		Mode = "Toggle", -- Always, Toggle, Hold
		Default = "G", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

		-- Occurs when the keybind is clicked, Value is `true`/`false`
		Callback = function(Value)
			if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("BodyVelocity") then
				PlayerFly:SetValue(false)
			else
				PlayerFly:SetValue(true)
			end
		end,

		-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
		ChangedCallback = function(New)
			print("Keybind changed!", New)
		end
	})


	local ColorSettingsSelection = Tabs.Settings:AddSection("Color Settings")

	local ResizeToolOutlineColor = ColorSettingsSelection:AddColorpicker("ResizeToolOutlineColor", {
		Title = "ResizeToolOutlineColor",
		Default = Color3.fromRGB(225, 0, 0)
	})

	ResizeToolOutlineColor:OnChanged(function(Value)
		_G.ResizeToolOutlineColor = Value
	end)

	local ResizeToolMoveButtons = ColorSettingsSelection:AddColorpicker("ResizeToolMoveButtons", {
		Title = "ResizeToolMoveButtons",
		Default = Color3.fromRGB(254, 254, 254)
	})

	ResizeToolMoveButtons:OnChanged(function(Value)
		_G.ResizeToolMoveButtonColor = Value
	end)

	local ResizeToolFillColor = ColorSettingsSelection:AddColorpicker("ResizeToolFillColor", {
		Title = "Resize Tool FillColor",
		Description = "",
		Transparency = 0,
		Default = Color3.fromRGB(96, 205, 255),
	})

	ResizeToolFillColor:OnChanged(function()
		_G.ResizeToolFillColor = ResizeToolFillColor.Value
		_G.ResizeToolFillTransparency = ResizeToolFillColor.Transparency
	end)


--[[

local Section = Tab:CreateSection("Loader Settings")

CreateFolder("AutoStart")
CreateFile("/AutoStart/AutoLoadSettings", "false", true)

local Button = Tab:CreateButton({
	Name = "Load Settings",
	Callback = function()
		Rayfield:LoadConfiguration()
	end,
})

Toggle = Tab:CreateToggle({
	Name = "Auto Load Settings on Script Start",
	CurrentValue = false,
	Flag = "Auto Load Settings on Script Start", 
	Callback = function(Value)
		if Value == true then
			CreateFile("/AutoStart/AutoLoadSettings", "true", false)
		else
			CreateFile("/AutoStart/AutoLoadSettings", "false", false)
		end
	end,
})

if ReadFile("/AutoStart/AutoLoadSettings") == "true" then
	print("Loading Settings...")
	Rayfield:LoadConfiguration()
else
	print("Not Loading Settings!")
end

]]

--[[

local Button = Tab:CreateButton({
	Name = "Anti Cheat Bypass [BETA]",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/samuelLovesPie/verm_releases/main/IslandsTPBypass.lua"))()
	end,
})

]]



	_G.TweenFlySpeed = 25

	_G.RockTarget = "Stone"
	_G.RockFarmSpeed = 25
	_G.AutoReplaceCrop = true
	_G.SelectedTree = "all"
	_G.SelectedMob = "slime"
	_G.SelectedCrop = "wheat"
	_G.CropAura_BETA = false
	_G.UseSichle = true
	_G.SichleCropDelay = 13
	_G.SichleCropRange = 30
	_G.WalkSpeed = 30
	_G.JumpPower = 50
	_G.TeleportMethod = "Tween"
	_G.UseSichleTool = "sickleStone"
	_G.PET_ANIMALFarm = false
	_G.PET_ANIMALAura = false
	_G.PlowDistance = 10
	_G.FastBlockPrinter = true
	_G.Place3 = false
	_G.PlayerBlockPrinterSpeed = 5
	_G.BlockPrinterTP = true
	_G.Island_USERID = game.Players.LocalPlayer.UserId
	_G.SelectedBoss = "slimeKing"
	_G.MobTpYPos = 8
	_G.SafeUseSichle = true
	_G.SuperFastCropFarm = false
	_G.RemotesToSendToDestroy = 3
	_G.PlaceCropsMaxArea = 30

	_G.CheckPrintedBlocks = true

	_G.SelectedTotem = "totemWheat"
	_G.SelectedUpgrade = "utility"
	_G.TotemLevel = 25
	_G.AutoUpgradeTotem = false 

	_G.ResizeToolOutlineColor = Color3.fromRGB(225, 0, 0)

	_G.ResizeToolMoveButtonColor = Color3.fromRGB(254, 254, 254)

	_G.ResizeToolFillTransparency = 1
	_G.ResizeToolFillColor = Color3.fromRGB(225, 225, 225)

	local MainCooldown = false
	local CB = false

	local FM = false
	local ReplaceCooldown = false

	game:GetService("RunService").RenderStepped:Connect(function()
		local Character = game.Players.LocalPlayer.Character 
		if Character then
			local Humanoid = Character:FindFirstChild("Humanoid")
			if Humanoid then
				Humanoid.WalkSpeed = _G.WalkSpeed or 30
				Humanoid.JumpPower = _G.JumpPower or 50
			end
		end
	end)



	MAINSCRIPTHANDLER = game:GetService("RunService").RenderStepped:Connect(function()

		if _G.NoFog == true then
			local Lighting = game:GetService("Lighting")
			Lighting.FogEnd = 100000
			for i,v in pairs(Lighting:GetDescendants()) do
				if v:IsA("Atmosphere") then
					v:Destroy()
				end
			end
		end

		-- Event --

		-- Event --


		if _G.AutoFarm == true then
			if FM == false then
				FM = true
				FarmMob()
				--task.wait(0.1)
				FM = false
			end
		else
			_G.MobRemoteSpamming = false
			if _G.DoubleAutoFarm == true then
				DoubleFarmMob()
			end
		end



		if _G.BossAutoFarm == true then
			BossCheck(_G.SelectedBoss)
		end

		if _G.MobKillAura == true then
			KillAura()
		end

		if _G.voidParasiteFarm == true then
			voidParasiteFarm(true)
		end

		if _G.SpiritAutoFarmBool == true then
			spiritFarm(true)
		end



		if _G.AuraAuraPlace == true then
			SeedAura()
		end

		if _G.PET_ANIMALFarm == true then
			PET_ANIMALFarm(true)
		end

		if _G.PET_ANIMALAura == true then
			PET_ANIMALFarm(false)
		end

		if _G.flowerAura == true  then
			flowerFarm(false)
		end

		if _G.PlowAura == true  then
			if PLAC == false then -- funktion cooldown wegen lag
				PlowAura(true)
			end
		end


		if _G.UnPlowAura == true then -- funktion cooldown wegen lag
			if PLAC == false then
				PlowAura(false)
			end
		end

		if _G.flowerFarm == true  then
			flowerFarm(true)
		end

		if _G.CropAutoFarm == true then
			if _G.UseSichle == true then
				if SichleFarmCooldown == false then
					SichleFarmCooldown = true
					local LocalPlayer = game.Players.LocalPlayer
					SichleCropFarm(true)
				end
			else
				local LocalPlayer = game.Players.LocalPlayer
				CropFarm(true)
			end

		end

		if _G.CropAura_BETA == true then
			if _G.UseSichle == true then
				if SichleAuraCooldown == false then
					SichleAuraCooldown = true
					local LocalPlayer = game.Players.LocalPlayer
					SichleCropFarm(false)
				end
			else
				local LocalPlayer = game.Players.LocalPlayer
				CropFarm(false)
			end
		end


		if _G.TreeAutoFarm == true then
			TreeFarm(true)
		end	

		if _G.TreeAura == true then
			TreeFarm(false)
			-- TreeAura()
		end

		if _G.FishFarm == true then
			FishFarm()
		end

		if _G.ChestAura == true then
			ChestAura()
		end

		if _G.AutoCollectFruits == true then
			AutoCollectFruits()
		end

		if _G.RockAutoFarm == true then
			RockFarmV2(_G.RockTarget or "Stone", true)
		end


		if _G.RockFarmonIsland == true then
			RockFarmV2(_G.RockTargetonIsland or "Stone", true)
		end

		if _G.RockAura == true then
			RockAura()
		end

		if _G.AutoPickupItems == true then
			AutoPickupItems()
		end

		if _G.AutoCleanIsland == true then
			CleanIsland()
		end

		-- TOTEM --


		if _G.AutoCollectTotemItems == true then
			AutoCollectTotemItems()
		end

		if 	_G.AutoUpgradeTotem == true then

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

			local Island = GetIsland()

			local Totems = {}

			for i,v in ipairs(Island:FindFirstChild("Blocks"):GetChildren()) do
				if v.Name == _G.SelectedTotem then

					if v:FindFirstChild("UpgradeProgress"):FindFirstChild(_G.SelectedUpgrade) then
						if v:FindFirstChild("UpgradeProgress"):FindFirstChild(_G.SelectedUpgrade).Value <= _G.TotemLevel then
							table.insert(Totems, v)
							task.wait()
						else
							DebugCheck(0,"Level erreicht!")
							return nil 
						end
					else 
						DebugCheck(0,"UpgradeProgress not found!")
						return nil 
					end
				end
			end

			local NearestTotem = findNearestPart(Totems)

			print("Nearest:",NearestTotem)

			local v = NearestTotem

			while NearestTotem and v:FindFirstChild("UpgradeProgress") and v:FindFirstChild("UpgradeProgress"):FindFirstChild(_G.SelectedUpgrade).Value < _G.TotemLevel do

				if _G.AutoUpgradeTotem == false then 
					return nil 
				end


				local Distance = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

				if Distance > 10 then
					print("Distance Kleiner als 20")
					TeleportV4(v.Position)
					repeat wait() TeleportV4(v.Position) until (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 9 
				end


				local ohInstance1 = v
				local ohString2 = GetName(v.Name)
				local ohString3 = _G.SelectedUpgrade

				game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.UpgradeBlock:InvokeServer(ohInstance1, ohString2, ohString3)


			end

		end -- abfrage

		-- TOTEM --

	end)

--[[


DebugCheck(0,"Gui lol!")

Gui:FindFirstChild("Main").MouseEnter:Connect(function()
	DebugCheck(0,"INGUI")
	CANUSEAUTOCLICKER = false
end)

Gui:FindFirstChild("Main").MouseLeave:Connect(function()
	DebugCheck(0,"OUTOFUI")
	CANUSEAUTOCLICKER = true
end)


]]
--[[

game:GetService("RunService").RenderStepped:connect(function()
	if _G.DebugMode ~= true then
		-- DebugCheck(0,Hash())
	end

	if Gui then
		Gui.Name = Hash()
		for i,v in ipairs(Gui:GetChildren()) do
			v.Name = Hash()
		end
	end
end)

while Rayfield ~= nil do


	local VERSION = loadstring(game:HttpGet('https://raw.githubusercontent.com/pascaldercoole1/NekoHub-Beta/main/MAIN_VERSION'))()

	local C_VERSION = 1

	if VERSION ~= C_VERSION then