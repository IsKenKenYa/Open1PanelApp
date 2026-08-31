import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/container_extension_models.dart';
import 'package:onepanel_client/data/models/container_models.dart';
import 'package:onepanel_client/data/models/docker_models.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/features/containers/containers_provider.dart';
import 'package:onepanel_client/features/containers/container_service.dart';

class MockContainerService extends Mock implements ContainerService {}

void main() {
  group('ContainersProvider behavior', () {
    late MockContainerService service;
    late ContainersProvider provider;

    ContainerStatus buildStatus() => const ContainerStatus(
          all: 0,
          running: 0,
          paused: 0,
          exited: 0,
          created: 0,
          dead: 0,
          removing: 0,
          restarting: 0,
          containerCount: 0,
          imageCount: 0,
          imageSize: 0,
          networkCount: 0,
          volumeCount: 0,
          composeCount: 0,
          composeTemplateCount: 0,
          repoCount: 0,
        );

    setUp(() {
      service = MockContainerService();
      provider = ContainersProvider(service: service);
      when(() => service.listContainers())
          .thenAnswer((_) async => const <ContainerInfo>[]);
      when(() => service.listImages())
          .thenAnswer((_) async => const <ContainerImage>[]);
      when(() => service.listRepos())
          .thenAnswer((_) async => const <ContainerRepo>[]);
      when(() => service.listTemplates())
          .thenAnswer((_) async => const <ContainerTemplate>[]);
      when(() => service.getContainerStatus())
          .thenAnswer((_) async => buildStatus());
      when(() => service.getDaemonJson()).thenAnswer((_) async => '{}');
      when(() => service.listComposesPage()).thenAnswer(
        (_) async => PageResult<ComposeProject>(items: const [], total: 0),
      );
      when(() => service.listContainerStats())
          .thenAnswer((_) async => const <ContainerListStats>[]);
    });

    test('loadContainers computes running stopped and paused counts',
        () async {
      when(() => service.listContainers()).thenAnswer((_) async => const [
            ContainerInfo(
              id: '1',
              name: 'web',
              image: 'nginx:latest',
              status: 'Up 2 hours',
              state: 'running',
            ),
            ContainerInfo(
              id: '2',
              name: 'db',
              image: 'mysql:8',
              status: 'Exited (0)',
              state: 'exited',
            ),
            ContainerInfo(
              id: '3',
              name: 'cache',
              image: 'redis:7',
              status: 'Up (Paused)',
              state: 'paused',
            ),
          ]);

      await provider.loadContainers();

      expect(provider.data.containerStats.total, 3);
      expect(provider.data.containerStats.running, 1);
      expect(provider.data.containerStats.stopped, 1);
      expect(provider.data.containerStats.paused, 1);
      expect(provider.containersState.error, isNull);
      expect(provider.containersState.isLoading, isFalse);
    });

    test('loadImages populates image stats', () async {
      when(() => service.listImages()).thenAnswer((_) async => const [
            ContainerImage(id: 'img-1', repoTags: ['nginx:latest']),
            ContainerImage(id: 'img-2', repoTags: ['mysql:8']),
          ]);

      await provider.loadImages();

      expect(provider.data.images, hasLength(2));
      expect(provider.data.imageStats.total, 2);
      expect(provider.data.imageStats.used, 2);
      expect(provider.data.imageStats.unused, 0);
      expect(provider.imagesState.error, isNull);
    });

    test('loadImages failure exposes error and keeps state clean', () async {
      when(() => service.listImages()).thenThrow(Exception('images down'));

      await provider.loadImages();

      expect(provider.imagesState.error, contains('加载镜像失败'));
      expect(provider.imagesState.isLoading, isFalse);
      expect(provider.data.images, isEmpty);
    });

    test('loadAll isolates section failures so healthy sections still load',
        () async {
      when(() => service.listContainers())
          .thenThrow(Exception('containers down'));
      when(() => service.listRepos()).thenAnswer((_) async => const [
            ContainerRepo(
              id: 1,
              name: 'dockerhub',
              downloadUrl: 'https://registry.example.com',
              createdAt: '2026-03-29T00:00:00Z',
              updatedAt: '2026-03-29T00:00:00Z',
            ),
          ]);

      await provider.loadAll();

      expect(provider.containersState.error, contains('加载容器失败'));
      expect(provider.reposState.error, isNull);
      expect(provider.data.repos, hasLength(1));
      expect(provider.imagesState.error, isNull);
      expect(provider.configState.error, isNull);
      expect(provider.data.isLoading, isFalse);
    });

    test('startContainer refreshes container list on success', () async {
      var containers = const [
        ContainerInfo(
          id: 'c1',
          name: 'web',
          image: 'nginx:latest',
          status: 'Exited',
          state: 'exited',
        ),
      ];
      when(() => service.listContainers()).thenAnswer((_) async => containers);
      when(() => service.startContainer('c1')).thenAnswer((_) async {
        containers = const [
          ContainerInfo(
            id: 'c1',
            name: 'web',
            image: 'nginx:latest',
            status: 'Up 1 second',
            state: 'running',
          ),
        ];
      });

      await provider.loadContainers();
      expect(provider.data.containers.first.state, 'exited');

      expect(await provider.startContainer('c1'), isTrue);
      expect(provider.data.containers.first.state, 'running');
      verify(() => service.startContainer('c1')).called(1);
    });

    test('stopContainer failure exposes error and returns false', () async {
      when(() => service.stopContainer('c1'))
          .thenThrow(Exception('stop failed'));

      expect(await provider.stopContainer('c1'), isFalse);
      expect(provider.data.error, contains('停止容器失败'));
    });

    test('deleteImage rejects non numeric id without touching service',
        () async {
      expect(await provider.deleteImage('abc'), isFalse);
      expect(provider.data.error, contains('无效镜像ID'));
      verifyNever(() => service.removeImage(any()));
    });

    test('commitContainer refreshes images instead of containers', () async {
      const request = ContainerCommit(
        containerID: 'c1',
        containerName: 'web',
        newImageName: 'web-backup:latest',
      );
      when(() => service.commitContainer(request)).thenAnswer((_) async {});

      await provider.loadContainers();
      clearInteractions(service);

      expect(await provider.commitContainer(request), isTrue);
      verify(() => service.listImages()).called(1);
      verifyNever(() => service.listContainers());
    });

    test('cleanContainerLog succeeds without refreshing lists', () async {
      when(() => service.cleanContainerLog('web')).thenAnswer((_) async {});

      await provider.loadContainers();
      clearInteractions(service);

      expect(await provider.cleanContainerLog('web'), isTrue);
      verifyNever(() => service.listContainers());
      verifyNever(() => service.listImages());
    });

    test('clearError resets every section error', () async {
      when(() => service.listContainers()).thenThrow(Exception('c down'));
      when(() => service.listRepos()).thenThrow(Exception('r down'));

      await provider.loadContainers();
      await provider.loadRepos();
      expect(provider.containersState.error, isNotNull);
      expect(provider.reposState.error, isNotNull);

      provider.clearError();

      expect(provider.containersState.error, isNull);
      expect(provider.reposState.error, isNull);
      expect(provider.data.error, isNull);
    });

    test('loadStatus failure exposes overview error and recovers on retry',
        () async {
      when(() => service.getContainerStatus())
          .thenThrow(Exception('status down'));

      await provider.loadStatus();
      expect(provider.overviewState.error, contains('Load status failed'));
      expect(provider.overviewState.isLoading, isFalse);

      when(() => service.getContainerStatus())
          .thenAnswer((_) async => buildStatus());
      await provider.loadStatus();

      expect(provider.overviewState.error, isNull);
      expect(provider.data.status, isNotNull);
    });
  });
}
