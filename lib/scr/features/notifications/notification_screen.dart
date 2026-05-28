import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'notifications_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dummy data for now - link this to your backend later
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'New Attendance Session',
      body: 'Dr. Kunle has started attendance for CSC 401 in Hall B.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    AppNotification(
      id: '2',
      title: 'Attendance Marked',
      body: 'Your attendance for GST 101 has been successfully recorded.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _notifications.clear()),
              child: const Text("Clear All", style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return _buildNotificationCard(item);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No notifications yet", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification item) {
    return Container(
      decoration: BoxDecoration(
        color: item.isRead ? Colors.white : Colors.blue.shade50.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.isRead ? Colors.grey.shade200 : Colors.blue.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: item.isRead ? Colors.grey.shade100 : Colors.blueAccent,
          child: Icon(
            item.title.contains('Attendance') ? Icons.school : Icons.info_outline,
            color: item.isRead ? Colors.grey : Colors.white,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.body),
            const SizedBox(height: 8),
            Text(
              DateFormat('hh:mm a').format(item.timestamp),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}