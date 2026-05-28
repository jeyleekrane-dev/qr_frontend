import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // To format dates nicely
import '../attendance/attendance_service.dart';


class AttendanceHistoryScreen extends ConsumerWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ref.read(attendanceServiceProvider).getAttendanceHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Error loading history: ${snapshot.error}"));
          }

          final records = snapshot.data ?? [];

          return Column(
            children: [
              _buildSummaryHeader(records),
              const Divider(),
              Expanded(
                child: records.isEmpty
                    ? const Center(child: Text("No attendance records found."))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: records.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return _buildHistoryCard(record);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryHeader(List<dynamic> records) {
    // Calculate simple stats
    int presentCount = records.where((r) => r['status'] == 'present').length;
    double percentage = records.isEmpty ? 0 : (presentCount / records.length) * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("${percentage.toStringAsFixed(0)}%", "Total Rate"),
          _statItem("$presentCount", "Present"),
          _statItem("${records.length - presentCount}", "Absent/Late"),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> record) {
    // Parse the date from Django (e.g., 2026-05-15T10:00:00Z)
    DateTime date = DateTime.parse(record['session_date']);
    String formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: record['status'] == 'present' ? Colors.green.shade50 : Colors.red.shade50,
            child: Icon(
              record['status'] == 'present' ? Icons.check : Icons.close,
              color: record['status'] == 'present' ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['course_name'] ?? "Unknown Course",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Text(
            record['status'].toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: record['status'] == 'present' ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}