import 'package:equatable/equatable.dart';

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
