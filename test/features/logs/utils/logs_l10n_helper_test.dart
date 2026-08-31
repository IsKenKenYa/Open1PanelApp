import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/features/logs/utils/logs_l10n_helper.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';

void main() {
  AppLocalizations l10n(String locale) {
    return lookupAppLocalizations(Locale(locale));
  }

  group('logsStatusLabel', () {
    test('maps Success/Failed/Executing to localized labels', () {
      expect(logsStatusLabel(l10n('zh'), 'Success'), '成功');
      expect(logsStatusLabel(l10n('zh'), 'Failed'), '失败');
      expect(logsStatusLabel(l10n('zh'), 'Executing'), '执行中');
      expect(logsStatusLabel(l10n('en'), 'Success'), 'Success');
      expect(logsStatusLabel(l10n('en'), 'Failed'), 'Failed');
    });

    test('is case-insensitive and falls back to raw value', () {
      expect(logsStatusLabel(l10n('zh'), 'success'), '成功');
      expect(logsStatusLabel(l10n('zh'), 'FAILED'), '失败');
      expect(logsStatusLabel(l10n('zh'), 'Weird'), 'Weird');
      expect(logsStatusLabel(l10n('zh'), null), '-');
      expect(logsStatusLabel(l10n('zh'), ''), '-');
    });
  });

  group('formatLogsTimestamp', () {
    test('formats ISO timestamps (with nanoseconds and offset) to local short format',
        () {
      // 回归：日志中心此前直接外露上游 ISO 串（含纳秒与 +08:00 偏移）。
      final formatted = formatLogsTimestamp(
        '2026-08-31T02:36:52.208959072+08:00',
      );
      expect(formatted, matches(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$')));
    });

    test('formats epoch-backed ISO strings as UTC input correctly', () {
      final formatted = formatLogsTimestamp('2026-01-01T00:30:00Z');
      expect(formatted, matches(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$')));
    });

    test('falls back to raw value when unparseable', () {
      expect(formatLogsTimestamp('not-a-date'), 'not-a-date');
      expect(formatLogsTimestamp(null), '-');
      expect(formatLogsTimestamp(''), '-');
    });
  });
}
