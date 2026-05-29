import 'dart:convert';
import 'dart:io';

/// 解析 lcov.info 生成覆盖率报告
///
/// 用法:
///   dart run test/scripts/parse_coverage.dart                    # 解析当前覆盖率
///   dart run test/scripts/parse_coverage.dart --diff <old.json>  # 对比两份报告
///   dart run test/scripts/parse_coverage.dart --output <path>    # 指定输出路径
void main(List<String> args) async {
  final lcovPath = 'coverage/lcov.info';
  final outputPath = 'coverage/coverage_report.json';

  // 解析参数
  String? diffPath;
  String? customOutput;
  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--diff' && i + 1 < args.length) {
      diffPath = args[i + 1];
    } else if (args[i] == '--output' && i + 1 < args.length) {
      customOutput = args[i + 1];
    }
  }

  final outFile = customOutput ?? outputPath;

  // 检查 lcov 文件
  final lcovFile = File(lcovPath);
  if (!await lcovFile.exists()) {
    stderr.writeln('错误: $lcovPath 不存在。请先运行: flutter test --coverage');
    exit(1);
  }

  // 解析 lcov
  final records = await _parseLcov(lcovFile);

  // 生成报告
  final report = _generateReport(records);

  // 写入 JSON
  final encoder = JsonEncoder.withIndent('  ');
  await File(outFile).writeAsString(encoder.convert(report));
  stdout.writeln('覆盖率报告已生成: $outFile');

  // 打印摘要
  _printSummary(report);

  // 对比模式
  if (diffPath != null) {
    final diffFile = File(diffPath);
    if (await diffFile.exists()) {
      final oldReport =
          jsonDecode(await diffFile.readAsString()) as Map<String, dynamic>;
      _printDiff(oldReport, report);
    } else {
      stderr.writeln('警告: 对比文件 $diffPath 不存在');
    }
  }
}

class LcovRecord {
  final String path;
  final int linesFound;
  final int linesHit;
  final Map<int, int> lineHits; // line number -> hit count

  LcovRecord({
    required this.path,
    required this.linesFound,
    required this.linesHit,
    required this.lineHits,
  });
}

Future<List<LcovRecord>> _parseLcov(File file) async {
  final records = <LcovRecord>[];
  final lines = await file.readAsLines();

  String? currentPath;
  int linesFound = 0;
  int linesHit = 0;
  final lineHits = <int, int>{};

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentPath = line.substring(3).trim();
      linesFound = 0;
      linesHit = 0;
      lineHits.clear();
    } else if (line.startsWith('DA:')) {
      final parts = line.substring(3).split(',');
      if (parts.length >= 2) {
        final lineNum = int.tryParse(parts[0]);
        final hits = int.tryParse(parts[1]);
        if (lineNum != null && hits != null) {
          lineHits[lineNum] = hits;
          linesFound++;
          if (hits > 0) linesHit++;
        }
      }
    } else if (line.startsWith('LF:')) {
      linesFound = int.tryParse(line.substring(3)) ?? linesFound;
    } else if (line.startsWith('LH:')) {
      linesHit = int.tryParse(line.substring(3)) ?? linesHit;
    } else if (line == 'end_of_record' && currentPath != null) {
      records.add(LcovRecord(
        path: currentPath,
        linesFound: linesFound,
        linesHit: linesHit,
        lineHits: Map.from(lineHits),
      ));
      currentPath = null;
    }
  }

  return records;
}

bool _shouldExclude(String path) {
  return path.endsWith('.g.dart') ||
      path.endsWith('.freezed.dart') ||
      path.contains('.g.dart') ||
      path.contains('.freezed.dart');
}

Map<String, dynamic> _generateReport(List<LcovRecord> records) {
  // 排除生成文件
  final filtered = records.where((r) => !_shouldExclude(r.path)).toList();

  // per-file 统计
  final files = <Map<String, dynamic>>[];
  for (final r in filtered) {
    final pct = r.linesFound > 0 ? (r.linesHit / r.linesFound * 100) : 100.0;
    final uncoveredLines = r.lineHits.entries
        .where((e) => e.value == 0)
        .map((e) => e.key)
        .toList()
      ..sort();
    files.add({
      'path': r.path,
      'lines_found': r.linesFound,
      'lines_hit': r.linesHit,
      'coverage_pct': double.parse(pct.toStringAsFixed(1)),
      'uncovered_lines': uncoveredLines,
    });
  }

  // 按覆盖率排序（最低在前）
  files.sort((a, b) =>
      (a['coverage_pct'] as double).compareTo(b['coverage_pct'] as double));

  // per-directory 统计
  final dirStats = <String, Map<String, int>>{};
  for (final r in filtered) {
    final dir = _getDirectory(r.path);
    dirStats.putIfAbsent(dir, () => {'found': 0, 'hit': 0});
    dirStats[dir]!['found'] =
        (dirStats[dir]!['found'] ?? 0) + r.linesFound;
    dirStats[dir]!['hit'] = (dirStats[dir]!['hit'] ?? 0) + r.linesHit;
  }

  final directories = <Map<String, dynamic>>[];
  dirStats.forEach((dir, stats) {
    final found = stats['found'] ?? 0;
    final hit = stats['hit'] ?? 0;
    final pct = found > 0 ? (hit / found * 100) : 100.0;
    directories.add({
      'directory': dir,
      'lines_found': found,
      'lines_hit': hit,
      'coverage_pct': double.parse(pct.toStringAsFixed(1)),
    });
  });
  directories.sort((a, b) => (a['coverage_pct'] as double)
      .compareTo(b['coverage_pct'] as double));

  // 总计
  final totalFound =
      filtered.fold<int>(0, (sum, r) => sum + r.linesFound);
  final totalHit = filtered.fold<int>(0, (sum, r) => sum + r.linesHit);
  final totalPct =
      totalFound > 0 ? (totalHit / totalFound * 100) : 100.0;

  return {
    'generated_at': DateTime.now().toIso8601String(),
    'total_files': filtered.length,
    'total_lines_found': totalFound,
    'total_lines_hit': totalHit,
    'total_coverage_pct': double.parse(totalPct.toStringAsFixed(1)),
    'excluded_files': records.length - filtered.length,
    'directories': directories,
    'files': files,
  };
}

