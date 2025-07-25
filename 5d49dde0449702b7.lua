local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Gui = player:WaitForChild("PlayerGui")

-- إعدادات السكربت
local CLICK_DELAY = 0.2  -- التأخير بين الضغطات
local WAIT_DELAY = 1     -- التأخير عند غياب الزر
local ENABLED = false    -- التفعيل يتم عن طريق التوقل

-- دالة للتحقق من إمكانية الضغط على الزرار
local function canClick(btn)
	return btn and btn.Visible and btn.AbsoluteSize.Magnitude > 10
end

-- دالة للتحقق من أن العنصر مرئي فعلياً
local function isActuallyVisible(obj)
	if not obj then return false end
	local current = obj
	while current and current ~= Gui do
		local success, result = pcall(function()
			return current.Visible
		end)
		if success and not result then
			return false
		end
		current = current.Parent
	end
	return obj.AbsoluteSize.Magnitude > 10
end

-- دالة للضغط على الزر
local function clickButton(btn)
	if not btn then return false end
	local pos = btn.AbsolutePosition
	local size = btn.AbsoluteSize
	local inset = GuiService:GetGuiInset()
	local x = pos.X + size.X / 2
	local y = pos.Y + size.Y / 2 + inset.Y

	VIM:SendMouseMoveEvent(x, y, game)
	task.wait(0.05)
	VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
	task.wait(0.05)
	VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)

	return true
end

-- دالة للبحث عن الزرار بالاسم
local function findButton(parent, buttonName)
	if not parent then return nil end
	local function searchRecursive(obj)
		if obj.Name == buttonName and obj:IsA("GuiButton") then
			return obj
		end
		for _, child in pairs(obj:GetChildren()) do
			local result = searchRecursive(child)
			if result then return result end
		end
		return nil
	end
	return searchRecursive(parent)
end

-- دالة للبحث عن الزر بالنص
local function findButtonByText(parent, text)
	if not parent then return nil end
	local function searchRecursive(obj)
		if obj:IsA("GuiButton") or obj:IsA("TextButton") then
			local hasText = obj:FindFirstChild("Text") or obj.Text
			if hasText and string.find(string.lower(tostring(hasText)), string.lower(text)) then
				return obj
			end
		end
		for _, child in pairs(obj:GetChildren()) do
			local result = searchRecursive(child)
			if result then return result end
		end
		return nil
	end
	return searchRecursive(parent)
end

-- الحلقة الرئيسية للضغط التلقائي
task.spawn(function()
	local interface = Gui:WaitForChild("Interface", 10)
	if not interface then return end

	local rollButton = nil
	local searchPaths = {
		"Customisation.Family.Buttons_2.Roll",
		"Roll",
		"RollButton"
	}

	for _, path in pairs(searchPaths) do
		local pathParts = string.split(path, ".")
		local current = interface
		for _, part in pairs(pathParts) do
			if current then
				current = current:FindFirstChild(part)
			end
		end
		if current and current:IsA("GuiButton") then
			rollButton = current
			break
		end
	end

	if not rollButton then
		rollButton = findButton(interface, "Roll")
	end
	if not rollButton then
		rollButton = findButtonByText(interface, "roll")
	end
	if not rollButton then
		return
	end

	while true do
		if ENABLED then
			if canClick(rollButton) and isActuallyVisible(rollButton) then
				clickButton(rollButton)
				task.wait(CLICK_DELAY)
			else
				task.wait(WAIT_DELAY)
			end
		else
			task.wait(1)
		end
	end
end)

--//==============================\\--
--||            👑 ESP            ||--
--\\==============================//--


-- متغيرات التحكم
local ESPEnabled = false
local ESPColor = Color3.fromRGB(96, 205, 255)
local ESPSize = Vector3.new(50, 50, 50)

-- دالة إنشاء ESP على النيب
local function createNapeESP(nape)
    if not nape:FindFirstChild("NapeESP") then
        local esp = Instance.new("BoxHandleAdornment")
        esp.Name = "NapeESP"
        esp.Adornee = nape
        esp.AlwaysOnTop = true
        esp.ZIndex = 5
        esp.Size = ESPSize
        esp.Transparency = 0.5
        esp.Color3 = ESPColor
        esp.Parent = nape
    end
end

local function applyNapeESP()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then
        return
    end

    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape and nape:IsA("BasePart") then
                    createNapeESP(nape)
                end
            end
        end
    end
end

local function removeAllNapeESP()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then
        return
    end

    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape and nape:FindFirstChild("NapeESP") then
                    nape.NapeESP:Destroy()
                end
            end
        end
    end
end

