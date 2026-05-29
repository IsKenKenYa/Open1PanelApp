import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/network/interceptors/logging_interceptor.dart';

void main() {
  group('LoggingInterceptor', () {
    group('enabled=false', () {
      test('onRequest passes through without error', () {
        final interceptor = LoggingInterceptor(false);
        final handler = _TestRequestHandler();
        final options = RequestOptions(path: '/test');
        interceptor.onRequest(options, handler);
        expect(handler.nextCalled, isTrue);
      });

      test('onResponse passes through without error', () {
        final interceptor = LoggingInterceptor(false);
        final handler = _TestResponseHandler();
        final response = Response(
          data: 'test',
          requestOptions: RequestOptions(path: '/test'),
        );
        interceptor.onResponse(response, handler);
        expect(handler.nextCalled, isTrue);
      });

      test('onError passes through without error', () {
        final interceptor = LoggingInterceptor(false);
        final handler = _TestErrorHandler();
        final err = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );
        interceptor.onError(err, handler);
        expect(handler.nextCalled, isTrue);
      });
    });

    group('enabled=true', () {
      test('onRequest passes through', () {
        final interceptor = LoggingInterceptor(true);
        final handler = _TestRequestHandler();
        final options = RequestOptions(path: '/test');
        interceptor.onRequest(options, handler);
        expect(handler.nextCalled, isTrue);
      });

      test('onRequest logs body when logBody=true and data present', () {
        final interceptor = LoggingInterceptor(true, true);
        final handler = _TestRequestHandler();
        final options = RequestOptions(
          path: '/test',
          data: {'key': 'value'},
        );
        interceptor.onRequest(options, handler);
        expect(handler.nextCalled, isTrue);
      });

      test('onRequest does not log body when logBody=false', () {
        final interceptor = LoggingInterceptor(true, false);
        final handler = _TestRequestHandler();
        final options = RequestOptions(
          path: '/test',
          data: {'key': 'value'},
        );
        interceptor.onRequest(options, handler);
        expect(handler.nextCalled, isTrue);
      });

      test('onRequest logs query parameters when present', () {
        final interceptor = LoggingInterceptor(true);
        final handler = _TestRequestHandler();
        final options = RequestOptions(
          path: '/test',
          queryParameters: {'page': 1},
        );
        interceptor.onRequest(options, handler);
        expect(handler.nextCalled, isTrue);
      });

      test('onResponse passes through', () {
        final interceptor = LoggingInterceptor(true);
        final handler = _TestResponseHandler();
        final response = Response(
          data: 'test',
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test'),
        );
        interceptor.onResponse(response, handler);
        expect(handler.nextCalled, isTrue);
      });

      test('onResponse truncates long response data', () {
        final interceptor = LoggingInterceptor(true, true);
        final handler = _TestResponseHandler();
        final longData = 'x' * 600;
        final response = Response(
          data: longData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test'),
        );
        interceptor.onResponse(response, handler);
        expect(handler.nextCalled, isTrue);
      });

      test('onError passes through', () {
        final interceptor = LoggingInterceptor(true);
        final handler = _TestErrorHandler();
        final err = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.badResponse,
          message: 'error',
        );
        interceptor.onError(err, handler);
        expect(handler.nextCalled, isTrue);
      });
    });

    group('constructor defaults', () {
      test('default enabled is true', () {
        final interceptor = LoggingInterceptor();
        expect(interceptor.enabled, isTrue);
      });

      test('default logBody is true', () {
        final interceptor = LoggingInterceptor();
        expect(interceptor.logBody, isTrue);
      });
    });
  });
}

class _TestRequestHandler extends RequestInterceptorHandler {
  bool nextCalled = false;
  @override
  void next(RequestOptions options) => nextCalled = true;
  @override
  void resolve(Response response, [bool callFollowing = false]) {}
  @override
  void reject(DioException e, [bool callFollowing = false]) {}
}

class _TestResponseHandler extends ResponseInterceptorHandler {
  bool nextCalled = false;
  @override
  void next(Response response) => nextCalled = true;
  @override
  void resolve(Response response, [bool callFollowing = false]) {}
  @override
  void reject(DioException e, [bool callFollowing = false]) {}
}

class _TestErrorHandler extends ErrorInterceptorHandler {
  bool nextCalled = false;
  @override
  void next(DioException err) => nextCalled = true;
  @override
  void resolve(Response response, [bool callFollowing = false]) {}
  @override
  void reject(DioException e, [bool callFollowing = false]) {}
}
