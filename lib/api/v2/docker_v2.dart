/// 1Panel V2 API - Docker 相关接口
/// 
/// 此文件包含与Docker管理相关的所有API接口，
/// 包括Docker的安装、配置、容器管理、镜像管理等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/docker_models.dart';

class DockerV2Api {
  final ApiClient _client;

  DockerV2Api(this._client);

  /// 获取Docker状态
  /// 
  /// 获取Docker的当前状态
  /// @return Docker状态
  Future<Response> getDockerStatus() async {
    return await _client.get('/docker');
  }

  /// 安装Docker
  /// 
  /// 安装Docker
  /// @param version 版本（可选）
  /// @param mirror 镜像源（可选）
  /// @return 安装结果
  Future<Response> installDocker({
    String? version,
    String? mirror,
  }) async {
    final data = {
      if (version != null) 'version': version,
      if (mirror != null) 'mirror': mirror,
    };
    return await _client.post('/docker/install', data: data);
  }

  /// 卸载Docker
  /// 
  /// 卸载Docker
  /// @param force 是否强制卸载
  /// @return 卸载结果
  Future<Response> uninstallDocker({bool force = false}) async {
    final data = {
      'force': force,
    };
    return await _client.post('/docker/uninstall', data: data);
  }

  /// 启动Docker
  /// 
  /// 启动Docker服务
  /// @return 启动结果
  Future<Response> startDocker() async {
    return await _client.post('/docker/start');
  }

  /// 停止Docker
  /// 
  /// 停止Docker服务
  /// @return 停止结果
  Future<Response> stopDocker() async {
    return await _client.post('/docker/stop');
  }

  /// 重启Docker
  /// 
  /// 重启Docker服务
  /// @return 重启结果
  Future<Response> restartDocker() async {
    return await _client.post('/docker/restart');
  }

  /// 获取Docker配置
  /// 
  /// 获取Docker配置信息
  /// @return Docker配置
  Future<Response> getDockerConfig() async {
    return await _client.get('/docker/config');
  }

  /// 更新Docker配置
  /// 
  /// 更新Docker配置
  /// @param config 配置内容
  /// @return 更新结果
  Future<Response> updateDockerConfig(Map<String, dynamic> config) async {
    return await _client.post('/docker/config', data: config);
  }

  /// 获取Docker信息
  /// 
  /// 获取Docker详细信息
  /// @return Docker信息
  Future<Response> getDockerInfo() async {
    return await _client.get('/docker/info');
  }

  /// 获取Docker版本
  /// 
  /// 获取Docker版本信息
  /// @return Docker版本
  Future<Response> getDockerVersion() async {
    return await _client.get('/docker/version');
  }

