import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/formations/models/formation.dart';

// Paleta de gradientes para thumbnails das formações (fallback)
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

/// Mapeamento de keywords do nome da formação → logo local
String? _localLogoAsset(String nome) {
  final n = nome.toLowerCase();
  if (n.contains('reforço')) return 'assets/images/logo-REFORCO-maior.png';
  if (n.contains('paz')) return 'assets/images/logo-PAZ-maior.png';
  if (n.contains('basta') || n.contains('violência contra a mulher')) {
    return 'assets/images/logo-BASTA-maior.png';
  }
  if (n.contains('feminicídio'))
    return 'assets/images/logo-FEMINICIDIO-maior.png';
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
    final localLogo = _localLogoAsset(formation.nome);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: localLogo != null
                    ? Image.asset(
                        localLogo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _GradientThumb(
                          colors: gradientColors,
                          initials: _initials(formation.nome),
                        ),
                      )
                    : (formation.thumbUrl != null &&
                            formation.thumbUrl!.isNotEmpty
                        ? Image.network(
                            formation.thumbUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _GradientThumb(
                              colors: gradientColors,
                              initials: _initials(formation.nome),
                            ),
                          )
                        : _GradientThumb(
                            colors: gradientColors,
                            initials: _initials(formation.nome),
                          )),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formation.nome,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String nome) {
    final words = nome.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }
}

class _GradientThumb extends StatelessWidget {
  final List<Color> colors;
  final String initials;
  const _GradientThumb({required this.colors, required this.initials});

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
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
