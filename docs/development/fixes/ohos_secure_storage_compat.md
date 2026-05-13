# OHOS 平台 flutter_secure_storage 兼容性问题

> 日期：2026-05-11
> 设备：Pura90 模拟器 (OpenHarmony-6.1.1.115, API 24)
> 现象：监控页面显示「加载失败 加载GPU信息失败: Unsupported operation:unsupported_platform」

## 根本原因

`flutter_secure_storage` 插件没有 OHOS 原生实现。当在 OHOS 平台调用 `FlutterSecureStorage.read()` / `.write()` 时，`_selectOptions()` 方法抛出 `Unsupported operation: unsupported_platform`。

## ⚠️ 重要发现：项目已有 OHOS 桥接代码

项目**已存在** OHOS 插件桥接代码，位于 `ohos/entry/src/main/ets/plugins/`：

| 原生插件 | OHOS 桥接文件 | 状态 |
|---------|--------------|------|
| `flutter_secure_storage` | `OhosSecureStoragePlugin.ets` | ✅ 已实现 |
| `shared_preferences` | `OhosSharedPreferencesPlugin.ets` | ✅ 已实现 |
| `path_provider` | `OhosPathProviderPlugin.ets` | ✅ 已实现 |
| `package_info_plus` | `OhosPackageInfoPlugin.ets` | ✅ 已实现 |
| `local_auth` | `OhosLocalAuthPlugin.ets` | ✅ 已实现（graceful fallback） |

这些插件通过 `OhosCompatibilityPluginRegistrant` 注册到 Flutter 引擎：
```dart
// EntryAbility.ets
OhosCompatibilityPluginRegistrant.registerWith(flutterEngine)
```

**但是**，从日志来看，`OhosSecureStoragePlugin` 的调用失败了。问题出在 **`OhosPreferenceStore`** 使用了 `@ohos.data.preferences`（普通 Preferences），而不是 HUKS（硬件级密钥库）。对于安全存储场景，应该使用 `ohos.security.huks` 替代。

## 错误传播链

```
FlutterSecureStorage._selectOptions → 抛出 UnsupportedError("unsupported_platform")
  ← HiveStorageService.init() 读取加密密钥
    ← MonitorLocalDataSource.init()
      ← MonitoringProvider._ensureService()
        → ⛔ 加载GPU信息 failed / 加载监控数据 failed
```

## 受影响的 3 个使用点

### 1. HiveStorageService（加密密钥存储）

- 文件：`lib/core/storage/hive_storage_service.dart:43`
- 问题：`isEncrypted: true` 时，`init()` 用 `FlutterSecureStorage.read()` 读取加密密钥，未捕获平台不支持异常
- 触发路径：`MonitorLocalDataSource` 构造时硬编码 `isEncrypted: true`

### 2. SecureApiKeyStore（API Key 存储）

- 文件：`lib/core/config/api_config.dart:17-138`
- 问题：`_shouldUsePrefsFallback` 只检查 macOS/Windows/Linux，**不包含 OHOS**
- 现状：有 fallback 机制但条件不覆盖 OHOS，异常被 catch 后走 `_memoryFallback`，重启后数据丢失

### 3. SecureAuthSessionStore（认证 Token 存储）

- 文件：`lib/features/auth/auth_session_store.dart:19-61`
- 问题：**完全没有 fallback 机制**，OHOS 上直接抛异常
- 影响：用户无法登录/保持登录状态

## 修复方案

### 方案 A：升级现有 OHOS 桥接 — 使用 HUKS（推荐）

现有 `OhosSecureStoragePlugin` 使用的是 `OhosPreferenceStore`（`@ohos.data.preferences`），这是普通偏好存储，**不是安全存储**。应改为使用 `ohos.security.huks`（Huawei Universal Key Store）实现硬件级加密：

