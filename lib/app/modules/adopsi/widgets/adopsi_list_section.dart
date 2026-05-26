import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/utils/app_navigator.dart';
import '../widgets/app_net_image.dart';
import '../view/adopsi_lihat_semua.dart';

/// Model data untuk card hewan di list horizontal
class AdopsiHewanItem {
  final String name;
  final String shelter;
  final double rating;
  final int reviewCount;
  final String url;
  final Color fallback;

  const AdopsiHewanItem({
    required this.name,
    required this.shelter,
    required this.rating,
    required this.reviewCount,
    required this.url,
    required this.fallback,
  });
}

/// Section dengan header + tombol Lihat Semua + horizontal scroll card
class AdopsiListSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<AdopsiHewanItem> items;

  const AdopsiListSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Tombol Lihat Semua → navigasi ke LihatSemuaView
              OutlinedButton(
                onPressed: () {
                  AppNavigator.push(
                    context,
                    LihatSemuaView(title: title),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF87537),
                  side: const BorderSide(color: Color(0xFFF87537), width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        // Horizontal scroll list
        SizedBox(
          height: 210.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => _HewanCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}

class _HewanCard extends StatelessWidget {
  final AdopsiHewanItem item;
  const _HewanCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: SizedBox(
              height: 130.h,
              width: double.infinity,
              child: AppNetImage(url: item.url, fallbackColor: item.fallback),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 3.h),
            child: Text(
              item.name,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 4.h),
            child: Text(
              item.shelter,
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                color: const Color(0xFF999999),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
            child: Row(
              children: [
                Icon(Icons.star_rounded,
                    size: 13.w, color: const Color(0xFFF87537)),
                SizedBox(width: 3.w),
                Text(
                  '(${item.rating.toStringAsFixed(1)})',
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: const Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '  •  ${item.reviewCount} Ulasan',
                  style: GoogleFonts.poppins(
                    fontSize: 9.sp,
                    color: const Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}