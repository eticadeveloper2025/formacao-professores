import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/calendar_entry.dart';

final calendarServiceProvider = Provider<CalendarService>((ref) {
  return CalendarService(ref.watch(dioClientProvider));
});

class CalendarFilters {
  final DateTime? month;
  final String? type;
  final int? week;
  final String? chapter;
  final String? search;

  const CalendarFilters({
    this.month,
    this.type,
    this.week,
    this.chapter,
    this.search,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      if (month != null) 'month': month!.month,
      if (month != null) 'year': month!.year,
      if (type != null && type!.isNotEmpty) 'type': type,
      if (week != null) 'week': week,
      if (chapter != null && chapter!.isNotEmpty) 'chapter': chapter,
      if (search != null && search!.isNotEmpty) 'search': search,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarFilters &&
        other.month?.year == month?.year &&
        other.month?.month == month?.month &&
        other.type == type &&
        other.week == week &&
        other.chapter == chapter &&
        other.search == search;
  }

  @override
  int get hashCode => Object.hash(
        month?.year,
        month?.month,
        type,
        week,
        chapter,
        search,
      );
}

class CalendarService {
  final Dio _dio;

  CalendarService(this._dio);

  Future<List<CalendarEntry>> getCalendarEntries(
      CalendarFilters filters) async {
    try {
      final response = await _dio.get(
        '/calendar',
        queryParameters: filters.toQueryParameters(),
      );
      final data = response.data['data'] as List;
      return data
          .map(
              (item) => CalendarEntry.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      throw Exception('Não foi possível carregar o calendário.');
    }
  }

  Future<CalendarEntry> getCalendarEntry(int id) async {
    try {
      final response = await _dio.get('/calendar/$id');
      return CalendarEntry.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } catch (_) {
      throw Exception('Não foi possível carregar a atividade do calendário.');
    }
  }
}
