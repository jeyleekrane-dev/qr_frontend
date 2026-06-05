import 'dart:developer' as developer;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/auth_provider.dart';
import '../auth/user_model.dart';
import '../../utils/dio_client.dart';

part 'profile_provider.freezed.dart';

// ─── State ───────────────────────────────────────────────────────────────────

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoadingProfile,
    @Default(false) bool isUpdating,
    @Default(false) bool isUploadingPicture,
    UserModel? profile,
    String? errorMessage,
    String? successMessage,
  }) = _ProfileState;
}

// ─── Provider ────────────────────────────────────────────────────────────────

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

class ProfileNotifier extends Notifier<ProfileState> {
  final _picker = ImagePicker();

  @override
  ProfileState build() {
    // Kick off profile fetch when provider is first read
    Future.microtask(() => fetchProfile());
    return const ProfileState();
  }

  Dio get _dio => ref.read(dioProvider);

  // ─── Fetch ─────────────────────────────────────────────────────────────────

  /// Fetches the current user profile from the backend.
  Future<void> fetchProfile() async {
    state = state.copyWith(isLoadingProfile: true, errorMessage: null);

    try {
      final response = await _dio.get('api/v1/profile/');
      final data = response.data as Map<String, dynamic>;
      final profile = UserModel.fromJson(data);

      // Keep auth state in sync with latest profile data
      ref.read(authProvider.notifier).syncUser(profile);

      state = state.copyWith(isLoadingProfile: false, profile: profile);
    } on DioException catch (e) {
      developer.log('fetchProfile DioException: $e', name: 'ProfileNotifier');
      state = state.copyWith(
        isLoadingProfile: false,
        errorMessage: _extractErrorMessage(e, 'Failed to load profile.'),
      );
    } catch (e) {
      developer.log('fetchProfile unexpected error: $e',
          name: 'ProfileNotifier');
      state = state.copyWith(
        isLoadingProfile: false,
        errorMessage: 'An unexpected error occurred.',
      );
    }
  }

  // ─── Update Profile ────────────────────────────────────────────────────────

  /// Updates first name and last name.
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    state = state.copyWith(
      isUpdating: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final response = await _dio.patch(
        'api/v1/profile/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      final updated = UserModel.fromJson(response.data as Map<String, dynamic>);
      ref.read(authProvider.notifier).syncUser(updated);

      state = state.copyWith(
        isUpdating: false,
        profile: updated,
        successMessage: 'Profile updated successfully!',
      );

      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: _extractErrorMessage(e, 'Failed to update profile.'),
      );
      return false;
    } catch (e) {
      developer.log('updateProfile unexpected error: $e',
          name: 'ProfileNotifier');
      state = state.copyWith(
        isUpdating: false,
        errorMessage: 'An unexpected error occurred.',
      );
      return false;
    }
  }

  // ─── Profile Picture ───────────────────────────────────────────────────────

  /// Opens image picker and uploads the selected image.
  Future<void> pickAndUploadPicture() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (picked == null) return; // user cancelled

      await _uploadPicture(File(picked.path));
    } catch (e) {
      developer.log('pickAndUploadPicture error: $e', name: 'ProfileNotifier');
      state = state.copyWith(
        errorMessage: 'Failed to pick image. Please try again.',
      );
    }
  }

  Future<void> _uploadPicture(File imageFile) async {
    state = state.copyWith(
      isUploadingPicture: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await _dio.patch(
        'api/v1/profile/',
        data: formData,
      );

      final updated = UserModel.fromJson(response.data as Map<String, dynamic>);
      ref.read(authProvider.notifier).syncUser(updated);

      state = state.copyWith(
        isUploadingPicture: false,
        profile: updated,
        successMessage: 'Profile picture updated!',
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isUploadingPicture: false,
        errorMessage: _extractErrorMessage(e, 'Failed to upload picture.'),
      );
    } catch (e) {
      developer.log('_uploadPicture unexpected error: $e',
          name: 'ProfileNotifier');
      state = state.copyWith(
        isUploadingPicture: false,
        errorMessage: 'An unexpected error occurred.',
      );
    }
  }

  // ─── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await ref.read(authProvider.notifier).logout();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }

  String _extractErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data == null) return e.message ?? fallback;
    if (data is! Map) return data.toString();
    return data['detail']?.toString() ??
        data['error']?.toString() ??
        data['message']?.toString() ??
        fallback;
  }
}
