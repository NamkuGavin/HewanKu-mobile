import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bgColor = backgroundColor ?? const Color(0xFFFBA81F);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14.sp),
          ],
        ),
      ),
    );
  }
}