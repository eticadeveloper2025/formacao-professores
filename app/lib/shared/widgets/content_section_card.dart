import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ContentSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final bool initiallyExpanded;

  const ContentSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Icon(icon, color: AppTheme.brandOrange),
          iconColor: AppTheme.brandOrange,
          collapsedIconColor: AppTheme.textSecondary,
          title: Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
