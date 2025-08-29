if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().TranslationCounter = nil
Translations = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Translation/Translation.lua"))()
loadstring(game:HttpGet("https://pastefy.app/yavAjgX3/raw"))()
repeat task.wait() until TranslationCounter
if game.CoreGui:FindFirstChild("Country") then
    game.CoreGui:FindFirstChild("Country"):Destroy()
end
wait(0.3)
local Player = game.Players.LocalPlayer
game:GetService("UserInputService").JumpRequest:connect(function()
    if _G.InfiniteJump == true then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if _G.AutoSpeed == true then
        if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed or 50
        end
    end
end)
function CheckWall(Target)
    local Direction = (Target.Position - game.Workspace.CurrentCamera.CFrame.Position).unit * (Target.Position - game.Workspace.CurrentCamera.CFrame.Position).Magnitude
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, game.Workspace.CurrentCamera}
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local Result = game.Workspace:Raycast(game.Workspace.CurrentCamera.CFrame.Position, Direction, RaycastParams)
    return Result == nil or Result.Instance:IsDescendantOf(Target)
end
function PartLagDe(g)
    for i, v in pairs(_G.PartLag) do
        if g.Name:find(v) then
            g:Destroy()
        end
    end
end
workspace.DescendantAdded:Connect(function(v)
    if _G.AntiLag == true then
        if v:IsA("ForceField") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") then
            v:Destroy()
        end
        if v:IsA("BasePart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.BackSurface = "SmoothNoOutlines"
            v.BottomSurface = "SmoothNoOutlines"
            v.FrontSurface = "SmoothNoOutlines"
            v.LeftSurface = "SmoothNoOutlines"
            v.RightSurface = "SmoothNoOutlines"
            v.TopSurface = "SmoothNoOutlines"
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        end
    end
end)

local Name = "Ink Game"
function Translation(Section, Text)
    if TranslationCounter == "English" then
        return Text
    end
    local lang = Translations[TranslationCounter]
    if lang and lang[Name] and lang[Name][Section] and lang[Name][Section][Text] then
        return lang[Name][Section][Text]
    else
        return Text
    end
end