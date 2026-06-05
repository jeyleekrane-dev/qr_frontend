import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_frontend/scr/utils/device_helper.dart';
import 'auth_state.dart';
import 'user_model.dart';
import '../../utils/storage_provider.dart';
import '../../utils/dio_client.dart';

// ─── Provider ────────────────────────────────────────────────────────────────

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

/// Owns the single source of truth for authentication:
/// the current [token] and [user].
///
/// Loading and error states are intentionally NOT here —
/// they belong to each feature notifier (LoginNotifier, RegisterNotifier, etc.)
/// to avoid shared mutable state across screens.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Auth provider must survive the entire app lifetime
    ref.keepAlive();
    return const AuthState();
  }

  // ─── Convenience Getters ────────────────────────────────────────────────
  Dio get _dio => ref.read(dioProvider);
  FlutterSecureStorage get _storage => ref.read(storageProvider);

  // ─── Public API ──────────────────────────────────────────────────────────

  /// Reads the stored access token on app start.
  /// Called by [SplashNotifier.bootstrap].
  Future<void> checkAuthStatus() async {
    try {
      final token = await _storage.read(key: 'access_token');
      state = AuthState(token: token, user: null);
    } catch (e) {
      developer.log('checkAuthStatus failed: $e', name: 'AuthNotifier');
      state = const AuthState();
    }
  }

  /// Syncs the latest user data into auth state without touching the token.
  /// Called by ProfileNotifier after a successful fetch or update.
  void syncUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  /// Authenticates the user and persists tokens.
  /// Returns `true` on success, `false` on failure.
  /// Throws nothing — all errors are returned as `false` with state set.
  Future<bool> login(String email, String password) async {
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
      final userModel = userData != null
          ? UserModel.fromJson(userData as Map<String, dynamic>)
          : null;

      state = AuthState(token: accessToken, user: userModel);
      return true;
    } on DioException catch (e) {
      developer.log('login DioException: $e', name: 'AuthNotifier');
      // ✅ Don't set errorMessage here — LoginNotifier owns that
      state = const AuthState();
      rethrow; // rethrow so LoginNotifier can extract the message
    } catch (e) {
      developer.log('login unexpected error: $e', name: 'AuthNotifier');
      state = const AuthState();
      rethrow;
    }
  }

  /// Registers a new user and persists tokens.
  /// Returns `true` on success, `false` on failure.
  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      final deviceId = await DeviceHelper.getUniqueId();
      final isTeacher = role.toLowerCase() == 'teacher';

      final response = await _dio.post(
        'api/v1/register/',
        data: {
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
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
              isStudent: !isTeacher,
              isTeacher: isTeacher,
              profilePicture: null,
              deviceInfo: '',
            );

      state = AuthState(token: accessToken, user: userModel);
      return true;
    } on DioException catch (e) {
      developer.log('register DioException: $e', name: 'AuthNotifier');
      state = const AuthState();
      rethrow;
    } catch (e) {
      developer.log('register unexpected error: $e', name: 'AuthNotifier');
      state = const AuthState();
      rethrow;
    }
  }

  /// Clears backend session and all local storage.
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken != null) {
        await _dio.post('api/v1/logout/', data: {'refresh': refreshToken});
      }
    } catch (e) {
      // Backend logout failure is non-critical — always clear locally
      developer.log('logout backend call failed: $e', name: 'AuthNotifier');
    }

    await _storage.deleteAll();
    state = const AuthState();
  }

  // ─── Private Helpers ─────────────────────────────────────────────────────

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
}
