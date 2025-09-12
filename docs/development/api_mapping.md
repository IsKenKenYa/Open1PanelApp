# 1Panel 移动端APP - API接口映射文档

## 1. 概述

本文档详细描述了1Panel V2 API与Flutter移动端APP之间的接口映射关系，包括认证机制、请求模型、响应模型以及错误处理。通过本文档，开发人员可以了解如何在Flutter应用中调用1Panel API，实现服务器管理功能。

### 1.1 多服务器管理支持

虽然1Panel的多服务器（多节点管理）是专业版功能，但本移动端APP通过客户端管理多个服务器连接的方式，实现了变相的免费多服务器管理功能。用户可以在APP中添加、切换和管理多个1Panel服务器，每个服务器连接都独立维护其认证状态和数据。

## 2. 认证机制

### 2.1 登录认证
1Panel API使用基于Token的认证机制。用户登录后，服务器返回一个访问令牌，后续请求需要在请求头中携带该令牌。

#### 2.1.1 登录请求
- **API端点**: `/api/v1/auth/login`
- **请求方法**: POST
- **请求模型**: `request.Login`
- **响应模型**: `response.Login`

#### 2.1.2 Flutter实现（支持多服务器）
```dart
/// 服务器连接信息模型
class ServerConnection {
  final String id; // 服务器唯一标识
  final String name; // 服务器名称
  final String url; // 服务器URL
  final String version; // 1Panel版本
  final bool isDefault; // 是否为默认服务器
  final DateTime lastConnected;

  ServerConnection({
    required this.id,
    required this.name,
    required this.url,
    required this.version,
    this.isDefault = false,
    DateTime? lastConnected,
  }) : this.lastConnected = lastConnected ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'version': version,
      'isDefault': isDefault,
      'lastConnected': lastConnected.toIso8601String(),
    };
  }

  factory ServerConnection.fromJson(Map<String, dynamic> json) {
    return ServerConnection(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      version: json['version'],
      isDefault: json['isDefault'],
      lastConnected: DateTime.parse(json['lastConnected']),
    );
  }
}

/// 服务器连接管理器
class ServerConnectionManager {
  static const _serversKey = 'servers';
  static const _currentServerIdKey = 'current_server_id';
  
  /// 登录并保存服务器信息
  Future<LoginResponse> login({
    required String username,
    required String password,
    required String serverUrl,
    required String serverName,
    bool setAsDefault = false,
  }) async {
    // 确保URL格式正确
    String formattedUrl = serverUrl.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      // 默认使用https
      formattedUrl = 'https://$formattedUrl';
    }
    
    // 移除URL末尾的斜杠
    if (formattedUrl.endsWith('/')) {
      formattedUrl = formattedUrl.substring(0, formattedUrl.length - 1);
    }

    try {
      final response = await http.post(
        Uri.parse('$formattedUrl/api/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        
        // 创建或更新服务器连接信息
        final serverId = _generateServerId(formattedUrl);
        final serverConnection = ServerConnection(
          id: serverId,
          name: serverName,
          url: formattedUrl,
          version: loginResponse.version ?? 'Unknown',
          isDefault: setAsDefault,
          lastConnected: DateTime.now(),
        );
        
        // 保存服务器信息
        await _saveServer(serverConnection);
        
        // 保存令牌
        final tokenStorage = TokenStorage();
        await tokenStorage.saveToken(serverId, loginResponse.token);
        
        // 如果设为默认服务器，更新默认服务器设置
        if (setAsDefault) {
          await _setCurrentServerId(serverId);
        }
        
        return loginResponse;
      } else {
        // 解析错误信息
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? '登录失败';
        throw Exception('登录失败: $errorMessage');
      }
    } catch (e) {
      throw Exception('连接服务器失败: ${e.toString()}');
    }
  }
  
  /// 生成服务器唯一ID
  String _generateServerId(String url) {
    return url.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  }
  
  /// 保存服务器信息
  Future<void> _saveServer(ServerConnection server) async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = prefs.getString(_serversKey);
    
    List<ServerConnection> servers = [];
    if (serversJson != null) {
      final List<dynamic> serversList = jsonDecode(serversJson);
      servers = serversList
          .map((json) => ServerConnection.fromJson(json))
          .toList();
    }
    
    // 移除已存在的相同ID的服务器
    servers.removeWhere((s) => s.id == server.id);
    
    // 如果设为默认，取消其他服务器的默认状态
    if (server.isDefault) {
      servers = servers.map((s) => 
          ServerConnection.fromJson(s.toJson()..['isDefault'] = false)
      ).toList();
    }
    
    // 添加新服务器
    servers.add(server);
    
    // 保存更新后的服务器列表
    final updatedServersJson = jsonEncode(
      servers.map((s) => s.toJson()).toList()
    );
    await prefs.setString(_serversKey, updatedServersJson);
  }
  
  /// 设置当前活动服务器
  Future<void> setCurrentServer(String serverId) async {
    await _setCurrentServerId(serverId);
    
    // 更新最后连接时间
    final servers = await getAllServers();
    final server = servers.firstWhere((s) => s.id == serverId);
    final updatedServer = ServerConnection(
      id: server.id,
      name: server.name,
      url: server.url,
      version: server.version,
      isDefault: server.isDefault,
      lastConnected: DateTime.now(),
    );
    await _saveServer(updatedServer);
  }
  
  /// 获取当前活动服务器
  Future<ServerConnection?> getCurrentServer() async {
    final serverId = await _getCurrentServerId();
    if (serverId == null) return null;
    
    final servers = await getAllServers();
    return servers.firstWhere((s) => s.id == serverId, orElse: () => null);
  }
  
  /// 获取所有已保存的服务器
  Future<List<ServerConnection>> getAllServers() async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = prefs.getString(_serversKey);
    
    if (serversJson == null) return [];
    
    final List<dynamic> serversList = jsonDecode(serversJson);
    return serversList
        .map((json) => ServerConnection.fromJson(json))
        .toList();
  }
  
  /// 删除服务器
  Future<void> deleteServer(String serverId) async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = prefs.getString(_serversKey);
    
    if (serversJson == null) return;
    
    List<ServerConnection> servers = [];
    final List<dynamic> serversList = jsonDecode(serversJson);
    servers = serversList
        .map((json) => ServerConnection.fromJson(json))
        .toList();
    
    // 移除指定服务器
    servers.removeWhere((s) => s.id == serverId);
    
    // 如果删除的是当前服务器，尝试设置其他服务器为当前
    final currentServerId = await _getCurrentServerId();
    if (currentServerId == serverId && servers.isNotEmpty) {
      await _setCurrentServerId(servers[0].id);
    }
    
    // 保存更新后的服务器列表
    final updatedServersJson = jsonEncode(
      servers.map((s) => s.toJson()).toList()
    );
    await prefs.setString(_serversKey, updatedServersJson);
    
    // 同时删除该服务器的令牌
    final tokenStorage = TokenStorage();
    await tokenStorage.removeToken(serverId);
  }
  
  /// 保存当前服务器ID
  Future<void> _setCurrentServerId(String serverId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentServerIdKey, serverId);
  }
  
  /// 获取当前服务器ID
  Future<String?> _getCurrentServerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentServerIdKey);
  }
}

### 2.2 令牌管理
在Flutter应用中，我们需要管理访问令牌，包括存储、刷新和失效处理。

#### 2.2.1 令牌存储
```dart
class TokenStorage {
  static const String _tokenPrefix = 'auth_token_';
  
