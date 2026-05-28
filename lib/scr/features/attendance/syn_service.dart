import 'package:hive_flutter/hive_flutter.dart';
import 'attendance_service.dart';
import 'offline_scan_model.dart';

class SyncService {
  final AttendanceService _attendanceService;
  SyncService(this._attendanceService);

  Future<void> syncPendingScans() async {
    final box = Hive.box<OfflineScan>('pending_scans');
    final List<OfflineScan> scans = box.values.toList();

    for (var scan in scans) {
      try {
        await _attendanceService.submitScan(
          qrToken: scan.qrToken,
          sessionId: scan.sessionId,
          // Note: Add manual timestamp/lat/lng to your service 
          // to ensure the backend uses the ORIGINAL scan data.
        );
        // If successful, delete from local storage
        await scan.delete();
      } catch (e) {
        // If it fails (still no internet), skip and try the next one
        continue;
      }
    }
  }
}