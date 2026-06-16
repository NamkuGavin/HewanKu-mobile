import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../adopsi/view/adopsi_detail_hewan.dart';
import '../../adopsi/view/adopsi_lihat_semua.dart';
import '../../adopsi/widgets/hewan_model.dart';
import 'home_animal_card.dart';
import 'home_section_placeholder.dart';

class HomeFeaturedSection extends StatelessWidget {
  final List<HewanModel> items;
  final bool hasError;
  final VoidCallback onRetry;

  const HomeFeaturedSection({super.key, required this.items, required this.hasError, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final previewItems = items.take(5).toList(growable: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hewan Unggulan',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: items.isEmpty
                    ? null
                    : () => AppNavigator.push(context, LihatSemuaView(title: 'Hewan Unggulan', items: items)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFF87537),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lihat Semua',
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF87537),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (hasError)
            HomeSectionPlaceholder(
              icon: Icons.pets_rounded,
              title: 'Hewan unggulan belum bisa dimuat.',
              description: 'Coba muat ulang untuk mengambil data terbaru dari server.',
              onRetry: onRetry,
            )
          else
            SizedBox(
              height: 278.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: previewItems.length,
                separatorBuilder: (_, _) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final hewan = previewItems[index];
                  return SizedBox(
                    width: 170.w,
                    child: HomeAnimalCard(
                      hewan: hewan,
                      onTap: () => AppNavigator.push(context, AdopsiDetailHewanView(hewan: hewan)),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
