local ui = loadstring(game:HttpGet("https://pastebin.com/raw/wk7ZrGyr"))()

local win = ui:Create({
    Name = "Celeron's GUI (Azure Latch)",
    ThemeColor = Color3.fromRGB(100, 85, 174),
    StartupSound = "rbxassetid://6958727243",
    ThemeFont = Enum.Font.FredokaOne
})

local maintab = win:Tab("Blatant")
local maintab2 = win:Tab("Silent")
local funtab = win:Tab("Movesets")
local emotetab = win:Tab("Emotes")
local teleporttab = win:Tab("Teleports")
local misctab = win:Tab("Others")
local helptab = win:Tab("Info")

maintab:Label("Script Made By Celeron + Daffy!")
maintab2:Label("Set The Auto-Counter Number To Your Character's Counter Move!")
funtab:Label("Custom Movesets, Not Actual Unlocks!")
emotetab:Label("The Sounds Are Client Sided, The Emotes Are Visible!")
teleporttab:Label("Map Teleports, No Prerequisites To Use!")
misctab:Label("Miscellaneous Features, They Give No Advantages In-Game!")
helptab:Label("GUI Controls Are Below, Script Credits Are At The Bottom!")
helptab:Label("Show / Hide GUI: Right Alt")

helptab:Button("Show Keybinds", function()
    local StarterGui = game:GetService("StarterGui")

    StarterGui:SetCore("SendNotification", {
        Title = "Keybinds",
        Text = "Z = Auto-Dribble\nX = Move One\nC = Move Two\nV = Move Three",
        Duration = 4
    })

    task.delay(0.5, function()
        StarterGui:SetCore("SendNotification", {
            Title = "Keybinds",
            Text = "N = Move Four\nM = Move Five",
            Duration = 4
        })
    end)
end)

_G._rushingSoundPlaying = false
_G._rushing = false
_G._sideDashing = false

maintab:Button("Metavision", function()
loadstring(game:HttpGet("https://pastebin.com/raw/FVgs7bQw"))()
end)

maintab:Button("Auto-Goal", function()
    _G.AUTO_GOAL = not _G.AUTO_GOAL
    if _G.AUTO_GOAL then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Farm Goals",
            Text = "Activated!",
            Duration = 5
        })
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MapFolder = workspace:WaitForChild("map")
local AGoal = MapFolder:WaitForChild("Agoal")
local BGoal = MapFolder:WaitForChild("Bgoal")

local LocalPlayer = Players.LocalPlayer

local function IsInGame()
    local LocalCharacter = LocalPlayer.Character
    if not LocalCharacter then return false end

    local StateFolder = LocalCharacter:FindFirstChild("state")
    if not StateFolder then return false end

    local InGameValue = StateFolder:FindFirstChild("ingame")
    if not InGameValue then return false end

    return InGameValue.Value
end

local function DisableCollisionBoxes()
    local MapFolder = workspace:FindFirstChild("map")
    if not MapFolder then return end

    local GkBarriar = MapFolder:FindFirstChild("gkbarriar")
    local AGoal = MapFolder:FindFirstChild("Agoal")
    local BGoal = MapFolder:FindFirstChild("Bgoal")

    if GkBarriar then
        local ABarriar = GkBarriar:FindFirstChild("A")
        local BBarriar = GkBarriar:FindFirstChild("B")

        if ABarriar then ABarriar.CanCollide = false end
        if BBarriar then BBarriar.CanCollide = false end
    end

    if AGoal then AGoal.CanCollide = false end
    if BGoal then BGoal.CanCollide = false end
end

local function StealBall()
    local LocalCharacter = LocalPlayer.Character
    local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
    local Football = workspace.Terrain:FindFirstChild("Ball")

    if LocalHumanoidRootPart and Football then
        LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position.X, 0, Football.Position.Z)
    end
    
    for _, OtherPlayer in pairs(Players:GetPlayers()) do
        if OtherPlayer ~= LocalPlayer then
            local OtherCharacter = OtherPlayer.Character
            local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Ball")
            local OtherHumanoidRootPart = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")

            if OtherFootball and OtherHumanoidRootPart and LocalHumanoidRootPart then
                LocalHumanoidRootPart.CFrame = OtherFootball.CFrame

                local args = {
                    buffer.fromstring("\b\001"),
                    {
                        { "tackle" }
                    }
                }

                ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
            end
        end
    end
end

local function HasBall()
    local LocalCharacter = LocalPlayer.Character
    local Football = LocalCharacter and LocalCharacter:FindFirstChild("Ball")
    return Football ~= nil
end

coroutine.resume(coroutine.create(function()
    RunService.RenderStepped:Connect(function()
        if not _G.AUTO_GOAL then return end
        pcall(function()
            if not IsInGame() then return end
            DisableCollisionBoxes()
            StealBall()
            if HasBall() then
                local LocalCharacter = LocalPlayer.Character
                local LocalRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
                local Goal = LocalPlayer.Team.Name == "A" and BGoal or AGoal

                if LocalRootPart and Goal then
                    LocalRootPart.CFrame = Goal.CFrame

                    local args = {
                        buffer.fromstring("\b\001"),
                        {
                            { "tackle" }
                        }
                    }

                    ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
                end
            end
        end)
    end)
end))
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Farm Goals",
            Text = "Deactivated!",
            Duration = 5
        })
    end
end)

maintab:Button("Always Ball", function()
_G.ALWAYS_BALL_ACTIVE = not _G.ALWAYS_BALL_ACTIVE
if _G.ALWAYS_BALL_ACTIVE then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Always Ball",
        Text = "Activated!",
        Duration = 5
    })

    workspace.Gravity = 0

    spawn(function()
        while _G.ALWAYS_BALL_ACTIVE do
            local LocalPlayer = game.Players.LocalPlayer
            local LocalCharacter = LocalPlayer.Character
            local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
            local Football = workspace.Terrain:FindFirstChild("Ball")
            
            if LocalHumanoidRootPart and Football then
                LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position)
            end

            for _, OtherPlayer in pairs(game.Players:GetPlayers()) do
                if OtherPlayer ~= LocalPlayer then
                    local OtherCharacter = OtherPlayer.Character
                    local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Ball")
                    local OtherHumanoidRootPart = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")

                    if OtherFootball and OtherHumanoidRootPart and LocalHumanoidRootPart then
                        LocalHumanoidRootPart.CFrame = OtherFootball.CFrame

                        local args = {
                            buffer.fromstring("\b\001"),
                            {
                                { "tackle" }
                            }
                        }

                        game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))
                    end
                end
            end
            
            task.wait(0.1)
        end
    end)
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Always Ball",
        Text = "Deactivated!",
        Duration = 5
    })

    workspace.Gravity = 196.2
end
end)

