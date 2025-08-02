DELTA["6d"] = Instance.new("StringValue", DELTA["3b"]);
DELTA["6d"]["Value"] = [[Menu]];
DELTA["6d"]["Name"] = [[Marker]];

-- StarterGui.Delta.Settings
DELTA["6e"] = Instance.new("Frame", DELTA["1"]);
DELTA["6e"]["ZIndex"] = 100;
DELTA["6e"]["BackgroundColor3"] = Color3.fromRGB(255, 0, 0);
DELTA["6e"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DELTA["6e"]["BackgroundTransparency"] = 1;
DELTA["6e"]["Size"] = UDim2.new(0.8064976334571838, 0, 0.9616625905036926, 0);
DELTA["6e"]["Position"] = UDim2.new(0.47783252596855164, 0, 0.5, 0);
DELTA["6e"]["Visible"] = false;
DELTA["6e"]["Name"] = [[Settings]];

-- StarterGui.Delta.Settings.Searchbar
DELTA["6f"] = Instance.new("Frame", DELTA["6e"]);
DELTA["6f"]["ZIndex"] = 2;
DELTA["6f"]["BackgroundColor3"] = Color3.fromRGB(38, 41, 50);
DELTA["6f"]["AnchorPoint"] = Vector2.new(1, 0);
DELTA["6f"]["Size"] = UDim2.new(0.7300000190734863, 0, 0.12585513293743134, 0);
DELTA["6f"]["Position"] = UDim2.new(1, 0, 0, 0);
DELTA["6f"]["Name"] = [[Searchbar]];

-- StarterGui.Delta.Settings.Searchbar.UICorner
DELTA["70"] = Instance.new("UICorner", DELTA["6f"]);
DELTA["70"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

-- StarterGui.Delta.Settings.Searchbar.ImageLabel
DELTA["71"] = Instance.new("ImageLabel", DELTA["6f"]);
DELTA["71"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["71"]["AnchorPoint"] = Vector2.new(0, 0.5);
DELTA["71"]["Image"] = [[rbxassetid://13365156882]];
DELTA["71"]["Size"] = UDim2.new(0.025552265346050262, 0, 0.40771156549453735, 0);
DELTA["71"]["BackgroundTransparency"] = 1;
DELTA["71"]["Position"] = UDim2.new(0.01834862306714058, 0, 0.5, 0);

-- StarterGui.Delta.Settings.Searchbar.ImageLabel.UIAspectRatioConstraint
DELTA["72"] = Instance.new("UIAspectRatioConstraint", DELTA["71"]);


-- StarterGui.Delta.Settings.Searchbar.Input
DELTA["73"] = Instance.new("TextBox", DELTA["6f"]);
DELTA["73"]["Active"] = true;
DELTA["73"]["TextSize"] = 14;
DELTA["73"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DELTA["73"]["TextWrapped"] = true;
DELTA["73"]["TextScaled"] = true;
DELTA["73"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["73"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["73"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
DELTA["73"]["AnchorPoint"] = Vector2.new(0, 0.5);
DELTA["73"]["BackgroundTransparency"] = 1;
DELTA["73"]["PlaceholderText"] = [[Search for options]];
DELTA["73"]["Size"] = UDim2.new(0.8766564130783081, 0, 0.35361653566360474, 0);
DELTA["73"]["Selectable"] = false;
DELTA["73"]["Text"] = [[]];
DELTA["73"]["Position"] = UDim2.new(0.061162080615758896, 0, 0.49999991059303284, 0);
DELTA["73"]["Name"] = [[Input]];

-- StarterGui.Delta.Settings.Searchbar.SettingsSearchHandler
DELTA["74"] = Instance.new("LocalScript", DELTA["6f"]);
DELTA["74"]["Name"] = [[SettingsSearchHandler]];

-- StarterGui.Delta.Settings.Sort
DELTA["75"] = Instance.new("Frame", DELTA["6e"]);
DELTA["75"]["ZIndex"] = 2;
DELTA["75"]["BackgroundColor3"] = Color3.fromRGB(24, 25, 33);
DELTA["75"]["Size"] = UDim2.new(0.25, 0, 0.12585513293743134, 0);
DELTA["75"]["Name"] = [[Sort]];

-- StarterGui.Delta.Settings.Sort.UICorner
DELTA["76"] = Instance.new("UICorner", DELTA["75"]);
DELTA["76"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

-- StarterGui.Delta.Settings.Sort.UIListLayout
DELTA["77"] = Instance.new("UIListLayout", DELTA["75"]);
DELTA["77"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
DELTA["77"]["FillDirection"] = Enum.FillDirection.Horizontal;
DELTA["77"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
DELTA["77"]["Padding"] = UDim.new(0.029999999329447746, 0);
DELTA["77"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- StarterGui.Delta.Settings.Sort.Enabled
DELTA["78"] = Instance.new("TextButton", DELTA["75"]);
DELTA["78"]["TextWrapped"] = true;
DELTA["78"]["TextScaled"] = true;
DELTA["78"]["BackgroundColor3"] = Color3.fromRGB(51, 56, 70);
DELTA["78"]["TextSize"] = 14;
DELTA["78"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DELTA["78"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["78"]["Size"] = UDim2.new(0.27783116698265076, 0, 0.5168541073799133, 0);
DELTA["78"]["LayoutOrder"] = 1;
DELTA["78"]["Name"] = [[Enabled]];
DELTA["78"]["Text"] = [[Enabled]];
DELTA["78"]["Position"] = UDim2.new(0.02489338628947735, 0, 0.24157275259494781, 0);
DELTA["78"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Settings.Sort.Enabled.UICorner
DELTA["79"] = Instance.new("UICorner", DELTA["78"]);
DELTA["79"]["CornerRadius"] = UDim.new(1, 0);

-- StarterGui.Delta.Settings.Sort.Enabled.UIPadding
DELTA["7a"] = Instance.new("UIPadding", DELTA["78"]);
DELTA["7a"]["PaddingTop"] = UDim.new(0.30000001192092896, 0);
DELTA["7a"]["PaddingBottom"] = UDim.new(0.30000001192092896, 0);

-- StarterGui.Delta.Settings.Sort.Disabled
DELTA["7b"] = Instance.new("TextButton", DELTA["75"]);
DELTA["7b"]["TextWrapped"] = true;
DELTA["7b"]["TextScaled"] = true;
DELTA["7b"]["BackgroundColor3"] = Color3.fromRGB(51, 56, 70);
DELTA["7b"]["TextSize"] = 14;
DELTA["7b"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DELTA["7b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["7b"]["Size"] = UDim2.new(0.2778310179710388, 0, 0.5168541073799133, 0);
DELTA["7b"]["LayoutOrder"] = 2;
DELTA["7b"]["Name"] = [[Disabled]];
DELTA["7b"]["Text"] = [[Disabled]];
DELTA["7b"]["Position"] = UDim2.new(0.33081313967704773, 0, 0.24157275259494781, 0);
DELTA["7b"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Settings.Sort.Disabled.UICorner
DELTA["7c"] = Instance.new("UICorner", DELTA["7b"]);
DELTA["7c"]["CornerRadius"] = UDim.new(1, 0);

-- StarterGui.Delta.Settings.Sort.Disabled.UIPadding
DELTA["7d"] = Instance.new("UIPadding", DELTA["7b"]);
DELTA["7d"]["PaddingTop"] = UDim.new(0.30000001192092896, 0);
DELTA["7d"]["PaddingBottom"] = UDim.new(0.30000001192092896, 0);

-- StarterGui.Delta.Settings.Sort.All
DELTA["7e"] = Instance.new("TextButton", DELTA["75"]);
DELTA["7e"]["TextWrapped"] = true;
DELTA["7e"]["TextScaled"] = true;
DELTA["7e"]["BackgroundColor3"] = Color3.fromRGB(51, 56, 70);
DELTA["7e"]["TextSize"] = 14;
DELTA["7e"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DELTA["7e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["7e"]["Size"] = UDim2.new(0.2778310179710388, 0, 0.5168541073799133, 0);
DELTA["7e"]["LayoutOrder"] = 3;
DELTA["7e"]["Name"] = [[All]];
DELTA["7e"]["Text"] = [[All]];
DELTA["7e"]["Position"] = UDim2.new(0.6367325186729431, 0, 0.24157275259494781, 0);

-- StarterGui.Delta.Settings.Sort.All.UICorner
DELTA["7f"] = Instance.new("UICorner", DELTA["7e"]);
DELTA["7f"]["CornerRadius"] = UDim.new(1, 0);

-- StarterGui.Delta.Settings.Sort.All.UIPadding
DELTA["80"] = Instance.new("UIPadding", DELTA["7e"]);
DELTA["80"]["PaddingTop"] = UDim.new(0.30000001192092896, 0);
DELTA["80"]["PaddingBottom"] = UDim.new(0.30000001192092896, 0);

-- StarterGui.Delta.Settings.Sort.SettingsFilterHandler
DELTA["81"] = Instance.new("LocalScript", DELTA["75"]);
DELTA["81"]["Name"] = [[SettingsFilterHandler]];

-- StarterGui.Delta.Settings.Holder
DELTA["82"] = Instance.new("ScrollingFrame", DELTA["6e"]);
DELTA["82"]["CanvasSize"] = UDim2.new(0, 0, 4, 0);
DELTA["82"]["ScrollBarImageTransparency"] = 1;
DELTA["82"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["82"]["AnchorPoint"] = Vector2.new(0.5, 1);
DELTA["82"]["BackgroundTransparency"] = 1;
DELTA["82"]["Size"] = UDim2.new(1, 0, 0.8416813015937805, 0);
DELTA["82"]["Selectable"] = false;
DELTA["82"]["ScrollBarThickness"] = 1;
DELTA["82"]["Position"] = UDim2.new(0.5, 0, 1.0000001192092896, 0);
DELTA["82"]["Name"] = [[Holder]];

-- StarterGui.Delta.Settings.Holder.UIListLayout
DELTA["83"] = Instance.new("UIListLayout", DELTA["82"]);
DELTA["83"]["Padding"] = UDim.new(0.004999999888241291, 0);
DELTA["83"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- StarterGui.Delta.Settings.Marker
DELTA["84"] = Instance.new("StringValue", DELTA["6e"]);
DELTA["84"]["Value"] = [[Menu]];
DELTA["84"]["Name"] = [[Marker]];

-- StarterGui.Delta.DarkOverlay
DELTA["85"] = Instance.new("Frame", DELTA["1"]);
DELTA["85"]["ZIndex"] = -100;
DELTA["85"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
DELTA["85"]["BackgroundTransparency"] = 0.6600000262260437;
DELTA["85"]["Size"] = UDim2.new(2, 0, 2, 0);
DELTA["85"]["Position"] = UDim2.new(-1, 0, -1, 0);
DELTA["85"]["Name"] = [[DarkOverlay]];

-- StarterGui.Delta.Executor
DELTA["86"] = Instance.new("Frame", DELTA["1"]);
DELTA["86"]["ZIndex"] = 100;
DELTA["86"]["BackgroundColor3"] = Color3.fromRGB(255, 0, 0);
DELTA["86"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DELTA["86"]["BackgroundTransparency"] = 1;
DELTA["86"]["Size"] = UDim2.new(0.8397729992866516, 0, 0.7730588316917419, 0);
DELTA["86"]["Position"] = UDim2.new(0.4824247360229492, 0, 0.524213433265686, 0);
DELTA["86"]["Visible"] = false;
DELTA["86"]["Name"] = [[Executor]];

-- StarterGui.Delta.Executor.Executor
DELTA["87"] = Instance.new("ImageLabel", DELTA["86"]);
DELTA["87"]["BorderSizePixel"] = 0;
DELTA["87"]["ScaleType"] = Enum.ScaleType.Crop;
DELTA["87"]["BackgroundColor3"] = Color3.fromRGB(36, 0, 0);
DELTA["87"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["87"]["Image"] = [[rbxassetid://13387419794]];
DELTA["87"]["Size"] = UDim2.new(0.6566376686096191, 0, 0.9981886148452759, 0);
DELTA["87"]["ClipsDescendants"] = true;
DELTA["87"]["Name"] = [[Executor]];
DELTA["87"]["Position"] = UDim2.new(1.0000001192092896, 0, 0.5, 0);

-- StarterGui.Delta.Executor.Executor.Overlay
DELTA["88"] = Instance.new("ImageLabel", DELTA["87"]);
DELTA["88"]["BackgroundColor3"] = Color3.fromRGB(26, 27, 36);
DELTA["88"]["Image"] = [[rbxassetid://13387657138]];
DELTA["88"]["Size"] = UDim2.new(1, 0, 1, 0);
DELTA["88"]["Name"] = [[Overlay]];
DELTA["88"]["BackgroundTransparency"] = 0.800000011920929;

-- StarterGui.Delta.Executor.Executor.Overlay.UICorner
DELTA["89"] = Instance.new("UICorner", DELTA["88"]);
DELTA["89"]["CornerRadius"] = UDim.new(0.05000000074505806, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu
DELTA["8a"] = Instance.new("ImageButton", DELTA["88"]);
DELTA["8a"]["ZIndex"] = 1000;
DELTA["8a"]["BorderSizePixel"] = 0;
DELTA["8a"]["BackgroundColor3"] = Color3.fromRGB(22, 22, 30);
DELTA["8a"]["AnchorPoint"] = Vector2.new(1, 0);
DELTA["8a"]["Image"] = [[rbxassetid://0]];
DELTA["8a"]["Size"] = UDim2.new(0.06392838805913925, 0, 0.08036314696073532, 0);
DELTA["8a"]["Name"] = [[Menu]];
DELTA["8a"]["Position"] = UDim2.new(0.9912378787994385, 0, 0.026684332638978958, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.ImageButton
DELTA["8b"] = Instance.new("ImageButton", DELTA["8a"]);
DELTA["8b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["8b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DELTA["8b"]["Image"] = [[rbxassetid://13387875723]];
DELTA["8b"]["Size"] = UDim2.new(0.0789814367890358, 0, 0.4144761860370636, 0);
DELTA["8b"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
DELTA["8b"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.UICorner
DELTA["8c"] = Instance.new("UICorner", DELTA["8a"]);
DELTA["8c"]["CornerRadius"] = UDim.new(1, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.UIAspectRatioConstraint
DELTA["8d"] = Instance.new("UIAspectRatioConstraint", DELTA["8a"]);


-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown
DELTA["8e"] = Instance.new("Frame", DELTA["8a"]);
DELTA["8e"]["BackgroundColor3"] = Color3.fromRGB(41, 44, 52);
DELTA["8e"]["Size"] = UDim2.new(4.045529842376709, 0, 2.321711778640747, 0);
DELTA["8e"]["Position"] = UDim2.new(-3.045860767364502, 0, 1.093127965927124, 0);
DELTA["8e"]["Visible"] = false;
DELTA["8e"]["Name"] = [[Dropdown]];

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.UIListLayout
DELTA["8f"] = Instance.new("UIListLayout", DELTA["8e"]);
DELTA["8f"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
DELTA["8f"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
DELTA["8f"]["Padding"] = UDim.new(0.029999999329447746, 0);
DELTA["8f"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option1
DELTA["90"] = Instance.new("ImageButton", DELTA["8e"]);
DELTA["90"]["BackgroundColor3"] = Color3.fromRGB(59, 139, 254);
DELTA["90"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["90"]["Image"] = [[rbxassetid://0]];
DELTA["90"]["Size"] = UDim2.new(0.8604854345321655, 0, 0.22047363221645355, 0);
DELTA["90"]["Name"] = [[Option1]];
DELTA["90"]["Position"] = UDim2.new(0.9302427172660828, 0, 0.276297390460968, 0);
DELTA["90"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option1.UICorner
DELTA["91"] = Instance.new("UICorner", DELTA["90"]);
DELTA["91"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option1.Title
DELTA["92"] = Instance.new("TextLabel", DELTA["90"]);
DELTA["92"]["TextWrapped"] = true;
DELTA["92"]["ZIndex"] = 999999999;
DELTA["92"]["TextScaled"] = true;
DELTA["92"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["92"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DELTA["92"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
DELTA["92"]["TextSize"] = 14;
DELTA["92"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["92"]["AnchorPoint"] = Vector2.new(0, 0.5);
DELTA["92"]["Size"] = UDim2.new(0.7953082323074341, 0, 0.8179191946983337, 0);
DELTA["92"]["Text"] = [[Default]];
DELTA["92"]["Name"] = [[Title]];
DELTA["92"]["BackgroundTransparency"] = 1;
DELTA["92"]["Position"] = UDim2.new(0, 0, 0.5, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option1.Checked
DELTA["93"] = Instance.new("ImageButton", DELTA["90"]);
DELTA["93"]["BackgroundColor3"] = Color3.fromRGB(59, 139, 254);
DELTA["93"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["93"]["Image"] = [[rbxassetid://13441695981]];
DELTA["93"]["Size"] = UDim2.new(0.0812797099351883, 0, 0.5769613981246948, 0);
DELTA["93"]["Name"] = [[Checked]];
DELTA["93"]["Position"] = UDim2.new(1, 0, 0.5, 0);
DELTA["93"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option1.Checked.UIAspectRatioConstraint
DELTA["94"] = Instance.new("UIAspectRatioConstraint", DELTA["93"]);


-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Divider
DELTA["95"] = Instance.new("Frame", DELTA["8e"]);
DELTA["95"]["BackgroundColor3"] = Color3.fromRGB(59, 63, 74);
DELTA["95"]["Size"] = UDim2.new(0.8604854345321655, 0, 0.012410691007971764, 0);
DELTA["95"]["Position"] = UDim2.new(0.06975728273391724, 0, 0.4001886248588562, 0);
DELTA["95"]["Name"] = [[Divider]];

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option2
DELTA["96"] = Instance.new("ImageButton", DELTA["8e"]);
DELTA["96"]["BackgroundColor3"] = Color3.fromRGB(59, 139, 254);
DELTA["96"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["96"]["Image"] = [[rbxassetid://0]];
DELTA["96"]["Size"] = UDim2.new(0.8604854345321655, 0, 0.22047372162342072, 0);
DELTA["96"]["Name"] = [[Option2]];
DELTA["96"]["Position"] = UDim2.new(0.9302427172660828, 0, 0.5364913940429688, 0);
DELTA["96"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option2.UICorner
DELTA["97"] = Instance.new("UICorner", DELTA["96"]);
DELTA["97"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option2.Title
DELTA["98"] = Instance.new("TextLabel", DELTA["96"]);
DELTA["98"]["TextWrapped"] = true;
DELTA["98"]["ZIndex"] = 999999999;
DELTA["98"]["TextScaled"] = true;
DELTA["98"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["98"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DELTA["98"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
DELTA["98"]["TextSize"] = 14;
DELTA["98"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["98"]["AnchorPoint"] = Vector2.new(0, 0.5);
DELTA["98"]["Size"] = UDim2.new(0.7953082323074341, 0, 0.8179191946983337, 0);
DELTA["98"]["Text"] = [[Light]];
DELTA["98"]["Name"] = [[Title]];
DELTA["98"]["BackgroundTransparency"] = 1;
DELTA["98"]["Position"] = UDim2.new(0, 0, 0.5, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option2.Checked
DELTA["99"] = Instance.new("ImageButton", DELTA["96"]);
DELTA["99"]["BackgroundColor3"] = Color3.fromRGB(59, 139, 254);
DELTA["99"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["99"]["Image"] = [[rbxassetid://13441695981]];
DELTA["99"]["Size"] = UDim2.new(0.0812797099351883, 0, 0.5769613981246948, 0);
DELTA["99"]["Name"] = [[Checked]];
DELTA["99"]["Visible"] = false;
DELTA["99"]["Position"] = UDim2.new(1, 0, 0.5, 0);
DELTA["99"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option2.Checked.UIAspectRatioConstraint
DELTA["9a"] = Instance.new("UIAspectRatioConstraint", DELTA["99"]);


-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Divider
DELTA["9b"] = Instance.new("Frame", DELTA["8e"]);
DELTA["9b"]["BackgroundColor3"] = Color3.fromRGB(59, 63, 74);
DELTA["9b"]["Size"] = UDim2.new(0.8604854345321655, 0, 0.012410691007971764, 0);
DELTA["9b"]["Position"] = UDim2.new(0.06975728273391724, 0, 0.6603825688362122, 0);
DELTA["9b"]["Name"] = [[Divider]];

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option3
DELTA["9c"] = Instance.new("ImageButton", DELTA["8e"]);
DELTA["9c"]["BackgroundColor3"] = Color3.fromRGB(59, 139, 254);
DELTA["9c"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["9c"]["Image"] = [[rbxassetid://0]];
DELTA["9c"]["Size"] = UDim2.new(0.8604854345321655, 0, 0.2204737514257431, 0);
DELTA["9c"]["Name"] = [[Option3]];
DELTA["9c"]["Position"] = UDim2.new(0.9302427172660828, 0, 0.7966850399971008, 0);
DELTA["9c"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option3.UICorner
DELTA["9d"] = Instance.new("UICorner", DELTA["9c"]);
DELTA["9d"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option3.Title
DELTA["9e"] = Instance.new("TextLabel", DELTA["9c"]);
DELTA["9e"]["TextWrapped"] = true;
DELTA["9e"]["ZIndex"] = 999999999;
DELTA["9e"]["TextScaled"] = true;
DELTA["9e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["9e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DELTA["9e"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
DELTA["9e"]["TextSize"] = 14;
DELTA["9e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DELTA["9e"]["AnchorPoint"] = Vector2.new(0, 0.5);
DELTA["9e"]["Size"] = UDim2.new(0.7953082323074341, 0, 0.8179191946983337, 0);
DELTA["9e"]["Text"] = [[Amoled]];
DELTA["9e"]["Name"] = [[Title]];
DELTA["9e"]["BackgroundTransparency"] = 1;
DELTA["9e"]["Position"] = UDim2.new(0, 0, 0.5, 0);

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option3.Checked
DELTA["9f"] = Instance.new("ImageButton", DELTA["9c"]);
DELTA["9f"]["BackgroundColor3"] = Color3.fromRGB(59, 139, 254);
DELTA["9f"]["AnchorPoint"] = Vector2.new(1, 0.5);
DELTA["9f"]["Image"] = [[rbxassetid://13441695981]];
DELTA["9f"]["Size"] = UDim2.new(0.0812797099351883, 0, 0.5769613981246948, 0);
DELTA["9f"]["Name"] = [[Checked]];
DELTA["9f"]["Visible"] = false;
DELTA["9f"]["Position"] = UDim2.new(1, 0, 0.5, 0);
DELTA["9f"]["BackgroundTransparency"] = 1;

-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.Option3.Checked.UIAspectRatioConstraint
DELTA["a0"] = Instance.new("UIAspectRatioConstraint", DELTA["9f"]);


-- StarterGui.Delta.Executor.Executor.Overlay.Menu.Dropdown.UICorner
DELTA["a1"] = Instance.new("UICorner", DELTA["8e"]);
DELTA["a1"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);