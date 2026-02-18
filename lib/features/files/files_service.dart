import '../../api/v2/file_v2.dart';
import '../../data/models/file_models.dart';
import '../../core/network/api_client_manager.dart';
import '../../core/config/api_config.dart';
import '../../core/services/logger/logger_service.dart';

class FilesService {
  FileV2Api? _api;
  String? _currentServerId;

  Future<FileV2Api> _getApi() async {
    appLogger.dWithPackage('files', '_getApi: 开始获取API客户端');
    final config = await ApiConfigManager.getCurrentConfig();
    if (config == null) {
      appLogger.eWithPackage('files', '_getApi: 没有配置服务器');
      throw StateError('No server configured');
    }
    
    if (_api == null || _currentServerId != config.id) {
      appLogger.dWithPackage('files', '_getApi: 创建新的API客户端, serverId=${config.id}');
      final client = await ApiClientManager.instance.getCurrentClient();
      _api = FileV2Api(client);
      _currentServerId = config.id;
    }
    return _api!;
  }

  void clearCache() {
    appLogger.dWithPackage('files', 'clearCache: 清除API缓存');
    _api = null;
    _currentServerId = null;
  }

  Future<ApiConfig?> getCurrentServer() async {
    return await ApiConfigManager.getCurrentConfig();
  }

  Future<FileSearchResponse> searchFiles({
    required String path,
    String? search,
    int page = 1,
    int pageSize = 100,
    bool? expand,
    String? sortBy,
    String? sortOrder,
  }) async {
    appLogger.dWithPackage('files', 'searchFiles: path=$path, search=$search, page=$page');
    final api = await _getApi();
    final response = await api.searchFiles(FileSearch(
      path: path,
      search: search,
      page: page,
      pageSize: pageSize,
      expand: expand,
      sortBy: sortBy,
      sortOrder: sortOrder,
    ));
    appLogger.iWithPackage('files', 'searchFiles: 成功, 文件数=${response.data?.items.length ?? 0}');
    return response.data!;
  }

  Future<List<FileInfo>> getFiles({
    required String path,
    String? search,
    int page = 1,
    int pageSize = 100,
    bool expand = true,
    String? sortBy,
    String? sortOrder,
    bool? showHidden,
  }) async {
    appLogger.dWithPackage('files', 'getFiles: path=$path, search=$search, page=$page, pageSize=$pageSize');
    final api = await _getApi();
    final response = await api.getFiles(FileSearch(
      path: path,
      search: search,
      page: page,
      pageSize: pageSize,
      expand: expand,
      sortBy: sortBy,
      sortOrder: sortOrder,
      showHidden: showHidden,
    ));
    final files = response.data ?? [];
    appLogger.iWithPackage('files', 'getFiles: 成功, 返回${files.length}个文件');
    return files;
  }

  Future<void> createDirectory(String path) async {
    appLogger.dWithPackage('files', 'createDirectory: path=$path');
    final api = await _getApi();
    await api.createDirectory(FileCreate(path: path, isDir: true));
    appLogger.iWithPackage('files', 'createDirectory: 成功创建文件夹 $path');
  }

  Future<void> createFile(String path, {String? content}) async {
    appLogger.dWithPackage('files', 'createFile: path=$path, hasContent=${content != null}');
    final api = await _getApi();
    await api.createFile(FileCreate(path: path, content: content, isDir: false));
    appLogger.iWithPackage('files', 'createFile: 成功创建文件 $path');
  }

  Future<void> deleteFiles(List<String> paths, {bool? force, bool? isDir}) async {
    appLogger.dWithPackage('files', 'deleteFiles: paths=$paths, force=$force, isDir=$isDir');
    final api = await _getApi();
    if (paths.length == 1) {
      await api.deleteFile(FileDelete(path: paths.first, isDir: isDir, forceDelete: force));
    } else {
      await api.deleteFiles(FileBatchDelete(paths: paths, isDir: isDir));
    }
    appLogger.iWithPackage('files', 'deleteFiles: 成功删除 ${paths.length} 个文件');
  }

