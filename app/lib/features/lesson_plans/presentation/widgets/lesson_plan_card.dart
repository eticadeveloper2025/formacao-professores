import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/bncc_skill_chip.dart';
import '../../data/models/lesson_plan.dart';

class LessonPlanCard extends StatelessWidget {
  final LessonPlan plan;

  const LessonPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/planos-aula/${plan.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.brandOrange.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Semana ${plan.weekNumber} · Aula ${plan.lessonNumber}',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppTheme.brandOrange),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                plan.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cap. ${plan.chapter}: ${plan.theme}',
                style: const TextStyle(
                    color: AppTheme.textSecondary, height: 1.35),
              ),
              const SizedBox(height: 10),
              Text(
                '${plan.durationMinutes} min · ${plan.mainActivity}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13),
              ),
              if (plan.bnccSkills.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: plan.bnccSkills
                      .map((skill) => BnccSkillChip(label: skill))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
