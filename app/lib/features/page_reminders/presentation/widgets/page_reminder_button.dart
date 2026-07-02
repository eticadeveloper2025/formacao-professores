import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/page_reminder_provider.dart';
import 'page_reminder_player.dart';

class PageReminderButton extends ConsumerWidget {
  final String pageKey;
  final String label;

  const PageReminderButton({
    super.key,
    required this.pageKey,
    this.label = 'Ouvir explicação desta página',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderAsync = ref.watch(pageReminderProvider(pageKey));

    return reminderAsync.when(
      data: (reminder) => Semantics(
        button: true,
        label: label,
        child: OutlinedButton.icon(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppTheme.secondary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              builder: (_) => PageReminderPlayer(reminder: reminder),
            );
          },
          icon: const Icon(Icons.record_voice_over_rounded, size: 18),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.textPrimary,
            side: const BorderSide(color: AppTheme.brandOrange),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      loading: () => OutlinedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: const Text('Carregando explicação'),
      ),
      error: (_, __) => OutlinedButton.icon(
        onPressed: () => ref.invalidate(pageReminderProvider(pageKey)),
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: const Text('Tentar carregar explicação'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.textPrimary,
          side: const BorderSide(color: AppTheme.error),
        ),
      ),
    );
  }
}
