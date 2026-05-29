import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/setting_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';

import 'compose_api_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late SettingV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = SettingV2Api(mockClient);
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

  group('SettingV2Api - Menu Settings', () {
    group('updateMenuSettings', () {
      test('sends menu update request successfully', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/core/settings/menu/update'),
            ));

        final request = MenuUpdate(
          menus: ['dashboard', 'container', 'website', 'database'],
        );
        final response = await api.updateMenuSettings(request);
        expect(response.statusCode, 200);
      });

      test('sends empty menu list', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/core/settings/menu/update'),
            ));

        final request = MenuUpdate(menus: []);
        final response = await api.updateMenuSettings(request);
        expect(response.statusCode, 200);
      });

      test('sends single menu item', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/core/settings/menu/update'),
            ));

        final request = MenuUpdate(menus: ['dashboard']);
        final response = await api.updateMenuSettings(request);
        expect(response.statusCode, 200);
      });

      test('verifies request body format', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/core/settings/menu/update'),
            ));

        final request = MenuUpdate(
          menus: ['dashboard', 'container'],
        );
        await api.updateMenuSettings(request);

        verify(mockClient.post(
          any,
          data: {'menus': ['dashboard', 'container']},
        )).called(1);
      });
    });

    group('getDefaultMenu', () {
      test('returns default menu data', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse({
              'data': ['dashboard', 'container', 'website', 'database'],
            }, path: '/core/settings/menu/default'));

        final response = await api.getDefaultMenu();
        expect(response.statusCode, 200);
        expect(response.data, isNotNull);
      });

      test('handles null data in response', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => _successResponse(
              {},
              path: '/core/settings/menu/default',
            ));

        final response = await api.getDefaultMenu();
        expect(response.statusCode, 200);
      });
    });
  });
}
