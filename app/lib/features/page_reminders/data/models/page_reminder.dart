class PageReminder {
  final int id;
  final String pageKey;
  final String title;
  final String description;
  final String mediaUrl;
  final String? thumbnailUrl;
  final String transcript;
  final int durationSeconds;
  final bool active;
  final int order;

  const PageReminder({
    required this.id,
    required this.pageKey,
    required this.title,
    required this.description,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.transcript,
    required this.durationSeconds,
    required this.active,
    required this.order,
  });

  factory PageReminder.fromJson(Map<String, dynamic> json) {
    return PageReminder(
      id: json['id'] as int,
      pageKey: (json['pageKey'] ?? json['page_key']) as String,
      title: json['title'] as String,
      description: json['description'] as String,
      mediaUrl: (json['mediaUrl'] ?? json['media_url']) as String,
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail_url'],
      transcript: json['transcript'] as String,
      durationSeconds:
          (json['durationSeconds'] ?? json['duration_seconds'] ?? 0) as int,
      active: json['active'] ?? true,
      order: json['order'] ?? 0,
    );
  }
}
