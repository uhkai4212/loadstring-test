local function C_19c()
local script = DELTA["19c"];

----------------------------- Startup Configs (not important to change.) -----------------------------
local ts = game:GetService("TweenService")
local isTween = script.Parent.IsTween
--repeat until game:IsLoaded()
script.Parent.Home.Holder.Script:Destroy()

script.Parent.Scripthub.Popup.Visible = false
script.Parent.Scripthub.DarkOverlay.Visible = true
script.Parent.Scripthub.DarkOverlay.Transparency = 1
local UILib = require(script.Parent.UILibrary)


-- Actual Init stuffs

game.Players.LocalPlayer.Chatted:Connect(function(msg)
    if msg:match("/e sd") then
        
        if DELTA["1"].Enabled == true then
            DELTA["1"].Enabled = false
        elseif DELTA["Ui"] == true then
            DELTA["Ui"].Enabled = false
        end
    elseif msg:match("/e hd") then
        DELTA["1"].Enabled = false
    end
end)


---------------------------- Built-In configs ----------------------------
pcall(function() makefolder("DeltaConfigs") end)

UILib:AddTab()
UILib.Settings:AddSwitch("Auto Execute", "Toggle auto-execution of scripts in the autoexec folder", not isfile("disableautoexec"), function(state)

    if(state) then
        if(isfile("disableautoexec")) then
            delfile("disableautoexec")
        end
    else
        writefile("disableautoexec", "hi")
    end

end)

UILib.Settings:AddSwitch("Auto Close", "Toggle X button requirement to close popups", not isfile("preventautoclose"), function(state)

    if(state) then
        if(isfile("preventautoclose")) then
            delfile("preventautoclose")
        end
    else
        writefile("preventautoclose", "hi")
    end

end)

UILib.Settings:AddSwitch("Syn Env", "Uses Synapse X' naming standard", isfile("uses_syn"), function(state)

    if(state) then
        writefile("uses_syn", "hi")
        getgenv().syn = syn_backup
        
    else
        if(isfile("uses_syn")) then
            delfile("uses_syn")
            getgenv().syn = nil
        end
    end

end)

UILib.Settings:AddSwitch("Console", "Toggle roblox console logs in the GUI", isfile("useconsole"), function(state)

    if(state) then
        if(isfile("useconsole")) then
            delfile("useconsole")
        end
    else
        writefile("useconsole", "hi")
    end

end)

UILib.Settings:AddDropdown("FPS Cap", "Change the FPS cap for a smoother experience", "60 FPS", {"60 FPS", "120 FPS", "Max FPS"}, function(selection)
		if selection == "60 FPS" then
			setfpscap(60)
		elseif selection == "120 FPS" then
			setfpscap(120)
		elseif selection == "Max FPS" then
			setfpscap(getfpsmax())
		end
	end)

UILib.Settings:AddDropdown("Icon Size", "Change the floating Icon's size", readfile("iconsize"), {"Medium", "Small", "Large"}, function(selection)
		if selection == "Small" then
			DELTA["DaIcon"].Size = UDim2.new(0,30,0,30)
            writefile("iconsize", "Small")
		elseif selection == "Medium" then
			DELTA["DaIcon"].Size = UDim2.new(0,45,0,45)
            writefile("iconsize", "Medium")
		elseif selection == "Large" then
			DELTA["DaIcon"].Size = UDim2.new(0,60,0,60)
            writefile("iconsize", "Large")
		end
	end)

UILib.Settings:AddDropdown("Icon Shape", "Change the floating Icon's shape", readfile("iconshape"), {"Squircle", "Circle", "Square"}, function(selection)
		if selection == "Squircle" then
			DELTA["das"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);
            writefile("iconshape", "Squircle")
		elseif selection == "Circle" then
			DELTA["das"]["CornerRadius"] = UDim.new(0.50000000298023224, 0);
            writefile("iconshape", "Circle")
		elseif selection == "Square" then
			DELTA["das"]["CornerRadius"] = UDim.new(0, 0);
            writefile("iconshape", "Square")
		end
	end)

UILib.Settings:AddDropdown("Icon Color", "Change the floating Icon's color", readfile("iconcolor"), {"Blue", "Green", "Purple"}, function(selection)
		if selection == "Blue" then
            DELTA["daStroke"].Color = Color3.fromRGB(65, 169, 255)
            writefile("iconcolor", "Blue")
		elseif selection == "Green" then
            DELTA["daStroke"].Color = Color3.fromRGB(55, 219, 69)
            writefile("iconcolor", "Green")
		elseif selection == "Purple" then
            DELTA["daStroke"].Color = Color3.fromRGB(125, 65, 255)
            writefile("iconcolor", "Purple")
		end
	end)

UILib.Settings:AddButton("Join Discord", "Copies our discord invite", function()
        setclipboard("https://discord.gg/deltaexploits")
        end)  

UILib.Settings:AddButton("Rejoin", "Rejoins your current server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end)  

    UILib.Settings:AddButton("Small Server", "Joins a server with a low playercount", function()
        local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"

local _place = game.PlaceId
local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
function ListServers(cursor)
   local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
   return Http:JSONDecode(Raw)
end

local Server, Next; repeat
   local Servers = ListServers(Next)
   Server = Servers.data[1]
   Next = Servers.nextPageCursor
until Server

TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
        end)  

UILib.Settings:AddButton("Serverhop", "Teleport to a new server", function()
    local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end