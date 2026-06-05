import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_state.freezed.dart';

// ✅ Removed fromJson/toJson — auth state is runtime-only, never persisted
// ✅ Removed isLoading — each feature provider (login/register) owns its loading
// ✅ Removed errorMessage — each feature provider owns its errors

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    UserModel? user,
    String? token,
  }) = _AuthState;
}
