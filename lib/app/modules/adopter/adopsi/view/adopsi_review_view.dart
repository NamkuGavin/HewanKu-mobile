import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../models/review/adopter_animal_review_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/order/adopter_review_service.dart';
import '../../home/widgets/home_section_placeholder.dart';
import '../widgets/adopsi_review_widgets.dart';

class AdopsiReviewView extends StatefulWidget {
  final int animalId;
  final String animalName;

  const AdopsiReviewView({
    super.key,
    required this.animalId,
    required this.animalName,
  });

  @override
  State<AdopsiReviewView> createState() => _AdopsiReviewViewState();
}

class _AdopsiReviewViewState extends State<AdopsiReviewView> {
  AdopterAnimalReviewModel _reviewData = const AdopterAnimalReviewModel.empty();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReviews());
  }

  Future<void> _loadReviews() async {
    if (widget.animalId <= 0) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      final reviewData = await AdopterReviewService.instance.getAnimalReviews(
        widget.animalId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _reviewData = reviewData;
        _isLoading = false;
        _hasError = false;
      });
    } catch (error) {
      if (!mounted || _isUnauthorized(error)) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      AppSnackbar.show(
        context,
        message: _resolveErrorMessage(error),
        type: _resolveErrorType(error),
      );
    }
  }

  bool _isUnauthorized(Object error) {
    return error is ApiException && error.isUnauthorized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Gagal memuat ulasan hewan.';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _ReviewAppBar(animalName: widget.animalName),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _ReviewLoadingState(animalName: widget.animalName);
    }

    if (_hasError) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        children: [
          HomeSectionPlaceholder(
            icon: Icons.reviews_outlined,
            title: 'Ulasan belum bisa dimuat',
            description:
                'Coba ambil ulang data ulasan untuk ${widget.animalName.trim().isEmpty ? 'hewan ini' : widget.animalName.trim()}.',
            onRetry: _loadReviews,
          ),
        ],
      );
    }

    if (!_reviewData.hasReviews) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        children: [
          _EmptyReviewState(
            animalName: widget.animalName,
            onRefresh: _loadReviews,
          ),
        ],
      );
    }

    final reviewItems = _reviewData.reviews
        .map(
          (item) => ReviewItem(
            nama: item.userName,
            tanggal: item.dateAdded,
            rating: item.rating,
            ulasan: item.comment,
            fotoUrl: item.photoUrl,
          ),
        )
        .toList(growable: false);

    return RefreshIndicator(
      color: const Color(0xFFF87537),
      onRefresh: _loadReviews,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          ReviewRatingSummary(
            ratingRata: _reviewData.averageRating,
            totalUlasan: _reviewData.totalReviews,
            distribusi: _reviewData.distributionRatio,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          ...reviewItems.map((item) => ReviewCard(item: item)),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _ReviewAppBar extends StatelessWidget {
  final String animalName;

  const _ReviewAppBar({required this.animalName});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final trimmedAnimalName = animalName.trim();

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 20.w, 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => AppNavigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: primaryColor,
              size: 24.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Rating & Ulasan',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                if (trimmedAnimalName.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    trimmedAnimalName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8D8D8D),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
    );
  }
}

class _ReviewLoadingState extends StatelessWidget {
  final String animalName;

  const _ReviewLoadingState({required this.animalName});

  @override
  Widget build(BuildContext context) {
    final trimmedAnimalName = animalName.trim();

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 28.w),
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F3),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFF8D7C5)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28.w,
              height: 28.w,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFFF87537),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Memuat ulasan',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2F2F2F),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              trimmedAnimalName.isEmpty
                  ? 'Sebentar, data ulasan hewan sedang diambil.'
                  : 'Sebentar, data ulasan untuk $trimmedAnimalName sedang diambil.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: const Color(0xFF7A7A7A),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyReviewState extends StatelessWidget {
  final String animalName;
  final Future<void> Function() onRefresh;

  const _EmptyReviewState({required this.animalName, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final trimmedAnimalName = animalName.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F3),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF8D7C5)),
      ),
      child: Column(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: const BoxDecoration(
              color: Color(0xFFFDE5D9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_outlined,
              size: 26.sp,
              color: const Color(0xFFF87537),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Belum ada ulasan',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2F2F2F),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            trimmedAnimalName.isEmpty
                ? 'Hewan ini belum memiliki rating atau komentar dari adopter.'
                : '$trimmedAnimalName belum memiliki rating atau komentar dari adopter.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: const Color(0xFF7A7A7A),
              height: 1.55,
            ),
          ),
          SizedBox(height: 14.h),
          OutlinedButton(
            onPressed: () => onRefresh(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFF87537),
              side: const BorderSide(color: Color(0xFFF87537), width: 1.1),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            child: Text(
              'Muat Ulang',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF87537),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
