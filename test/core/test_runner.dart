/// 测试运行器
///
/// 提供统一的测试执行和报告生成功能

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'test_config_manager.dart';

class TestRunner {
  static final TestRunner _instance = TestRunner._internal();
  static TestRunner get instance => _instance;

  final List<TestSuiteResult> _results = [];
  DateTime? _startTime;
  DateTime? _endTime;

  TestRunner._internal();

  void startSuite(String suiteName) {
    print('\n========================================');
    print('开始测试套件: $suiteName');
    print('========================================\n');
  }

  void endSuite(String suiteName, {required int passed, required int failed, required int skipped}) {
    final result = TestSuiteResult(
      suiteName: suiteName,
      passed: passed,
      failed: failed,
      skipped: skipped,
      timestamp: DateTime.now(),
    );
    _results.add(result);

    print('\n----------------------------------------');
    print('测试套件完成: $suiteName');
    print('通过: $passed, 失败: $failed, 跳过: $skipped');
    print('----------------------------------------\n');
  }

  void startAllTests() {
    _startTime = DateTime.now();
    _results.clear();
    print('\n╔════════════════════════════════════════╗');
    print('║     1Panel V2 API 测试开始            ║');
    print('╚════════════════════════════════════════╝\n');
    print('测试环境配置:');
    print('  服务器: ${TestEnvironment.baseUrl}');
    print('  API版本: ${TestEnvironment.apiVersion}');
    print('  集成测试: ${TestEnvironment.runIntegrationTests ? '启用' : '禁用'}');
    print('  破坏性测试: ${TestEnvironment.runDestructiveTests ? '启用' : '禁用'}');
    print('');
  }

  void endAllTests() {
    _endTime = DateTime.now();
    _generateReport();
  }

  void _generateReport() {
    final totalPassed = _results.fold(0, (sum, r) => sum + r.passed);
    final totalFailed = _results.fold(0, (sum, r) => sum + r.failed);
    final totalSkipped = _results.fold(0, (sum, r) => sum + r.skipped);
    final totalTests = totalPassed + totalFailed + totalSkipped;

    print('\n╔════════════════════════════════════════╗');
    print('║     1Panel V2 API 测试报告            ║');
    print('╚════════════════════════════════════════╝\n');

    print('测试概要:');
    print('  开始时间: ${_startTime?.toIso8601String() ?? 'N/A'}');
    print('  结束时间: ${_endTime?.toIso8601String() ?? 'N/A'}');
    final duration = _startTime != null && _endTime != null
        ? _endTime!.difference(_startTime!)
        : Duration.zero;
    print('  持续时间: ${duration.inSeconds}秒');
    print('');
    print('测试统计:');
    print('  总测试数: $totalTests');
    print('  ✅ 通过: $totalPassed');
    print('  ❌ 失败: $totalFailed');
    print('  ⏭️  跳过: $totalSkipped');
    print('  通过率: ${totalTests > 0 ? (totalPassed / totalTests * 100).toStringAsFixed(2) : 0}%');
    print('');

    print('各模块测试结果:');
    for (final result in _results) {
      final status = result.failed > 0 ? '❌' : (result.skipped > 0 ? '⚠️' : '✅');
      print('  $status ${result.suiteName}: ${result.passed}/${result.passed + result.failed + result.skipped}');
    }
    print('');

    _saveReport(totalTests, totalPassed, totalFailed, totalSkipped, duration);
  }