-- تحديث اللون الحالي
local function updateNapeESPColor()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then
        return
    end

    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape then
                    local esp = nape:FindFirstChild("NapeESP")
                    if esp then
                        esp.Color3 = ESPColor
                    end
                end
            end
        end
    end
end

-- دعم العمالقة الجدد تلقائيًا
local titansFolder = workspace:FindFirstChild("Titans")

if titansFolder then
    titansFolder.ChildAdded:Connect(function(titan)
        if not ESPEnabled then return end
        task.wait(0.5)
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape then
                    createNapeESP(nape)
                end
            end
        end
    end)
end

Tabs.Esp:AddToggle("NapeESP", {
    Title = "Enable Nape ESP",
    Default = false,
    Callback = function(value)
        ESPEnabled = value
        if value then
            applyNapeESP()
        else
            removeAllNapeESP()
        end
    end
})

local Colorpicker = Tabs.Esp:AddColorpicker("ESPColorPicker", {
    Title = "ESP Color",
    Default = ESPColor
})

Colorpicker:OnChanged(function(newColor)
    ESPColor = newColor
    updateNapeESPColor()
end)

Colorpicker:SetValueRGB(Color3.fromRGB(96, 205, 255))



--//==============================\\--
--||           👑 Raids           ||--
--\\==============================//--



--============[ 1. Auto Skip Cutscene ]============--

local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local interface = player:FindFirstChild("PlayerGui")
    and player.PlayerGui:FindFirstChild("Interface")

local skipBtn = interface and interface:FindFirstChild("Skip")

local autoSkipEnabled = false

local function updateNavigation(guiObject: GuiObject | nil)
    GuiService.SelectedObject = guiObject
end

local function shouldClickSkip()
	return skipBtn
		and skipBtn.Visible
		and skipBtn.AbsoluteSize.Magnitude > 10
end

local function pressSkipKey()
    updateNavigation(skipBtn)

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

    task.wait(0.01)
    updateNavigation(nil)
end

task.spawn(function()
	while true do
		if autoSkipEnabled and shouldClickSkip() then
			pressSkipKey()
			task.wait(1) -- تقلل الانتظار عشان يضغط بسرعة
		end
		task.wait(0.5)
	end
end)

local Toggle = Tabs.Raids:AddToggle("AutoSkipCutscene", {
    Title = "Auto Skip Cutscene",
    Default = false,
    Callback = function(state)
        autoSkipEnabled = state
    end
})


--============[ 1. Auto Open Chests ]============--


local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local player = game.Players.LocalPlayer
local Gui = player:WaitForChild("PlayerGui")

-- تحكم التوقلات
local autoFreeEnabled = false
local autoPremiumEnabled = false

local function canClick(btn)
	return btn and btn.Visible and btn.AbsoluteSize.Magnitude > 10
end

local function isActuallyVisible(obj)
	if not obj then return false end
	local current = obj
	while current and current ~= Gui do
		local success, result = pcall(function() return current.Visible end)
		if success and not result then
			return false
		end
		current = current.Parent
	end
	return obj.AbsoluteSize.Magnitude > 10
end

local function clickButton(btn)
	local pos = btn.AbsolutePosition
	local size = btn.AbsoluteSize
	local inset = GuiService:GetGuiInset()

	local x = pos.X + size.X / 2
	local y = pos.Y + size.Y / 2 + inset.Y

	VIM:SendMouseMoveEvent(x, y, game)
	task.wait(0.05)
	VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
	task.wait(0.05)
	VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- 🔁 Auto Free Chest
task.spawn(function()
	local interface = Gui:WaitForChild("Interface")
	local chests = interface:WaitForChild("Chests")
	local freeBtn = chests:WaitForChild("Free")
	local finishBtn = chests:WaitForChild("Finish")

	while true do
		if autoFreeEnabled and isActuallyVisible(finishBtn) then
			if canClick(freeBtn) then
				clickButton(freeBtn)
				task.wait(7)
			end
			if canClick(finishBtn) then
				clickButton(finishBtn)
				task.wait(2)
			end
			while isActuallyVisible(finishBtn) do
				task.wait(1)
			end
		else
			task.wait(1)
		end
	end
end)

-- 🔁 Auto Premium Chest
task.spawn(function()
	local interface = Gui:WaitForChild("Interface")
	local chests = interface:WaitForChild("Chests")
	local premiumBtn = chests:WaitForChild("Premium")
	local finishBtn = chests:WaitForChild("Finish")

	while true do
		if autoPremiumEnabled and isActuallyVisible(finishBtn) then
			if canClick(premiumBtn) then
				clickButton(premiumBtn)
				task.wait(7)
			end
			if canClick(finishBtn) then
				clickButton(finishBtn)
				task.wait(2)
			end
			while isActuallyVisible(finishBtn) do
				task.wait(1)
			end
		else
			task.wait(1)
		end
	end
end)


