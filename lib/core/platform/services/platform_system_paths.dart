import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/core/platform/services/ohos_platform_channel.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';

/// Cross-platform abstraction for "where is the system's download directory?".
///
/// Replaces the previous reliance on `path_provider.getDownloadsDirectory()`,
/// which is only implemented on macOS and throws `Unsupported operation` on
/// every other platform (causing the OHOS download crash).
///
/// The result is always a real filesystem path the app can read/write to.
/// When the underlying platform exposes a public Downloads folder the result
/// maps to that folder; otherwise it falls back to the app's sandbox
/// (ApplicationDocumentsDirectory for mobile, env var for desktop).
@immutable
class PlatformSystemPaths {
  const PlatformSystemPaths._();

  /// Hook for tests. Production code never sets this; tests inject a stub.
  @visibleForTesting
  static ResolverFn? testResolver;

  /// Optional MethodChannel override for tests. Production uses
  /// [OhosPlatformChannel] default.
  @visibleForTesting
  static OhosPlatformChannel? testOhosChannel;

  /// Optional platform capabilities override. Production uses
  /// [PlatformCapabilities.current()]; tests inject a snapshot to force
  /// a particular branch (e.g. OHOS, Android, macOS).
  @visibleForTesting
  static PlatformCapabilitiesSnapshot? testCapabilities;

  /// Resolves the "system download directory" for the current platform.
  ///
  /// Returns a real filesystem path (with the directory created if missing).
  /// Returns `null` only when resolution fails irrecoverably (e.g. the OHOS
  /// channel call throws); callers must fall back to
  /// [getApplicationDocumentsDirectory].
  static Future<io.Directory?> defaultDownloadDir() async {
    if (testResolver != null) {
      return testResolver!();
    }

    final capabilities = testCapabilities ?? PlatformCapabilities.current();

    // OHOS: ask the native side. The OHOS app sandbox does not expose a
    // public Downloads path to the user, so the native side maps to its
    // own "Files/Downloads/..." location backed by `filesDir/...`.
    if (capabilities.isOhos) {
      final channel = testOhosChannel ?? const OhosPlatformChannel();
      try {
        final result = await channel.getPublicDownloadDir();
        final path = result['path'] as String?;
        if (path == null || path.isEmpty) {
          return null;
        }
        final dir = io.Directory(path);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        return dir;
      } catch (error, stackTrace) {
        appLogger.wWithPackage(
          'core.platform.system_paths',
          'OHOS getPublicDownloadDir failed, falling back to documents dir',
          error: error,
          stackTrace: stackTrace,
        );
        return null;
      }
    }

    if (capabilities.targetPlatform == TargetPlatform.android) {
      // Private external storage does not require READ/WRITE_EXTERNAL_STORAGE
      // on modern Android and survives scoped storage. `/Download` is the
      // well-known public location; the app's external root is a safe
      // fallback when the public folder is unmounted (e.g. removable SD).
      final publicDir = io.Directory('/storage/emulated/0/Download');
      if (await publicDir.exists()) {
        return publicDir;
      }
      try {
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          return extDir;
        }
      } catch (error, stackTrace) {
        // getExternalStorageDirectory throws on non-Android platforms
        // (e.g. when running tests on the host VM). Swallow and fall
        // through to the documents-directory fallback below.
        appLogger.wWithPackage(
          'core.platform.system_paths',
          'getExternalStorageDirectory unavailable on this platform',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return null;
    }

    if (capabilities.targetPlatform == TargetPlatform.iOS) {
      // iOS apps do not have access to a public Downloads folder outside the
      // sandbox; users retrieve files through the Files app via
      // `UIDocumentPickerViewController` in the picker path.
      final docs = await getApplicationDocumentsDirectory();
      return io.Directory('${docs.path}/Downloads');
    }

    if (capabilities.targetPlatform == TargetPlatform.macOS) {
      final home = io.Platform.environment['HOME'];
      if (home == null || home.isEmpty) {
        return null;
      }
      return io.Directory('$home/Downloads');
    }

    if (capabilities.targetPlatform == TargetPlatform.windows) {
      // Use USERPROFILE rather than USERPROFILE\Downloads via shell expansion
      // — path_provider is unreliable on Windows for `getDownloadsDirectory`.
      final userProfile = io.Platform.environment['USERPROFILE'];
      if (userProfile == null || userProfile.isEmpty) {
        return null;
      }
      return io.Directory('$userProfile\\Downloads');
    }

    if (capabilities.targetPlatform == TargetPlatform.linux) {
      // XDG_DOWNLOAD_DIR is set by the freedesktop user-dirs spec; fall back
      // to $HOME/Downloads when missing.
      final xdg = io.Platform.environment['XDG_DOWNLOAD_DIR'];
      if (xdg != null && xdg.isNotEmpty) {
        return io.Directory(xdg);
      }
      final home = io.Platform.environment['HOME'];
      if (home == null || home.isEmpty) {
        return null;
      }
      return io.Directory('$home/Downloads');
    }

    return null;
  }

  /// Compose `<downloads>/<subDir>/<file>` with auto-creation of
  /// intermediate directories. When [subDir] is empty or null, returns
  /// `<downloads>/<file>`. Returns `null` if [defaultDownloadDir] fails
  /// and there is no fallback available.
  static Future<io.File?> resolveFilePath({
    required String fileName,
    String? subDir,
  }) async {
    final base = await defaultDownloadDir();
    if (base == null) {
      return null;
    }
    final segments = <String>[base.path];
    if (subDir != null && subDir.trim().isNotEmpty) {
      segments.add(subDir.trim());
    }
    final directory = io.Directory(segments.join(io.Platform.pathSeparator));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return io.File(
      '${directory.path}${io.Platform.pathSeparator}$fileName',
    );
  }
}

/// Resolver function used by tests. Returns a directory or null.
typedef ResolverFn = Future<io.Directory?> Function();
