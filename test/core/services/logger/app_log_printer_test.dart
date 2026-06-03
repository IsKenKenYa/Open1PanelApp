import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:onepanel_client/core/services/logger/app_log_printer.dart';
import 'package:onepanel_client/core/services/logger/log_format.dart';

LogEvent _buildEvent(
  Level level,
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) {
  return LogEvent(
    level,
    message,
    time: DateTime(2026, 6, 3, 18, 6, 12, 353),
    error: error,
    stackTrace: stackTrace,
  );
}

void main() {
  group('AppLogPrinter (AI Agent format)', () {
    final printer = AppLogPrinter(format: LogFormat.aiAgent);

    test('Info line is single-line without box-drawing chars', () {
      final out = printer.log(_buildEvent(Level.info, '[UI:features.dashboard] hello world'));
      expect(out.length, 1);
      final line = out.first;
      expect(line.contains('├'), isFalse);
      expect(line.contains('┄'), isFalse);
      expect(line.contains('└'), isFalse);
      expect(line.contains('─'), isFalse);
      expect(line.contains('hello world'), isTrue);
      expect(line.contains('[INFO ]'), isTrue);
      expect(line.contains('[UI:features.dashboard]'), isTrue);
    });

    test('Error line includes err= and at frames (max 3)', () {
      final st = StackTrace.fromString('''
#0      frame_one (file.dart:10)
#1      frame_two (file.dart:20)
#2      frame_three (file.dart:30)
#3      frame_four (file.dart:40)
#4      frame_five (file.dart:50)
''');
      final out = printer.log(_buildEvent(
        Level.error,
        '[NET:core.network.dio] Request failed',
        error: 'SocketException',
        stackTrace: st,
      ));
      expect(out.length, 1);
      final line = out.first;
      expect(line.contains('| err=SocketException'), isTrue);
      expect(line.contains('frame_one'), isTrue);
      expect(line.contains('frame_two'), isTrue);
      expect(line.contains('frame_three'), isTrue);
      // 4th and 5th frames should be truncated
      expect(line.contains('frame_four'), isFalse);
      expect(line.contains('frame_five'), isFalse);
    });

    test('Short stack preserved fully', () {
      final st = StackTrace.fromString('#0      only_frame\n#1      <asynchronous suspension>');
      final out = printer.log(_buildEvent(
        Level.error,
        '[NET:core.network.dio] single frame',
        stackTrace: st,
      ));
      expect(out.first.contains('| at '), isTrue);
      expect(out.first.contains('only_frame'), isTrue);
    });

    test('No stack trace omits the "at" segment', () {
      final out = printer.log(_buildEvent(Level.info, '[UI:features.dashboard] msg'));
      expect(out.first.contains('| at '), isFalse);
    });

    test('Explicit category in prefix overrides lookup', () {
      // [UI:pkg] is the implicit form. AppLogPrinter keeps it as-is in output.
      final out = printer.log(_buildEvent(Level.info, '[CRASH:my.package] boom'));
      expect(out.first.contains('[CRASH:my.package]'), isTrue);
    });
  });

  group('reformatAiAgentToHumanReadable', () {
    test('parses single line and adds emoji', () {
      const aiLine = '2026-06-03 18:06:12.353 [INFO ][UI:features.dashboard] hello';
      final out = reformatAiAgentToHumanReadable(aiLine);
      expect(out.contains('ℹ️'), isTrue);
      expect(out.contains('hello'), isTrue);
      expect(out.contains('features.dashboard'), isTrue);
    });

    test('parses error line with err and frames', () {
      const aiLine = '2026-06-03 18:06:12.353 [ERROR][NET:core.network.dio] failed | err=oops | at f1, f2';
      final out = reformatAiAgentToHumanReadable(aiLine);
      expect(out.contains('❌'), isTrue);
      expect(out.contains('err=oops'), isTrue);
      expect(out.contains('at f1'), isTrue);
      expect(out.contains('at f2'), isTrue);
    });

    test('non-AI-Agent line is passed through', () {
      const plain = 'this is not a log line';
      final out = reformatAiAgentToHumanReadable(plain);
      expect(out.trim(), plain);
    });
  });
}
