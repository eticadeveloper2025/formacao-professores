import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_end_drawer.dart';
import '../../../../shared/widgets/authenticated_app_bar.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/responsive_content_container.dart';
import '../../../page_reminders/presentation/widgets/page_reminder_button.dart';
import '../../data/models/calendar_entry.dart';
import '../../data/services/calendar_service.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_entry_card.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _month;
  String? _type;
  int? _week;
  String? _chapter;
  String? _search;
  final _searchController = TextEditingController();

  static const _types = [
    'Aula',
    'Atividade no app',
    'Debate',
    'Quiz',
    'Vídeo',
    'Material complementar',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  CalendarFilters get _filters => CalendarFilters(
        month: _month,
        type: _type,
        week: _week,
        chapter: _chapter,
        search: _search,
      );

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(calendarEntriesProvider(_filters));

    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer: const AppEndDrawer(),
      appBar: buildAuthenticatedAppBar(context: context),
      body: entriesAsync.when(
        data: (entries) => RefreshIndicator(
          color: AppTheme.brandOrange,
          onRefresh: () async =>
              ref.refresh(calendarEntriesProvider(_filters).future),
          child: ListView(
            children: [
              ResponsiveContentContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageReminderButton(pageKey: 'calendar'),
                    const SizedBox(height: 16),
                    _Header(
                      month: _month,
                      onPrevious: () => setState(() {
                        _month = DateTime(_month.year, _month.month - 1);
                      }),
                      onNext: () => setState(() {
                        _month = DateTime(_month.year, _month.month + 1);
                      }),
                      onToday: () => setState(() {
                        final now = DateTime.now();
                        _month = DateTime(now.year, now.month);
                      }),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por tema',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () => setState(() {
                                  _searchController.clear();
                                  _search = null;
                                }),
                              ),
                      ),
                      onSubmitted: (value) => setState(() {
                        _search = value.trim().isEmpty ? null : value.trim();
                      }),
                    ),
                    const SizedBox(height: 12),
                    _FilterRow(
                      type: _type,
                      week: _week,
                      chapter: _chapter,
                      types: _types,
                      onTypeChanged: (value) => setState(() => _type = value),
                      onWeekChanged: (value) => setState(() => _week = value),
                      onChapterChanged: (value) =>
                          setState(() => _chapter = value),
                      onClear: () => setState(() {
                        _type = null;
                        _week = null;
                        _chapter = null;
                        _search = null;
                        _searchController.clear();
                      }),
                    ),
                    const SizedBox(height: 16),
                    if (entries.isEmpty)
                      EmptyStateWidget(
                        icon: Icons.calendar_month_rounded,
                        title: 'Nenhuma atividade encontrada',
                        subtitle:
                            'Ajuste os filtros ou navegue para outro mês do calendário.',
                        actionLabel: 'Limpar filtros',
                        onAction: () => setState(() {
                          _type = null;
                          _week = null;
                          _chapter = null;
                          _search = null;
                          _searchController.clear();
                        }),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth >= 760) {
                            return _CalendarTable(entries: entries);
                          }
                          return Column(
                            children: entries
                                .map((entry) => CalendarEntryCard(entry: entry))
                                .toList(),
                          );
                        },
                      ),
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
          title: 'Erro ao carregar o calendário',
          subtitle: 'Verifique sua conexão e tente novamente.',
          actionLabel: 'Tentar novamente',
          onAction: () => ref.invalidate(calendarEntriesProvider(_filters)),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const _Header({
    required this.month,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Calendário · ${_monthName(month.month)} ${month.year}',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Mês anterior',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        IconButton(
          tooltip: 'Próximo mês',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
        TextButton(onPressed: onToday, child: const Text('Hoje')),
      ],
    );
  }

  String _monthName(int month) {
    const names = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    return names[month - 1];
  }
}

class _FilterRow extends StatelessWidget {
  final String? type;
  final int? week;
  final String? chapter;
  final List<String> types;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<int?> onWeekChanged;
  final ValueChanged<String?> onChapterChanged;
  final VoidCallback onClear;

  const _FilterRow({
    required this.type,
    required this.week,
    required this.chapter,
    required this.types,
    required this.onTypeChanged,
    required this.onWeekChanged,
    required this.onChapterChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        DropdownButton<String?>(
          value: type,
          hint: const Text('Tipo'),
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
            ...types.map((type) => DropdownMenuItem<String?>(
                  value: type,
                  child: Text(type),
                )),
          ],
          onChanged: onTypeChanged,
        ),
        DropdownButton<int?>(
          value: week,
          hint: const Text('Semana'),
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('Todas')),
            ...List.generate(12, (index) => index + 1).map(
              (week) => DropdownMenuItem<int?>(
                value: week,
                child: Text('Semana $week'),
              ),
            ),
          ],
          onChanged: onWeekChanged,
        ),
        DropdownButton<String?>(
          value: chapter,
          hint: const Text('Capítulo'),
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
            ...List.generate(6, (index) => '${index + 1}').map(
              (chapter) => DropdownMenuItem<String?>(
                value: chapter,
                child: Text('Cap. $chapter'),
              ),
            ),
          ],
          onChanged: onChapterChanged,
        ),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
          label: const Text('Limpar'),
        ),
      ],
    );
  }
}

class _CalendarTable extends StatelessWidget {
  final List<CalendarEntry> entries;

  const _CalendarTable({required this.entries});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: const TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        dataTextStyle: const TextStyle(color: AppTheme.textSecondary),
        columns: const [
          DataColumn(label: Text('Data')),
          DataColumn(label: Text('Aula/Tema')),
          DataColumn(label: Text('Objetivo')),
          DataColumn(label: Text('Atividade')),
          DataColumn(label: Text('Habilidade BNCC')),
          DataColumn(label: Text('Competência BNCC')),
        ],
        rows: entries
            .map(
              (entry) => DataRow(
                cells: [
                  DataCell(Text(_formatDate(entry.date))),
                  DataCell(SizedBox(width: 180, child: Text(entry.theme))),
                  DataCell(SizedBox(width: 220, child: Text(entry.objective))),
                  DataCell(SizedBox(width: 220, child: Text(entry.activity))),
                  DataCell(Text(entry.bnccSkills.join(', '))),
                  DataCell(
                      SizedBox(width: 220, child: Text(entry.bnccCompetency))),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
