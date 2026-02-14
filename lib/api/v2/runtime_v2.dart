import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/common_models.dart';

class RuntimeV2Api {
  final DioClient _client;

  RuntimeV2Api(this._client);

  /// 创建运行时
  ///
  /// 创建一个新的运行时环境
  /// @param request 运行时创建请求
  /// @return 创建结果
  Future<Response<RuntimeInfo>> createRuntime(RuntimeCreate request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/runtimes'),
      data: request.toJson(),
    );
    return Response(
      data: RuntimeInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取运行时详情
  ///
  /// 获取指定运行时的详细信息
  /// @param id 运行时ID
  /// @return 运行时详情
  Future<Response<RuntimeInfo>> getRuntime(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id'),
    );
    return Response(
      data: RuntimeInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 删除运行时
  ///
  /// 删除指定的运行时
  /// @param ids 运行时ID列表
  /// @return 删除结果
  Future<Response> deleteRuntime(List<int> ids) async {
    final operation = BatchDelete(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/del'),
      data: operation.toJson(),
    );
  }

  /// 操作运行时
  ///
  /// 对运行时执行操作（启动、停止、重启等）
  /// @param request 运行时操作请求
  /// @return 操作结果
  Future<Response> operateRuntime(RuntimeOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/operate'),
      data: request.toJson(),
    );
  }

  /// 获取PHP运行时扩展列表
  ///
  /// 获取PHP运行时的可用扩展列表
  /// @param id 运行时ID
  /// @return 扩展列表
  Future<Response<List<String>>> getPhpExtensions(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id/extensions'),
    );
    return Response(
      data: (response.data as List?)?.cast<String>() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新PHP运行时配置
  ///
  /// 更新PHP运行时的配置文件
  /// @param request 配置更新请求
  /// @return 更新结果
  Future<Response> updatePhpConfig(RuntimeConfigUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/php/config/update'),
      data: request.toJson(),
    );
  }

  /// 加载PHP运行时配置
  ///
  /// 加载PHP运行时的配置文件内容
  /// @param id 运行时ID
  /// @return 配置内容
  Future<Response<String>> loadPhpConfig(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id/php/config'),
    );
    return Response(
      data: response.data.toString(),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取PHP运行时状态
  ///
  /// 获取PHP运行时的当前状态
  /// @param id 运行时ID
  /// @return 运行时状态
  Future<Response<RuntimeStatus>> getPhpStatus(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id/php/status'),
    );
    return Response(
      data: RuntimeStatus.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新运行时备注
  ///
  /// 更新运行时的备注信息
  /// @param request 备注更新请求
  /// @return 更新结果
  Future<Response> updateRuntimeRemark(RuntimeRemarkUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/remark/update'),
      data: request.toJson(),
    );
  }

  /// 获取运行时列表
  ///
  /// 获取所有运行时列表
  /// @param request 搜索请求
  /// @return 运行时列表
  Future<Response<PageResult<RuntimeInfo>>> getRuntimes(RuntimeSearch request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/runtimes/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => RuntimeInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 同步运行时状态
  ///
  /// 同步所有运行时的状态
  /// @return 同步结果
  Future<Response> syncRuntimeStatus() async {
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/status/sync'),
    );
  }

  /// 更新运行时
  ///
  /// 更新指定的运行时配置
  /// @param request 运行时更新请求
  /// @return 更新结果
  Future<Response> updateRuntime(RuntimeUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/update'),
      data: request.toJson(),
    );
  }
}

/// 运行时创建请求
class RuntimeCreate {
  final String? name;
  final String? type;
  final String? version;
  final String? remark;

  const RuntimeCreate({
    this.name,
    this.type,
    this.version,
    this.remark,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (type != null) 'type': type,
        if (version != null) 'version': version,
        if (remark != null) 'remark': remark,
      };
}

/// 运行时操作请求
class RuntimeOperate {
  final int? id;
  final String? operate;

  const RuntimeOperate({
    this.id,
    this.operate,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (operate != null) 'operate': operate,
      };
}

/// 运行时配置更新请求
class RuntimeConfigUpdate {
  final int? id;
  final String? content;

  const RuntimeConfigUpdate({
    this.id,
    this.content,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (content != null) 'content': content,
      };
}

/// 运行时备注更新请求
class RuntimeRemarkUpdate {
  final int? id;
  final String? remark;

  const RuntimeRemarkUpdate({
    this.id,
    this.remark,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (remark != null) 'remark': remark,
      };
}

/// 运行时搜索请求
class RuntimeSearch {
  final String? name;
  final String? type;
  final String? status;
  final int? page;
  final int? pageSize;

  const RuntimeSearch({
    this.name,
    this.type,
    this.status,
    this.page,
    this.pageSize,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (type != null) 'type': type,
        if (status != null) 'status': status,
        if (page != null) 'page': page,
        if (pageSize != null) 'pageSize': pageSize,
      };
}

/// 运行时更新请求
class RuntimeUpdate {
  final int? id;
  final String? name;
  final String? remark;

  const RuntimeUpdate({
    this.id,
    this.name,
    this.remark,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (remark != null) 'remark': remark,
      };
}

/// 运行时信息
class RuntimeInfo {
  final int? id;
  final String? name;
  final String? type;
  final String? version;
  final String? status;
  final String? remark;
  final String? createdAt;

  const RuntimeInfo({
    this.id,
    this.name,
    this.type,
    this.version,
    this.status,
    this.remark,
    this.createdAt,
  });

  factory RuntimeInfo.fromJson(Map<String, dynamic> json) {
    return RuntimeInfo(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      version: json['version'] as String?,
      status: json['status'] as String?,
      remark: json['remark'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (type != null) 'type': type,
        if (version != null) 'version': version,
        if (status != null) 'status': status,
        if (remark != null) 'remark': remark,
        if (createdAt != null) 'createdAt': createdAt,
      };
}

/// 运行时状态
class RuntimeStatus {
  final String? status;
  final String? message;
  final int? uptime;

  const RuntimeStatus({
    this.status,
    this.message,
    this.uptime,
  });

  factory RuntimeStatus.fromJson(Map<String, dynamic> json) {
    return RuntimeStatus(
      status: json['status'] as String?,
      message: json['message'] as String?,
      uptime: json['uptime'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (status != null) 'status': status,
        if (message != null) 'message': message,
        if (uptime != null) 'uptime': uptime,
      };
}
