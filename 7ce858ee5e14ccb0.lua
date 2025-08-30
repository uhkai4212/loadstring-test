local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Good Hub",
   Icon = nil,
   LoadingTitle = "Good Hub",
   LoadingSubtitle = "by David",
   Theme = "Default",
   ToggleUIKeybind = "K",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Good Hub"
   }
})

local ItemsTab = Window:CreateTab("Items", 4483362458)
local BuildTab = Window:CreateTab("Building", 4483362458)
local TeleportTab = Window:CreateTab("Teleports", 4483362458)

-- Teleports
TeleportTab:CreateButton({
   Name = "Shop",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-425, 6, 77)
   end
})

TeleportTab:CreateButton({
   Name = "Main Area",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-394, 3, 423)
   end
})

-- Items functions
local function teleportToRandomAsset(name)
   local assets = {}
   for _, v in ipairs(workspace:GetDescendants()) do
      if v:IsA("BasePart") and string.lower(v.Name):find(string.lower(name)) then
         table.insert(assets, v)
      end
   end
   if #assets > 0 then
      local choice = assets[math.random(1, #assets)]
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = choice.CFrame + Vector3.new(0, 3, 0)
   end
end

ItemsTab:CreateButton({ Name = "Hammer", Callback = function() teleportToRandomAsset("hammer") end })
ItemsTab:CreateButton({ Name = "Food", Callback = function() teleportToRandomAsset("food") end })
ItemsTab:CreateButton({ Name = "Money", Callback = function() teleportToRandomAsset("money") end })
ItemsTab:CreateButton({ Name = "Crowbar", Callback = function() teleportToRandomAsset("crowbar") end })
ItemsTab:CreateButton({ Name = "Bat", Callback = function() teleportToRandomAsset("bat") end })
ItemsTab:CreateButton({ Name = "Lantern", Callback = function() teleportToRandomAsset("lantern") end })

-- Build system
_G.selectedBuild = "hut"

BuildTab:CreateInput({
   Name = "Select build (hut, wall, floor, big house)",
   PlaceholderText = "put build name here",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.selectedBuild = Text
   end
})

BuildTab:CreateButton({
   Name = "Build selected structure",
   Callback = function()
      if _G.selectedBuild == "hut" then
         BuildHut()
      elseif _G.selectedBuild == "wall" then
         BuildWall()
      elseif _G.selectedBuild == "floor" then
         BuildFloor()
      elseif _G.selectedBuild == "big house" then
         BuildBigHouse()
      else
         warn("Unknown build type: " .. tostring(_G.selectedBuild))
      end
   end
})

-- On-screen draggable build button toggle
local buildUIButton
BuildTab:CreateToggle({
    Name = "Build Button",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            buildUIButton = Instance.new("ScreenGui")
            buildUIButton.Name = "BuildUIButton"
            buildUIButton.ResetOnSpawn = false
            buildUIButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 150, 0, 50)
            button.Position = UDim2.new(0.5, -75, 0.85, 0)
            button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            button.Text = "Build"
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Font = Enum.Font.SourceSansBold
            button.TextSize = 24
            button.Parent = buildUIButton

            button.Active = true
            button.Draggable = true

            button.MouseButton1Click:Connect(function()
                if _G.selectedBuild == "hut" then
                    BuildHut()
                elseif _G.selectedBuild == "wall" then
                    BuildWall()
                elseif _G.selectedBuild == "floor" then
                    BuildFloor()
                elseif _G.selectedBuild == "big house" then
                    BuildBigHouse()
                else
                    warn("Unknown build type: " .. tostring(_G.selectedBuild))
                end
            end)
        else
            if buildUIButton then
                buildUIButton:Destroy()
                buildUIButton = nil
            end
        end
    end
})

-- Preview system
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local previewFolder = Instance.new("Folder", workspace)
previewFolder.Name = "PreviewParts"
_G.floorPreviewCFrame = nil

local function clearPreview()
   for _, v in ipairs(previewFolder:GetChildren()) do
      v:Destroy()
   end
end

local function createPreviewPart(size, cframe)
   local preview = Instance.new("Part")
   preview.Anchored = true
   preview.CanCollide = false
   preview.Transparency = 0.75
   preview.Color = Color3.fromRGB(0, 255, 0)
   preview.Material = Enum.Material.ForceField
   preview.Size = size
   preview.CFrame = cframe
   preview.Parent = previewFolder
end

RunService.RenderStepped:Connect(function()
   if not _G.selectedBuild then return end
   local char = player.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end

   clearPreview()

   local root = char.HumanoidRootPart
   local forward = root.CFrame.LookVector
   local right = root.CFrame.RightVector
   local origin = root.Position + Vector3.new(0, -3, 0)

   if _G.selectedBuild == "hut" then
      local center = origin + forward * 6 + Vector3.new(0, 3.75, 0)
      createPreviewPart(Vector3.new(12, 7.5, 12), CFrame.new(center, center + forward))

   elseif _G.selectedBuild == "wall" then
      local center = origin + forward * 2 + Vector3.new(0, 3, 0)
      createPreviewPart(Vector3.new(12, 6, 0.5), CFrame.new(center, center + forward))

   elseif _G.selectedBuild == "floor" then
      local center = origin + forward * 6 + Vector3.new(0, 0.25, 0)
      _G.floorPreviewCFrame = CFrame.new(center, center + forward)
      createPreviewPart(Vector3.new(12, 0.5, 12), _G.floorPreviewCFrame)

   elseif _G.selectedBuild == "big house" then
      local center = origin + forward * 30 + Vector3.new(0, 8, 0)
      createPreviewPart(Vector3.new(60, 16, 60), CFrame.new(center, center + forward))
   end
end)

-- Build functions
function BuildHut()
   local char = game.Players.LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end

   local hammer = char:FindFirstChild("Hammer")
   local part = workspace.Road:GetChildren()[33]
   if not hammer or not hammer:FindFirstChild("BuildPlank") or not part then return end
   local fire = function(p1, p2)
      hammer.BuildPlank:FireServer(p1, p2, part, part, Vector3.new(0, 1, 0))
   end

   local root = char.HumanoidRootPart
   local forward = root.CFrame.LookVector
   local right = root.CFrame.RightVector
   local origin = root.Position + Vector3.new(0, -3, 0)

   for y = 0.5, 7, 0.5 do
      if y < 1 or y > 5.5 then
         fire(origin + right * -6 + Vector3.new(0, y, 0), origin + right * 6 + Vector3.new(0, y, 0))
      else
         fire(origin + right * -6 + Vector3.new(0, y, 0), origin + right * -2 + Vector3.new(0, y, 0))
         fire(origin + right * 2 + Vector3.new(0, y, 0), origin + right * 6 + Vector3.new(0, y, 0))
      end
   end
   for y = 0.5, 7, 0.5 do fire(origin + right * 6 + Vector3.new(0, y, 0), origin + right * 6 + forward * 12 + Vector3.new(0, y, 0)) end
   for y = 0.5, 7, 0.5 do fire(origin + right * -6 + forward * 12 + Vector3.new(0, y, 0), origin + right * 6 + forward * 12 + Vector3.new(0, y, 0)) end
   for y = 0.5, 7, 0.5 do fire(origin + right * -6 + Vector3.new(0, y, 0), origin + right * -6 + forward * 12 + Vector3.new(0, y, 0)) end
   for z = 0, 12, 2 do fire(origin + right * -6 + Vector3.new(0, 7.5, 0) + forward * z, origin + right * 6 + Vector3.new(0, 7.5, 0) + forward * z) end
end

function BuildWall()
   local char = game.Players.LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end

   local root = char.HumanoidRootPart
   local forward = root.CFrame.LookVector
   local right = root.CFrame.RightVector
   local start = root.Position + forward * 2 + Vector3.new(0, -3, 0)

   local hammer = char:FindFirstChild("Hammer")
   local part = workspace.Ground:GetChildren()[9]
   if not hammer or not hammer:FindFirstChild("BuildPlank") or not part then return end
   local fire = function(p1, p2)
      hammer.BuildPlank:FireServer(p1, p2, part, part, Vector3.new(0, 1, 0))
   end

   for y = 0.5, 6, 0.5 do
      fire(start + right * -6 + Vector3.new(0, y, 0), start + right * 6 + Vector3.new(0, y, 0))
   end
end

function BuildFloor()
   local char = game.Players.LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") or not _G.floorPreviewCFrame then return end

   local hammer = char:FindFirstChild("Hammer")
   local part = workspace.Road:GetChildren()[33]
   if not hammer or not hammer:FindFirstChild("BuildPlank") or not part then return end
   local fire = function(p1, p2)
      hammer.BuildPlank:FireServer(p1, p2, part, part, Vector3.new(0, 1, 0))
   end

   local cframe = _G.floorPreviewCFrame
   for x = -6, 5.5, 0.5 do
      local p1 = cframe * Vector3.new(x, 0, -6)
      local p2 = cframe * Vector3.new(x, 0, 6)
      fire(p1, p2)
   end
end

-- Updated BuildBigHouse with optimized floor and ceiling
function BuildBigHouse()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local root = char.HumanoidRootPart
    local forward = root.CFrame.LookVector
    local right = root.CFrame.RightVector
    local origin = root.Position + Vector3.new(0, -3, 0)

    local hammer = char:FindFirstChild("Hammer")
    local part = workspace.Road:GetChildren()[33]
    if not hammer or not hammer:FindFirstChild("BuildPlank") or not part then return end

    local fire = function(p1, p2)
        local dist = (p1 - p2).Magnitude
        if dist <= 11 then
            hammer.BuildPlank:FireServer(p1, p2, part, part, Vector3.new(0, 1, 0))
        else
            local dir = (p2 - p1).Unit
            local steps = math.ceil(dist / 11)
            local stepLength = dist / steps
            for i = 0, steps - 1 do
                local segStart = p1 + dir * (i * stepLength)
                local segEnd = p1 + dir * ((i + 1) * stepLength)
                hammer.BuildPlank:FireServer(segStart, segEnd, part, part, Vector3.new(0, 1, 0))
            end
        end
    end

    local function wall(p1, p2, height, hasDoor)
        for y = 0.5, height, 0.5 do
            if hasDoor and y <= 8 then
                local mid = (p1 + p2) / 2
                local dir = (p2 - p1).Unit
                local halfDoor = 2.5
                local left = mid - dir * halfDoor
                local right = mid + dir * halfDoor
                fire(p1 + Vector3.new(0, y, 0), left + Vector3.new(0, y, 0))
                fire(right + Vector3.new(0, y, 0), p2 + Vector3.new(0, y, 0))
            else
                fire(p1 + Vector3.new(0, y, 0), p2 + Vector3.new(0, y, 0))
            end
        end
    end

    local size = 60
    local height = 16
    local corners = {
        origin + right * -size/2,
        origin + right * size/2,
        origin + right * size/2 + forward * size,
        origin + right * -size/2 + forward * size
    }

    wall(corners[1], corners[2], height, true)
    wall(corners[2], corners[3], height, false)
    wall(corners[3], corners[4], height, false)
    wall(corners[4], corners[1], height, false)

    -- Optimized ceiling using 11 x 2 planks
    for z = 0, size - 2, 2 do
        for x = -size/2, size/2 - 11, 11 do
            local p1 = origin + right * x + forward * z + Vector3.new(0, height + 0.5, 0)
            local p2 = p1 + right * 11
            fire(p1, p2)
        end
    end

    -- Optimized floor using 11 x 2 x 0.5 planks
    for z = 0, size - 2, 2 do
        for x = -size/2, size/2 - 11, 11 do
            local p1 = origin + right * x + forward * z + Vector3.new(0, 0.25, 0)
            local p2 = p1 + right * 11
            fire(p1, p2)
        end
    end
end

Rayfield:LoadConfiguration()