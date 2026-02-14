class MockApiResponses {
  static Map<String, dynamic> success({dynamic data, String message = 'success'}) {
    return {
      'code': 200,
      'message': message,
      'data': data,
    };
  }

  static Map<String, dynamic> error({int code = 500, String message = 'error', dynamic data}) {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }

  static Map<String, dynamic> pageResult({
    required List<dynamic> items,
    int total = 0,
    int page = 1,
    int pageSize = 10,
  }) {
    return {
      'code': 200,
      'message': 'success',
      'data': {
        'items': items,
        'total': total,
        'page': page,
        'pageSize': pageSize,
      },
    };
  }
}

class MockDashboardResponses {
  static Map<String, dynamic> baseInfo() {
    return MockApiResponses.success(data: {
      'appName': '1Panel',
      'version': '2.0.0',
      'dockerVersion': '24.0.7',
      'goVersion': '1.21.5',
      'database': 'sqlite',
      'mode': 'production',
      'system': 'Ubuntu 22.04 LTS',
      'kernelVersion': '5.15.0-91-generic',
      'architecture': 'x86_64',
      'ip': '192.168.1.100',
      'currentVersion': 'v2.0.0',
      'latestVersion': 'v2.0.1',
      'isUpgrade': true,
    });
  }

  static Map<String, dynamic> currentInfo() {
    return MockApiResponses.success(data: {
      'cpuUsage': 25.5,
      'memUsage': 45.2,
      'diskUsage': 60.8,
      'ioUsage': 10.3,
      'netIn': 1024000,
      'netOut': 512000,
      'diskRead': 204800,
      'diskWrite': 102400,
      'uptime': 86400,
      'load1': 0.5,
      'load5': 0.8,
      'load15': 1.0,
    });
  }

  static Map<String, dynamic> systemStatus() {
    return MockApiResponses.success(data: {
      'isInitialized': true,
      'isInstalled': true,
      'hasLicense': false,
      'hasBackup': true,
    });
  }
}

class MockToolboxResponses {
  static Map<String, dynamic> deviceBaseInfo() {
    return MockApiResponses.success(data: {
      'hostname': 'test-server',
      'dns': '8.8.8.8',
      'ntp': 'ntp.ubuntu.com',
      'localTime': '2024-01-01T12:00:00Z',
      'timeZone': 'Asia/Shanghai',
      'productName': '1Panel',
      'productVersion': '2.0.0',
      'systemName': 'Ubuntu',
      'systemVersion': '22.04',
    });
  }

  static Map<String, dynamic> fail2banBaseInfo() {
    return MockApiResponses.success(data: {
      'isEnable': true,
      'version': '1.0.2',
      'port': '22',
      'maxretry': '5',
      'findtime': '600',
      'bantime': '3600',
    });
  }

  static Map<String, dynamic> ftpBaseInfo() {
    return MockApiResponses.success(data: {
      'status': 'running',
      'version': '1.3.8',
      'baseDir': '/var/ftp',
    });
  }

  static Map<String, dynamic> cleanData() {
    return MockApiResponses.success(data: [
      {'name': '系统缓存', 'size': '1.2GB', 'path': '/var/cache'},
      {'name': '日志文件', 'size': '500MB', 'path': '/var/log'},
      {'name': '临时文件', 'size': '200MB', 'path': '/tmp'},
    ]);
  }

  static Map<String, dynamic> cleanTree() {
    return MockApiResponses.success(data: [
      {
        'label': '系统清理',
        'value': 'system',
        'children': [
          {'label': '系统缓存', 'value': '/var/cache'},
          {'label': '日志文件', 'value': '/var/log'},
        ],
      },
      {
        'label': '应用清理',
        'value': 'app',
        'children': [
          {'label': 'Docker镜像', 'value': 'docker_images'},
          {'label': 'Docker容器', 'value': 'docker_containers'},
        ],
      },
    ]);
  }

  static Map<String, dynamic> deviceUsers() {
    return MockApiResponses.success(data: ['root', 'ubuntu', 'admin']);
  }

