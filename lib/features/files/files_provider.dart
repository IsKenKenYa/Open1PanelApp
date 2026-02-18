import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'files_service.dart';
import '../../data/models/file_models.dart';
import '../../core/config/api_config.dart';
import '../../core/network/api_client_manager.dart';
import '../../core/services/logger/logger_service.dart';

class FilesData {
  final List<FileInfo> files;
  final String currentPath;
  final List<String> pathHistory;
  final bool isLoading;
  final String? error;
  final Set<String> selectedFiles;
  final String? sortBy;
  final String? sortOrder;
  final String? searchQuery;
  final ApiConfig? currentServer;
  final List<FileMountInfo>? mountInfo;
  final FileRecycleStatus? recycleBinStatus;

  const FilesData({
    this.files = const [],
    this.currentPath = '/',
    this.pathHistory = const ['/'],
    this.isLoading = false,
    this.error,
    this.selectedFiles = const {},
    this.sortBy,
    this.sortOrder,
    this.searchQuery,
    this.currentServer,
    this.mountInfo,
    this.recycleBinStatus,
  });

  FilesData copyWith({
    List<FileInfo>? files,
    String? currentPath,
    List<String>? pathHistory,
    bool? isLoading,
    String? error,
    Set<String>? selectedFiles,
    String? sortBy,
    String? sortOrder,
    String? searchQuery,
    ApiConfig? currentServer,
    List<FileMountInfo>? mountInfo,
    FileRecycleStatus? recycleBinStatus,
  }) {
    return FilesData(
      files: files ?? this.files,
      currentPath: currentPath ?? this.currentPath,
      pathHistory: pathHistory ?? this.pathHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedFiles: selectedFiles ?? this.selectedFiles,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      searchQuery: searchQuery ?? this.searchQuery,
      currentServer: currentServer ?? this.currentServer,
      mountInfo: mountInfo ?? this.mountInfo,
      recycleBinStatus: recycleBinStatus ?? this.recycleBinStatus,
    );
  }

  bool get hasSelection => selectedFiles.isNotEmpty;
  int get selectionCount => selectedFiles.length;
  bool isSelected(String path) => selectedFiles.contains(path);
  bool get isSearching => searchQuery != null && searchQuery!.isNotEmpty;
  bool get hasServer => currentServer != null;
}

class FilesProvider extends ChangeNotifier {
  final FilesService _service = FilesService();
  FilesData _data = const FilesData();

  FilesData get data => _data;

  List<String> _pathSegments(String path) {
    return path.split('/').where((segment) => segment.isNotEmpty).toList();
  }

  String _normalizePath(String path) {
    final segments = _pathSegments(path);
    if (segments.isEmpty) return '/';
    return '/${segments.join('/')}';
  }

  Future<void> loadServer() async {
    appLogger.dWithPackage('files_provider', 'loadServer: 开始加载服务器配置');
    final server = await _service.getCurrentServer();
    _data = _data.copyWith(currentServer: server);
    appLogger.iWithPackage('files_provider', 'loadServer: 服务器配置加载完成, serverId=${server?.id}');
    notifyListeners();
  }

  Future<void> loadFiles({String? path}) async {
    final targetPath = _normalizePath(path ?? _data.currentPath);
    appLogger.dWithPackage('files_provider', 'loadFiles: 开始加载文件列表, path=$targetPath');
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final files = await _service.getFiles(
        path: targetPath,
        search: _data.searchQuery,
      );
      
      _data = _data.copyWith(
        files: files,
        currentPath: targetPath,
        isLoading: false,
        selectedFiles: {},
      );
      
      if (path != null && !_data.pathHistory.contains(targetPath)) {
        _data = _data.copyWith(
          pathHistory: [..._data.pathHistory, targetPath],
        );
      }
      appLogger.iWithPackage('files_provider', 'loadFiles: 成功加载${files.length}个文件');
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'loadFiles: 加载失败', error: e, stackTrace: stackTrace);
      _data = _data.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> loadMountInfo() async {
    try {
      final mounts = await _service.getMountInfo();
      _data = _data.copyWith(mountInfo: mounts);
      notifyListeners();
    } catch (e) {
      appLogger.eWithPackage('files_provider', 'loadMountInfo: 加载挂载信息失败', error: e);
    }
  }

