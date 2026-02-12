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

class OllamaModel {
  final String? name;
  final String? size;
  final String? modified;

  OllamaModel({
    this.name,
    this.size,
    this.modified,
  });

  factory OllamaModel.fromJson(Map<String, dynamic> json) {
    return OllamaModel(
      name: json['name'],
      size: json['size'],
      modified: json['modified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (size != null) 'size': size,
      if (modified != null) 'modified': modified,
    };
  }
}

class OllamaModelDropList {
  final String? label;
  final String? value;

  OllamaModelDropList({
    this.label,
    this.value,
  });

  factory OllamaModelDropList.fromJson(Map<String, dynamic> json) {
    return OllamaModelDropList(
      label: json['label'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (label != null) 'label': label,
      if (value != null) 'value': value,
    };
  }
}
