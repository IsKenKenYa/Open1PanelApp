# Flutter 统一日志系统

这个统一日志系统基于 [logger](https://pub.dev/packages/logger) 库实现，提供了根据不同构建模式（debug/release）自动配置日志级别的功能。

## 功能特点

- 根据构建模式自动配置日志级别
- 过滤不需要的日志（如MESA图形相关日志）
- 统一的日志输出格式
- 支持多种日志级别（Trace, Debug, Info, Warning, Error, Fatal）
- 可定制的日志输出配置

## 日志级别配置

### Debug模式
- 输出所有级别的日志（Trace, Debug, Info, Warning, Error, Fatal）
- 显示完整的方法调用栈
- 显示时间戳

### Profile模式
- 输出Info、Warning和Error级别的日志
- 限制方法调用栈显示
- 显示时间戳

### Release模式
- 仅输出Warning和Error级别的日志
- 不显示方法调用栈
- 不显示时间戳

## 日志过滤

系统会自动过滤包含以下标签的日志：
- `MESA` - 过滤MESA图形相关日志
- `exportSyncFdForQSRILocked` - 过滤特定图形系统日志

## 使用方法

### 1. 初始化日志服务

在 `main.dart` 中初始化日志服务：

```dart
import 'core/services/logger/logger_service.dart';

void main() {
  // 初始化日志服务
  appLogger.init();
  
  // 记录应用启动日志
  appLogger.i('App 启动');
  
  runApp(const MyApp());
}
```

### 2. 使用日志服务

在需要记录日志的地方导入并使用日志服务：

```dart
import 'core/services/logger/logger_service.dart';

// 记录不同级别的日志（带包名）
appLogger.tWithPackage('package_name', '这是一条Trace级别日志');
appLogger.dWithPackage('package_name', '这是一条Debug级别日志');
appLogger.iWithPackage('package_name', '这是一条Info级别日志');
appLogger.wWithPackage('package_name', '这是一条Warning级别日志');
appLogger.eWithPackage('package_name', '这是一条Error级别日志');
appLogger.fWithPackage('package_name', '这是一条Fatal级别日志');

// 带异常和堆栈跟踪的日志
try {
  // 可能出错的代码
} catch (e, stackTrace) {
  appLogger.eWithPackage('package_name', '捕获到异常', error: e, stackTrace: stackTrace);
}
```

### 3. 日志级别说明

| 级别 | 方法 | 说明 | 适用模式 |
|------|------|------|----------|
| Trace | `appLogger.tWithPackage()` | 最详细的日志，用于追踪执行流程 | Debug |
| Debug | `appLogger.dWithPackage()` | 调试信息，用于开发调试 | Debug |
| Info | `appLogger.iWithPackage()` | 一般信息，用于记录应用状态 | Debug, Profile |
| Warning | `appLogger.wWithPackage()` | 警告信息，用于记录潜在问题 | All |
| Error | `appLogger.eWithPackage()` | 错误信息，用于记录错误 | All |
| Fatal | `appLogger.fWithPackage()` | 严重错误，用于记录致命错误 | All |

### 4. 包名规范

为了便于日志分类和过滤，所有日志方法都必须指定包名参数。包名应遵循以下规范：

- 使用点分格式，如 `app`、`services.auth`、`ui.login` 等
- 包名应反映日志来源的功能模块
- 常用包名前缀：
  - `app` - 应用级别日志
  - `services` - 服务层日志
  - `ui` - 用户界面相关日志
  - `network` - 网络请求相关日志
  - `data` - 数据处理相关日志

## 配置选项

可以通过修改 `lib/core/config/logger_config.dart` 文件来自定义日志配置：

```dart
// 日志格式配置
static const bool enableColors = true;        // 是否启用颜色
static const bool enableEmojis = true;       // 是否启用表情符号
static const bool enableTimeStamps = true;   // 是否启用时间戳
static const int maxMethodCount = 3;         // 最大方法调用栈显示数量
static const int maxErrorMethodCount = 8;    // 最大错误方法调用栈显示数量
static const int lineLength = 120;           // 日志行长度

// 日志过滤配置
static const List<String> excludedLogTags = [
  'MESA',                          // 过滤MESA图形相关日志
  'exportSyncFdForQSRILocked',     // 过滤特定图形系统日志
];
```

## 最佳实践

1. **在适当的地方使用适当的日志级别**
   - 使用 `appLogger.dWithPackage()` 记录调试信息
   - 使用 `appLogger.iWithPackage()` 记录应用状态变化
   - 使用 `appLogger.wWithPackage()` 记录潜在问题
   - 使用 `appLogger.eWithPackage()` 记录错误和异常
   - 使用 `appLogger.fWithPackage()` 记录致命错误

2. **避免在生产环境中记录敏感信息**
   - 不要在日志中记录密码、令牌等敏感信息
   - 使用 `appLogger.dWithPackage()` 和 `appLogger.tWithPackage()` 记录调试信息，这些在生产环境中不会输出

3. **使用结构化日志**
   - 使用Map或对象记录结构化信息
   - 例如：`appLogger.iWithPackage('data.user', '用户信息: $userMap')`

4. **在关键操作前后添加日志**
   - 例如网络请求、数据库操作等
   - 有助于追踪问题

5. **使用有意义的包名**
   - 包名应反映日志来源的功能模块
   - 例如：`appLogger.iWithPackage('network.api', 'API请求开始')`

## 示例

查看 `lib/core/services/logger/logger_example.dart` 文件获取更多使用示例。

## 参考

- [logger 库文档](https://pub.dev/packages/logger)
- [Flutter 官方文档](https://flutter.dev/docs)
- [Material Design 规范](https://material.io/design)