import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ── Import dari widgets/ yang sudah ada ──────────────────────
import '../widgets/shelter_header_widget.dart';
import '../widgets/shelter_cover_avatar.dart';
import '../widgets/shelter_info_field.dart';
import '../widgets/shelter_payment_section.dart';

// ── Import LogoutSheet dari adopter ──────────────────────────
import 'package:hewanku_mobile/app/modules/adopter/profil/widgets/logout_sheet.dart';


class ProfilShelterView extends StatefulWidget {
  const ProfilShelterView({super.key});

  @override
  State<ProfilShelterView> createState() => _ProfilShelterViewState();
}

class _ProfilShelterViewState extends State<ProfilShelterView> {
  final _namaShelterController = TextEditingController(
    text: 'Paws Shelter Central',
  );
  final _emailController = TextEditingController(
    text: 'contact@pawsshelter.org',
  );
  final _teleponController = TextEditingController(text: '+62 812 3456 7890');
  final _alamatController = TextEditingController(
    text: 'Jl. Kemang Raya No. 12, Jakarta Selatan, 12730',
  );

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
            // ① Header — dari shelter_header_widget.dart
            ShelterHeaderWidget(onNotifTap: () {}),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ② Cover + Avatar — dari shelter_cover_avatar.dart
                    ShelterCoverAvatar(onEditCover: () {}, onEditAvatar: () {}),
                    SizedBox(height: 52.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── INFORMASI DASAR ───────────────
                          _SectionTitle(title: 'INFORMASI DASAR'),
                          SizedBox(height: 14.h),

                          // ③ Field — dari shelter_info_field.dart
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

                          // ── METODE PEMBAYARAN ─────────────
                          _SectionTitle(title: 'METODE PEMBAYARAN'),
                          SizedBox(height: 14.h),

                          // ④ Payment — dari shelter_payment_section.dart
                          const ShelterPaymentSection(),
                          SizedBox(height: 28.h),

                          // ── LOKASI & DETAIL ───────────────
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

                          // ⑤ Status verifikasi
                          _VerifikasiCard(primaryColor: primaryColor),
                          SizedBox(height: 20.h),

                          // ── Tombol SIMPAN PERUBAHAN ───────
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8.w),
                                        const Text(
                                          'Perubahan berhasil disimpan!',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: primaryColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    margin: EdgeInsets.fromLTRB(
                                      20.w,
                                      0,
                                      20.w,
                                      16.h,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              ),
                              icon: Icon(
                                Icons.save_outlined,
                                color: Colors.white,
                                size: 18.sp,
                              ),
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
                          SizedBox(height: 12.h),

                          // ── Tombol LOG OUT ────────────────
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => LogoutSheet.show(context),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                side: BorderSide(color: primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              ),
                              icon: Icon(
                                Icons.logout_rounded,
                                color: primaryColor,
                                size: 18.sp,
                              ),
                              label: Text(
                                'Log Out',
                                style: textTheme.labelLarge?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
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

// ─────────────────────────────────────────────────────────────
// 2 widget kecil yang MEMANG tempatnya di view
// (terlalu sederhana untuk dijadikan file terpisah sendiri)
// ─────────────────────────────────────────────────────────────

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

class _VerifikasiCard extends StatelessWidget {
  final Color primaryColor;
  const _VerifikasiCard({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: primaryColor, size: 22.sp),
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
                  style: textTheme.labelMedium?.copyWith(color: primaryColor),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: primaryColor, size: 22.sp),
        ],
      ),
    );
  }
}
