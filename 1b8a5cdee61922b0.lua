local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)("Pepsi's UI Library")

-- Create main window
local Window = Library:CreateWindow({
    Name = 'Pepsi Library',
    Themeable = {
        Info = 'Discord Server: VzYTJ7Y',
        Credit = true, -- Shows library credits
    },
    DefaultTheme = shared.themename or '{"__Designer.Colors.main":"4dbed9"}'
})

-- Create tab and section
local GeneralTab = Window:CreateTab({Name = 'General'})
local MainSection = GeneralTab:CreateSection({
    Name = 'Main Controls',
    Side = 'Left'
})

-- Add a toggle with keybind
MainSection:AddToggle({
    Name = 'Chip auto farm',
    Value = false,
    Flag = 'auto_farm',
    Keybind = {
        Flag = 'farm_keybind',
        Mode = 'Toggle',
        Value = Enum.KeyCode.F
    },
    Callback = function(state)
        loadstring(game:HttpGet('https://pastebin.com/raw/5uXv990f'))()
    end
})

MainSection:AddButton({
    Name = 'box auto farm',
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/Yitz4dyk'))()
    end
})

local GeneralSection = GeneralTab:CreateSection({
    Name = 'esp',
    Side = 'Right'  -- 'Left' or 'Right'
})

GeneralSection:AddButton({
    Name = 'ATM',
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/ikvvvwYW'))()
    end
})

GeneralSection:AddButton({
    Name = 'box',
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/FVpv6mnq'))()
    end
})

GeneralSection:AddButton({
    Name = 'Skeleton',
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/melvin123gp/shit/refs/heads/main/skeleto"))()()
    end
})

GeneralSection:AddButton({
    Name = 'cham',
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/melvin123gp/e21/refs/heads/main/111"))()()
    end
})

GeneralSection:AddButton({
    Name = 'Inventory',
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/4b3B5nmZ'))()
    end
})

local GeneralSection = GeneralTab:CreateSection({
    Name = 'Firerate',
    Side = 'Right'  -- 'Left' or 'Right'
})

GeneralSection:AddButton({
    Name = 'fire rate',
    Callback = function()
        local Players = game:GetService("Players")
-- Function to enable one-shot
local function enableOneShot(tool)
    if tool:IsA("Tool") then
        local settingModule = tool:FindFirstChild("Setting")

        if settingModule and settingModule:IsA("ModuleScript") then
            local success, settings = pcall(require, settingModule)

            if success and type(settings) == "table" and settings.FireRate ~= nil then
                settings.Auto = true;
                settings.FireRate = 0.07;
                setting.ReloadTime = 0;
                setting.Accuracy = 1;
                setting.SpreadX = 0;
                setting.SpreadY = 0;
                setting.Range = 50000;
                setting.JamChance = 0;
                setting.CameraRecoilingEnabled = false;
                setting.Recoil = 0;
                print("god mode activated.")
            else
                print("The 'Setting' module is invalid or does not contain 'BaseDamage'.")
            end
        else
            print("This tool does not have a 'Setting' module.")
        end
    end
end

-- Monitor equipped tools
local function onCharacterAdded(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            enableOneShot(child)
        end
    end)

    -- Check for tools that may already be equipped
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            enableOneShot(child)
        end
    end
end

-- Setup for the local player
local localPlayer = Players.LocalPlayer

if localPlayer.Character then
    onCharacterAdded(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)
    end
})

GeneralSection:AddButton({
    Name = '3 person lock',
    Callback = function()
        local Area = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MyCharacter = LocalPlayer.Character
local MyRoot = MyCharacter:FindFirstChild("Head")
local MyHumanoid = MyCharacter:FindFirstChild("Humanoid")
local Mouse = LocalPlayer:GetMouse()
local MyView = Area.CurrentCamera
local MyTeamColor = LocalPlayer.TeamColor
local HoldingM2 = true
local Active = true
local Lock = false
local Epitaph = .010
local HeadOffset = Vector3.new(0, .1, 0)

_G.TeamCheck = false
_G.AimPart = "Head"
_G.Sensitivity = 0
_G.CircleSides = 64
_G.CircleColor = Color3.fromRGB(255, 0, 130)
_G.CircleTransparency = 0
_G.CircleRadius = 200
_G.CircleFilled = false
_G.CircleVisible = true
_G.CircleThickness = 1

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(MyView.ViewportSize.X / 2, MyView.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function CursorLock()
	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
end
local function UnLockCursor()
	HoldingM2 = true Active = true Lock = false 
	UIS.MouseBehavior = Enum.MouseBehavior.Default
end
function FindNearestPlayer()
	local dist = math.huge
	local Target = nil
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 and v.Character:FindFirstChild("Head") and v then
			local TheirCharacter = v.Character
			local CharacterRoot, Visible = MyView:WorldToViewportPoint(TheirCharacter[_G.AimPart].Position)
			if Visible then
				local RealMag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(CharacterRoot.X, CharacterRoot.Y)).Magnitude
				if RealMag < dist and RealMag < FOVCircle.Radius then
					dist = RealMag
					Target = TheirCharacter
				end
			end
		end
	end
	return Target
end

UIS.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		HoldingM2 = true
		Active = true
		Lock = true
		if Active then
        	local The_Enemy = FindNearestPlayer()
			while HoldingM2 do task.wait(.000001)
				if Lock and The_Enemy ~= nil then
					local Future = The_Enemy.Head.CFrame + (The_Enemy.Head.Velocity * Epitaph)
					MyView.CFrame = CFrame.lookAt(MyView.CFrame.Position, Future.Position)
					CursorLock()
				end
			end
		end
	end
end)
UIS.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		UnLockCursor()
	end
end)
game.StarterGui:SetCore("SendNotification", {Title = "Mouse lock", Text = "Loaded", Duration = 5,})
    end
})

