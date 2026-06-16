import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/contant/assets.dart';
import '../../../../common/widgets/app_net_image.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../services/api/api_exception.dart';
import '../../favorit/model/favorit_item.dart';
import '../../favorit/model/favorit_provider.dart';
import 'hewan_model.dart';

const _orange = Color(0xFFF87537);

String _formatReview(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  int count = 0;

  for (int index = digits.length - 1; index >= 0; index--) {
    if (count > 0 && count % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[index]);
    count++;
  }

  return buffer.toString().split('').reversed.join();
}

class DetailHewanHeroImage extends StatelessWidget {
  final HewanModel hewan;

  const DetailHewanHeroImage({super.key, required this.hewan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: SizedBox(
          height: 248.h,
          width: double.infinity,
          child: AppNetImage(url: hewan.imageUrl, fallbackColor: Color(hewan.fallbackColorValue)),
        ),
      ),
    );
  }
}

class DetailHewanMetaChips extends StatelessWidget {
  final String category;
  final String statusAdopsi;

  const DetailHewanMetaChips({super.key, required this.category, required this.statusAdopsi});

  @override
  Widget build(BuildContext context) {
    final status = statusAdopsi.trim().toLowerCase();
    final statusColor = status.contains('tersedia') ? const Color(0xFF1F8A4D) : const Color(0xFFB96A00);
    final statusBackground = status.contains('tersedia') ? const Color(0xFFEAF8F0) : const Color(0xFFFFF6E8);

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _MetaChip(
          icon: Icons.pets_rounded,
          label: category,
          backgroundColor: const Color(0xFFFCE8DE),
          foregroundColor: const Color(0xFFBC622F),
        ),
        _MetaChip(
          icon: Icons.verified_rounded,
          label: statusAdopsi,
          backgroundColor: statusBackground,
          foregroundColor: statusColor,
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const _MetaChip({required this.icon, required this.label, required this.backgroundColor, required this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(50.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: foregroundColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w700, color: foregroundColor),
          ),
        ],
      ),
    );
  }
}

