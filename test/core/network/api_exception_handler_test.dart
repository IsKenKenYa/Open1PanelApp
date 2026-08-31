import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/network/api_exception_handler.dart';
import 'package:onepanel_client/core/network/network_exceptions.dart';

void main() {
  group('ApiExceptionHandler.safeApiCall', () {
    test('returns result on success', () async {
      final result = await ApiExceptionHandler.safeApiCall(
        () async => 'success',
        fallback: 'default',
      );
      expect(result, 'success');
    });

    test('returns fallback on StateError with API config message', () async {
      final result = await ApiExceptionHandler.safeApiCall(
        () async => throw StateError('No API config available'),
        fallback: 'default',
      );
      expect(result, 'default');
    });

    test('returns fallback on NetworkConnectionException', () async {
      final result = await ApiExceptionHandler.safeApiCall(
        () async => throw const NetworkConnectionException('no internet'),
        fallback: 42,
      );
      expect(result, 42);
    });

    test('returns fallback on HttpException', () async {
      final result = await ApiExceptionHandler.safeApiCall(
        () async => throw const HttpException('bad request', statusCode: 400),
        fallback: <String, dynamic>{},
      );
      expect(result, <String, dynamic>{});
    });

    test('returns fallback on AuthException', () async {
      final result = await ApiExceptionHandler.safeApiCall(
        () async => throw const AuthException('unauthorized', statusCode: 401),
        fallback: null,
      );
      expect(result, isNull);
    });

    test('returns fallback on ServerException', () async {
      final result = await ApiExceptionHandler.safeApiCall(
        () async => throw const ServerException('crash', statusCode: 500),
        fallback: -1,
      );
      expect(result, -1);
    });

    test('returns fallback on DioException', () async {
      final result = await ApiExceptionHandler.safeApiCall(
        () async => throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          message: 'timeout',
        ),
        fallback: 'recovered',
      );
      expect(result, 'recovered');
    });

    test('returns fallback on generic exception', () async {
      final result = await ApiExceptionHandler.safeApiCall(
        () async => throw Exception('unexpected'),
        fallback: 'safe',
      );
      expect(result, 'safe');
    });

    test('uses custom logContext', () async {
      // Just verify it doesn't crash with custom context
      final result = await ApiExceptionHandler.safeApiCall(
        () async => throw const NetworkConnectionException('fail'),
        fallback: 'ok',
        logContext: 'custom.module',
      );
      expect(result, 'ok');
    });

    test('returns fallback of correct generic type', () async {
      final result = await ApiExceptionHandler.safeApiCall<List<int>>(
        () async => throw Exception('fail'),
        fallback: [1, 2, 3],
      );
      expect(result, [1, 2, 3]);
    });
  });

  group('ApiExceptionHandler.safeApiCallOrThrow', () {
    test('returns result on success', () async {
      final result = await ApiExceptionHandler.safeApiCallOrThrow(
        () async => 'success',
      );
      expect(result, 'success');
    });

    test('converts StateError to NetworkConnectionException', () async {
      expect(
        () => ApiExceptionHandler.safeApiCallOrThrow(
          () async => throw StateError('No API config available'),
        ),
        throwsA(isA<NetworkException>().having(
          (e) => e.message,
          'message',
          'No server connection configured',
        )),
      );
    });

    test('rethrows NetworkConnectionException', () async {
      expect(
        () => ApiExceptionHandler.safeApiCallOrThrow(
          () async => throw const NetworkConnectionException('no internet'),
        ),
        throwsA(isA<NetworkConnectionException>()),
      );
    });

    test('rethrows HttpException', () async {
      expect(
        () => ApiExceptionHandler.safeApiCallOrThrow(
          () async => throw const HttpException('bad', statusCode: 400),
        ),
        throwsA(isA<HttpException>()),
      );
    });

    test('rethrows AuthException', () async {
      expect(
        () => ApiExceptionHandler.safeApiCallOrThrow(
          () async => throw const AuthException('expired', statusCode: 401),
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('rethrows ServerException', () async {
      expect(
        () => ApiExceptionHandler.safeApiCallOrThrow(
          () async => throw const ServerException('crash', statusCode: 500),
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('rethrows generic exceptions', () async {
      expect(
        () => ApiExceptionHandler.safeApiCallOrThrow(
          () async => throw Exception('unexpected'),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('rethrows DioException', () async {
      try {
        await ApiExceptionHandler.safeApiCallOrThrow(
          () async => throw DioException(
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        fail('Expected DioException to be thrown');
      } on DioException catch (_) {
        // Expected
      }
    });

    test('uses custom logContext', () async {
      final result = await ApiExceptionHandler.safeApiCallOrThrow(
        () async => 'ok',
        logContext: 'custom.module',
      );
      expect(result, 'ok');
    });
  });
}
