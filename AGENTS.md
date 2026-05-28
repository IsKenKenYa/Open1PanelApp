# 仓库开发规范

> **适用范围**：本规范适用于所有 AI IDE（Claude Code、Kiro、Cursor、Windsurf、GitHub Copilot 等）和人工开发者。
>
> **配套文档**：
> - `AGENTS.md`（本文）：硬性规则、架构规范、测试门禁、行为准则
> - `CLAUDE.md`：Claude Code 专用补充说明
> - `.kiro/steering/*.md`：Kiro 自动包含的开发指导
>
> **阅读优先级**：本文 > 配套文档 > 项目内其他文档

## 行为准则（硬约束）

**权衡**：这些准则偏向谨慎而非速度。对于简单任务，请自行判断。

### 编码前思考 — 不要假设，不要隐藏困惑，暴露权衡

- 明确陈述你的假设。不确定时，提问。
- 存在多种合理解释时，全部呈现 — 不要默默选一种执行。
- 存在更简单的做法时，提出异议。该推回时推回。
- 某事不清楚时，停下来。指出不清楚的地方，提问。

### 简洁优先 — 最少代码解决问题，不做投机性编写

- 不添加要求之外的功能。
- 不为单次使用代码创建抽象。
- 不添加未请求的"灵活性"或"可配置性"。
- 不为不可能发生的场景做错误处理。
- 200 行能写成 50 行的，重写。
- 检验标准：资深工程师会觉得过于复杂吗？如果是，简化。

### 精准修改 — 只碰必须碰的，只清理自己的烂摊子

编辑现有代码时：
- 不要"改进"相邻代码、注释或格式。
- 不要重构没坏的东西。
- 匹配现有风格，即使你偏好不同写法。
- 注意到无关死代码时提一下，不要自行删除。

你的改动产生孤儿代码时：
- 清理 **你自己的改动** 造成的无用 import/变量/函数。
- 不要删除 **预先存在的** 死代码，除非被要求。
- 检验标准：diff 中的每一行修改都应能直接追溯到用户的请求。

### 目标驱动执行 — 定义成功标准，循环直到验证通过

将指令式任务转化为可验证目标：
- "添加验证" → "为无效输入写测试，然后让它们通过"
- "修复 bug" → "写一个复现测试，然后让它通过"
- "重构 X" → "确保重构前后测试都通过"

多步骤任务先列简短计划，每步附验证方式：
```
1. [步骤] → 验证: [检查方式]
2. [步骤] → 验证: [检查方式]
3. [步骤] → 验证: [检查方式]
```

强成功标准让 Agent 能独立循环；弱标准（"让它工作"）需要不断澄清。

## 项目结构与模块组织
- 业务源码位于 `lib/`，核心目录包括：
  - `lib/api/v2/`：Retrofit API 客户端
  - `lib/core/`：基础设施与核心服务
  - `lib/data/`：数据模型与仓库
  - `lib/features/`：业务功能模块
  - `lib/pages/`：页面容器
  - `lib/shared/`：共享组件与常量
- 平台目录位于 `android/`、`ios/`、`macos/`、`windows/`、`linux/`、`web/`。
- 测试目录位于 `test/`，覆盖目录位于 `coverage/`。
- 结构规则：当同一功能模块达到 2 个及以上文件时，必须建立独立子目录（例如 `lib/core/auth/`）。

## 1Panel 只读与适配基线（强制）
- `docs/OpenSource/1Panel/**` 为上游镜像与参考资料，整个目录只读。
- 禁止直接或间接修改 `docs/OpenSource/1Panel/**` 下任何文件。
- 模块能力设计必须参考 1Panel Web 前端行为与交互语义，在客户端完成高保真功能还原。
- 在能力还原基础上允许客户端增强，增强方向至少包含：多机统一管理、MFA（多因素认证）等移动端价值能力。
- 当 Swagger、注解、路由与真实返回不一致时：必须通过客户端 API 测试确认真实行为并在客户端兼容；严禁通过修改上游文件来"修复契约"。

