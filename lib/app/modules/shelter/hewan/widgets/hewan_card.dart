import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HewanCard extends StatelessWidget {
  final String name;
  final String price;
  final String status;
  final Color statusColor;
  final String? imageUrl;
  final String waktu;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HewanCard({
    super.key,
    required this.name,
    required this.price,
    required this.status,
    required this.statusColor,
    this.imageUrl,
    this.waktu = '',
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Baris atas: foto + info + edit/hapus ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto hewan
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        width: 70.w,
                        height: 70.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              SizedBox(width: 14.w),

              // Nama + harga — jarak lebih lebar sesuai Figma
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      name,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 6.h), // ← jarak lebih lebar
                    Text(
                      price,
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Edit & hapus di POJOK KANAN ATAS — horizontal sejajar
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: Icon(
                      Icons.edit_outlined,
                      size: 20.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 20.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // ── Baris bawah: badge status kiri + waktu kanan ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge status
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: statusColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Waktu di kanan bawah
              if (waktu.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      waktu,
                      style: textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF9E9E9E),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 70.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const Icon(Icons.pets, color: Colors.white54),
    );
  }
}
