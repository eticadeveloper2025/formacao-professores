import 'package:flutter/material.dart';
import '../../../shared/widgets/badge_card.dart';
import '../models/badge.dart';

class BadgeGrid extends StatelessWidget {
  final List<BadgeModel> badges;

  const BadgeGrid({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return BadgeCard(badge: badge, conquistado: badge.conquistado);
      },
    );
  }
}
