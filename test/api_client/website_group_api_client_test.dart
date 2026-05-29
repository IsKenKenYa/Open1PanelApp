import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/website_group_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';

import 'compose_api_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late WebsiteGroupV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = WebsiteGroupV2Api(mockClient);
  });

  group('WebsiteGroupV2Api', () {
    test('getGroups sends POST with name and type', () async {
      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/groups'),
          ));

      final response = await api.getGroups(name: 'test', type: 'website');
      expect(response.statusCode, 200);
      verify(mockClient.post<void>(
        any,
        data: {'name': 'test', 'type': 'website'},
      )).called(1);
    });

    test('getGroups uses empty defaults when no params provided', () async {
      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/groups'),
          ));

      final response = await api.getGroups();
      expect(response.statusCode, 200);
      verify(mockClient.post<void>(
        any,
        data: {'name': '', 'type': ''},
      )).called(1);
    });

    test('searchGroups returns Map response', () async {
      final searchData = {'type': 'website', 'page': 1, 'pageSize': 10};
      final jsonResponse = {
        'items': [
          {'id': 1, 'name': 'Default', 'type': 'website'},
        ],
        'total': 1,
      };

      when(mockClient.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<Map<String, dynamic>>(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/groups/search'),
          ));

      final response = await api.searchGroups(searchData);
      expect(response.data, isA<Map<String, dynamic>>());
      expect(response.data!['total'], 1);
    });

    test('updateGroup sends POST with group data', () async {
      final groupData = {
        'id': 1,
        'name': 'Updated Group',
        'type': 'website',
      };

      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/groups/update'),
          ));

      final response = await api.updateGroup(groupData);
      expect(response.statusCode, 200);
      verify(mockClient.post<void>(
        any,
        data: groupData,
      )).called(1);
    });

    test('deleteGroup sends POST with delete data', () async {
      final deleteData = {
        'ids': [1, 2],
      };

      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/groups/del'),
          ));

      final response = await api.deleteGroup(deleteData);
      expect(response.statusCode, 200);
      verify(mockClient.post<void>(
        any,
        data: deleteData,
      )).called(1);
    });
  });
}
