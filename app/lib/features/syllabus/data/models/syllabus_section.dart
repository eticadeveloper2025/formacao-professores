class SyllabusSection {
  final int id;
  final String title;
  final String content;
  final String sectionType;
  final int order;
  final bool active;

  const SyllabusSection({
    required this.id,
    required this.title,
    required this.content,
    required this.sectionType,
    required this.order,
    required this.active,
  });

  factory SyllabusSection.fromJson(Map<String, dynamic> json) {
    return SyllabusSection(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      sectionType: (json['sectionType'] ?? json['section_type']) as String,
      order: json['order'] ?? 0,
      active: json['active'] ?? true,
    );
  }
}
