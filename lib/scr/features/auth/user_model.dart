import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({

    final String? id,
    required String email,
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name') @Default('') String lastName,
    @JsonKey(name: 'is_student') @Default(false) bool isStudent,
    @JsonKey(name: 'is_teacher') @Default(false) bool isTeacher,
    @JsonKey(name: 'profile_picture')
    String? profilePicture,
    @JsonKey(name: 'device_info') @Default('') String deviceInfo,

  }) = _UserModel;

  // Keep legacy UI field alive.
  const UserModel._();

  /// Computed legacy helper.
  /// Not part of JSON serialization.
  @JsonKey(ignore: true)
  String get isStaff => isTeacher ? 'teacher' : 'student';

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}


