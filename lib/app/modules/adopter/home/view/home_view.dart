import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_search_bar.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_category_section.dart';
import '../widgets/home_featured_section.dart';
import '../widgets/home_news_section.dart';

class HomeView extends StatelessWidget {
  final VoidCallback? onGoToAdopsi;
  final ValueChanged<int>? onTabTap; // ← callback untuk pindah tab

  const HomeView({super.key, this.onGoToAdopsi, this.onTabTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSearchBar(),
          SizedBox(height: 12.h),
          HomeHeroBanner(onAdopsiTap: onGoToAdopsi),
          SizedBox(height: 28.h),
          HomeCategorySection(),
          SizedBox(height: 28.h),
          HomeFeaturedSection(onTabTap: onTabTap), // ← diteruskan
          SizedBox(height: 28.h),
          HomeNewsSection(),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}