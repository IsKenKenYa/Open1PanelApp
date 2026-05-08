# 1Panel Client Code Wiki

## 概述

**1Panel Client** 是一个基于 Flutter 的跨平台客户端应用，用于连接和管理一个或多个 1Panel 服务器。该项目提供完整的 1Panel V2 API 覆盖（34个模块，425+ 端点），支持多服务器切换、实时状态监控和常用操作管理。

---

## 目录结构

```
lib/
├── api/v2/              # Type-safe API客户端（1Panel V2 APIs）- 34个模块
├── config/              # 应用配置（路由、API配置）
├── core/                # 核心功能（网络、日志、主题、国际化）
│   ├── config/          # API常量和配置管理
│   ├── network/         # 网络层（Dio客户端、拦截器）
│   ├── services/        # 核心服务（日志、存储等）
│   ├── storage/         # 存储服务
│   ├── theme/           # 主题管理
│   └── utils/           # 工具函数
├── data/                # 数据层
│   └── models/          # 强类型数据模型（60+文件）
├── features/            # 功能模块（按业务领域划分）
├── pages/               # UI页面容器
├── shared/              # 共享组件
├── ui/                  # UI层（桌面、移动端适配）
├── widgets/             # 通用组件
└── main.dart            # 应用入口
```

---

## 核心架构

### 分层架构

| 层级 | 职责 | 代码位置 |
|------|------|----------|
| **Presentation** | UI展示与交互 | `lib/features/*/pages/`, `lib/features/*/widgets/` |
| **State** | 状态管理 | `lib/features/*/providers/` |
| **Service** | 业务逻辑与数据加工 | `lib/core/services/`, `lib/features/*/services/` |
| **Repository** | 数据单一事实来源 | `lib/data/repositories/` |
| **Model** | 数据结构定义 | `lib/data/models/` |
| **API/Infra** | 外部通信与存储 | `lib/api/v2/`, `lib/core/network/`, `lib/core/storage/` |

**依赖方向**：`Presentation → State → Service/Repository → API/Infra`

---

## 网络层架构

### DioClient - HTTP客户端核心

**文件**: [lib/core/network/dio_client.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/network/dio_client.dart)

**核心职责**:
- 统一HTTP客户端封装
- 自动重试机制（指数退避）
- 统一异常处理与转换
- 支持不安全TLS模式

**核心方法**:

| 方法 | 说明 | 参数 | 返回值 |
|------|------|------|--------|
| `get<T>()` | GET请求 | `path`, `queryParameters`, `options` | `Future<Response<T>>` |
| `post<T>()` | POST请求 | `path`, `data`, `queryParameters`, `options` | `Future<Response<T>>` |
| `put<T>()` | PUT请求 | `path`, `data`, `queryParameters`, `options` | `Future<Response<T>>` |
| `delete<T>()` | DELETE请求 | `path`, `data`, `queryParameters`, `options` | `Future<Response<T>>` |
| `upload<T>()` | 文件上传 | `path`, `formData`, `onSendProgress`, `options` | `Future<Response<T>>` |
| `download()` | 文件下载 | `urlPath`, `savePath`, `onReceiveProgress`, `options` | `Future<Response>` |
| `updateAuth()` | 更新认证信息 | `apiKey` | `void` |

### 拦截器体系

| 拦截器 | 文件 | 职责 |
|--------|------|------|
| **AuthInterceptor** | [auth_interceptor.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/network/interceptors/auth_interceptor.dart) | 自动添加1Panel认证头 |
| **BusinessResponseInterceptor** | - | 业务响应处理 |
| **LoggingInterceptor** | [logging_interceptor.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/network/interceptors/logging_interceptor.dart) | 请求/响应日志（仅Debug模式） |
| **RetryInterceptor** | [retry_interceptor.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/network/interceptors/retry_interceptor.dart) | 自动重试（最多3次） |

### 1Panel认证机制

**文件**: [lib/core/network/onepanel_auth_headers.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/network/onepanel_auth_headers.dart)

**认证流程**:
1. 生成秒级时间戳
2. 计算MD5哈希: `MD5("1panel" + apiKey + timestamp)`
3. 添加请求头: `1Panel-Token` 和 `1Panel-Timestamp`

**核心代码**:
```dart
static Map<String, String> build(String apiKey) {
  final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();
  final authToken = _generateToken(apiKey, timestamp);
  return <String, String>{
    ApiConstants.authHeaderToken: authToken,
    ApiConstants.authHeaderTimestamp: timestamp,
  };
}
```

