import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_category_card.dart';

class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({super.key});

  // Data dummy — ganti dengan data dari API nanti
  static const List<Map<String, dynamic>> _categories = [
    {
      'nama': 'Anjing',
      'jumlah': 100,
      'imageUrl':
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=300',
    },
    {
      'nama': 'Iguana',
      'jumlah': 20,
      'imageUrl':
          'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=300',
    },
    {
      'nama': 'Kura-kura',
      'jumlah': 200,
      'imageUrl':
          'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?w=300',
    },
    {
      'nama': 'Kucing',
      'jumlah': 150,
      'imageUrl':
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=300',
    },
    {
      'nama': 'Kelinci',
      'jumlah': 60,
      'imageUrl':
          'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=300',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Telusuri Berdasarkan Kategori',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // ListView horizontal scroll
        SizedBox(
          height: 150.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final item = _categories[index];
              return HomeCategoryCard(
                imageUrl: item['imageUrl'],
                namaKategori: item['nama'],
                jumlahTersedia: item['jumlah'],
                onTap: () {
                  // TODO: navigasi ke halaman kategori
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
