repeat wait() until game:IsLoaded()

local IsPremium = true 
local DidKey = false
local ScriptVersion = "V4"

local FileName = "Nekohub"
local GameName = "Islands"
local DeveloperVersion = true

local NotificationIcon = "rbxassetid://1234567890"

function SendNotification(Title, Text)
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = Title, -- Required
		Text = Text, -- Required
		Icon = NotificationIcon -- Optional
	})
end	

SendNotification("Welcome!", "Welcome to "..FileName .. " " .. ScriptVersion.."!")

local PremiumText1 = "Premium is only 2$ Lifetime. Go buy it in discord.gg/MbsxuDEzgT"

if isfolder(FileName) then

else
	makefolder(FileName)
end


if isfolder(FileName.."/"..GameName) then

else
	makefolder(FileName.."/"..GameName)
end

function IsFile(Name)
	return isfile(FileName.."/"..GameName.."/"..Name)
end	

function IsFolder(Name)
	return isfolder(FileName.."/"..GameName.."/"..Name)
end	


function ReadFile(Name) 
	if isfile(FileName.."/"..GameName.."/"..Name) == true then
		return readfile(FileName.."/"..GameName.."/"..Name)
	else
		return readfile(FileName.."/"..GameName..Name)
	end
	return readfile(FileName.."/"..GameName.."/"..Name)
end

function CreateFolder(Name)
	makefolder(FileName.."/"..GameName.."/"..Name)
end	

function CreateFile(Name, Data, CheckIfFile)
	if CheckIfFile == true then
		if isfile(FileName.."/"..GameName.."/"..Name) then

		else
			writefile(FileName.."/"..GameName.."/"..Name, Data)
		end
	else
		writefile(FileName.."/"..GameName.."/"..Name, Data)
	end
end	

-- local TemplateFile = game:HttpGet("https://pastebin.com/raw/yQUgfbZy")
-- CreateFile("/Schematica/Template", TemplateFile, false)


task.wait(1)

function GetSchematicaFiles()
	local Path = FileName.."/"..GameName.."/".."Schematica"

	local Files = listfiles(Path)

	if not Files or (#Files == 0) then
		local TemplateFile = game:HttpGet("https://pastebin.com/raw/yQUgfbZy")
		CreateFile("/Schematica/Template", TemplateFile, false)

		task.wait(1)

		local Files = listfiles(Path)

		return Files;

	else
		return Files;
	end



	--[[

	for i,v in pairs(Files) do
		print(i,v)
	end

	]]
end

CreateFolder("Schematica")

CreateFolder("ello")

-- if _G.UJGNAIKGNAJGNJSAGNLSAGLSLKRGJLKNIGANBJIERGBJISRABIGBSJIGNBSHGNNKISGABISGBSNGJSNJGSNGLJKSNG == true then

if IsPremium == false then -- true
	IsPremium = true
	DidKey = true
else
	DidKey = false
	-- KeySystem()
end


local CloneFolder

if game:GetService("Workspace"):FindFirstChild("Clones/Ne_KO_HUB") then
	CloneFolder = game:GetService("Workspace"):FindFirstChild("Clones/Ne_KO_HUB")
else
	local F = Instance.new("Model")
	F.Parent = game:GetService("Workspace")
	F.Name = "Clones/Ne_KO_HUB"
	CloneFolder = F
end

function DeleteIsland(PASSWORD)
	if PASSWORD == "UI NB)QUN BGTUI(O $ I)ONHZIO$NUI GOH)U$UB GZ)($NZOU IGHN$)(TMI)(O)" then 
		game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("CLIENT_RESET_ISLAND_REQUEST"):InvokeServer()
	end
end

function IsInTable(Table, NameToCheck)
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
		return false
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

DebugCheck(0,"im waiting...")

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local NofLibery = loadstring(game:HttpGet('https://raw.githubusercontent.com/NtReadVirtualMemory/Open-Source-Scripts/refs/heads/main/Rayfield.lua'))() -- https://raw.githubusercontent.com/pascaldercoole1/NekoHub-Beta/main/Nekohub%20V3

DebugCheck(0,"Loaded!")

DebugCheck(0,"Anti AFK: Loaded!")

game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)

_G.TeleportSpeed = 30


