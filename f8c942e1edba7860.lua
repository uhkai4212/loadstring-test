--task.wait(.2)
    script.Parent.Home.Popup.Visible = false

    else
        script.Parent.Home.Popup.Visible = false
    end
    local tw2 = ts:Create(script.Parent.Home.DarkOverlay, TweenInfo.new(.15), {
        Transparency = 1
    })
    tw2:Play()
    tw2.Completed:Wait()
    script.Parent.Home.DarkOverlay.Visible = false
    end)
script.Parent.Home.Popup.Add.MouseButton1Click:Connect(function()
    UILib.SavedScripts:Add(script.Parent.Home.Popup.Title.TextBox.Text, script.Parent.Home.Popup.Source.TextBox.Text)
    writefile("d_android_script_dir/" .. script.Parent.Home.Popup.Title.TextBox.Text, script.Parent.Home.Popup.Source.TextBox.Text)

    if(not isfile("preventautoclose")) then
        script.Parent.Home.DarkOverlay.Visible = false
        script.Parent.Home.Popup.Visible = false
    end

    end)

script.Parent.Home.Searchbar.Button.MouseButton1Click:Connect(function()
    UILib.SavedScripts:OpenPopup()
    end)

script.Parent.Home.Searchbar.Input:GetPropertyChangedSignal("Text"):Connect(function()
    for i,v in pairs(script.Parent.Home.Holder:GetChildren()) do
    if v:IsA("ImageLabel") then
    if string.find(string.lower(v.Title.Text),string.lower(script.Parent.Home.Searchbar.Input.Text)) then
    v.Visible = true
    else
        v.Visible = false
    end
    end
    end
    if script.Parent.Home.Searchbar.Input.Text == "" then
    for i,v in pairs(script.Parent.Home.Holder:GetChildren()) do
    if v:IsA("ImageLabel") then
    v.Visible = true
    end
    end
    end
    end)

end;
task.spawn(C_19c);



local LOADER = {};


local GuiService2 = game:GetService("GuiService")

