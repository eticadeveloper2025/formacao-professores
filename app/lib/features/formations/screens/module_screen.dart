import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_end_drawer.dart';
import '../../../shared/widgets/video_player_widget.dart';
import '../../progress/services/progress_service.dart';

class ModuleScreen extends ConsumerStatefulWidget {
  final int moduleId;
  final String? titulo;
  final String? descricao;
  final String? videoUrl;
  final int? ordem;
  final int? totalModulos;

  const ModuleScreen({
    super.key,
    required this.moduleId,
    this.titulo,
    this.descricao,
    this.videoUrl,
    this.ordem,
    this.totalModulos,
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
      endDrawer: const AppEndDrawer(),
      appBar: AppBar(
        backgroundColor: AppTheme.brandOrange,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            const Text(
              'FORMAÇÃO PARA PROFESSORES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
            if (widget.ordem != null && widget.totalModulos != null)
              Text(
                'Módulo ${widget.ordem} de ${widget.totalModulos}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                ),
              ),
          ],
        ),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
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
                        color: AppTheme.brandOrange.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppTheme.brandOrange,
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
