import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({

    final String? id,
    required String email,
    required String firstName,
    required String lastName,
    @Default(false) bool isStudent,
    @Default(false) bool isTeacher,
    @JsonKey(name: 'profile_picture')
    String? profilePicture,
    @Default('') String deviceInfo,

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


