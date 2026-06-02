import 'package:onepanel_client/core/services/logger/logger_service.dart';

class PlatformDownloadTask {
  const PlatformDownloadTask({
    required this.id,
    required this.url,
    required this.savedDir,
    this.fileName,
    this.progress = 0,
    this.status = 'unknown',
  });

  final String id;
  final String url;
  final String savedDir;
  final String? fileName;
  final int progress;
  final String status;
}

abstract class PlatformDownloadService {
  Future<String?> enqueue({
    required String url,
    required String savedDir,
    String? fileName,
    Map<String, String>? headers,
  });

  Future<void> pause(String taskId);

  Future<void> resume(String taskId);

  Future<void> cancel(String taskId);

  Future<void> delete(String taskId);

  Future<List<PlatformDownloadTask>> listTasks();

  /// 1Panel download URLs embed time-limited auth tokens that can expire
  /// before large transfers complete; this re-enqueues with refreshed headers.
  Future<String?> retryWithFreshAuth({
    required PlatformDownloadTask task,
    required Map<String, String> headers,
  });
}

class UnsupportedPlatformDownloadService implements PlatformDownloadService {
  const UnsupportedPlatformDownloadService();

  @override
  Future<void> cancel(String taskId) async {}

  @override
  Future<void> delete(String taskId) async {}

  @override
  Future<String?> enqueue({
    required String url,
    required String savedDir,
    String? fileName,
    Map<String, String>? headers,
  }) async {
    appLogger.wWithPackage(
      'core.platform.download_service',
      'Platform downloader is not available on this host yet.',
    );
    return null;
  }

  @override
  Future<List<PlatformDownloadTask>> listTasks() async {
    return const <PlatformDownloadTask>[];
  }

  @override
  Future<void> pause(String taskId) async {}

  @override
  Future<String?> retryWithFreshAuth({
    required PlatformDownloadTask task,
    required Map<String, String> headers,
  }) async {
    return enqueue(
      url: task.url,
      savedDir: task.savedDir,
      fileName: task.fileName,
      headers: headers,
    );
  }

  @override
  Future<void> resume(String taskId) async {}
}
