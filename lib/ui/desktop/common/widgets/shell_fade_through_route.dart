import 'package:flutter/material.dart';

/// Material Design 3 "Fade Through" transition used by the desktop
/// shell's inner `Navigator`.
///
/// A Fade Through consists of:
/// 1. The outgoing page fades out (no movement).
/// 2. The incoming page starts at 0% scale, fades in, and translates
///    upward by 8dp. (We approximate the scale-free MD3 spec with
///    just the fade + vertical offset, matching the more common
///    Fade Through variant used by the M3 catalog.)
///
/// Used by `openRouteRespectingShell` when pushing a sub-page into
/// the content area's inner `Navigator` so that the surrounding
/// sidebar / top toolbar stays stable while the content area
/// animates on its own.
class ShellFadeThroughPageRoute<T> extends PageRoute<T> {
  ShellFadeThroughPageRoute({
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    super.settings,
  });

  /// Builder for the page content.
  final WidgetBuilder builder;

  /// Total duration of the fade-through transition (forward and
  /// reverse). Defaults to 200ms, matching the M3 spec.
  final Duration duration;

  @override
  final bool opaque = true;

  @override
  final bool barrierDismissible = false;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => null;

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Builder(builder: builder);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Forward direction: 0 -> 1 means "page is being pushed in".
    // We reuse the same animation for both the fade and the offset
    // (with a slight ease-out curve) so the page slides up and fades
    // in together.
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic,
    );

    final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    final slideIn = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(curved);

    // Reverse the animation drives the outgoing page's fade-out only
    // (no scale or translation).
    final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: ReverseAnimation(animation),
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: fadeOut,
      child: FadeTransition(
        opacity: fadeIn,
        child: SlideTransition(
          position: slideIn,
          child: child,
        ),
      ),
    );
  }
}
