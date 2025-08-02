end)
    wait(0.1)

    if isfile(randomname) then
    uilib.ScriptSearch:Add(script.title, script.game.name, script.script, randomname, script.verified, script.views)

    else
        uilib.ScriptSearch:Add(script.title, script.game.name, script.script, "", script.verified, script.views)
    end
--print'yey'

    else
        uilib.ScriptSearch:Add(script.title, script.game.name, script.script, "https://assetgame.roblox.com/Game/Tools/ThumbnailAsset.ashx?aid="..script.game.gameId.."&fmt=png&wd=420&ht=420", script.verified, script.views)
--parint"gamur"
    end
    --print"oki"
    end
    end
    end)


end;
task.spawn(C_50);