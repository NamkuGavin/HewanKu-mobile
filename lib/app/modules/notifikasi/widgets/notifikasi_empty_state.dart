import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotifikasiEmptyState extends StatelessWidget {
  const NotifikasiEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Container(color: const Color(0xFFF5F5F5)),

        // Blob kanan atas
        Positioned(
          top: -40,
          right: -40,
          child: _PeachBlob(size: 180),
        ),
        // Blob kiri tengah
        Positioned(
          top: 280,
          left: -50,
          child: _PeachBlob(size: 140),
        ),
        // Blob kanan bawah
        Positioned(
          bottom: -30,
          right: -20,
          child: _PeachBlob(size: 120),
        ),

        // Konten tengah
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pets, size: 80.sp, color: const Color(0xFFCCCCCC)),
              SizedBox(height: 16.h),
              Text(
                'Tidak ada\nNotifikasi',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFBBBBBB),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PeachBlob extends StatelessWidget {
  final double size;
  const _PeachBlob({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            const Color(0xFFF87537).withOpacity(0.25),
            const Color(0xFFFBA81F).withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.6),
          topRight: Radius.circular(size * 0.35),
          bottomLeft: Radius.circular(size * 0.4),
          bottomRight: Radius.circular(size * 0.65),
        ),
      ),
    );
  }
}