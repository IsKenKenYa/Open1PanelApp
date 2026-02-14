import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import 'package:onepanelapp_app/data/models/common_models.dart';

void main() {
  setUpAll(() async {
    await setupTestEnvironment();
  });

  tearDownAll(() async {
    await teardownTestEnvironment();
  });

  group('Command数据模型测试', () {
    test('CommandInfo应该正确序列化和反序列化', () {
      final model = CommandInfo(
        id: 1,
        name: '重启服务',
        command: 'systemctl restart nginx',
        groupBelong: '系统管理',
        groupID: 1,
        type: 'shell',
      );

      final json = model.toJson();
      final restored = CommandInfo.fromJson(json);

      expect(restored.id, equals(model.id));
      expect(restored.name, equals(model.name));
      expect(restored.command, equals(model.command));
      expect(restored.groupBelong, equals(model.groupBelong));
      expect(restored.groupID, equals(model.groupID));
      expect(restored.type, equals(model.type));
    });

    test('CommandInfo应该处理null值', () {
      final model = CommandInfo(
        id: 1,
        name: '简单命令',
      );

      final json = model.toJson();
      final restored = CommandInfo.fromJson(json);

      expect(restored.command, isNull);
      expect(restored.groupBelong, isNull);
    });

    test('CommandOperate应该正确序列化和反序列化', () {
      final model = CommandOperate(
        id: 1,
        name: '更新系统',
        command: 'apt update && apt upgrade -y',
        groupBelong: '系统维护',
        groupID: 2,
        type: 'shell',
      );

      final json = model.toJson();
      final restored = CommandOperate.fromJson(json);

      expect(restored.id, equals(model.id));
      expect(restored.name, equals(model.name));
      expect(restored.command, equals(model.command));
    });

    test('CommandOperate的必填字段验证', () {
      final model = CommandOperate(
        name: '测试命令',
        command: 'echo "test"',
      );

      final json = model.toJson();
      expect(json['name'], equals('测试命令'));
      expect(json['command'], equals('echo "test"'));
    });

    test('CommandTree应该正确序列化和反序列化', () {
      final model = CommandTree(
        label: '系统管理',
        value: 'system',
        children: [
          CommandTree(label: '服务管理', value: 'service'),
          CommandTree(label: '网络管理', value: 'network'),
        ],
      );

      final json = model.toJson();
      final restored = CommandTree.fromJson(json);

      expect(restored.label, equals(model.label));
      expect(restored.value, equals(model.value));
      expect(restored.children?.length, equals(2));
      expect(restored.children?[0].label, equals('服务管理'));
    });

    test('CommandTree应该处理空children', () {
      final model = CommandTree(
        label: '根节点',
        value: 'root',
      );

      final json = model.toJson();
      final restored = CommandTree.fromJson(json);

      expect(restored.children, isNull);
    });

    test('CommandTree应该处理嵌套结构', () {
      final model = CommandTree(
        label: '根',
        value: 'root',
        children: [
          CommandTree(
            label: '一级',
            value: 'level1',
            children: [
              CommandTree(label: '二级', value: 'level2'),
            ],
          ),
        ],
      );

      final json = model.toJson();
      final restored = CommandTree.fromJson(json);

      expect(restored.children?[0].children?[0].label, equals('二级'));
    });
  });

  group('Script数据模型测试', () {
    test('ScriptOperate应该正确序列化和反序列化', () {
      final model = ScriptOperate(
        id: 1,
        name: '备份脚本',
        description: '每日自动备份数据',
        script: '#!/bin/bash\nbackup_data()',
        groups: '备份任务',
        isInteractive: false,
      );

      final json = model.toJson();
      final restored = ScriptOperate.fromJson(json);

      expect(restored.id, equals(model.id));
      expect(restored.name, equals(model.name));
      expect(restored.description, equals(model.description));
      expect(restored.script, equals(model.script));
      expect(restored.groups, equals(model.groups));
      expect(restored.isInteractive, equals(model.isInteractive));
    });

    test('ScriptOperate应该处理null值', () {
      final model = ScriptOperate(
        name: '简单脚本',
      );

      final json = model.toJson();
      final restored = ScriptOperate.fromJson(json);

      expect(restored.description, isNull);
      expect(restored.script, isNull);
      expect(restored.isInteractive, isNull);
    });

    test('ScriptOperate应该处理多行脚本', () {
      final scriptContent = '''#!/bin/bash
# 这是一个多行脚本
echo "开始执行"
cd /var/www
ls -la
echo "执行完成"''';

      final model = ScriptOperate(
        name: '多行脚本',
        script: scriptContent,
      );

      final json = model.toJson();
      final restored = ScriptOperate.fromJson(json);

      expect(restored.script, equals(scriptContent));
    });

    test('ScriptOptions应该正确序列化和反序列化', () {
      final model = ScriptOptions(
        id: 1,
        name: '脚本选项1',
      );

      final json = model.toJson();
      final restored = ScriptOptions.fromJson(json);

      expect(restored.id, equals(model.id));
      expect(restored.name, equals(model.name));
    });

    test('ScriptOptions应该处理null值', () {
      final model = ScriptOptions();

      final json = model.toJson();
      final restored = ScriptOptions.fromJson(json);

      expect(restored.id, isNull);
      expect(restored.name, isNull);
    });
  });

  group('Command边界条件测试', () {
    test('Command应该处理空字符串', () {
      final model = CommandInfo(
        id: 1,
        name: '',
        command: '',
      );

      final json = model.toJson();
      final restored = CommandInfo.fromJson(json);

      expect(restored.name, equals(''));
      expect(restored.command, equals(''));
    });

    test('Command应该处理特殊字符', () {
      final model = CommandInfo(
        id: 1,
        name: '命令 & 管道',
        command: 'ls -la | grep "test" > /dev/null 2>&1',
      );

      final json = model.toJson();
      final restored = CommandInfo.fromJson(json);

      expect(restored.name, equals('命令 & 管道'));
      expect(restored.command, equals('ls -la | grep "test" > /dev/null 2>&1'));
    });

    test('Command应该处理Unicode字符', () {
      final model = CommandInfo(
        id: 1,
        name: '🚀 部署脚本',
        command: 'echo "你好世界"',
      );

      final json = model.toJson();
      final restored = CommandInfo.fromJson(json);

      expect(restored.name, equals('🚀 部署脚本'));
      expect(restored.command, equals('echo "你好世界"'));
    });

    test('Command应该处理很长的命令', () {
      final longCommand = 'echo "${'a' * 10000}"';
      final model = CommandInfo(
        id: 1,
        name: '长命令',
        command: longCommand,
      );

      final json = model.toJson();
      final restored = CommandInfo.fromJson(json);

      expect(restored.command?.length, equals(longCommand.length));
    });
  });

  group('Script边界条件测试', () {
    test('Script应该处理空脚本内容', () {
      final model = ScriptOperate(
        name: '空脚本',
        script: '',
      );

      final json = model.toJson();
      final restored = ScriptOperate.fromJson(json);

      expect(restored.script, equals(''));
    });

    test('Script应该处理特殊字符', () {
      final model = ScriptOperate(
        name: '特殊字符脚本',
        script: '#!/bin/bash\necho "<>&\'"',
      );

      final json = model.toJson();
      final restored = ScriptOperate.fromJson(json);

      expect(restored.script, equals('#!/bin/bash\necho "<>&\'"'));
    });

    test('Script应该处理Unicode字符', () {
      final model = ScriptOperate(
        name: '🚀 部署脚本',
        script: 'echo "你好世界 🌍"',
      );

      final json = model.toJson();
      final restored = ScriptOperate.fromJson(json);

      expect(restored.name, equals('🚀 部署脚本'));
      expect(restored.script, equals('echo "你好世界 🌍"'));
    });

    test('Script应该处理长脚本', () {
      final longScript = 'echo "${'a' * 10000}"';
      final model = ScriptOperate(
        name: '长脚本',
        script: longScript,
      );

      final json = model.toJson();
      final restored = ScriptOperate.fromJson(json);

      expect(restored.script?.length, equals(longScript.length));
    });
  });
}
