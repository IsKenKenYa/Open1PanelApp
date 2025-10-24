/// Terminal management data models for 1Panel V2 API
///
/// This file contains all data models related to terminal/SSH management,
/// including connections, sessions, commands, etc.

import 'package:equatable/equatable.dart';

/// Terminal connection model
class TerminalConnection extends Equatable {
  final int? id;
  final String? name;
  final String? host;
  final int? port;
  final String? username;
  final String? authType;
  final bool? connected;
  final String? lastConnected;
  final String? description;

  const TerminalConnection({
    this.id,
    this.name,
    this.host,
    this.port,
    this.username,
    this.authType,
    this.connected,
    this.lastConnected,
    this.description,
  });

  factory TerminalConnection.fromJson(Map<String, dynamic> json) {
    return TerminalConnection(
      id: json['id'] as int?,
      name: json['name'] as String?,
      host: json['host'] as String?,
      port: json['port'] as int?,
      username: json['username'] as String?,
      authType: json['authType'] as String?,
      connected: json['connected'] as bool?,
      lastConnected: json['lastConnected'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'username': username,
      'authType': authType,
      'connected': connected,
      'lastConnected': lastConnected,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, name, host, port, username, authType, connected, lastConnected, description];
}

/// Terminal session model
class TerminalSession extends Equatable {
  final String? sessionId;
  final int? connectionId;
  final String? status;
  final String? startTime;
  final String? lastActivity;

  const TerminalSession({
    this.sessionId,
    this.connectionId,
    this.status,
    this.startTime,
    this.lastActivity,
  });

  factory TerminalSession.fromJson(Map<String, dynamic> json) {
    return TerminalSession(
      sessionId: json['sessionId'] as String?,
      connectionId: json['connectionId'] as int?,
      status: json['status'] as String?,
      startTime: json['startTime'] as String?,
      lastActivity: json['lastActivity'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'connectionId': connectionId,
      'status': status,
      'startTime': startTime,
      'lastActivity': lastActivity,
    };
  }

  @override
  List<Object?> get props => [sessionId, connectionId, status, startTime, lastActivity];
}