// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 bool get isLoadingProfile; bool get isUpdating; bool get isUploadingPicture; UserModel? get profile; String? get errorMessage; String? get successMessage;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.isLoadingProfile, isLoadingProfile) || other.isLoadingProfile == isLoadingProfile)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.isUploadingPicture, isUploadingPicture) || other.isUploadingPicture == isUploadingPicture)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoadingProfile,isUpdating,isUploadingPicture,profile,errorMessage,successMessage);

@override
String toString() {
  return 'ProfileState(isLoadingProfile: $isLoadingProfile, isUpdating: $isUpdating, isUploadingPicture: $isUploadingPicture, profile: $profile, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 bool isLoadingProfile, bool isUpdating, bool isUploadingPicture, UserModel? profile, String? errorMessage, String? successMessage
});


$UserModelCopyWith<$Res>? get profile;

}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoadingProfile = null,Object? isUpdating = null,Object? isUploadingPicture = null,Object? profile = freezed,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
isLoadingProfile: null == isLoadingProfile ? _self.isLoadingProfile : isLoadingProfile // ignore: cast_nullable_to_non_nullable
as bool,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,isUploadingPicture: null == isUploadingPicture ? _self.isUploadingPicture : isUploadingPicture // ignore: cast_nullable_to_non_nullable
as bool,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserModel?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoadingProfile,  bool isUpdating,  bool isUploadingPicture,  UserModel? profile,  String? errorMessage,  String? successMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.isLoadingProfile,_that.isUpdating,_that.isUploadingPicture,_that.profile,_that.errorMessage,_that.successMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoadingProfile,  bool isUpdating,  bool isUploadingPicture,  UserModel? profile,  String? errorMessage,  String? successMessage)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.isLoadingProfile,_that.isUpdating,_that.isUploadingPicture,_that.profile,_that.errorMessage,_that.successMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoadingProfile,  bool isUpdating,  bool isUploadingPicture,  UserModel? profile,  String? errorMessage,  String? successMessage)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.isLoadingProfile,_that.isUpdating,_that.isUploadingPicture,_that.profile,_that.errorMessage,_that.successMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState implements ProfileState {
  const _ProfileState({this.isLoadingProfile = false, this.isUpdating = false, this.isUploadingPicture = false, this.profile, this.errorMessage, this.successMessage});
  

@override@JsonKey() final  bool isLoadingProfile;
@override@JsonKey() final  bool isUpdating;
@override@JsonKey() final  bool isUploadingPicture;
@override final  UserModel? profile;
@override final  String? errorMessage;
@override final  String? successMessage;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.isLoadingProfile, isLoadingProfile) || other.isLoadingProfile == isLoadingProfile)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.isUploadingPicture, isUploadingPicture) || other.isUploadingPicture == isUploadingPicture)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoadingProfile,isUpdating,isUploadingPicture,profile,errorMessage,successMessage);

@override
String toString() {
  return 'ProfileState(isLoadingProfile: $isLoadingProfile, isUpdating: $isUpdating, isUploadingPicture: $isUploadingPicture, profile: $profile, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoadingProfile, bool isUpdating, bool isUploadingPicture, UserModel? profile, String? errorMessage, String? successMessage
});


@override $UserModelCopyWith<$Res>? get profile;

}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoadingProfile = null,Object? isUpdating = null,Object? isUploadingPicture = null,Object? profile = freezed,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_ProfileState(
isLoadingProfile: null == isLoadingProfile ? _self.isLoadingProfile : isLoadingProfile // ignore: cast_nullable_to_non_nullable
as bool,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,isUploadingPicture: null == isUploadingPicture ? _self.isUploadingPicture : isUploadingPicture // ignore: cast_nullable_to_non_nullable
as bool,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserModel?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
