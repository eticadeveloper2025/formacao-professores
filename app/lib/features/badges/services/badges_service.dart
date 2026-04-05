import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../models/badge.dart';

final badgesServiceProvider = Provider<BadgesService>((ref) {
  return BadgesService(ref.watch(dioClientProvider));
});

class BadgesService {
  final Dio _dio;
  BadgesService(this._dio);

  Future<List<BadgeModel>> getMyBadges() async {
    final response = await _dio.get('/badges/me');
    final data = response.data['data'] as List;
    return data.map((e) => BadgeModel.fromJson(e)).toList();
  }

  Future<List<BadgeModel>> getFormationBadges(int formationId) async {
    final response = await _dio.get('/badges/formation/$formationId');
    final data = response.data['data'] as List;
    return data.map((e) => BadgeModel.fromJson(e)).toList();
  }
}
