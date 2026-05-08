# Apple 原生轨道结构拆分设计

## 0. 现状分析

### iOS 当前状态

当前 iOS 原生轨道全部代码集中在 `ios/Runner/AppDelegate.swift` 单文件中（约 610 行），包含：

| 组件 | 行范围 | 职责 |
|------|--------|------|
| `RunnerApp` | 1-36 | App 入口 + render mode 切换 |
| `ContentView` | 38-176 | TabView 容器 + 全部 MethodChannel 调用 + 全部 @State 数据 |
| `ServersView` | 178-231 | 服务器列表视图 |
| `FilesView` | 233-290 | 文件列表视图 |
| `ContainersView` | 292-366 | 容器列表视图 |
| `AppsView` | 368-418 | 应用列表视图 |
| `WebsitesView` | 420-465 | 网站列表视图 |
| `MonitoringView` | 467-522 | 监控指标视图 |
| `MetricRow` | 524-542 | 共享指标行组件 |
| `FlutterViewControllerRepresentable` | 544-557 | Flutter 视图桥接 |
| `AppDelegate` | 559-581 | FlutterAppDelegate + engine 配置 |
| `NativeSettingsView` | 583-610 | 设置视图 |

**核心问题**：
- 无 ViewModel 层，数据通过 props 从 ContentView 逐层传递
- 无 ChannelManager，MethodChannel 创建和调用散落在 ContentView 中
- 无 ThemeManager / TranslationsManager，翻译通过 props 传递
- 无统一的加载/错误/空态处理
- 文件已达 610 行，继续增长将超出 1000 LOC 限制

### macOS 已有模式（参照基线）

macOS 已完成拆分，目录结构为：

```
macos/Runner/UI/
├── Core/
│   ├── ChannelManager.swift        # 单例，invokeDataMethod / invokeDataMethodAsync
│   ├── ThemeManager.swift          # 单例 ObservableObject，主题属性
│   ├── TranslationsManager.swift   # 单例 ObservableObject，翻译字典
│   └── ViewExtensions.swift        # 视图扩展
├── Components/
│   └── VisualEffectView.swift      # 毛玻璃效果组件
├── Modules/
│   ├── AI/                         # AIView + AIViewModel
│   ├── Apps/                       # AppsView + AppsViewModel
│   ├── Backups/                    # BackupsView + BackupsViewModel
│   ├── Containers/                 # ContainersView + ContainersViewModel
│   ├── CronJobs/                   # CronJobsView + CronJobsViewModel
│   ├── Dashboard/                  # DashboardView + DashboardViewModel
│   ├── Databases/                  # DatabasesView + DatabasesViewModel
│   ├── Files/                      # FilesView + FilesViewModel
│   ├── Firewall/                   # FirewallView + FirewallViewModel
│   ├── Monitoring/                 # MonitoringView + MonitoringViewModel
│   ├── Servers/                    # ServersView + ServersViewModel
│   ├── Settings/                   # SettingsView + SettingsViewModel
│   ├── Shell/                      # MainShellView + SidebarView + FlutterContentView
│   └── Websites/                   # WebsitesView + WebsitesViewModel
```

macOS ViewModel 范式（以 ServersViewModel 为例）：
- `ObservableObject` class，`@Published` 属性驱动 UI
- 通过 `ChannelManager.shared.invokeDataMethod()` 获取数据
- 包含 `isLoading`、`errorMessage`、业务数据等状态
- ViewModel 内部处理 `DispatchQueue.main.async` 切换

macOS View 范式（以 ServersView 为例）：
- `@StateObject` 持有 ViewModel
- `@EnvironmentObject` 注入 ThemeManager / TranslationsManager
- 根据 `viewModel.isLoading` / `viewModel.servers.isEmpty` 切换加载/空态/内容视图

---

## 1. 拆分目标文件结构（对齐 macOS Runner/UI/ 目录结构）