  Future<void> renameFile(String oldPath, String newPath) async {
    appLogger.dWithPackage('files', 'renameFile: oldPath=$oldPath, newPath=$newPath');
    final api = await _getApi();
    await api.renameFile(FileRename(oldPath: oldPath, newPath: newPath));
    appLogger.iWithPackage('files', 'renameFile: 成功重命名 $oldPath -> $newPath');
  }

  Future<void> moveFiles(List<String> paths, String targetPath) async {
    appLogger.dWithPackage('files', 'moveFiles: paths=$paths, targetPath=$targetPath');
    final api = await _getApi();
    await api.moveFiles(FileMove(paths: paths, targetPath: targetPath, type: 'cut'));
    appLogger.iWithPackage('files', 'moveFiles: 成功移动 ${paths.length} 个文件到 $targetPath');
  }

  Future<void> copyFiles(List<String> paths, String targetPath, {String? newName}) async {
    appLogger.dWithPackage('files', 'copyFiles: paths=$paths, targetPath=$targetPath, newName=$newName');
    final api = await _getApi();
    
    for (final sourcePath in paths) {
      final sourceDir = sourcePath.substring(0, sourcePath.lastIndexOf('/'));
      final sourceName = sourcePath.substring(sourcePath.lastIndexOf('/') + 1);
      
      String? name = newName;
      
      if (sourceDir == targetPath && name == null) {
        name = _generateCopyName(sourceName);
        appLogger.iWithPackage('files', 'copyFiles: 源目录与目标目录相同，自动重命名为 $name');
      }
      
      await api.moveFiles(FileMove(
        paths: [sourcePath],
        targetPath: targetPath,
        type: 'copy',
        name: name,
      ));
    }
    
    appLogger.iWithPackage('files', 'copyFiles: 成功复制 ${paths.length} 个文件到 $targetPath');
  }

  String _generateCopyName(String originalName) {
    final lastDot = originalName.lastIndexOf('.');
    String baseName;
    String extension = '';
    
    if (lastDot > 0) {
      baseName = originalName.substring(0, lastDot);
      extension = originalName.substring(lastDot);
    } else {
      baseName = originalName;
    }
    
    int counter = 1;
    while (true) {
      final newName = '$baseName ($counter)$extension';
      return newName;
    }
  }

  Future<String> getFileContent(String path) async {
    appLogger.dWithPackage('files', 'getFileContent: path=$path');
    final api = await _getApi();
    final response = await api.getFileContent(path);
    appLogger.iWithPackage('files', 'getFileContent: 成功获取文件内容, 长度=${response.data?.length ?? 0}');
    return response.data ?? '';
  }

  Future<void> updateFileContent(String path, String content) async {
    appLogger.dWithPackage('files', 'updateFileContent: path=$path, contentLength=${content.length}');
    final api = await _getApi();
    await api.updateFileContent(FileContent(path: path, content: content));
    appLogger.iWithPackage('files', 'updateFileContent: 成功更新文件内容');
  }

  Future<void> compressFiles({
    required List<String> files,
    required String dst,
    required String name,
    required String type,
    String? secret,
  }) async {
    appLogger.dWithPackage('files', 'compressFiles: files=$files, dst=$dst, name=$name, type=$type, hasSecret=${secret != null}');
    final api = await _getApi();
    await api.compressFiles(FileCompress(
      files: files,
      dst: dst,
      name: name,
      type: type,
      secret: secret,
    ));
    appLogger.iWithPackage('files', 'compressFiles: 成功压缩到 $dst/$name');
  }

  Future<void> extractFile({
    required String path,
    required String dst,
    required String type,
    String? secret,
  }) async {
    appLogger.dWithPackage('files', 'extractFile: path=$path, dst=$dst, type=$type, hasSecret=${secret != null}');
    final api = await _getApi();
    await api.extractFile(FileExtract(
      path: path,
      dst: dst,
      type: type,
      secret: secret,
    ));
    appLogger.iWithPackage('files', 'extractFile: 成功解压到 $dst');
  }