GeneralSection:AddButton({
    Name = 'instant loot',
    Callback = function()
        for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
    if v:IsA("ProximityPrompt") then
        v["HoldDuration"] = 0
    end
end
 
 
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(v)
    v["HoldDuration"] = 0
end)
    end
})

GeneralSection:AddButton({
    Name = 'deleat J',
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/nGp4HFHa'))()
    end
})

local GeneralSection = GeneralTab:CreateSection({
    Name = 'Game',
    Side = 'Left'  -- 'Left' or 'Right'
})

GeneralSection:AddButton({
    Name = 'Bright',
    Callback = function()
        local lighting = game:GetService("Lighting");
    lighting.Ambient = Color3.fromRGB(255, 255, 255);
    lighting.Brightness = 1;
    lighting.FogEnd = 1e10;
    for i, v in pairs(lighting:GetDescendants()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false;
        end;
    end;
    lighting.Changed:Connect(function()
        lighting.Ambient = Color3.fromRGB(255, 255, 255);
        lighting.Brightness = 1;
        lighting.FogEnd = 1e10;
    end);
    spawn(function()
        local character = game:GetService("Players").LocalPlayer.Character;
        while wait() do
            repeat wait() until character ~= nil;
            if not character.HumanoidRootPart:FindFirstChildWhichIsA("PointLight") then
                local headlight = Instance.new("PointLight", character.HumanoidRootPart);
                headlight.Brightness = 1;
                headlight.Range = 60;
            end;
        end;
    end);
    end
})

GeneralSection:AddButton({
    Name = 'Enable reset button',
    Callback = function()
        while true do
     game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
     game:GetService("RunService").RenderStepped:Wait()
    end
end
})

GeneralSection:AddButton({
    Name = 'join low server',
    Callback = function()
        getgenv().AutoTeleport = true
getgenv().DontTeleportTheSameNumber = true --If you set this true it won't teleport to the server if it has the same number of players as your current server
getgenv().CopytoClipboard = false

if not game:IsLoaded() then
    print("Game is loading waiting... | Amnesia Empty Server Finder")
    repeat
        wait()
    until game:IsLoaded()
    end

local maxplayers = math.huge
local serversmaxplayer;
local goodserver;
local gamelink = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

function serversearch()
    for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink)).data) do
        if type(v) == "table" and maxplayers > v.playing then
            serversmaxplayer = v.maxPlayers
            maxplayers = v.playing
            goodserver = v.id
        end
    end
    print("Currently checking the servers with max this number of players : " .. maxplayers .. " | Amnesia Empty Server Finder")
end

function getservers()
    serversearch()
    for i,v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink))) do
        if i == "nextPageCursor" then
            if gamelink:find("&cursor=") then
                local a = gamelink:find("&cursor=")
                local b = gamelink:sub(a)
                gamelink = gamelink:gsub(b, "")
            end
            gamelink = gamelink .. "&cursor=" ..v
            getservers()
        end
    end
end

getservers()

    print("All of the servers are searched") 
	print("Server : " .. goodserver .. " Players : " .. maxplayers .. "/" .. serversmaxplayer .. " | Amnesia Empty Server Finder")
    if CopytoClipboard then
    setclipboard(goodserver)
    end
    if AutoTeleport then
        if DontTeleportTheSameNumber then 
            if #game:GetService("Players"):GetPlayers() - 1 == maxplayers then
                return warn("It has same number of players (except you)")
            elseif goodserver == game.JobId then
                return warn("Your current server is the most empty server atm") 
            end
        end
        print("AutoTeleport is enabled. Teleporting to : " .. goodserver)
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, goodserver)
    end
   end,
})

GeneralSection:AddButton({
    Name = 'Spoof name',
    Callback = function()
         getgenv().name = "////???////"
 
local Plr = game.Players.LocalPlayer
for Index, Value in next, game:GetDescendants() do 
    if Value.ClassName == "TextLabel" then 
        local has = string.find(Value.Text,Plr.Name) 
        if has then 
            local str = Value.Text:gsub(Plr.Name,name)
            Value.Text = str 
        end
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(Plr.Name,name)
            Value.Text = str 
        end)
    end
end
 
game.DescendantAdded:Connect(function(Value)
    if Value.ClassName == "TextLabel" then 
        local has = string.find(Value.Text,Plr.Name)
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(Plr.Name,name)
            Value.Text = str 
        end)
        if has then 
            local str = Value.Text:gsub(Plr.Name,name)
            Value.Text = str 
        end
 
    end
end)
   end,
})

GeneralSection:AddButton({
    Name = 'Inf zoom',
    Callback = function()
          getgenv().host = game:GetService'Players'.LocalPlayer

host.CameraMaxZoomDistance = math.huge
    end
})