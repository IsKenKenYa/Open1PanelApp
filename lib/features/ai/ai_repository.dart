/// AI模块数据仓库
/// 
/// 此文件包含AI功能相关的数据访问逻辑，
/// 用于封装数据源，提供统一的数据访问接口。

import 'package:dio/dio.dart';
import '../../api/v2/ai_v2.dart';
import '../../data/models/ai_models.dart';
import '../../data/models/common_models.dart';

/// AI数据仓库类
class AIRepository {
  final AIV2Api _api;

  AIRepository(this._api);

  /// 绑定域名
  /// 
  /// 为AI服务绑定域名
  /// @param appInstallId 应用安装ID
  /// @param domain 域名
  /// @param ipList IP列表
  /// @param sslId SSL证书ID
  /// @param websiteId 网站ID
  /// @return 绑定结果
  Future<Response> bindDomain({
    required int appInstallID,
    required String domain,
    String? ipList,
    int? sslID,
    int? websiteID,
  }) async {
    final request = OllamaBindDomain(
      appInstallID: appInstallID,
      domain: domain,
      ipList: ipList,
      sslID: sslID,
      websiteID: websiteID,
    );
    return await _api.bindDomain(request);
  }

  /// 获取绑定域名
  /// 
  /// 获取当前AI服务绑定的域名信息
  /// @param appInstallID 应用安装ID
  /// @return 域名信息
  Future<OllamaBindDomainRes> getBindDomain({
    required int appInstallID,
  }) async {
    final request = OllamaBindDomainReq(appInstallID: appInstallID);
    final response = await _api.getBindDomain(request);
    return response.data!;
  }

  /// 加载GPU/XPU信息
  /// 
  /// 获取系统中的GPU或XPU信息
  /// @return GPU/XPU信息列表
  Future<List<GpuInfo>> loadGpuInfo() async {
    final response = await _api.loadGpuInfo();
    return response.data!;
  }

  /// 创建Ollama模型
  /// 
  /// 创建一个新的Ollama模型
  /// @param name 模型名称
  /// @param taskID 任务ID
  /// @return 创建结果
  Future<Response> createOllamaModel({
    required String name,
    String? taskID,
  }) async {
    final request = OllamaModelName(
      name: name,
      taskID: taskID,
    );
    return await _api.createOllamaModel(request);
  }

  /// 关闭Ollama模型连接
  /// 
  /// 关闭指定Ollama模型的连接
  /// @param name 模型名称
  /// @param taskID 任务ID
  /// @return 操作结果
  Future<Response> closeOllamaModel({
    required String name,
    String? taskID,
  }) async {
    final request = OllamaModelName(
      name: name,
      taskID: taskID,
    );
    return await _api.closeOllamaModel(request);
  }

  /// 删除Ollama模型
  /// 
  /// 删除指定的Ollama模型
  /// @param ids 模型ID列表
  /// @param forceDelete 是否强制删除
  /// @return 删除结果
  Future<Response> deleteOllamaModel({
    required List<int> ids,
    bool forceDelete = false,
  }) async {
    final request = ForceDelete(
      forceDelete: forceDelete,
      ids: ids,
    );
    return await _api.deleteOllamaModel(request);
  }

  /// 加载Ollama模型
  ///
  /// 加载指定的Ollama模型
  /// @param name 模型名称
  /// @param taskID 任务ID
  /// @return 加载结果
  Future<String> loadOllamaModel({
    required String name,
    String? taskID,
  }) async {
    final request = OllamaModelName(
      name: name,
      taskID: taskID,
    );
    final response = await _api.loadOllamaModel(request);
    return response.data!;
  }

  /// 重新创建Ollama模型
  ///
  /// 重新创建指定的Ollama模型
  /// @param name 模型名称
  /// @param taskID 任务ID
  /// @return 创建结果
  Future<Response> recreateOllamaModel({
    required String name,
    String? taskID,
  }) async {
    final request = OllamaModelName(
      name: name,
      taskID: taskID,
    );
    return await _api.recreateOllamaModel(request);
  }

  /// 搜索Ollama模型
  /// 
  /// 搜索Ollama模型列表
  /// @param page 页码
  /// @param pageSize 每页大小
  /// @param info 搜索信息
  /// @return 搜索结果
  Future<PageResult<OllamaModel>> searchOllamaModels({
    required int page,
    required int pageSize,
    String? info,
  }) async {
    final request = SearchWithPage(
      page: page,
      pageSize: pageSize,
      info: info,
    );
    final response = await _api.searchOllamaModels(request);
    return response.data!;
  }

  /// 同步Ollama模型列表
  /// 
  /// 同步Ollama模型列表
  /// @return 模型列表
  Future<List<OllamaModelDropList>> syncOllamaModels() async {
    final response = await _api.syncOllamaModels();
    return response.data!;
  }
}