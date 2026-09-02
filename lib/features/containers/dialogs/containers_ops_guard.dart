/// Containers 模块对话框写操作的互斥执行守卫（防重复提交）。
///
/// 背景：containers 5 件套（Compose/网络/存储卷/模板/仓库）与镜像操作的
/// 创建对话框均为 collector 模式——对话框收集输入后由外层 Provider 执行。
/// 执行期间 FAB 仍可点击，存在重复提交风险。本守卫按操作名互斥，
/// 执行中同名操作直接拒绝（调用方静默返回，SnackBar 反馈由 Provider 提供）。
class ContainersOpsGuard {
  ContainersOpsGuard._();

  static final Set<String> _running = <String>{};

  /// 尝试占用操作槽位；已在执行返回 false。
  static bool begin(String op) => _running.add(op);

  /// 释放操作槽位（幂等）。
  static void end(String op) => _running.remove(op);

  /// 测试辅助：清空全部槽位。
  static void reset() => _running.clear();

  /// 便于测试观察。
  static bool isRunning(String op) => _running.contains(op);
}
