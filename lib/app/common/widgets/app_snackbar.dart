import 'dart:async';

import 'package:flutter/material.dart';

enum AppSnackbarType { success, warning, error }

class AppSnackbar {
  AppSnackbar._();

  static OverlayEntry? _entry;

  static void show(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.error,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true) ?? Navigator.maybeOf(context, rootNavigator: true)?.overlay;
    if (overlay == null) {
      return;
    }

    _removeCurrent();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _OverlaySnackbar(
        message: message,
        type: type,
        duration: duration,
        onDismissed: () {
          if (_entry == entry) {
            _removeCurrent();
          }
        },
      ),
    );

    _entry = entry;
    overlay.insert(entry);
  }

  static void _removeCurrent() {
    _entry?.remove();
    _entry = null;
  }
}

class _OverlaySnackbar extends StatefulWidget {
  final String message;
  final AppSnackbarType type;
  final Duration duration;
  final VoidCallback onDismissed;

  const _OverlaySnackbar({required this.message, required this.type, required this.duration, required this.onDismissed});

  @override
  State<_OverlaySnackbar> createState() => _OverlaySnackbarState();
}

class _OverlaySnackbarState extends State<_OverlaySnackbar> {
  Timer? _dismissTimer;
  bool _isVisible = false;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      setState(() => _isVisible = true);
      _dismissTimer = Timer(widget.duration, _dismiss);
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  void _dismiss() {
    if (_isClosing || !mounted) {
      return;
    }

    _isClosing = true;
    _dismissTimer?.cancel();
    setState(() => _isVisible = false);
    Future<void>.delayed(const Duration(milliseconds: 220), () {
      widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = _SnackbarConfig.fromType(widget.type);

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: _dismiss,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                offset: _isVisible ? Offset.zero : const Offset(0, -1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: _isVisible ? 1 : 0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Material(
                      color: Colors.transparent,
                      child: _SnackbarCard(
                        icon: config.icon,
                        iconColor: config.iconColor,
                        backgroundColor: config.backgroundColor,
                        borderColor: config.borderColor,
                        message: widget.message,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SnackbarCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final String message;

  const _SnackbarCard({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2937), height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnackbarConfig {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  const _SnackbarConfig({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  factory _SnackbarConfig.fromType(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return const _SnackbarConfig(
          icon: Icons.check_circle_rounded,
          iconColor: Color(0xFF1F8A4D),
          backgroundColor: Color(0xFFEAF8F0),
          borderColor: Color(0xFFCBEBD7),
        );
      case AppSnackbarType.warning:
        return const _SnackbarConfig(
          icon: Icons.warning_amber_rounded,
          iconColor: Color(0xFFB96A00),
          backgroundColor: Color(0xFFFFF6E8),
          borderColor: Color(0xFFF3D9A6),
        );
      case AppSnackbarType.error:
        return const _SnackbarConfig(
          icon: Icons.close_rounded,
          iconColor: Color(0xFFD14343),
          backgroundColor: Color(0xFFFDECEC),
          borderColor: Color(0xFFF4C5C5),
        );
    }
  }
}
