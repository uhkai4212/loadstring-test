local placeId = game.PlaceId
local chapter1PlaceId = 4480809144
local chapter2PlaceId = 10384852727
local chapter3PlaceId = 10384858885

if placeId == chapter1PlaceId then
    print("Chapter 1")
    wait(1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Chapter 1",
        Text = "Loading...",
        Duration = 3
    })
    wait(2)

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Granny: Multiplayer - Free - 🧓🏿🏏", "Default")

local HighlightLib = {}

local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineTransparency = 0.5
local CoreGui = game:FindService("CoreGui")
local Workspace = game.Workspace
local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

HighlightLib.Models = {}
HighlightLib.Parts = {}

local function addNameTag(instance, name, color)
    local nameTag = Instance.new("BillboardGui")
    nameTag.Adornee = instance
    nameTag.Size = UDim2.new(0, 75, 0, 30)
    nameTag.StudsOffset = Vector3.new(0, 3, 0)
    nameTag.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0
    textLabel.Text = name
    textLabel.TextScaled = true
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextSize = 12
    textLabel.Parent = nameTag

    nameTag.Parent = instance
end

local function HighlightPart(name, fillColor, outlineColor)
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") then
            if object.Name:lower() == name:lower() then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = Storage
                Highlight.Adornee = object
                Highlight.FillColor = fillColor
                Highlight.DepthMode = DepthMode
                Highlight.FillTransparency = FillTransparency
                Highlight.OutlineColor = outlineColor
                Highlight.OutlineTransparency = OutlineTransparency
                addNameTag(object, name, outlineColor)
                table.insert(HighlightLib.Parts, {object, Highlight})
            end
        end
    end
end

local function HighlightModel(name, fillColor, outlineColor)
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name:lower() == name:lower() then
            local highlight = Instance.new("Highlight")
            highlight.Name = model.Name
            highlight.FillColor = fillColor
            highlight.DepthMode = DepthMode
            highlight.FillTransparency = FillTransparency
            highlight.OutlineColor = outlineColor
            highlight.OutlineTransparency = OutlineTransparency
            highlight.Parent = Storage
            highlight.Adornee = model
            table.insert(HighlightLib.Models, {model, highlight})
            addNameTag(model, model.Name, outlineColor)
            return
        end
    end
end

local function UpdateHighlights()
    for _, highlightedPart in pairs(HighlightLib.Parts) do
        local part, highlight = highlightedPart[1], highlightedPart[2]
        if part and part.Parent then
            highlight.Adornee = part
        else
            highlight:Destroy()
            table.remove(HighlightLib.Parts, _)
        end
    end

    for _, highlightedModel in pairs(HighlightLib.Models) do
        local model, highlight = highlightedModel[1], highlightedModel[2]
        if model and model.Parent then
            highlight.Adornee = model
        else
            highlight:Destroy()
            table.remove(HighlightLib.Models, _)
        end
    end
end

Workspace.DescendantAdded:Connect(function(instance)
    if instance:IsA("BasePart") or instance:IsA("Model") then
        UpdateHighlights()
    end
end)

HighlightLib.HighlightModel = function(name, fillColor, outlineColor)
    HighlightModel(name, fillColor, outlineColor)
end

HighlightLib.HighlightPart = function(name, fillColor, outlineColor)
    HighlightPart(name, fillColor, outlineColor)
end

local tab = DrRayLibrary.newTab("Chapter 1", "ImageIdHere")

tab.newLabel("Items")

local lighting = game.Lighting
local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

tab.newInput("Item", "Enter Item Name To Obtain", function(inputText)
    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find(inputText:lower()) then
                for _, presetName in ipairs(presets) do
                    local preset = workspace:FindFirstChild(presetName)
                    if preset then
                        local toolObject = preset:FindFirstChild(tool.Name)
                        if toolObject and toolObject:FindFirstChild("InteractRemote") then
                            local args = {
                                [1] = game:GetService("Players").LocalPlayer
                            }
                            toolObject.InteractRemote:FireServer(unpack(args))
                            wait(0.1)
                        end
                    end
                end
            end
        end
    else
        warn("Lighting not found.")
    end
end)

