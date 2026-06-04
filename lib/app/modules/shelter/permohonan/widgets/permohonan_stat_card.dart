import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PermohonanStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color borderColor;
  final String label;
  final int count;

  const PermohonanStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.borderColor,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: borderColor.withOpacity(0.35), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon dalam lingkaran — ukuran sama persis Figma
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(height: 8.h),

            // Label — all caps, kecil, abu
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9.sp, // ← lebih kecil sesuai Figma
                color: const Color(0xFF9E9E9E),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // Angka — besar dan bold sesuai Figma
            Text(
              count.toString().padLeft(2, '0'),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 26.sp, // ← besar sesuai Figma
                fontWeight: FontWeight.w800,
                color: Colors.black,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
