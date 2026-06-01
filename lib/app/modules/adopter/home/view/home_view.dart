import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_search_bar.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_category_section.dart';
import '../widgets/home_featured_section.dart';
import '../widgets/home_news_section.dart';

class HomeView extends StatelessWidget {
  // Callback ini dipanggil saat user tekan "Adopsi Sekarang"
  // navbar_view.dart yang akan handle pindah tab ke index 1 (Adopsi)
  final VoidCallback? onGoToAdopsi;

  const HomeView({super.key, this.onGoToAdopsi});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSearchBar(),
          SizedBox(height: 12.h),

          HomeHeroBanner(
            onAdopsiTap: onGoToAdopsi, // ← diteruskan dari navbar
          ),
          SizedBox(height: 28.h),

          HomeCategorySection(),
          SizedBox(height: 28.h),

          HomeFeaturedSection(),
          SizedBox(height: 28.h),

          HomeNewsSection(),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}