local Setings = getgenv().TomGamingMod or {}
getgenv().TomGamingMod = Setings

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()

local Window = ReGui:Window({
 Title = "Tom | Gaming Mod Menu",
 Size = UDim2.fromOffset(200, 300)
})

Setings["Multi-Jump"] = false
Setings["Noclip"] = false
Setings["TP Distance"] = 5
Setings["TP Enabled"] = false

local spawnBlocks = {}
for _, v in pairs(Workspace:GetDescendants()) do
 if v:IsA("BasePart") and v.Name:lower():find("spawn") then
  table.insert(spawnBlocks, v)
 end
end

local function getClosestPlayer()
 local closest, dist = nil, math.huge
 for _, v in pairs(Players:GetPlayers()) do
  if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
   local mag = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
   if mag < dist then
    closest = v
    dist = mag
   end
  end
 end
 return closest, dist
end

RunService.RenderStepped:Connect(function()
 if Setings["Multi-Jump"] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
  local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
  if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
   humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
  end
 end
end)

RunService.Stepped:Connect(function()
 if Setings["Noclip"] and LocalPlayer.Character then
  for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
   if v:IsA("BasePart") and v.CanCollide then
    v.CanCollide = false
   end
  end
 end
end)

RunService.Heartbeat:Connect(function()
 if Setings["TP Enabled"] then
  local closest, dist = getClosestPlayer()
  if closest and dist <= Setings["TP Distance"] then
   local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
   if hrp and #spawnBlocks > 0 then
    local target = spawnBlocks[math.random(1, #spawnBlocks)]
    hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0)
   end
  end
 end
end)

local function SpinPlayer()
 local char = LocalPlayer.Character
 if char and char:FindFirstChild("HumanoidRootPart") then
  spawn(function()
   for i = 1, 120 do
    char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(10), 0)
    RunService.RenderStepped:Wait()
   end
  end)
 end
end

local function ESPKeyParts()
 for _, v in pairs(Workspace:GetDescendants()) do
  if v:IsA("BasePart") and (v.Name:lower():find("key")) then
   local adorn = Instance.new("BoxHandleAdornment")
   adorn.Adornee = v
   adorn.Size = v.Size + Vector3.new(0.1, 0.1, 0.1)
   adorn.AlwaysOnTop = true
   adorn.ZIndex = 5
   adorn.Transparency = 0.5
   adorn.Color3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
   adorn.Parent = v
   spawn(function()
    while adorn and adorn.Parent do
     adorn.Color3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
     RunService.RenderStepped:Wait()
    end
   end)
  end
 end
end

local function SendChatMessage(message)
 if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
  local success, err = pcall(function()
   local channel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral", 5)
   if channel then
    channel:SendAsync(message)
   end
  end)
 else
  local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
  if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
   chatEvent.SayMessageRequest:FireServer(message, "All")
  end
 end
end

-- UI Elements Start Here:

Window:Checkbox({
 Label = "Multi-Jump",
 Value = false,
 Callback = function(self, val)
  Setings["Multi-Jump"] = val
 end
})

Window:Checkbox({
 Label = "Noclip",
 Value = false,
 Callback = function(self, val)
  Setings["Noclip"] = val
 end
})

Window:SliderFloat({
 Label = "TP to spawn if any player its close than studs",
 Minimum = 1,
 Maximum = 10,
 Value = 5,
 Callback = function(self, val)
  Setings["TP Distance"] = val
 end
})

Window:Button({
 Text = "TP Auto ON",
 Callback = function()
  Setings["TP Enabled"] = true
 end
})

Window:Button({
 Text = "TP Auto OFF",
 Callback = function()
  Setings["TP Enabled"] = false
 end
})

Window:Combo({
 Label = "Teleport To Player",
 Selected = "",
 GetItems = function()
  local list = {}
  for _, v in pairs(Players:GetPlayers()) do
   if v ~= LocalPlayer then
    table.insert(list, v.Name)
   end
  end
  return list
 end,
 Callback = function(self, selected)
  local target = Players:FindFirstChild(selected)
  if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
   local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
   if myHRP then
    myHRP.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
   end
  end
 end
})

Window:Separator({Text = "Advanced"})

Window:Button({
 Text = "Spin",
 Callback = function()
  SpinPlayer()
 end
})

Window:Button({
 Text = "ESP key (USE EACH ROUND)",
 Callback = function()
  ESPKeyParts()
 end
})

