import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/calendar_entry.dart';
import '../../data/services/calendar_service.dart';

final calendarEntriesProvider =
    FutureProvider.family<List<CalendarEntry>, CalendarFilters>((ref, filters) {
  return ref.watch(calendarServiceProvider).getCalendarEntries(filters);
});

final calendarEntryDetailProvider =
    FutureProvider.family<CalendarEntry, int>((ref, id) {
  return ref.watch(calendarServiceProvider).getCalendarEntry(id);
});
