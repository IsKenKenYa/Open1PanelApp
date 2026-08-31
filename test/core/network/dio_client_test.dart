import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/config/api_constants.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/core/network/network_exceptions.dart';

void main() {
  group('DioClient', () {
    group('constructor', () {
      test('creates with default baseUrl', () {
        final client = DioClient();
        expect(client.dio.options.baseUrl, ApiConstants.defaultBaseUrl);
      });

      test('creates with custom baseUrl', () {
        final client = DioClient(baseUrl: 'https://custom.host:8080');
        expect(client.dio.options.baseUrl, 'https://custom.host:8080');
      });

      test('sets connect timeout', () {
        final client = DioClient();
        expect(client.dio.options.connectTimeout,
            Duration(seconds: ApiConstants.connectTimeout));
      });

      test('sets receive timeout', () {
        final client = DioClient();
        expect(client.dio.options.receiveTimeout,
            Duration(seconds: ApiConstants.receiveTimeout));
      });

      test('sets send timeout', () {
        final client = DioClient();
        expect(client.dio.options.sendTimeout,
            Duration(seconds: ApiConstants.sendTimeout));
      });

      test('sets response type to json', () {
        final client = DioClient();
        expect(client.dio.options.responseType, ResponseType.json);
      });

      test('sets default headers', () {
        final client = DioClient();
        expect(client.dio.options.headers['Content-Type'], 'application/json');
        expect(client.dio.options.headers['Accept'], 'application/json');
        expect(client.dio.options.headers['User-Agent'], ApiConstants.userAgent);
      });

      test('adds 4 business interceptors plus dio built-in (total 5)', () {
        final client = DioClient();
        // dio >= 5.9 内置 ImplyContentTypeInterceptor，
        // 加上 DioClient 显式添加的 Auth/BusinessResponse/Logging/Retry 共 5 个。
        expect(client.dio.interceptors.length, 5);
        expect(
          client.dio.interceptors.any((i) => i.runtimeType.toString() == 'AuthInterceptor'),
          isTrue,
        );
        expect(
          client.dio.interceptors.any((i) => i.runtimeType.toString() == 'BusinessResponseInterceptor'),
          isTrue,
        );
        expect(
          client.dio.interceptors.any((i) => i.runtimeType.toString() == 'LoggingInterceptor'),
          isTrue,
        );
        expect(
          client.dio.interceptors.any((i) => i.runtimeType.toString() == 'RetryInterceptor'),
          isTrue,
        );
      });

      test('exposes dio instance', () {
        final client = DioClient();
        expect(client.dio, isA<Dio>());
      });
    });

    group('updateAuth', () {
      test('does not throw', () {
        final client = DioClient();
        expect(() => client.updateAuth('new-key'), returnsNormally);
      });

      test('can be called with null', () {
        final client = DioClient();
        expect(() => client.updateAuth(null), returnsNormally);
      });

      test('can be called with empty string', () {
        final client = DioClient();
        expect(() => client.updateAuth(''), returnsNormally);
      });
    });

    group('validateStatus', () {
      test('accepts 200', () {
        final client = DioClient();
        expect(client.dio.options.validateStatus!(200), isTrue);
      });

      test('accepts 201', () {
        final client = DioClient();
        expect(client.dio.options.validateStatus!(201), isTrue);
      });

      test('accepts 299', () {
        final client = DioClient();
        expect(client.dio.options.validateStatus!(299), isTrue);
      });

      test('rejects 300', () {
        final client = DioClient();
        expect(client.dio.options.validateStatus!(300), isFalse);
      });

      test('rejects 400', () {
        final client = DioClient();
        expect(client.dio.options.validateStatus!(400), isFalse);
      });

      test('rejects 500', () {
        final client = DioClient();
        expect(client.dio.options.validateStatus!(500), isFalse);
      });

      test('rejects null', () {
        final client = DioClient();
        expect(client.dio.options.validateStatus!(null), isFalse);
      });
    });

    group('HTTP methods exist', () {
      test('get method is callable', () {
        final client = DioClient();
        expect(client.get, isA<Function>());
      });

      test('post method is callable', () {
        final client = DioClient();
        expect(client.post, isA<Function>());
      });

      test('put method is callable', () {
        final client = DioClient();
        expect(client.put, isA<Function>());
      });

      test('delete method is callable', () {
        final client = DioClient();
        expect(client.delete, isA<Function>());
      });

      test('patch method is callable', () {
        final client = DioClient();
        expect(client.patch, isA<Function>());
      });

      test('upload method is callable', () {
        final client = DioClient();
        expect(client.upload, isA<Function>());
      });

      test('download method is callable', () {
        final client = DioClient();
        expect(client.download, isA<Function>());
      });
    });

    group('exception conversion', () {
      test('get throws NetworkConnectionException on connection error', () async {
        final client = DioClient(baseUrl: 'http://localhost:1');
        expect(
          () => client.get('/test'),
          throwsA(isA<NetworkConnectionException>()),
        );
      }, timeout: Timeout(Duration(seconds: 10)));

      test('post throws NetworkConnectionException on connection error', () async {
        final client = DioClient(baseUrl: 'http://localhost:1');
        expect(
          () => client.post('/test'),
          throwsA(isA<NetworkConnectionException>()),
        );
      }, timeout: Timeout(Duration(seconds: 10)));
    });
  });
}
