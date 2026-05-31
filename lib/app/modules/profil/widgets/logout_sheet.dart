import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/utils/app_navigator.dart';
import '../../auth/role/view/role_view.dart';
import '../../../common/contant/assets.dart';

class LogoutSheet extends StatelessWidget {
  const LogoutSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const LogoutSheet(),
    );
  }

  void _onConfirmLogout(BuildContext context) {
    // Tutup sheet dulu, lalu arahkan ke halaman intro (RoleView)
    // pushAndRemoveAll → hapus semua stack, user tidak bisa back ke Home
    AppNavigator.pushAndRemoveAll(context, const RoleView());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Tombol back pojok kiri atas ──────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 30.w,
                color: const Color(0xFFF87537),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // ── Ilustrasi ────────────────────────────────────────────
          Image.asset(
            ImageAsset.imageHewanku,
            width: 180.w,
            height: 180.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 28.h),

          // ── Judul ────────────────────────────────────────────────
          Text(
            'Apakah kamu yakin ingin\nLogout dari akunmu?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
              height: 1.35,
            ),
          ),
          SizedBox(height: 10.h),

          // ── Subtitle ─────────────────────────────────────────────
          Text(
            'Tenang saja, kamu masih bisa masuk kembali ke\nakunmu dengan cara login kembali terlebih dahulu',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: const Color(0xFF999999),
              height: 1.5,
            ),
          ),
          SizedBox(height: 32.h),

          // ── Tombol Lanjutkan Keluar Akun ─────────────────────────
          GestureDetector(
            onTap: () => _onConfirmLogout(context),
            child: Container(
              width: double.infinity,
              height: 52.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF87537), Color(0xFFFBA81F)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Text(
                'Lanjutkan Keluar Akun',
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}