import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/features/server/server_repository.dart';
import 'package:onepanel_client/core/config/api_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Bug Condition - Server Disk Display', () {
    test('Property 1: diskPercent should not be null when server has disk data', () async {
      final repository = const ServerRepository();

      try {
        final configs = await ApiConfigManager.getConfigs();
        if (configs.isEmpty) {
          debugPrint('⚠️  跳过测试: 没有配置的服务器');
          return;
        }

        final testServerId = configs.first.id;
        debugPrint('📊 测试服务器: $testServerId');

        final metrics = await repository.loadServerMetrics(testServerId);

        debugPrint('📈 返回的指标:');
        debugPrint('  - cpuPercent: ${metrics.cpuPercent}');
        debugPrint('  - memoryPercent: ${metrics.memoryPercent}');
        debugPrint('  - diskPercent: ${metrics.diskPercent}');
        debugPrint('  - load: ${metrics.load}');

        if (metrics.diskPercent == null) {
          debugPrint('❌ Bug 确认: diskPercent 为 null');
          debugPrint('   这证明了 bug 存在 - 磁盘信息无法显示');
          debugPrint('   UI 将显示 "--" 而不是实际的磁盘使用率');
        }

        expect(
          metrics.diskPercent,
          isNotNull,
          reason: 'diskPercent 不应该为 null - 服务器应该有磁盘数据',
        );

        expect(
          metrics.diskPercent! >= 0 && metrics.diskPercent! <= 100,
          isTrue,
          reason: 'diskPercent 应该在 0-100 之间',
        );

        debugPrint('✅ 测试通过: diskPercent = ${metrics.diskPercent}%');
      } catch (e, stackTrace) {
        debugPrint('❌ 测试执行失败: $e');
        debugPrint('堆栈跟踪: $stackTrace');
        rethrow;
      }
    });

    test('Bug Condition: Monitor API returns null diskPercent', () async {
      final repository = const ServerRepository();

      try {
        final configs = await ApiConfigManager.getConfigs();
        if (configs.isEmpty) {
          debugPrint('⚠️  跳过测试: 没有配置的服务器');
          return;
        }

        final testServerId = configs.first.id;
        final metrics = await repository.loadServerMetrics(testServerId);

        if (metrics.diskPercent == null) {
          debugPrint('');
          debugPrint('========================================');
          debugPrint('反例 (Counterexample) 记录:');
          debugPrint('========================================');
          debugPrint('服务器ID: $testServerId');
          debugPrint('Bug Condition: diskPercent = null');
          debugPrint('');
          debugPrint('其他指标状态:');
          debugPrint('  - cpuPercent: ${metrics.cpuPercent ?? "null"}');
          debugPrint('  - memoryPercent: ${metrics.memoryPercent ?? "null"}');
          debugPrint('  - load: ${metrics.load ?? "null"}');
          debugPrint('');
          debugPrint('根本原因分析:');
          debugPrint('  当前实现使用 Monitor API (/api/v2/hosts/monitor/search)');
          debugPrint('  Monitor API 可能未返回 diskData 字段');
          debugPrint('  或者 diskData 为空数组');
          debugPrint('');
          debugPrint('推荐修复方案:');
          debugPrint('  使用 Dashboard API (/api/v2/dashboard/base)');
          debugPrint('  Dashboard API 已验证返回正确的磁盘数据');
          debugPrint('========================================');
        }

        expect(
          metrics.diskPercent,
          isNotNull,
          reason: 'Bug Condition: Monitor API 未返回有效的 diskPercent',
        );
      } catch (e) {
        debugPrint('测试执行异常: $e');
        rethrow;
      }
    });
  });
}
