import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_end_drawer.dart';
import '../../auth/providers/auth_provider.dart';
import '../../progress/models/user_progress.dart';
import '../../progress/providers/progress_provider.dart';
import '../widgets/formation_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final nome = authState.user?.nome ?? 'Professor(a)';
    final firstName = nome.split(' ').first;

    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer: const AppEndDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.brandOrange,
        elevation: 0,
        centerTitle: true,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, Prof. $firstName!',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Continue sua formação hoje',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            // Card "Continue de onde parou"
            ref.watch(myProgressProvider).maybeWhen(
                  data: (list) {
                    final inProgress = list
                        .where((p) => p.percentual > 0 && p.percentual < 100)
                        .toList();
                    if (inProgress.isEmpty) return const SizedBox.shrink();
                    return _ContinueCard(progress: inProgress.first);
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Coleções de Formação',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const FormationGrid(),
          ],
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final UserProgress progress;
  const _ContinueCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: GestureDetector(
        onTap: () => context.push('/formations/${progress.formationId}'),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.brandOrange.withOpacity(0.12),
                AppTheme.cardBackground,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.brandOrange.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.brandOrange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppTheme.brandOrange,
                  size: 22,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Continue de onde parou',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      progress.formationNome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${progress.modulosConcluidos}/${progress.totalModulos} módulos · ${progress.percentual.toInt()}%',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.brandOrange),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
