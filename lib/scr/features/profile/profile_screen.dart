import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text("My Account"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "${user?.firstName} ${user?.lastName}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Center(child: Text(user?.email ?? "student@ulearning.edu.ng", style: const TextStyle(color: Colors.grey))),
          const SizedBox(height: 32),
          
          _buildProfileTile(Icons.fingerprint, "Device Bound", "Infinix Note 30 (Verified)"),
          _buildProfileTile(Icons.security, "Privacy Settings", "Location shared during scans"),
          _buildProfileTile(Icons.help_outline, "Support", "Contact Faculty Admin"),
          
          const Divider(height: 40),
          
          ListTile(
            onTap: () => ref.read(authProvider.notifier).logout(),
            leading: const Icon(Icons.logout, color: Colors.lightBlueAccent),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}