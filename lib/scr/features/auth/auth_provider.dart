import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_frontend/scr/utils/device_helper.dart';
import 'auth_state.dart';
import 'user_model.dart';
import '../../utils/storage_provider.dart';
import '../../utils/dio_client.dart';

/// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(dioProvider),
    ref.read(storageProvider),
  );
});

/// Auth Notifier — manages login, register, logout and token persistence.
class AuthNotifier extends StateNotifier<AuthState> {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._dio, this._storage) : super(const AuthState());

  // ─── Helpers ─────────────────────────────────────────────

  /// Parse the most useful error message from a Dio error response.
  /// Handles Django REST / DRF style responses such as:
  ///   {"detail": "..."}
  ///   {"error": "..."}
  ///   {"email": ["already exists"]}  ← field-level errors
  ///   {"non_field_errors": ["..."]}
  String _extractErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data == null) return e.message ?? fallback;
    if (data is! Map) return data.toString();

    // 1. Simple string fields
    if (data['detail'] != null) return data['detail'].toString();
    if (data['error'] != null) return data['error'].toString();
    if (data['message'] != null) return data['message'].toString();

    // 2. Non-field-errors (DRF convention)
    final nonFieldErrors = data['non_field_errors'];
    if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
      return nonFieldErrors.join(', ');
    }

    // 3. Field-level errors — collect the first ones
    final buffer = StringBuffer();
    data.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        buffer.write('${_humaniseFieldName(key)}: ${value.first}. ');
      }
    });
    if (buffer.isNotEmpty) return buffer.toString().trim();

    return fallback;
  }

  /// Turn "confirm_password" → "Confirm password" for user-facing messages.
  String _humaniseFieldName(String field) {
    return field.replaceAll('_', ' ').replaceRange(0, 1, field[0].toUpperCase());
  }

  /// Extract token from various common backend response shapes.
  String? _extractAccessToken(Map<String, dynamic> data) {
    return data['access']?.toString() ??
        data['token']?.toString() ??
        data['access_token']?.toString() ??
        (data['tokens'] is Map ? data['tokens']['access']?.toString() : null);
  }

  String? _extractRefreshToken(Map<String, dynamic> data) {
    return data['refresh']?.toString() ??
        data['refresh_token']?.toString() ??
        (data['tokens'] is Map ? data['tokens']['refresh']?.toString() : null);
  }

  /// Persist tokens to secure storage, guarding against null.
  Future<void> _persistTokens({
    required String? accessToken,
    required String? refreshToken,
  }) async {
    if (accessToken != null && accessToken.isNotEmpty) {
      await _storage.write(key: 'access_token', value: accessToken);
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
  }

  // ─── Public API ──────────────────────────────────────────

  /// Check token during splash screen.
  Future<void> checkAuthStatus() async {
    try {
      final token = await _storage.read(key: 'access_token');

      state = AuthState(
        token: token,
        user: null, // Profile can be fetched lazily on the home screen
        isLoading: false,
      );
    } catch (e) {
      developer.log('checkAuthStatus failed: $e', name: 'AuthNotifier');
      state = const AuthState(isLoading: false);
    }
  }

  /// Register a new user.
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final deviceId = await DeviceHelper.getUniqueId();

      final isTeacher = role.toLowerCase() == 'teacher';
      final isStudent = !isTeacher;

      final response = await _dio.post(
        'api/v1/register/',
        data: {
          'email': email,
          'password': password,
          'confirm_password': password,
          'first_name': firstName,
          'last_name': lastName,
          'role': isTeacher ? 'teacher' : 'student',
          'device_id': deviceId,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final accessToken = _extractAccessToken(data);
      final refreshToken = _extractRefreshToken(data);

      await _persistTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      final userData = data['user'] ?? data['profile'] ?? data['data'];
      final userModel = userData != null
          ? UserModel.fromJson(userData as Map<String, dynamic>)
          : UserModel(
              id: null,
              email: email,
              firstName: firstName,
              lastName: lastName,
              isStudent: isStudent,
              isTeacher: isTeacher,
              profilePicture: null,
              deviceInfo: '',
            );

      state = state.copyWith(
        isLoading: false,
        user: userModel,
        token: accessToken,
        errorMessage: null,
      );

      return true;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e, 'Registration failed');
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return false;
    } catch (e) {
      developer.log('register unexpected error: $e', name: 'AuthNotifier');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Login user. Returns `true` if login succeeded.
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final deviceId = await DeviceHelper.getUniqueId();

      final response = await _dio.post(
        'api/v1/login/',
        data: {
          'email': email,
          'password': password,
          'device_id': deviceId,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final accessToken = _extractAccessToken(data);
      final refreshToken = _extractRefreshToken(data);

      await _persistTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      final userData = data['user'];
      final userModel =
          userData != null ? UserModel.fromJson(userData as Map<String, dynamic>) : null;

      state = AuthState(
        token: accessToken,
        user: userModel,
        isLoading: false,
        errorMessage: null,
      );

      return true;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e, 'Login failed');

      state = AuthState(
        isLoading: false,
        errorMessage: errorMessage,
        token: null,
        user: null,
      );

      return false;
    } catch (e) {
      developer.log('login unexpected error: $e', name: 'AuthNotifier');
      state = const AuthState(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Logout — clears backend session and local storage.
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken != null) {
        await _dio.post('api/v1/logout/', data: {'refresh': refreshToken});
      }
    } catch (e) {
      // Backend failure is non-critical — always clear locally
      developer.log('logout backend call failed: $e', name: 'AuthNotifier');
    }

    await _storage.deleteAll();

    state = const AuthState(
      token: null,
      user: null,
      isLoading: false,
    );
  }
}
