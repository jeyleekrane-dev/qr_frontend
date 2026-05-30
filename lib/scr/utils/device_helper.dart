import 'package:device_info_plus/device_info_plus.dart';

class DeviceHelper {
  static Future<String> getUniqueId() async {
    final deviceInfo = DeviceInfoPlugin();

    // In web builds, dart:io's Platform is not supported.
    // device_info_plus will still throw for unsupported platforms, so we catch.
    try {
      final android = await deviceInfo.androidInfo;
      // If androidInfo is supported, prefer id.
      return android.id;
    } catch (_) {
      // ignore
    }

    try {
      final ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor ?? 'unknown_ios';
    } catch (_) {
      // ignore
    }

    // Web/other platforms.
    return 'web_or_unknown_device';
  }
}

