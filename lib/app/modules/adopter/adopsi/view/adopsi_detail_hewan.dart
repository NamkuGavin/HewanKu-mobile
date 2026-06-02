import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../favorit/view/favorit_view.dart';
import '../../navbar/widgets/bottom_navbar.dart';
import '../../notifikasi/view/notifikasi_view.dart';
import '../widgets/hewan_model.dart';
import '../widgets/detail_hewan_widgets.dart';

class AdopsiDetailHewanView extends StatelessWidget {
  final HewanModel hewan;
  final ValueChanged<int>? onTabTap; // ← callback dari NavbarView
  final String jenisKelamin;
  final String umur;
  final String statusAdopsi;
  final double hargaAsli;
  final double hargaDiskon;
  final String kontakPenjual;

  const AdopsiDetailHewanView({
    super.key,
    required this.hewan,
    this.onTabTap,
    this.jenisKelamin = 'Jantan',
    this.umur = '2 Tahun',
    this.statusAdopsi = 'Belum di adopsi',
    this.hargaAsli = 6500000,
    this.hargaDiskon = 6000000,
    this.kontakPenjual = '+6281367889011',
  });

  @override
  Widget build(BuildContext context) {
    final category = hewan.tags.isNotEmpty ? hewan.tags.first : '-';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailHewanHeader(),
              SizedBox(height: 8.h),
              DetailHewanHeroImage(hewan: hewan),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${hewan.name} - ${hewan.shelter}',
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    DetailHewanRating(
                      rating: hewan.rating,
                      reviewCount: hewan.reviewCount,
                    ),
                    SizedBox(height: 14.h),
                    DetailHewanInfoGrid(
                      jenisKelamin: jenisKelamin,
                      umur: umur,
                      statusAdopsi: statusAdopsi,
                      category: category,
                    ),
                    SizedBox(height: 16.h),
                    DetailHewanPriceRow(
                      hargaAsli: hargaAsli,
                      hargaDiskon: hargaDiskon,
                      onAdopsiTap: () {},
                    ),
                    SizedBox(height: 16.h),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1, height: 1),
                    SizedBox(height: 14.h),
                    DetailHewanFavoritRow(
                      hewan: hewan,
                      onLihatReviewTap: () {},
                    ),
                    SizedBox(height: 10.h),
                    DetailHewanKontakRow(
                      kontakPenjual: kontakPenjual,
                      onKontakTap: () {},
                    ),
                    SizedBox(height: 16.h),
                    const DetailHewanPaymentCard(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavbar(
        currentIndex: 1,
        onTap: (index) {
          // Pop semua halaman sampai NavbarView (root), lalu pindah tab
          AppNavigator.popUntilFirst(context);
          onTabTap?.call(index);
        },
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────
class _DetailHewanHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 12.h, 20.w, 10.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, color: primaryColor, size: 24.sp),
          ),
          const Spacer(),
          _IconBtn(
            icon: Icons.notifications_none_rounded,
            color: primaryColor,
            onTap: () => AppNavigator.push(context, const NotifikasiView()),
          ),
          SizedBox(width: 8.w),
          _IconBtn(
            icon: Icons.favorite_border_rounded,
            color: primaryColor,
            onTap: () => AppNavigator.push(context, const FavoritView()),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F8F8),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36.w,
          height: 36.h,
          child: Icon(icon, size: 20.w, color: color),
        ),
      ),
    );
  }
}