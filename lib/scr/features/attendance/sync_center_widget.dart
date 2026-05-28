import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'offline_scan_model.dart';
// Import your sync service here later
// import 'sync_service.dart';

class SyncCenterWidget extends StatelessWidget {
  const SyncCenterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This builder listens to the 'pending_scans' box in real-time
    return ValueListenableBuilder(
      valueListenable: Hive.box<OfflineScan>('pending_scans').listenable(),
      builder: (context, Box<OfflineScan> box, _) {
        // If there are no offline scans, this widget occupies zero space
        if (box.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.cloud_off_rounded,
                  color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${box.length} Scans Pending",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      "Waiting for network connection...",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your sync trigger here
                  // ref.read(syncServiceProvider).syncPendingScans();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("SYNC"),
              ),
            ],
          ),
        );
      },
    );
  }
}
