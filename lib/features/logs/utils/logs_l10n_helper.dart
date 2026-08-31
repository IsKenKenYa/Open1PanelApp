import 'package:intl/intl.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';

/// 日志状态值（上游为 Success/Failed/Executing 等英文原值）映射为本地化文案。
String logsStatusLabel(AppLocalizations l10n, String? status) {
  switch ((status ?? '').trim().toLowerCase()) {
    case '':
      return '-';
    case 'success':
      return l10n.logsStatusSuccess;
    case 'failed':
      return l10n.logsStatusFailed;
    case 'executing':
      return l10n.logsStatusExecuting;
    default:
      return status ?? '-';
  }
}

/// 日志时间戳（ISO 8601，可能带纳秒）格式化为本地短格式；解析失败回退原值。
String formatLogsTimestamp(String? raw) {
  if (raw == null || raw.isEmpty) return '-';
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return raw;
  return DateFormat('yyyy-MM-dd HH:mm').format(parsed.toLocal());
}

String? localizeLogsError(
  AppLocalizations l10n,
  String? errorMessage,
) {
  switch (errorMessage) {
    case null:
    case '':
      return null;
    case 'logs.operation.loadFailed':
      return l10n.logsOperationLoadFailed;
    case 'logs.login.loadFailed':
      return l10n.logsLoginLoadFailed;
    case 'logs.task.loadFailed':
      return l10n.logsTaskLoadFailed;
    case 'logs.task.detailLoadFailed':
      return l10n.logsTaskDetailLoadFailed;
    case 'logs.task.missingTaskId':
      return l10n.logsTaskMissingTaskId;
    case 'logs.system.filesLoadFailed':
      return l10n.logsSystemFilesLoadFailed;
    case 'logs.system.contentLoadFailed':
      return l10n.logsSystemContentLoadFailed;
    default:
      return errorMessage;
  }
}
