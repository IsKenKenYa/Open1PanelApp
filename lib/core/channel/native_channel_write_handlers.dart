import '../../features/ai/ai_repository.dart';
import '../../features/apps/app_service.dart';
import '../../features/backups/services/backup_record_service.dart';
import '../../features/containers/container_service.dart';
import '../../features/databases/databases_service.dart';
import '../../data/models/cronjob_list_models.dart';
import '../../data/repositories/cronjob_repository.dart';
import '../../features/files/services/file_browser_service.dart';
import '../../features/firewall/firewall_service.dart';
import '../../features/server/server_repository.dart';
import '../../features/websites/services/websites_service.dart';
import '../../data/models/website_models.dart';
import '../../data/repositories/website_repository.dart';
import '../../core/config/api_config.dart';
import '../../core/services/app_preferences_service.dart';
import '../../core/theme/ui_render_mode.dart';
import '../../data/models/backup_account_models.dart';
import '../../data/models/firewall_models.dart';
import '../../data/models/database_models.dart';
import '../services/logger/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' show Locale;

/// 统一返回结构：成功 `{success: true}`，失败 `{success: false, error: String}`。
Map<String, dynamic> _ok() => {'success': true};
Map<String, dynamic> _err(Object e) => {'success': false, 'error': e.toString()};

/// 所有 Native Channel 写操作 handlers 的集中实现。
/// 被 [NativeChannelManager] 的 dispatch switch 调用。
class NativeChannelWriteHandlers {
  // ── 服务器 ────────────────────────────────────────────────────────────────

  /// 新增服务器配置。参数：`{name: String, url: String, apiKey: String}`
  static Future<Map<String, dynamic>> addServer(dynamic arguments) async {
    try {
      final name = arguments['name'] as String;
      final url = arguments['url'] as String;
      final apiKey = arguments['apiKey'] as String;
      final id = 'server_${DateTime.now().microsecondsSinceEpoch}';
      final config = ApiConfig(
        id: id,
        name: name,
        url: url,
        apiKey: apiKey,
      );
      final repository = const ServerRepository();
      await repository.saveConfig(config);
      return _ok();
    } catch (e) {
      appLogger.e('addServer failed: $e');
      return _err(e);
    }
  }

  /// 切换当前服务器。参数：`{id: String}`
  static Future<Map<String, dynamic>> connectServer(dynamic arguments) async {
    try {
      final id = arguments['id'] as String;
      final repository = ServerRepository();
      await repository.setCurrent(id);
      return _ok();
    } catch (e) {
      appLogger.e('connectServer failed: $e');
      return _err(e);
    }
  }

  /// 删除服务器配置。参数：`{id: String}`
  static Future<Map<String, dynamic>> deleteServer(dynamic arguments) async {
    try {
      final id = arguments['id'] as String;
      final repository = ServerRepository();
      await repository.removeConfig(id);
      return _ok();
    } catch (e) {
      appLogger.e('deleteServer failed: $e');
      return _err(e);
    }
  }

  // ── 网站 ────────────────────────────────────────────────────────────────

  /// 切换网站运行状态。参数：`{id: int, currentStatus: String}`
  static Future<Map<String, dynamic>> toggleWebsiteStatus(
      dynamic arguments) async {
    try {
      final id = _toInt(arguments['id']);
      final currentStatus = arguments['currentStatus'] as String? ?? '';
      final service = WebsitesService();
      if (currentStatus == 'running') {
        await service.stopWebsite(id);
      } else {
        await service.startWebsite(id);
      }
      return _ok();
    } catch (e) {
      appLogger.e('toggleWebsiteStatus failed: $e');
      return _err(e);
    }
  }

  /// 删除网站。参数：`{id: int}`
  static Future<Map<String, dynamic>> deleteWebsite(dynamic arguments) async {
    try {
      final id = _toInt(arguments['id']);
      final service = WebsitesService();
      await service.deleteWebsite(id);
      return _ok();
    } catch (e) {
      appLogger.e('deleteWebsite failed: $e');
      return _err(e);
    }
  }

