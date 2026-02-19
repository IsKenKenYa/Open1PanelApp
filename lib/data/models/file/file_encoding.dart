import 'package:equatable/equatable.dart';

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

class FileConvertRequest extends Equatable {
  final String path;
  final String fromEncoding;
  final String toEncoding;

  const FileConvertRequest({
    required this.path,
    required this.fromEncoding,
    required this.toEncoding,
  });

  factory FileConvertRequest.fromJson(Map<String, dynamic> json) {
    return FileConvertRequest(
      path: json['path'] as String,
      fromEncoding: json['fromEncoding'] as String,
      toEncoding: json['toEncoding'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'fromEncoding': fromEncoding,
      'toEncoding': toEncoding,
    };
  }

  @override
  List<Object?> get props => [path, fromEncoding, toEncoding];
}

class FileConvertLogRequest extends Equatable {
  final String path;

  const FileConvertLogRequest({
    required this.path,
  });

  factory FileConvertLogRequest.fromJson(Map<String, dynamic> json) {
    return FileConvertLogRequest(
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
