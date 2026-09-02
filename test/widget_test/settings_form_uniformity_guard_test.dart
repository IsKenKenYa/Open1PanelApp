import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// settings 系表单页统一守卫（UI 统一 A）：
///
/// 1. settings 域含「保存」语义的表单页必须复用 AppFormScaffold——
///    保存按钮统一在 bottomNavigationBar 全宽 FilledButton，自带
///    isSaving 防重复提交；
/// 2. 禁止在 ListView children 内直接放保存按钮（旧式单列表单页形态）；
/// 3. 裸 Card( 与 SectionCard 不得在同页混用（卡片视觉统一）。
void main() {
  final settingsDir = Directory('lib/features/settings');

  List<File> settingsPages() => settingsDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('_page.dart'))
      .toList();

  test('settings 表单页保存按钮必须经 AppFormScaffold（统一守卫）', () {
    final offenders = <String>[];

    for (final file in settingsPages()) {
      final content = file.readAsStringSync();
      // 表单页判定：含表单 key 与保存方法（避免误伤页面内功能性按钮）。
      final isFormPage = content.contains('_formKey') ||
          content.contains('_saveSettings') ||
          content.contains('_handleSave');
      final usesScaffold = content.contains('AppFormScaffold');
      final hasSaveButton = RegExp(
        r'(FilledButton|ElevatedButton)[^;]*(commonSave|Save)',
        multiLine: true,
      ).hasMatch(content);

      if (isFormPage && hasSaveButton && !usesScaffold) {
        offenders.add(file.path);
      }
    }

    expect(offenders, isEmpty,
        reason: 'settings 表单页必须迁 AppFormScaffold：$offenders');
  });

  test('settings 表单页禁止 ListView 内嵌保存按钮（旧式形态守卫）', () {
    final offenders = <String>[];

    for (final file in settingsPages()) {
      final content = file.readAsStringSync();
      if (!usesAppFormScaffold(content) &&
          content.contains('_formKey') &&
          content.contains('FilledButton') &&
          content.contains('ListView(')) {
        // 保存钮在 body 列表内 = 旧式形态（AppFormScaffold 把它放 bottomNavigationBar）。
        final saveInList = RegExp(
          r'ListView\([\s\S]{0,4000}FilledButton',
        ).hasMatch(content);
        if (saveInList) {
          offenders.add(file.path);
        }
      }
    }

    expect(offenders, isEmpty, reason: '保存按钮应在 bottomNavigationBar：$offenders');
  });
}

bool usesAppFormScaffold(String content) => content.contains('AppFormScaffold');
