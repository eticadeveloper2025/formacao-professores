import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/lesson_plan.dart';
import '../../data/services/lesson_plan_service.dart';

final lessonPlansProvider =
    FutureProvider.family<List<LessonPlan>, LessonPlanFilters>((ref, filters) {
  return ref.watch(lessonPlanServiceProvider).getLessonPlans(filters);
});

final lessonPlanDetailProvider =
    FutureProvider.family<LessonPlan, int>((ref, id) {
  return ref.watch(lessonPlanServiceProvider).getLessonPlan(id);
});
