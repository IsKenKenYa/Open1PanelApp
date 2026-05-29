import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/container_models.dart';
import 'package:onepanel_client/features/orchestration/providers/compose_provider.dart';
import 'package:onepanel_client/features/orchestration/services/orchestration_service.dart';

class MockOrchestrationService extends Mock implements OrchestrationService {}

void main() {
  late MockOrchestrationService service;
  late ComposeProvider provider;

  final testCompose = ContainerCompose(
    id: '1',
    name: 'test-stack',
    path: '/opt/test-stack',
    status: 'running',
  );

  setUp(() {
    service = MockOrchestrationService();
    provider = ComposeProvider(service: service);
  });

  setUpAll(() {
    registerFallbackValue(
      const ContainerComposeCreate(from: 'edit', name: ''),
    );
    registerFallbackValue(
      const ContainerComposeUpdateRequest(name: '', path: '', content: ''),
    );
    registerFallbackValue(
      const ContainerComposeLogCleanRequest(name: '', path: ''),
    );
  });

  group('ComposeProvider', () {
    group('loadComposes', () {
      test('success populates list and clears error', () async {
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => [testCompose]);

        await provider.loadComposes();

        expect(provider.composes, hasLength(1));
        expect(provider.composes.first.name, 'test-stack');
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);
      });

      test('failure sets error and keeps list empty', () async {
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenThrow(Exception('network error'));

        await provider.loadComposes();

        expect(provider.composes, isEmpty);
        expect(provider.error, contains('network error'));
        expect(provider.isLoading, isFalse);
      });
    });

    group('createCompose', () {
      test('success reloads list and returns true', () async {
        const request = ContainerComposeCreate(from: 'edit', name: 'new-stack');
        when(() => service.createCompose(request))
            .thenAnswer((_) async {});
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => [testCompose]);

        final result = await provider.createCompose(request);

        expect(result, isTrue);
        expect(provider.composes, hasLength(1));
        verify(() => service.createCompose(request)).called(1);
        verify(() => service.loadComposes(page: 1, pageSize: 10)).called(1);
      });

      test('failure sets error and returns false', () async {
        const request = ContainerComposeCreate(from: 'edit', name: 'bad-stack');
        when(() => service.createCompose(request))
            .thenThrow(Exception('create failed'));

        final result = await provider.createCompose(request);

        expect(result, isFalse);
        expect(provider.error, contains('create failed'));
      });
    });

    group('upCompose', () {
      test('success reloads list and returns true', () async {
        when(() => service.upCompose(testCompose))
            .thenAnswer((_) async {});
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => [testCompose]);

        final result = await provider.upCompose(testCompose);

        expect(result, isTrue);
        verify(() => service.upCompose(testCompose)).called(1);
      });
    });

    group('downCompose', () {
      test('success reloads list and returns true', () async {
        when(() => service.downCompose(testCompose))
            .thenAnswer((_) async {});
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => []);

        final result = await provider.downCompose(testCompose);

        expect(result, isTrue);
        verify(() => service.downCompose(testCompose)).called(1);
      });
    });

    group('deleteCompose', () {
      test('success reloads list and returns true', () async {
        when(
          () => service.deleteCompose(testCompose, force: false, withFile: false),
        ).thenAnswer((_) async {});
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => []);

        final result = await provider.deleteCompose(testCompose);

        expect(result, isTrue);
        expect(provider.composes, isEmpty);
        verify(
          () => service.deleteCompose(testCompose, force: false, withFile: false),
        ).called(1);
      });

      test('failure sets error and returns false', () async {
        when(
          () => service.deleteCompose(testCompose, force: false, withFile: false),
        ).thenThrow(Exception('delete blocked'));

        final result = await provider.deleteCompose(testCompose);

        expect(result, isFalse);
        expect(provider.error, contains('delete blocked'));
      });

      test('passes force and withFile to service', () async {
        when(
          () => service.deleteCompose(testCompose, force: true, withFile: true),
        ).thenAnswer((_) async {});
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => []);

        final result = await provider.deleteCompose(
          testCompose,
          force: true,
          withFile: true,
        );

        expect(result, isTrue);
        verify(
          () => service.deleteCompose(testCompose, force: true, withFile: true),
        ).called(1);
      });
    });

    group('updateCompose', () {
      test('success reloads list and returns true', () async {
        const request = ContainerComposeUpdateRequest(
          name: 'test-stack',
          path: '/opt/test-stack',
          content: 'version: "3"',
        );
        when(() => service.updateCompose(request))
            .thenAnswer((_) async {});
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => [testCompose]);

        final result = await provider.updateCompose(request);

        expect(result, isTrue);
        verify(() => service.updateCompose(request)).called(1);
      });
    });

    group('testCompose', () {
      test('success returns true without reloading list', () async {
        const request = ContainerComposeCreate(from: 'edit', name: 'test-stack');
        when(() => service.testCompose(request))
            .thenAnswer((_) async {});

        final result = await provider.testCompose(request);

        expect(result, isTrue);
        verify(() => service.testCompose(request)).called(1);
        verifyNever(
          () => service.loadComposes(page: any(named: 'page'), pageSize: any(named: 'pageSize')),
        );
      });
    });

    group('cleanComposeLog', () {
      test('success returns true', () async {
        const request = ContainerComposeLogCleanRequest(
          name: 'test-stack',
          path: '/opt/test-stack',
        );
        when(() => service.cleanComposeLog(request))
            .thenAnswer((_) async {});

        final result = await provider.cleanComposeLog(request);

        expect(result, isTrue);
        verify(() => service.cleanComposeLog(request)).called(1);
      });
    });

    group('onServerChanged', () {
      test('clears state and optionally reloads', () async {
        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => [testCompose]);

        await provider.loadComposes();
        expect(provider.composes, hasLength(1));

        await provider.onServerChanged();
        expect(provider.composes, isEmpty);
        expect(provider.error, isNull);
        expect(provider.isLoading, isFalse);

        clearInteractions(service);

        when(
          () => service.loadComposes(page: 1, pageSize: 10),
        ).thenAnswer((_) async => []);

        await provider.onServerChanged(reload: true);
        verify(() => service.loadComposes(page: 1, pageSize: 10)).called(1);
      });
    });
  });
}