-- LOADERLoadingScreen
LOADER["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
LOADER["1"]["IgnoreGuiInset"] = true;
LOADER["1"]["Enabled"] = false;
LOADER["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
LOADER["1"]["Name"] = [[LOADERLoadingScreen]];
LOADER["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
LOADER["1"]["ResetOnSpawn"] = false;

-- LOADERLoadingScreen.DarkOverlay
LOADER["2"] = Instance.new("Frame", LOADER["1"]);
LOADER["2"]["ZIndex"] = -100;
LOADER["2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
LOADER["2"]["BackgroundTransparency"] = 0.6600000262260437;
LOADER["2"]["Size"] = UDim2.new(2, 0, 2, 0);
LOADER["2"]["Position"] = UDim2.new(-1, 0, -1, 0);
LOADER["2"]["Name"] = [[DarkOverlay]];

-- LOADERLoadingScreen.MainFrame
LOADER["3"] = Instance.new("ImageLabel", LOADER["1"]);
LOADER["3"].BorderSizePixel = 0;
LOADER["3"].ScaleType = Enum.ScaleType.Crop;
LOADER["3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255);
LOADER["3"].Image = "rbxassetid://13387419794";
LOADER["3"].LayoutOrder = 10;
LOADER["3"].Size = UDim2.new(0.32863849401474, 0, 0.31259891390800476, 0);
LOADER["3"].BorderColor3 = Color3.fromRGB(0, 0, 0);
LOADER["3"].Name = "MainFrame";

local DaIconSize = LOADER["3"].Size
local ScreenCenterX = GuiService2:GetScreenResolution().X / 2
local ScreenCenterY = GuiService2:GetScreenResolution().Y / 2

local DaIconPositionX = ScreenCenterX - DaIconSize.X.Offset / 2
local DaIconPositionY = ScreenCenterY - DaIconSize.Y.Offset / 2
LOADER["3"].Position = UDim2.new(0, DaIconPositionX, 0, DaIconPositionY/20)


-- LOADERLoadingScreen.MainFrame.UICorner
LOADER["4"] = Instance.new("UICorner", LOADER["3"]);
LOADER["4"]["CornerRadius"] = UDim.new(0.07000000029802322, 0);

-- LOADERLoadingScreen.MainFrame.Overlay
LOADER["5"] = Instance.new("ImageLabel", LOADER["3"]);
LOADER["5"]["BackgroundColor3"] = Color3.fromRGB(26, 27, 36);
LOADER["5"]["Image"] = [[rbxassetid://13387657138]];
LOADER["5"]["LayoutOrder"] = 10;
LOADER["5"]["Size"] = UDim2.new(1, 0, 1, 0);
LOADER["5"]["Name"] = [[Overlay]];
LOADER["5"]["BackgroundTransparency"] = 0.800000011920929;

-- LOADERLoadingScreen.MainFrame.Overlay.UICorner
LOADER["6"] = Instance.new("UICorner", LOADER["5"]);
LOADER["6"]["CornerRadius"] = UDim.new(0.07000000029802322, 0);

-- LOADERLoadingScreen.MainFrame.Overlay.Title
LOADER["7"] = Instance.new("TextLabel", LOADER["5"]);
LOADER["7"]["TextWrapped"] = true;
LOADER["7"]["TextScaled"] = true;
LOADER["7"]["BackgroundColor3"] = Color3.fromRGB(118, 192, 255);
LOADER["7"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LOADER["7"]["TextSize"] = 14;
LOADER["7"]["TextColor3"] = Color3.fromRGB(203, 244, 255);
LOADER["7"]["AnchorPoint"] = Vector2.new(0, 0.5);
LOADER["7"]["Size"] = UDim2.new(0.6451469659805298, 0, 0.1418459564447403, 0);
LOADER["7"]["Text"] = [[Please wait a while!]];
LOADER["7"]["Name"] = [[Title]];
LOADER["7"]["BackgroundTransparency"] = 1;
LOADER["7"]["Position"] = UDim2.new(0.1773512363433838, 0, 0.4073548913002014, 0);

-- LOADERLoadingScreen.MainFrame.Overlay.Desc
LOADER["8"] = Instance.new("TextLabel", LOADER["5"]);
LOADER["8"]["TextWrapped"] = true;
LOADER["8"]["TextScaled"] = true;
LOADER["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LOADER["8"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
LOADER["8"]["TextSize"] = 14;
LOADER["8"]["TextColor3"] = Color3.fromRGB(199, 220, 255);
LOADER["8"]["AnchorPoint"] = Vector2.new(0, 0.5);
LOADER["8"]["Size"] = UDim2.new(0.8879498243331909, 0, 0.1277613639831543, 0);
LOADER["8"]["Text"] = [[We are currently setting everything up for you]];
LOADER["8"]["Name"] = [[Desc]];
LOADER["8"]["BackgroundTransparency"] = 1;
LOADER["8"]["Position"] = UDim2.new(0.06185942143201828, 0, 0.5393086075782776, 0);

-- LOADERLoadingScreen.MainFrame.DropShadowHolder
LOADER["9"] = Instance.new("Frame", LOADER["3"]);
LOADER["9"]["ZIndex"] = 0;
LOADER["9"]["BorderSizePixel"] = 0;
LOADER["9"]["BackgroundTransparency"] = 1;
LOADER["9"]["Size"] = UDim2.new(1, 0, 1, 0);
LOADER["9"]["Name"] = [[DropShadowHolder]];

-- LOADERLoadingScreen.MainFrame.DropShadowHolder.DropShadow
LOADER["a"] = Instance.new("ImageLabel", LOADER["9"]);
LOADER["a"]["ZIndex"] = 0;
LOADER["a"]["BorderSizePixel"] = 0;
LOADER["a"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
LOADER["a"]["ScaleType"] = Enum.ScaleType.Slice;
LOADER["a"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
LOADER["a"]["ImageTransparency"] = 0.699999988079071;
LOADER["a"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
LOADER["a"]["Image"] = [[rbxassetid://6014261993]];
LOADER["a"]["Size"] = UDim2.new(1, 47, 1, 47);
LOADER["a"]["Name"] = [[DropShadow]];
LOADER["a"]["BackgroundTransparency"] = 1;
LOADER["a"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

-- LOADERLoadingScreen.MainFrame.UIAspectRatioConstraint
LOADER["b"] = Instance.new("UIAspectRatioConstraint", LOADER["3"]);
LOADER["b"]["AspectRatio"] = 1.8712739944458008;

-- LOADERLoadingScreen.LoadingModule
LOADER["c"] = Instance.new("ModuleScript", LOADER["1"]);
LOADER["c"]["Name"] = [[LoadingModule]];


-- Require LOADER wrapper
local LOADER_REQUIRE = require;
local LOADER_MODULES = {};
local function require(Module:ModuleScript)
    local ModuleState = LOADER_MODULES[Module];
    if ModuleState then
        if not ModuleState.Required then
            ModuleState.Required = true;
            ModuleState.Value = ModuleState.Closure();
        end
        return ModuleState.Value;
    end;
    return LOADER_REQUIRE(Module);
end

LOADER_MODULES[LOADER["c"]] = {
    Closure = function()
        local script = LOADER["c"];
        local lib = {}

        local tweenserv = game:GetService("TweenService")
        local frame = script.Parent.MainFrame
        local DarkOverlay = script.Parent.DarkOverlay

        local isLoading = false
        local delayz = 0.6

        local function TextFadeLoop()
            local title = frame.Overlay.Title
            local desc = frame.Overlay.Desc

            local timeToFade = 1

            local titleStart = tweenserv:Create(title, TweenInfo.new(timeToFade, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.8})
            local titleEnd = tweenserv:Create(title, TweenInfo.new(timeToFade, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})

            local descStart = tweenserv:Create(desc, TweenInfo.new(timeToFade, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.8})
            local descEnd = tweenserv:Create(desc, TweenInfo.new(timeToFade, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})

            while isLoading == true do
                titleStart:Play()
                descStart:Play()
                titleStart.Completed:Wait()
                titleEnd:Play()
                descEnd:Play()
                titleEnd.Completed:Wait()
            end
        end

        function lib:Start()
            isLoading = true

            script.Parent.Enabled = true
            frame.Position = UDim2.new(0.336, 0, -0.372, 0)
            DarkOverlay.Transparency = 1

            local tw1 = tweenserv:Create(frame, TweenInfo.new(delayz, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.336, 0, 0.322, 0)})
            local tw2 = tweenserv:Create(DarkOverlay, TweenInfo.new(delayz, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.66})
            tw1:Play()
            tw2:Play()
            tw2.Completed:Wait()
            TextFadeLoop()
        end

        function lib:End()
            isLoading = false

            DarkOverlay.Transparency = 1

            local tw1 = tweenserv:Create(frame, TweenInfo.new(delayz, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.336, 0, -0.372, 0)})
            local tw2 = tweenserv:Create(DarkOverlay, TweenInfo.new(delayz, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
            tw1:Play()
            tw2:Play()
        end

        return lib
    end;
}

getgenv().rLib = require(LOADER["c"])

-- Create a coroutine to run the loading animation asynchronously
coroutine.wrap(function()
    getgenv().rLib:Start()
end)()


function whitelist()
    local username = game.Players.LocalPlayer.Name
    local response = game:HttpGet("https://whitelist.deltaexploits.net/api/whitelisted?username=" .. username)
    local success, data = pcall(function()
        return game:GetService('HttpService'):JSONDecode(response)
    end)
    if success and data and data["data"] and data["data"]["whitelisted"] == true then
        --print("whitelisted")
        writefile("dsigfiureikuger.txt", "WHITELIST")
        GrantAccess()
        return true
    end
    return false
end

function boost_whitelist()
    local username = game.Players.LocalPlayer.Name
    local response = game:HttpGet("https://deltafunny.dosware.repl.co/checkKey/" .. username)
    if string.find(response, "cock_cock_cock") then
        writefile("dsigfiureikuger.txt", "BOOST")
        GrantAccess()
        return true
    end
    return false
end





if not isfile("dsigfiureikuger.txt") then
    writefile("dsigfiureikuger.txt", "hi")
end




function checkkey()

    local savedkey = readfile("dsigfiureikuger.txt")

	local keyless = "true"
	if string.find(keyless, "true") then
		GrantAccess()
        return true
	end

    if Verify() then
        GrantAccess()
        return true
    end

    if(savedkey == "WHITELIST") then
        if whitelist() then
            GrantAccess()
            return true
        end
    end
    
    if(savedkey == "ALYSSE") then
            GrantAccess()
            return true
    end

    if(savedkey == "BOOST") then
        if boost_whitelist() then
            GrantAccess()
            return true
        end
    end

end


coroutine.wrap(function()
    --print("starting up")
	local bool = checkkey()
    
    -- This is being ran when no saved key is found
    if not bool then
        --print("no valid key")
        wait(1)
	    getgenv().rLib:End()
        DELTA["1"].Enabled = true
        StartUp()
    else
        DELTA["1"].Enabled = true
    end
end)()

return DELTA["1"], require;