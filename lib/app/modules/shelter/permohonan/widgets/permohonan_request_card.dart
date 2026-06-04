import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/permohonan_item.dart';

class PermohonanRequestCard extends StatelessWidget {
  final PermohonanItem item;
  final VoidCallback? onSetuju;
  final VoidCallback? onTolak;

  const PermohonanRequestCard({
    super.key,
    required this.item,
    this.onSetuju,
    this.onTolak,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Info hewan + adopter + waktu ──
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto hewan
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: item.imageUrl != null
                      ? Image.network(
                          item.imageUrl!,
                          width: 64.w,
                          height: 64.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                SizedBox(width: 12.w),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama hewan + waktu
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.judulHewan,
                              style: textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Text(
                            item.waktu,
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF9E9E9E),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Nama adopter
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 13.sp,
                            color: const Color(0xFF9E9E9E),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item.namaAdopter,
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),

                      // File PDF
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.insert_drive_file_outlined,
                              size: 13.sp,
                              color: const Color(0xFFF87537),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              item.namaFile,
                              style: textTheme.labelMedium?.copyWith(
                                color: const Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Garis pemisah ──
          Divider(height: 1, thickness: 1, color: const Color(0xFFF0F0F0)),

          // ── Tombol Setuju & Tolak ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                // Setuju
                Expanded(
                  child: GestureDetector(
                    onTap: onSetuju,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 16.sp),
                          SizedBox(width: 6.w),
                          Text(
                            'Setuju',
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Tolak
                Expanded(
                  child: GestureDetector(
                    onTap: onTolak,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, color: Colors.red, size: 16.sp),
                          SizedBox(width: 6.w),
                          Text(
                            'Tolak',
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 64.w,
      height: 64.h,
      color: const Color(0xFFE0E0E0),
      child: const Icon(Icons.pets, color: Colors.white54),
    );
  }
}
