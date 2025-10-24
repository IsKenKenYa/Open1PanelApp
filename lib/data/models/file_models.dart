/// 1Panel V2 API - File 相关数据模型
///
/// 此文件包含文件管理相关的所有数据模型，
/// 包括文件的创建、更新、查询等操作的数据结构。

import 'package:equatable/equatable.dart';

/// 文件搜索模型
class FileSearch extends Equatable {
  final String path;
  final String? search;
  final int page;
  final int pageSize;
  final bool? expand;
  final String? sortBy;
  final String? sortOrder;

  const FileSearch({
    required this.path,
    this.search,
    this.page = 1,
    this.pageSize = 100,
    this.expand,
    this.sortBy,
    this.sortOrder,
  });

  factory FileSearch.fromJson(Map<String, dynamic> json) {
    return FileSearch(
      path: json['path'] as String,
      search: json['search'] as String?,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 100,
      expand: json['expand'] as bool?,
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'search': search,
      'page': page,
      'pageSize': pageSize,
      'expand': expand,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }

  @override
  List<Object?> get props => [
        path,
        search,
        page,
        pageSize,
        expand,
        sortBy,
        sortOrder,
      ];
}

/// 文件信息模型
class FileInfo extends Equatable {
  final String name;
  final String path;
  final String type;
  final int size;
  final String? permission;
  final String? user;
  final String? group;
  final DateTime? modifiedAt;
  final DateTime? createdAt;
  final String? mimeType;
  final bool isDir;
  final bool isSymlink;
  final String? linkTarget;
  final List<FileInfo>? children;

