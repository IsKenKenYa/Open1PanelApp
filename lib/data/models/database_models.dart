/// 1Panel V2 API - Database 相关数据模型
///
/// 此文件包含数据库管理相关的所有数据模型，
/// 包括数据库的创建、更新、查询等操作的数据结构。

import 'package:equatable/equatable.dart';

/// 数据库创建模型
class DatabaseCreate extends Equatable {
  final String name;
  final String type;
  final String? version;
  final int? port;
  final String? username;
  final String? password;
  final String? charset;
  final String? collation;
  final String? description;
  final String? format;
  final bool? fromLocal;
  final String? remark;

  const DatabaseCreate({
    required this.name,
    required this.type,
    this.version,
    this.port,
    this.username,
    this.password,
    this.charset,
    this.collation,
    this.description,
    this.format,
    this.fromLocal,
    this.remark,
  });

  factory DatabaseCreate.fromJson(Map<String, dynamic> json) {
    return DatabaseCreate(
      name: json['name'] as String,
      type: json['type'] as String,
      version: json['version'] as String?,
      port: json['port'] as int?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      charset: json['charset'] as String?,
      collation: json['collation'] as String?,
      description: json['description'] as String?,
      format: json['format'] as String?,
      fromLocal: json['fromLocal'] as bool?,
      remark: json['remark'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'version': version,
      'port': port,
      'username': username,
      'password': password,
      'charset': charset,
      'collation': collation,
      'description': description,
      'format': format,
      'fromLocal': fromLocal,
      'remark': remark,
    };
  }

  @override
  List<Object?> get props => [
        name,
        type,
        version,
        port,
        username,
        password,
        charset,
        collation,
        description,
        format,
        fromLocal,
        remark,
      ];
}

/// 数据库更新模型
class DatabaseUpdate extends DatabaseCreate {
  final int id;

  const DatabaseUpdate({
    required this.id,
    required super.name,
    required super.type,
    super.version,
    super.port,
    super.username,
    super.password,
    super.charset,
    super.collation,
    super.description,
    super.format,
    super.fromLocal,
    super.remark,
  });

  factory DatabaseUpdate.fromJson(Map<String, dynamic> json) {
    return DatabaseUpdate(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      version: json['version'] as String?,
      port: json['port'] as int?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      charset: json['charset'] as String?,
      collation: json['collation'] as String?,
      description: json['description'] as String?,
      format: json['format'] as String?,
      fromLocal: json['fromLocal'] as bool?,
      remark: json['remark'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['id'] = id;
    return json;
  }

  @override
  List<Object?> get props => [...super.props, id];
}

/// 数据库搜索模型
class DatabaseSearch extends Equatable {
  final String? info;
  final String? name;
  final int page;
  final int pageSize;

  const DatabaseSearch({
    this.info,
    this.name,
    this.page = 1,
    this.pageSize = 20,
  });

  factory DatabaseSearch.fromJson(Map<String, dynamic> json) {
    return DatabaseSearch(
      info: json['info'] as String?,
      name: json['name'] as String?,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info,
      'name': name,
      'page': page,
      'pageSize': pageSize,
    };
  }

  @override
  List<Object?> get props => [info, name, page, pageSize];
}

/// 数据库信息模型
class DatabaseInfo extends Equatable {
  final int id;
  final String name;
  final String type;
  final String version;
  final String status;
  final String? host;
  final int? port;
  final String? username;
  final String? password;
  final String? charset;
  final String? collation;
  final String? description;
  final String? format;
  final String? remark;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? size;
  final String? connectionError;

  const DatabaseInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.version,
    required this.status,
    this.host,
    this.port,
    this.username,
    this.password,
    this.charset,
    this.collation,
    this.description,
    this.format,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.size,
    this.connectionError,
  });

