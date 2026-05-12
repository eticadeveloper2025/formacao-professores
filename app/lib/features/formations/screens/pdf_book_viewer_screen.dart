import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import '../../../core/theme/app_theme.dart';

class PdfBookViewerScreen extends StatefulWidget {
  final String assetPath;
  final String title;

  const PdfBookViewerScreen({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  State<PdfBookViewerScreen> createState() => _PdfBookViewerScreenState();
}

class _PdfBookViewerScreenState extends State<PdfBookViewerScreen> {
  late final PdfControllerPinch _controller;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(
      document: PdfDocument.openAsset(widget.assetPath),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Image.asset(
          'assets/images/BASTA-logo2.png',
          height: 36,
          fit: BoxFit.contain,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppTheme.secondary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfViewPinch(
              controller: _controller,
              onDocumentLoaded: (doc) {
                setState(() => _totalPages = doc.pagesCount);
              },
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                options: const DefaultBuilderOptions(),
                documentLoaderBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.brandOrange,
                  ),
                ),
                pageLoaderBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.brandOrange,
                  ),
                ),
                errorBuilder: (_, error) => Center(
                  child: Text(
                    'Erro ao carregar PDF',
                    style: const TextStyle(color: AppTheme.error),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: AppTheme.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => _controller.previousPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  ),
                ),
                Text(
                  _totalPages > 0 ? '$_currentPage / $_totalPages' : '...',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => _controller.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeIn,
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
