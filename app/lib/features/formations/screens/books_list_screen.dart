import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_end_drawer.dart';

class _Book {
  final String title;
  final String asset;
  final String pdfAsset;

  const _Book({
    required this.title,
    required this.asset,
    required this.pdfAsset,
  });
}

class _BookSection {
  final String category;
  final List<_Book> books;

  const _BookSection({required this.category, required this.books});
}

class BooksListScreen extends StatelessWidget {
  final int formationId;

  const BooksListScreen({super.key, required this.formationId});

  static const List<_BookSection> _sections = [
    _BookSection(category: 'Anos Iniciais', books: [
      _Book(
        title: 'Aluna',
        asset: 'assets/images/anosiniciais.png',
        pdfAsset: 'assets/pdfs/basta/anos_iniciais_mulher.pdf',
      ),
      _Book(
        title: 'Aluno',
        asset: 'assets/images/anosiniciais2.png',
        pdfAsset: 'assets/pdfs/basta/anos_iniciais_homem.pdf',
      ),
      _Book(
        title: 'Professor',
        asset: 'assets/images/anosiniciais3.png',
        pdfAsset: 'assets/pdfs/basta/anos_iniciais_professor.pdf',
      ),
    ]),
    _BookSection(category: 'Anos Finais', books: [
      _Book(
        title: 'Aluna',
        asset: 'assets/images/anosfinais.png',
        pdfAsset: 'assets/pdfs/basta/anos_finais_mulher.pdf',
      ),
      _Book(
        title: 'Aluno',
        asset: 'assets/images/anosfinais2.png',
        pdfAsset: 'assets/pdfs/basta/anos_finais_homem.pdf',
      ),
      _Book(
        title: 'Professor',
        asset: 'assets/images/anosfinais3.png',
        pdfAsset: 'assets/pdfs/basta/anos_finais_professor.pdf',
      ),
    ]),
    _BookSection(category: 'Ensino Médio', books: [
      _Book(
        title: 'Aluna',
        asset: 'assets/images/ensinomedio.png',
        pdfAsset: 'assets/pdfs/basta/ensino_medio_mulher.pdf',
      ),
      _Book(
        title: 'Aluno',
        asset: 'assets/images/ensinomedio2.png',
        pdfAsset: 'assets/pdfs/basta/ensino_medio_homem.pdf',
      ),
      _Book(
        title: 'Professor',
        asset: 'assets/images/ensinomedio3.png',
        pdfAsset: 'assets/pdfs/basta/ensino_medio_professor.pdf',
      ),
    ]),
    _BookSection(category: 'EJA', books: [
      _Book(
        title: 'Professor',
        asset: 'assets/images/ejafoto.png',
        pdfAsset: 'assets/pdfs/basta/eja_professor.pdf',
      ),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      endDrawer: const AppEndDrawer(),
      appBar: AppBar(
        backgroundColor: AppTheme.brandOrange,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'FORMAÇÃO PARA PROFESSORES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            color: AppTheme.secondary,
            child: Center(
              child: Image.asset(
                'assets/images/BASTA-logo2.png',
                height: 56,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: _sections.length,
              itemBuilder: (context, sectionIndex) {
                final section = _sections[sectionIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                      child: Text(
                        section.category,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: section.books.length,
                        itemBuilder: (context, bookIndex) {
                          final book = section.books[bookIndex];
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                '/book-viewer',
                                extra: {
                                  'assetPath': book.pdfAsset,
                                  'title': book.title,
                                },
                              );
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppTheme.secondary,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  book.asset,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppTheme.secondary,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.menu_book,
                                            color: AppTheme.brandOrange,
                                            size: 32),
                                        const SizedBox(height: 6),
                                        Text(
                                          book.title,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