  /// 保存令牌
  Future<void> saveToken(String serverId, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_getTokenKey(serverId), token);
  }
  
  /// 获取令牌
  Future<String?> getToken(String serverId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_getTokenKey(serverId));
  }
  
  /// 移除令牌
  Future<void> removeToken(String serverId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getTokenKey(serverId));
  }
  
  /// 生成令牌存储键名
  String _getTokenKey(String serverId) {
    return '$_tokenPrefix$serverId';
  }
}
```

#### 2.2.2 令牌刷新（支持多服务器）
```dart
Future<void> refreshToken(String serverId, String serverUrl) async {
  final tokenStorage = TokenStorage();
  final token = await tokenStorage.getToken(serverId);
  if (token == null) {
    throw Exception('没有令牌可刷新');
  }

  final response = await http.post(
    Uri.parse('$serverUrl/api/v1/auth/refresh'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final newToken = data['token'];
    await tokenStorage.saveToken(serverId, newToken);
  } else {
    throw Exception('刷新令牌失败');
  }
}
```

### 2.3 请求拦截器
为了在每个请求中自动添加认证令牌，我们可以使用Dio库的拦截器：

```dart
class AuthInterceptor extends Interceptor {
  final String serverId;
  final String serverUrl;
  final ServerConnectionManager _serverManager;
  final TokenStorage _tokenStorage;
  
  AuthInterceptor({
    required this.serverId,
    required this.serverUrl,
  }) : _serverManager = ServerConnectionManager(),
       _tokenStorage = TokenStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getToken(serverId);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 令牌过期，尝试刷新
      try {
        await refreshToken(serverId, serverUrl);
        final token = await _tokenStorage.getToken(serverId);
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        // 重试请求
        final response = await Dio().fetch(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        // 刷新失败，清除令牌
        await _tokenStorage.removeToken(serverId);
        handler.next(err);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
```

## 3. HTTP客户端封装

### 3.1 支持多服务器的认证拦截器
```dart
class AuthInterceptor extends Interceptor {
  final String serverId;
  final String serverUrl;
  final ServerConnectionManager _serverManager;
  final TokenStorage _tokenStorage;
  
  AuthInterceptor({
    required this.serverId,
    required this.serverUrl,
  }) : _serverManager = ServerConnectionManager(),
       _tokenStorage = TokenStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getToken(serverId);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await refreshToken(serverId, serverUrl);
        // 重新发起请求
        final options = err.requestOptions;
        final token = await _tokenStorage.getToken(serverId);
        options.headers['Authorization'] = 'Bearer $token';
        final response = await Dio().request(
          options.path,
          options: options,
        );
        handler.resolve(response);
        return;
      } catch (_) {
        // 刷新失败，清除令牌
        await _tokenStorage.removeToken(serverId);
      }
    }
    handler.next(err);
  }
}

### 3.2 支持多服务器的API客户端
class ApiClient {
  final String serverId;
  final String serverUrl;
  late Dio _dio;
  
  ApiClient({
    required this.serverId,
    required this.serverUrl,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: serverUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ));
    
    // 添加拦截器
    _dio.interceptors.add(AuthInterceptor(
      serverId: serverId,
      serverUrl: serverUrl,
    ));
    _dio.interceptors.add(LogInterceptor());
  }
  
  Dio get dio => _dio;
}

### 3.3 API客户端管理器
class ApiClientManager {
  static final ApiClientManager _instance = ApiClientManager._internal();
  final Map<String, ApiClient> _clients = {};
  
  factory ApiClientManager() {
    return _instance;
  }
  
  ApiClientManager._internal();
  
  /// 获取指定服务器的API客户端
  ApiClient getClient(String serverId, String serverUrl) {
    if (!_clients.containsKey(serverId)) {
      _clients[serverId] = ApiClient(
        serverId: serverId,
        serverUrl: serverUrl,
      );
    }
    return _clients[serverId]!;
  }
  
  /// 移除指定服务器的API客户端
  void removeClient(String serverId) {
    _clients.remove(serverId);
  }
  
