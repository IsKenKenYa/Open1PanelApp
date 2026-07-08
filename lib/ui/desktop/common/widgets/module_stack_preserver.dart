import 'package:flutter/foundation.dart';
import 'package:onepanel_client/features/shell/models/client_module.dart';

/// Lightweight description of a single route inside the shell's inner
/// navigator. Captures only the data we need to rebuild the route when
/// switching modules — `name` plus its `arguments`.
@immutable
class ShellInnerRouteEntry {
  const ShellInnerRouteEntry({required this.name, this.arguments});

  final String? name;
  final Object? arguments;

  @override
  bool operator ==(Object other) {
    return other is ShellInnerRouteEntry &&
        other.name == name &&
        other.arguments == arguments;
  }

  @override
  int get hashCode => Object.hash(name, arguments);

  @override
  String toString() => 'ShellInnerRouteEntry(name: $name, arguments: $arguments)';
}

/// Pure-logic helper that keeps a per-module snapshot of the shell's
/// inner-navigator route stack.
///
/// Used by `ShellContentHost` to:
///   1. capture the current inner stack before switching away from a
///      module, and
///   2. restore the captured stack when the user navigates back to
///      that module.
///
/// Kept as a pure-Dart class so it can be unit-tested without a
/// `BuildContext`. All methods are deterministic; no global state.
class ModuleStackPreserver {
  ModuleStackPreserver();

  final Map<ClientModule, List<ShellInnerRouteEntry>> _snapshots =
      <ClientModule, List<ShellInnerRouteEntry>>{};

  /// Whether any module currently has a captured snapshot.
  bool get hasAnySnapshot => _snapshots.isNotEmpty;

  /// Returns the captured snapshot for [module], or `null` if none.
  List<ShellInnerRouteEntry>? snapshotFor(ClientModule module) {
    final value = _snapshots[module];
    if (value == null || value.isEmpty) {
      return null;
    }
    return List<ShellInnerRouteEntry>.unmodifiable(value);
  }

  /// Captures the inner stack for [module].
  ///
  /// Pass an empty list when the inner navigator is at its initial
  /// route — that clears any previously-saved snapshot for the module.
  void capture(ClientModule module, List<ShellInnerRouteEntry> entries) {
    if (entries.isEmpty) {
      _snapshots.remove(module);
      return;
    }
    _snapshots[module] = List<ShellInnerRouteEntry>.unmodifiable(entries);
  }

  /// Clears the captured snapshot for [module] (if any).
  void forget(ClientModule module) {
    _snapshots.remove(module);
  }

  /// Clears all captured snapshots.
  void clear() {
    _snapshots.clear();
  }

  /// Visible for tests: how many modules currently have a snapshot.
  @visibleForTesting
  int get debugSnapshotCount => _snapshots.length;
}