maintab:Button("Get Flow (Enable Header, Req. Ball)", function()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local virtualInputManager = game:GetService("VirtualInputManager")

if humanoidRootPart then
    local originalPosition = humanoidRootPart.Position
    humanoidRootPart.CFrame = CFrame.new(Vector3.new(-390, 475, 354))
	task.wait(0.3)
    virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.1)
    virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
	workspace.Gravity = 0

	spawn(function()
    local startTime = tick()

    while tick() - startTime < 20 do
        local LocalCharacter = game.Players.LocalPlayer.Character
        local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
        local Football = workspace.Terrain:FindFirstChild("Ball")
        
        if LocalHumanoidRootPart and Football then
            LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position.X, Football.Position.Y, Football.Position.Z)
        end

        for _, OtherPlayer in pairs(game.Players:GetPlayers()) do
            if OtherPlayer.Name ~= game.Players.LocalPlayer.Name then
                local OtherCharacter = OtherPlayer.Character
                local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Ball")
                local OtherHumanoidRootPart = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")

                if OtherFootball and OtherHumanoidRootPart and LocalHumanoidRootPart then
                    LocalHumanoidRootPart.CFrame = OtherFootball.CFrame
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                end
            end
        end
        
        task.wait(0.1)
    end
    workspace.Gravity = 196.2
	end)
    humanoidRootPart.CFrame = CFrame.new(originalPosition)
end
end)

maintab2:Button("Bind Magnet (M2 BIND)", function()
local userInputService = game:GetService("UserInputService")
local remote = game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable")

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        remote:FireServer(buffer.fromstring("\016"))
    end
end)
end)

maintab2:Textbox("Ball Magnet", function(v)
	local player = game.Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local remote = game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable")

	local range = tonumber(v) or 0

	local function findBall()
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name == "Ball" then
				return obj
			end
		end
		return nil
	end

	spawn(function()
		while true do
			wait(0.5)
			local target = findBall()
			if target and (hrp.Position - target.Position).Magnitude <= range then
				remote:FireServer(buffer.fromstring("\016"))
			end
		end
	end)
end)

maintab2:Button("GK-Style Slide", function()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

UserInputService.InputBegan:Connect(function(input, isProcessed)
	if isProcessed or input.KeyCode ~= Enum.KeyCode.Q then return end

	task.delay(0.425, function()
		local target = root.CFrame + (root.CFrame.LookVector * 30)

		local tweenInfo = TweenInfo.new(
			0.05,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		)

		local tween = TweenService:Create(root, tweenInfo, {CFrame = target})
		tween:Play()
	end)
end)
end)

maintab2:Button("Suppress Notifications", function()
    _G.suppressNotifs = not (_G.suppressNotifs or false)
    local StarterGui = game:GetService("StarterGui")

    StarterGui:SetCore("SendNotification", {
        Title = "Notifications",
        Text = _G.suppressNotifs and "Suppressed." or "Un-Suppressed.",
        Duration = 3
    })
end)

_G.suppressNotifs = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local ANIMATION_ID = "rbxassetid://109744655458082"
local cooldowns = {}

local function notify(title, text, duration)
    if not _G.suppressNotifs then
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 2
        })
    end
end

local function setupAutoBehavior(toggleKey, skillName, humanoidRootPart)
    RunService.Stepped:Connect(function()
        if not _G[toggleKey] or not humanoidRootPart then return end

        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and target.Character and target.Team ~= player.Team then
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = target.Character:FindFirstChild("Humanoid")
                local animator = targetHumanoid and targetHumanoid:FindFirstChildOfClass("Animator")

                if targetHRP and animator then
                    local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
                    if distance <= 35 then
                        local now = tick()
                        local last = cooldowns[target] or 0
                        if now - last >= 0.5 then
                            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                if track.Animation.AnimationId == ANIMATION_ID then
                                    cooldowns[target] = now

                                    local args
                                    if skillName == "dribble" then
                                        args = {
                                            buffer.fromstring("\b\001"),
                                            {
                                                { skillName, false }
                                            }
                                        }
                                    else
                                        args = {
                                            buffer.fromstring("\b\001"),
                                            {
                                                { skillName }
                                            }
                                        }
                                    end

                                    ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function createAutoCounter(label, toggleKey, skillName)
    maintab2:Button(label, function()
        _G[toggleKey] = not (_G[toggleKey] or false)
        notify(label, _G[toggleKey] and "Enabled." or "Disabled.", 3)

        local function onCharacterLoaded(char)
            local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
            setupAutoBehavior(toggleKey, skillName, humanoidRootPart)
        end

        if player.Character then
            onCharacterLoaded(player.Character)
        end

        player.CharacterAdded:Connect(onCharacterLoaded)
    end)
end

createAutoCounter("Auto-Dribble", "toggleDetection", "dribble")
createAutoCounter("Auto-Counter (Move One)", "toggleCounter1", "skill1")
createAutoCounter("Auto-Counter (Move Two)", "toggleCounter2", "skill2")
createAutoCounter("Auto-Counter (Move Three)", "toggleCounter3", "skill3")
createAutoCounter("Auto-Counter (Move Four)", "toggleCounter4", "skill4")
createAutoCounter("Auto-Counter (Move Five)", "toggleCounter5", "skill5")

if not _G._keybindSetup then
    _G._keybindSetup = true

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode

        local keyMap = {
            [Enum.KeyCode.Z] = {"toggleDetection", "Auto-Dribble", "dribble"},
            [Enum.KeyCode.X] = {"toggleCounter1", "Auto-Counter (Move One)", "skill1"},
            [Enum.KeyCode.C] = {"toggleCounter2", "Auto-Counter (Move Two)", "skill2"},
            [Enum.KeyCode.V] = {"toggleCounter3", "Auto-Counter (Move Three)", "skill3"},
            [Enum.KeyCode.N] = {"toggleCounter4", "Auto-Counter (Move Four)", "skill4"},
            [Enum.KeyCode.M] = {"toggleCounter5", "Auto-Counter (Move Five)", "skill5"},
        }

        local mapping = keyMap[key]
        if mapping then
            local toggleKey, label, skillName = unpack(mapping)
            _G[toggleKey] = not (_G[toggleKey] or false)
            notify(label, _G[toggleKey] and "Enabled." or "Disabled.")

            local function onCharacterLoaded(char)
                local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
                setupAutoBehavior(toggleKey, skillName, humanoidRootPart)
            end

            if player.Character then
                onCharacterLoaded(player.Character)
            end

            player.CharacterAdded:Connect(onCharacterLoaded)
        end
    end)
end

