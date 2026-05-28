import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'adopsi_filter_hewan.dart';

class AdopsiFilterChips extends StatefulWidget {
  const AdopsiFilterChips({super.key});

  @override
  State<AdopsiFilterChips> createState() => _AdopsiFilterChipsState();
}

class _AdopsiFilterChipsState extends State<AdopsiFilterChips> {
  int _selectedIndex = 0;

  static const List<String> _categories = [
    'Kucing',
    'Anjing',
    'Ikan',
    'Burung',
    'Kelinci',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        children: [
          // Tombol filter icon
          _FilterIconButton(onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const AdopsiFilterHewan(),
            );
          }),
          SizedBox(width: 10.w),
          // Chip kategori
          ...List.generate(_categories.length, (i) {
            final isSelected = i == _selectedIndex;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF87537)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFF87537)
                          : const Color(0xFFDDDDDD),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Text(
                    _categories[i],
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF555555),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _FilterIconButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFDDDDDD), width: 1.2),
        ),
        child: Icon(
          Icons.tune_rounded,
          size: 18.w,
          color: const Color(0xFF555555),
        ),
      ),
    );
  }
}