import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../home/widgets/home_section_placeholder.dart';
import '../view/adopsi_detail_hewan.dart';
import '../view/adopsi_lihat_semua.dart';
import 'hewan_model.dart';
import 'hewan_showcase_card.dart';

class AdopsiListSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<HewanModel> items;
  final bool hasError;
  final VoidCallback onRetry;

  const AdopsiListSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.hasError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: HomeSectionPlaceholder(
          icon: Icons.pets_outlined,
          title: '$title belum bisa dimuat.',
          description: 'Coba muat ulang untuk mengambil data terbaru.',
          onRetry: onRetry,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton(
                onPressed: items.isEmpty
                    ? null
                    : () => AppNavigator.push(context, LihatSemuaView(title: title, items: items)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF87537),
                  side: const BorderSide(color: Color(0xFFF87537), width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 275.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => _HewanCard(hewan: items[index]),
          ),
        ),
      ],
    );
  }
}

class _HewanCard extends StatelessWidget {
  final HewanModel hewan;

  const _HewanCard({required this.hewan});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170.w,
      child: HewanShowcaseCard(
        hewan: hewan,
        onTap: () => AppNavigator.push(context, AdopsiDetailHewanView(hewan: hewan)),
      ),
    );
  }
}
