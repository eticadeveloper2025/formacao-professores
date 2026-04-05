import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/video_player_widget.dart';
import '../../progress/services/progress_service.dart';

class ModuleScreen extends ConsumerStatefulWidget {
  final int moduleId;
  final String? titulo;
  final String? descricao;
  final String? videoUrl;

  const ModuleScreen({
    super.key,
    required this.moduleId,
    this.titulo,
    this.descricao,
    this.videoUrl,
  });

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
        title: Text(widget.titulo ?? 'Módulo'),
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
            if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty)
              VideoPlayerWidget(videoUrl: widget.videoUrl!)
            else
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1F2B4A), Color(0xFF16213E)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.orange.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppTheme.orange,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Vídeo em breve',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            if (widget.titulo != null)
              Text(
                widget.titulo!,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (widget.titulo != null) const SizedBox(height: 12),
            if (widget.descricao != null)
              Text(
                widget.descricao!,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14),
              )
            else
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
