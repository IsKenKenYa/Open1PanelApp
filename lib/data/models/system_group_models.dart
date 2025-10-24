/// 1Panel V2 API - System Group 相关数据模型
///
/// 此文件包含系统组管理相关的所有数据模型，
/// 包括组的创建、更新、查询等操作的数据结构。

import 'package:equatable/equatable.dart';

/// 创建组请求模型
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

/// 更新组请求模型
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

/// 搜索组请求模型
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

/// 按ID操作请求模型
class OperateByID extends Equatable {
  final int id;

  const OperateByID({
    required this.id,
  });

  factory OperateByID.fromJson(Map<String, dynamic> json) {
    return OperateByID(
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  @override
  List<Object?> get props => [id];
}

/// 按类型操作响应模型
class OperateByType extends Equatable {
  final String type;

  const OperateByType({
    required this.type,
  });

  factory OperateByType.fromJson(Map<String, dynamic> json) {
    return OperateByType(
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

/// 组信息模型
class GroupInfo extends OperateByType {
  final int? id;
  final String? name;
  final bool? isDefault;

  const GroupInfo({
    this.id,
    this.name,
    required super.type,
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

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    if (id != null) json['id'] = id;
    if (name != null) json['name'] = name;
    if (isDefault != null) json['isDefault'] = isDefault;
    return json;
  }

  @override
  List<Object?> get props => [id, name, type, isDefault];
}