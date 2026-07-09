import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/features/shell/controllers/current_server_controller.dart';

/// Mixin for pages that require an active server connection before loading
/// data.
///
/// Consolidates the 88+ duplicated `hasServer` guard checks scattered across
/// 40+ page files (architecture review R5 candidate 3). Pages mix this in
/// and override [onServerReady] instead of manually checking
/// `CurrentServerController.hasServer` in every `initState`.
///
/// Usage:
/// ```dart
/// class _MyPageState extends State<MyPage> with ServerAwarePageMixin {
///   @override
///   void onServerReady() {
///     // Load data here
///     _provider.load();
///   }
/// }
/// ```
mixin ServerAwarePageMixin<T extends StatefulWidget> on State<T> {
  bool _serverChecked = false;

  /// Override this to perform the initial data load when a server is active.
  /// Called once after the first frame, only when [hasServer] is true.
  void onServerReady() {}

  /// Checks whether a server is currently active. Call this from
  /// [initState]'s post-frame callback or [didChangeDependencies].
  /// Returns true if the server check has already been performed.
  bool checkServerAndLoad() {
    if (_serverChecked || !mounted) return true;
    _serverChecked = true;

    final hasServer =
        context.read<CurrentServerController>().hasServer;
    if (hasServer) {
      onServerReady();
    }
    return true;
  }
}
