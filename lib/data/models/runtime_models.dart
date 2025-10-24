/// Runtime management data models for 1Panel V2 API
///
/// This file contains all data models related to runtime management,
/// including Java, Node.js, Python, Go, PHP runtime environments.

import 'package:equatable/equatable.dart';

/// Runtime type enumeration
enum RuntimeType {
  java('java'),
  node('node'),
  python('python'),
  go('go'),
  php('php'),
  dotnet('dotnet');

  const RuntimeType(this.value);
  final String value;

  static RuntimeType fromString(String value) {
    return RuntimeType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => RuntimeType.java,
    );
  }
}

/// Runtime creation request model
class RuntimeCreate extends Equatable {
  final String name;
  final String type;
  final String? version;
  final String? source;
  final String? path;
  final Map<String, dynamic>? params;

  const RuntimeCreate({
    required this.name,
    required this.type,
    this.version,
    this.source,
    this.path,
    this.params,
  });

  factory RuntimeCreate.fromJson(Map<String, dynamic> json) {
    return RuntimeCreate(
      name: json['name'] as String,
      type: json['type'] as String,
      version: json['version'] as String?,
      source: json['source'] as String?,
      path: json['path'] as String?,
      params: json['params'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'version': version,
      'source': source,
      'path': path,
      'params': params,
    };
  }

  @override
  List<Object?> get props => [name, type, version, source, path, params];
}

/// Runtime information model
class RuntimeInfo extends Equatable {
  final int? id;
  final String? name;
  final String? type;
  final String? version;
  final String? source;
  final String? path;
  final String? status;
  final String? port;
  final Map<String, dynamic>? params;
  final String? createTime;
  final String? updateTime;

  const RuntimeInfo({
    this.id,
    this.name,
    this.type,
    this.version,
    this.source,
    this.path,
    this.status,
    this.port,
    this.params,
    this.createTime,
    this.updateTime,
  });

