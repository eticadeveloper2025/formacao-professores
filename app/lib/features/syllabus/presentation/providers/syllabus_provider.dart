import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/syllabus_section.dart';
import '../../data/services/syllabus_service.dart';

final syllabusProvider = FutureProvider<List<SyllabusSection>>((ref) async {
  return ref.watch(syllabusServiceProvider).getSyllabus();
});
