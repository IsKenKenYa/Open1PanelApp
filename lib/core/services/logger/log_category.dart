/// 日志功能域分类维度。
///
/// 区别于 `package` 来源标识（如 `data.repositories.dashboard`），本枚举
/// 用于在 `LogViewer` 面板、用户过滤、错误归因等场景下，按功能域快速筛选。
///
/// 来源 `package` → `LogCategory` 的映射见
/// `lib/core/config/logger_config.dart` 中的 `defaultCategoryForPackage`。
enum LogCategory {
  /// 网络请求（HTTP / WebSocket / DNS / TLS）
  network,

  /// UI 事件、页面跳转、用户交互
  ui,

  /// 文件读写、下载、上传、文件传输
  fileIo,

  /// 数据库 / Repository / 缓存
  db,

  /// 鉴权、登录、MFA、Passkey
  auth,

  /// 崩溃、Fatal、未捕获异常
  crash,

  /// 日志系统自身、平台通道、启动 / 关闭
  system,

  /// 未知 / 未分类
  unclassified;

  /// 简短标签（4-7 字符），用于单行结构化日志的中括号内显示。
  String get shortTag {
    switch (this) {
      case LogCategory.network:
        return 'NET';
      case LogCategory.ui:
        return 'UI';
      case LogCategory.fileIo:
        return 'FILE';
      case LogCategory.db:
        return 'DB';
      case LogCategory.auth:
        return 'AUTH';
      case LogCategory.crash:
        return 'CRASH';
      case LogCategory.system:
        return 'SYS';
      case LogCategory.unclassified:
        return 'UNC';
    }
  }

  /// 完整标签，用于人读格式与导出预览。
  String get label {
    switch (this) {
      case LogCategory.network:
        return 'NETWORK';
      case LogCategory.ui:
        return 'UI';
      case LogCategory.fileIo:
        return 'FILE_IO';
      case LogCategory.db:
        return 'DB';
      case LogCategory.auth:
        return 'AUTH';
      case LogCategory.crash:
        return 'CRASH';
      case LogCategory.system:
        return 'SYSTEM';
      case LogCategory.unclassified:
        return 'UNCLASSIFIED';
    }
  }
}
