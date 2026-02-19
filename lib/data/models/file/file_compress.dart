import 'package:equatable/equatable.dart';

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

class FileCompress extends Equatable {
  final List<String> files;
  final String dst;
  final String name;
  final String type;
  final String? secret;
  final bool? replace;

  const FileCompress({
    required this.files,
    required this.dst,
    required this.name,
    required this.type,
    this.secret,
    this.replace,
  });

  factory FileCompress.fromJson(Map<String, dynamic> json) {
    return FileCompress(
      files: (json['files'] as List?)?.cast<String>() ?? [],
      dst: json['dst'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'zip',
      secret: json['secret'] as String?,
      replace: json['replace'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'files': files,
      'dst': dst,
      'name': name,
      'type': type,
    };
    if (secret != null) json['secret'] = secret;
    if (replace != null) json['replace'] = replace;
    return json;
  }

  @override
  List<Object?> get props => [files, dst, name, type, secret, replace];
}

class FileExtract extends Equatable {
  final String path;
  final String dst;
  final String type;
  final String? secret;

  const FileExtract({
    required this.path,
    required this.dst,
    required this.type,
    this.secret,
  });

  factory FileExtract.fromJson(Map<String, dynamic> json) {
    return FileExtract(
      path: json['path'] as String? ?? '',
      dst: json['dst'] as String? ?? '',
      type: json['type'] as String? ?? '',
      secret: json['secret'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'path': path,
      'dst': dst,
      'type': type,
    };
    if (secret != null) json['secret'] = secret;
    return json;
  }

  @override
  List<Object?> get props => [path, dst, type, secret];
}
