import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    // Kick off bootstrap after first frame so ref is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrapAndNavigate();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  Future<void> _bootstrapAndNavigate() async {
    final status = await ref.read(splashProvider.notifier).bootstrap();
    if (!mounted) return;

    switch (status) {
      case SplashStatus.authenticated:
        context.go('/home');
        break;
      case SplashStatus.unauthenticated:
        context.go('/login');
        break;
      case SplashStatus.loading:
        break;
    }
  }

  // ─── Navigation listener ──────────────────────────────────────────────────

  /// Reacts to [SplashStatus] changes and navigates accordingly.
  /// Called from [ref.listen] inside build — no setState needed.
  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      body: Stack(
        children: [
          _buildLogo(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ─── UI Sections ──────────────────────────────────────────────────────────

  Widget _buildLogo() => Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff2563eb), Color(0xff3b82f6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff2563eb).withValues(alpha: 0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'uLearning',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: const Color(0xff0f172a),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildBottomBar() => Positioned(
        bottom: 50,
        left: 0,
        right: 0,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(
                width: 40,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: Color(0xff2563eb),
                  minHeight: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enterprise Attendance System',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xff94a3b8),
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      );
}
