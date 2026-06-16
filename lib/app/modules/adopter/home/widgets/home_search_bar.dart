import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
      child: SizedBox(
        height: 46.h,
        child: TextField(
          readOnly: true,
          onTap: onTap,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: const Color(0xFF333333),
          ),
          decoration: InputDecoration(
            hintText: 'Cari Hewan...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: const Color(0xFFAAAAAA),
            ),
            suffixIcon: Icon(
              Icons.search,
              color: const Color(0xFFAAAAAA),
              size: 22.w,
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 18.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.r),
              borderSide: const BorderSide(
                color: Color(0xFFF87537),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
