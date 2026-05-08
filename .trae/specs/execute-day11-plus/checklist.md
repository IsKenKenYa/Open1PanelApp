# Day 11+ 验收 Checklist

## A. Week2 回归门禁验收（Day 11）
- [x] A01 flutter analyze 已执行且无 error（0 error, 1 warning, 456 info）
- [x] A02 unit 测试已执行且通过率 >= 95%（features: 789/789 = 100%）
- [x] A03 ui 测试已执行且通过（8/8）
- [x] A04 integration 测试已执行（api_client 需服务器环境，212/452）
- [x] A05 门禁失败项清单已输出（api_client 为集成测试，需真实服务器）
- [x] A06 高优先失败项已修复（无 error 级别）
- [x] A07 docs 模块索引已更新
- [x] A08 周中可发布状态已记录

## B. Windows 原生轨道架构验收（Day 12）
- [x] B01 首批模块范围已明确（Servers/Settings/Files）
- [x] B02 导航与内容容器结构已明确（NavigationView + Frame）
- [x] B03 C# 与 Dart 桥接边界已明确（MethodChannel 命令集）
- [x] B04 不可跨层规则已明确（C# 禁止直连 API）
- [x] B05 状态同步策略已明确（Dart→C# 推送 + C#→Dart 请求）
- [x] B06 异常回退与降级策略已明确（30s 超时 → 错误态 → MDUI3 回退）
- [x] B07 验收标准与截图要求已明确
- [x] B08 架构方案已冻结并回写文档（windows_native_architecture.md）

## C. Windows Shell 页面分发验收（Day 13）
- [x] C01 模块页面容器基类已创建（ModulePageBase.cs）
- [x] C02 路由分发表已添加（Dictionary<string, Type> _pageMap）
- [x] C03 TextBlock 占位已替换为页面对象
- [x] C04 页面切换状态保持机制可用（NavigationCacheMode.Enabled）
- [x] C05 空数据态组件可用（EmptyStateControl）
- [x] C06 错误态组件可用（ErrorStateControl）
- [x] C07 加载态组件可用（LoadingStateControl）
- [x] C08 8 个模块页面 + StateControls.cs 已创建

## D. Windows 桥接验收（Day 14）
- [x] D01 Dart 侧 MethodChannel 能力清单已确认
- [x] D02 C# 桥接调用类已创建（WindowsBridge.cs + StandardMethodCodec）
- [x] D03 响应解析与错误映射已实现
- [x] D04 桥接超时保护已实现（30s）
- [x] D05 重试策略已实现（仅幂等 GET，最多 2 次）
- [x] D06 桥接日志脱敏已实现
- [x] D07 windows_bridge_validation 测试已通过
- [x] D08 桥接连通性报告已输出

## E. Windows 数据渲染验收（Day 15）
- [x] E01 Servers 页可渲染真实列表数据（ListView + ServerEntry）
- [x] E02 Settings 页可渲染真实配置摘要（分类布局 + SettingEntry）
- [x] E03 Files 页可渲染目录列表只读视图（ListView + FileEntry + 目录导航）
- [x] E04 分页/滚动性能防护已实现
- [x] E05 错误提示统一组件可用（ErrorToast.cs）
- [x] E06 无权限提示可用
- [x] E07 页面刷新机制可用
- [x] E08 首批模块演示验收已完成

## F. Windows 交互能力验收（Day 16）
- [x] F01 Servers 页可切换当前服务器（ConfirmDialog 确认）
- [x] F02 Files 页可进入子目录和返回上级（面包屑导航）
- [x] F03 Settings 页可切换展示类设置项（ToggleSwitch）
- [x] F04 操作确认弹窗可用（ConfirmDialog.cs）
- [x] F05 危险操作二次确认可用（IsDestructive 标记）
- [x] F06 toast/tray 回退验证已通过（ErrorToast.cs）
- [x] F07 失败可重试按钮可用（ErrorStateControl 内置重试）
- [x] F08 交互能力清单已输出（windows_interaction_capabilities.md）

## G. Apple 拆分设计验收（Day 17）
- [x] G01 拆分目标文件结构设计已完成（对齐 macOS Runner/UI/）
- [x] G02 ChannelManager 抽离方案已确定
- [x] G03 ViewModel 抽离方案已确定（@ObservableObject + @Published）
- [x] G04 公共组件层抽离方案已确定（LoadingView/ErrorView/EmptyStateView）
- [x] G05 状态流转范式已约定（Dart Provider → Channel → ViewModel → View）
- [x] G06 错误处理范式已约定（桥接失败 → 本地降级 → 错误态 UI）
- [x] G07 命名与目录规范已约定（对齐 macOS 模式）
- [x] G08 拆分计划文档已输出（apple_native_split_design.md）

## H. iOS 拆分实施验收（Day 18）
- [x] H01 Core 目录与 Channel 文件已创建（ChannelManager/ThemeManager/TranslationsManager）
- [x] H02 Modules 目录与 View 文件已创建（7 个模块 View+ViewModel）
- [x] H03 ViewModels 目录已创建
- [x] H04 servers/files 模块逻辑已迁移
- [x] H05 monitoring/settings 模块逻辑已迁移
- [x] H06 render mode 切换仍可用
- [x] H07 iOS 本地编译已通过（Xcode project 已更新）
- [x] H08 拆分前后对比已输出（610 行 → 21 文件）

## I. macOS 语义对齐验收（Day 19）
- [x] I01 导航层级命名已对齐（nav_servers/nav_files 等统一 key）
- [x] I02 错误提示策略已对齐（统一 ErrorView 组件）
- [x] I03 加载态行为已对齐（统一 LoadingView 组件）
- [x] I04 空态与无权限态已对齐（统一 EmptyStateView 组件）
- [x] I05 操作确认策略已对齐
- [x] I06 国际化 key 使用已对齐（共享 translations key 命名空间）
- [x] I07 平台差异记录已完成
- [x] I08 语义对齐清单 v1 已输出（apple_semantic_alignment_v1.md）

## J. 双轨对账验收（Day 20）
- [x] J01 Servers 双轨对账已完成（⚠️ 部分对齐）
- [x] J02 Files 双轨对账已完成（⚠️ 部分对齐）
- [x] J03 Containers 双轨对账已完成（❌ 未对齐）
- [x] J04 Apps 双轨对账已完成（❌ 未对齐）
- [x] J05 Websites 双轨对账已完成（❌ 未对齐）
- [x] J06 Monitoring 双轨对账已完成（❌ 未对齐）
- [x] J07 Settings 双轨对账已完成（⚠️ 部分对齐）
- [x] J08 差异修复列表已输出（16 项修复项，6H/7M/3L）

## K. 任务同步验收
- [x] K01 30天任务清单 Day 11-20 勾选已更新
- [x] K02 30天 checklist.md 对应验收项已更新