maintab:Button("Hide Ace Eater", function()
local char = game.Players.LocalPlayer.Character
local ogAnim = char.Animate.idle.Animation1.AnimationId

local UserInputService = game:GetService("UserInputService")
local starterGui = game:GetService("StarterGui")

_G.HideAce = not _G.HideAce

local function sendNotification(status)
    starterGui:SetCore("SendNotification", {
        Title = "Hide Ace Toggle",
        Text = status,
        Duration = 3
    })
end

function onKeyPress(inputObject, gameProcessedEvent)
    if not gameProcessedEvent and _G.HideAce then
        if inputObject.KeyCode == Enum.KeyCode.Five and game.Players.LocalPlayer:GetAttribute("style") == "donlorenzo" then 
            task.wait(0.1)
            for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://108103339994438" then
                    track:Stop()
                    break
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(onKeyPress)

sendNotification(_G.HideAce and "Enabled." or "Disabled.")
end)

maintab:Button("Team Goal (YOUR GOAL)", function()
local plr = game.Players.LocalPlayer
				if plr.Team == game.Teams:FindFirstChild("A") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-538, 3, 1603)
				elseif plr.Team == game.Teams:FindFirstChild("B") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-535, 3, 946)
				end
end)

maintab:Button("Auto QuickTimeEvent", function()
    local runService = game:GetService("RunService")
    local players = game:GetService("Players")
    local virtualInputManager = game:GetService("VirtualInputManager")
    local starterGui = game:GetService("StarterGui")
    local player = players.LocalPlayer

    _G.QuickTimeEvent = not _G.QuickTimeEvent

    local function sendNotification(status)
        if not _G.suppressNotifs then
            starterGui:SetCore("SendNotification", {
                Title = "QuickTimeEvent",
                Text = status,
                Duration = 3
            })
        end
    end

    local function getAllTextLabels(parent)
        local textLabels = {}
        for _, descendant in ipairs(parent:GetDescendants()) do
            if descendant:IsA("TextLabel") then
                table.insert(textLabels, descendant)
            end
        end
        return textLabels
    end

    local function convertNumberToKeyText(text)
        local numberMap = {
            ["1"] = "One", ["2"] = "Two", ["3"] = "Three", ["4"] = "Four", ["5"] = "Five",
            ["6"] = "Six", ["7"] = "Seven", ["8"] = "Eight", ["9"] = "Nine", ["0"] = "Zero"
        }
        return numberMap[text] or text
    end

    local function checkQTE()
        if _G.QuickTimeEvent and player and player:FindFirstChild("PlayerGui") then
            local qteGui = player.PlayerGui:FindFirstChild("Qte")
            if qteGui and qteGui:FindFirstChild("QTE") and qteGui.QTE:FindFirstChild("Frame") then
                local qteFrame = qteGui.QTE.Frame
                if qteFrame.Size.X.Scale <= 0.740000169 and qteFrame.Size.X.Scale >= 0.720000019 and
                   qteFrame.Size.Y.Scale <= 0.74999999 and qteFrame.Size.Y.Scale >= 0.720000019 then

                    local textLabels = getAllTextLabels(qteGui.QTE)

                    for _, label in ipairs(textLabels) do
                        local keyText = convertNumberToKeyText(label.Text)
                        local keyCode = Enum.KeyCode[keyText]
                        if keyCode then
                            virtualInputManager:SendKeyEvent(true, keyCode, false, game)
                            virtualInputManager:SendKeyEvent(false, keyCode, false, game)
                        end
                    end
                end
            end
        end
    end

    runService.RenderStepped:Connect(checkQTE)
    sendNotification(_G.QuickTimeEvent and "Enabled." or "Disabled.")
end)

maintab:Button("No Rush Cooldown", function()
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local starterGui = game:GetService("StarterGui")
    local player = game.Players.LocalPlayer

    _G.ForwardRushEnabled = not _G.ForwardRushEnabled
    _G._rushing = false
    _G._rushingSoundPlaying = false

    if not _G.suppressNotifs then
        starterGui:SetCore("SendNotification", {
            Title = "No Rush CD",
            Text = _G.ForwardRushEnabled and "Enabled." or "Disabled.",
            Duration = 2
        })
    end

    local function forwardRush()
        if _G._rushing or not _G.ForwardRushEnabled then return end
        _G._rushing = true

        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not rootPart then
            _G._rushing = false
            return
        end

        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://79394729551302"
        local animationTrack = animator:LoadAnimation(animation)
        animationTrack:Play()

	task.delay(0.05, function()
    	if animationTrack.IsPlaying then
       		local sound = Instance.new("Sound")
        	sound.SoundId = "rbxassetid://105267293181745"
        	sound.Parent = rootPart
        	sound.Looped = false
        	sound:Play()
        	sound.Ended:Connect(function()
            sound:Destroy()
        	end)
    	end
	end)

        local startPos = rootPart.Position
        local endPos = startPos + rootPart.CFrame.LookVector * 45
        local duration, elapsed = 0.5, 0
        local dashId = "ForwardRush_" .. tostring(os.clock())

        runService:BindToRenderStep(dashId, Enum.RenderPriority.Character.Value, function(dt)
            if not rootPart or not rootPart.Parent then
                runService:UnbindFromRenderStep(dashId)
                _G._rushing = false
                return
            end

            elapsed += dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            local newPos = startPos:Lerp(endPos, alpha)
            rootPart.CFrame = CFrame.new(newPos, newPos + rootPart.CFrame.LookVector)

            if alpha >= 1 then
                runService:UnbindFromRenderStep(dashId)
                _G._rushing = false
            end
        end)
    end

    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
            forwardRush()
        end
    end)
end)

maintab:Button("No Side Dash Cooldown", function()
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local starterGui = game:GetService("StarterGui")
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    _G.SideDashEnabled = not _G.SideDashEnabled

    if not _G.suppressNotifs then
        starterGui:SetCore("SendNotification", {
            Title = "No Side Dash CD",
            Text = _G.SideDashEnabled and "Enabled." or "Disabled.",
            Duration = 2
        })
    end

    local function playDashSound()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://71212694698006"
        sound.Parent = rootPart
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end

local function sideDash(direction)
    if humanoid and rootPart and _G.SideDashEnabled and not _G._sideDashing then
        _G._sideDashing = true

        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
        local animation = Instance.new("Animation")
        animation.AnimationId = direction == "right" and "rbxassetid://114016332539655" or "rbxassetid://100207093237932"
        local animationTrack = animator:LoadAnimation(animation)
        animationTrack:Play()
        playDashSound()

        local offset = rootPart.CFrame.RightVector * (direction == "right" and 25 or -25)
        local startPos = rootPart.Position
        local endPos = startPos + offset
        local duration, elapsed = 0.55, 0 
        local dashId = "SideDash_" .. tostring(os.clock())

        runService:BindToRenderStep(dashId, Enum.RenderPriority.Character.Value, function(dt)
            if not rootPart or not rootPart.Parent then
                runService:UnbindFromRenderStep(dashId)
                _G._sideDashing = false
                return
            end

            elapsed += dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            local newPos = startPos:Lerp(endPos, alpha)
            rootPart.CFrame = CFrame.new(newPos, newPos + rootPart.CFrame.LookVector)

            if alpha >= 1 then
                runService:UnbindFromRenderStep(dashId)
                _G._sideDashing = false
            end
        end)
    end
end

    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
            local isA = userInputService:IsKeyDown(Enum.KeyCode.A)
            local isD = userInputService:IsKeyDown(Enum.KeyCode.D)
            if isD then sideDash("right") elseif isA then sideDash("left") end
        end
    end)