tab.newButton("Obtain Items", "Obtains Items", function()
    local lighting = game.Lighting
    local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") then
                for _, presetName in ipairs(presets) do
                    local preset = workspace:FindFirstChild(presetName)
                    if preset then
                        local toolObject = preset:FindFirstChild(tool.Name)
                        if toolObject and toolObject:FindFirstChild("InteractRemote") then
                            local args = {
                                [1] = game:GetService("Players").LocalPlayer
                            }
                            toolObject.InteractRemote:FireServer(unpack(args))
                            wait(0.1)
                        end
                    end
                end
            end
        end
    else
        warn("Please Don't Skid ;-;")
    end
end)

tab.newButton("Obtain General Items","Obtains General Items", function()
local generalItems = {"Crossbow", "Note", "FreezeTrap", "Pepper spray"}

local args = {
    [1] = game:GetService("Players").LocalPlayer
}

local function interactWithItem(itemName)
    local generalItemsFolder = workspace:FindFirstChild("General Items")
    if generalItemsFolder then
        local item = generalItemsFolder:FindFirstChild(itemName)
        if item and item:FindFirstChild("InteractRemote") then
            item.InteractRemote:FireServer(unpack(args))
            return true
        end
    end
    return false
end

for _, itemName in ipairs(generalItems) do
    interactWithItem(itemName)
    wait(0.1)
end
end)

tab.newButton("Obtain Keys","Obtains Keys", function()
local lighting = game.Lighting
local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

if lighting then
    for _, tool in pairs(lighting:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:find("key") then
            for _, presetName in ipairs(presets) do
                local preset = workspace:FindFirstChild(presetName)
                if preset then
                    local toolObject = preset:FindFirstChild(tool.Name)
                    if toolObject and toolObject:FindFirstChild("InteractRemote") then
                        local args = {
                            [1] = game:GetService("Players").LocalPlayer
                        }
                        toolObject.InteractRemote:FireServer(unpack(args))
                        wait(0.1)
                    end
                end
            end
        end
    end
else
    warn("Please Don't Skid ;-;")
end
end)
tab.newLabel("Highlights")
tab.newButton("Highlight Granny", "Esp/Chams", function()
    HighlightLib.HighlightModel("Granny", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "Granny" then
            HighlightLib.HighlightModel("Granny", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
        end
    end)
end)
tab.newButton("Highlight Slendrina's Mother", "Esp/Chams", function()
    HighlightLib.HighlightModel("SlendrinaMother", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "SlendrinaMother" then
            HighlightLib.HighlightModel("SlendrinaMother", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
        end
    end)
end)
tab.newButton("Highlight Items", "Esp/Chams", function()
    local lighting = game.Lighting
    local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

    local toolNames = {}
    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(toolNames, tool.Name)
            end
        end
    end

    local function highlightMatchingParts()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and table.find(toolNames, part.Name) then
                HighlightLib.HighlightPart(part.Name, Color3.fromRGB(0, 225, 0), Color3.fromRGB(0, 225, 0))
            end
        end
    end

    highlightMatchingParts()

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") and table.find(toolNames, descendant.Name) then
            HighlightLib.HighlightPart(descendant.Name, Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 225, 0))
        end
    end)
end)
tab.newLabel("Extra")
tab.newButton("Practice Mode","Practice Gamemode", function()
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Model") and object.Name == "Granny" then
        object:Destroy()
    end
end
wait(0.1)
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Model") and object.Name == "SlendrinaMother" then
        object:Destroy()
    end
end
end)
tab.newButton("Instant Interact","Proximity Prompt", function()
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
  fireproximityprompt(prompt)
end)
end)
tab.newButton("Remove Bear Traps","Removes Bear Trap Objects", function()
while true do
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Part") and object.Name == "Close" then
        object:Destroy()
    end
end
wait(5)
end
end)
tab.newLabel("OP'S")
local isToggled = false
local hiddenButtons = {}

local function hideDropButtons(container)
    for _, v in pairs(container:GetDescendants()) do
        if v:IsA("TextButton") and v.Text:find("DROP") then
            if v.Visible then
                v.Visible = false
                table.insert(hiddenButtons, v)
            end
        end
    end
end

local function showHiddenButtons()
    for _, v in ipairs(hiddenButtons) do
        if v and v.Parent then
            v.Visible = true
        end
    end
    hiddenButtons = {}
end