function TweenHello()
	local Notify = Instance.new("ScreenGui")
	local Background = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Image = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local Label = Instance.new("TextLabel")
	local Text = Instance.new("TextLabel")
	local Line = Instance.new("Frame")

	local TweenService = game:GetService("TweenService")

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	Background.Position = UDim2.new(-1, 0, 0.5, 0)

	local tween = TweenService:Create(Background, tweenInfo, {
		Position = UDim2.new(0.05, 0, 0.5, 0)
	})

	local function removeNotification()
		wait(3)
		tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
		local tweenOut = TweenService:Create(Background, tweenInfo, {
			Position = UDim2.new(-1, 0, 0.5, 0)
		})
		tweenOut:Play()
		wait(1)
		Notify:Destroy()
	end


	Notify.Name = "Notify"
	Notify.Parent = game:GetService("CoreGui")
	Notify.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Background.Name = "Background"
	Background.Parent = Notify
	Background.BackgroundColor3 = Color3.fromRGB(6, 5, 35)
	Background.Position = UDim2.new(0.05, 0, 0.5, 0)
	Background.Size = UDim2.new(0, 240, 0, 70)

	UICorner.CornerRadius = UDim.new(0, 15)
	UICorner.Parent = Background

	Image.Name = "Image"
	Image.Parent = Background
	Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Image.BorderSizePixel = 0
	Image.Position = UDim2.new(0.0291666668, 0, 0.142857149, 0)
	Image.Size = UDim2.new(0, 50, 0, 50)
	Image.Image = "rbxassetid://12954693578"
	Image.ScaleType = Enum.ScaleType.Tile

	UICorner_2.Parent = Image

	Label.Name = "Label"
	Label.Parent = Background
	Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1.000
	Label.BorderSizePixel = 0
	Label.Position = UDim2.new(0.273145556, 0, 0, 0)
	Label.Size = UDim2.new(0, 167, 0, 35)
	Label.Font = Enum.Font.SourceSansBold
	Label.Text = "Neko Hub V4"
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 28.000

	Text.Name = "Text"
	Text.Parent = Background
	Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Text.BackgroundTransparency = 1.000
	Text.BorderSizePixel = 0
	Text.Position = UDim2.new(0.273145556, 0, 0.50957489, 0)
	Text.Size = UDim2.new(0, 167, 0, 24)
	Text.Font = Enum.Font.SourceSans
	Text.Text = "Welcome!"
	Text.TextColor3 = Color3.fromRGB(255, 255, 255)
	Text.TextSize = 23.000

	Line.Name = "Line"
	Line.Parent = Background
	Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Line.BackgroundTransparency = 0.300
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0.237499997, 0, 0.5, 0)
	Line.Size = UDim2.new(0, 183, 0, 1)

	local TweenService = game:GetService("TweenService")

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	Background.Position = UDim2.new(-1, 0, 0.5, 0)

	local tween = TweenService:Create(Background, tweenInfo, {
		Position = UDim2.new(0.05, 0, 0.5, 0)
	})

	tween:Play()

	local soundId = "rbxassetid://4695797538"

	local sound = Instance.new("Sound")
	sound.Name = "MySound"
	sound.SoundId = soundId
	sound.Volume = 1
	sound.PlaybackSpeed = 1
	sound.Looped = false
	sound.Parent = game.Workspace

	sound:Play()

	local function removeNotification()
		wait(3)
		tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
		local tweenOut = TweenService:Create(Background, tweenInfo, {
			Position = UDim2.new(-1, 0, 0.5, 0)
		})
		tweenOut:Play()
		wait(1)
		Notify:Destroy()
	end

	removeNotification()
end


TweenHello()

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/IJHGIAJGIHJASUIJGHIUHIUHSUIAOHJAHOIBNAO/Nekohub/main/Fluent-master/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/IJHGIAJGIHJASUIJGHIUHIUHSUIAOHJAHOIBNAO/Nekohub/main/Fluent-master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/IJHGIAJGIHJASUIJGHIUHIUHSUIAOHJAHOIBNAO/Nekohub/main/Fluent-master/Addons/InterfaceManager.lua"))()
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/pascaldercoole1/NekoHub-Beta/main/Nekohub%20V3'))() 



