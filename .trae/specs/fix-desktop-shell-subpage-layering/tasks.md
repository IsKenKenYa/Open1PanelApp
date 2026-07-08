# Tasks

- [x] Task 1: 抽出 `ShellContentHost` 共用组件（统一 macOS/Windows/通用桌面端）
  - [x] SubTask 1.1: 在 `lib/ui/desktop/common/widgets/shell_content_host.dart` 新建 `ShellContentHost`（StatefulWidget），内部始终挂一个 `Navigator`，并通过 `GlobalKey<NavigatorState> _contentNavigatorKey` 暴露。
  - [x] SubTask 1.2: `ShellContentHost` 接收 `ClientModule module` + `Object? moduleArguments`（用于切换模块时定位初始路由），并用 `WillPopScope`/`PopScope` 拦截系统返回键，先尝试 `_contentNavigatorKey.currentState?.maybePop()`。
  - [x] SubTask 1.3: 写一个最小 widget 测试：构造 `ShellContentHost`，通过 `findShellContentNavigator`（新建）能拿到非空 `NavigatorState`。

- [x] Task 1.5: 按模块保留内层栈快照（多端共用）
  - [x] SubTask 1.5.1: 在 `ShellContentHost` 内部维护 `Map<ClientModule, _ModuleStackSnapshot>`；模块切换时 `_contentNavigatorKey.currentState` 通过 `popUntil(isFirst: true)` 收集当前栈描述（路径名列表），再调用 `pushAndRemoveUntil` 重建目标模块栈。
  - [x] SubTask 1.5.2: 新增 `lib/ui/desktop/common/widgets/module_stack_preserver.dart`（纯逻辑类），把栈快照的"序列化 / 反序列化"集中处理；测试覆盖"切回模块后子页位置恢复"。
  - [x] SubTask 1.5.3: 写测试：切到 Settings→Language，切到 Container，切回 Settings，应当还原到 Language 而不是 Settings 主页。

- [x] Task 1.6: 多端输入设备适配（鼠标/键盘 vs 触摸）
  - [x] SubTask 1.6.1: 在 `lib/core/platform/utils/platform_utils.dart` 新增 `InputDeviceKind inputDeviceKinds(BuildContext context)`，综合 `Platform.isMacOS/Windows/Linux`（返回 pointer）以及 `Platform.isIOS/Android + formFactor == tablet`（返回 touch）。
  - [x] SubTask 1.6.2: `ShellContentHost` 通过 `Builder` 包裹侧栏 + 内容区；指针模式下 `NavigationRail` 常驻 + 注册 `Shortcuts`/`Actions` 绑定 `Cmd/Ctrl+<digit>`；触摸模式下挂 `IdleTimer` + `FloatingActionButton` 折叠入口。
  - [x] SubTask 1.6.3: 内容区触摸模式启用 `Dismissible` 边缘返回手势（仅左侧 32dp 触发区），与 `Navigator.maybePop` 联动。
  - [x] SubTask 1.6.4: 写 widget 测试：模拟触摸平台，`NavigationRail` 在 idle 后折叠为 `FloatingActionButton`；指针平台保持原样。

- [x] Task 2: 替换 `DesktopContentHost` 的 `IndexedStack` 为 `ShellContentHost`
  - [x] SubTask 1.1: 改造 `lib/ui/desktop/common/widgets/desktop_content_host.dart`，当 `embeddedRoute != null` 时仍走原 `DesktopRoutedModuleHost` 兼容路径；当 `embeddedRoute == null` 时改为挂 `ShellContentHost(module: …)`，主模块页作为其初始路由。
  - [x] SubTask 1.2: 删除（或标记 `@Deprecated`）`_moduleCache` 与 `IndexedStack` 渲染；保留 `useStableModuleKey` 行为由 `ShellContentHost` 通过 `KeyedSubtree` 复现。
  - [x] SubTask 1.3: 跑现有 `desktop_shell_page_test.dart`，保证模块切换/缓存不破。

