import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileInfoSection extends StatelessWidget {
  final String namaLengkap;
  final String email;
  final String noHandphone;
  final VoidCallback? onEditTap;

  const ProfileInfoSection({
    super.key,
    required this.namaLengkap,
    required this.email,
    required this.noHandphone,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: "Informasi Pribadi" + tombol "Edit Profil"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Informasi Pribadi',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: onEditTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBA81F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'Edit Profil',
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Field: Nama Lengkap
        _buildFieldLabel(context, 'Nama Lengkap'),
        SizedBox(height: 6.h),
        _buildReadonlyField(context, namaLengkap),
        SizedBox(height: 14.h),

        // Field: Email
        _buildFieldLabel(context, 'Email'),
        SizedBox(height: 6.h),
        _buildReadonlyField(context, email),
        SizedBox(height: 14.h),

        // Field: No. Handphone
        _buildFieldLabel(context, 'No. Handphone'),
        SizedBox(height: 6.h),
        _buildReadonlyField(context, noHandphone),
      ],
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildReadonlyField(BuildContext context, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        value,
        style: textTheme.labelLarge?.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
