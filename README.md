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

## 发布范围

当前这台 Windows 测试机通过 GitHub 读取补丁，并把单个 Lua 文件交给模拟器。更新链路只读取仓库根目录的 `snail-patch.lua`。仓库不存放存档、备份、日志、账号凭据或 APK。补丁运行在各自的游戏上下文中，每位玩家的进度保留在自己的设备。

给玩家分发时，首包需要包含更新客户端。后续流程是收集反馈、验证修复、发布签名补丁，再由玩家设备下载并校验兼容版本。适合热更新的补丁可在游戏运行时应用。需要替换 Android 原生内容的版本走签名一致的 APK 更新。当前仓库仍是私有维护仓，尚未向玩家公开发布下载端点或 APK。
