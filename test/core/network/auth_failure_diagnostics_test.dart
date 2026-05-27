import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/config/api_constants.dart';
import 'package:onepanel_client/core/network/auth_failure_diagnostics.dart';

void main() {
  group('AuthFailureDiagnostics', () {
    test('explains empty key or skipped auth headers', () {
      final message = AuthFailureDiagnostics.describe(
        DioException(
          requestOptions: RequestOptions(path: '/api/v2/settings/search'),
          response: Response<void>(
            requestOptions: RequestOptions(path: '/api/v2/settings/search'),
            statusCode: 401,
          ),
        ),
      );

      expect(message, contains(ApiConstants.authHeaderToken));
      expect(message, contains(ApiConstants.authHeaderTimestamp));
      expect(message, contains('API key'));
    });

    test('explains HTML 401 from reverse proxy or gateway', () {
      final request = RequestOptions(
        path: '/api/v2/files/search',
        headers: <String, Object?>{
          ApiConstants.authHeaderToken: 'a' * 32,
          ApiConstants.authHeaderTimestamp:
              '${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
        },
      );
      final message = AuthFailureDiagnostics.describe(
        DioException(
          requestOptions: request,
          response: Response<String>(
            requestOptions: request,
            statusCode: 401,
            data: '<html><body>unauthorized</body></html>',
            headers: Headers.fromMap(<String, List<String>>{
              'content-type': <String>['text/html'],
            }),
          ),
        ),
      );

      expect(message, contains('HTML 401'));
      expect(message, contains('反向代理'));
    });

    test('explains stale timestamp', () {
      final request = RequestOptions(
        path: '/api/v2/files/download',
        headers: <String, Object?>{
          ApiConstants.authHeaderToken: 'a' * 32,
          ApiConstants.authHeaderTimestamp: '1704067200',
        },
      );
      final message = AuthFailureDiagnostics.describe(
        DioException(
          requestOptions: request,
          response: Response<void>(
            requestOptions: request,
            statusCode: 401,
          ),
        ),
      );

      expect(message, contains('时间'));
      expect(message, contains('5 分钟'));
    });
  });
}
