import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/openresty_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/data/models/openresty_models.dart';

import 'compose_api_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late OpenRestyV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = OpenRestyV2Api(mockClient);
  });

  RequestOptions _opts(String path) => RequestOptions(path: path);

  Response<Map<String, dynamic>> _successResponse(
    Map<String, dynamic> data, {
    String path = '/test',
  }) {
    return Response(
      data: data,
      statusCode: 200,
      requestOptions: _opts(path),
    );
  }

  group('OpenRestyV2Api - Nginx', () {
    group('getOpenRestyStatus', () {
      test('returns OpenrestyStatus from response', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'active': 5,
                'accepts': 1000,
                'handled': 999,
                'requests': 5000,
                'reading': 1,
                'writing': 2,
                'waiting': 3,
              },
            }, path: '/openresty/status'));

        final response = await api.getOpenRestyStatus();
        expect(response.data, isA<OpenrestyStatus>());
        expect(response.data!.active, 5);
        expect(response.data!.accepts, 1000);
        expect(response.data!.handled, 999);
        expect(response.data!.requests, 5000);
        expect(response.data!.reading, 1);
        expect(response.data!.writing, 2);
        expect(response.data!.waiting, 3);
      });

      test('handles null optional fields', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': {},
            }, path: '/openresty/status'));

        final response = await api.getOpenRestyStatus();
        expect(response.data, isA<OpenrestyStatus>());
        expect(response.data!.active, isNull);
      });
    });

    group('getOpenRestyConfig', () {
      test('returns OpenrestyFile from response', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'content': 'worker_processes auto;\nevents {}',
              },
            }, path: '/openresty'));

        final response = await api.getOpenRestyConfig();
        expect(response.data, isA<OpenrestyFile>());
        expect(response.data!.content, 'worker_processes auto;\nevents {}');
      });
    });

    group('buildOpenResty', () {
      test('sends build request successfully', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/openresty/build'),
            ));

        final request = OpenrestyBuildRequest(
          mirror: 'https://mirror.example.com',
          taskId: 'build-task-001',
        );
        final response = await api.buildOpenResty(request);
        expect(response.statusCode, 200);
      });
    });

    group('updateOpenRestyConfigByFile', () {
      test('sends file update request successfully', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/openresty/file'),
            ));

        final request = OpenrestyConfigFileUpdateRequest(
          content: 'worker_processes 4;',
        );
        final response = await api.updateOpenRestyConfigByFile(request);
        expect(response.statusCode, 200);
      });
    });

    group('getOpenRestyHttps', () {
      test('returns OpenrestyHttpsConfig from response', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'https': true,
                'sslRejectHandshake': false,
              },
            }, path: '/openresty/https'));

        final response = await api.getOpenRestyHttps();
        expect(response.data, isA<OpenrestyHttpsConfig>());
        expect(response.data!.https, true);
        expect(response.data!.sslRejectHandshake, false);
      });
    });

    group('updateOpenRestyHttps', () {
      test('sends HTTPS update request successfully', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/openresty/https'),
            ));

        final request = OpenrestyDefaultHttpsUpdateRequest(
          operate: OpenrestyDefaultHttpsOperate.enable,
          sslRejectHandshake: true,
        );
        final response = await api.updateOpenRestyHttps(request);
        expect(response.statusCode, 200);
      });
    });

    group('getOpenRestyModules', () {
      test('returns OpenrestyBuildConfig from response', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'modules': ['http_ssl', 'http_gzip'],
                'configureArgs': '--with-http_ssl_module',
              },
            }, path: '/openresty/modules'));

        final response = await api.getOpenRestyModules();
        expect(response.data, isA<OpenrestyBuildConfig>());
      });
    });

    group('updateOpenRestyModules', () {
      test('sends module update request successfully', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/openresty/modules/update'),
            ));

        final request = OpenrestyModuleUpdateRequest(
          name: 'http_ssl',
          operate: OpenrestyModuleOperate.update,
          enable: true,
        );
        final response = await api.updateOpenRestyModules(request);
        expect(response.statusCode, 200);
      });
    });

    group('getOpenRestyScope', () {
      test('returns list of OpenrestyParam from response', () async {
        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': [
                {'name': 'worker_processes', 'params': ['auto']},
                {'name': 'worker_connections', 'params': ['1024']},
              ],
            }, path: '/openresty/scope'));

        final request = OpenrestyScopeRequest(
          scope: NginxKey.indexKey,
        );
        final response = await api.getOpenRestyScope(request);
        expect(response.data, isA<List<OpenrestyParam>>());
        expect(response.data!.length, 2);
        expect(response.data!.first.name, 'worker_processes');
        expect(response.data!.first.params, ['auto']);
      });

      test('handles empty scope results', () async {
        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': [],
            }, path: '/openresty/scope'));

        final request = OpenrestyScopeRequest(
          scope: NginxKey.indexKey,
        );
        final response = await api.getOpenRestyScope(request);
        expect(response.data, isEmpty);
      });
    });

    group('updateOpenResty', () {
      test('sends config update request successfully', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/openresty/update'),
            ));

        final request = OpenrestyConfigUpdateRequest(
          operate: OpenrestyConfigOperate.update,
          params: [
            OpenrestyParam(name: 'worker_processes', params: ['4']),
          ],
        );
        final response = await api.updateOpenResty(request);
        expect(response.statusCode, 200);
      });
    });
  });
}
