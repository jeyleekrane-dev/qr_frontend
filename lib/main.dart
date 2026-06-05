import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_frontend/scr/features/attendance/offline_scan_adapter.dart';
import 'package:qr_frontend/scr/features/attendance/offline_scan_model.dart';
import 'package:qr_frontend/scr/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Hive for offline sync
  await Hive.initFlutter();
  Hive.registerAdapter(OfflineScanAdapter());
  await Hive.openBox<OfflineScan>('pending_scans');

  runApp(const ProviderScope(child: ULearningApp()));
}

// We use ConsumerWidget so we can access 'ref'
class ULearningApp extends ConsumerWidget {
  const ULearningApp({super.key});

  static final _rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the routerProvider we created in the routing folder
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'uLearning — QR Attendance',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _rootScaffoldMessengerKey,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      // We remove 'home:' and use 'routerConfig' instead
      routerConfig: router,
    );
  }
}
