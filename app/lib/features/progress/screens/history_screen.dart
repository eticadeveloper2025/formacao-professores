import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../models/user_progress.dart';
import '../providers/progress_provider.dart';

// Paleta reutilizada para thumbnails de progresso
const List<List<Color>> _kProgressGradients = [
  [Color(0xFF00B4D8), Color(0xFF0077B6)],
  [Color(0xFF2DC653), Color(0xFF007200)],
  [Color(0xFFFF4D6D), Color(0xFF9D0208)],
  [Color(0xFFFFB703), Color(0xFFE85D04)],
  [Color(0xFF7209B7), Color(0xFF3A0CA3)],
  [Color(0xFF4CC9F0), Color(0xFF4361EE)],
  [Color(0xFFF72585), Color(0xFF7209B7)],
  [Color(0xFF06D6A0), Color(0xFF118AB2)],
];

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(myProgressProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Histórico de Formação'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: progressAsync.when(
        data: (progressList) => progressList.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma formação iniciada ainda',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: progressList.length,
                itemBuilder: (context, index) {
                  final p = progressList[index];
                  return _ProgressCard(progress: p, index: index);
                },
              ),
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.orange)),
        error: (e, _) => Center(
            child: Text('Erro: $e',
                style: const TextStyle(color: AppTheme.error))),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final UserProgress progress;
  final int index;

  const _ProgressCard({required this.progress, required this.index});

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        _kProgressGradients[index % _kProgressGradients.length];
    final percent = progress.percentual.clamp(0.0, 100.0);

    return GestureDetector(
      onTap: () =>
          context.push('/formations/${progress.formationId}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail area with progress ring overlay
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background gradient or image
                    progress.thumbUrl != null &&
                            progress.thumbUrl!.isNotEmpty
                        ? Image.network(progress.thumbUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _gradientBg(gradientColors))
                        : _gradientBg(gradientColors),
                    // Dark overlay
                    Container(
                        color: Colors.black.withOpacity(0.35)),
                    // Progress ring centered
                    Center(
                      child: _ProgressRingPainter(percent: percent),
                    ),
                  ],
                ),
              ),
            ),
            // Formation name
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.formationNome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${progress.modulosConcluidos}/${progress.totalModulos} módulos',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientBg(List<Color> colors) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends StatelessWidget {
  final double percent;
  const _ProgressRingPainter({required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 62,
      child: CustomPaint(
        painter: _RingPainter(percent: percent),
        child: Center(
          child: Text(
            '${percent.toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  _RingPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 5.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -3.14159 / 2;
    final sweepAngle = 2 * 3.14159 * (percent / 100);

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    final color = percent >= 100
        ? AppTheme.green
        : percent > 0
            ? AppTheme.orange
            : Colors.grey;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.percent != percent;
}
