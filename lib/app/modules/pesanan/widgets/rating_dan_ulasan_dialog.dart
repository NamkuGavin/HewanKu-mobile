import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingUlasanDialog extends StatefulWidget {
  final String namaShelter;

  const RatingUlasanDialog({super.key, required this.namaShelter});

  /// Tampilkan dialog dari mana saja:
  /// RatingUlasanDialog.show(context, namaShelter: 'Shelter Hewan Abadi');
  static void show(BuildContext context, {required String namaShelter}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => RatingUlasanDialog(namaShelter: namaShelter),
    );
  }

  @override
  State<RatingUlasanDialog> createState() => _RatingUlasanDialogState();
}

class _RatingUlasanDialogState extends State<RatingUlasanDialog> {
  int _selectedStar = 4; // bintang yang dipilih (1-5), default 4
  final TextEditingController _ulasanController = TextEditingController();
  bool _remainAnonymous = false;
  static const int _maxChar = 200;

  @override
  void dispose() {
    _ulasanController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // TODO: kirim rating & ulasan ke API
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header: icon + judul + subtitle ───────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFDDDDDD),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.star_outline_rounded,
                      size: 22.w,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beri Nilai Shelter Kami',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Provide us with feedback for the product.',
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

              // ── Rating bintang ─────────────────────────────────────
              Row(
                children: [
                  Text(
                    'Rating kamu',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF444444),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.help_outline_rounded,
                      size: 14.w, color: const Color(0xFFBBBBBB)),
                ],
              ),
              SizedBox(height: 12.h),

              // 5 bintang interaktif
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (i) {
                  final starIndex = i + 1;
                  final isActive = starIndex <= _selectedStar;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedStar = starIndex),
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Icon(
                        Icons.star_rounded,
                        size: 36.w,
                        color: isActive
                            ? const Color(0xFFF87537)
                            : const Color(0xFFDDDDDD),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20.h),

              // ── Text area ulasan ───────────────────────────────────
              Text(
                'Ulasan Shelter  (Opsional)',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
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
                  children: [
                    TextField(
                      controller: _ulasanController,
                      maxLines: 5,
                      maxLength: _maxChar,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF333333),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Silahkan isi ulasan shelter...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: const Color(0xFFBBBBBB),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(
                            12.w, 12.h, 12.w, 0),
                        counterText: '', // sembunyikan counter bawaan
                      ),
                    ),
                    // Counter karakter custom di kanan bawah
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${_ulasanController.text.length}/$_maxChar',
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: const Color(0xFFBBBBBB),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.edit_outlined,
                              size: 12.w, color: const Color(0xFFBBBBBB)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // ── Remain anonymous checkbox ──────────────────────────
              GestureDetector(
                onTap: () =>
                    setState(() => _remainAnonymous = !_remainAnonymous),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _remainAnonymous
                              ? const Color(0xFFF87537)
                              : const Color(0xFFCCCCCC),
                          width: _remainAnonymous ? 6 : 1.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Remain anonymous',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // ── Tombol Cancel & Submit ─────────────────────────────
              Divider(height: 1, color: const Color(0xFFF0F0F0)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  // Cancel
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 46.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color(0xFFEEEEEE), width: 1),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Text(
                          'Cancel',
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
                  // Submit
                  Expanded(
                    child: GestureDetector(
                      onTap: _onSubmit,
                      child: Container(
                        height: 46.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF87537),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Text(
                          'Submit',
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