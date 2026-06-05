import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../auth/auth_provider.dart';

part 'login_provider.freezed.dart';

// ─── State ───────────────────────────────────────────────────────────────────

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _LoginState;
}

// ─── Provider ────────────────────────────────────────────────────────────────

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  /// Delegates to [AuthNotifier.login] and mirrors the result into [LoginState].
  Future<bool> login(String email, String password) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    try {
      final success =
          await ref.read(authProvider.notifier).login(email, password);

      if (success) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Login failed.',
        );
      }

      return success;
    } catch (e) {
      developer.log('LoginNotifier unexpected error: $e', name: 'LoginNotifier');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Clears stale error when user starts editing fields.
  void clearStatus() {
    state = state.copyWith(errorMessage: null, isSuccess: false);
  }
}
