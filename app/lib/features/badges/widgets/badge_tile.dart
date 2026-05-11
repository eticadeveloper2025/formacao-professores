import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/badge.dart';

/// Tile de badge estilo "colecionável" — pronto para receber imagem real futuramente.
/// - [badge.conquistado] == true → arte viva com borda laranja
/// - [badge.conquistado] == false → tile escurecido com cadeado
class BadgeTile extends StatelessWidget {
  final BadgeModel badge;

  const BadgeTile({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.conquistado;
    final hasImage = badge.imagemUrl != null && badge.imagemUrl!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color:
                  unlocked ? const Color(0xFF1E2A47) : const Color(0xFF161E30),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: unlocked
                    ? AppTheme.brandOrange.withOpacity(0.65)
                    : Colors.white.withOpacity(0.07),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: unlocked && hasImage
                  ? Image.network(
                      badge.imagemUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(unlocked),
                    )
                  : _placeholder(unlocked),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          badge.nome,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: unlocked
                ? AppTheme.textPrimary
                : AppTheme.textSecondary.withOpacity(0.5),
            fontSize: 10,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _placeholder(bool unlocked) {
    if (unlocked) {
      return Container(
        color: const Color(0xFF253550),
        child: const Center(
          child: Icon(
            Icons.emoji_events_rounded,
            color: AppTheme.brandOrange,
            size: 38,
          ),
        ),
      );
    }
    return Container(
      color: const Color(0xFF131A28),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.emoji_events_rounded,
            color: AppTheme.textSecondary.withOpacity(0.15),
            size: 38,
          ),
          const Positioned(
            bottom: 10,
            right: 10,
            child: Icon(
              Icons.lock_rounded,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
