import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/formation.dart';
import '../models/formation_module.dart';
import '../services/formation_service.dart';

final formationsProvider = FutureProvider<List<Formation>>((ref) async {
  return ref.watch(formationServiceProvider).getFormations();
});

final formationDetailProvider = FutureProvider.family<Formation, int>((ref, id) async {
  return ref.watch(formationServiceProvider).getFormation(id);
});

final formationModulesProvider = FutureProvider.family<List<FormationModule>, int>((ref, id) async {
  return ref.watch(formationServiceProvider).getModules(id);
});