  /// 获取Docker镜像列表
  /// 
  /// 获取所有Docker镜像列表
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 镜像列表
  Future<Response> getDockerImages({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/docker/images/search', data: data);
  }

  /// 拉取Docker镜像
  /// 
  /// 拉取Docker镜像
  /// @param image 镜像名称
  /// @param tag 镜像标签（可选，默认为latest）
  /// @return 拉取结果
  Future<Response> pullDockerImage({
    required String image,
    String tag = 'latest',
  }) async {
    final data = {
      'image': image,
      'tag': tag,
    };
    return await _client.post('/docker/images/pull', data: data);
  }

  /// 删除Docker镜像
  /// 
  /// 删除Docker镜像
  /// @param id 镜像ID
  /// @param force 是否强制删除（可选，默认为false）
  /// @return 删除结果
  Future<Response> deleteDockerImage({
    required String id,
    bool force = false,
  }) async {
    final data = {
      'id': id,
      'force': force,
    };
    return await _client.post('/docker/images/delete', data: data);
  }

  /// 批量删除Docker镜像
  /// 
  /// 批量删除Docker镜像
  /// @param ids 镜像ID列表
  /// @param force 是否强制删除（可选，默认为false）
  /// @return 删除结果
  Future<Response> deleteDockerImages({
    required List<String> ids,
    bool force = false,
  }) async {
    final data = {
      'ids': ids,
      'force': force,
    };
    return await _client.post('/docker/images/batch/delete', data: data);
  }

  /// 获取Docker容器列表
  /// 
  /// 获取所有Docker容器列表
  /// @param search 搜索关键词（可选）
  /// @param status 容器状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 容器列表
  Future<Response> getDockerContainers({
    String? search,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (status != null) 'status': status,
    };
    return await _client.post('/docker/containers/search', data: data);
  }

  /// 创建Docker容器
  /// 
  /// 创建Docker容器
  /// @param config 容器配置
  /// @return 创建结果
  Future<Response> createDockerContainer(Map<String, dynamic> config) async {
    return await _client.post('/docker/containers', data: config);
  }

  /// 启动Docker容器
  /// 
  /// 启动Docker容器
  /// @param id 容器ID
  /// @return 启动结果
  Future<Response> startDockerContainer(String id) async {
    return await _client.post('/docker/containers/$id/start');
  }

  /// 停止Docker容器
  /// 
  /// 停止Docker容器
  /// @param id 容器ID
  /// @param timeout 超时时间（可选，单位：秒）
  /// @return 停止结果
  Future<Response> stopDockerContainer(String id, {int? timeout}) async {
    final data = {
      if (timeout != null) 'timeout': timeout,
    };
    return await _client.post('/docker/containers/$id/stop', data: data);
  }

  /// 重启Docker容器
  /// 
  /// 重启Docker容器
  /// @param id 容器ID
  /// @param timeout 超时时间（可选，单位：秒）
  /// @return 重启结果
  Future<Response> restartDockerContainer(String id, {int? timeout}) async {
    final data = {
      if (timeout != null) 'timeout': timeout,
    };
    return await _client.post('/docker/containers/$id/restart', data: data);
  }

  /// 删除Docker容器
  /// 
  /// 删除Docker容器
  /// @param id 容器ID
  /// @param force 是否强制删除（可选，默认为false）
  /// @return 删除结果
  Future<Response> deleteDockerContainer({
    required String id,
    bool force = false,
  }) async {
    final data = {
      'id': id,
      'force': force,
    };
    return await _client.post('/docker/containers/delete', data: data);
  }

  /// 批量删除Docker容器
  /// 
  /// 批量删除Docker容器
  /// @param ids 容器ID列表
  /// @param force 是否强制删除（可选，默认为false）
  /// @return 删除结果
  Future<Response> deleteDockerContainers({
    required List<String> ids,
    bool force = false,
  }) async {
    final data = {
      'ids': ids,
      'force': force,
    };
    return await _client.post('/docker/containers/batch/delete', data: data);
  }

  /// 获取Docker容器详情
  /// 
  /// 获取Docker容器详情
  /// @param id 容器ID
  /// @return 容器详情
  Future<Response> getDockerContainerDetail(String id) async {
    return await _client.get('/docker/containers/$id');
  }

  /// 获取Docker容器日志
  /// 
  /// 获取Docker容器日志
  /// @param id 容器ID
  /// @param lines 日志行数（可选，默认为100）
  /// @param since 开始时间（可选）
  /// @return 容器日志
  Future<Response> getDockerContainerLogs({
    required String id,
    int lines = 100,
    String? since,
  }) async {
    final data = {
      'lines': lines,
      if (since != null) 'since': since,
    };
    return await _client.post('/docker/containers/$id/logs', data: data);
  }

  /// 获取Docker容器统计信息
  /// 
  /// 获取Docker容器统计信息
  /// @param id 容器ID
  /// @return 统计信息
  Future<Response> getDockerContainerStats(String id) async {
    return await _client.get('/docker/containers/$id/stats');
  }

  /// 获取Docker容器进程
  /// 
  /// 获取Docker容器进程列表
  /// @param id 容器ID
  /// @return 进程列表
  Future<Response> getDockerContainerProcesses(String id) async {
    return await _client.get('/docker/containers/$id/processes');
  }

  /// 获取Docker网络列表
  /// 
  /// 获取所有Docker网络列表
  /// @param search 搜索关键词（可选）
  /// @param driver 网络驱动（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 网络列表
  Future<Response> getDockerNetworks({
    String? search,
    String? driver,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (driver != null) 'driver': driver,
    };
    return await _client.post('/docker/networks/search', data: data);
  }

  /// 创建Docker网络
  /// 
  /// 创建Docker网络
  /// @param name 网络名称
  /// @param driver 网络驱动（可选，默认为bridge）
  /// @param options 网络选项（可选）
  /// @return 创建结果
  Future<Response> createDockerNetwork({
    required String name,
    String driver = 'bridge',
    Map<String, dynamic>? options,
  }) async {
    final data = {
      'name': name,
      'driver': driver,
      if (options != null) 'options': options,
    };
    return await _client.post('/docker/networks', data: data);
  }

  /// 删除Docker网络
  /// 
  /// 删除Docker网络
  /// @param id 网络ID
  /// @return 删除结果
  Future<Response> deleteDockerNetwork(String id) async {
    return await _client.delete('/docker/networks/$id');
  }

  /// 获取Docker卷列表
  /// 
  /// 获取所有Docker卷列表
  /// @param search 搜索关键词（可选）
  /// @param driver 卷驱动（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 卷列表
  Future<Response> getDockerVolumes({
    String? search,
    String? driver,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (driver != null) 'driver': driver,
    };
    return await _client.post('/docker/volumes/search', data: data);
  }

  /// 创建Docker卷
  /// 
  /// 创建Docker卷
  /// @param name 卷名称
  /// @param driver 卷驱动（可选，默认为local）
  /// @param options 卷选项（可选）
  /// @return 创建结果
  Future<Response> createDockerVolume({
    required String name,
    String driver = 'local',
    Map<String, dynamic>? options,
  }) async {
    final data = {
      'name': name,
      'driver': driver,
      if (options != null) 'options': options,
    };
    return await _client.post('/docker/volumes', data: data);
  }

  /// 删除Docker卷
  /// 
  /// 删除Docker卷
  /// @param name 卷名称
  /// @param force 是否强制删除（可选，默认为false）
  /// @return 删除结果
  Future<Response> deleteDockerVolume({
    required String name,
    bool force = false,
  }) async {
    final data = {
      'name': name,
      'force': force,
    };
    return await _client.post('/docker/volumes/delete', data: data);
  }

  /// 获取Docker仓库列表
  /// 
  /// 获取所有Docker仓库列表
  /// @return 仓库列表
  Future<Response> getDockerRegistries() async {
    return await _client.get('/docker/registries');
  }

  /// 添加Docker仓库
  /// 
  /// 添加Docker仓库
  /// @param name 仓库名称
  /// @param url 仓库URL
  /// @param username 用户名（可选）
  /// @param password 密码（可选）
  /// @return 添加结果
  Future<Response> addDockerRegistry({
    required String name,
    required String url,
    String? username,
    String? password,
  }) async {
    final data = {
      'name': name,
      'url': url,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
    };
    return await _client.post('/docker/registries', data: data);
  }

  /// 更新Docker仓库
  /// 
  /// 更新Docker仓库
  /// @param id 仓库ID
  /// @param name 仓库名称（可选）
  /// @param url 仓库URL（可选）
  /// @param username 用户名（可选）
  /// @param password 密码（可选）
  /// @return 更新结果
  Future<Response> updateDockerRegistry({
    required int id,
    String? name,
    String? url,
    String? username,
    String? password,
  }) async {
    final data = {
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
    };
    return await _client.post('/docker/registries/$id', data: data);
  }

  /// 删除Docker仓库
  /// 
  /// 删除Docker仓库
  /// @param id 仓库ID
  /// @return 删除结果
  Future<Response> deleteDockerRegistry(int id) async {
    return await _client.delete('/docker/registries/$id');
  }

  /// 测试Docker仓库连接
  /// 
  /// 测试Docker仓库连接
  /// @param id 仓库ID
  /// @return 测试结果
  Future<Response> testDockerRegistry(int id) async {
    return await _client.post('/docker/registries/$id/test');
  }

  /// 获取Docker事件
  /// 
  /// 获取Docker事件
  /// @param since 开始时间（可选）
  /// @param until 结束时间（可选）
  /// @return 事件列表
  Future<Response> getDockerEvents({
    String? since,
    String? until,
  }) async {
    final data = {
      if (since != null) 'since': since,
      if (until != null) 'until': until,
    };
    return await _client.post('/docker/events', data: data);
  }

  /// 获取Docker系统信息
  /// 
  /// 获取Docker系统信息
  /// @return 系统信息
  Future<Response> getDockerSystemInfo() async {
    return await _client.get('/docker/system/info');
  }

  /// 获取Docker磁盘使用情况
  /// 
  /// 获取Docker磁盘使用情况
  /// @return 磁盘使用情况
  Future<Response> getDockerDiskUsage() async {
    return await _client.get('/docker/system/df');
  }

  /// 清理Docker未使用的资源
  /// 
  /// 清理Docker未使用的资源
  /// @param pruneType 清理类型（可选，images/containers/networks/volumes/all）
  /// @return 清理结果
  Future<Response> pruneDocker({String? pruneType}) async {
    final data = {
      if (pruneType != null) 'pruneType': pruneType,
    };
    return await _client.post('/docker/prune', data: data);
  }
}