end)

local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")

local isClicking = false
local isEnabled = false

local function preloadAssets()
    local assetsToPreload = {}
    ContentProvider:PreloadAsync(assetsToPreload)
end

local function emulateClickAtMousePosition()
    local mouseLocation = UserInputService:GetMouseLocation()
    local x, y = mouseLocation.X, mouseLocation.Y
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

local function teleportToBall()
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local football = workspace.Terrain:FindFirstChild("Ball")

    if humanoidRootPart and football then
        humanoidRootPart.CFrame = CFrame.new(football.Position)
    end

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Name ~= player.Name then
            local otherCharacter = otherPlayer.Character
            local otherFootball = otherCharacter and otherCharacter:FindFirstChild("Ball")
            local otherHumanoidRootPart = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")

            if otherFootball and otherHumanoidRootPart and humanoidRootPart then
                humanoidRootPart.CFrame = otherFootball.CFrame
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
            end
        end
    end
end

maintab2:Button("Get Center-Field", function()
local args = {
    buffer.fromstring("\013\001\001\000B")
}
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))

local args = {
    buffer.fromstring("\013\001\001\000B")
}
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args)) 
end)

maintab2:Button("Get Goalie", function()
local args = {
    buffer.fromstring("\013\005\001\000B")
}
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))

local args = {
    buffer.fromstring("\013\005\001\000A")
}
game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args)) 
end)

maintab:Button("Steal Ball", function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local function HasBall()
    local LocalCharacter = LocalPlayer.Character
    local Football = LocalCharacter and LocalCharacter:FindFirstChild("Ball")
    return Football ~= nil
end

local function StealBall()
    while not HasBall() do
        local LocalCharacter = LocalPlayer.Character
        local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
        local Football = workspace.Terrain:FindFirstChild("Ball")

        if LocalHumanoidRootPart and Football then
            LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position)
        end

        for _, OtherPlayer in pairs(Players:GetPlayers()) do
            if OtherPlayer ~= LocalPlayer then
                local OtherCharacter = OtherPlayer.Character
                local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Ball")
                local OtherHumanoidRootPart = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")

                if OtherFootball and OtherHumanoidRootPart and LocalHumanoidRootPart then
                    LocalHumanoidRootPart.CFrame = OtherFootball.CFrame

                    local args = {
                        buffer.fromstring("\b\001"),
                        {
                            { "tackle" }
                        }
                    }

                    ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
                end
            end
        end
        task.wait(0.2)
    end
end

StealBall()
end)

maintab:Button("Bring Ball", function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local function HasBall()
    local LocalCharacter = LocalPlayer.Character
    local Football = LocalCharacter and LocalCharacter:FindFirstChild("Ball")
    return Football ~= nil
end

local function StealBall()
    while not HasBall() do
        local LocalCharacter = LocalPlayer.Character
        local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
        local Football = workspace.Terrain:FindFirstChild("Ball")

        if LocalHumanoidRootPart and Football then
            LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position)
        end

        for _, OtherPlayer in pairs(Players:GetPlayers()) do
            if OtherPlayer ~= LocalPlayer then
                local OtherCharacter = OtherPlayer.Character
                local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Ball")
                local OtherHumanoidRootPart = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")

                if OtherFootball and OtherHumanoidRootPart and LocalHumanoidRootPart then
                    LocalHumanoidRootPart.CFrame = OtherFootball.CFrame

                    local args = {
                        buffer.fromstring("\b\001"),
                        {
                            { "tackle" }
                        }
                    }
                    ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
                end
            end
        end
        task.wait(0.2)
    end
end

spawn(function()
    local LocalCharacter = LocalPlayer.Character
    local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
    local Football = workspace.Terrain:FindFirstChild("Ball")

    if LocalHumanoidRootPart and Football then
        local originalPosition = LocalHumanoidRootPart.CFrame
        LocalHumanoidRootPart.CFrame = CFrame.new(Football.Position)
        StealBall()
        task.wait(0.3)
        LocalHumanoidRootPart.CFrame = originalPosition
    end
end)
end)

maintab:Button("Manual Score", function()
    local coordinateA = Vector3.new(-552, 3, 1730)
    local coordinateB = Vector3.new(-549, 3, 818)

    local function teleportToPosition(position)
        local LocalCharacter = game.Players.LocalPlayer.Character
        local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")

        if LocalHumanoidRootPart then
            LocalHumanoidRootPart.CFrame = CFrame.new(position)
        end
    end

    local function checkTeamAndTeleport()
        local teamName = game.Players.LocalPlayer.Team and game.Players.LocalPlayer.Team.Name

        if teamName == "A" then
            teleportToPosition(coordinateB)
        elseif teamName == "B" then
            teleportToPosition(coordinateA)
        end
    end

    checkTeamAndTeleport()
end)

maintab:Button("Break Ball (Player Method, Req. Ball)", function()
    local baseplatePosition = Vector3.new(-190, 14864566, 492)
    local partSize = Vector3.new(10, 1, 10)
    local gap = 0

    for x = 0, 2 do
        for z = 0, 2 do
            local part = Instance.new("Part")
            part.Size = partSize
            part.Anchored = true
            part.Position = baseplatePosition + Vector3.new(x * (partSize.X + gap), 0, z * (partSize.Z + gap))
            part.Parent = workspace
        end
    end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    character:WaitForChild("HumanoidRootPart").CFrame =
        CFrame.new(baseplatePosition + Vector3.new(0, 100000000000000, 0))
end)

maintab:Button("Break Ball (Ball Method, Req. Ball)", function()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local virtualInputManager = game:GetService("VirtualInputManager")

if humanoidRootPart then
    local originalPosition = humanoidRootPart.Position
    humanoidRootPart.CFrame = CFrame.new(Vector3.new(-390, 475, 354))
	task.wait(0.3)
    virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.1)
    virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
	task.wait(0.3)
    humanoidRootPart.CFrame = CFrame.new(originalPosition)
end
end)

maintab:Button("Permanent Break Ball (CAN'T BE REVERSED!)", function()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-603, -422, -2081))
end)

