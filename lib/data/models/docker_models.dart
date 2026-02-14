import 'package:equatable/equatable.dart';

/// Docker status model
class DockerStatus extends Equatable {
  final bool isRunning;
  final String? version;
  final String? apiVersion;
  final String? os;
  final String? architecture;
  final int? containers;
  final int? containersRunning;
  final int? containersPaused;
  final int? containersStopped;
  final int? images;
  final String? storageDriver;
  final String? loggingDriver;
  final String? cgroupDriver;
  final String? cgroupVersion;
  final bool? liveRestoreEnabled;
  final bool? swarm;

  const DockerStatus({
    required this.isRunning,
    this.version,
    this.apiVersion,
    this.os,
    this.architecture,
    this.containers,
    this.containersRunning,
    this.containersPaused,
    this.containersStopped,
    this.images,
    this.storageDriver,
    this.loggingDriver,
    this.cgroupDriver,
    this.cgroupVersion,
    this.liveRestoreEnabled,
    this.swarm,
  });

  factory DockerStatus.fromJson(Map<String, dynamic> json) {
    return DockerStatus(
      isRunning: json['isRunning'] as bool? ?? false,
      version: json['version'] as String?,
      apiVersion: json['apiVersion'] as String?,
      os: json['os'] as String?,
      architecture: json['architecture'] as String?,
      containers: json['containers'] as int?,
      containersRunning: json['containersRunning'] as int?,
      containersPaused: json['containersPaused'] as int?,
      containersStopped: json['containersStopped'] as int?,
      images: json['images'] as int?,
      storageDriver: json['storageDriver'] as String?,
      loggingDriver: json['loggingDriver'] as String?,
      cgroupDriver: json['cgroupDriver'] as String?,
      cgroupVersion: json['cgroupVersion'] as String?,
      liveRestoreEnabled: json['liveRestoreEnabled'] as bool?,
      swarm: json['swarm'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRunning': isRunning,
      'version': version,
      'apiVersion': apiVersion,
      'os': os,
      'architecture': architecture,
      'containers': containers,
      'containersRunning': containersRunning,
      'containersPaused': containersPaused,
      'containersStopped': containersStopped,
      'images': images,
      'storageDriver': storageDriver,
      'loggingDriver': loggingDriver,
      'cgroupDriver': cgroupDriver,
      'cgroupVersion': cgroupVersion,
      'liveRestoreEnabled': liveRestoreEnabled,
      'swarm': swarm,
    };
  }

  @override
  List<Object?> get props => [
        isRunning,
        version,
        apiVersion,
        os,
        architecture,
        containers,
        containersRunning,
        containersPaused,
        containersStopped,
        images,
        storageDriver,
        loggingDriver,
        cgroupDriver,
        cgroupVersion,
        liveRestoreEnabled,
        swarm,
      ];
}

/// Docker configuration model
class DockerConfig extends Equatable {
  final String? registryMirrors;
  final String? insecureRegistries;
  final String? dns;
  final String? logDriver;
  final String? logOpts;
  final String? storageDriver;
  final String? execOpts;
  final bool? liveRestore;
  final String? dataRoot;

  const DockerConfig({
    this.registryMirrors,
    this.insecureRegistries,
    this.dns,
    this.logDriver,
    this.logOpts,
    this.storageDriver,
    this.execOpts,
    this.liveRestore,
    this.dataRoot,
  });

  factory DockerConfig.fromJson(Map<String, dynamic> json) {
    return DockerConfig(
      registryMirrors: json['registryMirrors'] as String?,
      insecureRegistries: json['insecureRegistries'] as String?,
      dns: json['dns'] as String?,
      logDriver: json['logDriver'] as String?,
      logOpts: json['logOpts'] as String?,
      storageDriver: json['storageDriver'] as String?,
      execOpts: json['execOpts'] as String?,
      liveRestore: json['liveRestore'] as bool?,
      dataRoot: json['dataRoot'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registryMirrors': registryMirrors,
      'insecureRegistries': insecureRegistries,
      'dns': dns,
      'logDriver': logDriver,
      'logOpts': logOpts,
      'storageDriver': storageDriver,
      'execOpts': execOpts,
      'liveRestore': liveRestore,
      'dataRoot': dataRoot,
    };
  }

  @override
  List<Object?> get props => [
        registryMirrors,
        insecureRegistries,
        dns,
        logDriver,
        logOpts,
        storageDriver,
        execOpts,
        liveRestore,
        dataRoot,
      ];
}

/// Docker operation request model
class DockerOperation extends Equatable {
  final String operation;
  final Map<String, dynamic>? options;

  const DockerOperation({
    required this.operation,
    this.options,
  });

  factory DockerOperation.fromJson(Map<String, dynamic> json) {
    return DockerOperation(
      operation: json['operation'] as String,
      options: json['options'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'options': options,
    };
  }

  @override
  List<Object?> get props => [operation, options];
}