## 架构与分层（强制）
- 共享业务核心必须由 Dart 实现，原生层只承载 UI 容器与平台能力接入。
- 强制六层划分：
  - 状态层：默认 Provider，连接 UI 与业务逻辑（`lib/features/*/providers/`）
  - 服务层：业务规则与数据加工（`lib/core/services/` 或业务模块 `*_service.dart`）
  - 仓库层：数据单一事实来源（`lib/data/repositories/`）
  - 模型层：实体与请求响应结构（`lib/data/models/`）
  - API/基础设施层：外部通信、存储、平台交互（`lib/api/v2/`、`lib/core/network/`、`lib/core/storage/`、`lib/core/channel/`）
  - 核心配置层：路由、主题、国际化、全局配置（`lib/core/`）
- 依赖方向仅允许：`Presentation -> State -> Service/Repository -> API/Infra`。
- UI 层禁止直接调用 `lib/api/v2/`，必须通过 Service/Repository。
- 业务逻辑禁止写在 Widget `build()` 或原生 UI 控制器内。
- 状态管理默认 Provider，其他模式需评审通过。

## 跨平台 UI 治理（非 Web，强制）
- 适配范围：Android、iOS、iPadOS、macOS、Windows、Linux、HarmonyOS（目标平台）；Web 不在当前适配范围。
- MDUI3 是全平台可用基线，必须持续可运行，不得降级为"仅回退方案"。
- Apple（iOS/iPadOS/macOS）与 Windows 必须建设原生 UI 轨道，同时保留 MDUI3 通用轨道。
- 允许并鼓励多设计系统与多主题，但必须走统一注册中心与主题控制，禁止页面私自定义独立体系。
- 设计系统与主题是两层概念：
  - 设计系统：MDUI3、Apple 风格、Fluent/WinUI3 等
  - 主题配置：浅色、深色、动态色、品牌色、用户自定义方案
- 平台策略：
  - Windows：强制建设 Fluent/WinUI3 原生轨道
  - iOS/iPadOS/macOS：强制建设 SwiftUI 原生轨道，视觉方向适配 Liquid Glass 风格
  - Android：Dart MDUI3 为默认落地路径；原生实现仅允许经评审批准后引入
  - Linux：当前阶段以 Dart MDUI3 交付为主，原生容器能力按社区扩展路线规划
  - HarmonyOS：作为一等目标平台推进，当前以 Dart 共享业务核心 + ArkTS Platform Bridge 补齐系统能力，文件、下载、日志、媒体、认证等缺口优先走项目自有 facade 与 ArkTS 桥接
- 无论使用何种 UI 体系，共享业务逻辑都必须复用同一套 Dart State/Service/Repository/API，不得分叉为多套业务实现。
- 原生 UI 同样必须遵守 `Presentation -> State -> Service/Repository -> API/Infra`，不得跨层直接访问 API。
- HarmonyOS 原生层只承载平台能力，不得复制 1Panel 业务逻辑；Flutter 侧必须通过 `PlatformFileService`、`PlatformDiagnosticsService`、`PlatformDownloadService`、`PlatformMediaService` 等 facade 访问平台能力，禁止业务代码散落裸 `MethodChannel`。
- 桌面缓存模块页必须禁用非当前页 Hero；带 `FloatingActionButton` 的页面必须显式设置 `heroTag` 或显式禁用 Hero。
- 禁止可变 widget 自引用包装链。
- 桌面模块切换必须留在统一壳内，普通切换不得再次 `push` 完整壳或首页。
- 桌面 `Scaffold` / `AppBar` / `NavigationRail` / 壳内容区默认必须使用 `surface` 或 `surfaceContainer*`，禁止整页透明背景。

## 文件规模与拆分规则（严格）

### 文件大小限制
- 所有代码文件（文档与 Swagger 产物除外）硬上限为 `1000 LOC`，超出必须拆分。
- 推荐阈值：逻辑文件 ≤ `500 LOC`，UI 文件（Page/复合 Widget）≤ `800 LOC`。
- 单一逻辑/架构文件不得承担 3 个及以上功能域（职责上限为 2 个）。
- LOC 统计口径为非空非注释行，`*.g.dart`、`*.freezed.dart` 不计入。

### 文件修改原则（强制）
1. **在原文件上修改，不创建副本** — 禁止 `_fixed`、`_new`、`_v2`、`_temp`、`_backup`、`_old` 后缀。
2. **达到 1000 LOC 时才拆分** — 未达到时继续在原文件中修改。
3. **拆分后的文件使用有意义的名称** — 按职责命名，不使用版本后缀。Git 已有历史记录，不需要保留备份。

