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
    final fields = [
      ('Nama Lengkap', namaLengkap),
      ('Email', email),
      ('No. Handphone', noHandphone),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        for (final field in fields) ...[
          _ProfileInfoField(label: field.$1, value: field.$2),
          if (field != fields.last) SizedBox(height: 14.h),
        ],
      ],
    );
  }
}

class _ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        SizedBox(height: 6.h),
        _ReadonlyField(value),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  final String value;

  const _ReadonlyField(this.value);

  @override
  Widget build(BuildContext context) {
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
