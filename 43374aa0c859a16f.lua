local function C_122()
local script = DELTA["122"];
local ScriptSuggestion = script.Parent
local uilib = require(script.Parent.Parent.Parent.Parent.UILibrary)
getgenv().is_iy = false


ScriptSuggestion.Overlay.Holder.Showcase.MouseButton1Click:Connect(function()
    print("showcase clicked")
    loadstring(game:HttpGet("https://gist.githubusercontent.com/lxnnydev/c533c374ca4c1dcef4e1e10e33fa4a0c/raw/03e74f184f801dad77d3ebe1e2f18c6ac87ca612/delta___IY.gistfile1.txt.lua",true))()

    end)
end;
task.spawn(C_122);
-- StarterGui.Delta.Executor.Sidemenu.Network.NetworkStatsHandler
local function C_131()
local script = DELTA["131"];
local Network = script.Parent
local localplr = game:GetService("Players").LocalPlayer

-- Get players in real-time
local function GetPlrs()
return #game.Players:GetPlayers()
end
local function SetTextForPlr()
Network.Overlay.Holder.Information.Players.Text = "<font color=\"#4FA4F2\">" .. tostring(GetPlrs()) .. "</font> players"
end
SetTextForPlr()

game.Players.PlayerAdded:Connect(function()
    SetTextForPlr()
    end)
game.Players.PlayerAdded:Connect(function()
    SetTextForPlr()
    end)

-- Get Real time ping
local function GetPing()
return localplr:GetNetworkPing()
end


local RunService = game:GetService("RunService")
local FpsLabel = Network.Overlay.Holder.Information.Memory
local TimeFunction = RunService:IsRunning() and time or os.clock

local LastIteration, Start
local FrameUpdateTable = {}

local function HeartbeatUpdate()
    LastIteration = TimeFunction()
    for Index = #FrameUpdateTable, 1, -1 do
        FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
    end

    FrameUpdateTable[1] = LastIteration

    local elapsedTime = TimeFunction() - Start
    local updateInterval = 1 -- Update interval in seconds (e.g., 0.5 or 1)
    if elapsedTime >= updateInterval then
        FpsLabel.Text = "<font color=\"#4FA4F2\">"..tostring(math.floor(#FrameUpdateTable / elapsedTime)) .. "</font> FPS"
        Start = TimeFunction()
    end
end

Start = TimeFunction()
RunService.Heartbeat:Connect(HeartbeatUpdate)



end;
task.spawn(C_131);