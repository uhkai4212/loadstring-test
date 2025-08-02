local plr = game.Players.LocalPlayer
            
                            plr:GetMouse().KeyDown:Connect(function(K)
                                if K == "p" then
                                    Animations.Visible = false
                                end
                            end)
            end)
            
            sector11:AddButton("No Fog", function()
            while true do
                            wait()
                            game.Lighting.FogEnd = 1000000
                            wait()
                            end
            end)
            
            sector11:AddButton("Rejoin", function()
             local tpservice= game:GetService("TeleportService")
                        local plr = game.Players.LocalPlayer
            
                        tpservice:Teleport(game.PlaceId, plr)
            end)

            sector11:AddButton("Chat Spy", function()
                -- // Initialise
          --if (getgenv().ChatSpy) then return getgenv().ChatSpy; end;
          repeat wait() until game:GetService("ContentProvider").RequestQueueSize == 0;
          repeat wait() until game:IsLoaded();
  
          -- // Vars
          local Players = game:GetService("Players");
          local StarterGui = game:GetService("StarterGui");
          local ReplicatedStorage = game:GetService("ReplicatedStorage");
          local LocalPlayer = Players.LocalPlayer;
          local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
          local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents");
          local SayMessageRequest = DefaultChatSystemChatEvents:WaitForChild("SayMessageRequest");
          local OnMessageDoneFiltering = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering");
          getgenv().ChatSpy = {
              Enabled = true,
              SpyOnSelf = true,
              Public = false,
              Chat = {
                  Colour  = Color3.fromRGB(255, 0, 0),
                  Font = Enum.Font.SourceSans,
                  TextSize = 18,
                  Text = "",
              },
              IgnoreList = {
                  {Message = ":part/1/1/1", ExactMatch = true},
                  {Message = ":part/10/10/10", ExactMatch = true},
                  {Message = "A?????????", ExactMatch = false},
                  {Message = ":colorshifttop 10000 0 0", ExactMatch = true},
                  {Message = ":colorshiftbottom 10000 0 0", ExactMatch = true},
                  {Message = ":colorshifttop 0 10000 0", ExactMatch = true},
                  {Message = ":colorshiftbottom 0 10000 0", ExactMatch = true},
                  {Message = ":colorshifttop 0 0 10000", ExactMatch = true},
                  {Message = ":colorshiftbottom 0 0 10000", ExactMatch = true},
              },
          };
  
          -- // Function
          function ChatSpy.checkIgnored(message)
              for i = 1, #ChatSpy.IgnoreList do
                  local v = ChatSpy.IgnoreList[i];
                  if (v.ExactMatch and message == v.Message) or (not v.ExactMatch and string.match(v.Message, message)) then
                      return true;
                  end;
              end;
              return false;
          end;
  
          function ChatSpy.onChatted(targetPlayer, message)
              if (targetPlayer == LocalPlayer and string.lower(message):sub(1, 4) == "/spy") then
                  ChatSpy.Enabled = not ChatSpy.Enabled; wait(0.3);
                  ChatSpy.Chat.Text = "[SPY] - "..(ChatSpy.Enabled and "Enabled." or "Disabled.");
  
                  StarterGui:SetCore("ChatMakeSystemMessage", ChatSpy.Chat);
              elseif (ChatSpy.Enabled and (ChatSpy.SpyOnSelf or targetPlayer ~= LocalPlayer)) then
                  local message = message:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ');
  
                  local Hidden = true;
                  local Connection = OnMessageDoneFiltering.OnClientEvent:Connect(function(packet, channel)
                      if (packet.SpeakerUserId == targetPlayer.UserId and packet.Message == message:sub(#message - #packet.Message + 1) and (channel == "All" or (channel == "Team" and not ChatSpy.Public and Players[packet.FromSpeaker].Team == LocalPlayer.Team))) then
                          Hidden = false;
                      end;
                  end);
  
                  wait(1);
                  Connection:Disconnect();
  
                  if (Hidden and ChatSpy.Enabled and not ChatSpy.checkIgnored(message)) then
                      if (#message > 1200) then
                          message = message:sub(1200) .. "...";
                      end;
                      ChatSpy.Chat.Text = "[SPY] - ["..targetPlayer.Name.."]: " .. message;
                      if (ChatSpy.Public) then SayMessageRequest:FireServer(ChatSpy.Chat.Text, "All"); else StarterGui:SetCore("ChatMakeSystemMessage", ChatSpy.Chat); end;
                  end;
              end;
          end;
  
          -- // Handling Chats
          local AllPlayers = Players:GetPlayers();
          for i = 1, #AllPlayers do
              local player = AllPlayers[i];
              player.Chatted:Connect(function(message)
                  ChatSpy.onChatted(player, message);
              end);
          end;
  
          Players.PlayerAdded:Connect(function(player)
              player.Chatted:Connect(function(message)
                  ChatSpy.onChatted(player, message);
              end);
          end);
  
          -- // Initialise Text
          ChatSpy.Chat.Text = "[SPY] - "..(ChatSpy.Enabled and "Enabled." or "Disabled.");
          StarterGui:SetCore("ChatMakeSystemMessage", ChatSpy.Chat);
  
          -- // Update Chat Frame
          local chatFrame = LocalPlayer.PlayerGui.Chat.Frame;
          chatFrame.ChatChannelParentFrame.Visible = true;
          chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), chatFrame.ChatChannelParentFrame.Size.Y);
          end)
      
      sector11:AddButton("Speed Glitch (X)", function()
          local Player = game:GetService("Players").LocalPlayer
              local Mouse = Player:GetMouse()
              local SpeedGlitch = false
              local Wallet = Player.Backpack:FindFirstChild("Wallet")
  
              local UniversalAnimation = Instance.new("Animation")
  
              function stopTracks()
                  for _, v in next, game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks() do
                      if (v.Animation.AnimationId:match("rbxassetid")) then
                          v:Stop()
                      end
                  end
              end
  
              function loadAnimation(id)
                  if UniversalAnimation.AnimationId == id then
                      stopTracks()
                      UniversalAnimation.AnimationId = "1"
                  else
                      UniversalAnimation.AnimationId = id
                      local animationTrack = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(UniversalAnimation)
                      animationTrack:Play()
                  end
              end
  
              Mouse.KeyDown:Connect(function(Key)
                  if Key == "x" then
                      SpeedGlitch = not SpeedGlitch
                      if SpeedGlitch == true then
                          stopTracks()
                          loadAnimation("rbxassetid://3189777795")
                          wait(1.5)
                          Wallet.Parent = Player.Character
                          wait(0.15)
                          Player.Character:FindFirstChild("Wallet").Parent = Player.Backpack
                          wait(0.05)
                          repeat game:GetService("RunService").Heartbeat:wait()
                              keypress(0x49)
                              game:GetService("RunService").Heartbeat:wait()
                              keypress(0x4F)
                              game:GetService("RunService").Heartbeat:wait()
                              keyrelease(0x49)
                              game:GetService("RunService").Heartbeat:wait()
                              keyrelease(0x4F)
                              game:GetService("RunService").Heartbeat:wait()
                          until SpeedGlitch == false
                      end
                  end
              end)
      end)
      






    local sector12 = Misctablolxdrawruwu:CreateSector("Others (2)", "left")


sector12:AddButton("Anti Slow", function(L_178_arg0)
antislow = L_175_arg0
	repeat
		wait(0.1)
		local L_176_ = game.Players.LocalPlayer
		local L_177_ = L_176_.Character.BodyEffects.Movement:FindFirstChild('NoJumping') or L_176_.Character.BodyEffects.Movement:FindFirstChild('ReduceWalk') or L_176_.Character.BodyEffects.Movement:FindFirstChild('NoWalkSpeed')
		if L_177_ then
			L_177_:Destroy()
		end
		if L_176_.Character.BodyEffects.Reload.Value == true then
			L_176_.Character.BodyEffects.Reload.Value = false
		end
	until antislow == false
end)

sector12:AddButton("Trashtalk (J)", function(L_178_arg0)
   local plr = game.Players.LocalPlayer
                repeat wait() until plr.Character
                local char = plr.Character

                local garbage = {
                "ur bad";
                "nice try bud";
                "ez";
                "my grandma has more skill than you";
                "gun user";
                "bunny hopper";
                "trash";
                "LOL";
                "LMAO";
                "imagine being you right now";
                "xd";
                "you smell";
                "ur bad";
                "why do you even try";
                "I didn't think being this bad was possible";
                "leave";
                "no skill";
                "you thought";
                "bad";
                "you're nothing";
                "lol";
                "so trash";
                "dog water";
                "ur salty";
                "salty";
                "ur mad son";
                "cry more";
                "keep crying";
                "cry baby";
                "hahaha I won";
                "no one likes u";
                "darn";
                "thank you for your time";
                "you were so close!";
                "better luck next time!";
                "rodent";
                "ur so bad ur my seed";
                "/e dab";
                "/e dab";
                "time to take out the trash";
                "did you get worse?";
                "I'm surprised you haven't quit yet";
                "sonned";
                 "lightwork";
            }
                function TrashTalk(inputObject, gameProcessedEvent)
                 if inputObject.KeyCode == Enum.KeyCode.J and gameProcessedEvent == false then
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                garbage[math.random(1,#garbage)],
                "All"
                )
                     end
                end
                game:GetService("UserInputService").InputBegan:connect(TrashTalk)
                end)


sector12:AddButton("Infinite Zoom",false,function()
game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = math.huge
end)




    sector12:AddButton("CFrame Speed (N)", function()
	repeat
		wait()
	until game:IsLoaded()
	local L_134_ = game:service('Players')
	local L_135_ = L_134_.LocalPlayer
	repeat
		wait()
	until L_135_.Character
	local L_136_ = game:service('UserInputService')
	local L_137_ = game:service('RunService')
	getgenv().Multiplier = 0.5
	local L_138_ = true
	local L_139_
	L_136_.InputBegan:connect(function(L_140_arg0)
		if L_140_arg0.KeyCode == Enum.KeyCode.LeftBracket then
			Multiplier = Multiplier + 0.01
			print(Multiplier)
			wait(0.2)
			while L_136_:IsKeyDown(Enum.KeyCode.LeftBracket) do
				wait()
				Multiplier = Multiplier + 0.01
				print(Multiplier)
			end
		end
		if L_140_arg0.KeyCode == Enum.KeyCode.RightBracket then
			Multiplier = Multiplier - 0.01
			print(Multiplier)
			wait(0.2)
			while L_136_:IsKeyDown(Enum.KeyCode.RightBracket) do
				wait()
				Multiplier = Multiplier - 0.01
				print(Multiplier)
			end
		end
		if L_140_arg0.KeyCode == Enum.KeyCode.N then
			L_138_ = not L_138_
			if L_138_ == true then
				repeat
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * Multiplier
					game:GetService("RunService").Stepped:wait()
				until L_138_ == false
			end
		end
	end)
end)   

 sector12:AddTextbox("CFrame Speed", "", function(L_142_arg0)
	getgenv().Multiplier = L_142_arg0
    end)
    
    








     local sector17 = Misctablolxdrawruwu:CreateSector("Misc Main", "right")
    
            sector17:AddButton("Fly (X)", function()
                local plr = game.Players.LocalPlayer
                local mouse = plr:GetMouse()
                
                localplayer = plr
                
                if workspace:FindFirstChild("Core") then
                workspace.Core:Destroy()
                end
                
                local Core = Instance.new("Part")
                Core.Name = "Core"
                Core.Size = Vector3.new(0.05, 0.05, 0.05)
                
                spawn(function()
                Core.Parent = workspace
                local Weld = Instance.new("Weld", Core)
                Weld.Part0 = Core
                Weld.Part1 = localplayer.Character.LowerTorso
                Weld.C0 = CFrame.new(0, 0, 0)
                end)
                
                workspace:WaitForChild("Core")
                
                local torso = workspace.Core
                flying = true
                local speed=10
                local keys={a=false,d=false,w=false,s=false}
                local e1
                local e2
                local function start()
                local pos = Instance.new("BodyPosition",torso)
                local gyro = Instance.new("BodyGyro",torso)
                pos.Name="EPIXPOS"
                pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
                pos.position = torso.Position
                gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                gyro.cframe = torso.CFrame
                repeat
                wait()
                localplayer.Character.Humanoid.PlatformStand=true
                local new=gyro.cframe - gyro.cframe.p + pos.position
                if not keys.w and not keys.s and not keys.a and not keys.d then
                speed=5
                end
                if keys.w then
                new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed=speed+0
                end
                if keys.s then
                new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed=speed+0
                end
                if keys.d then
                new = new * CFrame.new(speed,0,0)
                speed=speed+0
                end
                if keys.a then
                new = new * CFrame.new(-speed,0,0)
                speed=speed+0
                end
                if speed>10 then
                speed=5
                end
                pos.position=new.p
                if keys.w then
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*0),0,0)
                elseif keys.s then
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*0),0,0)
                else
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame
                end
                until flying == false
                if gyro then gyro:Destroy() end
                if pos then pos:Destroy() end
                flying=false
                localplayer.Character.Humanoid.PlatformStand=false
                speed=10
                end
                e1=mouse.KeyDown:connect(function(key)
                if not torso or not torso.Parent then flying=false e1:disconnect() e2:disconnect() return end
                if key=="w" then
                keys.w=true
                elseif key=="s" then
                keys.s=true
                elseif key=="a" then
                keys.a=true
                elseif key=="d" then
                keys.d=true
                elseif key=="x" then
                if flying==true then
                flying=false
                else
                flying=true
                start()
                end
                end
                end)
                e2=mouse.KeyUp:connect(function(key)
                if key=="w" then
                keys.w=false
                elseif key=="s" then
                keys.s=false
                elseif key=="a" then
                keys.a=false
                elseif key=="d" then
                keys.d=false
                end
                end)
                start()
            end)
    
            sector17:AddButton("Real Macro (B)", function()
                local Player = game:GetService("Players").LocalPlayer
                local Mouse = Player:GetMouse()
                local SpeedGlitch = false
                local Wallet = Player.Backpack:FindFirstChild("Wallet")
     
                local UniversalAnimation = Instance.new("Animation")
     
                function stopTracks()
                    for _, v in next, game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks() do
                        if (v.Animation.AnimationId:match("rbxassetid")) then
                            v:Stop()
                        end
                    end
                end
     
                function loadAnimation(id)
                    if UniversalAnimation.AnimationId == id then
                        stopTracks()
                        UniversalAnimation.AnimationId = "1"
                    else
                        UniversalAnimation.AnimationId = id
                        local animationTrack = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(UniversalAnimation)
                        animationTrack:Play()
                    end
                end
     
                Mouse.KeyDown:Connect(function(Key)
                    if Key == "b" then
                        SpeedGlitch = not SpeedGlitch
                        if SpeedGlitch == true then
                            loadAnimation("rbxassetid://3189777795")
                            wait(1.5)
                            Wallet.Parent = Player.Character
                            wait(0.15)
                            Player.Character:FindFirstChild("Wallet").Parent = Player.Backpack
                            wait(0.05)
                            repeat game:GetService("RunService").Heartbeat:wait()
                                keypress(0x49)
                                game:GetService("RunService").Heartbeat:wait()
                                keypress(0x4F)
                                game:GetService("RunService").Heartbeat:wait()
                                keyrelease(0x49)
                                game:GetService("RunService").Heartbeat:wait()
                                keyrelease(0x4F)
                                game:GetService("RunService").Heartbeat:wait()
                            until SpeedGlitch == false
                        end
                    end
                end)
            end)

    
    
            sector17:AddButton("Fake macro (Z)", function()
                superhuman = false
                plr = game.Players.LocalPlayer
                mouse = plr:GetMouse()
                mouse.KeyDown:connect(function(key)
                    if key == "z" and superhuman == false then
                        superhuman = true
                        game.Players.LocalPlayer.Character.Humanoid.Name = "Humz"
                        game.Players.LocalPlayer.Character.Humz.WalkSpeed = 150
                        game.Players.LocalPlayer.Character.Humz.JumpPower = 50
                    elseif key == "z" and superhuman == true then
                        superhuman = false
                        game.Players.LocalPlayer.Character.Humz.WalkSpeed = 16
                        game.Players.LocalPlayer.Character.Humz.JumpPower = 50
                        game.Players.LocalPlayer.Character.Humz.Name = "Humanoid"
                    end
                end)
            end)
    
            sector17:AddButton('Normal Fov', function()
                workspace.CurrentCamera.FieldOfView = 70
            end)
            
            sector17:AddButton('Pro Fov', function()
                workspace.CurrentCamera.FieldOfView = 120
            end)
             
            local Fov = sector17:AddSlider("Fov Slider", 70, 0, 120, 5, function(value) 
                game:GetService'Workspace'.Camera.FieldOfView = value
            end)
            
            
            
            local sector18 = Misctablolxdrawruwu:CreateSector("Client Sided Character", "right")
    
            sector18:AddButton("Korblox", function()
                local ply = game.Players.LocalPlayer
                local chr = ply.Character
                chr.RightLowerLeg.MeshId = "902942093"
                chr.RightLowerLeg.Transparency = "1"
                chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
                chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
                chr.RightFoot.MeshId = "902942089"
                chr.RightFoot.Transparency = "1"
            end)
    
            sector18:AddButton("Headless", function()
                game.Players.LocalPlayer.Character.Head.Transparency = 1
                for i,v in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
                if (v:IsA("Decal")) then
                v:Destroy()
                end
                end
            end)
            
            local sector19 = Misctablolxdrawruwu:CreateSector("Client Sided Faces", "right")
            
            sector19:AddButton("Super Super Happy Face", function()
                game.Players.LocalPlayer.Character.Head.face.Texture = "rbxassetid://7150793967"
            end)
    
            sector19:AddButton("Yum!", function()
                game.Players.LocalPlayer.Character.Head.face.Texture = "rbxassetid://720921501"
            end)
    
           
    
            sector19:AddButton("Beast Mode", function()
                game.Players.LocalPlayer.Character.Head.face.Texture = "rbxassetid://265790768"
            end)
    
            sector19:AddButton("Playful Vampire", function()
                game.Players.LocalPlayer.Character.Head.face.Texture = "rbxassetid://6982506164"
            end)
            
             local AimingTab = Window:CreateTab("Made By Wuss")