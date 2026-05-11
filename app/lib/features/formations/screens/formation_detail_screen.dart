import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_end_drawer.dart';
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
      endDrawer: const AppEndDrawer(),
      appBar: AppBar(
        backgroundColor: AppTheme.brandOrange,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'FORMAÇÃO PARA PROFESSORES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
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
                      onTap: () => context.push(
                        '/modules/${module.id}',
                        extra: {
                          'titulo': module.titulo,
                          'descricao': module.descricao,
                          'videoUrl': module.videoUrl,
                          'ordem': module.ordem,
                          'totalModulos': modulos.length,
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.brandOrange),
        ),
        error: (e, _) => Center(
          child:
              Text('Erro: $e', style: const TextStyle(color: AppTheme.error)),
        ),
      ),
    );
  }
}
