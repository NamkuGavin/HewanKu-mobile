import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/favorit_item.dart';

class FavoritItemCard extends StatelessWidget {
  final FavoritItem item;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const FavoritItemCard({
    super.key,
    required this.item,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        color: isHighlighted ? const Color(0xFFFFF3EC) : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Stack dengan clipBehavior.none supaya icon bisa overlap keluar foto
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Foto hewan
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    item.imageUrl,
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: const Icon(Icons.pets, color: Colors.white54),
                    ),
                  ),
                ),

                // Icon hati — overlap keluar di pojok kanan bawah
                Positioned(
                  bottom: -8,
                  right: -8,
                  child: Container(
                    width: 26.w,
                    height: 26.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF87537),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 13.sp,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(width: 16.w),

            // Teks nama + waktu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.judulLengkap,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.waktu,
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w400,
                    ),
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
