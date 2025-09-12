# 1Panel移动端APP 数据模型设计

## 1. 概述

本文档详细描述了1Panel移动端APP中使用的数据模型和它们之间的关系，为前端开发提供清晰的数据结构指导。所有数据模型设计均基于1Panel V2 API的响应结构，并进行了适当的优化以适应移动应用的需求。

## 2. 基础模型

### 2.1 响应模型 (ApiResponse)

统一的API响应模型，用于处理所有API返回的数据。

```dart
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse<T>(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
```

### 2.2 分页模型 (PaginationData)

用于处理API返回的分页数据。

```dart
class PaginationData<T> {
  final int total;
  final List<T> items;

  PaginationData({
    required this.total,
    required this.items,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PaginationData<T>(
      total: json['total'],
      items: List<T>.from(json['items'].map((x) => fromJsonT(x))),
    );
  }
}
```

## 3. 用户认证相关模型

### 3.1 API版本 (ApiVersion)

表示支持的1Panel API版本。

```dart
enum ApiVersion {
  v1,
  v2,
}

class ApiVersionInfo {
  final ApiVersion version;
  final String endpointPrefix;

  ApiVersionInfo({
    required this.version,
    required this.endpointPrefix,
  });

  static List<ApiVersionInfo> get supportedVersions => [
        ApiVersionInfo(
          version: ApiVersion.v1,
          endpointPrefix: '/api/v1',
        ),
        ApiVersionInfo(
          version: ApiVersion.v2,
          endpointPrefix: '/api/v2',
        ),
      ];

  static ApiVersionInfo get defaultVersion => supportedVersions.last;
}
```

### 3.2 用户信息 (UserInfo)

存储用户的基本信息。

```dart
class UserInfo {
  final String id;
  final String username;
  final String nickname;
  final String? email;
  final String role;
  final String status;
  final DateTime createTime;
  final DateTime updateTime;

  UserInfo({
    required this.id,
    required this.username,
    required this.nickname,
    this.email,
    required this.role,
    required this.status,
    required this.createTime,
    required this.updateTime,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      username: json['username'],
      nickname: json['nickname'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }
}
```

### 3.2 登录响应 (LoginResponse)

登录API返回的响应数据。

```dart
class LoginResponse {
  final String token;
  final UserInfo userInfo;

  LoginResponse({
    required this.token,
    required this.userInfo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      userInfo: UserInfo.fromJson(json['userInfo']),
    );
  }
}
```

### 3.3 服务器连接信息 (ServerConnectionInfo)

存储用户连接的服务器信息。

```dart
class ServerConnectionInfo {
  final String id;
  final String name;
  final String host;
  final int port;
  final bool useHttps;
  final String? alias;
  final DateTime lastConnected;
  final ApiVersion apiVersion;
  final bool isDefault;
  final String? token;

  ServerConnectionInfo({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.useHttps,
    this.alias,
    required this.lastConnected,
    this.apiVersion = ApiVersion.v2,
    this.isDefault = false,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'useHttps': useHttps,
      'alias': alias,
      'lastConnected': lastConnected.toIso8601String(),
      'apiVersion': apiVersion.index,
      'isDefault': isDefault,
      'token': token,
    };
  }

  factory ServerConnectionInfo.fromJson(Map<String, dynamic> json) {
    return ServerConnectionInfo(
      id: json['id'],
      name: json['name'],
      host: json['host'],
      port: json['port'],
      useHttps: json['useHttps'],
      alias: json['alias'],
      lastConnected: DateTime.parse(json['lastConnected']),
      apiVersion: ApiVersion.values[json['apiVersion'] ?? 1], // 默认v2
      isDefault: json['isDefault'] ?? false,
      token: json['token'],
    );
  }

  String get baseUrl {
    final protocol = useHttps ? 'https' : 'http';
    return '$protocol://$host:$port';
  }

  String get apiEndpointPrefix {
    return ApiVersionInfo.supportedVersions
        .firstWhere((v) => v.version == apiVersion)
        .endpointPrefix;
  }

  ServerConnectionInfo copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    bool? useHttps,
    String? alias,
    DateTime? lastConnected,
    ApiVersion? apiVersion,
    bool? isDefault,
    String? token,
  }) {
    return ServerConnectionInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      useHttps: useHttps ?? this.useHttps,
      alias: alias ?? this.alias,
      lastConnected: lastConnected ?? this.lastConnected,
      apiVersion: apiVersion ?? this.apiVersion,
      isDefault: isDefault ?? this.isDefault,
      token: token ?? this.token,
    );
  }
}
```

