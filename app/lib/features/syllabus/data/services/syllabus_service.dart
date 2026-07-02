import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/syllabus_section.dart';

final syllabusServiceProvider = Provider<SyllabusService>((ref) {
  return SyllabusService(ref.watch(dioClientProvider));
});

class SyllabusService {
  final Dio _dio;

  SyllabusService(this._dio);

  Future<List<SyllabusSection>> getSyllabus() async {
    try {
      final response = await _dio.get('/syllabus');
      final data = response.data['data'] as List;
      return data
          .map((item) =>
              SyllabusSection.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      throw Exception('Não foi possível carregar a ementa do projeto.');
    }
  }
}
