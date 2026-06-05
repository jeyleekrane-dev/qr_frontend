// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_dashboard_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseAllocation {

 String get id; String get code; String get title; String get schedule;
/// Create a copy of CourseAllocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseAllocationCopyWith<CourseAllocation> get copyWith => _$CourseAllocationCopyWithImpl<CourseAllocation>(this as CourseAllocation, _$identity);

  /// Serializes this CourseAllocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseAllocation&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,title,schedule);

@override
String toString() {
  return 'CourseAllocation(id: $id, code: $code, title: $title, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $CourseAllocationCopyWith<$Res>  {
  factory $CourseAllocationCopyWith(CourseAllocation value, $Res Function(CourseAllocation) _then) = _$CourseAllocationCopyWithImpl;
@useResult
$Res call({
 String id, String code, String title, String schedule
});




}
/// @nodoc
class _$CourseAllocationCopyWithImpl<$Res>
    implements $CourseAllocationCopyWith<$Res> {
  _$CourseAllocationCopyWithImpl(this._self, this._then);

  final CourseAllocation _self;
  final $Res Function(CourseAllocation) _then;

/// Create a copy of CourseAllocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? title = null,Object? schedule = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseAllocation].
extension CourseAllocationPatterns on CourseAllocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseAllocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseAllocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseAllocation value)  $default,){
final _that = this;
switch (_that) {
case _CourseAllocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseAllocation value)?  $default,){
final _that = this;
switch (_that) {
case _CourseAllocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String title,  String schedule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseAllocation() when $default != null:
return $default(_that.id,_that.code,_that.title,_that.schedule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String title,  String schedule)  $default,) {final _that = this;
switch (_that) {
case _CourseAllocation():
return $default(_that.id,_that.code,_that.title,_that.schedule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String title,  String schedule)?  $default,) {final _that = this;
switch (_that) {
case _CourseAllocation() when $default != null:
return $default(_that.id,_that.code,_that.title,_that.schedule);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseAllocation implements CourseAllocation {
  const _CourseAllocation({required this.id, required this.code, required this.title, required this.schedule});
  factory _CourseAllocation.fromJson(Map<String, dynamic> json) => _$CourseAllocationFromJson(json);

@override final  String id;
@override final  String code;
@override final  String title;
@override final  String schedule;

/// Create a copy of CourseAllocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseAllocationCopyWith<_CourseAllocation> get copyWith => __$CourseAllocationCopyWithImpl<_CourseAllocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseAllocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseAllocation&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,title,schedule);

@override
String toString() {
  return 'CourseAllocation(id: $id, code: $code, title: $title, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class _$CourseAllocationCopyWith<$Res> implements $CourseAllocationCopyWith<$Res> {
  factory _$CourseAllocationCopyWith(_CourseAllocation value, $Res Function(_CourseAllocation) _then) = __$CourseAllocationCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String title, String schedule
});




}
/// @nodoc
class __$CourseAllocationCopyWithImpl<$Res>
    implements _$CourseAllocationCopyWith<$Res> {
  __$CourseAllocationCopyWithImpl(this._self, this._then);

  final _CourseAllocation _self;
  final $Res Function(_CourseAllocation) _then;

/// Create a copy of CourseAllocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? title = null,Object? schedule = null,}) {
  return _then(_CourseAllocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TeacherDashboardState {

 List<CourseAllocation> get courses; bool get isLoading; String? get errorMessage;
/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherDashboardStateCopyWith<TeacherDashboardState> get copyWith => _$TeacherDashboardStateCopyWithImpl<TeacherDashboardState>(this as TeacherDashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherDashboardState&&const DeepCollectionEquality().equals(other.courses, courses)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(courses),isLoading,errorMessage);

@override
String toString() {
  return 'TeacherDashboardState(courses: $courses, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TeacherDashboardStateCopyWith<$Res>  {
  factory $TeacherDashboardStateCopyWith(TeacherDashboardState value, $Res Function(TeacherDashboardState) _then) = _$TeacherDashboardStateCopyWithImpl;
@useResult
$Res call({
 List<CourseAllocation> courses, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$TeacherDashboardStateCopyWithImpl<$Res>
    implements $TeacherDashboardStateCopyWith<$Res> {
  _$TeacherDashboardStateCopyWithImpl(this._self, this._then);

  final TeacherDashboardState _self;
  final $Res Function(TeacherDashboardState) _then;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courses = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
courses: null == courses ? _self.courses : courses // ignore: cast_nullable_to_non_nullable
as List<CourseAllocation>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherDashboardState].
extension TeacherDashboardStatePatterns on TeacherDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _TeacherDashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CourseAllocation> courses,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
return $default(_that.courses,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CourseAllocation> courses,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TeacherDashboardState():
return $default(_that.courses,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CourseAllocation> courses,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
return $default(_that.courses,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherDashboardState implements TeacherDashboardState {
  const _TeacherDashboardState({final  List<CourseAllocation> courses = const [], this.isLoading = false, this.errorMessage}): _courses = courses;
  

 final  List<CourseAllocation> _courses;
@override@JsonKey() List<CourseAllocation> get courses {
  if (_courses is EqualUnmodifiableListView) return _courses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_courses);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherDashboardStateCopyWith<_TeacherDashboardState> get copyWith => __$TeacherDashboardStateCopyWithImpl<_TeacherDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherDashboardState&&const DeepCollectionEquality().equals(other._courses, _courses)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_courses),isLoading,errorMessage);

@override
String toString() {
  return 'TeacherDashboardState(courses: $courses, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TeacherDashboardStateCopyWith<$Res> implements $TeacherDashboardStateCopyWith<$Res> {
  factory _$TeacherDashboardStateCopyWith(_TeacherDashboardState value, $Res Function(_TeacherDashboardState) _then) = __$TeacherDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 List<CourseAllocation> courses, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$TeacherDashboardStateCopyWithImpl<$Res>
    implements _$TeacherDashboardStateCopyWith<$Res> {
  __$TeacherDashboardStateCopyWithImpl(this._self, this._then);

  final _TeacherDashboardState _self;
  final $Res Function(_TeacherDashboardState) _then;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courses = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_TeacherDashboardState(
courses: null == courses ? _self._courses : courses // ignore: cast_nullable_to_non_nullable
as List<CourseAllocation>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
