import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:onepanel_client/core/config/release_channel_config.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/core/platform/services/ohos_platform_channel.dart';

class PlatformDiagnosticsService {
  PlatformDiagnosticsService({
    PlatformCapabilitiesSnapshot? capabilities,
    OhosPlatformChannel? ohosChannel,
  })  : _capabilities = capabilities ?? PlatformCapabilities.current(),
        _ohosChannel = ohosChannel ?? const OhosPlatformChannel();

  final PlatformCapabilitiesSnapshot _capabilities;
  final OhosPlatformChannel _ohosChannel;

  Future<Map<String, Object?>> collectRuntimeInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final info = <String, Object?>{
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': '${packageInfo.version}+${packageInfo.buildNumber}',
      'releaseChannel': AppReleaseChannelConfig.channelStorageValue,
      'targetPlatform': _capabilities.targetPlatform.name,
      'operatingSystem': _capabilities.operatingSystem,
      'isOhos': _capabilities.isOhos,
    };

    if (_capabilities.isOhos) {
      try {
        info.addAll(await _ohosChannel.getRuntimeInfo());
      } catch (_) {
        info['ohosRuntimeInfo'] = 'unavailable';
      }
    }

    return info;
  }

  /// Markdown template with `{{placeholder}}` markers, separated from the
  /// runtime-info interpolation logic so the template can be maintained
  /// independently (architecture review candidate ⑬).
  static const String _feedbackTemplate = '''
## 问题摘要
-

## 复现步骤
1.
2.
3.

## 预期行为
-

## 实际行为
-

## 日志与截图
-

## HarmonyOS / 构建信息
- app: {{appName}} {{version}}
- package: {{packageName}}
- channel: {{releaseChannel}}
- targetPlatform: {{targetPlatform}}
- operatingSystem: {{operatingSystem}}
- isOhos: {{isOhos}}
- device: {{deviceType}}
- osVersion: {{osVersion}}
- flutterOhosVersion: {{flutterOhosVersion}}
- hapCommit: {{hapCommit}}
- clearedBackgroundBeforeReopen: 是/否
''';

  Future<String> buildFeedbackTemplate() async {
    final info = await collectRuntimeInfo();
    return _feedbackTemplate
        .replaceAll('{{appName}}', info['appName']?.toString() ?? 'unknown')
        .replaceAll('{{version}}', info['version']?.toString() ?? 'unknown')
        .replaceAll(
            '{{packageName}}', info['packageName']?.toString() ?? 'unknown')
        .replaceAll('{{releaseChannel}}',
            info['releaseChannel']?.toString() ?? 'unknown')
        .replaceAll('{{targetPlatform}}',
            info['targetPlatform']?.toString() ?? 'unknown')
        .replaceAll('{{operatingSystem}}',
            info['operatingSystem']?.toString() ?? 'unknown')
        .replaceAll('{{isOhos}}', info['isOhos']?.toString() ?? 'false')
        .replaceAll(
            '{{deviceType}}', info['deviceType']?.toString() ?? 'unknown')
        .replaceAll('{{osVersion}}',
            (info['displayVersion'] ?? info['osFullName'] ?? 'unknown')
                .toString())
        .replaceAll('{{flutterOhosVersion}}',
            info['flutterOhosVersion']?.toString() ?? 'unknown')
        .replaceAll('{{hapCommit}}',
            info['hapCommit']?.toString() ?? '请填写构建提交哈希')
        .trim();
  }

  Future<void> copyFeedbackTemplate() async {
    await Clipboard.setData(
      ClipboardData(text: await buildFeedbackTemplate()),
    );
  }
}