  Future<FilePermission> getFilePermission(String path) async {
    appLogger.dWithPackage('files', 'getFilePermission: path=$path');
    final api = await _getApi();
    final response = await api.getFilePermission(path);
    return response.data!;
  }

  Future<void> updateFilePermission(FilePermission permission) async {
    appLogger.dWithPackage('files', 'updateFilePermission: path=${permission.path}');
    final api = await _getApi();
    await api.updateFilePermission(permission);
  }

  Future<FileCheckResult> checkFile(String path) async {
    appLogger.dWithPackage('files', 'checkFile: path=$path');
    final api = await _getApi();
    final response = await api.checkFile(FileCheck(path: path));
    return response.data!;
  }

  Future<FileTree> getFileTree({
    required String path,
    int? maxDepth,
    bool? includeFiles,
    bool? includeHidden,
  }) async {
    appLogger.dWithPackage('files', 'getFileTree: path=$path, maxDepth=$maxDepth');
    final api = await _getApi();
    final response = await api.getFileTree(FileTreeRequest(
      path: path,
      maxDepth: maxDepth,
      includeFiles: includeFiles,
      includeHidden: includeHidden,
    ));
    return response.data!;
  }

  Future<FileSizeInfo> getFileSize(String path, {bool? recursive}) async {
    appLogger.dWithPackage('files', 'getFileSize: path=$path, recursive=$recursive');
    final api = await _getApi();
    final response = await api.getFileSize(FileSizeRequest(
      path: path,
      recursive: recursive,
    ));
    return response.data!;
  }

  Future<void> favoriteFile(String path, {String? name, String? description}) async {
    appLogger.dWithPackage('files', 'favoriteFile: path=$path');
    final api = await _getApi();
    await api.favoriteFile(FileFavorite(path: path, name: name, description: description));
  }

  Future<void> unfavoriteFile(String path) async {
    appLogger.dWithPackage('files', 'unfavoriteFile: path=$path');
    final api = await _getApi();
    await api.unfavoriteFile(FileUnfavorite(path: path));
  }

  Future<List<FileInfo>> searchFavoriteFiles({
    required String path,
    int page = 1,
    int pageSize = 100,
  }) async {
    appLogger.dWithPackage('files', 'searchFavoriteFiles: path=$path');
    final api = await _getApi();
    final response = await api.searchFavoriteFiles(FileSearch(
      path: path,
      page: page,
      pageSize: pageSize,
    ));
    return response.data!;
  }

  Future<String> getRecycleBinStatus() async {
    appLogger.dWithPackage('files', 'getRecycleBinStatus');
    final api = await _getApi();
    final response = await api.getRecycleBinStatus();
    return response.data!.fileCount.toString();
  }

  Future<List<FileInfo>> searchRecycleBin({
    required String path,
    int page = 1,
    int pageSize = 100,
  }) async {
    appLogger.dWithPackage('files', 'searchRecycleBin: path=$path');
    final api = await _getApi();
    final response = await api.searchRecycleBin(FileSearch(
      path: path,
      page: page,
      pageSize: pageSize,
    ));
    return response.data!;
  }

  Future<void> clearRecycleBin() async {
    appLogger.dWithPackage('files', 'clearRecycleBin');
    final api = await _getApi();
    await api.clearRecycleBin();
  }

  Future<FileWgetResult> wgetDownload({
    required String url,
    required String path,
    String? filename,
    bool? overwrite,
  }) async {
    appLogger.dWithPackage('files', 'wgetDownload: url=$url, path=$path');
    final api = await _getApi();
    final response = await api.wgetDownload(FileWgetRequest(
      url: url,
      path: path,
      filename: filename,
      overwrite: overwrite,
    ));
    return response.data!;
  }

  Future<void> convertFile({
    required String path,
    required String fromEncoding,
    required String toEncoding,
  }) async {
    appLogger.dWithPackage('files', 'convertFile: path=$path, from=$fromEncoding, to=$toEncoding');
    final api = await _getApi();
    await api.convertFile(FileConvertRequest(
      path: path,
      fromEncoding: fromEncoding,
      toEncoding: toEncoding,
    ));
  }

