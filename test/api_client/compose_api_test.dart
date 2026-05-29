import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/compose_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/container_models.dart';
import 'package:onepanel_client/data/models/docker_models.dart';

import 'compose_api_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late ComposeV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = ComposeV2Api(mockClient);
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

  group('ComposeV2Api', () {
    test('listComposes returns PageResult when items is a List', () async {
      final jsonResponse = {
        "items": [
          {
            "id": "1",
            "name": "test-compose",
            "path": "/opt/1panel/apps/test",
            "status": "running"
          }
        ],
        "total": 1,
        "page": 1,
        "pageSize": 10
      };

      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final response = await api.listComposes();
      expect(response.data, isA<PageResult<ComposeProject>>());
      expect(response.data!.items.length, 1);
      expect(response.data!.items.first.name, 'test-compose');
    });

    test(
        'listComposes handles Map items by converting values to List (if supported) or empty',
        () async {
      final jsonResponse = {
        "items": {
          "1": {"id": "1", "name": "test-map"}
        },
        "total": 1
      };

      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final response = await api.listComposes();
      expect(response.data!.items, isEmpty);
    });

    test('listComposes handles null items gracefully', () async {
      final jsonResponse = {"items": null, "total": 0};

      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final response = await api.listComposes();
      expect(response.data!.items, isEmpty);
    });

    test('listComposes with search parameter', () async {
      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {
              "data": {
                "items": [
                  {"id": "1", "name": "web-app", "status": "running"},
                ],
                "total": 1,
              },
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final response = await api.listComposes(search: 'web', page: 1, pageSize: 5);
      expect(response.data, isA<PageResult<ComposeProject>>());
      expect(response.data!.items.first.name, 'web-app');
    });

    group('createCompose', () {
      test('returns ComposeProject from response', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'id': '2',
                'name': 'new-compose',
                'path': '/opt/1panel/apps/new-compose',
                'status': 'created',
              },
            }, path: '/containers/compose'));

        final request = ContainerComposeCreate(
          from: 'template',
          name: 'new-compose',
        );
        final response = await api.createCompose(request);
        expect(response.data, isA<ComposeProject>());
        expect(response.data!.name, 'new-compose');
        expect(response.data!.id, '2');
      });
    });

    group('upCompose', () {
      test('sends up operation request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/operate'),
            ));

        final compose = ContainerCompose(
          id: '1',
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
        );
        final response = await api.upCompose(compose);
        expect(response.statusCode, 200);
      });
    });

    group('downCompose', () {
      test('sends down operation request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/operate'),
            ));

        final compose = ContainerCompose(
          id: '1',
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
        );
        final response = await api.downCompose(compose);
        expect(response.statusCode, 200);
      });
    });

    group('startCompose', () {
      test('sends start operation request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/operate'),
            ));

        final compose = ContainerCompose(
          id: '1',
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
        );
        final response = await api.startCompose(compose);
        expect(response.statusCode, 200);
      });
    });

    group('stopCompose', () {
      test('sends stop operation request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/operate'),
            ));

        final compose = ContainerCompose(
          id: '1',
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
        );
        final response = await api.stopCompose(compose);
        expect(response.statusCode, 200);
      });
    });

    group('restartCompose', () {
      test('sends restart operation request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/operate'),
            ));

        final compose = ContainerCompose(
          id: '1',
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
        );
        final response = await api.restartCompose(compose);
        expect(response.statusCode, 200);
      });
    });

    group('deleteCompose', () {
      test('sends delete operation request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/operate'),
            ));

        final compose = ContainerCompose(
          id: '1',
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
        );
        final response = await api.deleteCompose(compose);
        expect(response.statusCode, 200);
      });

      test('sends delete with force and withFile flags', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/operate'),
            ));

        final compose = ContainerCompose(
          id: '1',
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
        );
        await api.deleteCompose(compose, force: true, withFile: true);
      });
    });

    group('loadComposeEnv', () {
      test('returns list of environment variable strings', () async {
        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': ['DB_HOST=localhost', 'DB_PORT=5432'],
            }, path: '/containers/compose/env'));

        final request = FilePath(path: '/opt/1panel/apps/test/.env');
        final response = await api.loadComposeEnv(request);
        expect(response.data, isA<List<String>>());
        expect(response.data!.length, 2);
        expect(response.data!.first, 'DB_HOST=localhost');
      });

      test('handles empty env list', () async {
        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => _successResponse({
              'data': [],
            }, path: '/containers/compose/env'));

        final request = FilePath(path: '/opt/1panel/apps/test/.env');
        final response = await api.loadComposeEnv(request);
        expect(response.data, isEmpty);
      });
    });

    group('updateCompose', () {
      test('sends update request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/update'),
            ));

        final request = ContainerComposeUpdateRequest(
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
          content: 'version: "3"\nservices:\n  web:\n    image: nginx',
        );
        final response = await api.updateCompose(request);
        expect(response.statusCode, 200);
      });
    });

    group('testCompose', () {
      test('sends test request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/test'),
            ));

        final request = ContainerComposeCreate(
          from: 'edit',
          name: 'test-compose',
          file: 'version: "3"\nservices:\n  web:\n    image: nginx',
        );
        final response = await api.testCompose(request);
        expect(response.statusCode, 200);
      });
    });

    group('cleanComposeLog', () {
      test('sends clean log request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/compose/clean/log'),
            ));

        final request = ContainerComposeLogCleanRequest(
          name: 'test-compose',
          path: '/opt/1panel/apps/test',
        );
        final response = await api.cleanComposeLog(request);
        expect(response.statusCode, 200);
      });
    });
  });
}
