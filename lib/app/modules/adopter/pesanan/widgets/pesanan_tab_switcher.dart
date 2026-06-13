import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PesananTabSwitcher extends StatelessWidget {
  static const _labels = ['Pesanan\nSaya', 'Pesanan\nTerakhir'];

  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const PesananTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: List.generate(_labels.length, (index) {
          return _TabItem(
            label: _labels[index],
            isActive: selectedIndex == index,
            onTap: () => onTabChanged(index),
          );
        }),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFBA81F) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : const Color(0xFF555555),
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
