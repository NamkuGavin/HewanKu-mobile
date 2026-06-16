import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/home/adopter_home_service.dart';
import '../../favorit/view/favorit_view.dart';
import '../../notifikasi/view/notifikasi_view.dart';
import '../widgets/detail_hewan_widgets.dart';
import '../widgets/hewan_model.dart';
import 'adopsi_form_identitas_view.dart';
import 'adopsi_review_view.dart';

class AdopsiDetailHewanView extends StatefulWidget {
  final HewanModel hewan;

  const AdopsiDetailHewanView({super.key, required this.hewan});

  @override
  State<AdopsiDetailHewanView> createState() => _AdopsiDetailHewanViewState();
}

class _AdopsiDetailHewanViewState extends State<AdopsiDetailHewanView> {
  late HewanModel _displayedHewan;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _displayedHewan = widget.hewan;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAnimalDetail());
  }

  Future<void> _loadAnimalDetail() async {
    if (_isRefreshing || !mounted || widget.hewan.id <= 0) {
      return;
    }

    setState(() => _isRefreshing = true);

    try {
      final detail = await AdopterHomeService.instance.getAnimalDetail(widget.hewan.id);

      if (!mounted) {
        return;
      }

      setState(() => _displayedHewan = detail);
    } catch (error) {
      if (!mounted || _isUnauthorized(error)) {
        return;
      }

      AppSnackbar.show(context, message: _resolveErrorMessage(error), type: _resolveErrorType(error));
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      } else {
        _isRefreshing = false;
      }
    }
  }

  bool _isUnauthorized(Object error) {
    return error is ApiException && error.isUnauthorized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Gagal memuat detail hewan.';
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
    final hewan = _displayedHewan;
    final category = hewan.kategori?.trim().isNotEmpty == true
        ? hewan.kategori!.trim()
        : (hewan.tags.isNotEmpty ? hewan.tags.first : 'Hewan');
    final statusAdopsi = hewan.statusAdopsi?.trim().isNotEmpty == true ? hewan.statusAdopsi!.trim() : 'Belum diadopsi';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: SafeArea(
        child: Column(
          children: [
            _DetailHewanHeader(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: _isRefreshing ? 2.h : 0,
              width: double.infinity,
              child: const LinearProgressIndicator(color: Color(0xFFF87537), backgroundColor: Color(0xFFFCE1D2)),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 28.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    DetailHewanHeroImage(hewan: hewan),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailHewanMetaChips(category: category, statusAdopsi: statusAdopsi),
                          SizedBox(height: 14.h),
                          Text(
                            hewan.name,
                            style: GoogleFonts.poppins(
                              fontSize: 21.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                              height: 1.32,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.storefront_rounded, size: 15.sp, color: const Color(0xFF929292)),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  hewan.shelter,
                                  style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF7D7D7D), height: 1.45),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          DetailHewanRating(rating: hewan.rating, reviewCount: hewan.reviewCount),
                          SizedBox(height: 18.h),
                          DetailHewanInfoGrid(
                            jenisKelamin: hewan.jenisKelamin ?? '-',
                            umur: hewan.umur ?? '-',
                            statusAdopsi: statusAdopsi,
                            kategori: category,
                          ),
                          SizedBox(height: 18.h),
                          DetailHewanPriceCard(
                            harga: hewan.price,
                            onAdopsiTap: () => AppNavigator.push(context, AdopsiFormIdentitasView(hewan: hewan)),
                          ),
                          SizedBox(height: 18.h),
                          const Divider(color: Color(0xFFF0ECE8), thickness: 1, height: 1),
                          SizedBox(height: 16.h),
                          DetailHewanFavoritRow(
                            hewan: hewan,
                            onLihatReviewTap: () => AppNavigator.push(context, const AdopsiReviewView()),
                          ),
                          SizedBox(height: 16.h),
                          DetailHewanKontakCard(shelterName: hewan.shelter, kontakShelter: hewan.kontakShelter ?? ''),
                          SizedBox(height: 16.h),
                          const DetailHewanPaymentCard(),
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
          Text(
            'Detail Hewan',
            style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)),
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
      color: const Color(0xFFF7F3EF),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38.w,
          height: 38.h,
          child: Icon(icon, size: 20.w, color: color),
        ),
      ),
    );
  }
}
