class PdfDocumentInfo {
  final int id;
  final String title;
  final String assetPath;

  const PdfDocumentInfo({
    required this.id,
    required this.title,
    required this.assetPath,
  });
}

class PdfDocumentRegistry {
  static const Map<int, PdfDocumentInfo> documents = {
    1: PdfDocumentInfo(
      id: 1,
      title: 'Anos Iniciais - Aluna',
      assetPath: 'assets/pdfs/basta/anos_iniciais_mulher.pdf',
    ),
    2: PdfDocumentInfo(
      id: 2,
      title: 'Anos Iniciais - Aluno',
      assetPath: 'assets/pdfs/basta/anos_iniciais_homem.pdf',
    ),
    3: PdfDocumentInfo(
      id: 3,
      title: 'Anos Iniciais - Professor',
      assetPath: 'assets/pdfs/basta/anos_iniciais_professor.pdf',
    ),
    4: PdfDocumentInfo(
      id: 4,
      title: 'Anos Finais - Aluna',
      assetPath: 'assets/pdfs/basta/anos_finais_mulher.pdf',
    ),
    5: PdfDocumentInfo(
      id: 5,
      title: 'Anos Finais - Aluno',
      assetPath: 'assets/pdfs/basta/anos_finais_homem.pdf',
    ),
    10: PdfDocumentInfo(
      id: 10,
      title: 'Anos Finais - Professor',
      assetPath: 'assets/pdfs/basta/anos_finais_professor.pdf',
    ),
  };

  static PdfDocumentInfo? findById(int id) => documents[id];
}
