class User {
  final int id;
  final String nome;
  final String email;
  final String nivelAcesso;
  final String? avatarUrl;
  final Map<String, dynamic>? school;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.nivelAcesso,
    this.avatarUrl,
    this.school,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      nivelAcesso: json['nivel_acesso'] ?? 'professor',
      avatarUrl: json['avatar_url'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'nivel_acesso': nivelAcesso,
        'avatar_url': avatarUrl,
        'school': school,
      };
}