  static Map<String, dynamic> zoneOptions() {
    return MockApiResponses.success(data: [
      'Asia/Shanghai',
      'Asia/Tokyo',
      'America/New_York',
      'Europe/London',
      'UTC',
    ]);
  }
}

class MockContainerResponses {
  static Map<String, dynamic> containerList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'containerID': 'abc123def456',
          'name': 'nginx-server',
          'image': 'nginx:latest',
          'status': 'running',
          'state': 'running',
          'createdAt': '2024-01-01T00:00:00Z',
          'ports': ['80:80', '443:443'],
        },
        {
          'containerID': 'def456ghi789',
          'name': 'mysql-db',
          'image': 'mysql:8.0',
          'status': 'running',
          'state': 'running',
          'createdAt': '2024-01-02T00:00:00Z',
          'ports': ['3306:3306'],
        },
      ],
      total: 2,
    );
  }

  static Map<String, dynamic> imageList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 'sha256:abc123',
          'repository': 'nginx',
          'tag': 'latest',
          'size': 142000000,
          'createdAt': '2024-01-01T00:00:00Z',
        },
        {
          'id': 'sha256:def456',
          'repository': 'mysql',
          'tag': '8.0',
          'size': 556000000,
          'createdAt': '2024-01-02T00:00:00Z',
        },
      ],
      total: 2,
    );
  }

  static Map<String, dynamic> volumeList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'name': 'nginx_data',
          'driver': 'local',
          'mountpoint': '/var/lib/docker/volumes/nginx_data/_data',
          'createdAt': '2024-01-01T00:00:00Z',
        },
      ],
      total: 1,
    );
  }

  static Map<String, dynamic> networkList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'name': 'bridge',
          'driver': 'bridge',
          'scope': 'local',
          'subnet': '172.17.0.0/16',
        },
        {
          'name': 'host',
          'driver': 'host',
          'scope': 'local',
          'subnet': '',
        },
      ],
      total: 2,
    );
  }
}

class MockAppResponses {
  static Map<String, dynamic> appList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'key': 'nginx',
          'name': 'Nginx',
          'shortDesc': '高性能HTTP和反向代理服务器',
          'icon': 'nginx.png',
          'category': 'web-server',
          'status': 'installed',
          'version': '1.24.0',
        },
        {
          'key': 'mysql',
          'name': 'MySQL',
          'shortDesc': '开源关系型数据库',
          'icon': 'mysql.png',
          'category': 'database',
          'status': 'not-installed',
          'version': '8.0',
        },
      ],
      total: 2,
    );
  }

  static Map<String, dynamic> installedList() {
    return MockApiResponses.success(data: [
      {
        'id': 1,
        'appId': 1,
        'name': 'nginx-server',
        'appKey': 'nginx',
        'version': '1.24.0',
        'status': 'running',
        'createdAt': '2024-01-01T00:00:00Z',
      },
    ]);
  }

  static Map<String, dynamic> appDetail() {
    return MockApiResponses.success(data: {
      'key': 'nginx',
      'name': 'Nginx',
      'version': '1.24.0',
      'description': '高性能HTTP和反向代理服务器',
      'icon': 'nginx.png',
      'readme': '# Nginx\n\nNginx是一个高性能的HTTP和反向代理服务器...',
      'params': [
        {
          'key': 'port',
          'label': '端口',
          'type': 'number',
          'default': 80,
          'required': true,
        },
        {
          'key': 'domain',
          'label': '域名',
          'type': 'text',
          'default': '',
          'required': false,
        },
      ],
    });
  }
}

class MockDatabaseResponses {
  static Map<String, dynamic> mysqlList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'name': 'mysql-main',
          'type': 'mysql',
          'version': '8.0',
          'status': 'running',
          'port': 3306,
          'createdAt': '2024-01-01T00:00:00Z',
        },
      ],
      total: 1,
    );
  }

  static Map<String, dynamic> databaseList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'name': 'app_production',
          'charset': 'utf8mb4',
          'collation': 'utf8mb4_unicode_ci',
          'size': '100MB',
        },
        {
          'id': 2,
          'name': 'app_development',
          'charset': 'utf8mb4',
          'collation': 'utf8mb4_unicode_ci',
          'size': '50MB',
        },
      ],
      total: 2,
    );
  }

  static Map<String, dynamic> userList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'username': 'app_user',
          'host': '%',
          'databases': ['app_production', 'app_development'],
          'privileges': 'SELECT, INSERT, UPDATE, DELETE',
        },
      ],
      total: 1,
    );
  }
}