```
ios/Runner/UI/
├── Core/
│   ├── ChannelManager.swift        # MethodChannel 通信管理
│   ├── ThemeManager.swift          # 主题/深浅色管理
│   └── TranslationsManager.swift   # 国际化管理
├── Modules/
│   ├── Servers/
│   │   ├── ServersView.swift
│   │   └── ServersViewModel.swift
│   ├── Files/
│   │   ├── FilesView.swift
│   │   └── FilesViewModel.swift
│   ├── Containers/
│   │   ├── ContainersView.swift
│   │   └── ContainersViewModel.swift
│   ├── Apps/
│   │   ├── AppsView.swift
│   │   └── AppsViewModel.swift
│   ├── Websites/
│   │   ├── WebsitesView.swift
│   │   └── WebsitesViewModel.swift
│   ├── Monitoring/
│   │   ├── MonitoringView.swift
│   │   └── MonitoringViewModel.swift
│   └── Settings/
│       ├── SettingsView.swift
│       └── SettingsViewModel.swift
├── Components/
│   ├── LoadingView.swift
│   ├── ErrorView.swift
│   └── EmptyStateView.swift
└── Shell/
    └── AppShellView.swift           # TabView 容器 + render mode 切换
```

拆分后 `AppDelegate.swift` 仅保留：

```swift
@main
struct RunnerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var uiRenderMode: String = "native"
    @State private var modeLoaded: Bool = false

    var body: some Scene {
        WindowGroup {
            if !modeLoaded {
                Color.white.ignoresSafeArea().onAppear { loadRenderMode() }
            } else if uiRenderMode == "md3" {
                FlutterViewControllerRepresentable(engine: appDelegate.flutterEngine)
                    .ignoresSafeArea()
            } else {
                AppShellView(engine: appDelegate.flutterEngine)
            }
        }
    }

    private func loadRenderMode() { ... }
}

@objc class AppDelegate: FlutterAppDelegate {
    let flutterEngine = FlutterEngine(name: "my flutter engine")
    override func application(...) -> Bool { ... }
}
```

---

## 2. ChannelManager 抽离方案

### 2.1 从 AppDelegate.swift 提取的内容

当前 iOS 中 MethodChannel 的使用分散在两处：

1. **AppDelegate**（第 570 行）：创建 `onepanel/ios_channel`，处理 `ping` 方法
2. **ContentView**（第 101-175 行）：创建 `com.onepanel.client/method`，调用 `getTranslations`、`getServers`、`getFiles`、`getContainers`、`getApps`、`getWebsites`、`getMonitoring`

### 2.2 统一为 ChannelManager 单例

对齐 macOS `ChannelManager.swift` 的接口设计，iOS 版本差异点：

| 方面 | macOS | iOS |
|------|-------|-----|
| 导入 | `FlutterMacOS` | `Flutter` |
| 二进制信使 | `FlutterBinaryMessenger` | 同左 |
| Shell Channel | `onepanel/macos_shell` | `onepanel/ios_shell` |

