import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Header logo
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.orange, Color(0xFFFF9500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.orange.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.menu_book_rounded,
                    color: Colors.white, size: 34),
              ),
              const SizedBox(height: 24),
              // Video placeholder
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1F2B4A), Color(0xFF16213E)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.orange.withOpacity(0.2), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.orange.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppTheme.orange,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Vídeo de Boas-vindas',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Bem-vindo(a) à Formação\npara Professores!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Esta estrutura de formação foi construída para lhe entregar as mais atualizadas práticas pedagógicas e metodologias educacionais. Estamos abertos a comentários, sugestões e avaliações.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
              ),
              const Spacer(),
              AppButton(
                label: 'VAMOS COMEÇAR!',
                onPressed: () => context.go('/home'),
                icon: Icons.arrow_forward,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
