import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AdopsiFilterChips extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final bool hasActiveAdvancedFilter;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onFilterTap;

  const AdopsiFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.hasActiveAdvancedFilter,
    required this.onCategorySelected,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterIconButton(isActive: hasActiveAdvancedFilter, onTap: onFilterTap),
          if (categories.isNotEmpty) SizedBox(width: 10.w),
          ...categories.map((category) {
            final isSelected = selectedCategory == category;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () => onCategorySelected(isSelected ? null : category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF87537) : Colors.transparent,
                    border: Border.all(color: isSelected ? const Color(0xFFF87537) : const Color(0xFFDDDDDD), width: 1.2),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF555555),
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
  final bool isActive;
  final VoidCallback onTap;

  const _FilterIconButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF87537) : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isActive ? const Color(0xFFF87537) : const Color(0xFFDDDDDD), width: 1.2),
        ),
        child: Icon(Icons.tune_rounded, size: 18.w, color: isActive ? Colors.white : const Color(0xFF555555)),
      ),
    );
  }
}
