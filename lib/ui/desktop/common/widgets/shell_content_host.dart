import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/features/shell/module_page_factory.dart';
import 'package:onepanel_client/features/shell/models/client_module.dart';
import 'package:onepanel_client/features/shell/widgets/no_server_selected_state.dart';
import 'package:onepanel_client/ui/desktop/common/widgets/desktop_routed_module_host.dart';

/// Container widget for the desktop/tablet shell's right content area.
///
/// Hosts a permanently-mounted inner `Navigator` so that:
/// - Opening a sub-page (e.g. `Settings → Language`) only animates the
///   content area; the surrounding `NavigationRail` / `AppBar` stay
///   stable.
/// - The system back gesture first pops the inner stack before falling
///   through to the outer shell.
///
/// This widget is shared by `MacosShellContentPage`,
/// `WindowsShellContentPage`, `DesktopShellPage` (and the tablet shell
/// when present) so all desktop/tablet form factors use a single
/// `ShellContentHost` tree.
///
/// When the same parent switches between modules (e.g. user clicks a
/// different item in the sidebar), the parent is expected to keep this
/// widget alive for each previously-visited module — either by
/// `IndexedStack` with a per-module `KeyedSubtree` key, or by handing
/// the same `key` through from the parent's state. That way each
/// module's inner stack survives the switch.
class ShellContentHost extends StatefulWidget {
  ShellContentHost({
    super.key,
    required this.module,
    required this.serverId,
    this.embeddedRoute,
    this.embeddedRouteArguments,
  });

  final ClientModule module;
  final String? serverId;
  final String? embeddedRoute;
  final Object? embeddedRouteArguments;

  /// Per-instance key for the inner `Navigator`. We deliberately keep
  /// it as a per-instance `GlobalKey` (rather than a single static
  /// shared by every `ShellContentHost` in the tree) because the
  /// outer `DesktopContentHost` mounts *all* module hosts at once via
  /// `IndexedStack`. Sharing a `GlobalKey` across multiple mounted
  /// widgets triggers Flutter's key-uniqueness assertion and — in
  /// release mode — silently corrupts the inner `Navigator` state,
  /// which is what was causing "page content lost" when the user
  /// switched between several top-level modules.
  final GlobalKey<NavigatorState> _innerNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'ShellContentHostNavigator');

  @override
  State<ShellContentHost> createState() => ShellContentHostState();
}

/// Public State for [ShellContentHost] so that navigation helpers can
/// locate the inner `Navigator` of the *current* module (whichever
/// `ShellContentHost` wraps the caller's `BuildContext`) without
/// relying on a globally-shared `GlobalKey`.
class ShellContentHostState extends State<ShellContentHost> {
  /// The inner `Navigator`'s state, or `null` if the host has not
  /// finished its first frame yet.
  NavigatorState? get innerNavigator => widget._innerNavigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    if (widget.embeddedRoute != null) {
      return KeyedSubtree(
        key: ValueKey('desktop-embedded-route:${widget.embeddedRoute}'),
        child: DesktopRoutedModuleHost(
          routeName: widget.embeddedRoute!,
          routeArguments: widget.embeddedRouteArguments,
        ),
      );
    }

    if (widget.module.requiresServer && widget.serverId == null) {
      return NoServerSelectedState(
        moduleName: widget.module.label(context.l10n),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        final navigator = widget._innerNavigatorKey.currentState;
        if (navigator == null) {
          return;
        }
        if (navigator.canPop()) {
          navigator.pop();
        }
        // When the inner stack is at its initial route the pop is left
        // to the outer shell (or system) so the navigation back gesture
        // is not consumed.
      },
      child: _buildInnerNavigator(),
    );
  }

  Widget _buildInnerNavigator() {
    return KeyedSubtree(
      key: ValueKey('shell-content-host:${widget.module.storageId}'),
      child: Navigator(
        key: widget._innerNavigatorKey,
        pages: <Page<dynamic>>[
          MaterialPage<void>(
            key: ValueKey('shell-content-host-init:${widget.module.storageId}'),
            child: _buildModuleRoot(),
          ),
        ],
        onDidRemovePage: _onInnerPageRemoved,
      ),
    );
  }

  Widget _buildModuleRoot() {
    return KeyedSubtree(
      key: ValueKey('shell-content-host-module:${widget.module.storageId}'),
      child: buildShellModulePage(
        context,
        module: widget.module,
        serverId: widget.serverId,
        useStableModuleKey: true,
      ),
    );
  }

  void _onInnerPageRemoved(Page<dynamic> page) {
    // Reserved hook. The shell does not currently expose inner-stack
    // snapshots; per-module stack persistence is achieved by the
    // parent keeping this widget alive across module switches.
  }
}
