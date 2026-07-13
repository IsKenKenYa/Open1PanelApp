import 'package:onepanel_client/data/models/database_models.dart';

bool databaseSupportsBackups(DatabaseScope scope) {
  return scope == DatabaseScope.mysql ||
      scope == DatabaseScope.postgresql ||
      scope == DatabaseScope.redis;
}

bool databaseSupportsUserManagement(DatabaseScope scope) {
  return scope == DatabaseScope.mysql || scope == DatabaseScope.postgresql;
}

bool databaseSupportsPrivilegeManagement(DatabaseScope scope) {
  return scope == DatabaseScope.postgresql || scope == DatabaseScope.mongodb;
}

String databaseBackupType(DatabaseListItem item) {
  switch (item.scope) {
    case DatabaseScope.mysql:
      return 'mysql';
    case DatabaseScope.postgresql:
      return 'postgresql';
    case DatabaseScope.mongodb:
      return 'mongodb';
    case DatabaseScope.redis:
      return 'redis';
    case DatabaseScope.remote:
      throw UnsupportedError('Remote databases do not support backups.');
  }
}

String databaseBackupName(DatabaseListItem item) {
  switch (item.scope) {
    case DatabaseScope.mysql:
    case DatabaseScope.postgresql:
    case DatabaseScope.mongodb:
      return item.lookupName;
    case DatabaseScope.redis:
      return item.lookupName;
    case DatabaseScope.remote:
      throw UnsupportedError('Remote databases do not support backups.');
  }
}

String databaseBackupDetailName(DatabaseListItem item) {
  switch (item.scope) {
    case DatabaseScope.mysql:
    case DatabaseScope.postgresql:
    case DatabaseScope.mongodb:
      return item.name;
    case DatabaseScope.redis:
      // Redis has no database-level naming concept (it's key-value), so return empty.
      return '';
    case DatabaseScope.remote:
      throw UnsupportedError('Remote databases do not support backups.');
  }
}
