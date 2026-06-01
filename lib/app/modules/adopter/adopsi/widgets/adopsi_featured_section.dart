import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/contant/assets.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../../app/common/widgets/app_net_image.dart';
import 'hewan_model.dart';
import '../view/adopsi_detail_hewan.dart';

class AdopsiFeaturedSection extends StatelessWidget {
  const AdopsiFeaturedSection({super.key});

  static const List<HewanModel> _items = [
    HewanModel(
      name: 'Kucing Anggora',
      shelter: 'Shelter Hewan Abadi',
      priceRange: 'Rp 2.000.000',
      rating: 5.0,
      reviewCount: 0,
      tags: ['Kucing'],
      imageUrl: ImageAsset.kucingAnggora,
      fallbackColorValue: 0xFFE8DDD0,
    ),
    HewanModel(
      name: 'British Short Hair',
      shelter: 'Shelter Hewan Abadi',
      priceRange: 'Rp 2.000.000',
      rating: 5.0,
      reviewCount: 0,
      tags: ['Kucing'],
      imageUrl: ImageAsset.britishShorthair,
      fallbackColorValue: 0xFF8A9BAB,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekomendasi',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: _items
                .map((item) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: item == _items.first ? 8.w : 0,
                          left: item == _items.last ? 8.w : 0,
                        ),
                        child: _FeaturedCard(hewan: item),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final HewanModel hewan;
  const _FeaturedCard({required this.hewan});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigator.push(
        context,
        AdopsiDetailHewanView(hewan: hewan),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: SizedBox(
                height: 145.h,
                width: double.infinity,
                child: AppNetImage(
                  url: hewan.imageUrl,
                  fallbackColor: Color(hewan.fallbackColorValue),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 3.h),
              child: Text(
                hewan.name,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 12.h),
              child: Text(
                hewan.priceRange,
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: const Color(0xFFAAAAAA),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}