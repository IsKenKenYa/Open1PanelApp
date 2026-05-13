import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';

void main() {
  test('detects OHOS from Android target platform and operating system', () {
    final snapshot = PlatformCapabilities.resolveForTest(
      isWeb: false,
      targetPlatform: TargetPlatform.android,
      operatingSystem: 'OHOS',
    );

    expect(snapshot.isOhos, isTrue);
    expect(snapshot.supportsBackgroundDownloader, isFalse);
    expect(snapshot.supportsOpenDownloadedFile, isFalse);
    expect(snapshot.supportsPasskeys, isFalse);
  });

  test('keeps Android capabilities enabled for non-OHOS hosts', () {
    final snapshot = PlatformCapabilities.resolveForTest(
      isWeb: false,
      targetPlatform: TargetPlatform.android,
      operatingSystem: 'android',
    );

    expect(snapshot.isOhos, isFalse);
    expect(snapshot.supportsBackgroundDownloader, isTrue);
    expect(snapshot.supportsOpenDownloadedFile, isTrue);
    expect(snapshot.supportsPasskeys, isTrue);
  });
}
