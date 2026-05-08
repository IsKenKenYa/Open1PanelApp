# Windows 原生轨道架构设计

## 1. 首批模块范围

| 模块 | 功能 | 说明 |
|------|------|------|
| Servers | 服务器列表、切换当前服务器 | 展示已注册服务器，支持一键切换当前活跃服务器 |
| Settings | 系统设置摘要、展示类设置切换 | 只读展示关键设置项，支持布尔类设置快速切换 |
| Files | 目录列表只读视图、子目录导航 | 只读浏览目录结构，支持进入子目录 |

首批模块选择原则：

- 数据结构简单，JSON 序列化/反序列化成本低
- 交互模式以列表展示和简单操作为主，不涉及复杂表单
- 可完整验证 NavigationView 导航、Frame 页面缓存、MethodChannel 桥接、四态切换等核心机制

## 2. 导航与内容容器结构

### 主容器

- 主容器使用 `NavigationView`（左侧菜单 + 右侧内容区）
- 对应当前 [MainWindow.xaml](../../windows/runner/native_host/OnePanelNativeHost/MainWindow.xaml) 中的 `RootNavigationView`

### 菜单项

NavigationView 菜单项与 1Panel 模块一一对应：

| 菜单项 | Icon | 首批实现 |
|--------|------|----------|
| Servers | Globe | 是 |
| Files | Folder | 是 |
| Containers | AllApps | 否 |
| Apps | Library | 否 |
| Websites | World | 否 |
| AI | PreviewLink | 否 |
| Security | Protect | 否 |
| Settings | Setting | 是 |

非首批模块在导航中保留占位，点击后显示"即将支持"提示页面。

### 内容路由

- NavigationView `SelectionChanged` 事件触发 `Frame.Navigate(typeof(ModulePage))`
- 每个模块对应一个独立 Page 类型
- 页面注册映射表：

```csharp
static readonly Dictionary<string, Type> _pageMap = new()
{
    ["Servers"] = typeof(ServersPage),
    ["Files"] = typeof(FilesPage),
    ["Containers"] = typeof(PlaceholderPage),
    ["Apps"] = typeof(PlaceholderPage),
    ["Websites"] = typeof(PlaceholderPage),
    ["AI"] = typeof(PlaceholderPage),
    ["Security"] = typeof(PlaceholderPage),
    ["Settings"] = typeof(SettingsPage),
};
```

### 页面缓存

- 页面设置 `NavigationCacheMode.Enabled`，保持页面状态
- 切换菜单项时页面实例保留，避免重复创建和重复数据拉取
- 页面 `OnNavigatedTo` 时拉取最新数据刷新视图

## 3. C# 与 Dart 桥接边界

### 桥接方式

- 使用 MethodChannel `com.openpanel.windows/shell_bridge`
- 与现有窗口管理通道 `onepanel/windows_bridge`（[windows_shell_bridge.dart](../../lib/core/channel/windows/windows_shell_bridge.dart)）并行，职责分离
- `onepanel/windows_bridge`：窗口管理、托盘、通知等系统级能力
- `com.openpanel.windows/shell_bridge`：业务数据获取与渲染模式控制

### 命令集

| 命令 | 方向 | 参数 | 返回值 | 说明 |
|------|------|------|--------|------|
| getServers | C# -> Dart | 无 | `List<ServerInfo>` | 获取服务器列表 |
| getCurrentServer | C# -> Dart | 无 | `ServerInfo` | 获取当前活跃服务器 |
| switchServer | C# -> Dart | `id: String` | `bool` | 切换当前服务器 |
| getFiles | C# -> Dart | `path: String` | `List<FileEntry>` | 获取指定路径下的文件列表 |
| getSettingsSummary | C# -> Dart | 无 | `SettingsSummary` | 获取设置摘要 |
| setRenderMode | C# -> Dart | `mode: String` | `bool` | 切换渲染模式（native/mdui3） |
| getRenderMode | C# -> Dart | 无 | `String` | 获取当前渲染模式 |

### 数据格式

- 所有数据通过 JSON 序列化/反序列化传递
- C# 端使用 `System.Text.Json`，Dart 端使用 `dart:convert`
- 数据模型示例：

```json
{
  "id": "srv-001",
  "name": "Production",
  "host": "192.168.1.100",
  "port": 8888,
  "isActive": true
}
```

### 不可跨层规则

- C# 端禁止直连 HTTP API，必须通过 Dart Provider/Service 获取数据
- C# 端仅作为 Presentation Layer，不承载任何业务逻辑
- 数据流向严格遵循：`C# UI -> MethodChannel -> Dart Service/Repository -> Dart API/Infra`
- 违反此规则的代码不得合并

## 4. 状态同步策略

### Dart -> C#（推送）

- 使用 EventChannel 推送状态变更通知
- 推送场景：
  - 服务器列表变更（新增、删除、状态变化）
  - 当前服务器切换完成
  - 设置项变更
- C# 端监听 EventChannel 流，收到通知后调用对应 MethodChannel 拉取最新数据

### C# -> Dart（请求/响应）

