import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';

/// Coarse classification of the dominant input device the user is
/// working with. Used by shell-level affordances to decide between
/// pointer-driven (mouse + keyboard) and touch-driven layouts.
enum InputDeviceKind {
  /// Mouse + keyboard (or trackpad + keyboard). Default for desktop
  /// host platforms and for any host whose screen width is at least
  /// `tabletWidthBreakpoint`.
  pointer,

  /// Touch-first interaction. Default for phone- and tablet-form-factor
  /// devices.
  touch,
}

class PlatformUtils {
  // Material Design 3 canonical breakpoints: 600 compact/medium, 1024 medium/expanded
  static const double mobileWidthBreakpoint = 600.0;
  static const double tabletWidthBreakpoint = 1024.0;

  /// Whether the current platform is a desktop platform
  static bool get isDesktopPlatform {
    return PlatformCapabilities.current().isDesktopHost;
  }

  /// Whether the current platform is a mobile platform
  static bool get isMobilePlatform {
    return PlatformCapabilities.current().isMobileHost;
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

  /// Resolves the dominant input device kind for the current runtime.
  ///
  /// Rules:
  /// - Desktop host platforms (macOS / Windows / Linux / Linux) default
  ///   to [InputDeviceKind.pointer].
  /// - Mobile host platforms (iOS / Android / OHOS) default to
  ///   [InputDeviceKind.touch].
  /// - For the web build we fall back to screen width: smaller than
  ///   `tabletWidthBreakpoint` is `touch`, otherwise `pointer`.
  ///
  /// The classification is purely a hint used to switch between two
  /// shell-level affordance layers (a permanent `NavigationRail` vs a
  /// collapsible floating button + edge-swipe-back). It never changes
  /// the visual style — both layouts honour the active MDUI3 theme.
  static InputDeviceKind inputDeviceKinds(BuildContext context) {
    if (kIsWeb) {
      return MediaQuery.sizeOf(context).width >= tabletWidthBreakpoint
          ? InputDeviceKind.pointer
          : InputDeviceKind.touch;
    }
    if (isDesktopPlatform) {
      return InputDeviceKind.pointer;
    }
    return InputDeviceKind.touch;
  }

  // Specific Platforms based on TargetPlatform
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isOhos => PlatformCapabilities.current().isOhos;
}
