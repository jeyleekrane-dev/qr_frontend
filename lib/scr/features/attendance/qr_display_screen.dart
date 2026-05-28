import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'teacher_service.dart';
import 'live_monitor_list.dart'; // Ensure this widget is defined to show live attendees
import 'package:url_launcher/url_launcher.dart';

class QrDisplayScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String initialToken;

  const QrDisplayScreen({
    super.key, 
    required this.sessionId, 
    required this.initialToken,
  });

  @override
  ConsumerState<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends ConsumerState<QrDisplayScreen> {
  late String _currentToken;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentToken = widget.initialToken;
    // Refresh the QR every 20 seconds
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) => _refreshToken());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshToken() async {
    try {
      final newToken = await ref.read(teacherServiceProvider).refreshQr(widget.sessionId);
      setState(() => _currentToken = newToken);
    } catch (e) {
      debugPrint("Silent refresh failed: $e");
    }
  }
  // Inside your QrDisplayScreen or a "Session History" screen:
  Future<void> _handleExport() async {
    try {
      final String url = await ref.read(teacherServiceProvider).getExportUrl(widget.sessionId);
      final Uri uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Export failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String qrData = jsonEncode({
      "s": widget.sessionId,
      "t": _currentToken,
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Session'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _handleExport,
            tooltip: 'Export Attendance',
          ),
        ],
      ),
    body: Column(
      children: [
        // Top Section: QR Code
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.grey.shade50,
          child: Column(
            children: [
              QrImageView(
                data: qrData,
                size: 220.0,
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.blueAccent),
              ),
              const SizedBox(height: 10),
              const Text("Students should scan the code above", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        
        // Bottom Section: Live List
        Expanded(
          child: LiveMonitorList(sessionId: widget.sessionId),
        ),
      ],
    ),
  );
}
}