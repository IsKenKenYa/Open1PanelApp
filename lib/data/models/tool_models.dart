/// System tools data models for 1Panel V2 API
///
/// This file contains all data models related to system tools,
/// including utilities, diagnostics, maintenance tools, etc.

import 'package:equatable/equatable.dart';

/// Tool information model
class ToolInfo extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? category;
  final String? version;
  final String? status;
  final bool? enabled;
  final Map<String, dynamic>? config;

  const ToolInfo({
    this.id,
    this.name,
    this.description,
    this.category,
    this.version,
    this.status,
    this.enabled,
    this.config,
  });

  factory ToolInfo.fromJson(Map<String, dynamic> json) {
    return ToolInfo(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      version: json['version'] as String?,
      status: json['status'] as String?,
      enabled: json['enabled'] as bool?,
      config: json['config'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'version': version,
      'status': status,
      'enabled': enabled,
      'config': config,
    };
  }

  @override
  List<Object?> get props => [id, name, description, category, version, status, enabled, config];
}