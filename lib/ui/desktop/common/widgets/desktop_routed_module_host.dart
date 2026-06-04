import 'package:flutter/material.dart';
import 'package:onepanel_client/config/app_router.dart';

/// Hosts a route-driven module page inside desktop shell content.
///
/// This keeps desktop navigation inside a single shell while reusing
/// existing route builders and provider wiring from [AppRouter].
class DesktopRoutedModuleHost extends StatelessWidget {
  const DesktopRoutedModuleHost({
    super.key,
    required this.routeName,
    this.routeArguments,
  }) : assert(routeName != AppRoutes.home);

  final String routeName;
  final Object? routeArguments;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      // Use `generateEmbeddedRoute` (not `generateRoute`) so the inner
      // Navigator resolves the route via its `defaultBuilder` instead
      // of the desktop platform override. The override would push a
      // new `UiRouteHost` wrapping `MacosShellContentPage`, which then
      // renders *another* `DesktopRoutedModuleHost` for the same route
      // — stack overflow at `FocusNode.descendants` after a few
      // hundred frames. The outer `desktopBuilder` already hosted
      // us in the shell; we just need to render the actual page here.
      onGenerateRoute: AppRouter.generateEmbeddedRoute,
      onGenerateInitialRoutes: (_, __) {
        return [
          AppRouter.generateEmbeddedRoute(
            RouteSettings(name: routeName, arguments: routeArguments),
          ),
        ];
      },
    );
  }
}
