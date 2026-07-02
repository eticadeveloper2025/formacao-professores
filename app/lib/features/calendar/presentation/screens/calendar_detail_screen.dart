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
import '../providers/calendar_provider.dart';

class CalendarDetailScreen extends ConsumerWidget {
  final int entryId;

  const CalendarDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(calendarEntryDetailProvider(entryId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer: const AppEndDrawer(),
      appBar: buildAuthenticatedAppBar(context: context),
      body: entryAsync.when(
        data: (entry) => ListView(
          children: [
            ResponsiveContentContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageReminderButton(pageKey: 'calendar'),
                  const SizedBox(height: 16),
                  Text(
                    entry.theme,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Semana ${entry.weekNumber} · Aula ${entry.lessonNumber} · Cap. ${entry.chapter}',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.bnccSkills
                        .map((skill) => BnccSkillChip(label: skill))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  ContentSectionCard(
                    icon: Icons.flag_rounded,
                    title: 'Objetivo',
                    content: entry.objective,
                    initiallyExpanded: true,
                  ),
                  ContentSectionCard(
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Atividade',
                    content: entry.activity,
                    initiallyExpanded: true,
                  ),
                  ContentSectionCard(
                    icon: Icons.workspace_premium_rounded,
                    title: 'Competência BNCC',
                    content: entry.bnccCompetency,
                  ),
                  if (entry.complementaryMaterial != null)
                    ContentSectionCard(
                      icon: Icons.attach_file_rounded,
                      title: 'Material complementar',
                      content: entry.complementaryMaterial!,
                    ),
                  if (entry.lessonPlanId != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.push('/planos-aula/${entry.lessonPlanId}'),
                        icon: const Icon(Icons.assignment_rounded),
                        label: const Text('Abrir plano de aula relacionado'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.brandOrange,
                        ),
                      ),
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
          title: 'Erro ao carregar atividade',
          subtitle: 'Não foi possível abrir este item do calendário.',
          actionLabel: 'Tentar novamente',
          onAction: () => ref.invalidate(calendarEntryDetailProvider(entryId)),
        ),
      ),
    );
  }
}
