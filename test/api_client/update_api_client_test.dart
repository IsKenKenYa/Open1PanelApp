import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/update_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';

import 'compose_api_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late UpdateV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = UpdateV2Api(mockClient);
  });

  group('UpdateV2Api', () {
    test('systemUpgrade sends POST with version and returns void', () async {
      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/core/settings/upgrade'),
          ));

      final response = await api.systemUpgrade(version: 'v1.0.0');
      expect(response.statusCode, 200);
      verify(mockClient.post<void>(
        any,
        data: {'version': 'v1.0.0'},
      )).called(1);
    });

    test('systemUpgrade uses empty version by default', () async {
      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/core/settings/upgrade'),
          ));

      final response = await api.systemUpgrade();
      expect(response.statusCode, 200);
      verify(mockClient.post<void>(
        any,
        data: {'version': ''},
      )).called(1);
    });

    test('getUpgradeNotes returns notes string', () async {
      when(mockClient.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<Map<String, dynamic>>(
            data: {'data': 'Release notes content'},
            statusCode: 200,
            requestOptions:
                RequestOptions(path: '/core/settings/upgrade/notes'),
          ));

      final response = await api.getUpgradeNotes(version: 'v1.0.0');
      expect(response.data, 'Release notes content');
    });

    test('getUpgradeNotes returns empty string when data is null', () async {
      when(mockClient.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<Map<String, dynamic>>(
            data: {'data': null},
            statusCode: 200,
            requestOptions:
                RequestOptions(path: '/core/settings/upgrade/notes'),
          ));

      final response = await api.getUpgradeNotes();
      expect(response.data, '');
    });

    test('getUpgradeReleases returns list of release maps', () async {
      final releases = [
        {'version': 'v1.2.0', 'tag': 'v1.2.0'},
        {'version': 'v1.1.0', 'tag': 'v1.1.0'},
      ];

      when(mockClient.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<Map<String, dynamic>>(
            data: {'data': releases},
            statusCode: 200,
            requestOptions:
                RequestOptions(path: '/core/settings/upgrade/releases'),
          ));

      final response = await api.getUpgradeReleases();
      expect(response.data, isA<List<Map<String, dynamic>>>());
      expect(response.data!.length, 2);
      expect(response.data!.first['version'], 'v1.2.0');
    });

    test('getUpgradeReleases returns empty list when data is null', () async {
      when(mockClient.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<Map<String, dynamic>>(
            data: {'data': null},
            statusCode: 200,
            requestOptions:
                RequestOptions(path: '/core/settings/upgrade/releases'),
          ));

      final response = await api.getUpgradeReleases();
      expect(response.data, isEmpty);
    });
  });
}