### 异常类型

**文件**: [lib/core/network/network_exceptions.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/network/network_exceptions.dart)

| 异常类型 | 触发条件 |
|----------|----------|
| `NetworkConnectionException` | 网络连接失败（超时、连接错误） |
| `AuthException` | 认证失败（HTTP 401） |
| `ServerException` | 服务器错误（HTTP 5xx） |
| `HttpException` | 其他HTTP错误（HTTP 4xx） |

---

## API层 - 模块清单

**位置**: [lib/api/v2/](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/api/v2/)

| API文件 | 功能模块 | 说明 |
|---------|----------|------|
| `ai_v2.dart` | AI管理 | Ollama模型、GPU监控、域名绑定 |
| `app_v2.dart` | 应用管理 | 应用商店、安装、更新 |
| `auth_v2.dart` | 认证 | 登录、登出、会话管理 |
| `backup_account_v2.dart` | 备份账户 | 备份配置与管理 |
| `command_v2.dart` | 命令管理 | 命令执行与管理 |
| `compose_v2.dart` | Docker Compose | Compose编排管理 |
| `container_v2.dart` | 容器管理 | Docker容器生命周期 |
| `cronjob_v2.dart` | 定时任务 | 计划任务与执行日志 |
| `dashboard_v2.dart` | 仪表盘 | 系统概览与状态 |
| `database_v2.dart` | 数据库管理 | MySQL/MariaDB、PostgreSQL、Redis |
| `disk_management_v2.dart` | 磁盘管理 | 磁盘操作 |
| `docker_v2.dart` | Docker服务 | Docker引擎管理 |
| `file_v2.dart` | 文件管理 | 文件浏览、编辑、上传下载 |
| `firewall_v2.dart` | 防火墙管理 | 规则、IP白名单、端口管理 |
| `host_v2.dart` | 主机管理 | 主机资产、系统信息 |
| `host_tool_v2.dart` | 主机工具 | 主机工具集 |
| `logs_v2.dart` | 日志管理 | 系统日志、任务日志 |
| `monitor_v2.dart` | 监控管理 | 实时指标与图表 |
| `openresty_v2.dart` | OpenResty管理 | Nginx配置与管理 |
| `process_v2.dart` | 进程管理 | 系统进程监控 |
| `runtime_v2.dart` | 运行时管理 | PHP扩展、Node模块、Supervisor |
| `script_library_v2.dart` | 脚本库 | 脚本管理与执行 |
| `setting_v2.dart` | 设置管理 | 系统配置、快照 |
| `snapshot_v2.dart` | 快照管理 | 系统快照与恢复 |
| `ssh_v2.dart` | SSH管理 | SSH配置、证书、日志 |
| `ssl_v2.dart` | SSL管理 | SSL证书、ACME集成 |
| `system_group_v2.dart` | 系统组管理 | 用户组管理 |
| `task_log_v2.dart` | 任务日志 | 任务执行日志 |
| `terminal_v2.dart` | 终端管理 | SSH会话 |
| `toolbox_v2.dart` | 工具箱 | 设备管理、磁盘操作、ClamAV等 |
| `update_v2.dart` | 更新管理 | 系统更新 |
| `user_v2.dart` | 用户管理 | 用户认证、角色权限 |
| `website_v2.dart` | 网站管理 | 网站、域名、SSL、代理 |
| `website_group_v2.dart` | 网站组管理 | 网站分组管理 |

---

## 数据模型层

**位置**: [lib/data/models/](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/data/models/)

### 通用模型

| 模型类 | 文件 | 说明 |
|--------|------|------|
| `OperateByID` | [common_models.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/data/models/common_models.dart) | 通过ID操作 |
| `PageRequest` | - | 分页请求参数 |
| `PageResult<T>` | - | 分页结果 |
| `SearchRequest` | - | 搜索请求 |
| `CommonResponse<T>` | - | 通用响应封装 |
| `SystemInfo` | - | 系统信息 |
| `Status` | - | 状态枚举 |

### 核心业务模型

| 模型文件 | 功能 |
|----------|------|
| `ai_models.dart` | AI/Ollama管理 |
| `app_models.dart` | 应用管理 |
| `auth_models.dart` | 认证管理 |
| `container_models.dart` | 容器管理 |
| `database_models.dart` | 数据库管理 |
| `file_models.dart` | 文件管理 |
| `host_models.dart` | 主机管理 |
| `website_models.dart` | 网站管理 |

