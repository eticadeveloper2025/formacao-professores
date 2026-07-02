import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_end_drawer.dart';
import '../../../../shared/widgets/authenticated_app_bar.dart';
import '../../../../shared/widgets/content_section_card.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/responsive_content_container.dart';
import '../../../page_reminders/presentation/widgets/page_reminder_button.dart';
import '../../data/models/syllabus_section.dart';
import '../providers/syllabus_provider.dart';

class SyllabusScreen extends ConsumerWidget {
  const SyllabusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syllabusAsync = ref.watch(syllabusProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer: const AppEndDrawer(),
      appBar: buildAuthenticatedAppBar(context: context),
      body: syllabusAsync.when(
        data: (sections) {
          if (sections.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.menu_book_rounded,
              title: 'Ementa indisponível',
              subtitle:
                  'Nenhuma ementa ativa foi encontrada para este projeto.',
              actionLabel: 'Tentar novamente',
              onAction: () => ref.invalidate(syllabusProvider),
            );
          }

          final overview = _find(sections, 'overview');
          final targetAudience = _find(sections, 'targetAudience');
          final workload = _find(sections, 'workload');
          final methodology = _find(sections, 'methodology');
          final assessment = _find(sections, 'assessment');
          final bncc = _find(sections, 'bnccSkills');

          return RefreshIndicator(
            color: AppTheme.brandOrange,
            onRefresh: () async => ref.refresh(syllabusProvider.future),
            child: ListView(
              children: [
                ResponsiveContentContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageReminderButton(pageKey: 'syllabus'),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.brandOrange.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ementa do Projeto',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              overview?.content ?? sections.first.content,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _InfoChip(
                                  icon: Icons.groups_rounded,
                                  label:
                                      targetAudience?.title ?? 'Público-alvo',
                                ),
                                _InfoChip(
                                  icon: Icons.schedule_rounded,
                                  label: workload?.title ?? 'Carga horária',
                                ),
                                const _InfoChip(
                                  icon: Icons.phone_android_rounded,
                                  label: 'Mobile e Web',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (methodology != null)
                        ContentSectionCard(
                          icon: Icons.psychology_rounded,
                          title: methodology.title,
                          content: methodology.content,
                          initiallyExpanded: true,
                        ),
                      if (assessment != null)
                        ContentSectionCard(
                          icon: Icons.fact_check_rounded,
                          title: assessment.title,
                          content: assessment.content,
                        ),
                      if (bncc != null)
                        ContentSectionCard(
                          icon: Icons.school_rounded,
                          title: bncc.title,
                          content: bncc.content,
                        ),
                      ...sections
                          .where((section) => !{
                                'overview',
                                'methodology',
                                'assessment',
                                'bnccSkills',
                              }.contains(section.sectionType))
                          .map(
                            (section) => ContentSectionCard(
                              icon: _iconFor(section.sectionType),
                              title: section.title,
                              content: section.content,
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.brandOrange),
        ),
        error: (_, __) => EmptyStateWidget(
          icon: Icons.error_outline_rounded,
          title: 'Erro ao carregar a ementa',
          subtitle: 'Verifique sua conexão e tente novamente.',
          actionLabel: 'Tentar novamente',
          onAction: () => ref.invalidate(syllabusProvider),
        ),
      ),
    );
  }

  SyllabusSection? _find(List<SyllabusSection> sections, String type) {
    for (final section in sections) {
      if (section.sectionType == type) return section;
    }
    return null;
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'targetAudience':
        return Icons.groups_rounded;
      case 'generalObjective':
      case 'specificObjectives':
        return Icons.flag_rounded;
      case 'workload':
        return Icons.schedule_rounded;
      case 'contents':
        return Icons.view_list_rounded;
      case 'resources':
        return Icons.handyman_rounded;
      case 'competencies':
        return Icons.workspace_premium_rounded;
      case 'complementaryMaterials':
        return Icons.attach_file_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.brandOrange, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