  // ── 容器 ────────────────────────────────────────────────────────────────

  /// 切换容器启停状态。参数：`{id: String, state: String}`
  static Future<Map<String, dynamic>> toggleContainerState(
      dynamic arguments) async {
    try {
      final id = arguments['id'] as String;
      final state = arguments['state'] as String? ?? '';
      final service = ContainerService();
      if (state == 'running') {
        await service.stopContainer(id);
      } else {
        await service.startContainer(id);
      }
      return _ok();
    } catch (e) {
      appLogger.e('toggleContainerState failed: $e');
      return _err(e);
    }
  }

  /// 重启容器。参数：`{id: String}`
  static Future<Map<String, dynamic>> restartContainer(
      dynamic arguments) async {
    try {
      final id = arguments['id'] as String;
      final service = ContainerService();
      await service.restartContainer(id);
      return _ok();
    } catch (e) {
      appLogger.e('restartContainer failed: $e');
      return _err(e);
    }
  }

  /// 删除容器。参数：`{id: String}`
  static Future<Map<String, dynamic>> deleteContainer(
      dynamic arguments) async {
    try {
      final id = arguments['id'] as String;
      final service = ContainerService();
      await service.removeContainer(id);
      return _ok();
    } catch (e) {
      appLogger.e('deleteContainer failed: $e');
      return _err(e);
    }
  }

  // ── 应用 ────────────────────────────────────────────────────────────────

  /// 启动应用。参数：`{installId: int}`
  static Future<Map<String, dynamic>> startApp(dynamic arguments) async {
    try {
      final installId = _toInt(arguments['installId']);
      final service = AppService();
      await service.operateApp(installId, 'start');
      return _ok();
    } catch (e) {
      appLogger.e('startApp failed: $e');
      return _err(e);
    }
  }

  /// 停止应用。参数：`{installId: int}`
  static Future<Map<String, dynamic>> stopApp(dynamic arguments) async {
    try {
      final installId = _toInt(arguments['installId']);
      final service = AppService();
      await service.operateApp(installId, 'stop');
      return _ok();
    } catch (e) {
      appLogger.e('stopApp failed: $e');
      return _err(e);
    }
  }

  /// 卸载应用。参数：`{installId: String}`
  static Future<Map<String, dynamic>> uninstallApp(dynamic arguments) async {
    try {
      final installId = arguments['installId'].toString();
      final service = AppService();
      await service.uninstallApp(installId);
      return _ok();
    } catch (e) {
      appLogger.e('uninstallApp failed: $e');
      return _err(e);
    }
  }

  // ── 文件 ────────────────────────────────────────────────────────────────

  /// 删除文件或目录。参数：`{path: String, isDir: bool?}`
  static Future<Map<String, dynamic>> deleteFile(dynamic arguments) async {
    try {
      final path = arguments['path'] as String;
      final isDir = arguments['isDir'] as bool?;
      final service = FileBrowserService();
      await service.deleteFiles([path], isDir: isDir);
      return _ok();
    } catch (e) {
      appLogger.e('deleteFile failed: $e');
      return _err(e);
    }
  }

  /// 创建目录。参数：`{path: String}`
  static Future<Map<String, dynamic>> createFolder(dynamic arguments) async {
    try {
      final path = arguments['path'] as String;
      final service = FileBrowserService();
      await service.createDirectory(path);
      return _ok();
    } catch (e) {
      appLogger.e('createFolder failed: $e');
      return _err(e);
    }
  }

  // ── 定时任务 ──────────────────────────────────────────────────────────────