## 4. 仪表盘相关模型

### 4.1 系统概览 (SystemOverview)

存储系统概览信息，包括CPU、内存、磁盘等资源使用情况。

```dart
class SystemOverview {
  final SystemInfo system;
  final CpuInfo cpu;
  final MemoryInfo memory;
  final DiskInfo disk;
  final NetworkInfo network;
  final int appCount;
  final int containerCount;
  final int websiteCount;
  final int backupCount;

  SystemOverview({
    required this.system,
    required this.cpu,
    required this.memory,
    required this.disk,
    required this.network,
    required this.appCount,
    required this.containerCount,
    required this.websiteCount,
    required this.backupCount,
  });

  factory SystemOverview.fromJson(Map<String, dynamic> json) {
    return SystemOverview(
      system: SystemInfo.fromJson(json['system']),
      cpu: CpuInfo.fromJson(json['cpu']),
      memory: MemoryInfo.fromJson(json['memory']),
      disk: DiskInfo.fromJson(json['disk']),
      network: NetworkInfo.fromJson(json['network']),
      appCount: json['appCount'],
      containerCount: json['containerCount'],
      websiteCount: json['websiteCount'],
      backupCount: json['backupCount'],
    );
  }
}

class SystemInfo {
  final String hostname;
  final String os;
  final String version;
  final String arch;
  final String kernel;
  final String uptime;

  SystemInfo({
    required this.hostname,
    required this.os,
    required this.version,
    required this.arch,
    required this.kernel,
    required this.uptime,
  });

  factory SystemInfo.fromJson(Map<String, dynamic> json) {
    return SystemInfo(
      hostname: json['hostname'],
      os: json['os'],
      version: json['version'],
      arch: json['arch'],
      kernel: json['kernel'],
      uptime: json['uptime'],
    );
  }
}

class CpuInfo {
  final double usage;
  final int cores;
  final String model;

  CpuInfo({
    required this.usage,
    required this.cores,
    required this.model,
  });

  factory CpuInfo.fromJson(Map<String, dynamic> json) {
    return CpuInfo(
      usage: json['usage'].toDouble(),
      cores: json['cores'],
      model: json['model'],
    );
  }
}

class MemoryInfo {
  final int total;
  final int used;
  final int free;
  final double usage;

  MemoryInfo({
    required this.total,
    required this.used,
    required this.free,
    required this.usage,
  });

  factory MemoryInfo.fromJson(Map<String, dynamic> json) {
    return MemoryInfo(
      total: json['total'],
      used: json['used'],
      free: json['free'],
      usage: json['usage'].toDouble(),
    );
  }
}

class DiskInfo {
  final int total;
  final int used;
  final int free;
  final double usage;

  DiskInfo({
    required this.total,
    required this.used,
    required this.free,
    required this.usage,
  });

  factory DiskInfo.fromJson(Map<String, dynamic> json) {
    return DiskInfo(
      total: json['total'],
      used: json['used'],
      free: json['free'],
      usage: json['usage'].toDouble(),
    );
  }
}

class NetworkInfo {
  final int inBytes;
  final int outBytes;

  NetworkInfo({
    required this.inBytes,
    required this.outBytes,
  });

  factory NetworkInfo.fromJson(Map<String, dynamic> json) {
    return NetworkInfo(
      inBytes: json['in'],
      outBytes: json['out'],
    );
  }
}
```

## 5. 应用管理相关模型

