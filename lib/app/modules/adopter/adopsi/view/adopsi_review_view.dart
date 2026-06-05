import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../widgets/adopsi_review_widgets.dart';

class AdopsiReviewView extends StatelessWidget {
  const AdopsiReviewView({super.key});

  // ── Data dummy — ganti dengan data dari API nanti ─────────────────────────
  static const double _ratingRata = 5.0;
  static const int _totalUlasan = 1200;

  static const Map<int, double> _distribusi = {
    5: 1.0,
    4: 0.0,
    3: 0.0,
    2: 0.0,
    1: 0.0,
  };

  static const List<ReviewItem> _reviews = [
    ReviewItem(
      nama: 'Najwa',
      tanggal: '27/01/2025',
      rating: 5.0,
      ulasan:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut.',
    ),
    ReviewItem(
      nama: 'Najwa',
      tanggal: '27/01/2025',
      rating: 5.0,
      ulasan:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut.',
    ),
    ReviewItem(
      nama: 'Najwa',
      tanggal: '27/01/2025',
      rating: 5.0,
      ulasan:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut.',
    ),
    ReviewItem(
      nama: 'Najwa',
      tanggal: '27/01/2025',
      rating: 5.0,
      ulasan:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut.',
    ),
    ReviewItem(
      nama: 'Najwa',
      tanggal: '27/01/2025',
      rating: 5.0,
      ulasan:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar custom ──────────────────────────────────────
            _ReviewAppBar(),
            // ── Konten scrollable ──────────────────────────────────
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // Rating summary
                  ReviewRatingSummary(
                    ratingRata: _ratingRata,
                    totalUlasan: _totalUlasan,
                    distribusi: _distribusi,
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                  // List review
                  ..._reviews.map((item) => ReviewCard(item: item)),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── AppBar: tombol back + judul tengah ───────────────────────────────────────
class _ReviewAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 20.w, 10.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: primaryColor,
              size: 24.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Rating & Ulasan',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          SizedBox(width: 24.w), // placeholder agar judul benar-benar di tengah
        ],
      ),
    );
  }
}