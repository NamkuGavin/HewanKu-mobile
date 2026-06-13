import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBioCard extends StatelessWidget {
  final String bio;

  const ProfileBioCard({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tentang Aku',
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Color(0xFFFBA81F), width: 1.2),
          ),
          child: Text(
            bio,
            style: textTheme.labelLarge?.copyWith(
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
