import 'package:equatable/equatable.dart';

class GroupCreate extends Equatable {
  final int? id;
  final String name;
  final String type;

  const GroupCreate({
    this.id,
    required this.name,
    required this.type,
  });

  factory GroupCreate.fromJson(Map<String, dynamic> json) {
    return GroupCreate(
      id: json['id'] as int?,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [id, name, type];
}

class GroupUpdate extends GroupCreate {
  final bool? isDefault;

  const GroupUpdate({
    super.id,
    required super.name,
    required super.type,
    this.isDefault,
  });

  factory GroupUpdate.fromJson(Map<String, dynamic> json) {
    return GroupUpdate(
      id: json['id'] as int?,
      name: json['name'] as String,
      type: json['type'] as String,
      isDefault: json['isDefault'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    if (isDefault != null) {
      json['isDefault'] = isDefault;
    }
    return json;
  }

  @override
  List<Object?> get props => [...super.props, isDefault];
}

class GroupSearch extends Equatable {
  final String type;

  const GroupSearch({
    required this.type,
  });

  factory GroupSearch.fromJson(Map<String, dynamic> json) {
    return GroupSearch(
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }

  @override
  List<Object?> get props => [type];
}

class GroupInfo extends Equatable {
  final int? id;
  final String? name;
  final String type;
  final bool? isDefault;

  const GroupInfo({
    this.id,
    this.name,
    required this.type,
    this.isDefault,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) {
    return GroupInfo(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String,
      isDefault: json['isDefault'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      'type': type,
      if (isDefault != null) 'isDefault': isDefault,
    };
  }

  @override
  List<Object?> get props => [id, name, type, isDefault];
}
