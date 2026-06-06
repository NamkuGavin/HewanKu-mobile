import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_net_image.dart';
import '../model/favorit_item.dart';

class FavoritItemCard extends StatelessWidget {
  final FavoritItem item;
  final bool isHighlighted;
  final bool isDeleteMode;
  final bool isSelected;
  final VoidCallback? onTap;

  const FavoritItemCard({
    super.key,
    required this.item,
    this.isHighlighted = false,
    this.isDeleteMode = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final _ = Theme.of(context).primaryColor;

    Color bgColor = Colors.white;
    if (isSelected) {
      bgColor = const Color(0xFFFFEBEB);
    } else if (isHighlighted) {
      bgColor = const Color(0xFFFFF3EC);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        color: bgColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox di kiri saat mode hapus
            if (isDeleteMode) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 22.w,
                height: 22.h,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.red : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.red : const Color(0xFFCCCCCC),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded, size: 13.sp, color: Colors.white)
                    : null,
              ),
            ],

            // Foto hewan
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    width: 70.w,
                    height: 70.h,
                    child: AppNetImage(
                      url: item.imageUrl,
                      fallbackColor: const Color(0xFFE0E0E0),
                    ),
                  ),
                ),
                if (!isDeleteMode)
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

            // Nama hewan & shelter
            Expanded(
              child: Text(
                item.judulLengkap,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}