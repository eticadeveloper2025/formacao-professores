import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../models/formation.dart';
import '../models/formation_module.dart';

final formationServiceProvider = Provider<FormationService>((ref) {
  return FormationService(ref.watch(dioClientProvider));
});

class FormationService {
  final Dio _dio;
  FormationService(this._dio);

  Future<List<Formation>> getFormations() async {
    final response = await _dio.get('/formations');
    final data = response.data['data'] as List;
    return data.map((e) => Formation.fromJson(e)).toList();
  }

  Future<Formation> getFormation(int id) async {
    final response = await _dio.get('/formations/$id');
    return Formation.fromJson(response.data['data']);
  }

  Future<List<FormationModule>> getModules(int formationId) async {
    final response = await _dio.get('/formations/$formationId/modules');
    final data = response.data['data'] as List;
    return data.map((e) => FormationModule.fromJson(e)).toList();
  }
}
