# 单机游戏补丁发布

把要热更新的 Lua 函数放在仓库根目录的 `snail-patch.lua`，提交到 `main`。Windows 更新程序会读取该分支最新提交，等待模拟器中的游戏处于可更新状态后应用。更新脚本每隔约一分钟检查一次。游戏内局面繁忙时，应用时间可能推后。

每次提交提供一套完整的函数替换。用 `original(模块, 方法)` 调用启动时已安装的版本，用 `replace(模块, 方法, 函数)` 登记替换。移除某项替换后，该方法会恢复为启动时的实现。

```lua
local eventSp = original("offline.TourMetrics", "eventSp")
replace("offline.TourMetrics", "eventSp", function(state, eventId)
    return eventSp(state, eventId)
end)
```

当前支持这些方法。

- `offline.Combat.simulate`
- `offline.Compass.plan`
- `offline.Conditions.check`
- `offline.ExplorationCombatSP.amount`
- `offline.HomeClickEggs.sync`
- `offline.HomeFinds.sync`
- `offline.LotteryExtras.select`
- `offline.Partners.skipWait`
- `offline.QiqiHandbook.list` 和 `preview`
- `offline.Tour.planArea` 和 `planEvent`
- `offline.TourMetrics.eventSp`

安装新界面、更新脚本入口、改原生代码或替换 APK 需要按正常的安装流程处理。这里只发布针对固定 Lua 方法的补丁。每个补丁以提交 ID 校验，发布文件上限 128 KiB。
