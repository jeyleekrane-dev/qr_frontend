import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../attendance/sync_center_widget.dart'; // The offline indicator
import '../attendance/teacher_dashboard.dart';
import '../auth/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _checkPermissionsAndNavigate(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (!context.mounted) return;

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      context.push('/scanner');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("GPS Permission is required to mark attendance.")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final String? rawPicPath = user?.profilePicture;

    final String? profilePicUrl = (rawPicPath != null && rawPicPath.isNotEmpty)
    ? (rawPicPath.startsWith('http') 
        ? rawPicPath 
        : '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/${rawPicPath.replaceAll(RegExp(r'^/+'), '')}')
    : null;
    if (user?.role == 'teacher') {
      return const TeacherDashboard();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Stylish Header
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // This hides the default title center-collapse behavior
              // so our custom background layout takes center stage.
              centerTitle: true,
              title: const Text(
                "Dashboard", // Elegant, minimal title when collapsed
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E3C72), Color(0xFF2A5298)], // Richer, modern deep blue gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20), // Spacing from top
                      // Modern Circular Avatar with a glowing border
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40, // Larger, modern size
                          backgroundColor: Colors.white,
                          // 2. Your updated CircleAvatar properties:
                      backgroundImage: (profilePicUrl != null && profilePicUrl.isNotEmpty)
                          ? NetworkImage(profilePicUrl)
                          : null,

                      // Only display the icon when there is NO valid image profilePicUrl available
                      child: (profilePicUrl == null || profilePicUrl.isEmpty) 
                          ? const Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                        
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Subtitle / Greeting
                      Text(
                        "Welcome back,",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,


                        ),
                      ),
                      const SizedBox(height: 4),
                      // User Email / Name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          user?.email ?? "User Email",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
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
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_outlined),
                    onPressed: () => context.push('/notifications'),
                  ),
                  // The "Red Dot" indicator
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6)),
                      constraints:
                          const BoxConstraints(minWidth: 8, minHeight: 8),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ),

          // 2. Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Show this ONLY if there are offline scans pending
                const SyncCenterWidget(),

                // 3. Attendance Summary Cards
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildStatCard("85%", "Attendance", Colors.green),
                      const SizedBox(width: 12),
                      _buildStatCard("12/15", "Lectures", Colors.orange),
                    ],
                  ),
                ),

                // 4. THE MAIN ACTION: SCAN BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () => _checkPermissionsAndNavigate(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.blue.shade200, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.qr_code_scanner,
                              size: 64, color: Colors.blueAccent),
                          const SizedBox(height: 12),
                          const Text(
                            "TAP TO SCAN ATTENDANCE",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Recent Activity List
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Recent History",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          // 6. List of recent attendance
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text("Course Unit ${index + 1}"),
                subtitle: const Text("Marked at 10:15 AM"),
                trailing: const Icon(Icons.chevron_right),
              ),
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
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
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