  /// 清除所有API客户端
  void clearAllClients() {
    _clients.clear();
  }
}

### 3.2 API服务类（支持多服务器）
```dart
class ApiService {
  final String serverId;
  final String serverUrl;
  late final Dio _dio;
  final ApiClientManager _apiClientManager = ApiClientManager();
  
  ApiService({
    required this.serverId,
    required this.serverUrl,
  }) {
    final apiClient = _apiClientManager.getClient(serverId, serverUrl);
    _dio = apiClient.dio;
  }
  
  // 通用请求方法
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
  
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }
  
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
```

## 4. 仪表盘模块

### 4.1 获取系统概览
- **API端点**: `/api/v1/dashboard/overview`
- **请求方法**: GET
- **响应模型**: `response.DashboardOverview`

#### 4.1.1 Flutter实现
```dart
class DashboardService {
  final ApiService _apiService;
  
  DashboardService({
    required String serverId,
    required String serverUrl,
  }) : _apiService = ApiService(
         serverId: serverId,
         serverUrl: serverUrl,
       );
  
  Future<DashboardOverview> getOverview() async {
    try {
      final response = await _apiService.get('/api/v1/dashboard/overview');
      return DashboardOverview.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('获取系统概览失败: ${e.message}');
    }
  }
}
```

#### 4.1.2 数据模型
```dart
class DashboardOverview {
  final SystemInfo system;
  final CpuInfo cpu;
  final MemoryInfo memory;
  final DiskInfo disk;
  final NetworkInfo network;
  
  DashboardOverview({
    required this.system,
    required this.cpu,
    required this.memory,
    required this.disk,
    required this.network,
  });
  
  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      system: SystemInfo.fromJson(json['system']),
      cpu: CpuInfo.fromJson(json['cpu']),
      memory: MemoryInfo.fromJson(json['memory']),
      disk: DiskInfo.fromJson(json['disk']),
      network: NetworkInfo.fromJson(json['network']),
    );
  }
}

class SystemInfo {
  final String hostname;
  final String os;
  final String kernel;
  final String uptime;
  
  SystemInfo({
    required this.hostname,
    required this.os,
    required this.kernel,
    required this.uptime,
  });
  
  factory SystemInfo.fromJson(Map<String, dynamic> json) {
    return SystemInfo(
      hostname: json['hostname'],
      os: json['os'],
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
  final double usage;
  final int total;
  final int available;
  
  MemoryInfo({
    required this.usage,
    required this.total,
    required this.available,
  });
  
  factory MemoryInfo.fromJson(Map<String, dynamic> json) {
    return MemoryInfo(
      usage: json['usage'].toDouble(),
      total: json['total'],
      available: json['available'],
    );
  }
}

class DiskInfo {
  final double usage;
  final int total;
  final int available;
  
  DiskInfo({
    required this.usage,
    required this.total,
    required this.available,
  });
  
  factory DiskInfo.fromJson(Map<String, dynamic> json) {
    return DiskInfo(
      usage: json['usage'].toDouble(),
      total: json['total'],
      available: json['available'],
    );
  }
}

class NetworkInfo {
  final int bytesReceived;
  final int bytesSent;
  
  NetworkInfo({
    required this.bytesReceived,
    required this.bytesSent,
  });
  
  factory NetworkInfo.fromJson(Map<String, dynamic> json) {
    return NetworkInfo(
      bytesReceived: json['bytesReceived'],
      bytesSent: json['bytesSent'],
    );
  }
}
```

### 4.2 获取系统状态
- **API端点**: `/api/v1/dashboard/status`
- **请求方法**: GET
- **响应模型**: `response.DashboardStatus`

#### 4.2.1 Flutter实现
```dart
Future<DashboardStatus> getStatus() async {
  try {
    final response = await _apiService.get('/api/v1/dashboard/status');
    return DashboardStatus.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('获取系统状态失败: ${e.message}');
  }
}
```

## 5. 应用管理模块

### 5.1 获取应用列表
- **API端点**: `/api/v1/apps`
- **请求方法**: GET
- **响应模型**: `List<response.AppDTO>`

#### 5.1.1 Flutter实现
```dart
class AppService {
  final ApiService _apiService;
  
  AppService({
    required String serverId,
    required String serverUrl,
  }) : _apiService = ApiService(
         serverId: serverId,
         serverUrl: serverUrl,
       );
  
  Future<List<AppDTO>> getAppList() async {
    try {
      final response = await _apiService.get('/api/v1/apps');
      final List<dynamic> data = response.data;
      return data.map((json) => AppDTO.fromJson(json)).toList();
    } on DioError catch (e) {
      throw Exception('获取应用列表失败: ${e.message}');
    }
  }
}
```

#### 5.1.2 数据模型
```dart
class AppDTO {
  final int id;
  final String name;
  final String key;
  final String version;
  final String status;
  final String description;
  final String icon;
  final DateTime installTime;
  final int port;
  final String index;
  
  AppDTO({
    required this.id,
    required this.name,
    required this.key,
    required this.version,
    required this.status,
    required this.description,
    required this.icon,
    required this.installTime,
    required this.port,
    required this.index,
  });
  
  factory AppDTO.fromJson(Map<String, dynamic> json) {
    return AppDTO(
      id: json['id'],
      name: json['name'],
      key: json['key'],
      version: json['version'],
      status: json['status'],
      description: json['description'],
      icon: json['icon'],
      installTime: DateTime.parse(json['installTime']),
      port: json['port'],
      index: json['index'],
    );
  }
}
```

### 5.2 获取应用详情
- **API端点**: `/api/v1/apps/{id}`
- **请求方法**: GET
- **响应模型**: `response.AppDetail`

