import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/widgets/app_loading_dialog.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/order/adopter_review_service.dart';
import '../../../../services/order/adopter_review_state_service.dart';

class RatingUlasanDialog extends StatefulWidget {
  final int orderId;
  final int animalId;
  final String animalName;
  final String namaShelter;

  const RatingUlasanDialog({
    super.key,
    required this.orderId,
    required this.animalId,
    required this.animalName,
    required this.namaShelter,
  });

  static Future<bool?> show(
    BuildContext context, {
    required int orderId,
    required int animalId,
    required String animalName,
    required String namaShelter,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => RatingUlasanDialog(
        orderId: orderId,
        animalId: animalId,
        animalName: animalName,
        namaShelter: namaShelter,
      ),
    );
  }

  @override
  State<RatingUlasanDialog> createState() => _RatingUlasanDialogState();
}

class _RatingUlasanDialogState extends State<RatingUlasanDialog> {
  final TextEditingController _ulasanController = TextEditingController();
  bool _isSubmitting = false;
  double _rating = 4.5;
  static const int _maxChar = 200;

  @override
  void dispose() {
    _ulasanController.dispose();
    super.dispose();
  }

  String get _ratingLabel => _rating.toStringAsFixed(_rating % 1 == 0 ? 0 : 1);

  Future<void> _onSubmit() async {
    if (_isSubmitting) {
      return;
    }

    if (widget.animalId <= 0 || widget.orderId <= 0) {
      AppSnackbar.show(
        context,
        message: 'Data hewan untuk ulasan tidak valid.',
        type: AppSnackbarType.warning,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    AppLoadingDialog.show(context, message: 'Mengirim ulasan...');

    try {
      final response = await AdopterReviewService.instance.createReview(
        animalId: widget.animalId,
        rating: _rating,
        comment: _ulasanController.text.trim(),
      );
      await AdopterReviewStateService.instance.markReviewed(widget.orderId);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
      AppSnackbar.show(
        context,
        message: _resolveSuccessMessage(response.message),
        type: AppSnackbarType.success,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppSnackbar.show(
        context,
        message: _resolveErrorMessage(error),
        type: _resolveErrorType(error),
      );
    } finally {
      AppLoadingDialog.hide();
      if (mounted) {
        setState(() => _isSubmitting = false);
      } else {
        _isSubmitting = false;
      }
    }
  }

  String _resolveSuccessMessage(String? message) {
    final normalized = message?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'Ulasan berhasil dikirim.';
    }
    return normalized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Gagal mengirim ulasan.';
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
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3EC),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 22.w,
                      color: const Color(0xFFF87537),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Beri Ulasan untuk ${widget.animalName}',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Adopsi dari ${widget.namaShelter}',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 28.h, color: const Color(0xFFF0F0F0)),
              Row(
                children: <Widget>[
                  Text(
                    'Rating kamu',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF444444),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3EC),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      '$_ratingLabel / 5.0',
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF87537),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: List<Widget>.generate(5, (int index) {
                  final threshold = index + 1;
                  final icon = _rating >= threshold
                      ? Icons.star_rounded
                      : (_rating >= threshold - 0.5
                            ? Icons.star_half_rounded
                            : Icons.star_outline_rounded);
                  return Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Icon(
                      icon,
                      size: 28.w,
                      color: const Color(0xFFF87537),
                    ),
                  );
                }),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFF87537),
                  inactiveTrackColor: const Color(0xFFFFD8C0),
                  thumbColor: const Color(0xFFF87537),
                  overlayColor: const Color(0x33F87537),
                  valueIndicatorColor: const Color(0xFFF87537),
                  trackHeight: 4.h,
                ),
                child: Slider(
                  min: 0.5,
                  max: 5.0,
                  divisions: 9,
                  value: _rating,
                  label: _ratingLabel,
                  onChanged: _isSubmitting
                      ? null
                      : (double value) {
                          setState(() => _rating = value);
                        },
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Ulasan Hewan (Opsional)',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF444444),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _ulasanController,
                      maxLines: 5,
                      maxLength: _maxChar,
                      enabled: !_isSubmitting,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF333333),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ceritakan pengalaman adopsimu...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: const Color(0xFFBBBBBB),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(
                          12.w,
                          12.h,
                          12.w,
                          0,
                        ),
                        counterText: '',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${_ulasanController.text.length}/$_maxChar',
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: const Color(0xFFBBBBBB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Divider(height: 1, color: const Color(0xFFF0F0F0)),
              SizedBox(height: 16.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: _isSubmitting
                          ? null
                          : () => Navigator.pop(context, false),
                      child: Container(
                        height: 46.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFEEEEEE),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: _isSubmitting ? null : _onSubmit,
                      child: Container(
                        height: 46.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isSubmitting
                              ? const Color(0xFFFFD8C0)
                              : const Color(0xFFF87537),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Text(
                          _isSubmitting ? 'Mengirim...' : 'Kirim Ulasan',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
