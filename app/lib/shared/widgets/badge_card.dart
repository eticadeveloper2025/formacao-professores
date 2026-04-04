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
            : null,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 48,
                color: conquistado ? AppTheme.orange : AppTheme.textSecondary.withOpacity(0.3),
              ),
              if (!conquistado)
                const Icon(Icons.lock, size: 20, color: AppTheme.textSecondary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            badge.nome,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: conquistado ? AppTheme.textPrimary : AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