maintab:Button("Barou Devour Goal", function()
local plr = game.Players.LocalPlayer

			local function countEnimTeamMembers()
				local op = game.Teams:FindFirstChild("A")
				if plr.Team == game.Teams:FindFirstChild("A") then
					op = game.Teams:FindFirstChild("B")
				end
				local count = 0
				for _, player in ipairs(game.Players:GetPlayers()) do
					if player.Team == op then
						count += 1
					end
				end
				return count
			end
			
			local function getTwoRandomEnemies()
				local enemies = {}
				local op = game.Teams:FindFirstChild("A")
				if plr.Team == game.Teams:FindFirstChild("A") then
					op = game.Teams:FindFirstChild("B")
				end
				
				for _, player in ipairs(game.Players:GetPlayers()) do
					if player ~= plr and player.Team == op then
						table.insert(enemies, player)
					end
				end
				
				for i = #enemies, 2, -1 do
					local j = math.random(1, i)
					enemies[i], enemies[j] = enemies[j], enemies[i]
				end

				return enemies[1], enemies[2]
			end
			
			if countEnimTeamMembers() >= 2 then
				local p1, p2 = getTwoRandomEnemies()
				if not p1 or not p2 then return end
				
				local op = game.Teams:FindFirstChild("A")
				if plr.Team == game.Teams:FindFirstChild("A") then
					op = game.Teams:FindFirstChild("B")
				end

				local function tpToPlayer(targetPlayer)
					local char = plr.Character or plr.CharacterAdded:Wait()
					local root = char:WaitForChild("HumanoidRootPart")
					local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")

					if root and targetRoot then
						root.CFrame = targetRoot.CFrame
					end
				end

				tpToPlayer(p1)
				task.wait(0.3)
				tpToPlayer(p2)
				
				task.wait(0.3)
				
				if plr.Team == game.Teams:FindFirstChild("A") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-625, 3, 925)
				elseif plr.Team == game.Teams:FindFirstChild("B") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-588, 3, 1643)
				end
			end
end)

maintab:Button("Nagi Dream Goal", function()
local plr = game.Players.LocalPlayer
if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
    local hrp = plr.Character.HumanoidRootPart
    
    if plr.Team == game.Teams:FindFirstChild("A") then
        hrp.CFrame = CFrame.new(-459, 3, 862)
    elseif plr.Team == game.Teams:FindFirstChild("B") then
        hrp.CFrame = CFrame.new(-611, 3, 1682) * CFrame.Angles(0, math.rad(180), 0)
    end
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
    plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    task.wait(0.2)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
end
end)

maintab:Button("Isagi U-20 Goal", function()
local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local teams = game:GetService("Teams")

if plr.Team == teams:FindFirstChild("A") then
    hrp.Position = Vector3.new(-539, 3, 996)
elseif plr.Team == teams:FindFirstChild("B") then
    hrp.Position = Vector3.new(-537, 3, 1557)
end

task.wait(0.5)

local skillRemote = game.ReplicatedStorage:WaitForChild("SkillRemote")
skillRemote:FireServer("Skill3")
end)

maintab:Button("Shidou Back-Heel Goal", function()
local plr = game.Players.LocalPlayer
				if plr.Team == game.Teams:FindFirstChild("A") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-625, 3, 925)
				elseif plr.Team == game.Teams:FindFirstChild("B") then
					plr.Character.HumanoidRootPart.Position = Vector3.new(-588, 3, 1643)
				end
				task.wait(0.25)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
			end)

maintab2:Textbox("Character Picker", function(v)

local validNames = {
    ["rin"] = "\019\003\000rin",
    ["aiku"] = "\019\004\000aiku",
    ["barou"] = "\019\005\000barou",
    ["sae"] = "\019\003\000sae",
    ["kaiser"] = "\019\006\000kaiser",
    ["don"] = "\019\010\000donlorenzo",
    ["nagi"] = "\019\004\000nagi",
    ["shidou"] = "\019\006\000shidou",
    ["isagi"] = "\019\005\000isagi"
}

local function checkAndFire(v)
    local match = validNames[v]
    if match then
        local args = { buffer.fromstring(match) }
        game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(unpack(args))
    else
    end
end

checkAndFire(v)
end)

funtab:Button("Don Lorenzo (Nagi)", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Credits",
    Text = "brought to you by celeron!",
    Duration = 5,
    Button1 = "OK",
})
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local root = char.HumanoidRootPart
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")


local skill1Anim = Instance.new("Animation")
skill1Anim.AnimationId = "rbxassetid://102294508090597"
local s1db = false
local dribble = hum:LoadAnimation(skill1Anim)
dribble.Priority = Enum.AnimationPriority.Action2


local skill2Anim = Instance.new("Animation")
skill2Anim.AnimationId = "rbxassetid://90734196141468"
local s2db = false
local controlJump = hum:LoadAnimation(skill2Anim)
controlJump.Priority = Enum.AnimationPriority.Action2

local skill2AnimVAR = Instance.new("Animation")
skill2AnimVAR.AnimationId = "rbxassetid://82371642989185"
local s2dbVar = false
local controlLand = hum:LoadAnimation(skill2AnimVAR)
controlLand.Priority = Enum.AnimationPriority.Action3

local skill3Anim = Instance.new("Animation")
skill3Anim.AnimationId = "rbxassetid://85862104307480"
local s3db = false
local pass = hum:LoadAnimation(skill3Anim)
pass.Priority = Enum.AnimationPriority.Action2


local function haveBall()
	local Football = char and char:FindFirstChild("Ball")
	return Football ~= nil
end

