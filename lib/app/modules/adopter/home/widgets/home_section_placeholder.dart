import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSectionPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onRetry;

  const HomeSectionPlaceholder({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF8D7C5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFF87537), size: 28.sp),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2F2F2F),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(fontSize: 11.sp, height: 1.5, color: const Color(0xFF7A7A7A)),
          ),
          SizedBox(height: 14.h),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFF87537),
              side: const BorderSide(color: Color(0xFFF87537), width: 1.1),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
            ),
            child: Text(
              'Coba Lagi',
              style: textTheme.labelLarge?.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF87537),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
