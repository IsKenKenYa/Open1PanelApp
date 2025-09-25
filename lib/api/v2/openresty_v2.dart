/// 1Panel V2 API - OpenResty 相关接口
/// 
/// 此文件包含与OpenResty管理相关的所有API接口，
/// 包括OpenResty的安装、配置、管理等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/openresty_models.dart';

class OpenRestyV2Api {
  final ApiClient _client;

  OpenRestyV2Api(this._client);

  /// 获取OpenResty状态
  /// 
  /// 获取OpenResty的当前状态
  /// @return OpenResty状态
  Future<Response> getOpenRestyStatus() async {
    return await _client.get('/openresty');
  }

  /// 安装OpenResty
  /// 
  /// 安装OpenResty
  /// @param version 版本（可选）
  /// @return 安装结果
  Future<Response> installOpenResty({String? version}) async {
    final data = {
      if (version != null) 'version': version,
    };
    return await _client.post('/openresty/install', data: data);
  }

  /// 卸载OpenResty
  /// 
  /// 卸载OpenResty
  /// @param force 是否强制卸载
  /// @return 卸载结果
  Future<Response> uninstallOpenResty({bool force = false}) async {
    final data = {
      'force': force,
    };
    return await _client.post('/openresty/uninstall', data: data);
  }

  /// 启动OpenResty
  /// 
  /// 启动OpenResty服务
  /// @return 启动结果
  Future<Response> startOpenResty() async {
    return await _client.post('/openresty/start');
  }

  /// 停止OpenResty
  /// 
  /// 停止OpenResty服务
  /// @return 停止结果
  Future<Response> stopOpenResty() async {
    return await _client.post('/openresty/stop');
  }

  /// 重启OpenResty
  /// 
  /// 重启OpenResty服务
  /// @return 重启结果
  Future<Response> restartOpenResty() async {
    return await _client.post('/openresty/restart');
  }

  /// 重新加载OpenResty配置
  /// 
  /// 重新加载OpenResty配置
  /// @return 重新加载结果
  Future<Response> reloadOpenResty() async {
    return await _client.post('/openresty/reload');
  }

  /// 获取OpenResty配置
  /// 
  /// 获取OpenResty配置
  /// @return OpenResty配置
  Future<Response> getOpenRestyConfig() async {
    return await _client.get('/openresty/config');
  }

  /// 更新OpenResty配置
  /// 
  /// 更新OpenResty配置
  /// @param config 配置内容
  /// @return 更新结果
  Future<Response> updateOpenRestyConfig(String config) async {
    final data = {
      'config': config,
    };
    return await _client.post('/openresty/config', data: data);
  }

  /// 获取OpenResty版本列表
  /// 
  /// 获取可用的OpenResty版本列表
  /// @return 版本列表
  Future<Response> getOpenRestyVersions() async {
    return await _client.get('/openresty/versions');
  }

  /// 升级OpenResty
  /// 
  /// 升级OpenResty到指定版本
  /// @param version 目标版本
  /// @return 升级结果
  Future<Response> upgradeOpenResty(String version) async {
    final data = {
      'version': version,
    };
    return await _client.post('/openresty/upgrade', data: data);
  }

  /// 获取OpenResty日志
  /// 
  /// 获取OpenResty日志
  /// @param lines 日志行数（可选，默认为100）
  /// @return OpenResty日志
  Future<Response> getOpenRestyLogs({int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/openresty/logs', data: data);
  }

  /// 获取OpenResty性能统计
  /// 
  /// 获取OpenResty性能统计信息
  /// @return 性能统计
  Future<Response> getOpenRestyStats() async {
    return await _client.get('/openresty/stats');
  }

  /// 获取OpenResty模块列表
  /// 
  /// 获取OpenResty已安装的模块列表
  /// @return 模块列表
  Future<Response> getOpenRestyModules() async {
    return await _client.get('/openresty/modules');
  }

  /// 安装OpenResty模块
  /// 
  /// 安装指定的OpenResty模块
  /// @param moduleName 模块名称
  /// @return 安装结果
  Future<Response> installOpenRestyModule(String moduleName) async {
    final data = {
      'moduleName': moduleName,
    };
    return await _client.post('/openresty/modules/install', data: data);
  }

  /// 卸载OpenResty模块
  /// 
  /// 卸载指定的OpenResty模块
  /// @param moduleName 模块名称
  /// @return 卸载结果
  Future<Response> uninstallOpenRestyModule(String moduleName) async {
    final data = {
      'moduleName': moduleName,
    };
    return await _client.post('/openresty/modules/uninstall', data: data);
  }

  /// 获取OpenResty构建状态
  /// 
  /// 获取OpenResty构建状态
  /// @return 构建状态
  Future<Response> getOpenRestyBuildStatus() async {
    return await _client.get('/openresty/build');
  }

  /// 构建OpenResty
  /// 
  /// 构建OpenResty
  /// @param config 构建配置
  /// @return 构建结果
  Future<Response> buildOpenResty(Map<String, dynamic> config) async {
    return await _client.post('/openresty/build', data: config);
  }
}