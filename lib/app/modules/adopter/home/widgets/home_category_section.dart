import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_category_card.dart';

class HomeCategorySection extends StatelessWidget {
  final ValueChanged<String>? onCategoryTap;

  const HomeCategorySection({super.key, this.onCategoryTap});

  static const List<_HomeCategory> _categories = [
    _HomeCategory(nama: 'Anjing', imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=300'),
    _HomeCategory(nama: 'Kucing', imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=300'),
    _HomeCategory(nama: 'Kelinci', imageUrl: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=300'),
    _HomeCategory(nama: 'Hamster', imageUrl: 'https://images.unsplash.com/photo-1548767797-d8c844163c4c?w=300'),
    _HomeCategory(nama: 'Kura-kura', imageUrl: 'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?w=300'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Telusuri Berdasarkan Kategori',
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
              ),
              SizedBox(height: 4.h),
              Text(
                'Pilih kategori favoritmu lalu lanjutkan ke halaman adopsi.',
                style: textTheme.labelLarge?.copyWith(color: const Color(0xFF8E8E8E), height: 1.5),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 158.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final item = _categories[index];
              return HomeCategoryCard(
                imageUrl: item.imageUrl,
                namaKategori: item.nama,
                onTap: () => onCategoryTap?.call(item.nama),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HomeCategory {
  final String nama;
  final String imageUrl;

  const _HomeCategory({required this.nama, required this.imageUrl});
}
