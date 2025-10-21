# 日志系统规则

## 概述

本项目使用统一的日志系统，位于 `lib/core/services/logger_service.dart`，禁止直接使用 `print()` 语句。日志系统根据不同的构建模式（debug/release）配置不同的日志级别，并支持包名标识以区分不同模块的日志。

## 日志级别规范

### 日志级别定义

- **Trace (t)**: 最详细的日志信息，仅在Debug模式下使用
- **Debug (d)**: 调试信息，仅在Debug和Profile模式下使用
- **Info (i)**: 一般信息，在Debug和Profile模式下使用
- **Warning (w)**: 警告信息，在所有模式下使用
- **Error (e)**: 错误信息，在所有模式下使用
- **Fatal (f)**: 严重错误信息，在所有模式下使用

### 构建模式与日志级别

- **Debug模式**: 输出所有级别的日志（Trace, Debug, Info, Warning, Error, Fatal）
- **Profile模式**: 输出Info、Warning、Error和Fatal级别的日志
- **Release模式**: 仅输出Warning、Error和Fatal级别的日志

## 日志输出格式

### 基本格式

所有日志输出必须包含包名标识，格式为 `[包名] 日志内容`。例如：
```
[auth.service] 用户登录成功
[network.api] 请求失败: 404
```

### 包名规范

- 包名应使用小写字母和点号分隔，例如 `auth.service`、`network.api`
- 包名应反映日志来源的模块和功能
- 包名应与文件路径对应，例如：
  - `lib/features/dashboard/dashboard_service.dart` 使用包名 `[features.dashboard]`
  - `lib/core/services/logger_service.dart` 使用包名 `[core.services]`
- 如果不指定包名，系统会自动添加默认包名 `[core.services]`

## 日志过滤规则

系统会自动过滤包含以下标签的日志：
- `MESA` - 过滤MESA图形相关日志
- `exportSyncFdForQSRILocked` - 过滤特定图形系统日志
- 包含特定关键词的日志（在LoggerConfig中配置）

### 自定义过滤

可以在 `lib/core/config/logger_config.dart` 中配置自定义过滤规则：

```dart
static bool shouldFilterLog(String message) {
  // 添加自定义过滤逻辑
  if (message.contains('不必要的关键词')) {
    return true;
  }
  return false;
}
```

## 日志使用方法

### 基本使用

```dart
import 'core/services/logger_service.dart';

// 基本日志输出
appLogger.d('[包名] 这是一条Debug级别日志');
appLogger.i('[包名] 这是一条Info级别日志');
appLogger.w('[包名] 这是一条Warning级别日志');
appLogger.e('[包名] 这是一条Error级别日志');
appLogger.f('[包名] 这是一条Fatal级别日志');
```

### 带包名的日志输出

```dart
// 带包名的日志输出
appLogger.dWithPackage('auth.service', '用户登录成功');
appLogger.iWithPackage('network.api', '请求发送成功');
appLogger.wWithPackage('database', '连接缓慢');
appLogger.eWithPackage('file.manager', '文件读取失败', error: e, stackTrace: stackTrace);
appLogger.fWithPackage('system', '系统崩溃', error: e, stackTrace: stackTrace);
```

### 带异常和堆栈跟踪的日志

```dart
try {
  // 可能出错的代码
} catch (e, stackTrace) {
  appLogger.e('[包名] 捕获到异常', error: e, stackTrace: stackTrace);
}
```

## 代码规范

### 禁止使用print()
- 禁止在代码中直接使用 `print()` 语句
- 禁止使用 `debugPrint()` 语句
- 必须使用统一的日志系统 `appLogger` 替代
- 所有日志输出必须使用 `appLogger` 实例

### 包名规范
- 所有日志输出必须包含包名标识
- 日志中的包名应与文件路径对应，例如：
  - `lib/features/dashboard/dashboard_service.dart` 使用包名 `[features.dashboard]`
  - `lib/core/services/logger_service.dart` 使用包名 `[core.services]`
- 包名应使用小写字母和点号分隔，例如 `auth.service`、`network.api`
- 包名应反映日志来源的模块和功能
- 使用 `appLogger.dWithPackage()` 等带包名的方法，或确保消息本身包含包名
- 如果不指定包名，系统会自动添加默认包名 `[core.services]`

### 日志级别选择
- **Trace**: 用于追踪详细的执行流程，仅在Debug模式使用
- **Debug**: 用于调试信息，仅在Debug和Profile模式使用
- **Info**: 用于记录一般信息，在Debug和Profile模式使用
- **Warning**: 用于记录潜在问题，在所有模式使用
- **Error**: 用于记录错误和异常，在所有模式使用
- **Fatal**: 用于记录致命错误，在所有模式使用
- 根据日志的重要性选择合适的级别
- Debug和Trace级别仅在开发环境使用
- 生产环境只应看到Warning及以上级别的日志

## 开发流程

### 新功能开发
1. 在相应包目录下创建文件
2. 使用统一的日志系统记录日志
3. 确保日志包含正确的包名前缀
4. 根据日志内容选择适当的日志级别
5. 确保错误日志包含错误对象和堆栈跟踪

### 问题排查
1. 使用Debug模式获取详细日志
2. 使用包名前缀过滤特定模块的日志
3. 关注Error和Fatal级别的日志

### 代码审查
- 代码审查时检查是否使用了正确的日志方法
- 确保所有日志都包含包名标识
- 检查日志级别是否合适

## 违规处理
- 代码审查时发现直接使用 `print()` 语句将被要求修改
- 日志不包含包名标识将被要求修改
- 使用不当的日志级别将被要求修改

## 最佳实践

### 性能考虑
- 避免在高频调用的代码中使用Trace或Debug级别日志
- 复杂对象的日志输出应考虑性能影响
- Release模式下自动过滤低级别日志以提高性能

### 可读性
- 日志消息应清晰、简洁，包含必要的上下文信息
- 错误日志应包含足够的信息以便排查问题
- 使用一致的日志格式和命名约定

### 调试支持
- Debug模式下提供详细的日志信息
- 关键操作应记录日志以便追踪问题
- 使用包名标识快速定位日志来源