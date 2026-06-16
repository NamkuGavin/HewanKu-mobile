import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'hewan_list_card.dart';
import 'hewan_model.dart';

class AdopsiResultList extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<HewanModel> items;
  final String emptyTitle;
  final String emptyDescription;
  final String resetLabel;
  final VoidCallback onReset;

  const AdopsiResultList({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.resetLabel,
    required this.onReset,
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
              TextButton(
                onPressed: onReset,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFF87537),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  resetLabel,
                  style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F3),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFF8D7C5)),
              ),
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 28.sp, color: const Color(0xFFF87537)),
                  SizedBox(height: 10.h),
                  Text(
                    emptyTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2F2F2F)),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    emptyDescription,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 11.sp, height: 1.5, color: const Color(0xFF7A7A7A)),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 12.h),
            itemCount: items.length,
            itemBuilder: (context, index) => HewanListCard(hewan: items[index]),
          ),
      ],
    );
  }
}
