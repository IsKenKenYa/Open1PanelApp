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

  Future<String> buildFeedbackTemplate() async {
    final info = await collectRuntimeInfo();
    return '''
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
- app: ${info['appName']} ${info['version']}
- package: ${info['packageName']}
- channel: ${info['releaseChannel']}
- targetPlatform: ${info['targetPlatform']}
- operatingSystem: ${info['operatingSystem']}
- isOhos: ${info['isOhos']}
- device: ${info['deviceType'] ?? 'unknown'}
- osVersion: ${info['displayVersion'] ?? info['osFullName'] ?? 'unknown'}
- flutterOhosVersion: ${info['flutterOhosVersion'] ?? 'unknown'}
- hapCommit: ${info['hapCommit'] ?? '请填写构建提交哈希'}
- clearedBackgroundBeforeReopen: 是/否
'''
        .trim();
  }

  Future<void> copyFeedbackTemplate() async {
    await Clipboard.setData(
      ClipboardData(text: await buildFeedbackTemplate()),
    );
  }
}
