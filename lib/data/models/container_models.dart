/// 1Panel V2 API - Container 相关数据模型
///
/// 此文件包含容器管理相关的所有数据模型，
/// 包括容器的创建、更新、查询等操作的数据结构。

import 'package:equatable/equatable.dart';

/// 容器操作模型
class ContainerOperate extends Equatable {
  final bool? autoRemove;
  final List<String>? cmd;
  final String? containerID;
  final int? cpuShares;
  final List<String>? dns;
  final String? domainName;
  final List<String>? entrypoint;
  final List<String>? env;
  final List<PortHelper>? exposedPorts;
  final bool? forcePull;
  final String? hostname;
  final String image;
  final String? ipv4;
  final String? ipv6;
  final List<String>? labels;
  final String? macAddr;
  final int? memory;
  final String name;
  final int? nanoCPUs;
  final String? network;
  final bool? openStdin;
  final bool? privileged;
  final bool? publishAllPorts;
  final String? restartPolicy;
  final String? taskID;
  final bool? tty;
  final String? user;
  final List<VolumeHelper>? volumes;
  final String? workingDir;

  const ContainerOperate({
    this.autoRemove,
    this.cmd,
    this.containerID,
    this.cpuShares,
    this.dns,
    this.domainName,
    this.entrypoint,
    this.env,
    this.exposedPorts,
    this.forcePull,
    this.hostname,
    required this.image,
    this.ipv4,
    this.ipv6,
    this.labels,
    this.macAddr,
    this.memory,
    required this.name,
    this.nanoCPUs,
    this.network,
    this.openStdin,
    this.privileged,
    this.publishAllPorts,
    this.restartPolicy,
    this.taskID,
    this.tty,
    this.user,
    this.volumes,
    this.workingDir,
  });

  factory ContainerOperate.fromJson(Map<String, dynamic> json) {
    return ContainerOperate(
      autoRemove: json['autoRemove'] as bool?,
      cmd: (json['cmd'] as List?)?.cast<String>(),
      containerID: json['containerID'] as String?,
      cpuShares: json['cpuShares'] as int?,
      dns: (json['dns'] as List?)?.cast<String>(),
      domainName: json['domainName'] as String?,
      entrypoint: (json['entrypoint'] as List?)?.cast<String>(),
      env: (json['env'] as List?)?.cast<String>(),
      exposedPorts: (json['exposedPorts'] as List?)
          ?.map((item) => PortHelper.fromJson(item as Map<String, dynamic>))
          .toList(),
      forcePull: json['forcePull'] as bool?,
      hostname: json['hostname'] as String?,
      image: json['image'] as String,
      ipv4: json['ipv4'] as String?,
      ipv6: json['ipv6'] as String?,
      labels: (json['labels'] as List?)?.cast<String>(),
      macAddr: json['macAddr'] as String?,
      memory: json['memory'] as int?,
      name: json['name'] as String,
      nanoCPUs: json['nanoCPUs'] as int?,
      network: json['network'] as String?,
      openStdin: json['openStdin'] as bool?,
      privileged: json['privileged'] as bool?,
      publishAllPorts: json['publishAllPorts'] as bool?,
      restartPolicy: json['restartPolicy'] as String?,
      taskID: json['taskID'] as String?,
      tty: json['tty'] as bool?,
      user: json['user'] as String?,
      volumes: (json['volumes'] as List?)
          ?.map((item) => VolumeHelper.fromJson(item as Map<String, dynamic>))
          .toList(),
      workingDir: json['workingDir'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoRemove': autoRemove,
      'cmd': cmd,
      'containerID': containerID,
      'cpuShares': cpuShares,
      'dns': dns,
      'domainName': domainName,
      'entrypoint': entrypoint,
      'env': env,
      'exposedPorts': exposedPorts?.map((item) => item.toJson()).toList(),
      'forcePull': forcePull,
      'hostname': hostname,
      'image': image,
      'ipv4': ipv4,
      'ipv6': ipv6,
      'labels': labels,
      'macAddr': macAddr,
      'memory': memory,
      'name': name,
      'nanoCPUs': nanoCPUs,
      'network': network,
      'openStdin': openStdin,
      'privileged': privileged,
      'publishAllPorts': publishAllPorts,
      'restartPolicy': restartPolicy,
      'taskID': taskID,
      'tty': tty,
      'user': user,
      'volumes': volumes?.map((item) => item.toJson()).toList(),
      'workingDir': workingDir,
    };
  }

  @override
  List<Object?> get props => [
        autoRemove,
        cmd,
        containerID,
        cpuShares,
        dns,
        domainName,
        entrypoint,
        env,
        exposedPorts,
        forcePull,
        hostname,
        image,
        ipv4,
        ipv6,
        labels,
        macAddr,
        memory,
        name,
        nanoCPUs,
        network,
        openStdin,
        privileged,
        publishAllPorts,
        restartPolicy,
        taskID,
        tty,
        user,
        volumes,
        workingDir,
      ];
}

/// 容器批量操作模型
class ContainerOperation extends Equatable {
  final List<String> names;
  final String operation;

