import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../models/register_request.dart';
import '../providers/auth_provider.dart';
import '../../home/services/home_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmSenhaController = TextEditingController();
  final _codigoController = TextEditingController();
  int? _selectedSchoolId;
  String _selectedNivel = 'professor';

  final List<String> _niveis = ['professor', 'coordenador', 'diretor'];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmSenhaController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSchoolId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma escola')),
      );
      return;
    }

    final request = RegisterRequest(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text,
      codigoAcesso: _codigoController.text.trim(),
      schoolId: _selectedSchoolId!,
      nivelAcesso: _selectedNivel,
    );

    final success = await ref.read(authProvider.notifier).register(request);
    if (success && mounted) {
      context.go('/success');
    }
  }

  InputDecoration _pillDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 15),
      filled: true,
      fillColor: AppTheme.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppTheme.brandYellow, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final schoolsAsync = ref.watch(schoolsProvider);

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Orange top stripe
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
                          const SizedBox(height: 12),
                          // Back button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: AppTheme.textPrimary,
                                size: 22,
                              ),
                              onPressed: () => context.pop(),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Logo
                          Center(
                            child: Image.network(
                              'https://midiasave-5c064.web.app/logoetica-branco.png',
                              height: 70,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.menu_book_rounded,
                                color: AppTheme.brandOrange,
                                size: 50,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Column(
                            children: [
                              Text(
                                'Formação para',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.brandYellow,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'PROFESSORES',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            label: 'Nome',
                            controller: _nomeController,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Informe o nome'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Informe o email';
                              }
                              if (!v.contains('@')) return 'Email inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          // Escola dropdown
                          schoolsAsync.when(
                            data: (schools) => DropdownButtonFormField<int>(
                              initialValue: _selectedSchoolId,
                              decoration: _pillDecoration('Escola'),
                              dropdownColor: AppTheme.secondary,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary, fontSize: 15),
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppTheme.textSecondary),
                              items: schools.map((s) {
                                return DropdownMenuItem(
                                    value: s['id'] as int,
                                    child: Text(s['nome']));
                              }).toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedSchoolId = v),
                            ),
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: CircularProgressIndicator(
                                    color: AppTheme.brandOrange,
                                    strokeWidth: 2),
                              ),
                            ),
                            error: (_, __) => const Text(
                              'Erro ao carregar escolas',
                              style: TextStyle(color: AppTheme.error),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Nível de acesso dropdown
                          DropdownButtonFormField<String>(
                            initialValue: _selectedNivel,
                            decoration: _pillDecoration('Nível de acesso'),
                            dropdownColor: AppTheme.secondary,
                            style: const TextStyle(
                                color: AppTheme.textPrimary, fontSize: 15),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: AppTheme.textSecondary),
                            items: _niveis.map((n) {
                              return DropdownMenuItem(value: n, child: Text(n));
                            }).toList(),
                            onChanged: (v) =>
                                setState(() => _selectedNivel = v!),
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Senha',
                            controller: _senhaController,
                            isPassword: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Informe a senha';
                              }
                              if (v.length < 6) {
                                return 'Senha deve ter no mínimo 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Confirmar senha',
                            controller: _confirmSenhaController,
                            isPassword: true,
                            validator: (v) {
                              if (v != _senhaController.text) {
                                return 'Senhas não conferem';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Código de acesso',
                            controller: _codigoController,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Informe o código de acesso'
                                : null,
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
                            label: 'CADASTRAR',
                            isLoading: authState.isLoading,
                            backgroundColor: AppTheme.brandGreen,
                            onPressed: _handleRegister,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Já tem cadastro? ',
                                  style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: 'Faça login',
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
