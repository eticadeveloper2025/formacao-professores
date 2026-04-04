import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/badges_provider.dart';
import '../widgets/badge_grid.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(myBadgesProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Minhas Conquistas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: badgesAsync.when(
        data: (badges) {
          final conquistados = badges.where((b) => b.conquistado).length;
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: AppTheme.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$conquistados',
                          style: const TextStyle(
                            color: AppTheme.orange,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Conquistadas',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${badges.length - conquistados}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Bloqueadas',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: BadgeGrid(badges: badges),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.orange)),
        error: (e, _) => Center(child: Text('Erro: $e', style: const TextStyle(color: AppTheme.error))),
      ),
    );
  }
}
