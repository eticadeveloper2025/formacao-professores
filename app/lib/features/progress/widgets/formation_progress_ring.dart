import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_theme.dart';
import '../models/user_progress.dart';

// Vivid ring colors cycling by formation index
const List<Color> kRingColors = [
  Color(0xFFFF6FC8), // pink
  Color(0xFF00C2FF), // cyan
  Color(0xFF7BFF6F), // green
  Color(0xFFFFD700), // gold
  Color(0xFFFF8C42), // orange
  Color(0xFF9B72FF), // purple
  Color(0xFF00FFC2), // teal
  Color(0xFFFF5252), // red
];

class FormationProgressRing extends StatelessWidget {
  final UserProgress progress;
  final Color ringColor;

  const FormationProgressRing({
    super.key,
    required this.progress,
    required this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    final percent = progress.percentual.clamp(0.0, 100.0);
    final fraction = (percent / 100.0).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 66,
          lineWidth: 9,
          percent: fraction,
          backgroundColor: Colors.white.withOpacity(0.08),
          progressColor: ringColor,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 900,
          center: _LogoPlaceholder(
            thumbUrl: progress.thumbUrl,
            accentColor: ringColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${percent.toInt()}%',
          style: TextStyle(
            color: ringColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            progress.formationNome,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.textSecondary.withOpacity(0.85),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  final String? thumbUrl;
  final Color accentColor;

  const _LogoPlaceholder({required this.thumbUrl, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    const double size = 94;
    const double radius = 13;

    if (thumbUrl != null && thumbUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          thumbUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(size, radius),
        ),
      );
    }

    return _placeholder(size, radius);
  }

  Widget _placeholder(double size, double radius) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A47),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(
        Icons.school_rounded,
        color: AppTheme.textSecondary.withOpacity(0.4),
        size: 36,
      ),
    );
  }
}
