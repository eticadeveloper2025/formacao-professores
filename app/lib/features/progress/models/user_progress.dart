class UserProgress {
  final int formationId;
  final String formationNome;
  final String? thumbUrl;
  final int totalModulos;
  final int modulosConcluidos;
  final double percentual;

  UserProgress({
    required this.formationId,
    required this.formationNome,
    this.thumbUrl,
    required this.totalModulos,
    required this.modulosConcluidos,
    required this.percentual,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      formationId: json['formation_id'],
      formationNome: json['formation_nome'],
      thumbUrl: json['thumb_url'],
      totalModulos: json['total_modulos'] ?? 0,
      modulosConcluidos: json['modulos_concluidos'] ?? 0,
      percentual: (json['percentual'] ?? 0).toDouble(),
    );
  }
}