```swift
import Foundation
import Flutter

class ChannelManager {
    static let shared = ChannelManager()

    private var dataChannel: FlutterMethodChannel?
    private var shellChannel: FlutterMethodChannel?

    private init() {}

    func setup(binaryMessenger: FlutterBinaryMessenger) {
        dataChannel = FlutterMethodChannel(
            name: "com.onepanel.client/method",
            binaryMessenger: binaryMessenger
        )
        shellChannel = FlutterMethodChannel(
            name: "onepanel/ios_shell",
            binaryMessenger: binaryMessenger
        )
    }

    func invokeDataMethod(_ method: String, arguments: Any? = nil,
                          completion: @escaping (Any?) -> Void) {
        guard let dataChannel = dataChannel else {
            completion(nil)
            return
        }
        dataChannel.invokeMethod(method, arguments: arguments) { result in
            completion(result)
        }
    }

    func invokeDataMethodAsync(_ method: String, arguments: Any? = nil) async throws -> Any? {
        return try await withCheckedThrowingContinuation { continuation in
            guard let dataChannel = dataChannel else {
                continuation.resume(throwing: NSError(
                    domain: "ChannelManager", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Data channel not initialized"]
                ))
                return
            }
            dataChannel.invokeMethod(method, arguments: arguments) { result in
                if let flutterError = result as? FlutterError {
                    continuation.resume(throwing: NSError(
                        domain: "FlutterError",
                        code: Int(flutterError.code) ?? -1,
                        userInfo: [NSLocalizedDescriptionKey: flutterError.message ?? "Unknown error"]
                    ))
                } else if (result as AnyObject) === FlutterMethodNotImplemented {
                    continuation.resume(throwing: NSError(
                        domain: "FlutterError", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Method not implemented"]
                    ))
                } else {
                    continuation.resume(returning: result)
                }
            }
        }
    }

    func invokeShellMethod(_ method: String, arguments: Any? = nil,
                           completion: @escaping (Any?) -> Void) {
        guard let shellChannel = shellChannel else {
            completion(nil)
            return
        }
        shellChannel.invokeMethod(method, arguments: arguments) { result in
            completion(result)
        }
    }
}
```

### 2.3 向后兼容

- `AppDelegate` 保留 `FlutterAppDelegate` 继承 + `flutterEngine.run()` + plugin 注册
- 在 `didFinishLaunchingWithOptions` 中调用 `ChannelManager.shared.setup(binaryMessenger:)` 替代原有的 channel 创建逻辑
- 原有 `onepanel/ios_channel` 的 `ping` handler 迁移至 `ChannelManager.setup()` 中的 `shellChannel` 处理

---

## 3. ViewModel 抽离方案

### 3.1 ViewModel 基本范式

每个 ViewModel 为 `ObservableObject` class（对齐 macOS 模式），包含：

- `@Published var isLoading: Bool` - 加载状态
- `@Published var errorMessage: String?` - 错误信息
- `@Published var` + 业务数据属性
- 数据获取方法：调用 `ChannelManager.shared.invokeDataMethod()` 获取数据

### 3.2 iOS 与 macOS ViewModel 差异

| 方面 | macOS | iOS |
|------|-------|-----|
| 数据模型 | 独立 struct（如 `ServerModel`） | 当前使用 `[[String: Any]]` |
| 列表组件 | `Table` | `List` |
| 导航结构 | `NavigationSplitView` | `TabView` |

**建议**：iOS ViewModel 同样引入独立数据模型 struct（如 `ServerModel`），与 macOS 共享模型定义逻辑。

### 3.3 ServersViewModel 示例

当前 iOS ContentView 中的 `loadServers()` 方法（第 117-125 行）：

```swift
// 当前：ContentView 中的方法
private func loadServers() {
    channel?.invokeMethod("getServers", arguments: nil) { result in
        if let result = result as? [[String: Any]] {
            DispatchQueue.main.async {
                self.servers = result
            }
        }
    }
}
```

拆分后 ServersViewModel：

```swift
import Foundation

struct ServerModel: Identifiable {
    let originalId: String
    let name: String
    let url: String
    let isCurrent: Bool
    let cpu: Double
    let memory: Double

    var id: String { originalId }
}

class ServersViewModel: ObservableObject {
    @Published var servers: [ServerModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchServers() {
        isLoading = true
        errorMessage = nil
        ChannelManager.shared.invokeDataMethod("getServers") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let dictArray = result as? [[String: Any]] else { return }
                self?.servers = dictArray.compactMap { dict in
                    guard let name = dict["name"] as? String,
                          let url = dict["url"] as? String else { return nil }
                    let rawId = dict["id"]
                    let originalId: String
                    if let intId = rawId as? Int { originalId = String(intId) }
                    else { originalId = rawId as? String ?? "" }
                    let isCurrent = dict["isCurrent"] as? Bool ?? false
                    let cpu = dict["cpu"] as? Double ?? 0
                    let memory = dict["memory"] as? Double ?? 0
                    return ServerModel(
                        originalId: originalId, name: name,
                        url: url, isCurrent: isCurrent,
                        cpu: cpu, memory: memory
                    )
                }
            }
        }
    }
}
```

