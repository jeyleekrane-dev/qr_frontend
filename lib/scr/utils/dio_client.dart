// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../utils/storage_provider.dart';


// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: (dotenv.get('API_BASE_URL').trim()).replaceAll(RegExp(r'/+$'), '') + '/',

//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//       headers: {
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       },
//     ),
//   );

//   // Debugging Network Logger
//   dio.interceptors.add(
//     LogInterceptor(
//       requestBody: true,
//       responseBody: true,
//     ),
//   );

//   // Automated JWT & Token Management Interceptor
//   dio.interceptors.add(
//     InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         // 1. Read your secure storage provider
//         final storage = ref.read(storageProvider);
//         final token = await storage.read(key: 'access_token');

//         // 2. Inject the JWT token automatically into every backend request
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         return handler.next(options);
//       },
//       onResponse: (response, handler) {
//         return handler.next(response);
//       },
//       onError: (DioException e, handler) async {
//         // 3. Handle Unauthorized/Expired Sessions (Crucial for live classroom security)
//         if (e.response?.statusCode == 401) {

//           // If the backend says the token is invalid, log the user out safely
//           // logout handled by UI/provider layer to avoid circular dependency
//           // ref.read(authProvider.notifier).logout();
//         }
//         return handler.next(e);
//       },
//     ),
//   );


//   return dio;
// });



import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/storage_provider.dart';

/// 1. Dedicated Class for Auth Token Management
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Read the token directly from the injected secure storage instance
    final token = await _storage.read(key: 'access_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle Unauthorized/Expired Sessions
    if (err.response?.statusCode == 401) {
      // Clear the expired token from storage immediately
      await _storage.delete(key: 'access_token');
      
      // TODO: If you want to trigger UI logout without circular dependencies,
      // you can listen to a stream of token changes, or use a global navigation key/event.
    }
    return handler.next(err);
  }
}

/// 2. The Main Dio Provider
final dioProvider = Provider<Dio>((ref) {
  // Watch the storage dependency safely at initialization time
  final storage = ref.watch(storageProvider);

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
  dio.interceptors.add(AuthInterceptor(storage));

  return dio;
});