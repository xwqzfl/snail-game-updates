# 单机游戏补丁发布

## 当前玩家升级路径

| 当前版本 | 更新步骤 |
| --- | --- |
| 1.0.x，例如 1.0.17 | 先覆盖安装 1.1.0，再在游戏内通过「云端更新」升到 1.1.3。 |
| 1.1.0 | 在游戏内通过「云端更新」升到 1.1.3。 |

[1.1.0 安装包分段与合并步骤](https://github.com/xwqzfl/snail-game-updates/releases/tag/apk-v30-aad9b88acdc8) · [1.1.3 差分更新](https://github.com/xwqzfl/snail-game-updates/releases/tag/apk-v33-5c3e8c23ac35)

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
- `offline.ActivityVisibility.selection`（1.0.3 起）
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

这条 Lua 热更新渠道支持上述函数，每份 Lua 源码上限 128 KiB。新界面、核心脚本和 Android 代码可通过下方的整包更新渠道发布。

## 控制活动页显示

自修复版 1.0.3 通过源码的 `ActivityNavigationM.isActivitySwitchOpen` 控制显示，默认关闭所有活动。维护端在 `snail-patch.lua` 的 `activityIds` 中填写要开启的活动导航 ID，然后按上面的流程签名发布。比如 `{[8] = true, [-71504] = true}` 选中两项，`{}` 关闭全部活动。活动页、日历和轮播沿用原有日期、资格和服务端关闭开关。

每次发布都是完整配置。发布其他修复时保留已选的 `activityIds`。玩家联网收到配置后，游戏在空闲时应用，离线重启仍读取已缓存的配置。活动进度和奖励记录继续保存在原存档。

## 发布范围

Windows 测试机从 GitHub 读取 `snail-patch.lua`。玩家手机读取 `snail-player-update.txt`，在本机验证发布签名、兼容版本和补丁校验值后加载。修复回退可用上一份可用源码重新签名发布，序号仍依次递增。

玩家进度、备份和日志留在各自设备上，发布密钥保存在维护机。离线时可以继续使用已有补丁游玩。

## 整包更新

玩家先覆盖安装一次自修复版 1.0.2 或更新的带整包更新客户端的版本。之后打开游戏或点击「云端更新」可检查新版。下载前会显示版本和大小，由玩家确认。暂停或网络中断后，再次检查更新可从已校验的分段继续。下载和校验完成后由 Android 安装器确认覆盖安装。Android 8 及以上首次可能会要求允许此应用安装未知应用。

维护机使用与现有自修复版相同的 APK 签名。每次发布提高 `versionCode`，APK 名称中的显示版本也同步更新。以下命令从合适的自修复基础 APK 打包并准备更新，示例使用 `1.0.3` 和版本码 `6`。

```powershell
./GameUpdates/build-apk.ps1 -Source 'C:/path/base.apk' -Output 'C:/path/snail-1.0.3.apk' -Version 1.0.3 -Code 6
./GameUpdates/publish-apk.ps1 -Directory 'C:/path/release-6' -Apk 'C:/path/snail-1.0.3.apk'
```

准备命令校验 APK 签名，把 APK 切为 256 MiB 分段，并生成签名清单。要发布已经验证的准备目录，运行以下命令。

```powershell
./GameUpdates/publish-apk.ps1 -Directory 'C:/path/release-6' -Publish
```

发布命令在昨晚使用的 GitHub 仓库上传并校验 GitHub Release 附件，再提交 `snail-apk-update.txt`。客户端验证清单签名、版本码、每个分段和完整 APK 的 SHA-256。Android 安装器验证包名和 APK 签名，完成覆盖安装并保留应用数据。首次部署安装器的版本通过直接分发 APK 交付，早期版本只能读取 Lua 更新。