### 3.4 状态流转

```
Dart Provider/Service
    |  MethodChannel (com.onepanel.client/method)
    v
ChannelManager (单例)
    |  invokeDataMethod / invokeDataMethodAsync
    v
ViewModel (@ObservableObject)
    |  @Published 属性变化
    v
SwiftUI View
```

### 3.5 各模块 ViewModel 提取映射

| 模块 | 当前位置（ContentView 行号） | 提取目标 |
|------|---------------------------|---------|
| Servers | loadServers (117-125) | ServersViewModel.fetchServers() |
| Files | loadFiles (127-135) | FilesViewModel.fetchFiles(path:) |
| Containers | loadContainers (137-145) | ContainersViewModel.fetchContainers() |
| Apps | loadApps (147-155) | AppsViewModel.fetchApps() |
| Websites | loadWebsites (157-165) | WebsitesViewModel.fetchWebsites() |
| Monitoring | loadMonitoring (167-175) | MonitoringViewModel.fetchMonitoring() |
| Translations | loadTranslations (107-115) | TranslationsManager.load() |

---

## 4. 公共组件层抽离方案

### 4.1 LoadingView

统一加载指示器，替代各模块中分散的加载态处理：

```swift
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

### 4.2 ErrorView

统一错误提示 + 重试按钮：

```swift
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    @EnvironmentObject var translations: TranslationsManager

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button(translations.get("retry", fallback: "Retry"), action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

### 4.3 EmptyStateView

统一空态提示：

```swift
struct EmptyStateView: View {
    let icon: String
    let message: String
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil
    @EnvironmentObject var translations: TranslationsManager

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text(message)
                .foregroundColor(.secondary)
            if let label = actionLabel, let action = action {
                Button(label, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

### 4.4 现有共享组件迁移

| 当前位置 | 迁移目标 |
|---------|---------|
| `MetricRow`（第 524-542 行） | `Components/MetricRow.swift` |
| `FlutterViewControllerRepresentable`（第 544-557 行） | `Components/FlutterViewControllerRepresentable.swift` |

---

## 5. 状态流转范式

### 5.1 数据流

```
Dart Provider/Service
    |
    | MethodChannel (com.onepanel.client/method)
    v
ChannelManager (单例，ios/Runner/UI/Core/ChannelManager.swift)
    |
    | invokeDataMethod("getServers") / invokeDataMethodAsync("getServers")
    v
ServersViewModel (@ObservableObject, ios/Runner/UI/Modules/Servers/ServersViewModel.swift)
    |
    | @Published servers / isLoading / errorMessage
    v
ServersView (SwiftUI, ios/Runner/UI/Modules/Servers/ServersView.swift)
```

### 5.2 主题与翻译流

```
Dart ThemeProvider / L10n
    |
    | MethodChannel
    v
ThemeManager / TranslationsManager (单例 ObservableObject)
    |
    | @EnvironmentObject 注入
    v
所有 View
```

### 5.3 Render Mode 切换流

```
RunnerApp
    |
    | getUIRenderMode -> "native" / "md3"
    v
AppShellView (native) / FlutterViewControllerRepresentable (md3)
```

---

## 6. 错误处理范式

### 6.1 错误流转

```
桥接调用 (ChannelManager.invokeDataMethod)
    |
    | 失败（channel 未初始化 / FlutterError / FlutterMethodNotImplemented）
    v
ChannelManager 返回 nil 或 throw NSError
    |
    | ViewModel 检测
    v
设置 errorMessage 状态 + isLoading = false
    |
    | View 检测 errorMessage != nil
    v
显示 ErrorView + 重试按钮
```

### 6.2 ViewModel 错误处理模板

```swift
func fetchData() {
    isLoading = true
    errorMessage = nil
    ChannelManager.shared.invokeDataMethod("getXxx") { [weak self] result in
        DispatchQueue.main.async {
            self?.isLoading = false
            if let error = result as? FlutterError {
                self?.errorMessage = error.message ?? "Unknown error"
                return
            }
            guard let data = result as? [[String: Any]] else {
                self?.errorMessage = "Invalid data format"
                return
            }
            // parse data...
        }
    }
}
```

### 6.3 View 错误处理模板

```swift
var body: some View {
    Group {
        if viewModel.isLoading {
            LoadingView()
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error, onRetry: viewModel.fetchData)
        } else if viewModel.items.isEmpty {
            EmptyStateView(icon: "tray", message: translations.get("noData"))
        } else {
            // content
        }
    }
}
```

---

## 7. 命名与目录规范（对齐 macOS 模式）

### 7.1 文件命名

| 类型 | 规范 | 示例 |
|------|------|------|
| View | PascalCase | `ServersView.swift` |
| ViewModel | PascalCase | `ServersViewModel.swift` |
| Model | PascalCase | `ServerModel.swift`（如需独立文件） |
| Component | PascalCase | `LoadingView.swift` |
| Core Manager | PascalCase | `ChannelManager.swift` |

### 7.2 目录命名

- 目录命名使用 PascalCase（如 `Modules/Servers/`）
- 与 macOS 保持一致的命名空间

### 7.3 ViewModel 命名

- 格式：`{Module}ViewModel`
- 示例：`ServersViewModel`、`FilesViewModel`、`ContainersViewModel`

### 7.4 Channel 方法命名

- 格式：`get{Module}{Action}`
- 示例：`getServers`、`getFiles`、`getContainers`、`getApps`、`getWebsites`、`getMonitoring`
- 与 macOS ChannelManager 的方法名完全一致

### 7.5 iOS 与 macOS 命名对照

| iOS | macOS | 说明 |
|-----|-------|------|
| `AppShellView` (TabView) | `MainShellView` (NavigationSplitView) | 容器视图，平台差异 |
| `ChannelManager` | `ChannelManager` | 接口一致，导入不同 |
| `ThemeManager` | `ThemeManager` | 接口一致 |
| `TranslationsManager` | `TranslationsManager` | 接口一致 |
| `ServersViewModel` | `ServersViewModel` | 接口一致 |
| `ServersView` | `ServersView` | UI 实现不同（List vs Table） |

---

## 8. 拆分实施步骤

### 第一步：创建 Core/ 目录，提取 ChannelManager / ThemeManager / TranslationsManager

- 创建 `ios/Runner/UI/Core/` 目录
- 从 AppDelegate.swift 提取 MethodChannel 逻辑到 `ChannelManager.swift`
- 从 AppDelegate.swift 提取主题相关逻辑到 `ThemeManager.swift`（对齐 macOS ThemeManager）
- 从 AppDelegate.swift 提取翻译逻辑到 `TranslationsManager.swift`（对齐 macOS TranslationsManager）
- 在 AppDelegate 中调用 `ChannelManager.shared.setup(binaryMessenger:)`

### 第二步：创建 Components/ 目录，提取公共组件

- 创建 `ios/Runner/UI/Components/` 目录
- 提取 `MetricRow` 到 `Components/MetricRow.swift`
- 提取 `FlutterViewControllerRepresentable` 到 `Components/FlutterViewControllerRepresentable.swift`
- 新建 `LoadingView.swift`、`ErrorView.swift`、`EmptyStateView.swift`

### 第三步：创建 Modules/ 目录，逐模块提取 View + ViewModel

按以下顺序逐模块提取（每个模块独立可验证）：

1. **Servers** - 最成熟的模块，macOS 已有完整 ViewModel 参考
2. **Files** - 包含路径参数，验证参数传递模式
3. **Containers** - 包含状态颜色逻辑
4. **Apps** - 结构相对简单
5. **Websites** - 结构相对简单
6. **Monitoring** - 使用 MetricRow 共享组件
7. **Settings** - 包含 render mode 切换逻辑

每个模块提取步骤：
1. 创建 `Modules/{Module}/` 目录
2. 创建 `{Module}ViewModel.swift`，从 ContentView 提取数据加载方法
3. 创建 `{Module}View.swift`，从 AppDelegate.swift 提取视图代码
4. View 使用 `@StateObject` 持有 ViewModel，`@EnvironmentObject` 注入主题/翻译
5. 验证模块独立运行

### 第四步：创建 Shell/ 目录，提取 AppShellView

- 创建 `ios/Runner/UI/Shell/` 目录
- 从 AppDelegate.swift 提取 `ContentView`（TabView 容器）到 `AppShellView.swift`
- AppShellView 负责组装各模块 View 到 TabView
- 注入 `ThemeManager` 和 `TranslationsManager` 为 `@EnvironmentObject`

### 第五步：AppDelegate.swift 精简

- 仅保留 `RunnerApp`（App 入口 + render mode 切换）和 `AppDelegate`（FlutterAppDelegate 继承 + engine 配置）
- 预期精简至约 40 行

### 第六步：验证 render mode 切换仍可用

- 测试 native mode：AppShellView 正常显示
- 测试 md3 mode：FlutterViewControllerRepresentable 正常显示
- 测试切换后重启生效

### 第七步：验证 iOS 编译通过

- 确认所有新文件已添加到 Xcode 项目
- 运行 `flutter build ios --debug` 确认编译通过
- 在模拟器上验证各模块功能正常

---

## 附录 A：iOS 与 macOS 目录结构对照

```
ios/Runner/UI/                          macos/Runner/UI/
├── Core/                               ├── Core/
│   ├── ChannelManager.swift    <-->    │   ├── ChannelManager.swift
│   ├── ThemeManager.swift      <-->    │   ├── ThemeManager.swift
│   └── TranslationsManager.swift <-->  │   ├── TranslationsManager.swift
│                                       │   └── ViewExtensions.swift
├── Modules/                            ├── Modules/
│   ├── Servers/                <-->    │   ├── Servers/
│   ├── Files/                  <-->    │   ├── Files/
│   ├── Containers/             <-->    │   ├── Containers/
│   ├── Apps/                   <-->    │   ├── Apps/
│   ├── Websites/               <-->    │   ├── Websites/
│   ├── Monitoring/             <-->    │   ├── Monitoring/
│   └── Settings/               <-->    │   ├── Settings/
│                                       │   ├── AI/
│                                       │   ├── Backups/
│                                       │   ├── CronJobs/
│                                       │   ├── Dashboard/
│                                       │   ├── Databases/
│                                       │   ├── Firewall/
│                                       │   └── Shell/
├── Components/                         ├── Components/
│   ├── LoadingView.swift               │   └── VisualEffectView.swift
│   ├── ErrorView.swift                 │
│   ├── EmptyStateView.swift            │
│   ├── MetricRow.swift                 │
│   └── FlutterViewControllerRepresentable.swift
└── Shell/                              (macOS Shell 在 Modules/Shell/ 内)
    └── AppShellView.swift
```

## 附录 B：iOS 特有模块规划（后续迭代）

macOS 已有但 iOS 尚未实现的模块，后续迭代按需添加：

| 模块 | macOS 状态 | iOS 优先级 |
|------|-----------|-----------|
| Dashboard | 已实现 | P1 |
| Databases | 已实现 | P1 |
| AI | 已实现 | P2 |
| Backups | 已实现 | P2 |
| CronJobs | 已实现 | P2 |
| Firewall | 已实现 | P3 |
