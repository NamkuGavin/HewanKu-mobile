import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ============================================================
// lib/app/modules/shelter/home/widgets/home_section_header.dart
// Berisi: baris judul section + tombol "Lihat Semua"
// Dipakai di: section Hewan dan section Permohonan
// ============================================================

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onLihatSemua;

  const HomeSectionHeader({super.key, required this.title, this.onLihatSemua});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        TextButton(
          onPressed: onLihatSemua,
          child: Text(
            'Lihat Semua',
            style: TextStyle(
              color: primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
