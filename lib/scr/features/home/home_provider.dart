import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import '../auth/auth_provider.dart';

part 'home_provider.freezed.dart';

// ─── State ───────────────────────────────────────────────────────────────────

enum LocationStatus { idle, granted, denied }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(LocationStatus.idle) LocationStatus locationStatus,
    @Default(false) bool isCheckingPermission,
    String? resolvedProfilePicUrl,
  }) = _HomeState;
}

// ─── Provider ────────────────────────────────────────────────────────────────

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

// ─── Notifier ────────────────────────────────────────────────────────────────

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    _resolveProfilePicUrl();
    return const HomeState();
  }

  /// Builds the full profile picture URL from env + relative path.
  void _resolveProfilePicUrl() {
    final user = ref.read(authProvider).user;
    final rawPath = user?.profilePicture;
    if (rawPath == null || rawPath.isEmpty) return;

    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final url = rawPath.startsWith('http')
        ? rawPath
        : '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/'
            '${rawPath.replaceAll(RegExp(r'^/+'), '')}';

    state = state.copyWith(resolvedProfilePicUrl: url);
  }

  /// Checks location permission and returns whether navigation should proceed.
  Future<bool> checkLocationPermission() async {
    state = state.copyWith(isCheckingPermission: true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final granted = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;

      state = state.copyWith(
        isCheckingPermission: false,
        locationStatus: granted ? LocationStatus.granted : LocationStatus.denied,
      );

      return granted;
    } catch (e) {
      developer.log('checkLocationPermission failed: $e', name: 'HomeNotifier');
      state = state.copyWith(
        isCheckingPermission: false,
        locationStatus: LocationStatus.denied,
      );
      return false;
    }
  }

  /// Logs the user out via auth provider.
  Future<void> logout() async {
    await ref.read(authProvider.notifier).logout();
  }
}
