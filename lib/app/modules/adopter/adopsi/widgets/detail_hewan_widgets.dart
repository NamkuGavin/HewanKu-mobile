import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/contant/assets.dart';
import '../../favorit/model/favorit_item.dart';
import '../../favorit/model/favorit_provider.dart';
import '../../../../common/widgets/app_net_image.dart';
import 'hewan_model.dart';
import 'hewan_list_card.dart';

// ── Konstanta warna lokal ────────────────────────────────────────────────────
const _orange = Color(0xFFF87537);

// ── Helper format angka ──────────────────────────────────────────────────────
String formatRupiah(double v) {
  final s = v.round().toString();
  final buf = StringBuffer();
  int c = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    if (c > 0 && c % 3 == 0) buf.write('.');
    buf.write(s[i]);
    c++;
  }
  return 'Rp${buf.toString().split('').reversed.join()}';
}

String formatReview(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  int c = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    if (c > 0 && c % 3 == 0) buf.write(',');
    buf.write(s[i]);
    c++;
  }
  return buf.toString().split('').reversed.join();
}

// ── 1. Hero Image ────────────────────────────────────────────────────────────
class DetailHewanHeroImage extends StatelessWidget {
  final HewanModel hewan;
  const DetailHewanHeroImage({super.key, required this.hewan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          height: 280.h,
          width: double.infinity,
          child: AppNetImage(
            url: hewan.imageUrl,
            fallbackColor: Color(hewan.fallbackColorValue),
          ),
        ),
      ),
    );
  }
}

// ── 2. Rating ────────────────────────────────────────────────────────────────
class DetailHewanRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  const DetailHewanRating({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          if (i < rating.floor()) {
            return Icon(Icons.star_rounded, color: _orange, size: 16.sp);
          } else if (i < rating) {
            return Icon(Icons.star_half_rounded, color: _orange, size: 16.sp);
          } else {
            return Icon(Icons.star_border_rounded, color: _orange, size: 16.sp);
          }
        }),
        SizedBox(width: 6.w),
        Text(
          '$rating Star Rating',
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '(${formatReview(reviewCount)} User feedback)',
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: const Color(0xFF888888),
          ),
        ),
      ],
    );
  }
}

// ── 3. Tags ──────────────────────────────────────────────────────────────────
class DetailHewanTags extends StatelessWidget {
  final List<String> tags;
  const DetailHewanTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: tags.map((tag) => HewanTagChip(label: tag)).toList(),
    );
  }
}

// ── 4. Info Grid ─────────────────────────────────────────────────────────────
class DetailHewanInfoGrid extends StatelessWidget {
  final String jenisKelamin;
  final String umur;
  final String statusAdopsi;
  final String category;

  const DetailHewanInfoGrid({
    super.key,
    required this.jenisKelamin,
    required this.umur,
    required this.statusAdopsi,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _InfoLabel('Jenis Kelamin', jenisKelamin, bold: true)),
            Expanded(child: _InfoLabel('Tersedia', statusAdopsi, valueColor: _orange)),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(child: _InfoLabel('Umur', umur, bold: true)),
            Expanded(child: _InfoLabel('Category', category, bold: true)),
          ],
        ),
      ],
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _InfoLabel(this.label, this.value, {this.bold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF555555)),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: valueColor ?? const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 5. Harga + Tombol Adopsi ─────────────────────────────────────────────────
class DetailHewanPriceRow extends StatelessWidget {
  final double hargaAsli;
  final double hargaDiskon;
  final VoidCallback? onAdopsiTap;

  const DetailHewanPriceRow({
    super.key,
    required this.hargaAsli,
    required this.hargaDiskon,
    this.onAdopsiTap,
  });

  int get _discountPercent =>
      ((hargaAsli - hargaDiskon) / hargaAsli * 100).round();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formatRupiah(hargaDiskon),
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: Colors.lightBlueAccent,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              formatRupiah(hargaAsli),
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: const Color(0xFFAAAAAA),
                decoration: TextDecoration.lineThrough,
                decorationColor: const Color(0xFFAAAAAA),
              ),
            ),
            SizedBox(width: 5.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _orange,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '$_discountPercent% OFF',
                style: GoogleFonts.poppins(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onAdopsiTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _orange, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'ADOPSI SEKARANG',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: _orange,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── 6. Favorit + Lihat Review ────────────────────────────────────────────────
// Menerima HewanModel agar bisa tambah/hapus favorit via FavoritProvider
class DetailHewanFavoritRow extends StatelessWidget {
  final HewanModel hewan;
  final VoidCallback? onLihatReviewTap;

  const DetailHewanFavoritRow({
    super.key,
    required this.hewan,
    this.onLihatReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<FavoritItem>>(
      valueListenable: FavoritProvider.of(context),
      builder: (context, list, _) {
        final isFavorit = list.any((f) => f.namaHewan == hewan.name);
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                if (isFavorit) {
                  FavoritProvider.hapus(
                    context,
                    FavoritItem(
                      imageUrl: hewan.imageUrl,
                      namaHewan: hewan.name,
                      namaShelter: hewan.shelter,
                      waktu: 'Baru saja',
                    ),
                  );
                } else {
                  FavoritProvider.tambah(
                    context,
                    FavoritItem(
                      imageUrl: hewan.imageUrl,
                      namaHewan: hewan.name,
                      namaShelter: hewan.shelter,
                      waktu: 'Baru saja',
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Icon(
                    isFavorit ? Icons.favorite : Icons.favorite_border,
                    color: isFavorit ? _orange : const Color(0xFF666666),
                    size: 20.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Tambahkan ke Favorit',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: const Color(0xFF444444),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onLihatReviewTap,
              child: Text(
                'Lihat Review Hewan',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: _orange,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── 7. Kontak Penjual ────────────────────────────────────────────────────────
class DetailHewanKontakRow extends StatelessWidget {
  final String kontakPenjual;
  final VoidCallback? onKontakTap;

  const DetailHewanKontakRow({
    super.key,
    required this.kontakPenjual,
    this.onKontakTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Kontak Penjual',
          style: GoogleFonts.poppins(fontSize: 13.sp, color: const Color(0xFF444444)),
        ),
        SizedBox(width: 14.w),
        GestureDetector(
          onTap: onKontakTap,
          child: Text(
            kontakPenjual,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: _orange,
            ),
          ),
        ),
      ],
    );
  }
}

// ── 8. Payment Card ──────────────────────────────────────────────────────────
class DetailHewanPaymentCard extends StatelessWidget {
  const DetailHewanPaymentCard({super.key});

  static const _logos = [
    ImageAsset.gopay,
    ImageAsset.qris,
    ImageAsset.mandiriLogo,
    ImageAsset.danaLogo,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDDDDD)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Checkout Aman 100% Terjamin',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: _logos
                .map((logo) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Image.asset(
                          logo,
                          height: 28.h,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}