  const ContainerOperation({
    required this.names,
    required this.operation,
  });

  factory ContainerOperation.fromJson(Map<String, dynamic> json) {
    return ContainerOperation(
      names: (json['names'] as List?)?.cast<String>() ?? [],
      operation: json['operation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'names': names,
      'operation': operation,
    };
  }

  @override
  List<Object?> get props => [names, operation];
}

/// 容器统计信息模型
class ContainerStats extends Equatable {
  final int cache;
  final double cpuPercent;
  final int ioRead;
  final int ioWrite;
  final int memory;
  final int networkRX;
  final int networkTX;
  final String? shotTime;

  const ContainerStats({
    required this.cache,
    required this.cpuPercent,
    required this.ioRead,
    required this.ioWrite,
    required this.memory,
    required this.networkRX,
    required this.networkTX,
    this.shotTime,
  });

  factory ContainerStats.fromJson(Map<String, dynamic> json) {
    return ContainerStats(
      cache: json['cache'] as int? ?? 0,
      cpuPercent: (json['cpuPercent'] as num?)?.toDouble() ?? 0.0,
      ioRead: json['ioRead'] as int? ?? 0,
      ioWrite: json['ioWrite'] as int? ?? 0,
      memory: json['memory'] as int? ?? 0,
      networkRX: json['networkRX'] as int? ?? 0,
      networkTX: json['networkTX'] as int? ?? 0,
      shotTime: json['shotTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cache': cache,
      'cpuPercent': cpuPercent,
      'ioRead': ioRead,
      'ioWrite': ioWrite,
      'memory': memory,
      'networkRX': networkRX,
      'networkTX': networkTX,
      'shotTime': shotTime,
    };
  }

  @override
  List<Object?> get props => [
        cache,
        cpuPercent,
        ioRead,
        ioWrite,
        memory,
        networkRX,
        networkTX,
        shotTime,
      ];
}

/// 容器列表统计信息模型
class ContainerListStats extends Equatable {
  final String containerID;
  final double cpuPercent;
  final int cpuTotalUsage;
  final int memoryCache;
  final int memoryLimit;
  final double memoryPercent;
  final int memoryUsage;
  final int percpuUsage;
  final int systemUsage;

  const ContainerListStats({
    required this.containerID,
    required this.cpuPercent,
    required this.cpuTotalUsage,
    required this.memoryCache,
    required this.memoryLimit,
    required this.memoryPercent,
    required this.memoryUsage,
    required this.percpuUsage,
    required this.systemUsage,
  });

