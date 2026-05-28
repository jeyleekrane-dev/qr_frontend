import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'teacher_service.dart';
import 'qr_display_screen.dart'; // We'll build this next

class TeacherDashboard extends ConsumerStatefulWidget {
  const TeacherDashboard({super.key});

  @override
  ConsumerState<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends ConsumerState<TeacherDashboard> {
  final _titleController = TextEditingController();
  bool _isLoading = false;

  Future<void> _startSession() async {
    setState(() => _isLoading = true);
    try {
      // 1. Get Teacher's current location to set the center of the geofence
      Position pos = await Geolocator.getCurrentPosition();
      
      // 2. Create session on Backend
      final session = await ref.read(teacherServiceProvider).createSession(
        title: _titleController.text,
        lat: pos.latitude,
        lng: pos.longitude,
      );

      if (mounted) {
        // 3. Navigate to the QR Display Screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QrDisplayScreen(
              sessionId: session['id'],
              initialToken: session['qr_token'],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Class Title (e.g. CSC 201)'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _startSession,
                child: _isLoading 
                  ? const CircularProgressIndicator() 
                  : const Text('Start Attendance Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}