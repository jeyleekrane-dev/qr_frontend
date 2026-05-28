import 'package:hive/hive.dart';

// part 'offline_scan_model.g.dart';

@HiveType(typeId: 1)
class OfflineScan extends HiveObject {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final String qrToken;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final double lat;

  @HiveField(4)
  final double lng;

  OfflineScan({
    required this.sessionId,
    required this.qrToken,
    required this.timestamp,
    required this.lat,
    required this.lng,
  });
}