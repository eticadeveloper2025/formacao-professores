import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/app_theme.dart';

class CircularProgressWidget extends StatelessWidget {
  final double percent;
  final double radius;
  final String? label;

  const CircularProgressWidget({
    super.key,
    required this.percent,
    this.radius = 50,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: 8.0,
      percent: (percent / 100).clamp(0.0, 1.0),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${percent.toInt()}%',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (label != null)
            Text(
              label!,
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
            ),
        ],
      ),
      progressColor: AppTheme.green,
      backgroundColor: AppTheme.secondary,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
