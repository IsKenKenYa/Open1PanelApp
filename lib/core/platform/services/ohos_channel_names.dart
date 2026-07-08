/// Centralized channel name constants for OHOS platform bridges.
///
/// Keeping channel names in a single source prevents drift between the
/// ArkTS registrant, [OhosPlatformChannel], [OhosDownloadService], and any
/// business-layer callers. Renaming a channel only needs to happen here.
class OhosChannelNames {
  const OhosChannelNames._();

  /// General platform-bridge channel (runtime info, file pickers, save).
  static const String ohosPlatform = 'onepanel/ohos_platform';

  /// Download command channel (enqueue/pause/resume/cancel).
  static const String ohosDownload = 'onepanel/ohos_download';

  /// Download progress event channel (real-time bytesReceived/totalBytes).
  static const String ohosDownloadProgress = 'onepanel/ohos_download_progress';
}