  Future<void> _saveReport(int total, int passed, int failed, int skipped, Duration duration) async {
    if (!TestEnvironment.saveTestLogs) return;

    try {
      final reportDir = Directory(TestEnvironment.testReportPath);
      if (!reportDir.existsSync()) {
        reportDir.createSync(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final reportFile = File('${reportDir.path}/test_report_$timestamp.md');

      final buffer = StringBuffer();
      buffer.writeln('# 1Panel V2 API 测试报告');
      buffer.writeln();
      buffer.writeln('## 测试概要');
      buffer.writeln();
      buffer.writeln('| 指标 | 值 |');
      buffer.writeln('|------|------|');
      buffer.writeln('| 开始时间 | ${_startTime?.toIso8601String() ?? 'N/A'} |');
      buffer.writeln('| 结束时间 | ${_endTime?.toIso8601String() ?? 'N/A'} |');
      buffer.writeln('| 持续时间 | ${duration.inSeconds}秒 |');
      buffer.writeln('| 总测试数 | $total |');
      buffer.writeln('| 通过数 | $passed |');
      buffer.writeln('| 失败数 | $failed |');
      buffer.writeln('| 跳过数 | $skipped |');
      buffer.writeln('| 通过率 | ${total > 0 ? (passed / total * 100).toStringAsFixed(2) : 0}% |');
      buffer.writeln();
      buffer.writeln('## 测试环境');
      buffer.writeln();
      buffer.writeln('| 配置项 | 值 |');
      buffer.writeln('|--------|------|');
      buffer.writeln('| 服务器URL | ${TestEnvironment.baseUrl} |');
      buffer.writeln('| API版本 | ${TestEnvironment.apiVersion} |');
      buffer.writeln('| 集成测试 | ${TestEnvironment.runIntegrationTests ? '启用' : '禁用'} |');
      buffer.writeln('| 破坏性测试 | ${TestEnvironment.runDestructiveTests ? '启用' : '禁用'} |');
      buffer.writeln();
      buffer.writeln('## 各模块测试结果');
      buffer.writeln();
      buffer.writeln('| 模块 | 通过 | 失败 | 跳过 | 状态 |');
      buffer.writeln('|------|------|------|------|------|');

      for (final result in _results) {
        final status = result.failed > 0 ? '❌ 失败' : (result.skipped > 0 ? '⚠️ 部分跳过' : '✅ 通过');
        buffer.writeln('| ${result.suiteName} | ${result.passed} | ${result.failed} | ${result.skipped} | $status |');
      }

      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln('*报告生成时间: ${DateTime.now().toIso8601String()}*');

      await reportFile.writeAsString(buffer.toString());
      print('测试报告已保存到: ${reportFile.path}');
    } catch (e) {
      print('保存测试报告失败: $e');
    }
  }

  List<TestSuiteResult> get results => List.unmodifiable(_results);
}

class TestSuiteResult {
  final String suiteName;
  final int passed;
  final int failed;
  final int skipped;
  final DateTime timestamp;

  TestSuiteResult({
    required this.suiteName,
    required this.passed,
    required this.failed,
    required this.skipped,
    required this.timestamp,
  });

  int get total => passed + failed + skipped;
  double get passRate => total > 0 ? (passed / total) * 100 : 0;
}

class TestLogger {
  static void info(String message) {
    print('[INFO] $message');
  }

  static void success(String message) {
    print('[SUCCESS] ✅ $message');
  }

  static void error(String message) {
    print('[ERROR] ❌ $message');
  }

  static void warning(String message) {
    print('[WARNING] ⚠️ $message');
  }

  static void skip(String message) {
    print('[SKIP] ⏭️ $message');
  }

  static void testStart(String testName) {
    print('  ▶ $testName');
  }

  static void testPass(String testName) {
    print('    ✅ 通过: $testName');
  }

  static void testFail(String testName, String error) {
    print('    ❌ 失败: $testName');
    print('       错误: $error');
  }

  static void testSkip(String testName, String reason) {
    print('    ⏭️ 跳过: $testName ($reason)');
  }
}

class ApiTestRegistry {
  static final ApiTestRegistry _instance = ApiTestRegistry._internal();
  static ApiTestRegistry get instance => _instance;

  final Map<String, ApiTestDefinition> _tests = {};

  ApiTestRegistry._internal();

  void register(ApiTestDefinition test) {
    _tests[test.id] = test;
  }

  ApiTestDefinition? get(String id) => _tests[id];

  List<ApiTestDefinition> getAll() => _tests.values.toList();

  List<ApiTestDefinition> getByModule(String module) {
    return _tests.values.where((t) => t.module == module).toList();
  }

  List<ApiTestDefinition> getByTag(String tag) {
    return _tests.values.where((t) => t.tags.contains(tag)).toList();
  }

  int get totalTests => _tests.length;
}

class ApiTestDefinition {
  final String id;
  final String name;
  final String module;
  final String description;
  final String method;
  final String path;
  final List<String> tags;
  final bool requiresAuth;
  final bool isDestructive;
  final bool isIntegration;

  const ApiTestDefinition({
    required this.id,
    required this.name,
    required this.module,
    required this.description,
    required this.method,
    required this.path,
    this.tags = const [],
    this.requiresAuth = true,
    this.isDestructive = false,
    this.isIntegration = false,
  });
}