  Future<String> convertFileLog(String path) async {
    appLogger.dWithPackage('files', 'convertFileLog: path=$path');
    final api = await _getApi();
    final response = await api.convertFileLog(FileConvertLogRequest(path: path));
    return response.data ?? '';
  }

  Future<FileDepthSizeInfo> getDepthSize(List<String> paths) async {
    appLogger.dWithPackage('files', 'getDepthSize: paths=$paths');
    final api = await _getApi();
    final response = await api.getDepthSize(FileDepthSizeRequest(paths: paths));
    return response.data!;
  }

  Future<List<FileMountInfo>> getMountInfo() async {
    appLogger.dWithPackage('files', 'getMountInfo');
    final api = await _getApi();
    final response = await api.getMountInfo();
    return response.data!;
  }

  Future<String> previewFile(String path, {int? line, int? limit}) async {
    appLogger.dWithPackage('files', 'previewFile: path=$path, line=$line, limit=$limit');
    final api = await _getApi();
    final response = await api.previewFile(FilePreviewRequest(
      path: path,
      line: line,
      limit: limit,
    ));
    return response.data ?? '';
  }

  Future<FileUserGroupResponse> getUserGroup() async {
    appLogger.dWithPackage('files', 'getUserGroup');
    final api = await _getApi();
    final response = await api.getUserGroup();
    return response.data!;
  }

  Future<FileBatchCheckResult> batchCheckFiles(List<String> paths) async {
    appLogger.dWithPackage('files', 'batchCheckFiles: paths=$paths');
    final api = await _getApi();
    final response = await api.batchCheckFiles(FileBatchCheckRequest(paths: paths));
    return response.data!;
  }

  Future<void> changeFileMode(String path, String mode, {bool? recursive}) async {
    appLogger.dWithPackage('files', 'changeFileMode: path=$path, mode=$mode');
    final api = await _getApi();
    await api.changeFileMode(FileModeChange(
      path: path,
      mode: mode,
      recursive: recursive,
    ));
  }

  Future<void> changeFileOwner(String path, {String? user, String? group, bool? recursive}) async {
    appLogger.dWithPackage('files', 'changeFileOwner: path=$path, user=$user, group=$group');
    final api = await _getApi();
    await api.changeFileOwner(FileOwnerChange(
      path: path,
      user: user,
      group: group,
      recursive: recursive,
    ));
  }

  Future<void> saveFile(String path, String content, {String? encoding, bool? createDir}) async {
    appLogger.dWithPackage('files', 'saveFile: path=$path, contentLength=${content.length}');
    final api = await _getApi();
    await api.saveFile(FileSave(
      path: path,
      content: content,
      encoding: encoding,
      createDir: createDir,
    ));
  }

  Future<String> readFile(String path, {int? offset, int? length, String? encoding}) async {
    appLogger.dWithPackage('files', 'readFile: path=$path, offset=$offset, length=$length');
    final api = await _getApi();
    final response = await api.readFile(FileRead(
      path: path,
      offset: offset,
      length: length,
      encoding: encoding,
    ));
    return response.data ?? '';
  }

  Future<void> downloadFile(String path, String savePath) async {
    appLogger.dWithPackage('files', 'downloadFile: path=$path, savePath=$savePath');
    final api = await _getApi();
    await api.downloadFile(path);
  }

  Future<void> uploadFile(String path, dynamic file) async {
    appLogger.dWithPackage('files', 'uploadFile: path=$path');
    final api = await _getApi();
    await api.uploadFile(path, file);
  }

  Future<void> batchChangeRole(List<String> paths, String operation, {bool? force}) async {
    appLogger.dWithPackage('files', 'batchChangeRole: paths=$paths, operation=$operation');
    final api = await _getApi();
    await api.batchChangeFileRole(FileBatchOperate(
      paths: paths,
      operation: operation,
      force: force,
    ));
  }
}
