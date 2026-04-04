import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationTile extends StatelessWidget {
  final String titulo;
  final String mensagem;
  final bool lida;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.titulo,
    required this.mensagem,
    required this.lida,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: lida ? AppTheme.secondary : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: lida ? null : Border.all(color: AppTheme.orange.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: lida ? Colors.transparent : AppTheme.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: lida ? FontWeight.normal : FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mensagem,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
