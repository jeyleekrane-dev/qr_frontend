import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/storage_provider.dart';


final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: (dotenv.get('API_BASE_URL').trim()).replaceAll(RegExp(r'/+$'), '') + '/',

      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  // Debugging Network Logger
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  );

  // Automated JWT & Token Management Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Read your secure storage provider
        final storage = ref.read(storageProvider);
        final token = await storage.read(key: 'access_token');

        // 2. Inject the JWT token automatically into every backend request
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // 3. Handle Unauthorized/Expired Sessions (Crucial for live classroom security)
        if (e.response?.statusCode == 401) {
          // If the backend says the token is invalid, log the user out safely
          // logout handled by UI/provider layer to avoid circular dependency
          // ref.read(authProvider.notifier).logout();
        }
        return handler.next(e);
      },
    ),
  );


  return dio;
});
