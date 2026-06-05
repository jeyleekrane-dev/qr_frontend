import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/auth_provider.dart';
import '../auth/user_model.dart';
import 'teacher_dashboard_provider.dart';

class TeacherDashboard extends ConsumerWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider.select((s) => s.user));
    final state = ref.watch(teacherDashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: _buildAppBar(context, ref, user),
      body: _buildBody(context, ref, state, user),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────

  AppBar _buildAppBar(BuildContext context, WidgetRef ref, user) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Console',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      );

  // ─── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TeacherDashboardState state,
    user,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return _buildErrorState(ref, state.errorMessage!);
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildGreeting(user),
        const SizedBox(height: 32),
        _buildSectionLabel('Active Allocations'),
        const SizedBox(height: 16),
        if (state.courses.isEmpty)
          _buildEmptyState()
        else
          ...state.courses.map(
            (course) => _CourseCard(
              course: course,
              onGenerateQr: () => _handleGenerateQr(context, course),
            ),
          ),
      ],
    );
  }

  // ─── Greeting ──────────────────────────────────────────────────────────────

  Widget _buildGreeting(UserModel? user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: GoogleFonts.inter(
              color: const Color(0xff64748b),
              fontSize: 15,
            ),
          ),
          Text(
            'Dr. ${user?.lastName ?? 'Lecturer'}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: const Color(0xff0f172a),
            ),
          ),
        ],
      );

  Widget _buildSectionLabel(String label) => Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xff0f172a),
        ),
      );

  // ─── States ────────────────────────────────────────────────────────────────

  Widget _buildEmptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              const Icon(Icons.menu_book_rounded,
                  size: 48, color: Color(0xffcbd5e1)),
              const SizedBox(height: 16),
              Text(
                'No courses allocated yet.',
                style: GoogleFonts.inter(color: const Color(0xff64748b)),
              ),
            ],
          ),
        ),
      );

  Widget _buildErrorState(WidgetRef ref, String message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
                onPressed: () => ref
                    .read(teacherDashboardProvider.notifier)
                    .fetchCourses(),
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Retry', style: GoogleFonts.inter()),
              ),
            ],
          ),
        ),
      );

  // ─── Handlers ──────────────────────────────────────────────────────────────

  void _handleGenerateQr(BuildContext context, CourseAllocation course) {
    // Navigate to QR generation screen, passing course id
    context.push('/teacher/generate-qr', extra: course);
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Log Out',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.inter(color: const Color(0xff64748b)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: const Color(0xff64748b)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Log Out',
              style: GoogleFonts.inter(
                color: const Color(0xffef4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(teacherDashboardProvider.notifier).logout();
      if (context.mounted) context.go('/login');
    }
  }
}

// ─── Course Card Widget ───────────────────────────────────────────────────────

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.course,
    required this.onGenerateQr,
  });

  final CourseAllocation course;
  final VoidCallback onGenerateQr;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffe2e8f0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course code badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xffe0e7ff),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    course.code,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2563eb),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff0f172a),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: Color(0xff94a3b8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      course.schedule,
                      style: GoogleFonts.inter(
                        color: const Color(0xff94a3b8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // QR generate button
          GestureDetector(
            onTap: onGenerateQr,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffe0e7ff),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                color: Color(0xff2563eb),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
