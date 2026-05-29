import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/network/network_exceptions.dart';

void main() {
  group('NetworkConnectionException', () {
    test('extends NetworkException and Exception', () {
      const e = NetworkConnectionException('no internet');
      expect(e, isA<NetworkException>());
      expect(e, isA<Exception>());
    });

    test('stores message', () {
      const e = NetworkConnectionException('timeout');
      expect(e.message, 'timeout');
    });

    test('toString returns formatted message', () {
      const e = NetworkConnectionException('connection failed');
      expect(e.toString(), 'NetworkException: connection failed');
    });

    test('accepts requestOptions', () {
      final options = RequestOptions(path: '/api');
      final e = NetworkConnectionException('fail', requestOptions: options);
      expect(e.requestOptions, options);
    });

    test('requestOptions defaults to null', () {
      const e = NetworkConnectionException('fail');
      expect(e.requestOptions, isNull);
    });

    test('statusCode is always null (no statusCode param)', () {
      const e = NetworkConnectionException('fail');
      expect(e.statusCode, isNull);
    });
  });

  group('HttpException', () {
    test('extends NetworkException', () {
      const e = HttpException('bad request');
      expect(e, isA<NetworkException>());
    });

    test('stores message and statusCode', () {
      const e = HttpException('not found', statusCode: 404);
      expect(e.message, 'not found');
      expect(e.statusCode, 404);
    });

    test('statusCode defaults to null', () {
      const e = HttpException('error');
      expect(e.statusCode, isNull);
    });

    test('accepts requestOptions', () {
      final options = RequestOptions(path: '/test');
      final e = HttpException('err', requestOptions: options);
      expect(e.requestOptions, options);
    });

    test('requestOptions defaults to null', () {
      const e = HttpException('err');
      expect(e.requestOptions, isNull);
    });
  });

  group('AuthException', () {
    test('extends NetworkException', () {
      const e = AuthException('unauthorized');
      expect(e, isA<NetworkException>());
    });

    test('stores message and statusCode', () {
      const e = AuthException('token expired', statusCode: 401);
      expect(e.message, 'token expired');
      expect(e.statusCode, 401);
    });

    test('statusCode defaults to null', () {
      const e = AuthException('auth fail');
      expect(e.statusCode, isNull);
    });

    test('accepts requestOptions', () {
      final options = RequestOptions(path: '/test');
      final e = AuthException('err', requestOptions: options);
      expect(e.requestOptions, options);
    });
  });

  group('ServerException', () {
    test('extends NetworkException', () {
      const e = ServerException('internal error');
      expect(e, isA<NetworkException>());
    });

    test('stores message and statusCode', () {
      const e = ServerException('crash', statusCode: 500);
      expect(e.message, 'crash');
      expect(e.statusCode, 500);
    });

    test('statusCode defaults to null', () {
      const e = ServerException('error');
      expect(e.statusCode, isNull);
    });

    test('accepts requestOptions', () {
      final options = RequestOptions(path: '/test');
      final e = ServerException('err', requestOptions: options);
      expect(e.requestOptions, options);
    });
  });

  group('Exception type hierarchy', () {
    test('NetworkConnectionException is NetworkException', () {
      expect(const NetworkConnectionException('x'), isA<NetworkException>());
    });

    test('HttpException is NetworkException', () {
      expect(const HttpException('x'), isA<NetworkException>());
    });

    test('AuthException is NetworkException', () {
      expect(const AuthException('x'), isA<NetworkException>());
    });

    test('ServerException is NetworkException', () {
      expect(const ServerException('x'), isA<NetworkException>());
    });

    test('subclasses are distinct types', () {
      expect(const NetworkConnectionException('x'), isNot(isA<HttpException>()));
      expect(const HttpException('x'), isNot(isA<AuthException>()));
      expect(const AuthException('x'), isNot(isA<ServerException>()));
      expect(const ServerException('x'), isNot(isA<NetworkConnectionException>()));
    });

    test('all can be caught as NetworkException', () {
      for (final e in [
        const NetworkConnectionException('a'),
        const HttpException('b'),
        const AuthException('c'),
        const ServerException('d'),
      ]) {
        expect(() => throw e, throwsA(isA<NetworkException>()));
      }
    });
  });
}
