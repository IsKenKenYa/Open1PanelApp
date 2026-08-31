import 'package:equatable/equatable.dart';
import 'container_models.dart';

/// Docker 镜像模型
class DockerImage extends Equatable {
  final String id;
  final List<String> tags;
  final int size;
  final String created;
  final String? digest;
  final bool isUsed;

  const DockerImage({
    required this.id,
    required this.tags,
    required this.size,
    required this.created,
    this.digest,
    this.isUsed = false,
  });

  factory DockerImage.fromJson(Map<String, dynamic> json) {
    return DockerImage(
      id: json['id'] as String? ?? '',
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      size: json['size'] as int? ?? 0,
      created: _resolveCreated(json['created']),
      digest: json['digest'] as String?,
      isUsed: json['isUsed'] as bool? ?? false,
    );
  }

  /// 上游 1Panel Docker API 的 created 可能是 epoch 秒（int）或 ISO 字符串，
  /// 统一归一为 ISO 字符串，避免 UI 直接外露 epoch 数值。
  static String _resolveCreated(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true)
          .toIso8601String();
    }
    return value as String? ?? '';
  }

  /// 解析创建时间；无法解析时返回 null（UI 需自行兜底）。
  DateTime? get createdDateTime => DateTime.tryParse(created);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tags': tags,
      'size': size,
      'created': created,
      'digest': digest,
      'isUsed': isUsed,
    };
  }

  @override
  List<Object?> get props => [id, tags, size, created, digest, isUsed];
}

/// Docker 网络模型
class DockerNetwork extends Equatable {
  final String id;
  final String name;
  final String driver;
  final String? scope;
  final bool? internal;
  final bool? attachable;
  final String? subnet;
  final String? gateway;

  const DockerNetwork({
    required this.id,
    required this.name,
    required this.driver,
    this.scope,
    this.internal,
    this.attachable,
    this.subnet,
    this.gateway,
  });

  factory DockerNetwork.fromJson(Map<String, dynamic> json) {
    return DockerNetwork(
      id: _cleanNullableString(json['id']) ?? '',
      name: _cleanNullableString(json['name']) ?? '',
      // Docker none 网络的驱动名就是字面 "null"，与空值一并归一，避免 UI 外露。
      driver: _cleanNullableString(json['driver']) ?? '',
      scope: _cleanNullableString(json['scope']),
      internal: json['internal'] as bool?,
      attachable: json['attachable'] as bool?,
      subnet: _cleanNullableString(json['subnet']),
      gateway: _cleanNullableString(json['gateway']),
    );
  }

  /// 上游偶发用字面 "null" 或空串表示空值，统一归一为 null。
  static String? _cleanNullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;
    return text;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'driver': driver,
      'scope': scope,
      'internal': internal,
      'attachable': attachable,
      'subnet': subnet,
      'gateway': gateway,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        driver,
        scope,
        internal,
        attachable,
        subnet,
        gateway,
      ];
}

/// Docker 卷模型
class DockerVolume extends Equatable {
  final String name;
  final String driver;
  final String? mountpoint;
  final Map<String, String>? labels;
  final Map<String, String>? options;

  const DockerVolume({
    required this.name,
    required this.driver,
    this.mountpoint,
    this.labels,
    this.options,
  });

  factory DockerVolume.fromJson(Map<String, dynamic> json) {
    return DockerVolume(
      name: json['name'] as String? ?? '',
      driver: json['driver'] as String? ?? '',
      mountpoint: json['mountpoint'] as String?,
      labels: (json['labels'] as Map<String, dynamic>?)?.cast<String, String>(),
      options:
          (json['options'] as Map<String, dynamic>?)?.cast<String, String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'driver': driver,
      'mountpoint': mountpoint,
      'labels': labels,
      'options': options,
    };
  }

  @override
  List<Object?> get props => [name, driver, mountpoint, labels, options];
}

/// Compose 项目模型 (复用 ContainerCompose)
typedef ComposeProject = ContainerCompose;

/// Compose 模板模型
class ComposeTemplate extends Equatable {
  final String id;
  final String name;
  final String content;
  final String? description;
  final String? createTime;
  final String? updateTime;

  const ComposeTemplate({
    required this.id,
    required this.name,
    required this.content,
    this.description,
    this.createTime,
    this.updateTime,
  });

  factory ComposeTemplate.fromJson(Map<String, dynamic> json) {
    return ComposeTemplate(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      content: json['content'] as String? ?? '',
      description: json['description'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'description': description,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, content, description, createTime, updateTime];
}

/// Container Compose 日志搜索请求模型
class ContainerComposeLogSearch extends Equatable {
  final int composeId;
  final int lines;

  const ContainerComposeLogSearch({
    required this.composeId,
    this.lines = 100,
  });

  Map<String, dynamic> toJson() {
    return {
      'composeId': composeId,
      'lines': lines,
    };
  }

  @override
  List<Object?> get props => [composeId, lines];
}
