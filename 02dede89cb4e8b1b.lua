local function C_21()
local script = DELTA["21"];
local buttons = script.Parent.Holder
local KeyInput = buttons.Input.TextBox.Input
local tweenserv = game:GetService("TweenService")
local istween = script.Parent.Parent.IsTween

repeat

until game:IsLoaded()
getgenv().StartUp = function()


script.Parent.Visible = true
local twinfo = TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
if istween.Value == true then
script.Parent.Position = UDim2.new(1.3, 0, 0.5 ,0)
local tween = tweenserv:Create(script.Parent, twinfo, {
    Position = UDim2.new(1, 0,.5, 0)})
tween:Play()
end
--tween.Completed:Wait()

end
StartUp()

getgenv().is_unlocked = false

getgenv().GrantAccess = function()
    getgenv().rLib:End()
    DELTA["Ui"].Enabled = false
    if(not isfile("is_versx_beta")) then
		writefile("is_versx_beta", "true")
		wait()
	end
    getgenv().is_unlocked = true
    if istween.Value == true then
        -- tween closing key sys
        local twinfo = TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = tweenserv:Create(script.Parent, twinfo, {Position = UDim2.new(1.3, 0, 0.5 ,0)})
        tween:Play()
        tween.Completed:Wait()
        script.Parent.Visible = false
        task.wait(.1)
        -- tween open main menu
        script.Parent.Parent.Sidebar.Position = UDim2.new(1.078, 0,0.474, 0)
        script.Parent.Parent.Sidebar.Visible = true
        local twinfo2 = TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween2 = tweenserv:Create(script.Parent.Parent.Sidebar, twinfo2, {Position = UDim2.new(1, 0,0.474, 0)})
        tween2:Play()
    else
        script.Parent.Visible = false
        script.Parent.Parent.Sidebar.Visible = true
    end

    if(not isfile("disableautoexec")) then
        runautoexec()
    end
end
local visiblelists = {}
visiblelists.Home = false
visiblelists.Executor = false
visiblelists.Scripthub = false
visiblelists.Settings = false
visiblelists.Console = false

function OpenDelta()
    for i,v in pairs(script.Parent.Parent:GetChildren()) do
        if v:FindFirstChild("Marker") then
            if v.Marker.Value == "Menu" then
                v.Visible = visiblelists[v.Name]
            end
        end
    end

    script.Parent.Parent.Sidebar.Position = UDim2.new(1.078, 0,0.474, 0)
    script.Parent.Parent.Sidebar.Visible = true
    local twinfo = TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenMenu = tweenserv:Create(script.Parent.Parent.Sidebar, twinfo, {Position = UDim2.new(1, 0,0.474, 0)})
    
    script.Parent.Parent.DarkOverlay.Transparency = 1
    script.Parent.Parent.DarkOverlay.Visible = true
    local tweenBg = tweenserv:Create(script.Parent.Parent.DarkOverlay, TweenInfo.new(.25), {Transparency = .5})

    tweenMenu:Play()
    tweenBg:Play()
end

function CloseDelta()

    for i,v in pairs(script.Parent.Parent:GetChildren()) do
        if v:FindFirstChild("Marker") then
            if v.Marker.Value == "Menu" then
                visiblelists[v.Name] = v.Visible
                v.Visible = false
            end
        end
    end

    script.Parent.Parent.Sidebar.Position = UDim2.new(1, 0,0.474, 0)
    script.Parent.Parent.Sidebar.Visible = true
    local twinfo = TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenMenu = tweenserv:Create(script.Parent.Parent.Sidebar, twinfo, {Position = UDim2.new(1.078, 0,0.474, 0)})
    
    script.Parent.Parent.DarkOverlay.Transparency = .5
    script.Parent.Parent.DarkOverlay.Visible = true
    local tweenBg = tweenserv:Create(script.Parent.Parent.DarkOverlay, TweenInfo.new(.25), {Transparency = 1})

    tweenMenu:Play()
    tweenBg:Play()
    tweenBg.Completed:Wait()
    DELTA["Ui"].Enabled = true
end

-- Discord
buttons.Button2.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/Wu9tFvVFaB")
    end)





if gethui():FindFirstChild("DeltaGui") then
    gethui():FindFirstChild("DeltaGui"):Destroy()
end



local AccountId = 8;


function GetLink()
    return string.format("https://gateway.platoboost.com/a/%i?id=%i", AccountId, game:GetService("Players").LocalPlayer.UserId);
end

local rateLimit = false;
local rateLimitCountdown = 0;
local errorWait = false;