```typescript
// OhosSecureStoragePlugin.ets - 使用 HUKS 替代 Preferences
import huks from '@ohos.security.huks';

// 密钥别名
const KEY_ALIAS = 'flutter_secure_storage_key';

// 生成/获取密钥
async function getOrCreateKey() {
  let options = {
    purpose: huks.KuksPurposeEnum.KUKS_PURPOSE_ENCRYPT | huks.KuksPurposeEnum.KUKS_PURPOSE_DECRYPT,
    algName: 'AES256',
  };
  // 检查密钥是否存在，不存在则创建
  let hasKey = await huks.isKeyExist(KEY_ALIAS, options);
  if (!hasKey) {
    await huks.generateKey(KEY_ALIAS, options);
  }
  return KEY_ALIAS;
}
```

**HUKS 优势**：密钥由 TEE（可信执行环境）保护，即使 root 也无法导出，支持国密 SM4/SM2 算法。

### 方案 B：Dart 层 Fallback（最小改动）

如果暂时不修改原生代码，可以在 Dart 层捕获异常并降级：

```dart
// HiveStorageService.init()
Future<void> init() async {
  if (Hive.isBoxOpen(boxName)) {
    _box = Hive.box(boxName);
    return;
  }
  await Hive.initFlutter();

  List<int>? encryptionKey;

  if (isEncrypted) {
    try {
      String? keyStr = await _secureStorage.read(key: '${boxName}_key');
      if (keyStr == null) {
        final key = Hive.generateSecureKey();
        await _secureStorage.write(key: '${boxName}_key', value: base64Url.encode(key));
        encryptionKey = key;
      } else {
        encryptionKey = base64Url.decode(keyStr);
      }
    } on UnsupportedError {
      // OHOS fallback: 不使用加密
      appLogger.wWithPackage('core.storage.hive_storage', 'SecureStorage unsupported on OHOS, using non-encrypted storage');
      isEncrypted = false;
    }
  }
  // ... 后续逻辑
}
```

同时扩展 `SecureApiKeyStore._shouldUsePrefsFallback` 条件：

```dart
bool get _shouldUsePrefsFallback =>
    !kIsWeb &&
    (io.Platform.isMacOS || io.Platform.isWindows || io.Platform.isLinux ||
     defaultTargetPlatform == TargetPlatform.android && _isOHOS());
```

### 方案 C：完全替换为 SharedPreferences + 内存缓存

对于 OHOS 平台，将 `flutter_secure_storage` 完全替换为 `shared_preferences`，安全性略低但功能正常（已有 OHOS 桥接）。

## OHOS 平台检测方式

`dart:io` 的 `Platform` 没有 `isOHOS` 属性，需要通过以下方式检测：

```dart
import 'dart:io' as io;
import 'package:flutter/foundation.dart';

bool isOHOS() {
  if (kIsWeb) return false;
  // 方法1：通过 defaultTargetPlatform（需验证 OHOS Flutter 是否设置正确）
  if (defaultTargetPlatform == TargetPlatform.android) {
    // OHOS Flutter 可能被识别为 android
    try {
      return io.Platform.operatingSystem == 'ohos';
    } catch (_) {
      return false;
    }
  }
  return false;
}
```

## 所有不支持 OHOS 的依赖清单

### 🔴 高优先级（运行时崩溃/功能不可用）

| 包 | 版本 | OHOS 状态 | 已有桥接 | 影响 | 解决方案 |
|----|------|----------|---------|------|---------|
| `flutter_secure_storage` | ^10.0.0 | ❌ 无原生实现 | ⚠️ 有但不安全 | 加密存储失败、登录失效 | 使用 HUKS 升级桥接 / Dart fallback |
| `hive_flutter` | ^1.1.0 | ⚠️ Hive 本身支持，但依赖 secure_storage | - | 加密 Hive Box 无法打开 | OHOS 降级为非加密模式 |
| `flutter_downloader` | ^1.11.4 | ❌ 无 OHOS 支持 | 无 | 文件下载功能不可用 | 暂时禁用 / 替换为 Dio |
| `open_filex` | ^4.7.0 | ❌ 无 OHOS 支持 | 无 | 无法打开下载文件 | 暂时禁用 |
| `passkeys` | ^2.18.0 | ❌ OHOS 不支持 | 无 | Passkey 功能不可用 | 已在 `passkey_service.dart:67` 返回 unsupported |

### 🟡 中优先级（功能降级但不崩溃）