function onKeyPress(inputObject, gameProcessedEvent)
	if not gameProcessedEvent then
		if inputObject.KeyCode == Enum.KeyCode.One then
			
			if not haveBall() then return end
			if s1db == false then
				s1db = true
				
				dribble:Play()
				local vel = Instance.new("BodyVelocity")
				vel.MaxForce = Vector3.new(1,0,1) * 30000
				vel.Name = "BodyVelocity" .. math.random(1,99999)
				vel.Velocity = root.CFrame.LookVector * 40
				vel.Parent = root
				game.Debris:AddItem(vel, 2.4)
				local sfx = game.ReplicatedStorage.Resources.donlorenzo.dribbletest:Clone()
				sfx.Parent = root
				sfx:Play()
				game.Debris:AddItem(sfx, 2.5)
				for _, v in pairs (game.ReplicatedStorage.Resources.donlorenzo.skill1movingpart:GetDescendants()) do
					if v.Name == "b" or v.Name == "p" then
						local new = v:Clone()
						new.Parent = root
						new.Enabled = true
						game.Debris:AddItem(new, 2.5)
					end
				end
				for _, v in pairs (char:GetChildren()) do
					if v.Name == "Torso" or v.Name == "Right Leg" or v.Name == "Right Arm" or v.Name == "Left Leg" or v.Name == "Left Arm" or v.Name == "Head" then
						for _, g in pairs (game.ReplicatedStorage.Resources.donlorenzo.ult4aura:GetChildren()) do
							if g.Name == "Fire" or g.Name == "Fog" or g.Name == "R. C. Fire" or g.Name == "mainfire" then
								local new = g:Clone()
								new.Parent = v
								new.Enabled = true
								new.LockedToPart = true
								game.Debris:AddItem(new, 2.5)
							end
						end
					end
				end
				
				repeat
					task.wait()
					VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
					vel.Velocity = root.CFrame.LookVector * 40
				until not root:FindFirstChild(vel.Name)
				
				task.wait(21.6)
				for _, v in pairs (root:GetDescendants()) do
					if v.Name == "b" or v.Name == "p" then
						v:Destroy()
					end
				end
				s1db = false
			end
			
			
		elseif inputObject.KeyCode == Enum.KeyCode.Two then
			
			if haveBall() then return end
			if s2db == false then
				s2db = true
				controlJump:Play()
				
				local did = false
				
				for i = 1, 2, 0.1 do
					if game.Workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable then
						did = true
						break
					end
					task.wait(0.1)
				end
				
				if did then
					controlJump:Stop()
					controlLand:Play()
					
					local sfx = game.ReplicatedStorage.Resources.donlorenzo.ult4:Clone()
					sfx.Parent = root
					sfx:Play()
					
					for _, v in pairs (game.ReplicatedStorage.Resources.donlorenzo.ult4vfx.rootlocation.skill4ballpartflashsteps:GetChildren()) do
						local new = v:Clone()
						new.Parent = char:FindFirstChild("Ball")
						new.Enabled = true
						new.LockedToPart = true
						game.Debris:AddItem(new, 0.85)
					end
					
					for _, v in pairs (char:GetChildren()) do
						if v.Name == "Torso" or v.Name == "Right Leg" or v.Name == "Right Arm" or v.Name == "Left Leg" or v.Name == "Left Arm" or v.Name == "Head" then
							for _, g in pairs (game.ReplicatedStorage.Resources.donlorenzo.ult4aura:GetChildren()) do
								if g.Name == "Fire" or g.Name == "Fog" or g.Name == "R. C. Fire" or g.Name == "mainfire" then
									local new = g:Clone()
									new.Parent = v
									new.Enabled = true
									new.LockedToPart = true
									game.Debris:AddItem(new, 1)
								end
							end
						end
					end
					task.wait(0.85)
					controlLand:Stop()
				end
				
				task.wait(20)
				s2db = false
			end
			
		elseif inputObject.KeyCode == Enum.KeyCode.Three then
			
			if not haveBall() then return end
			if s3db == false then
				s3db = true
				pass:Play()
				local sfx = game.ReplicatedStorage.Resources.donlorenzo.skill2:Clone()
				sfx.Parent = root
				sfx:Play()
				
				for _, v in pairs (char:GetChildren()) do
					if v.Name == "Torso" or v.Name == "Right Leg" or v.Name == "Right Arm" or v.Name == "Left Leg" or v.Name == "Left Arm" or v.Name == "Head" then
						for _, g in pairs (game.ReplicatedStorage.Resources.donlorenzo.ult4aura:GetChildren()) do
							if g.Name == "Fire" or g.Name == "Fog" or g.Name == "R. C. Fire" or g.Name == "mainfire" then
								local new = g:Clone()
								new.Parent = v
								new.Enabled = true
								new.LockedToPart = true
								game.Debris:AddItem(new, 1)
							end
						end
					end
				end
				
				task.wait(25)
				s3db = false
			end
		
		end
	end
end
task.wait(1)
print("loaded don lorenzo script")
UserInputService.InputBegan:connect(onKeyPress)
end)

funtab:Button("Ronaldo (Shidou)", function()

local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Credits",
    Text = "brought to you by celeron!",
    Duration = 5,
    Button1 = "OK",
})
task.wait(1)

