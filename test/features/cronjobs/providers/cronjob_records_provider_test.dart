import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/cronjob_record_models.dart';
import 'package:onepanel_client/data/repositories/cronjob_repository.dart';
import 'package:onepanel_client/features/cronjobs/providers/cronjob_records_provider.dart';

class _MockCronjobRepository extends Mock implements CronjobRepository {}

void main() {
  late _MockCronjobRepository repository;
  late CronjobRecordsProvider provider;

  const record = CronjobRecordInfo(
    id: 11,
    taskId: 'task-1',
    startTime: '2026-03-27 00:00:00',
    status: 'Success',
    message: 'finished',
    targetPath: '/tmp/result',
    interval: 80,
    file: 'record.log',
  );

  setUpAll(() {
    registerFallbackValue(const CronjobRecordQuery(cronjobId: 1));
    registerFallbackValue(
      const CronjobRecordCleanRequest(cronjobId: 1),
    );
  });

  setUp(() {
    repository = _MockCronjobRepository();
    when(() => repository.searchRecords(any())).thenAnswer(
      (_) async => const PageResult<CronjobRecordInfo>(
        items: <CronjobRecordInfo>[record],
        total: 1,
      ),
    );
    when(() => repository.loadRecordLog(any()))
        .thenAnswer((_) async => 'record log content');
    when(() => repository.cleanRecords(any())).thenAnswer((_) async {});
    provider = CronjobRecordsProvider(repository: repository);
  });

  test('load fetches records', () async {
    await provider.load(1);

    expect(provider.items, hasLength(1));
    expect(provider.statusFilter, isEmpty);
  });

  test('loadRecordLog stores selected log', () async {
    await provider.loadRecordLog(11);

    expect(provider.selectedRecordId, 11);
    expect(provider.selectedLog, 'record log content');
  });

  test('cleanRecords calls repository and reloads', () async {
    await provider.load(1);
    clearInteractions(repository);
    when(() => repository.searchRecords(any())).thenAnswer(
      (_) async => const PageResult<CronjobRecordInfo>(
        items: <CronjobRecordInfo>[record],
        total: 1,
      ),
    );

    final result = await provider.cleanRecords(
      cleanData: true,
      cleanRemoteData: false,
    );

    expect(result, isTrue);
    verify(
      () => repository.cleanRecords(
        const CronjobRecordCleanRequest(
          cronjobId: 1,
          cleanData: true,
          cleanRemoteData: false,
        ),
      ),
    ).called(1);
    verify(() => repository.searchRecords(any())).called(1);
  });
}
