import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ui_target.dart';

class UiTargetResolver {
  const UiTargetResolver._();

  static const double _kTabletShortestSide = 600;
  static const double _kDesktopMinWidth = 1024;

  static UiTarget resolve(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shortestSide = size.shortestSide;
    final width = size.width;

    return resolveForTest(
      isWeb: kIsWeb,
      platform: defaultTargetPlatform,
      shortestSide: shortestSide,
      width: width,
    );
  }

  @visibleForTesting
  static UiTarget resolveForTest({
    required bool isWeb,
    required TargetPlatform platform,
    required double shortestSide,
    required double width,
  }) {
    if (isWeb) {
      final formFactor = _resolveWebFormFactor(
        shortestSide: shortestSide,
        width: width,
      );
      return UiTarget(
        platformKind: UiPlatformKind.web,
        formFactor: formFactor,
        tabletKind: formFactor == UiFormFactor.tablet
            ? TabletKind.webTablet
            : TabletKind.none,
      );
    }

    switch (platform.name) {
      case 'macOS':
        return const UiTarget(
          platformKind: UiPlatformKind.desktopMacos,
          formFactor: UiFormFactor.desktop,
        );
      case 'windows':
        return const UiTarget(
          platformKind: UiPlatformKind.desktopWindows,
          formFactor: UiFormFactor.desktop,
        );
      case 'linux':
        return const UiTarget(
          platformKind: UiPlatformKind.desktopLinux,
          formFactor: UiFormFactor.desktop,
        );
      case 'iOS':
        if (shortestSide >= _kTabletShortestSide) {
          return const UiTarget(
            platformKind: UiPlatformKind.mobile,
            formFactor: UiFormFactor.tablet,
            tabletKind: TabletKind.ipad,
          );
        }
        return const UiTarget(
          platformKind: UiPlatformKind.mobile,
          formFactor: UiFormFactor.phone,
        );
      case 'android':
        if (shortestSide >= _kTabletShortestSide) {
          return const UiTarget(
            platformKind: UiPlatformKind.mobile,
            formFactor: UiFormFactor.tablet,
            tabletKind: TabletKind.androidPad,
          );
        }
        return const UiTarget(
          platformKind: UiPlatformKind.mobile,
          formFactor: UiFormFactor.phone,
        );
      case 'fuchsia':
      case 'ohos':
      default:
        // Placeholder mapping for future HarmonyOS family support.
        if (shortestSide >= _kTabletShortestSide) {
          return const UiTarget(
            platformKind: UiPlatformKind.harmony,
            formFactor: UiFormFactor.tablet,
            tabletKind: TabletKind.harmonyPad,
          );
        }
        return const UiTarget(
          platformKind: UiPlatformKind.harmony,
          formFactor: UiFormFactor.phone,
        );
    }
  }

  static UiFormFactor _resolveWebFormFactor({
    required double shortestSide,
    required double width,
  }) {
    if (width >= _kDesktopMinWidth) {
      return UiFormFactor.desktop;
    }
    if (shortestSide >= _kTabletShortestSide) {
      return UiFormFactor.tablet;
    }
    return UiFormFactor.phone;
  }
}
