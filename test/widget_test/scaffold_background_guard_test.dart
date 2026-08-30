import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 阶段1-类3 守卫：页面级 Scaffold 禁止透明背景。
///
/// AGENTS.md 要求 Scaffold 背景使用 surface/surfaceContainer*。Material 3
/// 默认即 surface，因此不强制逐处显式声明，但透明背景属于历史透明壳 bug
/// 的回潮路径，必须拦截。desktop_sidebar 为有意透明的侧栏组件，豁免。
void main() {
  test('页面级 Scaffold 无透明背景（类3 守卫）', () {
    final root = Directory('lib');
    final offenders = <String>[];
    const allowlist = <String>{
      'lib/ui/desktop/common/widgets/desktop_sidebar.dart',
    };

    await_for:
    for (final entity in root.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue await_for;
      }
      if (allowlist.contains(entity.path)) {
        continue;
      }
      final content = entity.readAsStringSync();
      if (!content.contains('Scaffold(')) {
        continue;
      }
      if (content.contains('backgroundColor: Colors.transparent')) {
        offenders.add(entity.path);
      }
    }

    expect(offenders, isEmpty,
        reason: '页面级 Scaffold 禁止 Colors.transparent 背景：$offenders');
  });

  test('桌面壳入口 Scaffold 显式 surface 背景（类3 守卫）', () {
    for (final path in [
      'lib/ui/desktop/common/app/desktop_shell_page.dart',
      'lib/ui/desktop/macos/app/macos_shell_content_page.dart',
    ]) {
      final content = File(path).readAsStringSync();
      expect(content.contains('backgroundColor: scheme.surface'), isTrue,
          reason: '$path 必须显式 surface 背景');
    }
  });
}
