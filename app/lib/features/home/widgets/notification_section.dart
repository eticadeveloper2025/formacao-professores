import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/notification_tile.dart';
import '../providers/home_provider.dart';
import '../services/home_service.dart';

class NotificationSection extends ConsumerWidget {
  const NotificationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Notificações',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...notifications.take(3).map((n) => NotificationTile(
                  titulo: n['titulo'],
                  mensagem: n['mensagem'],
                  lida: n['lida'],
                  onTap: () async {
                    if (!n['lida']) {
                      await ref.read(homeServiceProvider).markNotificationRead(n['id']);
                      ref.invalidate(notificationsProvider);
                    }
                  },
                )),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
