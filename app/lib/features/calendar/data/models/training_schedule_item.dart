class TrainingScheduleItem {
  final int id;
  final String title;
  final String? subtitle;
  final String? chapter;
  final int order;
  final int documentId;
  final String documentUrl;
  final int? startPage;
  final String? thumbnailUrl;
  final bool active;

  const TrainingScheduleItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.chapter,
    required this.order,
    required this.documentId,
    required this.documentUrl,
    this.startPage,
    this.thumbnailUrl,
    required this.active,
  });

  factory TrainingScheduleItem.fromJson(Map<String, dynamic> json) {
    return TrainingScheduleItem(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'],
      chapter: json['chapter'],
      order: json['order'] ?? 0,
      documentId: (json['documentId'] ?? json['document_id']) as int,
      documentUrl: (json['documentUrl'] ?? json['document_url']) as String,
      startPage: json['startPage'] ?? json['start_page'],
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail_url'],
      active: json['active'] ?? true,
    );
  }
}
