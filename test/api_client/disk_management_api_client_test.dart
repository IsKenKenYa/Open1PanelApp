import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepanel_client/api/v2/disk_management_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/data/models/disk_management_models.dart';

import 'disk_management_api_client_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late DiskManagementV2Api api;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    api = DiskManagementV2Api(mockClient);
  });

  RequestOptions _opts(String path) => RequestOptions(path: path);

  group('DiskManagementV2Api', () {
    group('getCompleteDiskInfo', () {
      test('should return CompleteDiskInfo on success', () async {
        final jsonResponse = {
          'code': 200,
          'data': {
            'disks': [
              {
                'device': '/dev/sda',
                'size': '500G',
                'model': 'Samsung SSD',
                'diskType': 'SSD',
                'isRemovable': false,
                'isSystem': true,
                'filesystem': 'ext4',
                'used': '200G',
                'avail': '300G',
                'usePercent': 40,
                'mountPoint': '/',
                'isMounted': true,
                'serial': 'S1234',
                'partitions': [
                  {
                    'device': '/dev/sda1',
                    'size': '500G',
                    'model': '',
                    'diskType': '',
                    'isRemovable': false,
                    'isSystem': true,
                    'filesystem': 'ext4',
                    'used': '200G',
                    'avail': '300G',
                    'usePercent': 40,
                    'mountPoint': '/',
                    'isMounted': true,
                    'serial': '',
                  },
                ],
              },
            ],
            'systemDisks': [],
            'unpartitionedDisks': [],
            'totalDisks': 1,
            'totalCapacity': 500,
          },
        };

        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks'),
            ));

        final response = await api.getCompleteDiskInfo();

        expect(response.statusCode, 200);
        expect(response.data, isA<CompleteDiskInfo>());
        expect(response.data!.disks, hasLength(1));
        expect(response.data!.disks.first.device, '/dev/sda');
        expect(response.data!.disks.first.model, 'Samsung SSD');
        expect(response.data!.disks.first.partitions, hasLength(1));
        expect(response.data!.totalDisks, 1);
        expect(response.data!.totalCapacity, 500);
      });

      test('should handle empty data gracefully', () async {
        final jsonResponse = {
          'code': 200,
          'data': <String, dynamic>{},
        };

        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks'),
            ));

        final response = await api.getCompleteDiskInfo();

        expect(response.data, isA<CompleteDiskInfo>());
        expect(response.data!.disks, isEmpty);
        expect(response.data!.systemDisks, isEmpty);
        expect(response.data!.unpartitionedDisks, isEmpty);
        expect(response.data!.totalDisks, 0);
      });

      test('should handle missing data field', () async {
        when(mockClient.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks'),
            ));

        final response = await api.getCompleteDiskInfo();

        expect(response.data, isA<CompleteDiskInfo>());
        expect(response.data!.disks, isEmpty);
      });
    });

    group('mountDisk', () {
      test('should return success string on mount', () async {
        const request = DiskMountRequest(
          device: '/dev/sdb1',
          filesystem: 'ext4',
          mountPoint: '/mnt/data',
        );

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': 'mount success'},
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks/mount'),
            ));

        final response = await api.mountDisk(request);

        expect(response.statusCode, 200);
        expect(response.data, 'mount success');
      });

      test('should handle empty data response', () async {
        const request = DiskMountRequest(
          device: '/dev/sdb1',
          filesystem: 'ext4',
          mountPoint: '/mnt/data',
        );

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': null},
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks/mount'),
            ));

        final response = await api.mountDisk(request);

        expect(response.data, '');
      });
    });

    group('partitionDisk', () {
      test('should return success string on partition', () async {
        const request = DiskPartitionRequest(
          device: '/dev/sdb',
          filesystem: 'ext4',
          mountPoint: '/mnt/data',
          label: 'data',
        );

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': 'partition success'},
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks/partition'),
            ));

        final response = await api.partitionDisk(request);

        expect(response.statusCode, 200);
        expect(response.data, 'partition success');
      });

      test('should handle null data field', () async {
        const request = DiskPartitionRequest(
          device: '/dev/sdb',
          filesystem: 'ext4',
          mountPoint: '/mnt/data',
        );

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': null},
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks/partition'),
            ));

        final response = await api.partitionDisk(request);

        expect(response.data, '');
      });
    });

    group('unmountDisk', () {
      test('should return success string on unmount', () async {
        const request = DiskUnmountRequest(mountPoint: '/mnt/data');

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': 'unmount success'},
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks/unmount'),
            ));

        final response = await api.unmountDisk(request);

        expect(response.statusCode, 200);
        expect(response.data, 'unmount success');
      });

      test('should handle null data field', () async {
        const request = DiskUnmountRequest(mountPoint: '/mnt/data');

        when(mockClient.post<Map<String, dynamic>>(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {'code': 200, 'data': null},
              statusCode: 200,
              requestOptions: _opts('/api/v2/hosts/disks/unmount'),
            ));

        final response = await api.unmountDisk(request);

        expect(response.data, '');
      });
    });
  });
}
