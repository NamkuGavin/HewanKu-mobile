import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/pesanan_item.dart';

class PesananTimeline extends StatelessWidget {
  final List<TimelineStep> steps;
  final String perkiraanKedatangan;

  const PesananTimeline({
    super.key,
    required this.steps,
    required this.perkiraanKedatangan,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(steps.length, (i) {
          return _TimelineRow(step: steps[i], isLast: i == steps.length - 1);
        }),

        // Garis tipis pemisah
        SizedBox(height: 16.h),
        Divider(height: 1, thickness: 1, color: const Color(0xFFF0F0F0)),
        SizedBox(height: 14.h),

        // Perkiraan kedatangan
        Text(
          'Perkiraan kedatangan pesanan',
          style: textTheme.labelMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          perkiraanKedatangan,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TimelineStep step;
  final bool isLast;

  const _TimelineRow({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Color dotColor;
    final Color lineColor;

    switch (step.status) {
      case TimelineStatus.selesai:
        dotColor = const Color(0xFFF87537);
        lineColor = const Color(0xFFF87537);
        break;
      case TimelineStatus.aktif:
        dotColor = const Color(0xFFF87537);
        lineColor = const Color(0xFFE0E0E0);
        break;
      case TimelineStatus.menunggu:
        dotColor = const Color(0xFFDDDDDD);
        lineColor = const Color(0xFFE0E0E0);
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kolom dot + garis
        SizedBox(
          width: 28.w,
          child: Column(
            children: [
              // Dot
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
                child: step.status == TimelineStatus.selesai
                    ? Icon(Icons.check, color: Colors.white, size: 11.sp)
                    : null,
              ),
              // Garis vertikal panjang antara step
              if (!isLast)
                Container(
                  width: 2.5,
                  // ← PANJANGKAN GARIS — ini yang bikin jarak antar step lebih besar
                  height: step.waktu != null ? 52.h : 44.h,
                  color: lineColor,
                  margin: EdgeInsets.symmetric(vertical: 3.h),
                ),
            ],
          ),
        ),
        SizedBox(width: 12.w),

        // Teks step — padding bawah lebih besar supaya tidak mepet
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : (step.waktu != null ? 0 : 0),
              top: 1.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.judul,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: step.status == TimelineStatus.menunggu
                        ? const Color(0xFFAAAAAA)
                        : Colors.black,
                    fontSize: 13.sp,
                  ),
                ),
                if (step.waktu != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    step.waktu!,
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF9E9E9E),
                      height: 1.4,
                    ),
                  ),
                ],
                // Tambah space bawah supaya tidak mepet ke garis
                SizedBox(height: isLast ? 0 : 6.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
