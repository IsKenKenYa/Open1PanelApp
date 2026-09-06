import 'dart:io';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';

/// WinUI3 原生宿主(headless 引擎)与 Flutter runner 的数据目录对齐。
///
/// headless 引擎寄生在 OnePanelNativeHost.exe 进程内，path_provider 按该 exe
/// 的 VERSIONINFO 派生应用支持目录，与 Flutter runner（IsKenKenYa\1Panel
/// Client）不一致，导致服务器配置等数据读不到。此处在 host 激活时把
/// PathProviderPlatform 的支持目录显式对齐到 runner 目录——常量与
/// windows/runner/render_mode_bootstrap.cpp 的 kCompanyName 同源。
class RunnerDataPath {
  const RunnerDataPath._();

  static const String _companyName = 'IsKenKenYa';
  static const String _productName = '1Panel Client';

  /// 解析 Flutter runner 的应用支持目录；[appDataDir] 缺失时返回 null。
  static String? resolveRunnerSupportDirectory({String? appDataDir}) {
    if (appDataDir == null || appDataDir.isEmpty) {
      return null;
    }
    return [
      appDataDir,
      _companyName,
      _productName,
    ].join(Platform.pathSeparator);
  }

  /// 把所有已知的路径提供方对齐到 [supportPath]：
  /// - PathProviderPlatform.instance（path_provider/Hive 等消费）
  /// - SharedPreferencesWindows.pathProvider（其内部直接实例化，须单独覆盖）
  static void alignAllPathProviders({
    required PathProviderPlatform fallback,
    required String supportPath,
    SharedPreferencesStorePlatform? store,
  }) {
    PathProviderPlatform.instance = RunnerAlignedPathProvider(
      fallback: fallback,
      supportPath: supportPath,
    );
    final target = store ?? SharedPreferencesStorePlatform.instance;
    if (target is SharedPreferencesWindows) {
      target.pathProvider = _FixedSupportPathWindows(supportPath);
    }
  }
}

/// 仅覆盖应用支持目录，其余路径查询委托原有实现。
/// PlatformInterface 约定必须 extends（implements 会被运行时防护拒绝），
/// 未覆盖的成员经 noSuchMethod 转发 fallback。
class RunnerAlignedPathProvider extends PathProviderPlatform {
  RunnerAlignedPathProvider({
    required PathProviderPlatform fallback,
    required String supportPath,
  })  : _fallback = fallback,
        _supportPath = supportPath;

  final PathProviderPlatform _fallback;
  final String _supportPath;

  // base 的各路径方法有默认实现（抛 UnimplementedError），须逐个转发。
  @override
  Future<String?> getApplicationSupportPath() async => _supportPath;

  @override
  Future<String?> getTemporaryPath() => _fallback.getTemporaryPath();

  @override
  Future<String?> getLibraryPath() => _fallback.getLibraryPath();

  @override
  Future<String?> getApplicationDocumentsPath() =>
      _fallback.getApplicationDocumentsPath();

  @override
  Future<String?> getApplicationCachePath() =>
      _fallback.getApplicationCachePath();

  @override
  Future<String?> getExternalStoragePath() =>
      _fallback.getExternalStoragePath();

  @override
  Future<List<String>?> getExternalCachePaths() =>
      _fallback.getExternalCachePaths();

  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) =>
      _fallback.getExternalStoragePaths(type: type);

  @override
  Future<String?> getDownloadsPath() => _fallback.getDownloadsPath();
}

class _FixedSupportPathWindows extends PathProviderWindows {
  _FixedSupportPathWindows(this._supportPath);

  final String _supportPath;

  @override
  Future<String?> getApplicationSupportPath() async => _supportPath;
}
