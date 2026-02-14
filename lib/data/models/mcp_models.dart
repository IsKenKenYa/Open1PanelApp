/// MCP服务器环境变量
class McpEnvironment {
  final String? key;
  final String? value;

  const McpEnvironment({
    this.key,
    this.value,
  });

  factory McpEnvironment.fromJson(Map<String, dynamic> json) {
    return McpEnvironment(
      key: json['key'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}

/// MCP服务器卷挂载
class McpVolume {
  final String? source;
  final String? target;

  const McpVolume({
    this.source,
    this.target,
  });

  factory McpVolume.fromJson(Map<String, dynamic> json) {
    return McpVolume(
      source: json['source'] as String?,
      target: json['target'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'target': target,
    };
  }
}

/// MCP绑定域名请求
class McpBindDomain {
  final String domain;
  final String? ipList;
  final int? sslID;

  const McpBindDomain({
    required this.domain,
    this.ipList,
    this.sslID,
  });

  factory McpBindDomain.fromJson(Map<String, dynamic> json) {
    return McpBindDomain(
      domain: json['domain'] as String,
      ipList: json['ipList'] as String?,
      sslID: json['sslID'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'ipList': ipList,
      'sslID': sslID,
    };
  }
}

/// MCP绑定域名更新请求
class McpBindDomainUpdate {
  final String? ipList;
  final int? sslID;
  final int websiteID;

  const McpBindDomainUpdate({
    this.ipList,
    this.sslID,
    required this.websiteID,
  });

  factory McpBindDomainUpdate.fromJson(Map<String, dynamic> json) {
    return McpBindDomainUpdate(
      ipList: json['ipList'] as String?,
      sslID: json['sslID'] as int?,
      websiteID: json['websiteID'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ipList': ipList,
      'sslID': sslID,
      'websiteID': websiteID,
    };
  }
}

/// MCP服务器创建请求
class McpServerCreate {
  final String? baseUrl;
  final String command;
  final String? containerName;
  final List<McpEnvironment>? environments;
  final String? hostIP;
  final String name;
  final String outputTransport;
  final int port;
  final String? ssePath;
  final String? streamableHttpPath;
  final String type;
  final List<McpVolume>? volumes;

  const McpServerCreate({
    this.baseUrl,
    required this.command,
    this.containerName,
    this.environments,
    this.hostIP,
    required this.name,
    required this.outputTransport,
    required this.port,
    this.ssePath,
    this.streamableHttpPath,
    required this.type,
    this.volumes,
  });

  factory McpServerCreate.fromJson(Map<String, dynamic> json) {
    return McpServerCreate(
      baseUrl: json['baseUrl'] as String?,
      command: json['command'] as String,
      containerName: json['containerName'] as String?,
      environments: (json['environments'] as List<dynamic>?)
          ?.map((e) => McpEnvironment.fromJson(e as Map<String, dynamic>))
          .toList(),
      hostIP: json['hostIP'] as String?,
      name: json['name'] as String,
      outputTransport: json['outputTransport'] as String,
      port: json['port'] as int,
      ssePath: json['ssePath'] as String?,
      streamableHttpPath: json['streamableHttpPath'] as String?,
      type: json['type'] as String,
      volumes: (json['volumes'] as List<dynamic>?)
          ?.map((e) => McpVolume.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'command': command,
      'containerName': containerName,
      'environments': environments?.map((e) => e.toJson()).toList(),
      'hostIP': hostIP,
      'name': name,
      'outputTransport': outputTransport,
      'port': port,
      'ssePath': ssePath,
      'streamableHttpPath': streamableHttpPath,
      'type': type,
      'volumes': volumes?.map((e) => e.toJson()).toList(),
    };
  }
}

/// MCP服务器删除请求
class McpServerDelete {
  final int id;

  const McpServerDelete({
    required this.id,
  });

  factory McpServerDelete.fromJson(Map<String, dynamic> json) {
    return McpServerDelete(
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

/// MCP服务器操作请求
class McpServerOperate {
  final int id;
  final String operate;

  const McpServerOperate({
    required this.id,
    required this.operate,
  });

  factory McpServerOperate.fromJson(Map<String, dynamic> json) {
    return McpServerOperate(
      id: json['id'] as int,
      operate: json['operate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operate': operate,
    };
  }
}

/// MCP服务器搜索请求
class McpServerSearch {
  final String? name;
  final int page;
  final int pageSize;
  final bool? sync;

  const McpServerSearch({
    this.name,
    required this.page,
    required this.pageSize,
    this.sync,
  });

  factory McpServerSearch.fromJson(Map<String, dynamic> json) {
    return McpServerSearch(
      name: json['name'] as String?,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      sync: json['sync'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'sync': sync,
    };
  }
}

/// MCP服务器更新请求
class McpServerUpdate {
  final String? baseUrl;
  final String? command;
  final String? containerName;
  final List<McpEnvironment>? environments;
  final String? hostIP;
  final int? id;
  final String? name;
  final String? outputTransport;
  final int? port;
  final String? ssePath;
  final String? streamableHttpPath;
  final String? type;
  final List<McpVolume>? volumes;

  const McpServerUpdate({
    this.baseUrl,
    this.command,
    this.containerName,
    this.environments,
    this.hostIP,
    this.id,
    this.name,
    this.outputTransport,
    this.port,
    this.ssePath,
    this.streamableHttpPath,
    this.type,
    this.volumes,
  });

  factory McpServerUpdate.fromJson(Map<String, dynamic> json) {
    return McpServerUpdate(
      baseUrl: json['baseUrl'] as String?,
      command: json['command'] as String?,
      containerName: json['containerName'] as String?,
      environments: (json['environments'] as List<dynamic>?)
          ?.map((e) => McpEnvironment.fromJson(e as Map<String, dynamic>))
          .toList(),
      hostIP: json['hostIP'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      outputTransport: json['outputTransport'] as String?,
      port: json['port'] as int?,
      ssePath: json['ssePath'] as String?,
      streamableHttpPath: json['streamableHttpPath'] as String?,
      type: json['type'] as String?,
      volumes: (json['volumes'] as List<dynamic>?)
          ?.map((e) => McpVolume.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'command': command,
      'containerName': containerName,
      'environments': environments?.map((e) => e.toJson()).toList(),
      'hostIP': hostIP,
      'id': id,
      'name': name,
      'outputTransport': outputTransport,
      'port': port,
      'ssePath': ssePath,
      'streamableHttpPath': streamableHttpPath,
      'type': type,
      'volumes': volumes?.map((e) => e.toJson()).toList(),
    };
  }
}

/// MCP绑定域名响应
class McpBindDomainRes {
  final int? acmeAccountID;
  final List<String>? allowIPs;
  final String? connUrl;
  final String? domain;
  final int? sslID;
  final int? websiteID;

  const McpBindDomainRes({
    this.acmeAccountID,
    this.allowIPs,
    this.connUrl,
    this.domain,
    this.sslID,
    this.websiteID,
  });

  factory McpBindDomainRes.fromJson(Map<String, dynamic> json) {
    return McpBindDomainRes(
      acmeAccountID: json['acmeAccountID'] as int?,
      allowIPs: (json['allowIPs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      connUrl: json['connUrl'] as String?,
      domain: json['domain'] as String?,
      sslID: json['sslID'] as int?,
      websiteID: json['websiteID'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acmeAccountID': acmeAccountID,
      'allowIPs': allowIPs,
      'connUrl': connUrl,
      'domain': domain,
      'sslID': sslID,
      'websiteID': websiteID,
    };
  }
}

/// MCP服务器DTO
class McpServerDTO {
  final String? baseUrl;
  final String? command;
  final String? containerName;
  final String? createdAt;
  final String? dir;
  final String? dockerCompose;
  final String? env;
  final List<McpEnvironment>? environments;
  final String? hostIP;
  final int? id;
  final String? message;
  final String? name;
  final String? outputTransport;
  final int? port;
  final String? ssePath;
  final String? status;
  final String? streamableHttpPath;
  final String? type;
  final String? updatedAt;
  final List<McpVolume>? volumes;
  final int? websiteID;

  const McpServerDTO({
    this.baseUrl,
    this.command,
    this.containerName,
    this.createdAt,
    this.dir,
    this.dockerCompose,
    this.env,
    this.environments,
    this.hostIP,
    this.id,
    this.message,
    this.name,
    this.outputTransport,
    this.port,
    this.ssePath,
    this.status,
    this.streamableHttpPath,
    this.type,
    this.updatedAt,
    this.volumes,
    this.websiteID,
  });

  factory McpServerDTO.fromJson(Map<String, dynamic> json) {
    return McpServerDTO(
      baseUrl: json['baseUrl'] as String?,
      command: json['command'] as String?,
      containerName: json['containerName'] as String?,
      createdAt: json['createdAt'] as String?,
      dir: json['dir'] as String?,
      dockerCompose: json['dockerCompose'] as String?,
      env: json['env'] as String?,
      environments: (json['environments'] as List<dynamic>?)
          ?.map((e) => McpEnvironment.fromJson(e as Map<String, dynamic>))
          .toList(),
      hostIP: json['hostIP'] as String?,
      id: json['id'] as int?,
      message: json['message'] as String?,
      name: json['name'] as String?,
      outputTransport: json['outputTransport'] as String?,
      port: json['port'] as int?,
      ssePath: json['ssePath'] as String?,
      status: json['status'] as String?,
      streamableHttpPath: json['streamableHttpPath'] as String?,
      type: json['type'] as String?,
      updatedAt: json['updatedAt'] as String?,
      volumes: (json['volumes'] as List<dynamic>?)
          ?.map((e) => McpVolume.fromJson(e as Map<String, dynamic>))
          .toList(),
      websiteID: json['websiteID'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'command': command,
      'containerName': containerName,
      'createdAt': createdAt,
      'dir': dir,
      'dockerCompose': dockerCompose,
      'env': env,
      'environments': environments?.map((e) => e.toJson()).toList(),
      'hostIP': hostIP,
      'id': id,
      'message': message,
      'name': name,
      'outputTransport': outputTransport,
      'port': port,
      'ssePath': ssePath,
      'status': status,
      'streamableHttpPath': streamableHttpPath,
      'type': type,
      'updatedAt': updatedAt,
      'volumes': volumes?.map((e) => e.toJson()).toList(),
      'websiteID': websiteID,
    };
  }
}

/// MCP服务器列表响应
class McpServersRes {
  final List<McpServerDTO>? items;
  final int? total;

  const McpServersRes({
    this.items,
    this.total,
  });

  factory McpServersRes.fromJson(Map<String, dynamic> json) {
    return McpServersRes(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => McpServerDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }
}