- [x] Task 3: 让 `openRouteRespectingShell` 走内层 `Navigator`
  - [x] SubTask 1.1: 新增 `lib/ui/routing/route_helpers.dart` 中的 `NavigatorState? findShellContentNavigator(BuildContext context)`：通过 `ShellContentHost._contentNavigatorKey.currentState` 拿到。
  - [x] SubTask 1.2: 在 `lib/features/shell/shell_navigation.dart` 中改写 `openRouteRespectingShell`：
    - 当 `target != null && PlatformUtils.isDesktop(context) && target.embedRouteInShell` 时
      - 调 `findShellContentNavigator(context)`；若非空，调 `Navigator.push(MaterialPageRoute(builder: …))` 来打开子页（这里走 `AppRouter.generateRoute` 的 `defaultBuilder`，避开 desktop override 再次套壳）。
      - 若为空，回退到 `pushReplacementNamed(home, …)`。
  - [x] SubTask 1.3: 在 iPad/Android Pad 平板路径（如果 `PlatformUtils.isDesktop(context)` 命中平板）同样走内层 Navigator。

- [x] Task 4: 各外壳页面接入 `ShellContentHost`
  - [x] SubTask 1.1: `lib/ui/desktop/macos/app/macos_shell_content_page.dart` —— `DesktopContentHost` 调用处保持 `embeddedRoute: _embeddedRouteName`，但让 `DesktopContentHost`（已改造）在 `embeddedRoute == null` 时也用 `ShellContentHost` 包裹主页面。
  - [x] SubTask 1.2: 同样改 `lib/ui/desktop/windows/app/windows_shell_content_page.dart`、`lib/ui/desktop/common/app/desktop_shell_page.dart`，以及 `lib/ui/tablet/` 下（若存在）等价页面。
  - [x] SubTask 1.3: 在每个外壳 `_buildShellContent` 中显式 `KeyedSubtree(key: shellContentKey)`，让 `findShellContentNavigator` 通过固定 key 命中。

- [x] Task 5: 抑制内层 Navigator 的全局 slide 动画（统一为 MDUI3 FadeThrough）
  - [x] SubTask 1.1: 在 `ShellContentHost` 的 `onGenerateRoute` 处用 `PageRouteBuilder` 自定义转场（200ms，旧页淡出 + 新页淡入并向上偏移 8dp 的 FadeThrough 效果），`barrierDismissible: false`。**不**使用水平 slide 动画。
  - [x] SubTask 1.2: 写一个 widget 测试：从子页返回时仅内容区有 fade 动画，侧栏无 `AnimatedSwitcher`/slide 动画；测试断言转场过程中 `NavigationRail` 的 `Element` 引用保持不变。

- [x] Task 6: 回归 & 集成测试
  - [x] SubTask 1.1: 扩充 `test/ui/desktop_shell_stability_policy_test.dart`：新增用例「点击设置 → 语言，仅内容区出现过渡；侧栏 `NavigationRail` widget 在过渡前后是同一 Element 引用」。
  - [x] SubTask 1.2: 新增 `test/ui/shell_content_navigator_test.dart`：验证 `findShellContentNavigator` 在桌面外壳内命中，在 `MaterialApp` 直挂的子 widget 中返回 null。
  - [x] SubTask 1.3: 新增 `test/ui/shell_input_device_adaptation_test.dart`：覆盖 pointer/touch 两种模式下 `NavigationRail` 形态差异。
  - [x] SubTask 1.4: 跑全量 `dart run test/scripts/test_runner.dart all`，确保不破其它用例。

# Task Dependencies
- Task 2 depends on Task 1
- Task 1.5 depends on Task 1
- Task 1.6 depends on Task 1
- Task 3 depends on Task 1
- Task 4 depends on Task 1, Task 1.5, Task 2
- Task 5 depends on Task 1
- Task 6 depends on Task 1, Task 1.5, Task 1.6, Task 3, Task 4, Task 5
