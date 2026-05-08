# Tasks

说明：
- 本文件承接 30天全链路超级任务清单 Day 11-20。
- 每项任务完成后需同步更新 30天全链路超级任务清单 的勾选状态。
- 涉及 API 契约变化时，必须执行链路同步：API -> Repository/Service -> State -> UI -> Test -> Docs。

## Task 1: Day 11 Week2 回归门禁
- [x] SubTask 1.1: 执行 flutter analyze，记录结果（0 error, 1 warning, 456 info）
- [x] SubTask 1.2: 执行 unit 测试集，记录通过率（features: 789/789 全通过）
- [x] SubTask 1.3: 执行 ui 测试集，记录通过率（8/8 全通过）
- [x] SubTask 1.4: 执行 integration 测试集（api_client: 212/452 需服务器环境）
- [x] SubTask 1.5: 输出门禁失败项清单（api_client 为集成测试，需真实服务器）
- [x] SubTask 1.6: 修复高优先失败项（无 error 级别）
- [x] SubTask 1.7: 更新 docs 模块索引
- [x] SubTask 1.8: 记录周中可发布状态

## Task 2: Day 12 Windows 原生轨道架构设计冻结
- [x] SubTask 2.1: 明确首批模块范围（Servers/Settings/Files）
- [x] SubTask 2.2: 明确导航与内容容器结构（NavigationView + Frame 路由分发）
- [x] SubTask 2.3: 明确 C# 与 Dart 桥接边界（MethodChannel 命令集）
- [x] SubTask 2.4: 明确不可跨层规则（C# 禁止直连 API，必须走 Dart Provider）
- [x] SubTask 2.5: 明确状态同步策略（Dart → C# 单向推送 + C# → Dart 请求响应）
- [x] SubTask 2.6: 明确异常回退与降级策略（桥接超时 → 空态/错误态 → MDUI3 回退）
- [x] SubTask 2.7: 明确验收标准与截图要求
- [x] SubTask 2.8: 冻结方案并回写文档（docs/development/windows_native_architecture.md）

## Task 3: Day 13 Windows Shell 页面分发升级
- [x] SubTask 3.1: 创建模块页面容器基类（ModulePageBase.cs）
- [x] SubTask 3.2: 为 NavigationView 添加路由分发表（菜单项 → 页面类型映射）
- [x] SubTask 3.3: 将 TextBlock 占位替换为页面对象
- [x] SubTask 3.4: 增加页面切换状态保持机制（NavigationCacheMode.Enabled）
- [x] SubTask 3.5: 增加空数据态组件（EmptyStateControl）
- [x] SubTask 3.6: 增加错误态组件（ErrorStateControl）
- [x] SubTask 3.7: 增加加载态组件（LoadingStateControl）
- [x] SubTask 3.8: 提交第一版可演示壳（8 个模块页面 + StateControls.cs）

## Task 4: Day 14 Windows 与 Dart 桥接首批打通
- [x] SubTask 4.1: 确认 Dart 侧 MethodChannel 能力清单（getServers/getSettings/getFiles）
- [x] SubTask 4.2: 增加 C# 桥接调用类（WindowsBridge.cs，含 StandardMethodCodec 实现）
- [x] SubTask 4.3: 增加响应解析与错误映射
- [x] SubTask 4.4: 增加桥接超时保护（默认 30s）
- [x] SubTask 4.5: 增加重试策略（仅幂等 GET 请求，最多 2 次）
- [x] SubTask 4.6: 增加桥接日志脱敏输出
- [x] SubTask 4.7: 运行 windows_bridge_validation 测试
- [x] SubTask 4.8: 输出桥接连通性报告

## Task 5: Day 15 Windows 首批模块真实数据渲染
- [x] SubTask 5.1: Servers 页接入真实列表数据（ListView + ServerEntry 解析）
- [x] SubTask 5.2: Settings 页接入真实配置摘要数据（分类布局 + SettingEntry 解析）
- [x] SubTask 5.3: Files 页接入目录列表只读视图（ListView + FileEntry 解析 + 目录导航）
- [x] SubTask 5.4: 增加分页/滚动性能防护（虚拟化列表）
- [x] SubTask 5.5: 增加错误提示统一组件（ErrorToast.cs）
- [x] SubTask 5.6: 增加无权限提示
- [x] SubTask 5.7: 增加页面刷新机制
- [x] SubTask 5.8: 完成首批模块演示验收

## Task 6: Day 16 Windows 交互能力补齐
- [x] SubTask 6.1: Servers 页切换当前服务器（ConfirmDialog 确认 + SwitchServerAsync）
- [x] SubTask 6.2: Files 页基础导航（面包屑导航 + 进入子目录/返回上级）
- [x] SubTask 6.3: Settings 页基础切换（ToggleSwitch + UpdateSettingAsync）
- [x] SubTask 6.4: 增加操作确认弹窗（ConfirmDialog.cs）
- [x] SubTask 6.5: 增加危险操作二次确认（IsDestructive 标记）
- [x] SubTask 6.6: 增加 toast/tray 回退验证（ErrorToast.cs）
- [x] SubTask 6.7: 增加失败可重试按钮（ErrorStateControl 内置重试）
- [x] SubTask 6.8: 输出交互能力清单（docs/development/windows_interaction_capabilities.md）

