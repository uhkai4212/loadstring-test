function module.SavedScripts:OpenPopup()
    script.Parent.Home.Popup.Visible = true
    script.Parent.Home.DarkOverlay.Visible = true
    script.Parent.Home.DarkOverlay.Transparency = 1
    if isTween.Value == true then
    script.Parent.Home.Popup.Position = UDim2.new(0.5, 0,1.58, 0)
    ts:Create(script.Parent.Home.Popup, TweenInfo.new(.2), {
        Position = UDim2.new(0.5, 0,0.5, 0)
    }):Play()
    end
    ts:Create(script.Parent.Home.DarkOverlay, TweenInfo.new(.15), {
        Transparency = 0.5
    }):Play()
    end

    function module.SavedScripts:Add(title: string, source: string, tag: string)
    local newscript = reserved.Script:Clone()
    newscript.Visible = true
    newscript.Parent = script.Parent.Home.Holder
    newscript.Title.Text = title
    if type(tag) == "string" then
    newscript.Frame.Title.Text = tag
    if tag == "Built-In" then
    newscript.LayoutOrder = 999999999
    end

    else
        newscript.Frame.Visible = false

    end



    newscript.Button.MouseButton1Click:Connect(function()
        loadstring(source)()
        end)

        newscript.Button1.MouseButton1Click:Connect(function()
            newscript:Destroy()
            if isfile("d_android_script_dir/"..title) then
                delfile("d_android_script_dir/"..title)
            end
        end)
    end
    return module;

    end;
};