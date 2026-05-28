// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String?,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      isStudent: json['isStudent'] as bool? ?? false,
      isTeacher: json['isTeacher'] as bool? ?? false,
      profilePicture: json['profile_picture'] as String?,
      deviceInfo: json['deviceInfo'] as String? ?? '',
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'isStudent': instance.isStudent,
      'isTeacher': instance.isTeacher,
      'profile_picture': instance.profilePicture,
      'deviceInfo': instance.deviceInfo,
    };
