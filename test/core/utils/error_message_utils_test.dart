import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/network/network_exceptions.dart';
import 'package:onepanel_client/core/utils/error_message_utils.dart';

void main() {
  group('ErrorMessageUtils', () {
    test('normalize strips Exception prefix', () {
      expect(
        ErrorMessageUtils.normalize(Exception('请求失败')),
        '请求失败',
      );
    });

    test('normalize uses NetworkException message', () {
      const error = HttpException('服务内部错误', statusCode: 500);
      expect(ErrorMessageUtils.normalize(error), '服务内部错误');
    });

    test('truncateForToast shortens long messages', () {
      final long = 'a' * 150;
      final truncated = ErrorMessageUtils.truncateForToast(long, maxLength: 120);
      expect(truncated.length, 120);
      expect(truncated.endsWith('…'), isTrue);
    });

    test('truncateForToast keeps short messages unchanged', () {
      expect(ErrorMessageUtils.truncateForToast('short'), 'short');
    });

    test('userFacingMessage combines normalize and truncate', () {
      final message = ErrorMessageUtils.userFacingMessage(
        NetworkConnectionException('连接超时'),
        maxLength: 50,
      );
      expect(message, '连接超时');
    });

    group('DioException handling', () {
      RequestOptions requestOptions() => RequestOptions(path: '/test');

      test('connectionTimeout returns timeout message', () {
        final error = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: requestOptions(),
        );
        expect(ErrorMessageUtils.normalize(error), 'Connection timed out');
      });

      test('connectionError returns connection failed message', () {
        final error = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: requestOptions(),
        );
        expect(ErrorMessageUtils.normalize(error), 'Network connection failed');
      });

      test('badResponse 401 returns Unauthorized', () {
        final error = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions(),
          response: Response(
            requestOptions: requestOptions(),
            statusCode: 401,
          ),
        );
        expect(ErrorMessageUtils.normalize(error), 'Unauthorized');
      });

      test('badResponse 500 returns Server error', () {
        final error = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions(),
          response: Response(
            requestOptions: requestOptions(),
            statusCode: 500,
          ),
        );
        expect(ErrorMessageUtils.normalize(error), 'Server error (500)');
      });

      test('badResponse with server message uses it', () {
        final error = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions(),
          response: Response(
            requestOptions: requestOptions(),
            statusCode: 400,
            data: {'message': 'Invalid parameter'},
          ),
        );
        expect(ErrorMessageUtils.normalize(error), 'Invalid parameter');
      });

      test('cancel returns cancelled message', () {
        final error = DioException(
          type: DioExceptionType.cancel,
          requestOptions: requestOptions(),
        );
        expect(ErrorMessageUtils.normalize(error), 'Request cancelled');
      });
    });
  });
}
