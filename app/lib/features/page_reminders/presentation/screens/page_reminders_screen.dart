import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_end_drawer.dart';
import '../../../../shared/widgets/authenticated_app_bar.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/responsive_content_container.dart';
import '../providers/page_reminder_provider.dart';
import '../widgets/page_reminder_player.dart';

class PageRemindersScreen extends ConsumerWidget {
  const PageRemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(pageRemindersProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer: const AppEndDrawer(),
      appBar: buildAuthenticatedAppBar(context: context),
      body: remindersAsync.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.record_voice_over_rounded,
              title: 'Nenhum lembrete disponível',
              subtitle:
                  'Os vídeos lembrete serão exibidos aqui quando cadastrados.',
              actionLabel: 'Tentar novamente',
              onAction: () => ref.invalidate(pageRemindersProvider),
            );
          }

          return ListView(
            children: [
              ResponsiveContentContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vídeo Lembrete',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ouça explicações rápidas sobre como navegar pelos conteúdos pedagógicos.',
                      style:
                          TextStyle(color: AppTheme.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    ...reminders.map(
                      (reminder) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: const Icon(
                              Icons.record_voice_over_rounded,
                              color: AppTheme.brandOrange,
                            ),
                            iconColor: AppTheme.brandOrange,
                            collapsedIconColor: AppTheme.textSecondary,
                            title: Text(
                              reminder.title,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              reminder.description,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            children: [
                              PageReminderPlayer(reminder: reminder),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.brandOrange),
        ),
        error: (_, __) => EmptyStateWidget(
          icon: Icons.error_outline_rounded,
          title: 'Erro ao carregar lembretes',
          subtitle: 'Verifique sua conexão e tente novamente.',
          actionLabel: 'Tentar novamente',
          onAction: () => ref.invalidate(pageRemindersProvider),
        ),
      ),
    );
  }
}
