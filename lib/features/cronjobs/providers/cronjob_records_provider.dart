import 'package:flutter/foundation.dart';
import 'package:onepanel_client/core/presentation/safe_change_notifier.dart';
import 'package:onepanel_client/core/presentation/async_state_notifier.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';
import 'package:onepanel_client/data/models/cronjob_record_models.dart';
import 'package:onepanel_client/data/repositories/cronjob_repository.dart';

class CronjobRecordsProvider extends ChangeNotifier with SafeChangeNotifier, AsyncStateNotifier {
  CronjobRecordsProvider({
    CronjobRepository? repository,
  }) : _repository = repository ?? CronjobRepository();

  final CronjobRepository _repository;

  int? _cronjobId;
  List<CronjobRecordInfo> _items = const <CronjobRecordInfo>[];
  String _statusFilter = '';
  bool _isMutating = false;
  int? _selectedRecordId;
  String _selectedLog = '';

  List<CronjobRecordInfo> get items => _items;
  String get statusFilter => _statusFilter;
  bool get isMutating => _isMutating;
  int? get selectedRecordId => _selectedRecordId;
  String get selectedLog => _selectedLog;

  Future<void> load(int cronjobId) async {
    _cronjobId = cronjobId;
    setLoading();
    try {
      final result = await _repository.searchRecords(
        CronjobRecordQuery(
          cronjobId: cronjobId,
          status: _statusFilter,
        ),
      );
      _items = result.items;
      setSuccess(isEmpty: _items.isEmpty);
    } catch (error, stackTrace) {
      appLogger.eWithPackage(
        'features.cronjobs.providers.records',
        'load failed',
        error: error,
        stackTrace: stackTrace,
      );
      _items = const <CronjobRecordInfo>[];
      setError(error);
    }
  }

  Future<void> updateStatusFilter(String status) async {
    _statusFilter = status;
    final cronjobId = _cronjobId;
    if (cronjobId != null) {
      await load(cronjobId);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadRecordLog(int id) async {
    try {
      _selectedRecordId = id;
      _selectedLog = await _repository.loadRecordLog(id);
      notifyListeners();
    } catch (error, stackTrace) {
      appLogger.eWithPackage(
        'features.cronjobs.providers.records',
        'loadRecordLog failed',
        error: error,
        stackTrace: stackTrace,
      );
      setError(error);
    }
  }

  Future<bool> cleanRecords({
    required bool cleanData,
    required bool cleanRemoteData,
  }) async {
    final cronjobId = _cronjobId;
    if (cronjobId == null) return false;
    _isMutating = true;
    clearError(notify: false);
    notifyListeners();
    try {
      await _repository.cleanRecords(
        CronjobRecordCleanRequest(
          cronjobId: cronjobId,
          cleanData: cleanData,
          cleanRemoteData: cleanRemoteData,
        ),
      );
      await load(cronjobId);
      return true;
    } catch (error, stackTrace) {
      appLogger.eWithPackage(
        'features.cronjobs.providers.records',
        'cleanRecords failed',
        error: error,
        stackTrace: stackTrace,
      );
      setError(error, notify: false);
      return false;
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }
}
