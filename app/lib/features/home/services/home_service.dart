import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';

final homeServiceProvider = Provider<HomeService>((ref) {
  return HomeService(ref.watch(dioClientProvider));
});

final schoolsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(homeServiceProvider);
  return service.getSchools();
});

class HomeService {
  final Dio _dio;
  HomeService(this._dio);

  Future<List<Map<String, dynamic>>> getSchools() async {
    final response = await _dio.get('/schools');
    final data = response.data['data'] as List;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await _dio.get('/notifications/me');
    final data = response.data['data'] as List;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> markNotificationRead(int id) async {
    await _dio.patch('/notifications/$id/read');
  }
}
