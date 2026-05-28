import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
// import '../features/home/history_screen.dart';
// import '../features/attendance/scanner_screen.dart';
// import '../features/auth/auth_provider.dart';
// import '../features/auth/login_screen.dart';
// import '../features/auth/register_screen.dart';
// import '../features/auth/splash_screen.dart';
// import '../features/home/home_screen.dart';
// import '../features/notifications/notification_screen.dart';
// import '../features/profile/profile_screen.dart';
import 'package:qr_frontend/scr/features/auth/auth_provider.dart';
import 'package:qr_frontend/scr/features/auth/login_screen.dart';
import 'package:qr_frontend/scr/features/auth/register_screen.dart';
import 'package:qr_frontend/scr/features/auth/splash_screen.dart';
import 'package:qr_frontend/scr/features/home/home_screen.dart';
import 'package:qr_frontend/scr/features/history/history_screen.dart';
import 'package:qr_frontend/scr/features/notifications/notification_screen.dart';
import 'package:qr_frontend/scr/features/profile/profile_screen.dart';
import 'package:qr_frontend/scr/features/attendance/scanner_screen.dart';
import 'package:qr_frontend/src/features/attendance/attendance_history_screen.dart';


import 'main_wrapper.dart';



final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorHistoryKey = GlobalKey<NavigatorState>(debugLabel: 'history');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
   redirect: (context, state) {
    // 1. If auth state is still fetching from local storage, keep showing splash
    if (authState.isLoading) return '/splash';
    
    final bool isLoggedIn = authState.token != null;
    final bool isGoingToAuth = state.matchedLocation == '/login' || state.matchedLocation == '/register';

    // 2. If NOT logged in, restrict traffic strictly to auth screens
    if (!isLoggedIn) {
      if (!isGoingToAuth) {
        return '/login'; // Force them to login page
      }
      return null; // Let them stay on login or register
    }

    // 3. If LOGGED IN, kick them away from auth/splash screens and send them to dashboard
    if (isLoggedIn && (isGoingToAuth || state.matchedLocation == '/splash')) {
      return '/home';
    }

    // Fallthrough: allow navigation to proceed to regular dashboard routes (/profile, /history, etc.)
    return null;
  },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      
      // Bottom Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainWrapper(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHistoryKey,
            routes: [GoRoute(path: '/history', builder: (context, state) => const AttendanceHistoryScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen())],
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
  path: '/notifications',
  builder: (context, state) => const NotificationScreen(),
),

    ],
  );
});