### 5.1 应用 (App)

存储应用的基本信息。

```dart
class App {
  final String id;
  final String name;
  final String version;
  final String description;
  final String logo;
  final String category;
  final String status;
  final DateTime createTime;
  final DateTime updateTime;

  App({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    required this.logo,
    required this.category,
    required this.status,
    required this.createTime,
    required this.updateTime,
  });

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'],
      name: json['name'],
      version: json['version'],
      description: json['description'],
      logo: json['logo'],
      category: json['category'],
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }
}
```

### 5.2 应用详情 (AppDetail)

存储应用的详细信息，继承自App。

```dart
class AppDetail extends App {
  final Map<String, dynamic> config;
  final List<PortMapping> ports;
  final List<VolumeMapping> volumes;

  AppDetail({
    required String id,
    required String name,
    required String version,
    required String description,
    required String logo,
    required String category,
    required String status,
    required DateTime createTime,
    required DateTime updateTime,
    required this.config,
    required this.ports,
    required this.volumes,
  }) : super(
          id: id,
          name: name,
          version: version,
          description: description,
          logo: logo,
          category: category,
          status: status,
          createTime: createTime,
          updateTime: updateTime,
        );

  factory AppDetail.fromJson(Map<String, dynamic> json) {
    return AppDetail(
      id: json['id'],
      name: json['name'],
      version: json['version'],
      description: json['description'],
      logo: json['logo'],
      category: json['category'],
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
      config: Map<String, dynamic>.from(json['config']),
      ports: List<PortMapping>.from(json['ports'].map((x) => PortMapping.fromJson(x))),
      volumes: List<VolumeMapping>.from(json['volumes'].map((x) => VolumeMapping.fromJson(x))),
    );
  }
}

class PortMapping {
  final int containerPort;
  final int hostPort;
  final String protocol;

  PortMapping({
    required this.containerPort,
    required this.hostPort,
    required this.protocol,
  });

  factory PortMapping.fromJson(Map<String, dynamic> json) {
    return PortMapping(
      containerPort: json['containerPort'],
      hostPort: json['hostPort'],
      protocol: json['protocol'],
    );
  }
}

class VolumeMapping {
  final String containerPath;
  final String hostPath;
  final String mode;

  VolumeMapping({
    required this.containerPath,
    required this.hostPath,
    required this.mode,
  });

  factory VolumeMapping.fromJson(Map<String, dynamic> json) {
    return VolumeMapping(
      containerPath: json['containerPath'],
      hostPath: json['hostPath'],
      mode: json['mode'],
    );
  }
}
```

## 6. 容器管理相关模型

### 6.1 容器 (Container)

存储容器的基本信息。

```dart
class Container {
  final String id;
  final String name;
  final String image;
  final String status;
  final DateTime created;
  final List<PortMapping> ports;
  final Map<String, String> labels;

  Container({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.created,
    required this.ports,
    required this.labels,
  });

  factory Container.fromJson(Map<String, dynamic> json) {
    return Container(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      created: DateTime.parse(json['created']),
      ports: List<PortMapping>.from(json['ports'].map((x) => PortMapping.fromJson(x))),
      labels: Map<String, String>.from(json['labels']),
    );
  }
}
```

### 6.2 容器详情 (ContainerDetail)

存储容器的详细信息，继承自Container。

