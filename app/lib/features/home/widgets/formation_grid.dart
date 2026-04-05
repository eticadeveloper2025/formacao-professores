import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/formation_card.dart';
import '../../formations/providers/formation_provider.dart';

class FormationGrid extends ConsumerWidget {
  const FormationGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formationsAsync = ref.watch(formationsProvider);

    return formationsAsync.when(
      data: (formations) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemCount: formations.length,
        itemBuilder: (context, index) {
          final formation = formations[index];
          return FormationCard(
            formation: formation,
            onTap: () => context.push('/formations/${formation.id}'),
          );
        },
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.orange),
      ),
      error: (e, _) => const Center(
        child: Text(
          'Erro ao carregar formações',
          style: TextStyle(color: AppTheme.error),
        ),
      ),
    );
  }
}
