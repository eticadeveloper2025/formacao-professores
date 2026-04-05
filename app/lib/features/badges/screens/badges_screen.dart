import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../models/badge.dart';
import '../providers/badges_provider.dart';
import '../../../shared/widgets/badge_card.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(myBadgesProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Conquistas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: badgesAsync.when(
        data: (badges) {
          final conquistados = badges.where((b) => b.conquistado).length;

          // Group badges by formation name
          final grouped = <String, List<BadgeModel>>{};
          for (final badge in badges) {
            final formationName =
                badge.formation?['nome'] as String? ?? 'Geral';
            grouped.putIfAbsent(formationName, () => []).add(badge);
          }

          return Column(
            children: [
              // Stats header
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: AppTheme.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      value: '$conquistados',
                      label: 'Conquistadas',
                      color: AppTheme.orange,
                    ),
                    Container(
                        width: 1, height: 36, color: AppTheme.cardBackground),
                    _StatChip(
                      value: '${badges.length - conquistados}',
                      label: 'Bloqueadas',
                      color: AppTheme.textSecondary,
                    ),
                    Container(
                        width: 1, height: 36, color: AppTheme.cardBackground),
                    _StatChip(
                      value: '${badges.length}',
                      label: 'Total',
                      color: AppTheme.green,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  children: grouped.entries.map((entry) {
                    final formationName = entry.key;
                    final formationBadges = entry.value;
                    final conquered =
                        formationBadges.where((b) => b.conquistado).length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  formationName,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: conquered == formationBadges.length
                                      ? AppTheme.green.withOpacity(0.15)
                                      : AppTheme.cardBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$conquered/${formationBadges.length}',
                                  style: TextStyle(
                                    color: conquered == formationBadges.length
                                        ? AppTheme.green
                                        : AppTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: formationBadges.length,
                          itemBuilder: (context, index) {
                            final badge = formationBadges[index];
                            return BadgeCard(
                                badge: badge,
                                conquistado: badge.conquistado);
                          },
                        ),
                        const SizedBox(height: 8),
                        const Divider(
                            color: Color(0xFF232F4A),
                            indent: 16,
                            endIndent: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.orange)),
        error: (e, _) => Center(
            child: Text('Erro: $e',
                style: const TextStyle(color: AppTheme.error))),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatChip(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }
}
