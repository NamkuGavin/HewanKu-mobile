import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hewanku_mobile/app/common/contant/assets.dart';
import 'package:hewanku_mobile/app/modules/shelter/hewan/widgets/hewan_card.dart';
import 'package:hewanku_mobile/app/modules/shelter/permohonan/widgets/permohonan_card.dart';

class HomeShelterView extends StatelessWidget {
  // Callback dari navbar — pindah ke tab Profil tanpa push
  final VoidCallback? onGoToProfil;

  const HomeShelterView({super.key, this.onGoToProfil});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(IconAsset.hewankuLogoSecondary),
                  Material(
                    color: const Color(0xFFF8F8F8),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
                      child: SizedBox(
                        width: 36.w, height: 36.h,
                        child: Icon(Icons.notifications_none_rounded, size: 20.sp, color: primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Search bar
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cari Hewan...',
                  hintStyle: textTheme.labelLarge?.copyWith(color: const Color(0xFF9E9E9E)),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
                  filled: true,
                  fillColor: const Color(0xFFE9E9E9),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shelter Hewan',
                      style: textTheme.labelLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8.h),
                    Text('Ayo Buat Shelter\nKamu',
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800, height: 1.2, fontSize: 22.sp)),
                    SizedBox(height: 8.h),
                    Text('Kelola hewan peliharaan dan temukan pemilik baru untuk mereka.',
                      style: textTheme.labelLarge?.copyWith(color: Colors.black54)),
                    SizedBox(height: 16.h),

                    // Tombol Daftar Shelter → pindah tab ke Profil (navbar tetap ada)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryColor,
                          minimumSize: Size(double.infinity, 45.h),
                          elevation: 0,
                          side: const BorderSide(color: Color(0xFFE9E9E9)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
                        ),
                        onPressed: onGoToProfil, // ← pindah tab, bukan push
                        icon: Icon(Icons.storefront_outlined, size: 18.sp),
                        label: Text('Daftar Shelter',
                          style: textTheme.labelLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Tombol Daftar Hewan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 45.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
                        ),
                        onPressed: () {
                          // TODO: navigasi ke halaman daftar hewan
                        },
                        icon: Icon(Icons.add_circle_outline, size: 18.sp),
                        label: Text('Daftar Hewan',
                          style: textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Statistik
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SIAP ADOPSI', style: textTheme.labelMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                        SizedBox(height: 4.h),
                        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text('24', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 28.sp)),
                          SizedBox(width: 4.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Text('Ekor', style: textTheme.bodySmall?.copyWith(color: Colors.black54)),
                          ),
                        ]),
                      ],
                    ),
                    Icon(Icons.bar_chart_rounded, color: primaryColor, size: 32.sp),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Hewan di Shelter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hewan di Shelter kamu', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  TextButton(onPressed: () {}, child: Text('Lihat Semua', style: TextStyle(color: primaryColor, fontSize: 12.sp))),
                ],
              ),
              SizedBox(height: 8.h),

              HewanCard(name: 'Mochi', price: 'Rp 0 (Adopsi)', status: 'AKTIF', statusColor: Colors.green, imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=200', waktu: '2 jam lalu'),
              HewanCard(name: 'Buddy', price: 'Rp 0 (Adopsi)', status: 'PENDING', statusColor: Colors.orange, imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=200', waktu: '5 jam lalu'),
              HewanCard(name: 'Luna', price: 'Teradopsi', status: 'SELESAI', statusColor: Colors.grey, imageUrl: 'https://images.unsplash.com/photo-1596492784531-6e6eb5ea9993?w=200', waktu: '1 hari lalu'),
              SizedBox(height: 8.h),

              // Permohonan Adopsi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Permohonan Adopsi', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  TextButton(onPressed: () {}, child: Text('Lihat Semua', style: TextStyle(color: primaryColor, fontSize: 12.sp))),
                ],
              ),
              SizedBox(height: 8.h),

              const PermohonanCard(petName: 'Milo', requester: 'Requested by Sarah Jenkins', imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=100'),
              const PermohonanCard(petName: 'Bella', requester: 'Requested by David Chen', imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=100'),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}