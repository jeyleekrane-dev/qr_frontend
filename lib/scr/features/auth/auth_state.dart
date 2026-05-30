import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    UserModel? user,
    String? token,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
