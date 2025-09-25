/// 1Panel V2 API - 应用相关数据模型

import 'package:json_annotation/json_annotation.dart';

part 'app_models.g.dart';

/// 应用搜索请求模型
@JsonSerializable()
class AppSearchRequest {
  final int page;
  final int pageSize;
  final String? name;
  final bool? recommend;
  final String? resource;
  final bool? showCurrentArch;
  final List<String>? tags;
  final String? type;

  AppSearchRequest({
    required this.page,
    required this.pageSize,
    this.name,
    this.recommend,
    this.resource,
    this.showCurrentArch,
    this.tags,
    this.type,
  });

  factory AppSearchRequest.fromJson(Map<String, dynamic> json) => _$AppSearchRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AppSearchRequestToJson(this);
}

/// 应用搜索响应模型
@JsonSerializable()
class AppSearchResponse {
  final List<AppItem> items;
  final int total;

  AppSearchResponse({
    required this.items,
    required this.total,
  });

  factory AppSearchResponse.fromJson(Map<String, dynamic> json) => _$AppSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AppSearchResponseToJson(this);
}

/// 应用项模型
@JsonSerializable()
class AppItem {
  final String description;
  final String? github;
  final bool gpuSupport;
  final String icon;
  final int id;
  final bool installed;
  final String key;
  final int limit;
  final String name;
  final int recommend;
  final String resource;
  final String status;
  final List<TagDTO> tags;
  final String type;
  final List<String> versions;
  final String? website;

  AppItem({
    required this.description,
    this.github,
    required this.gpuSupport,
    required this.icon,
    required this.id,
    required this.installed,
    required this.key,
    required this.limit,
    required this.name,
    required this.recommend,
    required this.resource,
    required this.status,
    required this.tags,
    required this.type,
    required this.versions,
    this.website,
  });

  factory AppItem.fromJson(Map<String, dynamic> json) => _$AppItemFromJson(json);
  Map<String, dynamic> toJson() => _$AppItemToJson(this);
}

/// 标签DTO模型
@JsonSerializable()
class TagDTO {
  final int id;
  final String key;
  final String name;

  TagDTO({
    required this.id,
    required this.key,
    required this.name,
  });

  factory TagDTO.fromJson(Map<String, dynamic> json) => _$TagDTOFromJson(json);
  Map<String, dynamic> toJson() => _$TagDTOToJson(this);
}

/// 应用安装创建请求模型
@JsonSerializable()
class AppInstallCreateRequest {
  final bool? advanced;
  final bool? allowPort;
  final int appDetailId;
  final String? containerName;
  final double? cpuQuota;
  final String? dockerCompose;
  final bool? editCompose;
  final bool? gpuConfig;
  final bool? hostMode;
  final double? memoryLimit;
  final String? memoryUnit;
  final String name;
  final Map<String, dynamic>? params;
  final bool? pullImage;
  final Map<String, String>? services;
  final String? taskID;
  final String? type;
  final String? webUI;

  AppInstallCreateRequest({
    this.advanced,
    this.allowPort,
    required this.appDetailId,
    this.containerName,
    this.cpuQuota,
    this.dockerCompose,
    this.editCompose,
    this.gpuConfig,
    this.hostMode,
    this.memoryLimit,
    this.memoryUnit,
    required this.name,
    this.params,
    this.pullImage,
    this.services,
    this.taskID,
    this.type,
    this.webUI,
  });

  factory AppInstallCreateRequest.fromJson(Map<String, dynamic> json) => _$AppInstallCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AppInstallCreateRequestToJson(this);
}

/// 应用安装模型
@JsonSerializable()
class AppInstall {
  final App app;
  final int appDetailId;
  final int appId;
  final String? containerName;
  final String createdAt;
  final String? description;
  final String? dockerCompose;
  final String? env;
  final int? httpPort;
  final int? httpsPort;
  final int id;
  final String? message;
  final String name;
  final String? param;
  final String? serviceName;
  final String status;
  final String updatedAt;
  final String version;
  final String? webUI;

  AppInstall({
    required this.app,
    required this.appDetailId,
    required this.appId,
    this.containerName,
    required this.createdAt,
    this.description,
    this.dockerCompose,
    this.env,
    this.httpPort,
    this.httpsPort,
    required this.id,
    this.message,
    required this.name,
    this.param,
    this.serviceName,
    required this.status,
    required this.updatedAt,
    required this.version,
    this.webUI,
  });

  factory AppInstall.fromJson(Map<String, dynamic> json) => _$AppInstallFromJson(json);
  Map<String, dynamic> toJson() => _$AppInstallToJson(this);
}

