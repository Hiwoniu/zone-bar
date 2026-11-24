# 两地时 / ZoneBar

小而专的 macOS 状态栏时钟：在状态栏显示一个指定时区的时间，比如 `🇨🇳 11/24 18:50`。

## 功能

**v1.0**
- 状态栏显示指定时区的时间
- 可搜索的时区列表，支持中文城市名、拼音、英文名、缩写（PST / JST）和 `GMT+8` 这种写法，常用时区排在最前
- 显示格式：只显示日期 / 只显示时间 / 日期加时间；12 或 24 小时制；可选显示星期和秒
- 前缀：国旗 emoji / 城市简称（“京”）/ 不显示
- 下拉菜单：完整日期时间、和本地相差几小时、对方现在是白天还是夜里
- 开机自启动（`SMAppService`）
- 不显示 Dock 图标（`LSUIElement`）

**v1.1**
- 多个时区：状态栏只显示一个，下拉菜单列出其余的，点哪个就切到哪个
- 自定义格式字符串（如 `MM-dd HH:mm`）
- 点一下时间就复制
- 农历日期，带干支年（`Calendar(identifier: .chinese)`）
- 标注夏令时，30 天内有切换时提前提示

## 构建

需要 macOS 13 及以上，以及 Xcode 15 或更新版本（Swift 5.9+）。

```bash
./scripts/build-app.sh
```

```bash
cp -R build/ZoneBar.app /Applications/
```

```bash
open /Applications/ZoneBar.app
```

开机自启动要从 `/Applications` 运行才可靠。如果系统提示需要批准，到 系统设置 › 通用 › 登录项 里允许。

开发时可以直接运行（不会打包成 .app，所以开机自启动不可用）：

```bash
swift run
```

## 结构

| 文件 | 作用 |
|---|---|
| `Models.swift` | 共享的数据类型：`ZoneInfo`、`FormatOptions` 等 |
| `AppState.swift` | 唯一的状态来源，存到 UserDefaults |
| `TimeZoneCatalog.swift` | 精选城市数据（中文名、简称、国旗、拼音），以及搜索 |
| `ZoneFormatter.swift` | 各种格式化：状态栏文字、时差、昼夜、农历、夏令时 |
| `ClockTicker.swift` | 对齐到整分钟（显示秒时对齐到整秒）的省电刷新 |
| `LaunchAtLogin.swift` | 开机自启动 |
| `ZoneBarApp.swift` / `MenuContentView.swift` / `ZonePickerView.swift` / `SettingsView.swift` | 界面 |

刻意不做：日历、提醒、世界地图。
