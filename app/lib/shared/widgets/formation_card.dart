import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/formations/models/formation.dart';

// Paleta de gradientes para thumbnails das formações
const List<List<Color>> _kFormationGradients = [
  [Color(0xFF00B4D8), Color(0xFF0077B6)],
  [Color(0xFF2DC653), Color(0xFF007200)],
  [Color(0xFFFF4D6D), Color(0xFF9D0208)],
  [Color(0xFFFFB703), Color(0xFFE85D04)],
  [Color(0xFF7209B7), Color(0xFF3A0CA3)],
  [Color(0xFF4CC9F0), Color(0xFF4361EE)],
  [Color(0xFFF72585), Color(0xFF7209B7)],
  [Color(0xFF06D6A0), Color(0xFF118AB2)],
];

class FormationCard extends StatelessWidget {
  final Formation formation;
  final VoidCallback? onTap;

  const FormationCard({
    super.key,
    required this.formation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        _kFormationGradients[formation.id % _kFormationGradients.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: formation.thumbUrl != null &&
                        formation.thumbUrl!.isNotEmpty
                    ? Image.network(
                        formation.thumbUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _GradientThumb(colors: gradientColors),
                      )
                    : _GradientThumb(colors: gradientColors),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formation.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    if (formation.descricao != null &&
                        formation.descricao!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        formation.descricao!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientThumb extends StatelessWidget {
  final List<Color> colors;
  const _GradientThumb({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.school_rounded,
          color: Colors.white.withOpacity(0.85),
          size: 48,
        ),
      ),
    );
  }
}