```dart
class ContainerDetail extends Container {
  final List<VolumeMapping> volumes;
  final List<String> env;
  final ContainerStats stats;

  ContainerDetail({
    required String id,
    required String name,
    required String image,
    required String status,
    required DateTime created,
    required List<PortMapping> ports,
    required Map<String, String> labels,
    required this.volumes,
    required this.env,
    required this.stats,
  }) : super(
          id: id,
          name: name,
          image: image,
          status: status,
          created: created,
          ports: ports,
          labels: labels,
        );

  factory ContainerDetail.fromJson(Map<String, dynamic> json) {
    return ContainerDetail(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      created: DateTime.parse(json['created']),
      ports: List<PortMapping>.from(json['ports'].map((x) => PortMapping.fromJson(x))),
      labels: Map<String, String>.from(json['labels']),
      volumes: List<VolumeMapping>.from(json['volumes'].map((x) => VolumeMapping.fromJson(x))),
      env: List<String>.from(json['env']),
      stats: ContainerStats.fromJson(json['stats']),
    );
  }
}

class ContainerStats {
  final double cpuUsage;
  final MemoryStats memory;
  final NetworkStats network;

  ContainerStats({
    required this.cpuUsage,
    required this.memory,
    required this.network,
  });

  factory ContainerStats.fromJson(Map<String, dynamic> json) {
    return ContainerStats(
      cpuUsage: json['cpu'].toDouble(),
      memory: MemoryStats.fromJson(json['memory']),
      network: NetworkStats.fromJson(json['network']),
    );
  }
}

class MemoryStats {
  final int used;
  final int limit;

  MemoryStats({
    required this.used,
    required this.limit,
  });

  factory MemoryStats.fromJson(Map<String, dynamic> json) {
    return MemoryStats(
      used: json['used'],
      limit: json['limit'],
    );
  }
}

class NetworkStats {
  final int inBytes;
  final int outBytes;

  NetworkStats({
    required this.inBytes,
    required this.outBytes,
  });

  factory NetworkStats.fromJson(Map<String, dynamic> json) {
    return NetworkStats(
      inBytes: json['in'],
      outBytes: json['out'],
    );
  }
}
```

## 7. 网站管理相关模型

### 7.1 网站 (Website)

存储网站的基本信息。

```dart
class Website {
  final String id;
  final String domain;
  final String sslStatus;
  final DateTime? sslExpiry;
  final String status;
  final DateTime createTime;
  final DateTime updateTime;

  Website({
    required this.id,
    required this.domain,
    required this.sslStatus,
    this.sslExpiry,
    required this.status,
    required this.createTime,
    required this.updateTime,
  });

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      id: json['id'],
      domain: json['domain'],
      sslStatus: json['sslStatus'],
      sslExpiry: json['sslExpiry'] != null ? DateTime.parse(json['sslExpiry']) : null,
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }
}
```

### 7.2 网站详情 (WebsiteDetail)

存储网站的详细信息，继承自Website。

```dart
class WebsiteDetail extends Website {
  final List<String> aliases;
  final String rootPath;
  final List<String> indexFiles;
  final String? sslCert;
  final String? sslKey;
  final bool httpToHttps;

  WebsiteDetail({
    required String id,
    required String domain,
    required String sslStatus,
    DateTime? sslExpiry,
    required String status,
    required DateTime createTime,
    required DateTime updateTime,
    required this.aliases,
    required this.rootPath,
    required this.indexFiles,
    this.sslCert,
    this.sslKey,
    required this.httpToHttps,
  }) : super(
          id: id,
          domain: domain,
          sslStatus: sslStatus,
          sslExpiry: sslExpiry,
          status: status,
          createTime: createTime,
          updateTime: updateTime,
        );

  factory WebsiteDetail.fromJson(Map<String, dynamic> json) {
    return WebsiteDetail(
      id: json['id'],
      domain: json['domain'],
      sslStatus: json['sslStatus'],
      sslExpiry: json['sslExpiry'] != null ? DateTime.parse(json['sslExpiry']) : null,
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
      aliases: List<String>.from(json['aliases']),
      rootPath: json['rootPath'],
      indexFiles: List<String>.from(json['indexFiles']),
      sslCert: json['sslCert'],
      sslKey: json['sslKey'],
      httpToHttps: json['httpToHttps'],
    );
  }
}
```

## 8. 文件管理相关模型

### 8.1 文件/目录项 (FileItem)

存储文件或目录的基本信息。

