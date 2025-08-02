script.Parent.ScriptHubWindow.CloseB.MouseButton1Click:connect(function()
		ScriptHubWindowOpen = false
		script.Parent.ScriptHubWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
	end)
	
	-- Settings Window
	
	script.Parent.SettingsWindow.CloseB.MouseButton1Click:connect(function()
		SettingsWindowOpen = false
		script.Parent.SettingsWindow:TweenPosition(UDim2.new(1,200,0.5,-20), "Out", "Quint", 1, true)
	end)
	
	-- Scrolling Frame Canvas Adjuster
	-- Credits: https://devforum.roblox.com/t/have-uilistlayout-set-the-canvassize-property-of-scrollingframes-automatically/76287
	
	script.Parent.ScriptHubWindow.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		script.Parent.ScriptHubWindow.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,script.Parent.ScriptHubWindow.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	end)
	
	script.Parent.ScriptListWindow.ScriptListFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		script.Parent.ScriptListWindow.ScriptListFrame.CanvasSize = UDim2.new(0,0,0,script.Parent.ScriptListWindow.ScriptListFrame.UIListLayout.AbsoluteContentSize.Y)
	end)
	
	script.Parent.SettingsWindow.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		script.Parent.SettingsWindow.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,script.Parent.SettingsWindow.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	end)
	
	script.Parent.SidebarFrame.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		script.Parent.SidebarFrame.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,script.Parent.SidebarFrame.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	end)
	
	-- Username Setting
	-- From: https://www.youtube.com/watch?v=e4nBaHjr5Hw
	-- dunno how to make one myself l0l
	
	local plrAvatar, isReady = game:GetService("Players"):GetUserThumbnailAsync(game:GetService("Players").LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
	
	script.Parent.SidebarFrame.ScrollingFrame.UsernamePlace.Title.Text = "Hello!\n"..game:GetService("Players").LocalPlayer.Name
	script.Parent.SidebarFrame.ScrollingFrame.UsernamePlace.Icon.ProfileImage.Image = plrAvatar
	
	
end
coroutine.wrap(UENDBFZ_fake_script)()
local function KEARIL_fake_script() -- ScriptHubWindow.ScriptBloxCode 
	local script = Instance.new('LocalScript', ScriptHubWindow)

	ChosenColor = "#1890ff"
	local page = 1
	local searchstring = "a"
	
	if isfile("theme_vegax_color.txt") == true then
		ChosenColor = readfile("theme_vegax_color.txt")
	end
	
	local httpService = game:GetService("HttpService");
	local content = {};
	
	local scriptBlox = {
		host = "https://scriptblox.com"
	}
	--[[
	
	function scriptBlox:loadImage(path, id)
		if not isfolder("ScriptBlox") then
			makefolder("ScriptBlox");
		end
	
		local fileName = "ScriptBlox/" .. id .. ".webp";
		local data = http_request({
			Url = scriptBlox.host .. path,
			Method = "GET"
		});
	
		if data.Success then
			writefile(fileName, data.Body);
	        return getcustomasset(fileName);
	    else
	        return "";
		end
	end
	
	function scriptBlox:loadImage(gameId)
		local thumbnailUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. tostring(gameId) .. "&width=420&height=420&format=png"
	
		local success, imageData = pcall(function()
			return http_request({
				Url = thumbnailUrl,
				Method = "GET"
			})
		end)
	
		if success and imageData.Success then
			local thumbnailId = game:GetService("ContentProvider"):PreloadAsync({ imageData.Body })
			return thumbnailId
		else
			warn("Failed to load image for game ID:", gameId)
			return ""
		end
	end
	
	]]
	
	--[[
	function scriptBlox:GET(path)
		local result = http_request({
			Url = scriptBlox.host .. path,
			Method = "GET"
		})
	
		if result.Success then
			local status, data = pcall(function()
				return httpService:JSONDecode(result.Body)
			end)
	
			if status then
				return data.result.scripts
			else
				warn("Error decoding JSON:", data)
				return {
					result = {
						totalPages = 1,
						scripts = {}
					}
				}
			end
		else
			warn("HTTP request failed:", result.StatusCode, result.Body)
			return {
				result = {
					totalPages = 1,
					scripts = {}
				}
			}
		end
	end
	
	]]
	
	function scriptBlox:GET(path)
		local result = http_request({
			Url = scriptBlox.host .. path,
			Method = "GET"
		})
	
		if result.Success then
			local status, data = pcall(function()
				return httpService:JSONDecode(result.Body)
			end)
	
			if status and data and data.result and data.result.scripts then
				return data.result.scripts
			else
				warn("Error decoding JSON:", data)
			end
		else
			warn("HTTP request failed:", result.StatusCode, result.Body)
		end
	
		-- Return a default value in case of error or missing data
		return {
			result = {
				totalPages = 1,
				scripts = {}
			}
		}
	end
	
	
	function scriptBlox:getScripts(searchQuery, page, maxResults)
		local path = "/api/script/search?q=" .. searchQuery .. "&mode=free&max=" .. tostring(maxResults) .. "&page=" .. tostring(page);
		local data = scriptBlox:GET(path);
		
		return data;
	end
	
	function Create_Script_Rectangle(title, subtitle, gamingid, scripttext)
		local S1 = Instance.new("Frame")
		local Execute = Instance.new("ImageButton")
		local UICorner = Instance.new("UICorner")
		local UICorner_2 = Instance.new("UICorner")
		local ImageLabel = Instance.new("ImageLabel")
		local UICorner_3 = Instance.new("UICorner")
		local SubTitle = Instance.new("TextLabel")
		local Title = Instance.new("TextLabel")
	
		--Properties:
	
		S1.Name = "S1"
		S1.Parent = ScrollingFrame_2
		S1.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
		S1.BorderSizePixel = 0
		S1.Size = UDim2.new(1, -10, 0, 80)
	
		Execute.Name = "Execute"
		Execute.Parent = S1
		Execute.AnchorPoint = Vector2.new(1, 0.5)
		Execute.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
		Execute.BackgroundTransparency = 0.400
		Execute.BorderSizePixel = 0
		Execute.LayoutOrder = 10
		Execute.Position = UDim2.new(1, -23, 0.5, 0)
		Execute.Size = UDim2.new(0, 34, 0, 34)
		Execute.ZIndex = 2
		Execute.Image = "rbxassetid://3926307971"
		Execute.ImageRectOffset = Vector2.new(764, 244)
		Execute.ImageRectSize = Vector2.new(36, 36)
		Execute.MouseButton1Click:Connect(function()
			executecode(scripttext)
		end)
	
		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = Execute
	
		UICorner_2.CornerRadius = UDim.new(0, 10)
		UICorner_2.Parent = S1
	
		ImageLabel.Parent = S1
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Size = UDim2.new(1, 0, 1, 0)
		ImageLabel.Image = "https://assetgame.roblox.com/Game/Tools/ThumbnailAsset.ashx?aid="..gamingid.."&fmt=png&wd=420&ht=420"
		ImageLabel.ScaleType = Enum.ScaleType.Crop
	
		UICorner_3.CornerRadius = UDim.new(0, 10)
		UICorner_3.Parent = ImageLabel
	
		SubTitle.Name = "SubTitle"
		SubTitle.Parent = S1
		SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SubTitle.BackgroundTransparency = 1.000
		SubTitle.BorderSizePixel = 0
		SubTitle.Position = UDim2.new(0, 25, 0.5, 0)
		SubTitle.Size = UDim2.new(1, -93, 0.5, 0)
		SubTitle.Font = Enum.Font.Gotham
		SubTitle.Text = subtitle
		SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		SubTitle.TextSize = 14.000
		SubTitle.TextXAlignment = Enum.TextXAlignment.Left
		SubTitle.TextYAlignment = Enum.TextYAlignment.Top
	
		Title.Name = "Title"
		Title.Parent = S1
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0, 25, 0, 0)
		Title.Size = UDim2.new(1, -93, 0.5, 0)
		Title.Font = Enum.Font.GothamBold
		Title.Text = title
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 19.000
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.TextYAlignment = Enum.TextYAlignment.Bottom
	
		table.insert(content, S1);
	end
	
	function Clear() -- Clears the script list
		for _, element in pairs(content) do
			element:Destroy();
		end
	
		content = {};