  /// 切换定时任务启停。参数：`{id: int, currentStatus: String}`
  static Future<Map<String, dynamic>> toggleCronJobStatus(
      dynamic arguments) async {
    try {
      final id = _toInt(arguments['id']);
      final currentStatus = arguments['currentStatus'] as String? ?? '';
      final service = CronjobRepository();
      final newStatus = currentStatus == 'Enable' ? 'Disable' : 'Enable';
      await service.updateStatus(CronjobStatusUpdate(id: id, status: newStatus));
      return _ok();
    } catch (e) {
      appLogger.e('toggleCronJobStatus failed: $e');
      return _err(e);
    }
  }

  /// 删除定时任务。参数：`{id: int}`
  static Future<Map<String, dynamic>> deleteCronJob(dynamic arguments) async {
    try {
      final id = _toInt(arguments['id']);
      final service = CronjobRepository();
      await service.deleteById(id);
      return _ok();
    } catch (e) {
      appLogger.e('deleteCronJob failed: $e');
      return _err(e);
    }
  }

  // ── 备份 ─────────────────────────────────────────────────────────────────

  /// 删除备份记录。参数：`{id: int, name: String, type: String, status: String}`
  static Future<Map<String, dynamic>> deleteBackup(dynamic arguments) async {
    try {
      final record = BackupRecord(
        id: _toInt(arguments['id']),
        name: arguments['name'] as String? ?? '',
        type: arguments['type'] as String? ?? '',
        status: arguments['status'] as String? ?? '',
        size: 0,
      );
      final service = BackupRecordService();
      await service.deleteRecord(record);
      return _ok();
    } catch (e) {
      appLogger.e('deleteBackup failed: $e');
      return _err(e);
    }
  }

  // ── AI 模型 ──────────────────────────────────────────────────────────────

  /// 删除 Ollama 模型。参数：`{id: int}`
  static Future<Map<String, dynamic>> deleteAIModel(dynamic arguments) async {
    try {
      final id = _toInt(arguments['id']);
      final repository = AIRepository();
      await repository.deleteOllamaModel(ids: [id]);
      return _ok();
    } catch (e) {
      appLogger.e('deleteAIModel failed: $e');
      return _err(e);
    }
  }

  // ── 防火墙 ────────────────────────────────────────────────────────────────

  /// 添加防火墙端口规则。参数：`{port: String, protocol: String, address: String, strategy: String}`
  static Future<Map<String, dynamic>> addFirewallRule(dynamic arguments) async {
    try {
      final port = arguments['port'] as String? ?? '';
      final protocol = arguments['protocol'] as String? ?? 'tcp';
      final address = arguments['address'] as String? ?? '';
      final strategy = arguments['strategy'] as String? ?? 'accept';
      final service = FirewallService();
      if (port.isNotEmpty) {
        await service.createPortRule(FirewallPortRulePayload(
          operation: 'add',
          address: address,
          port: port,
          source: address,
          protocol: protocol,
          strategy: strategy,
        ));
      } else if (address.isNotEmpty) {
        await service.createIpRule(FirewallIpRulePayload(
          operation: 'add',
          address: address,
          strategy: strategy,
        ));
      }
      return _ok();
    } catch (e) {
      appLogger.e('addFirewallRule failed: $e');
      return _err(e);
    }
  }

  /// 删除防火墙规则。参数：`{port: String, protocol: String, address: String, strategy: String}`
  static Future<Map<String, dynamic>> deleteFirewallRule(
      dynamic arguments) async {
    try {
      final port = arguments['port'] as String? ?? '';
      final protocol = arguments['protocol'] as String? ?? '';
      final strategy = arguments['strategy'] as String? ?? '';
      final address = arguments['address'] as String? ?? '';
      final ruleType = port.isNotEmpty ? 'port' : 'address';
      final request = FirewallBatchRuleRequest(
        type: ruleType,
        rules: [
          {
            'port': port,
            'protocol': protocol,
            'strategy': strategy,
            'address': address,
          }
        ],
      );
      final service = FirewallService();
      await service.deleteRules(request);
      return _ok();
    } catch (e) {
      appLogger.e('deleteFirewallRule failed: $e');
      return _err(e);
    }
  }

