for _,file in ipairs(listfiles("d_android_script_dir")) do
UILib.SavedScripts:Add(file:sub(22, #file), readfile(file))
end



------------------------ Expose the modules as global env for plugins. -----------------------------------------getgenv().delta = {}

getgenv().delta = {}

function delta:AddTab(a,b)
    UILib:AddTab(a,b)
end

function delta:SetCurrentSuggestionScript(a,b)
    UILib:SetCurrentSuggestionScript(a,b)
end

delta.SavedScripts = {}

function delta:SaveScript(a,b,c)
    UILib.SavedScripts:Add(a,b,c)
end

delta.Settings = {}

function delta.Settings:AddButton(a,b,c)
    UILib.Settings:AddButton(a,b,c)
end

function delta.Settings:AddSwitch(a,b,c,d)
    UILib.Settings:AddSwitch(a,b,c,d)
end

function delta.Settings:AddInput(a,b,c)
    UILib.Settings:AddTextbox(a,b,c)
end

function delta.Settings:AddDropdown(a,b,c,d)
    UILib.Settings:AddDropdown(a,b,c,d)
end

makefolder("DeltaPlugins")
for _,file in pairs(listfiles("DeltaPlugins")) do
    loadstring(readfile(file))()
end

-------------------------------------------------------------------------
-- Home: Popup Handler
script.Parent.Home.Popup.Visible = false
script.Parent.Home.DarkOverlay.Visible = false

script.Parent.Home.Popup.Close.MouseButton1Click:Connect(function()
    if isTween.Value == true then