Window:Button({
 Text = "Change size",
 Callback = function()
  SendChatMessage("Super Ring Parts V4 By lukas")
 end
})

Window:Separator({Text = "Humanoid"})

Window:Button({
 Text = "Enable Jump (ONLY IF YOU RE KILLER)",
 Callback = function()
  local char = LocalPlayer.Character
  if char and char:FindFirstChildWhichIsA("Humanoid") then
   local hum = char:FindFirstChildWhichIsA("Humanoid")
   hum.UseJumpPower = true
   hum.JumpPower = 50
   hum.JumpHeight = 7.2
   hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
   hum:ChangeState(Enum.HumanoidStateType.Jumping)
  end
 end
})

Window:SliderFloat({
 Label = "Speed",
 Minimum = 1,
 Maximum = 100,
 Value = 16,
 Callback = function(self, val)
  local char = LocalPlayer.Character
  if char and char:FindFirstChildWhichIsA("Humanoid") then
   char:FindFirstChildWhichIsA("Humanoid").WalkSpeed = val
  end
 end
})

Window:SliderFloat({
 Label = "JumpPower",
 Minimum = 1,
 Maximum = 200,
 Value = 50,
 Callback = function(self, val)
  local char = LocalPlayer.Character
  if char and char:FindFirstChildWhichIsA("Humanoid") then
   char:FindFirstChildWhichIsA("Humanoid").JumpPower = val
  end
 end
})

Window:Separator({Text = "More Stuff"})

Window:Button({
 Text = "TP to the owner of this script (woahhhhhhy(lua))",
 Callback = function()
  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  for _, plr in pairs(Players:GetPlayers()) do
   if plr.UserId == 8594637526 and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
    if hrp then
     hrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
   end
  end
 end
})

Window:Button({
 Text = "Scan Accessories (Retain/Force Parts)",
 Callback = function()
  local found = {}
  for _, v in pairs(Workspace:GetDescendants()) do
   if v:IsA("BasePart") then
    if v:FindFirstChild("RetainPart") or v:FindFirstChild("NetworkPart") or v:FindFirstChild("ForcePart") or v:FindFirstChildWhichIsA("BodyForce") or v:FindFirstChildWhichIsA("AlignPosition") then
     table.insert(found, v:GetFullName())
    end
   end
  end
  print("Found Parts:")
  for _, part in pairs(found) do
   print(part)
  end
 end
})

Window:Button({
 Text = "Unanchor All Accessories",
 Callback = function()
  local char = LocalPlayer.Character
  if not char then return end
  for _, acc in pairs(char:GetDescendants()) do
   if acc:IsA("Accessory") then
    local handle = acc:FindFirstChild("Handle")
    if handle and handle:IsA("BasePart") then
     handle.Anchored = false
    end
   end
  end
 end
})

Window:Button({
 Text = "Destroy Mod Menu",
 Callback = function()
  local ui = game:GetService("CoreGui"):FindFirstChild("ReGui")
  if ui then
   ui:Destroy()
  end
 end
})

Window:Button({
 Text = "Fly (Q to toggle)",
 Callback = function()
  local uis = game:GetService("UserInputService")
  local flying = false
  local vel, gyro

  local function StartFly()
   local char = LocalPlayer.Character
   local hrp = char and char:FindFirstChild("HumanoidRootPart")
   if not hrp then return end

   flying = true
   vel = Instance.new("BodyVelocity")
   vel.Velocity = Vector3.zero
   vel.MaxForce = Vector3.new(999999, 999999, 999999)
   vel.Parent = hrp

   gyro = Instance.new("BodyGyro")
   gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
   gyro.CFrame = hrp.CFrame
   gyro.P = 100000
   gyro.Parent = hrp

   RunService.RenderStepped:Connect(function()
    if flying and vel and gyro then
     local cam = Workspace.CurrentCamera
     local moveDir = Vector3.new()
     if uis:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
     if uis:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
     if uis:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
     if uis:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
     if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
     if uis:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end
     vel.Velocity = moveDir.Unit * 60
     gyro.CFrame = cam.CFrame
    end
   end)
  end

  local function StopFly()
   flying = false
   if vel then vel:Destroy() end
   if gyro then gyro:Destroy() end
  end

  uis.InputBegan:Connect(function(key, gpe)
   if gpe then return end
   if key.KeyCode == Enum.KeyCode.Q then
    if flying then
     StopFly()
    else
     StartFly()
    end
   end
  end)

  StartFly()
 end
})