import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/host_tool_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/data/models/host_tool_models.dart';

import 'host_tool_api_client_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late HostToolV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = HostToolV2Api(mockClient);
  });

  RequestOptions _opts(String path) => RequestOptions(path: path);

  group('HostToolV2Api', () {
    group('getToolStatus', () {
      test('should return HostToolStatusResponse on success', () async {
        const request = HostToolRequest(type: 'supervisord');
        final jsonResponse = {
          'code': 200,
          'data': {
            'type': 'supervisord',
            'config': {
              'configPath': '/etc/supervisord.conf',
              'includeDir': '/etc/supervisord.d',
              'logPath': '/var/log/supervisord.log',
              'isExist': true,
              'init': true,
              'msg': '',
              'version': '4.2.5',
              'status': 'running',
              'ctlExist': true,
              'serviceName': 'supervisord',
            },
          },
        };

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool'),
            ));

        final response = await api.getToolStatus(request);

        expect(response.statusCode, 200);
        expect(response.data, isA<HostToolStatusResponse>());
        expect(response.data!.type, 'supervisord');
        expect(response.data!.config.isExist, true);
        expect(response.data!.config.status, 'running');
        expect(response.data!.config.version, '4.2.5');
      });

      test('should handle missing config gracefully', () async {
        const request = HostToolRequest(type: 'supervisord');
        final jsonResponse = {
          'code': 200,
          'data': {'type': 'supervisord'},
        };

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool'),
            ));

        final response = await api.getToolStatus(request);

        expect(response.data!.config, isA<SupervisorServiceInfo>());
        expect(response.data!.config.isExist, false);
      });

      test('should handle empty data field', () async {
        const request = HostToolRequest(type: 'supervisord');

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool'),
            ));

        final response = await api.getToolStatus(request);

        expect(response.data!.type, '');
        expect(response.data!.config.isExist, false);
      });
    });

    group('getToolConfig', () {
      test('should return HostToolConfigResponse on success', () async {
        const request = HostToolConfigRequest(
          type: 'supervisord',
          operate: 'get',
        );
        final jsonResponse = {
          'code': 200,
          'data': {
            'type': 'supervisord',
            'content': '[supervisord]\nnodaemon=false\n',
          },
        };

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool/config'),
            ));

        final response = await api.getToolConfig(request);

        expect(response.statusCode, 200);
        expect(response.data, isA<HostToolConfigResponse>());
        expect(response.data!.type, 'supervisord');
        expect(response.data!.content, contains('nodaemon'));
      });

      test('should handle empty data field', () async {
        const request = HostToolConfigRequest(
          type: 'supervisord',
          operate: 'get',
        );

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool/config'),
            ));

        final response = await api.getToolConfig(request);

        expect(response.data!.type, '');
        expect(response.data!.content, '');
      });
    });

    group('initTool', () {
      test('should send init request successfully', () async {
        const request = HostToolCreateRequest(
          type: 'supervisord',
          configPath: '/etc/supervisord.conf',
          serviceName: 'supervisord',
        );

        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool/init'),
            ));

        final response = await api.initTool(request);

        expect(response.statusCode, 200);
      });
    });

    group('operateTool', () {
      test('should send operate request successfully', () async {
        const request = HostToolRequest(
          type: 'supervisord',
          operate: 'restart',
        );

        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool/operate'),
            ));

        final response = await api.operateTool(request);

        expect(response.statusCode, 200);
      });
    });

    group('getSupervisorProcesses', () {
      test('should return list of processes when data is a List', () async {
        final jsonResponse = {
          'code': 200,
          'data': [
            {
              'name': 'worker-1',
              'command': 'python worker.py',
              'user': 'root',
              'dir': '/opt/workers',
              'numprocs': '1',
              'msg': '',
              'environment': 'ENV=prod',
              'autoRestart': 'true',
              'autoStart': 'true',
              'status': [
                {
                  'PID': '1234',
                  'status': 'RUNNING',
                  'uptime': '10:30',
                  'name': 'worker-1',
                  'msg': '',
                },
              ],
            },
          ],
        };

        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool/supervisor/process'),
            ));

        final response = await api.getSupervisorProcesses();

        expect(response.statusCode, 200);
        expect(response.data, isA<List<HostToolProcessConfig>>());
        expect(response.data, hasLength(1));
        expect(response.data!.first.name, 'worker-1');
        expect(response.data!.first.command, 'python worker.py');
        expect(response.data!.first.status, hasLength(1));
        expect(response.data!.first.status.first.pid, '1234');
        expect(response.data!.first.status.first.status, 'RUNNING');
      });

      test('should return single-item list when data is a Map', () async {
        final jsonResponse = {
          'code': 200,
          'data': {
            'name': 'single-process',
            'command': '/usr/bin/single',
            'user': 'root',
            'dir': '/opt',
            'numprocs': '1',
            'msg': '',
            'environment': '',
            'autoRestart': 'true',
            'autoStart': 'true',
            'status': [],
          },
        };

        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool/supervisor/process'),
            ));

        final response = await api.getSupervisorProcesses();

        expect(response.data, hasLength(1));
        expect(response.data!.first.name, 'single-process');
      });

      test('should return empty list when data is null', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool/supervisor/process'),
            ));

        final response = await api.getSupervisorProcesses();

        expect(response.data, isEmpty);
      });

      test('should return empty list when data is unexpected type', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': 'unexpected_string'},
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/tool/supervisor/process'),
            ));

        final response = await api.getSupervisorProcesses();

        expect(response.data, isEmpty);
      });
    });

    group('upsertSupervisorProcess', () {
      test('should send upsert request successfully', () async {
        const request = HostToolProcessConfigRequest(
          name: 'worker-1',
          operate: 'create',
          command: 'python worker.py',
          user: 'root',
          dir: '/opt/workers',
          numprocs: '1',
          autoRestart: 'true',
          autoStart: 'true',
        );

        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/hosts/tool/supervisor/process'),
            ));

        final response = await api.upsertSupervisorProcess(request);

        expect(response.statusCode, 200);
      });
    });

    group('operateSupervisorProcess', () {
      test('should send operate request successfully', () async {
        const request = HostToolProcessOperateRequest(
          name: 'worker-1',
          operate: 'restart',
        );

        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/hosts/tool/supervisor/process'),
            ));

        final response = await api.operateSupervisorProcess(request);

        expect(response.statusCode, 200);
      });
    });

    group('operateSupervisorProcessFile', () {
      test('should return file content string on success', () async {
        const request = HostToolProcessFileRequest(
          name: 'worker-1',
          operate: 'get',
          file: 'config',
        );
        final fileContent = '[program:worker-1]\ncommand=python worker.py\n';

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': fileContent},
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/hosts/tool/supervisor/process/file'),
            ));

        final response = await api.operateSupervisorProcessFile(request);

        expect(response.statusCode, 200);
        expect(response.data, fileContent);
      });

      test('should handle null data field', () async {
        const request = HostToolProcessFileRequest(
          name: 'worker-1',
          operate: 'get',
          file: 'config',
        );

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': null},
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/hosts/tool/supervisor/process/file'),
            ));

        final response = await api.operateSupervisorProcessFile(request);

        expect(response.data, '');
      });
    });
  });
}
