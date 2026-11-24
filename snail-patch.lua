-- Keep the game list usable while the new installation control is rebuilt.
local initItem = original("game.ui.form.computer.UIComputerGameList", "initItem")
replace("game.ui.form.computer.UIComputerGameList", "initItem", function(...)
    local ok, result = pcall(initItem, ...)
    if ok then return result end
    if type(result) ~= "string" or not string.find(result, "BUTTON_STYLE", 1, true) then
        error(result, 0)
    end
end)

-- A signed release displays only the activity navigation IDs listed here.
if supports and supports("offline.ActivityVisibility", "selection") then
    local activityIds = {}
    replace("offline.ActivityVisibility", "selection", function()
        return activityIds
    end)
end
