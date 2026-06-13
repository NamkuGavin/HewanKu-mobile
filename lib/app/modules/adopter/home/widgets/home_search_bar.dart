import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: const Color(0xFF9E9E9E), size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Cari Hewan...',
                    hintStyle: textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: textTheme.labelLarge?.copyWith(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
