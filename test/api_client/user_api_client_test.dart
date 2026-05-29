import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/user_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/user_models.dart';

import 'compose_api_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late UserV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = UserV2Api(mockClient);
  });

  group('UserV2Api', () {
    test('login returns UserLoginResponse', () async {
      final loginData = const UserLogin(
        username: 'admin',
        password: '123456',
      );
      final jsonResponse = {
        'token': 'abc123',
        'refreshToken': 'ref123',
        'user': {'id': 1, 'username': 'admin'},
        'expiresIn': 3600,
      };

      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/core/auth/login'),
          ));

      final response = await api.login(loginData);
      expect(response.data, isA<UserLoginResponse>());
      expect(response.data!.token, 'abc123');
      expect(response.data!.user!.username, 'admin');
    });

    test('logout sends POST and returns void', () async {
      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/core/auth/logout'),
          ));

      final response = await api.logout();
      expect(response.statusCode, 200);
    });

    test('mfaLogin returns UserLoginResponse', () async {
      final mfaData = const UserMFALogin(
        username: 'admin',
        password: '123456',
        mfaCode: '654321',
        mfaToken: 'mfa_token',
      );
      final jsonResponse = {
        'token': 'mfa_abc123',
        'user': {'id': 1, 'username': 'admin'},
      };

      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/core/auth/mfalogin'),
          ));

      final response = await api.mfaLogin(mfaData);
      expect(response.data, isA<UserLoginResponse>());
      expect(response.data!.token, 'mfa_abc123');
    });

    test('getCaptcha returns CaptchaResponse', () async {
      final jsonResponse = {
        'captchaId': 'cap_001',
        'captchaBase64': 'base64data',
      };

      when(mockClient.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/core/auth/captcha'),
          ));

      final response = await api.getCaptcha();
      expect(response.data, isA<CaptchaResponse>());
      expect(response.data!.captchaId, 'cap_001');
    });

    test('getAuthSettings returns AuthSettings', () async {
      final jsonResponse = {
        'captchaEnabled': true,
        'mfaEnabled': false,
        'sessionTimeout': 3600,
      };

      when(mockClient.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/core/auth/setting'),
          ));

      final response = await api.getAuthSettings();
      expect(response.data, isA<AuthSettings>());
      expect(response.data!.captchaEnabled, true);
      expect(response.data!.mfaEnabled, false);
    });

    test('getUsers returns PageResult<UserInfo>', () async {
      final jsonResponse = {
        'items': [
          {'id': 1, 'username': 'admin', 'role': 'admin'},
          {'id': 2, 'username': 'user1', 'role': 'user'},
        ],
        'total': 2,
        'page': 1,
        'pageSize': 10,
      };

      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/search'),
          ));

      final response = await api.getUsers();
      expect(response.data, isA<PageResult<UserInfo>>());
      expect(response.data!.items.length, 2);
      expect(response.data!.items.first.username, 'admin');
    });

    test('createUser sends POST with user data', () async {
      final userData = const UserCreate(
        username: 'newuser',
        password: 'pass123',
        email: 'new@example.com',
      );

      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users'),
          ));

      final response = await api.createUser(userData);
      expect(response.statusCode, 200);
      verify(mockClient.post<void>(
        any,
        data: userData.toJson(),
      )).called(1);
    });

    test('getUserDetail returns UserInfo', () async {
      final jsonResponse = {
        'id': 1,
        'username': 'admin',
        'email': 'admin@example.com',
        'role': 'admin',
        'status': 'active',
      };

      when(mockClient.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/1'),
          ));

      final response = await api.getUserDetail(1);
      expect(response.data, isA<UserInfo>());
      expect(response.data!.id, 1);
      expect(response.data!.username, 'admin');
    });

    test('updateUser sends POST with update data', () async {
      final updateData = const UserUpdate(id: 1, nickname: 'Updated Name');

      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/1'),
          ));

      final response = await api.updateUser(updateData);
      expect(response.statusCode, 200);
    });

    test('deleteUser sends POST with ids', () async {
      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/del'),
          ));

      final response = await api.deleteUser([1, 2]);
      expect(response.statusCode, 200);
    });

    test('enableUser sends POST with enable operation', () async {
      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/enable'),
          ));

      final response = await api.enableUser([1, 2]);
      expect(response.statusCode, 200);
      verify(mockClient.post(
        any,
        data: {
          'ids': [1, 2],
          'operation': 'enable',
        },
      )).called(1);
    });

    test('disableUser sends POST with disable operation', () async {
      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/disable'),
          ));

      final response = await api.disableUser([3]);
      expect(response.statusCode, 200);
      verify(mockClient.post(
        any,
        data: {
          'ids': [3],
          'operation': 'disable',
        },
      )).called(1);
    });

    test('resetUserPassword sends POST with password', () async {
      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/1/password/reset'),
          ));

      final response = await api.resetUserPassword(id: 1, password: 'newPass');
      expect(response.statusCode, 200);
    });

    test('changePassword sends POST with old and new password', () async {
      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/password/change'),
          ));

      final response = await api.changePassword(
        oldPassword: 'old123',
        newPassword: 'new456',
      );
      expect(response.statusCode, 200);
      verify(mockClient.post(
        any,
        data: {
          'oldPassword': 'old123',
          'newPassword': 'new456',
        },
      )).called(1);
    });

    test('getCurrentUser returns UserInfo', () async {
      final jsonResponse = {
        'id': 1,
        'username': 'admin',
        'email': 'admin@example.com',
      };

      when(mockClient.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/current'),
          ));

      final response = await api.getCurrentUser();
      expect(response.data, isA<UserInfo>());
      expect(response.data!.username, 'admin');
    });

    test('updateCurrentUser sends POST with user data', () async {
      final updateData = const UserUpdate(id: 1, nickname: 'New Nickname');

      when(mockClient.post<void>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response<void>(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/current'),
          ));

      final response = await api.updateCurrentUser(updateData);
      expect(response.statusCode, 200);
    });

    test('getRoles returns list of Role', () async {
      final jsonResponse = [
        {'id': 1, 'name': 'Admin', 'code': 'admin'},
        {'id': 2, 'name': 'User', 'code': 'user'},
      ];

      when(mockClient.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/roles'),
          ));

      final response = await api.getRoles();
      expect(response.data, isA<List<Role>>());
      expect(response.data!.length, 2);
      expect(response.data!.first.name, 'Admin');
    });

    test('getPermissions returns list of Permission', () async {
      final jsonResponse = [
        {'id': 'p1', 'name': 'Read', 'resource': 'users', 'action': 'read'},
        {'id': 'p2', 'name': 'Write', 'resource': 'users', 'action': 'write'},
      ];

      when(mockClient.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/permissions'),
          ));

      final response = await api.getPermissions();
      expect(response.data, isA<List<Permission>>());
      expect(response.data!.length, 2);
      expect(response.data!.first.name, 'Read');
    });

    test('getUserSessions returns PageResult<UserSession>', () async {
      final jsonResponse = {
        'items': [
          {
            'sessionId': 'sess_001',
            'userId': 1,
            'username': 'admin',
            'ipAddress': '192.168.1.1',
            'active': true,
          }
        ],
        'total': 1,
        'page': 1,
        'pageSize': 10,
      };

      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/sessions/search'),
          ));

      final response = await api.getUserSessions();
      expect(response.data, isA<PageResult<UserSession>>());
      expect(response.data!.items.length, 1);
      expect(response.data!.items.first.sessionId, 'sess_001');
    });

    test('getUserSessions sends userId when provided', () async {
      final jsonResponse = {
        'items': <Map<String, dynamic>>[],
        'total': 0,
        'page': 1,
        'pageSize': 10,
      };

      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: jsonResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/sessions/search'),
          ));

      await api.getUserSessions(userId: 5, page: 2, pageSize: 20);
      verify(mockClient.post(
        any,
        data: {'page': 2, 'pageSize': 20, 'userId': 5},
      )).called(1);
    });

    test('forceLogoutUser sends POST with sessionIds', () async {
      when(mockClient.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users/force-logout'),
          ));

      final response =
          await api.forceLogoutUser(['sess_001', 'sess_002']);
      expect(response.statusCode, 200);
      verify(mockClient.post(
        any,
        data: {
          'sessionIds': ['sess_001', 'sess_002'],
        },
      )).called(1);
    });
  });
}
