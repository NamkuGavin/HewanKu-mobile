import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_net_image.dart';

class HomeNewsListItem extends StatelessWidget {
  final String imageUrl;
  final String kategori;
  final String judul;
  final String tanggal;
  final VoidCallback? onTap;

  const HomeNewsListItem({
    super.key,
    required this.imageUrl,
    required this.kategori,
    required this.judul,
    required this.tanggal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        padding: EdgeInsets.all(10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto kiri — rounded
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: 80.w,
                height: 80.h,
                child: AppNetImage(url: imageUrl, fallbackColor: const Color(0xFFE0E0E0)),
              ),
            ),
            SizedBox(width: 12.w),

            // Teks kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategori,
                    style: textTheme.labelMedium?.copyWith(color: const Color(0xFF9E9E9E), fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    judul,
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    tanggal,
                    style: textTheme.labelMedium?.copyWith(color: const Color(0xFF9E9E9E), fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
