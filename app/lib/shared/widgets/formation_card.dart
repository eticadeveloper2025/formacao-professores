import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/formations/models/formation.dart';

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
    final logoAsset = _kFormationLogos[formation.id];

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: logoAsset != null
                    ? Image.asset(
                        logoAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _FallbackThumb(nome: formation.nome),
                      )
                    : _FallbackThumb(nome: formation.nome),
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
}

class _FallbackThumb extends StatelessWidget {
  final String nome;
  const _FallbackThumb({required this.nome});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(nome);
    return Container(
      color: AppTheme.secondary,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
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
