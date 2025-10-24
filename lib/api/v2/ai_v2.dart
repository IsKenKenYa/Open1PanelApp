/// 1Panel V2 API - AI 相关接口
///
/// 此文件包含与AI功能相关的所有API接口，
/// 包括Ollama模型管理、GPU信息获取、域名绑定等操作。

import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/ai_models.dart';

class AIV2Api {
  final DioClient _client;

  AIV2Api(this._client);

  /// 绑定域名
  ///
  /// 为AI服务绑定域名
  /// @param request 绑定域名请求
  /// @return 绑定结果
  Future<Response> bindDomain(OllamaBindDomain request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/ai/domain/bind'),
      data: request.toJson(),
    );
  }

  /// 获取绑定域名
  ///
  /// 获取当前AI服务绑定的域名信息
  /// @param request 获取绑定域名请求
  /// @return 域名信息
  Future<Response<OllamaBindDomainRes>> getBindDomain(OllamaBindDomainReq request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/ai/domain/get'),
      data: request.toJson(),
    );
    return Response(
      data: OllamaBindDomainRes.fromJson(response.data),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 加载GPU/XPU信息
  ///
  /// 获取系统中的GPU或XPU信息
  /// @return GPU/XPU信息
  Future<Response<List<GpuInfo>>> loadGpuInfo() async {
    final response = await _client.get(ApiConstants.buildApiPath('/ai/gpu/load'));
    return Response(
      data: (response.data as List?)
              ?.map((i) => GpuInfo.fromJson(i))
              .toList() ??
          [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 创建Ollama模型
  ///
  /// 创建一个新的Ollama模型
  /// @param request 模型名称请求
  /// @return 创建结果
  Future<Response> createOllamaModel(OllamaModelName request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/ai/ollama/model'),
      data: request.toJson(),
    );
  }

  /// 关闭Ollama模型连接
  ///
  /// 关闭指定Ollama模型的连接
  /// @param request 模型名称请求
  /// @return 操作结果
  Future<Response> closeOllamaModel(OllamaModelName request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/ai/ollama/close'),
      data: request.toJson(),
    );
  }

  /// 删除Ollama模型
  ///
  /// 删除指定的Ollama模型
  /// @param request 删除请求
  /// @return 删除结果
  Future<Response> deleteOllamaModel(ForceDelete request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/ai/ollama/model/del'),
      data: request.toJson(),
    );
  }

  /// 加载Ollama模型
  /// 
  /// 加载指定的Ollama模型
  /// @param request 模型名称请求
  /// @return 加载结果
  Future<Response<String>> loadOllamaModel(OllamaModelName request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/ai/ollama/model/load'),
      data: request.toJson(),
    );
    return Response(
      data: response.data?.toString() ?? '',
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 重新创建Ollama模型
  /// 
  /// 重新创建指定的Ollama模型
  /// @param request 模型名称请求
  /// @return 创建结果
  Future<Response> recreateOllamaModel(OllamaModelName request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/ai/ollama/model/recreate'),
      data: request.toJson(),
    );
  }

  /// 搜索Ollama模型
  /// 
  /// 搜索Ollama模型列表
  /// @param request 搜索请求
  /// @return 搜索结果
  Future<Response<PageResult<OllamaModel>>> searchOllamaModels(SearchWithPage request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/ai/ollama/model/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult<OllamaModel>.fromJson(response.data, (json) => OllamaModel.fromJson(json as Map<String, dynamic>)),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 同步Ollama模型列表
  /// 
  /// 同步Ollama模型列表
  /// @return 模型列表
  Future<Response<List<OllamaModelDropList>>> syncOllamaModels() async {
    final response = await _client.post(ApiConstants.buildApiPath('/ai/ollama/model/sync'));
    return Response(
      data: (response.data as List?)
              ?.map((i) => OllamaModelDropList.fromJson(i))
              .toList() ??
          [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}