tab.newToggle("Spawn FreezeTraps", "Click To Loop", false, function(bool)
    isToggled = bool

    if not isToggled then
        hideDropButtons(workspace)
        hideDropButtons(game:GetService("Players"))
    else
        showHiddenButtons()
    end

    while isToggled do
        task.wait(0.1)
        local args = {
            [1] = game:GetService("Players").LocalPlayer
        }
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local backpack = player:FindFirstChildOfClass("Backpack")

        local freezeTrapTool = backpack and backpack:FindFirstChild("Freeze trap")
        if freezeTrapTool and character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:EquipTool(freezeTrapTool)
            end
        end

        local freezeTrap = workspace:FindFirstChild("General Items"):FindFirstChild("FreezeTrap")
        if freezeTrap and freezeTrap:FindFirstChild("InteractRemote") then
            freezeTrap.InteractRemote:FireServer(unpack(args))
        end
        task.wait(0.1)

        local freezeTrapInCharacter = character and character:FindFirstChild("Freeze trap")
        if freezeTrapInCharacter and freezeTrapInCharacter:FindFirstChild("FireEvent") then
            freezeTrapInCharacter.FireEvent:FireServer(unpack(args))
        end
        task.wait(0.1)
    end

    if not isToggled then
        hideDropButtons(workspace)
        hideDropButtons(game:GetService("Players"))
    end
end)

elseif placeId == chapter2PlaceId then
    print("Chapter 2")
    wait(1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Chapter 2",
        Text = "Loading...",
        Duration = 3
    })
    wait(2)

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Granny: Multiplayer - Free - 🧓🏿🏏", "Default")

local HighlightLib = {}

local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineTransparency = 0.5
local CoreGui = game:FindService("CoreGui")
local Workspace = game.Workspace
local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

HighlightLib.Models = {}
HighlightLib.Parts = {}

local function addNameTag(instance, name, color)
    local nameTag = Instance.new("BillboardGui")
    nameTag.Adornee = instance
    nameTag.Size = UDim2.new(0, 75, 0, 30)
    nameTag.StudsOffset = Vector3.new(0, 3, 0)
    nameTag.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0
    textLabel.Text = name
    textLabel.TextScaled = true
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextSize = 12
    textLabel.Parent = nameTag

    nameTag.Parent = instance
end

local function HighlightPart(name, fillColor, outlineColor)
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") then
            if object.Name:lower() == name:lower() then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = Storage
                Highlight.Adornee = object
                Highlight.FillColor = fillColor
                Highlight.DepthMode = DepthMode
                Highlight.FillTransparency = FillTransparency
                Highlight.OutlineColor = outlineColor
                Highlight.OutlineTransparency = OutlineTransparency
                addNameTag(object, name, outlineColor)
                table.insert(HighlightLib.Parts, {object, Highlight})
            end
        end
    end
end

local function HighlightModel(name, fillColor, outlineColor)
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name:lower() == name:lower() then
            local highlight = Instance.new("Highlight")
            highlight.Name = model.Name
            highlight.FillColor = fillColor
            highlight.DepthMode = DepthMode
            highlight.FillTransparency = FillTransparency
            highlight.OutlineColor = outlineColor
            highlight.OutlineTransparency = OutlineTransparency
            highlight.Parent = Storage
            highlight.Adornee = model
            table.insert(HighlightLib.Models, {model, highlight})
            addNameTag(model, model.Name, outlineColor)
            return
        end
    end
end

local function UpdateHighlights()
    for _, highlightedPart in pairs(HighlightLib.Parts) do
        local part, highlight = highlightedPart[1], highlightedPart[2]
        if part and part.Parent then
            highlight.Adornee = part
        else
            highlight:Destroy()
            table.remove(HighlightLib.Parts, _)
        end
    end

    for _, highlightedModel in pairs(HighlightLib.Models) do
        local model, highlight = highlightedModel[1], highlightedModel[2]
        if model and model.Parent then
            highlight.Adornee = model
        else
            highlight:Destroy()
            table.remove(HighlightLib.Models, _)
        end
    end
end

Workspace.DescendantAdded:Connect(function(instance)
    if instance:IsA("BasePart") or instance:IsA("Model") then
        UpdateHighlights()
    end
end)

HighlightLib.HighlightModel = function(name, fillColor, outlineColor)
    HighlightModel(name, fillColor, outlineColor)
end

HighlightLib.HighlightPart = function(name, fillColor, outlineColor)
    HighlightPart(name, fillColor, outlineColor)
end

