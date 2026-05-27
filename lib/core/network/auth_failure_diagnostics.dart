import 'package:dio/dio.dart';

import '../config/api_constants.dart';

class AuthFailureDiagnostics {
  const AuthFailureDiagnostics._();

  static String describe(DioException error) {
    final details = <String>[];
    final headers = error.requestOptions.headers;
    final token = headers[ApiConstants.authHeaderToken]?.toString();
    final timestamp = headers[ApiConstants.authHeaderTimestamp]?.toString();
    final responseData = error.response?.data;
    final contentType = error.response?.headers.value('content-type') ?? '';

    if (token == null || token.isEmpty) {
      details.add('未生成 ${ApiConstants.authHeaderToken}，请检查 API key 是否为空或重启后读取失败');
    }

    if (timestamp == null || timestamp.isEmpty) {
      details.add(
        '未生成 ${ApiConstants.authHeaderTimestamp}，请检查认证拦截器是否被跳过',
      );
    } else {
      final parsedTimestamp = int.tryParse(timestamp);
      if (parsedTimestamp == null) {
        details.add('${ApiConstants.authHeaderTimestamp} 不是有效秒级时间戳');
      } else {
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final skew = (now - parsedTimestamp).abs();
        if (skew > 300) {
          details.add('客户端与服务器时间可能偏差超过 5 分钟，请校准系统时间');
        }
      }
    }

    if (_looksLikeHtml(responseData, contentType)) {
      details.add('服务器返回 HTML 401，优先检查反向代理路径、API 网关或登录页重定向');
    }

    details.add('请确认 1Panel API 已启用、API key 未重置且 IP 白名单允许当前设备访问');

    return '认证失败(401): ${details.join('；')}';
  }

  static bool _looksLikeHtml(Object? responseData, String contentType) {
    if (contentType.toLowerCase().contains('text/html')) {
      return true;
    }
    if (responseData is! String) {
      return false;
    }
    final trimmed = responseData.trimLeft().toLowerCase();
    return trimmed.startsWith('<!doctype html') || trimmed.startsWith('<html');
  }
}
