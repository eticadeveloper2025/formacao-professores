import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/lesson_plan.dart';

final lessonPlanServiceProvider = Provider<LessonPlanService>((ref) {
  return LessonPlanService(ref.watch(dioClientProvider));
});

class LessonPlanFilters {
  final String? chapter;
  final int? week;
  final String? bnccSkill;
  final String? search;

  const LessonPlanFilters({
    this.chapter,
    this.week,
    this.bnccSkill,
    this.search,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      if (chapter != null && chapter!.isNotEmpty) 'chapter': chapter,
      if (week != null) 'week': week,
      if (bnccSkill != null && bnccSkill!.isNotEmpty) 'bnccSkill': bnccSkill,
      if (search != null && search!.isNotEmpty) 'search': search,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is LessonPlanFilters &&
        other.chapter == chapter &&
        other.week == week &&
        other.bnccSkill == bnccSkill &&
        other.search == search;
  }

  @override
  int get hashCode => Object.hash(chapter, week, bnccSkill, search);
}

class LessonPlanService {
  final Dio _dio;

  LessonPlanService(this._dio);

  Future<List<LessonPlan>> getLessonPlans(LessonPlanFilters filters) async {
    try {
      final response = await _dio.get(
        '/lesson-plans',
        queryParameters: filters.toQueryParameters(),
      );
      final data = response.data['data'] as List;
      return data
          .map((item) => LessonPlan.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      throw Exception('Não foi possível carregar os planos de aula.');
    }
  }

  Future<LessonPlan> getLessonPlan(int id) async {
    try {
      final response = await _dio.get('/lesson-plans/$id');
      return LessonPlan.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } catch (_) {
      throw Exception('Não foi possível carregar o plano de aula.');
    }
  }
}
