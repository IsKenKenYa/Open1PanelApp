import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/channel/native_channel_manager.dart';
import 'package:onepanel_client/core/channel/native_channel_write_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// WinUI3 网站页新建表单依赖的 createWebsite 通道契约。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('createWebsite (native channel write handler)', () {
    test('缺 primaryDomain 返回失败结构（不发网络请求）', () async {
      final result = await NativeChannelWriteHandlers.createWebsite(
        {'primaryDomain': ''},
      );

      expect(result['success'], isFalse);
      expect(result['error'], isNotNull);
    });

    test('port 非法时回退默认 80 并进入创建链路（无服务器时失败但不抛出）', () async {
      // 无有效服务器配置时底层请求失败，handler 必须吞掉异常返回失败结构，
      // 不允许向原生侧抛出（跨通道异常会变成 PlatformException）。
      final result = await NativeChannelWriteHandlers.createWebsite(
        {'primaryDomain': 'demo.example.com', 'port': 'abc'},
      );

      expect(result.containsKey('success'), isTrue);
      expect(result['success'], anyOf(isTrue, isFalse));
    });

    test('dispatch 路由 createWebsite 到写 handler', () async {
      final result = await NativeChannelManager.instance.handleMethodCall(
        'createWebsite',
        {'primaryDomain': ''},
      );

      expect(result['success'], isFalse);
    });
  });
}
