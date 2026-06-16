import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AdopsiSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const AdopsiSearchBar({super.key, required this.controller, required this.onChanged, this.onClear});

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
      child: SizedBox(
        height: 46.h,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF333333)),
          decoration: InputDecoration(
            hintText: 'Cari Hewan...',
            hintStyle: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFFAAAAAA)),
            suffixIcon: IconButton(
              onPressed: hasText ? onClear : null,
              icon: Icon(hasText ? Icons.close_rounded : Icons.search, color: const Color(0xFFAAAAAA), size: 22.w),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 18.w),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.r), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.r), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.r),
              borderSide: const BorderSide(color: Color(0xFFF87537), width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