  const FileInfo({
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    this.permission,
    this.user,
    this.group,
    this.modifiedAt,
    this.createdAt,
    this.mimeType,
    this.isDir = false,
    this.isSymlink = false,
    this.linkTarget,
    this.children,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      name: json['name'] as String,
      path: json['path'] as String,
      type: json['type'] as String,
      size: json['size'] as int? ?? 0,
      permission: json['permission'] as String?,
      user: json['user'] as String?,
      group: json['group'] as String?,
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      mimeType: json['mimeType'] as String?,
      isDir: json['isDir'] as bool? ?? false,
      isSymlink: json['isSymlink'] as bool? ?? false,
      linkTarget: json['linkTarget'] as String?,
      children: (json['children'] as List?)
          ?.map((item) => FileInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type,
      'size': size,
      'permission': permission,
      'user': user,
      'group': group,
      'modifiedAt': modifiedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'mimeType': mimeType,
      'isDir': isDir,
      'isSymlink': isSymlink,
      'linkTarget': linkTarget,
      'children': children?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        name,
        path,
        type,
        size,
        permission,
        user,
        group,
        modifiedAt,
        createdAt,
        mimeType,
        isDir,
        isSymlink,
        linkTarget,
        children,
      ];
}

/// 文件操作模型
class FileOperate extends Equatable {
  final List<String> paths;
  final bool? force;

  const FileOperate({
    required this.paths,
    this.force,
  });

  factory FileOperate.fromJson(Map<String, dynamic> json) {
    return FileOperate(
      paths: (json['paths'] as List?)?.cast<String>() ?? [],
      force: json['force'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paths': paths,
      'force': force,
    };
  }

  @override
  List<Object?> get props => [paths, force];
}

/// 文件重命名模型
class FileRename extends Equatable {
  final String oldPath;
  final String newPath;

  const FileRename({
    required this.oldPath,
    required this.newPath,
  });

  factory FileRename.fromJson(Map<String, dynamic> json) {
    return FileRename(
      oldPath: json['oldPath'] as String,
      newPath: json['newPath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oldPath': oldPath,
      'newPath': newPath,
    };
  }

  @override
  List<Object?> get props => [oldPath, newPath];
}

/// 文件移动模型
class FileMove extends Equatable {
  final List<String> paths;
  final String targetPath;

  const FileMove({
    required this.paths,
    required this.targetPath,
  });

  factory FileMove.fromJson(Map<String, dynamic> json) {
    return FileMove(
      paths: (json['paths'] as List?)?.cast<String>() ?? [],
      targetPath: json['targetPath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paths': paths,
      'targetPath': targetPath,
    };
  }

  @override
  List<Object?> get props => [paths, targetPath];
}

/// 文件复制模型
class FileCopy extends Equatable {
  final List<String> paths;
  final String targetPath;

  const FileCopy({
    required this.paths,
    required this.targetPath,
  });

  factory FileCopy.fromJson(Map<String, dynamic> json) {
    return FileCopy(
      paths: (json['paths'] as List?)?.cast<String>() ?? [],
      targetPath: json['targetPath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paths': paths,
      'targetPath': targetPath,
    };
  }

  @override
  List<Object?> get props => [paths, targetPath];
}

/// 文件上传模型
class FileUpload extends Equatable {
  final String path;
  final String? fileName;
  final bool? override;

  const FileUpload({
    required this.path,
    this.fileName,
    this.override,
  });

  factory FileUpload.fromJson(Map<String, dynamic> json) {
    return FileUpload(
      path: json['path'] as String,
      fileName: json['fileName'] as String?,
      override: json['override'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'fileName': fileName,
      'override': override,
    };
  }

  @override
  List<Object?> get props => [path, fileName, override];
}

/// 文件下载模型
class FileDownload extends Equatable {
  final String path;
  final bool? isDownload;

  const FileDownload({
    required this.path,
    this.isDownload,
  });

  factory FileDownload.fromJson(Map<String, dynamic> json) {
    return FileDownload(
      path: json['path'] as String,
      isDownload: json['isDownload'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'isDownload': isDownload,
    };
  }

  @override
  List<Object?> get props => [path, isDownload];
}

/// 文件内容模型
class FileContent extends Equatable {
  final String path;
  final String? content;

  const FileContent({
    required this.path,
    this.content,
  });

  factory FileContent.fromJson(Map<String, dynamic> json) {
    return FileContent(
      path: json['path'] as String,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'content': content,
    };
  }

  @override
  List<Object?> get props => [path, content];
}

/// 文件压缩模型
class FileCompress extends Equatable {
  final List<String> paths;
  final String targetPath;
  final String type;
  final String? password;

  const FileCompress({
    required this.paths,
    required this.targetPath,
    required this.type,
    this.password,
  });

  factory FileCompress.fromJson(Map<String, dynamic> json) {
    return FileCompress(
      paths: (json['paths'] as List?)?.cast<String>() ?? [],
      targetPath: json['targetPath'] as String,
      type: json['type'] as String,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paths': paths,
      'targetPath': targetPath,
      'type': type,
      if (password != null) 'password': password,
    };
  }

  @override
  List<Object?> get props => [paths, targetPath, type, password];
}

/// 文件解压模型
class FileExtract extends Equatable {
  final String path;
  final String targetPath;
  final String? password;

  const FileExtract({
    required this.path,
    required this.targetPath,
    this.password,
  });

  factory FileExtract.fromJson(Map<String, dynamic> json) {
    return FileExtract(
      path: json['path'] as String,
      targetPath: json['targetPath'] as String,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'targetPath': targetPath,
      if (password != null) 'password': password,
    };
  }

  @override
  List<Object?> get props => [path, targetPath, password];
}

/// 文件权限模型
class FilePermission extends Equatable {
  final String path;
  final String? permission;
  final String? user;
  final String? group;
  final bool? recursive;

  const FilePermission({
    required this.path,
    this.permission,
    this.user,
    this.group,
    this.recursive,
  });

  factory FilePermission.fromJson(Map<String, dynamic> json) {
    return FilePermission(
      path: json['path'] as String,
      permission: json['permission'] as String?,
      user: json['user'] as String?,
      group: json['group'] as String?,
      recursive: json['recursive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'permission': permission,
      'user': user,
      'group': group,
      'recursive': recursive,
    };
  }

  @override
  List<Object?> get props => [
        path,
        permission,
        user,
        group,
        recursive,
      ];
}

/// 文件创建模型
class FileCreate extends Equatable {
  final String path;
  final String? content;
  final bool? isDir;
  final String? permission;

  const FileCreate({
    required this.path,
    this.content,
    this.isDir,
    this.permission,
  });

  factory FileCreate.fromJson(Map<String, dynamic> json) {
    return FileCreate(
      path: json['path'] as String,
      content: json['content'] as String?,
      isDir: json['isDir'] as bool?,
      permission: json['permission'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'content': content,
      'isDir': isDir,
      'permission': permission,
    };
  }

  @override
  List<Object?> get props => [path, content, isDir, permission];
}

/// 文件类型枚举
enum FileType {
  file('file', '文件'),
  directory('directory', '目录'),
  symlink('symlink', '符号链接');

  const FileType(this.value, this.displayName);

  final String value;
  final String displayName;

  static FileType fromString(String value) {
    return FileType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => FileType.file,
    );
  }
}

/// 压缩类型枚举
enum CompressType {
  zip('zip', 'ZIP'),
  tar('tar', 'TAR'),
  tarGz('tar.gz', 'TAR.GZ'),
  tarBz2('tar.bz2', 'TAR.BZ2'),
  gz('gz', 'GZ'),
  bz2('bz2', 'BZ2'),
  xz('xz', 'XZ'),
  sevenZ('7z', '7Z');

  const CompressType(this.value, this.displayName);

  final String value;
  final String displayName;

  static CompressType fromString(String value) {
    return CompressType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => CompressType.zip,
    );
  }
}

/// 文件批量操作模型
class FileBatchOperate extends Equatable {
  final List<String> paths;
  final String operation;
  final bool? force;

  const FileBatchOperate({
    required this.paths,
    required this.operation,
    this.force,
  });

  factory FileBatchOperate.fromJson(Map<String, dynamic> json) {
    return FileBatchOperate(
      paths: (json['paths'] as List?)?.cast<String>() ?? [],
      operation: json['operation'] as String,
      force: json['force'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paths': paths,
      'operation': operation,
      'force': force,
    };
  }

  @override
  List<Object?> get props => [paths, operation, force];
}

/// 文件检查模型
class FileCheck extends Equatable {
  final String path;
  final bool? checkExists;
  final bool? checkReadable;
  final bool? checkWritable;

  const FileCheck({
    required this.path,
    this.checkExists,
    this.checkReadable,
    this.checkWritable,
  });

  factory FileCheck.fromJson(Map<String, dynamic> json) {
    return FileCheck(
      path: json['path'] as String,
      checkExists: json['checkExists'] as bool?,
      checkReadable: json['checkReadable'] as bool?,
      checkWritable: json['checkWritable'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'checkExists': checkExists,
      'checkReadable': checkReadable,
      'checkWritable': checkWritable,
    };
  }

  @override
  List<Object?> get props => [path, checkExists, checkReadable, checkWritable];
}

/// 文件检查结果模型
class FileCheckResult extends Equatable {
  final String path;
  final bool exists;
  final bool readable;
  final bool writable;
  final bool isDirectory;
  final bool isFile;
  final int? size;
  final String? lastModified;

  const FileCheckResult({
    required this.path,
    required this.exists,
    required this.readable,
    required this.writable,
    required this.isDirectory,
    required this.isFile,
    this.size,
    this.lastModified,
  });

  factory FileCheckResult.fromJson(Map<String, dynamic> json) {
    return FileCheckResult(
      path: json['path'] as String,
      exists: json['exists'] as bool? ?? false,
      readable: json['readable'] as bool? ?? false,
      writable: json['writable'] as bool? ?? false,
      isDirectory: json['isDirectory'] as bool? ?? false,
      isFile: json['isFile'] as bool? ?? false,
      size: json['size'] as int?,
      lastModified: json['lastModified'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'exists': exists,
      'readable': readable,
      'writable': writable,
      'isDirectory': isDirectory,
      'isFile': isFile,
      'size': size,
      'lastModified': lastModified,
    };
  }

  @override
  List<Object?> get props => [path, exists, readable, writable, isDirectory, isFile, size, lastModified];
}

/// 文件分块下载模型
class FileChunkDownload extends Equatable {
  final String path;
  final int chunkSize;
  final int chunkNumber;
  final String? filePath;

  const FileChunkDownload({
    required this.path,
    required this.chunkSize,
    required this.chunkNumber,
    this.filePath,
  });

  factory FileChunkDownload.fromJson(Map<String, dynamic> json) {
    return FileChunkDownload(
      path: json['path'] as String,
      chunkSize: json['chunkSize'] as int,
      chunkNumber: json['chunkNumber'] as int,
      filePath: json['filePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'chunkSize': chunkSize,
      'chunkNumber': chunkNumber,
      'filePath': filePath,
    };
  }

  @override
  List<Object?> get props => [path, chunkSize, chunkNumber, filePath];
}

/// 文件分块数据模型
class FileChunkData extends Equatable {
  final String? data;
  final int chunkNumber;
  final bool isLastChunk;
  final String? checksum;

  const FileChunkData({
    this.data,
    required this.chunkNumber,
    required this.isLastChunk,
    this.checksum,
  });

  factory FileChunkData.fromJson(Map<String, dynamic> json) {
    return FileChunkData(
      data: json['data'] as String?,
      chunkNumber: json['chunkNumber'] as int,
      isLastChunk: json['isLastChunk'] as bool? ?? false,
      checksum: json['checksum'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'chunkNumber': chunkNumber,
      'isLastChunk': isLastChunk,
      'checksum': checksum,
    };
  }

  @override
  List<Object?> get props => [data, chunkNumber, isLastChunk, checksum];
}

/// 文件分块上传模型
class FileChunkUpload extends Equatable {
  final String path;
  final String data;
  final int chunkNumber;
  final bool isLastChunk;
  final String? checksum;

  const FileChunkUpload({
    required this.path,
    required this.data,
    required this.chunkNumber,
    required this.isLastChunk,
    this.checksum,
  });

  factory FileChunkUpload.fromJson(Map<String, dynamic> json) {
    return FileChunkUpload(
      path: json['path'] as String,
      data: json['data'] as String,
      chunkNumber: json['chunkNumber'] as int,
      isLastChunk: json['isLastChunk'] as bool? ?? false,
      checksum: json['checksum'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'data': data,
      'chunkNumber': chunkNumber,
      'isLastChunk': isLastChunk,
      'checksum': checksum,
    };
  }

  @override
  List<Object?> get props => [path, data, chunkNumber, isLastChunk, checksum];
}

/// 文件分块结果模型
class FileChunkResult extends Equatable {
  final bool success;
  final int? totalChunks;
  final int? uploadedChunks;
  final String? message;

  const FileChunkResult({
    required this.success,
    this.totalChunks,
    this.uploadedChunks,
    this.message,
  });

  factory FileChunkResult.fromJson(Map<String, dynamic> json) {
    return FileChunkResult(
      success: json['success'] as bool? ?? false,
      totalChunks: json['totalChunks'] as int?,
      uploadedChunks: json['uploadedChunks'] as int?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'totalChunks': totalChunks,
      'uploadedChunks': uploadedChunks,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [success, totalChunks, uploadedChunks, message];
}

/// 文件收藏模型
class FileFavorite extends Equatable {
  final String path;
  final String? name;
  final String? description;

  const FileFavorite({
    required this.path,
    this.name,
    this.description,
  });

  factory FileFavorite.fromJson(Map<String, dynamic> json) {
    return FileFavorite(
      path: json['path'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [path, name, description];
}

/// 文件取消收藏模型
class FileUnfavorite extends Equatable {
  final String path;

  const FileUnfavorite({
    required this.path,
  });

  factory FileUnfavorite.fromJson(Map<String, dynamic> json) {
    return FileUnfavorite(
      path: json['path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
    };
  }

  @override
  List<Object?> get props => [path];
}

/// 文件模式修改模型
class FileModeChange extends Equatable {
  final String path;
  final String mode;
  final bool? recursive;

  const FileModeChange({
    required this.path,
    required this.mode,
    this.recursive,
  });

  factory FileModeChange.fromJson(Map<String, dynamic> json) {
    return FileModeChange(
      path: json['path'] as String,
      mode: json['mode'] as String,
      recursive: json['recursive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'mode': mode,
      'recursive': recursive,
    };
  }

  @override
  List<Object?> get props => [path, mode, recursive];
}

/// 文件所有者修改模型
class FileOwnerChange extends Equatable {
  final String path;
  final String? user;
  final String? group;
  final bool? recursive;

  const FileOwnerChange({
    required this.path,
    this.user,
    this.group,
    this.recursive,
  });

  factory FileOwnerChange.fromJson(Map<String, dynamic> json) {
    return FileOwnerChange(
      path: json['path'] as String,
      user: json['user'] as String?,
      group: json['group'] as String?,
      recursive: json['recursive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'user': user,
      'group': group,
      'recursive': recursive,
    };
  }

  @override
  List<Object?> get props => [path, user, group, recursive];
}

/// 文件读取模型
class FileRead extends Equatable {
  final String path;
  final int? offset;
  final int? length;
  final String? encoding;

  const FileRead({
    required this.path,
    this.offset,
    this.length,
    this.encoding,
  });

  factory FileRead.fromJson(Map<String, dynamic> json) {
    return FileRead(
      path: json['path'] as String,
      offset: json['offset'] as int?,
      length: json['length'] as int?,
      encoding: json['encoding'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'offset': offset,
      'length': length,
      'encoding': encoding,
    };
  }

  @override
  List<Object?> get props => [path, offset, length, encoding];
}

/// 文件保存模型
class FileSave extends Equatable {
  final String path;
  final String content;
  final String? encoding;
  final bool? createDir;

  const FileSave({
    required this.path,
    required this.content,
    this.encoding,
    this.createDir,
  });

  factory FileSave.fromJson(Map<String, dynamic> json) {
    return FileSave(
      path: json['path'] as String,
      content: json['content'] as String,
      encoding: json['encoding'] as String?,
      createDir: json['createDir'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'content': content,
      'encoding': encoding,
      'createDir': createDir,
    };
  }

  @override
  List<Object?> get props => [path, content, encoding, createDir];
}

/// 文件回收站减少模型
class FileRecycleReduce extends Equatable {
  final int? days;
  final int? count;
  final bool? byDate;

  const FileRecycleReduce({
    this.days,
    this.count,
    this.byDate,
  });

  factory FileRecycleReduce.fromJson(Map<String, dynamic> json) {
    return FileRecycleReduce(
      days: json['days'] as int?,
      count: json['count'] as int?,
      byDate: json['byDate'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'count': count,
      'byDate': byDate,
    };
  }

  @override
  List<Object?> get props => [days, count, byDate];
}

/// 文件回收站结果模型
class FileRecycleResult extends Equatable {
  final int deletedCount;
  final int totalSize;
  final String? message;

  const FileRecycleResult({
    required this.deletedCount,
    required this.totalSize,
    this.message,
  });

  factory FileRecycleResult.fromJson(Map<String, dynamic> json) {
    return FileRecycleResult(
      deletedCount: json['deletedCount'] as int? ?? 0,
      totalSize: json['totalSize'] as int? ?? 0,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deletedCount': deletedCount,
      'totalSize': totalSize,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [deletedCount, totalSize, message];
}

/// 文件回收站状态模型
class FileRecycleStatus extends Equatable {
  final int fileCount;
  final int totalSize;
  final String? oldestFile;
  final String? newestFile;

  const FileRecycleStatus({
    required this.fileCount,
    required this.totalSize,
    this.oldestFile,
    this.newestFile,
  });

  factory FileRecycleStatus.fromJson(Map<String, dynamic> json) {
    return FileRecycleStatus(
      fileCount: json['fileCount'] as int? ?? 0,
      totalSize: json['totalSize'] as int? ?? 0,
      oldestFile: json['oldestFile'] as String?,
      newestFile: json['newestFile'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileCount': fileCount,
      'totalSize': totalSize,
      'oldestFile': oldestFile,
      'newestFile': newestFile,
    };
  }

  @override
  List<Object?> get props => [fileCount, totalSize, oldestFile, newestFile];
}

/// 文件大小请求模型
class FileSizeRequest extends Equatable {
  final String path;
  final bool? recursive;
  final bool? includeHidden;

  const FileSizeRequest({
    required this.path,
    this.recursive,
    this.includeHidden,
  });

  factory FileSizeRequest.fromJson(Map<String, dynamic> json) {
    return FileSizeRequest(
      path: json['path'] as String,
      recursive: json['recursive'] as bool?,
      includeHidden: json['includeHidden'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'recursive': recursive,
      'includeHidden': includeHidden,
    };
  }

  @override
  List<Object?> get props => [path, recursive, includeHidden];
}

/// 文件大小信息模型
class FileSizeInfo extends Equatable {
  final String path;
  final int totalSize;
  final int fileCount;
  final int directoryCount;
  final Map<String, int>? sizeByType;

  const FileSizeInfo({
    required this.path,
    required this.totalSize,
    required this.fileCount,
    required this.directoryCount,
    this.sizeByType,
  });

  factory FileSizeInfo.fromJson(Map<String, dynamic> json) {
    return FileSizeInfo(
      path: json['path'] as String,
      totalSize: json['totalSize'] as int? ?? 0,
      fileCount: json['fileCount'] as int? ?? 0,
      directoryCount: json['directoryCount'] as int? ?? 0,
      sizeByType: (json['sizeByType'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'totalSize': totalSize,
      'fileCount': fileCount,
      'directoryCount': directoryCount,
      'sizeByType': sizeByType,
    };
  }

  @override
  List<Object?> get props => [path, totalSize, fileCount, directoryCount, sizeByType];
}

/// 文件树请求模型
class FileTreeRequest extends Equatable {
  final String path;
  final int? maxDepth;
  final bool? includeFiles;
  final bool? includeHidden;
  final List<String>? excludePatterns;

  const FileTreeRequest({
    required this.path,
    this.maxDepth,
    this.includeFiles,
    this.includeHidden,
    this.excludePatterns,
  });

  factory FileTreeRequest.fromJson(Map<String, dynamic> json) {
    return FileTreeRequest(
      path: json['path'] as String,
      maxDepth: json['maxDepth'] as int?,
      includeFiles: json['includeFiles'] as bool?,
      includeHidden: json['includeHidden'] as bool?,
      excludePatterns: (json['excludePatterns'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'maxDepth': maxDepth,
      'includeFiles': includeFiles,
      'includeHidden': includeHidden,
      'excludePatterns': excludePatterns,
    };
  }

  @override
  List<Object?> get props => [path, maxDepth, includeFiles, includeHidden, excludePatterns];
}

/// 文件树模型
class FileTree extends Equatable {
  final String path;
  final String name;
  final String type;
  final int size;
  final List<FileTree>? children;
  final int depth;

  const FileTree({
    required this.path,
    required this.name,
    required this.type,
    required this.size,
    this.children,
    required this.depth,
  });

  factory FileTree.fromJson(Map<String, dynamic> json) {
    return FileTree(
      path: json['path'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      size: json['size'] as int? ?? 0,
      children: (json['children'] as List?)
          ?.map((item) => FileTree.fromJson(item as Map<String, dynamic>))
          .toList(),
      depth: json['depth'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'type': type,
      'size': size,
      'children': children?.map((item) => item.toJson()).toList(),
      'depth': depth,
    };
  }

  @override
  List<Object?> get props => [path, name, type, size, children, depth];
}

/// 文件Wget请求模型
class FileWgetRequest extends Equatable {
  final String url;
  final String path;
  final String? filename;
  final bool? overwrite;
  final Map<String, String>? headers;

  const FileWgetRequest({
    required this.url,
    required this.path,
    this.filename,
    this.overwrite,
    this.headers,
  });

  factory FileWgetRequest.fromJson(Map<String, dynamic> json) {
    return FileWgetRequest(
      url: json['url'] as String,
      path: json['path'] as String,
      filename: json['filename'] as String?,
      overwrite: json['overwrite'] as bool?,
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as String),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'path': path,
      'filename': filename,
      'overwrite': overwrite,
      'headers': headers,
    };
  }

  @override
  List<Object?> get props => [url, path, filename, overwrite, headers];
}

/// 文件Wget结果模型
class FileWgetResult extends Equatable {
  final bool success;
  final String? filePath;
  final String? error;
  final int? downloadedSize;
  final String? checksum;

  const FileWgetResult({
    required this.success,
    this.filePath,
    this.error,
    this.downloadedSize,
    this.checksum,
  });

  factory FileWgetResult.fromJson(Map<String, dynamic> json) {
    return FileWgetResult(
      success: json['success'] as bool? ?? false,
      filePath: json['filePath'] as String?,
      error: json['error'] as String?,
      downloadedSize: json['downloadedSize'] as int?,
      checksum: json['checksum'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'filePath': filePath,
      'error': error,
      'downloadedSize': downloadedSize,
      'checksum': checksum,
    };
  }

  @override
  List<Object?> get props => [success, filePath, error, downloadedSize, checksum];
}

/// 文件批量结果模型
class FileBatchResult extends Equatable {
  final bool success;
  final int successCount;
  final int failureCount;
  final List<String>? errors;
  final List<String>? processedPaths;

  const FileBatchResult({
    required this.success,
    required this.successCount,
    required this.failureCount,
    this.errors,
    this.processedPaths,
  });

  factory FileBatchResult.fromJson(Map<String, dynamic> json) {
    return FileBatchResult(
      success: json['success'] as bool? ?? false,
      successCount: json['successCount'] as int? ?? 0,
      failureCount: json['failureCount'] as int? ?? 0,
      errors: (json['errors'] as List?)?.cast<String>(),
      processedPaths: (json['processedPaths'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'successCount': successCount,
      'failureCount': failureCount,
      'errors': errors,
      'processedPaths': processedPaths,
    };
  }

  @override
  List<Object?> get props => [success, successCount, failureCount, errors, processedPaths];
}

/// 文件属性请求模型
class FilePropertiesRequest extends Equatable {
  final String path;
  final bool? calculateChecksum;
  final bool? includeExtended;

  const FilePropertiesRequest({
    required this.path,
    this.calculateChecksum,
    this.includeExtended,
  });

  factory FilePropertiesRequest.fromJson(Map<String, dynamic> json) {
    return FilePropertiesRequest(
      path: json['path'] as String,
      calculateChecksum: json['calculateChecksum'] as bool?,
      includeExtended: json['includeExtended'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'calculateChecksum': calculateChecksum,
      'includeExtended': includeExtended,
    };
  }

  @override
  List<Object?> get props => [path, calculateChecksum, includeExtended];
}

/// 文件属性模型
class FileProperties extends Equatable {
  final String path;
  final String name;
  final String type;
  final int size;
  final String? mimeType;
  final String? permission;
  final String? owner;
  final String? group;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final DateTime? accessedAt;
  final String? checksum;
  final Map<String, dynamic>? extendedAttributes;

  const FileProperties({
    required this.path,
    required this.name,
    required this.type,
    required this.size,
    this.mimeType,
    this.permission,
    this.owner,
    this.group,
    this.createdAt,
    this.modifiedAt,
    this.accessedAt,
    this.checksum,
    this.extendedAttributes,
  });

  factory FileProperties.fromJson(Map<String, dynamic> json) {
    return FileProperties(
      path: json['path'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      size: json['size'] as int? ?? 0,
      mimeType: json['mimeType'] as String?,
      permission: json['permission'] as String?,
      owner: json['owner'] as String?,
      group: json['group'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'] as String)
          : null,
      accessedAt: json['accessedAt'] != null
          ? DateTime.parse(json['accessedAt'] as String)
          : null,
      checksum: json['checksum'] as String?,
      extendedAttributes: json['extendedAttributes'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'type': type,
      'size': size,
      'mimeType': mimeType,
      'permission': permission,
      'owner': owner,
      'group': group,
      'createdAt': createdAt?.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
      'accessedAt': accessedAt?.toIso8601String(),
      'checksum': checksum,
      'extendedAttributes': extendedAttributes,
    };
  }

  @override
  List<Object?> get props => [
        path,
        name,
        type,
        size,
        mimeType,
        permission,
        owner,
        group,
        createdAt,
        modifiedAt,
        accessedAt,
        checksum,
        extendedAttributes,
      ];
}

/// 文件链接创建模型
class FileLinkCreate extends Equatable {
  final String sourcePath;
  final String linkPath;
  final String linkType;
  final bool? overwrite;

  const FileLinkCreate({
    required this.sourcePath,
    required this.linkPath,
    required this.linkType,
    this.overwrite,
  });

  factory FileLinkCreate.fromJson(Map<String, dynamic> json) {
    return FileLinkCreate(
      sourcePath: json['sourcePath'] as String,
      linkPath: json['linkPath'] as String,
      linkType: json['linkType'] as String,
      overwrite: json['overwrite'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sourcePath': sourcePath,
      'linkPath': linkPath,
      'linkType': linkType,
      'overwrite': overwrite,
    };
  }

  @override
  List<Object?> get props => [sourcePath, linkPath, linkType, overwrite];
}

/// 文件链接结果模型
class FileLinkResult extends Equatable {
  final bool success;
  final String? linkPath;
  final String? error;

  const FileLinkResult({
    required this.success,
    this.linkPath,
    this.error,
  });

  factory FileLinkResult.fromJson(Map<String, dynamic> json) {
    return FileLinkResult(
      success: json['success'] as bool? ?? false,
      linkPath: json['linkPath'] as String?,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'linkPath': linkPath,
      'error': error,
    };
  }

  @override
  List<Object?> get props => [success, linkPath, error];
}

/// 文件编码转换模型
class FileEncodingConvert extends Equatable {
  final String path;
  final String fromEncoding;
  final String toEncoding;
  final bool? backup;

  const FileEncodingConvert({
    required this.path,
    required this.fromEncoding,
    required this.toEncoding,
    this.backup,
  });

  factory FileEncodingConvert.fromJson(Map<String, dynamic> json) {
    return FileEncodingConvert(
      path: json['path'] as String,
      fromEncoding: json['fromEncoding'] as String,
      toEncoding: json['toEncoding'] as String,
      backup: json['backup'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'fromEncoding': fromEncoding,
      'toEncoding': toEncoding,
      'backup': backup,
    };
  }

  @override
  List<Object?> get props => [path, fromEncoding, toEncoding, backup];
}

/// 文件编码结果模型
class FileEncodingResult extends Equatable {
  final bool success;
  final String? convertedPath;
  final String? backupPath;
  final String? error;

  const FileEncodingResult({
    required this.success,
    this.convertedPath,
    this.backupPath,
    this.error,
  });

  factory FileEncodingResult.fromJson(Map<String, dynamic> json) {
    return FileEncodingResult(
      success: json['success'] as bool? ?? false,
      convertedPath: json['convertedPath'] as String?,
      backupPath: json['backupPath'] as String?,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'convertedPath': convertedPath,
      'backupPath': backupPath,
      'error': error,
    };
  }

  @override
  List<Object?> get props => [success, convertedPath, backupPath, error];
}

/// 文件搜索请求模型
class FileSearchInRequest extends Equatable {
  final String path;
  final String pattern;
  final bool? caseSensitive;
  final bool? wholeWord;
  final bool? regex;
  final List<String>? fileTypes;
  final int? maxResults;

  const FileSearchInRequest({
    required this.path,
    required this.pattern,
    this.caseSensitive,
    this.wholeWord,
    this.regex,
    this.fileTypes,
    this.maxResults,
  });

  factory FileSearchInRequest.fromJson(Map<String, dynamic> json) {
    return FileSearchInRequest(
      path: json['path'] as String,
      pattern: json['pattern'] as String,
      caseSensitive: json['caseSensitive'] as bool?,
      wholeWord: json['wholeWord'] as bool?,
      regex: json['regex'] as bool?,
      fileTypes: (json['fileTypes'] as List?)?.cast<String>(),
      maxResults: json['maxResults'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'pattern': pattern,
      'caseSensitive': caseSensitive,
      'wholeWord': wholeWord,
      'regex': regex,
      'fileTypes': fileTypes,
      'maxResults': maxResults,
    };
  }

  @override
  List<Object?> get props => [path, pattern, caseSensitive, wholeWord, regex, fileTypes, maxResults];
}

/// 文件搜索结果模型
class FileSearchResult extends Equatable {
  final List<FileSearchMatch> matches;
  final int totalMatches;
  final int filesSearched;

  const FileSearchResult({
    required this.matches,
    required this.totalMatches,
    required this.filesSearched,
  });

  factory FileSearchResult.fromJson(Map<String, dynamic> json) {
    return FileSearchResult(
      matches: (json['matches'] as List?)
          ?.map((item) => FileSearchMatch.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      totalMatches: json['totalMatches'] as int? ?? 0,
      filesSearched: json['filesSearched'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matches': matches.map((item) => item.toJson()).toList(),
      'totalMatches': totalMatches,
      'filesSearched': filesSearched,
    };
  }

  @override
  List<Object?> get props => [matches, totalMatches, filesSearched];
}

/// 文件搜索匹配模型
class FileSearchMatch extends Equatable {
  final String filePath;
  final int lineNumber;
  final int columnNumber;
  final String line;
  final String match;

  const FileSearchMatch({
    required this.filePath,
    required this.lineNumber,
    required this.columnNumber,
    required this.line,
    required this.match,
  });

  factory FileSearchMatch.fromJson(Map<String, dynamic> json) {
    return FileSearchMatch(
      filePath: json['filePath'] as String,
      lineNumber: json['lineNumber'] as int? ?? 0,
      columnNumber: json['columnNumber'] as int? ?? 0,
      line: json['line'] as String,
      match: json['match'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'lineNumber': lineNumber,
      'columnNumber': columnNumber,
      'line': line,
      'match': match,
    };
  }

  @override
  List<Object?> get props => [filePath, lineNumber, columnNumber, line, match];
}