String _getDirectory(String path) {
  // 取前两层目录，如 lib/core/network -> lib/core
  final parts = path.split('/');
  if (parts.length >= 3) {
    return '${parts[0]}/${parts[1]}/${parts[2]}';
  }
  if (parts.length >= 2) {
    return '${parts[0]}/${parts[1]}';
  }
  return path;
}

void _printSummary(Map<String, dynamic> report) {
  stdout.writeln('');
  stdout.writeln('════════════════════════════════════════');
  stdout.writeln('  覆盖率摘要');
  stdout.writeln('════════════════════════════════════════');
  stdout.writeln('  文件数: ${report['total_files']}');
  stdout.writeln('  总行数: ${report['total_lines_found']}');
  stdout.writeln('  覆盖行: ${report['total_lines_hit']}');
  stdout.writeln('  覆盖率: ${report['total_coverage_pct']}%');
  stdout.writeln('  排除文件: ${report['excluded_files']} (生成代码)');
  stdout.writeln('');

  // 目录覆盖率
  stdout.writeln('  按目录:');
  final dirs = report['directories'] as List;
  for (final dir in dirs) {
    final pct = dir['coverage_pct'] as double;
    final marker = pct < 50 ? '❌' : pct < 80 ? '⚠️' : '✅';
    stdout.writeln('    $marker ${dir["directory"]}: $pct%');
  }

  // 最低覆盖率文件 (前 20)
  stdout.writeln('');
  stdout.writeln('  最低覆盖率文件 (前 20):');
  final files = report['files'] as List;
  final showCount = files.length < 20 ? files.length : 20;
  for (int i = 0; i < showCount; i++) {
    final f = files[i];
    final pct = f['coverage_pct'] as double;
    final marker = pct == 0 ? '❌' : pct < 50 ? '⚠️' : '✅';
    stdout.writeln('    $marker ${f["path"]}: $pct%');
  }
  stdout.writeln('════════════════════════════════════════');
}

void _printDiff(
    Map<String, dynamic> oldReport, Map<String, dynamic> newReport) {
  stdout.writeln('');
  stdout.writeln('════════════════════════════════════════');
  stdout.writeln('  覆盖率变化');
  stdout.writeln('════════════════════════════════════════');

  final oldPct = oldReport['total_coverage_pct'] as double;
  final newPct = newReport['total_coverage_pct'] as double;
  final delta = newPct - oldPct;
  final arrow = delta > 0 ? '↑' : delta < 0 ? '↓' : '→';
  stdout.writeln('  总覆盖率: $oldPct% $arrow $newPct% (${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)}%)');

  final oldFiles = oldReport['total_files'] as int;
  final newFiles = newReport['total_files'] as int;
  stdout.writeln('  文件数: $oldFiles → $newFiles');

  // 按目录对比
  final oldDirs = <String, double>{};
  for (final d in (oldReport['directories'] as List)) {
    oldDirs[d['directory'] as String] = d['coverage_pct'] as double;
  }

  stdout.writeln('');
  stdout.writeln('  按目录变化:');
  for (final d in (newReport['directories'] as List)) {
    final dir = d['directory'] as String;
    final newDirPct = d['coverage_pct'] as double;
    final oldDirPct = oldDirs[dir];
    if (oldDirPct != null) {
      final dirDelta = newDirPct - oldDirPct;
      final dirArrow = dirDelta > 0 ? '↑' : dirDelta < 0 ? '↓' : '→';
      stdout.writeln(
          '    $dir: $oldDirPct% $dirArrow $newDirPct% (${dirDelta >= 0 ? '+' : ''}${dirDelta.toStringAsFixed(1)}%)');
    } else {
      stdout.writeln('    $dir: NEW → $newDirPct%');
    }
  }
  stdout.writeln('════════════════════════════════════════');
}
