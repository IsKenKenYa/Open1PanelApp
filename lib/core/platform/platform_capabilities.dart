import 'dart:io' as io;

import 'package:flutter/foundation.dart';

@immutable
class PlatformCapabilitiesSnapshot {
  const PlatformCapabilitiesSnapshot({
    required this.isWeb,
    required this.targetPlatform,
    required this.operatingSystem,
  });

  final bool isWeb;
  final TargetPlatform targetPlatform;
  final String? operatingSystem;

  String get _normalizedOperatingSystem =>
      operatingSystem?.toLowerCase().trim() ?? '';

  bool get isOhos {
    if (isWeb) {
      return false;
    }
    if (targetPlatform.name == 'ohos') {
      return true;
    }
    return targetPlatform == TargetPlatform.android &&
        (_normalizedOperatingSystem.contains('ohos') ||
            _normalizedOperatingSystem.contains('harmony'));
  }

  bool get isDesktopHost {
    if (isWeb) {
      return false;
    }
    switch (targetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  bool get isMobileHost {
    if (isWeb) {
      return false;
    }
    return isOhos ||
        targetPlatform == TargetPlatform.android ||
        targetPlatform == TargetPlatform.iOS;
  }

  bool get supportsSecureStorage => !isWeb;

  bool get supportsBackgroundDownloader =>
      !isWeb && targetPlatform == TargetPlatform.android && !isOhos;

  bool get supportsOpenDownloadedFile => !isWeb && !isOhos;

  bool get supportsAndroidIntent =>
      !isWeb && targetPlatform == TargetPlatform.android && !isOhos;

  bool get supportsPasskeys {
    if (isWeb) {
      return true;
    }
    switch (targetPlatform) {
      case TargetPlatform.android:
        return !isOhos;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}

class PlatformCapabilities {
  const PlatformCapabilities._();

  static PlatformCapabilitiesSnapshot current() {
    return resolveForTest(
      isWeb: kIsWeb,
      targetPlatform: defaultTargetPlatform,
      operatingSystem: _readOperatingSystem(),
    );
  }

  @visibleForTesting
  static PlatformCapabilitiesSnapshot resolveForTest({
    required bool isWeb,
    required TargetPlatform targetPlatform,
    required String? operatingSystem,
  }) {
    return PlatformCapabilitiesSnapshot(
      isWeb: isWeb,
      targetPlatform: targetPlatform,
      operatingSystem: operatingSystem,
    );
  }

  static String? _readOperatingSystem() {
    if (kIsWeb) {
      return null;
    }
    try {
      return io.Platform.operatingSystem;
    } catch (_) {
      return null;
    }
  }
}
