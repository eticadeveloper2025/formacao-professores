/// Modelo de livro/material didático vinculado a uma formação.
class Book {
  final String titulo;
  final String
      categoria; // 'Anos Iniciais', 'Anos Finais', 'Ensino Médio', 'EJA'
  final String tipo; // 'Aluno (Menino)', 'Aluno (Menina)', 'Professor'
  final String pdfAsset; // caminho do asset Flutter
  final String?
      audioBaseUrl; // URL base para arquivos de áudio por página (futura integração)
  final String? coverAsset; // caminho da imagem de capa (PNG em assets/images)

  const Book({
    required this.titulo,
    required this.categoria,
    required this.tipo,
    required this.pdfAsset,
    this.audioBaseUrl,
    this.coverAsset,
  });
}

/// Dados estáticos dos livros da coleção BASTA!
/// Outros livros serão adicionados quando os PDFs estiverem disponíveis.
class BastaBooks {
  static const List<Book> all = [
    // ── Anos Iniciais (1º ao 5º ano) ──────────────────────────────────
    Book(
      titulo: '1º ao 5º ano — Livro do Aluno (Menino)',
      categoria: 'Anos Iniciais',
      tipo: 'Aluno (Menino)',
      pdfAsset: 'assets/pdf/1 ao 5 ano-HOMEM-Basta.pdf',
      coverAsset: 'assets/images/anosiniciais.png',
    ),
    Book(
      titulo: '1º ao 5º ano — Livro do Aluno (Menina)',
      categoria: 'Anos Iniciais',
      tipo: 'Aluno (Menina)',
      pdfAsset: 'assets/pdf/1 ao 5 ano-MULHER-Basta.pdf',
      coverAsset: 'assets/images/anosiniciais2.png',
    ),
    Book(
      titulo: '1º ao 5º ano — Livro do Professor',
      categoria: 'Anos Iniciais',
      tipo: 'Professor',
      pdfAsset: 'assets/pdf/1 ao 5 ano-PROFESSOR-Basta.pdf',
      coverAsset: 'assets/images/anosiniciais3.png',
    ),

    // ── Anos Finais (6º ao 9º ano) ────────────────────────────────────
    Book(
      titulo: '6º ao 9º ano — Livro do Aluno (Menino)',
      categoria: 'Anos Finais',
      tipo: 'Aluno (Menino)',
      pdfAsset: 'assets/pdf/6 ao 9 ano-HOMEM-Basta.pdf',
      coverAsset: 'assets/images/anosfinais.png',
    ),
    Book(
      titulo: '6º ao 9º ano — Livro do Aluno (Menina)',
      categoria: 'Anos Finais',
      tipo: 'Aluno (Menina)',
      pdfAsset: 'assets/pdf/6 ao 9 ano-MULHER-Basta.pdf',
      coverAsset: 'assets/images/anosfinais2.png',
    ),
    Book(
      titulo: '6º ao 9º ano — Livro do Professor',
      categoria: 'Anos Finais',
      tipo: 'Professor',
      pdfAsset: 'assets/pdf/6 ao 9 ano-PROFESSOR-Basta.pdf',
      coverAsset: 'assets/images/anosfinais3.png',
    ),

    // ── Ensino Médio (1º ao 3º EM) ────────────────────────────────────
    Book(
      titulo: '1º ao 3º EM — Livro do Aluno (Menino)',
      categoria: 'Ensino Médio',
      tipo: 'Aluno (Menino)',
      pdfAsset: 'assets/pdf/1 ao 3 EM-HOMEM-Basta.pdf',
      coverAsset: 'assets/images/ensinomedio.png',
    ),
    Book(
      titulo: '1º ao 3º EM — Livro do Aluno (Menina)',
      categoria: 'Ensino Médio',
      tipo: 'Aluno (Menina)',
      pdfAsset: 'assets/pdf/1 ao 3 EM-MULHER-Basta.pdf',
      coverAsset: 'assets/images/ensinomedio2.png',
    ),
    Book(
      titulo: '1º ao 3º EM — Livro do Professor',
      categoria: 'Ensino Médio',
      tipo: 'Professor',
      pdfAsset: 'assets/pdf/1 ao 3 EM-PROFESSOR-Basta.pdf',
      coverAsset: 'assets/images/ensinomedio3.png',
    ),

    // ── EJA ────────────────────────────────────────────────────────────
    Book(
      titulo: 'EJA — Livro do Professor',
      categoria: 'EJA',
      tipo: 'Professor',
      pdfAsset: 'assets/pdf/EJA-PROFESSOR-Basta.pdf',
      coverAsset: 'assets/images/ejafoto.png',
    ),
  ];

  /// Retorna os livros agrupados por categoria na ordem correta.
  static Map<String, List<Book>> get grouped {
    final order = ['Anos Iniciais', 'Anos Finais', 'Ensino Médio', 'EJA'];
    final map = <String, List<Book>>{};
    for (final cat in order) {
      final books = all.where((b) => b.categoria == cat).toList();
      if (books.isNotEmpty) map[cat] = books;
    }
    return map;
  }
}