class DetailHewanRating extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const DetailHewanRating({super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    final hasReview = rating > 0 && reviewCount > 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF1E2D8)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(color: Color(0xFFFFF1E8), shape: BoxShape.circle),
            child: Icon(Icons.star_rounded, color: _orange, size: 18.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasReview ? '$rating / 5.0' : 'Belum ada review',
                  style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)),
                ),
                SizedBox(height: 2.h),
                Text(
                  hasReview ? '${_formatReview(reviewCount)} ulasan adopter' : 'Rating akan muncul setelah ada penilaian.',
                  style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF7E7E7E), height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailHewanInfoGrid extends StatelessWidget {
  final String jenisKelamin;
  final String umur;
  final String statusAdopsi;
  final String kategori;

  const DetailHewanInfoGrid({
    super.key,
    required this.jenisKelamin,
    required this.umur,
    required this.statusAdopsi,
    required this.kategori,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      childAspectRatio: 1.75,
      children: [
        _InfoTile(icon: Icons.category_rounded, label: 'Kategori', value: kategori),
        _InfoTile(icon: Icons.transgender_rounded, label: 'Jenis Kelamin', value: jenisKelamin),
        _InfoTile(icon: Icons.cake_rounded, label: 'Umur', value: umur),
        _InfoTile(icon: Icons.inventory_2_rounded, label: 'Status', value: statusAdopsi),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF0E5DE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16.sp, color: const Color(0xFFF87537)),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 10.sp, color: const Color(0xFF8F8F8F), fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: const Color(0xFF1A1A1A),
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailHewanPriceCard extends StatelessWidget {
  final String harga;
  final VoidCallback? onAdopsiTap;

  const DetailHewanPriceCard({super.key, required this.harga, this.onAdopsiTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6F0),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF5D7C7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biaya adopsi',
            style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF8A8A8A), fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(
            harga,
            style: GoogleFonts.poppins(fontSize: 21.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1A1A1A)),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAdopsiTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              child: Text(
                'Adopsi Sekarang',
                style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailHewanFavoritRow extends StatelessWidget {
  final HewanModel hewan;
  final VoidCallback? onLihatReviewTap;

  const DetailHewanFavoritRow({super.key, required this.hewan, this.onLihatReviewTap});

  Future<void> _toggleFavorite(BuildContext context, {required bool isFavorit}) async {
    try {
      if (isFavorit) {
        await FavoritProvider.hapus(context, hewan);
      } else {
        await FavoritProvider.tambah(context, hewan);
      }

      if (!context.mounted) {
        return;
      }

      AppSnackbar.show(
        context,
        message: isFavorit ? 'Hewan berhasil dihapus dari favorit.' : 'Hewan berhasil disimpan ke favorit.',
        type: AppSnackbarType.success,
      );
    } catch (error) {
      if (!context.mounted || _isUnauthorized(error)) {
        return;
      }

      AppSnackbar.show(context, message: _resolveErrorMessage(error), type: _resolveErrorType(error));
    }
  }

  bool _isUnauthorized(Object error) {
    return error is ApiException && error.isUnauthorized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Gagal memperbarui favorit hewan.';
  }

  AppSnackbarType _resolveErrorType(Object error) {
    if (error is ApiException) {
      final statusCode = error.statusCode;
      if (statusCode == null || statusCode >= 500) {
        return AppSnackbarType.error;
      }
      return AppSnackbarType.warning;
    }
    return AppSnackbarType.error;
  }

  @override
  Widget build(BuildContext context) {
    final controller = FavoritProvider.of(context);
    if (!controller.hasLoaded && !controller.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadFavorites().catchError((_) {});
      });
    }

    return ValueListenableBuilder<List<FavoritItem>>(
      valueListenable: controller,
      builder: (context, list, _) {
        final isFavorit = controller.containsAnimal(hewan);
        final isBusy = controller.isBusy(hewan.id);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10.w,
          children: [
            GestureDetector(
              onTap: isBusy ? null : () => _toggleFavorite(context, isFavorit: isFavorit),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isBusy)
                    SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2.2, color: _orange),
                    )
                  else
                    Icon(
                      isFavorit ? Icons.favorite_rounded : Icons.favorite_border,
                      color: isFavorit ? _orange : const Color(0xFF676767),
                      size: 19.sp,
                    ),
                  SizedBox(width: 6.w),
                  Text(
                    isBusy
                        ? 'Menyimpan favorit...'
                        : isFavorit
                        ? 'Sudah di Favorit'
                        : 'Tambahkan ke Favorit',
                    style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF444444), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onLihatReviewTap,
              child: Text(
                'Lihat Review Hewan',
                style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w700, color: _orange),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DetailHewanKontakCard extends StatelessWidget {
  final String shelterName;
  final String kontakShelter;

  const DetailHewanKontakCard({super.key, required this.shelterName, required this.kontakShelter});

  String get _displayPhone => kontakShelter.trim();

  String get _waNumber {
    final digits = kontakShelter.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('0')) {
      return '62${digits.substring(1)}';
    }
    return digits;
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    if (_waNumber.isEmpty) {
      AppSnackbar.show(context, message: 'Nomor WhatsApp shelter belum tersedia.', type: AppSnackbarType.warning);
      return;
    }

    final uri = Uri.parse('https://wa.me/$_waNumber');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      AppSnackbar.show(context, message: 'WhatsApp tidak dapat dibuka saat ini.', type: AppSnackbarType.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhone = _displayPhone.isNotEmpty && _displayPhone != '-';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF0E5DE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: const BoxDecoration(color: Color(0xFFE9F8EF), shape: BoxShape.circle),
                child: Icon(Icons.chat_bubble_rounded, color: Color(0xFF1F8A4D), size: 18.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kontak Shelter',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      shelterName,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: const Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            hasPhone ? _displayPhone : 'Nomor WhatsApp belum tersedia',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: hasPhone ? const Color(0xFF444444) : const Color(0xFF8F8F8F),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: hasPhone ? () => _openWhatsApp(context) : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1F8A4D),
                side: const BorderSide(color: Color(0xFF1F8A4D), width: 1.2),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              icon: Icon(Icons.chat_rounded, size: 18.sp),
              label: Text(
                'Chat WhatsApp',
                style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailHewanPaymentCard extends StatelessWidget {
  const DetailHewanPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0E5DE)),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Checkout Aman 100% Terjamin',
            style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF333333)),
          ),
          SizedBox(height: 6.h),
          Text(
            'Metode pembayaran populer siap digunakan saat proses adopsi.',
            style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF8A8A8A), height: 1.45),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PaymentLogo(assetPath: ImageAsset.gopay, height: 22.h),
              _PaymentLogo(assetPath: ImageAsset.qris, height: 20.h),
              _PaymentLogo(assetPath: ImageAsset.mandiriLogo, height: 22.h),
              _PaymentLogo(assetPath: ImageAsset.danaLogo, height: 22.h),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentLogo extends StatelessWidget {
  final String assetPath;
  final double height;

  const _PaymentLogo({required this.assetPath, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetPath, height: height, fit: BoxFit.contain);
  }
}
