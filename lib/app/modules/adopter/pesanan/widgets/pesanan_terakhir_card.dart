import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_net_image.dart';
import '../model/pesanan_terakhir_item.dart';

class PesananTerakhirCard extends StatelessWidget {
  final PesananTerakhirItem item;
  final VoidCallback? onRatingTap;

  const PesananTerakhirCard({super.key, required this.item, this.onRatingTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final shadowColor = Colors.black.withValues(alpha: 0.07);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: nama shelter kiri + blob oranye kanan ──
          Stack(
            children: [
              // Blob oranye kanan
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 100.w,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF87537), Color(0xFFFBA81F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(70),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.pets,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 36.sp,
                    ),
                  ),
                ),
              ),

              // Teks header kiri
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 112.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.namaShelter,
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      item.nomorInvoice,
                      style: textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // Status "Berhasil" hijau + tanggal
                    Row(
                      children: [
                        Text(
                          item.statusLabel,
                          style: textTheme.labelMedium?.copyWith(
                            color: item.statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            item.tanggal,
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF9E9E9E),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Body ──
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label "Detail Adopsi"
                Text(
                  'Detail Adopsi',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),

                // ── Tabel detail adopsi ──
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      // Header tabel
                      _TableHeader(textTheme: textTheme),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                      // Rows data
                      ...item.detailAdopsi.asMap().entries.map((entry) {
                        final isLast =
                            entry.key == item.detailAdopsi.length - 1;
                        return Column(
                          children: [
                            _TableRow(row: entry.value, textTheme: textTheme),
                            if (!isLast)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFEEEEEE),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Total Biaya + tombol Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Biaya',
                            style: textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.totalBiaya,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tombol Rating & Ulasan — hitam pill
                    if (item.canReview)
                      GestureDetector(
                        onTap: onRatingTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text(
                            'Rating & Ulasan',
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: item.statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Text(
                          item.actionLabel,
                          style: textTheme.labelLarge?.copyWith(
                            color: item.statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Teks terima kasih
                Text(
                  item.pesanTerimakasih,
                  style: textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF9E9E9E),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Header tabel — Nama |  Harga
class _TableHeader extends StatelessWidget {
  final TextTheme textTheme;
  const _TableHeader({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
      ),
      child: Row(
        children: [
          // Nama (flex lebih besar)
          Expanded(
            flex: 4,
            child: Text(
              'Nama',
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF555555),
              ),
            ),
          ),
          // Harga
          Expanded(
            flex: 3,
            child: Text(
              'Harga',
              textAlign: TextAlign.right,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Row data tabel — 1 hewan
class _TableRow extends StatelessWidget {
  final DetailAdopsiRow row;
  final TextTheme textTheme;
  const _TableRow({required this.row, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kolom Nama: foto + nama + sub
          Expanded(
            flex: 4,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: SizedBox(
                    width: 32.w,
                    height: 32.h,
                    child: AppNetImage(
                      url: row.imageUrl,
                      fallbackColor: const Color(0xFFE0E0E0),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.namaHewan,
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        row.subNama,
                        style: textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF9E9E9E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Kolom Harga
          Expanded(
            flex: 3,
            child: Text(
              row.harga,
              textAlign: TextAlign.right,
              style: textTheme.labelMedium?.copyWith(
                color: const Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
