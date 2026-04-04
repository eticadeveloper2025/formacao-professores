class Formation {
  final int id;
  final String nome;
  final String? descricao;
  final String? thumbUrl;
  final int ordem;
  final bool ativo;

  Formation({
    required this.id,
    required this.nome,
    this.descricao,
    this.thumbUrl,
    required this.ordem,
    required this.ativo,
  });

  factory Formation.fromJson(Map<String, dynamic> json) {
    return Formation(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      thumbUrl: json['thumb_url'],
      ordem: json['ordem'] ?? 0,
      ativo: json['ativo'] ?? true,
    );
  }
}
