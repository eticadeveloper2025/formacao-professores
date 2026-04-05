import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final Ref ref;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthInterceptor(this.dio, this.ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppConfig.tokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _storage.read(key: AppConfig.refreshTokenKey);
        if (refreshToken != null) {
          final response = await dio.post('/auth/refresh', data: {
            'refreshToken': refreshToken,
          });
          final newToken = response.data['data']['accessToken'];
          await _storage.write(key: AppConfig.tokenKey, value: newToken);

          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await dio.fetch(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (_) {
        await _storage.deleteAll();
      }
    }
    handler.next(err);
  }
}
