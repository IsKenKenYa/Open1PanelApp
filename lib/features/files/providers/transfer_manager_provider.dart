import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/core/presentation/safe_change_notifier.dart';
import 'package:onepanel_client/core/services/transfer/transfer_manager.dart';

enum TransferChannel { downloads, uploads }

class TransferManagerProvider extends ChangeNotifier with SafeChangeNotifier {
  TransferManagerProvider({
    TransferManager? transferManager,
    Future<List<DownloadTask>?> Function()? loadTasksOverride,
    Future<void> Function()? clearCompletedOverride,
    PlatformCapabilitiesSnapshot? capabilities,
  })  : _transferManager = transferManager ?? TransferManager(),
        _loadTasksOverride = loadTasksOverride,
        _clearCompletedOverride = clearCompletedOverride,
        _capabilities = capabilities ?? PlatformCapabilities.current();

  final TransferManager _transferManager;
  final Future<List<DownloadTask>?> Function()? _loadTasksOverride;
  final Future<void> Function()? _clearCompletedOverride;
  final PlatformCapabilitiesSnapshot _capabilities;

  TransferChannel _channel = TransferChannel.downloads;
  List<DownloadTask>? _downloadTasks;
  bool _isLoading = true;
  Timer? _refreshTimer;

  TransferChannel get channel => _channel;
  List<DownloadTask>? get downloadTasks => _downloadTasks;
  bool get isLoading => _isLoading;
  bool get isBackgroundDownloadSupported =>
      _capabilities.supportsBackgroundDownloader;
  String? get unsupportedReason => isBackgroundDownloadSupported
      ? null
      : 'transferBackgroundDownloadUnsupported';

  Future<void> initialize() async {
    if (!isBackgroundDownloadSupported) {
      _downloadTasks = const <DownloadTask>[];
      _isLoading = false;
      notifyListeners();
      return;
    }
    await loadTasks();
    _startAutoRefresh();
  }

  void setChannel(TransferChannel channel) {
    _channel = channel;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    if (!isBackgroundDownloadSupported) {
      _downloadTasks = const <DownloadTask>[];
      _isLoading = false;
      notifyListeners();
      return;
    }
    final tasks = await (_loadTasksOverride?.call() ??
        _transferManager.getDownloaderTasks());
    _downloadTasks = tasks;
    _isLoading = false;
    notifyListeners();
  }

  List<DownloadTask> getActiveDownloads() {
    if (_downloadTasks == null) return const <DownloadTask>[];
    return _downloadTasks!
        .where(
          (task) =>
              task.status == DownloadTaskStatus.running ||
              task.status == DownloadTaskStatus.paused ||
              task.status == DownloadTaskStatus.enqueued ||
              task.status == DownloadTaskStatus.undefined ||
              (task.status == DownloadTaskStatus.failed &&
                  task.progress != 100),
        )
        .toList(growable: false);
  }

  List<DownloadTask> getCompletedDownloads() {
    if (_downloadTasks == null) return const <DownloadTask>[];
    return _downloadTasks!
        .where(
          (task) =>
              task.status == DownloadTaskStatus.complete ||
              task.status == DownloadTaskStatus.canceled ||
              (task.status == DownloadTaskStatus.failed &&
                  task.progress == 100),
        )
        .toList(growable: false);
  }

  Future<void> clearCompletedDownloads() async {
    if (!isBackgroundDownloadSupported) {
      return;
    }
    if (_clearCompletedOverride != null) {
      await _clearCompletedOverride.call();
    } else {
      await _transferManager.clearCompleted();
    }
    await loadTasks();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      loadTasks();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
