import '../../../page_reminders/data/models/page_reminder.dart';

class LessonPlan {
  final int id;
  final String title;
  final String chapter;
  final String theme;
  final int weekNumber;
  final int lessonNumber;
  final int durationMinutes;
  final String generalObjective;
  final List<String> specificObjectives;
  final String mainActivity;
  final String methodology;
  final List<String> requiredResources;
  final List<String> bnccSkills;
  final List<String> bnccCompetencies;
  final String teacherGuidance;
  final String assessment;
  final List<String> complementaryMaterials;
  final String? attachmentUrl;
  final int? reminderId;
  final PageReminder? reminder;
  final bool active;
  final int order;

  const LessonPlan({
    required this.id,
    required this.title,
    required this.chapter,
    required this.theme,
    required this.weekNumber,
    required this.lessonNumber,
    required this.durationMinutes,
    required this.generalObjective,
    required this.specificObjectives,
    required this.mainActivity,
    required this.methodology,
    required this.requiredResources,
    required this.bnccSkills,
    required this.bnccCompetencies,
    required this.teacherGuidance,
    required this.assessment,
    required this.complementaryMaterials,
    this.attachmentUrl,
    this.reminderId,
    this.reminder,
    required this.active,
    required this.order,
  });

  factory LessonPlan.fromJson(Map<String, dynamic> json) {
    return LessonPlan(
      id: json['id'] as int,
      title: json['title'] as String,
      chapter: json['chapter'] as String,
      theme: json['theme'] as String,
      weekNumber: (json['weekNumber'] ?? json['week_number']) as int,
      lessonNumber: (json['lessonNumber'] ?? json['lesson_number']) as int,
      durationMinutes:
          (json['durationMinutes'] ?? json['duration_minutes'] ?? 50) as int,
      generalObjective:
          (json['generalObjective'] ?? json['general_objective']) as String,
      specificObjectives: _stringList(
          json['specificObjectives'] ?? json['specific_objectives']),
      mainActivity: (json['mainActivity'] ?? json['main_activity']) as String,
      methodology: json['methodology'] as String,
      requiredResources:
          _stringList(json['requiredResources'] ?? json['required_resources']),
      bnccSkills: _stringList(json['bnccSkills'] ?? json['bncc_skills']),
      bnccCompetencies:
          _stringList(json['bnccCompetencies'] ?? json['bncc_competencies']),
      teacherGuidance:
          (json['teacherGuidance'] ?? json['teacher_guidance']) as String,
      assessment: json['assessment'] as String,
      complementaryMaterials: _stringList(
        json['complementaryMaterials'] ?? json['complementary_materials'],
      ),
      attachmentUrl: json['attachmentUrl'] ?? json['attachment_url'],
      reminderId: json['reminderId'] ?? json['reminder_id'],
      reminder: json['reminder'] == null
          ? null
          : PageReminder.fromJson(Map<String, dynamic>.from(json['reminder'])),
      active: json['active'] ?? true,
      order: json['order'] ?? 0,
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
