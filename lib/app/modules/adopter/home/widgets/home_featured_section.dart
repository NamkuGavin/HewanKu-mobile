import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/contant/assets.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../adopsi/widgets/hewan_model.dart';
import '../../adopsi/view/adopsi_detail_hewan.dart';
import 'home_animal_card.dart';

class HomeFeaturedSection extends StatelessWidget {
  const HomeFeaturedSection({super.key});

  static const List<HewanModel> _items = [
    HewanModel(
      name: 'Kucing Anggora',
      shelter: 'Shelter Hewan Abadi',
      price: 'Rp 2.000.000',
      rating: 5.0,
      reviewCount: 0,
      tags: ['Kucing'],
      imageUrl: ImageAsset.kucingAnggora,
      fallbackColorValue: 0xFFE8DDD0,
    ),
    HewanModel(
      name: 'British Short Hair',
      shelter: 'Shelter Hewan Abadi',
      price: 'Rp 2.000.000',
      rating: 5.0,
      reviewCount: 0,
      tags: ['Kucing'],
      imageUrl: ImageAsset.britishShorthair,
      fallbackColorValue: 0xFF8A9BAB,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hewan Unggulan',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: List.generate(_items.length, (index) {
              final hewan = _items[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 0 ? 8.w : 0,
                    left: index == 1 ? 8.w : 0,
                  ),
                  child: HomeAnimalCard(
                    imageUrl: hewan.imageUrl,
                    namaHewan: hewan.name,
                    harga: hewan.price,
                    onTap: () => AppNavigator.push(
                      context,
                      AdopsiDetailHewanView(hewan: hewan),
                    ),
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