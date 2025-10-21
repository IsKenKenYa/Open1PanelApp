/// 1Panel V2 API - AI 相关数据模型
/// 
/// 此文件包含与AI功能相关的所有数据模型定义，
/// 包括Ollama模型管理、GPU信息获取、域名绑定等操作的数据结构。

class OllamaBindDomain {
  final int appInstallID;
  final String domain;
  final String? ipList;
  final int? sslID;
  final int? websiteID;

  OllamaBindDomain({
    required this.appInstallID,
    required this.domain,
    this.ipList,
    this.sslID,
    this.websiteID,
  });

  factory OllamaBindDomain.fromJson(Map<String, dynamic> json) {
    return OllamaBindDomain(
      appInstallID: json['appInstallID'] ?? 0,
      domain: json['domain'] ?? '',
      ipList: json['ipList'],
      sslID: json['sslID'],
      websiteID: json['websiteID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appInstallID': appInstallID,
      'domain': domain,
      if (ipList != null) 'ipList': ipList,
      if (sslID != null) 'sslID': sslID,
      if (websiteID != null) 'websiteID': websiteID,
    };
  }
}

class OllamaBindDomainReq {
  final int appInstallID;

  OllamaBindDomainReq({
    required this.appInstallID,
  });

  factory OllamaBindDomainReq.fromJson(Map<String, dynamic> json) {
    return OllamaBindDomainReq(
      appInstallID: json['appInstallID'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appInstallID': appInstallID,
    };
  }
}

class OllamaBindDomainRes {
  final int? acmeAccountID;
  final List<String>? allowIPs;
  final String? connUrl;
  final String? domain;
  final int? sslID;
  final int? websiteID;

  OllamaBindDomainRes({
    this.acmeAccountID,
    this.allowIPs,
    this.connUrl,
    this.domain,
    this.sslID,
    this.websiteID,
  });

  factory OllamaBindDomainRes.fromJson(Map<String, dynamic> json) {
    return OllamaBindDomainRes(
      acmeAccountID: json['acmeAccountID'],
      allowIPs: json['allowIPs'] != null ? List<String>.from(json['allowIPs']) : null,
      connUrl: json['connUrl'],
      domain: json['domain'],
      sslID: json['sslID'],
      websiteID: json['websiteID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (acmeAccountID != null) 'acmeAccountID': acmeAccountID,
      if (allowIPs != null) 'allowIPs': allowIPs,
      if (connUrl != null) 'connUrl': connUrl,
      if (domain != null) 'domain': domain,
      if (sslID != null) 'sslID': sslID,
      if (websiteID != null) 'websiteID': websiteID,
    };
  }
}

class OllamaModelName {
  final String name;
  final String? taskID;

  OllamaModelName({
    required this.name,
    this.taskID,
  });

  factory OllamaModelName.fromJson(Map<String, dynamic> json) {
    return OllamaModelName(
      name: json['name'] ?? '',
      taskID: json['taskID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (taskID != null) 'taskID': taskID,
    };
  }
}

class GPUInfo {
  final String? fanSpeed;
  final String? gpuUtil;
  final int? index;
  final String? maxPowerLimit;
  final String? memTotal;
  final String? memUsed;
  final String? memoryUsage;
  final String? performanceState;
  final String? powerDraw;
  final String? powerUsage;
  final String? productName;
  final String? temperature;

  GPUInfo({
    this.fanSpeed,
    this.gpuUtil,
    this.index,
    this.maxPowerLimit,
    this.memTotal,
    this.memUsed,
    this.memoryUsage,
    this.performanceState,
    this.powerDraw,
    this.powerUsage,
    this.productName,
    this.temperature,
  });

