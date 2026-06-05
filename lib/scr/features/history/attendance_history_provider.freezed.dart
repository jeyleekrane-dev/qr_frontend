// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_history_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceRecord {

 String get courseName; String get status; DateTime get sessionDate;
/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<AttendanceRecord> get copyWith => _$AttendanceRecordCopyWithImpl<AttendanceRecord>(this as AttendanceRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecord&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.status, status) || other.status == status)&&(identical(other.sessionDate, sessionDate) || other.sessionDate == sessionDate));
}


@override
int get hashCode => Object.hash(runtimeType,courseName,status,sessionDate);

@override
String toString() {
  return 'AttendanceRecord(courseName: $courseName, status: $status, sessionDate: $sessionDate)';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordCopyWith<$Res>  {
  factory $AttendanceRecordCopyWith(AttendanceRecord value, $Res Function(AttendanceRecord) _then) = _$AttendanceRecordCopyWithImpl;
@useResult
$Res call({
 String courseName, String status, DateTime sessionDate
});




}
/// @nodoc
class _$AttendanceRecordCopyWithImpl<$Res>
    implements $AttendanceRecordCopyWith<$Res> {
  _$AttendanceRecordCopyWithImpl(this._self, this._then);

  final AttendanceRecord _self;
  final $Res Function(AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseName = null,Object? status = null,Object? sessionDate = null,}) {
  return _then(_self.copyWith(
courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,sessionDate: null == sessionDate ? _self.sessionDate : sessionDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceRecord].
extension AttendanceRecordPatterns on AttendanceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecord value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String courseName,  String status,  DateTime sessionDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.courseName,_that.status,_that.sessionDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String courseName,  String status,  DateTime sessionDate)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that.courseName,_that.status,_that.sessionDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String courseName,  String status,  DateTime sessionDate)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.courseName,_that.status,_that.sessionDate);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceRecord extends AttendanceRecord {
  const _AttendanceRecord({required this.courseName, required this.status, required this.sessionDate}): super._();
  

@override final  String courseName;
@override final  String status;
@override final  DateTime sessionDate;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecordCopyWith<_AttendanceRecord> get copyWith => __$AttendanceRecordCopyWithImpl<_AttendanceRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecord&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.status, status) || other.status == status)&&(identical(other.sessionDate, sessionDate) || other.sessionDate == sessionDate));
}


@override
int get hashCode => Object.hash(runtimeType,courseName,status,sessionDate);

@override
String toString() {
  return 'AttendanceRecord(courseName: $courseName, status: $status, sessionDate: $sessionDate)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordCopyWith<$Res> implements $AttendanceRecordCopyWith<$Res> {
  factory _$AttendanceRecordCopyWith(_AttendanceRecord value, $Res Function(_AttendanceRecord) _then) = __$AttendanceRecordCopyWithImpl;
@override @useResult
$Res call({
 String courseName, String status, DateTime sessionDate
});




}
/// @nodoc
class __$AttendanceRecordCopyWithImpl<$Res>
    implements _$AttendanceRecordCopyWith<$Res> {
  __$AttendanceRecordCopyWithImpl(this._self, this._then);

  final _AttendanceRecord _self;
  final $Res Function(_AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseName = null,Object? status = null,Object? sessionDate = null,}) {
  return _then(_AttendanceRecord(
courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,sessionDate: null == sessionDate ? _self.sessionDate : sessionDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$AttendanceHistoryState {

 List<AttendanceRecord> get records; bool get isLoading; String? get errorMessage;
/// Create a copy of AttendanceHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceHistoryStateCopyWith<AttendanceHistoryState> get copyWith => _$AttendanceHistoryStateCopyWithImpl<AttendanceHistoryState>(this as AttendanceHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceHistoryState&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(records),isLoading,errorMessage);

@override
String toString() {
  return 'AttendanceHistoryState(records: $records, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AttendanceHistoryStateCopyWith<$Res>  {
  factory $AttendanceHistoryStateCopyWith(AttendanceHistoryState value, $Res Function(AttendanceHistoryState) _then) = _$AttendanceHistoryStateCopyWithImpl;
@useResult
$Res call({
 List<AttendanceRecord> records, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$AttendanceHistoryStateCopyWithImpl<$Res>
    implements $AttendanceHistoryStateCopyWith<$Res> {
  _$AttendanceHistoryStateCopyWithImpl(this._self, this._then);

  final AttendanceHistoryState _self;
  final $Res Function(AttendanceHistoryState) _then;

/// Create a copy of AttendanceHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? records = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceHistoryState].
extension AttendanceHistoryStatePatterns on AttendanceHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AttendanceRecord> records,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceHistoryState() when $default != null:
return $default(_that.records,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AttendanceRecord> records,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AttendanceHistoryState():
return $default(_that.records,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AttendanceRecord> records,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceHistoryState() when $default != null:
return $default(_that.records,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceHistoryState extends AttendanceHistoryState {
  const _AttendanceHistoryState({final  List<AttendanceRecord> records = const [], this.isLoading = false, this.errorMessage}): _records = records,super._();
  

 final  List<AttendanceRecord> _records;
@override@JsonKey() List<AttendanceRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of AttendanceHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceHistoryStateCopyWith<_AttendanceHistoryState> get copyWith => __$AttendanceHistoryStateCopyWithImpl<_AttendanceHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceHistoryState&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records),isLoading,errorMessage);

@override
String toString() {
  return 'AttendanceHistoryState(records: $records, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AttendanceHistoryStateCopyWith<$Res> implements $AttendanceHistoryStateCopyWith<$Res> {
  factory _$AttendanceHistoryStateCopyWith(_AttendanceHistoryState value, $Res Function(_AttendanceHistoryState) _then) = __$AttendanceHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<AttendanceRecord> records, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$AttendanceHistoryStateCopyWithImpl<$Res>
    implements _$AttendanceHistoryStateCopyWith<$Res> {
  __$AttendanceHistoryStateCopyWithImpl(this._self, this._then);

  final _AttendanceHistoryState _self;
  final $Res Function(_AttendanceHistoryState) _then;

/// Create a copy of AttendanceHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? records = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_AttendanceHistoryState(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