Tabs.Raids:AddToggle("AutoPremiumChest", {
	Title = "Auto Premium Chest",
	Default = false,
	Callback = function(state)
		autoPremiumEnabled = state
	end
})


-- ✅ التوقلين باستخدام Fluent UI
Tabs.Raids:AddToggle("AutoFreeChest", {
	Title = "Auto Free Chest",
	Default = false,
	Callback = function(state)
		autoFreeEnabled = state
	end
})


--//==============================\\--
--||           👑 Webhook         ||--
--\\==============================//--

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local webhookURL = ""
local sendWebhook = false
local showUsername = false
local thumbnailURL = "https://media.discordapp.net/attachments/1375563869367435344/1382238069121482893/g2XBB0B.png?ex=684a6d04&is=68491b84&hm=43c78606310dd13f2241727ad200be03226aba7328ba3fc233f84cde2f246048&=&format=webp&quality=lossless&width=968&height=968"


local function formatWithCommas(number)
    number = tonumber(number)
    if not number then return "0" end
    local formatted = tostring(number)
    local k
    while true do  
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- ✅ UI Toggles
Tabs.Webhook:AddToggle("SendWebhookToggle", {
    Title = "Notify Webhook",
    Default = false,
    Callback = function(Value) sendWebhook = Value end
})

Tabs.Webhook:AddToggle("DisplayUsernameToggle", {
    Title = "Display Roblox Username",
    Default = false,
    Callback = function(Value) showUsername = Value end
})

Tabs.Webhook:AddInput("WebhookInput", {
    Title = "Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    Finished = true,
    Callback = function(Value) webhookURL = Value end
})

-- ✅ التحقق من ظهور الزر فعليًا
local function isActuallyVisible(instance)
    if not instance or not instance:IsDescendantOf(player.PlayerGui) then return false end
    while instance and instance ~= player.PlayerGui do
        if instance:IsA("GuiObject") and not instance.Visible then return false end
        instance = instance.Parent
    end
    return true
end

-- ✅ جلب زر Retry
local function getRetryButton()
    local gui = player:FindFirstChild("PlayerGui")
    return gui and gui:FindFirstChild("Interface")
        and gui.Interface:FindFirstChild("Rewards")
        and gui.Interface.Rewards:FindFirstChild("Main")
        and gui.Interface.Rewards.Main:FindFirstChild("Info")
        and gui.Interface.Rewards.Main.Info:FindFirstChild("Main")
        and gui.Interface.Rewards.Main.Info.Main:FindFirstChild("Buttons")
        and gui.Interface.Rewards.Main.Info.Main.Buttons:FindFirstChild("Retry")
end

-- ✅ جلب قيمة نص معين
local function getText(path)
    local node = player:FindFirstChild("PlayerGui")
    for _, part in ipairs(string.split(path, ".")) do
        if not node then return "0" end
        node = node:FindFirstChild(part)
    end
    return node and node.Text or "0"
end

local aliasMap = {
    Serum = { "Attack Serum", "Armored Serum", "Female Serum" },
}

local function getDropQuantity(dropName)
    local base = player:FindFirstChild("PlayerGui")
    base = base and base:FindFirstChild("Interface")
    base = base and base:FindFirstChild("Rewards")
    base = base and base:FindFirstChild("Main")
    base = base and base:FindFirstChild("Info")
    base = base and base:FindFirstChild("Main")
    base = base and base:FindFirstChild("Items")

    local total = 0
    if base then
        local names = aliasMap[dropName] or { dropName }

        for _, name in ipairs(names) do
            for _, drop in ipairs(base:GetChildren()) do
                if drop.Name == name then
                    for _, sub in pairs(drop:GetDescendants()) do
                        if sub:IsA("TextLabel") then
                            local raw = sub.Text:match("[%d,.]+")
                            if raw then
                                raw = raw:gsub(",", "")
                                local number = tonumber(raw)
                                if number then
                                    total += number
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return tostring(total)
end

