import 'package:flutter/foundation.dart';
import 'package:onepanel_client/core/presentation/safe_change_notifier.dart';
import 'package:onepanel_client/data/models/container_models.dart';
import 'package:onepanel_client/features/orchestration/services/orchestration_service.dart';

/// 编排模版状态管理。
/// 对齐 1Panel 前端 `container/template/index.vue`：列表、创建、编辑、删除。
class ComposeTemplateProvider extends ChangeNotifier with SafeChangeNotifier {
  ComposeTemplateProvider({OrchestrationService? service})
      : _service = service ?? OrchestrationService();

  final OrchestrationService _service;

  List<ContainerTemplate> _templates = [];
  bool _isLoading = false;
  String? _error;

  List<ContainerTemplate> get templates => _templates;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTemplates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _templates = await _service.loadTemplates();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTemplate(ContainerTemplateOperate request) async {
    try {
      await _service.createTemplate(request);
      await loadTemplates();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTemplate(ContainerTemplateOperate request) async {
    try {
      await _service.updateTemplate(request);
      await loadTemplates();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTemplates(List<int> ids) async {
    try {
      await _service.deleteTemplates(ids);
      await loadTemplates();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
