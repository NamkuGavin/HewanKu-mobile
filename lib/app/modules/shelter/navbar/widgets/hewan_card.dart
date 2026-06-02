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
    this.waktu = '2 jam lalu',
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto hewan
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: 64.w,
                    height: 64.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          SizedBox(width: 12.w),

          // Info hewan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  price,
                  style: textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge status
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Waktu
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 11.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          waktu,
                          style: textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF9E9E9E),
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tombol edit & hapus
          Column(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: Icon(
                  Icons.edit_outlined,
                  size: 20.sp,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
              SizedBox(height: 12.h),
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
