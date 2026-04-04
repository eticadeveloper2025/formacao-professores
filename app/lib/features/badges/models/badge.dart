class BadgeModel {
  final int id;
  final String nome;
  final String? descricao;
  final String? imagemUrl;
  final int criterioPercentual;
  final bool conquistado;
  final DateTime? conquistadoEm;
  final Map<String, dynamic>? formation;

  BadgeModel({
    required this.id,
    required this.nome,
    this.descricao,
    this.imagemUrl,
    required this.criterioPercentual,
    required this.conquistado,
    this.conquistadoEm,
    this.formation,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      imagemUrl: json['imagem_url'],
      criterioPercentual: json['criterio_percentual'] ?? 100,
      conquistado: json['conquistado'] ?? false,
      conquistadoEm: json['conquistado_em'] != null
          ? DateTime.tryParse(json['conquistado_em'])
          : null,
      formation: json['formation'],
    );
  }
}
