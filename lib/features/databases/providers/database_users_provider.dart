import 'package:flutter/foundation.dart';
import 'package:onepanel_client/core/utils/error_message_utils.dart';
import 'package:onepanel_client/core/presentation/safe_change_notifier.dart';
import 'package:onepanel_client/data/models/database_models.dart';
import 'package:onepanel_client/features/databases/services/database_user_service.dart';

class DatabaseUsersState {
  const DatabaseUsersState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.context,
    this.users = const <Map<String, dynamic>>[],
  });

  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final DatabaseUserContext? context;
  final List<Map<String, dynamic>> users;
}

class DatabaseUsersProvider extends ChangeNotifier with SafeChangeNotifier {
  DatabaseUsersProvider({
    required this.item,
    DatabaseUserService? service,
  }) : _service = service ?? DatabaseUserService();

  final DatabaseListItem item;
  final DatabaseUserService _service;

  DatabaseUsersState _state = const DatabaseUsersState();
  DatabaseUsersState get state => _state;

  Future<void> load() async {
    _state = DatabaseUsersState(isLoading: true, users: _state.users);
    notifyListeners();
    try {
      final context = await _service.loadContext(item);
      var users = _state.users;
      // V2 新体系：MySQL 用户列表来自 /databases/users/search。
      if (item.scope == DatabaseScope.mysql) {
        users = await _service.listMysqlUsers(item);
      }
      _state = DatabaseUsersState(context: context, users: users);
    } catch (e) {
      _state = DatabaseUsersState(
        error: ErrorMessageUtils.userFacingMessage(e),
        users: _state.users,
      );
    }
    notifyListeners();
  }

  Future<bool> bindUser({
    required String username,
    required String password,
    String permission = '%',
    bool superUser = false,
  }) async {
    return _runMutation(() async {
      await _service.bindUser(
        item,
        username: username,
        password: password,
        permission: permission,
        superUser: superUser,
      );
      // Optimistically update the context with the new username instead of
      // re-fetching from the server, to avoid an extra round-trip.
      final nextContext =
          (_state.context ?? await _service.loadContext(item)).copyWith(
        currentUsername: username,
        superUser: superUser,
      );
      _state = DatabaseUsersState(
        context: nextContext,
        users: item.scope == DatabaseScope.mysql
            ? await _service.listMysqlUsers(item)
            : _state.users,
      );
      notifyListeners();
    });
  }

  /// 删除 MySQL 用户（V2 新体系）。
  Future<bool> deleteMysqlUser(Map<String, dynamic> user) async {
    final username = user['username']?.toString() ?? '';
    final host = user['host']?.toString() ?? '%';
    if (username.isEmpty) return false;
    return _runMutation(() async {
      await _service.deleteMysqlUser(
        item,
        username: username,
        host: host,
      );
      _state = DatabaseUsersState(
        context: _state.context,
        users: await _service.listMysqlUsers(item),
      );
    });
  }

  /// 修改 MySQL 用户密码（V2 新体系）。
  Future<bool> changeMysqlUserPassword({
    required Map<String, dynamic> user,
    required String password,
  }) async {
    final username = user['username']?.toString() ?? '';
    final host = user['host']?.toString() ?? '%';
    if (username.isEmpty || password.isEmpty) return false;
    return _runMutation(() async {
      await _service.changeMysqlUserPassword(
        item,
        username: username,
        host: host,
        password: password,
      );
      _state = DatabaseUsersState(
        context: _state.context,
        users: await _service.listMysqlUsers(item),
      );
    });
  }

  Future<bool> updatePrivileges({
    required bool superUser,
  }) async {
    final currentUsername = _state.context?.currentUsername;
    // Can't update privileges without a bound user; this is a no-op guard.
    if (currentUsername == null || currentUsername.isEmpty) {
      return false;
    }
    return _runMutation(() async {
      await _service.updatePrivileges(
        item,
        username: currentUsername,
        superUser: superUser,
      );
      _state = DatabaseUsersState(
        context: _state.context?.copyWith(superUser: superUser),
      );
      notifyListeners();
    });
  }

  Future<bool> _runMutation(Future<void> Function() action) async {
    _state = DatabaseUsersState(
      context: _state.context,
      isSubmitting: true,
    );
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _state = DatabaseUsersState(
        context: _state.context,
        error: ErrorMessageUtils.userFacingMessage(e),
      );
      notifyListeners();
      return false;
    } finally {
      if (_state.isSubmitting) {
        _state = DatabaseUsersState(context: _state.context);
        notifyListeners();
      }
    }
  }
}
