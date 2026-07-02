import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_end_drawer.dart';
import '../../../../shared/widgets/authenticated_app_bar.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/responsive_content_container.dart';
import '../../../page_reminders/presentation/widgets/page_reminder_button.dart';
import '../../data/services/lesson_plan_service.dart';
import '../providers/lesson_plan_provider.dart';
import '../widgets/lesson_plan_card.dart';

class LessonPlansScreen extends ConsumerStatefulWidget {
  const LessonPlansScreen({super.key});

  @override
  ConsumerState<LessonPlansScreen> createState() => _LessonPlansScreenState();
}

class _LessonPlansScreenState extends ConsumerState<LessonPlansScreen> {
  String? _chapter;
  int? _week;
  String? _bnccSkill;
  String? _search;
  final _searchController = TextEditingController();
  final _skillController = TextEditingController();

  LessonPlanFilters get _filters => LessonPlanFilters(
        chapter: _chapter,
        week: _week,
        bnccSkill: _bnccSkill,
        search: _search,
      );

  @override
  void dispose() {
    _searchController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(lessonPlansProvider(_filters));

    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer: const AppEndDrawer(),
      appBar: buildAuthenticatedAppBar(context: context),
      body: plansAsync.when(
        data: (plans) => RefreshIndicator(
          color: AppTheme.brandOrange,
          onRefresh: () async =>
              ref.refresh(lessonPlansProvider(_filters).future),
          child: ListView(
            children: [
              ResponsiveContentContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageReminderButton(pageKey: 'lesson-plans'),
                    const SizedBox(height: 16),
                    const Text(
                      'Planos de Aula',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Consulte objetivos, BNCC, metodologia, recursos e orientações para cada aula.',
                      style:
                          TextStyle(color: AppTheme.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar por título ou tema',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      onSubmitted: (value) => setState(() {
                        _search = value.trim().isEmpty ? null : value.trim();
                      }),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _skillController,
                      decoration: const InputDecoration(
                        hintText: 'Filtrar por habilidade BNCC',
                        prefixIcon: Icon(Icons.school_rounded),
                      ),
                      onSubmitted: (value) => setState(() {
                        _bnccSkill = value.trim().isEmpty ? null : value.trim();
                      }),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        DropdownButton<String?>(
                          value: _chapter,
                          hint: const Text('Capítulo'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Todos'),
                            ),
                            ...List.generate(6, (index) => '${index + 1}')
                                .map((chapter) => DropdownMenuItem<String?>(
                                      value: chapter,
                                      child: Text('Cap. $chapter'),
                                    )),
                          ],
                          onChanged: (value) =>
                              setState(() => _chapter = value),
                        ),
                        DropdownButton<int?>(
                          value: _week,
                          hint: const Text('Semana'),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('Todas'),
                            ),
                            ...List.generate(12, (index) => index + 1)
                                .map((week) => DropdownMenuItem<int?>(
                                      value: week,
                                      child: Text('Semana $week'),
                                    )),
                          ],
                          onChanged: (value) => setState(() => _week = value),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => setState(() {
                            _chapter = null;
                            _week = null;
                            _bnccSkill = null;
                            _search = null;
                            _searchController.clear();
                            _skillController.clear();
                          }),
                          icon: const Icon(Icons.filter_alt_off_rounded,
                              size: 18),
                          label: const Text('Limpar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (plans.isEmpty)
                      EmptyStateWidget(
                        icon: Icons.assignment_rounded,
                        title: 'Nenhum plano encontrado',
                        subtitle:
                            'Ajuste os filtros para visualizar outros planos.',
                        actionLabel: 'Limpar filtros',
                        onAction: () => setState(() {
                          _chapter = null;
                          _week = null;
                          _bnccSkill = null;
                          _search = null;
                          _searchController.clear();
                          _skillController.clear();
                        }),
                      )
                    else
                      ...plans.map((plan) => LessonPlanCard(plan: plan)),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.brandOrange),
        ),
        error: (_, __) => EmptyStateWidget(
          icon: Icons.error_outline_rounded,
          title: 'Erro ao carregar planos',
          subtitle: 'Verifique sua conexão e tente novamente.',
          actionLabel: 'Tentar novamente',
          onAction: () => ref.invalidate(lessonPlansProvider(_filters)),
        ),
      ),
    );
  }
}
