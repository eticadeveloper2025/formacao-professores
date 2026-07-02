import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/providers/auth_provider.dart';

class AppEndDrawer extends ConsumerWidget {
  const AppEndDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final nome = user?.nome ?? 'Professor(a)';
    final inicial = nome.isNotEmpty ? nome[0].toUpperCase() : 'P';
    final schoolNome = user?.school?['nome'] as String?;
    final location = GoRouterState.of(context).uri.path;

    return Drawer(
      width: 280,
      backgroundColor: AppTheme.secondary,
      child: SafeArea(
        child: Column(
          children: [
            // Header laranja com avatar + nome + escola
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                color: AppTheme.brandOrange,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Text(
                      inicial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (schoolNome != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      schoolNome,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Início',
                    isActive: location == '/home',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/home');
                    },
                  ),
                  _NavItem(
                    icon: Icons.menu_book_rounded,
                    label: 'Ementa do Projeto',
                    isActive: location.startsWith('/ementa'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/ementa');
                    },
                  ),
                  _NavItem(
                    icon: Icons.calendar_month_rounded,
                    label: 'Calendário',
                    isActive: location.startsWith('/calendario'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/calendario');
                    },
                  ),
                  _NavItem(
                    icon: Icons.assignment_rounded,
                    label: 'Planos de Aula',
                    isActive: location.startsWith('/planos-aula'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/planos-aula');
                    },
                  ),
                  _NavItem(
                    icon: Icons.record_voice_over_rounded,
                    label: 'Vídeo Lembrete',
                    isActive: location.startsWith('/video-lembrete'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/video-lembrete');
                    },
                  ),
                  _NavItem(
                    icon: Icons.history_rounded,
                    label: 'Histórico',
                    isActive: location.startsWith('/history'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/history');
                    },
                  ),
                  _NavItem(
                    icon: Icons.emoji_events_rounded,
                    label: 'Conquistas',
                    isActive: location.startsWith('/badges'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/badges');
                    },
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Perfil',
                    isActive: location.startsWith('/profile'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/profile');
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12),
            _NavItem(
              icon: Icons.exit_to_app_rounded,
              label: 'Sair',
              iconColor: AppTheme.error,
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground =
        iconColor ?? (isActive ? AppTheme.brandOrange : AppTheme.textPrimary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: ListTile(
        selected: isActive,
        selectedTileColor: AppTheme.brandOrange.withValues(alpha: 0.14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: foreground, size: 22),
        title: Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        horizontalTitleGap: 8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
