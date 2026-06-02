import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/shelter_header_widget.dart';
import '../widgets/shelter_cover_avatar.dart';
import '../widgets/shelter_info_field.dart';
import '../widgets/shelter_payment_section.dart';

class ProfilShelterView extends StatefulWidget {
  const ProfilShelterView({super.key});

  @override
  State<ProfilShelterView> createState() => _ProfilShelterViewState();
}

class _ProfilShelterViewState extends State<ProfilShelterView> {
  // Controllers informasi dasar
  final _namaShelterController = TextEditingController(text: 'Paws Shelter Central');
  final _emailController = TextEditingController(text: 'contact@pawsshelter.org');
  final _teleponController = TextEditingController(text: '+62 812 3456 7890');
  final _alamatController = TextEditingController(
      text: 'Jl. Kemang Raya No. 12, Jakarta Selatan, 12730');

  @override
  void dispose() {
    _namaShelterController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header: logo HewanKu + icon notif
            ShelterHeaderWidget(
              onNotifTap: () {
                // TODO: navigasi ke notifikasi
              },
            ),

            // Konten scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Cover + avatar ──
                    ShelterCoverAvatar(
                      onEditCover: () {
                        // TODO: buka image picker untuk cover
                      },
                      onEditAvatar: () {
                        // TODO: buka image picker untuk avatar
                      },
                    ),
                    SizedBox(height: 52.h), // space untuk avatar yang overlap

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── SECTION: INFORMASI DASAR ──
                          _SectionTitle(title: 'INFORMASI DASAR'),
                          SizedBox(height: 14.h),

                          ShelterInfoField(
                            label: 'Nama Shelter',
                            hintText: 'Paws Shelter Central',
                            controller: _namaShelterController,
                            prefixIcon: Icons.home_outlined,
                          ),
                          SizedBox(height: 14.h),

                          ShelterInfoField(
                            label: 'Email Kontak',
                            hintText: 'contact@shelter.com',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 14.h),

                          ShelterInfoField(
                            label: 'Nomor Telepon',
                            hintText: '+62 812 3456 7890',
                            controller: _teleponController,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 28.h),

                          // ── SECTION: METODE PEMBAYARAN ──
                          _SectionTitle(title: 'METODE PEMBAYARAN'),
                          SizedBox(height: 14.h),

                          const ShelterPaymentSection(),
                          SizedBox(height: 28.h),

                          // ── SECTION: LOKASI & DETAIL ──
                          _SectionTitle(title: 'LOKASI & DETAIL'),
                          SizedBox(height: 14.h),

                          ShelterInfoField(
                            label: 'Alamat Lengkap',
                            hintText: 'Jl. ...',
                            controller: _alamatController,
                            prefixIcon: Icons.location_on_outlined,
                            maxLines: 3,
                          ),
                          SizedBox(height: 20.h),

                          // ── Status Verifikasi card ──
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 14.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3EC),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: const Color(0xFFF87537).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.verified_user_outlined,
                                    color: primaryColor, size: 22.sp),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status Verifikasi',
                                        style: textTheme.labelLarge?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Terverifikasi sejak Jan 2023',
                                        style: textTheme.labelMedium?.copyWith(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.check_circle,
                                    color: primaryColor, size: 22.sp),
                              ],
                            ),
                          ),
                          SizedBox(height: 28.h),

                          // ── Tombol SIMPAN PERUBAHAN ──
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: simpan ke API
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              ),
                              icon: Icon(Icons.save_outlined,
                                  color: Colors.white, size: 18.sp),
                              label: Text(
                                'SIMPAN PERUBAHAN',
                                style: textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget judul section — bold uppercase
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: Colors.black,
        letterSpacing: 0.5,
      ),
    );
  }
}