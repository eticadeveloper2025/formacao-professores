import '../../../lesson_plans/data/models/lesson_plan.dart';
import '../../../page_reminders/data/models/page_reminder.dart';

class CalendarEntry {
  final int id;
  final DateTime date;
  final int weekNumber;
  final int lessonNumber;
  final String chapter;
  final String theme;
  final String objective;
  final String activity;
  final String activityType;
  final List<String> bnccSkills;
  final String bnccCompetency;
  final String status;
  final String? complementaryMaterial;
  final String? videoUrl;
  final int? lessonPlanId;
  final LessonPlan? lessonPlan;
  final int? reminderId;
  final PageReminder? reminder;

  const CalendarEntry({
    required this.id,
    required this.date,
    required this.weekNumber,
    required this.lessonNumber,
    required this.chapter,
    required this.theme,
    required this.objective,
    required this.activity,
    required this.activityType,
    required this.bnccSkills,
    required this.bnccCompetency,
    required this.status,
    this.complementaryMaterial,
    this.videoUrl,
    this.lessonPlanId,
    this.lessonPlan,
    this.reminderId,
    this.reminder,
  });

  factory CalendarEntry.fromJson(Map<String, dynamic> json) {
    return CalendarEntry(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      weekNumber: (json['weekNumber'] ?? json['week_number']) as int,
      lessonNumber: (json['lessonNumber'] ?? json['lesson_number']) as int,
      chapter: json['chapter'] as String,
      theme: json['theme'] as String,
      objective: json['objective'] as String,
      activity: json['activity'] as String,
      activityType: (json['activityType'] ?? json['activity_type']) as String,
      bnccSkills: _stringList(json['bnccSkills'] ?? json['bncc_skills']),
      bnccCompetency:
          (json['bnccCompetency'] ?? json['bncc_competency']) as String,
      status: json['status'] ?? 'planejado',
      complementaryMaterial:
          json['complementaryMaterial'] ?? json['complementary_material'],
      videoUrl: json['videoUrl'] ?? json['video_url'],
      lessonPlanId: json['lessonPlanId'] ?? json['lesson_plan_id'],
      lessonPlan: json['lessonPlan'] == null
          ? null
          : LessonPlan.fromJson(Map<String, dynamic>.from(json['lessonPlan'])),
      reminderId: json['reminderId'] ?? json['reminder_id'],
      reminder: json['reminder'] == null
          ? null
          : PageReminder.fromJson(Map<String, dynamic>.from(json['reminder'])),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.isNotEmpty) {
      return value.split(',').map((item) => item.trim()).toList();
    }
    return const [];
  }
}
