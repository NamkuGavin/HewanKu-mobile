import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ============================================================
// lib/app/modules/shelter/home/widgets/home_shelter_banner.dart
// Berisi: banner oranye dengan tombol Daftar Shelter & Daftar Hewan
// ============================================================

class HomeShelterBanner extends StatelessWidget {
  final VoidCallback? onDaftarShelter;
  final VoidCallback? onDaftarHewan;

  const HomeShelterBanner({
    super.key,
    this.onDaftarShelter,
    this.onDaftarHewan,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shelter Hewan',
            style: textTheme.labelLarge?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Ayo Buat Shelter\nKamu',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.2,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Kelola hewan peliharaan dan temukan pemilik baru untuk mereka.',
            style: textTheme.labelLarge?.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 16.h),

          // Tombol Daftar Shelter → tab Profil
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                minimumSize: Size(double.infinity, 45.h),
                elevation: 0,
                side: const BorderSide(color: Color(0xFFE9E9E9)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              onPressed: onDaftarShelter,
              icon: Icon(Icons.storefront_outlined, size: 18.sp),
              label: Text(
                'Daftar Shelter',
                style: textTheme.labelLarge?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Tombol Daftar Hewan → TambahHewanView
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 45.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              onPressed: onDaftarHewan,
              icon: Icon(Icons.add_circle_outline, size: 18.sp),
              label: Text(
                'Daftar Hewan',
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
