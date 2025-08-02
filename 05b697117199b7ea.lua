local httpService = cloneref(game:GetService("HttpService"));

local _tablefind = clonefunction(table.find);

local isA = clonefunction(game.IsA);

local GuiService = game:GetService("GuiService")

makefolder("d_android_script_dir")

if gethui():FindFirstChild("DeltaGui") then
    gethui():FindFirstChild("DeltaGui"):Destroy()
end



if not isfile("iconsize") then
    writefile("iconsize", "Medium")
end

if not isfile("iconshape") then
    writefile("iconshape", "Squircle")
end

if not isfile("iconcolor") then
    writefile("iconcolor", "Blue")
end


getgenv().syn_backup = syn

if not isfile("uses_syn") then
    getgenv().syn = nil
end

-- Go to near end line for configs.

--local executeclipboard = readclipboard_hideenv


getgenv().readclipboard_hideenv = nil

local DELTA = {};
getgenv().Vm9vaE59PzVBeTVNdyY4JDsieDglUzdwRDNabyExbjR1ezBmYHNNT2kjOXk = true



if gethui():FindFirstChild("Delta") then
    gethui():FindFirstChild("Delta"):Destroy()
end

-- StarterGui.Delta
DELTA["1"] = Instance.new("ScreenGui", gethui());
DELTA["1"]["Name"] = [[Delta]];
DELTA["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
DELTA["1"]["ResetOnSpawn"] = false;
DELTA["1"]["DisplayOrder"] = 10;
DELTA["1"].Enabled = false

-- Dis is for floating icon Players
DELTA["Ui"] = Instance.new("ScreenGui", gethui())
DELTA["Ui"].Enabled = false
DELTA["Ui"].Name = "DeltaIcon"

DELTA["DaIcon"] = Instance.new("ImageButton", DELTA["Ui"])

local iconsize = readfile("iconsize")
if iconsize == "Medium" then
    DELTA["DaIcon"].Size = UDim2.new(0,45,0,45)
elseif iconsize == "Small" then
    DELTA["DaIcon"].Size = UDim2.new(0,30,0,30)
elseif iconsize == "Large" then
    DELTA["DaIcon"].Size = UDim2.new(0,60,0,60)
else
    DELTA["DaIcon"].Size = UDim2.new(0,45,0,45)
end

local DaIconSize = DELTA["DaIcon"].Size
local ScreenCenterX = GuiService:GetScreenResolution().X / 2
local ScreenCenterY = GuiService:GetScreenResolution().Y / 2

local DaIconPositionX = ScreenCenterX - DaIconSize.X.Offset / 2
local DaIconPositionY = ScreenCenterY - DaIconSize.Y.Offset / 2
DELTA["DaIcon"].Position = UDim2.new(0, DaIconPositionX, 0, DaIconPositionY/20)
DELTA["DaIcon"].Draggable = true
DELTA["DaIcon"].Image = "rbxassetid://12730597972"
DELTA["DaIcon"].BackgroundColor3 = Color3.fromRGB(26, 28, 36)

DELTA["das"] = Instance.new("UICorner", DELTA["DaIcon"]);

local iconsize = readfile("iconshape")
if iconsize == "Squircle" then
    DELTA["das"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);
elseif iconsize == "Circle" then
    DELTA["das"]["CornerRadius"] = UDim.new(0.50000000298023224, 0);
elseif iconsize == "Square" then
    DELTA["das"]["CornerRadius"] = UDim.new(0, 0);
else
    DELTA["das"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);
end




DELTA["daStroke"] = Instance.new("UIStroke", DELTA["DaIcon"])
DELTA["daStroke"].Thickness = 2
DELTA["daStroke"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local iconsize = readfile("iconcolor")
if iconsize == "Blue" then
    DELTA["daStroke"].Color = Color3.fromRGB(65, 169, 255)
elseif iconsize == "Green" then
    DELTA["daStroke"].Color = Color3.fromRGB(55, 219, 69)
elseif iconsize == "Purple" then
    DELTA["daStroke"].Color = Color3.fromRGB(125, 65, 255)
else
    DELTA["daStroke"].Color = Color3.fromRGB(65, 169, 255)
end


-- StarterGui.Delta.KeySystem
DELTA["2"] = Instance.new("Frame", DELTA["1"]);
DELTA["2"]["BackgroundColor3"] = Color3.fromRGB(26, 28, 36);
DELTA["2"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["2"]["Size"] = UDim2.new(0.328000009059906, 0, 1.2, 0);
DELTA["2"]["Position"] = UDim2.new(1, 0, 0.5, 0);
DELTA["2"]["Visible"] = false;
DELTA["2"]["Name"] = [[KeySystem]];

-- StarterGui.Delta.KeySystem.Holder
DELTA["3"] = Instance.new("Frame", DELTA["2"]);
DELTA["3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["3"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["3"]["BackgroundTransparency"] = 1;
DELTA["3"]["Size"] = UDim2.new(1, 0, 1, 0);
DELTA["3"]["Position"] = UDim2.new(1, 0, 0.5, 0);
DELTA["3"]["Name"] = [[Holder]];

-- StarterGui.Delta.KeySystem.Holder.UIListLayout
DELTA["4"] = Instance.new("UIListLayout", DELTA["3"]);
DELTA["4"]["Padding"] = UDim.new(0.03999999910593033, 0);
DELTA["4"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- StarterGui.Delta.KeySystem.Holder.Title
DELTA["5"] = Instance.new("Frame", DELTA["3"]);
DELTA["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["5"]["BackgroundTransparency"] = 1;
DELTA["5"]["Size"] = UDim2.new(1, 0, 0.18677474558353424, 0);
DELTA["5"]["Name"] = [[Title]];

-- StarterGui.Delta.KeySystem.Holder.Title.UIListLayout
DELTA["6"] = Instance.new("UIListLayout", DELTA["5"]);
DELTA["6"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- StarterGui.Delta.KeySystem.Holder.Title.Title
DELTA["7"] = Instance.new("TextLabel", DELTA["5"]);
DELTA["7"]["TextWrapped"] = true;
DELTA["7"]["TextScaled"] = true;
DELTA["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DELTA["7"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DELTA["7"]["TextSize"] = 14;
DELTA["7"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["7"]["AnchorPoint"] = Vector2.new(0.5, 0);
DELTA["7"]["Size"] = UDim2.new(0.8398135900497437, 0, 0.4, 0);
DELTA["7"]["Text"] = [[Welcome back!]];
DELTA["7"]["Name"] = [[Title]];
DELTA["7"]["BackgroundTransparency"] = 1;
DELTA["7"]["Position"] = UDim2.new(0.4199067950248718, 0, 0, 0);

-- StarterGui.Delta.KeySystem.Holder.Title.Paragraph
DELTA["8"] = Instance.new("TextLabel", DELTA["5"]);
DELTA["8"]["TextWrapped"] = true;
DELTA["8"]["TextScaled"] = true;
DELTA["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DELTA["8"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
DELTA["8"]["TextSize"] = 14;
DELTA["8"]["TextColor3"] = Color3.fromRGB(115, 127, 152);
DELTA["8"]["AnchorPoint"] = Vector2.new(0.5, 1);
DELTA["8"]["Size"] = UDim2.new(0.8980631828308105, 0, 0.35361653566360474, 0);
DELTA["8"]["Text"] = [[Access Delta through completing the key system, doesn't take long!]];
DELTA["8"]["Name"] = [[Paragraph]];
DELTA["8"]["BackgroundTransparency"] = 1;
DELTA["8"]["Position"] = UDim2.new(0.4490315914154053, 0, 0.85361647605896, 0);

-- StarterGui.Delta.KeySystem.Holder.Input
DELTA["9"] = Instance.new("Frame", DELTA["3"]);
DELTA["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["9"]["BackgroundTransparency"] = 1;
DELTA["9"]["LayoutOrder"] = 1;
DELTA["9"]["Size"] = UDim2.new(1, 0, 0.13557736575603485, 0);
DELTA["9"]["Position"] = UDim2.new(0, 0, 0.22365736961364746, 0);
DELTA["9"]["Name"] = [[Input]];

-- StarterGui.Delta.KeySystem.Holder.Input.Title
DELTA["a"] = Instance.new("TextLabel", DELTA["9"]);
DELTA["a"]["TextWrapped"] = true;
DELTA["a"]["TextScaled"] = true;
DELTA["a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DELTA["a"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DELTA["a"]["TextSize"] = 14;
DELTA["a"]["TextColor3"] = Color3.fromRGB(129, 143, 164);
DELTA["a"]["AnchorPoint"] = Vector2.new(0.5, 0);
DELTA["a"]["Size"] = UDim2.new(0.6213776469230652, 0, 0.2623675465583801, 0);
DELTA["a"]["Text"] = [[Enter key]];
DELTA["a"]["Name"] = [[Title]];
DELTA["a"]["BackgroundTransparency"] = 1;
DELTA["a"]["Position"] = UDim2.new(0.3106888234615326, 0, -2.339766922432318e-07, 0);

-- StarterGui.Delta.KeySystem.Holder.Input.TextBox
DELTA["b"] = Instance.new("Frame", DELTA["9"]);
DELTA["b"]["BorderSizePixel"] = 0;
DELTA["b"]["BackgroundColor3"] = Color3.fromRGB(31, 37, 47);
DELTA["b"]["AnchorPoint"] = Vector2.new(0.5, 1);
DELTA["b"]["Size"] = UDim2.new(0.9975729584693909, 0, 0.6160375475883484, 0);
DELTA["b"]["Position"] = UDim2.new(0.49878647923469543, 0, 1, 0);
DELTA["b"]["Name"] = [[TextBox]];

-- StarterGui.Delta.KeySystem.Holder.Input.TextBox.Input
DELTA["c"] = Instance.new("TextBox", DELTA["b"]);
DELTA["c"]["Active"] = true;
DELTA["c"]["PlaceholderColor3"] = Color3.fromRGB(104, 120, 144);
DELTA["c"]["BorderSizePixel"] = 0;
DELTA["c"]["TextSize"] = 14;
DELTA["c"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DELTA["c"]["TextWrapped"] = true;
DELTA["c"]["TextScaled"] = true;
DELTA["c"]["BackgroundColor3"] = Color3.fromRGB(31, 37, 47);
DELTA["c"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["c"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
DELTA["c"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DELTA["c"]["BackgroundTransparency"] = 1;
DELTA["c"]["PlaceholderText"] = [[examplekey123$]];
DELTA["c"]["Size"] = UDim2.new(0.8865329027175903, 0, 0.5, 0);
DELTA["c"]["Selectable"] = false;
DELTA["c"]["Text"] = [[]];
DELTA["c"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
DELTA["c"]["Name"] = [[Input]];

-- StarterGui.Delta.KeySystem.Holder.Input.TextBox.UICorner
DELTA["d"] = Instance.new("UICorner", DELTA["b"]);
DELTA["d"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

-- StarterGui.Delta.KeySystem.Holder.Buttons
DELTA["e"] = Instance.new("Frame", DELTA["3"]);
DELTA["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["e"]["BackgroundTransparency"] = 1;
DELTA["e"]["LayoutOrder"] = 2;
DELTA["e"]["Size"] = UDim2.new(1, 0, 0.19585928320884705, 0);
DELTA["e"]["Position"] = UDim2.new(0, 0, 0.39611735939979553, 0);
DELTA["e"]["Name"] = [[Buttons]];

-- StarterGui.Delta.KeySystem.Holder.Buttons.Button1
DELTA["f"] = Instance.new("ImageButton", DELTA["e"]);
DELTA["f"]["Active"] = false;
DELTA["f"]["BorderSizePixel"] = 0;
DELTA["f"]["BackgroundColor3"] = Color3.fromRGB(60, 137, 196);
DELTA["f"]["Selectable"] = false;
DELTA["f"]["Size"] = UDim2.new(0.9975729584693909, 0, 0.43042951822280884, 0);
DELTA["f"]["Name"] = [[Button1]];
DELTA["f"]["BackgroundTransparency"] = 0.8799999952316284;

-- StarterGui.Delta.KeySystem.Holder.Buttons.Button1.UICorner
DELTA["10"] = Instance.new("UICorner", DELTA["f"]);
DELTA["10"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

-- StarterGui.Delta.KeySystem.Holder.Buttons.Button1.UIStroke
DELTA["11"] = Instance.new("UIStroke", DELTA["f"]);
DELTA["11"]["Color"] = Color3.fromRGB(60, 137, 196);
DELTA["11"]["Thickness"] = 2;

-- StarterGui.Delta.KeySystem.Holder.Buttons.Button1.Input
DELTA["12"] = Instance.new("TextLabel", DELTA["f"]);
DELTA["12"]["TextWrapped"] = true;
DELTA["12"]["BorderSizePixel"] = 0;
DELTA["12"]["TextScaled"] = true;
DELTA["12"]["BackgroundColor3"] = Color3.fromRGB(31, 37, 47);
DELTA["12"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DELTA["12"]["TextSize"] = 14;
DELTA["12"]["TextColor3"] = Color3.fromRGB(140, 206, 255);
DELTA["12"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DELTA["12"]["Size"] = UDim2.new(0.8865329027175903, 0, 0.5, 0);
DELTA["12"]["Text"] = [[Continue]];
DELTA["12"]["Name"] = [[Input]];
DELTA["12"]["BackgroundTransparency"] = 1;
DELTA["12"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

-- StarterGui.Delta.KeySystem.Holder.Buttons.Button2
DELTA["13"] = Instance.new("ImageButton", DELTA["e"]);
DELTA["13"]["Active"] = false;
DELTA["13"]["BorderSizePixel"] = 0;
DELTA["13"]["BackgroundColor3"] = Color3.fromRGB(31, 37, 47);
DELTA["13"]["Selectable"] = false;
DELTA["13"]["AnchorPoint"] = Vector2.new(0, 1);
DELTA["13"]["Size"] = UDim2.new(0.9975729584693909, 0, 0.4304293990135193, 0);
DELTA["13"]["Name"] = [[Button2]];
DELTA["13"]["Position"] = UDim2.new(0, 0, 0.9999996423721313, 0);

-- StarterGui.Delta.KeySystem.Holder.Buttons.Button2.UICorner
DELTA["14"] = Instance.new("UICorner", DELTA["13"]);
DELTA["14"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

-- StarterGui.Delta.KeySystem.Holder.Buttons.Button2.UIStroke
DELTA["15"] = Instance.new("UIStroke", DELTA["13"]);
DELTA["15"]["Color"] = Color3.fromRGB(31, 37, 47);
DELTA["15"]["Thickness"] = 2;

-- StarterGui.Delta.KeySystem.Holder.Buttons.Button2.Input
DELTA["16"] = Instance.new("TextLabel", DELTA["13"]);
DELTA["16"]["TextWrapped"] = true;
DELTA["16"]["BorderSizePixel"] = 0;
DELTA["16"]["TextScaled"] = true;
DELTA["16"]["BackgroundColor3"] = Color3.fromRGB(31, 37, 47);
DELTA["16"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DELTA["16"]["TextSize"] = 14;
DELTA["16"]["TextColor3"] = Color3.fromRGB(162, 191, 212);
DELTA["16"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DELTA["16"]["Size"] = UDim2.new(0.8865329027175903, 0, 0.5, 0);
DELTA["16"]["Text"] = [[Receive Key]];
DELTA["16"]["Name"] = [[Input]];
DELTA["16"]["BackgroundTransparency"] = 1;
DELTA["16"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

-- StarterGui.Delta.KeySystem.Holder.Message
DELTA["17"] = Instance.new("ImageLabel", DELTA["3"]);
DELTA["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["17"]["Image"] = [[rbxassetid://13363093418]];
DELTA["17"]["LayoutOrder"] = 3;
DELTA["17"]["Size"] = UDim2.new(1, 0, 0.13, 0);
DELTA["17"]["Name"] = [[Message]];
DELTA["17"]["BackgroundTransparency"] = 1;
DELTA["17"]["Position"] = UDim2.new(0, 0, 0.6288594007492065, 0);

-- StarterGui.Delta.KeySystem.Holder.Message.Paragraph
DELTA["18"] = Instance.new("TextLabel", DELTA["17"]);
DELTA["18"]["TextWrapped"] = true;
DELTA["18"]["TextScaled"] = true;
DELTA["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["18"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
DELTA["18"]["TextSize"] = 14;
DELTA["18"]["TextColor3"] = Color3.fromRGB(115, 127, 152);
DELTA["18"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DELTA["18"]["Size"] = UDim2.new(0.6844813227653503, 0, 0.4, 0);
DELTA["18"]["Text"] = [[Start exploiting when you complete our key system!]];
DELTA["18"]["Name"] = [[Paragraph]];
DELTA["18"]["BackgroundTransparency"] = 1;
DELTA["18"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

-- StarterGui.Delta.KeySystem.Holder.Button2
DELTA["19"] = Instance.new("ImageButton", DELTA["3"]);
DELTA["19"]["Active"] = false;
DELTA["19"]["BorderSizePixel"] = 0;
DELTA["19"]["BackgroundColor3"] = Color3.fromRGB(31, 37, 47);
DELTA["19"]["Selectable"] = false;
DELTA["19"]["LayoutOrder"] = 4;
DELTA["19"]["AnchorPoint"] = Vector2.new(0, 1);
DELTA["19"]["Size"] = UDim2.new(0.9975730180740356, 0, 0.08399911224842072, 0);
DELTA["19"]["Name"] = [[Button2]];
DELTA["19"]["Position"] = UDim2.new(0, 0, 0.9326172471046448, 0);

-- StarterGui.Delta.KeySystem.Holder.Button2.UICorner
DELTA["1a"] = Instance.new("UICorner", DELTA["19"]);
DELTA["1a"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

-- StarterGui.Delta.KeySystem.Holder.Button2.Input
DELTA["1b"] = Instance.new("TextButton", DELTA["19"]);
DELTA["1b"]["TextWrapped"] = true;
DELTA["1b"]["Active"] = false;
DELTA["1b"]["BorderSizePixel"] = 0;
DELTA["1b"]["AutoButtonColor"] = false;
DELTA["1b"]["TextScaled"] = true;
DELTA["1b"]["BackgroundColor3"] = Color3.fromRGB(31, 37, 47);
DELTA["1b"]["TextSize"] = 14;
DELTA["1b"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DELTA["1b"]["TextColor3"] = Color3.fromRGB(162, 191, 212);
DELTA["1b"]["Selectable"] = false;
DELTA["1b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DELTA["1b"]["Size"] = UDim2.new(0.8865329027175903, 0, 0.5, 0);
DELTA["1b"]["Name"] = [[Input]];
DELTA["1b"]["Text"] = [[Discord]];
DELTA["1b"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
DELTA["1b"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.KeySystem.Holder.Button2.UIStroke
DELTA["1c"] = Instance.new("UIStroke", DELTA["19"]);
DELTA["1c"]["Color"] = Color3.fromRGB(31, 37, 47);
DELTA["1c"]["Thickness"] = 2;

-- StarterGui.Delta.KeySystem.UIPadding
DELTA["1d"] = Instance.new("UIPadding", DELTA["2"]);
DELTA["1d"]["PaddingTop"] = UDim.new(0.05000000074505806, 0);
DELTA["1d"]["PaddingRight"] = UDim.new(0.15000000596046448, 0);
DELTA["1d"]["PaddingLeft"] = UDim.new(0.15000000596046448, 0);

-- StarterGui.Delta.KeySystem.ImageButton
DELTA["1e"] = Instance.new("ImageButton", DELTA["2"]);
DELTA["1e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["1e"]["AnchorPoint"] = Vector2.new(1, 0);
DELTA["1e"]["Image"] = [[rbxassetid://13363121645]];
DELTA["1e"]["Size"] = UDim2.new(0.07999999821186066, 0, 0.07999999821186066, 0);
DELTA["1e"]["Position"] = UDim2.new(1, 0, 0.02012072503566742, 0);
DELTA["1e"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.KeySystem.ImageButton.UIAspectRatioConstraint
DELTA["1f"] = Instance.new("UIAspectRatioConstraint", DELTA["1e"]);


-- StarterGui.Delta.KeySystem.Marker
DELTA["20"] = Instance.new("StringValue", DELTA["2"]);
DELTA["20"]["Value"] = [[Menu]];
DELTA["20"]["Name"] = [[Marker]];