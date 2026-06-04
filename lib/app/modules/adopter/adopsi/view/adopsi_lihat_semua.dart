import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../widgets/hewan_model.dart';
import '../widgets/hewan_list_card.dart';
import '../../../../common/contant/assets.dart';

class LihatSemuaView extends StatelessWidget {
  final String title;

  const LihatSemuaView({
    super.key,
    this.title = 'Lihat Semua',
  });

  static const List<HewanModel> _hewanList = [
    HewanModel(
      name: 'Kucing Anggora',
      shelter: 'Shelter Pejuang Hewan',
      priceRange: '500rb - 5jt',
      rating: 5.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Anjing', 'Kucing'],
      imageUrl: ImageAsset.kucingAnggora,
      fallbackColorValue: 0xFFE8DDD0,
    ),
    HewanModel(
      name: 'Angsa',
      shelter: 'Shelter Pejuang Hewan',
      priceRange: '750rb - 10jt',
      rating: 4.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Angsa', 'Bebek'],
      imageUrl: ImageAsset.angsa,
      fallbackColorValue: 0xFFD4E4D0,
    ),
    HewanModel(
      name: 'Anjing Chuahua',
      shelter: 'Shelter Pak Selamet',
      priceRange: '2jt - 20jt',
      rating: 5.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Anjing', 'Kucing'],
      imageUrl: ImageAsset.anjingChuahua,
      fallbackColorValue: 0xFFD4C5A9,
    ),
    HewanModel(
      name: 'Kura-kura',
      shelter: 'Shelter Pejuang Hewan',
      priceRange: '1rb - 5jt',
      rating: 4.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Kura-kura', 'Kucing'],
      imageUrl: ImageAsset.kuraKura,
      fallbackColorValue: 0xFF7B8B6A,
    ),
    HewanModel(
      name: 'Iguana',
      shelter: 'Shelter Surganya Hewan',
      priceRange: '1rb - 5jt',
      rating: 4.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Iguana', 'Kucing'],
      imageUrl: ImageAsset.iguana,
      fallbackColorValue: 0xFF8B9E5A,
    ),
    HewanModel(
      name: 'British Short Hair',
      shelter: 'Shelter Pejuang Hewan',
      priceRange: '2jt - 15jt',
      rating: 5.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Kucing'],
      imageUrl: ImageAsset.britishShorthair,
      fallbackColorValue: 0xFF8A9BAB,
    ),
    HewanModel(
      name: 'Kelinci',
      shelter: 'Shelter Hewan Bahagia',
      priceRange: '200rb - 2jt',
      rating: 4.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Kelinci'],
      imageUrl: ImageAsset.kelinci,
      fallbackColorValue: 0xFFE8E0D5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _LihatSemuaAppBar(title: title),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
                itemCount: _hewanList.length,
                itemBuilder: (context, index) => HewanListCard(
                  hewan: _hewanList[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LihatSemuaAppBar extends StatelessWidget {
  final String title;
  const _LihatSemuaAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 20.w, 10.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, size: 24.w, color: const Color(0xFFF87537)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
    );
  }
}