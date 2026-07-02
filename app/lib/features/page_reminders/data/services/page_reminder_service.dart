import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/page_reminder.dart';

final pageReminderServiceProvider = Provider<PageReminderService>((ref) {
  return PageReminderService(ref.watch(dioClientProvider));
});

class PageReminderService {
  final Dio _dio;

  PageReminderService(this._dio);

  Future<List<PageReminder>> getPageReminders() async {
    try {
      final response = await _dio.get('/page-reminders');
      final data = response.data['data'] as List;
      return data
          .map((item) => PageReminder.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      throw Exception('Não foi possível carregar os vídeos lembrete.');
    }
  }

  Future<PageReminder> getPageReminder(int id) async {
    try {
      final response = await _dio.get('/page-reminders/$id');
      return PageReminder.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } catch (_) {
      throw Exception('Não foi possível carregar o vídeo lembrete.');
    }
  }

  Future<PageReminder> getPageReminderByPageKey(String pageKey) async {
    try {
      final response = await _dio.get('/page-reminders/page/$pageKey');
      return PageReminder.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } catch (_) {
      throw Exception('Não foi possível carregar a explicação desta página.');
    }
  }
}