  Future<void> loadRecycleBinStatus() async {
    try {
      final api = await ApiClientManager.instance.getFileApi();
      final response = await api.getRecycleBinStatus();
      _data = _data.copyWith(recycleBinStatus: response.data);
      notifyListeners();
    } catch (e) {
      appLogger.eWithPackage('files_provider', 'loadRecycleBinStatus: 加载回收站状态失败', error: e);
    }
  }

  void onServerChanged() {
    appLogger.dWithPackage('files_provider', 'onServerChanged: 服务器变更，重置状态');
    _service.clearCache();
    _data = const FilesData();
    notifyListeners();
    loadServer().then((_) => loadFiles());
  }

  Future<void> navigateTo(String path) async {
    await loadFiles(path: _normalizePath(path));
  }

  Future<void> navigateUp() async {
    if (_data.currentPath == '/') return;

    final segments = _pathSegments(_data.currentPath);
    if (segments.isEmpty) {
      await loadFiles(path: '/');
      return;
    }
    segments.removeLast();
    final parentPath = segments.isEmpty ? '/' : '/${segments.join('/')}';
    await loadFiles(path: parentPath);
  }

  Future<void> refresh() async {
    appLogger.dWithPackage('files_provider', 'refresh: 刷新文件列表');
    await loadFiles();
  }

  void setSearchQuery(String? query) {
    _data = _data.copyWith(searchQuery: query);
    notifyListeners();
  }

  void setSorting(String? sortBy, String? sortOrder) {
    _data = _data.copyWith(sortBy: sortBy, sortOrder: sortOrder);
    notifyListeners();
    loadFiles();
  }

  void toggleSelection(String path) {
    final newSelection = Set<String>.from(_data.selectedFiles);
    if (newSelection.contains(path)) {
      newSelection.remove(path);
    } else {
      newSelection.add(path);
    }
    _data = _data.copyWith(selectedFiles: newSelection);
    notifyListeners();
  }

  void selectAll() {
    final allPaths = _data.files.map((f) => f.path).toSet();
    _data = _data.copyWith(selectedFiles: allPaths);
    notifyListeners();
  }

  void clearSelection() {
    _data = _data.copyWith(selectedFiles: {});
    notifyListeners();
  }

