import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_end_drawer.dart';
import '../providers/auth_provider.dart';
import '../../badges/providers/badges_provider.dart';
import '../../progress/providers/progress_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final progressAsync = ref.watch(myProgressProvider);
    final badgesAsync = ref.watch(myBadgesProvider);

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/login'));
      return const SizedBox.shrink();
    }

    final inicial = user.nome.isNotEmpty ? user.nome[0].toUpperCase() : 'P';
    final schoolNome = user.school?['nome'] as String?;
    final schoolRegiao = user.school?['regiao'] as String?;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 44,
              backgroundColor: AppTheme.brandOrange.withOpacity(0.2),
              child: Text(
                inicial,
                style: const TextStyle(
                  color: AppTheme.brandOrange,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.nome,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            // Stats row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: 'Módulos\nConcluídos',
                    value: progressAsync.maybeWhen(
                      data: (list) => list
                          .fold(0, (s, p) => s + p.modulosConcluidos)
                          .toString(),
                      orElse: () => '--',
                    ),
                  ),
                  _StatItem(
                    label: 'Em\nAndamento',
                    value: progressAsync.maybeWhen(
                      data: (list) => list
                          .where((p) => p.percentual > 0 && p.percentual < 100)
                          .length
                          .toString(),
                      orElse: () => '--',
                    ),
                  ),
                  _StatItem(
                    label: 'Insígnias\nConquistadas',
                    value: badgesAsync.maybeWhen(
                      data: (list) => list.length.toString(),
                      orElse: () => '--',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _InfoCard(label: 'Nível de acesso', value: user.nivelAcesso),
            if (schoolNome != null) ...[
              const SizedBox(height: 12),
              _InfoCard(label: 'Escola', value: schoolNome),
            ],
            if (schoolRegiao != null) ...[
              const SizedBox(height: 12),
              _InfoCard(label: 'Região', value: schoolRegiao),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.brandOrange,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
