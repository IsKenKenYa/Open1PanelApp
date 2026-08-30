import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 阶段1-类4/5 守卫：
/// 1. 所有 FloatingActionButton 声明必须带 heroTag（AGENTS.md：桌面多模块页
///    禁用非当前页 Hero，缺 heroTag 会引发 Hero 冲突异常）。
/// 2. 对话框内容禁止使用固定宽度 SizedBox(width: >=300)（窄屏溢出），
///    应使用 AdaptiveLayoutSpec.dialogConstraints 的 ConstrainedBox。
void main() {
  final root = Directory('lib');

  List<File> collectDartFiles() => root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('所有 FloatingActionButton 必须显式 heroTag（类4 守卫）', () {
    final offenders = <String>[];
    final fabPattern = RegExp(r"(?<![A-Za-z_])FloatingActionButton(?:\.(?:extended|large|small))?\(");

    for (final file in collectDartFiles()) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final match = fabPattern.firstMatch(lines[i]);
        if (match == null) {
          continue;
        }
        // 在声明后的 12 行窗口内找 heroTag。
        final window = lines
            .skip(i)
            .take(12)
            .join('\n');
        if (!window.contains('heroTag')) {
          offenders.add('${file.path}:${i + 1}');
        }
      }
    }

    expect(offenders, isEmpty, reason: 'FAB 缺少 heroTag：$offenders');
  });

  test('对话框内容禁止固定宽度 SizedBox(width>=300)（类5 守卫）', () {
    final offenders = <String>[];
    // width 与 SizedBox( 可能跨行，全文匹配后换算行号。
    final sizedBoxPattern = RegExp(r'SizedBox\(\s*width:\s*(\d{3,})');

    for (final file in collectDartFiles()) {
      final content = file.readAsStringSync();
      final lines = content.split('\n');
      for (final match in sizedBoxPattern.allMatches(content)) {
        final width = int.tryParse(match.group(1) ?? '');
        if (width == null || width < 300) {
          continue;
        }
        var lineNo = 1;
        for (var i = 0; i < match.start && i < content.length; i++) {
          if (content.codeUnitAt(i) == 0x0A) {
            lineNo++;
          }
        }
        // 只拦对话框场景：同一文件若为对话框/弹层类才报。
        final isDialogFile =
            file.path.contains('dialog') ||
                file.path.contains('Dialog') ||
                lines.join('\n').contains('showDialog') ||
                lines.join('\n').contains('showModalBottomSheet') ||
                lines.join('\n').contains('AlertDialog');
        if (!isDialogFile) {
          continue;
        }
        offenders.add('${file.path}:$lineNo (width=$width)');
      }
    }

    expect(offenders, isEmpty, reason: '固定宽对话框应改用 dialogConstraints：$offenders');
  });
}
