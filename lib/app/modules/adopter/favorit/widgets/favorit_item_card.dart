import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/widgets/app_net_image.dart';
import '../model/favorit_item.dart';

class FavoritItemCard extends StatelessWidget {
  final FavoritItem item;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const FavoritItemCard({
    super.key,
    required this.item,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hewan = item.hewan;
    final category = hewan.kategori?.trim().isNotEmpty == true
        ? hewan.kategori!.trim()
        : (hewan.tags.isNotEmpty ? hewan.tags.first : 'Hewan');
    final status = hewan.resolvedStatusAdopsi;
    final statusIsAvailable = hewan.isAvailableForAdoption;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Ink(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFFFFF7F1) : Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: isHighlighted
                  ? const Color(0xFFF5D7C6)
                  : const Color(0xFFF1E8E1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SizedBox(
                  width: 88.w,
                  height: 96.h,
                  child: AppNetImage(
                    url: item.imageUrl,
                    fallbackColor: Color(hewan.fallbackColorValue),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _CategoryChip(label: category),
                        const Spacer(),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFE7DD),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: const Color(0xFFF87537),
                            size: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      item.namaHewan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.storefront_rounded,
                          size: 14.sp,
                          color: const Color(0xFF949494),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            item.namaShelter,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: const Color(0xFF7F7F7F),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Biaya adopsi',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  color: const Color(0xFF9A9A9A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                hewan.price,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: const Color(0xFFF87537),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusIsAvailable
                                ? const Color(0xFFEAF8F0)
                                : const Color(0xFFFFF6E8),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: statusIsAvailable
                                  ? const Color(0xFF1F8A4D)
                                  : const Color(0xFFB96A00),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          'Buka detail hewan',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 15.sp,
                          color: const Color(0xFFF87537),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE8DE),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFBC622F),
        ),
      ),
    );
  }
}
