import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../core/config/app_config.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/profile_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/success_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/welcome_screen.dart';
import '../features/formations/screens/formation_detail_screen.dart';
import '../features/formations/screens/module_screen.dart';
import '../features/formations/screens/books_list_screen.dart';
import '../features/formations/screens/pdf_book_pages_screen.dart';
import '../features/formations/screens/pdf_book_viewer_screen.dart';
import '../features/formations/data/pdf_document_registry.dart';
import '../features/progress/screens/history_screen.dart';
import '../features/badges/screens/badges_screen.dart';
import '../features/syllabus/presentation/screens/syllabus_screen.dart';
import '../features/calendar/presentation/screens/calendar_screen.dart';
import '../features/calendar/presentation/screens/calendar_detail_screen.dart';
import '../features/lesson_plans/presentation/screens/lesson_plans_screen.dart';
import '../features/lesson_plans/presentation/screens/lesson_plan_detail_screen.dart';
import '../features/page_reminders/presentation/screens/page_reminders_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      try {
        const storage = FlutterSecureStorage();
        final token = await storage.read(key: AppConfig.tokenKey);
        final isLoggedIn = token != null;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        if (!isLoggedIn && !isAuthRoute) return '/login';
        if (isLoggedIn && state.matchedLocation == '/login') return '/home';
        return null;
      } catch (_) {
        // Keystore inacessível (ex: Android Keystore bloqueado, primeiro boot).
        // Redireciona para login como fallback seguro.
        return '/login';
      }
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/success', builder: (_, __) => const SuccessScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/ementa', builder: (_, __) => const SyllabusScreen()),
      GoRoute(path: '/calendario', builder: (_, __) => const CalendarScreen()),
      GoRoute(
        path: '/calendario/:id',
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CalendarDetailScreen(entryId: id);
        },
      ),
      GoRoute(
        path: '/planos-aula',
        builder: (_, __) => const LessonPlansScreen(),
      ),
      GoRoute(
        path: '/planos-aula/:id',
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LessonPlanDetailScreen(planId: id);
        },
      ),
      GoRoute(
        path: '/video-lembrete',
        builder: (_, __) => const PageRemindersScreen(),
      ),
      GoRoute(
        path: '/formations/:id',
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          return FormationDetailScreen(formationId: id);
        },
      ),
      GoRoute(
        path: '/formations/:id/books',
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BooksListScreen(formationId: id);
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
            ordem: extra?['ordem'] as int?,
            totalModulos: extra?['totalModulos'] as int?,
          );
        },
      ),
      GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
      GoRoute(path: '/badges', builder: (_, __) => const BadgesScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(
        path: '/book-pages',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PdfBookPagesScreen(
            assetPath: extra['assetPath'] as String,
            title: extra['title'] as String,
          );
        },
      ),
      GoRoute(
        path: '/book-viewer',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PdfBookViewerScreen(
            assetPath: extra['assetPath'] as String,
            title: extra['title'] as String,
            initialPage: extra['initialPage'] as int? ?? 1,
          );
        },
      ),
      GoRoute(
        path: '/pdf/:documentId',
        builder: (_, state) {
          final documentId = int.parse(state.pathParameters['documentId']!);
          final page =
              int.tryParse(state.uri.queryParameters['page'] ?? '') ?? 1;
          final extra = state.extra as Map<String, dynamic>?;
          final registered = PdfDocumentRegistry.findById(documentId);
          final assetPath =
              extra?['assetPath'] as String? ?? registered?.assetPath;
          final title = extra?['title'] as String? ?? registered?.title;

          if (assetPath == null || title == null) {
            return const PdfBookViewerScreen(
              assetPath: 'assets/pdfs/basta/anos_finais_professor.pdf',
              title: 'Cronograma Formativo',
              initialPage: 1,
            );
          }

          return PdfBookViewerScreen(
            assetPath: assetPath,
            title: title,
            initialPage: extra?['initialPage'] as int? ?? page,
          );
        },
      ),
    ],
  );
});
