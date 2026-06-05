import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../attendance/attendance_service.dart';

part 'attendance_history_provider.freezed.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

@freezed
abstract class AttendanceRecord with _$AttendanceRecord {
  const factory AttendanceRecord({
    required String courseName,
    required String status,
    required DateTime sessionDate,
  }) = _AttendanceRecord;

  const AttendanceRecord._();

  /// Formatted date string for display.
  String get formattedDate =>
      DateFormat('MMM dd, yyyy • hh:mm a').format(sessionDate);

  /// Whether the student was present.
  bool get isPresent => status.toLowerCase() == 'present';

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      courseName: json['course_name'] as String? ?? 'Unknown Course',
      status: json['status'] as String? ?? 'absent',
      sessionDate: DateTime.parse(json['session_date'] as String),
    );
  }
}

// ─── Summary Model ────────────────────────────────────────────────────────────

class AttendanceSummary {
  const AttendanceSummary({
    required this.total,
    required this.presentCount,
  });

  final int total;
  final int presentCount;

  int get absentCount => total - presentCount;

  double get percentage =>
      total == 0 ? 0 : (presentCount / total) * 100;

  String get percentageLabel => '${percentage.toStringAsFixed(0)}%';
}

// ─── State ────────────────────────────────────────────────────────────────────

@freezed
abstract class AttendanceHistoryState with _$AttendanceHistoryState {
  const factory AttendanceHistoryState({
    @Default([]) List<AttendanceRecord> records,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AttendanceHistoryState;

  const AttendanceHistoryState._();

  AttendanceSummary get summary => AttendanceSummary(
        total: records.length,
        presentCount: records.where((r) => r.isPresent).length,
      );
}

// ─── Provider ────────────────────────────────────────────────────────────────

final attendanceHistoryProvider =
    NotifierProvider<AttendanceHistoryNotifier, AttendanceHistoryState>(
  AttendanceHistoryNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

class AttendanceHistoryNotifier extends Notifier<AttendanceHistoryState> {
  @override
  AttendanceHistoryState build() {
    // Kick off history fetch when provider is first read
    Future.microtask(() => fetchHistory());
    return const AttendanceHistoryState();
  }

  /// Fetches attendance history from the service.
  Future<void> fetchHistory() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final raw =
          await ref.read(attendanceServiceProvider).getAttendanceHistory();

      final records = raw
          .map((item) =>
              AttendanceRecord.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(isLoading: false, records: records);
    } catch (e) {
      developer.log('fetchHistory failed: $e',
          name: 'AttendanceHistoryNotifier');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load attendance history. Please try again.',
      );
    }
  }
}