function Verify()
    local key = KeyInput.Text;

    if errorWait or rateLimit then 
        return false
    end;

    DELTA["18"]["Text"] = "Checking key...";

    local response = request({
        Url = "https://api1.platoboost.com/v1/public/whitelist/8/" .. game:GetService("Players").LocalPlayer.UserId .. "?s",
        Method = "GET"
    })

    if response.StatusCode == 200 then
        if string.find(response.Body, "true") then
            DELTA["18"]["Text"] = "Successfully whitelisted key!";
            return true
        else
            if (#key > 0) then
                local redeemResponse = request({
                    Url = "https://api1.platoboost.com/v1/authenticators/redeem/8/" .. game:GetService("Players").LocalPlayer.UserId .. "/" .. key,
                    Method = "POST"
                });

                if redeemResponse.StatusCode == 200 then
                    if string.find(redeemResponse.Body, "true") then
                        DELTA["18"]["Text"] = "Successfully redeemed key!";
                        return true
                    end
                end           
            end
            DELTA["18"]["Text"] = "Invalid key detected, please try again!";
            return false
        end
    elseif response.StatusCode == 204 then
		DELTA["18"]["Text"] = "Invalid key detected, please try again!";
        return false;
    elseif response.StatusCode == 429 then
        if not rateLimit then 
            rateLimit = true
            rateLimitCountdown = 10
            task.spawn(function() 
                --cloudflare limits for 10seconds.
                while rateLimit do
                    DELTA["18"]["Text"] = "You are being rate-limited, please slow down. Try again in " .. rateLimitCountdown .. " seconds.";
                    wait(1)
                    rateLimitCountdown = rateLimitCountdown - 1;
                    
                    if rateLimitCountdown < 0 then
                        rateLimit = false;
                        rateLimitCountdown = 0;
                        DELTA["18"]["Text"] = "Rate limit is over, please try again.";
                    end
                end
            end) 
        end
    elseif response.StatusCode == 500 then
        errorWait = true
        task.spawn(function() 
            DELTA["18"]["Text"] = "An error has occured in the server, please wait 3 seconds and try again.";
            wait(3) 
            errorWait = false 
        end)
    end
end



-- Continue
buttons.Buttons.Button1.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    
    
    -- whitelist test
    if key == "WHITELIST" then
        whitelist()
    elseif string.find(key, "BOOST") then
        boost_whitelist()
    end

    if Verify() then
        GrantAccess()
    end
end)


-- Get Key
buttons.Buttons.Button2.MouseButton1Click:Connect(function()
    setclipboard(GetLink())
    buttons.Buttons.Button2.Input.Text = "Copied Link"
    end)

-- Close
script.Parent.ImageButton.MouseButton1Click:Connect(function()
    gethui().Delta.Enabled = false
    end)
end;
task.spawn(C_21);

local function C_39()
local script = DELTA["39"]
local buttons = script.Parent
local inactivecolor = buttons.InactiveColor
local activecolor = buttons.ActiveColor
local ts = game.TweenService
local isTween = script.Parent.Parent.IsTween

for i, v in pairs(buttons:GetChildren()) do
    if v:IsA("ImageButton") then
        if v.Name ~= "ToggleUI" then
            originalPos = script.Parent.Parent[v.Name].Position
        end
        v.MouseButton1Click:Connect(function()
            if v.Name == "ToggleUI" then
                
                CloseDelta()
            elseif v.Name ~= "ToggleUI" then
                for _, btns in pairs(buttons:GetChildren()) do
                    if btns:IsA("ImageButton") and btns.Name ~= "ToggleUI" then
                        if btns.Name ~= v.Name then
                            ts:Create(btns.ImageLabel, TweenInfo.new(.3), {
                                ImageColor3 = Color3.fromRGB(137, 144, 163)
                            }):Play()
                            ts:Create(btns, TweenInfo.new(.3), {
                                BackgroundColor3 = inactivecolor.Value
                            }):Play()
                            script.Parent.Parent[btns.Name].Visible = false
                            if isTween.Value == true then
                                ts:Create(script.Parent.Parent[btns.Name], TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                                    Position = UDim2.new(.4, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset)
                                }):Play()
                            end
                        else
                            ts:Create(btns.ImageLabel, TweenInfo.new(.3), {
                                ImageColor3 = Color3.fromRGB(255, 255, 255)
                            }):Play()
                            ts:Create(btns, TweenInfo.new(.3), {
                                BackgroundColor3 = activecolor.Value
                            }):Play()
                            script.Parent.Parent[btns.Name].Visible = true
                            if isTween.Value == true then
                                script.Parent.Parent[btns.Name].Position = UDim2.new(.4, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset)
                                ts:Create(script.Parent.Parent[btns.Name], TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                                    Position = originalPos
                                }):Play()
                            end
                        end
                    end
                end
            end
        end)
    end
end

end

task.spawn(C_39)



DELTA["DaIcon"].MouseButton1Click:Connect(function()
    if(getgenv().is_unlocked) then
        OpenDelta()
    end
    
    DELTA["1"].Enabled = true
    DELTA["Ui"].Enabled = false
end)

DELTA["1e"].MouseButton1Click:Connect(function()
    DELTA["1"].Enabled = false
    DELTA["Ui"].Enabled = true
end)