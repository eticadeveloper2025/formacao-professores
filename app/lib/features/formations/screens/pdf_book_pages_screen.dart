import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import '../../../core/theme/app_theme.dart';

class PdfBookPagesScreen extends StatefulWidget {
  final String assetPath;
  final String title;

  const PdfBookPagesScreen({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  State<PdfBookPagesScreen> createState() => _PdfBookPagesScreenState();
}

class _PdfBookPagesScreenState extends State<PdfBookPagesScreen> {
  PdfDocument? _document;
  int _pagesCount = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final doc = await PdfDocument.openAsset(widget.assetPath);
      if (mounted) {
        setState(() {
          _document = doc;
          _pagesCount = doc.pagesCount;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _document?.close();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: AppTheme.brandOrange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.brandOrange,
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Text(
                          'Erro ao carregar: $_error',
                          style: const TextStyle(color: AppTheme.error),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _pagesCount,
                        itemBuilder: (context, index) {
                          final pageNumber = index + 1;
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                '/book-viewer',
                                extra: {
                                  'assetPath': widget.assetPath,
                                  'title': widget.title,
                                  'initialPage': pageNumber,
                                },
                              );
                            },
                            child: _PageThumbnail(
                              document: _document!,
                              pageNumber: pageNumber,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _PageThumbnail extends StatefulWidget {
  final PdfDocument document;
  final int pageNumber;

  const _PageThumbnail({
    required this.document,
    required this.pageNumber,
  });

  @override
  State<_PageThumbnail> createState() => _PageThumbnailState();
}

class _PageThumbnailState extends State<_PageThumbnail> {
  PdfPageImage? _image;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _render();
  }

  Future<void> _render() async {
    try {
      final page = await widget.document.getPage(widget.pageNumber);
      final image = await page.render(
        width: page.width * 0.5,
        height: page.height * 0.5,
        backgroundColor: '#ffffff',
      );
      await page.close();
      if (mounted) {
        setState(() {
          _image = image;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.secondary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: AppTheme.brandOrange,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    if (_image == null) {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.secondary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Icon(Icons.broken_image, color: AppTheme.textSecondary),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.memory(
        _image!.bytes,
        fit: BoxFit.cover,
      ),
    );
  }
}
