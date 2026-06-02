import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_net_image.dart';
import 'hewan_model.dart';
import '../view/adopsi_detail_hewan.dart';

class HewanListCard extends StatelessWidget {
  final HewanModel hewan;
  final ValueChanged<int>? onTabTap; // ← diterima dari LihatSemuaView

  const HewanListCard({super.key, required this.hewan, this.onTabTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator.push(
        context,
        AdopsiDetailHewanView(hewan: hewan, onTabTap: onTabTap),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImageWithRating(hewan: hewan),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${hewan.name}, ${hewan.shelter}.',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        hewan.priceRange,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: const Color(0xFF888888),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        children: hewan.tags
                            .map((tag) => HewanTagChip(label: tag))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: const Color(0xFFF0F0F0),
            indent: 20.w,
            endIndent: 20.w,
          ),
        ],
      ),
    );
  }
}

class _ImageWithRating extends StatelessWidget {
  final HewanModel hewan;
  const _ImageWithRating({required this.hewan});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            width: 110.w,
            height: 110.h,
            child: AppNetImage(
              url: hewan.imageUrl,
              fallbackColor: Color(hewan.fallbackColorValue),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_rounded, size: 13.w, color: const Color(0xFFF87537)),
                    SizedBox(width: 3.w),
                    Text(
                      '(${hewan.rating.toStringAsFixed(1)})',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+${hewan.reviewCount} Ulasan',
                  style: GoogleFonts.poppins(fontSize: 9.sp, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HewanTagChip extends StatelessWidget {
  final String label;
  const HewanTagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11.sp,
          color: const Color(0xFF444444),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}