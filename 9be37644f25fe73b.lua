local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local camera = workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")
local debrisService = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Disable or enabled what you want
local isFlingEnabled = true
local antiGrabEnabled = true

-- SuperThrow
local flingStrengthValue = 200
-- Change value to your preferred strength
-------------------------------------
function ThrowFunction()
    local humanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
    
    workspace.ChildAdded:Connect(function(model)
        if model.Name == "GrabParts" then
            local grabPart = model["GrabPart"]["WeldConstraint"].Part1
            
            if grabPart then
                model:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not model.Parent and isFlingEnabled then
                        userInputService.InputBegan:Connect(function(input, chat)
                            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                                local bodyVelocity = Instance.new("BodyVelocity", grabPart)
                                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                bodyVelocity.Velocity = camera.CFrame.lookVector * flingStrengthValue
                                debrisService:AddItem(bodyVelocity, 1)
                            end
                        end)
                    end
                end)
            end
        end
    end)
end

local function AntiGrab()
    while antiGrabEnabled and task.wait() do
        if localPlayer.IsHeld.Value then
                while localPlayer.IsHeld.Value do
                    ReplicatedStorage.CharacterEvents.Struggle:FireServer(localPlayer)
                    task.wait(0.01) 
                end
            end
        end
    end

ThrowFunction()
if antiGrabEnabled then
    AntiGrab()
end