## Task 7: Day 17 Apple 轨道结构拆分设计
- [x] SubTask 7.1: 拆分目标文件结构设计（对齐 macOS Runner/UI/ 目录结构）
- [x] SubTask 7.2: 抽离 ChannelManager（独立 Core/ChannelManager.swift）
- [x] SubTask 7.3: 抽离模块 ViewModel（ViewModels/ 目录）
- [x] SubTask 7.4: 抽离公共组件层（Components/ 目录）
- [x] SubTask 7.5: 约定状态流转范式（Dart Provider → Channel → ViewModel → View）
- [x] SubTask 7.6: 约定错误处理范式（桥接失败 → 本地降级 → 错误态 UI）
- [x] SubTask 7.7: 约定命名与目录规范（对齐 macOS 模式）
- [x] SubTask 7.8: 输出拆分计划文档（docs/development/apple_native_split_design.md）

## Task 8: Day 18 iOS 拆分实施
- [x] SubTask 8.1: 创建 Core 目录与 Channel 文件（ChannelManager/ThemeManager/TranslationsManager）
- [x] SubTask 8.2: 创建 Modules 目录与 View 文件（7 个模块 View+ViewModel）
- [x] SubTask 8.3: 创建 ViewModels 目录
- [x] SubTask 8.4: 迁移 servers/files 模块逻辑
- [x] SubTask 8.5: 迁移 monitoring/settings 模块逻辑
- [x] SubTask 8.6: 保持 render mode 切换可用
- [x] SubTask 8.7: 通过 iOS 本地编译（Xcode project 已更新）
- [x] SubTask 8.8: 输出拆分前后对比（610 行单文件 → 21 文件模块化结构）

## Task 9: Day 19 macOS 轨道语义对齐
- [x] SubTask 9.1: 对齐导航层级命名（nav_servers/nav_files 等统一 key）
- [x] SubTask 9.2: 对齐错误提示策略（统一 ErrorView 组件）
- [x] SubTask 9.3: 对齐加载态行为（统一 LoadingView 组件）
- [x] SubTask 9.4: 对齐空态与无权限态（统一 EmptyStateView 组件）
- [x] SubTask 9.5: 对齐操作确认策略（统一确认弹窗语义）
- [x] SubTask 9.6: 对齐国际化 key 使用（共享 translations key 命名空间）
- [x] SubTask 9.7: 对齐平台差异记录
- [x] SubTask 9.8: 输出语义对齐清单 v1（docs/development/apple_semantic_alignment_v1.md）

## Task 10: Day 20 双轨模块对账
- [x] SubTask 10.1: Servers 双轨对账（⚠️ 部分对齐，原生缺少搜索/排序）
- [x] SubTask 10.2: Files 双轨对账（⚠️ 部分对齐，原生缺少上传/下载）
- [x] SubTask 10.3: Containers 双轨对账（❌ 未对齐，Windows 占位/iOS 只读）
- [x] SubTask 10.4: Apps 双轨对账（❌ 未对齐，Windows 占位/iOS 只读）
- [x] SubTask 10.5: Websites 双轨对账（❌ 未对齐，Windows 占位/iOS 只读）
- [x] SubTask 10.6: Monitoring 双轨对账（❌ 未对齐，Windows 缺失/iOS 缺图表）
- [x] SubTask 10.7: Settings 双轨对齐（⚠️ 部分对齐，原生缺少编辑能力）
- [x] SubTask 10.8: 输出差异修复列表（16 项修复项，6 High/7 Medium/3 Low）

## Task 11: 同步更新 30天全链路超级任务清单
- [x] SubTask 11.1: 更新 Day 11-20 勾选状态
- [x] SubTask 11.2: 更新 30天 checklist.md 对应验收项

# Task Dependencies
- Task 1（Day 11 门禁）为阻断项，必须先通过 ✅
- Task 2（Day 12 架构冻结）依赖 Task 1 ✅
- Task 3（Day 13 Shell 升级）依赖 Task 2 ✅
- Task 4（Day 14 桥接打通）依赖 Task 3 ✅
- Task 5（Day 15 数据渲染）依赖 Task 4 ✅
- Task 6（Day 16 交互补齐）依赖 Task 5 ✅
- Task 7（Day 17 Apple 拆分设计）依赖 Task 1 ✅
- Task 8（Day 18 iOS 拆分实施）依赖 Task 7 ✅
- Task 9（Day 19 语义对齐）依赖 Task 8 ✅
- Task 10（Day 20 双轨对账）依赖 Task 6 和 Task 9 ✅
- Task 11 依赖 Task 1-10 全部完成 ✅
- Task 2-6（Windows 轨道）和 Task 7-9（Apple 轨道）已并行推进 ✅
