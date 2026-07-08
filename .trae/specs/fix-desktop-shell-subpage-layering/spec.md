# 桌面/平板端二级页面层级错位修复 Spec

## Why
桌面端（macOS/Windows/Linux）和部分平板端（iPadOS/Android Pad）的二级页面过渡动画与左侧导航栏（NavigationRail/Sidebar）位于同一动画层级，导致用户进入二级页面时整张外壳（侧栏 + 顶栏 + 内容区）整体滑动进入/退出。这与 macOS/Windows 的「侧栏常驻 + 仅内容区过渡」交互直觉相悖，也违反 `.trae/rules/project_rules.md` 中「桌面端 `Scaffold` / `AppBar` / `NavigationRail` / 壳内容区默认必须使用 `surface` 或 `surfaceContainer*`」的稳定性约束。

## What Changes
- **重构桌面外壳的内容区**：使 `MacosShellContentPage` / `WindowsShellContentPage` / `DesktopShellPage`（以及 `TabletShellPage` 当存在时）的右侧内容区**始终**挂载一个内层 `Navigator`（即 `DesktopRoutedModuleHost` 或等价的 `ShellContentNavigator`），主模块页作为该内层 `Navigator` 的初始路由。
- **替换 `openRouteRespectingShell` 的桌面/平板行为**：当目标路由是 `embedRouteInShell: true` 时，改为**推入**当前外壳的内层 `Navigator`（即 `Navigator.of(shellContentKey)`），而不是 `pushReplacementNamed` 到顶层 Navigator。
- **保留顶层回退**：当 `shellContentKey` 不可达（如移动端、或路由来自外壳之外）时，回退到 `pushReplacementNamed(home, arguments: …)` 的现有行为。
- **消除内层 Navigator 的自带转场**：内层 `Navigator` 使用自定义 `PageRoute`（仅做通用 MDUI3 `FadeThrough` 转场：旧页淡出 + 新页淡入并轻微向上偏移 8dp，时长 200ms；且 `barrierDismissible: false`），**不**引入 macOS/Windows 风格的水平 slide-in（这两类风格的滑动属于原生 UI 轨道职责，Dart MDUI3 轨道统一使用 `FadeThrough`）。
- **补回退机制**：当内层 Navigator 已无路可退（如用户已经在子页），通过 `Navigator.maybePop` 先回退内容区栈；若用户在外壳顶层则继续走顶层 `pushReplacementNamed`。
- **统一各平台入口**：`MacosShellContentPage`、`WindowsShellContentPage`、`DesktopShellPage` 共用同一棵 `ShellContentHost` 子树，并对外暴露 `GlobalKey<NavigatorState>` 供路由助手查询。
- **按模块保留内层栈**：每个模块各自维护独立的内层 `Navigator` 栈；模块切换时记录当前模块的最后一次栈快照，切回时还原（避免用户每次切回都要重新进入子页）。
- **多端交互适配**：壳层在保持通用（同一棵 `ShellContentHost`）的同时，根据当前输入设备类型（鼠标/键盘 vs 触摸）路由到不同的交互行为：
  - **鼠标 + 键盘（macOS/Windows 桌面）**：侧栏 `NavigationRail` 保持常驻 + 键盘快捷键（`Cmd/Ctrl + 数字`）切换模块。
  - **触摸为主（iPadOS/Android Pad、Windows 平板模式）**：侧栏可在闲置时自动折叠为悬浮按钮 / 边缘指示器，长按弹出，主操作区支持触摸滑动手势返回。
  - 实际判定通过 `PlatformUtils.inputDeviceKinds`（综合 `MediaQueryData.supportedLocales` 之外的设备能力 + 平台标识）返回 `InputDeviceKind.pointer` 或 `InputDeviceKind.touch`，由 `ShellContentHost` 的 `Builder` 包裹。
  - **不**在 Dart MDUI3 轨道引入任何 macOS/Windows 原生视觉差异（视觉差异由原生 UI 轨道承载）。
- **回归保护**：补充 widget 测试，断言「进入二级页面时，sidebar/NavigationRail 不在 `AnimatedSwitcher`/`MaterialPageRoute` 的过渡范围内」。

## Impact
- Affected specs:
  - `adapt-desktop-tablet-ui`（外壳/侧栏/导航的整体约束）
  - `fix-cross-platform-file-save`（其中 `pushReplacementNamed` 也会受 `openRouteRespectingShell` 行为影响）
  - `migrate-to-native-ui` / `replicate-mdui3-to-native-ui`（若启用原生侧栏，要保证原生侧栏不被 Dart 侧 Navigator 整体替换）
- Affected code:
  - `lib/features/shell/shell_navigation.dart`（`openRouteRespectingShell`）
  - `lib/ui/desktop/common/widgets/desktop_routed_module_host.dart`（新增「始终挂载」模式 + `GlobalKey<NavigatorState>` 暴露）
  - `lib/ui/desktop/common/widgets/desktop_content_host.dart`（替换 `IndexedStack` 模式为 `ShellContentHost`）
  - `lib/ui/desktop/macos/app/macos_shell_content_page.dart`（接入新的 `ShellContentHost`）
  - `lib/ui/desktop/windows/app/windows_shell_content_page.dart`（同上）
  - `lib/ui/desktop/common/app/desktop_shell_page.dart`（同上）
  - `lib/ui/tablet/` 下对应 Shell（如存在）
  - `lib/ui/routing/route_helpers.dart`（新增 `findShellContentNavigator` 帮助函数）
  - `test/ui/desktop_shell_stability_policy_test.dart`（回归测试）