  factory ContainerListStats.fromJson(Map<String, dynamic> json) {
    return ContainerListStats(
      containerID: json['containerID'] as String,
      cpuPercent: (json['cpuPercent'] as num?)?.toDouble() ?? 0.0,
      cpuTotalUsage: json['cpuTotalUsage'] as int? ?? 0,
      memoryCache: json['memoryCache'] as int? ?? 0,
      memoryLimit: json['memoryLimit'] as int? ?? 0,
      memoryPercent: (json['memoryPercent'] as num?)?.toDouble() ?? 0.0,
      memoryUsage: json['memoryUsage'] as int? ?? 0,
      percpuUsage: json['percpuUsage'] as int? ?? 0,
      systemUsage: json['systemUsage'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'containerID': containerID,
      'cpuPercent': cpuPercent,
      'cpuTotalUsage': cpuTotalUsage,
      'memoryCache': memoryCache,
      'memoryLimit': memoryLimit,
      'memoryPercent': memoryPercent,
      'memoryUsage': memoryUsage,
      'percpuUsage': percpuUsage,
      'systemUsage': systemUsage,
    };
  }

  @override
  List<Object?> get props => [
        containerID,
        cpuPercent,
        cpuTotalUsage,
        memoryCache,
        memoryLimit,
        memoryPercent,
        memoryUsage,
        percpuUsage,
        systemUsage,
      ];
}

/// 容器状态统计模型
class ContainerStatus extends Equatable {
  final int all;
  final int composeCount;
  final int composeTemplateCount;
  final int containerCount;
  final int created;
  final int dead;
  final int exited;
  final int imageCount;
  final int imageSize;
  final int networkCount;
  final int paused;
  final int removing;
  final int repoCount;
  final int restarting;
  final int running;
  final int volumeCount;

  const ContainerStatus({
    required this.all,
    required this.composeCount,
    required this.composeTemplateCount,
    required this.containerCount,
    required this.created,
    required this.dead,
    required this.exited,
    required this.imageCount,
    required this.imageSize,
    required this.networkCount,
    required this.paused,
    required this.removing,
    required this.repoCount,
    required this.restarting,
    required this.running,
    required this.volumeCount,
  });

  factory ContainerStatus.fromJson(Map<String, dynamic> json) {
    return ContainerStatus(
      all: json['all'] as int? ?? 0,
      composeCount: json['composeCount'] as int? ?? 0,
      composeTemplateCount: json['composeTemplateCount'] as int? ?? 0,
      containerCount: json['containerCount'] as int? ?? 0,
      created: json['created'] as int? ?? 0,
      dead: json['dead'] as int? ?? 0,
      exited: json['exited'] as int? ?? 0,
      imageCount: json['imageCount'] as int? ?? 0,
      imageSize: json['imageSize'] as int? ?? 0,
      networkCount: json['networkCount'] as int? ?? 0,
      paused: json['paused'] as int? ?? 0,
      removing: json['removing'] as int? ?? 0,
      repoCount: json['repoCount'] as int? ?? 0,
      restarting: json['restarting'] as int? ?? 0,
      running: json['running'] as int? ?? 0,
      volumeCount: json['volumeCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'all': all,
      'composeCount': composeCount,
      'composeTemplateCount': composeTemplateCount,
      'containerCount': containerCount,
      'created': created,
      'dead': dead,
      'exited': exited,
      'imageCount': imageCount,
      'imageSize': imageSize,
      'networkCount': networkCount,
      'paused': paused,
      'removing': removing,
      'repoCount': repoCount,
      'restarting': restarting,
      'running': running,
      'volumeCount': volumeCount,
    };
  }

  @override
  List<Object?> get props => [
        all,
        composeCount,
        composeTemplateCount,
        containerCount,
        created,
        dead,
        exited,
        imageCount,
        imageSize,
        networkCount,
        paused,
        removing,
        repoCount,
        restarting,
        running,
        volumeCount,
      ];
}

/// 端口配置模型
class PortHelper extends Equatable {
  final String containerPort;
  final String? hostIP;
  final String? hostPort;
  final String protocol;

  const PortHelper({
    required this.containerPort,
    this.hostIP,
    this.hostPort,
    this.protocol = 'tcp',
  });

  factory PortHelper.fromJson(Map<String, dynamic> json) {
    return PortHelper(
      containerPort: json['containerPort'] as String,
      hostIP: json['hostIP'] as String?,
      hostPort: json['hostPort'] as String?,
      protocol: json['protocol'] as String? ?? 'tcp',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'containerPort': containerPort,
      'hostIP': hostIP,
      'hostPort': hostPort,
      'protocol': protocol,
    };
  }

