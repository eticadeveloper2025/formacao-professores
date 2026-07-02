import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_end_drawer.dart';
import '../../../../shared/widgets/authenticated_app_bar.dart';
import '../../../../shared/widgets/bncc_skill_chip.dart';
import '../../../../shared/widgets/content_section_card.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/responsive_content_container.dart';
import '../../../page_reminders/presentation/widgets/page_reminder_button.dart';
import '../providers/lesson_plan_provider.dart';

class LessonPlanDetailScreen extends ConsumerWidget {
  final int planId;

  const LessonPlanDetailScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(lessonPlanDetailProvider(planId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer: const AppEndDrawer(),
      appBar: buildAuthenticatedAppBar(context: context),
      body: planAsync.when(
        data: (plan) => ListView(
          children: [
            ResponsiveContentContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageReminderButton(pageKey: 'lesson-plans'),
                  const SizedBox(height: 16),
                  Text(
                    plan.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cap. ${plan.chapter} · Semana ${plan.weekNumber} · Aula ${plan.lessonNumber} · ${plan.durationMinutes} min',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: plan.bnccSkills
                        .map((skill) => BnccSkillChip(label: skill))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  ContentSectionCard(
                    icon: Icons.badge_rounded,
                    title: 'Identificação',
                    content: '${plan.theme}\nCapítulo ${plan.chapter}',
                    initiallyExpanded: true,
                  ),
                  ContentSectionCard(
                    icon: Icons.flag_rounded,
                    title: 'Objetivos',
                    content:
                        '${plan.generalObjective}\n\n${plan.specificObjectives.map((item) => '- $item').join('\n')}',
                    initiallyExpanded: true,
                  ),
                  ContentSectionCard(
                    icon: Icons.inventory_2_rounded,
                    title: 'Preparação',
                    content: plan.requiredResources
                        .map((item) => '- $item')
                        .join('\n'),
                  ),
                  ContentSectionCard(
                    icon: Icons.route_rounded,
                    title: 'Desenvolvimento da aula',
                    content: plan.methodology,
                  ),
                  ContentSectionCard(
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Atividade',
                    content: plan.mainActivity,
                  ),
                  ContentSectionCard(
                    icon: Icons.school_rounded,
                    title: 'BNCC',
                    content:
                        'Habilidades: ${plan.bnccSkills.join(', ')}\n\nCompetências: ${plan.bnccCompetencies.join(', ')}',
                  ),
                  ContentSectionCard(
                    icon: Icons.fact_check_rounded,
                    title: 'Avaliação',
                    content: plan.assessment,
                  ),
                  ContentSectionCard(
                    icon: Icons.attach_file_rounded,
                    title: 'Materiais',
                    content: plan.complementaryMaterials.isEmpty
                        ? 'Nenhum material complementar cadastrado.'
                        : plan.complementaryMaterials
                            .map((item) => '- $item')
                            .join('\n'),
                  ),
                  ContentSectionCard(
                    icon: Icons.tips_and_updates_rounded,
                    title: 'Orientações ao professor',
                    content: plan.teacherGuidance,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => context.push('/calendario'),
                        icon:
                            const Icon(Icons.calendar_month_rounded, size: 18),
                        label: const Text('Voltar ao calendário'),
                      ),
                      if (plan.attachmentUrl != null)
                        OutlinedButton.icon(
                          onPressed: () =>
                              _showUrl(context, plan.attachmentUrl!),
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: const Text('Abrir anexo'),
                        ),
                      if (plan.complementaryMaterials.isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: () => _showMaterials(
                            context,
                            plan.complementaryMaterials,
                          ),
                          icon: const Icon(Icons.folder_open_rounded, size: 18),
                          label: const Text('Materiais'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.brandOrange),
        ),
        error: (_, __) => EmptyStateWidget(
          icon: Icons.error_outline_rounded,
          title: 'Erro ao carregar plano',
          subtitle: 'Não foi possível abrir este plano de aula.',
          actionLabel: 'Tentar novamente',
          onAction: () => ref.invalidate(lessonPlanDetailProvider(planId)),
        ),
      ),
    );
  }

  void _showUrl(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arquivo anexo'),
        content: SelectableText(url),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showMaterials(BuildContext context, List<String> materials) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.secondary,
      builder: (context) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            const Text(
              'Materiais complementares',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...materials.map(
              (material) => ListTile(
                leading: const Icon(Icons.attach_file_rounded),
                title: Text(material),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
