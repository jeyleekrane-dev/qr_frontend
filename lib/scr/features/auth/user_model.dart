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
    @JsonKey(name: 'profile_picture') String? profilePicture,
    @JsonKey(name: 'device_info') @Default('') String deviceInfo,
  }) = _UserModel;

  // Required for custom getters on freezed classes.
  const UserModel._();

  /// Convenience getter — returns the user's role as a human-readable string.
  /// Not part of JSON serialization.
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get role => isTeacher ? 'teacher' : 'student';

  /// Full display name.
  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
