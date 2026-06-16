import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_net_image.dart';

class HomeCategoryCard extends StatelessWidget {
  final String imageUrl;
  final String namaKategori;
  final VoidCallback? onTap;

  const HomeCategoryCard({super.key, required this.imageUrl, required this.namaKategori, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderRadius = BorderRadius.circular(18.r);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          width: 124.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            border: Border.all(color: const Color(0xFFF3E2D8), width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 14, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
                child: SizedBox(
                  height: 92.h,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppNetImage(url: imageUrl, fallbackColor: const Color(0xFFFFDCCB)),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withValues(alpha: 0.04), Colors.black.withValues(alpha: 0.22)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaKategori,
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            'Lihat hewan',
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFFF87537),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(Icons.arrow_forward_rounded, size: 15.sp, color: const Color(0xFFF87537)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