### 文件组织规则
- 子目录命名使用小写下划线，反映功能域。
- 避免创建过深的目录层级（建议不超过 4 层）。

## 自动化研发流程（强制）
- 所有模块开发必须按照以下自动化闭环执行，不得跳步：
  1. 需求拆解（明确能力边界、依赖、验收条件）
  2. 测试用例设计（单测、集成、UI/交互、契约偏差用例）
  3. 自动化测试基线准备（脚本、夹具、环境变量、门禁）
  4. 功能开发实现（按分层架构落地）
  5. 单元测试执行与修复
  6. 集成测试执行与修复（涉及 API/网络/数据写入时为必跑项）
  7. 文档与基线回写（模块文档、分析基线、兼容策略）
- 任一步骤失败必须回到对应步骤修复后再继续，不允许"带失败推进"。

## 构建、测试与开发命令

```bash
flutter pub get                              # 安装依赖
flutter run                                  # 调试运行
flutter analyze                              # 静态分析
flutter test                                 # 执行全部测试
flutter test test/<file>_test.dart           # 执行单个测试文件
flutter test --coverage                      # 生成覆盖率报告
flutter packages pub run build_runner build  # 生成模型与 Retrofit 代码
flutter packages pub run build_runner watch  # 监听变更自动代码生成
flutter build apk --release                  # 构建 Android APK
flutter build appbundle                      # 构建 Android App Bundle
flutter build ios --release                  # 构建 iOS（仅 macOS）
```

## 编码风格与命名规范
- Dart 使用 2 空格缩进，启用 `flutter_lints`。
- 文件命名使用小写下划线。
- 后缀规范：`_page.dart`、`_widget.dart`、`_service.dart`、`_model.dart`、`_repository.dart`。
- 日志规则：禁止使用 `print()` 或 `debugPrint()`，统一使用 `lib/core/services/logger/logger_service.dart` 中的 `appLogger`。

## 测试规范与门禁
- 测试文件以 `_test.dart` 结尾，按功能归档到 `test/` 子目录。
- Bug 修复必须补充回归测试。
- 提交前必须可运行 `flutter analyze`。
- 提交前必须可运行 `dart run test/scripts/test_runner.dart unit`。
- 涉及 API/网络或数据写入时，必须运行 `dart run test/scripts/test_runner.dart integration`。
- 涉及 UI 改动时，必须运行 `dart run test/scripts/test_runner.dart ui`。
- 涉及 Windows 原生 UI 轨道改动时，必须运行 `dotnet build windows/runner/native_host/OnePanelNativeHost/OnePanelNativeHost.csproj -c Debug`。
- 涉及 Apple 原生 UI 轨道改动时，必须在 macOS/CI 环境运行 `xcodebuild`（iOS + macOS）构建门禁并附结果。
- 涉及 HarmonyOS/OHOS 平台能力、依赖、存储、文件、下载、日志、媒体或构建配置时，必须运行 `hflutter build hap --release` 或等效完整 Flutter-OH 路径命令，并附 HAP 输出路径。
- 原生 UI 适配门禁失败必须阻断推进，不允许"带失败继续"。
- 回归基线使用 `dart run test/scripts/test_runner.dart all`。

## AI 工具集成与知识管理

### 知识库管理（适用于支持 MCP 的 AI IDE）
- 重大架构决策、关键约定、通用踩坑必须写入 `agent-memory-mcp`（`decision` / `pattern`）。
- 实施前应先执行 `memory_search` 检索既有结论，避免重复决策。
- 不支持 MCP 的 AI IDE：通过阅读本文档和 Git 历史获取项目知识。

### 文档同步规则
- 规范变更必须同步更新 `AGENTS.md`（本文）、`CLAUDE.md`、`.kiro/steering/*.md`。
- 跨平台 UI 或原生扩展策略变更时，必须同步更新 `docs/development/cross_platform_ui_governance.md`、`docs/模块适配专属工作流.md`、`docs/原生UI适配专属工作流.md`。