---

## 状态管理层

### Provider清单

**位置**: `lib/features/*/providers/`

| Provider | 功能 | 所属模块 |
|----------|------|----------|
| `DashboardProvider` | 仪表盘状态 | Dashboard |
| `AppsProvider` | 应用管理状态 | Apps |
| `ContainersProvider` | 容器管理状态 | Containers |
| `DatabasesProvider` | 数据库管理状态 | Databases |
| `FilesProvider` | 文件管理状态 | Files |
| `FirewallProvider` | 防火墙状态 | Firewall |
| `AIProvider` | AI管理状态 | AI |
| `WebsitesProvider` | 网站管理状态 | Websites |
| `ServerProvider` | 服务器管理状态 | Server |
| `CurrentServerController` | 当前服务器状态 | Shell |
| `ThemeController` | 主题管理状态 | Core |
| `AppSettingsController` | 应用设置状态 | Core |

---

## 核心服务

### 日志服务

**文件**: [lib/core/services/logger/logger_service.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/services/logger/logger_service.dart)

**特性**:
- **隐私保护**: 自动屏蔽公网IP地址
- **分级日志**: 支持 trace/debug/info/warning/error/fatal
- **双输出**: 控制台 + 文件
- **发布渠道策略**: 根据渠道自动调整日志级别

**核心方法**:

| 方法 | 级别 | 说明 |
|------|------|------|
| `t()` / `tWithPackage()` | Trace | 追踪级别（最详细） |
| `d()` / `dWithPackage()` | Debug | 调试级别 |
| `i()` / `iWithPackage()` | Info | 信息级别 |
| `w()` / `wWithPackage()` | Warning | 警告级别 |
| `e()` / `eWithPackage()` | Error | 错误级别 |
| `f()` / `fWithPackage()` | Fatal | 致命级别 |

### 认证服务

**文件**: [lib/features/auth/auth_service.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/features/auth/auth_service.dart)

**职责**:
- 处理登录/登出流程
- 管理API密钥
- 处理会话状态

---

## 路由系统

### 路由配置

**文件**: [lib/config/app_router.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/config/app_router.dart)

**核心路由**:

| 路由路径 | 页面 | 说明 |
|----------|------|------|
| `/` | SplashPage | 启动页 |
| `/onboarding` | OnboardingPage | 引导页 |
| `/home` | UiRouteHost | 主页面 |
| `/dashboard` | Dashboard | 仪表盘 |
| `/files` | FilesPage | 文件管理 |
| `/containers` | ContainersPage | 容器管理 |
| `/apps` | AppsPage | 应用管理 |
| `/databases` | DatabasesPage | 数据库管理 |
| `/websites` | WebsitesPage | 网站管理 |
| `/ai` | AIPage | AI管理 |
| `/settings` | SettingsPage | 设置 |
| `/terminal` | TerminalPage | 终端 |
| `/monitoring` | MonitoringPage | 监控 |

---

## 主题与国际化

### 主题管理

**文件**: [lib/core/theme/](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/theme/)

**特性**:
- Material Design 3 支持
- 动态色彩（Material You）
- 深浅色模式切换
- 自定义种子色

### 国际化

**文件**: [lib/l10n/](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/l10n/)

**支持语言**:
- 中文 (`app_zh.arb`)
- 英文 (`app_en.arb`)

**使用方式**:
```dart
AppLocalizations.of(context)!.appTitle
```

---

## 配置常量

### API配置

