/// Process management data models for 1Panel V2 API
///
/// This file contains all data models related to process management,
/// including process monitoring, process control, etc.

import 'package:equatable/equatable.dart';

/// Process status enumeration
enum ProcessStatus {
  running('running'),
  sleeping('sleeping'),
  stopped('stopped'),
  zombie('zombie'),
  dead('dead');

  const ProcessStatus(this.value);
  final String value;

  static ProcessStatus fromString(String value) {
    return ProcessStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ProcessStatus.stopped,
    );
  }
}

/// Process information model
class ProcessInfo extends Equatable {
  final int? pid;
  final String? name;
  final String? command;
  final String? user;
  final int? cpuUsage;
  final int? memoryUsage;
  final ProcessStatus? status;
  final String? startTime;
  final String? path;
  final int? parentId;
  final List<int>? children;

  const ProcessInfo({
    this.pid,
    this.name,
    this.command,
    this.user,
    this.cpuUsage,
    this.memoryUsage,
    this.status,
    this.startTime,
    this.path,
    this.parentId,
    this.children,
  });

  factory ProcessInfo.fromJson(Map<String, dynamic> json) {
    return ProcessInfo(
      pid: json['pid'] as int?,
      name: json['name'] as String?,
      command: json['command'] as String?,
      user: json['user'] as String?,
      cpuUsage: json['cpuUsage'] as int?,
      memoryUsage: json['memoryUsage'] as int?,
      status: json['status'] != null ? ProcessStatus.fromString(json['status'] as String) : null,
      startTime: json['startTime'] as String?,
      path: json['path'] as String?,
      parentId: json['parentId'] as int?,
      children: (json['children'] as List?)?.map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'name': name,
      'command': command,
      'user': user,
      'cpuUsage': cpuUsage,
      'memoryUsage': memoryUsage,
      'status': status?.value,
      'startTime': startTime,
      'path': path,
      'parentId': parentId,
      'children': children,
    };
  }

  @override
  List<Object?> get props => [pid, name, command, user, cpuUsage, memoryUsage, status, startTime, path, parentId, children];
}

/// Process search request model
class ProcessSearch extends Equatable {
  final int? page;
  final int? pageSize;
  final String? search;
  final String? user;
  final ProcessStatus? status;
  final String? sortBy;
  final String? sortOrder;

  const ProcessSearch({
    this.page,
    this.pageSize,
    this.search,
    this.user,
    this.status,
    this.sortBy,
    this.sortOrder,
  });

  factory ProcessSearch.fromJson(Map<String, dynamic> json) {
    return ProcessSearch(
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
      search: json['search'] as String?,
      user: json['user'] as String?,
      status: json['status'] != null ? ProcessStatus.fromString(json['status'] as String) : null,
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'search': search,
      'user': user,
      'status': status?.value,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }

  @override
  List<Object?> get props => [page, pageSize, search, user, status, sortBy, sortOrder];
}

/// Process operation model
class ProcessOperation extends Equatable {
  final List<int> pids;
  final String operation;

  const ProcessOperation({
    required this.pids,
    required this.operation,
  });

  factory ProcessOperation.fromJson(Map<String, dynamic> json) {
    return ProcessOperation(
      pids: (json['pids'] as List?)?.map((e) => e as int).toList() ?? [],
      operation: json['operation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pids': pids,
      'operation': operation,
    };
  }

  @override
  List<Object?> get props => [pids, operation];
}

/// Process monitoring statistics model
class ProcessStats extends Equatable {
  final int? totalProcesses;
  final int? runningProcesses;
  final int? sleepingProcesses;
  final int? stoppedProcesses;
  final int? zombieProcesses;
  final double? totalCpuUsage;
  final int? totalMemoryUsage;

  const ProcessStats({
    this.totalProcesses,
    this.runningProcesses,
    this.sleepingProcesses,
    this.stoppedProcesses,
    this.zombieProcesses,
    this.totalCpuUsage,
    this.totalMemoryUsage,
  });

  factory ProcessStats.fromJson(Map<String, dynamic> json) {
    return ProcessStats(
      totalProcesses: json['totalProcesses'] as int?,
      runningProcesses: json['runningProcesses'] as int?,
      sleepingProcesses: json['sleepingProcesses'] as int?,
      stoppedProcesses: json['stoppedProcesses'] as int?,
      zombieProcesses: json['zombieProcesses'] as int?,
      totalCpuUsage: (json['totalCpuUsage'] as num?)?.toDouble(),
      totalMemoryUsage: json['totalMemoryUsage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalProcesses': totalProcesses,
      'runningProcesses': runningProcesses,
      'sleepingProcesses': sleepingProcesses,
      'stoppedProcesses': stoppedProcesses,
      'zombieProcesses': zombieProcesses,
      'totalCpuUsage': totalCpuUsage,
      'totalMemoryUsage': totalMemoryUsage,
    };
  }

  @override
  List<Object?> get props => [totalProcesses, runningProcesses, sleepingProcesses, stoppedProcesses, zombieProcesses, totalCpuUsage, totalMemoryUsage];
}

/// Process tree node model
class ProcessTreeNode extends Equatable {
  final ProcessInfo? process;
  final List<ProcessTreeNode>? children;

  const ProcessTreeNode({
    this.process,
    this.children,
  });

  factory ProcessTreeNode.fromJson(Map<String, dynamic> json) {
    return ProcessTreeNode(
      process: json['process'] != null ? ProcessInfo.fromJson(json['process'] as Map<String, dynamic>) : null,
      children: (json['children'] as List?)
          ?.map((item) => ProcessTreeNode.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'process': process?.toJson(),
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [process, children];
}