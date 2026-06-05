import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../attendance/sync_center_widget.dart';
import '../teachers/teacher_dashboard.dart';
import '../auth/auth_provider.dart';
import 'home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider.select((s) => s.user));

    // Teacher gets their own dashboard
    if (user?.role == 'teacher') {
      return const TeacherDashboard();
    }

    return const _StudentHomeView();
  }
}

// ─── Student Home ─────────────────────────────────────────────────────────────

class _StudentHomeView extends ConsumerWidget {
  const _StudentHomeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider.select((s) => s.user));
    final profilePicUrl = ref.watch(
      homeProvider.select((s) => s.resolvedProfilePicUrl),
    );
    final isCheckingPermission = ref.watch(
      homeProvider.select((s) => s.isCheckingPermission),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, ref, user, profilePicUrl),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SyncCenterWidget(),
                _buildStatCards(),
                const SizedBox(height: 16),
                _buildScanButton(context, ref, isCheckingPermission),
                const SizedBox(height: 24),
                _buildSectionLabel('Recent History'),
              ],
            ),
          ),
          _buildRecentList(),
        ],
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────

  SliverAppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    user,
    String? profilePicUrl,
  ) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildAvatar(profilePicUrl),
                const SizedBox(height: 10),
                Text(
                  'Welcome back,',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    user?.fullName.isNotEmpty == true
                        ? user!.fullName
                        : user?.email ?? 'User',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        _buildNotificationIcon(context),
        _buildLogoutButton(context, ref),
      ],
    );
  }

  Widget _buildAvatar(String? profilePicUrl) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          backgroundImage:
              profilePicUrl != null ? NetworkImage(profilePicUrl) : null,
          child: profilePicUrl == null
              ? const Icon(Icons.person_rounded, size: 40, color: Colors.grey)
              : null,
        ),
      );

  Widget _buildNotificationIcon(BuildContext context) => Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
            ),
          ),
        ],
      );

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) => IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () => _confirmLogout(context, ref),
      );

  // ─── Logout Confirmation ───────────────────────────────────────────────────

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
      await ref.read(homeProvider.notifier).logout();
      if (context.mounted) context.go('/login');
    }
  }

  // ─── Body Sections ─────────────────────────────────────────────────────────

  Widget _buildStatCards() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _StatCard(value: '85%', label: 'Attendance', color: Colors.green),
            const SizedBox(width: 12),
            _StatCard(value: '12/15', label: 'Lectures', color: Colors.orange),
          ],
        ),
      );

  Widget _buildScanButton(
    BuildContext context,
    WidgetRef ref,
    bool isChecking,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          onTap: isChecking ? null : () => _handleScan(context, ref),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade200, width: 2),
            ),
            child: Column(
              children: [
                isChecking
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.qr_code_scanner,
                        size: 64, color: Colors.blueAccent),
                const SizedBox(height: 12),
                Text(
                  isChecking
                      ? 'Checking Permission...'
                      : 'TAP TO SCAN ATTENDANCE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSectionLabel(String label) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  SliverList _buildRecentList() => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text('Course Unit ${index + 1}'),
            subtitle: const Text('Marked at 10:15 AM'),
            trailing: const Icon(Icons.chevron_right),
          ),
          childCount: 5,
        ),
      );

  // ─── Scan Handler ──────────────────────────────────────────────────────────

  Future<void> _handleScan(BuildContext context, WidgetRef ref) async {
    final granted =
        await ref.read(homeProvider.notifier).checkLocationPermission();

    if (!context.mounted) return;

    if (granted) {
      context.push('/scanner');
    } else {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'GPS permission is required to mark attendance.',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: const Color(0xffef4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
    }
  }
}

// ─── Extracted Stat Card Widget ───────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
