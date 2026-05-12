import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_end_drawer.dart';

const Map<int, String> _kFormationLogos = {
  1: 'assets/images/logo-REFORCO-maior.png',
  2: 'assets/images/logo-PAZ-maior.png',
  3: 'assets/images/logo-BASTA-maior.png',
  4: 'assets/images/logo-FEMINICIDIO-maior.png',
  5: 'assets/images/logo-AFRO-maior.png',
  6: 'assets/images/logo-TRANSITO-maior.png',
  7: 'assets/images/logo-ENERGIA-maior.png',
  8: 'assets/images/logo-DENGUE-maior.png',
  9: 'assets/images/logo-ADOL-maior.png',
  10: 'assets/images/logo-AMBIENT-maior.png',
};

class FormationDetailScreen extends ConsumerStatefulWidget {
  final int formationId;

  const FormationDetailScreen({super.key, required this.formationId});

  @override
  ConsumerState<FormationDetailScreen> createState() =>
      _FormationDetailScreenState();
}

class _FormationDetailScreenState extends ConsumerState<FormationDetailScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/SID.mp4')
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo =
        _kFormationLogos[widget.formationId] ?? 'assets/images/logo-BASTA-maior.png';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Formation logo
            Image.asset(
              logo,
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            // Video player
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        }),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(_controller),
                            ValueListenableBuilder<VideoPlayerValue>(
                              valueListenable: _controller,
                              builder: (_, value, __) => value.isPlaying
                                  ? const SizedBox.shrink()
                                  : Container(
                                      color: Colors.black38,
                                      child: const Icon(
                                        Icons.play_circle_fill_rounded,
                                        color: Colors.white,
                                        size: 64,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.brandOrange),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            // ACESSAR LIVROS button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.push('/formations/${widget.formationId}/books'),
                icon: const Icon(Icons.menu_book_rounded, size: 18),
                label: const Text(
                  'ACESSAR LIVROS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