#### 5.2.1 Flutter实现
```dart
Future<AppDetail> getAppDetail(int id) async {
  try {
    final response = await _apiService.get('/api/v1/apps/$id');
    return AppDetail.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('获取应用详情失败: ${e.message}');
  }
}
```

### 5.3 安装应用
- **API端点**: `/api/v1/apps/install`
- **请求方法**: POST
- **请求模型**: `request.AppInstallCreate`
- **响应模型**: `response.AppInstall`

#### 5.3.1 Flutter实现
```dart
Future<AppInstall> installApp(AppInstallCreateRequest request) async {
  try {
    final response = await _apiService.post(
      '/api/v1/apps/install',
      data: request.toJson(),
    );
    return AppInstall.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('安装应用失败: ${e.message}');
  }
}
```

#### 5.3.2 请求模型
```dart
class AppInstallCreateRequest {
  final String appKey;
  final String version;
  final String? name;
  final int? port;
  final bool? enableSSL;
  final String? domain;
  final String? advancedConfig;
  
  AppInstallCreateRequest({
    required this.appKey,
    required this.version,
    this.name,
    this.port,
    this.enableSSL,
    this.domain,
    this.advancedConfig,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'appKey': appKey,
      'version': version,
      'name': name,
      'port': port,
      'enableSSL': enableSSL,
      'domain': domain,
      'advancedConfig': advancedConfig,
    };
  }
}
```

### 5.4 卸载应用
- **API端点**: `/api/v1/apps/{id}/uninstall`
- **请求方法**: POST
- **响应模型**: `response.AppUninstall`

#### 5.4.1 Flutter实现
```dart
Future<AppUninstall> uninstallApp(int id) async {
  try {
    final response = await _apiService.post('/api/v1/apps/$id/uninstall');
    return AppUninstall.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('卸载应用失败: ${e.message}');
  }
}
```

### 5.5 启动/停止应用
- **API端点**: `/api/v1/apps/{id}/start` 或 `/api/v1/apps/{id}/stop`
- **请求方法**: POST
- **响应模型**: `response.AppOperate`

#### 5.5.1 Flutter实现
```dart
Future<AppOperate> startApp(int id) async {
  try {
    final response = await _apiService.post('/api/v1/apps/$id/start');
    return AppOperate.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('启动应用失败: ${e.message}');
  }
}

Future<AppOperate> stopApp(int id) async {
  try {
    final response = await _apiService.post('/api/v1/apps/$id/stop');
    return AppOperate.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('停止应用失败: ${e.message}');
  }
}
```

## 6. 容器管理模块

### 6.1 获取容器列表
- **API端点**: `/api/v1/containers`
- **请求方法**: GET
- **响应模型**: `List<response.ContainerDTO>`

#### 6.1.1 Flutter实现
```dart
class ContainerService {
  final ApiService _apiService;
  
  ContainerService({
    required String serverId,
    required String serverUrl,
  }) : _apiService = ApiService(
         serverId: serverId,
         serverUrl: serverUrl,
       );
  
  Future<List<ContainerDTO>> getContainerList() async {
    try {
      final response = await _apiService.get('/api/v1/containers');
      final List<dynamic> data = response.data;
      return data.map((json) => ContainerDTO.fromJson(json)).toList();
    } on DioError catch (e) {
      throw Exception('获取容器列表失败: ${e.message}');
    }
  }
}
```

#### 6.1.2 数据模型
```dart
class ContainerDTO {
  final String id;
  final String name;
  final String image;
  final String status;
  final String state;
  final DateTime created;
  final List<String> ports;
  final Map<String, String> labels;
  
  ContainerDTO({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.state,
    required this.created,
    required this.ports,
    required this.labels,
  });
  
  factory ContainerDTO.fromJson(Map<String, dynamic> json) {
    return ContainerDTO(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      state: json['state'],
      created: DateTime.parse(json['created']),
      ports: List<String>.from(json['ports']),
      labels: Map<String, String>.from(json['labels']),
    );
  }
}
```

### 6.2 获取容器详情
- **API端点**: `/api/v1/containers/{id}`
- **请求方法**: GET
- **响应模型**: `response.ContainerDetail`

#### 6.2.1 Flutter实现
```dart
Future<ContainerDetail> getContainerDetail(String id) async {
  try {
    final response = await _apiService.get('/api/v1/containers/$id');
    return ContainerDetail.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('获取容器详情失败: ${e.message}');
  }
}
```

### 6.3 启动/停止容器
- **API端点**: `/api/v1/containers/{id}/start` 或 `/api/v1/containers/{id}/stop`
- **请求方法**: POST
- **响应模型**: `response.ContainerOperate`

#### 6.3.1 Flutter实现
```dart
Future<ContainerOperate> startContainer(String id) async {
  try {
    final response = await _apiService.post('/api/v1/containers/$id/start');
    return ContainerOperate.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('启动容器失败: ${e.message}');
  }
}

Future<ContainerOperate> stopContainer(String id) async {
  try {
    final response = await _apiService.post('/api/v1/containers/$id/stop');
    return ContainerOperate.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('停止容器失败: ${e.message}');
  }
}
```

### 6.4 删除容器
- **API端点**: `/api/v1/containers/{id}`
- **请求方法**: DELETE
- **响应模型**: `response.ContainerDelete`

#### 6.4.1 Flutter实现
```dart
Future<ContainerDelete> deleteContainer(String id) async {
  try {
    final response = await _apiService.delete('/api/v1/containers/$id');
    return ContainerDelete.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('删除容器失败: ${e.message}');
  }
}
```

## 7. 网站管理模块

### 7.1 获取网站列表
- **API端点**: `/api/v1/websites`
- **请求方法**: GET
- **响应模型**: `List<response.WebsiteDTO>`