local tab = DrRayLibrary.newTab("Chapter 2", "ImageIdHere")

tab.newLabel("Items")

local lighting = game.Lighting
local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

tab.newInput("Item", "Enter Item Name To Obtain", function(inputText)
    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find(inputText:lower()) then
                for _, presetName in ipairs(presets) do
                    local preset = workspace:FindFirstChild(presetName)
                    if preset then
                        local toolObject = preset:FindFirstChild(tool.Name)
                        if toolObject and toolObject:FindFirstChild("InteractRemote") then
                            local args = {
                                [1] = game:GetService("Players").LocalPlayer
                            }
                            toolObject.InteractRemote:FireServer(unpack(args))
                            wait(0.1)
                        end
                    end
                end
            end
        end
    else
        warn("Lighting not found.")
    end
end)

tab.newButton("Obtain Items", "Obtains Items", function()
    local lighting = game.Lighting
    local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") then
                for _, presetName in ipairs(presets) do
                    local preset = workspace:FindFirstChild(presetName)
                    if preset then
                        local toolObject = preset:FindFirstChild(tool.Name)
                        if toolObject and toolObject:FindFirstChild("InteractRemote") then
                            local args = {
                                [1] = game:GetService("Players").LocalPlayer
                            }
                            toolObject.InteractRemote:FireServer(unpack(args))
                            wait(0.1)
                        end
                    end
                end
            end
        end
    else
        warn("Please Don't Skid ;-;")
    end
end)

tab.newButton("Obtain Keys","Obtains Keys", function()
local lighting = game.Lighting
local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

if lighting then
    for _, tool in pairs(lighting:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:find("key") then
            for _, presetName in ipairs(presets) do
                local preset = workspace:FindFirstChild(presetName)
                if preset then
                    local toolObject = preset:FindFirstChild(tool.Name)
                    if toolObject and toolObject:FindFirstChild("InteractRemote") then
                        local args = {
                            [1] = game:GetService("Players").LocalPlayer
                        }
                        toolObject.InteractRemote:FireServer(unpack(args))
                        wait(0.1)
                    end
                end
            end
        end
    end
else
    warn("Please Don't Skid ;-;")
end
end)
tab.newLabel("Highlights")
tab.newButton("Highlight Granny", "Esp/Chams", function()
    HighlightLib.HighlightModel("Granny", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "Granny" then
            HighlightLib.HighlightModel("Granny", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
        end
    end)
end)
tab.newButton("Highlight Grandpa", "Esp/Chams", function()
    HighlightLib.HighlightModel("Grandpa", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "Grandpa" then
            HighlightLib.HighlightModel("Grandpa", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
        end
    end)
end)

tab.newButton("Highlight Items", "Esp/Chams", function()
    local lighting = game.Lighting
    local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

    local toolNames = {}
    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(toolNames, tool.Name)
            end
        end
    end

    local function highlightMatchingParts()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and table.find(toolNames, part.Name) then
                HighlightLib.HighlightPart(part.Name, Color3.fromRGB(0, 225, 0), Color3.fromRGB(0, 225, 0))
            end
        end
    end

    highlightMatchingParts()

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") and table.find(toolNames, descendant.Name) then
            HighlightLib.HighlightPart(descendant.Name, Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 225, 0))
        end
    end)
end)
tab.newLabel("Extra")
tab.newButton("Practice Mode","Practice Gamemode", function()
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Model") and object.Name == "Granny" then
        object:Destroy()
    end
end
wait(0.1)
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Model") and object.Name == "Grandpa" then
        object:Destroy()
    end
end
end)
tab.newButton("Instant Interact","Proximity Prompt", function()
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
  fireproximityprompt(prompt)
end)
end)
tab.newButton("Remove Bear Traps","Removes Bear Trap Objects", function()
while true do
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Part") and object.Name == "Close" then
        object:Destroy()
    end
end
wait(5)
end
end)
tab.newLabel("OP'S")
tab.newButton("Throw Grenade","Button", function()
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ActionMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 30)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "Throw-G"
button.Font = Enum.Font.SourceSans
button.FontSize = Enum.FontSize.Size24
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

button.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 50)
toggleButton.Text = "Toggle Drag"
toggleButton.Name = "ToggleDragButton" -- Unique identifier
toggleButton.Font = Enum.Font.SourceSans
toggleButton.FontSize = Enum.FontSize.Size24
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

