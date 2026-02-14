import 'package:flutter/foundation.dart';
import '../../data/models/container_models.dart';
import '../../data/models/container_extension_models.dart';
import 'container_service.dart';

/// 容器统计数据
class ContainerStats {
  final int total;
  final int running;
  final int stopped;
  final int paused;

  const ContainerStats({
    this.total = 0,
    this.running = 0,
    this.stopped = 0,
    this.paused = 0,
  });
}

/// 镜像统计数据
class ImageStats {
  final int total;
  final int used;
  final int unused;

  const ImageStats({
    this.total = 0,
    this.used = 0,
    this.unused = 0,
  });
}

/// 容器数据状态
class ContainersData {
  final List<ContainerInfo> containers;
  final List<ContainerImage> images;
  final ContainerStats containerStats;
  final ImageStats imageStats;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const ContainersData({
    this.containers = const [],
    this.images = const [],
    this.containerStats = const ContainerStats(),
    this.imageStats = const ImageStats(),
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  ContainersData copyWith({
    List<ContainerInfo>? containers,
    List<ContainerImage>? images,
    ContainerStats? containerStats,
    ImageStats? imageStats,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return ContainersData(
      containers: containers ?? this.containers,
      images: images ?? this.images,
      containerStats: containerStats ?? this.containerStats,
      imageStats: imageStats ?? this.imageStats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// 容器管理状态管理器
class ContainersProvider extends ChangeNotifier {
  ContainersProvider({ContainerService? service}) : _service = service;

  ContainerService? _service;

  ContainersData _data = const ContainersData();

  ContainersData get data => _data;

  Future<void> _ensureService() async {
    _service ??= ContainerService();
  }

  /// 加载容器数据
  Future<void> loadContainers() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _ensureService();

      final containers = await _service!.listContainers();

      // 计算统计
      int running = 0, stopped = 0, paused = 0;
      for (final container in containers) {
        switch (container.state.toLowerCase()) {
          case 'running':
            running++;
            break;
          case 'exited':
          case 'stopped':
            stopped++;
            break;
          case 'paused':
            paused++;
            break;
        }
      }

      _data = _data.copyWith(
        containers: containers,
        containerStats: ContainerStats(
          total: containers.length,
          running: running,
          stopped: stopped,
          paused: paused,
        ),
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _data = _data.copyWith(
        isLoading: false,
        error: '加载容器失败: $e',
      );
    }
    notifyListeners();
  }

  /// 加载镜像数据
  Future<void> loadImages() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _ensureService();

      final images = await _service!.listImages();

      // 计算统计（简化处理，实际应该根据是否被使用来判断）
      _data = _data.copyWith(
        images: images,
        imageStats: ImageStats(
          total: images.length,
          used: images.length, // 简化处理
          unused: 0,
        ),
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _data = _data.copyWith(
        isLoading: false,
        error: '加载镜像失败: $e',
      );
    }
    notifyListeners();
  }

  /// 加载所有数据
  Future<void> loadAll() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _ensureService();

      // 并行加载容器和镜像
      await Future.wait([
        loadContainers(),
        loadImages(),
      ]);
    } catch (e) {
      _data = _data.copyWith(
        isLoading: false,
        error: '加载数据失败: $e',
      );
      notifyListeners();
    }
  }

  /// 启动容器
  Future<bool> startContainer(String containerId) async {
    try {
      await _ensureService();
      await _service!.startContainer(containerId);
      await loadContainers(); // 刷新列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '启动容器失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 停止容器
  Future<bool> stopContainer(String containerId) async {
    try {
      await _ensureService();
      await _service!.stopContainer(containerId);
      await loadContainers(); // 刷新列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '停止容器失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 重启容器
  Future<bool> restartContainer(String containerId) async {
    try {
      await _ensureService();
      await _service!.restartContainer(containerId);
      await loadContainers(); // 刷新列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '重启容器失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 删除容器
  Future<bool> deleteContainer(String containerId) async {
    try {
      await _ensureService();
      await _service!.removeContainer(containerId);
      await loadContainers(); // 刷新列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '删除容器失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 删除镜像
  Future<bool> deleteImage(String imageId) async {
    try {
      await _ensureService();
      final id = int.tryParse(imageId);
      if (id == null) {
        _data = _data.copyWith(error: '删除镜像失败: 无效镜像ID');
        notifyListeners();
        return false;
      }
      await _service!.removeImage(id);
      await loadImages(); // 刷新列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '删除镜像失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 刷新数据
  Future<void> refresh() async {
    await loadAll();
  }

  /// 清除错误
  void clearError() {
    _data = _data.copyWith(error: null);
    notifyListeners();
  }
}
