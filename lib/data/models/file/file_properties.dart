import 'package:equatable/equatable.dart';

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
