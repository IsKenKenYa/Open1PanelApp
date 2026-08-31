import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/features/orchestration/providers/compose_provider.dart';
import 'package:onepanel_client/features/orchestration/providers/image_provider.dart';
import 'package:onepanel_client/features/orchestration/providers/network_provider.dart';
import 'package:onepanel_client/features/orchestration/providers/volume_provider.dart';
import 'package:onepanel_client/data/models/docker_models.dart';
import 'package:onepanel_client/data/models/container_models.dart';

void main() {
  group('Orchestration Providers Initialization', () {
    test('ComposeProvider should initialize without error', () {
      final provider = ComposeProvider();
      expect(provider.composes, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('DockerImageProvider should initialize without error', () {
      final provider = DockerImageProvider();
      expect(provider.images, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('NetworkProvider should initialize without error', () {
      final provider = NetworkProvider();
      expect(provider.networks, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('VolumeProvider should initialize without error', () {
      final provider = VolumeProvider();
      expect(provider.volumes, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });
  });

  group('Orchestration Models Parsing', () {
    test('DockerImage.fromJson should parse correctly', () {
      final json = {
        'id': 'sha256:123456',
        'tags': ['nginx:latest'],
        'size': 1024,
        'created': '2023-01-01',
        'digest': 'sha256:digest'
      };

      final image = DockerImage.fromJson(json);

      expect(image.id, 'sha256:123456');
      expect(image.tags, ['nginx:latest']);
      expect(image.size, 1024);
      expect(image.created, '2023-01-01');
      expect(image.digest, 'sha256:digest');
    });

    test('DockerImage.fromJson should accept epoch seconds for created', () {
      // 回归：上游 1Panel Docker API 的 created 是 epoch 秒（int），
      // 旧实现 `as String?` 会抛类型转换异常导致镜像列表加载失败。
      final image = DockerImage.fromJson({
        'id': 'sha256:epoch',
        'tags': <String>[],
        'size': 1,
        'created': 1704067200,
      });

      expect(image.created, '2024-01-01T00:00:00.000Z');
      expect(image.createdDateTime, isNotNull);
    });

    test('DockerImage.createdDateTime should parse ISO string', () {
      final image = DockerImage.fromJson({
        'id': 'sha256:iso',
        'created': '2024-01-01T00:00:00Z',
      });
      expect(image.createdDateTime, isNotNull);
    });

    test('DockerNetwork.fromJson should normalize literal null strings', () {
      // 回归：Docker none 网络的 driver 字面为 "null"，空子网/网关会以
      // 空串出现，UI 需要统一兜底展示。
      final network = DockerNetwork.fromJson({
        'id': 'net-null',
        'name': 'none',
        'driver': 'null',
        'subnet': '',
        'gateway': 'null',
      });

      expect(network.driver, '');
      expect(network.subnet, isNull);
      expect(network.gateway, isNull);
    });

    test('DockerNetwork.fromJson should parse correctly', () {
      final json = {
        'id': 'net1',
        'name': 'my-network',
        'driver': 'bridge',
        'scope': 'local',
        'internal': false,
        'attachable': true,
        'subnet': '172.18.0.0/16',
        'gateway': '172.18.0.1'
      };

      final network = DockerNetwork.fromJson(json);

      expect(network.id, 'net1');
      expect(network.name, 'my-network');
      expect(network.driver, 'bridge');
      expect(network.scope, 'local');
      expect(network.internal, isFalse);
      expect(network.attachable, isTrue);
      expect(network.subnet, '172.18.0.0/16');
      expect(network.gateway, '172.18.0.1');
    });

    test('DockerVolume.fromJson should parse correctly', () {
      final json = {
        'name': 'vol1',
        'driver': 'local',
        'mountpoint': '/var/lib/docker/volumes/vol1/_data',
        'labels': {'key': 'value'},
        'options': {'device': 'tmpfs'}
      };

      final volume = DockerVolume.fromJson(json);

      expect(volume.name, 'vol1');
      expect(volume.driver, 'local');
      expect(volume.mountpoint, '/var/lib/docker/volumes/vol1/_data');
      expect(volume.labels, {'key': 'value'});
      expect(volume.options, {'device': 'tmpfs'});
    });

    test('ContainerCompose.fromJson should parse correctly', () {
      final json = {
        'id': 'compose1',
        'name': 'my-project',
        'path': '/opt/1panel/compose/my-project',
        'version': 'v1',
        'status': 'running',
        'createTime': '2023-01-01',
        'updateTime': '2023-01-02',
        'networks': ['net1'],
        'volumes': ['vol1'],
        'services': ['web', 'db']
      };

      final compose = ContainerCompose.fromJson(json);

      expect(compose.id, 'compose1');
      expect(compose.name, 'my-project');
      expect(compose.path, '/opt/1panel/compose/my-project');
      expect(compose.version, 'v1');
      expect(compose.status, 'running');
      expect(compose.createTime, '2023-01-01');
      expect(compose.updateTime, '2023-01-02');
      expect(compose.networks, ['net1']);
      expect(compose.volumes, ['vol1']);
      expect(compose.services, ['web', 'db']);
    });
  });
}
