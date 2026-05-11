# CI 运行手册

## CI 工作流概览

本项目包含以下 CI 工作流：

| 工作流 | 文件 | 触发条件 | 说明 |
|--------|------|----------|------|
| Flutter CI | `flutter-ci.yml` | push/PR 到 `dev-v2` | 静态分析 + 单元测试 |
| Flutter UI Tests | `flutter-ui-test.yml` | push/PR 到 `dev-v2` | UI 测试 |
| Flutter Integration Tests | `flutter-integration.yml` | 手动触发 | 集成测试 |
| Android Tag Release | `android-tag-release.yml` | tag 推送 (`debug-*`, `beta-*`, `pre-release-*`, `v*`) | Android 发布构建 |
| macOS Build | `macos-build.yml` | 按配置触发 | macOS 构建 |
| iOS Build | `ios-build.yml` | 按配置触发 | iOS 构建 |
| Windows Native Build | `windows-native-build.yml` | 按配置触发 | Windows 原生构建 |
| Doc Sync Check | `doc-sync-check.yml` | PR 到 `dev-v2`（路径过滤） | 文档同步检查 |

## 触发条件详解

### 自动触发

- **push 到 `dev-v2`**：触发 Flutter CI 和 Flutter UI Tests
- **PR 到 `dev-v2`**：触发 Flutter CI、Flutter UI Tests 和 Doc Sync Check
- **Tag 推送**：触发 Android Tag Release（仅限 `debug-*`、`beta-*`、`pre-release-*`、`v*` 格式）

### 手动触发

- **Flutter Integration Tests**：在 GitHub Actions 页面点击 "Run workflow"
- **Android Tag Release**：支持 `workflow_dispatch` 手动触发

### 并发控制

所有工作流均配置了 `concurrency`，同一分支的重复运行会自动取消前一次。

## 本地运行 CI 等效命令

在推送代码前，建议在本地运行以下命令确保通过 CI 检查：

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 静态分析（对应 Analyze 任务）

```bash
flutter analyze
```

预期输出：`No issues found!`

### 3. 单元测试（对应 Unit Tests 任务）

```bash
flutter test test/features test/api test/core test/data test/auth test/config test/shared --no-pub
```

### 4. UI 测试（对应 UI Tests 任务）

```bash
flutter test test/ui --no-pub
```

### 5. 集成测试（对应 Integration Tests 任务）

```bash
flutter test test/api_client test/integration --no-pub
```

### 6. 完整回归基线

```bash
dart run test/scripts/test_runner.dart all
```

### 7. 代码生成（如修改了模型或 API）

```bash
flutter packages pub run build_runner build
```

## CI 结果解读

### Flutter CI 工作流

#### Analyze 任务

- ✅ **通过**：输出 `No issues found!`
- ❌ **失败**：输出包含 `error`、`warning` 或 `info` 级别的问题
- 查看 Job Summary 中的 "🔍 Analyze Results" 获取问题统计

#### Unit Tests 任务

- ✅ **通过**：输出 `All tests passed!`
- ❌ **失败**：输出包含失败的测试用例详情
- 查看 Job Summary 中的 "🧪 Unit Test Results" 获取通过/失败计数
- 失败时可下载 `unit-test-results` artifact 查看完整日志

#### 网络重试机制

单元测试任务内置了网络故障重试机制：

- 最多重试 2 次（共 3 次尝试）
- 仅当输出包含 `Connection`、`SocketException` 或 `TimeoutException` 时触发重试
- 非网络故障不会重试，直接失败

### Flutter UI Tests 工作流

- ✅ **通过**：所有 UI 测试通过
- ❌ **失败**：可下载 `ui-test-results` artifact 查看完整日志

### Doc Sync Check 工作流

- ✅ **通过**：所有文档时间戳同步
- ⚠️ **警告**：PR 中会收到评论，列出需要更新的文档

## 处理不稳定测试（Flaky Tests）

### 识别不稳定测试

不稳定测试的特征：

- 同一代码多次运行结果不一致
- 仅在 CI 环境失败，本地通过
- 失败信息涉及网络、时序、资源竞争

### 处理策略

1. **确认是否为网络问题**：查看 CI 日志是否包含 `Connection`、`SocketException`、`TimeoutException`。CI 已内置网络重试机制，如果重试后仍失败，需进一步排查。

2. **本地复现**：
   ```bash
   # 多次运行同一测试
   for i in {1..5}; do flutter test test/path/to/test.dart; done
   ```

3. **添加超时和重试**：在测试中添加 `timeout` 参数：
   ```dart
   test('my test', () async {
     // ...
   }, timeout: Timeout(Duration(seconds: 30)));
   ```

4. **使用 test retry 标签**：对于已知的不稳定测试，使用 `@Retry` 注解：
   ```dart
   import 'package:test/test.dart';
   
   @Retry(2)
   void main() {
     test('flaky test', () {
       // ...
     });
   }
   ```

5. **隔离外部依赖**：将网络请求替换为 mock，避免依赖外部服务。

6. **报告和跟踪**：在 `test/bugfix/` 中创建回归测试，注释中说明不稳定测试的问题和修复方案。

## 添加新测试文件到 CI

### 单元测试

1. 在 `test/` 对应子目录下创建 `_test.dart` 文件
2. 确认文件位于以下目录之一（已被 CI 覆盖）：
   - `test/features/`
   - `test/api/`
   - `test/core/`
   - `test/data/`
   - `test/auth/`
   - `test/config/`
   - `test/shared/`
3. 如果新增了顶层测试目录，需更新 `flutter-ci.yml` 中 `Run Unit Tests` 步骤的路径列表

### UI 测试

1. 在 `test/ui/` 目录下创建 `_test.dart` 文件
2. UI 测试会自动包含在 `flutter-ui-test.yml` 中

### 集成测试

1. 在 `test/api_client/` 或 `test/integration/` 目录下创建 `_test.dart` 文件
2. 集成测试需手动触发运行

### 新增测试目录

如果需要新增测试目录（如 `test/services/`），需同步更新：

1. `flutter-ci.yml` 中 `Run Unit Tests` 步骤的路径
2. `AGENTS.md` 中的测试命令说明
3. 本手册中的本地运行命令

## 缓存策略

CI 使用以下缓存加速构建：

| 缓存类型 | 路径 | Key | 说明 |
|----------|------|-----|------|
| Pub | `~/.pub-cache`, `.dart_tool` | `pub-{os}-{hashFiles(pubspec.lock)}` | Dart 依赖 |
| Gradle | `~/.gradle/caches`, `~/.gradle/wrapper` | `gradle-{os}-{hashFiles(android/**/*.gradle*, android/gradle-wrapper.properties)}` | Android 构建依赖 |
| Flutter SDK | 由 `subosito/flutter-action` 管理 | 基于 flutter-version 和 channel | Flutter SDK |

缓存失效条件：

- `pubspec.lock` 变更时 Pub 缓存失效
- Android Gradle 文件变更时 Gradle 缓存失效
- `restore-keys` 提供部分匹配的回退缓存

## Artifact 说明

| Artifact 名称 | 工作流 | 条件 | 保留天数 |
|---------------|--------|------|----------|
| `unit-test-results` | Flutter CI | 测试失败时 | 7 |
| `ui-test-results` | Flutter UI Tests | 测试失败时 | 7 |

Artifact 包含 `test-results/` 目录下的完整测试输出日志，可在 GitHub Actions 运行页面下载。
