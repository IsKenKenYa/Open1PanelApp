import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/runtime_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/runtime_models.dart';

import 'compose_api_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late RuntimeV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = RuntimeV2Api(mockClient);
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

  group('RuntimeV2Api - PHP Extensions', () {
    group('getPhpExtensions', () {
      test('returns PHPExtensionsRes from response', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'extensions': ['curl', 'json', 'mbstring'],
                'supportExtensions': [
                  {
                    'name': 'redis',
                    'description': 'Redis client',
                    'installed': false,
                    'versions': ['5.3', '6.0'],
                  },
                  {
                    'name': 'swoole',
                    'description': 'Coroutine framework',
                    'installed': true,
                    'check': 'php -m | grep swoole',
                  },
                ],
              },
            }, path: '/runtimes/php/1/extensions'));

        final response = await api.getPhpExtensions(1);
        expect(response.data, isA<PHPExtensionsRes>());
        expect(response.data!.extensions, ['curl', 'json', 'mbstring']);
        expect(response.data!.supportExtensions.length, 2);
        expect(response.data!.supportExtensions.first.name, 'redis');
        expect(response.data!.supportExtensions.first.installed, false);
        expect(response.data!.supportExtensions.last.name, 'swoole');
        expect(response.data!.supportExtensions.last.installed, true);
      });

      test('handles empty extensions response', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': <String, dynamic>{},
            }, path: '/runtimes/php/1/extensions'));

        final response = await api.getPhpExtensions(1);
        expect(response.data, isA<PHPExtensionsRes>());
        expect(response.data!.extensions, isEmpty);
        expect(response.data!.supportExtensions, isEmpty);
      });
    });

    group('searchPhpExtensionRecords', () {
      test('returns PageResult of PHPExtensionRecord', () async {
        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'items': [
                  {'id': 1, 'name': 'My Extensions', 'extensions': 'redis,swoole'},
                  {'id': 2, 'name': 'Default', 'extensions': 'curl,json'},
                ],
                'total': 2,
                'page': 1,
                'pageSize': 20,
              },
            }, path: '/runtimes/php/extensions/search'));

        final request = PHPExtensionRecordSearch(page: 1, pageSize: 20);
        final response = await api.searchPhpExtensionRecords(request);
        expect(response.data, isA<PageResult<PHPExtensionRecord>>());
        expect(response.data!.items.length, 2);
        expect(response.data!.items.first.name, 'My Extensions');
        expect(response.data!.items.first.extensions, 'redis,swoole');
        expect(response.data!.total, 2);
      });

      test('handles empty search results', () async {
        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'items': [],
                'total': 0,
              },
            }, path: '/runtimes/php/extensions/search'));

        final request = PHPExtensionRecordSearch(page: 1, pageSize: 20);
        final response = await api.searchPhpExtensionRecords(request);
        expect(response.data!.items, isEmpty);
      });
    });

    group('createPhpExtensionRecord', () {
      test('sends create request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/runtimes/php/extensions'),
            ));

        final request = PHPExtensionRecordCreate(
          name: 'My Extensions',
          extensions: 'redis,swoole',
        );
        final response = await api.createPhpExtensionRecord(request);
        expect(response.statusCode, 200);
      });
    });

    group('updatePhpExtensionRecord', () {
      test('sends update request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/runtimes/php/extensions/update'),
            ));

        final request = PHPExtensionRecordUpdate(
          id: 1,
          extensions: 'redis,swoole,imagick',
        );
        final response = await api.updatePhpExtensionRecord(request);
        expect(response.statusCode, 200);
      });
    });

    group('deletePhpExtensionRecord', () {
      test('sends delete request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/runtimes/php/extensions/del'),
            ));

        final request = PHPExtensionRecordDelete(id: 1);
        final response = await api.deletePhpExtensionRecord(request);
        expect(response.statusCode, 200);
      });
    });

    group('installPhpExtension', () {
      test('sends install request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/runtimes/php/extensions/install'),
            ));

        final request = PHPExtensionInstallRequest(
          id: 1,
          name: 'redis',
          taskId: 'install-task-001',
        );
        final response = await api.installPhpExtension(request);
        expect(response.statusCode, 200);
      });
    });

    group('uninstallPhpExtension', () {
      test('sends uninstall request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/runtimes/php/extensions/uninstall'),
            ));

        final request = PHPExtensionInstallRequest(
          id: 1,
          name: 'redis',
        );
        final response = await api.uninstallPhpExtension(request);
        expect(response.statusCode, 200);
      });
    });
  });
}
