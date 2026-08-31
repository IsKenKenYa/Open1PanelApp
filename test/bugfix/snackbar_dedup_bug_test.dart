import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';
import 'package:onepanel_client/shared/widgets/operations/partial_error_toast_listener.dart';

/// 回归测试：错误 Toast 内容级去重（真机走查 P2-4）
///
/// 问题描述：
/// 多个 keep-alive 页面各自挂 PartialErrorToastListener，轮询失败时的去重
/// 按 listener 实例（而非消息内容）判断，同一错误消息被不同实例（或错误
/// 反复清除再出现的同一实例）反复 clearSnackBars + showSnackBar，计时不断
/// 被重置，错误 Toast 跨页"永驻"30+ 分钟不消失。
///
/// 修复方案：
/// 1. PartialErrorToastListener 去重 key 改为"错误消息内容"级别（静态登记
///    表，跨实例共享），同消息已展示期间不重复弹；
/// 2. SnackBarUtils._show 显示前检查同内容 Toast 是否仍在展示期内，是则
///    跳过、保持原计时；对外方法签名保持不变。
void main() {
  Widget wrap(Widget child) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );

  testWidgets('SnackBarUtils: 同消息连续触发只弹一次且不重置计时',
      (tester) async {
    await tester.pumpWidget(wrap(const SizedBox.shrink()));
    final context = tester.element(find.byType(SizedBox).first);

    SnackBarUtils.showError(context, 'dedup-error-1');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    // 入场动画完成后的这一帧 build 才会启动 SnackBar 自动隐藏计时器
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    // 同消息在展示期内再次触发：应被跳过，而不是 clear + 重置计时
    SnackBarUtils.showError(context, 'dedup-error-1');
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    // 首条 Toast 按原计时消失（隐藏计时器在入场完成后的 build 启动，~5.4s
    // 触发；6s 帧推进退出动画、7s 帧完成移除）；若第二条重置了计时，此时仍应可见。
    await tester.pump(const Duration(milliseconds: 4600));
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump();
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('SnackBarUtils: 不同消息不受去重影响，正常替换弹出',
      (tester) async {
    await tester.pumpWidget(wrap(const SizedBox.shrink()));
    final context = tester.element(find.byType(SizedBox).first);

    SnackBarUtils.showError(context, 'dedup-error-A');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('dedup-error-A'), findsOneWidget);

    SnackBarUtils.showError(context, 'dedup-error-B');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.textContaining('dedup-error-B'), findsOneWidget);
    expect(find.textContaining('dedup-error-A'), findsNothing);
  });

  testWidgets('PartialErrorToastListener: 跨实例同消息只弹一次且不重置计时',
      (tester) async {
    // 第一个 keep-alive 页面的 listener 轮询失败
    await tester.pumpWidget(wrap(
      const PartialErrorToastListener(
        key: ValueKey('first'),
        errorMessage: 'dedup-listener-1',
        hasCachedData: true,
        fallbackTitle: 'Load failed',
      ),
    ));
    await tester.pump(); // postFrameCallback 触发展示
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(); // 入场完成后的 build 启动自动隐藏计时器
    expect(find.byType(SnackBar), findsOneWidget);

    // 另一个 keep-alive 页面的 listener 对同一错误消息触发（新实例）
    await tester.pumpWidget(wrap(
      const PartialErrorToastListener(
        key: ValueKey('second'),
        errorMessage: 'dedup-listener-1',
        hasCachedData: true,
        fallbackTitle: 'Load failed',
      ),
    ));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    // 首条 Toast 按原计时消失，不被第二实例重置
    await tester.pump(const Duration(milliseconds: 4600));
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump();
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('PartialErrorToastListener: 不同消息仍正常弹出（防过度去重）',
      (tester) async {
    await tester.pumpWidget(wrap(
      const PartialErrorToastListener(
        key: ValueKey('first'),
        errorMessage: 'dedup-listener-A',
        hasCachedData: true,
        fallbackTitle: 'Load failed',
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('dedup-listener-A'), findsOneWidget);

    await tester.pumpWidget(wrap(
      const PartialErrorToastListener(
        key: ValueKey('second'),
        errorMessage: 'dedup-listener-B',
        hasCachedData: true,
        fallbackTitle: 'Load failed',
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.textContaining('dedup-listener-B'), findsOneWidget);
  });
}
