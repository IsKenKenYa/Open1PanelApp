import 'package:onepanel_client/api/v2/cronjob_v2.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/cronjob_form_request_models.dart';
import 'package:onepanel_client/data/models/cronjob_list_models.dart';
import 'package:onepanel_client/data/models/cronjob_record_models.dart';
import 'package:onepanel_client/data/models/system_group_models.dart';
import 'package:onepanel_client/features/group/services/group_service.dart';

class CronjobRepository {
  CronjobRepository({
    ApiClientManager? clientManager,
    CronjobV2Api? api,
    GroupService? groupService,
  })  : _clientManager = clientManager ?? ApiClientManager.instance,
        _api = api,
        _groupService = groupService ?? GroupService();

  final ApiClientManager _clientManager;
  CronjobV2Api? _api;
  final GroupService _groupService;

  Future<CronjobV2Api> _ensureApi() async {
    return _api ??= await _clientManager.getCronjobApi();
  }

  Future<List<GroupInfo>> loadGroups({bool forceRefresh = false}) {
    return _groupService.listGroups('cronjob', forceRefresh: forceRefresh);
  }

  Future<PageResult<CronjobSummary>> searchCronjobs(
    CronjobListQuery request,
  ) async {
    final api = await _ensureApi();
    final response = await api.searchCronjobs(request);
    return response.data ??
        const PageResult<CronjobSummary>(items: <CronjobSummary>[], total: 0);
  }

  /// Searches cronjobs and enriches each item with a [nextHandlePreview]
  /// when its spec is non-empty. This absorbs the orchestration that
  /// previously lived in `CronjobService` so the service layer is no longer
  /// a shallow pass-through.
  Future<PageResult<CronjobSummary>> searchCronjobsWithPreview(
    CronjobListQuery request,
  ) async {
    final result = await searchCronjobs(request);
    if (result.items.isEmpty) return result;
    final items =
        await Future.wait(result.items.map((CronjobSummary item) async {
      if (item.spec.isEmpty) return item;
      final nextHandles = await loadNextHandle(item.spec);
      return item.copyWith(
        nextHandlePreview: nextHandles.isEmpty ? null : nextHandles.first,
      );
    }));
    return PageResult<CronjobSummary>(
      items: items,
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
      totalPages: result.totalPages,
    );
  }

  Future<List<String>> loadNextHandle(String spec) async {
    final api = await _ensureApi();
    final response =
        await api.loadNextHandle(CronjobNextPreviewRequest(spec: spec));
    return response.data ?? const <String>[];
  }

  Future<void> updateStatus(CronjobStatusUpdate request) async {
    final api = await _ensureApi();
    await api.updateCronjobStatus(request);
  }

  Future<void> handleOnce(int id) async {
    final api = await _ensureApi();
    await api.handleCronjobOnce(CronjobHandleRequest(id: id));
  }

  Future<void> stop(int id) async {
    final api = await _ensureApi();
    await api.stopCronjob(id);
  }

  Future<void> delete(CronjobBatchDeleteRequest request) async {
    final api = await _ensureApi();
    await api.deleteCronjob(request);
  }

  /// Convenience wrapper for single-cronjob deletion, preserving the
  /// `cleanData` / `cleanRemoteData` flags previously exposed by
  /// `CronjobService.delete`.
  Future<void> deleteById(
    int id, {
    bool cleanData = false,
    bool cleanRemoteData = false,
  }) {
    return delete(CronjobBatchDeleteRequest(
      ids: <int>[id],
      cleanData: cleanData,
      cleanRemoteData: cleanRemoteData,
    ));
  }

  Future<PageResult<CronjobRecordInfo>> searchRecords(
    CronjobRecordQuery request,
  ) async {
    final api = await _ensureApi();
    final response = await api.searchCronjobRecords(request);
    return response.data ??
        const PageResult<CronjobRecordInfo>(
          items: <CronjobRecordInfo>[],
          total: 0,
        );
  }

  Future<String> loadRecordLog(int id) async {
    final api = await _ensureApi();
    final response = await api.getRecordLog(id);
    return response.data ?? '';
  }

  Future<void> cleanRecords(CronjobRecordCleanRequest request) async {
    final api = await _ensureApi();
    await api.cleanRecords(request);
  }

  Future<List<CronjobScriptOption>> loadScriptOptions() async {
    final api = await _ensureApi();
    final response = await api.getScriptOptions();
    return response.data ?? const <CronjobScriptOption>[];
  }
}
