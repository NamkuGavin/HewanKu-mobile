import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HewanBanner extends StatelessWidget {
  final VoidCallback? onTambah;

  const HewanBanner({super.key, this.onTambah});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTambah,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF87537), Color(0xFFFBA81F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol + (lingkaran putih)
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 28.sp),
            ),
            SizedBox(height: 12.h),

            // Teks utama
            Text(
              'Tambah Hewan Baru',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Daftarkan penghuni baru shelter!',
              style: textTheme.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
