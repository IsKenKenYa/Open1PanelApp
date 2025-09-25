import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ApiClient {
  final String baseUrl;
  final String apiKey;
  late Dio _dio;

  ApiClient({
    required this.baseUrl,
    required this.apiKey,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ));

    // 添加拦截器
    _dio.interceptors.add(AuthInterceptor(apiKey: apiKey));
    _dio.interceptors.add(LogInterceptor());
  }

  Dio get dio => _dio;

  /// 发送POST请求
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// 发送GET请求
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// 发送PUT请求
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// 发送DELETE请求
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

class AuthInterceptor extends Interceptor {
  final String apiKey;

  AuthInterceptor({required this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 生成当前时间戳（秒级）
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    // 生成Token: md5('1panel' + API-Key + UnixTimestamp)
    final token = _generateToken(apiKey, timestamp);
    
    // 添加请求头
    options.headers['1Panel-Token'] = token;
    options.headers['1Panel-Timestamp'] = timestamp.toString();
    
    handler.next(options);
  }

  String _generateToken(String apiKey, int timestamp) {
    final data = utf8.encode('1panel$apiKey$timestamp');
    final digest = md5.convert(data);
    return digest.toString();
  }
}

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