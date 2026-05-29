import 'package:flutter/material.dart';

import '../widgets/adopsi_featured_section.dart';
import '../widgets/adopsi_filter_chips.dart';
import '../widgets/adopsi_list_section.dart';
import '../widgets/adopsi_search_bar.dart';
import '../../../common/contant/assets.dart';

class AdopsiView extends StatelessWidget {
  const AdopsiView({super.key});

  static const List<AdopsiHewanItem> _rekomendasiItems = [
    AdopsiHewanItem(
      name: 'Anjing Chuahua',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: ImageAsset.anjingChuahua,
      fallback: Color(0xFFD4C5A9),
    ),
    AdopsiHewanItem(
      name: 'Iguna',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: ImageAsset.iguana,
      fallback: Color(0xFF8B9E5A),
    ),
    AdopsiHewanItem(
      name: 'Kura-kura',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: ImageAsset.kuraKura,
      fallback: Color(0xFF7B8B6A),
    ),
  ];

  static const List<AdopsiHewanItem> _topRatedItems = [
    AdopsiHewanItem(
      name: 'Kucing Sphynx',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: ImageAsset.kucingSphynx,
      fallback: Color(0xFFD8C4B0),
    ),
    AdopsiHewanItem(
      name: 'British Short Hair',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: ImageAsset.britishShorthair,
      fallback: Color(0xFF8A9BAB),
    ),
    AdopsiHewanItem(
      name: 'Kura-kura',
      shelter: 'Shelter Hewan Abadi',
      rating: 5.0,
      reviewCount: 5,
      url: ImageAsset.kuraKura,
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
            title: 'Top Sales',
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