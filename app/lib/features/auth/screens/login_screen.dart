import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .login(_emailController.text.trim(), _senhaController.text);

    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF16213E),
                  Color(0xFF1A1A2E),
                  Color(0xFF0F1424)
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Orange top stripe + scrollable content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: AppTheme.brandOrange,
                height: MediaQuery.of(context).padding.top + 6.0,
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),
                          Center(
                            child: Image.network(
                              'https://midiasave-5c064.web.app/logoetica-branco.png',
                              height: 90,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.menu_book_rounded,
                                color: AppTheme.brandOrange,
                                size: 60,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Column(
                            children: [
                              Text(
                                'Formação para',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.brandYellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                'PROFESSORES',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 44),
                          AppTextField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Informe o email';
                              if (!v.contains('@')) return 'Email inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Senha',
                            controller: _senhaController,
                            isPassword: true,
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Informe a senha';
                              if (v.length < 6) return 'Senha muito curta';
                              return null;
                            },
                          ),
                          if (authState.error != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              authState.error!,
                              style: const TextStyle(
                                  color: AppTheme.error, fontSize: 13),
                            ),
                          ],
                          const SizedBox(height: 28),
                          AppButton(
                            label: 'ENTRAR',
                            isLoading: authState.isLoading,
                            backgroundColor: AppTheme.brandGreen,
                            onPressed: _handleLogin,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () => context.push('/register'),
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Não tem login? ',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Faça o seu cadastro',
                                      style: TextStyle(
                                        color: AppTheme.brandYellow,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
