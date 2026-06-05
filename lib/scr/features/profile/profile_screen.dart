import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/user_model.dart';
import 'profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // ─── Prefill form when profile loads ──────────────────────────────────────

  void _prefillControllers(UserModel profile) {
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
  }

  // ─── Handlers ─────────────────────────────────────────────────────────────

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(profileProvider.notifier).updateProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
        );

    if (!mounted) return;

    final state = ref.read(profileProvider);
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    if (success) {
      setState(() => _isEditing = false);
      messenger.showSnackBar(_successSnackBar(
        state.successMessage ?? 'Profile updated!',
      ));
    } else {
      messenger.showSnackBar(_errorSnackBar(
        state.errorMessage ?? 'Update failed.',
      ));
    }
  }

  Future<void> _handleLogout() async {
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
      await ref.read(profileProvider.notifier).logout();
      if (mounted) context.go('/login');
    }
  }

  // ─── Snackbars ─────────────────────────────────────────────────────────────

  SnackBar _successSnackBar(String message) => SnackBar(
        content: Text(message,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xff10b981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  SnackBar _errorSnackBar(String message) => SnackBar(
        content: Text(message,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xffef4444),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);

    // Prefill controllers when profile first loads
    if (state.profile != null && _firstNameController.text.isEmpty) {
      _prefillControllers(state.profile!);
    }

    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: _buildAppBar(state),
      body: state.isLoadingProfile
          ? const Center(child: CircularProgressIndicator())
          : state.profile == null
              ? _buildErrorState()
              : _buildBody(state),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────

  AppBar _buildAppBar(ProfileState state) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xff0f172a),
        title: Text(
          'My Account',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          if (!state.isLoadingProfile && state.profile != null)
            TextButton(
              onPressed: state.isUpdating
                  ? null
                  : () {
                      if (_isEditing) {
                        _handleSave();
                      } else {
                        setState(() => _isEditing = true);
                      }
                    },
              child: state.isUpdating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isEditing ? 'Save' : 'Edit',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff2563eb),
                      ),
                    ),
            ),
        ],
      );

  // ─── Error State ───────────────────────────────────────────────────────────

  Widget _buildErrorState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Color(0xffcbd5e1)),
              const SizedBox(height: 16),
              Text(
                ref.read(profileProvider).errorMessage ??
                    'Failed to load profile.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: const Color(0xff64748b)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(profileProvider.notifier).fetchProfile(),
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Retry', style: GoogleFonts.inter()),
              ),
            ],
          ),
        ),
      );

  // ─── Main Body ─────────────────────────────────────────────────────────────

  Widget _buildBody(ProfileState state) {
    final profile = state.profile!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildAvatarSection(state),
        const SizedBox(height: 24),
        _buildNameAndRole(profile),
        const SizedBox(height: 32),
        _isEditing
            ? _buildEditForm()
            : _buildInfoSection(profile),
        const SizedBox(height: 24),
        _buildMenuSection(),
        const SizedBox(height: 16),
        _buildLogoutTile(),
      ],
    );
  }

  // ─── Avatar ────────────────────────────────────────────────────────────────

  Widget _buildAvatarSection(ProfileState state) {
    final rawPath = state.profile?.profilePicture;
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    String? picUrl;

    if (rawPath != null && rawPath.isNotEmpty) {
      picUrl = rawPath.startsWith('http')
          ? rawPath
          : '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/'
              '${rawPath.replaceAll(RegExp(r'^/+'), '')}';
    }

    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xff2563eb), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff2563eb).withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: const Color(0xffe0e7ff),
              backgroundImage:
                  picUrl != null ? NetworkImage(picUrl) : null,
              child: picUrl == null
                  ? const Icon(Icons.person_rounded,
                      size: 52, color: Color(0xff2563eb))
                  : null,
            ),
          ),

          // Upload button overlay
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: state.isUploadingPicture
                  ? null
                  : () => ref
                      .read(profileProvider.notifier)
                      .pickAndUploadPicture(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xff2563eb),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: state.isUploadingPicture
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.camera_alt_rounded,
                        size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Name & Role ───────────────────────────────────────────────────────────

  Widget _buildNameAndRole(UserModel profile) => Column(
        children: [
          Text(
            profile.fullName.isNotEmpty ? profile.fullName : 'No name set',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xff0f172a),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xff64748b),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: profile.isTeacher
                  ? const Color(0xfff3e8ff)
                  : const Color(0xffe0f2fe),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              profile.role.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: profile.isTeacher
                    ? const Color(0xff7c3aed)
                    : const Color(0xff0284c7),
              ),
            ),
          ),
        ],
      );

  // ─── Info Section (view mode) ──────────────────────────────────────────────

  Widget _buildInfoSection(UserModel profile) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffe2e8f0)),
        ),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: 'First Name',
              value: profile.firstName.isNotEmpty
                  ? profile.firstName
                  : '—',
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: 'Last Name',
              value: profile.lastName.isNotEmpty
                  ? profile.lastName
                  : '—',
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.alternate_email_rounded,
              label: 'Email',
              value: profile.email,
            ),
          ],
        ),
      );

  // ─── Edit Form ─────────────────────────────────────────────────────────────

  Widget _buildEditForm() => Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xff2563eb), width: 1.5),
          ),
          child: Column(
            children: [
              _EditField(
                label: 'First Name',
                controller: _firstNameController,
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _EditField(
                label: 'Last Name',
                controller: _lastNameController,
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              // Cancel button
              TextButton(
                onPressed: () {
                  _prefillControllers(
                      ref.read(profileProvider).profile!);
                  setState(() => _isEditing = false);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: const Color(0xff64748b),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  // ─── Menu Section ──────────────────────────────────────────────────────────

  Widget _buildMenuSection() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffe2e8f0)),
        ),
        child: Column(
          children: [
            _MenuTile(
              icon: Icons.fingerprint,
              title: 'Device Bound',
              subtitle: 'This device is verified',
              onTap: () {},
            ),
            const Divider(height: 1, indent: 56),
            _MenuTile(
              icon: Icons.security_rounded,
              title: 'Privacy Settings',
              subtitle: 'Location shared during scans',
              onTap: () {},
            ),
            const Divider(height: 1, indent: 56),
            _MenuTile(
              icon: Icons.help_outline_rounded,
              title: 'Support',
              subtitle: 'Contact Faculty Admin',
              onTap: () {},
            ),
          ],
        ),
      );

  // ─── Logout ────────────────────────────────────────────────────────────────

  Widget _buildLogoutTile() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffe2e8f0)),
        ),
        child: ListTile(
          onTap: _handleLogout,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xfffef2f2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.logout_rounded,
                color: Color(0xffef4444), size: 20),
          ),
          title: Text(
            'Log Out',
            style: GoogleFonts.inter(
              color: const Color(0xffef4444),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: Color(0xffcbd5e1)),
        ),
      );
}

// ─── Extracted Widgets ────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xff94a3b8)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xff94a3b8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xff0f172a),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.validator,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          color: const Color(0xff94a3b8),
        ),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xff94a3b8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffe2e8f0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffe2e8f0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xff2563eb), width: 1.5),
        ),
        filled: true,
        fillColor: const Color(0xfff8fafc),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xffe0e7ff),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xff2563eb), size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: const Color(0xff0f172a),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xff64748b),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: Color(0xffcbd5e1), size: 20),
    );
  }
}