/// 应用模型
@JsonSerializable()
class App {
  final String architectures;
  final String createdAt;
  final bool crossVersionUpdate;
  final String description;
  final String? document;
  final String? github;
  final bool gpuSupport;
  final String icon;
  final int id;
  final String key;
  final int lastModified;
  final int limit;
  final int memoryRequired;
  final String name;
  final String? readMe;
  final int recommend;
  final String required;
  final double requiredPanelVersion;
  final String resource;
  final String? shortDescEn;
  final String? shortDescZh;
  final String status;
  final List<String> tags;
  final String type;
  final String updatedAt;
  final String? website;

  App({
    required this.architectures,
    required this.createdAt,
    required this.crossVersionUpdate,
    required this.description,
    this.document,
    this.github,
    required this.gpuSupport,
    required this.icon,
    required this.id,
    required this.key,
    required this.lastModified,
    required this.limit,
    required this.memoryRequired,
    required this.name,
    this.readMe,
    required this.recommend,
    required this.required,
    required this.requiredPanelVersion,
    required this.resource,
    this.shortDescEn,
    this.shortDescZh,
    required this.status,
    required this.tags,
    required this.type,
    required this.updatedAt,
    this.website,
  });

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
  Map<String, dynamic> toJson() => _$AppToJson(this);
}

/// 应用安装信息请求模型
@JsonSerializable()
class AppInstalledInfoRequest {
  final String key;
  final String? name;

  AppInstalledInfoRequest({
    required this.key,
    this.name,
  });

  factory AppInstalledInfoRequest.fromJson(Map<String, dynamic> json) => _$AppInstalledInfoRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AppInstalledInfoRequestToJson(this);
}

/// 应用安装检查响应模型
@JsonSerializable()
class AppInstalledCheckResponse {
  final bool exist;
  final String? message;

  AppInstalledCheckResponse({
    required this.exist,
    this.message,
  });

  factory AppInstalledCheckResponse.fromJson(Map<String, dynamic> json) => _$AppInstalledCheckResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AppInstalledCheckResponseToJson(this);
}

/// 应用安装操作请求模型
@JsonSerializable()
class AppInstalledOperateRequest {
  final bool? backup;
  final int? backupId;
  final bool? deleteBackup;
  final bool? deleteDB;
  final bool? deleteImage;
  final int? detailId;
  final String? dockerCompose;
  final bool? forceDelete;
  final int installId;
  final String operate;
  final bool? pullImage;
  final String? taskID;

  AppInstalledOperateRequest({
    this.backup,
    this.backupId,
    this.deleteBackup,
    this.deleteDB,
    this.deleteImage,
    this.detailId,
    this.dockerCompose,
    this.forceDelete,
    required this.installId,
    required this.operate,
    this.pullImage,
    this.taskID,
  });

  factory AppInstalledOperateRequest.fromJson(Map<String, dynamic> json) => _$AppInstalledOperateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AppInstalledOperateRequestToJson(this);
}

/// 应用安装搜索请求模型
@JsonSerializable()
class AppInstalledSearchRequest {
  final bool? all;
  final String? name;
  final int page;
  final int pageSize;
  final bool? sync;
  final List<String>? tags;
  final String? type;
  final bool? unused;
  final bool? update;

  AppInstalledSearchRequest({
    this.all,
    this.name,
    required this.page,
    required this.pageSize,
    this.sync,
    this.tags,
    this.type,
    this.unused,
    this.update,
  });

  factory AppInstalledSearchRequest.fromJson(Map<String, dynamic> json) => _$AppInstalledSearchRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AppInstalledSearchRequestToJson(this);
}

/// 应用服务响应模型
@JsonSerializable()
class AppServiceResponse {
  final dynamic config;
  final String from;
  final String label;
  final String status;
  final String value;

  AppServiceResponse({
    required this.config,
    required this.from,
    required this.label,
    required this.status,
    required this.value,
  });

  factory AppServiceResponse.fromJson(Map<String, dynamic> json) => _$AppServiceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AppServiceResponseToJson(this);
}

/// 应用商店配置响应模型
@JsonSerializable()
class AppstoreConfigResponse {
  final String? defaultDomain;

  AppstoreConfigResponse({
    this.defaultDomain,
  });

  factory AppstoreConfigResponse.fromJson(Map<String, dynamic> json) => _$AppstoreConfigResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AppstoreConfigResponseToJson(this);
}

/// 应用商店更新请求模型
@JsonSerializable()
class AppstoreUpdateRequest {
  final String? defaultDomain;

  AppstoreUpdateRequest({
    this.defaultDomain,
  });

  factory AppstoreUpdateRequest.fromJson(Map<String, dynamic> json) => _$AppstoreUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AppstoreUpdateRequestToJson(this);
}

/// 分页结果模型
@JsonSerializable(
  genericArgumentFactories: true,
)
class PageResult<T> {
  final List<T> items;
  final int total;

  PageResult({
    required this.items,
    required this.total,
  });

  factory PageResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PageResult<T>(
      items: (json['items'] as List)
          .map((item) => fromJsonT(item))
          .toList(),
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'items': items.map(toJsonT).toList(),
      'total': total,
    };
  }
}