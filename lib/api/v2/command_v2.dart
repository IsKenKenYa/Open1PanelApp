import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/common_models.dart';

class CommandV2Api {
  final DioClient _client;

  CommandV2Api(this._client);

  // ==================== Command 命令管理 ====================

  /// 创建快捷命令
  Future<Response> createCommand(CommandOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/commands'),
      data: request.toJson(),
    );
  }

  /// 获取命令详情
  Future<Response<CommandInfo>> getCommand(OperateByType request) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/commands/command'),
      queryParameters: request.toJson(),
    );
    return Response(
      data: CommandInfo.fromJson(response.data),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 删除命令
  Future<Response> deleteCommand(OperateByIDs request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/commands/del'),
      data: request.toJson(),
    );
  }

  /// 导出命令
  Future<Response<String>> exportCommand(OperateByIDs request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/commands/export'),
      data: request.toJson(),
    );
    return Response(
      data: response.data as String,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 导入命令
  Future<Response> importCommand(String content) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/commands/import'),
      data: {'content': content},
    );
  }

  /// 搜索命令
  Future<Response<PageResult<CommandInfo>>> searchCommand(PageRequest request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/commands/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data,
        (json) => CommandInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取命令树
  Future<Response<List<CommandTree>>> getCommandTree() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/commands/tree'),
    );
    return Response(
      data: (response.data as List<dynamic>)
          .map((e) => CommandTree.fromJson(e as Map<String, dynamic>))
          .toList(),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新命令
  Future<Response> updateCommand(CommandOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/commands/update'),
      data: request.toJson(),
    );
  }

  // ==================== Script 脚本库 ====================

  /// 创建脚本
  Future<Response> createScript(ScriptOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/script'),
      data: request.toJson(),
    );
  }

  /// 删除脚本
  Future<Response> deleteScript(OperateByID request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/script/del'),
      data: request.toJson(),
    );
  }

  /// 搜索脚本
  Future<Response<PageResult<ScriptOperate>>> searchScript(PageRequest request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/script/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data,
        (json) => ScriptOperate.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 同步脚本
  Future<Response> syncScript() async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/script/sync'),
    );
  }

  /// 更新脚本
  Future<Response> updateScript(ScriptOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/script/update'),
      data: request.toJson(),
    );
  }

  /// 获取脚本选项列表
  Future<Response<List<ScriptOptions>>> getScriptOptions() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/script/options'),
    );
    return Response(
      data: (response.data as List<dynamic>)
          .map((e) => ScriptOptions.fromJson(e as Map<String, dynamic>))
          .toList(),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}
