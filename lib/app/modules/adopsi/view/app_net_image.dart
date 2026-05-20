import 'package:flutter/material.dart';

/// Widget gambar dari URL network dengan loading indicator dan fallback warna.
/// Dipakai bersama oleh semua modul (home, adopsi, dsb).
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

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: fallbackColor.withOpacity(0.35),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFF87537),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(color: fallbackColor),
    );
  }
}