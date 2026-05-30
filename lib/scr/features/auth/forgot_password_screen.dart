import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/custom_text_field.dart';
import '../../utils/dio_client.dart';


//simple , localization state provider for button loading animation

final forgotPasswordLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

class ForgotPasswordScreen extends ConsumerWidget {
  ForgotPasswordScreen({super.key});

  final  _formKey =  GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _handleReset(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    final loadingNotifier = ref.read(forgotPasswordLoadingProvider.notifier);
    loadingNotifier.state = true;

    try {
      final dio = ref.read(dioProvider);

      // Hit your clean Django rest-auth endpoint
      await dio.post('auth/password-reset/', data: {
        'email': _emailController.text.trim(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reset link sent! Check your institutional inbox."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      if (context.mounted) {
        final errorMsg = e.response?.data['detail'] ?? "Failed to request reset.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } finally {
      loadingNotifier.state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(forgotPasswordLoadingProvider);

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your institutional email registered with uLearning to receive recovery steps.",
                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 32),

                // Using your project's custom text field widget
                CustomTextField(
                  controller: _emailController,

                  hintText: "e.g., lecturer@ulearning.edu.ng",
                  labelText: "Institutional Email",
                  prefixIcon: const Icon(Icons.alternate_email_rounded, size: 20),

                  validator: (value) => (value == null || !value.contains('@'))
                      ? "Please enter a valid institutional email"
                      : null,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _handleReset(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Send Reset Link", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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