toggleButton.Parent = screenGui

-- Remove duplicates of "ToggleDragButton"
for _, gui in pairs(screenGui:GetChildren()) do
    if gui:IsA("TextButton") and gui.Name == "ToggleDragButton" and gui ~= toggleButton then
        gui:Destroy()
    end
end

local UserInputService = game:GetService("UserInputService")

local dragToggle = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function toggleDraggable()
    dragToggle = not dragToggle
    if not dragToggle then
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.Position = UDim2.new(0, button.Position.X.Offset, 0, button.Position.Y.Offset)
        if button:FindFirstChild("AnchorsConstraint") then
            button.AnchorsConstraint:Destroy()
        end
    end
end

button.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and dragToggle then
        dragStart = input.Position
        startPos = button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        updateInput(input)
    end
end)

toggleButton.MouseButton1Click:Connect(toggleDraggable)

button.MouseButton1Click:Connect(function()
local args = {
    [1] = game:GetService("Players").LocalPlayer
}

game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.ScreenGUI.HandGrenadeGUI.EnemyDamage:FireServer(unpack(args))
end)
end)

elseif placeId == chapter3PlaceId then
    print("Chapter 3")
    wait(1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Chapter 3",
        Text = "Loading...",
        Duration = 3
    })
    wait(2)

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Granny: Multiplayer - Free - 🧓🏿🏏", "Default")

local HighlightLib = {}

local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineTransparency = 0.5
local CoreGui = game:FindService("CoreGui")
local Workspace = game.Workspace
local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

HighlightLib.Models = {}
HighlightLib.Parts = {}

local function addNameTag(instance, name, color)
    local nameTag = Instance.new("BillboardGui")
    nameTag.Adornee = instance
    nameTag.Size = UDim2.new(0, 75, 0, 30)
    nameTag.StudsOffset = Vector3.new(0, 3, 0)
    nameTag.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0
    textLabel.Text = name
    textLabel.TextScaled = true
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextSize = 12
    textLabel.Parent = nameTag

    nameTag.Parent = instance
end

local function HighlightPart(name, fillColor, outlineColor)
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") then
            if object.Name:lower() == name:lower() then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = Storage
                Highlight.Adornee = object
                Highlight.FillColor = fillColor
                Highlight.DepthMode = DepthMode
                Highlight.FillTransparency = FillTransparency
                Highlight.OutlineColor = outlineColor
                Highlight.OutlineTransparency = OutlineTransparency
                addNameTag(object, name, outlineColor)
                table.insert(HighlightLib.Parts, {object, Highlight})
            end
        end
    end
end

local function HighlightModel(name, fillColor, outlineColor)
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name:lower() == name:lower() then
            local highlight = Instance.new("Highlight")
            highlight.Name = model.Name
            highlight.FillColor = fillColor
            highlight.DepthMode = DepthMode
            highlight.FillTransparency = FillTransparency
            highlight.OutlineColor = outlineColor
            highlight.OutlineTransparency = OutlineTransparency
            highlight.Parent = Storage
            highlight.Adornee = model
            table.insert(HighlightLib.Models, {model, highlight})
            addNameTag(model, model.Name, outlineColor)
            return
        end
    end
end

local function UpdateHighlights()
    for _, highlightedPart in pairs(HighlightLib.Parts) do
        local part, highlight = highlightedPart[1], highlightedPart[2]
        if part and part.Parent then
            highlight.Adornee = part
        else
            highlight:Destroy()
            table.remove(HighlightLib.Parts, _)
        end
    end

    for _, highlightedModel in pairs(HighlightLib.Models) do
        local model, highlight = highlightedModel[1], highlightedModel[2]
        if model and model.Parent then
            highlight.Adornee = model
        else
            highlight:Destroy()
            table.remove(HighlightLib.Models, _)
        end
    end
end

Workspace.DescendantAdded:Connect(function(instance)
    if instance:IsA("BasePart") or instance:IsA("Model") then
        UpdateHighlights()
    end
end)

HighlightLib.HighlightModel = function(name, fillColor, outlineColor)
    HighlightModel(name, fillColor, outlineColor)
end

HighlightLib.HighlightPart = function(name, fillColor, outlineColor)
    HighlightPart(name, fillColor, outlineColor)
end

local tab = DrRayLibrary.newTab("Chapter 3", "ImageIdHere")

tab.newLabel("Items")

