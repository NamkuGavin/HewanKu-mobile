import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeroBanner extends StatelessWidget {
  final VoidCallback? onAdopsiTap;

  const HomeHeroBanner({super.key, this.onAdopsiTap});

  static const List<String> _photos = [
    'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400',
    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400',
    'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=400',
  ];

  @override
  Widget build(BuildContext context) {
    // Ambil font dari theme — sudah Poppins sesuai AppThemeData
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          color: const Color(0xFFF8F9FA),
          child: Stack(
            children: [
              // Blob kanan atas — gradient F87537 → FBA81F
              Positioned(
                top: -30,
                right: -30,
                child: _GradientBlob(size: 130),
              ),
              // Blob kiri bawah
              Positioned(
                bottom: 60,
                left: -30,
                child: _GradientBlob(size: 100),
              ),
              // Blob kanan bawah kecil
              Positioned(
                bottom: -20,
                right: 40,
                child: _GradientBlob(size: 70),
              ),

              // Konten
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label oranye — pakai font dari theme (Poppins)
                    Text(
                      'Adopsi Hewan',
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFFF87537),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Judul besar — pakai bodyLarge dari theme lalu override size & weight
                    Text(
                      'Temukan Pasangan\nSempurna Anda. Adopsi\nHewan Peliharaan Hari Ini.',
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Deskripsi
                    Text(
                      'Buka pintu rumah dan hatimu untuk hewan yang kamu butuhkan. Temukan kecocokan terbaik dan berikan mereka kesempatan kedua untuk hidup bahagia bersamamu.',
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF757575),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Grid foto
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.r),
                            child: Image.network(
                              _photos[0],
                              height: 170.h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _placeholder(170.h),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: Image.network(
                                  _photos[1],
                                  height: 80.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => _placeholder(80.h),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: Image.network(
                                  _photos[2],
                                  height: 80.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => _placeholder(80.h),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Tombol hitam pill
                    Center(
                      child: ElevatedButton(
                        onPressed: onAdopsiTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 36.w, vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        child: Text(
                          'Adopsi Sekarang',
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFE0E0E0),
      child: const Icon(Icons.pets, color: Colors.white70),
    );
  }
}

// Blob dengan gradient F87537 (oranye tua) → FBA81F (oranye kuning) — sama persis Figma
class _GradientBlob extends StatelessWidget {
  final double size;
  const _GradientBlob({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF87537), // stop 0% — oranye tua
            Color(0xFFFBA81F), // stop 100% — oranye kuning
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.6),
          topRight: Radius.circular(size * 0.3),
          bottomLeft: Radius.circular(size * 0.4),
          bottomRight: Radius.circular(size * 0.7),
        ),
      ),
    );
  }
}