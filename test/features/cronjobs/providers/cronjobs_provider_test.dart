import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/cronjob_list_models.dart';
import 'package:onepanel_client/data/models/system_group_models.dart';
import 'package:onepanel_client/data/repositories/cronjob_repository.dart';
import 'package:onepanel_client/features/cronjobs/providers/cronjobs_provider.dart';

class _MockCronjobRepository extends Mock implements CronjobRepository {}

void main() {
  late _MockCronjobRepository repository;
  late CronjobsProvider provider;

  final groups = <GroupInfo>[
    const GroupInfo(id: 1, name: 'Default', type: 'cronjob', isDefault: true),
  ];
  const item = CronjobSummary(
    id: 1,
    name: 'nightly-backup',
    type: 'shell',
    groupId: 1,
    groupBelong: 'Default',
    spec: '0 0 * * *',
    specCustom: false,
    status: 'Enable',
    lastRecordStatus: 'Success',
    lastRecordTime: '2026-03-27 00:00:00',
    retainCopies: 7,
    scriptMode: '',
    command: 'echo ok',
    executor: 'root',
  );

  setUpAll(() {
    registerFallbackValue(const CronjobListQuery());
    registerFallbackValue(const CronjobStatusUpdate(id: 0, status: ''));
  });

  setUp(() {
    repository = _MockCronjobRepository();
    when(() => repository.loadGroups(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async => groups);
    when(() => repository.searchCronjobsWithPreview(any())).thenAnswer(
      (_) async => const PageResult<CronjobSummary>(
        items: <CronjobSummary>[item],
        total: 1,
      ),
    );
    when(() => repository.updateStatus(any())).thenAnswer((_) async {});
    when(() => repository.handleOnce(any())).thenAnswer((_) async {});
    when(() => repository.stop(any())).thenAnswer((_) async {});
    provider = CronjobsProvider(repository: repository);
  });

  test('load sets cronjobs and groups', () async {
    await provider.load();

    expect(provider.items, hasLength(1));
    expect(provider.groups, hasLength(1));
    expect(provider.selectedGroupId, isNull);
  });

  test('updateStatus calls repository and reloads list', () async {
    await provider.load();
    clearInteractions(repository);
    when(() => repository.loadGroups(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async => groups);
    when(() => repository.searchCronjobsWithPreview(any())).thenAnswer(
      (_) async => const PageResult<CronjobSummary>(
        items: <CronjobSummary>[item],
        total: 1,
      ),
    );

    final result = await provider.updateStatus(item, 'Disable');

    expect(result, isTrue);
    verify(() => repository.updateStatus(
            const CronjobStatusUpdate(id: 1, status: 'Disable')))
        .called(1);
    verify(() => repository.searchCronjobsWithPreview(any())).called(1);
  });

  test('handleOnce calls repository and reloads list', () async {
    await provider.load();
    clearInteractions(repository);
    when(() => repository.loadGroups(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async => groups);
    when(() => repository.searchCronjobsWithPreview(any())).thenAnswer(
      (_) async => const PageResult<CronjobSummary>(
        items: <CronjobSummary>[item],
        total: 1,
      ),
    );

    final result = await provider.handleOnce(item);

    expect(result, isTrue);
    verify(() => repository.handleOnce(1)).called(1);
    verify(() => repository.searchCronjobsWithPreview(any())).called(1);
  });
}
