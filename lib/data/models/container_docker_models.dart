import 'package:equatable/equatable.dart';

class NetworkCreate extends Equatable {
  final String name;
  final String? driver;
  final bool? internal;
  final bool? attachable;
  final List<String>? ipam;
  final Map<String, String>? labels;
  final bool? enableIPv6;
  final bool? ipv4;
  final String? subnet;
  final String? gateway;
  final String? ipRange;
  final List<String>? options;

  const NetworkCreate({
    required this.name,
    this.driver,
    this.internal,
    this.attachable,
    this.ipam,
    this.labels,
    this.enableIPv6,
    this.ipv4,
    this.subnet,
    this.gateway,
    this.ipRange,
    this.options,
  });

  factory NetworkCreate.fromJson(Map<String, dynamic> json) {
    return NetworkCreate(
      name: json['name'] as String,
      driver: json['driver'] as String?,
      internal: json['internal'] as bool?,
      attachable: json['attachable'] as bool?,
      ipam: (json['ipam'] as List?)?.cast<String>(),
      labels: (json['labels'] as Map<String, dynamic>?)?.cast<String, String>(),
      enableIPv6: json['enableIPv6'] as bool?,
      ipv4: json['ipv4'] as bool?,
      subnet: json['subnet'] as String?,
      gateway: json['gateway'] as String?,
      ipRange: json['ipRange'] as String?,
      options: (json['options'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (driver != null) 'driver': driver,
      if (internal != null) 'internal': internal,
      if (attachable != null) 'attachable': attachable,
      if (ipam != null) 'ipam': ipam,
      if (labels != null) 'labels': labels,
      if (enableIPv6 != null) 'enableIPv6': enableIPv6,
      if (ipv4 != null) 'ipv4': ipv4,
      if (subnet != null) 'subnet': subnet,
      if (gateway != null) 'gateway': gateway,
      if (ipRange != null) 'ipRange': ipRange,
      if (options != null) 'options': options,
    };
  }

  @override
  List<Object?> get props => [
        name,
        driver,
        internal,
        attachable,
        ipam,
        labels,
        enableIPv6,
        ipv4,
        subnet,
        gateway,
        ipRange,
        options,
      ];
}

/// 卷创建模型
class VolumeCreate extends Equatable {
  final String name;
  final String? driver;
  final Map<String, String>? driverOpts;
  final Map<String, String>? labels;

  const VolumeCreate({
    required this.name,
    this.driver,
    this.driverOpts,
    this.labels,
  });

  factory VolumeCreate.fromJson(Map<String, dynamic> json) {
    return VolumeCreate(
      name: json['name'] as String,
      driver: json['driver'] as String?,
      driverOpts:
          (json['driverOpts'] as Map<String, dynamic>?)?.cast<String, String>(),
      labels: (json['labels'] as Map<String, dynamic>?)?.cast<String, String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'driver': driver,
      'driverOpts': driverOpts,
      'labels': labels,
    };
  }

  @override
  List<Object?> get props => [name, driver, driverOpts, labels];
}

/// 容器清理报告模型
class ContainerPruneReport extends Equatable {
  final int? deletedCount;
  final int? spaceReclaimed;
  final List<String>? deletedItems;
  final String? message;

  const ContainerPruneReport({
    this.deletedCount,
    this.spaceReclaimed,
    this.deletedItems,
    this.message,
  });

  factory ContainerPruneReport.fromJson(Map<String, dynamic> json) {
    return ContainerPruneReport(
      deletedCount: json['deletedCount'] as int?,
      spaceReclaimed: json['spaceReclaimed'] as int?,
      deletedItems: (json['deletedItems'] as List?)?.cast<String>(),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deletedCount': deletedCount,
      'spaceReclaimed': spaceReclaimed,
      'deletedItems': deletedItems,
      'message': message,
    };
  }

  @override
  List<Object?> get props =>
      [deletedCount, spaceReclaimed, deletedItems, message];
}

/// 容器仓库模型
class ContainerRepo extends Equatable {
  final int id;
  final String name;
  final String downloadUrl;
  final String? username;
  final String? password;
  final String status;
  final String createdAt;
  final String updatedAt;

  const ContainerRepo({
    required this.id,
    required this.name,
    required this.downloadUrl,
    this.username,
    this.password,
    this.status = 'Success',
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContainerRepo.fromJson(Map<String, dynamic> json) {
    return ContainerRepo(
      id: json['id'] as int,
      name: json['name'] as String,
      downloadUrl: json['downloadUrl'] as String,
      username: json['username'] as String?,
      password: json['password'] as String?,
      status: json['status'] as String? ?? 'Success',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'downloadUrl': downloadUrl,
      'username': username,
      'password': password,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, downloadUrl, username, password, status, createdAt, updatedAt];
}

/// 容器仓库创建/更新模型
class ContainerRepoOperate extends Equatable {
  final int? id;
  final String name;
  final String downloadUrl;
  final String? username;
  final String? password;

  const ContainerRepoOperate({
    this.id,
    required this.name,
    required this.downloadUrl,
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'downloadUrl': downloadUrl,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
    };
  }

  @override
  List<Object?> get props => [id, name, downloadUrl, username, password];
}

/// 容器模板模型
class ContainerTemplate extends Equatable {
  final int id;
  final String name;
  final String description;
  final String content;
  final String createdAt;
  final String updatedAt;

  const ContainerTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContainerTemplate.fromJson(Map<String, dynamic> json) {
    return ContainerTemplate(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, description, content, createdAt, updatedAt];
}

/// 容器模板创建/更新模型
class ContainerTemplateOperate extends Equatable {
  final int? id;
  final String name;
  final String description;
  final String content;

  const ContainerTemplateOperate({
    this.id,
    required this.name,
    required this.description,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'content': content,
    };
  }

  @override
  List<Object?> get props => [id, name, description, content];
}

/// 容器模板批量导入模型
class ContainerTemplateBatch extends Equatable {
  final List<ContainerTemplateOperate> templates;

  const ContainerTemplateBatch({
    required this.templates,
  });

  Map<String, dynamic> toJson() {
    return {
      'templates': templates.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [templates];
}

/// 文件路径请求模型
class FilePath extends Equatable {
  final String path;

  const FilePath({required this.path});

  Map<String, dynamic> toJson() => {'path': path};

  factory FilePath.fromJson(Map<String, dynamic> json) {
    return FilePath(path: json['path'] as String? ?? '');
  }

  @override
  List<Object?> get props => [path];
}

/// 容器文件请求模型
class ContainerFileRequest extends Equatable {
  final String containerId;
  final String path;

  const ContainerFileRequest({
    required this.containerId,
    required this.path,
  });

  Map<String, dynamic> toJson() {
    return {
      'containerID': containerId,
      'path': path,
    };
  }

  factory ContainerFileRequest.fromJson(Map<String, dynamic> json) {
    return ContainerFileRequest(
      containerId: json['containerID'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [containerId, path];
}

/// 容器文件批量删除请求模型
class ContainerFileBatchDeleteRequest extends Equatable {
  final String containerId;
  final List<String> paths;

  const ContainerFileBatchDeleteRequest({
    required this.containerId,
    required this.paths,
  });

  Map<String, dynamic> toJson() {
    return {
      'containerID': containerId,
      'paths': paths,
    };
  }

  factory ContainerFileBatchDeleteRequest.fromJson(Map<String, dynamic> json) {
    return ContainerFileBatchDeleteRequest(
      containerId: json['containerID'] as String? ?? '',
      paths: (json['paths'] as List?)?.cast<String>() ?? const [],
    );
  }

  @override
  List<Object?> get props => [containerId, paths];
}

/// 容器文件信息模型
class ContainerFileInfo extends Equatable {
  final String name;
  final String path;
  final bool isDir;
  final bool isLink;
  final String? linkTo;
  final String? modTime;
  final String? mode;
  final int? size;

  const ContainerFileInfo({
    required this.name,
    required this.path,
    required this.isDir,
    required this.isLink,
    this.linkTo,
    this.modTime,
    this.mode,
    this.size,
  });

  factory ContainerFileInfo.fromJson(Map<String, dynamic> json) {
    return ContainerFileInfo(
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      isDir: json['isDir'] as bool? ?? false,
      isLink: json['isLink'] as bool? ?? false,
      linkTo: json['linkTo'] as String?,
      modTime: json['modTime'] as String?,
      mode: json['mode'] as String?,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'isDir': isDir,
      'isLink': isLink,
      'linkTo': linkTo,
      'modTime': modTime,
      'mode': mode,
      'size': size,
    };
  }

  @override
  List<Object?> get props =>
      [name, path, isDir, isLink, linkTo, modTime, mode, size];
}

/// 容器文件内容模型
class ContainerFileContent extends Equatable {
  final String content;
  final bool isBinary;
  final int size;
  final bool truncated;

  const ContainerFileContent({
    required this.content,
    required this.isBinary,
    required this.size,
    required this.truncated,
  });

  factory ContainerFileContent.fromJson(Map<String, dynamic> json) {
    return ContainerFileContent(
      content: json['content'] as String? ?? '',
      isBinary: json['isBinary'] as bool? ?? false,
      size: json['size'] as int? ?? 0,
      truncated: json['truncated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isBinary': isBinary,
      'size': size,
      'truncated': truncated,
    };
  }

  @override
  List<Object?> get props => [content, isBinary, size, truncated];
}

/// 容器资源占用统计
class ContainerItemStats extends Equatable {
  final int? buildCacheReclaimable;
  final int? buildCacheUsage;
  final int? containerReclaimable;
  final int? containerUsage;
  final int? imageReclaimable;
  final int? imageUsage;
  final int? sizeRootFs;
  final int? sizeRw;
  final int? volumeReclaimable;
  final int? volumeUsage;

  const ContainerItemStats({
    this.buildCacheReclaimable,
    this.buildCacheUsage,
    this.containerReclaimable,
    this.containerUsage,
    this.imageReclaimable,
    this.imageUsage,
    this.sizeRootFs,
    this.sizeRw,
    this.volumeReclaimable,
    this.volumeUsage,
  });

  factory ContainerItemStats.fromJson(Map<String, dynamic> json) {
    return ContainerItemStats(
      buildCacheReclaimable: json['buildCacheReclaimable'] as int?,
      buildCacheUsage: json['buildCacheUsage'] as int?,
      containerReclaimable: json['containerReclaimable'] as int?,
      containerUsage: json['containerUsage'] as int?,
      imageReclaimable: json['imageReclaimable'] as int?,
      imageUsage: json['imageUsage'] as int?,
      sizeRootFs: json['sizeRootFs'] as int?,
      sizeRw: json['sizeRw'] as int?,
      volumeReclaimable: json['volumeReclaimable'] as int?,
      volumeUsage: json['volumeUsage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buildCacheReclaimable': buildCacheReclaimable,
      'buildCacheUsage': buildCacheUsage,
      'containerReclaimable': containerReclaimable,
      'containerUsage': containerUsage,
      'imageReclaimable': imageReclaimable,
      'imageUsage': imageUsage,
      'sizeRootFs': sizeRootFs,
      'sizeRw': sizeRw,
      'volumeReclaimable': volumeReclaimable,
      'volumeUsage': volumeUsage,
    };
  }

  @override
  List<Object?> get props => [
        buildCacheReclaimable,
        buildCacheUsage,
        containerReclaimable,
        containerUsage,
        imageReclaimable,
        imageUsage,
        sizeRootFs,
        sizeRw,
        volumeReclaimable,
        volumeUsage,
      ];
}

/// 容器列表选项
class ContainerOption extends Equatable {
  final String name;
  final String? state;

  const ContainerOption({
    required this.name,
    this.state,
  });

  factory ContainerOption.fromJson(Map<String, dynamic> json) {
    return ContainerOption(
      name: json['name'] as String? ?? '',
      state: json['state'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'state': state,
      };

  @override
  List<Object?> get props => [name, state];
}

/// Docker状态模型
class DockerStatus extends Equatable {
  final bool isActive;
  final bool isExist;

  const DockerStatus({
    required this.isActive,
    required this.isExist,
  });

  factory DockerStatus.fromJson(Map<String, dynamic> json) {
    return DockerStatus(
      isActive: json['isActive'] as bool? ?? false,
      isExist: json['isExist'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'isActive': isActive,
        'isExist': isExist,
      };

  @override
  List<Object?> get props => [isActive, isExist];
}

/// Docker操作请求模型
class DockerOperation extends Equatable {
  final String operation;

  const DockerOperation({required this.operation});

  Map<String, dynamic> toJson() => {'operation': operation};

  factory DockerOperation.fromJson(Map<String, dynamic> json) {
    return DockerOperation(operation: json['operation'] as String? ?? '');
  }

  @override
  List<Object?> get props => [operation];
}

/// Docker日志/IPv6配置选项
class LogOption extends Equatable {
  final String? logMaxFile;
  final String? logMaxSize;

  const LogOption({
    this.logMaxFile,
    this.logMaxSize,
  });

  Map<String, dynamic> toJson() => {
        if (logMaxFile != null) 'logMaxFile': logMaxFile,
        if (logMaxSize != null) 'logMaxSize': logMaxSize,
      };

  factory LogOption.fromJson(Map<String, dynamic> json) {
    return LogOption(
      logMaxFile: json['logMaxFile'] as String?,
      logMaxSize: json['logMaxSize'] as String?,
    );
  }

  @override
  List<Object?> get props => [logMaxFile, logMaxSize];
}

/// Daemon配置更新（通过文件内容）
class DaemonJsonUpdateByFile extends Equatable {
  final String file;

  const DaemonJsonUpdateByFile({
    required this.file,
  });

  Map<String, dynamic> toJson() {
    return {
      'file': file,
    };
  }

  @override
  List<Object?> get props => [file];
}
