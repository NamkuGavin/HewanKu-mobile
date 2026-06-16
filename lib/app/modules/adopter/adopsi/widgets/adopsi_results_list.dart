import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'hewan_list_card.dart';
import 'hewan_model.dart';

class AdopsiResultsList extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<HewanModel> items;
  final String emptyTitle;
  final String emptyDescription;
  final String actionLabel;
  final VoidCallback onActionTap;

  const AdopsiResultsList({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
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
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(fontSize: 11.sp, height: 1.5, color: const Color(0xFF8A8A8A)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              OutlinedButton(
                onPressed: onActionTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF87537),
                  side: const BorderSide(color: Color(0xFFF87537), width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel,
                  style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 20.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F3),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xFFF7D8C7)),
              ),
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 28.sp, color: const Color(0xFFF87537)),
                  SizedBox(height: 12.h),
                  Text(
                    emptyTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2F2F2F)),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    emptyDescription,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 11.sp, height: 1.55, color: const Color(0xFF7A7A7A)),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(children: items.map((item) => HewanListCard(hewan: item)).toList(growable: false)),
          ),
      ],
    );
  }
}