-- ✅ Main loop
local lastMissionTime = nil
task.spawn(function()
    while true do
        local retryBtn = getRetryButton()
        if isActuallyVisible(retryBtn) and sendWebhook and webhookURL ~= "" then
            local currentTime = getText("Interface.Rewards.Main.Info.Main.Stats.Time_Taken.Amount")
            if currentTime ~= "0" and currentTime ~= lastMissionTime then
                lastMissionTime = currentTime

                local gold = getDropQuantity("Gold")
                local xp = getDropQuantity("XP")
                local bp_xp = getDropQuantity("BP_XP")
                local gems = getDropQuantity("Gems")
                local serum = getDropQuantity("Serum")
                local scarf = getDropQuantity("Scarf")
                local common = getDropQuantity("Common_Perk")
                local rare = getDropQuantity("Rare_Perk")
                local epic = getDropQuantity("Epic_Perk")
                local leg = getDropQuantity("Legendary_Perk")
                local prestige = getDropQuantity("Prestige_Scroll")
                local mythical = getDropQuantity("Secret_Perk")

                local damage = getText("Interface.Rewards.Main.Info.Main.Stats.Damage_Dealt.Amount")
                local kills = getText("Interface.Rewards.Main.Info.Main.Stats.Titans_Killed.Amount")
                local crits = getText("Interface.Rewards.Main.Info.Main.Stats.Critical_Hits.Amount")

                local timeString = os.date("%d-%b-%Y %I:%M %p")

                local fields = {
                    {name = "**User:**", value = tostring(showUsername and player.Name or "Disabled"), inline = false},
                    {name = "**Stats:**", value = string.format(
                        "%s Time Taken\n%s Damage Dealt\n%s Titan Kills\n%s Critical Hits",
                        currentTime, formatWithCommas(damage:gsub(",", "")), kills, crits
                    ), inline = true},
                    {name = "**Rewards:**", value = string.format(
                        "%s Gold\n%s XP\n%s Gems",
                        formatWithCommas(gold), formatWithCommas(xp), formatWithCommas(gems)
                    ), inline = true},
                    {name = "**Drops:**", value = string.format(
                        "Battle Bass XP: %s\nCommon Perks: %s\nRare Perks: %s\nEpic Perks: %s\nLegendary Perks: %s\nPrestige Scroll: %s",
                        formatWithCommas(bp_xp), formatWithCommas(common), formatWithCommas(rare),
                        formatWithCommas(epic), formatWithCommas(leg), formatWithCommas(prestige)
                    ), inline = true},
                    {name = "**Special Rewards:**", value = string.format(
                        "Serum: %s\nMythical Perk: %s\nScarf: %s",
                        formatWithCommas(serum), formatWithCommas(mythical), formatWithCommas(scarf)
                    ), inline = false}
                }

                local embed = {
                    title = "AOT:R Rewards Logger",
                    thumbnail = { url = thumbnailURL },
                    fields = fields,
                    footer = { text = "Sent at: " .. timeString }
                }

                local data = {
                    content = ((tonumber(serum) or 0) > 0 or (tonumber(mythical) or 0) > 0 or (tonumber(scarf) or 0) > 0) and "@everyone" or nil,
                    embeds = {embed}
                }

                request({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(data)
                })
            end
        end
        task.wait(1)
    end
end)



--//==============================\\--
--||       👑  Titan Ripper       ||--
--\\==============================//--


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Event = ReplicatedStorage.Assets.Remotes.GET

local SkillData
local success, result = pcall(function()
    return ReplicatedStorage:WaitForChild("Modules", 5)
        :WaitForChild("Storage", 5)
        :WaitForChild("Skill", 5)
end)

if success and result then
    SkillData = require(result)
else
    SkillData = {}
end

local autoSkillEnabled = false

local skills = {
    ["14"] = { lastUsed = 0, initialDelay = 0 },
    ["23"] = { lastUsed = 0, initialDelay = 0.4 }
}

for skillID, info in pairs(skills) do
    task.spawn(function()
        task.wait(info.initialDelay)
        while true do
            task.wait(0.1)
            if autoSkillEnabled then
                local now = tick()
                local skillInfo = typeof(SkillData) == "table" and SkillData[skillID]

                if skillInfo and skillInfo.Cooldown then
                    if now - info.lastUsed >= skillInfo.Cooldown then
                        local success = pcall(function()
                            Event:InvokeServer("S_Skills", "Usage", skillID, false)
                        end)
                        if success then
                            info.lastUsed = tick()
                        end
                    end
                end
            end
        end
    end)
end

Tabs.Main:AddToggle("AutoSkillNapeToggle", {
    Title = "Titan Ripper",
    Default = false,
    Callback = function(state)
        autoSkillEnabled = state

        if state then
            for _, info in pairs(skills) do
                info.lastUsed = 0
                info.initialDelayDone = false
            end

            resizeNapes()
            connection = workspace.DescendantAdded:Connect(function(desc)
                if desc:IsA("BasePart") and desc.Name == "Nape" then
                    task.wait(0.1)
                    desc.Size = newSize
                    desc.CFrame = desc.CFrame
                end
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})

local newSize = Vector3.new(1500, 1500, 1500)
local connection

local function resizeNapes()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "Nape" then
            v.Size = newSize
            v.CFrame = v.CFrame
        end
    end
end




SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()