## ADDED Requirements
### Requirement: 桌面/平板端二级页面过渡隔离
The system SHALL render a stable outer shell on desktop and tablet platforms. The left navigation rail / sidebar and the top toolbar SHALL remain in place when a sub-page is opened; only the right content area SHALL transition.

#### Scenario: 桌面端进入设置-语言子页
- **WHEN** 用户在 macOS/Windows/Linux 桌面端点击「设置 → 语言」二级入口
- **THEN** 仅右侧内容区出现水平 slide-in/fade 过渡动画
- **AND** 左侧 `NavigationRail` 不参与过渡，位置与宽度保持稳定
- **AND** 顶部 `AppBar`/工具栏不参与过渡

#### Scenario: 平板端进入容器详情子页
- **WHEN** 用户在 iPadOS/Android Pad 平板端点击某个容器项进入详情
- **THEN** 同样满足「侧栏 + 顶栏稳定、仅内容区过渡」

#### Scenario: 在子页面再进入孙页面
- **WHEN** 用户在已打开的子页面（如设置-语言）继续点击深层级入口
- **THEN** 内层 `Navigator` 栈持续累加，但外壳仍保持稳定
- **AND** 浏览器/系统回退按钮先回退内层栈

#### Scenario: 移动端回退
- **WHEN** 平台检测为手机（`formFactor == phone`）
- **THEN** `openRouteRespectingShell` 保持现有的 `Navigator.pushNamed` 行为不变

### Requirement: 内层 Navigator 接入点统一
The system SHALL expose a `GlobalKey<NavigatorState>` for the desktop/tablet shell content area so navigation helpers can push sub-pages directly without round-tripping the top-level Navigator.

#### Scenario: 子页可推入内层 Navigator
- **WHEN** 任意调用方在桌面端调用 `openRouteRespectingShell(context, '/settings/language')`
- **THEN** 通过 `findShellContentNavigator(context)` 找到外壳内层 `Navigator`
- **AND** 推入 `MaterialPage`（而非顶层 `MaterialPageRoute` 替换）
- **AND** 若 `findShellContentNavigator` 返回 `null`（如内嵌 widget 测试或移动端），回退到原 `pushReplacementNamed` 行为

## MODIFIED Requirements
### Requirement: 桌面外壳内容区始终挂载 Navigator
The desktop/tablet shell content area SHALL always be backed by a `ShellContentNavigator` (alias of `DesktopRoutedModuleHost` with `alwaysMounted: true`), with the module's primary page as the initial route. The previous `IndexedStack` of cached module pages SHALL be replaced with a single `ShellContentNavigator` that swaps its initial route on module change, **and** maintains per-module stack snapshots so that switching back to a previous module restores the user's last sub-page position.

### Requirement: 子页面导航不再替换顶层路由
`openRouteRespectingShell` SHALL no longer call `Navigator.of(context).pushReplacementNamed(AppRoutes.home, …)` on desktop/tablet when the target route is `embedRouteInShell: true`. It SHALL push the sub-page into the shell's inner `Navigator` instead.

### Requirement: 内层 Navigator 转场为通用 MDUI3 FadeThrough
The shell's inner `Navigator` SHALL use a custom `PageRouteBuilder` that performs a Material Design 3 `FadeThrough` transition (200ms: old page fades out, new page fades in with an 8dp upward translation). It SHALL NOT use macOS/Windows native horizontal slide transitions — those are reserved for the platform-native UI tracks.

### Requirement: 跨输入设备的壳层交互适配
The desktop/tablet shell SHALL remain a single `ShellContentHost` widget tree, but the `ShellContentHost` SHALL resolve `InputDeviceKind` via `PlatformUtils.inputDeviceKinds(context)` and adapt interaction affordances accordingly:
- **pointer** (mouse + keyboard, e.g. macOS/Windows desktop, Linux desktop): `NavigationRail` is always visible, `Cmd/Ctrl + <digit>` switches modules.
- **touch** (iPadOS/Android Pad, Windows tablet mode): `NavigationRail` collapses to a floating button / edge indicator after idle timeout, long-press reveals it, content area supports edge-swipe-back gesture.
- The shell itself is shared; only the **affordance layer** differs.

## REMOVED Requirements
### Requirement: `DesktopContentHost` 的 `IndexedStack` 多模块缓存
**Reason**: 当模块切换走外层 `MacosShellContentPage.setState` 即可；内层 Navigator 自身即可缓存各模块主页，无需 `IndexedStack` 同时缓存多模块；保留它会让「子页推入内层 Navigator」与「模块主页面在 IndexedStack 中」难以共存（容易把子页错误地压在 IndexedStack 的某一项之上）。**Migration**: 把现有 `_moduleCache` 中的主页面作为「各模块的初始路由注册表」，在外壳内层 Navigator 切换模块时，使用 `Navigator.pushAndRemoveUntil` 替换初始路由（保留栈上的子页通过 `willHandlePopInternally` 拦截并按需丢弃）。
