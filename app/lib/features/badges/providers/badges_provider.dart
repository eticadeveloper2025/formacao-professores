import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/badge.dart';
import '../services/badges_service.dart';

final myBadgesProvider = FutureProvider<List<BadgeModel>>((ref) async {
  return ref.watch(badgesServiceProvider).getMyBadges();
});

final formationBadgesProvider = FutureProvider.family<List<BadgeModel>, int>((ref, formationId) async {
  return ref.watch(badgesServiceProvider).getFormationBadges(formationId);
});
