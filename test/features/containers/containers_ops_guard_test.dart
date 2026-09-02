import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/features/containers/dialogs/containers_ops_guard.dart';

void main() {
  setUp(() => ContainersOpsGuard.reset());

  test('同名操作互斥：执行中 begin 返回 false，end 后可重入', () {
    expect(ContainersOpsGuard.begin('compose-create'), isTrue);
    expect(ContainersOpsGuard.begin('compose-create'), isFalse,
        reason: '执行中同名操作必须被拒绝（防重复提交）');
    ContainersOpsGuard.end('compose-create');
    expect(ContainersOpsGuard.begin('compose-create'), isTrue);
  });

  test('不同操作互不干扰', () {
    expect(ContainersOpsGuard.begin('image-pull'), isTrue);
    expect(ContainersOpsGuard.begin('image-build'), isTrue);
    ContainersOpsGuard.end('image-pull');
    expect(ContainersOpsGuard.isRunning('image-pull'), isFalse);
    expect(ContainersOpsGuard.isRunning('image-build'), isTrue);
  });

  test('end 幂等', () {
    ContainersOpsGuard.begin('network-create');
    ContainersOpsGuard.end('network-create');
    ContainersOpsGuard.end('network-create');
    expect(ContainersOpsGuard.isRunning('network-create'), isFalse);
  });
}
