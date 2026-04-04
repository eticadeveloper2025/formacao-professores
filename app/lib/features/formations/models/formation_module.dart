class FormationModule {
  final int id;
  final String titulo;
  final String? descricao;
  final String? videoUrl;
  final int ordem;
  final bool completed;

  FormationModule({
    required this.id,
    required this.titulo,
    this.descricao,
    this.videoUrl,
    required this.ordem,
    this.completed = false,
  });

  factory FormationModule.fromJson(Map<String, dynamic> json) {
    return FormationModule(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      videoUrl: json['video_url'],
      ordem: json['ordem'] ?? 0,
      completed: json['completed'] ?? false,
    );
  }
}
