/// AI模块入口文件
/// 
/// 此文件导出AI模块的所有功能，
/// 包括API服务、数据模型、业务逻辑层和UI页面。

// API服务
export '../../api/v2/ai_v2.dart';

// 数据模型
export '../../data/models/ai_models.dart';

// 业务逻辑层
export 'ai_service.dart';
export 'ai_repository.dart';
export 'ai_provider.dart';

// UI页面
export 'ai_page.dart';