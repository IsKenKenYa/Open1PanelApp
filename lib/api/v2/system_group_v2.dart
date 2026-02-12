import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/system_group_models.dart';
import '../../data/models/common_models.dart';

class SystemGroupV2Api {
  final DioClient _client;

  SystemGroupV2Api(this._client);

  Future<Response<List<GroupInfo>>> getGroups() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/core/groups'),
    );
    final data = response.data?['data'] as List?;
    return Response(
      data: data?.map((e) => GroupInfo.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  Future<Response<void>> deleteGroup(OperateByID request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/groups/del'),
      data: request.toJson(),
    );
  }

  Future<Response<PageResult<GroupInfo>>> searchGroups(SearchWithPage request) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/core/groups/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data?['data'] as Map<String, dynamic>? ?? {},
        (dynamic item) => GroupInfo.fromJson(item as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  Future<Response<void>> updateGroup(SystemGroupUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/groups/update'),
      data: request.toJson(),
    );
  }
}

class SystemGroupUpdate {
  final int id;
  final String name;
  final String type;

  const SystemGroupUpdate({
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'type': type};
}
