import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class MessageVideoPlayerScreen extends StatefulWidget {
  const MessageVideoPlayerScreen({required this.videoUrl, super.key});

  final String videoUrl;

  @override
  State<MessageVideoPlayerScreen> createState() =>
      _MessageVideoPlayerScreenState();
}

class _MessageVideoPlayerScreenState extends State<MessageVideoPlayerScreen> {
  late final VideoPlayerController _controller;
  Future<void>? _initializeFuture;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  Object? _initializationError;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeFuture = _controller
        .initialize()
        .timeout(const Duration(seconds: 12))
        .then((_) {
          _controller.play();
          _scheduleControlsAutoHide();
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object error) {
          _initializationError = error;
          if (!mounted) {
            return;
          }
          setState(() {});
        });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleControlsAutoHide() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showControls = false;
      });
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _scheduleControlsAutoHide();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
    _scheduleControlsAutoHide();
  }

  Future<void> _openExternally() async {
    final Uri uri = Uri.parse(widget.videoUrl);
    final bool canOpen = await canLaunchUrl(uri);
    if (!canOpen) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          final l10n = context.l10n;
          final bool hasPlayerError =
              _initializationError != null || snapshot.hasError;
          if (hasPlayerError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.mediaVideoLoadFailed,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _initializationError = null;
                            });
                            _initializeFuture = _controller
                                .initialize()
                                .timeout(const Duration(seconds: 12))
                                .then((_) {
                                  _controller.play();
                                  _scheduleControlsAutoHide();
                                  if (mounted) {
                                    setState(() {});
                                  }
                                })
                                .catchError((Object error) {
                                  _initializationError = error;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                          },
                          child: Text(l10n.retry),
                        ),
                        OutlinedButton(
                          onPressed: _openExternally,
                          child: Text(l10n.mediaOpenExternally),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.close),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState != ConnectionState.done ||
              !_controller.value.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }

          return GestureDetector(
            onTap: _toggleControlsVisibility,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 12,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: _showControls ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !_showControls,
                      child: SurfaceIconButton(
                        variant: SurfaceIconVariant.ghost,
                        icon: Icons.close,
                        onPressed: () => Navigator.of(context).pop(),
                        margin: EdgeInsets.zero,
                        foregroundColor: Colors.white,
                        tooltip: context.l10n.close,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: _showControls ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !_showControls,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
                        color: Colors.black.withAlpha(120),
                        child: Row(
                          children: [
                            SurfaceIconButton(
                              variant: SurfaceIconVariant.ghost,
                              icon: _controller.value.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              onPressed: _togglePlayPause,
                              margin: EdgeInsets.zero,
                              dimension: 40,
                              iconSize: 28,
                              foregroundColor: Colors.white,
                            ),
                            Expanded(
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: EdgeInsets.zero,
                                colors: VideoProgressColors(
                                  playedColor: Colors.white,
                                  bufferedColor: Colors.white.withAlpha(100),
                                  backgroundColor: Colors.white.withAlpha(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
