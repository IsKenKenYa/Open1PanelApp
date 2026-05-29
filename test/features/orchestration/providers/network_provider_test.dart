import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/container_docker_models.dart';
import 'package:onepanel_client/data/models/docker_models.dart';
import 'package:onepanel_client/features/orchestration/providers/network_provider.dart';
import 'package:onepanel_client/features/orchestration/services/orchestration_service.dart';

class MockOrchestrationService extends Mock implements OrchestrationService {}

void main() {
  late MockOrchestrationService service;
  late NetworkProvider provider;

  const testNetwork = DockerNetwork(
    id: 'net-1',
    name: 'test-bridge',
    driver: 'bridge',
    scope: 'local',
    internal: false,
    attachable: true,
    subnet: '172.20.0.0/16',
    gateway: '172.20.0.1',
  );

  const testNetwork2 = DockerNetwork(
    id: 'net-2',
    name: 'test-overlay',
    driver: 'overlay',
    scope: 'swarm',
  );

  setUp(() {
    service = MockOrchestrationService();
    provider = NetworkProvider(service: service);
  });

  setUpAll(() {
    registerFallbackValue(
      const NetworkCreate(name: ''),
    );
  });

  group('NetworkProvider', () {
    group('initial state', () {
      test('has empty networks, no loading, no error', () {
        expect(provider.networks, isEmpty);
        expect(provider.isLoading, isFalse);
        expect(provider.error, isNull);
      });
    });

    group('loadNetworks', () {
      test('success populates list and clears error', () async {
        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork, testNetwork2]);

        await provider.loadNetworks();

        expect(provider.networks, hasLength(2));
        expect(provider.networks.first.name, 'test-bridge');
        expect(provider.networks.last.name, 'test-overlay');
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
      });

      test('failure sets error and keeps list empty', () async {
        when(() => service.loadNetworks())
            .thenThrow(Exception('connection refused'));

        await provider.loadNetworks();

        expect(provider.networks, isEmpty);
        expect(provider.error, contains('connection refused'));
        expect(provider.isLoading, isFalse);
      });

      test('sets isLoading during request', () async {
        final completer = Completer<List<DockerNetwork>>();
        when(() => service.loadNetworks()).thenAnswer((_) => completer.future);

        final future = provider.loadNetworks();
        expect(provider.isLoading, isTrue);
        expect(provider.error, isNull);

        completer.complete([testNetwork]);
        await future;

        expect(provider.isLoading, isFalse);
      });

      test('success replaces previous error', () async {
        when(() => service.loadNetworks())
            .thenThrow(Exception('first error'));
        await provider.loadNetworks();
        expect(provider.error, isNotNull);

        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork]);
        await provider.loadNetworks();

        expect(provider.error, isNull);
        expect(provider.networks, hasLength(1));
      });

      test('failure keeps previous data and sets error', () async {
        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork]);
        await provider.loadNetworks();
        expect(provider.networks, hasLength(1));

        when(() => service.loadNetworks())
            .thenThrow(Exception('second error'));
        await provider.loadNetworks();

        expect(provider.networks, hasLength(1));
        expect(provider.error, contains('second error'));
      });
    });

    group('createNetwork', () {
      test('success reloads list and returns true', () async {
        const request = NetworkCreate(name: 'new-net', driver: 'bridge');
        when(() => service.createNetwork(request))
            .thenAnswer((_) async {});
        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork]);

        final result = await provider.createNetwork(request);

        expect(result, isTrue);
        expect(provider.networks, hasLength(1));
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
        verify(() => service.createNetwork(request)).called(1);
        verify(() => service.loadNetworks()).called(1);
      });

      test('failure sets error and returns false', () async {
        const request = NetworkCreate(name: 'bad-net');
        when(() => service.createNetwork(request))
            .thenThrow(Exception('name conflict'));

        final result = await provider.createNetwork(request);

        expect(result, isFalse);
        expect(provider.error, contains('name conflict'));
        expect(provider.isLoading, isFalse);
        verify(() => service.createNetwork(request)).called(1);
        verifyNever(() => service.loadNetworks());
      });

      test('success with all optional fields', () async {
        const request = NetworkCreate(
          name: 'full-net',
          driver: 'overlay',
          internal: true,
          attachable: true,
          enableIPv6: true,
          subnet: '10.0.0.0/24',
          gateway: '10.0.0.1',
          labels: {'env': 'prod'},
        );
        when(() => service.createNetwork(request))
            .thenAnswer((_) async {});
        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork]);

        final result = await provider.createNetwork(request);

        expect(result, isTrue);
        verify(() => service.createNetwork(request)).called(1);
      });
    });

    group('removeNetwork', () {
      test('success reloads list and returns true', () async {
        when(() => service.removeNetwork('net-1'))
            .thenAnswer((_) async {});
        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork2]);

        final result = await provider.removeNetwork('net-1');

        expect(result, isTrue);
        expect(provider.networks, hasLength(1));
        expect(provider.networks.first.id, 'net-2');
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
        verify(() => service.removeNetwork('net-1')).called(1);
        verify(() => service.loadNetworks()).called(1);
      });

      test('failure sets error and returns false', () async {
        when(() => service.removeNetwork('net-1'))
            .thenThrow(Exception('in use'));

        final result = await provider.removeNetwork('net-1');

        expect(result, isFalse);
        expect(provider.error, contains('in use'));
        expect(provider.isLoading, isFalse);
        verify(() => service.removeNetwork('net-1')).called(1);
        verifyNever(() => service.loadNetworks());
      });
    });

    group('onServerChanged', () {
      test('clears state without reload', () async {
        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork]);
        await provider.loadNetworks();
        expect(provider.networks, hasLength(1));

        await provider.onServerChanged();

        expect(provider.networks, isEmpty);
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
        verify(() => service.loadNetworks()).called(1);
      });

      test('clears state and reloads when reload is true', () async {
        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork]);
        await provider.loadNetworks();

        when(() => service.loadNetworks())
            .thenAnswer((_) async => [testNetwork, testNetwork2]);
        await provider.onServerChanged(reload: true);

        expect(provider.networks, hasLength(2));
        verify(() => service.loadNetworks()).called(greaterThanOrEqualTo(1));
      });

      test('clears error from previous failed request', () async {
        when(() => service.loadNetworks())
            .thenThrow(Exception('timeout'));
        await provider.loadNetworks();
        expect(provider.error, isNotNull);

        await provider.onServerChanged();

        expect(provider.error, isNull);
        expect(provider.networks, isEmpty);
      });
    });
  });
}
