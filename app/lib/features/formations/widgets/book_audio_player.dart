import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget de player de áudio para leitura de livros.
/// Integra com [audioplayers] para reproduzir MP3s associados às páginas do PDF.
/// Quando [audioUrl] é null, exibe o player desabilitado (sem arquivo de áudio).
class BookAudioPlayer extends StatefulWidget {
  final String? audioUrl;
  final String? trackLabel;
  final int? currentPage;

  const BookAudioPlayer({
    super.key,
    this.audioUrl,
    this.trackLabel,
    this.currentPage,
  });

  @override
  State<BookAudioPlayer> createState() => _BookAudioPlayerState();
}

class _BookAudioPlayerState extends State<BookAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();

  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<Duration>? _positionSub;

  bool get _hasAudio => widget.audioUrl != null;

  @override
  void initState() {
    super.initState();
    _stateSub = _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });
    _durationSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _positionSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
  }

  @override
  void didUpdateWidget(covariant BookAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Quando muda de página, para o áudio e reseta
    if (oldWidget.currentPage != widget.currentPage ||
        oldWidget.audioUrl != widget.audioUrl) {
      _player.stop();
      setState(() {
        _position = Duration.zero;
        _duration = Duration.zero;
        _playerState = PlayerState.stopped;
      });
    }
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (!_hasAudio) return;
    if (_playerState == PlayerState.playing) {
      await _player.pause();
    } else {
      await _player.play(UrlSource(widget.audioUrl!));
    }
  }

  Future<void> _seek(double value) async {
    if (!_hasAudio) return;
    final pos = Duration(milliseconds: value.toInt());
    await _player.seek(pos);
  }

  void _cycleSpeed() {
    if (!_hasAudio) return;
    final speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
    final idx = speeds.indexOf(_playbackSpeed);
    final next = speeds[(idx + 1) % speeds.length];
    setState(() => _playbackSpeed = next);
    _player.setPlaybackRate(next);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get _isPlaying => _playerState == PlayerState.playing;

  @override
  Widget build(BuildContext context) {
    final trackLabel = widget.trackLabel ??
        (widget.currentPage != null
            ? 'Orientações página ${widget.currentPage}.mp3'
            : 'Arquivo de áudio');

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.secondary,
        border: Border(top: BorderSide(color: Color(0xFF2A3A5C), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF3A4A6A),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Nome do track
          Row(
            children: [
              Icon(
                Icons.music_note_rounded,
                color: _hasAudio
                    ? AppTheme.brandOrange
                    : AppTheme.textSecondary.withOpacity(0.4),
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _hasAudio
                      ? trackLabel
                      : 'Áudio não disponível para esta página',
                  style: TextStyle(
                    color: _hasAudio
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Progress slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor:
                  _hasAudio ? AppTheme.brandOrange : const Color(0xFF3A4A6A),
              inactiveTrackColor: const Color(0xFF2A3A5C),
              thumbColor:
                  _hasAudio ? AppTheme.brandOrange : const Color(0xFF3A4A6A),
              overlayColor: AppTheme.brandOrange.withOpacity(0.2),
            ),
            child: Slider(
              value: _hasAudio
                  ? _position.inMilliseconds
                      .toDouble()
                      .clamp(0, _duration.inMilliseconds.toDouble())
                  : 0,
              min: 0,
              max: _duration.inMilliseconds > 0
                  ? _duration.inMilliseconds.toDouble()
                  : 1,
              onChanged: _hasAudio ? _seek : null,
            ),
          ),

          // Tempo + controles
          Row(
            children: [
              // Tempo decorrido / total
              Text(
                _hasAudio
                    ? '${_formatDuration(_position)} / ${_formatDuration(_duration)}'
                    : '--:-- / --:--',
                style: TextStyle(
                  color:
                      AppTheme.textSecondary.withOpacity(_hasAudio ? 1.0 : 0.4),
                  fontSize: 11,
                ),
              ),
              const Spacer(),

              // Botão de velocidade
              GestureDetector(
                onTap: _hasAudio ? _cycleSpeed : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _hasAudio
                        ? AppTheme.brandOrange.withOpacity(0.12)
                        : const Color(0xFF2A3A5C),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_playbackSpeed}x',
                    style: TextStyle(
                      color: _hasAudio
                          ? AppTheme.brandOrange
                          : AppTheme.textSecondary.withOpacity(0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Botão play/pause principal
              GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _hasAudio
                        ? AppTheme.brandOrange
                        : const Color(0xFF2A3A5C),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: _hasAudio ? Colors.white : const Color(0xFF3A4A6A),
                    size: 28,
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
