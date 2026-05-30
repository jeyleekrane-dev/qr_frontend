import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';


class TeacherDashboard extends ConsumerWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the active logged-in user profile from our unified authProvider
    final user = ref.watch(authProvider).user;

    final assignedCourses = [
      {"code": "CSC 401", "title": "Compiler Construction", "schedule": "Mon & Wed • 10:00 AM"},
      {"code": "CSC 403", "title": "Artificial Intelligence", "schedule": "Tue & Thu • 02:00 PM"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Console", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new_rounded, color: Colors.redAccent),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Greeting Header
          Text(
            "Welcome back,",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
          Text(
            "Dr. ${user?.lastName ?? 'Lecturer'}",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 32),

          const Text(
            "Active Allocations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),

          // Streamlined Minimal Course Cards
          ...assignedCourses.map((course) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['code']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course['title']!,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(course['schedule']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Clean Circular Trigger Button
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade100,
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.qr_code_2_rounded),
                    onPressed: () {
                      // Hook here directly into TeacherService to initialize the QR generation stream
                    },
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}