  @override
  List<Object?> get props => [containerPort, hostIP, hostPort, protocol];
}

/// 卷配置模型
class VolumeHelper extends Equatable {
  final String containerDir;
  final String mode;
  final String sourceDir;
  final String type;

  const VolumeHelper({
    required this.containerDir,
    this.mode = 'rw',
    required this.sourceDir,
    this.type = 'bind',
  });

  factory VolumeHelper.fromJson(Map<String, dynamic> json) {
    return VolumeHelper(
      containerDir: json['containerDir'] as String,
      mode: json['mode'] as String? ?? 'rw',
      sourceDir: json['sourceDir'] as String,
      type: json['type'] as String? ?? 'bind',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'containerDir': containerDir,
      'mode': mode,
      'sourceDir': sourceDir,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [containerDir, mode, sourceDir, type];
}

/// 容器分页查询模型
class PageContainer extends Equatable {
  final bool? excludeAppStore;
  final String? filters;
  final String? name;
  final String? order;
  final String? orderBy;
  final int page;
  final int pageSize;
  final String? state;

  const PageContainer({
    this.excludeAppStore,
    this.filters,
    this.name,
    this.order,
    this.orderBy,
    required this.page,
    required this.pageSize,
    this.state,
  });

  factory PageContainer.fromJson(Map<String, dynamic> json) {
    return PageContainer(
      excludeAppStore: json['excludeAppStore'] as bool?,
      filters: json['filters'] as String?,
      name: json['name'] as String?,
      order: json['order'] as String?,
      orderBy: json['orderBy'] as String?,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      state: json['state'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'excludeAppStore': excludeAppStore,
      'filters': filters,
      'name': name,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
      'state': state,
    };
  }

  @override
  List<Object?> get props => [
        excludeAppStore,
        filters,
        name,
        order,
        orderBy,
        page,
        pageSize,
        state,
      ];
}

/// 容器信息模型
class ContainerInfo extends Equatable {
  final String id;
  final String name;
  final String image;
  final String status;
  final String state;
  final int? ports;
  final String? createTime;
  final String? ipAddress;
  final String? network;
  final String? cpuUsage;
  final String? memoryUsage;
  final List<String>? labels;
  final List<PortHelper>? portBindings;
  final List<VolumeHelper>? volumeBindings;

  const ContainerInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.state,
    this.ports,
    this.createTime,
    this.ipAddress,
    this.network,
    this.cpuUsage,
    this.memoryUsage,
    this.labels,
    this.portBindings,
    this.volumeBindings,
  });

  factory ContainerInfo.fromJson(Map<String, dynamic> json) {
    return ContainerInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      status: json['status'] as String,
      state: json['state'] as String,
      ports: json['ports'] as int?,
      createTime: json['createTime'] as String?,
      ipAddress: json['ipAddress'] as String?,
      network: json['network'] as String?,
      cpuUsage: json['cpuUsage'] as String?,
      memoryUsage: json['memoryUsage'] as String?,
      labels: (json['labels'] as List?)?.cast<String>(),
      portBindings: (json['portBindings'] as List?)
          ?.map((item) => PortHelper.fromJson(item as Map<String, dynamic>))
          .toList(),
      volumeBindings: (json['volumeBindings'] as List?)
          ?.map((item) => VolumeHelper.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'status': status,
      'state': state,
      'ports': ports,
      'createTime': createTime,
      'ipAddress': ipAddress,
      'network': network,
      'cpuUsage': cpuUsage,
      'memoryUsage': memoryUsage,
      'labels': labels,
      'portBindings': portBindings?.map((item) => item.toJson()).toList(),
      'volumeBindings': volumeBindings?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        status,
        state,
        ports,
        createTime,
        ipAddress,
        network,
        cpuUsage,
        memoryUsage,
        labels,
        portBindings,
        volumeBindings,
      ];
}

/// 容器提交模型
class ContainerCommit extends Equatable {
  final String? author;
  final String? comment;
  final String containerID;
  final String containerName;
  final String newImageName;
  final bool? pause;

  const ContainerCommit({
    this.author,
    this.comment,
    required this.containerID,
    required this.containerName,
    required this.newImageName,
    this.pause,
  });

  factory ContainerCommit.fromJson(Map<String, dynamic> json) {
    return ContainerCommit(
      author: json['author'] as String?,
      comment: json['comment'] as String?,
      containerID: json['containerID'] as String,
      containerName: json['containerName'] as String,
      newImageName: json['newImageName'] as String,
      pause: json['pause'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'comment': comment,
      'containerID': containerID,
      'containerName': containerName,
      'newImageName': newImageName,
      'pause': pause,
    };
  }

  @override
  List<Object?> get props => [author, comment, containerID, containerName, newImageName, pause];
}

/// 容器清理模型
class ContainerPrune extends Equatable {
  final String pruneType;
  final bool? withTagAll;

  const ContainerPrune({
    required this.pruneType,
    this.withTagAll,
  });

  factory ContainerPrune.fromJson(Map<String, dynamic> json) {
    return ContainerPrune(
      pruneType: json['pruneType'] as String,
      withTagAll: json['withTagAll'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pruneType': pruneType,
      'withTagAll': withTagAll,
    };
  }

  @override
  List<Object?> get props => [pruneType, withTagAll];
}

/// 容器升级模型
class ContainerUpgrade extends Equatable {
  final bool? forcePull;
  final String image;
  final String name;
  final String? taskID;

  const ContainerUpgrade({
    this.forcePull,
    required this.image,
    required this.name,
    this.taskID,
  });

  factory ContainerUpgrade.fromJson(Map<String, dynamic> json) {
    return ContainerUpgrade(
      forcePull: json['forcePull'] as bool?,
      image: json['image'] as String,
      name: json['name'] as String,
      taskID: json['taskID'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'forcePull': forcePull,
      'image': image,
      'name': name,
      'taskID': taskID,
    };
  }

  @override
  List<Object?> get props => [forcePull, image, name, taskID];
}

/// 容器重命名模型
class ContainerRename extends Equatable {
  final String name;
  final String newName;

  const ContainerRename({
    required this.name,
    required this.newName,
  });

  factory ContainerRename.fromJson(Map<String, dynamic> json) {
    return ContainerRename(
      name: json['name'] as String,
      newName: json['newName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'newName': newName,
    };
  }

  @override
  List<Object?> get props => [name, newName];
}

/// 容器操作类型枚举
enum ContainerOperationType {
  up('up', '启动'),
  start('start', '开始'),
  stop('stop', '停止'),
  restart('restart', '重启'),
  kill('kill', '强制停止'),
  pause('pause', '暂停'),
  unpause('unpause', '恢复'),
  remove('remove', '删除');

  const ContainerOperationType(this.value, this.displayName);

  final String value;
  final String displayName;

  static ContainerOperationType fromString(String value) {
    return ContainerOperationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ContainerOperationType.start,
    );
  }
}

/// 容器状态枚举
enum ContainerState {
  all('all', '全部'),
  created('created', '已创建'),
  running('running', '运行中'),
  paused('paused', '已暂停'),
  restarting('restarting', '重启中'),
  removing('removing', '删除中'),
  exited('exited', '已退出'),
  dead('dead', '死亡状态');

  const ContainerState(this.value, this.displayName);

  final String value;
  final String displayName;

  static ContainerState fromString(String value) {
    return ContainerState.values.firstWhere(
      (state) => state.value == value,
      orElse: () => ContainerState.all,
    );
  }
}

/// 容器清理类型枚举
enum ContainerPruneType {
  container('container', '容器'),
  image('image', '镜像'),
  volume('volume', '卷'),
  network('network', '网络'),
  buildcache('buildcache', '构建缓存');

  const ContainerPruneType(this.value, this.displayName);

  final String value;
  final String displayName;

  static ContainerPruneType fromString(String value) {
    return ContainerPruneType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ContainerPruneType.container,
    );
  }
}