local userInput = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local player = players.LocalPlayer
local char = player.Character
local hum = char:FindFirstChild("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

local specialAnim = Instance.new("Animation")
specialAnim.AnimationId = "rbxassetid://99863640587448"

local function playSpecialAnimation()
    if hum then
        local animator = hum:FindFirstChild("Animator") or Instance.new("Animator", hum)
        local track = animator:LoadAnimation(specialAnim)
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
    end
end

userInput.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.G then
        local stateFlow = workspace:FindFirstChild("characters") 
                          and workspace.characters:FindFirstChild(player.Name)
                          and workspace.characters[player.Name]:FindFirstChild("state")
                          and workspace.characters[player.Name].state:FindFirstChild("flow")
        
        if stateFlow and stateFlow.Value == 100 then
            wait(1)
            playSpecialAnimation()
        end
    end
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

local replicatedStorage = game:GetService("ReplicatedStorage")
local aura = replicatedStorage:FindFirstChild("Resources") and replicatedStorage.Resources:FindFirstChild("ronaldo") and replicatedStorage.Resources.ronaldo:FindFirstChild("Aura")

if aura and humanoidRootPart then
    local auraModel = Instance.new("Model")
    auraModel.Name = "RonaldoAura"
    auraModel.Parent = workspace

    local bodyParts = {
        character:FindFirstChild("HumanoidRootPart"),
        character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"),
        character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"),
        character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"),
        character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"),
        character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"),
        character:FindFirstChild("Head")
    }

    for _, particleEmitter in pairs(aura:GetDescendants()) do
        if particleEmitter:IsA("ParticleEmitter") then
            particleEmitter.Enabled = true
        end
    end

    for _, bodyPart in pairs(bodyParts) do
        if bodyPart then
            local auraAttachment = aura:Clone()
            auraAttachment.Parent = auraModel
            auraAttachment.CFrame = bodyPart.CFrame

            local weld = Instance.new("WeldConstraint")
            weld.Part0 = bodyPart
            weld.Part1 = auraAttachment
            weld.Parent = bodyPart
        end
    end
end

local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local root = char.HumanoidRootPart
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")


local bicycle1 = Instance.new("Animation")
bicycle1.AnimationId = "rbxassetid://126734456236034"
local bicycleDB = false
local bicycle = hum:LoadAnimation(bicycle1)
bicycle.Priority = Enum.AnimationPriority.Action2

local dribble1 = Instance.new("Animation")
dribble1.AnimationId = "rbxassetid://95054281301535"
local dribbleDB = false
local dribble = hum:LoadAnimation(dribble1)
dribble.Priority = Enum.AnimationPriority.Action2

local assets = game:GetService("ReplicatedStorage").Resources.ronaldo.bicyclekick

local function haveBall()
	local Football = char and char:FindFirstChild("Ball")
	return Football ~= nil
end

function onKeyPress(inputObject, gameProcessedEvent)
	if not gameProcessedEvent then
		if inputObject.KeyCode == Enum.KeyCode.Two then
			
			if not haveBall() then return end
			if bicycleDB == false then
				bicycleDB = true
				
				bicycle:Play()
				
				task.wait(0.7)
				
				local boom = assets.vfx2:Clone()
				boom.Parent = root
				boom.vfx2:FindFirstChild("RONALDO!!!!"):Emit(1)
				game.Debris:AddItem(boom, 3)
				
				task.wait(19)
				bicycleDB = false
			end
		end
	end
end

UserInputService.InputBegan:connect(onKeyPress)

local userInput = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local player = players.LocalPlayer
local charsFolder = workspace:FindFirstChild("characters")
local charModel = charsFolder and charsFolder:FindFirstChild(player.Name)
local rootPart = charModel and charModel:FindFirstChild("HumanoidRootPart")

local lastUseTime = 0
local cooldown = 7.5

local function updateToolName()
    local gui = player:FindFirstChild("PlayerGui")
    if gui then
        local hotbar = gui:FindFirstChild("Hotbar")
        if hotbar then
            local backpack = hotbar:FindFirstChild("Backpack")
            if backpack then
                local hotbarSkills = backpack:FindFirstChild("Hotbar")
                if hotbarSkills then
                    local skill1 = hotbarSkills:FindFirstChild("skill1")
                    local skill2 = hotbarSkills:FindFirstChild("skill2")

                    if skill1 then
                        local base1 = skill1:FindFirstChild("Base")
                        if base1 then
                            local toolName1 = base1:FindFirstChild("ToolName")
                            if toolName1 and toolName1:IsA("TextLabel") then
                                toolName1.Text = "CR7 Dribble"
                            end

                            local reuse1 = base1:FindFirstChild("Reuse")
                            if reuse1 and reuse1:IsA("TextLabel") then
                                reuse1.Text = "Variant"
                            end
                        end
                    end

                    if skill2 then
                        local base2 = skill2:FindFirstChild("Base")
                        if base2 then
                            local toolName2 = base2:FindFirstChild("ToolName")
                            if toolName2 and toolName2:IsA("TextLabel") then
                                toolName2.Text = "Bicycle Kick"
                            end
                        end
                    end
                end
            end
        end
    end
end

local function activate()
    if not workspace.characters[player.Name]:FindFirstChild("Ball") then return end

    local currentTime = tick()
    if currentTime - lastUseTime < cooldown then return end
    lastUseTime = currentTime

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://88322771999430"

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://132960304435042"
    sound.Volume = 1
    sound.Parent = rootPart

    local humanoid = charModel:FindFirstChild("Humanoid")
    if humanoid and rootPart then
        local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
        local track = animator:LoadAnimation(anim)

        sound:Play()
        track:Play()
        task.wait(1.5)

        local dist = 165
        local speed = 0.5
        local moved = 0

        local conn
        conn = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
            if moved >= dist then
                conn:Disconnect()
                local tweenService = game:GetService("TweenService")
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local slideTween = tweenService:Create(rootPart, tweenInfo, {CFrame = rootPart.CFrame + (rootPart.CFrame.LookVector * 25)})
                slideTween:Play()
                return
            end

            local forward = rootPart.CFrame.LookVector
            rootPart.CFrame = rootPart.CFrame + (forward * speed)
            moved = moved + speed
        end)
    end
end

userInput.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.One then
            activate()
        end
    end
end)

updateToolName()

print("loaded RONALDO SUIII script")
end)

funtab:Button("Trolling Moveset", function()
    local char = game.Players.LocalPlayer.Character
    local plr = game.Players.LocalPlayer
    local hotbar = plr.PlayerGui.Hotbar
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator")

    local runAnimation = Instance.new("Animation")
    runAnimation.AnimationId = "rbxassetid://117921992582675"

    local walkAnimation = Instance.new("Animation")
    walkAnimation.AnimationId = "rbxassetid://117921992582675"

    local runTrack = animator:LoadAnimation(runAnimation)
    local walkTrack = animator:LoadAnimation(walkAnimation)

    humanoid.Running:Connect(function(speed)
        if speed > 8 then
            walkTrack:Stop()
            runTrack:Play()
        elseif speed > 0 then
            runTrack:Stop()
            walkTrack:Play()
        else
            walkTrack:Stop()
            runTrack:Stop()
        end
    end)

    local flowTexts = {
        ["nagi"] = "mcdonalds application",
        ["isagi"] = "2 loving parents",
        ["sae"] = "aura farm",
        ["rin"] = "luke warm",
        ["donlorenzo"] = "homeless person",
        ["kaiser"] = "clown of isagi's story",
        ["shidou"] = "saes #1 fan",
        ["aiku"] = "dih snake",
        ["barou"] = "barou barou kun",
        ["bachira"] = "ball hog",
        ["gagamaru"] = "team carrying goat"
    }

    if flowTexts[plr:GetAttribute("style")] then
        hotbar.MagicHealth.TextLabel.Text = flowTexts[plr:GetAttribute("style")]
    else
        hotbar.MagicHealth.TextLabel.Text = "you dont exist"
    end

    hotbar.MagicHealth.ModeText.Text = ""
    hotbar.MagicHealth.Health.Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)

misctab:Button("Mute Crowd (REJOIN TO FIX)", function()
while true do
task.wait(0.05)
game:GetService("SoundService")["football-crowd-3-69245"].Volume = 0
end
end)

emotetab:Button("Toosie Slide", function()
_G.isEnabled = _G.isEnabled or false

local animationId = "rbxassetid://95959941666543"
local soundId = "rbxassetid://1845341094"

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator")

local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack = animator:LoadAnimation(animation)

local sound

local function toggleState()
    _G.isEnabled = not _G.isEnabled
    
    if _G.isEnabled then
        animationTrack:Play()
        sound = Instance.new("Sound")
        sound.Name = "Toosie Slide"
        sound.SoundId = soundId
        sound.Looped = true
        sound.Parent = game.SoundService
        sound:Play()
    else
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end

        local existingSound = game.SoundService:FindFirstChild("Toosie Slide")
        if existingSound then
            existingSound:Stop()
            existingSound:Destroy()
        end
    end
end

toggleState()
end)