```dart
enum FileType {
  file,
  directory,
}

class FileItem {
  final String name;
  final String path;
  final FileType type;
  final int size;
  final DateTime modTime;
  final String permissions;

  FileItem({
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.modTime,
    required this.permissions,
  });

  factory FileItem.fromJson(Map<String, dynamic> json) {
    return FileItem(
      name: json['name'],
      path: json['path'],
      type: json['type'] == 'file' ? FileType.file : FileType.directory,
      size: json['size'],
      modTime: DateTime.parse(json['modTime']),
      permissions: json['permissions'],
    );
  }
}
```

### 8.2 目录浏览结果 (DirectoryBrowseResult)

存储目录浏览的结果。

```dart
class DirectoryBrowseResult {
  final String currentPath;
  final String? parentPath;
  final List<FileItem> items;

  DirectoryBrowseResult({
    required this.currentPath,
    this.parentPath,
    required this.items,
  });

  factory DirectoryBrowseResult.fromJson(Map<String, dynamic> json) {
    return DirectoryBrowseResult(
      currentPath: json['currentPath'],
      parentPath: json['parentPath'],
      items: List<FileItem>.from(json['items'].map((x) => FileItem.fromJson(x))),
    );
  }
}
```

## 9. 备份管理相关模型

### 9.1 备份 (Backup)

存储备份的基本信息。

```dart
enum BackupType {
  app,
  website,
  database,
  system,
}

enum BackupStatus {
  completed,
  running,
  failed,
}

class Backup {
  final String id;
  final String name;
  final BackupType type;
  final String sourceId;
  final String sourceName;
  final int size;
  final BackupStatus status;
  final DateTime createTime;

  Backup({
    required this.id,
    required this.name,
    required this.type,
    required this.sourceId,
    required this.sourceName,
    required this.size,
    required this.status,
    required this.createTime,
  });

  factory Backup.fromJson(Map<String, dynamic> json) {
    BackupType type;
    switch (json['type']) {
      case 'app':
        type = BackupType.app;
        break;
      case 'website':
        type = BackupType.website;
        break;
      case 'database':
        type = BackupType.database;
        break;
      case 'system':
        type = BackupType.system;
        break;
      default:
        type = BackupType.app;
    }

    BackupStatus status;
    switch (json['status']) {
      case 'completed':
        status = BackupStatus.completed;
        break;
      case 'running':
        status = BackupStatus.running;
        break;
      case 'failed':
        status = BackupStatus.failed;
        break;
      default:
        status = BackupStatus.completed;
    }

    return Backup(
      id: json['id'],
      name: json['name'],
      type: type,
      sourceId: json['sourceId'],
      sourceName: json['sourceName'],
      size: json['size'],
      status: status,
      createTime: DateTime.parse(json['createTime']),
    );
  }
}
```

## 10. WebSocket相关模型

### 10.1 WebSocket消息 (WebSocketMessage)

存储WebSocket接收到的消息。

```dart
enum WebSocketMessageType {
  systemStats,
  containerStatus,
  appStatus,
  websiteStatus,
  unknown,
}

class WebSocketMessage {
  final WebSocketMessageType type;
  final Map<String, dynamic> data;

  WebSocketMessage({
    required this.type,
    required this.data,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    WebSocketMessageType type;
    switch (json['type']) {
      case 'system_stats':
        type = WebSocketMessageType.systemStats;
        break;
      case 'container_status':
        type = WebSocketMessageType.containerStatus;
        break;
      case 'app_status':
        type = WebSocketMessageType.appStatus;
        break;
      case 'website_status':
        type = WebSocketMessageType.websiteStatus;
        break;
      default:
        type = WebSocketMessageType.unknown;
    }

    return WebSocketMessage(
      type: type,
      data: Map<String, dynamic>.from(json['data']),
    );
  }
}
```

## 11. 数据模型关系图

