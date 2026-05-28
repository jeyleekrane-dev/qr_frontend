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

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {

  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._dio, this._storage) : super(const AuthState());

  /// Check token during splash screen
  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'access_token');
    
    // Optional: If you saved user data locally, you could read it here.
    // For now, we restore the token state.
    if (token != null) {
      state = AuthState(
        token: token,
        user: null, // You can fetch profile details from backend here if needed
        isLoading: false,
      );
    } else {
      state = const AuthState(
        token: null,
        user: null,
        isLoading: false,
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final deviceId = await DeviceHelper.getUniqueId();

      final isTeacher = role.toLowerCase() == 'teacher';
      final isStudent = !isTeacher;

      // Backend expects: api/v1/register/
      // Backend also expects confirm_password (required).
      final response = await _dio.post(
        'api/v1/register/',
        data: {
          'email': email,
          'password': password,
          // Send confirm_password to satisfy backend validation.
          'confirm_password': password,
          'first_name': firstName,
          'last_name': lastName,
          // send role in backend-friendly format
          'role': isTeacher ? 'teacher' : 'student',
          'device_id': deviceId,
        },
      );

      // Common patterns:
      // 1) {access:..., refresh:..., user:{...}}
      // 2) {tokens:{access:..., refresh:...}, user:{...}}
      final accessToken = response.data['access'] ?? response.data['token'] ?? response.data['access_token'];
      final refreshToken = response.data['refresh'] ?? response.data['refresh_token'];
      final userData = response.data['user'] ?? response.data['profile'] ?? response.data['data'];

      if (accessToken is String) {
        await _storage.write(key: 'access_token', value: accessToken);
      }
      if (refreshToken is String) {
        await _storage.write(key: 'refresh_token', value: refreshToken);
      }

      final userModel = userData != null
          ? UserModel.fromJson(userData)
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
        token: accessToken is String ? accessToken : null,
        errorMessage: null,
      );
    } on DioException catch (e) {


      final errorMessage =
          e.response?.data['detail']?.toString() ??
          e.response?.data['error']?.toString() ??
          'Register failed';
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }

  /// Login User
  /// Returns true if login succeeded, false otherwise.
  Future<bool> login(String email, String password) async {
    state = const AuthState(isLoading: true);

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

      final accessToken =
          response.data['access'] ??
          response.data['token'] ??
          response.data['access_token'];
      final refreshToken =
          response.data['refresh'] ?? response.data['refresh_token'];

      final userData = response.data['user'];
      final userModel = userData != null ? UserModel.fromJson(userData) : null;

      await _storage.write(
        key: 'access_token',
        value: accessToken,
      );

      await _storage.write(
        key: 'refresh_token',
        value: refreshToken,
      );

      state = AuthState(
        token: accessToken,
        user: userModel,
        isLoading: false,
        errorMessage: null,
      );

      return true;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['detail']?.toString() ??
          e.response?.data['error']?.toString() ??
          'Login failed';

      state = AuthState(
        isLoading: false,
        errorMessage: errorMessage,
        token: null,
        user: null,
      );

      return false;
    }
  }


  /// Logout
  Future<void> logout() async {
    try {
      await _dio.post('api/v1/logout/');
    } catch (_) {
      // ignore and still clear locally
    }

    await _storage.deleteAll();

    state = const AuthState(
      token: null,
      user: null, // Clear user info on logout
      isLoading: false,
    );
  }

}