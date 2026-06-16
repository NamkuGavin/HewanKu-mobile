import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_net_image.dart';
import 'hewan_model.dart';

class HewanShowcaseCard extends StatelessWidget {
  final HewanModel hewan;
  final VoidCallback? onTap;
  final double imageHeight;

  const HewanShowcaseCard({super.key, required this.hewan, this.onTap, this.imageHeight = 136});

  String get _primaryCategory {
    if (hewan.kategori != null && hewan.kategori!.trim().isNotEmpty) {
      return hewan.kategori!.trim();
    }
    if (hewan.tags.isNotEmpty) {
      return hewan.tags.first.trim();
    }
    return 'Hewan';
  }

  String get _statusLabel {
    return hewan.resolvedStatusAdopsi;
  }

  bool get _showRating => hewan.rating > 0;
  bool get _isAvailable => hewan.isAvailableForAdoption;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isAvailable ? 0.07 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              child: Stack(
                children: [
                  Opacity(
                    opacity: _isAvailable ? 1 : 0.74,
                    child: SizedBox(
                      height: imageHeight.h,
                      width: double.infinity,
                      child: AppNetImage(url: hewan.imageUrl, fallbackColor: Color(hewan.fallbackColorValue)),
                    ),
                  ),
                  Positioned(
                    left: 10.w,
                    top: 10.h,
                    child: _InfoChip(
                      label: _primaryCategory,
                      backgroundColor: const Color(0xFFFCE7DA),
                      textColor: const Color(0xFFB85A25),
                    ),
                  ),
                  if (_statusLabel.isNotEmpty)
                    Positioned(
                      right: 10.w,
                      top: 10.h,
                      child: _InfoChip(
                        label: _statusLabel,
                        backgroundColor: _isAvailable ? const Color(0xFFE8F7EE) : const Color(0xFFFFF0E5),
                        textColor: _isAvailable ? const Color(0xFF2E8B57) : const Color(0xFFB96A00),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hewan.name,
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    if (_showRating) ...[_RatingBadge(rating: hewan.rating), SizedBox(height: 8.h)],
                    Text(
                      'Biaya adopsi',
                      style: textTheme.labelMedium?.copyWith(
                        fontSize: 10.sp,
                        color: const Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      hewan.price,
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: _isAvailable ? const Color(0xFFF87537) : const Color(0xFF9D9D9D),
                        height: 1.25,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _InfoChip({required this.label, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(50.r)),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontSize: 9.sp, fontWeight: FontWeight.w700, color: textColor),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: const Color(0xFFFFF5E6), borderRadius: BorderRadius.circular(50.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13.sp, color: const Color(0xFFF5A623)),
          SizedBox(width: 4.w),
          Text(
            rating.toStringAsFixed(rating % 1 == 0 ? 0 : 1),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700, color: const Color(0xFF8A5A00)),
          ),
        ],
      ),
    );
  }
}
