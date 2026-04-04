import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_progress.dart';
import '../services/progress_service.dart';

final myProgressProvider = FutureProvider<List<UserProgress>>((ref) async {
  return ref.watch(progressServiceProvider).getMyProgress();
});

final formationProgressProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, formationId) async {
  return ref.watch(progressServiceProvider).getFormationProgress(formationId);
});
