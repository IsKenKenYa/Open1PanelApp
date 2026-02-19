import 'package:equatable/equatable.dart';

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
