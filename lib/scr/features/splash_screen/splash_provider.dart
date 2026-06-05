import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../auth/auth_provider.dart';

part 'splash_provider.freezed.dart';

// ─── State ───────────────────────────────────────────────────────────────────

enum SplashStatus { loading, authenticated, unauthenticated }

@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    @Default(SplashStatus.loading) SplashStatus status,
  }) = _SplashState;
}

// ─── Provider ────────────────────────────────────────────────────────────────

final splashProvider = NotifierProvider<SplashNotifier, SplashState>(
  SplashNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

class SplashNotifier extends Notifier<SplashState> {
  @override
  SplashState build() => const SplashState();

  /// Runs the bootstrap sequence:
  /// 1. Enforces minimum splash display time.
  /// 2. Checks stored auth token.
  /// 3. Resolves to [authenticated] or [unauthenticated].
  Future<SplashStatus> bootstrap() async {
    // Minimum brand impression time
    await Future.delayed(const Duration(milliseconds: 1200));

    try {
      await ref
          .read(authProvider.notifier)
          .checkAuthStatus()
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      developer.log('bootstrap checkAuthStatus failed: $e',
          name: 'SplashNotifier');
      // Token check failure is non-critical — fall through to login
    }

    final token = ref.read(authProvider).token;
    final status =
        token != null ? SplashStatus.authenticated : SplashStatus.unauthenticated;

    state = state.copyWith(
      status: status,
    );
    return status;
  }
}
