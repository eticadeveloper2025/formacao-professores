import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

PreferredSizeWidget buildAuthenticatedAppBar({
  required BuildContext context,
  bool showBackButton = true,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: AppTheme.brandOrange,
    elevation: 0,
    centerTitle: true,
    leading: showBackButton
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => context.pop(),
          )
        : null,
    title: const Text(
      'FORMAÇÃO PARA PROFESSORES',
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.6,
      ),
    ),
    actions: [
      Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () => Scaffold.of(ctx).openEndDrawer(),
        ),
      ),
    ],
  );
}
