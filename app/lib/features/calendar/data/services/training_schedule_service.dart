import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/training_schedule_item.dart';

final trainingScheduleServiceProvider =
    Provider<TrainingScheduleService>((ref) {
  return TrainingScheduleService(ref.watch(dioClientProvider));
});

class TrainingScheduleService {
  final Dio _dio;

  TrainingScheduleService(this._dio);

  Future<List<TrainingScheduleItem>> getTrainingSchedule() async {
    try {
      final response = await _dio.get('/training-schedule');
      final data = response.data['data'] as List;
      return data
          .map((item) =>
              TrainingScheduleItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      throw Exception('Não foi possível carregar o cronograma formativo.');
    }
  }
}