local lighting = game.Lighting
local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

tab.newInput("Item", "Enter Item Name To Obtain", function(inputText)
    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find(inputText:lower()) then
                for _, presetName in ipairs(presets) do
                    local preset = workspace:FindFirstChild(presetName)
                    if preset then
                        local toolObject = preset:FindFirstChild(tool.Name)
                        if toolObject and toolObject:FindFirstChild("InteractRemote") then
                            local args = {
                                [1] = game:GetService("Players").LocalPlayer
                            }
                            toolObject.InteractRemote:FireServer(unpack(args))
                            wait(0.1)
                        end
                    end
                end
            end
        end
    else
        warn("Lighting not found.")
    end
end)

tab.newButton("Obtain Items", "Obtains Items", function()
    local lighting = game.Lighting
    local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") then
                for _, presetName in ipairs(presets) do
                    local preset = workspace:FindFirstChild(presetName)
                    if preset then
                        local toolObject = preset:FindFirstChild(tool.Name)
                        if toolObject and toolObject:FindFirstChild("InteractRemote") then
                            local args = {
                                [1] = game:GetService("Players").LocalPlayer
                            }
                            toolObject.InteractRemote:FireServer(unpack(args))
                            wait(0.1)
                        end
                    end
                end
            end
        end
    else
        warn("Please Don't Skid ;-;")
    end
end)

tab.newButton("Obtain Keys","Obtains Keys", function()
local lighting = game.Lighting
local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

if lighting then
    for _, tool in pairs(lighting:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:find("key") then
            for _, presetName in ipairs(presets) do
                local preset = workspace:FindFirstChild(presetName)
                if preset then
                    local toolObject = preset:FindFirstChild(tool.Name)
                    if toolObject and toolObject:FindFirstChild("InteractRemote") then
                        local args = {
                            [1] = game:GetService("Players").LocalPlayer
                        }
                        toolObject.InteractRemote:FireServer(unpack(args))
                        wait(0.1)
                    end
                end
            end
        end
    end
else
    warn("Please Don't Skid ;-;")
end
end)
tab.newLabel("Highlights")
tab.newButton("Highlight Granny", "Esp/Chams", function()
    HighlightLib.HighlightModel("Granny", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "Granny" then
            HighlightLib.HighlightModel("Granny", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
        end
    end)
end)
tab.newButton("Highlight Grandpa", "Esp/Chams", function()
    HighlightLib.HighlightModel("Grandpa", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "Grandpa" then
            HighlightLib.HighlightModel("Grandpa", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
        end
    end)
end)
tab.newButton("Highlight Slendrina", "Esp/Chams", function()
    HighlightLib.HighlightModel("Slendrina", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "Slendrina" then
            HighlightLib.HighlightModel("Slendrina", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
        end
    end)
end)

tab.newButton("Highlight Items", "Esp/Chams", function()
    local lighting = game.Lighting
    local presets = {"Preset1", "Preset2", "Preset3", "Preset4", "Preset5"}

    local toolNames = {}
    if lighting then
        for _, tool in pairs(lighting:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(toolNames, tool.Name)
            end
        end
    end

    local function highlightMatchingParts()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and table.find(toolNames, part.Name) then
                HighlightLib.HighlightPart(part.Name, Color3.fromRGB(0, 225, 0), Color3.fromRGB(0, 225, 0))
            end
        end
    end

    highlightMatchingParts()

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") and table.find(toolNames, descendant.Name) then
            HighlightLib.HighlightPart(descendant.Name, Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 225, 0))
        end
    end)
end)
tab.newLabel("Extra")
tab.newButton("Practice Mode","Practice Gamemode", function()
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Model") and object.Name == "Granny" then
        object:Destroy()
    end
end
wait(0.1)
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Model") and object.Name == "Grandpa" then
        object:Destroy()
    end
end
wait(0.1)
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Model") and object.Name == "Slendrina" then
        object:Destroy()
    end
end
end)
tab.newButton("Instant Interact","Proximity Prompt", function()
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
  fireproximityprompt(prompt)
end)
end)
tab.newButton("Remove Bear Traps","Removes Bear Trap Objects", function()
while true do
for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Part") and object.Name == "Close" then
        object:Destroy()
    end
end
wait(5)
end
end)
tab.newLabel("OP'S")

else
    warn("An Error Occured Please Report It In Our Server")
end