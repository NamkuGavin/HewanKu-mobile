import 'package:flutter/material.dart';

class AppNetImage extends StatelessWidget {
  final String url;
  final Color fallbackColor;
  final BoxFit fit;

  const AppNetImage({
    super.key,
    required this.url,
    required this.fallbackColor,
    this.fit = BoxFit.cover,
  });

  // Kalau tidak diawali 'http' → dianggap asset lokal
  bool get _isAsset => !url.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(
        url,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            Container(color: fallbackColor),
      );
    }

    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: fallbackColor.withValues(alpha: 0.35),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFF87537),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) =>
          Container(color: fallbackColor),
    );
  }
}