import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/network/interceptors/business_response_interceptor.dart';

void main() {
  late BusinessResponseInterceptor interceptor;

  setUp(() {
    interceptor = BusinessResponseInterceptor();
  });

  Response _makeResponse(dynamic data, {int statusCode = 200}) {
    return Response(
      data: data,
      statusCode: statusCode,
      requestOptions: RequestOptions(path: '/test'),
    );
  }

  group('BusinessResponseInterceptor', () {
    test('passes through when response data is not a map', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(_makeResponse('raw string'), handler);
      expect(handler.nextCalled, isTrue);
      expect(handler.rejected, isFalse);
    });

    test('passes through when response data is a list', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(_makeResponse([1, 2, 3]), handler);
      expect(handler.nextCalled, isTrue);
      expect(handler.rejected, isFalse);
    });

    test('passes through when code is 200', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(
        _makeResponse({'code': 200, 'data': 'ok'}),
        handler,
      );
      expect(handler.nextCalled, isTrue);
      expect(handler.rejected, isFalse);
    });

    test('passes through when code is null', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(
        _makeResponse({'data': 'no code field'}),
        handler,
      );
      expect(handler.nextCalled, isTrue);
      expect(handler.rejected, isFalse);
    });

    test('rejects when code is not 200', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(
        _makeResponse({'code': 400, 'message': 'Bad request'}),
        handler,
      );
      expect(handler.rejected, isTrue);
      expect(handler.rejectException, isNotNull);
      expect(handler.rejectException!.type, DioExceptionType.badResponse);
      expect(handler.rejectException!.message, 'Bad request');
    });

    test('rejects with default message when message is missing', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(
        _makeResponse({'code': 500}),
        handler,
      );
      expect(handler.rejected, isTrue);
      expect(handler.rejectException!.message, '未知错误');
    });

    test('rejects with error code 500', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(
        _makeResponse({'code': 500, 'message': 'Internal error'}),
        handler,
      );
      expect(handler.rejected, isTrue);
      expect(handler.rejectException!.message, 'Internal error');
    });

    test('rejects with error code 10001 (custom business code)', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(
        _makeResponse({'code': 10001, 'message': 'Custom error'}),
        handler,
      );
      expect(handler.rejected, isTrue);
      expect(handler.rejectException!.message, 'Custom error');
    });

    test('passes through when response data is null', () {
      final handler = _TestResponseInterceptorHandler();
      interceptor.onResponse(_makeResponse(null), handler);
      expect(handler.nextCalled, isTrue);
      expect(handler.rejected, isFalse);
    });
  });
}

/// 测试用 ResponseInterceptorHandler
class _TestResponseInterceptorHandler extends ResponseInterceptorHandler {
  bool nextCalled = false;
  bool rejected = false;
  DioException? rejectException;

  @override
  void next(Response response) {
    nextCalled = true;
  }

  @override
  void reject(DioException e, [bool callFollowingErrorInterceptor = false]) {
    rejected = true;
    rejectException = e;
  }

  @override
  void resolve(Response response, [bool callFollowingResponseInterceptor = false]) {
    // Not used in this interceptor
  }
}
