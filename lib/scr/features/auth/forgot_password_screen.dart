import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common_widgets/custom_text_field.dart';
import '../../utils/dio_client.dart';

/// Localized loading state for the forgot password screen.
final forgotPasswordLoadingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

/// Forgot Password Screen — converted to ConsumerStatefulWidget so that
/// TextEditingController and GlobalKey<FormState> are properly disposed.
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

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final loadingNotifier = ref.read(forgotPasswordLoadingProvider.notifier);
    loadingNotifier.state = true;

    try {
      final dio = ref.read(dioProvider);

      await dio.post('api/v1/password-reset/', data: {
        'email': _emailController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reset link sent! Check your institutional inbox.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xff10b981),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;
      String errorMsg = 'Failed to request reset.';
      if (data is Map) {
        errorMsg = data['detail']?.toString() ??
            data['error']?.toString() ??
            errorMsg;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMsg,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xffef4444),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) {
        loadingNotifier.state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forgotPasswordLoadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xff0f172a),
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
                // Icon accent
                Container(
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
                        color: const Color(0xfff59e0b).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.lock_reset_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(height: 24),

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
                  'Enter the institutional email registered with your account to receive recovery steps.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xff64748b),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Form card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: const Color(0xffe2e8f0), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff0f172a).withOpacity(0.03),
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
                ),
                const SizedBox(height: 32),

                // Submit button
                SizedBox(
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
                                color: const Color(0xfff59e0b)
                                    .withOpacity(0.3),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}