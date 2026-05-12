import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import '../../../core/theme/app_theme.dart';

class PdfBookViewerScreen extends StatefulWidget {
  final String assetPath;
  final String title;
  final int initialPage;

  const PdfBookViewerScreen({
    super.key,
    required this.assetPath,
    required this.title,
    this.initialPage = 1,
  });

  @override
  State<PdfBookViewerScreen> createState() => _PdfBookViewerScreenState();
}

class _PdfBookViewerScreenState extends State<PdfBookViewerScreen> {
  late final PdfController _controller;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _controller = PdfController(
      document: PdfDocument.openAsset(widget.assetPath),
      initialPage: widget.initialPage,
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
        backgroundColor: AppTheme.secondary,
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
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PdfView(
                  controller: _controller,
                  onDocumentLoaded: (doc) {
                    setState(() => _totalPages = doc.pagesCount);
                  },
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  builders: PdfViewBuilders<DefaultBuilderOptions>(
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
                    errorBuilder: (_, error) => const Center(
                      child: Text(
                        'Erro ao carregar PDF',
                        style: TextStyle(color: AppTheme.error),
                      ),
                    ),
                  ),
                ),
                // Seta esquerda — centralizada verticalmente
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavArrow(
                      icon: Icons.arrow_back_ios_rounded,
                      onPressed: () => _controller.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                ),
                // Seta direita — centralizada verticalmente
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavArrow(
                      icon: Icons.arrow_forward_ios_rounded,
                      onPressed: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _AudioPlayerPlaceholder(pageNumber: _currentPage),
        ],
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavArrow({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
      ),
    );
  }
}

class _AudioPlayerPlaceholder extends StatelessWidget {
  final int pageNumber;

  const _AudioPlayerPlaceholder({required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.secondary,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Orientações página $pageNumber.mp3',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                '0:00',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: SliderComponentShape.noOverlay,
                    activeTrackColor: AppTheme.brandOrange,
                    inactiveTrackColor: AppTheme.background,
                    thumbColor: AppTheme.brandOrange,
                    disabledActiveTrackColor: AppTheme.brandOrange,
                    disabledInactiveTrackColor: AppTheme.background,
                    disabledThumbColor: AppTheme.brandOrange,
                  ),
                  child: Slider(value: 0, onChanged: null),
                ),
              ),
              const Text(
                '0:00',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.textSecondary),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '1x',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppTheme.brandOrange,
                  shape: BoxShape.circle,
                ),
                child: const IconButton(
                  icon: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: null,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: AppTheme.textSecondary,
                ),
                onPressed: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
