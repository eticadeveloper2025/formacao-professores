import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/circular_progress_widget.dart';
import '../models/formation_module.dart';
import '../../progress/providers/progress_provider.dart';
import '../widgets/module_card.dart';

class FormationDetailScreen extends ConsumerWidget {
  final int formationId;

  const FormationDetailScreen({super.key, required this.formationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(formationProgressProvider(formationId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Módulos da Formação'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: progressAsync.when(
        data: (progress) {
          final modulos = (progress['modulos'] as List<dynamic>);
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: AppTheme.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularProgressWidget(
                      percent: (progress['percentual'] as num).toDouble(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${progress['concluidos']} / ${progress['total']} módulos',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Concluídos',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: modulos.length,
                  itemBuilder: (context, index) {
                    final m = modulos[index] as Map<String, dynamic>;
                    final module = FormationModule(
                      id: m['module_id'] as int,
                      titulo: m['titulo'] as String,
                      videoUrl: m['video_url'] as String?,
                      ordem: m['ordem'] as int,
                      completed: m['completed'] as bool? ?? false,
                    );
                    return ModuleCard(
                      module: module,
                      onTap: () => context.push('/modules/${module.id}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.orange),
        ),
        error: (e, _) => Center(
          child: Text('Erro: $e', style: const TextStyle(color: AppTheme.error)),
        ),
      ),
    );
  }
}
