import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/docker_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/data/models/container_models.dart';
import 'package:onepanel_client/data/models/docker_models.dart';

import 'compose_api_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late DockerV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = DockerV2Api(mockClient);
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

  group('DockerV2Api - Networks', () {
    group('listNetworks', () {
      test('returns list of DockerNetwork from paged response', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'items': [
                  {
                    'id': 'net-001',
                    'name': 'bridge',
                    'driver': 'bridge',
                    'scope': 'local',
                    'internal': false,
                  },
                  {
                    'id': 'net-002',
                    'name': 'host',
                    'driver': 'host',
                    'scope': 'local',
                    'internal': false,
                  },
                ],
                'total': 2,
              },
            }, path: '/containers/network/search'));

        final response = await api.listNetworks();
        expect(response.data, isA<List<DockerNetwork>>());
        expect(response.data!.length, 2);
        expect(response.data!.first.name, 'bridge');
        expect(response.data!.first.driver, 'bridge');
        expect(response.data!.last.name, 'host');
      });

      test('handles empty network list', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'items': [],
                'total': 0,
              },
            }, path: '/containers/network/search'));

        final response = await api.listNetworks();
        expect(response.data, isEmpty);
      });

      test('handles response without data wrapper', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'items': [
                {
                  'id': 'net-001',
                  'name': 'bridge',
                  'driver': 'bridge',
                },
              ],
              'total': 1,
            }, path: '/containers/network/search'));

        final response = await api.listNetworks();
        expect(response.data, isA<List<DockerNetwork>>());
        expect(response.data!.length, 1);
      });

      test('parses network with optional fields', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'items': [
                  {
                    'id': 'net-003',
                    'name': 'custom-net',
                    'driver': 'overlay',
                    'scope': 'swarm',
                    'internal': true,
                    'attachable': true,
                    'subnet': '10.0.0.0/24',
                    'gateway': '10.0.0.1',
                  },
                ],
                'total': 1,
              },
            }, path: '/containers/network/search'));

        final response = await api.listNetworks();
        final network = response.data!.first;
        expect(network.id, 'net-003');
        expect(network.name, 'custom-net');
        expect(network.driver, 'overlay');
        expect(network.scope, 'swarm');
        expect(network.internal, true);
        expect(network.attachable, true);
        expect(network.subnet, '10.0.0.0/24');
        expect(network.gateway, '10.0.0.1');
      });
    });

    group('createNetwork', () {
      test('sends create request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/network'),
            ));

        final request = NetworkCreate(
          name: 'my-network',
          driver: 'bridge',
        );
        final response = await api.createNetwork(request);
        expect(response.statusCode, 200);
      });

      test('sends create request with subnet and gateway', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/network'),
            ));

        final request = NetworkCreate(
          name: 'my-network',
          driver: 'bridge',
          subnet: '172.20.0.0/16',
          gateway: '172.20.0.1',
        );
        await api.createNetwork(request);

        verify(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).called(1);
      });
    });

    group('removeNetwork', () {
      test('sends remove request with network id', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/network/del'),
            ));

        await api.removeNetwork('net-001');

        verify(mockClient.post<void>(
          any,
          data: {
            'names': ['net-001'],
          },
        )).called(1);
      });
    });
  });
}
