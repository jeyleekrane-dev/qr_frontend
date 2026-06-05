import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../auth/auth_provider.dart';

part 'register_provider.freezed.dart';

// ─── State ───────────────────────────────────────────────────────────────────

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? selectedRole,
    String? errorMessage,
  }) = _RegisterState;
}

// ─── Provider ────────────────────────────────────────────────────────────────

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  /// Updates the selected role (student / teacher).
  void selectRole(String role) {
    state = state.copyWith(selectedRole: role, errorMessage: null);
  }

  /// Clears stale error/success when user edits a field.
  void clearStatus() {
    state = state.copyWith(errorMessage: null, isSuccess: false);
  }

  /// Delegates to [AuthNotifier.register] and mirrors result into [RegisterState].
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String confirmPassword,
  }) async {
    // Role must be selected before calling this
    if (state.selectedRole == null) {
      state = state.copyWith(
        errorMessage: 'Please select a role (Student or Teacher)',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    try {
      final success = await ref.read(authProvider.notifier).register(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            role: state.selectedRole!,
            confirmPassword: confirmPassword,
          );

      if (success) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Registration failed.',
        );
      }

      return success;
    } catch (e) {
      developer.log(
        'RegisterNotifier unexpected error: $e',
        name: 'RegisterNotifier',
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }
}
