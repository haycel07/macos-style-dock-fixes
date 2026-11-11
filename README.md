# macos-style-dock-fixes

Windows 11 的 macOS 风格 Dock 修复版，基于 Zach Vaughn 的 **MacOS Style Dock 1.0** Windhawk 模块。

保留悬停波浪放大和玻璃效果，修复通知角标位置，给右侧状态栏补上同款玻璃底，并收回影响窗口缩略图定位的额外顶部占位。

**这是社区修改版，不是 Windhawk 官方发布版本，也不是完整的 macOS 桌面替换。**

## 当前版本

`1.0-local.4`，Windows 11 x64。当前构建使用 Windhawk 1.7.3 自带的 Clang 工具链。

## 修改内容

- **角标位置**：把通知数、OverlayIcon 和 Badge 控件定位到实际图标的右上角，静止时收进玻璃区域；保留通知数，随图标一起移动和缩放。
- **防止裁切**：解除角标祖先容器的显式裁剪，通知更新后重新处理。
- **右侧状态栏**：增加和 Dock 共用颜色、模糊、圆角及底部间距的玻璃板，保留原生时钟和托盘交互。玻璃背景不接收鼠标点击。
- **预览顶部占位**：去掉为角标额外增加的 12 px 原生任务栏高度，避免继续把原生窗口缩略图顶高。
- **动画**：保留上游的逐帧波浪放大及邻近图标过渡。

## 下载和安装

[下载完整项目 ZIP](https://github.com/haycel07/macos-style-dock-fixes/archive/refs/heads/main.zip) · [下载当前 DLL](bin/macos-style-dock_1.0-local.4.dll) · [文件校验](SHA256SUMS.txt)

适用于已经安装 **Windhawk 1.7.3 便携版** 的用户。标准安装版通常需要管理员权限，本仓库的自动安装脚本目前只处理便携版。

1. 从 [Windhawk 官方发布页](https://github.com/ramensoftware/windhawk/releases/tag/v1.7.3)安装或解压便携版。
2. 下载本项目 ZIP，完整解压。不要只复制 DLL。
3. 关闭其他修改任务栏布局、尺寸或动画的模块，包括 Windows 11 Taskbar Styler、Taskbar height and icon size、Taskbar Dock Animation、Taskbar Multirow。不要同时运行两份 MacOS Style Dock。
4. 在 PowerShell 7 中运行：

```powershell
./scripts/Install.ps1 -WindhawkDir 'C:\Tools\Windhawk'
```

脚本会校验 DLL，备份原模块配置和源码，复制运行库，并启动 Windhawk 后台。它不添加开机启动项，不修改系统更新、主题、应用固定项或全局动画设置。原版模块仍会按自己的逻辑处理 Dock 中资源管理器的位置。

如需恢复安装前的模块状态：

```powershell
./scripts/Restore.ps1 -WindhawkDir 'C:\Tools\Windhawk'
```

## 从源码构建

需要 Windows x64、Node.js 和 Windhawk 1.7.3 便携版（含编译器）。不需要另外安装 Visual Studio。

```powershell
$env:WINDHAWK_DIR = 'C:\Tools\Windhawk'
node ./scripts/build.mjs
```

源码位于 `src/macos-style-dock.wh.cpp`。构建输出到 `bin/`，编译日志位于 `build.log`。自行修改源码后重建的 DLL 哈希将不同，安装前需同步更新 `SHA256SUMS.txt` 中对应记录。

## 预设

`presets/macos-style-dock.ini`：约 31 px 基准图标、1.6 倍悬停放大、180 ms 平滑过渡，Tint 18 / Blur 30。Dock 默认常驻，自动隐藏不是此版本的目标。

## 验证范围与限制

在一台 Windows 11 25H2 x64 机器上编译并实际加载；已观察到 GPT/Codex 通知数完整落在玻璃区域内，右侧玻璃底和时钟可见。使用者确认当前外观可用。

原生任务栏窗口高度由 80 px 收回到 68 px；这是窗口几何变化的实测，不等于实测了缩略图窗口恰好下移 12 px。

多显示器、不同 DPI、所有应用角标、多位计数及所有通知状态未全量验证。上游模块的 ARM64、小任务栏按钮和其他任务栏模块兼容限制仍适用。当前 DLL 为本地构建，未作数字签名。

## 来源和许可

- 上游模块：[MacOS Style Dock](https://github.com/ramensoftware/windhawk-mods/blob/main/mods/macos-style-dock.wh.cpp)，作者 **Zach Vaughn**。
- 任务栏尺寸等相关上游实现引用了 **m417z** 的代码，详见源文件中的原始说明。
- 本仓库保留上游源码署名与 GPL-3.0 许可；修改说明和来源校验见 [NOTICE.md](NOTICE.md) 与 [docs/PROVENANCE.json](docs/PROVENANCE.json)。
- 本次修改发布于 2026-11-11。原有代码权利归原作者所有。

## English

A GPL-3.0 community fork of Zach Vaughn's MacOS Style Dock Windhawk mod. It anchors notification overlays inside the glass dock, adds a matching native system-tray glass plate, and removes extra frame height that affected thumbnail placement. Windows 11 x64; built with Windhawk 1.7.3. Not an official Windhawk release.
