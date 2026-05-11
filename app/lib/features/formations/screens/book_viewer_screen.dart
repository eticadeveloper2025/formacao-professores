import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_end_drawer.dart';
import '../models/book.dart';
import '../widgets/book_audio_player.dart';

class BookViewerScreen extends ConsumerStatefulWidget {
  final Book book;

  const BookViewerScreen({super.key, required this.book});

  @override
  ConsumerState<BookViewerScreen> createState() => _BookViewerScreenState();
}

class _BookViewerScreenState extends ConsumerState<BookViewerScreen> {
  PdfController? _pdfController;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  void _loadPdf() {
    try {
      setState(() {
        _pdfController = PdfController(
          document: PdfDocument.openAsset(widget.book.pdfAsset),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Não foi possível abrir o livro.\n$e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  void _previousPage() {
    _pdfController?.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    _pdfController?.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

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
        title: Text(
          widget.book.titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
          overflow: TextOverflow.ellipsis,
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
        children: [
          // Indicador de página
          if (!_isLoading && _errorMessage == null)
            Container(
              color: AppTheme.secondary,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded,
                        color: AppTheme.textPrimary),
                    onPressed: _currentPage > 1 ? _previousPage : null,
                    splashRadius: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _totalPages > 0
                        ? 'Página $_currentPage de $_totalPages'
                        : 'Carregando...',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded,
                        color: AppTheme.textPrimary),
                    onPressed: _currentPage < _totalPages ? _nextPage : null,
                    splashRadius: 20,
                  ),
                ],
              ),
            ),

          // Área do PDF
          Expanded(
            child: _buildPdfArea(),
          ),

          // Player de áudio
          BookAudioPlayer(
            audioUrl: null, // Futuro: mapear audioUrl por página
            currentPage: _currentPage,
            trackLabel: '${widget.book.titulo} — Página $_currentPage',
          ),
        ],
      ),
    );
  }

  Widget _buildPdfArea() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.brandOrange),
            SizedBox(height: 16),
            Text(
              'Abrindo livro...',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppTheme.error, size: 56),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadPdf();
                },
                icon: const Icon(Icons.refresh_rounded,
                    color: AppTheme.brandOrange),
                label: const Text('Tentar novamente',
                    style: TextStyle(color: AppTheme.brandOrange)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.brandOrange),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_pdfController == null) return const SizedBox.shrink();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < -300) _nextPage();
        if (details.primaryVelocity! > 300) _previousPage();
      },
      child: PdfView(
        controller: _pdfController!,
        scrollDirection: Axis.horizontal,
        onDocumentLoaded: (document) {
          setState(() => _totalPages = document.pagesCount);
        },
        onPageChanged: (page) {
          setState(() => _currentPage = page);
        },
        builders: PdfViewBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: AppTheme.brandOrange),
          ),
          pageLoaderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: AppTheme.brandOrange),
          ),
          pageBuilder: (context, pageImage, index, document) {
            return PhotoViewGalleryPageOptions(
              imageProvider: PdfPageImageProvider(
                pageImage,
                index,
                document.id,
              ),
              // "covered" faz a página preencher a tela pela altura,
              // evitando que páginas largas (spread) apareçam em miniatura.
              initialScale: PhotoViewComputedScale.covered * 1.0,
              minScale: PhotoViewComputedScale.covered * 1.0,
              maxScale: PhotoViewComputedScale.contained * 4.0,
            );
          },
        ),
      ),
    );
  }
}
