import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/training_schedule_item.dart';
import '../../data/services/training_schedule_service.dart';

final trainingScheduleProvider =
    FutureProvider<List<TrainingScheduleItem>>((ref) async {
  return ref.watch(trainingScheduleServiceProvider).getTrainingSchedule();
});
