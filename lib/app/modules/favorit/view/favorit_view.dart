import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/favorit_item.dart';
import '../widgets/favorit_item_card.dart';
import '../widgets/favorit_empty_state.dart';

class FavoritView extends StatelessWidget {
  const FavoritView({super.key});

  // Ganti list ini dengan data dari API nanti
  // Untuk test empty state: ubah jadi list kosong []
  static const List<FavoritItem> _favoritList = [
    FavoritItem(
      imageUrl:
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=200',
      namaHewan: 'Anjing Chiuhuahua',
      namaShelter: 'Shelter Abadi Hewan',
      waktu: '2 days ago',
    ),
    FavoritItem(
      imageUrl:
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=200',
      namaHewan: 'Kucing Anggora',
      namaShelter: 'Shelter Abadi Hewan',
      waktu: '2 days ago',
    ),
    FavoritItem(
      imageUrl:
          'https://images.unsplash.com/photo-1561037404-61cd46aa615b?w=200',
      namaHewan: 'Anjing Anggora',
      namaShelter: 'Shelter Abadi Surga Hewan',
      waktu: '3 days ago',
    ),
    FavoritItem(
      imageUrl:
          'https://images.unsplash.com/photo-1616874540629-0bb0e86db5e2?w=200',
      namaHewan: 'Kucing Spyix',
      namaShelter: 'Shelter Abadi Surga Hewan',
      waktu: '4 days ago',
    ),
    FavoritItem(
      imageUrl:
          'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?w=200',
      namaHewan: 'Kucing British Short Hair',
      namaShelter: 'Shelter We Care',
      waktu: '7 days ago',
    ),
    FavoritItem(
      imageUrl:
          'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?w=200',
      namaHewan: 'Kura - kura',
      namaShelter: 'Shelter Abadi Hewan',
      waktu: '10 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final isEmpty = _favoritList.isEmpty;

    return Scaffold(
      // Background menyesuaikan: putih kalau ada data, abu kalau kosong
      backgroundColor: isEmpty ? const Color(0xFFF5F5F5) : Colors.white,
      appBar: AppBar(
        backgroundColor: isEmpty ? const Color(0xFFF5F5F5) : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Favorit',
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      // Kondisi: tampilkan list atau empty state
      body: isEmpty
          ? const FavoritEmptyState()
          : ListView.separated(
              itemCount: _favoritList.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF0F0F0),
              ),
              itemBuilder: (context, index) {
                return FavoritItemCard(
                  item: _favoritList[index],
                  isHighlighted: index == 0,
                  onTap: () {
                    // TODO: navigasi ke detail hewan
                  },
                );
              },
            ),
    );
  }
}
