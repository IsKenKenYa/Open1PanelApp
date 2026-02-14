import 'package:equatable/equatable.dart';

/// OpenResty status model
class OpenrestyStatus extends Equatable {
  final bool isRunning;
  final String? version;
  final String? nginxVersion;
  final int? workerProcesses;
  final int? activeConnections;
  final int? accepts;
  final int? handled;
  final int? requests;
  final int? reading;
  final int? writing;
  final int? waiting;
  final String? configPath;
  final String? logPath;
  final String? errorLogPath;

  const OpenrestyStatus({
    required this.isRunning,
    this.version,
    this.nginxVersion,
    this.workerProcesses,
    this.activeConnections,
    this.accepts,
    this.handled,
    this.requests,
    this.reading,
    this.writing,
    this.waiting,
    this.configPath,
    this.logPath,
    this.errorLogPath,
  });

  factory OpenrestyStatus.fromJson(Map<String, dynamic> json) {
    return OpenrestyStatus(
      isRunning: json['isRunning'] as bool? ?? false,
      version: json['version'] as String?,
      nginxVersion: json['nginxVersion'] as String?,
      workerProcesses: json['workerProcesses'] as int?,
      activeConnections: json['activeConnections'] as int?,
      accepts: json['accepts'] as int?,
      handled: json['handled'] as int?,
      requests: json['requests'] as int?,
      reading: json['reading'] as int?,
      writing: json['writing'] as int?,
      waiting: json['waiting'] as int?,
      configPath: json['configPath'] as String?,
      logPath: json['logPath'] as String?,
      errorLogPath: json['errorLogPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRunning': isRunning,
      'version': version,
      'nginxVersion': nginxVersion,
      'workerProcesses': workerProcesses,
      'activeConnections': activeConnections,
      'accepts': accepts,
      'handled': handled,
      'requests': requests,
      'reading': reading,
      'writing': writing,
      'waiting': waiting,
      'configPath': configPath,
      'logPath': logPath,
      'errorLogPath': errorLogPath,
    };
  }

  @override
  List<Object?> get props => [
        isRunning,
        version,
        nginxVersion,
        workerProcesses,
        activeConnections,
        accepts,
        handled,
        requests,
        reading,
        writing,
        waiting,
        configPath,
        logPath,
        errorLogPath,
      ];
}

/// OpenResty configuration model
class OpenrestyConfig extends Equatable {
  final String? serverName;
  final int? listen;
  final bool? ssl;
  final int? sslListen;
  final String? certificate;
  final String? certificateKey;
  final String? root;
  final String? index;
  final List<String>? locations;
  final Map<String, dynamic>? upstreams;
  final bool? gzip;
  final Map<String, dynamic>? headers;

  const OpenrestyConfig({
    this.serverName,
    this.listen,
    this.ssl,
    this.sslListen,
    this.certificate,
    this.certificateKey,
    this.root,
    this.index,
    this.locations,
    this.upstreams,
    this.gzip,
    this.headers,
  });

  factory OpenrestyConfig.fromJson(Map<String, dynamic> json) {
    return OpenrestyConfig(
      serverName: json['serverName'] as String?,
      listen: json['listen'] as int?,
      ssl: json['ssl'] as bool?,
      sslListen: json['sslListen'] as int?,
      certificate: json['certificate'] as String?,
      certificateKey: json['certificateKey'] as String?,
      root: json['root'] as String?,
      index: json['index'] as String?,
      locations: (json['locations'] as List?)?.map((e) => e as String).toList(),
      upstreams: json['upstreams'] as Map<String, dynamic>?,
      gzip: json['gzip'] as bool?,
      headers: json['headers'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverName': serverName,
      'listen': listen,
      'ssl': ssl,
      'sslListen': sslListen,
      'certificate': certificate,
      'certificateKey': certificateKey,
      'root': root,
      'index': index,
      'locations': locations,
      'upstreams': upstreams,
      'gzip': gzip,
      'headers': headers,
    };
  }

  @override
  List<Object?> get props => [
        serverName,
        listen,
        ssl,
        sslListen,
        certificate,
        certificateKey,
        root,
        index,
        locations,
        upstreams,
        gzip,
        headers,
      ];
}

/// OpenResty operation request model
class OpenrestyOperation extends Equatable {
  final String operation;
  final Map<String, dynamic>? options;

  const OpenrestyOperation({
    required this.operation,
    this.options,
  });

  factory OpenrestyOperation.fromJson(Map<String, dynamic> json) {
    return OpenrestyOperation(
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

/// OpenResty log search model
class OpenrestyLogSearch extends Equatable {
  final String? domain;
  final String? startTime;
  final String? endTime;
  final int? page;
  final int? pageSize;
  final String? keyword;

  const OpenrestyLogSearch({
    this.domain,
    this.startTime,
    this.endTime,
    this.page,
    this.pageSize,
    this.keyword,
  });

  factory OpenrestyLogSearch.fromJson(Map<String, dynamic> json) {
    return OpenrestyLogSearch(
      domain: json['domain'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
      keyword: json['keyword'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'startTime': startTime,
      'endTime': endTime,
      'page': page,
      'pageSize': pageSize,
      'keyword': keyword,
    };
  }

  @override
  List<Object?> get props => [domain, startTime, endTime, page, pageSize, keyword];
}

/// OpenResty error log model
class OpenrestyErrorLog extends Equatable {
  final String? time;
  final String? level;
  final String? message;
  final String? client;
  final String? server;
  final String? request;

  const OpenrestyErrorLog({
    this.time,
    this.level,
    this.message,
    this.client,
    this.server,
    this.request,
  });

  factory OpenrestyErrorLog.fromJson(Map<String, dynamic> json) {
    return OpenrestyErrorLog(
      time: json['time'] as String?,
      level: json['level'] as String?,
      message: json['message'] as String?,
      client: json['client'] as String?,
      server: json['server'] as String?,
      request: json['request'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'level': level,
      'message': message,
      'client': client,
      'server': server,
      'request': request,
    };
  }

  @override
  List<Object?> get props => [time, level, message, client, server, request];
}

/// OpenResty access log model
class OpenrestyAccessLog extends Equatable {
  final String? time;
  final String? remoteAddr;
  final String? request;
  final int? status;
  final int? bodyBytesSent;
  final String? httpReferer;
  final String? httpUserAgent;
  final double? requestTime;

  const OpenrestyAccessLog({
    this.time,
    this.remoteAddr,
    this.request,
    this.status,
    this.bodyBytesSent,
    this.httpReferer,
    this.httpUserAgent,
    this.requestTime,
  });

  factory OpenrestyAccessLog.fromJson(Map<String, dynamic> json) {
    return OpenrestyAccessLog(
      time: json['time'] as String?,
      remoteAddr: json['remoteAddr'] as String?,
      request: json['request'] as String?,
      status: json['status'] as int?,
      bodyBytesSent: json['bodyBytesSent'] as int?,
      httpReferer: json['httpReferer'] as String?,
      httpUserAgent: json['httpUserAgent'] as String?,
      requestTime: json['requestTime'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'remoteAddr': remoteAddr,
      'request': request,
      'status': status,
      'bodyBytesSent': bodyBytesSent,
      'httpReferer': httpReferer,
      'httpUserAgent': httpUserAgent,
      'requestTime': requestTime,
    };
  }

  @override
  List<Object?> get props => [
        time,
        remoteAddr,
        request,
        status,
        bodyBytesSent,
        httpReferer,
        httpUserAgent,
        requestTime,
      ];
}
