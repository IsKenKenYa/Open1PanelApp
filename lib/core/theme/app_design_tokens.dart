import 'package:flutter/material.dart';

class AppDesignTokens {
  const AppDesignTokens._();

  static const double radiusSm = 10;
  static const double radiusMd = 14;
  static const double radiusLg = 20;

  /// M3 Expressive 大圆角：bottom sheet / dialog / 大型容器。
  static const double radiusXl = 28;

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;

  static const Duration motionFast = Duration(milliseconds: 150);
  static const Duration motionNormal = Duration(milliseconds: 240);

  /// M3 Expressive emphasized easing（Flutter 内置 emphasized 曲线）。
  static const Curve motionEmphasized = Curves.easeInOutCubicEmphasized;
  static const Curve motionStandard = Easing.standard;

  static const Color brand = Color(0xFF0C9B4B);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: spacingLg,
    vertical: spacingLg,
  );
}
