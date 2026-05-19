import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_animal_card.dart';

class HomeFeaturedSection extends StatelessWidget {
  const HomeFeaturedSection({super.key});

  // Data dummy — ganti dengan data dari API nanti
  static const List<Map<String, dynamic>> _animals = [
    {
      'nama': 'Kucing Anggora',
      'harga': 'Rp 3.500.000',
      'imageUrl':
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400',
    },
    {
      'nama': 'British Short Hair',
      'harga': 'Rp 3.800.000',
      'imageUrl':
          'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul section
          Text(
            'Hewan Unggulan',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.h),

          // Grid 2 kolom
          Row(
            children: List.generate(_animals.length, (index) {
              final item = _animals[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 0 ? 8.w : 0,
                    left: index == 1 ? 8.w : 0,
                  ),
                  child: HomeAnimalCard(
                    imageUrl: item['imageUrl'],
                    namaHewan: item['nama'],
                    harga: item['harga'],
                    onTap: () {
                      // TODO: navigasi ke detail hewan
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
