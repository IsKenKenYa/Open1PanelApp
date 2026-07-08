# Checklist

## 架构与组件
- [x] `ShellContentHost` 共用组件已建立，并对外暴露 `GlobalKey<NavigatorState>`
- [x] `findShellContentNavigator` 帮助函数可在桌面/平板外壳内命中内层 `NavigatorState`
- [x] `DesktopContentHost` 替换 `IndexedStack` 后，外壳内容区始终由 `ShellContentHost` 承载
- [x] `module_stack_preserver.dart` 已建立，能正确序列化/反序列化每个模块的内层栈

## 导航行为
- [x] 桌面端（macOS/Windows/Linux）点击二级入口，仅右侧内容区出现过渡动画
- [x] 桌面端 `NavigationRail` 在子页过渡前后保持同一 `Element` 引用，未被 `MaterialPageRoute` 整体替换
- [x] 桌面端顶栏 `AppBar`/工具栏在子页过渡中不参与动画
- [x] 平板端（iPadOS/Android Pad）行为与桌面端一致
- [x] 移动端（phone）行为保持现有 `pushNamed`，不受影响
- [x] 当 `findShellContentNavigator` 命中失败时（如直接测试），回退到 `pushReplacementNamed(home, …)`，不破已有调用方
- [x] 从 Settings→Language 切到 Container 再切回 Settings，仍停在 Language 子页（按模块保留栈）

## 内层 Navigator 转场
- [x] 内层 `Navigator` 使用 `PageRouteBuilder` 自定义转场（200ms FadeThrough：旧页淡出 + 新页淡入并向上偏移 8dp），**不是**水平 slide-in
- [x] `barrierDismissible` 关闭，不会因为点击空白处意外退出
- [x] 内层栈多次 push 时，新页面在内容区叠加，不影响侧栏/顶栏
- [x] 转场过程中 `NavigationRail` 的 `Element` 引用保持不变（widget 测试断言）

## 多端输入设备适配
- [x] `PlatformUtils.inputDeviceKinds(context)` 返回 `pointer` 或 `touch`
- [x] 指针模式（macOS/Windows/Linux 桌面）：`NavigationRail` 常驻可见
- [x] 指针模式：`Cmd/Ctrl + <digit>` 快捷键切换模块
- [x] 触摸模式（iPadOS/Android Pad/Windows 平板模式）：`NavigationRail` 在 idle 后折叠为 `FloatingActionButton`，长按展开
- [x] 触摸模式：内容区左侧 32dp 边缘支持滑动手势返回
- [x] 不同输入设备下壳层只切交互 affordance，视觉风格与 MDUI3 主题保持一致

## 路由与回退
- [x] `openRouteRespectingShell` 在桌面/平板且 `embedRouteInShell: true` 时走内层 `Navigator.push`
- [x] 系统/浏览器返回按钮先 `Navigator.maybePop` 内层栈；内层栈空时再走外壳或顶层回退
- [x] `embedRouteInShell: false` 的路由（如顶层模块切换）继续走 `pushReplacementNamed(home, …)`，与原行为一致

## 回归保护
- [x] `test/ui/desktop_shell_stability_policy_test.dart` 新增「侧栏不参与过渡」断言
- [x] `test/ui/shell_content_navigator_test.dart` 新增 `findShellContentNavigator` 命中/未命中两组用例
- [x] `test/ui/shell_input_device_adaptation_test.dart` 覆盖 pointer/touch 两种模式
- [x] 现有 `desktop_shell_page_test.dart`、`ui_route_host_test.dart`、`desktop_routed_module_host_recursion_test.dart` 全部通过
- [x] `dart run test/scripts/test_runner.dart unit` / `integration` / `ui` 全部通过

## 平台覆盖
- [x] macOS 26 Dart MDUI3 轨道：内层 Navigator 使用 FadeThrough；macOS 原生视觉差异由原生 UI 轨道承担，本轨道不引入
- [x] macOS 15 至少能打开，无 stack overflow
- [x] Windows Fluent/WinUI3 Dart 轨道：与 macOS Dart 轨道表现一致
- [x] Linux 按 Dart MDUI3 交付并满足本规格
- [x] iPadOS / Android Pad 平板路径覆盖（触摸模式 affordance）
- [x] Windows 平板模式（触摸模式 affordance）覆盖
