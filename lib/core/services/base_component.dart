import 'package:dio/dio.dart';
import '../network/api_client_manager.dart';

typedef PermissionResolver = Future<bool> Function(String permission);

class BaseComponent {
  BaseComponent({
    ApiClientManager? clientManager,
    PermissionResolver? permissionResolver,
    Duration? defaultCacheTtl,
  })  : _clientManager = clientManager ?? ApiClientManager.instance,
        _permissionResolver = permissionResolver,
        _defaultCacheTtl = defaultCacheTtl ?? const Duration(minutes: 5);

  final ApiClientManager _clientManager;
  final PermissionResolver? _permissionResolver;
  final Duration _defaultCacheTtl;
  final Map<String, _CacheEntry<dynamic>> _cache = {};

  bool _initialized = false;
  bool _disposed = false;

  ApiClientManager get clientManager => _clientManager;
  bool get isDisposed => _disposed;

  Future<void> init() async {
    if (_initialized || _disposed) {
      return;
    }
    _initialized = true;
    await onInit();
  }

  Future<void> onInit() async {}

  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _cache.clear();
    onDispose();
  }

  void onDispose() {}

  T? getCache<T>(String key, {Duration? ttl}) {
    final entry = _cache[key];
    if (entry == null) {
      return null;
    }
    final maxAge = ttl ?? _defaultCacheTtl;
    if (DateTime.now().difference(entry.timestamp) > maxAge) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T?;
  }

  void setCache<T>(String key, T value) {
    _cache[key] = _CacheEntry<T>(value);
  }

  void clearCache({String? key}) {
    if (key == null) {
      _cache.clear();
      return;
    }
    _cache.remove(key);
  }

  Future<void> ensurePermission(String permission) async {
    if (_permissionResolver == null) {
      return;
    }
    final allowed = await _permissionResolver!(permission);
    if (!allowed) {
      throw Exception('权限不足');
    }
  }

  Future<T> runGuarded<T>(
    Future<T> Function() action, {
    String? permission,
  }) async {
    if (_disposed) {
      throw StateError('组件已释放');
    }
    if (!_initialized) {
      await init();
    }
    if (permission != null) {
      await ensurePermission(permission);
    }
    try {
      return await action();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Exception _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('连接超时，请检查网络连接');
      case DioExceptionType.sendTimeout:
        return Exception('发送超时，请重试');
      case DioExceptionType.receiveTimeout:
        return Exception('接收超时，请重试');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return Exception('未授权，请重新登录');
        }
        if (statusCode == 403) {
          return Exception('权限不足');
        }
        if (statusCode == 404) {
          return Exception('资源不存在');
        }
        if (statusCode == 500) {
          return Exception('服务器内部错误');
        }
        return Exception('请求失败: ${error.response?.data}');
      case DioExceptionType.cancel:
        return Exception('请求已取消');
      case DioExceptionType.unknown:
        return Exception('网络错误，请检查网络连接');
      default:
        return Exception('未知错误');
    }
  }
}

class _CacheEntry<T> {
  _CacheEntry(this.value) : timestamp = DateTime.now();

  final T value;
  final DateTime timestamp;
}