  factory DatabaseInfo.fromJson(Map<String, dynamic> json) {
    return DatabaseInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      version: json['version'] as String,
      status: json['status'] as String,
      host: json['host'] as String?,
      port: json['port'] as int?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      charset: json['charset'] as String?,
      collation: json['collation'] as String?,
      description: json['description'] as String?,
      format: json['format'] as String?,
      remark: json['remark'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      size: json['size'] as int?,
      connectionError: json['connectionError'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'version': version,
      'status': status,
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'charset': charset,
      'collation': collation,
      'description': description,
      'format': format,
      'remark': remark,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'size': size,
      'connectionError': connectionError,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        version,
        status,
        host,
        port,
        username,
        password,
        charset,
        collation,
        description,
        format,
        remark,
        createdAt,
        updatedAt,
        size,
        connectionError,
      ];
}

/// 数据库连接信息模型
class DatabaseConn extends Equatable {
  final String containerName;
  final String password;
  final int? port;
  final String? serviceName;
  final String? status;
  final String? username;

  const DatabaseConn({
    required this.containerName,
    required this.password,
    this.port,
    this.serviceName,
    this.status,
    this.username,
  });

  factory DatabaseConn.fromJson(Map<String, dynamic> json) {
    return DatabaseConn(
      containerName: json['containerName'] as String,
      password: json['password'] as String,
      port: json['port'] as int?,
      serviceName: json['serviceName'] as String?,
      status: json['status'] as String?,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'containerName': containerName,
      'password': password,
      'port': port,
      'serviceName': serviceName,
      'status': status,
      'username': username,
    };
  }

  @override
  List<Object?> get props => [
        containerName,
        password,
        port,
        serviceName,
        status,
        username,
      ];
}

/// 数据库密码重置模型
class DatabaseResetPassword extends Equatable {
  final int id;
  final String? newPassword;

  const DatabaseResetPassword({
    required this.id,
    this.newPassword,
  });

  factory DatabaseResetPassword.fromJson(Map<String, dynamic> json) {
    return DatabaseResetPassword(
      id: json['id'] as int,
      newPassword: json['newPassword'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'newPassword': newPassword,
    };
  }

  @override
  List<Object?> get props => [id, newPassword];
}

/// 数据库备份模型
class DatabaseBackup extends Equatable {
  final int id;
  final String name;
  final String type;
  final String? targetDir;
  final String? fileName;
  final bool? encryption;
  final String? encryptionPassword;

  const DatabaseBackup({
    required this.id,
    required this.name,
    required this.type,
    this.targetDir,
    this.fileName,
    this.encryption,
    this.encryptionPassword,
  });

  factory DatabaseBackup.fromJson(Map<String, dynamic> json) {
    return DatabaseBackup(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      targetDir: json['targetDir'] as String?,
      fileName: json['fileName'] as String?,
      encryption: json['encryption'] as bool?,
      encryptionPassword: json['encryptionPassword'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'targetDir': targetDir,
      'fileName': fileName,
      'encryption': encryption,
      'encryptionPassword': encryptionPassword,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        targetDir,
        fileName,
        encryption,
        encryptionPassword,
      ];
}

/// 数据库恢复模型
class DatabaseRestore extends Equatable {
  final int id;
  final String? backupFile;
  final String? targetDir;

  const DatabaseRestore({
    required this.id,
    this.backupFile,
    this.targetDir,
  });

  factory DatabaseRestore.fromJson(Map<String, dynamic> json) {
    return DatabaseRestore(
      id: json['id'] as int,
      backupFile: json['backupFile'] as String?,
      targetDir: json['targetDir'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'backupFile': backupFile,
      'targetDir': targetDir,
    };
  }

  @override
  List<Object?> get props => [id, backupFile, targetDir];
}

/// 数据库类型枚举
enum DatabaseType {
  mysql('mysql', 'MySQL'),
  postgresql('postgresql', 'PostgreSQL'),
  mariadb('mariadb', 'MariaDB'),
  mongodb('mongodb', 'MongoDB'),
  redis('redis', 'Redis'),
  sqlite('sqlite', 'SQLite');

  const DatabaseType(this.value, this.displayName);

  final String value;
  final String displayName;

  static DatabaseType fromString(String value) {
    return DatabaseType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => DatabaseType.mysql,
    );
  }
}

/// 数据库状态枚举
enum DatabaseStatus {
  running('running', '运行中'),
  stopped('stopped', '已停止'),
  error('error', '错误'),
  installing('installing', '安装中'),
  creating('creating', '创建中'),
  deleting('deleting', '删除中'),
  backing_up('backing_up', '备份中'),
  restoring('restoring', '恢复中');

  const DatabaseStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static DatabaseStatus fromString(String value) {
    return DatabaseStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => DatabaseStatus.stopped,
    );
  }
}