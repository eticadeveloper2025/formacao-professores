import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/bncc_skill_chip.dart';
import '../../data/models/calendar_entry.dart';

class CalendarEntryCard extends StatelessWidget {
  final CalendarEntry entry;

  const CalendarEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
          leading: _TypeBadge(type: entry.activityType),
          title: Text(
            entry.theme,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Semana ${entry.weekNumber} · Aula ${entry.lessonNumber} · ${_formatDate(entry.date)}',
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ),
          children: [
            _DetailLine(label: 'Tipo', value: entry.activityType),
            _DetailLine(label: 'Status', value: entry.status),
            _DetailLine(label: 'Objetivo', value: entry.objective),
            _DetailLine(label: 'Atividade', value: entry.activity),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.bnccSkills
                    .map((skill) => BnccSkillChip(label: skill))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            _DetailLine(label: 'Competência BNCC', value: entry.bnccCompetency),
            if (entry.lessonPlanId != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () =>
                      context.push('/planos-aula/${entry.lessonPlanId}'),
                  icon: const Icon(Icons.assignment_rounded, size: 18),
                  label: const Text('Abrir plano de aula'),
                ),
              ),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.push('/calendario/${entry.id}'),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Ver detalhes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.brandOrange.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(_iconForType(type), color: AppTheme.brandOrange, size: 22),
    );
  }

  IconData _iconForType(String type) {
    final normalized = type.toLowerCase();
    if (normalized.contains('quiz')) return Icons.quiz_rounded;
    if (normalized.contains('debate')) return Icons.forum_rounded;
    if (normalized.contains('vídeo') || normalized.contains('video')) {
      return Icons.play_circle_rounded;
    }
    if (normalized.contains('material')) return Icons.attach_file_rounded;
    if (normalized.contains('app')) return Icons.touch_app_rounded;
    return Icons.school_rounded;
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: AppTheme.textSecondary,
              height: 1.35,
              fontSize: 13,
            ),
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ),
    );
  }
}
