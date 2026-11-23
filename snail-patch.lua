-- Keep the game list usable while the new installation control is rebuilt.
local initItem = original("game.ui.form.computer.UIComputerGameList", "initItem")
replace("game.ui.form.computer.UIComputerGameList", "initItem", function(...)
    local ok, result = pcall(initItem, ...)
    if ok then return result end
    if type(result) ~= "string" or not string.find(result, "BUTTON_STYLE", 1, true) then
        error(result, 0)
    end
end)