  Future<void> createDirectory(String name) async {
    final newPath = _data.currentPath == '/'
        ? '/$name'
        : '${_data.currentPath}/$name';
    appLogger.dWithPackage('files_provider', 'createDirectory: name=$name, fullPath=$newPath');
    try {
      await _service.createDirectory(newPath);
      appLogger.iWithPackage('files_provider', 'createDirectory: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'createDirectory: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> createFile(String name, {String? content}) async {
    final newPath = _data.currentPath == '/'
        ? '/$name'
        : '${_data.currentPath}/$name';
    appLogger.dWithPackage('files_provider', 'createFile: name=$name, fullPath=$newPath, hasContent=${content != null}');
    try {
      await _service.createFile(newPath, content: content);
      appLogger.iWithPackage('files_provider', 'createFile: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'createFile: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> uploadFiles(List<String> filePaths) async {
    appLogger.dWithPackage('files_provider', 'uploadFiles: filePaths=$filePaths, targetPath=${_data.currentPath}');
    try {
      for (final filePath in filePaths) {
        final file = await MultipartFile.fromFile(filePath);
        await _service.uploadFile(_data.currentPath, file);
      }
      appLogger.iWithPackage('files_provider', 'uploadFiles: 成功上传 ${filePaths.length} 个文件');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'uploadFiles: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteSelected() async {
    if (_data.selectedFiles.isEmpty) {
      appLogger.wWithPackage('files_provider', 'deleteSelected: 没有选中的文件');
      return;
    }
    appLogger.dWithPackage('files_provider', 'deleteSelected: 删除${_data.selectedFiles.length}个文件');
    try {
      await _service.deleteFiles(_data.selectedFiles.toList());
      appLogger.iWithPackage('files_provider', 'deleteSelected: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'deleteSelected: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteFile(String path) async {
    appLogger.dWithPackage('files_provider', 'deleteFile: path=$path');
    try {
      await _service.deleteFiles([path]);
      appLogger.iWithPackage('files_provider', 'deleteFile: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'deleteFile: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> renameFile(String oldPath, String newName) async {
    final parentPath = oldPath.substring(0, oldPath.lastIndexOf('/'));
    final newPath = parentPath.isEmpty ? '/$newName' : '$parentPath/$newName';
    appLogger.dWithPackage('files_provider', 'renameFile: oldPath=$oldPath, newPath=$newPath');
    try {
      await _service.renameFile(oldPath, newPath);
      appLogger.iWithPackage('files_provider', 'renameFile: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'renameFile: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> moveSelected(String targetPath) async {
    if (_data.selectedFiles.isEmpty) {
      appLogger.wWithPackage('files_provider', 'moveSelected: 没有选中的文件');
      return;
    }
    appLogger.dWithPackage('files_provider', 'moveSelected: 移动${_data.selectedFiles.length}个文件到$targetPath');
    try {
      await _service.moveFiles(_data.selectedFiles.toList(), targetPath);
      appLogger.iWithPackage('files_provider', 'moveSelected: 成功');
      clearSelection();
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'moveSelected: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> copySelected(String targetPath) async {
    if (_data.selectedFiles.isEmpty) {
      appLogger.wWithPackage('files_provider', 'copySelected: 没有选中的文件');
      return;
    }
    appLogger.dWithPackage('files_provider', 'copySelected: 复制${_data.selectedFiles.length}个文件到$targetPath');
    try {
      await _service.copyFiles(_data.selectedFiles.toList(), targetPath);
      appLogger.iWithPackage('files_provider', 'copySelected: 成功');
      clearSelection();
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'copySelected: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> moveFile(String sourcePath, String targetPath) async {
    appLogger.dWithPackage('files_provider', 'moveFile: source=$sourcePath, target=$targetPath');
    try {
      await _service.moveFiles([sourcePath], targetPath);
      appLogger.iWithPackage('files_provider', 'moveFile: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'moveFile: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> copyFile(String sourcePath, String targetPath) async {
    appLogger.dWithPackage('files_provider', 'copyFile: source=$sourcePath, target=$targetPath');
    try {
      await _service.copyFiles([sourcePath], targetPath);
      appLogger.iWithPackage('files_provider', 'copyFile: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'copyFile: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<String> getFileContent(String path) async {
    return await _service.getFileContent(path);
  }

  Future<void> saveFileContent(String path, String content) async {
    await _service.updateFileContent(path, content);
  }

  Future<void> compressSelected(String name, String type, {String? secret}) async {
    if (_data.selectedFiles.isEmpty) {
      appLogger.wWithPackage('files_provider', 'compressSelected: 没有选中的文件');
      return;
    }
    appLogger.dWithPackage('files_provider', 'compressSelected: 压缩${_data.selectedFiles.length}个文件, name=$name, type=$type');
    try {
      await _service.compressFiles(
        files: _data.selectedFiles.toList(),
        dst: _data.currentPath,
        name: name,
        type: type,
        secret: secret,
      );
      appLogger.iWithPackage('files_provider', 'compressSelected: 成功');
      clearSelection();
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'compressSelected: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> compressFiles(List<String> files, String dst, String name, String type, {String? secret}) async {
    appLogger.dWithPackage('files_provider', 'compressFiles: 压缩${files.length}个文件到$dst/$name, type=$type');
    try {
      await _service.compressFiles(
        files: files,
        dst: dst,
        name: name,
        type: type,
        secret: secret,
      );
      appLogger.iWithPackage('files_provider', 'compressFiles: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'compressFiles: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> extractFile(String path, String dst, String type, {String? secret}) async {
    appLogger.dWithPackage('files_provider', 'extractFile: 解压$path到$dst, type=$type');
    try {
      await _service.extractFile(path: path, dst: dst, type: type, secret: secret);
      appLogger.iWithPackage('files_provider', 'extractFile: 成功');
      await refresh();
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_provider', 'extractFile: 失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<FileSizeInfo> getFileSize(String path) async {
    return await _service.getFileSize(path, recursive: true);
  }

  Future<void> toggleFavorite(String path) async {
    final isFavorite = _data.files.firstWhere((f) => f.path == path).isDir;
    if (isFavorite) {
      await _service.unfavoriteFile(path);
    } else {
      await _service.favoriteFile(path);
    }
    await refresh();
  }
}