#### 7.1.1 Flutter实现
```dart
class WebsiteService {
  final ApiService _apiService;
  
  WebsiteService({
    required String serverId,
    required String serverUrl,
  }) : _apiService = ApiService(
         serverId: serverId,
         serverUrl: serverUrl,
       );
  
  Future<List<WebsiteDTO>> getWebsiteList() async {
    try {
      final response = await _apiService.get('/api/v1/websites');
      final List<dynamic> data = response.data;
      return data.map((json) => WebsiteDTO.fromJson(json)).toList();
    } on DioError catch (e) {
      throw Exception('获取网站列表失败: ${e.message}');
    }
  }
}
```

#### 7.1.2 数据模型
```dart
class WebsiteDTO {
  final int id;
  final String primaryDomain;
  final List<String> otherDomains;
  final String alias;
  final String sitePath;
  final String type;
  final String status;
  final bool ssl;
  final DateTime createTime;
  final DateTime updateTime;
  
  WebsiteDTO({
    required this.id,
    required this.primaryDomain,
    required this.otherDomains,
    required this.alias,
    required this.sitePath,
    required this.type,
    required this.status,
    required this.ssl,
    required this.createTime,
    required this.updateTime,
  });
  
  factory WebsiteDTO.fromJson(Map<String, dynamic> json) {
    return WebsiteDTO(
      id: json['id'],
      primaryDomain: json['primaryDomain'],
      otherDomains: List<String>.from(json['otherDomains']),
      alias: json['alias'],
      sitePath: json['sitePath'],
      type: json['type'],
      status: json['status'],
      ssl: json['ssl'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }
}
```

### 7.2 获取网站详情
- **API端点**: `/api/v1/websites/{id}`
- **请求方法**: GET
- **响应模型**: `response.WebsiteDetail`

#### 7.2.1 Flutter实现
```dart
Future<WebsiteDetail> getWebsiteDetail(int id) async {
  try {
    final response = await _apiService.get('/api/v1/websites/$id');
    return WebsiteDetail.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('获取网站详情失败: ${e.message}');
  }
}
```

### 7.3 创建网站
- **API端点**: `/api/v1/websites`
- **请求方法**: POST
- **请求模型**: `request.WebsiteCreate`
- **响应模型**: `response.WebsiteCreate`

#### 7.3.1 Flutter实现
```dart
Future<WebsiteCreate> createWebsite(WebsiteCreateRequest request) async {
  try {
    final response = await _apiService.post(
      '/api/v1/websites',
      data: request.toJson(),
    );
    return WebsiteCreate.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('创建网站失败: ${e.message}');
  }
}
```

#### 7.3.2 请求模型
```dart
class WebsiteCreateRequest {
  final String primaryDomain;
  final List<String> otherDomains;
  final String alias;
  final String sitePath;
  final String type;
  final bool enableSSL;
  
  WebsiteCreateRequest({
    required this.primaryDomain,
    required this.otherDomains,
    required this.alias,
    required this.sitePath,
    required this.type,
    required this.enableSSL,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'primaryDomain': primaryDomain,
      'otherDomains': otherDomains,
      'alias': alias,
      'sitePath': sitePath,
      'type': type,
      'enableSSL': enableSSL,
    };
  }
}
```

### 7.4 删除网站
- **API端点**: `/api/v1/websites/{id}`
- **请求方法**: DELETE
- **响应模型**: `response.WebsiteDelete`

#### 7.4.1 Flutter实现
```dart
Future<WebsiteDelete> deleteWebsite(int id) async {
  try {
    final response = await _apiService.delete('/api/v1/websites/$id');
    return WebsiteDelete.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('删除网站失败: ${e.message}');
  }
}
```

### 7.5 启用/禁用SSL
- **API端点**: `/api/v1/websites/{id}/ssl/enable` 或 `/api/v1/websites/{id}/ssl/disable`
- **请求方法**: POST
- **响应模型**: `response.WebsiteSSLOperate`

#### 7.5.1 Flutter实现
```dart
Future<WebsiteSSLOperate> enableSSL(int id) async {
  try {
    final response = await _apiService.post('/api/v1/websites/$id/ssl/enable');
    return WebsiteSSLOperate.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('启用SSL失败: ${e.message}');
  }
}

Future<WebsiteSSLOperate> disableSSL(int id) async {
  try {
    final response = await _apiService.post('/api/v1/websites/$id/ssl/disable');
    return WebsiteSSLOperate.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('禁用SSL失败: ${e.message}');
  }
}
```

## 8. 文件管理模块

### 8.1 获取文件列表
- **API端点**: `/api/v1/files`
- **请求方法**: GET
- **请求参数**: `path` (文件路径)
- **响应模型**: `List<response.FileInfo>`

#### 8.1.1 Flutter实现
```dart
class FileService {
  final ApiService _apiService;
  
  FileService({
    required String serverId,
    required String serverUrl,
  }) : _apiService = ApiService(
         serverId: serverId,
         serverUrl: serverUrl,
       );
  
  Future<List<FileInfo>> getFileList(String path) async {
    try {
      final response = await _apiService.get(
        '/api/v1/files',
        queryParameters: {'path': path},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => FileInfo.fromJson(json)).toList();
    } on DioError catch (e) {
      throw Exception('获取文件列表失败: ${e.message}');
    }
  }
}
```

#### 8.1.2 数据模型
```dart
class FileInfo {
  final String name;
  final String path;
  final bool isDir;
  final int size;
  final DateTime modifyTime;
  final String permission;
  
  FileInfo({
    required this.name,
    required this.path,
    required this.isDir,
    required this.size,
    required this.modifyTime,
    required this.permission,
  });
  
  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      name: json['name'],
      path: json['path'],
      isDir: json['isDir'],
      size: json['size'],
      modifyTime: DateTime.parse(json['modifyTime']),
      permission: json['permission'],
    );
  }
}
```

