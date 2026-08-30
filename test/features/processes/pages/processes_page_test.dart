import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/core/config/api_config.dart';
import 'package:onepanel_client/data/models/process_models.dart';
import 'package:onepanel_client/features/processes/pages/processes_page.dart';
import 'package:onepanel_client/features/processes/providers/processes_provider.dart';
import 'package:onepanel_client/features/processes/services/process_service.dart';
import 'package:onepanel_client/features/shell/controllers/current_server_controller.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class _MockProcessService extends Mock implements ProcessService {}

class _FakeCurrentServerController extends CurrentServerController {
  final ApiConfig _config = ApiConfig(
    id: 'server-1',
    name: 'Demo',
    url: 'https://demo.example.com',
    apiKey: 'key',
  );

  @override
  bool get hasServer => true;

  @override
  ApiConfig? get currentServer => _config;
}

class _NoServerCurrentServerController extends CurrentServerController {}

void main() {
  late StreamController<List<ProcessSummary>> controller;

  setUpAll(() {
    registerFallbackValue(const ProcessListQuery());
  });

  setUp(() {
    controller = StreamController<List<ProcessSummary>>.broadcast();
  });

  tearDown(() async {
    await controller.close();
  });

  testWidgets('ProcessesPage renders process card', (tester) async {
    final service = _MockProcessService();
    when(() => service.watchProcesses()).thenAnswer((_) => controller.stream);
    when(() => service.connectProcesses(any())).thenAnswer((_) async {});
    when(() => service.loadListening())
        .thenAnswer((_) async => const <ListeningProcess>[]);
    when(() => service.closeProcesses()).thenAnswer((_) async {});
    when(() => service.mergeListeningData(any(), any()))
        .thenAnswer((invocation) {
      return invocation.positionalArguments.first as List<ProcessSummary>;
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CurrentServerController>.value(
            value: _FakeCurrentServerController(),
          ),
          ChangeNotifierProvider<ProcessesProvider>(
            create: (_) => ProcessesProvider(service: service),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const ProcessesPage(),
        ),
      ),
    );
    // 等 postFrame 的 load() 完成订阅后才能 add，否则 broadcast 事件丢失。
    // load 会启动 3s 轮询定时器，须用固定 pump 而非 pumpAndSettle。
    await tester.pump();
    await tester.pump();
    controller.add(const <ProcessSummary>[
      ProcessSummary(
        pid: 1,
        name: 'sshd',
        parentPid: 0,
        username: 'root',
        status: 'running',
        startTime: 'now',
        numThreads: 1,
        numConnections: 1,
        cpuPercent: '1%',
        cpuValue: 1,
        memoryText: '10M',
        memoryValue: 10,
      ),
    ]);
    await tester.pump();
    await tester.pump();

    final context = tester.element(find.byType(ProcessesPage));
    final provider = context.read<ProcessesProvider>();
    final texts = tester
        .widgetList<Text>(find.byType(Text, skipOffstage: false))
        .map((t) => t.data)
        .take(20)
        .toList();
    expect(find.text('sshd'), findsOneWidget,
        reason: 'state: loading=${provider.isLoading} isEmpty=${provider.isEmpty} '
            'error=${provider.errorMessage} texts=$texts');
  });

  testWidgets('ProcessesPage does not connect when no server is active',
      (tester) async {
    final service = _MockProcessService();
    when(() => service.watchProcesses()).thenAnswer((_) => controller.stream);
    when(() => service.closeProcesses()).thenAnswer((_) async {});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CurrentServerController>.value(
            value: _NoServerCurrentServerController(),
          ),
          ChangeNotifierProvider<ProcessesProvider>(
            create: (_) => ProcessesProvider(service: service),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const ProcessesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    verifyNever(() => service.connectProcesses(any()));
  });
}
