import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HewanUploadFoto extends StatelessWidget {
  final VoidCallback? onTap;

  const HewanUploadFoto({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 180.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE8D6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_outlined,
                color: const Color(0xFFF87537),
                size: 26.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Unggah Foto Profil',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Potret resolusi tinggi bekerja paling baik\nuntuk menangkap tatapan unik mereka.',
              textAlign: TextAlign.center,
              style: textTheme.labelMedium?.copyWith(
                color: const Color(0xFF9E9E9E),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