  factory GPUInfo.fromJson(Map<String, dynamic> json) {
    return GPUInfo(
      fanSpeed: json['fanSpeed'],
      gpuUtil: json['gpuUtil'],
      index: json['index'],
      maxPowerLimit: json['maxPowerLimit'],
      memTotal: json['memTotal'],
      memUsed: json['memUsed'],
      memoryUsage: json['memoryUsage'],
      performanceState: json['performanceState'],
      powerDraw: json['powerDraw'],
      powerUsage: json['powerUsage'],
      productName: json['productName'],
      temperature: json['temperature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fanSpeed != null) 'fanSpeed': fanSpeed,
      if (gpuUtil != null) 'gpuUtil': gpuUtil,
      if (index != null) 'index': index,
      if (maxPowerLimit != null) 'maxPowerLimit': maxPowerLimit,
      if (memTotal != null) 'memTotal': memTotal,
      if (memUsed != null) 'memUsed': memUsed,
      if (memoryUsage != null) 'memoryUsage': memoryUsage,
      if (performanceState != null) 'performanceState': performanceState,
      if (powerDraw != null) 'powerDraw': powerDraw,
      if (powerUsage != null) 'powerUsage': powerUsage,
      if (productName != null) 'productName': productName,
      if (temperature != null) 'temperature': temperature,
    };
  }
}

class ForceDelete {
  final List<int> ids;
  final bool forceDelete;

  ForceDelete({
    required this.ids,
    this.forceDelete = false,
  });

  factory ForceDelete.fromJson(Map<String, dynamic> json) {
    return ForceDelete(
      ids: List<int>.from(json['ids'] ?? []),
      forceDelete: json['forceDelete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ids': ids,
      'forceDelete': forceDelete,
    };
  }
}

class SearchWithPage {
  final int page;
  final int pageSize;
  final String? info;

  SearchWithPage({
    required this.page,
    required this.pageSize,
    this.info,
  });

  factory SearchWithPage.fromJson(Map<String, dynamic> json) {
    return SearchWithPage(
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      info: json['info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      if (info != null) 'info': info,
    };
  }
}

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
      items: (json['items'] as List?)
              ?.map((i) => fromJsonT(i))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'items': items.map((i) => toJsonT(i)).toList(),
      'total': total,
    };
  }
}

class OllamaModelDropList {
  final int id;
  final String name;

  OllamaModelDropList({
    required this.id,
    required this.name,
  });

  factory OllamaModelDropList.fromJson(Map<String, dynamic> json) {
    return OllamaModelDropList(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class OllamaModel {
  final int id;
  final String name;
  final String model;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OllamaModel({
    required this.id,
    required this.name,
    required this.model,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OllamaModel.fromJson(Map<String, dynamic> json) {
    return OllamaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class GpuInfo {
  final String? fanSpeed;
  final String? gpuUtil;
  final int? index;
  final String? maxPowerLimit;
  final String? memTotal;
  final String? memUsed;
  final String? memoryUsage;
  final String? performanceState;
  final String? powerDraw;
  final String? powerUsage;
  final String? productName;
  final String? temperature;

  GpuInfo({
    this.fanSpeed,
    this.gpuUtil,
    this.index,
    this.maxPowerLimit,
    this.memTotal,
    this.memUsed,
    this.memoryUsage,
    this.performanceState,
    this.powerDraw,
    this.powerUsage,
    this.productName,
    this.temperature,
  });

  factory GpuInfo.fromJson(Map<String, dynamic> json) {
    return GpuInfo(
      fanSpeed: json['fanSpeed'],
      gpuUtil: json['gpuUtil'],
      index: json['index'],
      maxPowerLimit: json['maxPowerLimit'],
      memTotal: json['memTotal'],
      memUsed: json['memUsed'],
      memoryUsage: json['memoryUsage'],
      performanceState: json['performanceState'],
      powerDraw: json['powerDraw'],
      powerUsage: json['powerUsage'],
      productName: json['productName'],
      temperature: json['temperature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fanSpeed != null) 'fanSpeed': fanSpeed,
      if (gpuUtil != null) 'gpuUtil': gpuUtil,
      if (index != null) 'index': index,
      if (maxPowerLimit != null) 'maxPowerLimit': maxPowerLimit,
      if (memTotal != null) 'memTotal': memTotal,
      if (memUsed != null) 'memUsed': memUsed,
      if (memoryUsage != null) 'memoryUsage': memoryUsage,
      if (performanceState != null) 'performanceState': performanceState,
      if (powerDraw != null) 'powerDraw': powerDraw,
      if (powerUsage != null) 'powerUsage': powerUsage,
      if (productName != null) 'productName': productName,
      if (temperature != null) 'temperature': temperature,
    };
  }
}