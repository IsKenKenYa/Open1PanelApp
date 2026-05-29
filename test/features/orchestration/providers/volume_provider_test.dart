import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/container_docker_models.dart';
import 'package:onepanel_client/data/models/docker_models.dart';
import 'package:onepanel_client/features/orchestration/providers/volume_provider.dart';
import 'package:onepanel_client/features/orchestration/services/orchestration_service.dart';

class MockOrchestrationService extends Mock implements OrchestrationService {}

void main() {
  late MockOrchestrationService service;
  late VolumeProvider provider;

  const testVolume = DockerVolume(
    name: 'app-data',
    driver: 'local',
    mountpoint: '/var/lib/docker/volumes/app-data/_data',
    labels: {'env': 'prod'},
    options: {'type': 'nfs'},
  );

  const testVolume2 = DockerVolume(
    name: 'db-data',
    driver: 'local',
    mountpoint: '/var/lib/docker/volumes/db-data/_data',
  );

  setUp(() {
    service = MockOrchestrationService();
    provider = VolumeProvider(service: service);
  });

  setUpAll(() {
    registerFallbackValue(const VolumeCreate(name: ''));
  });

  group('VolumeProvider', () {
    group('initial state', () {
      test('has empty volumes, no loading, no error', () {
        expect(provider.volumes, isEmpty);
        expect(provider.isLoading, isFalse);
        expect(provider.error, isNull);
      });
    });

    group('loadVolumes', () {
      test('success populates list and clears error', () async {
        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume, testVolume2]);

        await provider.loadVolumes();

        expect(provider.volumes, hasLength(2));
        expect(provider.volumes.first.name, 'app-data');
        expect(provider.volumes.last.name, 'db-data');
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
      });

      test('failure sets error and keeps list empty', () async {
        when(() => service.loadVolumes())
            .thenThrow(Exception('connection refused'));

        await provider.loadVolumes();

        expect(provider.volumes, isEmpty);
        expect(provider.error, contains('connection refused'));
        expect(provider.isLoading, isFalse);
      });

      test('sets isLoading during request', () async {
        final completer = Completer<List<DockerVolume>>();
        when(() => service.loadVolumes()).thenAnswer((_) => completer.future);

        final future = provider.loadVolumes();
        expect(provider.isLoading, isTrue);
        expect(provider.error, isNull);

        completer.complete([testVolume]);
        await future;

        expect(provider.isLoading, isFalse);
      });

      test('success replaces previous error', () async {
        when(() => service.loadVolumes())
            .thenThrow(Exception('first error'));
        await provider.loadVolumes();
        expect(provider.error, isNotNull);

        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume]);
        await provider.loadVolumes();

        expect(provider.error, isNull);
        expect(provider.volumes, hasLength(1));
      });

      test('failure keeps previous data and sets error', () async {
        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume]);
        await provider.loadVolumes();
        expect(provider.volumes, hasLength(1));

        when(() => service.loadVolumes())
            .thenThrow(Exception('second error'));
        await provider.loadVolumes();

        expect(provider.volumes, hasLength(1));
        expect(provider.error, contains('second error'));
      });
    });

    group('createVolume', () {
      test('success reloads list and returns true', () async {
        const request = VolumeCreate(name: 'new-vol', driver: 'local');
        when(() => service.createVolume(request))
            .thenAnswer((_) async {});
        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume]);

        final result = await provider.createVolume(request);

        expect(result, isTrue);
        expect(provider.volumes, hasLength(1));
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
        verify(() => service.createVolume(request)).called(1);
        verify(() => service.loadVolumes()).called(1);
      });

      test('failure sets error and returns false', () async {
        const request = VolumeCreate(name: 'bad-vol');
        when(() => service.createVolume(request))
            .thenThrow(Exception('name conflict'));

        final result = await provider.createVolume(request);

        expect(result, isFalse);
        expect(provider.error, contains('name conflict'));
        expect(provider.isLoading, isFalse);
        verify(() => service.createVolume(request)).called(1);
        verifyNever(() => service.loadVolumes());
      });

      test('success with all optional fields', () async {
        const request = VolumeCreate(
          name: 'full-vol',
          driver: 'local',
          driverOpts: {'type': 'nfs', 'device': ':/data'},
          labels: {'env': 'prod', 'team': 'backend'},
        );
        when(() => service.createVolume(request))
            .thenAnswer((_) async {});
        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume]);

        final result = await provider.createVolume(request);

        expect(result, isTrue);
        verify(() => service.createVolume(request)).called(1);
      });
    });

    group('removeVolume', () {
      test('success reloads list and returns true', () async {
        when(() => service.removeVolume('app-data'))
            .thenAnswer((_) async {});
        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume2]);

        final result = await provider.removeVolume('app-data');

        expect(result, isTrue);
        expect(provider.volumes, hasLength(1));
        expect(provider.volumes.first.name, 'db-data');
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
        verify(() => service.removeVolume('app-data')).called(1);
        verify(() => service.loadVolumes()).called(1);
      });

      test('failure sets error and returns false', () async {
        when(() => service.removeVolume('app-data'))
            .thenThrow(Exception('in use'));

        final result = await provider.removeVolume('app-data');

        expect(result, isFalse);
        expect(provider.error, contains('in use'));
        expect(provider.isLoading, isFalse);
        verify(() => service.removeVolume('app-data')).called(1);
        verifyNever(() => service.loadVolumes());
      });
    });

    group('onServerChanged', () {
      test('clears state without reload', () async {
        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume]);
        await provider.loadVolumes();
        expect(provider.volumes, hasLength(1));

        clearInteractions(service);
        await provider.onServerChanged();

        expect(provider.volumes, isEmpty);
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
        verifyNever(() => service.loadVolumes());
      });

      test('clears state and reloads when reload is true', () async {
        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume]);
        await provider.loadVolumes();

        when(() => service.loadVolumes())
            .thenAnswer((_) async => [testVolume, testVolume2]);
        await provider.onServerChanged(reload: true);

        expect(provider.volumes, hasLength(2));
        verify(() => service.loadVolumes()).called(greaterThanOrEqualTo(1));
      });

      test('clears error from previous failed request', () async {
        when(() => service.loadVolumes())
            .thenThrow(Exception('timeout'));
        await provider.loadVolumes();
        expect(provider.error, isNotNull);

        await provider.onServerChanged();

        expect(provider.error, isNull);
        expect(provider.volumes, isEmpty);
      });
    });
  });
}
