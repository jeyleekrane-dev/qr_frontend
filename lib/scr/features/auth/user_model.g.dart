// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String?,
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      isStudent: json['is_student'] as bool? ?? false,
      isTeacher: json['is_teacher'] as bool? ?? false,
      profilePicture: json['profile_picture'] as String?,
      deviceInfo: json['device_info'] as String? ?? '',
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_student': instance.isStudent,
      'is_teacher': instance.isTeacher,
      'profile_picture': instance.profilePicture,
      'device_info': instance.deviceInfo,
    };
