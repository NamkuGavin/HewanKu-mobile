import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritEmptyState extends StatelessWidget {
  const FavoritEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFBF8), Color(0xFFF9F2EC)],
            ),
          ),
        ),
        Positioned(top: -30.h, right: -35.w, child: const _SoftBlob(size: 170)),
        Positioned(bottom: 90.h, left: -45.w, child: const _SoftBlob(size: 140)),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 28.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: const Color(0xFFF2DED0)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 22, offset: const Offset(0, 12)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 78.w,
                    height: 78.w,
                    decoration: const BoxDecoration(color: Color(0xFFFFEFE5), shape: BoxShape.circle),
                    child: Icon(Icons.favorite_border_rounded, size: 38.sp, color: const Color(0xFFF87537)),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Belum ada hewan favorit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Simpan hewan yang kamu suka dari halaman detail. Semua favorit akan muncul lagi di sini.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 12.sp, height: 1.6, color: const Color(0xFF7F7F7F)),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(color: const Color(0xFFFFF7F1), borderRadius: BorderRadius.circular(50.r)),
                    child: Text(
                      'Penghapusan favorit dilakukan dari detail hewan',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFBC622F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SoftBlob extends StatelessWidget {
  final double size;

  const _SoftBlob({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [const Color(0xFFF87537).withValues(alpha: 0.18), const Color(0xFFFBA81F).withValues(alpha: 0.06)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.6),
          topRight: Radius.circular(size * 0.32),
          bottomLeft: Radius.circular(size * 0.42),
          bottomRight: Radius.circular(size * 0.7),
        ),
      ),
    );
  }
}