  factory RuntimeInfo.fromJson(Map<String, dynamic> json) {
    return RuntimeInfo(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      version: json['version'] as String?,
      source: json['source'] as String?,
      path: json['path'] as String?,
      status: json['status'] as String?,
      port: json['port'] as String?,
      params: json['params'] as Map<String, dynamic>?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'version': version,
      'source': source,
      'path': path,
      'status': status,
      'port': port,
      'params': params,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  @override
  List<Object?> get props => [id, name, type, version, source, path, status, port, params, createTime, updateTime];
}

/// Runtime search request model
class RuntimeSearch extends Equatable {
  final int? page;
  final int? pageSize;
  final String? search;
  final String? type;
  final String? status;

  const RuntimeSearch({
    this.page,
    this.pageSize,
    this.search,
    this.type,
    this.status,
  });

  factory RuntimeSearch.fromJson(Map<String, dynamic> json) {
    return RuntimeSearch(
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
      search: json['search'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'search': search,
      'type': type,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [page, pageSize, search, type, status];
}

/// Runtime operation model
class RuntimeOperate extends Equatable {
  final List<int> ids;
  final String operation;

  const RuntimeOperate({
    required this.ids,
    required this.operation,
  });

  factory RuntimeOperate.fromJson(Map<String, dynamic> json) {
    return RuntimeOperate(
      ids: (json['ids'] as List?)?.map((e) => e as int).toList() ?? [],
      operation: json['operation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ids': ids,
      'operation': operation,
    };
  }

  @override
  List<Object?> get props => [ids, operation];
}

/// Runtime update request model
class RuntimeUpdate extends Equatable {
  final int id;
  final String? name;
  final String? version;
  final String? source;
  final String? path;
  final Map<String, dynamic>? params;

  const RuntimeUpdate({
    required this.id,
    this.name,
    this.version,
    this.source,
    this.path,
    this.params,
  });

  factory RuntimeUpdate.fromJson(Map<String, dynamic> json) {
    return RuntimeUpdate(
      id: json['id'] as int,
      name: json['name'] as String?,
      version: json['version'] as String?,
      source: json['source'] as String?,
      path: json['path'] as String?,
      params: json['params'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'source': source,
      'path': path,
      'params': params,
    };
  }

  @override
  List<Object?> get props => [id, name, version, source, path, params];
}

/// Java runtime specific model
class JavaRuntime extends Equatable {
  final int? id;
  final String? name;
  final String? version;
  final String? jdkHome;
  final String? javaHome;
  final String? classpath;
  final Map<String, String>? environmentVariables;
  final String? status;

  const JavaRuntime({
    this.id,
    this.name,
    this.version,
    this.jdkHome,
    this.javaHome,
    this.classpath,
    this.environmentVariables,
    this.status,
  });

  factory JavaRuntime.fromJson(Map<String, dynamic> json) {
    return JavaRuntime(
      id: json['id'] as int?,
      name: json['name'] as String?,
      version: json['version'] as String?,
      jdkHome: json['jdkHome'] as String?,
      javaHome: json['javaHome'] as String?,
      classpath: json['classpath'] as String?,
      environmentVariables: (json['environmentVariables'] as Map<String, dynamic>?)?.cast<String, String>(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'jdkHome': jdkHome,
      'javaHome': javaHome,
      'classpath': classpath,
      'environmentVariables': environmentVariables,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, name, version, jdkHome, javaHome, classpath, environmentVariables, status];
}

/// Node.js runtime specific model
class NodeRuntime extends Equatable {
  final int? id;
  final String? name;
  final String? version;
  final String? nodeHome;
  final String? npmHome;
  final String? packageManager;
  final Map<String, String>? environmentVariables;
  final String? status;

  const NodeRuntime({
    this.id,
    this.name,
    this.version,
    this.nodeHome,
    this.npmHome,
    this.packageManager,
    this.environmentVariables,
    this.status,
  });

  factory NodeRuntime.fromJson(Map<String, dynamic> json) {
    return NodeRuntime(
      id: json['id'] as int?,
      name: json['name'] as String?,
      version: json['version'] as String?,
      nodeHome: json['nodeHome'] as String?,
      npmHome: json['npmHome'] as String?,
      packageManager: json['packageManager'] as String?,
      environmentVariables: (json['environmentVariables'] as Map<String, dynamic>?)?.cast<String, String>(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'nodeHome': nodeHome,
      'npmHome': npmHome,
      'packageManager': packageManager,
      'environmentVariables': environmentVariables,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, name, version, nodeHome, npmHome, packageManager, environmentVariables, status];
}

/// Python runtime specific model
class PythonRuntime extends Equatable {
  final int? id;
  final String? name;
  final String? version;
  final String? pythonHome;
  final String? pipHome;
  final String? virtualenvPath;
  final Map<String, String>? environmentVariables;
  final String? status;

  const PythonRuntime({
    this.id,
    this.name,
    this.version,
    this.pythonHome,
    this.pipHome,
    this.virtualenvPath,
    this.environmentVariables,
    this.status,
  });

  factory PythonRuntime.fromJson(Map<String, dynamic> json) {
    return PythonRuntime(
      id: json['id'] as int?,
      name: json['name'] as String?,
      version: json['version'] as String?,
      pythonHome: json['pythonHome'] as String?,
      pipHome: json['pipHome'] as String?,
      virtualenvPath: json['virtualenvPath'] as String?,
      environmentVariables: (json['environmentVariables'] as Map<String, dynamic>?)?.cast<String, String>(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'pythonHome': pythonHome,
      'pipHome': pipHome,
      'virtualenvPath': virtualenvPath,
      'environmentVariables': environmentVariables,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, name, version, pythonHome, pipHome, virtualenvPath, environmentVariables, status];
}

/// Go runtime specific model
class GoRuntime extends Equatable {
  final int? id;
  final String? name;
  final String? version;
  final String? goHome;
  final String? gopath;
  final String? gocache;
  final Map<String, String>? environmentVariables;
  final String? status;

  const GoRuntime({
    this.id,
    this.name,
    this.version,
    this.goHome,
    this.gopath,
    this.gocache,
    this.environmentVariables,
    this.status,
  });

  factory GoRuntime.fromJson(Map<String, dynamic> json) {
    return GoRuntime(
      id: json['id'] as int?,
      name: json['name'] as String?,
      version: json['version'] as String?,
      goHome: json['goHome'] as String?,
      gopath: json['gopath'] as String?,
      gocache: json['gocache'] as String?,
      environmentVariables: (json['environmentVariables'] as Map<String, dynamic>?)?.cast<String, String>(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'goHome': goHome,
      'gopath': gopath,
      'gocache': gocache,
      'environmentVariables': environmentVariables,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, name, version, goHome, gopath, gocache, environmentVariables, status];
}

/// PHP runtime specific model
class PHPRuntime extends Equatable {
  final int? id;
  final String? name;
  final String? version;
  final String? phpHome;
  final String? phpIniPath;
  final String? extensionDir;
  final Map<String, String>? environmentVariables;
  final String? status;

  const PHPRuntime({
    this.id,
    this.name,
    this.version,
    this.phpHome,
    this.phpIniPath,
    this.extensionDir,
    this.environmentVariables,
    this.status,
  });

  factory PHPRuntime.fromJson(Map<String, dynamic> json) {
    return PHPRuntime(
      id: json['id'] as int?,
      name: json['name'] as String?,
      version: json['version'] as String?,
      phpHome: json['phpHome'] as String?,
      phpIniPath: json['phpIniPath'] as String?,
      extensionDir: json['extensionDir'] as String?,
      environmentVariables: (json['environmentVariables'] as Map<String, dynamic>?)?.cast<String, String>(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'phpHome': phpHome,
      'phpIniPath': phpIniPath,
      'extensionDir': extensionDir,
      'environmentVariables': environmentVariables,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, name, version, phpHome, phpIniPath, extensionDir, environmentVariables, status];
}

/// Runtime package model
class RuntimePackage extends Equatable {
  final int? id;
  final String? name;
  final String? version;
  final String? runtimeType;
  final int? runtimeId;
  final String? description;
  final String? status;

  const RuntimePackage({
    this.id,
    this.name,
    this.version,
    this.runtimeType,
    this.runtimeId,
    this.description,
    this.status,
  });

  factory RuntimePackage.fromJson(Map<String, dynamic> json) {
    return RuntimePackage(
      id: json['id'] as int?,
      name: json['name'] as String?,
      version: json['version'] as String?,
      runtimeType: json['runtimeType'] as String?,
      runtimeId: json['runtimeId'] as int?,
      description: json['description'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'runtimeType': runtimeType,
      'runtimeId': runtimeId,
      'description': description,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, name, version, runtimeType, runtimeId, description, status];
}