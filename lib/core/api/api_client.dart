import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return ApiClient(prefs: prefs);
});

class ApiClient {
  late final Dio _dio;
  final SharedPreferences _prefs;

  ApiClient({required SharedPreferences prefs}) : _prefs = prefs {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        sendTimeout: ApiEndpoints.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      print('🌐 API Client initialized');
      print('   Base URL: ${ApiEndpoints.baseUrl}');
      print('   Connection Timeout: ${ApiEndpoints.connectionTimeout}');
      print('   Receive Timeout: ${ApiEndpoints.receiveTimeout}');
      print('   Send Timeout: ${ApiEndpoints.sendTimeout}');
    }

    // Add logger first in debug mode for better visibility
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: false,
          maxWidth: 90,
        ),
      );
    }

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor(prefs: _prefs));

    // Auto retry on network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 2),
          Duration(seconds: 3),
          Duration(seconds: 5),
        ],
        retryEvaluator: (error, attempt) {
          // Retry on connection errors and timeouts, not on 4xx/5xx
          if (kDebugMode) {
            print('🔄 Retry attempt $attempt for error: ${error.type}');
            print('   Error message: ${error.message}');
          }
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Test server connectivity
  Future<bool> testConnection() async {
    try {
      if (kDebugMode) {
        print('🔍 Testing connection to: ${ApiEndpoints.baseUrl}');
      }

      final response = await _dio
          .get(
            '/health',
            options: Options(
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw DioException(
                requestOptions: RequestOptions(path: '/health'),
                type: DioExceptionType.connectionTimeout,
                message: 'Server not responding',
              );
            },
          );

      if (kDebugMode) {
        print('✅ Server is reachable: ${response.statusCode}');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Server connection failed:');
        print('   Base URL: ${ApiEndpoints.baseUrl}');
        print('   Error: $e');
        print('   ');
        print('💡 Possible issues:');
        print('   1. Server is not running on ${ApiEndpoints.baseUrl}');
        print('   2. Firewall is blocking the connection');
        print('   3. Wrong IP address configured');
        print('   4. Device and server are on different networks');
      }
      return false;
    }
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      if (kDebugMode) {
        print('🌐 Making GET request to: $path');
      }
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      if (kDebugMode) {
        print('💥 GET request failed for: $path');
        print('   Error: $e');
      }
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      if (kDebugMode) {
        print('🌐 Making POST request to: $path');
      }
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      if (kDebugMode) {
        print('💥 POST request failed for: $path');
        print('   Error: $e');
      }
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Multipart request for file uploads
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.post(
      path,
      data: formData,
      options: options,
      onSendProgress: onSendProgress,
    );
  }
}

// Auth Interceptor to add JWT token to requests
class _AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';
  static const String _requestStartMsKey = 'requestStartMs';

  _AuthInterceptor({required SharedPreferences prefs}) : _prefs = prefs;

  // Endpoints that don't require authentication
  static final _publicEndpoints = ['/auth/login', '/auth/register', '/health'];

  bool _isPublicEndpoint(String path) {
    return _publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.extra[_requestStartMsKey] = DateTime.now().millisecondsSinceEpoch;

    if (kDebugMode) {
      print(
        '🔐 Auth Interceptor: Processing ${options.method} ${options.path}',
      );
    }

    // Skip token check for public endpoints
    if (_isPublicEndpoint(options.path)) {
      if (kDebugMode) {
        print('   ℹ️  Public endpoint - no authentication required');
      }
      handler.next(options);
      return;
    }

    // Read token from SharedPreferences
    final token = _prefs.getString(_tokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      if (kDebugMode) {
        print('   ✓ Token added to request');
      }
    } else if (kDebugMode) {
      print(
        '   ⚠ No token found - request may fail if authentication required',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startedAt = response.requestOptions.extra[_requestStartMsKey] as int?;
    final durationMs = startedAt == null
        ? null
        : DateTime.now().millisecondsSinceEpoch - startedAt;

    if (kDebugMode) {
      print(
        '✅ Response received: ${response.statusCode} for ${response.requestOptions.path}${durationMs == null ? '' : ' (${durationMs}ms)'}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startedAt = err.requestOptions.extra[_requestStartMsKey] as int?;
    final durationMs = startedAt == null
        ? null
        : DateTime.now().millisecondsSinceEpoch - startedAt;

    if (kDebugMode) {
      print('❌ Request Error: ${err.type}');
      print('   URL: ${err.requestOptions.uri}');
      if (durationMs != null) {
        print('   Elapsed: ${durationMs}ms');
      }
      print('   Message: ${err.message}');
      if (err.response != null) {
        print('   Status Code: ${err.response?.statusCode}');
        print('   Response: ${err.response?.data}');
      } else {
        print(
          '   No HTTP response received. The failure happened before server replied (timeout/network/connectivity).',
        );
      }
    }
    handler.next(err);
  }
}
