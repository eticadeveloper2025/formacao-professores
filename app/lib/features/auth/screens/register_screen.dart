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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final schoolsAsync = ref.watch(schoolsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Cadastro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Criar sua conta',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Preencha os dados para acessar as formações',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  label: 'Nome completo',
                  controller: _nomeController,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe o email';
                    if (!v.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                schoolsAsync.when(
                  data: (schools) => DropdownButtonFormField<int>(
                    value: _selectedSchoolId,
                    decoration: const InputDecoration(
                      labelText: 'Escola',
                      prefixIcon: Icon(Icons.business, color: AppTheme.textSecondary),
                    ),
                    dropdownColor: AppTheme.secondary,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    items: schools.map((s) {
                      return DropdownMenuItem(value: s['id'] as int, child: Text(s['nome']));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedSchoolId = v),
                  ),
                  loading: () => const CircularProgressIndicator(color: AppTheme.orange),
                  error: (_, __) => const Text('Erro ao carregar escolas', style: TextStyle(color: AppTheme.error)),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedNivel,
                  decoration: const InputDecoration(
                    labelText: 'Nível de acesso',
                    prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.textSecondary),
                  ),
                  dropdownColor: AppTheme.secondary,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  items: _niveis.map((n) {
                    return DropdownMenuItem(value: n, child: Text(n));
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedNivel = v!),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Senha',
                  controller: _senhaController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe a senha';
                    if (v.length < 6) return 'Senha deve ter no mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Confirmar senha',
                  controller: _confirmSenhaController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) {
                    if (v != _senhaController.text) return 'Senhas não conferem';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Código de acesso',
                  controller: _codigoController,
                  prefixIcon: Icons.vpn_key_outlined,
                  validator: (v) => v == null || v.isEmpty ? 'Informe o código de acesso' : null,
                ),
                const SizedBox(height: 8),
                if (authState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      authState.error!,
                      style: const TextStyle(color: AppTheme.error, fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Cadastrar',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
