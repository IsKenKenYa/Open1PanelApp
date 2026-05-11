import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformUtils {
  // Constants for screen breakpoints
  static const double mobileWidthBreakpoint = 600.0;
  static const double tabletWidthBreakpoint = 1024.0;

  /// Whether the current platform is a desktop platform
  static bool get isDesktopPlatform {
    switch (defaultTargetPlatform.name) {
      case 'macOS':
      case 'windows':
      case 'linux':
        return true;
      case 'android':
      case 'iOS':
      case 'fuchsia':
      case 'ohos':
      default:
        return false;
    }
  }

  /// Whether the current platform is a mobile platform
  static bool get isMobilePlatform {
    switch (defaultTargetPlatform.name) {
      case 'android':
      case 'iOS':
      case 'ohos':
        return true;
      case 'macOS':
      case 'windows':
      case 'linux':
      case 'fuchsia':
      default:
        return false;
    }
  }

  /// Whether the device form factor is considered Desktop
  static bool isDesktop(BuildContext context) {
    if (kIsWeb) {
      return MediaQuery.sizeOf(context).width >= tabletWidthBreakpoint;
    }
    if (isDesktopPlatform) {
      return true;
    }
    // Fallback based on screen width for tablets behaving as desktop
    return MediaQuery.sizeOf(context).width >= tabletWidthBreakpoint;
  }

  /// Whether the device form factor is considered Tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileWidthBreakpoint && width < tabletWidthBreakpoint;
  }

  /// Whether the device form factor is considered Mobile
  static bool isMobile(BuildContext context) {
    if (kIsWeb) {
      return MediaQuery.sizeOf(context).width < mobileWidthBreakpoint;
    }
    if (isMobilePlatform) {
      return MediaQuery.sizeOf(context).width < mobileWidthBreakpoint;
    }
    return MediaQuery.sizeOf(context).width < mobileWidthBreakpoint;
  }

  // Specific Platforms based on TargetPlatform
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
}
