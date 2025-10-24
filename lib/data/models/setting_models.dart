/// Settings management data models for 1Panel V2 API
///
/// This file contains all data models related to system settings,
/// including configuration management, preferences, etc.

import 'package:equatable/equatable.dart';

/// Setting information model
class SettingInfo extends Equatable {
  final String? key;
  final String? value;
  final String? description;
  final String? type;
  final String? category;
  final bool? encrypted;
  final String? defaultValue;
  final String? updateTime;

  const SettingInfo({
    this.key,
    this.value,
    this.description,
    this.type,
    this.category,
    this.encrypted,
    this.defaultValue,
    this.updateTime,
  });

  factory SettingInfo.fromJson(Map<String, dynamic> json) {
    return SettingInfo(
      key: json['key'] as String?,
      value: json['value'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      category: json['category'] as String?,
      encrypted: json['encrypted'] as bool?,
      defaultValue: json['defaultValue'] as String?,
      updateTime: json['updateTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'description': description,
      'type': type,
      'category': category,
      'encrypted': encrypted,
      'defaultValue': defaultValue,
      'updateTime': updateTime,
    };
  }

  @override
  List<Object?> get props => [key, value, description, type, category, encrypted, defaultValue, updateTime];
}

/// Setting update request model
class SettingUpdate extends Equatable {
  final String key;
  final String value;

  const SettingUpdate({
    required this.key,
    required this.value,
  });

  factory SettingUpdate.fromJson(Map<String, dynamic> json) {
    return SettingUpdate(
      key: json['key'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  @override
  List<Object?> get props => [key, value];
}

/// Setting category model
class SettingCategory extends Equatable {
  final String? name;
  final String? description;
  final List<SettingInfo>? settings;

  const SettingCategory({
    this.name,
    this.description,
    this.settings,
  });

  factory SettingCategory.fromJson(Map<String, dynamic> json) {
    return SettingCategory(
      name: json['name'] as String?,
      description: json['description'] as String?,
      settings: (json['settings'] as List?)
          ?.map((item) => SettingInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'settings': settings?.map((setting) => setting.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [name, description, settings];
}