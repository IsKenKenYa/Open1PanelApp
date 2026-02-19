enum WgetDownloadState {
  idle,
  downloading,
  success,
  error,
}

class WgetDownloadStatus {
  final WgetDownloadState state;
  final String? message;
  final String? filePath;
  final int? downloadedSize;

  const WgetDownloadStatus({
    this.state = WgetDownloadState.idle,
    this.message,
    this.filePath,
    this.downloadedSize,
  });

  WgetDownloadStatus copyWith({
    WgetDownloadState? state,
    String? message,
    String? filePath,
    int? downloadedSize,
  }) {
    return WgetDownloadStatus(
      state: state ?? this.state,
      message: message ?? this.message,
      filePath: filePath ?? this.filePath,
      downloadedSize: downloadedSize ?? this.downloadedSize,
    );
  }
}
