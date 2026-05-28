import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../utils/dio_client.dart';

part 'teacher_service.g.dart';

@riverpod
TeacherService teacherService(TeacherServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return TeacherService(dio);
}

class TeacherService {
  final Dio _dio;
  TeacherService(this._dio);

  Future<Map<String, dynamic>> createSession({
    required String title,
    required double lat,
    required double lng,
    double radius = 100.0,
  }) async {
    final response = await _dio.post('attendance/sessions/', data: {
      "title": title,
      "latitude": lat,
      "longitude": lng,
      "radius_meters": radius,
    });
    return response.data;
  }

  Future<String> refreshQr(String sessionId) async {
    final response = await _dio.get('attendance/sessions/$sessionId/refresh-qr/');
    return response.data['qr_token'];
  }
  Future<List<dynamic>> getSessionAttendees(String sessionId) async {
  final response = await _dio.get('attendance/sessions/$sessionId/analytics/');
  // Based on our Django backend, this returns a list of student records
  return response.data['attendees'];
  }

  Future<String> getExportUrl(String sessionId) async {
    return "${_dio.options.baseUrl}attendance/sessions/$sessionId/analysis/";
  }
// Add these to your TeacherService class
  Future<List<dynamic>> searchStudents(String query) async {
    final response = await _dio.get('attendance/students/search/', queryParameters: {'q': query});
    return response.data; // List of students matching the search
  }

  Future<void> markManually(String sessionId, String studentId) async {
    await _dio.post('attendance/sessions/$sessionId/manual-mark/', data: {
      'student_id': studentId,
    });
  }



}
