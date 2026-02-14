import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import 'package:onepanelapp_app/data/models/toolbox_models.dart';

void main() {
  setUpAll(() async {
    await setupTestEnvironment();
  });

  tearDownAll(() async {
    await teardownTestEnvironment();
  });

  group('Toolbox数据模型测试', () {
    group('Clam模型测试', () {
      test('ClamCreate应该正确序列化和反序列化', () {
        final model = ClamCreate(
          alertCount: 5,
          alertMethod: 'email',
          alertTitle: '病毒检测警告',
          description: '每日系统扫描',
          infectedDir: '/var/quarantine',
          infectedStrategy: 'quarantine',
          name: '每日扫描任务',
          path: '/home',
          spec: '0 2 * * *',
          status: 'enable',
          timeout: 3600,
        );

        final json = model.toJson();
        final restored = ClamCreate.fromJson(json);

        expect(restored.alertCount, equals(model.alertCount));
        expect(restored.alertMethod, equals(model.alertMethod));
        expect(restored.name, equals(model.name));
      });

      test('ClamDelete应该正确序列化和反序列化', () {
        final model = ClamDelete(
          ids: [1, 2, 3],
          removeInfected: true,
        );

        final json = model.toJson();
        final restored = ClamDelete.fromJson(json);

        expect(restored.ids, equals(model.ids));
        expect(restored.removeInfected, equals(model.removeInfected));
      });

      test('ClamUpdate应该正确序列化和反序列化', () {
        final model = ClamUpdate(
          id: 1,
          name: '更新后的任务',
          status: 'disable',
          timeout: 7200,
        );

        final json = model.toJson();
        final restored = ClamUpdate.fromJson(json);

        expect(restored.id, equals(model.id));
        expect(restored.name, equals(model.name));
      });

      test('ClamBaseInfo应该正确序列化和反序列化', () {
        final model = ClamBaseInfo(
          id: 1,
          name: '测试任务',
          status: 'enable',
          path: '/home',
          spec: '0 2 * * *',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        final json = model.toJson();
        final restored = ClamBaseInfo.fromJson(json);

        expect(restored.id, equals(model.id));
        expect(restored.name, equals(model.name));
        expect(restored.status, equals(model.status));
      });

      test('ClamFileReq应该正确序列化和反序列化', () {
        final model = ClamFileReq(
          clamId: 1,
          name: 'test.txt',
          page: 1,
          pageSize: 20,
        );

        final json = model.toJson();
        final restored = ClamFileReq.fromJson(json);

        expect(restored.clamId, equals(model.clamId));
        expect(restored.page, equals(model.page));
      });
    });

    group('Device模型测试', () {
      test('DeviceBaseInfo应该正确序列化和反序列化', () {
        final model = DeviceBaseInfo(
          dns: '8.8.8.8',
          hostname: 'test-server',
          localTime: '2024-01-01T00:00:00Z',
          ntp: 'ntp.example.com',
          productName: '1Panel',
          productVersion: '2.0.0',
          systemName: 'Ubuntu',
          systemVersion: '22.04',
          timeZone: 'Asia/Shanghai',
        );

        final json = model.toJson();
        final restored = DeviceBaseInfo.fromJson(json);

        expect(restored.hostname, equals(model.hostname));
        expect(restored.dns, equals(model.dns));
      });

      test('DeviceConfUpdate应该正确序列化和反序列化', () {
        final model = DeviceConfUpdate(
          dns: '8.8.4.4',
          hostname: 'new-hostname',
          ntp: 'ntp.new.com',
          swap: '2G',
        );

        final json = model.toJson();
        final restored = DeviceConfUpdate.fromJson(json);

        expect(restored.hostname, equals(model.hostname));
        expect(restored.swap, equals(model.swap));
      });

      test('DevicePasswdUpdate应该正确序列化和反序列化', () {
        final model = DevicePasswdUpdate(
          oldPasswd: 'oldPassword123',
          newPasswd: 'newPassword456',
        );

        final json = model.toJson();
        final restored = DevicePasswdUpdate.fromJson(json);

        expect(restored.oldPasswd, equals(model.oldPasswd));
        expect(restored.newPasswd, equals(model.newPasswd));
      });
    });

    group('Fail2ban模型测试', () {
      test('Fail2banBaseInfo应该正确序列化和反序列化', () {
        final model = Fail2banBaseInfo(
          bantime: '3600',
          findtime: '600',
          isEnable: true,
          maxretry: '5',
          port: '22',
          version: '1.0.0',
        );

        final json = model.toJson();
        final restored = Fail2banBaseInfo.fromJson(json);

        expect(restored.isEnable, equals(model.isEnable));
        expect(restored.maxretry, equals(model.maxretry));
      });

      test('Fail2banUpdate应该正确序列化和反序列化', () {
        final model = Fail2banUpdate(
          bantime: '7200',
          findtime: '300',
          isEnable: false,
          maxretry: '3',
          port: '2222',
        );

        final json = model.toJson();
        final restored = Fail2banUpdate.fromJson(json);

        expect(restored.bantime, equals(model.bantime));
        expect(restored.isEnable, equals(model.isEnable));
      });

      test('Fail2banSearch应该正确序列化和反序列化', () {
        final model = Fail2banSearch(
          ip: '192.168.1.1',
          page: 1,
          pageSize: 20,
          status: 'banned',
        );

        final json = model.toJson();
        final restored = Fail2banSearch.fromJson(json);

        expect(restored.ip, equals(model.ip));
        expect(restored.status, equals(model.status));
      });

      test('Fail2banRecord应该正确序列化和反序列化', () {
        final model = Fail2banRecord(
          createdAt: '2024-01-01T00:00:00Z',
          ip: '192.168.1.100',
          status: 'banned',
        );

        final json = model.toJson();
        final restored = Fail2banRecord.fromJson(json);

        expect(restored.ip, equals(model.ip));
        expect(restored.status, equals(model.status));
      });
    });

    group('FTP模型测试', () {
      test('FtpBaseInfo应该正确序列化和反序列化', () {
        final model = FtpBaseInfo(
          baseDir: '/var/ftp',
          status: 'running',
          version: '1.0.0',
        );

        final json = model.toJson();
        final restored = FtpBaseInfo.fromJson(json);

        expect(restored.baseDir, equals(model.baseDir));
        expect(restored.status, equals(model.status));
      });

      test('FtpCreate应该正确序列化和反序列化', () {
        final model = FtpCreate(
          baseDir: '/var/ftp/user1',
          password: 'securePassword123',
          path: '/home/user1',
          user: 'user1',
        );

        final json = model.toJson();
        final restored = FtpCreate.fromJson(json);

        expect(restored.user, equals(model.user));
        expect(restored.baseDir, equals(model.baseDir));
      });

      test('FtpUpdate应该正确序列化和反序列化', () {
        final model = FtpUpdate(
          id: 1,
          user: 'updated_user',
          baseDir: '/var/ftp/updated',
          path: '/home/updated',
        );

        final json = model.toJson();
        final restored = FtpUpdate.fromJson(json);

        expect(restored.id, equals(model.id));
        expect(restored.user, equals(model.user));
      });

      test('FtpDelete应该正确序列化和反序列化', () {
        final model = FtpDelete(
          ids: [1, 2, 3],
        );

        final json = model.toJson();
        final restored = FtpDelete.fromJson(json);

        expect(restored.ids, equals(model.ids));
      });

      test('FtpSearch应该正确序列化和反序列化', () {
        final model = FtpSearch(
          info: 'user1',
          page: 1,
          pageSize: 20,
        );

        final json = model.toJson();
        final restored = FtpSearch.fromJson(json);

        expect(restored.info, equals(model.info));
        expect(restored.page, equals(model.page));
      });

      test('FtpInfo应该正确序列化和反序列化', () {
        final model = FtpInfo(
          id: 1,
          user: 'testuser',
          baseDir: '/var/ftp/testuser',
          path: '/home/testuser',
          status: 'active',
          createdAt: '2024-01-01T00:00:00Z',
        );

        final json = model.toJson();
        final restored = FtpInfo.fromJson(json);

        expect(restored.id, equals(model.id));
        expect(restored.user, equals(model.user));
      });
    });

    group('Clean模型测试', () {
      test('Clean应该正确序列化和反序列化', () {
        final model = Clean(
          cleanData: ['/tmp', '/var/log', '/var/cache'],
        );

        final json = model.toJson();
        final restored = Clean.fromJson(json);

        expect(restored.cleanData, equals(model.cleanData));
      });

      test('CleanData应该正确序列化和反序列化', () {
        final model = CleanData(
          name: '临时文件',
          size: '1.5GB',
          path: '/tmp',
        );

        final json = model.toJson();
        final restored = CleanData.fromJson(json);

        expect(restored.name, equals(model.name));
        expect(restored.size, equals(model.size));
      });

      test('CleanTree应该正确序列化和反序列化', () {
        final model = CleanTree(
          label: '系统清理',
          value: 'system',
          children: [
            CleanTree(label: '临时文件', value: '/tmp'),
            CleanTree(label: '日志文件', value: '/var/log'),
          ],
        );

        final json = model.toJson();
        final restored = CleanTree.fromJson(json);

        expect(restored.label, equals(model.label));
        expect(restored.children?.length, equals(2));
      });

      test('CleanLog应该正确序列化和反序列化', () {
        final model = CleanLog(
          id: 1,
          createdAt: '2024-01-01T00:00:00Z',
          detail: '清理完成',
          status: 'success',
        );

        final json = model.toJson();
        final restored = CleanLog.fromJson(json);

        expect(restored.id, equals(model.id));
        expect(restored.status, equals(model.status));
      });
    });

    group('Scan模型测试', () {
      test('Scan应该正确序列化和反序列化', () {
        final model = Scan(
          scanType: 'system',
        );

        final json = model.toJson();
        final restored = Scan.fromJson(json);

        expect(restored.scanType, equals(model.scanType));
      });
    });
  });

  group('Toolbox模型边界条件测试', () {
    test('空列表应该正确处理', () {
      final model = Clean(cleanData: []);
      final json = model.toJson();
      final restored = Clean.fromJson(json);

      expect(restored.cleanData, isEmpty);
    });

    test('null值应该正确处理', () {
      final model = ClamCreate(
        name: 'test',
        path: '/home',
      );

      final json = model.toJson();
      final restored = ClamCreate.fromJson(json);

      expect(restored.alertCount, isNull);
      expect(restored.name, equals('test'));
    });

    test('特殊字符应该正确处理', () {
      final model = FtpCreate(
        user: 'user@domain.com',
        baseDir: '/var/ftp/user_123',
        path: '/home/user with spaces',
      );

      final json = model.toJson();
      final restored = FtpCreate.fromJson(json);

      expect(restored.user, equals('user@domain.com'));
      expect(restored.path, equals('/home/user with spaces'));
    });

    test('Unicode字符应该正确处理', () {
      final model = DeviceBaseInfo(
        hostname: '测试主机🔧',
        timeZone: 'Asia/Shanghai',
      );

      final json = model.toJson();
      final restored = DeviceBaseInfo.fromJson(json);

      expect(restored.hostname, equals('测试主机🔧'));
    });
  });
}