class MockWebsiteResponses {
  static Map<String, dynamic> websiteList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'name': 'example.com',
          'primaryDomain': 'example.com',
          'type': 'static',
          'status': 'running',
          'https': true,
          'createdAt': '2024-01-01T00:00:00Z',
        },
        {
          'id': 2,
          'name': 'api.example.com',
          'primaryDomain': 'api.example.com',
          'type': 'proxy',
          'status': 'running',
          'https': true,
          'proxy': 'http://localhost:3000',
          'createdAt': '2024-01-02T00:00:00Z',
        },
      ],
      total: 2,
    );
  }

  static Map<String, dynamic> websiteDetail() {
    return MockApiResponses.success(data: {
      'id': 1,
      'name': 'example.com',
      'primaryDomain': 'example.com',
      'otherDomains': ['www.example.com'],
      'type': 'static',
      'status': 'running',
      'https': true,
      'ssl': {
        'provider': 'letsencrypt',
        'expireAt': '2025-01-01T00:00:00Z',
      },
      'rootPath': '/var/www/example.com',
      'nginxConfig': 'server { ... }',
    });
  }
}

class MockFileResponses {
  static Map<String, dynamic> fileList() {
    return MockApiResponses.success(data: {
      'path': '/var/www',
      'items': [
        {
          'name': 'example.com',
          'path': '/var/www/example.com',
          'isDir': true,
          'size': 4096,
          'mode': 'drwxr-xr-x',
          'modTime': '2024-01-01T00:00:00Z',
          'owner': 'root',
          'group': 'root',
        },
        {
          'name': 'index.html',
          'path': '/var/www/index.html',
          'isDir': false,
          'size': 1024,
          'mode': '-rw-r--r--',
          'modTime': '2024-01-01T00:00:00Z',
          'owner': 'root',
          'group': 'root',
          'extension': '.html',
        },
      ],
    });
  }

  static Map<String, dynamic> fileContent() {
    return MockApiResponses.success(data: {
      'path': '/var/www/index.html',
      'content': '<!DOCTYPE html><html><head><title>Test</title></head><body><h1>Hello World</h1></body></html>',
      'size': 1024,
      'encoding': 'utf-8',
    });
  }
}

class MockSSLResponses {
  static Map<String, dynamic> sslList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'domains': ['example.com', 'www.example.com'],
          'provider': 'letsencrypt',
          'expireAt': '2025-01-01T00:00:00Z',
          'autoRenew': true,
          'createdAt': '2024-01-01T00:00:00Z',
        },
      ],
      total: 1,
    );
  }

  static Map<String, dynamic> sslDetail() {
    return MockApiResponses.success(data: {
      'id': 1,
      'domains': ['example.com', 'www.example.com'],
      'provider': 'letsencrypt',
      'expireAt': '2025-01-01T00:00:00Z',
      'autoRenew': true,
      'certificate': '-----BEGIN CERTIFICATE-----\n...',
      'privateKey': '-----BEGIN PRIVATE KEY-----\n...',
      'createdAt': '2024-01-01T00:00:00Z',
    });
  }
}

class MockHostResponses {
  static Map<String, dynamic> hostList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'name': 'production-server',
          'ip': '192.168.1.100',
          'port': 22,
          'user': 'root',
          'authType': 'password',
          'status': 'connected',
          'createdAt': '2024-01-01T00:00:00Z',
        },
      ],
      total: 1,
    );
  }
}

class MockCronjobResponses {
  static Map<String, dynamic> cronjobList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'name': '每日备份',
          'type': 'backup',
          'spec': '0 2 * * *',
          'status': 'enable',
          'lastRunAt': '2024-01-01T02:00:00Z',
          'nextRunAt': '2024-01-02T02:00:00Z',
          'createdAt': '2024-01-01T00:00:00Z',
        },
      ],
      total: 1,
    );
  }
}