emotetab:Button("Sae Pose", function()

_G.SaePose = _G.SaePose or false

local animationId = "rbxassetid://136812327261825"
local soundId = "rbxassetid://1843404009"

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator")

local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack = animator:LoadAnimation(animation)

local sound

local function toggleState()
    _G.SaePose = not _G.SaePose
    
    if _G.SaePose then
        animationTrack:Play()
        sound = Instance.new("Sound")
        sound.Name = "Sae Pose"
        sound.SoundId = soundId
        sound.Volume = 1
        sound.Looped = true
        sound.Parent = game.SoundService
        sound:Play()
    else
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end

        local existingSound = game.SoundService:FindFirstChild("Sae Pose")
        if existingSound then
            existingSound:Stop()
            existingSound:Destroy()
        end
    end
end

toggleState()
end)

emotetab:Button("Akuma Taunt", function()
local animationId = "rbxassetid://111005363990501"
local soundId = "rbxassetid://133370927301258"

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator")

local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack = animator:LoadAnimation(animation)

local sound = Instance.new("Sound")
sound.Name = "Akuma Taunt"
sound.SoundId = soundId
sound.Volume = 10
sound.Parent = game.SoundService

local function runOnce()
    animationTrack:Play()
    sound:Play()

    sound.Ended:Connect(function()
        sound:Destroy()
    end)

    animationTrack.Stopped:Connect(function()
        animationTrack:Stop()
    end)
end

runOnce()
end)

emotetab:Button("Cartoon Fall", function()
local animationId = "rbxassetid://98064370044269"
local soundIds = { "rbxassetid://8663054927", "rbxassetid://4979513906" }

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator")

local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack = animator:LoadAnimation(animation)

local sound = Instance.new("Sound")
sound.Name = "Ragdoll"
sound.Volume = 10
sound.Parent = game.SoundService

local currentIndex = 1

local function playNextSound()
    if currentIndex <= #soundIds then
        sound.SoundId = soundIds[currentIndex]
        sound:Play()

        sound.Ended:Connect(function()
            currentIndex = currentIndex + 1
            playNextSound()
        end)
    else
        sound:Destroy()
    end
end
animationTrack:Play()
playNextSound()
end)

emotetab:Button("Spit", function()
local animationId = "rbxassetid://97257010665720"
local soundId = "rbxassetid://18111052648"

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator")

local animation = Instance.new("Animation")
animation.AnimationId = animationId

local animationTrack = animator:LoadAnimation(animation)

local sound = Instance.new("Sound")
sound.Name = "Spit"
sound.SoundId = soundId
sound.Volume = 2
sound.Parent = game.SoundService

animationTrack:Play()
sound:Play()

sound.Ended:Connect(function()
    sound:Destroy()
end)
end)

teleporttab:Button("Spawn Area", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-269, 4, -1599)
end)

teleporttab:Button("Middle Field", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-540, 3, 1274)
end)

teleporttab:Button("Gallery Area", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(109, 66, 3337)
end)

teleporttab:Button("Goal Box (A)", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-537, 3, 1575)
end)

teleporttab:Button("Goal Box (B)", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-534, 3, 974)
end)

misctab:Button("Upgrade UI (very cool actually)", function()
loadstring(game:HttpGet("https://pastebin.com/raw/QDNYsgxQ"))()
end)

misctab:Button("Overtime Cinematics", function()
local vals = game.ReplicatedStorage.workspace
local timer = vals.timer
local ingame = vals.roundstart

local music1Isagi = game:GetService("ReplicatedStorage").Resources.isagi["isagi themeover"]
local music2Sae = game:GetService("ReplicatedStorage").Resources.sae["sae one shot match theme"]

local gui = Instance.new("ScreenGui")
gui.ScreenInsets = Enum.ScreenInsets.None
gui.Name = "overtimethang"
gui.Parent = game.Players.LocalPlayer.PlayerGui

local image = Instance.new("ImageLabel")
image.AnchorPoint = Vector2.new(0.5, 0.5)
image.Position = UDim2.new(0.5, 0,0.5, 0)
image.Size = UDim2.new(1.2, 0,1.2, 0)
image.Image = "rbxassetid://11030033771"
image.ImageTransparency = 0.8
image.BackgroundTransparency = 1
image.Parent = gui

local overtime = false

task.spawn(function()
    while task.wait(0.05) do
        image.Visible = overtime
        
        if overtime == true then
            if game.Workspace.CurrentCamera.CameraType == Enum.CameraType.Custom then
                game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.2), {FieldOfView = 100}):Play()
            end
            
            if image.Rotation == 0 then
                image.Rotation = 180
            else
                image.Rotation = 0
            end
        end
    end
end)

timer.Changed:Connect(function()
    if timer.Value == 0 and ingame.Value == true then
        overtime = true
        
        repeat
            music1Isagi:Play()
            for i = 1, 50 do
                task.wait(1)
                if ingame.Value == false then
                    break
                end
            end
            music2Sae:Play()
            for i = 1, 58 do
                task.wait(1)
                if ingame.Value == false then
                    break
                end
            end
        until ingame.Value == false
        
    elseif ingame.Value == false then
        
        overtime = false
        music1Isagi:Stop()
        music2Sae:Stop()
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.2), {FieldOfView = 70}):Play()
        
    end
end)
end)

local bgmusicdb = false
misctab:Button("Background Music", function()
    if bgmusicdb == false then
        bgmusicdb = true
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        local hum = char.Humanoid

        local music = {
            "rbxassetid://126478006472705",
            "rbxassetid://138210588552041",
            "rbxassetid://137856744878500",
            "rbxassetid://97581213878614",
            "rbxassetid://71371939631022",
            "rbxassetid://119592773299545",
            "rbxassetid://134456641764445",
            "rbxassetid://100509882059819",
            "rbxassetid://128623853689708",
            "rbxassetid://70979311703713",
            "rbxassetid://92420662159372",
            "rbxassetid://97837345641106",
            "rbxassetid://102469310336986",
            "rbxassetid://101851803743361",
        }


        if game.SoundService:FindFirstChild("BGMusic") then
            game.SoundService.BGMusic:Destroy()
        end
        local sfx = Instance.new("Sound")
        sfx.Name = "BGMusic"
        sfx.Parent = game.SoundService
        sfx.SoundId = music[math.random(1, #music)]

        task.spawn(function()
            while hum do
                sfx:Play()
                task.wait(sfx.TimeLength)
                sfx.SoundId = music[math.random(1, #music)]
            end
        end)

        task.spawn(function()
            while hum do
                task.wait()

                if game:GetService("ReplicatedStorage").workspace.awaken.Value ~= nil then
                    sfx:Pause()
                else
                    sfx:Resume()
                end
            end
        end)

        hum.Died:Connect(function()
            sfx:Destroy()
        end)
    end
end)

misctab:Button("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

helptab:Button("Copy Owner Discord Username", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Username",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("ghostofcelleron")
end)

helptab:Button("Copy Discord Server Invite", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Invite",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("https://discord.gg/8stFYxJv4R")
end)