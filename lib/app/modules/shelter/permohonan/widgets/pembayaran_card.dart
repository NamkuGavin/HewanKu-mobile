import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/pembayaran_item.dart';

class PembayaranCard extends StatelessWidget {
  final PembayaranItem item;

  const PembayaranCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isBatal = item.status == StatusPembayaran.dibatalkan;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Baris 1: foto + nama hewan + badge status ──
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              children: [
                // Foto hewan
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: item.imageUrl != null
                      ? Image.network(
                          item.imageUrl!,
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                SizedBox(width: 12.w),

                // Nama + jenis • umur
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaHewan,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        '${item.jenisHewan} • ${item.umur}',
                        style: textTheme.labelMedium?.copyWith(
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge status
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    item.statusLabel,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: item.statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Garis tipis
          Divider(height: 1, thickness: 1, color: const Color(0xFFF5F5F5)),

          // ── Baris 2: nama adopter ──
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 6.h),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16.sp,
                  color: const Color(0xFF9E9E9E),
                ),
                SizedBox(width: 6.w),
                Text(
                  item.namaAdopter,
                  style: textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ── Baris 3: metode + waktu | total bayar ──
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Kiri: icon metode + waktu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon QRIS/Bank
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        item.metodePembayaran == 'QRIS' ? '⊞ QRIS' : '🏦 Bank',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WAKTU',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9.sp,
                            color: const Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.waktu,
                          style: textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF555555),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                // Kanan: total bayar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TOTAL BAYAR',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9.sp,
                        color: const Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.totalBayar,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        // Dibatalkan → abu + coret, Berhasil → oranye
                        color: isBatal
                            ? const Color(0xFF9E9E9E)
                            : const Color(0xFFF87537),
                        decoration: isBatal
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: const Color(0xFF9E9E9E),
                        decorationThickness: 2,
                      ),
                    ),
                  ],
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
      width: 60.w,
      height: 60.h,
      color: const Color(0xFFE0E0E0),
      child: const Icon(Icons.pets, color: Colors.white54),
    );
  }
}
