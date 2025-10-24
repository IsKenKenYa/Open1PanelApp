/// 1Panel V2 API - 通用数据模型
///
/// 此文件包含多个API模块共享的通用数据模型。

import 'package:equatable/equatable.dart';

/// 通过ID操作模型
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

/// 通过类型操作模型
class OperateByType extends Equatable {
  final int? id;
  final String name;
  final String type;

  const OperateByType({
    this.id,
    required this.name,
    required this.type,
  });

  factory OperateByType.fromJson(Map<String, dynamic> json) {
    return OperateByType(
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

/// 分页请求模型
class PageRequest extends Equatable {
  final int page;
  final int pageSize;

  const PageRequest({
    this.page = 1,
    this.pageSize = 20,
  });

  factory PageRequest.fromJson(Map<String, dynamic> json) {
    return PageRequest(
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
    };
  }

  @override
  List<Object?> get props => [page, pageSize];
}

/// 分页结果模型
class PageResult<T> extends Equatable {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const PageResult({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
    this.totalPages = 1,
  });

  factory PageResult.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PageResult(
      items: (json['items'] as List?)
          ?.map((item) => fromJsonT(item))
          .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [items, total, page, pageSize, totalPages];
}

/// 通用搜索模型
class SearchRequest extends PageRequest {
  final String? info;

  const SearchRequest({
    this.info,
    super.page,
    super.pageSize,
  });

  factory SearchRequest.fromJson(Map<String, dynamic> json) {
    return SearchRequest(
      info: json['info'] as String?,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    if (info != null) json['info'] = info;
    return json;
  }

  @override
  List<Object?> get props => [...super.props, info];
}

/// 通用响应模型
class CommonResponse<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;
  final String? code;
  final int? timestamp;

  const CommonResponse({
    required this.success,
    required this.message,
    this.data,
    this.code,
    this.timestamp,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return CommonResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      code: json['code'] as String?,
      timestamp: json['timestamp'] as int?,
    );
  }

  @override
  List<Object?> get props => [success, message, data, code, timestamp];
}

/// 状态枚举
class Status {
  static const String enabled = 'Enabled';
  static const String disabled = 'Disabled';
  static const String running = 'Running';
  static const String stopped = 'Stopped';
  static const String error = 'Error';
  static const String pending = 'Pending';
  static const String creating = 'Creating';
  static const String deleting = 'Deleting';
  static const String updating = 'Updating';
}

/// 排序方向枚举
enum SortDirection {
  asc('asc', '升序'),
  desc('desc', '降序');

  const SortDirection(this.value, this.displayName);

  final String value;
  final String displayName;

  static SortDirection fromString(String value) {
    return SortDirection.values.firstWhere(
      (direction) => direction.value == value,
      orElse: () => SortDirection.desc,
    );
  }
}