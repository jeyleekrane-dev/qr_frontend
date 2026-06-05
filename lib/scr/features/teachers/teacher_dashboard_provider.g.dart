// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_dashboard_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseAllocation _$CourseAllocationFromJson(Map<String, dynamic> json) =>
    _CourseAllocation(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      schedule: json['schedule'] as String,
    );

Map<String, dynamic> _$CourseAllocationToJson(_CourseAllocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'title': instance.title,
      'schedule': instance.schedule,
    };
