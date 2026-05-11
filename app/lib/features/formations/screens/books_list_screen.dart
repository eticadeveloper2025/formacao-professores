import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_end_drawer.dart';
import '../models/book.dart';
import '../models/formation.dart';
import '../providers/formation_provider.dart';

class BooksListScreen extends ConsumerWidget {
  final int formationId;

  const BooksListScreen({super.key, required this.formationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formationAsync = ref.watch(formationDetailProvider(formationId));

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
          'ACESSAR LIVROS',
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
      body: formationAsync.when(
        data: (formation) => _BooksListBody(formation: formation),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.brandOrange),
        ),
        error: (e, _) => Center(
          child: Text('Erro ao carregar: $e',
              style: const TextStyle(color: AppTheme.error)),
        ),
      ),
    );
  }
}

class _BooksListBody extends StatelessWidget {
  final Formation formation;

  const _BooksListBody({required this.formation});

  bool get _hasBastaBooks {
    return formation.nome.toLowerCase().contains('basta') ||
        formation.nome.toLowerCase().contains('violência contra a mulher');
  }

  String? get _localLogoAsset {
    final n = formation.nome.toLowerCase();
    if (n.contains('reforço')) return 'assets/images/logo-REFORCO-maior.png';
    if (n.contains('paz')) return 'assets/images/logo-PAZ-maior.png';
    if (n.contains('basta') || n.contains('violência contra a mulher')) {
      return 'assets/images/logo-BASTA-maior.png';
    }
    if (n.contains('feminicídio')) {
      return 'assets/images/logo-FEMINICIDIO-maior.png';
    }
    if (n.contains('afro') || n.contains('indígen')) {
      return 'assets/images/logo-AFRO-maior.png';
    }
    if (n.contains('trânsito')) return 'assets/images/logo-TRANSITO-maior.png';
    if (n.contains('energia')) return 'assets/images/logo-ENERGIA-maior.png';
    if (n.contains('dengue')) return 'assets/images/logo-DENGUE-maior.png';
    if (n.contains('empreendedor') || n.contains('adolescência')) {
      return 'assets/images/logo-ADOL-maior.png';
    }
    if (n.contains('ambiental')) return 'assets/images/logo-AMBIENT-maior.png';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final logo = _localLogoAsset;

    return CustomScrollView(
      slivers: [
        // Header com logo e título da coleção
        SliverToBoxAdapter(
          child: Container(
            color: AppTheme.secondary,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              children: [
                if (logo != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      logo,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const SizedBox(width: 80, height: 80),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formation.nome,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      if (formation.descricao != null &&
                          formation.descricao!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          formation.descricao!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Divisor
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        if (_hasBastaBooks)
          ..._buildBookSections(context)
        else
          SliverToBoxAdapter(
            child: _ComingSoonCard(formationName: formation.nome),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  List<Widget> _buildBookSections(BuildContext context) {
    final grouped = BastaBooks.grouped;
    final sections = <Widget>[];

    for (final entry in grouped.entries) {
      sections.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              entry.key,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      );

      sections.add(
        SliverToBoxAdapter(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.62,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: entry.value.length,
            itemBuilder: (ctx, i) => _BookCoverCard(book: entry.value[i]),
          ),
        ),
      );

      sections.add(
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
      );
    }

    return sections;
  }
}

class _BookCoverCard extends StatelessWidget {
  final Book book;

  const _BookCoverCard({required this.book});

  Color get _placeholderColor {
    if (book.tipo == 'Professor') return AppTheme.brandOrange;
    if (book.tipo == 'Aluno (Menino)') return const Color(0xFF4CC9F0);
    return const Color(0xFFF72585);
  }

  String get _tipoLabel {
    if (book.tipo == 'Professor') return 'Professor';
    if (book.tipo == 'Aluno (Menino)') return 'Menino';
    return 'Menina';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/book-viewer', extra: {'book': book}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.coverAsset != null
                  ? Image.asset(
                      book.coverAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _tipoLabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _placeholderColor.withOpacity(0.8),
            _placeholderColor.withOpacity(0.4),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          book.tipo == 'Professor'
              ? Icons.school_rounded
              : book.tipo == 'Aluno (Menino)'
                  ? Icons.person_rounded
                  : Icons.person_2_rounded,
          color: Colors.white.withOpacity(0.8),
          size: 40,
        ),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  final String formationName;

  const _ComingSoonCard({required this.formationName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.brandOrange.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  color: AppTheme.brandOrange.withOpacity(0.5),
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Livros em breve',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Os materiais didáticos de "$formationName" estão sendo preparados e serão disponibilizados em breve.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