**文件**: [lib/core/config/api_constants.dart](file:///Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/lib/core/config/api_constants.dart)

| 常量 | 值 | 说明 |
|------|-----|------|
| `apiVersion` | `v2` | API版本 |
| `apiPrefix` | `/api/v2` | API路径前缀 |
| `defaultBaseUrl` | `http://localhost:10086` | 默认服务器地址 |
| `connectTimeout` | 8秒 | 连接超时 |
| `receiveTimeout` | 8秒 | 接收超时 |
| `sendTimeout` | 8秒 | 发送超时 |
| `maxRetryAttempts` | 3 | 最大重试次数 |

---

## 运行与构建

### 开发命令

```bash
# 安装依赖
flutter pub get

# 运行调试
flutter run

# 运行发布模式
flutter run --release

# 代码分析
flutter analyze

# 运行测试
flutter test

# 代码生成（Retrofit/JSON序列化）
flutter packages pub run build_runner build
```

### 构建命令

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios --release

# macOS
flutter build macos --release

# Windows
flutter build windows --release
```

---

## 测试体系

### 测试目录结构

```
test/
├── api/              # API测试
├── api_client/       # API客户端测试
├── auth/             # 认证测试
├── bugfix/           # Bug修复回归测试
├── core/             # 核心模块测试
├── debug/            # 调试工具
├── features/         # 功能模块测试
└── scripts/          # 测试脚本
```

### 测试执行

```bash
# 运行单元测试
dart run test/scripts/test_runner.dart unit

# 运行集成测试
dart run test/scripts/test_runner.dart integration

# 运行UI测试
dart run test/scripts/test_runner.dart ui

# 运行所有测试
dart run test/scripts/test_runner.dart all
```

---

## 代码规范

### 文件命名

| 文件类型 | 后缀 | 示例 |
|----------|------|------|
| 页面 | `_page.dart` | `dashboard_page.dart` |
| 组件 | `_widget.dart` | `app_card_widget.dart` |
| Provider | `_provider.dart` | `dashboard_provider.dart` |
| 服务 | `_service.dart` | `auth_service.dart` |
| 模型 | `_models.dart` | `app_models.dart` |
| API客户端 | `_v2.dart` | `ai_v2.dart` |

### 文件大小限制
- **硬上限**: 1000 LOC（非空非注释行）
- **推荐阈值**: 逻辑文件 ≤ 500 LOC，UI文件 ≤ 800 LOC

### 日志规范
- 禁止使用 `print()` 或 `debugPrint()`
- 必须使用 `appLogger` 统一日志系统

---

## 跨平台支持

### 支持平台

| 平台 | 状态 | 说明 |
|------|------|------|
| Android | ✅ | 完整支持 |
| iOS | ✅ | 完整支持 |
| macOS | ✅ | 支持（macOS 15+） |
| Windows | ✅ | 支持 |
| Linux | ✅ | 支持 |
| Web | ✅ | 支持（有限制） |

### UI渲染策略

- **Android**: Material Design 3 (Dart)
- **Apple平台**: SwiftUI原生 + MD3回退
- **Windows**: Fluent/WinUI3原生 + MD3回退
- **Linux**: Material Design 3 (Dart)

---

## 关键技术特性

### 1. 多服务器管理
- 支持管理多个1Panel实例
- 服务器切换无需重新登录
- 统一的服务器配置管理

### 2. 安全认证
- API Key + MD5时间戳认证
- 安全存储API密钥（Flutter Secure Storage）
- 应用锁保护

### 3. 文件管理
- 完整的文件操作（浏览、编辑、上传、下载）
- 回收站功能
- 收藏管理
- 挂载点管理

### 4. 实时监控
- CPU/内存/磁盘/网络实时指标
- 图表可视化
- 进程监控

### 5. AI集成
- Ollama模型管理
- GPU监控
- AI Agent配置

---

## 扩展开发指南

### 添加新API模块

1. 在 `lib/api/v2/` 创建新的API客户端文件
2. 在 `lib/data/models/` 创建对应的数据模型
3. 创建Service类处理业务逻辑
4. 创建Provider管理状态
5. 创建UI页面和组件

### 添加新功能模块

1. 在 `lib/features/` 创建新目录
2. 按功能划分目录结构（pages、providers、services、widgets）
3. 在 `lib/config/app_router.dart` 注册路由
4. 添加国际化字符串

---

## 版本与发布

### 版本号策略
- 格式: `vX.Y.Z+build`
- 当前版本: `v0.6.0+1`

### 发布渠道
- `debug-*`: 内部Alpha版本
- `beta-*`: 公开预览版本
- `pre-release-*`: 发布候选版本
- `v*`: 稳定版本

---

## 许可证

**GNU General Public License v3.0 (GPL-3.0)**

详见 [LICENSE](LICENSE) 文件。

---

## 相关资源

- **1Panel Server**: [https://github.com/1Panel-dev/1Panel](https://github.com/1Panel-dev/1Panel)
- **Dio HTTP Client**: [https://github.com/cfug/dio](https://github.com/cfug/dio)
- **Flutter**: [https://flutter.dev/](https://flutter.dev/)
