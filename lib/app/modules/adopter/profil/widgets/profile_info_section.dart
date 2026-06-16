import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/form_validator.dart';

class ProfileInfoSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController namaLengkapController;
  final TextEditingController emailController;
  final TextEditingController noHandphoneController;
  final bool isEditing;
  final bool isSaving;
  final VoidCallback onEditTap;
  final VoidCallback onSaveTap;
  final VoidCallback? onCancelTap;

  const ProfileInfoSection({
    super.key,
    required this.formKey,
    required this.namaLengkapController,
    required this.emailController,
    required this.noHandphoneController,
    required this.isEditing,
    required this.isSaving,
    required this.onEditTap,
    required this.onSaveTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Informasi Pribadi',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isEditing && onCancelTap != null)
                  TextButton(
                    onPressed: isSaving ? null : onCancelTap,
                    child: Text(
                      'Batal',
                      style: textTheme.labelLarge?.copyWith(color: const Color(0xFF777777), fontWeight: FontWeight.w600),
                    ),
                  ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : isEditing
                      ? onSaveTap
                      : onEditTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBA81F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text(
                    isEditing ? 'Simpan' : 'Edit Profil',
                    style: textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Form(
          key: formKey,
          child: Column(
            children: [
              _ProfileInfoField(
                label: 'Nama Lengkap',
                controller: namaLengkapController,
                readOnly: !isEditing,
                hintText: 'Masukkan nama lengkap',
                validator: (value) => FormValidator.name(value, fieldName: 'Nama lengkap'),
              ),
              SizedBox(height: 14.h),
              _ProfileInfoField(
                label: 'Email',
                controller: emailController,
                readOnly: !isEditing,
                hintText: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
                validator: FormValidator.email,
              ),
              SizedBox(height: 14.h),
              _ProfileInfoField(
                label: 'No. Handphone',
                controller: noHandphoneController,
                readOnly: !isEditing,
                hintText: 'Masukkan nomor handphone',
                keyboardType: TextInputType.phone,
                validator: FormValidator.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _ProfileInfoField({
    required this.label,
    required this.controller,
    required this.readOnly,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          validator: validator,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: const Color(0xFF1F1F1F), fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: const Color(0xFFB1B1B1), fontWeight: FontWeight.w500),
            filled: true,
            fillColor: readOnly ? const Color(0xFFE9E9E9) : Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: readOnly ? Colors.transparent : const Color(0xFFF6C75A), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFF87537), width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFD9534F), width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFD9534F), width: 1.4),
            ),
          ),
        ),
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
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87, fontWeight: FontWeight.w600),
    );
  }
}
