import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ============================================================
// lib/app/modules/shelter/home/widgets/home_permohonan_card.dart
// Berisi: card permohonan adopsi di Home
// Berbeda dari permohonan_card.dart di folder permohonan/widgets/
// karena ini versi ringkas untuk preview di Home + bisa diklik semua
// ============================================================

class HomePermohonanCard extends StatelessWidget {
  final String petName;
  final String requester;
  final String? imageUrl;
  // Klik seluruh card + badge → pindah ke tab Permohonan
  final VoidCallback? onTap;

  const HomePermohonanCard({
    super.key,
    required this.petName,
    required this.requester,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar hewan
            CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xFFE0E0E0),
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : null,
              child: imageUrl == null
                  ? Icon(Icons.pets, color: Colors.white70, size: 22.sp)
                  : null,
            ),
            SizedBox(width: 12.w),

            // Nama + requester
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petName,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    requester,
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),

            // Badge MENUNGGU TINJAUAN
            // Klik ikut onTap dari GestureDetector parent
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'MENUNGGU\nTINJAUAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
