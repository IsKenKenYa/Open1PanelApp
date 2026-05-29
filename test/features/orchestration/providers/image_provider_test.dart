import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/container_image_models.dart';
import 'package:onepanel_client/data/models/docker_models.dart';
import 'package:onepanel_client/features/orchestration/providers/image_provider.dart';
import 'package:onepanel_client/features/orchestration/services/orchestration_service.dart';

class MockOrchestrationService extends Mock implements OrchestrationService {}

void main() {
  late MockOrchestrationService service;
  late DockerImageProvider provider;

  final testImages = [
    const DockerImage(
      id: 'sha256:abc123',
      tags: ['nginx:latest'],
      size: 1024,
      created: '2025-01-01T00:00:00Z',
    ),
    const DockerImage(
      id: 'sha256:def456',
      tags: ['redis:7', 'redis:latest'],
      size: 2048,
      created: '2025-01-02T00:00:00Z',
      isUsed: true,
    ),
  ];

  setUp(() {
    service = MockOrchestrationService();
    provider = DockerImageProvider(service: service);
  });

  setUpAll(() {
    registerFallbackValue(const ImagePull(image: 'fallback'));
    registerFallbackValue(
      const SearchWithPage(info: 'fallback', page: 1, pageSize: 20),
    );
  });

  group('DockerImageProvider', () {
    group('loadImages', () {
      test('success populates images list', () async {
        when(() => service.loadImages()).thenAnswer((_) async => testImages);

        await provider.loadImages();

        expect(provider.images, hasLength(2));
        expect(provider.images.first.id, 'sha256:abc123');
        expect(provider.images.last.isUsed, isTrue);
        expect(provider.isLoading, isFalse);
        expect(provider.error, isNull);
      });

      test('failure sets error and clears list', () async {
        when(() => service.loadImages()).thenThrow(Exception('network error'));

        await provider.loadImages();

        expect(provider.images, isEmpty);
        expect(provider.error, contains('network error'));
        expect(provider.isLoading, isFalse);
      });
    });

    group('pullImage', () {
      test('success returns true and reloads images', () async {
        when(
          () => service.pullImage(const ImagePull(image: 'nginx', tag: 'latest')),
        ).thenAnswer((_) async {});
        when(() => service.loadImages()).thenAnswer((_) async => testImages);

        final result = await provider.pullImage('nginx', tag: 'latest');

        expect(result, isTrue);
        expect(provider.images, hasLength(2));
        expect(provider.error, isNull);
        verify(() => service.pullImage(const ImagePull(image: 'nginx', tag: 'latest'))).called(1);
        verify(() => service.loadImages()).called(1);
      });

      test('failure returns false and sets error', () async {
        when(
          () => service.pullImage(const ImagePull(image: 'nginx', tag: 'latest')),
        ).thenThrow(Exception('pull blocked'));

        final result = await provider.pullImage('nginx', tag: 'latest');

        expect(result, isFalse);
        expect(provider.error, contains('pull blocked'));
        expect(provider.isLoading, isFalse);
      });
    });

    group('removeImage', () {
      test('success returns true and reloads images', () async {
        when(() => service.removeImage('sha256:abc123', force: false))
            .thenAnswer((_) async {});
        when(() => service.loadImages()).thenAnswer((_) async => [testImages.last]);

        final result = await provider.removeImage('sha256:abc123');

        expect(result, isTrue);
        expect(provider.images, hasLength(1));
        verify(() => service.removeImage('sha256:abc123', force: false)).called(1);
      });

      test('force delete passes force flag', () async {
        when(() => service.removeImage('sha256:abc123', force: true))
            .thenAnswer((_) async {});
        when(() => service.loadImages()).thenAnswer((_) async => []);

        final result = await provider.removeImage('sha256:abc123', force: true);

        expect(result, isTrue);
        verify(() => service.removeImage('sha256:abc123', force: true)).called(1);
      });

      test('failure returns false and sets error', () async {
        when(() => service.removeImage('sha256:abc123', force: false))
            .thenThrow(Exception('image in use'));

        final result = await provider.removeImage('sha256:abc123');

        expect(result, isFalse);
        expect(provider.error, contains('image in use'));
        expect(provider.isLoading, isFalse);
      });
    });

    group('searchImages', () {
      test('success returns search results', () async {
        const searchResult = PageResult<Map<String, dynamic>>(
          items: [
            {'name': 'nginx', 'description': 'web server'},
          ],
          total: 1,
        );
        when(
          () => service.searchImages(
            const SearchWithPage(info: 'nginx', page: 1, pageSize: 20),
          ),
        ).thenAnswer((_) async => searchResult);

        final result = await provider.searchImages('nginx');

        expect(result.items, hasLength(1));
        expect(result.total, 1);
        expect(provider.error, isNull);
      });

      test('failure returns empty result and sets error', () async {
        when(
          () => service.searchImages(
            const SearchWithPage(info: 'nginx', page: 1, pageSize: 20),
          ),
        ).thenThrow(Exception('search failed'));

        final result = await provider.searchImages('nginx');

        expect(result.items, isEmpty);
        expect(result.total, 0);
        expect(provider.error, contains('search failed'));
      });
    });
  });
}
