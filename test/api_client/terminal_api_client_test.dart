import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/terminal_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/data/models/terminal_models.dart';

import 'terminal_api_client_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late TerminalV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = TerminalV2Api(mockClient);
  });

  RequestOptions _opts(String path) => RequestOptions(path: path);

  group('TerminalV2Api', () {
    group('createTerminalSession', () {
      test('should return TerminalSessionInfo on success', () async {
        const request = TerminalSessionCreate(
          command: '/bin/bash',
          user: 'root',
          workDir: '/root',
        );
        final sessionJson = {
          'sessionId': 'sess-001',
          'status': 'running',
          'containerId': '',
          'createTime': '2025-01-01T00:00:00Z',
          'lastActivityTime': '2025-01-01T00:01:00Z',
        };

        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: sessionJson,
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/sessions'),
            ));

        final response = await api.createTerminalSession(request);

        expect(response.statusCode, 200);
        expect(response.data, isA<TerminalSessionInfo>());
        expect(response.data!.sessionId, 'sess-001');
        expect(response.data!.status, 'running');
        expect(response.data!.createTime, '2025-01-01T00:00:00Z');
      });
    });

    group('getTerminalSessions', () {
      test('should return list of sessions on success', () async {
        final sessionsJson = [
          {
            'sessionId': 'sess-001',
            'status': 'running',
            'containerId': '',
            'createTime': '2025-01-01T00:00:00Z',
            'lastActivityTime': '2025-01-01T00:01:00Z',
          },
          {
            'sessionId': 'sess-002',
            'status': 'stopped',
            'containerId': 'container-abc',
            'createTime': '2025-01-02T00:00:00Z',
            'lastActivityTime': '2025-01-02T00:05:00Z',
          },
        ];

        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: sessionsJson,
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/sessions'),
            ));

        final response = await api.getTerminalSessions();

        expect(response.statusCode, 200);
        expect(response.data, isA<List<TerminalSessionInfo>>());
        expect(response.data, hasLength(2));
        expect(response.data!.first.sessionId, 'sess-001');
        expect(response.data!.last.sessionId, 'sess-002');
      });

      test('should return empty list when data is null', () async {
        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/sessions'),
            ));

        final response = await api.getTerminalSessions();

        expect(response.data, isEmpty);
      });
    });

    group('getTerminalSessionDetail', () {
      test('should return session info for given id', () async {
        final sessionJson = {
          'sessionId': 'sess-001',
          'status': 'running',
          'containerId': '',
          'createTime': '2025-01-01T00:00:00Z',
          'lastActivityTime': '2025-01-01T00:01:00Z',
        };

        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: sessionJson,
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/sessions/sess-001'),
            ));

        final response = await api.getTerminalSessionDetail('sess-001');

        expect(response.data!.sessionId, 'sess-001');
        expect(response.data!.status, 'running');
      });
    });

    group('deleteTerminalSession', () {
      test('should send delete request successfully', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/sessions/delete'),
            ));

        final response = await api.deleteTerminalSession('sess-001');

        expect(response.statusCode, 200);
      });
    });

    group('executeTerminalCommand', () {
      test('should return TerminalCommandResult on success', () async {
        const request = TerminalCommandExecute(
          command: 'ls -la',
          user: 'root',
        );
        final resultJson = {
          'output': 'total 0\ndrwxr-xr-x 2 root root 40 Jan 1 00:00 .\n',
          'error': '',
          'exitCode': 0,
          'success': true,
        };

        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: resultJson,
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/command'),
            ));

        final response = await api.executeTerminalCommand(request);

        expect(response.data, isA<TerminalCommandResult>());
        expect(response.data!.success, true);
        expect(response.data!.exitCode, 0);
        expect(response.data!.output, contains('total'));
      });

      test('should handle command failure', () async {
        const request = TerminalCommandExecute(command: 'invalid_cmd');
        final resultJson = {
          'output': '',
          'error': 'command not found',
          'exitCode': 127,
          'success': false,
        };

        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: resultJson,
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/command'),
            ));

        final response = await api.executeTerminalCommand(request);

        expect(response.data!.success, false);
        expect(response.data!.exitCode, 127);
        expect(response.data!.error, 'command not found');
      });
    });

    group('searchTerminalSettings', () {
      test('should send search settings request', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/core/settings/terminal/search'),
            ));

        final response = await api.searchTerminalSettings({'key': 'value'});

        expect(response.statusCode, 200);
      });
    });

    group('updateTerminalSettings', () {
      test('should send update settings request', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/core/settings/terminal/update'),
            ));

        final response = await api.updateTerminalSettings({'key': 'newValue'});

        expect(response.statusCode, 200);
      });
    });

    group('getTerminalOutput', () {
      test('should return output with default lines', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'output': 'line1\nline2\n'},
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/output'),
            ));

        final response = await api.getTerminalOutput('sess-001');

        expect(response.statusCode, 200);
        expect(response.data, isNotNull);
      });

      test('should pass custom lines parameter', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'output': 'tail output'},
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/output'),
            ));

        final response = await api.getTerminalOutput('sess-001', lines: 50);

        expect(response.statusCode, 200);
      });
    });

    group('sendTerminalInput', () {
      test('should send input to session', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/input'),
            ));

        final response = await api.sendTerminalInput(
          sessionId: 'sess-001',
          input: 'echo hello\n',
        );

        expect(response.statusCode, 200);
      });
    });

    group('resizeTerminal', () {
      test('should send resize request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/resize'),
            ));

        final response = await api.resizeTerminal(
          sessionId: 'sess-001',
          rows: 40,
          columns: 120,
        );

        expect(response.statusCode, 200);
      });
    });

    group('getTerminalHistory', () {
      test('should return history with default limit', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'history': ['ls', 'cd /tmp', 'cat file']},
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/history'),
            ));

        final response = await api.getTerminalHistory('sess-001');

        expect(response.statusCode, 200);
      });

      test('should pass custom limit', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'history': <String>[]},
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/history'),
            ));

        final response = await api.getTerminalHistory('sess-001', limit: 50);

        expect(response.statusCode, 200);
      });
    });

    group('clearTerminalHistory', () {
      test('should send clear history request', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts(
                  '/api/v2/terminal/sessions/sess-001/history/clear'),
            ));

        final response = await api.clearTerminalHistory('sess-001');

        expect(response.statusCode, 200);
      });
    });

    group('getTerminalStatus', () {
      test('should get session status', () async {
        when(mockClient.get<void>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/status'),
            ));

        final response = await api.getTerminalStatus('sess-001');

        expect(response.statusCode, 200);
      });
    });

    group('renameTerminalSession', () {
      test('should send rename request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/rename'),
            ));

        final response = await api.renameTerminalSession(
          sessionId: 'sess-001',
          name: 'my-terminal',
        );

        expect(response.statusCode, 200);
      });
    });

    group('getTerminalFiles', () {
      test('should return files without path', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'files': []},
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/files'),
            ));

        final response = await api.getTerminalFiles('sess-001');

        expect(response.statusCode, 200);
      });

      test('should return files with path', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'files': []},
              statusCode: 200,
              requestOptions:
                  _opts('/api/v2/terminal/sessions/sess-001/files'),
            ));

        final response =
            await api.getTerminalFiles('sess-001', path: '/tmp');

        expect(response.statusCode, 200);
      });
    });

    group('uploadFileToTerminal', () {
      test('should send upload request without targetPath', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts(
                  '/api/v2/terminal/sessions/sess-001/files/upload'),
            ));

        final response = await api.uploadFileToTerminal(
          sessionId: 'sess-001',
          filePath: '/local/file.txt',
        );

        expect(response.statusCode, 200);
      });

      test('should send upload request with targetPath', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts(
                  '/api/v2/terminal/sessions/sess-001/files/upload'),
            ));

        final response = await api.uploadFileToTerminal(
          sessionId: 'sess-001',
          filePath: '/local/file.txt',
          targetPath: '/remote/dest/',
        );

        expect(response.statusCode, 200);
      });
    });

    group('downloadFileFromTerminal', () {
      test('should send download request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts(
                  '/api/v2/terminal/sessions/sess-001/files/download'),
            ));

        final response = await api.downloadFileFromTerminal(
          sessionId: 'sess-001',
          filePath: '/remote/file.txt',
        );

        expect(response.statusCode, 200);
      });
    });

    group('getTerminalProcesses', () {
      test('should get session processes', () async {
        when(mockClient.get<void>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts(
                  '/api/v2/terminal/sessions/sess-001/processes'),
            ));

        final response = await api.getTerminalProcesses('sess-001');

        expect(response.statusCode, 200);
      });
    });

    group('terminateTerminalProcess', () {
      test('should send terminate request', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts(
                  '/api/v2/terminal/sessions/sess-001/processes/terminate'),
            ));

        final response = await api.terminateTerminalProcess(
          sessionId: 'sess-001',
          processId: 1234,
        );

        expect(response.statusCode, 200);
      });
    });

    group('getTerminalConfig', () {
      test('should get terminal config', () async {
        when(mockClient.get<void>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/config'),
            ));

        final response = await api.getTerminalConfig();

        expect(response.statusCode, 200);
      });
    });

    group('updateTerminalConfig', () {
      test('should update terminal config', () async {
        when(mockClient.post<void>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/config'),
            ));

        final response = await api.updateTerminalConfig({
          'fontSize': 14,
          'theme': 'dark',
        });

        expect(response.statusCode, 200);
      });
    });

    group('getTerminalThemes', () {
      test('should get available themes', () async {
        when(mockClient.get<void>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/themes'),
            ));

        final response = await api.getTerminalThemes();

        expect(response.statusCode, 200);
      });
    });

    group('setTerminalTheme', () {
      test('should set terminal theme', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/theme'),
            ));

        final response = await api.setTerminalTheme('monokai');

        expect(response.statusCode, 200);
      });
    });

    group('getTerminalFonts', () {
      test('should get available fonts', () async {
        when(mockClient.get<void>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/fonts'),
            ));

        final response = await api.getTerminalFonts();

        expect(response.statusCode, 200);
      });
    });

    group('setTerminalFont', () {
      test('should set font without fontSize', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/font'),
            ));

        final response = await api.setTerminalFont(font: 'Fira Code');

        expect(response.statusCode, 200);
      });

      test('should set font with fontSize', () async {
        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: _opts('/api/v2/terminal/font'),
            ));

        final response =
            await api.setTerminalFont(font: 'Fira Code', fontSize: 16.0);

        expect(response.statusCode, 200);
      });
    });
  });
}
