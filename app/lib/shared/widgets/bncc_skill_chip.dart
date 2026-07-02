import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BnccSkillChip extends StatelessWidget {
  final String label;

  const BnccSkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Habilidade BNCC $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.brandOrange.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: AppTheme.brandOrange.withValues(alpha: 0.45)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
