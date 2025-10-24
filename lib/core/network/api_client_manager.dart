/// API客户端管理器
/// 用于管理多个服务器配置的API客户端实例
class ApiClientManager {
  static final ApiClientManager _instance = ApiClientManager._internal();
  final Map<String, ApiClient> _clients = {};

  factory ApiClientManager() {
    return _instance;
  }

  ApiClientManager._internal();

  /// 获取指定服务器的API客户端
  ApiClient getClient(String serverId, String serverUrl, String apiKey) {
    if (!_clients.containsKey(serverId)) {
      _clients[serverId] = ApiClient(
        baseUrl: serverUrl,
        apiKey: apiKey,
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