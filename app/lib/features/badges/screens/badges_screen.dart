import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_end_drawer.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../models/badge.dart';
import '../providers/badges_provider.dart';
import '../widgets/badge_tile.dart';

// Accent colors cycling per formation section
const List<Color> _kFormationColors = [
  Color(0xFFF37127), // orange
  Color(0xFF00C2FF), // cyan
  Color(0xFFFF6FC8), // pink
  Color(0xFFFFD700), // gold
  Color(0xFF7BFF6F), // green
  Color(0xFF9B72FF), // purple
  Color(0xFF00FFC2), // teal
  Color(0xFFFF5252), // red
];

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(myBadgesProvider);

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
      body: badgesAsync.when(
        data: (badges) {
          if (badges.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.emoji_events_rounded,
              title: 'Nenhuma insígnia ainda',
              subtitle:
                  'Conclua módulos e formações para desbloquear suas conquistas.',
              actionLabel: 'Explorar Formações',
              onAction: () => context.go('/home'),
            );
          }
          // Group badges by formation name preserving insertion order
          final grouped = <String, List<BadgeModel>>{};
          for (final badge in badges) {
            final formationName =
                badge.formation?['nome'] as String? ?? 'Geral';
            grouped.putIfAbsent(formationName, () => []).add(badge);
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              // Section title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Conquistas',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Professor(a), aqui estão todas as insígnias conquistadas ao longo de todas as suas formações.',
                      style: TextStyle(
                        color: AppTheme.textSecondary.withOpacity(0.85),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Formation sections
              ...grouped.entries.toList().asMap().entries.map((mapEntry) {
                final colorIndex = mapEntry.key;
                final formationName = mapEntry.value.key;
                final formationBadges = mapEntry.value.value;
                final accentColor =
                    _kFormationColors[colorIndex % _kFormationColors.length];

                return _FormationBadgesSection(
                  formationName: formationName,
                  badges: formationBadges,
                  accentColor: accentColor,
                );
              }),
            ],
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.brandOrange)),
        error: (e, _) => Center(
            child: Text('Erro: $e',
                style: const TextStyle(color: AppTheme.error))),
      ),
    );
  }
}

/// Seção de uma formação: cabeçalho + grade 3 colunas de BadgeTile.
class _FormationBadgesSection extends StatelessWidget {
  final String formationName;
  final List<BadgeModel> badges;
  final Color accentColor;

  const _FormationBadgesSection({
    required this.formationName,
    required this.badges,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Formation header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Formation accent dot / icon placeholder
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formationName,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Thin accent line
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: Container(height: 1, color: accentColor.withOpacity(0.4)),
          ),
          // 3-column badge grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) => BadgeTile(badge: badges[index]),
          ),
        ],
      ),
    );
  }
}
