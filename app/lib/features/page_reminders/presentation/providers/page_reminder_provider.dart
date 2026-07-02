import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/page_reminder.dart';
import '../../data/services/page_reminder_service.dart';

final pageRemindersProvider = FutureProvider<List<PageReminder>>((ref) async {
  return ref.watch(pageReminderServiceProvider).getPageReminders();
});

final pageReminderProvider =
    FutureProvider.family<PageReminder, String>((ref, pageKey) async {
  return ref
      .watch(pageReminderServiceProvider)
      .getPageReminderByPageKey(pageKey);
});

final pageReminderDetailProvider =
    FutureProvider.family<PageReminder, int>((ref, id) async {
  return ref.watch(pageReminderServiceProvider).getPageReminder(id);
});