| 包 | 版本 | OHOS 状态 | 已有桥接 | 影响 | 解决方案 |
|----|------|----------|---------|------|---------|
| `local_auth` | ^2.3.0 | ⚠️ 有桥接 | ✅ `OhosLocalAuthPlugin` | 生物认证返回 false | graceful fallback 已实现 |
| `window_manager` | ^0.4.3 | ❌ 桌面端专用 | 无 | 仅 macOS/Windows/Linux | OHOS 条件跳过 |
| `flutter_acrylic` | ^1.1.3 | ❌ 桌面端专用 | 无 | 仅 macOS/Windows | OHOS 条件跳过 |
| `macos_ui` | ^2.0.4 | ❌ macOS 专用 | 无 | 仅 macOS | OHOS 条件跳过 |
| `tray_manager` | ^0.2.2 | ❌ 桌面端专用 | 无 | 仅 macOS/Windows/Linux | OHOS 条件跳过 |
| `xterm` | ^4.0.0 | ⚠️ 可能无 OHOS 支持 | 无 | 终端功能不可用 | 检查 OHOS Flutter 版本兼容性 |
| `wakelock_plus` | ^1.5.1 | ❌ 无 OHOS 支持 | 无 | 屏幕常亮功能不可用 | 暂时禁用 |

### 🟢 低优先级（应该可用）

| 包 | 版本 | OHOS 状态 | 已有桥接 |
|----|------|----------|---------|
| `shared_preferences` | ^2.5.4 | ✅ 有桥接 | ✅ `OhosSharedPreferencesPlugin` |
| `path_provider` | ^2.1.0 | ✅ 有桥接 | ✅ `OhosPathProviderPlugin` |
| `package_info_plus` | ^9.0.0 | ✅ 有桥接 | ✅ `OhosPackageInfoPlugin` |
| `connectivity_plus` | ^7.0.0 | ✅ 应支持 | 无需（纯 Dart 逻辑） |
| `battery_plus` | ^7.0.0 | ✅ 应支持 | 无需（纯 Dart 逻辑） |
| `dio` | ^5.9.1 | ✅ 纯 Dart | 无需 |
| `provider` | ^6.1.1 | ✅ 纯 Dart | 无需 |
| `hive` | ^2.2.3 | ✅ 纯 Dart | 无需 |
| `intl` | ^0.20.2 | ✅ 纯 Dart | 无需 |
| `cached_network_image` | ^3.3.1 | ✅ 纯 Dart | 无需 |
| `flutter_svg` | ^2.0.0 | ✅ 纯 Dart | 无需 |
| `flutter_markdown` | ^0.7.4+3 | ✅ 纯 Dart | 无需 |
| `flutter_colorpicker` | ^1.1.0 | ✅ 纯 Dart | 无需 |
| `dynamic_color` | ^1.7.0 | ✅ 纯 Dart | 无需 |
| `audioplayers` | ^6.1.0 | ✅ 应支持 | 无 |
| `video_player` | ^2.9.3 | ✅ 应支持 | 无 |
| `file_picker` | ^8.0.0 | ✅ 应支持 | 无 |
| `permission_handler` | ^11.0.0 | ✅ Android/iOS 为主 | 无 |
| `url_launcher` | ^6.3.2 | ✅ 应支持 | 无 |
| `app_links` | ^6.4.0 | ✅ 应支持 | 无 |
| `android_intent_plus` | ^5.3.0 | ⚠️ Android 专用 | 无（OHOS 跳过） |
| `photo_view` | ^0.15.0 | ✅ 纯 Dart | 无需 |
| `shimmer` | ^3.0.0 | ✅ 纯 Dart | 无需 |
| `equatable` | ^2.0.8 | ✅ 纯 Dart | 无需 |
| `logger` | ^2.6.2 | ✅ 纯 Dart | 无需 |
| `crypto` | ^3.0.7 | ✅ 纯 Dart | 无需 |

## 关联信息

- HMOS Flutter 分支兼容性分析：当前 `oh-3.41.9-dev` 最接近但存在版本元数据问题
- `UiTargetResolver` 已有 `ohos` case 映射到 `UiPlatformKind.harmony`
- 日志文件：`logs/HMOS/Pura90（模拟器）.log`
- OHOS 插件目录：`ohos/entry/src/main/ets/plugins/`