```
[ServerConnectionInfo] --> [LoginResponse] --> [UserInfo]
        |
        v
[SystemOverview] <-- [SystemInfo], [CpuInfo], [MemoryInfo], [DiskInfo], [NetworkInfo]
        |
        v
+----------------+   +----------------+   +----------------+   +----------------+
|     App        |   |    Container   |   |    Website     |   |    Backup      |
+----------------+   +----------------+   +----------------+   +----------------+
        |                     |                     |                     |
        v                     v                     v                     v
+----------------+   +----------------+   +----------------+               
|    AppDetail   |   | ContainerDetail|   | WebsiteDetail  |               
+----------------+   +----------------+   +----------------+
        |                     |
        v                     v
[PortMapping], [VolumeMapping]  [PortMapping], [VolumeMapping], [ContainerStats]

[DirectoryBrowseResult] --> [FileItem]

[WebSocketMessage] --> [SystemOverview], [Container], [App], [Website]
```

## 12. 数据存储策略

### 12.1 本地存储

- **服务器连接信息**: 使用`flutter_secure_storage`存储，加密保存服务器连接信息
- **认证令牌**: 使用`flutter_secure_storage`存储，加密保存访问令牌和刷新令牌
- **用户首选项**: 使用`shared_preferences`存储，如主题设置、语言偏好等
- **离线数据**: 对于需要离线访问的数据，使用本地数据库如`sqflite`进行存储

### 12.2 缓存策略

- **内存缓存**: 使用`provider`的状态管理，在内存中缓存常用数据
- **磁盘缓存**: 使用`shared_preferences`或`sqflite`缓存需要持久化的数据
- **网络请求缓存**: 使用`dio`的缓存拦截器，缓存API响应数据

### 12.3 数据同步

- **定期同步**: 定期从服务器同步最新数据
- **实时同步**: 通过WebSocket接收实时数据更新
- **手动同步**: 提供手动刷新按钮，允许用户手动同步数据

## 13. 多服务器管理相关模型

### 13.1 服务器组 (ServerGroup)

用于对服务器进行分组管理。

```dart
class ServerGroup {
  final String id;
  final String name;
  final List<String> serverIds;
  final DateTime createTime;
  final DateTime updateTime;

  ServerGroup({
    required this.id,
    required this.name,
    required this.serverIds,
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serverIds': serverIds,
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
    };
  }

  factory ServerGroup.fromJson(Map<String, dynamic> json) {
    return ServerGroup(
      id: json['id'],
      name: json['name'],
      serverIds: List<String>.from(json['serverIds']),
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }
}
```

### 13.2 服务器连接状态 (ServerConnectionStatus)

表示服务器的连接状态。

```dart
enum ServerConnectionStatus {
  connected,
  connecting,
  disconnected,
  error,
}

class ServerConnectionState {
  final ServerConnectionInfo serverInfo;
  final ServerConnectionStatus status;
  final String? errorMessage;

  ServerConnectionState({
    required this.serverInfo,
    required this.status,
    this.errorMessage,
  });
}
```

## 14. 配置备份相关模型

### 14.1 应用配置 (AppConfig)

存储应用的全局配置信息。

```dart
class AppConfig {
  final bool darkMode;
  final String language;
  final bool useBiometric;
  final bool pushNotifications;
  final int refreshInterval;
  final bool offlineCacheEnabled;

  AppConfig({
    required this.darkMode,
    required this.language,
    required this.useBiometric,
    required this.pushNotifications,
    required this.refreshInterval,
    required this.offlineCacheEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'language': language,
      'useBiometric': useBiometric,
      'pushNotifications': pushNotifications,
      'refreshInterval': refreshInterval,
      'offlineCacheEnabled': offlineCacheEnabled,
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      darkMode: json['darkMode'] ?? false,
      language: json['language'] ?? 'en',
      useBiometric: json['useBiometric'] ?? false,
      pushNotifications: json['pushNotifications'] ?? true,
      refreshInterval: json['refreshInterval'] ?? 30,
      offlineCacheEnabled: json['offlineCacheEnabled'] ?? true,
    );
  }
}
```

### 14.2 配置备份 (ConfigBackup)

存储应用配置的备份信息。

