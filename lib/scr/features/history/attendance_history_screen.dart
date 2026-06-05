import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'attendance_history_provider.dart';

class AttendanceHistoryScreen extends ConsumerWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance History',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AttendanceHistoryState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return _buildErrorState(context, ref, state.errorMessage!);
    }

    if (state.records.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildSummaryHeader(state.summary),
        const Divider(),
        Expanded(child: _buildList(state.records)),
      ],
    );
  }

  // ─── States ────────────────────────────────────────────────────────────────

  Widget _buildErrorState(
          BuildContext context, WidgetRef ref, String message) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Color(0xffcbd5e1)),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: const Color(0xff64748b)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(attendanceHistoryProvider.notifier).fetchHistory(),
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Retry', style: GoogleFonts.inter()),
              ),
            ],
          ),
        ),
      );

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_rounded,
                size: 48, color: Color(0xffcbd5e1)),
            const SizedBox(height: 16),
            Text(
              'No attendance records found.',
              style: GoogleFonts.inter(color: const Color(0xff64748b)),
            ),
          ],
        ),
      );

  // ─── Summary ───────────────────────────────────────────────────────────────

  Widget _buildSummaryHeader(AttendanceSummary summary) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(value: summary.percentageLabel, label: 'Total Rate'),
            _StatItem(value: '${summary.presentCount}', label: 'Present'),
            _StatItem(
                value: '${summary.absentCount}', label: 'Absent / Late'),
          ],
        ),
      );

  // ─── List ──────────────────────────────────────────────────────────────────

  Widget _buildList(List<AttendanceRecord> records) => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _HistoryCard(record: records[index]),
      );
}

// ─── Extracted Widgets ────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: record.isPresent
                ? Colors.green.shade50
                : Colors.red.shade50,
            child: Icon(
              record.isPresent ? Icons.check : Icons.close,
              color: record.isPresent ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.courseName,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  record.formattedDate,
                  style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: record.isPresent
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              record.status.toUpperCase(),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: record.isPresent ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
