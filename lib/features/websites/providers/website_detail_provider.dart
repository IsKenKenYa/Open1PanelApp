import 'package:flutter/foundation.dart';
import 'package:onepanel_client/core/presentation/safe_change_notifier.dart';

import '../../../data/models/website_models.dart';
import '../../../data/repositories/website_repository.dart';

class WebsiteDetailProvider extends ChangeNotifier with SafeChangeNotifier {
  final int websiteId;
  final WebsiteRepository _repository;

  WebsiteDetailProvider({
    required this.websiteId,
    WebsiteRepository? repository,
  }) : _repository = repository ?? WebsiteRepository();

  bool isLoading = false;
  String? error;
  WebsiteInfo? website;

  Future<void> loadDetail() async {
    if (isDisposed) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      website = await _repository.getWebsiteDetail(websiteId);
      // Guard against notifying a disposed listener after the async gap.
      if (isDisposed) return;
    } catch (e) {
      if (!isDisposed) {
        error = e.toString();
      }
    } finally {
      if (!isDisposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> operate(String action) async {
    if (isDisposed) return;
    await _repository.operateWebsite(websiteId: websiteId, action: action);
    await loadDetail();
  }

  Future<void> setDefaultServer() async {
    if (isDisposed) return;
    await _repository.changeDefaultServer(id: websiteId);
    await loadDetail();
  }

  Future<void> deleteWebsite() async {
    if (isDisposed) return;
    await _repository.deleteWebsite(websiteId);
  }
}
