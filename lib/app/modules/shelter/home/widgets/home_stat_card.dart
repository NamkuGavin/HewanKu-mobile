import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ============================================================
// lib/app/modules/shelter/home/widgets/home_stat_card.dart
// Berisi: kartu "SIAP ADOPSI X Ekor"
// ============================================================

class HomeStatCard extends StatelessWidget {
  final int jumlahAktif;

  const HomeStatCard({super.key, required this.jumlahAktif});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIAP ADOPSI',
                style: textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$jumlahAktif',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Text(
                      'Ekor',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.bar_chart_rounded, color: primaryColor, size: 32.sp),
        ],
      ),
    );
  }
}
