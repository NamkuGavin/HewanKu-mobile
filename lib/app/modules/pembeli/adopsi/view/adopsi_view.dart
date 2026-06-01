import 'package:flutter/material.dart';

import '../widgets/adopsi_featured_section.dart';
import '../widgets/adopsi_filter_chips.dart';
import '../widgets/adopsi_list_section.dart';
import '../widgets/adopsi_search_bar.dart';
import '../widgets/hewan_model.dart';
import '../../../../common/contant/assets.dart';

class AdopsiView extends StatelessWidget {
  const AdopsiView({super.key});

  static const List<HewanModel> _rekomendasiItems = [
    HewanModel(
      name: 'Anjing Chuahua',
      shelter: 'Shelter Hewan Abadi',
      priceRange: '-',
      rating: 5.0,
      reviewCount: 5,
      tags: ['Anjing'],
      imageUrl: ImageAsset.anjingChuahua,
      fallbackColorValue: 0xFFD4C5A9,
    ),
    HewanModel(
      name: 'Iguana',
      shelter: 'Shelter Hewan Abadi',
      priceRange: '-',
      rating: 5.0,
      reviewCount: 5,
      tags: ['Iguana'],
      imageUrl: ImageAsset.iguana,
      fallbackColorValue: 0xFF8B9E5A,
    ),
    HewanModel(
      name: 'Kura-kura',
      shelter: 'Shelter Hewan Abadi',
      priceRange: '-',
      rating: 5.0,
      reviewCount: 5,
      tags: ['Kura-kura'],
      imageUrl: ImageAsset.kuraKura,
      fallbackColorValue: 0xFF7B8B6A,
    ),
  ];

  static const List<HewanModel> _topRatedItems = [
    HewanModel(
      name: 'Kucing Sphynx',
      shelter: 'Shelter Hewan Abadi',
      priceRange: '-',
      rating: 5.0,
      reviewCount: 5,
      tags: ['Kucing'],
      imageUrl: ImageAsset.kucingSphynx,
      fallbackColorValue: 0xFFD8C4B0,
    ),
    HewanModel(
      name: 'British Short Hair',
      shelter: 'Shelter Hewan Abadi',
      priceRange: '-',
      rating: 5.0,
      reviewCount: 5,
      tags: ['Kucing'],
      imageUrl: ImageAsset.britishShorthair,
      fallbackColorValue: 0xFF8A9BAB,
    ),
    HewanModel(
      name: 'Kura-kura',
      shelter: 'Shelter Hewan Abadi',
      priceRange: '-',
      rating: 5.0,
      reviewCount: 5,
      tags: ['Kura-kura'],
      imageUrl: ImageAsset.kuraKura,
      fallbackColorValue: 0xFF7B8B6A,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdopsiSearchBar(),
          const AdopsiFilterChips(),
          const SizedBox(height: 20),
          const AdopsiFeaturedSection(),
          const SizedBox(height: 24),
          AdopsiListSection(
            title: 'Top Sales',
            subtitle: 'Kami pilihin hewan kesukaanmu',
            items: _rekomendasiItems,
          ),
          const SizedBox(height: 24),
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