import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../auth/auth_provider.dart';
import '../../utils/dio_client.dart';

part 'teacher_dashboard_provider.freezed.dart';
part 'teacher_dashboard_provider.g.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

@freezed
abstract class CourseAllocation with _$CourseAllocation {
  const factory CourseAllocation({
    required String id,
    required String code,
    required String title,
    required String schedule,
  }) = _CourseAllocation;

  factory CourseAllocation.fromJson(Map<String, dynamic> json) =>
      _$CourseAllocationFromJson(json);
}

// ─── State ───────────────────────────────────────────────────────────────────

@freezed
abstract class TeacherDashboardState with _$TeacherDashboardState {
  const factory TeacherDashboardState({
    @Default([]) List<CourseAllocation> courses,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _TeacherDashboardState;
}

// ─── Provider ────────────────────────────────────────────────────────────────

final teacherDashboardProvider =
    NotifierProvider<TeacherDashboardNotifier, TeacherDashboardState>(
  TeacherDashboardNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

class TeacherDashboardNotifier extends Notifier<TeacherDashboardState> {
  @override
  TeacherDashboardState build() {
    // Kick off course fetch when provider is first read
    Future.microtask(() => fetchCourses());
    return const TeacherDashboardState();
  }

  Dio get _dio => ref.read(dioProvider);

  /// Fetches the teacher's assigned course allocations from the backend.
  Future<void> fetchCourses() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _dio.get('api/v1/teacher/courses/');
      final list = response.data as List;

      final courses = list
          .map((item) =>
              CourseAllocation.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(isLoading: false, courses: courses);
    } on DioException catch (e) {
      developer.log('fetchCourses DioException: $e',
          name: 'TeacherDashboardNotifier');
      state = state.copyWith(
        isLoading: false,
        errorMessage: _extractErrorMessage(e, 'Failed to load courses.'),
      );
    } catch (e) {
      developer.log('fetchCourses unexpected error: $e',
          name: 'TeacherDashboardNotifier');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred.',
      );
    }
  }

  /// Logs the teacher out.
  Future<void> logout() async {
    await ref.read(authProvider.notifier).logout();
  }

  String _extractErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data == null) return e.message ?? fallback;
    if (data is! Map) return data.toString();
    return data['detail']?.toString() ??
        data['error']?.toString() ??
        fallback;
  }
}
