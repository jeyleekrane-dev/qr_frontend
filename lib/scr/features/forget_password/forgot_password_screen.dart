import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common_widgets/custom_text_field.dart';
import 'forget_password_provider.dart';


class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ─── Handler ───────────────────────────────────────────────────────────────

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(forgotPasswordProvider.notifier)
        .sendResetLink(_emailController.text.trim());

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    if (success) {
      messenger.showSnackBar(_successSnackBar());
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/login');
      }
    } else {
      final msg = ref.read(forgotPasswordProvider).errorMessage ??
          'Failed to request reset.';
      messenger.showSnackBar(_errorSnackBar(msg));
    }
  }

  // ─── Snackbar Builders ─────────────────────────────────────────────────────

  SnackBar _successSnackBar() => SnackBar(
        content: Text(
          'Reset link sent! Check your institutional inbox. 📩',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xff10b981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
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
      forgotPasswordProvider.select((s) => s.isLoading),
    );

    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xff0f172a),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconAccent(),
                const SizedBox(height: 24),
                _buildHeader(),
                const SizedBox(height: 32),
                _buildFormCard(),
                const SizedBox(height: 32),
                _buildSubmitButton(isLoading),
              ],
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
            colors: [Color(0xfff59e0b), Color(0xfffbbf24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xfff59e0b).withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
            const Icon(Icons.lock_reset_rounded, color: Colors.white, size: 28),
      );

  Widget _buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reset Password',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: const Color(0xff0f172a),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the institutional email registered with your account '
            'to receive recovery steps.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xff64748b),
              height: 1.5,
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
        child: CustomTextField(
          label: 'Institutional Email',
          icon: Icons.alternate_email_rounded,
          controller: _emailController,
          hintText: 'e.g., lecturer@university.edu',
          onChange: (_) => ref.read(forgotPasswordProvider.notifier).clearStatus(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid institutional email';
            }
            return null;
          },
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
                    colors: [Color(0xffd97706), Color(0xfff59e0b)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            boxShadow: isLoading
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xfff59e0b).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleReset,
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
                    'Send Reset Link',
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
