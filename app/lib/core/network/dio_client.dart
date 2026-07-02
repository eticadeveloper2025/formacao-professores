import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.add(AuthInterceptor(dio, ref));
  dio.interceptors.add(_RenderColdStartRetryInterceptor());
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(responseBody: false));
  }
  return dio;
});

/// Interceptor de retry para lidar com o cold start do Render.com (~50s).
/// Tenta a requisição novamente, com timeout estendido, caso ocorra timeout de
/// conexão ou de recebimento na primeira tentativa.
class _RenderColdStartRetryInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isTimeout = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout;
    final alreadyRetried = err.requestOptions.extra['_retried'] == true;

    if (isTimeout && !alreadyRetried) {
      try {
        final retryDio = Dio(BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 90),
          receiveTimeout: const Duration(seconds: 90),
        ));
        final response = await retryDio.request<dynamic>(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            extra: {...err.requestOptions.extra, '_retried': true},
          ),
        );
        handler.resolve(response);
        return;
      } catch (_) {
        // Retry também falhou — propaga o erro original
      }
    }
    handler.next(err);
  }
}
