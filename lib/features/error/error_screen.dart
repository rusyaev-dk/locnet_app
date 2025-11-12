import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/presentation/presentation.dart';

/// A screen shown when a fatal error occurs in the application.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.error,
    required this.stackTrace,
    this.env = AppEnvType.dev,
    super.key,
    this.onRetry,
  });

  /// Error object that triggered the screen (always shown).
  final Object? error;

  /// Optional stack trace related to the error (shown only in dev/stage).
  final StackTrace? stackTrace;

  /// Current application environment.
  final AppEnvType env;

  /// Optional retry callback to relaunch the app initialization.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    // Neutral, app-agnostic theme (grayscale-oriented).
    final ThemeData neutralTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6D6D6D),
        secondary: Color(0xFF9E9E9E),
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF111111),
        error: Color(0xFFD32F2F),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE0E0E0),
          foregroundColor: const Color(0xFF111111),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
      dividerColor: const Color(0xFFE0E0E0),
      textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
    );

    final bool showStackTrace =
        env == AppEnvType.dev || env == AppEnvType.stage;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: neutralTheme,
      home: Scaffold(
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const NoGlowClampingBehavior(),
            child: Center(
              child: ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: [
                  const _HeadlinePanel(
                    titleEn:
                        'Something went wrong. Please try to reload the application.',
                    titleRu:
                        'Что-то пошло не так. Пожалуйста, попробуйте перезагрузить приложение.',
                  ),
                  const SizedBox(height: 100),
                  if (onRetry != null)
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh, size: 24),
                        label: const Text(
                          'Перезагрузить приложение / Ilovani qayta ishga tushiring',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  if (onRetry != null) const SizedBox(height: 20),
                  _CollapsiblePanel(
                    title: 'Info',
                    leading: const Icon(Icons.info_outline, size: 22),
                    child: SelectableText(
                      (error?.toString().trim().isNotEmpty ?? false)
                          ? '$error'
                          : '—',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  if (showStackTrace)
                    _CollapsiblePanel(
                      title: 'Stack trace',
                      leading: const Icon(Icons.article_outlined, size: 22),
                      child: SelectableText(
                        stackTrace?.toString() ?? '—',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeadlinePanel extends StatelessWidget {
  const _HeadlinePanel({required this.titleEn, required this.titleRu});

  final String titleEn;
  final String titleRu;

  @override
  Widget build(BuildContext context) {
    const Color panelBg = Color(0xFFFFFFFF);
    const Color panelBorder = Color(0xFFE0E0E0);
    const Color iconBg = Color(0xFFF0F0F0);
    const Color iconColor = Color(0xFF616161);
    const Color textPrimary = Color(0xFF0F0F0F);
    const Color textSecondary = Color(0xFF1A1A1A);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: panelBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // subtle shadow
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline, size: 30, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleEn,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  titleRu,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
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

/// Neutral collapsible panel with animated expand/collapse.
/// Keeps styling independent of the app theme.
class _CollapsiblePanel extends StatefulWidget {
  const _CollapsiblePanel({
    required this.title,
    required this.child,

    this.leading,
  });

  final String title;
  final Widget child;

  final Widget? leading;

  @override
  State<_CollapsiblePanel> createState() => _CollapsiblePanelState();
}

class _CollapsiblePanelState extends State<_CollapsiblePanel>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _expanded = false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: _expanded ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F0F0F),
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: Tween<double>(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: const Icon(
                      Icons.expand_more,
                      size: 22,
                      color: Color(0xFF616161),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: _expanded
                    ? const BoxConstraints()
                    : const BoxConstraints(maxHeight: 0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
