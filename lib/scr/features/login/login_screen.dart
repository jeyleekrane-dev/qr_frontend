import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_frontend/scr/common_widgets/custom_text_field.dart';
import 'package:qr_frontend/scr/utils/time_helper_funtion.dart';
import '../auth/auth_provider.dart';
import 'login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Handler ───────────────────────────────────────────────────────────────

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(loginProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    if (success) {
      messenger.showSnackBar(_successSnackBar());
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      context.go('/home');
    } else {
      final msg =
          ref.read(loginProvider).errorMessage ?? 'Login failed.';
      messenger.showSnackBar(_errorSnackBar(msg));
    }
  }

  // ─── Snackbar Builders ─────────────────────────────────────────────────────

  SnackBar _successSnackBar() => SnackBar(
        content: Text(
          'Welcome back! Login successful 🎉',
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

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      loginProvider.select((s) => s.isLoading),
    );

    // Greet with first name if already in auth state (e.g. returning user)
    final firstName = ref.watch(
      authProvider.select((s) => s.user?.firstName ?? ''),
    );

    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIconAccent(),
                  const SizedBox(height: 24),
                  _buildHeader(firstName),
                  const SizedBox(height: 36),
                  _buildFormCard(),
                  const SizedBox(height: 14),
                  _buildForgotPassword(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(isLoading),
                  const SizedBox(height: 32),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── UI Sections ───────────────────────────────────────────────────────────

  Widget _buildIconAccent() => Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff2563eb), Color(0xff3b82f6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff2563eb).withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.fingerprint, color: Colors.white, size: 28),
      );

  Widget _buildHeader(String firstName) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${getTimeBasedGreeting()} ${firstName.isNotEmpty ? firstName : ''}! 👋'
                .trim(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: const Color(0xff0f172a),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Log in to your Enterprise Attendance Account',
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
            CustomTextField(
              label: 'Email Address',
              icon: Icons.alternate_email_rounded,
              controller: _emailController,
              hintText: 'you@university.edu',
              onChange: (_) =>
                  ref.read(loginProvider.notifier).clearStatus(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email address';
                }
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
                  ref.read(loginProvider.notifier).clearStatus(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
            ),
          ],
        ),
      );

  Widget _buildForgotPassword() => Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => context.go('/forget_password'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xff2563eb),
            splashFactory: NoSplash.splashFactory,
          ),
          child: Text(
            'Forgot Password?',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  Widget _buildSubmitButton(bool isLoading) => SizedBox(
        width: double.infinity,
        height: 56,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isLoading
                ? null
                : const LinearGradient(
                    colors: [Color(0xff1e40af), Color(0xff2563eb)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            boxShadow: isLoading
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xff2563eb).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleLogin,
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
                    'Sign In',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      );

  Widget _buildFooter() => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xff64748b),
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/register'),
              child: Text(
                'Register',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xff2563eb),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
}
