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

  group('DockerV2Api - Volumes', () {
    group('listVolumes', () {
      test('returns list of DockerVolume from paged response', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'items': [
                  {
                    'name': 'app-data',
                    'driver': 'local',
                    'mountpoint': '/var/lib/docker/volumes/app-data/_data',
                  },
                  {
                    'name': 'db-data',
                    'driver': 'local',
                    'mountpoint': '/var/lib/docker/volumes/db-data/_data',
                  },
                ],
                'total': 2,
              },
            }, path: '/containers/volume/search'));

        final response = await api.listVolumes();
        expect(response.data, isA<List<DockerVolume>>());
        expect(response.data!.length, 2);
        expect(response.data!.first.name, 'app-data');
        expect(response.data!.first.driver, 'local');
        expect(response.data!.last.name, 'db-data');
      });

      test('handles empty volume list', () async {
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
            }, path: '/containers/volume/search'));

        final response = await api.listVolumes();
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
                  'name': 'vol-1',
                  'driver': 'local',
                },
              ],
              'total': 1,
            }, path: '/containers/volume/search'));

        final response = await api.listVolumes();
        expect(response.data, isA<List<DockerVolume>>());
        expect(response.data!.length, 1);
      });

      test('parses volume with labels and options', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': {
                'items': [
                  {
                    'name': 'nfs-vol',
                    'driver': 'local',
                    'mountpoint': '/var/lib/docker/volumes/nfs-vol/_data',
                    'labels': {'env': 'production'},
                    'options': {
                      'type': 'nfs',
                      'device': ':/share',
                    },
                  },
                ],
                'total': 1,
              },
            }, path: '/containers/volume/search'));

        final response = await api.listVolumes();
        final volume = response.data!.first;
        expect(volume.name, 'nfs-vol');
        expect(volume.labels, {'env': 'production'});
        expect(volume.options, {'type': 'nfs', 'device': ':/share'});
      });
    });

    group('createVolume', () {
      test('sends create request successfully', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/volume'),
            ));

        final request = VolumeCreate(name: 'my-volume');
        final response = await api.createVolume(request);
        expect(response.statusCode, 200);
      });

      test('sends create request with driver and labels', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/volume'),
            ));

        final request = VolumeCreate(
          name: 'my-volume',
          driver: 'local',
          labels: {'team': 'backend'},
        );
        await api.createVolume(request);

        verify(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).called(1);
      });
    });

    group('removeVolume', () {
      test('sends remove request with volume name', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/containers/volume/del'),
            ));

        await api.removeVolume('my-volume');

        verify(mockClient.post<void>(
          any,
          data: {
            'names': ['my-volume'],
          },
        )).called(1);
      });
    });
  });
}
