import 'package:flutter/material.dart';

import '../view/adopsi_featured_section.dart';
import '../view/adopsi_filter_chips.dart';
import '../view/adopsi_list_section.dart';
import '../view/adopsi_search_bar.dart';

class AdopsiView extends StatelessWidget {
  const AdopsiView({super.key});

  // ── Data Rekomendasi Untukmu ──────────────────────────────────────
  static const List<AdopsiHewanItem> _rekomendasiItems = [
    AdopsiHewanItem(
      name: 'Anjing Chuahua',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: 'https://images.unsplash.com/photo-1548366086-7f1b76106622?w=300&q=80',
      fallback: Color(0xFFD4C5A9),
    ),
    AdopsiHewanItem(
      name: 'Iguna',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: 'https://images.unsplash.com/photo-1597600159211-d6c104f408d1?w=300&q=80',
      fallback: Color(0xFF8B9E5A),
    ),
    AdopsiHewanItem(
      name: 'Kura-kura',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: 'https://images.unsplash.com/photo-1562515952-f6e7ab2e0174?w=300&q=80',
      fallback: Color(0xFF7B8B6A),
    ),
  ];

  // ── Data Rating Tertinggi ─────────────────────────────────────────
  static const List<AdopsiHewanItem> _topRatedItems = [
    AdopsiHewanItem(
      name: 'Anjing Sphynx',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=300&q=80',
      fallback: Color(0xFFD8C4B0),
    ),
    AdopsiHewanItem(
      name: 'British Short Hair',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&q=80',
      fallback: Color(0xFF8A9BAB),
    ),
    AdopsiHewanItem(
      name: 'Kura-kura',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: 'https://images.unsplash.com/photo-1562515952-f6e7ab2e0174?w=300&q=80',
      fallback: Color(0xFF7B8B6A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          const AdopsiSearchBar(),

          // Filter chips kategori
          const AdopsiFilterChips(),
          const SizedBox(height: 20),

          // Hewan Unggulan — 2-column grid
          const AdopsiFeaturedSection(),
          const SizedBox(height: 24),

          // Rekomendasi Untukmu — horizontal scroll
          AdopsiListSection(
            title: 'Rekomendasi Untukmu',
            subtitle: 'Kami pilihin hewan kesukaanmu',
            items: _rekomendasiItems,
          ),
          const SizedBox(height: 24),

          // Rating Tertinggi — horizontal scroll
          AdopsiListSection(
            title: 'Rating Tertinggi',
            subtitle: 'Kami pilihin shelter dengan rating tertinggi',
            items: _topRatedItems,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}