- 使用 MethodChannel 进行请求/响应式通信
- 所有数据操作（查询、切换、修改）均通过 MethodChannel 同步完成
- MethodChannel 调用超时设置为 30 秒

### 生命周期

- 页面 `OnNavigatedTo` 时拉取最新数据
- 页面 `OnNavigatedFrom` 时不销毁数据，保留缓存状态
- EventChannel 推送的数据变更会触发当前可见页面刷新

### 同步流程图

```
Dart Provider/Service
       |
       | EventChannel (推送通知)
       v
  C# EventListener
       |
       | MethodChannel (拉取数据)
       v
  C# Page.ViewModel
       |
       | 数据绑定
       v
  C# Page.UI
```

## 5. 异常回退与降级策略

### 桥接超时

- 超时阈值：30 秒
- 超时后显示错误态组件（ErrorStateControl）+ 重试按钮
- 重试按钮触发重新调用 MethodChannel

### 桥接连续失败

- 连续失败 3 次后弹出提示对话框
- 对话框内容：建议切换到 MDUI3 模式以获得完整功能
- 提供"切换到 MDUI3 模式"按钮，调用 `setRenderMode("mdui3")`
- 提供"继续重试"按钮，重置失败计数

### 数据为空

- 显示空态组件（EmptyStateControl）
- 空态组件包含图标、提示文字和操作按钮（如"添加服务器"）

### 无权限

- 显示无权限提示
- 提示内容说明当前用户无权访问该模块
- 提供"返回"按钮导航到有权限的页面

### 降级策略汇总

| 异常场景 | 降级行为 | 用户操作 |
|----------|----------|----------|
| 桥接超时（30s） | 显示错误态 + 重试按钮 | 点击重试 |
| 桥接失败 3 次 | 提示切换 MDUI3 模式 | 切换模式或继续重试 |
| 数据为空 | 显示空态组件 | 执行引导操作 |
| 无权限 | 显示无权限提示 | 返回其他页面 |

## 6. 页面组件体系

### ModulePageBase（基类）

所有模块页面的基类，提供四态切换能力：

```
ModulePageBase : Page
  ├── LoadingState    (加载中)
  ├── ContentState    (正常内容)
  ├── EmptyState      (数据为空)
  └── ErrorState      (加载失败)
```

基类职责：

- 管理当前页面状态（Loading/Content/Empty/Error）
- 提供状态切换方法（`ShowLoading()`、`ShowContent()`、`ShowEmpty()`、`ShowError()`）
- 统一处理桥接调用、超时、异常
- 提供 `OnDataLoaded()` 虚方法供子类实现数据渲染逻辑

### 具体页面

| 页面 | 基类 | 渲染内容 |
|------|------|----------|
| ServersPage | ModulePageBase | 服务器列表（ListView），当前服务器高亮，点击切换 |
| SettingsPage | ModulePageBase | 设置摘要分组（StackPanel + ToggleSwitch），布尔项可切换 |
| FilesPage | ModulePageBase | 文件/目录列表（ListView），目录项可点击进入子目录 |
| PlaceholderPage | Page | "即将支持"提示文字 |

### 状态控件

| 控件 | 用途 |
|------|------|
| LoadingStateControl | 显示 ProgressRing + 加载提示文字 |
| ErrorStateControl | 显示错误图标 + 错误信息 + 重试按钮 |
| EmptyStateControl | 显示空态图标 + 提示文字 + 引导操作按钮 |

### 页面状态流转

```
页面创建 -> LoadingState
    |
    v
桥接调用成功
    |
    +-- 数据非空 -> ContentState
    |
    +-- 数据为空 -> EmptyState
    |
桥接调用失败
    |
    +-- ErrorState -> 用户点击重试 -> LoadingState
    |
    +-- 连续失败3次 -> 提示切换 MDUI3
```

## 7. 验收标准

### 构建门禁

- `dotnet build windows/runner/native_host/OnePanelNativeHost/OnePanelNativeHost.csproj -c Debug` 可通过
- 无编译错误，无编译警告（除第三方依赖警告外）

### 导航功能

- NavigationView 菜单切换可显示对应页面
- 首批模块（Servers/Files/Settings）显示实际内容页面
- 非首批模块显示 PlaceholderPage
- 页面切换时状态保留（NavigationCacheMode.Enabled）

### 四态切换

- 页面初始进入时显示 LoadingState
- 数据加载成功后正确切换到 ContentState 或 EmptyState
- 桥接失败时显示 ErrorState
- 重试按钮可触发重新加载

### 桥接调用

- 桥接调用可返回数据（需 Flutter 引擎运行）
- 数据 JSON 序列化/反序列化正确
- 超时和异常处理符合降级策略

### 渲染模式切换

- `setRenderMode("mdui3")` 可切换到 MDUI3 模式
- `setRenderMode("native")` 可切换回原生模式
- `getRenderMode` 可正确返回当前模式

### 架构合规

- C# 端无直接 HTTP 调用
- 所有数据通过 MethodChannel 从 Dart 端获取
- 页面组件继承体系符合 ModulePageBase 规范
