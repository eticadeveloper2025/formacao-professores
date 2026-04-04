import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../progress/services/progress_service.dart';

class ModuleScreen extends ConsumerStatefulWidget {
  final int moduleId;

  const ModuleScreen({super.key, required this.moduleId});

  @override
  ConsumerState<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends ConsumerState<ModuleScreen> {
  bool _completing = false;

  Future<void> _completeModule() async {
    setState(() => _completing = true);
    try {
      await ref.read(progressServiceProvider).markCompleted(widget.moduleId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Módulo concluído! 🎉'),
            backgroundColor: AppTheme.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Módulo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_outline, color: AppTheme.orange, size: 64),
                  SizedBox(height: 8),
                  Text(
                    'Vídeo do Módulo',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '(YouTube Player)',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Descrição do módulo',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 40),
            AppButton(
              label: 'Marcar como Concluído',
              isLoading: _completing,
              onPressed: _completeModule,
              backgroundColor: AppTheme.green,
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }
}
