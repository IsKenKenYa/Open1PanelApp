import 'package:equatable/equatable.dart';

/// Firewall rule model
class FirewallRule extends Equatable {
  final int? id;
  final String? name;
  final String? type;
  final String? source;
  final String? target;
  final String? action;
  final String? protocol;
  final int? port;
  final String? portRange;
  final bool? enabled;
  final String? description;
  final String? createTime;
  final String? updateTime;

  const FirewallRule({
    this.id,
    this.name,
    this.type,
    this.source,
    this.target,
    this.action,
    this.protocol,
    this.port,
    this.portRange,
    this.enabled,
    this.description,
    this.createTime,
    this.updateTime,
  });

  factory FirewallRule.fromJson(Map<String, dynamic> json) {
    return FirewallRule(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      source: json['source'] as String?,
      target: json['target'] as String?,
      action: json['action'] as String?,
      protocol: json['protocol'] as String?,
      port: json['port'] as int?,
      portRange: json['portRange'] as String?,
      enabled: json['enabled'] as bool?,
      description: json['description'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'source': source,
      'target': target,
      'action': action,
      'protocol': protocol,
      'port': port,
      'portRange': portRange,
      'enabled': enabled,
      'description': description,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  @override
  List<Object?> get props => [id, name, type, source, target, action, protocol, port, portRange, enabled, description, createTime, updateTime];
}

/// Firewall rule creation model
class FirewallRuleCreate extends Equatable {
  final String name;
  final String type;
  final String source;
  final String? target;
  final String action;
  final String? protocol;
  final int? port;
  final String? portRange;
  final bool? enabled;
  final String? description;

  const FirewallRuleCreate({
    required this.name,
    required this.type,
    required this.source,
    this.target,
    required this.action,
    this.protocol,
    this.port,
    this.portRange,
    this.enabled,
    this.description,
  });

  factory FirewallRuleCreate.fromJson(Map<String, dynamic> json) {
    return FirewallRuleCreate(
      name: json['name'] as String,
      type: json['type'] as String,
      source: json['source'] as String,
      target: json['target'] as String?,
      action: json['action'] as String,
      protocol: json['protocol'] as String?,
      port: json['port'] as int?,
      portRange: json['portRange'] as String?,
      enabled: json['enabled'] as bool?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'source': source,
      'target': target,
      'action': action,
      'protocol': protocol,
      'port': port,
      'portRange': portRange,
      'enabled': enabled,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [name, type, source, target, action, protocol, port, portRange, enabled, description];
}

/// Firewall rule update model
class FirewallRuleUpdate extends Equatable {
  final int id;
  final String? name;
  final String? type;
  final String? source;
  final String? target;
  final String? action;
  final String? protocol;
  final int? port;
  final String? portRange;
  final bool? enabled;
  final String? description;

  const FirewallRuleUpdate({
    required this.id,
    this.name,
    this.type,
    this.source,
    this.target,
    this.action,
    this.protocol,
    this.port,
    this.portRange,
    this.enabled,
    this.description,
  });

  factory FirewallRuleUpdate.fromJson(Map<String, dynamic> json) {
    return FirewallRuleUpdate(
      id: json['id'] as int,
      name: json['name'] as String?,
      type: json['type'] as String?,
      source: json['source'] as String?,
      target: json['target'] as String?,
      action: json['action'] as String?,
      protocol: json['protocol'] as String?,
      port: json['port'] as int?,
      portRange: json['portRange'] as String?,
      enabled: json['enabled'] as bool?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'source': source,
      'target': target,
      'action': action,
      'protocol': protocol,
      'port': port,
      'portRange': portRange,
      'enabled': enabled,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, name, type, source, target, action, protocol, port, portRange, enabled, description];
}

/// Firewall rule search model
class FirewallRuleSearch extends Equatable {
  final int page;
  final int pageSize;
  final String? search;
  final String? type;
  final bool? enabled;

  const FirewallRuleSearch({
    required this.page,
    required this.pageSize,
    this.search,
    this.type,
    this.enabled,
  });

  factory FirewallRuleSearch.fromJson(Map<String, dynamic> json) {
    return FirewallRuleSearch(
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      search: json['search'] as String?,
      type: json['type'] as String?,
      enabled: json['enabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'search': search,
      'type': type,
      'enabled': enabled,
    };
  }

  @override
  List<Object?> get props => [page, pageSize, search, type, enabled];
}

/// Firewall port model
class FirewallPort extends Equatable {
  final int? id;
  final int? port;
  final String? protocol;
  final String? strategy;
  final String? source;
  final bool? enabled;
  final String? description;
  final String? createTime;

  const FirewallPort({
    this.id,
    this.port,
    this.protocol,
    this.strategy,
    this.source,
    this.enabled,
    this.description,
    this.createTime,
  });

  factory FirewallPort.fromJson(Map<String, dynamic> json) {
    return FirewallPort(
      id: json['id'] as int?,
      port: json['port'] as int?,
      protocol: json['protocol'] as String?,
      strategy: json['strategy'] as String?,
      source: json['source'] as String?,
      enabled: json['enabled'] as bool?,
      description: json['description'] as String?,
      createTime: json['createTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'port': port,
      'protocol': protocol,
      'strategy': strategy,
      'source': source,
      'enabled': enabled,
      'description': description,
      'createTime': createTime,
    };
  }

  @override
  List<Object?> get props => [id, port, protocol, strategy, source, enabled, description, createTime];
}

/// Firewall port creation model
class FirewallPortCreate extends Equatable {
  final int port;
  final String protocol;
  final String strategy;
  final String? source;
  final bool? enabled;
  final String? description;

  const FirewallPortCreate({
    required this.port,
    required this.protocol,
    required this.strategy,
    this.source,
    this.enabled,
    this.description,
  });

  factory FirewallPortCreate.fromJson(Map<String, dynamic> json) {
    return FirewallPortCreate(
      port: json['port'] as int,
      protocol: json['protocol'] as String,
      strategy: json['strategy'] as String,
      source: json['source'] as String?,
      enabled: json['enabled'] as bool?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'port': port,
      'protocol': protocol,
      'strategy': strategy,
      'source': source,
      'enabled': enabled,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [port, protocol, strategy, source, enabled, description];
}

/// Firewall port search model
class FirewallPortSearch extends Equatable {
  final int page;
  final int pageSize;
  final String? search;
  final String? protocol;
  final String? strategy;
  final bool? enabled;

  const FirewallPortSearch({
    required this.page,
    required this.pageSize,
    this.search,
    this.protocol,
    this.strategy,
    this.enabled,
  });

  factory FirewallPortSearch.fromJson(Map<String, dynamic> json) {
    return FirewallPortSearch(
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      search: json['search'] as String?,
      protocol: json['protocol'] as String?,
      strategy: json['strategy'] as String?,
      enabled: json['enabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'search': search,
      'protocol': protocol,
      'strategy': strategy,
      'enabled': enabled,
    };
  }

  @override
  List<Object?> get props => [page, pageSize, search, protocol, strategy, enabled];
}

/// Firewall status model
class FirewallStatus extends Equatable {
  final bool? enabled;
  final String? status;
  final String? version;
  final String? defaultPolicy;
  final int? activeRules;
  final int? activePorts;

  const FirewallStatus({
    this.enabled,
    this.status,
    this.version,
    this.defaultPolicy,
    this.activeRules,
    this.activePorts,
  });

  factory FirewallStatus.fromJson(Map<String, dynamic> json) {
    return FirewallStatus(
      enabled: json['enabled'] as bool?,
      status: json['status'] as String?,
      version: json['version'] as String?,
      defaultPolicy: json['defaultPolicy'] as String?,
      activeRules: json['activeRules'] as int?,
      activePorts: json['activePorts'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'status': status,
      'version': version,
      'defaultPolicy': defaultPolicy,
      'activeRules': activeRules,
      'activePorts': activePorts,
    };
  }

  @override
  List<Object?> get props => [enabled, status, version, defaultPolicy, activeRules, activePorts];
}

/// Firewall log model
class FirewallLog extends Equatable {
  final int? id;
  final String? timestamp;
  final String? action;
  final String? source;
  final String? destination;
  final String? protocol;
  final int? port;
  final String? interface;
  final String? reason;

  const FirewallLog({
    this.id,
    this.timestamp,
    this.action,
    this.source,
    this.destination,
    this.protocol,
    this.port,
    this.interface,
    this.reason,
  });

  factory FirewallLog.fromJson(Map<String, dynamic> json) {
    return FirewallLog(
      id: json['id'] as int?,
      timestamp: json['timestamp'] as String?,
      action: json['action'] as String?,
      source: json['source'] as String?,
      destination: json['destination'] as String?,
      protocol: json['protocol'] as String?,
      port: json['port'] as int?,
      interface: json['interface'] as String?,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp,
      'action': action,
      'source': source,
      'destination': destination,
      'protocol': protocol,
      'port': port,
      'interface': interface,
      'reason': reason,
    };
  }

  @override
  List<Object?> get props => [id, timestamp, action, source, destination, protocol, port, interface, reason];
}

/// Firewall log search model
class FirewallLogSearch extends Equatable {
  final int page;
  final int pageSize;
  final String? search;
  final String? action;
  final String? source;
  final String? protocol;
  final String? startTime;
  final String? endTime;

  const FirewallLogSearch({
    required this.page,
    required this.pageSize,
    this.search,
    this.action,
    this.source,
    this.protocol,
    this.startTime,
    this.endTime,
  });

  factory FirewallLogSearch.fromJson(Map<String, dynamic> json) {
    return FirewallLogSearch(
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      search: json['search'] as String?,
      action: json['action'] as String?,
      source: json['source'] as String?,
      protocol: json['protocol'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'search': search,
      'action': action,
      'source': source,
      'protocol': protocol,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  @override
  List<Object?> get props => [page, pageSize, search, action, source, protocol, startTime, endTime];
}