class MockMonitorResponses {
  static Map<String, dynamic> monitorData() {
    return MockApiResponses.success(data: {
      'timestamps': ['2024-01-01T00:00:00Z', '2024-01-01T00:05:00Z', '2024-01-01T00:10:00Z'],
      'cpu': [25.5, 30.2, 28.7],
      'memory': [45.2, 46.8, 47.1],
      'disk': [60.8, 60.9, 61.0],
      'network': {
        'in': [1024000, 1536000, 1280000],
        'out': [512000, 768000, 640000],
      },
    });
  }
}

class MockSettingResponses {
  static Map<String, dynamic> systemSettings() {
    return MockApiResponses.success(data: {
      'serverPort': 9999,
      'ssl': false,
      'language': 'zh-CN',
      'theme': 'light',
      'sessionTimeout': 30,
      'apiEnabled': true,
      'apiKey': 'your_api_key_here',
    });
  }

  static Map<String, dynamic> backupSettings() {
    return MockApiResponses.success(data: {
      'localPath': '/opt/1panel/backup',
      'accounts': [
        {
          'id': 1,
          'name': 'OSS备份',
          'type': 'oss',
          'bucket': 'backup-bucket',
          'region': 'cn-hangzhou',
        },
      ],
    });
  }
}

class MockUserResponses {
  static Map<String, dynamic> userList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'username': 'admin',
          'email': 'admin@example.com',
          'role': 'admin',
          'status': 'active',
          'createdAt': '2024-01-01T00:00:00Z',
          'lastLoginAt': '2024-01-15T12:00:00Z',
        },
      ],
      total: 1,
    );
  }
}

class MockAIResponses {
  static Map<String, dynamic> ollamaModels() {
    return MockApiResponses.pageResult(
      items: [
        {
          'name': 'llama2',
          'size': '4GB',
          'modifiedAt': '2024-01-01T00:00:00Z',
          'status': 'running',
        },
        {
          'name': 'mistral',
          'size': '4.1GB',
          'modifiedAt': '2024-01-02T00:00:00Z',
          'status': 'stopped',
        },
      ],
      total: 2,
    );
  }

  static Map<String, dynamic> mcpServers() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'name': 'filesystem-mcp',
          'type': 'stdio',
          'command': 'mcp-filesystem',
          'status': 'running',
          'createdAt': '2024-01-01T00:00:00Z',
        },
      ],
      total: 1,
    );
  }
}

class MockFirewallResponses {
  static Map<String, dynamic> firewallStatus() {
    return MockApiResponses.success(data: {
      'status': 'running',
      'defaultPolicy': 'DROP',
      'rules': [
        {
          'id': 1,
          'port': 22,
          'protocol': 'tcp',
          'strategy': 'accept',
          'address': '0.0.0.0/0',
        },
        {
          'id': 2,
          'port': 80,
          'protocol': 'tcp',
          'strategy': 'accept',
          'address': '0.0.0.0/0',
        },
      ],
    });
  }
}

class MockProcessResponses {
  static Map<String, dynamic> processList() {
    return MockApiResponses.pageResult(
      items: [
        {
          'pid': 1,
          'name': 'nginx',
          'cpu': 0.5,
          'mem': 1.2,
          'status': 'running',
          'user': 'root',
          'command': 'nginx: master process',
        },
        {
          'pid': 2,
          'name': 'mysql',
          'cpu': 2.3,
          'mem': 15.6,
          'status': 'running',
          'user': 'mysql',
          'command': 'mysqld',
        },
      ],
      total: 2,
    );
  }
}

class MockLogResponses {
  static Map<String, dynamic> systemLogs() {
    return MockApiResponses.pageResult(
      items: [
        {
          'id': 1,
          'level': 'info',
          'message': 'System started successfully',
          'source': 'system',
          'createdAt': '2024-01-01T00:00:00Z',
        },
        {
          'id': 2,
          'level': 'warning',
          'message': 'High memory usage detected',
          'source': 'monitor',
          'createdAt': '2024-01-01T00:05:00Z',
        },
      ],
      total: 2,
    );
  }
}