### 8.2 上传文件
- **API端点**: `/api/v1/files/upload`
- **请求方法**: POST
- **请求参数**: `path` (目标路径), `file` (文件)
- **响应模型**: `response.FileUpload`

#### 8.2.1 Flutter实现
```dart
Future<FileUpload> uploadFile(String path, File file) async {
  try {
    final fileName = path.split('/').last;
    final formData = FormData.fromMap({
      'path': path,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    
    final response = await _apiService.post(
      '/api/v1/files/upload',
      data: formData,
    );
    return FileUpload.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('上传文件失败: ${e.message}');
  }
}
```

### 8.3 下载文件
- **API端点**: `/api/v1/files/download`
- **请求方法**: GET
- **请求参数**: `path` (文件路径)
- **响应**: 文件内容

#### 8.3.1 Flutter实现
```dart
Future<void> downloadFile(String path, String savePath) async {
  try {
    final response = await _apiService.get(
      '/api/v1/files/download',
      queryParameters: {'path': path},
      options: Options(responseType: ResponseType.bytes),
    );
    
    final file = File(savePath);
    await file.writeAsBytes(response.data);
  } on DioError catch (e) {
    throw Exception('下载文件失败: ${e.message}');
  }
}
```

### 8.4 删除文件
- **API端点**: `/api/v1/files`
- **请求方法**: DELETE
- **请求参数**: `paths` (文件路径列表)
- **响应模型**: `response.FileDelete`

#### 8.4.1 Flutter实现
```dart
Future<FileDelete> deleteFiles(List<String> paths) async {
  try {
    final response = await _apiService.delete(
      '/api/v1/files',
      data: {'paths': paths},
    );
    return FileDelete.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('删除文件失败: ${e.message}');
  }
}
```

### 8.5 创建目录
- **API端点**: `/api/v1/files/directory`
- **请求方法**: POST
- **请求参数**: `path` (目录路径)
- **响应模型**: `response.FileCreateDir`

#### 8.5.1 Flutter实现
```dart
Future<FileCreateDir> createDirectory(String path) async {
  try {
    final response = await _apiService.post(
      '/api/v1/files/directory',
      data: {'path': path},
    );
    return FileCreateDir.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('创建目录失败: ${e.message}');
  }
}
```

## 9. 备份管理模块

### 9.1 获取备份列表
- **API端点**: `/api/v1/backups`
- **请求方法**: GET
- **响应模型**: `List<response.BackupDTO>`

#### 9.1.1 Flutter实现
```dart
class BackupService {
  final ApiService _apiService;
  
  BackupService({
    required String serverId,
    required String serverUrl,
  }) : _apiService = ApiService(
         serverId: serverId,
         serverUrl: serverUrl,
       );
  
  Future<List<BackupDTO>> getBackupList() async {
    try {
      final response = await _apiService.get('/api/v1/backups');
      final List<dynamic> data = response.data;
      return data.map((json) => BackupDTO.fromJson(json)).toList();
    } on DioError catch (e) {
      throw Exception('获取备份列表失败: ${e.message}');
    }
  }
}
```

#### 9.1.2 数据模型
```dart
class BackupDTO {
  final int id;
  final String name;
  final String type;
  final String status;
  final String path;
  final DateTime createTime;
  final int size;
  final String description;
  
  BackupDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.path,
    required this.createTime,
    required this.size,
    required this.description,
  });
  
  factory BackupDTO.fromJson(Map<String, dynamic> json) {
    return BackupDTO(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      status: json['status'],
      path: json['path'],
      createTime: DateTime.parse(json['createTime']),
      size: json['size'],
      description: json['description'],
    );
  }
}
```

### 9.2 创建备份
- **API端点**: `/api/v1/backups`
- **请求方法**: POST
- **请求模型**: `request.BackupCreate`
- **响应模型**: `response.BackupCreate`

#### 9.2.1 Flutter实现
```dart
Future<BackupCreate> createBackup(BackupCreateRequest request) async {
  try {
    final response = await _apiService.post(
      '/api/v1/backups',
      data: request.toJson(),
    );
    return BackupCreate.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('创建备份失败: ${e.message}');
  }
}
```

#### 9.2.2 请求模型
```dart
class BackupCreateRequest {
  final String name;
  final String type;
  final List<String> sourcePaths;
  final String targetPath;
  final String? description;
  
  BackupCreateRequest({
    required this.name,
    required this.type,
    required this.sourcePaths,
    required this.targetPath,
    this.description,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'sourcePaths': sourcePaths,
      'targetPath': targetPath,
      'description': description,
    };
  }
}
```

### 9.3 恢复备份
- **API端点**: `/api/v1/backups/{id}/restore`
- **请求方法**: POST
- **响应模型**: `response.BackupRestore`

#### 9.3.1 Flutter实现
```dart
Future<BackupRestore> restoreBackup(int id) async {
  try {
    final response = await _apiService.post('/api/v1/backups/$id/restore');
    return BackupRestore.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('恢复备份失败: ${e.message}');
  }
}
```

### 9.4 删除备份
- **API端点**: `/api/v1/backups/{id}`
- **请求方法**: DELETE
- **响应模型**: `response.BackupDelete`

#### 9.4.1 Flutter实现
```dart
Future<BackupDelete> deleteBackup(int id) async {
  try {
    final response = await _apiService.delete('/api/v1/backups/$id');
    return BackupDelete.fromJson(response.data);
  } on DioError catch (e) {
    throw Exception('删除备份失败: ${e.message}');
  }
}
```

## 10. 错误处理

### 10.1 错误类型
1Panel API返回的错误类型主要包括：

