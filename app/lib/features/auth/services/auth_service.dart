import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/app_config.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService(this._dio);

  Future<User> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    final data = response.data['data'];
    await _storage.write(key: AppConfig.tokenKey, value: data['accessToken']);
    await _storage.write(key: AppConfig.refreshTokenKey, value: data['refreshToken']);
    return User.fromJson(data['user']);
  }

  Future<User> register(RegisterRequest request) async {
    final response = await _dio.post('/auth/register', data: request.toJson());
    final data = response.data['data'];
    await _storage.write(key: AppConfig.tokenKey, value: data['accessToken']);
    return User.fromJson(data['user']);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConfig.tokenKey);
    return token != null;
  }
}
