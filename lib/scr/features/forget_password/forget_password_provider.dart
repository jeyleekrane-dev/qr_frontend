import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../utils/dio_client.dart';

part 'forget_password_provider.freezed.dart';

// ─── State ───────────────────────────────────────────────────────────────────

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _ForgotPasswordState;
}

// ─── Provider ────────────────────────────────────────────────────────────────

final forgotPasswordProvider =
    NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  ForgotPasswordNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  Dio get _dio => ref.read(dioProvider);

  /// Sends a password reset request to the backend.
  /// Returns `true` on success, `false` on failure.
  Future<bool> sendResetLink(String email) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    try {
      await _dio.post(
        'api/v1/password-reset/',
        data: {'email': email},
      );

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return false;
    } catch (e) {
      developer.log('sendResetLink unexpected error: $e',
          name: 'ForgotPasswordNotifier');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Clears any lingering error or success state (e.g. when user edits the field).
  void clearStatus() {
    state = state.copyWith(errorMessage: null, isSuccess: false);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data == null) return e.message ?? 'Failed to request reset.';
    if (data is! Map) return data.toString();

    return data['detail']?.toString() ??
        data['error']?.toString() ??
        data['message']?.toString() ??
        'Failed to request reset.';
  }
}
