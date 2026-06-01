import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/build_header_app.dart';
import '../../navbar/widgets/bottom_navbar.dart';
import '../widgets/hewan_model.dart';
import '../widgets/detail_hewan_widgets.dart';

class AdopsiDetailHewanView extends StatelessWidget {
  final HewanModel hewan;
  final String jenisKelamin;
  final String umur;
  final String statusAdopsi;
  final double hargaAsli;
  final double hargaDiskon;
  final String kontakPenjual;

  const AdopsiDetailHewanView({
    super.key,
    required this.hewan,
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
              const BuildAppHeader(),
              SizedBox(height: 8.h),

              DetailHewanHeroImage(hewan: hewan),

              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Nama hewan + shelter ──
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
                      onAdopsiTap: () {
                        // TODO: navigasi ke halaman checkout/adopsi
                      },
                    ),
                    SizedBox(height: 16.h),

                    const Divider(
                      color: Color(0xFFEEEEEE),
                      thickness: 1,
                      height: 1,
                    ),
                    SizedBox(height: 14.h),

                    DetailHewanFavoritRow(
                      onLihatReviewTap: () {
                        // TODO: navigasi ke halaman review hewan
                      },
                    ),
                    SizedBox(height: 10.h),

                    DetailHewanKontakRow(
                      kontakPenjual: kontakPenjual,
                      onKontakTap: () {
                        // TODO: launchUrl(Uri.parse('tel:$kontakPenjual'));
                      },
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
        onTap: (_) {},
      ),
    );
  }
}