--[[


if _G.SVMZeGIyVb8MDqFsrL0M == true then

else
	game.Players.LocalPlayer:Kick("BYE!")
	task.wait(2)
	while true do end
end

]]



function Remotes()
	DebugCheck(0,"HASH AUTO UPDATE 4")

	function UpdateRemote(RemoteName, Value)
		if game:FindFirstChild("_REMOTES_NEKO_") == nil then
			local REMOTES = Instance.new("Folder")
			REMOTES.Name = "_REMOTES_NEKO_"
			REMOTES.Parent = game
			UpdateRemote(RemoteName, Value)
		else
			if game:FindFirstChild("_REMOTES_NEKO_"):FindFirstChild(RemoteName) == nil then
				local _NEWREMOTE = Instance.new("StringValue")
				_NEWREMOTE.Name = RemoteName
				_NEWREMOTE.Value = Value
				_NEWREMOTE.Parent = game:FindFirstChild("_REMOTES_NEKO_")
			else
				DebugCheck(0,"Remote Update: "..RemoteName)
				game:FindFirstChild("_REMOTES_NEKO_"):FindFirstChild(RemoteName).Value = Value
			end
		end
	end

	if IsFolder("/Hash System") and IsFile("Game Version") and ReadFile("Game Version") and game.PlaceVersion == tonumber(ReadFile("Game Version")) then
		print("Ist Nicht geupdated!")

		UpdateRemote("KillRemote", ReadFile("/Hash System/KillRemote")) -- 2
		UpdateRemote("KillRemoteHashName", ReadFile("/Hash System/KillRemoteHashName")) -- 2
		_G.KillRemoteHash = ReadFile("/Hash System/KillRemoteHash")

		UpdateRemote("FishFarmFinishRemote", ReadFile("/Hash System/FishFarmFinishRemote")) -- 2
		UpdateRemote("AngelRemote", ReadFile("/Hash System/AngelRemote")) -- 2

		UpdateRemote("TOOL_PICKUPHashData", ReadFile("/Hash System/TOOL_PICKUPHashData")) -- 2
		_G.TOOL_PICKUPHash = ReadFile("/Hash System/TOOL_PICKUPHash")

		UpdateRemote("CropHashData", ReadFile("/Hash System/CropHashData")) -- 2
		_G.CropHash = ReadFile("/Hash System/CropHash")

		UpdateRemote("TreeHashData", ReadFile("/Hash System/TreeHashData")) -- 2
		_G.TreeHash = ReadFile("/Hash System/TreeHash")
		UpdateRemote("BlockHitHashData", ReadFile("/Hash System/BlockHitHashData")) -- 2
		_G.BlockHitHash = ReadFile("/Hash System/BlockHitHash")

		UpdateRemote("FlowerCollect", "client_request_1") -- 1
		UpdateRemote("PetCollect", "CLIENT_PET_ANIMAL")
		UpdateRemote("BlockRemote", "CLIENT_BLOCK_HIT_REQUEST")
		UpdateRemote("SpiritRemote", "nflutpppqsFS/ZroaqkcspgrTkvpnkrdWcc")

		UpdateRemote("CropPlaceHashData", ReadFile("/Hash System/CropPlaceHashData")) -- 2
		_G.CropPlaceHash = ReadFile("/Hash System/CropPlaceHash") -- 2
		_G.CropPlaceH1 = ReadFile("/Hash System/BlockPlaceHashData") 
		UpdateRemote("BlockPlaceHashData", ReadFile("/Hash System/BlockPlaceHashData")) -- 2
		_G.BlockPlaceHash = ReadFile("/Hash System/BlockPlaceHash") -- 2

	else

		CreateFolder("Hash System")

		print("Getting Hashes!")

		CreateFile("Game Version", tostring(game.PlaceVersion), false)

		function Update()
			local MOBRIGHT = ""
			local MOBLEFT = ""
			local mobRemoteName = ""
			function UpdateMob()

				local Tool

				for i,v in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do 
					if v.Name == "swordWood" then
						local Clone = v:Clone()
						Clone.Parent = game.Players.LocalPlayer.Character
						task.wait(0.2)
						Clone.Parent = game.Players.LocalPlayer.Backpack
						task.wait(0.2)
						Clone.Parent = game.Players.LocalPlayer.Character
						task.wait(0.2)
						Tool = Clone
					end
				end

				local function getrem(p9)
					rem = ""
					for i,v in pairs(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]:GetChildren()) do
						if v.Name:match(p9) then
							rem = v
						end
					end
					return rem.Name
				end
				local remleft = ""
				mobrem = ""
				for i,v in pairs(getgc(true)) do
					if type(v) == "function" and getinfo(v).name == "attemptHit" then
						for i2,v2 in pairs(getprotos(v)) do
							for i3,v3 in pairs(getprotos(v2)) do
								mobrem = getrem("/"..getconstants(v3)[1])
								remleft = getconstants(v3)[4]
							end
						end
					end
				end


				for i,v in pairs(getgc(true)) do
					if type(v) == "function" and getinfo(v).name == "attemptHit" then
						MOBRIGHT = getupvalues(v)[5]
						task.wait() -- 1
					end
				end
				print("mobrem:",mobrem)
				mobramsides = string.split(mobrem, "/")

				MOBLEFT = remleft
				if mobramsides and mobramsides[1] and mobramsides[2] then
					mobRemoteName = mobramsides[1].."/"..mobramsides[2]
					if MOBRIGHT then
						_G.KillRemoteHash = MOBRIGHT
					else
						_G.KillRemoteHash = nil
					end 
				else
					_G.KillRemoteHash = nil
					local RunService = game:GetService("RunService")
					local CoreGui = game:GetService("CoreGui")




				end
				if Tool then
					DebugCheck(0,"Sword ist da")

					Tool.Parent = game.Players.LocalPlayer.Backpack
					Tool:Destroy()
				else
					DebugCheck(0,"NO SWORD!")
				end
			end

			UpdateMob()


			local Remote1
			local Remote15
			local Remote2

			function UpdateFish()

				local Tool

				for i,v in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do 
					if v.Name == "fishingRod" then
						local Clone = v:Clone()
						Clone.Parent = game.Players.LocalPlayer.Character
						task.wait(0.5)
						Clone.Parent = game.Players.LocalPlayer.Backpack
						task.wait(0.5)
						Clone.Parent = game.Players.LocalPlayer.Character
						task.wait(0.5)
						Tool = Clone
					end
				end

				local function getrem(p9)
					rem = ""
					for i,v in pairs(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]:GetChildren()) do
						if v.Name:match(p9) then
							rem = v
						end
					end
					return rem.Name
				end

				local WerfRemote

				local dump1
				local dump2



				if Tool then
					local ToolScript = Tool:FindFirstChild("fishing-rod")

					if Tool and ToolScript then
						for i,v222 in pairs(getgc(true)) do
							if type(v222) == "function" and  getfenv(v222).script == ToolScript then


								for i,v in pairs(getconstants(v222)) do
									if i == 9 then

										if getrem(v) then
											DebugCheck(0,v)
											if v == 1.5 or v == "1.5" then

											else
												Remote1 = v
												Remote15 = string.split(Remote1, "/")[1]
												DebugCheck(0,"Remote15:",Remote15)

											end
										end
									end

									if i == 3 then
										if type(v) == "string" then
											if getrem(v) then

												Remote2 = v
												dump2 = Remote2
											end
										end
									end
								end

							end
						end

						local FinishRemote

						local function getrem(p9)
							rem = ""
							for i,v in pairs(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"]:GetChildren()) do
								if v.Name:match(p9) then
									rem = v
								end
							end
							return rem.Name
						end

						for i,v222 in pairs(getgc(true)) do
							if type(v222) == "function" and getinfo(v222).name == "handleGameOver" and getfenv(v222).script == game:GetService("Players").LocalPlayer.PlayerScripts.TS.flame.controllers.fishing["fishing-controller"] then


								for i,v in pairs(getconstants(v222)) do

									if type(v) == "string" then

										if getrem(v) then
											if i == 2 then
												DebugCheck(0,"FINISH: ",v)
												dump1 = v
												DebugCheck(0,Remote15)
												WerfRemote = Remote2.."/"..Remote15
												DebugCheck(0,"FNISH2:",WerfRemote)
											end
										end

									end

								end

							end
						end
						--[[

								if FinishRemote then
									UpdateRemote("FishFarmFinishRemote", FinishRemote)
									DebugCheck(0,"FishFarmFinishRemote", FinishRemote)
								else
									game.Players.LocalPlayer:Kick("cant get FinishRemote!")
								end
								if FinishRemote then
									UpdateRemote("AngelRemote", Remote1)
									DebugCheck(0,"AngelRemote", Remote1)
								else
									game.Players.LocalPlayer:Kick("cant get AngelRemote!")
								end

						]]
					end
				end

				local Finishremote = dump2.."/"..dump1

				DebugCheck(0,"FinishRemote:",Finishremote)

				if WerfRemote then
					DebugCheck(0,"WerfRemote:",WerfRemote)
				end

				UpdateRemote("FishFarmFinishRemote", Finishremote) -- 2
				SendNotification("[SECURITY]", "Check 1/42 Done!")
				UpdateRemote("AngelRemote", WerfRemote) -- 2
				SendNotification("[SECURITY]", "Check 2/42 Done!")

				CreateFile("/Hash System/FishFarmFinishRemote", Finishremote, false)
				SendNotification("[SECURITY]", "Check 3/42 Done!")
				CreateFile("/Hash System/AngelRemote", WerfRemote, false)
				SendNotification("[SECURITY]", "Check 4/42 Done!")
				Tool.Parent = game.Players.LocalPlayer.Backpack
				Tool:Destroy()

			end



			-- UpdateFish()

			task.spawn(function()
				UpdateFish()
				task.wait()
			end)

			function Updateinv(v)
				if v:FindFirstChild("sword") then
					if _G.KillRemoteHash == nil or _G.KillRemoteHash == "" or _G.KillRemoteHash == " " then
						UpdateMob()
						task.wait()
						UpdateRemote("KillRemote", mobRemoteName) -- 2
						SendNotification("[SECURITY]", "Check 5/42 Done!")
						UpdateRemote("KillRemoteHashName", MOBLEFT) -- 2
						SendNotification("[SECURITY]", "Check 6/42 Done!")
						_G.KillRemoteHash = MOBRIGHT
						SendNotification("[SECURITY]", "Check 7/42 Done!")
					end
				end
			end

			game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(v)
				Updateinv(v)
			end)

			game.Players.LocalPlayer.Backpack.ChildRemoved:Connect(function(v)
				Updateinv(v)
			end)

			print("mobRemoteName:",mobRemoteName)

			UpdateRemote("KillRemote", mobRemoteName) -- 2
			SendNotification("[SECURITY]", "Check 8/42 Done!")
			UpdateRemote("KillRemoteHashName", MOBLEFT) -- 2
			SendNotification("[SECURITY]", "Check 9/42 Done!")
			_G.KillRemoteHash = MOBRIGHT

			print("Debug 1")

			task.wait()

			CreateFile("/Hash System/KillRemote", mobRemoteName, false)
			SendNotification("[SECURITY]", "Check 10/42 Done!")
			CreateFile("/Hash System/KillRemoteHashName", MOBLEFT, false)
			SendNotification("[SECURITY]", "Check 11/42 Done!")
			CreateFile("/Hash System/KillRemoteHash", MOBRIGHT or _G.KillRemoteHash, false)
			SendNotification("[SECURITY]", "Check 12/42 Done!")

			print("Debug 2")


			local ToolLEFT
			local TOOLRIGHT 
			function UpdatePickUpTool()
				for i,v in pairs(getgc(true)) do
					if type(v) == "function" and getinfo(v).name == "pickupTool" then
						ToolLEFT = getconstants(v)[23]
						TOOLRIGHT = getconstants(v)[25]..getconstants(v)[26]
					end
				end
			end
			task.spawn(function()
				UpdatePickUpTool()
			end)

			print("Debug 3")

			UpdateRemote("TOOL_PICKUPHashData", ToolLEFT) -- 2
			SendNotification("[SECURITY]", "Check 13/42 Done!")
			_G.TOOL_PICKUPHash = TOOLRIGHT
			SendNotification("[SECURITY]", "Check 14/42 Done!")

			CreateFile("/Hash System/TOOL_PICKUPHashData", ToolLEFT, false)
			SendNotification("[SECURITY]", "Check 15/42 Done!")
			CreateFile("/Hash System/TOOL_PICKUPHash", TOOLRIGHT, false)
			SendNotification("[SECURITY]", "Check 16/42 Done!")

			print("Debug 4")

			local CROPleft
			local CROPright
			function CropUpdate()
				remleft = ""
				remright = ""
				for i,v in pairs(getgc(true)) do
					if type(v) == "function" and getinfo(v).name == "breakCrop" and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.TS.block.crop["crop-service"] then
						for i2,v2 in pairs(getprotos(v)) do

							for i,v in pairs(getconstants(v)) do

								if i == 22 then
									remleft = v 
								end 

								if i == 26 then
									remright = v 
								end


								if i == 27 then
									remright = remright..v
								end


							end
						end
					end
				end    
				if remleft and remright then
					CROPleft = remleft
					CROPright = remright
				else
					game.Players.LocalPlayer:Kick("Error: NCD1")
				end
			end
			task.spawn(function()
				CropUpdate()
			end)

			print("Debug 5")

			local HITleft
			local HITright
			function HitUpdate()
				remright2 = ""
				remleft = ""
				remright = ""
				for i,v in pairs(getgc(true)) do
					if type(v) == "function" and getinfo(v).name == "onBlockHit" then
						for i2,v2 in pairs(getprotos(v)) do
							if table.find(getconstants(v2), "Get") then
								for i3,v3 in pairs(getconstants(v2)) do
									remleft = getconstants(v2)[8]
									remright2 = getconstants(v2)[11]
									remright = getconstants(v2)[10]
								end
							end
						end
					end
				end

				HITleft = remleft
				HITright = remright..remright2
			end
			task.spawn(function()
				HitUpdate()
			end)

			task.wait(0.2)

			print("Debug 6")

			UpdateRemote("CropHashData", CROPleft) -- 2
			SendNotification("[SECURITY]", "Check 17/42 Done!")
			_G.CropHash = CROPright
			SendNotification("[SECURITY]", "Check 18/42 Done!")


			UpdateRemote("TreeHashData", HITleft) -- 2
			SendNotification("[SECURITY]", "Check 19/42 Done!")
			_G.TreeHash = HITright
			SendNotification("[SECURITY]", "Check 20/42 Done!")
			UpdateRemote("BlockHitHashData", HITleft) -- 2
			SendNotification("[SECURITY]", "Check 21/42 Done!")
			_G.BlockHitHash = HITright
			SendNotification("[SECURITY]", "Check 22/42 Done!")

			CreateFile("/Hash System/CropHashData", CROPleft, false)
			SendNotification("[SECURITY]", "Check 23/42 Done!")
			CreateFile("/Hash System/CropHash", CROPright, false)
			SendNotification("[SECURITY]", "Check 24/42 Done!")

			print("Debug 7")

			CreateFile("/Hash System/TreeHashData", HITleft, false)
			SendNotification("[SECURITY]", "Check 25/42 Done!")
			CreateFile("/Hash System/TreeHash", HITright, false)
			SendNotification("[SECURITY]", "Check 26/42 Done!")
			CreateFile("/Hash System/BlockHitHashData", HITleft, false)
			SendNotification("[SECURITY]", "Check 27/42 Done!")
			CreateFile("/Hash System/BlockHitHash", HITright, false)
			SendNotification("[SECURITY]", "Check 28/42 Done!")

			print("Debug 8")


			local BlockRight1
			local BlockRight
			local BlockLeft
			function UpdatePlaceBlocks()


				for i,v in pairs(getgc(true)) do
					if type(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.TS.flame.controllers.block["block-controller"] then

						for dddi,dddv in pairs(getconstants(v)) do

							if tonumber(dddi) == 23 then
								BlockLeft = dddv
							end
							if tonumber(dddi) == 25 then
								BlockLeft1 = dddv
							end
							if tonumber(dddi) == 26 then
								BlockRight = BlockLeft1..dddv
							end
						end
					end
				end

			end
			UpdatePlaceBlocks()

			print("Debug 9")

			function GetNet()
				local A1
				local A2

				for i,v in pairs(getgc(true)) do
					if type(v) == "function" and getinfo(v).name == "constructor" and getfenv(v).script == game:GetService("Workspace").ANTICATBYASHO.net.net then

						for i2,v2 in pairs(getprotos(v)) do

							A1 = getconstants(v2)[16]

							A2 = getconstants(v2)[13]

							for i,v in pairs(getconstants(v2)) do
								DebugCheck(0,i,v, " | type:", type(v)) 
							end


						end
					end
				end

				DebugCheck(0,A1)
				DebugCheck(0,A2)
			end

			print("Debug 10")

			UpdateRemote("FlowerCollect", "client_request_1") -- 1
			SendNotification("[SECURITY]", "Check 29/42 Done!")
			UpdateRemote("PetCollect", "CLIENT_PET_ANIMAL")
			SendNotification("[SECURITY]", "Check 30/42 Done!")
			UpdateRemote("BlockRemote", "CLIENT_BLOCK_HIT_REQUEST")
			SendNotification("[SECURITY]", "Check 31/42 Done!")
			-- UpdateRemote("SendMailRemote", "NINGI(HUINUH(UIN(IH(HUUI")
			SendNotification("[SECURITY]", "Check 32/42 Done!")
			UpdateRemote("SpiritRemote", "gecqaLhbvAbyjo/qDgqEvuQzyryuBnlzh")
			SendNotification("[SECURITY]", "Check 33/42 Done!")

			print("BlockLeft:",BlockLeft)

			UpdateRemote("CropPlaceHashData", BlockLeft) -- 2
			SendNotification("[SECURITY]", "Check 34/42 Done!")
			_G.CropPlaceHash = BlockRight -- 2
			SendNotification("[SECURITY]", "Check 35/42 Done!")
			_G.CropPlaceH1 = BlockLeft
			SendNotification("[SECURITY]", "Check 36/42 Done!")
			UpdateRemote("BlockPlaceHashData", BlockLeft) -- 2
			SendNotification("[SECURITY]", "Check 37/42 Done!")
			_G.BlockPlaceHash = BlockRight -- 2
			SendNotification("[SECURITY]", "Check 38/42 Done!")

			print("Debug 11")

			CreateFile("/Hash System/CropPlaceHashData", BlockLeft, false)
			SendNotification("[SECURITY]", "Check 39/42 Done!")
			CreateFile("/Hash System/CropPlaceHash", BlockRight, false)
			SendNotification("[SECURITY]", "Check 40/42 Done!")
			CreateFile("/Hash System/BlockPlaceHashData", BlockLeft, false)
			SendNotification("[SECURITY]", "Check 41/42 Done!")
			CreateFile("/Hash System/BlockPlaceHash", BlockRight, false)
			SendNotification("[SECURITY]", "Check 42/42 Done!")
		end
		Update()
	end
end

SendNotification("[SECURITY]", "Scanning Game...")

Remotes()

function FixInv()
	for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		v.Parent = game.Players.LocalPlayer.Character
		task.wait()
		v.Parent = game.Players.LocalPlayer.Backpack
		task.wait()
	end
end

local RemoteData = game:WaitForChild("_REMOTES_NEKO_")


_G.Island_USERID = game.Players.LocalPlayer.UserId

local CANUSEAUTOCLICKER = true



local MotHitH1 = RemoteData:FindFirstChild("KillRemoteHashName").Value
local MotHitH2 = _G.KillRemoteHash 

local CropPlaceH1 = RemoteData:FindFirstChild("CropPlaceHashData").Value
local CropPlaceH2 = _G.CropPlaceHash

local PickupH1 = RemoteData:FindFirstChild("TOOL_PICKUPHashData").Value
local PickupH2 = _G.TOOL_PICKUPHash

local PlaceHASHName = RemoteData:FindFirstChild("BlockPlaceHashData").Value
local PlaceHASH = _G.BlockPlaceHash

local HitHASHName = RemoteData:FindFirstChild("BlockHitHashData").Value
local HitHASH = _G.BlockHitHash


local MAINSCRIPTHANDLER

local LASTTWEEN = nil

-- CROP TEST --

local SichleAuraCooldown = false 
local SichleFarmCooldown = false
local CROPTWEEN22


-- Tables --
local SettingsTable = {

	-- Tween Fly -- 

	Twennnoclip = true,
	TweenFly = true,
	TweenFast = true,

	-- Player --

	PlayerFly = false,