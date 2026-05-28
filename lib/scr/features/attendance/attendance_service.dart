import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../utils/device_helper.dart';
import '../../utils/dio_client.dart';
part 'attendance_service.g.dart';

@riverpod
AttendanceService attendanceService(AttendanceServiceRef ref) { // Fixed Ref type name
  final dio = ref.watch(dioProvider);
  return AttendanceService(dio);
}

class AttendanceService {
  final Dio _dio;
  AttendanceService(this._dio);

  /// 1. Submit a scan to the backend
  Future<Response> submitScan({
    required String qrToken,
    required String sessionId,
  }) async {
    // 1. Get Current Location with a Timeout (important for deep classrooms)
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10), // Prevent infinite loading
      ),
    );

    // 2. Get Unique Hardware ID
    String deviceId = await DeviceHelper.getUniqueId();

    // 3. Post to the Django backend
    return await _dio.post(
      'attendance/scan/',
      data: {
        "qr_token": qrToken,
        "session_id": sessionId,
        "lat": position.latitude,
        "lng": position.longitude,
        "device_id": deviceId,
        "captured_at": DateTime.now().toIso8601String(), // Good for offline sync tracking
      },
    );
  }

  /// 2. Fetch History (Now properly placed outside submitScan)
  Future<List<dynamic>> getAttendanceHistory() async {
    try {
      final response = await _dio.get('attendance/my-history/');
      // Ensure we return a List even if data is null
      return response.data as List<dynamic>? ?? [];
    } on DioException {
      // Handle 401 (Unauthorized) or 404 specifically if needed
      rethrow;
    }
  }
}