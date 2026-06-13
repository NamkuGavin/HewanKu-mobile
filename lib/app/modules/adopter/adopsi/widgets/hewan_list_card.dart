import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_net_image.dart';
import 'hewan_model.dart';
import '../view/adopsi_detail_hewan.dart';

class HewanListCard extends StatelessWidget {
  final HewanModel hewan;
  const HewanListCard({super.key, required this.hewan});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          AppNavigator.push(context, AdopsiDetailHewanView(hewan: hewan)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto hewan — tanpa rating overlay
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
                SizedBox(width: 14.w),
                // Nama + harga saja
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hewan.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        hewan.price,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: const Color(0xFF888888),
                          fontWeight: FontWeight.w400,
                        ),
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
