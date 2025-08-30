-- local Mode = "Web"

-- -- if not getgenv().Import then
-- --     getgenv().Import = function(RunMode, filePath)
-- --         if RunMode == "Developer" then
-- --             local dirPath = "PhantomFlux-V2/"
-- --             local fullPath = dirPath .. filePath

-- --             if not isfolder(dirPath) then
-- --                 error("[Import]: Folder not found: " .. dirPath)
-- --             end
-- --             if not isfile(fullPath) then
-- --                 error("[Import]: File not found: " .. fullPath)
-- --             end

-- --             local source = readfile(fullPath)
-- --             if not source then
-- --                 error("[Import]: Failed to read file: " .. fullPath)
-- --             end

-- --             local func, err = loadstring(source)
-- --             if not func then