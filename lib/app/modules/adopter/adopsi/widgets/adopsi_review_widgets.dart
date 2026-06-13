import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/widgets/app_net_image.dart';

const _orange = Color(0xFFF87537);

// ── Model data review ────────────────────────────────────────────────────────
class ReviewItem {
  final String nama;
  final String tanggal;
  final double rating;
  final String ulasan;
  final String fotoUrl;

  const ReviewItem({
    required this.nama,
    required this.tanggal,
    required this.rating,
    required this.ulasan,
    this.fotoUrl = '',
  });
}

// ── 1. Rating Summary (kiri: angka besar + bintang; kanan: bar per bintang) ──
class ReviewRatingSummary extends StatelessWidget {
  final double ratingRata;
  final int totalUlasan;
  final Map<int, double> distribusi; // key: 1-5, value: 0.0-1.0 (persentase)

  const ReviewRatingSummary({
    super.key,
    required this.ratingRata,
    required this.totalUlasan,
    required this.distribusi,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kiri: angka besar + bintang + jumlah ulasan
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ratingRata.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 52.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                  height: 1,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < ratingRata.floor()
                        ? Icons.star_rounded
                        : i < ratingRata
                        ? Icons.star_half_rounded
                        : Icons.star_border_rounded,
                    color: _orange,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${_formatAngka(totalUlasan)} ulasan',
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: const Color(0xFF888888),
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          // Kanan: bar per bintang (5 → 1)
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final bintang = 5 - i;
                final persen = distribusi[bintang] ?? 0.0;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Row(
                    children: [
                      Text(
                        '$bintang',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: const Color(0xFF888888),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: persen,
                            minHeight: 7.h,
                            backgroundColor: const Color(0xFFE0E0E0),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              _orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAngka(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

// ── 2. Card satu review ───────────────────────────────────────────────────────
class ReviewCard extends StatelessWidget {
  final ReviewItem item;
  const ReviewCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris atas: foto + nama + tanggal | bintang + angka
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto profil
              ClipOval(
                child: SizedBox(
                  width: 42.w,
                  height: 42.w,
                  child: item.fotoUrl.isNotEmpty
                      ? AppNetImage(
                          url: item.fotoUrl,
                          fallbackColor: const Color(0xFFE0E0E0),
                        )
                      : Container(
                          color: const Color(0xFFE0E0E0),
                          child: Icon(
                            Icons.person,
                            size: 24.sp,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 10.w),
              // Nama + tanggal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      item.tanggal,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              // Bintang + angka rating
              Row(
                children: [
                  ...List.generate(
                    5,
                    (i) => Icon(
                      i < item.rating.floor()
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: _orange,
                      size: 13.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '(${item.rating.toStringAsFixed(1)})',
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: const Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Teks ulasan
          Text(
            item.ulasan,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: const Color(0xFF444444),
              height: 1.6,
            ),
          ),
          SizedBox(height: 16.h),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        ],
      ),
    );
  }
}
