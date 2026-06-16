import 'package:flutter/material.dart';

import '../../home/widgets/home_section_placeholder.dart';
import 'adopsi_list_section.dart';
import 'hewan_model.dart';

class AdopsiFeaturedSection extends StatelessWidget {
  final List<HewanModel> items;
  final bool hasError;
  final VoidCallback onRetry;

  const AdopsiFeaturedSection({super.key, required this.items, required this.hasError, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: HomeSectionPlaceholder(
          icon: Icons.recommend_rounded,
          title: 'Rekomendasi hewan belum bisa dimuat.',
          description: 'Coba muat ulang untuk mengambil rekomendasi terbaru.',
          onRetry: onRetry,
        ),
      );
    }

    return AdopsiListSection(
      title: 'Rekomendasi',
      subtitle: 'Pilihan hewan yang cocok untuk kamu',
      items: items,
      hasError: false,
      onRetry: onRetry,
    );
  }
}
