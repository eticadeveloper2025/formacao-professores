import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/home_service.dart';

final notificationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(homeServiceProvider);
  return service.getNotifications();
});
