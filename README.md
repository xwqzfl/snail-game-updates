# 单机游戏补丁发布

把要热更新的 Lua 函数放在维护工作区的 `GameUpdates/snail-patch.lua`，验证后运行 `./GameUpdates/publish-player.ps1`。发布命令用维护机的更新签名密钥把 Lua 和签名发布文件提交到 `main`。玩家安装支持自动更新的自修复版 APK 后，联网打开游戏即可检查更新。游戏进程运行期间约每分钟检查一次，遇到正在结算等情况会等到可以安全应用时再更新。

每次提交提供一套完整的函数替换。用 `original(模块, 方法)` 调用启动时已安装的版本，用 `replace(模块, 方法, 函数)` 登记替换。移除某项替换后，该方法会恢复为启动时的实现。

```lua
local eventSp = original("offline.TourMetrics", "eventSp")
replace("offline.TourMetrics", "eventSp", function(state, eventId)
    return eventSp(state, eventId)
end)
```

当前支持这些方法。

- `game.ui.form.computer.UIComputerGameList.initItem`
- `game.ui.form.main.UIMailInfo.registerTouchEvent`
- `game.ui.form.shop.UICommonShopBuyItem.getExtraDescInfo`
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

安装新界面、修改更新客户端、修改 Android 原生代码或替换 APK 需要分发同一应用 ID、同一签名的新安装包。这里的热更新支持上述 Lua 函数，每份 Lua 源码上限 128 KiB。

## 发布范围

Windows 测试机从 GitHub 读取 `snail-patch.lua`。玩家手机读取 `snail-player-update.txt`，在本机验证发布签名、兼容版本和补丁校验值后加载。修复回退可用上一份可用源码重新签名发布，序号仍依次递增。

仓库只发布代码补丁和说明。玩家进度、备份和日志留在各自设备上，发布密钥保存在维护机。离线时可以继续使用已有补丁游玩。
