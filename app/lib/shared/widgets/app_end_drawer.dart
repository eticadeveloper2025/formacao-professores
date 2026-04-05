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
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Início',
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            _NavItem(
              icon: Icons.history_rounded,
              label: 'Histórico',
              onTap: () {
                Navigator.pop(context);
                context.push('/history');
              },
            ),
            _NavItem(
              icon: Icons.emoji_events_rounded,
              label: 'Conquistas',
              onTap: () {
                Navigator.pop(context);
                context.push('/badges');
              },
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Perfil',
              onTap: () {
                Navigator.pop(context);
                context.push('/profile');
              },
            ),
            const Spacer(),
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

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppTheme.textPrimary, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: iconColor ?? AppTheme.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 8,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
