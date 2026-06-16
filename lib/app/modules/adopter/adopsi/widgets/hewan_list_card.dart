import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_net_image.dart';
import '../view/adopsi_detail_hewan.dart';
import 'hewan_model.dart';

class HewanListCard extends StatelessWidget {
  final HewanModel hewan;

  const HewanListCard({super.key, required this.hewan});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator.push(context, AdopsiDetailHewanView(hewan: hewan)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: SizedBox(
                    width: 110.w,
                    height: 110.h,
                    child: AppNetImage(url: hewan.imageUrl, fallbackColor: Color(hewan.fallbackColorValue)),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(color: const Color(0xFFFCE7DA), borderRadius: BorderRadius.circular(50.r)),
                        child: Text(
                          hewan.kategori ?? (hewan.tags.isNotEmpty ? hewan.tags.first : 'Hewan'),
                          style: GoogleFonts.poppins(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB85A25),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        hewan.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.storefront_rounded, size: 14.sp, color: const Color(0xFF9C9C9C)),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              hewan.shelter,
                              style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF808080), height: 1.35),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Biaya adopsi',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: const Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        hewan.price,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: const Color(0xFFF87537),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: const Color(0xFFF0F0F0), indent: 20.w, endIndent: 20.w),
        ],
      ),
    );
  }
}
