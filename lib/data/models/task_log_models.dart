import 'package:equatable/equatable.dart';

/// Task log model
class TaskLog extends Equatable {
  final int? id;
  final String? taskType;
  final String? taskName;
  final String? status;
  final String? message;
  final String? details;
  final String? createTime;
  final String? updateTime;
  final String? endTime;
  final int? progress;

  const TaskLog({
    this.id,
    this.taskType,
    this.taskName,
    this.status,
    this.message,
    this.details,
    this.createTime,
    this.updateTime,
    this.endTime,
    this.progress,
  });

  factory TaskLog.fromJson(Map<String, dynamic> json) {
    return TaskLog(
      id: json['id'] as int?,
      taskType: json['taskType'] as String?,
      taskName: json['taskName'] as String?,
      status: json['status'] as String?,
      message: json['message'] as String?,
      details: json['details'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
      endTime: json['endTime'] as String?,
      progress: json['progress'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskType': taskType,
      'taskName': taskName,
      'status': status,
      'message': message,
      'details': details,
      'createTime': createTime,
      'updateTime': updateTime,
      'endTime': endTime,
      'progress': progress,
    };
  }

  @override
  List<Object?> get props => [id, taskType, taskName, status, message, details, createTime, updateTime, endTime, progress];
}

/// Task log search model
class TaskLogSearch extends Equatable {
  final String? taskType;
  final String? status;
  final String? startTime;
  final String? endTime;
  final int? page;
  final int? pageSize;

  const TaskLogSearch({
    this.taskType,
    this.status,
    this.startTime,
    this.endTime,
    this.page,
    this.pageSize,
  });

  factory TaskLogSearch.fromJson(Map<String, dynamic> json) {
    return TaskLogSearch(
      taskType: json['taskType'] as String?,
      status: json['status'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskType': taskType,
      'status': status,
      'startTime': startTime,
      'endTime': endTime,
      'page': page,
      'pageSize': pageSize,
    };
  }

  @override
  List<Object?> get props => [taskType, status, startTime, endTime, page, pageSize];
}