- **400 Bad Request**: 请求参数错误
- **401 Unauthorized**: 未授权，需要登录
- **403 Forbidden**: 权限不足
- **404 Not Found**: 资源不存在
- **500 Internal Server Error**: 服务器内部错误

### 10.2 错误处理实现
```dart
class ApiErrorHandler {
  static void handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectionError:
        throw Exception('网络连接错误，请检查网络设置');
      case DioErrorType.connectionTimeout:
        throw Exception('连接超时，请稍后重试');
      case DioErrorType.sendTimeout:
        throw Exception('发送请求超时，请稍后重试');
      case DioErrorType.receiveTimeout:
        throw Exception('接收响应超时，请稍后重试');
      case DioErrorType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? '未知错误';
        
        switch (statusCode) {
          case 400:
            throw Exception('请求参数错误: $message');
          case 401:
            throw Exception('未授权，请重新登录');
          case 403:
            throw Exception('权限不足: $message');
          case 404:
            throw Exception('资源不存在: $message');
          case 500:
            throw Exception('服务器内部错误: $message');
          default:
            throw Exception('请求失败: $message');
        }
      case DioErrorType.cancel:
        throw Exception('请求已取消');
      case DioErrorType.unknown:
        throw Exception('未知错误: ${error.message}');
    }
  }
}
```

### 10.3 错误提示UI
```dart
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      action: SnackBarAction(
        label: '确定',
        textColor: Theme.of(context).colorScheme.onError,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
```

## 11. 数据缓存

### 11.1 缓存策略
为了提高应用性能和减少网络请求，我们需要实现数据缓存策略：

```dart
class CacheManager {
  static const _cacheDuration = Duration(minutes:30);
  static final _cache = <String, _CacheEntry>{};
  
  static T? get<T>(String key) {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired) {
      return entry.data as T;
    }
    return null;
  }
  
  static void put<T>(String key, T data) {
    _cache[key] = _CacheEntry(data, DateTime.now().add(_cacheDuration));
  }
  
  static void remove(String key) {
    _cache.remove(key);
  }
  
  static void clear() {
    _cache.clear();
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiryTime;
  
  _CacheEntry(this.data, this.expiryTime);
  
  bool get isExpired => DateTime.now().isAfter(expiryTime);
}
```

### 11.2 带缓存的服务实现
```dart
class AppServiceWithCache {
  final ApiService _apiService;
  final String _serverId;
  
  AppServiceWithCache({
    required String serverId,
    required String serverUrl,
  }) : _apiService = ApiService(
         serverId: serverId,
         serverUrl: serverUrl,
       ),
       _serverId = serverId;
  
  Future<List<AppDTO>> getAppList({bool forceRefresh = false}) async {
    final cacheKey = '${_serverId}_app_list';
    
    if (!forceRefresh) {
      final cachedData = CacheManager.get<List<AppDTO>>(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
    }
    
    try {
      final response = await _apiService.get('/api/v1/apps');
      final List<dynamic> data = response.data;
      final appList = data.map((json) => AppDTO.fromJson(json)).toList();
      
      // 缓存数据
      CacheManager.put(cacheKey, appList);
      
      return appList;
    } on DioError catch (e) {
      // 如果网络请求失败，尝试返回缓存数据
      final cachedData = CacheManager.get<List<AppDTO>>(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      
      ApiErrorHandler.handleError(e);
    }
    
    return [];
  }
}
```

## 12. 实时数据更新

### 12.1 WebSocket连接
为了实现实时数据更新，我们需要使用WebSocket连接：

```dart
class WebSocketService {
  final String serverId;
  final String serverUrl;
  IOWebSocketChannel? _channel;
  final StreamController<dynamic> _streamController = StreamController.broadcast();
  final TokenStorage _tokenStorage = TokenStorage();
  
  Stream<dynamic> get stream => _streamController.stream;
  
  WebSocketService({
    required this.serverId,
    required this.serverUrl,
  });
  
  Future<void> connect() async {
    try {
      final token = await _tokenStorage.getToken(serverId);
      // 将HTTP URL转换为WebSocket URL
      final wsProtocol = serverUrl.startsWith('https') ? 'wss' : 'ws';
      final wsBaseUrl = serverUrl.replaceFirst(RegExp(r'^https?://'), '');
      final wsUrl = '$wsProtocol://$wsBaseUrl/ws?token=$token';
      
      _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      
      _channel!.stream.listen(
        (data) {
          _streamController.add(data);
        },
        onError: (error) {
          _streamController.addError(error);
        },
        onDone: () {
          _streamController.close();
        },
      );
    } catch (e) {
      _streamController.addError('WebSocket连接失败: $e');
    }
  }
  
  void send(dynamic data) {
    _channel?.sink.add(data);
  }
  
  void disconnect() {
    _channel?.sink.close();
    _streamController.close();
  }
}
```

### 12.2 实时数据监听
```dart
class RealTimeDataService {
  final WebSocketService _webSocketService = WebSocketService();
  
  Stream<dynamic> get realTimeData => _webSocketService.stream;
  
  Future<void> connect() async {
    await _webSocketService.connect();
  }
  
  void disconnect() {
    _webSocketService.disconnect();
  }
  
  void subscribeToSystemStatus() {
    _webSocketService.send({
      'action': 'subscribe',
      'topic': 'system_status',
    });
  }
  
  void unsubscribeFromSystemStatus() {
    _webSocketService.send({
      'action': 'unsubscribe',
      'topic': 'system_status',
    });
  }
}
```

