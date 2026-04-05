import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/badges/models/badge.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  final bool conquistado;

  const BadgeCard({
    super.key,
    required this.badge,
    required this.conquistado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: conquistado ? AppTheme.cardBackground : AppTheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: conquistado
            ? Border.all(color: AppTheme.orange, width: 2)
            : Border.all(color: Colors.white.withOpacity(0.06), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.emoji_events_rounded,
                size: 44,
                color: conquistado
                    ? AppTheme.orange
                    : AppTheme.textSecondary.withOpacity(0.18),
              ),
              if (!conquistado)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.textSecondary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.lock,
                      size: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            badge.nome,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: conquistado
                  ? AppTheme.textPrimary
                  : AppTheme.textSecondary.withOpacity(0.55),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
