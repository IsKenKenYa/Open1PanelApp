import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';

class UpdateV2Api {
  final DioClient _client;

  UpdateV2Api(this._client);

  /// 系统升级
  Future<Response<void>> systemUpgrade() async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/upgrade'),
    );
  }

  /// 获取升级说明
  Future<Response<String>> getUpgradeNotes() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/core/settings/upgrade/notes'),
    );
    return Response(
      data: response.data?['data']?.toString() ?? '',
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取升级版本列表
  Future<Response<List<Map<String, dynamic>>>> getUpgradeReleases() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/core/settings/upgrade/releases'),
    );
    final data = response.data?['data'] as List?;
    return Response(
      data: data?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}
