import 'package:hive/hive.dart';
import 'offline_scan_model.dart';

class OfflineScanAdapter extends TypeAdapter<OfflineScan> {
  @override
  final int typeId = 1;

  @override
  OfflineScan read(BinaryReader reader) {
    return OfflineScan(
      sessionId: reader.read(),
      qrToken: reader.read(),
      timestamp: reader.read(),
      lat: reader.read(),
      lng: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, OfflineScan obj) {
    writer
      ..write(obj.sessionId)
      ..write(obj.qrToken)
      ..write(obj.timestamp)
      ..write(obj.lat)
      ..write(obj.lng);
  }
}