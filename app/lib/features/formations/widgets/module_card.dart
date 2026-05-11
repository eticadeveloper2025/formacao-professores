import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/formation_module.dart';

class ModuleCard extends StatelessWidget {
  final FormationModule module;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.module, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: module.completed
              ? Border.all(color: AppTheme.green, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: module.completed
                    ? AppTheme.green.withOpacity(0.15)
                    : AppTheme.brandOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                module.completed
                    ? Icons.check_circle
                    : Icons.play_circle_outline,
                color: module.completed ? AppTheme.green : AppTheme.brandOrange,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Módulo ${module.ordem}: ${module.titulo}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (module.descricao != null)
                    Text(
                      module.descricao!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: module.completed ? AppTheme.green : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
