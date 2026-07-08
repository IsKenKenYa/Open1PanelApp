import 'package:dio/dio.dart';
import '../../api/v2/ai_v2.dart';
import '../../core/utils/error_message_utils.dart';
import '../../data/models/ai_models.dart';
import '../../data/models/common_models.dart';

/// AI服务类
class AIService {
  final AIV2Api _api;

  AIService(this._api);

  /// 绑定域名
  ///
  /// 为AI服务绑定域名
  /// @param request 绑定域名请求
  /// @return 绑定结果
  Future<Response> bindDomain(OllamaBindDomain request) async {
    try {
      return await _api.bindDomain(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('绑定域名失败: $e');
    }
  }

  /// 获取绑定域名
  ///
  /// 获取当前AI服务绑定的域名信息
  /// @param request 获取绑定域名请求
  /// @return 域名信息
  Future<OllamaBindDomainRes> getBindDomain(OllamaBindDomainReq request) async {
    try {
      final response = await _api.getBindDomain(request);
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('获取绑定域名失败: $e');
    }
  }

  /// 加载GPU/XPU信息
  ///
  /// 获取系统中的GPU或XPU信息
  /// @return GPU/XPU信息列表
  Future<List<GpuInfo>> loadGpuInfo() async {
    try {
      final response = await _api.loadGpuInfo();
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('加载GPU信息失败: $e');
    }
  }

  /// 创建Ollama模型
  ///
  /// 创建一个新的Ollama模型
  /// @param request 模型名称请求
  /// @return 创建结果
  Future<Response> createOllamaModel(OllamaModelName request) async {
    try {
      return await _api.createOllamaModel(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('创建Ollama模型失败: $e');
    }
  }

  /// 关闭Ollama模型连接
  ///
  /// 关闭指定Ollama模型的连接
  /// @param request 模型名称请求
  /// @return 操作结果
  Future<Response> closeOllamaModel(OllamaModelName request) async {
    try {
      return await _api.closeOllamaModel(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('关闭Ollama模型失败: $e');
    }
  }

  /// 删除Ollama模型
  ///
  /// 删除指定的Ollama模型
  /// @param request 删除请求
  /// @return 删除结果
  Future<Response> deleteOllamaModel(ForceDelete request) async {
    try {
      return await _api.deleteOllamaModel(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('删除Ollama模型失败: $e');
    }
  }

  /// 加载Ollama模型
  ///
  /// 加载指定的Ollama模型
  /// @param request 模型名称请求
  /// @return 加载结果
  Future<String> loadOllamaModel(OllamaModelName request) async {
    try {
      final response = await _api.loadOllamaModel(request);
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('加载Ollama模型失败: $e');
    }
  }

  /// 重新创建Ollama模型
  ///
  /// 重新创建指定的Ollama模型
  /// @param request 模型名称请求
  /// @return 创建结果
  Future<Response> recreateOllamaModel(OllamaModelName request) async {
    try {
      return await _api.recreateOllamaModel(request);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('重新创建Ollama模型失败: $e');
    }
  }

  /// 搜索Ollama模型
  ///
  /// 搜索Ollama模型列表
  /// @param request 搜索请求
  /// @return 搜索结果
  Future<PageResult<OllamaModel>> searchOllamaModels(
      SearchWithPage request) async {
    try {
      final response = await _api.searchOllamaModels(request);
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('搜索Ollama模型失败: $e');
    }
  }

  /// 同步Ollama模型列表
  ///
  /// 同步Ollama模型列表
  /// @return 模型列表
  Future<List<OllamaModelDropList>> syncOllamaModels() async {
    try {
      final response = await _api.syncOllamaModels();
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('同步Ollama模型失败: $e');
    }
  }

  /// Translates a [DioException] to a user-facing message via
  /// [ErrorMessageUtils]. Previously this method hard-coded Chinese strings
  /// that leaked through e.toString() into the UI (architecture review
  /// candidate ⑭/⑰). Now it delegates to the shared seam so the message
  /// can be localized at the presentation layer.
  Exception _handleDioError(DioException error) {
    return Exception(ErrorMessageUtils.normalize(error));
  }
}