```dart
class ConfigBackup {
  final String id;
  final String name;
  final String description;
  final DateTime createTime;
  final int size;

  ConfigBackup({
    required this.id,
    required this.name,
    required this.description,
    required this.createTime,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createTime': createTime.toIso8601String(),
      'size': size,
    };
  }

  factory ConfigBackup.fromJson(Map<String, dynamic> json) {
    return ConfigBackup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createTime: DateTime.parse(json['createTime']),
      size: json['size'],
    );
  }
}
```

## 15. AI服务相关模型

### 15.1 AI服务配置 (AIServiceConfig)

存储AI服务的配置信息。

```dart
enum AIServiceType {
  ollama,
  openai,
  custom,
}

class AIServiceConfig {
  final String id;
  final String name;
  final AIServiceType type;
  final String endpoint;
  final String apiKey;
  final bool isEnabled;
  final Map<String, dynamic>? additionalParams;

  AIServiceConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.endpoint,
    required this.apiKey,
    required this.isEnabled,
    this.additionalParams,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'endpoint': endpoint,
      'apiKey': apiKey,
      'isEnabled': isEnabled,
      'additionalParams': additionalParams,
    };
  }

  factory AIServiceConfig.fromJson(Map<String, dynamic> json) {
    return AIServiceConfig(
      id: json['id'],
      name: json['name'],
      type: AIServiceType.values[json['type']],
      endpoint: json['endpoint'],
      apiKey: json['apiKey'],
      isEnabled: json['isEnabled'],
      additionalParams: json['additionalParams'] != null
          ? Map<String, dynamic>.from(json['additionalParams'])
          : null,
    );
  }
}
```

### 15.2 AI模型 (AIModel)

存储可用的AI模型信息。

```dart
class AIModel {
  final String id;
  final String name;
  final String description;
  final String provider;
  final bool isEnabled;
  final Map<String, dynamic>? parameters;

  AIModel({
    required this.id,
    required this.name,
    required this.description,
    required this.provider,
    required this.isEnabled,
    this.parameters,
  });

  factory AIModel.fromJson(Map<String, dynamic> json) {
    return AIModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      provider: json['provider'],
      isEnabled: json['isEnabled'] ?? false,
      parameters: json['parameters'] != null
          ? Map<String, dynamic>.from(json['parameters'])
          : null,
    );
  }
}
```

## 16. 数据模型关系图

```
[ServerConnectionInfo] --> [LoginResponse] --> [UserInfo]
        |                          |
        v                          v
[ServerGroup]                   [ApiVersionInfo]
        |
        v
[SystemOverview] <-- [SystemInfo], [CpuInfo], [MemoryInfo], [DiskInfo], [NetworkInfo]
        |
        v
+----------------+   +----------------+   +----------------+   +----------------+
|     App        |   |    Container   |   |    Website     |   |    Backup      |
+----------------+   +----------------+   +----------------+   +----------------+
        |                     |                     |                     |
        v                     v                     v                     v
+----------------+   +----------------+   +----------------+                
|    AppDetail   |   | ContainerDetail|   | WebsiteDetail  |                
+----------------+   +----------------+   +----------------+
        |                     |
        v                     v
[PortMapping], [VolumeMapping]  [PortMapping], [VolumeMapping], [ContainerStats]

[DirectoryBrowseResult] --> [FileItem]

[AppConfig] --> [ConfigBackup]

[AIServiceConfig] --> [AIModel]

[WebSocketMessage] --> [SystemOverview], [Container], [App], [Website]
```

## 17. 数据模型版本控制

随着1Panel API的更新，数据模型可能需要相应地进行调整。为了确保版本兼容性，我们将采用以下策略：

- 使用ApiVersion枚举明确标识支持的API版本
- 在ServerConnectionInfo中存储每个服务器使用的API版本
- 使用工厂构造函数进行灵活的JSON解析，支持不同版本的API响应
- 对于破坏性变更，创建新的数据模型类并提供迁移路径
- 实现版本检测机制，自动识别服务器支持的API版本

---

本数据模型设计文档会根据项目需求和1Panel API的更新而定期更新。如有任何问题或建议，请联系开发团队。