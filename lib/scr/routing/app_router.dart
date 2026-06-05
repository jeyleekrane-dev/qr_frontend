import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_frontend/scr/features/auth/auth_provider.dart';
import 'package:qr_frontend/scr/utils/dio_client.dart';

import 'package:qr_frontend/scr/features/home/home_screen.dart';
import 'package:qr_frontend/scr/features/notifications/notification_screen.dart';
import 'package:qr_frontend/scr/features/profile/profile_screen.dart';
import 'package:qr_frontend/scr/features/attendance/scanner_screen.dart';
import 'package:qr_frontend/scr/features/attendance/qr_display_screen.dart';
import 'package:qr_frontend/scr/features/teachers/teacher_dashboard_provider.dart';
import '../features/history/attendance_history_screen.dart';

import '../features/forget_password/forgot_password_screen.dart';
import '../features/login/login_screen.dart';
import '../features/register/register_screen.dart';
import '../features/splash_screen/splash_screen.dart';
import 'main_wrapper.dart';

// ─── Bridge: Riverpod → GoRouter refreshListenable ──────────────────────────

/// A [ChangeNotifier] that fires whenever [authProvider] state changes.
/// This tells GoRouter to re-evaluate its [redirect] callback.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) {
      notifyListeners();
    });
  }
}

// ─── Navigator Keys ─────────────────────────────────────────────────────────

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorHistoryKey = GlobalKey<NavigatorState>(
  debugLabel: 'history',
);
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'profile',
);

// ─── Router Provider ────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authChangeNotifier = AuthChangeNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authChangeNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final bool isLoggedIn = authState.token != null;
      final bool isGoingToAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forget_password';
      final bool isOnSplash = state.matchedLocation == '/splash';

      // 1. If NOT logged in, restrict traffic to auth/splash screens
      if (!isLoggedIn) {
        if (!isGoingToAuth && !isOnSplash) {
          return '/login'; // Force them to login page
        }
        return null; // Let them stay on login, register, splash, or forgot password
      }

      // 2. If LOGGED IN, kick them away from auth/splash screens
      if (isLoggedIn && (isGoingToAuth || isOnSplash)) {
        return '/home';
      }

      // Fallthrough: allow navigation to proceed to regular dashboard routes
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Bottom Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainWrapper(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHistoryKey,
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const AttendanceHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Screen that opens OVER the navigation bar (like the Scanner)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/scanner',
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/teacher/generate-qr',
        builder: (context, state) {
          final course = state.extra as CourseAllocation;
          return _TeacherQrLauncherScreen(course: course);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/forget_password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
    ],
  );
});

// ─── Teacher QR Session Launcher ─────────────────────────────────────────────

/// Intermediate screen: creates a session on the backend for the
/// selected course, then pushes to [QrDisplayScreen].
class _TeacherQrLauncherScreen extends ConsumerStatefulWidget {
  final CourseAllocation course;
  const _TeacherQrLauncherScreen({required this.course});

  @override
  ConsumerState<_TeacherQrLauncherScreen> createState() =>
      _TeacherQrLauncherScreenState();
}

class _TeacherQrLauncherScreenState
    extends ConsumerState<_TeacherQrLauncherScreen> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get teacher's current location for the geofence center
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final dio = ref.read(dioProvider);

      final response = await dio.post('attendance/sessions/', data: {
        'title': '${widget.course.code} — ${widget.course.title}',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'radius_meters': 100.0,
      });

      final session = response.data as Map<String, dynamic>;

      if (!mounted) return;
      // Replace this screen with the QR display
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QrDisplayScreen(
            sessionId: session['id'].toString(),
            initialToken: session['qr_token'] as String,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Failed to start session: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Starting ${widget.course.code}'),
      ),
      body: Center(
        child: _isLoading
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Creating session & fetching location...'),
                ],
              )
            : _error != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _startSession,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
      ),
    );
  }
}
