class RegisterRequest {
  final String nome;
  final String email;
  final String senha;
  final String codigoAcesso;
  final int schoolId;
  final String nivelAcesso;

  RegisterRequest({
    required this.nome,
    required this.email,
    required this.senha,
    required this.codigoAcesso,
    required this.schoolId,
    required this.nivelAcesso,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'senha': senha,
        'codigoAcesso': codigoAcesso,
        'schoolId': schoolId,
        'nivelAcesso': nivelAcesso,
      };
}
