import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/page_reminder.dart';

class PageReminderPlayer extends StatefulWidget {
  final PageReminder reminder;

  const PageReminderPlayer({super.key, required this.reminder});

  @override
  State<PageReminderPlayer> createState() => _PageReminderPlayerState();
}

class _PageReminderPlayerState extends State<PageReminderPlayer> {
  static VideoPlayerController? _activeController;

  late final VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.reminder.mediaUrl));
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _controller.initialize();
      _controller.addListener(_onTick);
      if (mounted) setState(() => _isInitialized = true);
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (_activeController == _controller) {
      _activeController = null;
    }
    _controller.removeListener(_onTick);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (!_isInitialized) return;
    if (_controller.value.isPlaying) {
      await _controller.pause();
      return;
    }

    if (_activeController != null && _activeController != _controller) {
      await _activeController!.pause();
    }
    _activeController = _controller;
    await _controller.play();
  }

  Future<void> _restart() async {
    if (!_isInitialized) return;
    await _controller.seekTo(Duration.zero);
    if (_activeController != null && _activeController != _controller) {
      await _activeController!.pause();
    }
    _activeController = _controller;
    await _controller.play();
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const _PlayerShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: AppTheme.error, size: 36),
            SizedBox(height: 8),
            Text(
              'Não foi possível carregar este lembrete.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return const _PlayerShell(
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.brandOrange),
        ),
      );
    }

    final value = _controller.value;
    final position = value.position;
    final duration = value.duration;

    return _PlayerShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: value.aspectRatio == 0 ? 16 / 9 : value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  if (!value.isPlaying)
                    Container(
                      color: Colors.black38,
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                        size: 58,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.reminder.title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.reminder.description,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: AppTheme.brandOrange,
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${_format(position)} / ${_format(duration)}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Semantics(
                button: true,
                label:
                    value.isPlaying ? 'Pausar lembrete' : 'Reproduzir lembrete',
                child: IconButton(
                  onPressed: _togglePlay,
                  icon: Icon(
                    value.isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: AppTheme.brandOrange,
                    size: 34,
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: 'Reiniciar lembrete',
                child: IconButton(
                  onPressed: _restart,
                  icon: const Icon(
                    Icons.replay_rounded,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              iconColor: AppTheme.brandOrange,
              collapsedIconColor: AppTheme.textSecondary,
              title: const Text(
                'Ver transcrição',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.reminder.transcript,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerShell extends StatelessWidget {
  final Widget child;

  const _PlayerShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: child,
      ),
    );
  }
}
