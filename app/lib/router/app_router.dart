import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../core/config/app_config.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/success_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/welcome_screen.dart';
import '../features/formations/screens/formation_detail_screen.dart';
import '../features/formations/screens/module_screen.dart';
import '../features/progress/screens/history_screen.dart';
import '../features/badges/screens/badges_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: AppConfig.tokenKey);
      final isLoggedIn = token != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && state.matchedLocation == '/login') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/success', builder: (_, __) => const SuccessScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: '/formations/:id',
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          return FormationDetailScreen(formationId: id);
        },
      ),
      GoRoute(
        path: '/modules/:id',
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          final extra = state.extra as Map<String, dynamic>?;
          return ModuleScreen(
            moduleId: id,
            titulo: extra?['titulo'] as String?,
            descricao: extra?['descricao'] as String?,
            videoUrl: extra?['videoUrl'] as String?,
          );
        },
      ),
      GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
      GoRoute(path: '/badges', builder: (_, __) => const BadgesScreen()),
    ],
  );
});
