local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = workspace.CurrentCamera

local AnimateScript
for _, child in ipairs(Character:GetChildren()) do
    if child:IsA("LocalScript") and child:FindFirstChild("ScaleDampeningPercent") then 
        AnimateScript = child
        break
    end
end

local EventsFolder = ReplicatedStorage:FindFirstChild("Events", true)
local SellSkillEvent = EventsFolder and EventsFolder:FindFirstChild("SellSkill")
local UpdateParticlesEvent = EventsFolder and EventsFolder:FindFirstChild("UpdateItemParticles")
local PromptLikeEvent = EventsFolder and EventsFolder:FindFirstChild("PromptLike")

local AnimateObject = Character:FindFirstChild("Animate") 

local signalsToClear = {
    Humanoid:GetPropertyChangedSignal("Sit"),
    workspace:GetPropertyChangedSignal("Gravity"),
    workspace.ChildAdded,
    Humanoid:GetPropertyChangedSignal("HipHeight"),
    Humanoid:GetPropertyChangedSignal("MaxSlopeAngle"),
    Humanoid:GetPropertyChangedSignal("PlatformStand"),
    Humanoid:GetPropertyChangedSignal("WalkToPoint"),
    Humanoid:GetPropertyChangedSignal("WalkToPart"),
    Humanoid.StateEnabledChanged,
    Humanoid.StateChanged,
    CurrentCamera:GetPropertyChangedSignal("CameraSubject"),
    CurrentCamera:GetPropertyChangedSignal("FieldOfView"),
    Character.DescendantAdded,
    LocalPlayer.Backpack.ChildAdded,
    PlayerGui.ChildAdded,
    LogService.MessageOut,
    Character.AncestryChanged
}

if AnimateObject then 
    table.insert(signalsToClear, AnimateObject.Changed) 
end
if SellSkillEvent then 
    table.insert(signalsToClear, SellSkillEvent.Changed) 
end
if UpdateParticlesEvent then 
    table.insert(signalsToClear, UpdateParticlesEvent.Changed) 
end

local function clearSignalConnections(signal)
    if not getconnections or typeof(signal) ~= "RBXScriptSignal" then 
        return 
    end
    
    local connections = getconnections(signal)
    if connections then
        for _, connection in ipairs(connections) do
            if connection and connection.Enabled then
            pcall(connection.Disconnect, connection)
            end
        end
    end
end

for _, signal in ipairs(signalsToClear) do
    pcall(clearSignalConnections, signal)
end

task.spawn(function()
    task.wait(5)
    for _, mapName in pairs({"BattleMap", "CaveMap", "ChampionMap", "KOTHMap", "ArenaMap"}) do
        local mapInstance = workspace:FindFirstChild(mapName)
        if mapInstance and mapInstance:FindFirstChild("Cells") then
            for _, descendant in pairs(mapInstance.Cells:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    pcall(clearSignalConnections, descendant.AncestryChanged)
                    pcall(clearSignalConnections, descendant:GetPropertyChangedSignal("CanCollide"))
                    pcall(clearSignalConnections, descendant:GetPropertyChangedSignal("CollisionGroup"))
                end
            end
        end
    end
end)

local function emptyFunc(...) 
end

if getconnections and getconstants and getupvalues and setupvalue then
    local neutralizedCount = 0
    for _, connection in ipairs(getconnections(RunService.Heartbeat)) do
        local func = connection.Function
        if func and islclosure(func) and getfenv(func).script == AnimateScript then 
            local constants = getconstants(func)
            local hasPunishKeywords = false
            
            for _, keyword in ipairs({ "Noob!!", "Your soul has been shifted.", "Make sure to like and subscribe!", "Your soul has been deleted.", "coreerror:", 475456048 }) do 
                if table.find(constants, keyword) then
                    hasPunishKeywords = true
                    break
                end
            end

            if hasPunishKeywords then
                local upvaluesList = getupvalues(func)
                for i, upvalue in ipairs(upvaluesList) do
                    if typeof(upvalue) == "function" and islclosure(upvalue) then
                        local upvalueConstants = getconstants(upvalue)
                        local callsPromptLike = false
                        for _, const in ipairs(upvalueConstants) do
                            if typeof(const) == "Instance" and const:IsA("RemoteEvent") and const.Name == "PromptLike" then
                                callsPromptLike = true
                                break
                            end
                        end
                        
                        if callsPromptLike then
                            local success = setupvalue(func, i, emptyFunc)
                            if success then 
                                neutralizedCount = neutralizedCount + 1 
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end

if hookfunction then
    local oldKick
    oldKick = hookfunction(LocalPlayer.Kick, function(player, message)
        message = message or ""
        if string.find(message, "impressive exploit", 1, true) or string.find(message, "Ok%.%.%. You've got a pretty impressive exploit", 1, true) then
        return 
        end
        if string.find(message, "Cinnamon Spice offers!", 1, true) then
        return 
        end
        return oldKick(player, message) 
    end)
end

if hookmetamethod and SellSkillEvent then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(...)
        local args = {...}
        local selfInstance = table.remove(args, 1) 
        local method = getnamecallmethod()

        if method == "FireServer" and selfInstance == SellSkillEvent then
            if #args >= 1 and args[1] == false then 
                return nil
            else
                return oldNamecall(selfInstance, unpack(args)) 
            end
        end

        if method == "FireServer" and typeof(selfInstance) == "Instance" and selfInstance:IsA("RemoteEvent") then
            if (UpdateParticlesEvent and selfInstance == UpdateParticlesEvent) or (PromptLikeEvent and selfInstance == PromptLikeEvent) then
                local block = false
                
                if UpdateParticlesEvent and selfInstance == UpdateParticlesEvent and #args >= 2 and args[2] == 5 then 
                    block = true 
                elseif PromptLikeEvent and selfInstance == PromptLikeEvent and #args >= 1 and typeof(args[1]) == "string" then 
                    local reportMessage = args[1]
                    local acKeywords = {"OrbitalCannonPart", "something happened", "GUI Detected", "outputted:", "BREAKING NEWS", "abducted", "soul has been ripped", "clap your hands", "hands slipped", "Factory", "floor is down here", "Noob!!", "coreerror:", "Your soul has been shifted", "Make sure to like and subscribe", "Your soul has been deleted"}
                    
                    for _, keyword in ipairs(acKeywords) do
                        if string.find(reportMessage, keyword, 1, true) then
                            block = true
                            break
                        end
                    end
                end

                if block then
                    return nil 
                end
            end
        end

        return oldNamecall(selfInstance, unpack(args)) 
    end)
end

print("done")