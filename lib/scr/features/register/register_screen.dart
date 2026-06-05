import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common_widgets/custom_text_field.dart';
import 'register_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // ─── Handler ───────────────────────────────────────────────────────────────

  Future<void> _handleRegister() async {
    // Role is validated inside the notifier, but we show snackbar from UI
    final selectedRole = ref.read(registerProvider).selectedRole;
    if (selectedRole == null) {
      _showSnackBar(_warningSnackBar('Please select a role (Student or Teacher)'));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(registerProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      _showSnackBar(_successSnackBar());
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      context.go('/home');
    } else {
      final msg =
          ref.read(registerProvider).errorMessage ?? 'Registration failed.';
      _showSnackBar(_errorSnackBar(msg));
    }
  }

  // ─── Snackbar Helpers ──────────────────────────────────────────────────────

  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  SnackBar _successSnackBar() => SnackBar(
        content: Text(
          'Account created successfully! 🎉',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xff10b981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  SnackBar _errorSnackBar(String message) => SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xffef4444),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  SnackBar _warningSnackBar(String message) => SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xfff59e0b),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      registerProvider.select((s) => s.isLoading),
    );
    final selectedRole = ref.watch(
      registerProvider.select((s) => s.selectedRole),
    );

    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                _buildBackButton(),
                const SizedBox(height: 24),
                _buildHeader(),
                const SizedBox(height: 30),
                _buildFormCard(),
                const SizedBox(height: 24),
                _buildRoleSectionLabel(),
                const SizedBox(height: 10),
                _buildRoleCards(selectedRole),
                const SizedBox(height: 32),
                _buildSubmitButton(isLoading, selectedRole),
                const SizedBox(height: 24),
                _buildFooter(selectedRole),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── UI Sections ───────────────────────────────────────────────────────────

  Widget _buildBackButton() => GestureDetector(
        onTap: () => context.canPop() ? context.pop() : context.go('/login'),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffe2e8f0), width: 1),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xff0f172a),
          ),
        ),
      );

  Widget _buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Account 🚀',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: const Color(0xff0f172a),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Register your new attendance profile',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xff64748b),
              height: 1.4,
            ),
          ),
        ],
      );

  Widget _buildFormCard() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xffe2e8f0), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0f172a).withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Name row
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'First Name',
                    icon: Icons.person_outline_rounded,
                    controller: _firstNameController,
                    onChange: (_) =>
                        ref.read(registerProvider.notifier).clearStatus(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    label: 'Last Name',
                    icon: Icons.person_outline_rounded,
                    controller: _lastNameController,
                    onChange: (_) =>
                        ref.read(registerProvider.notifier).clearStatus(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email Address',
              icon: Icons.alternate_email_rounded,
              controller: _emailController,
              hintText: 'you@university.edu',
              onChange: (_) =>
                  ref.read(registerProvider.notifier).clearStatus(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              controller: _passwordController,
              isPassword: true,
              onChange: (_) =>
                  ref.read(registerProvider.notifier).clearStatus(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirm Password',
              icon: Icons.lock_outline_rounded,
              controller: _confirmPasswordController,
              isPassword: true,
              onChange: (_) =>
                  ref.read(registerProvider.notifier).clearStatus(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      );

  Widget _buildRoleSectionLabel() => Text(
        'Select Your Role',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xff64748b),
        ),
      );

  Widget _buildRoleCards(String? selectedRole) => Row(
        children: [
          Expanded(
            child: _RoleCard(
              role: 'student',
              title: 'Student',
              icon: Icons.school_outlined,
              color: const Color(0xff2563eb),
              isSelected: selectedRole == 'student',
              onTap: () =>
                  ref.read(registerProvider.notifier).selectRole('student'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _RoleCard(
              role: 'teacher',
              title: 'Teacher',
              icon: Icons.assignment_ind_outlined,
              color: const Color(0xff7c3aed),
              isSelected: selectedRole == 'teacher',
              onTap: () =>
                  ref.read(registerProvider.notifier).selectRole('teacher'),
            ),
          ),
        ],
      );

  Widget _buildSubmitButton(bool isLoading, String? selectedRole) {
    final isTeacher = selectedRole == 'teacher';
    final activeColors = isTeacher
        ? [const Color(0xff6d28d9), const Color(0xff7c3aed)]
        : [const Color(0xff1e40af), const Color(0xff2563eb)];
    final shadowColor =
        isTeacher ? const Color(0xff7c3aed) : const Color(0xff2563eb);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isLoading
              ? null
              : LinearGradient(
                  colors: activeColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: shadowColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _handleRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            disabledBackgroundColor: const Color(0xffcbd5e1),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Sign Up',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFooter(String? selectedRole) => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xff64748b),
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/login'),
              child: Text(
                'Sign In',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: selectedRole == 'teacher'
                      ? const Color(0xff7c3aed)
                      : const Color(0xff2563eb),
                ),
              ),
            ),
          ],
        ),
      );
}

// ─── Role Card Widget (extracted as its own stateless widget) ─────────────────

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String role;
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xffe2e8f0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? color : const Color(0xff94a3b8),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : const Color(0xff64748b),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
