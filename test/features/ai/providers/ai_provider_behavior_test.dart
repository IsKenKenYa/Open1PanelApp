import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/ai_models.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/features/ai/ai_provider.dart';
import 'package:onepanel_client/features/ai/ai_repository.dart';

class MockAIRepository extends Mock implements AIRepository {}

void main() {
  group('AIProvider behavior', () {
    late MockAIRepository repository;
    late AIProvider provider;

    setUp(() {
      repository = MockAIRepository();
      provider = AIProvider(repository: repository);
    });

    test('loadGpuInfo toggles loading during fetch and populates list',
        () async {
      final completer = Completer<List<GpuInfo>>();
      when(() => repository.loadGpuInfo()).thenAnswer((_) => completer.future);

      final pending = provider.loadGpuInfo();
      expect(provider.isLoading, isTrue);

      completer.complete([GpuInfo(index: 0, gpuUtil: '12%')]);
      expect(await pending, isTrue);
      expect(provider.isLoading, isFalse);
      expect(provider.gpuInfoList, hasLength(1));
      expect(provider.gpuInfoList.first.gpuUtil, '12%');
      expect(provider.errorMessage, isNull);
    });

    test('loadGpuInfo failure exposes error and stops loading', () async {
      when(() => repository.loadGpuInfo()).thenThrow(Exception('gpu boom'));

      expect(await provider.loadGpuInfo(), isFalse);
      expect(provider.errorMessage, contains('加载GPU信息失败'));
      expect(provider.isLoading, isFalse);
    });

    test('failed load recovers to clean error state on next success',
        () async {
      when(() => repository.loadGpuInfo()).thenThrow(Exception('gpu boom'));
      await provider.loadGpuInfo();
      expect(provider.errorMessage, isNotNull);

      when(() => repository.loadGpuInfo()).thenAnswer((_) async => const []);
      expect(await provider.loadGpuInfo(), isTrue);
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, isFalse);
    });

    test('syncOllamaModels refreshes drop list and search results', () async {
      when(() => repository.syncOllamaModels()).thenAnswer(
        (_) async => [OllamaModelDropList(label: 'llama3', value: 'llama3')],
      );
      when(
        () => repository.searchOllamaModels(
          page: 1,
          pageSize: 20,
          info: null,
        ),
      ).thenAnswer(
        (_) async => PageResult<OllamaModel>(
          items: [OllamaModel(id: 1, name: 'llama3', size: '4.7GB')],
          total: 1,
        ),
      );

      expect(await provider.syncOllamaModels(), isTrue);
      expect(provider.ollamaModelDropList, hasLength(1));
      expect(provider.ollamaModelDropList.first.value, 'llama3');
      expect(provider.ollamaModelList.first.name, 'llama3');
      verify(
        () => repository.searchOllamaModels(
          page: 1,
          pageSize: 20,
          info: null,
        ),
      ).called(1);
    });

    test('deleteOllamaModel refreshes search results after delete', () async {
      var remaining = <OllamaModel>[
        OllamaModel(id: 1, name: 'keep', size: '1GB'),
      ];
      when(
        () => repository.searchOllamaModels(
          page: 1,
          pageSize: 20,
          info: null,
        ),
      ).thenAnswer(
        (_) async => PageResult<OllamaModel>(
          items: remaining,
          total: remaining.length,
        ),
      );
      when(() => repository.deleteOllamaModel(ids: [5], forceDelete: false))
          .thenAnswer((_) async {
        remaining = const <OllamaModel>[];
        return Response(requestOptions: RequestOptions(path: '/'));
      });

      await provider.searchOllamaModels();
      expect(provider.ollamaModelList, hasLength(1));

      expect(await provider.deleteOllamaModel(ids: [5]), isTrue);
      expect(provider.ollamaModelList, isEmpty);
      verify(() => repository.deleteOllamaModel(ids: [5], forceDelete: false))
          .called(1);
    });

    test('deleteOllamaModel failure exposes error and keeps list', () async {
      when(
        () => repository.searchOllamaModels(
          page: 1,
          pageSize: 20,
          info: null,
        ),
      ).thenAnswer(
        (_) async => PageResult<OllamaModel>(
          items: [OllamaModel(id: 1, name: 'keep', size: '1GB')],
          total: 1,
        ),
      );
      when(() => repository.deleteOllamaModel(ids: [5], forceDelete: true))
          .thenThrow(Exception('delete failed'));

      await provider.searchOllamaModels();
      expect(
        await provider.deleteOllamaModel(ids: [5], forceDelete: true),
        isFalse,
      );
      expect(provider.errorMessage, contains('删除Ollama模型失败'));
      expect(provider.ollamaModelList, hasLength(1));
    });

    test('loadOllamaModel failure exposes error and keeps message empty',
        () async {
      when(() => repository.loadOllamaModel(name: 'qwen2', taskID: null))
          .thenThrow(Exception('load failed'));

      expect(await provider.loadOllamaModel(name: 'qwen2'), isFalse);
      expect(provider.errorMessage, contains('加载Ollama模型失败'));
      expect(provider.lastOperationMessage, isNull);
      expect(provider.isLoading, isFalse);
    });

    test('setActiveAppInstallId and clearError update exposed state',
        () async {
      provider.setActiveAppInstallId(42);
      expect(provider.activeAppInstallId, 42);

      when(() => repository.getBindDomain(appInstallID: 42))
          .thenThrow(Exception('bind fetch failed'));
      await provider.getBindDomain(appInstallId: 42);
      expect(provider.errorMessage, contains('获取绑定域名失败'));

      provider.clearError();
      expect(provider.errorMessage, isNull);
      expect(provider.activeAppInstallId, 42);
    });

    test('getBindDomain failure keeps previous binding info', () async {
      when(() => repository.getBindDomain(appInstallID: 1)).thenAnswer(
        (_) async => OllamaBindDomainRes(
          domain: 'old.example.com',
          connUrl: 'https://old.example.com',
        ),
      );
      await provider.getBindDomain(appInstallId: 1);
      expect(provider.bindDomainInfo?.domain, 'old.example.com');

      when(() => repository.getBindDomain(appInstallID: 2))
          .thenThrow(Exception('bind fetch failed'));
      await provider.getBindDomain(appInstallId: 2);
      expect(provider.errorMessage, contains('获取绑定域名失败'));
      expect(provider.bindDomainInfo?.domain, 'old.example.com');
    });
  });
}
