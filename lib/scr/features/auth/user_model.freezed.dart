// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String? get id; String get email;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName;@JsonKey(name: 'is_student') bool get isStudent;@JsonKey(name: 'is_teacher') bool get isTeacher;@JsonKey(name: 'profile_picture') String? get profilePicture;@JsonKey(name: 'device_info') String get deviceInfo;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.isStudent, isStudent) || other.isStudent == isStudent)&&(identical(other.isTeacher, isTeacher) || other.isTeacher == isTeacher)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,isStudent,isTeacher,profilePicture,deviceInfo);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, firstName: $firstName, lastName: $lastName, isStudent: $isStudent, isTeacher: $isTeacher, profilePicture: $profilePicture, deviceInfo: $deviceInfo)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String? id, String email,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'is_student') bool isStudent,@JsonKey(name: 'is_teacher') bool isTeacher,@JsonKey(name: 'profile_picture') String? profilePicture,@JsonKey(name: 'device_info') String deviceInfo
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? email = null,Object? firstName = null,Object? lastName = null,Object? isStudent = null,Object? isTeacher = null,Object? profilePicture = freezed,Object? deviceInfo = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,isStudent: null == isStudent ? _self.isStudent : isStudent // ignore: cast_nullable_to_non_nullable
as bool,isTeacher: null == isTeacher ? _self.isTeacher : isTeacher // ignore: cast_nullable_to_non_nullable
as bool,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,deviceInfo: null == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String email, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'is_student')  bool isStudent, @JsonKey(name: 'is_teacher')  bool isTeacher, @JsonKey(name: 'profile_picture')  String? profilePicture, @JsonKey(name: 'device_info')  String deviceInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.isStudent,_that.isTeacher,_that.profilePicture,_that.deviceInfo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String email, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'is_student')  bool isStudent, @JsonKey(name: 'is_teacher')  bool isTeacher, @JsonKey(name: 'profile_picture')  String? profilePicture, @JsonKey(name: 'device_info')  String deviceInfo)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.isStudent,_that.isTeacher,_that.profilePicture,_that.deviceInfo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String email, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'is_student')  bool isStudent, @JsonKey(name: 'is_teacher')  bool isTeacher, @JsonKey(name: 'profile_picture')  String? profilePicture, @JsonKey(name: 'device_info')  String deviceInfo)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.isStudent,_that.isTeacher,_that.profilePicture,_that.deviceInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({this.id, required this.email, @JsonKey(name: 'first_name') this.firstName = '', @JsonKey(name: 'last_name') this.lastName = '', @JsonKey(name: 'is_student') this.isStudent = false, @JsonKey(name: 'is_teacher') this.isTeacher = false, @JsonKey(name: 'profile_picture') this.profilePicture, @JsonKey(name: 'device_info') this.deviceInfo = ''}): super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String? id;
@override final  String email;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey(name: 'is_student') final  bool isStudent;
@override@JsonKey(name: 'is_teacher') final  bool isTeacher;
@override@JsonKey(name: 'profile_picture') final  String? profilePicture;
@override@JsonKey(name: 'device_info') final  String deviceInfo;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.isStudent, isStudent) || other.isStudent == isStudent)&&(identical(other.isTeacher, isTeacher) || other.isTeacher == isTeacher)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,isStudent,isTeacher,profilePicture,deviceInfo);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, firstName: $firstName, lastName: $lastName, isStudent: $isStudent, isTeacher: $isTeacher, profilePicture: $profilePicture, deviceInfo: $deviceInfo)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String email,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'is_student') bool isStudent,@JsonKey(name: 'is_teacher') bool isTeacher,@JsonKey(name: 'profile_picture') String? profilePicture,@JsonKey(name: 'device_info') String deviceInfo
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? email = null,Object? firstName = null,Object? lastName = null,Object? isStudent = null,Object? isTeacher = null,Object? profilePicture = freezed,Object? deviceInfo = null,}) {
  return _then(_UserModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,isStudent: null == isStudent ? _self.isStudent : isStudent // ignore: cast_nullable_to_non_nullable
as bool,isTeacher: null == isTeacher ? _self.isTeacher : isTeacher // ignore: cast_nullable_to_non_nullable
as bool,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,deviceInfo: null == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
