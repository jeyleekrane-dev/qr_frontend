// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import 'package:google_fonts/google_fonts.dart';
// import '../../common_widgets/custom_text_field.dart';
// import 'auth_provider.dart';
// import 'auth_state.dart';

// // class _LoginScreenState extends ConsumerState<LoginScreen> {
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();

// //   @override
// //   void dispose() {
// //     _emailController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final authState = ref.watch(authProvider);

// //     // Riverpod listeners must be defined right at the start of build, 
// //     // cleanly executing side effects out of the widget tree return path.
// //     ref.listen<AuthState>(authProvider, (previous, next) {
// //       final prevToken = previous?.token;
// //       final nextToken = next.token;

// //       // 1. SUCCESS LOGIC
// //       if (prevToken == null && nextToken != null) {
// //         if (!context.mounted) return;

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Login successful 🎉'),
// //             backgroundColor: Colors.green,
// //           ),
// //         );

// //         // Safe frame execution: Navigate immediately after the frame completes rendering
// //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //           if (context.mounted) context.go('/home');
// //         });
// //         return;
// //       }

// //       // 2. FAILURE LOGIC
// //       final nextError = next.errorMessage;
// //       if (nextError != null && nextError != previous?.errorMessage) {
// //         if (!context.mounted) return;

// //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //           if (context.mounted) {
// //             // Clears any sticking snackbars before firing the new error
// //             ScaffoldMessenger.of(context).clearSnackBars();
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               SnackBar(
// //                 content: Text(nextError),
// //                 backgroundColor: Colors.redAccent,
// //               ),
// //             );
// //           }
// //         });
// //       }
// //     });

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.symmetric(horizontal: 24.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const SizedBox(height: 60),
// //               Text(
// //                 'Welcome Back Hassan! 👋',
// //                 style: GoogleFonts.poppins(
// //                   fontSize: 28,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black87,
// //                 ),
// //               ),
// //               Text(
// //                 'Log in to your Enterprise Attendance Account',
// //                 style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
// //               ),
// //               const SizedBox(height: 40),

// //               CustomTextField(
// //                 label: 'Email Address',
// //                 icon: Icons.alternate_email_rounded,
// //                 controller: _emailController,
// //               ),
// //               const SizedBox(height: 20),
// //               CustomTextField(
// //                 label: 'Password',
// //                 icon: Icons.lock_outline_rounded,
// //                 controller: _passwordController,
// //                 isPassword: true,
// //               ),

// //               const SizedBox(height: 12),
// //               Align(
// //                 alignment: Alignment.centerRight,
// //                 child: TextButton(
// //                   onPressed: () {},
// //                   child: const Text('Forgot Password?'),
// //                 ),
// //               ),
// //               const SizedBox(height: 30),

// //               // Login Button with Loading State
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 56,
// //                 child: ElevatedButton(
// //                   onPressed: authState.isLoading ? null : _handleLogin,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.blueAccent,
// //                     foregroundColor: Colors.white,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(16),
// //                     ),
// //                     elevation: 0,
// //                   ),
// //                   child: authState.isLoading
// //                       ? const SizedBox(
// //                           height: 24,
// //                           width: 24,
// //                           child: CircularProgressIndicator(
// //                             color: Colors.white,
// //                             strokeWidth: 2.5,
// //                           ),
// //                         )
// //                       : Text(
// //                           'Sign In',
// //                           style: GoogleFonts.inter(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                 ),
// //               ),

// //               const SizedBox(height: 24),
// //               Center(
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Text("Don't have an account? "),
// //                     GestureDetector(
// //                       onTap: () => context.go('/register'),
// //                       child: const Text(
// //                         "Register",
// //                         style: TextStyle(
// //                           color: Colors.blueAccent,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void _handleLogin() {
// //     final email = _emailController.text.trim();
// //     final password = _passwordController.text.trim();

// //     if (email.isEmpty || password.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please enter both email and password')),
// //       );
// //       return;
// //     }

// //     ref.read(authProvider.notifier).login(email, password);
// //   }
// // }
// // // class LoginScreen extends ConsumerStatefulWidget {
// // //   const LoginScreen({super.key});

// // //   @override
// // //   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// // // }

// // // class _LoginScreenState extends ConsumerState<LoginScreen> {
// // //   final _emailController = TextEditingController();
// // //   final _passwordController = TextEditingController();

// // //   void dispose() {
// // //     _emailController.dispose();
// // //     _passwordController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final authState = ref.watch(authProvider);

// // //     ref.listen<AuthState>(authProvider, (previous, next) {
// // //       // Show snackbars for success/failure.
// // //       final prevToken = previous?.token;
// // //       final nextToken = next.token;

// // //       // Success: token changes from null -> non-null
// // //       if (prevToken == null && nextToken != null) {
// // //         if (context.mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content: Text('Login successful'),
// // //               backgroundColor: Colors.green,
// // //             ),
// // //           );
// // //         }

// // //         // Navigate after snackbar (ensure snackbar is visible)
// // //         if (!context.mounted) return;
// // //         Future.delayed(const Duration(milliseconds: 300), () {
// // //           if (context.mounted) context.go('/home');
// // //         });
// // //         return;

// // //       }

// // //       // Failure: show error when backend returns it
// // //       final nextError = next.errorMessage;
// // //       if (nextError != null) {
// // //         if (context.mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             SnackBar(
// // //               content: Text(nextError),
// // //               backgroundColor: Colors.redAccent,
// // //             ),
// // //           );
// // //         }
// // //       }
// // //     });

// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       body: SafeArea(
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.symmetric(horizontal: 24.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               const SizedBox(height: 60),
// // //               Text(
// // //                 'Welcome Back Hassan! 👋',
// // //                 style: GoogleFonts.poppins(
// // //                   fontSize: 28,
// // //                   fontWeight: FontWeight.bold,
// // //                   color: Colors.black87,
// // //                 ),
// // //               ),
// // //               Text(
// // //                 'Log in to your Enterprise Attendance Account',
// // //                 style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
// // //               ),
// // //               const SizedBox(height: 40),

// // //               CustomTextField(
// // //                 label: 'Email Address',
// // //                 icon: Icons.alternate_email_rounded,
// // //                 controller: _emailController,
// // //               ),
// // //               const SizedBox(height: 20),
// // //               CustomTextField(
// // //                 label: 'Password',
// // //                 icon: Icons.lock_outline_rounded,
// // //                 controller: _passwordController,
// // //                 isPassword: true,
// // //               ),

// // //               const SizedBox(height: 12),
// // //               Align(
// // //                 alignment: Alignment.centerRight,
// // //                 child: TextButton(
// // //                   onPressed: () {},
// // //                   child: const Text('Forgot Password?'),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 30),

// // //               // Login Button with Loading State
// // //               SizedBox(
// // //                 width: double.infinity,
// // //                 height: 56,
// // //                 child: ElevatedButton(
// // //                   onPressed: authState.isLoading ? null : () => _handleLogin(),
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: Colors.blueAccent,
// // //                     foregroundColor: Colors.white,
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(16),
// // //                     ),
// // //                     elevation: 0,
// // //                   ),
// // //                   child: authState.isLoading
// // //                       ? const CircularProgressIndicator(color: Colors.white)
// // //                       : Text(
// // //                           'Sign In',
// // //                           style: GoogleFonts.inter(
// // //                             fontSize: 16,
// // //                             fontWeight: FontWeight.bold,
// // //                           ),
// // //                         ),
// // //                 ),
// // //               ),

// // //               const SizedBox(height: 24),
// // //               Center(
// // //                 child: Row(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     const Text("Don't have an account? "),
// // //                     GestureDetector(
// // //                       onTap: () {
// // //                         GoRouter.of(context).go('/register');
// // //                       },
// // //                       child: const Text(
// // //                         "Register",
// // //                         style: TextStyle(
// // //                           color: Colors.blueAccent,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _handleLogin() {
// // //     ref.read(authProvider.notifier).login(
// // //           _emailController.text,
// // //           _passwordController.text,
// // //         );
// // //   }
// // // }



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common_widgets/custom_text_field.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'Welcome Back Hassan! 👋',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Log in to your Enterprise Attendance Account',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),


              CustomTextField(
                label: 'Email Address',
                icon: Icons.alternate_email_rounded,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                controller: _passwordController,
                isPassword: true,
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password flow
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button with Loading State
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Sign In',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        context.go('/register');
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).login(email, password);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful 🎉'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/home');
    } else {
      final msg = ref.read(authProvider).errorMessage ?? 'Login failed';
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

}
