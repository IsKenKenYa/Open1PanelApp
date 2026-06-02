import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/features/files/providers/transfer_manager_provider.dart';

PlatformCapabilitiesSnapshot _ohosCapabilities() =>
    PlatformCapabilities.resolveForTest(
      isWeb: false,
      targetPlatform: TargetPlatform.android,
      operatingSystem: 'ohos',
    );

void main() {
  test('TransferManagerProvider loads tasks and filters active/completed',
      () async {
    final tasks = <DownloadTask>[
      DownloadTask(
        taskId: '1',
        status: DownloadTaskStatus.running,
        progress: 30,
        url: 'https://example.com/a',
        filename: 'a.txt',
        savedDir: '/tmp',
        timeCreated: 1,
        allowCellular: true,
      ),
      DownloadTask(
        taskId: '2',
        status: DownloadTaskStatus.complete,
        progress: 100,
        url: 'https://example.com/b',
        filename: 'b.txt',
        savedDir: '/tmp',
        timeCreated: 2,
        allowCellular: true,
      ),
    ];

    final provider = TransferManagerProvider(
      loadTasksOverride: () async => tasks,
    );

    await provider.initialize();

    expect(provider.isLoading, isFalse);
    expect(provider.getActiveDownloads(), hasLength(1));
    expect(provider.getCompletedDownloads(), hasLength(1));

    provider.setChannel(TransferChannel.uploads);
    expect(provider.channel, TransferChannel.uploads);
  });

  test('TransferManagerProvider clears completed downloads', () async {
    var clearCompletedCalls = 0;
    final provider = TransferManagerProvider(
      loadTasksOverride: () async => const <DownloadTask>[],
      clearCompletedOverride: () async {
        clearCompletedCalls += 1;
      },
    );

    await provider.clearCompletedDownloads();

    expect(clearCompletedCalls, 1);
  });

  test('TransferManagerProvider isDownloadSupported is true on OHOS', () async {
    final provider = TransferManagerProvider(
      capabilities: _ohosCapabilities(),
    );

    expect(provider.isDownloadSupported, isTrue);
    expect(provider.unsupportedReason, isNull);
  });

  test('mapOhosStatus maps all statuses correctly', () {
    expect(
      TransferManagerProvider.mapOhosStatusForTest('running'),
      DownloadTaskStatus.running,
    );
    expect(
      TransferManagerProvider.mapOhosStatusForTest('paused'),
      DownloadTaskStatus.paused,
    );
    expect(
      TransferManagerProvider.mapOhosStatusForTest('completed'),
      DownloadTaskStatus.complete,
    );
    expect(
      TransferManagerProvider.mapOhosStatusForTest('failed'),
      DownloadTaskStatus.failed,
    );
    expect(
      TransferManagerProvider.mapOhosStatusForTest('cancelled'),
      DownloadTaskStatus.canceled,
    );
    expect(
      TransferManagerProvider.mapOhosStatusForTest('unknown'),
      DownloadTaskStatus.undefined,
    );
  });
}