  // ── 缓存 ──────────────────────────────────────────────────────────────────

  /// 清除 SharedPreferences 缓存（保留服务器配置等核心数据）。无参数。
  static Future<Map<String, dynamic>> clearCache(dynamic arguments) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // 只清除非核心缓存 key（保留 app_ui_render_mode、app_locale 等设置）
      final keysToRemove = prefs.getKeys().where((k) =>
          !k.startsWith('flutter.server_') &&
          !k.startsWith('flutter.app_ui_render_mode') &&
          !k.startsWith('flutter.app_locale'));
      for (final k in keysToRemove) {
        await prefs.remove(k);
      }
      return _ok();
    } catch (e) {
      appLogger.e('clearCache failed: $e');
      return _err(e);
    }
  }

  // ── 设置 ────────────────────────────────────────────────────────────────

  /// 写客户端偏好（供 WinUI3 原生宿主切换渲染模式/语言）。
  /// 参数：`{key: 'renderMode'|'language', value: String}`
  static Future<Map<String, dynamic>> updateSetting(dynamic arguments) async {
    try {
      final key = arguments['key'] as String;
      final value = arguments['value'] as String?;
      final prefs = AppPreferencesService();
      switch (key) {
        case 'renderMode':
          await prefs.saveUIRenderMode(
            value == 'native' ? UIRenderMode.native : UIRenderMode.md3,
          );
          return _ok();
        case 'language':
          await prefs.saveLocale(
            value == null || value == 'system' ? null : Locale(value),
          );
          return _ok();
        default:
          return {'success': false, 'error': 'Unknown setting key: $key'};
      }
    } catch (e) {
      appLogger.e('updateSetting failed: $e');
      return _err(e);
    }
  }

  /// 新建网站（WinUI3 网站页新建表单，最小字段集对齐 Flutter 建站向导
  /// 的 deployment 缺省路径）。参数：
  /// `{primaryDomain: String, alias?: String, port?: int|String(default 80),
  ///   type?: String(default 'deployment'), remark?: String}`
  static Future<Map<String, dynamic>> createWebsite(dynamic arguments) async {
    try {
      final primaryDomain =
          (arguments['primaryDomain'] as String? ?? '').trim();
      if (primaryDomain.isEmpty) {
        return {'success': false, 'error': 'primaryDomain is required'};
      }
      final alias =
          (arguments['alias'] as String? ?? '').trim().isNotEmpty
              ? (arguments['alias'] as String).trim()
              : primaryDomain.replaceAll('.', '_');
      final port = int.tryParse('${arguments['port'] ?? 80}') ?? 80;
      final type = arguments['type'] as String? ?? 'deployment';
      final remark = (arguments['remark'] as String? ?? '').trim();

      // 与 Flutter 建站向导同序：先 preCheck 再 create。
      await WebsiteRepository().preCheckWebsite({});
      await WebsiteRepository().createWebsite(
        WebsiteCreate(
          alias: alias,
          name: primaryDomain,
          remark: remark.isEmpty ? null : remark,
          type: type,
          webSiteGroupId: 0,
          port: port,
          domains: [
            WebsiteDomain(domain: primaryDomain, port: port, ssl: false),
          ],
          taskId: DateTime.now().millisecondsSinceEpoch.toString(),
          ipv6: false,
        ),
      );
      return _ok();
    } catch (e) {
      appLogger.e('createWebsite failed: $e');
      return _err(e);
    }
  }

  // ── 数据库 ────────────────────────────────────────────────────────────────

  /// 新建数据库（本地部署最小集；remote 需连接信息）。
  /// 参数：`{name: String, type?: String(scope, 默认 mysql), description?: String,
  ///        address?: String, port?: int|String, username?: String, password?: String}`
  static Future<Map<String, dynamic>> createDatabase(dynamic arguments) async {
    try {
      final name = (arguments['name'] as String? ?? '').trim();
      if (name.isEmpty) {
        return {'success': false, 'error': 'name is required'};
      }
      final type = arguments['type'] as String? ?? 'mysql';
      final scope = DatabaseScope.values.firstWhere(
        (s) => s.value == type,
        orElse: () => DatabaseScope.mysql,
      );
      final isRemote = scope == DatabaseScope.remote || type == 'remote';
      final port = int.tryParse('${arguments['port'] ?? ''}');
      await DatabasesService().submitForm(
        DatabaseFormInput(
          scope: scope,
          name: name,
          engine: type,
          source: isRemote ? 'remote' : 'local',
          description: (arguments['description'] as String? ?? '').trim(),
          address: arguments['address'] as String?,
          port: port,
          username: arguments['username'] as String?,
          password: arguments['password'] as String?,
        ),
      );
      return _ok();
    } catch (e) {
      appLogger.e('createDatabase failed: $e');
      return _err(e);
    }
  }

  /// 删除数据库。参数：`{id: int|String}`
  static Future<Map<String, dynamic>> deleteDatabase(dynamic arguments) async {
    try {
      final id = int.tryParse('${arguments['id'] ?? ''}');
      if (id == null) {
        return {'success': false, 'error': 'id is required'};
      }
      await DatabasesService().deleteDatabase(id);
      return _ok();
    } catch (e) {
      appLogger.e('deleteDatabase failed: $e');
      return _err(e);
    }
  }

  /// 重建供改写操作使用的最小条目（字段覆盖 repository 各分支所需）。
  static DatabaseListItem _rebuildDatabaseItem(dynamic arguments) {
    final lookupName =
        (arguments['lookupName'] as String? ?? '').trim();
    final name = (arguments['name'] as String? ?? '').trim();
    if (lookupName.isEmpty && name.isEmpty) {
      throw ArgumentError('lookupName or name is required');
    }
    final type = arguments['scope'] as String? ?? 'mysql';
    return DatabaseListItem(
      scope: DatabaseScope.values.firstWhere(
        (s) => s.value == type,
        orElse: () => DatabaseScope.mysql,
      ),
      id: int.tryParse('${arguments['id'] ?? ''}'),
      name: name,
      engine: arguments['engine'] as String? ?? type,
      source: arguments['source'] as String? ?? 'local',
      database: lookupName.isEmpty ? null : lookupName,
    );
  }

  /// 修改数据库描述。参数：`{scope, lookupName?|name, engine?, source?, id?, description}`
  static Future<Map<String, dynamic>> updateDatabaseDescription(
      dynamic arguments) async {
    try {
      final description = arguments['description'] as String? ?? '';
      final item = _rebuildDatabaseItem(arguments);
      await DatabasesService().updateDescription(item, description);
      return _ok();
    } catch (e) {
      appLogger.e('updateDatabaseDescription failed: $e');
      return _err(e);
    }
  }

  /// 修改数据库密码。参数：`{scope, lookupName?|name, engine?, source?, id?, password}`
  static Future<Map<String, dynamic>> changeDatabasePassword(
      dynamic arguments) async {
    try {
      final password = arguments['password'] as String? ?? '';
      if (password.isEmpty) {
        return {'success': false, 'error': 'password is required'};
      }
      final item = _rebuildDatabaseItem(arguments);
      await DatabasesService().changePassword(item, password);
      return _ok();
    } catch (e) {
      appLogger.e('changeDatabasePassword failed: $e');
      return _err(e);
    }
  }

  // ── 内部工具 ──────────────────────────────────────────────────────────────

  /// 将 dynamic 类型的 id 安全转换为 int（支持 int 和 String 输入）。
  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return int.parse(value.toString());
  }
}