### AI IDE 特定配置
- **Claude Code**：参考 `AGENTS.md` + `CLAUDE.md`
- **Kiro**：使用 `.kiro/steering/*.md` 自动包含开发指导
- **Cursor/Windsurf**：主要参考 `AGENTS.md` 和 `.cursorrules`（如存在）
- **GitHub Copilot**：通过代码注释和文档上下文理解规范

## 知识图谱与代码索引

本项目同时使用两套代码智能工具，互相补充：

### graphify — 跨文件概念关系图谱
- 图谱位置：`graphify-out/`（已 gitignore）
- 查询：`graphify query "问题"` — BFS 遍历图谱回答架构问题
- 路径：`graphify path "模块A" "模块B"` — 两节点间最短路径
- 解释：`graphify explain "概念"` — 节点及其关联的详细说明
- 增量更新：`graphify update .` — 仅处理变更文件（代码自动，文档需手动）
- 监控：`graphify watch .` — 后台监控代码变更，自动重建图谱（注意：`watch` 是子命令，不是 `--watch` flag）
- 图谱报告：`graphify-out/GRAPH_REPORT.md` — God Nodes、意外连接、建议提问
- 适用场景：架构决策追溯、跨模块概念关系、文档/论文/图片语义理解

### CodeGraph — 代码符号索引与调用链
- 索引位置：`.codegraph/`（已 gitignore）
- 状态检查：`codegraph status`
- 增量同步：`codegraph sync`
- 监控：`codegraph serve --mcp`（MCP Server，自动同步，文件变更 2 秒后自动重建索引）
- 适用场景：符号搜索、调用链追踪（callers/callees）、影响分析（impact）、上下文构建（context）

### 使用优先级
1. 代码符号查询（谁调用了 X、X 调用了谁）→ 优先用 CodeGraph
2. 架构概念关系（模块间依赖、设计决策）→ 优先用 graphify
3. 文档/论文/图片理解 → 只有 graphify 支持

## 提交与合并请求规范
- 提交信息遵循 Conventional Commits，例如：`feat(scope): ...`、`fix(scope): ...`、`chore: ...`、`refactor: ...`。
- PR 需保持小步提交；大改动先开 issue 对齐范围。
- PR 必须包含：变更说明、测试结果、UI 变更截图（如适用）。
- 严禁在 issue、日志、截图中泄露密钥与敏感信息。

## 发布分支与 CI
- 长期主干分支：`dev-v2`，对标 1Panel 服务端 `dev-v2` 的单主干策略。
- `main` 分支计划移除，所有功能集成、稳定验证与发布准备均围绕 `dev-v2` 展开。
- Android APK 使用 tag 驱动发布：`debug-*`（Alpha）、`beta-*`（Beta 公开预览）、`pre-release-*`（Pre-Release）、`v*`（Release）。
- tag 来源约束：`debug` / `beta` / `pre-release` / `v*` 均必须来自 `dev-v2`。
- 版本号策略：当前默认仍采用客户端自身语义化版本（如 `v0.6.0`），与 1Panel V2 版本号同步的方案暂缓实施。

## 文档治理

### 核心原则
1. **先搜索，再创建** — 优先在现有文档中补充内容，避免碎片化。
2. **文档合并优先** — 多个相关主题应合并到同一文档的不同章节。
3. **文档更新优先于创建** — 现有文档可以满足需求时，更新现有文档。

### 允许的文档类型
- 核心规范：`README.md`、`AGENTS.md`、`CLAUDE.md`、`CHANGELOG.md`
- AI IDE 配置：`.kiro/steering/*.md`、`.cursorrules`、`.github/copilot-instructions.md`
- 架构与策略：`docs/development/*.md`、`docs/模块适配专属工作流.md`、`docs/原生UI适配专属工作流.md`
- 上游参考（只读）：`docs/OpenSource/1Panel/**`

### 信息记录位置
| 信息类型 | 记录位置 |
|---------|---------|
| Bug 修复说明 | `test/bugfix/*_test.dart` 注释 |
| 功能变更说明 | Git commit message |
| 架构决策 | `agent-memory-mcp` (MCP 支持的 IDE) |
| 开发流程指导 | `.kiro/steering/*.md` 或 `AGENTS.md` |

## 安全与配置说明
- API 访问使用 1Panel API Key，禁止提交密钥或令牌。
- 分享日志或复现步骤时必须脱敏 IP、用户名、凭据。
