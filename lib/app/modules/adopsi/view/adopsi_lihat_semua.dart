import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/utils/app_navigator.dart';
import '../widgets/hewan_model.dart';
import '../widgets/hewan_list_card.dart';

class LihatSemuaView extends StatelessWidget {
  final String title;

  const LihatSemuaView({
    super.key,
    this.title = 'Lihat Semua',
  });

  // ── Data dummy daftar hewan ───────────────────────────────────────
  static const List<HewanModel> _hewanList = [
    HewanModel(
      name: 'Kucing Anggora',
      shelter: 'Shelter Pejuang Hewan',
      priceRange: '500rb - 5jt',
      rating: 5.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Anjing', 'Kucing'],
      imageUrl:
          'https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400&q=80',
      fallbackColorValue: 0xFFE8DDD0,
    ),
    HewanModel(
      name: 'Angsa',
      shelter: 'Shelter Pejuang Hewan',
      priceRange: '750rb - 10jt',
      rating: 4.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Angsa', 'Bebek'],
      imageUrl:
          'https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=400&q=80',
      fallbackColorValue: 0xFFD4E4D0,
    ),
    HewanModel(
      name: 'Anjing Chuahua',
      shelter: 'Shelter Pak Selamet',
      priceRange: '2jt - 20jt',
      rating: 5.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Anjing', 'Kucing'],
      imageUrl:
          'https://images.unsplash.com/photo-1548366086-7f1b76106622?w=400&q=80',
      fallbackColorValue: 0xFFD4C5A9,
    ),
    HewanModel(
      name: 'Kura-kura',
      shelter: 'Shelter Pejuang Hewan',
      priceRange: '1rb - 5jt',
      rating: 4.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Kura-kura', 'Kucing'],
      imageUrl:
          'https://images.unsplash.com/photo-1562515952-f6e7ab2e0174?w=400&q=80',
      fallbackColorValue: 0xFF7B8B6A,
    ),
    HewanModel(
      name: 'Iguana',
      shelter: 'Shelter Surganya Hewan',
      priceRange: '1rb - 5jt',
      rating: 4.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Iguana', 'Kucing'],
      imageUrl:
          'https://images.unsplash.com/photo-1597600159211-d6c104f408d1?w=400&q=80',
      fallbackColorValue: 0xFF8B9E5A,
    ),
    HewanModel(
      name: 'British Short Hair',
      shelter: 'Shelter Pejuang Hewan',
      priceRange: '2jt - 15jt',
      rating: 5.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Kucing'],
      imageUrl:
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400&q=80',
      fallbackColorValue: 0xFF8A9BAB,
    ),
    HewanModel(
      name: 'Kelinci',
      shelter: 'Shelter Hewan Bahagia',
      priceRange: '200rb - 2jt',
      rating: 4.0,
      reviewCount: 99,
      tags: ['Vaksin', 'Kelinci'],
      imageUrl:
          'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=400&q=80',
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
            // ── AppBar custom ───────────────────────────────────────
            _LihatSemuaAppBar(title: title),

            // ── Daftar hewan ────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
                itemCount: _hewanList.length,
                itemBuilder: (context, index) =>
                    HewanListCard(hewan: _hewanList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── AppBar dengan tombol back + judul tengah ─────────────────────────────────
class _LihatSemuaAppBar extends StatelessWidget {
  final String title;
  const _LihatSemuaAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 20.w, 10.h),
      child: Row(
        children: [
          // Tombol back
          IconButton(
            onPressed: () => AppNavigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 24.w,
              color: const Color(0xFFF87537),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          // Judul tengah
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
          // Placeholder agar judul benar-benar di tengah
          SizedBox(width: 24.w),
        ],
      ),
    );
  }
}