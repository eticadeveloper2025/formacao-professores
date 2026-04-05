import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../models/user_progress.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService(ref.watch(dioClientProvider));
});

class ProgressService {
  final Dio _dio;
  ProgressService(this._dio);

  Future<List<UserProgress>> getMyProgress() async {
    final response = await _dio.get('/progress/me');
    final data = response.data['data'] as List;
    return data.map((e) => UserProgress.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getFormationProgress(int formationId) async {
    final response = await _dio.get('/progress/formation/$formationId');
    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<void> markCompleted(int moduleId) async {
    await _dio.post('/progress', data: {'moduleId': moduleId});
  }
}