### 12.3 实时数据UI更新
```dart
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final RealTimeDataService _realTimeDataService = RealTimeDataService();
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }
  
  Future<void> _connectToWebSocket() async {
    await _realTimeDataService.connect();
    _realTimeDataService.subscribeToSystemStatus();
    
    _subscription = _realTimeDataService.realTimeData.listen(
      (data) {
        final jsonData = jsonDecode(data);
        if (jsonData['topic'] == 'system_status') {
          _updateSystemStatus(jsonData['data']);
        }
      },
      onError: (error) {
        showErrorSnackBar(context, '实时数据更新失败: $error');
      },
    );
  }
  
  void _updateSystemStatus(Map<String, dynamic> data) {
    // 更新系统状态UI
    setState(() {
      // 更新状态数据
    });
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    _realTimeDataService.disconnect();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // 构建UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('仪表盘'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

## 13. 总结

本文档详细描述了1Panel V2 API与Flutter移动端APP之间的接口映射关系，包括认证机制、HTTP客户端封装、各个功能模块的API调用实现、错误处理、数据缓存和实时数据更新。通过遵循本文档的指导，开发人员可以快速构建一个功能完善、性能优异的1Panel移动端管理应用。

在实际开发过程中，还需要根据具体需求进行调整和优化，例如：
1. 根据实际API响应结构调整数据模型
2. 优化错误处理和用户提示
3. 实现更复杂的数据缓存策略
4. 添加更多的实时数据更新功能
5. 优化网络请求性能和用户体验

希望本文档能为1Panel移动端APP的开发提供有价值的参考。

## 14. 多服务器管理功能使用示例

### 14.1 添加新服务器

```dart
void addNewServer() async {
  try {
    final serverManager = ServerConnectionManager();
    final loginResponse = await serverManager.login(
      username: 'admin',
      password: 'your_password',
      serverUrl: '192.168.1.100:7080',
      serverName: '家用服务器',
      setAsDefault: true,
    );
    print('服务器添加成功，版本：${loginResponse.version}');
  } catch (e) {
    print('添加服务器失败：$e');
  }
}
```

### 14.2 切换当前服务器

```dart
void switchServer(String serverId) async {
  try {
    final serverManager = ServerConnectionManager();
    await serverManager.setCurrentServer(serverId);
    print('已切换到服务器：$serverId');
    // 这里通常需要刷新UI或重新加载数据
    reloadDashboardData();
  } catch (e) {
    print('切换服务器失败：$e');
  }
}

void reloadDashboardData() async {
  try {
    final serverManager = ServerConnectionManager();
    final currentServer = await serverManager.getCurrentServer();
    if (currentServer != null) {
      final dashboardService = DashboardService(
        serverId: currentServer.id,
        serverUrl: currentServer.url,
      );
      final overview = await dashboardService.getOverview();
      print('系统概览：${overview.system.hostname}，负载：${overview.cpu.usage}%');
      // 更新UI显示
    }
  } catch (e) {
    print('加载数据失败：$e');
  }
}
```

### 14.3 获取并显示所有已保存服务器

```dart
void showAllServers() async {
  try {
    final serverManager = ServerConnectionManager();
    final servers = await serverManager.getAllServers();
    
    for (var server in servers) {
      print('服务器名称：${server.name}');
      print('服务器URL：${server.url}');
      print('服务器版本：${server.version}');
      print('是否默认：${server.isDefault}');
      print('最后连接：${server.lastConnected}');
      print('---------------------------');
    }
  } catch (e) {
    print('获取服务器列表失败：$e');
  }
}
```

### 14.4 删除服务器

```dart
void removeServer(String serverId) async {
  try {
    final serverManager = ServerConnectionManager();
    await serverManager.deleteServer(serverId);
    print('服务器 $serverId 已删除');
    // 这里可能需要更新UI或切换到另一个可用服务器
  } catch (e) {
    print('删除服务器失败：$e');
  }
}
```

### 14.5 使用多服务器管理的实际应用场景

```dart
class ServerListPage extends StatefulWidget {
  @override
  _ServerListPageState createState() => _ServerListPageState();
}

class _ServerListPageState extends State<ServerListPage> {
  final ServerConnectionManager _serverManager = ServerConnectionManager();
  List<ServerConnection> _servers = [];
  ServerConnection? _currentServer;

  @override
  void initState() {
    super.initState();
    _loadServers();
  }

  Future<void> _loadServers() async {
    try {
      final servers = await _serverManager.getAllServers();
      final currentServer = await _serverManager.getCurrentServer();
      setState(() {
        _servers = servers;
        _currentServer = currentServer;
      });
    } catch (e) {
      showErrorSnackBar(context, '加载服务器列表失败: $e');
    }
  }

  Future<void> _handleSwitchServer(ServerConnection server) async {
    try {
      await _serverManager.setCurrentServer(server.id);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } catch (e) {
      showErrorSnackBar(context, '切换服务器失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('服务器列表'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => AddServerPage())
              ).then((_) => _loadServers());
            },
          ),
        ],
      ),
      body: _servers.isEmpty
          ? Center(child: Text('暂无服务器，请添加'))
          : ListView.builder(
              itemCount: _servers.length,
              itemBuilder: (context, index) {
                final server = _servers[index];
                return ListTile(
                  title: Text(server.name),
                  subtitle: Text(server.url),
                  trailing: server.id == _currentServer?.id
                      ? Chip(label: Text('当前'))
                      : null,
                  onTap: () => _handleSwitchServer(server),
                  onLongPress: () => _showServerOptions(server),
                );
              },
            ),
    );
  }

  void _showServerOptions(ServerConnection server) {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('编辑服务器'),
              onTap: () {
                Navigator.pop(context);
                // 实现编辑逻辑
              },
            ),
            ListTile(
              title: Text('删除服务器'),
              textColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _removeServer(server.id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeServer(String serverId) async {
    try {
      await _serverManager.deleteServer(serverId);
      _loadServers();
    } catch (e) {
      showErrorSnackBar(context, '删除服务器失败: $e');
    }
  }
}